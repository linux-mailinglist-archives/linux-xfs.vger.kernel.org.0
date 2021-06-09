Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 923DB3A08D4
	for <lists+linux-xfs@lfdr.de>; Wed,  9 Jun 2021 03:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbhFIBCr (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 8 Jun 2021 21:02:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:57178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230303AbhFIBCr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 8 Jun 2021 21:02:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D55BF60FF2
        for <linux-xfs@vger.kernel.org>; Wed,  9 Jun 2021 01:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623200453;
        bh=QdiM9VY0SxSZM+FulC19fTUbA/MHfpEdOvZbjU51inA=;
        h=Date:From:To:Subject:From;
        b=dQE8OW0bVkm/5LC8Zb63azHX9p1UNAkBHvrZQmvoVQ7BPSOAysiZ4cj6U5FOGQWFL
         TGy0kMeRNMoIKGIhlAMN6nIVrEtvkYvzej3sB2VO3vFQWMXk59yDZtV26QQu9kfYC9
         CSIiT6cTDKla8jzWO/c/Ur4qZJ3D8Ukroy1jU3uhEvpWBSSopMgFz/D72HnSrhZHJ4
         Ar3kKtigBIpPuNim+JDdp8HP9QAZFB8I6axCnn+N+LvjJi+ZYibKqdWVPo147ssR7n
         8FBm5HIypw/En0ICUI9+VWcC2AZhZzqTtq/V/eUU0rzT/TDW7AZt0PBACPngVWETTO
         /0apDWjob3SMw==
Date:   Tue, 8 Jun 2021 18:00:53 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next **REBASED** to 7e4311b04be4
Message-ID: <20210609010053.GV2945738@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been **REBASED**.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

There were enough attribution problems in the previous for-next push
that Dave and I decided that overrode the hassle of making everyone
rebase.  I /did/ warn you all not to rebase your dev branches just yet.
Here we go with the second try!  This time I also added Dave's CIL
scalability work and the last of my inode core refactoring patches.

So ... if you have some time to burn, try pulling this branch and let me
know what you think.  Assuming nothing weird happens in the next couple
of days, this will be the first real for-next branch for 5.14.  I think
Allison's delayed xattrs work will be next to land, probably in the post
-rc6 push.

I'm reworking the deferred inactivation patchset; we'll see how long it
takes to restabilize that. ;)

The new head of the for-next branch is commit:

7e4311b04be4 Merge tag 'xfs-cil-scale-2-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs into xfs-5.14-merge2-cil

New Commits:

Christoph Hellwig (4):
      [5a981e4ea8ff] xfs: mark xfs_bmap_set_attrforkoff static
      [54cd3aa6f810] xfs: remove ->b_offset handling for page backed buffers
      [934d1076bb2c] xfs: simplify the b_page_count calculation
      [170041f71596] xfs: cleanup error handling in xfs_buf_get_map

Darrick J. Wong (30):
      [a7bcb147fef3] xfs: clean up open-coded fs block unit conversions
      [20bd8e63f30b] xfs: remove unnecessary shifts
      [1ad2cfe0a570] xfs: move the quotaoff dqrele inode walk into xfs_icache.c
      [3ea06d73e3c0] xfs: detach inode dquots at the end of inactivation
      [df60019739d8] xfs: move the inode walk functions further down
      [c1115c0cba2b] xfs: rename xfs_inode_walk functions to xfs_icwalk
      [c809d7e948a1] xfs: pass the goal of the incore inode walk to xfs_inode_walk()
      [b9baaef42f76] xfs: separate the dqrele_all inode grab logic from xfs_inode_walk_ag_grab
      [9d2793ceecb9] xfs: move xfs_inew_wait call into xfs_dqrele_inode
      [7fdff52623b4] xfs: remove iter_flags parameter from xfs_inode_walk_*
      [f427cf5c6236] xfs: remove indirect calls from xfs_inode_walk{,_ag}
      [d20d5edcf941] xfs: clean up inode state flag tests in xfs_blockgc_igrab
      [594ab00b760f] xfs: make the icwalk processing functions clean up the grab state
      [919a4ddb6841] xfs: fix radix tree tag signs
      [9d5ee8375951] xfs: pass struct xfs_eofblocks to the inode scan callback
      [f1bc5c5630f9] xfs: merge xfs_reclaim_inodes_ag into xfs_inode_walk_ag
      [c076ae7a9361] xfs: refactor per-AG inode tagging functions
      [ebf2e3372332] Merge tag 'xfs-buf-bulk-alloc-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs into xfs-5.14-merge2
      [c3eabd365034] Merge tag 'xfs-perag-conv-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs into xfs-5.14-merge2
      [f52edf6c54d9] Merge tag 'unit-conversion-cleanups-5.14_2021-06-03' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-5.14-merge2
      [8b943d21d40d] Merge tag 'assorted-fixes-5.14-1_2021-06-03' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-5.14-merge2
      [ffc18582ed18] Merge tag 'inode-walk-cleanups-5.14_2021-06-03' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-5.14-merge2
      [255794c7ed7a] xfs: only reset incore inode health state flags when reclaiming an inode
      [7975e465af6b] xfs: drop IDONTCACHE on inodes when we mark them sick
      [2d53f66baffd] xfs: change the prefix of XFS_EOF_FLAGS_* to XFS_ICWALK_FLAG_
      [9492750a8b18] xfs: selectively keep sick inodes in memory
      [b26b2bf14f82] xfs: rename struct xfs_eofblocks to xfs_icwalk
      [295abff2fb94] Merge tag 'fix-inode-health-reports-5.14_2021-06-08' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-5.14-merge2
      [68b2c8bcdb81] Merge tag 'rename-eofblocks-5.14_2021-06-08' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-5.14-merge2
      [7e4311b04be4] Merge tag 'xfs-cil-scale-2-tag' of git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs into xfs-5.14-merge2-cil

