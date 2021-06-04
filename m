Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF81D39B0E6
	for <lists+linux-xfs@lfdr.de>; Fri,  4 Jun 2021 05:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbhFDDbR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 3 Jun 2021 23:31:17 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:45177 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229704AbhFDDbQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Jun 2021 23:31:16 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id DF8561AFC6B;
        Fri,  4 Jun 2021 13:29:29 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lp0WW-008iqK-U0; Fri, 04 Jun 2021 13:29:29 +1000
Date:   Fri, 4 Jun 2021 13:29:28 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [GIT PULL] xfs: CIL and log scalability improvements
Message-ID: <20210604032928.GU664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=Pd3FYh-qvBS4izetHo8A:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

Can you please pull the CIL and log improvements from the tag listed
below?

Cheers,

Dave.

The following changes since commit d07f6ca923ea0927a1024dfccafc5b53b61cfecc:

  Linux 5.13-rc2 (2021-05-16 15:27:44 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git tags/xfs-cil-scale-tag

for you to fetch changes up to 856d6346ad5e76f230906792b1eb4ba70c860748:

  xfs: expanding delayed logging design with background material (2021-06-04 12:42:29 +1000)

----------------------------------------------------------------
xfs: CIL and log scalability improvements

Performance improvements are largely documented in the change logs of the
individual patches. Headline numbers are an increase in transaction rate from
700k commits/s to 1.7M commits/s, and a reduction in fua/flush operations by
2-3 orders of magnitude on metadata heavy workloads that don't use fsync.

Summary of series:

Patches         Modifications
-------         -------------
1-7:            log write FUA/FLUSH optimisations
8:              bug fix
9-11:           Async CIL pushes
12-25:          xlog_write() rework
26-39:          CIL commit scalability

The log write FUA/FLUSH optimisations reduce the number of cache flushes
required to flush the CIL to the journal. It extends the old pre-delayed logging
ordering semantics required by writing individual transactions to the iclogs out
to cover then CIL checkpoint transactions rather than individual writes to the
iclogs. In doing so, we reduce the cache flush requirements to once per CIL
checkpoint rather than once per iclog write.

The async CIL pushes fix a pipeline limitation that only allowed a single CIL
push to be processed at a time. This was causing CIL checkpoint writing to
become CPU bound as only a single CIL checkpoint could be pushed at a time. The
checkpoint pipleine was designed to allow multiple pushes to be in flight at
once and use careful ordering of the commit records to ensure correct recovery
order, but the workqueue implementation didn't allow concurrent works to be run.
The concurrent works now extend out to 4 CIL checkpoints running at a time,
hence removing the CPU usage limiations without introducing new lock contention
issues.

The xlog_write() rework is long overdue. The code is complex, difficult to
understand, full of tricky, subtle corner cases and just generally really hard
to modify. This patchset reworks the xlog_write() API to reduce the processing
overhead of writing out long log vector chains, and factors the xlog_write()
code into a simple, compact fast path along with a clearer slow path to handle
the complex cases.

The CIL commit scalability patchset removes spinlocks from the transaction
commit fast path. These spinlocks are the performance limiting bottleneck in the
transaction commit path, so we apply a variety of different techniques to do
either atomic. lockless or per-cpu updates of the CIL tracking structures during
commits. This greatly increases the throughput of the the transaction commit
engine, moving the contention point to the log space tracking algorithms after
doubling throughput on 32-way workloads.

----------------------------------------------------------------
Dave Chinner (39):
      xfs: log stripe roundoff is a property of the log
      xfs: separate CIL commit record IO
      xfs: remove xfs_blkdev_issue_flush
      xfs: async blkdev cache flush
      xfs: CIL checkpoint flushes caches unconditionally
      xfs: remove need_start_rec parameter from xlog_write()
      xfs: journal IO cache flush reductions
      xfs: Fix CIL throttle hang when CIL space used going backwards
      xfs: xfs_log_force_lsn isn't passed a LSN
      xfs: AIL needs asynchronous CIL forcing
      xfs: CIL work is serialised, not pipelined
      xfs: factor out the CIL transaction header building
      xfs: only CIL pushes require a start record
      xfs: embed the xlog_op_header in the unmount record
      xfs: embed the xlog_op_header in the commit record
      xfs: log tickets don't need log client id
      xfs: move log iovec alignment to preparation function
      xfs: reserve space and initialise xlog_op_header in item formatting
      xfs: log ticket region debug is largely useless
      xfs: pass lv chain length into xlog_write()
      xfs: introduce xlog_write_single()
      xfs:_introduce xlog_write_partial()
      xfs: xlog_write() no longer needs contwr state
      xfs: xlog_write() doesn't need optype anymore
      xfs: CIL context doesn't need to count iovecs
      xfs: use the CIL space used counter for emptiness checks
      xfs: lift init CIL reservation out of xc_cil_lock
      xfs: rework per-iclog header CIL reservation
      xfs: introduce per-cpu CIL tracking structure
      xfs: implement percpu cil space used calculation
      xfs: track CIL ticket reservation in percpu structure
      xfs: convert CIL busy extents to per-cpu
      xfs: Add order IDs to log items in CIL
      xfs: convert CIL to unordered per cpu lists
      xfs: convert log vector chain to use list heads
      xfs: move CIL ordering to the logvec chain
      xfs: avoid cil push lock if possible
      xfs: xlog_sync() manually adjusts grant head space
      xfs: expanding delayed logging design with background material

 Documentation/filesystems/xfs-delayed-logging-design.rst |  361 ++++++++++++++++++++++++++----
 fs/xfs/libxfs/xfs_log_format.h                           |    4 -
 fs/xfs/libxfs/xfs_types.h                                |    1 +
 fs/xfs/xfs_bio_io.c                                      |   35 +++
 fs/xfs/xfs_buf.c                                         |    2 +-
 fs/xfs/xfs_buf_item.c                                    |   39 ++--
 fs/xfs/xfs_dquot_item.c                                  |    2 +-
 fs/xfs/xfs_file.c                                        |   20 +-
 fs/xfs/xfs_inode.c                                       |   10 +-
 fs/xfs/xfs_inode_item.c                                  |   18 +-
 fs/xfs/xfs_inode_item.h                                  |    2 +-
 fs/xfs/xfs_linux.h                                       |    2 +
 fs/xfs/xfs_log.c                                         | 1015 +++++++++++++++++++++++++++++++++++++++---------------------------------------------
 fs/xfs/xfs_log.h                                         |   66 ++----
 fs/xfs/xfs_log_cil.c                                     |  822 ++++++++++++++++++++++++++++++++++++++++++++++++++------------------
 fs/xfs/xfs_log_priv.h                                    |  114 +++++-----
 fs/xfs/xfs_super.c                                       |   13 +-
 fs/xfs/xfs_super.h                                       |    1 -
 fs/xfs/xfs_sysfs.c                                       |    1 +
 fs/xfs/xfs_trace.c                                       |    1 +
 fs/xfs/xfs_trans.c                                       |   18 +-
 fs/xfs/xfs_trans.h                                       |    5 +-
 fs/xfs/xfs_trans_ail.c                                   |   11 +-
 fs/xfs/xfs_trans_priv.h                                  |    3 +-
 include/linux/cpuhotplug.h                               |    1 +
 25 files changed, 1603 insertions(+), 964 deletions(-)

-- 
Dave Chinner
david@fromorbit.com
