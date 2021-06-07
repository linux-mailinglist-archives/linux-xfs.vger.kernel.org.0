Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2803139E97B
	for <lists+linux-xfs@lfdr.de>; Tue,  8 Jun 2021 00:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230212AbhFGW0q (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 7 Jun 2021 18:26:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:53412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229997AbhFGW0p (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 7 Jun 2021 18:26:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19DDC61040;
        Mon,  7 Jun 2021 22:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623104694;
        bh=Bdc5G+qg2OQbSWigSF7SC5B3+rby00p8YBdrryidofc=;
        h=Subject:From:To:Cc:Date:From;
        b=osW91JZhRxyd1gSy6KSCPJSPumyZ3uNku5rJr1kEmHg2OOuWf1zsc+Zrjfpq/lo9f
         Tyx/Gl1S5lmAqcLB3Wc0DTTf85/QHPMOQmEWH1f1EBbIwQcOqDhraEbDysJP/fQgA7
         oIJgfnHPu5sOre1u0DWhoPc5uzjDVMlvOKjhbJnznYPYUhltjuhdGDgLJOTmKKt4yR
         FbeFYBeaG5xlzryOWU1mTZjNtQ5X11R+wWI3guHhFS9CUxzPMTAtHceX5KTw8r3nr0
         kCCAJv54+J6t/HFfIV7ueA/ZJG9GDSrm7SEDQMnXd8TpMxzu91liIaTMnuJhFnV0Zz
         6y1USiqG6Kqkg==
Subject: [PATCHSET v6 0/9] xfs: deferred inode inactivation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
        linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Date:   Mon, 07 Jun 2021 15:24:53 -0700
Message-ID: <162310469340.3465262.504398465311182657.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This patch series implements deferred inode inactivation.  Inactivation
is what happens when an open file loses its last incore reference: if
the file has speculative preallocations, they must be freed, and if the
file is unlinked, all forks must be truncated, and the inode marked
freed in the inode chunk and the inode btrees.

Currently, all of this activity is performed in frontend threads when
the last in-memory reference is lost and/or the vfs decides to drop the
inode.  Three complaints stem from this behavior: first, that the time
to unlink (in the worst case) depends on both the complexity of the
directory as well as the the number of extents in that file; second,
that deleting a directory tree is inefficient and seeky because we free
the inodes in readdir order, not disk order; and third, the upcoming
online repair feature needs to be able to xfs_irele while scanning a
filesystem in transaction context.  It cannot perform inode inactivation
in this context because xfs does not support nested transactions.

The implementation will be familiar to those who have studied how XFS
scans for reclaimable in-core inodes -- we create a couple more inode
state flags to mark an inode as needing inactivation and being in the
middle of inactivation.  When inodes need inactivation, we set
NEED_INACTIVE in iflags, set the INACTIVE radix tree tag, and schedule a
deferred work item.  The deferred worker runs in an unbounded workqueue,
scanning the inode radix tree for tagged inodes to inactivate, and
performing all the on-disk metadata updates.  Once the inode has been
inactivated, it is left in the reclaim state and the background reclaim
worker (or direct reclaim) will get to it eventually.

Doing the inactivations from kernel threads solves the first problem by
constraining the amount of work done by the unlink() call to removing
the directory entry.  It solves the third problem by moving inactivation
to a separate process.  Because the inactivations are done in order of
inode number, we solve the second problem by performing updates in (we
hope) disk order.  This also decreases the amount of time it takes to
let go of an inode cluster if we're deleting entire directory trees.

There are three big warts I can think of in this series: first, because
the actual freeing of nlink==0 inodes is now done in the background,
this means that the system will be busy making metadata updates for some
time after the unlink() call returns.  This temporarily reduces
available iops.  Second, in order to retain the behavior that deleting
100TB of unshared data should result in a free space gain of 100TB, the
statvfs and quota reporting ioctls wait for inactivation to finish,
which increases the long tail latency of those calls.  This behavior is,
unfortunately, key to not introducing regressions in fstests.  The third
problem is that the deferrals keep memory usage higher for longer,
reduce opportunities to throttle the frontend when metadata load is
heavy, and the unbounded workqueues can create transaction storms.

For v5 there are some serious changes against the older versions of this
patchset -- we no longer cycle an inode's dquots to avoid fights with
quotaoff, and we actually shut down the background gc threads when the
filesystem is frozen.

v1-v2: NYE patchbombs
v3: rebase against 5.12-rc2 for submission.
v4: combine the can/has eofblocks predicates, clean up incore inode tree
    walks, fix inobt deadlock
v5: actually freeze the inode gc threads when we freeze the filesystem,
    consolidate the code that deals with inode tagging, and use
    foreground inactivation during quotaoff to avoid cycling dquots
v6: rebase to 5.13-rc4, fix quotaoff not to require foreground inactivation,
    refactor to use inode walk goals, use atomic bitflags to control the
    scheduling of gc workers

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=deferred-inactivation-5.14
---
 Documentation/admin-guide/xfs.rst |   10 +
 fs/xfs/libxfs/xfs_ag.c            |    3 
 fs/xfs/libxfs/xfs_ag.h            |    3 
 fs/xfs/scrub/common.c             |    2 
 fs/xfs/xfs_bmap_util.c            |   43 +++
 fs/xfs/xfs_fsops.c                |    4 
 fs/xfs/xfs_globals.c              |    3 
 fs/xfs/xfs_icache.c               |  596 ++++++++++++++++++++++++++++++++-----
 fs/xfs/xfs_icache.h               |   37 ++
 fs/xfs/xfs_inode.c                |   60 +++-
 fs/xfs/xfs_inode.h                |   15 +
 fs/xfs/xfs_itable.c               |   42 ++-
 fs/xfs/xfs_iwalk.c                |   33 ++
 fs/xfs/xfs_linux.h                |    2 
 fs/xfs/xfs_log_recover.c          |    7 
 fs/xfs/xfs_mount.c                |   30 ++
 fs/xfs/xfs_mount.h                |   16 +
 fs/xfs/xfs_qm_syscalls.c          |    4 
 fs/xfs/xfs_super.c                |  130 +++++++-
 fs/xfs/xfs_sysctl.c               |    9 +
 fs/xfs/xfs_sysctl.h               |    1 
 fs/xfs/xfs_trace.h                |   14 +
 22 files changed, 955 insertions(+), 109 deletions(-)