Dave Chinner (72):
      [0a683794ace2] xfs: split up xfs_buf_allocate_memory
      [07b5c5add42a] xfs: use xfs_buf_alloc_pages for uncached buffers
      [c9fa563072e1] xfs: use alloc_pages_bulk_array() for buffers
      [02c511738688] xfs: merge _xfs_buf_get_pages()
      [e7d236a6fe51] xfs: move page freeing into _xfs_buf_free_pages()
      [9bbafc71919a] xfs: move xfs_perag_get/put to xfs_ag.[ch]
      [61aa005a5bd7] xfs: prepare for moving perag definitions and support to libxfs
      [07b6403a6873] xfs: move perag structure and setup to libxfs/xfs_ag.[ch]
      [f250eedcf762] xfs: make for_each_perag... a first class citizen
      [934933c3eec9] xfs: convert raw ag walks to use for_each_perag
      [6f4118fc6482] xfs: convert xfs_iwalk to use perag references
      [7f8d3b3ca6fe] xfs: convert secondary superblock walk to use perags
      [45d066211756] xfs: pass perags through to the busy extent code
      [30933120ad79] xfs: push perags through the ag reservation callouts
      [58d43a7e3263] xfs: pass perags around in fsmap data dev functions
      [be9fb17d88f0] xfs: add a perag to the btree cursor
      [fa9c3c197329] xfs: convert rmap btree cursor to using a perag
      [a81a06211fb4] xfs: convert refcount btree cursor to use perags
      [289d38d22cd8] xfs: convert allocbt cursors to use perags
      [7b13c5155182] xfs: use perag for ialloc btree cursors
      [50f02fe3338d] xfs: remove agno from btree cursor
      [4268547305c9] xfs: simplify xfs_dialloc_select_ag() return values
      [89b1f55a2951] xfs: collapse AG selection for inode allocation
      [b652afd93703] xfs: get rid of xfs_dir_ialloc()
      [309161f6603c] xfs: inode allocation can use a single perag instance
      [8237fbf53d6f] xfs: clean up and simplify xfs_dialloc()
      [f40aadb2bb64] xfs: use perag through unlink processing
      [509201163fca] xfs: remove xfs_perag_t
      [977ec4ddf0b7] xfs: don't take a spinlock unconditionally in the DIO fastpath
      [7660a5b48fbe] xfs: log stripe roundoff is a property of the log
      [5fd9256ce156] xfs: separate CIL commit record IO
      [944f2c49fba1] xfs: remove xfs_blkdev_issue_flush
      [db7e30204e4c] xfs: async blkdev cache flush
      [0279bbbbc03f] xfs: CIL checkpoint flushes caches unconditionally
      [69d51e0e1686] xfs: remove need_start_rec parameter from xlog_write()
      [cb1acb3f3246] xfs: journal IO cache flush reductions
      [3682277520d6] xfs: Fix CIL throttle hang when CIL space used going backwards
      [f39ae5297c5c] xfs: xfs_log_force_lsn isn't passed a LSN
      [e12213ba5d90] xfs: AIL needs asynchronous CIL forcing
      [facd77e4e38b] xfs: CIL work is serialised, not pipelined
      [877cf3473914] xfs: factor out the CIL transaction header building
      [fa55689e031e] xfs: only CIL pushes require a start record
      [58adbf5268b1] xfs: embed the xlog_op_header in the unmount record
      [1d4f4b375658] xfs: embed the xlog_op_header in the commit record
      [58e54b5e5dcc] xfs: log tickets don't need log client id
      [695385a4aa76] xfs: move log iovec alignment to preparation function
      [b424a7fd981d] xfs: reserve space and initialise xlog_op_header in item formatting
      [b61901c58324] xfs: log ticket region debug is largely useless
      [66fc9ffa8638] xfs: pass lv chain length into xlog_write()
      [a8b8e1c74ea7] xfs: introduce xlog_write_single()
      [586359999f40] xfs:_introduce xlog_write_partial()
      [46eb52d3150c] xfs: xlog_write() no longer needs contwr state
      [9373dd073625] xfs: xlog_write() doesn't need optype anymore
      [5e5591ab632a] xfs: CIL context doesn't need to count iovecs
      [0d11bae4bcf4] xfs: use the CIL space used counter for emptiness checks
      [230b4cc9c9cc] xfs: lift init CIL reservation out of xc_cil_lock
      [153bd5b5cd98] xfs: rework per-iclog header CIL reservation
      [289ae7b48c2c] xfs: get rid of xb_to_gfp()
      [8bcac7448a94] xfs: merge xfs_buf_allocate_memory
      [abb480858143] xfs: introduce CPU hotplug infrastructure
      [0e4c3e0ee4fd] xfs: introduce per-cpu CIL tracking structure
      [a8613836d99e] xfs: implement percpu cil space used calculation
      [57edd3f6599e] xfs: track CIL ticket reservation in percpu structure
      [7f3b7c463f00] xfs: convert CIL busy extents to per-cpu
      [be05dd0e68ac] xfs: Add order IDs to log items in CIL
      [1f18c0c4b78c] xfs: convert CIL to unordered per cpu lists
      [a47518453bf9] xfs: convert log vector chain to use list heads
      [a1785f597c8b] xfs: move CIL ordering to the logvec chain
      [02f1473ded55] xfs: avoid cil push lock if possible
      [e469cbe84f4a] xfs: xlog_sync() manually adjusts grant head space
      [7017b129e69c] xfs: expanding delayed logging design with background material
      [9ba0889e2272] xfs: drop the AGI being passed to xfs_check_agi_freecount

Jiapeng Chong (1):
      [9673261c32dc] xfs: Remove redundant assignment to busy

Shaokun Zhang (1):
      [5f7fd7508620] xfs: sort variable alphabetically to avoid repeated declaration


Code Diffstat:

 .../filesystems/xfs-delayed-logging-design.rst     |  361 ++++++-
 fs/xfs/libxfs/xfs_ag.c                             |  273 ++++-
 fs/xfs/libxfs/xfs_ag.h                             |  136 +++
 fs/xfs/libxfs/xfs_ag_resv.c                        |   11 +-
 fs/xfs/libxfs/xfs_ag_resv.h                        |   15 +
 fs/xfs/libxfs/xfs_alloc.c                          |  111 +-
 fs/xfs/libxfs/xfs_alloc.h                          |    2 +-
 fs/xfs/libxfs/xfs_alloc_btree.c                    |   31 +-
 fs/xfs/libxfs/xfs_alloc_btree.h                    |    9 +-
 fs/xfs/libxfs/xfs_attr_leaf.c                      |    1 +
 fs/xfs/libxfs/xfs_bmap.c                           |    3 +-
 fs/xfs/libxfs/xfs_bmap.h                           |    1 -
 fs/xfs/libxfs/xfs_btree.c                          |   15 +-
 fs/xfs/libxfs/xfs_btree.h                          |   10 +-
 fs/xfs/libxfs/xfs_ialloc.c                         |  640 ++++++------
 fs/xfs/libxfs/xfs_ialloc.h                         |   40 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c                   |   46 +-
 fs/xfs/libxfs/xfs_ialloc_btree.h                   |   13 +-
 fs/xfs/libxfs/xfs_inode_buf.c                      |    2 +-
 fs/xfs/libxfs/xfs_log_format.h                     |    4 -
 fs/xfs/libxfs/xfs_refcount.c                       |  122 +--
 fs/xfs/libxfs/xfs_refcount.h                       |    9 +-
 fs/xfs/libxfs/xfs_refcount_btree.c                 |   39 +-
 fs/xfs/libxfs/xfs_refcount_btree.h                 |    7 +-
 fs/xfs/libxfs/xfs_rmap.c                           |  147 +--
 fs/xfs/libxfs/xfs_rmap.h                           |    6 +-
 fs/xfs/libxfs/xfs_rmap_btree.c                     |   46 +-
 fs/xfs/libxfs/xfs_rmap_btree.h                     |    6 +-
 fs/xfs/libxfs/xfs_sb.c                             |  146 +--
 fs/xfs/libxfs/xfs_sb.h                             |    9 -
 fs/xfs/libxfs/xfs_shared.h                         |   20 +-
 fs/xfs/libxfs/xfs_types.c                          |    4 +-
 fs/xfs/libxfs/xfs_types.h                          |    1 +
 fs/xfs/scrub/agheader.c                            |    1 +
 fs/xfs/scrub/agheader_repair.c                     |   33 +-
 fs/xfs/scrub/alloc.c                               |    3 +-
 fs/xfs/scrub/bmap.c                                |   21 +-
 fs/xfs/scrub/common.c                              |   15 +-
 fs/xfs/scrub/fscounters.c                          |   42 +-
 fs/xfs/scrub/health.c                              |    2 +-
 fs/xfs/scrub/ialloc.c                              |    9 +-
 fs/xfs/scrub/refcount.c                            |    3 +-
 fs/xfs/scrub/repair.c                              |   14 +-
 fs/xfs/scrub/rmap.c                                |    3 +-
 fs/xfs/scrub/trace.c                               |    3 +-
 fs/xfs/xfs_bio_io.c                                |   35 +
 fs/xfs/xfs_bmap_util.c                             |    6 +-
 fs/xfs/xfs_buf.c                                   |  309 +++---
 fs/xfs/xfs_buf.h                                   |    3 +-
 fs/xfs/xfs_buf_item.c                              |   39 +-
 fs/xfs/xfs_discard.c                               |    6 +-
 fs/xfs/xfs_dquot_item.c                            |    2 +-
 fs/xfs/xfs_extent_busy.c                           |   35 +-
 fs/xfs/xfs_extent_busy.h                           |    7 +-
 fs/xfs/xfs_file.c                                  |   70 +-
 fs/xfs/xfs_filestream.c                            |    2 +-
 fs/xfs/xfs_fsmap.c                                 |   80 +-
 fs/xfs/xfs_fsops.c                                 |    8 +-
 fs/xfs/xfs_health.c                                |   15 +-
 fs/xfs/xfs_icache.c                                |  980 ++++++++++--------
 fs/xfs/xfs_icache.h                                |   54 +-
 fs/xfs/xfs_inode.c                                 |  234 ++---
 fs/xfs/xfs_inode.h                                 |    9 +-
 fs/xfs/xfs_inode_item.c                            |   18 +-
 fs/xfs/xfs_inode_item.h                            |    2 +-
 fs/xfs/xfs_ioctl.c                                 |   41 +-
 fs/xfs/xfs_iops.c                                  |    4 +-
 fs/xfs/xfs_iwalk.c                                 |   84 +-
 fs/xfs/xfs_linux.h                                 |    2 +
 fs/xfs/xfs_log.c                                   | 1061 +++++++++-----------
 fs/xfs/xfs_log.h                                   |   66 +-
 fs/xfs/xfs_log_cil.c                               |  802 +++++++++++----
 fs/xfs/xfs_log_priv.h                              |  123 ++-
 fs/xfs/xfs_log_recover.c                           |   56 +-
 fs/xfs/xfs_mount.c                                 |  126 +--
 fs/xfs/xfs_mount.h                                 |  110 +-
 fs/xfs/xfs_qm.c                                    |   10 +-
 fs/xfs/xfs_qm.h                                    |    1 -
 fs/xfs/xfs_qm_syscalls.c                           |   54 +-
 fs/xfs/xfs_reflink.c                               |   13 +-
 fs/xfs/xfs_super.c                                 |   55 +-
 fs/xfs/xfs_super.h                                 |    1 -
 fs/xfs/xfs_symlink.c                               |    9 +-
 fs/xfs/xfs_sysfs.c                                 |    1 +
 fs/xfs/xfs_trace.c                                 |    3 +
 fs/xfs/xfs_trace.h                                 |   49 +-
 fs/xfs/xfs_trans.c                                 |   18 +-
 fs/xfs/xfs_trans.h                                 |    5 +-
 fs/xfs/xfs_trans_ail.c                             |   11 +-
 fs/xfs/xfs_trans_priv.h                            |    3 +-
 include/linux/cpuhotplug.h                         |    1 +
 91 files changed, 3898 insertions(+), 3160 deletions(-)
