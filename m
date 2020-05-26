Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B14721DA470
	for <lists+linux-xfs@lfdr.de>; Wed, 20 May 2020 00:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbgESWXY (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 19 May 2020 18:23:24 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:42421 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726862AbgESWXY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 May 2020 18:23:24 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id D3469D7A106
        for <linux-xfs@vger.kernel.org>; Wed, 20 May 2020 08:23:18 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jbAdm-0000Ob-GJ
        for linux-xfs@vger.kernel.org; Wed, 20 May 2020 08:23:14 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jbAdm-00AoIi-7E
        for linux-xfs@vger.kernel.org; Wed, 20 May 2020 08:23:14 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/2] xfs: separate read-only variables in struct xfs_mount
Date:   Wed, 20 May 2020 08:23:09 +1000
Message-Id: <20200519222310.2576434-2-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
In-Reply-To: <20200519222310.2576434-1-david@fromorbit.com>
References: <20200519222310.2576434-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=sTwFKg_x9MkA:10 a=20KFwNOVAAAA:8 a=Zjq8I2N-rEDDIEva9UgA:9
        a=qZx6Zq1HxP7nfBFs:21 a=FLUI2Buj5HuE8ukQ:21
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Seeing massive cpu usage from xfs_agino_range() on one machine;
instruction level profiles look similar to another machine running
the same workload, only one machien is consuming 10x as much CPU as
the other and going much slower. The only real difference between
the two machines is core count per socket. Both are running
identical 16p/16GB virtual machine configurations

Machine A:

  25.83%  [k] xfs_agino_range
  12.68%  [k] __xfs_dir3_data_check
   6.95%  [k] xfs_verify_ino
   6.78%  [k] xfs_dir2_data_entry_tag_p
   3.56%  [k] xfs_buf_find
   2.31%  [k] xfs_verify_dir_ino
   2.02%  [k] xfs_dabuf_map.constprop.0
   1.65%  [k] xfs_ag_block_count

And takes around 13 minutes to remove 50 million inodes.

Machine B:

  13.90%  [k] __pv_queued_spin_lock_slowpath
   3.76%  [k] do_raw_spin_lock
   2.83%  [k] xfs_dir3_leaf_check_int
   2.75%  [k] xfs_agino_range
   2.51%  [k] __raw_callee_save___pv_queued_spin_unlock
   2.18%  [k] __xfs_dir3_data_check
   2.02%  [k] xfs_log_commit_cil

And takes around 5m30s to remove 50 million inodes.

Suspect is cacheline contention on m_sectbb_log which is used in one
of the macros in xfs_agino_range. This is a read-only variable but
shares a cacheline with m_active_trans which is a global atomic that
gets bounced all around the machine.

The workload is trying to run hundreds of thousands of transactions
per second and hence cacheline contention will be occuring on this
atomic counter. Hence xfs_agino_range() is likely just be an
innocent bystander as the cache coherency protocol fights over the
cacheline between CPU cores and sockets.

On machine A, this rearrangement of the struct xfs_mount
results in the profile changing to:

   9.77%  [kernel]  [k] xfs_agino_range
   6.27%  [kernel]  [k] __xfs_dir3_data_check
   5.31%  [kernel]  [k] __pv_queued_spin_lock_slowpath
   4.54%  [kernel]  [k] xfs_buf_find
   3.79%  [kernel]  [k] do_raw_spin_lock
   3.39%  [kernel]  [k] xfs_verify_ino
   2.73%  [kernel]  [k] __raw_callee_save___pv_queued_spin_unlock

Vastly less CPU usage in xfs_agino_range(), but still 3x the amount
of machine B and still runs substantially slower than it should.

Current rm -rf of 50 million files:

		vanilla		patched
machine A	13m20s		6m42s
machine B	5m30s		5m02s

It's an improvement, hence indicating that separation and further
optimisation of read-only global filesystem data is worthwhile, but
it clearly isn't the underlying issue causing this specific
performance degradation.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_mount.h | 148 +++++++++++++++++++++++++--------------------
 1 file changed, 82 insertions(+), 66 deletions(-)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 4835581f3eb00..c1f92c1847bb2 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -55,61 +55,25 @@ struct xfs_error_cfg {
 	long		retry_timeout;	/* in jiffies, -1 = infinite */
 };
 
+/*
+ * The struct xfsmount layout is optimised to separate read-mostly variables
+ * from variables that are frequently modified. We put the read-mostly variables
+ * first, then place all the other variables at the end.
+ *
+ * Typically, read-mostly variables are those that are set at mount time and
+ * never changed again, or only change rarely as a result of things like sysfs
+ * knobs being tweaked.
+ */
 typedef struct xfs_mount {
+	struct xfs_sb		m_sb;		/* copy of fs superblock */
 	struct super_block	*m_super;
-
-	/*
-	 * Bitsets of per-fs metadata that have been checked and/or are sick.
-	 * Callers must hold m_sb_lock to access these two fields.
-	 */
-	uint8_t			m_fs_checked;
-	uint8_t			m_fs_sick;
-	/*
-	 * Bitsets of rt metadata that have been checked and/or are sick.
-	 * Callers must hold m_sb_lock to access this field.
-	 */
-	uint8_t			m_rt_checked;
-	uint8_t			m_rt_sick;
-
 	struct xfs_ail		*m_ail;		/* fs active log item list */
-
-	struct xfs_sb		m_sb;		/* copy of fs superblock */
-	spinlock_t		m_sb_lock;	/* sb counter lock */
-	struct percpu_counter	m_icount;	/* allocated inodes counter */
-	struct percpu_counter	m_ifree;	/* free inodes counter */
-	struct percpu_counter	m_fdblocks;	/* free block counter */
-	/*
-	 * Count of data device blocks reserved for delayed allocations,
-	 * including indlen blocks.  Does not include allocated CoW staging
-	 * extents or anything related to the rt device.
-	 */
-	struct percpu_counter	m_delalloc_blks;
-
 	struct xfs_buf		*m_sb_bp;	/* buffer for superblock */
 	char			*m_rtname;	/* realtime device name */
 	char			*m_logname;	/* external log device name */
-	int			m_bsize;	/* fs logical block size */
-	xfs_agnumber_t		m_agfrotor;	/* last ag where space found */
-	xfs_agnumber_t		m_agirotor;	/* last ag dir inode alloced */
-	spinlock_t		m_agirotor_lock;/* .. and lock protecting it */
-	xfs_agnumber_t		m_maxagi;	/* highest inode alloc group */
-	uint			m_allocsize_log;/* min write size log bytes */
-	uint			m_allocsize_blocks; /* min write size blocks */
 	struct xfs_da_geometry	*m_dir_geo;	/* directory block geometry */
 	struct xfs_da_geometry	*m_attr_geo;	/* attribute block geometry */
 	struct xlog		*m_log;		/* log specific stuff */
-	struct xfs_ino_geometry	m_ino_geo;	/* inode geometry */
-	int			m_logbufs;	/* number of log buffers */
-	int			m_logbsize;	/* size of each log buffer */
-	uint			m_rsumlevels;	/* rt summary levels */
-	uint			m_rsumsize;	/* size of rt summary, bytes */
-	/*
-	 * Optional cache of rt summary level per bitmap block with the
-	 * invariant that m_rsum_cache[bbno] <= the minimum i for which
-	 * rsum[i][bbno] != 0. Reads and writes are serialized by the rsumip
-	 * inode lock.
-	 */
-	uint8_t			*m_rsum_cache;
 	struct xfs_inode	*m_rbmip;	/* pointer to bitmap inode */
 	struct xfs_inode	*m_rsumip;	/* pointer to summary inode */
 	struct xfs_inode	*m_rootip;	/* pointer to root directory */
@@ -117,9 +81,26 @@ typedef struct xfs_mount {
 	xfs_buftarg_t		*m_ddev_targp;	/* saves taking the address */
 	xfs_buftarg_t		*m_logdev_targp;/* ptr to log device */
 	xfs_buftarg_t		*m_rtdev_targp;	/* ptr to rt device */
+	/*
+	 * Optional cache of rt summary level per bitmap block with the
+	 * invariant that m_rsum_cache[bbno] <= the minimum i for which
+	 * rsum[i][bbno] != 0. Reads and writes are serialized by the rsumip
+	 * inode lock.
+	 */
+	uint8_t			*m_rsum_cache;
+	struct xfs_mru_cache	*m_filestream;  /* per-mount filestream data */
+	struct workqueue_struct *m_buf_workqueue;
+	struct workqueue_struct	*m_unwritten_workqueue;
+	struct workqueue_struct	*m_cil_workqueue;
+	struct workqueue_struct	*m_reclaim_workqueue;
+	struct workqueue_struct *m_eofblocks_workqueue;
+	struct workqueue_struct	*m_sync_workqueue;
+
+	int			m_bsize;	/* fs logical block size */
 	uint8_t			m_blkbit_log;	/* blocklog + NBBY */
 	uint8_t			m_blkbb_log;	/* blocklog - BBSHIFT */
 	uint8_t			m_agno_log;	/* log #ag's */
+	uint8_t			m_sectbb_log;	/* sectlog - BBSHIFT */
 	uint			m_blockmask;	/* sb_blocksize-1 */
 	uint			m_blockwsize;	/* sb_blocksize in words */
 	uint			m_blockwmask;	/* blockwsize-1 */
@@ -138,47 +119,83 @@ typedef struct xfs_mount {
 	xfs_extlen_t		m_ag_prealloc_blocks; /* reserved ag blocks */
 	uint			m_alloc_set_aside; /* space we can't use */
 	uint			m_ag_max_usable; /* max space per AG */
-	struct radix_tree_root	m_perag_tree;	/* per-ag accounting info */
-	spinlock_t		m_perag_lock;	/* lock for m_perag_tree */
-	struct mutex		m_growlock;	/* growfs mutex */
+	int			m_dalign;	/* stripe unit */
+	int			m_swidth;	/* stripe width */
+	xfs_agnumber_t		m_maxagi;	/* highest inode alloc group */
+	uint			m_allocsize_log;/* min write size log bytes */
+	uint			m_allocsize_blocks; /* min write size blocks */
+	int			m_logbufs;	/* number of log buffers */
+	int			m_logbsize;	/* size of each log buffer */
+	uint			m_rsumlevels;	/* rt summary levels */
+	uint			m_rsumsize;	/* size of rt summary, bytes */
 	int			m_fixedfsid[2];	/* unchanged for life of FS */
-	uint64_t		m_flags;	/* global mount flags */
-	bool			m_finobt_nores; /* no per-AG finobt resv. */
 	uint			m_qflags;	/* quota status flags */
+	uint64_t		m_flags;	/* global mount flags */
+	int64_t			m_low_space[XFS_LOWSP_MAX];
+	struct xfs_ino_geometry	m_ino_geo;	/* inode geometry */
 	struct xfs_trans_resv	m_resv;		/* precomputed res values */
+						/* low free space thresholds */
+	bool			m_always_cow;
+	bool			m_fail_unmount;
+	bool			m_finobt_nores; /* no per-AG finobt resv. */
+	bool			m_update_sb;	/* sb needs update in mount */
+
+	/*
+	 * Bitsets of per-fs metadata that have been checked and/or are sick.
+	 * Callers must hold m_sb_lock to access these two fields.
+	 */
+	uint8_t			m_fs_checked;
+	uint8_t			m_fs_sick;
+	/*
+	 * Bitsets of rt metadata that have been checked and/or are sick.
+	 * Callers must hold m_sb_lock to access this field.
+	 */
+	uint8_t			m_rt_checked;
+	uint8_t			m_rt_sick;
+
+	/*
+	 * End of read-mostly variables. Frequently written variables and locks
+	 * should be placed below this comment from now on. The first variable
+	 * here is marked as cacheline aligned so they it is separated from
+	 * the read-mostly variables.
+	 */
+
+	spinlock_t ____cacheline_aligned m_sb_lock; /* sb counter lock */
+	struct percpu_counter	m_icount;	/* allocated inodes counter */
+	struct percpu_counter	m_ifree;	/* free inodes counter */
+	struct percpu_counter	m_fdblocks;	/* free block counter */
+	/*
+	 * Count of data device blocks reserved for delayed allocations,
+	 * including indlen blocks.  Does not include allocated CoW staging
+	 * extents or anything related to the rt device.
+	 */
+	struct percpu_counter	m_delalloc_blks;
+
+	struct radix_tree_root	m_perag_tree;	/* per-ag accounting info */
+	spinlock_t		m_perag_lock;	/* lock for m_perag_tree */
 	uint64_t		m_resblks;	/* total reserved blocks */
 	uint64_t		m_resblks_avail;/* available reserved blocks */
 	uint64_t		m_resblks_save;	/* reserved blks @ remount,ro */
-	int			m_dalign;	/* stripe unit */
-	int			m_swidth;	/* stripe width */
-	uint8_t			m_sectbb_log;	/* sectlog - BBSHIFT */
 	atomic_t		m_active_trans;	/* number trans frozen */
-	struct xfs_mru_cache	*m_filestream;  /* per-mount filestream data */
 	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
 	struct delayed_work	m_eofblocks_work; /* background eof blocks
 						     trimming */
 	struct delayed_work	m_cowblocks_work; /* background cow blocks
 						     trimming */
-	bool			m_update_sb;	/* sb needs update in mount */
-	int64_t			m_low_space[XFS_LOWSP_MAX];
-						/* low free space thresholds */
 	struct xfs_kobj		m_kobj;
 	struct xfs_kobj		m_error_kobj;
 	struct xfs_kobj		m_error_meta_kobj;
 	struct xfs_error_cfg	m_error_cfg[XFS_ERR_CLASS_MAX][XFS_ERR_ERRNO_MAX];
 	struct xstats		m_stats;	/* per-fs stats */
+	xfs_agnumber_t		m_agfrotor;	/* last ag where space found */
+	xfs_agnumber_t		m_agirotor;	/* last ag dir inode alloced */
+	spinlock_t		m_agirotor_lock;/* .. and lock protecting it */
 
 	/*
 	 * Workqueue item so that we can coalesce multiple inode flush attempts
 	 * into a single flush.
 	 */
 	struct work_struct	m_flush_inodes_work;
-	struct workqueue_struct *m_buf_workqueue;
-	struct workqueue_struct	*m_unwritten_workqueue;
-	struct workqueue_struct	*m_cil_workqueue;
-	struct workqueue_struct	*m_reclaim_workqueue;
-	struct workqueue_struct *m_eofblocks_workqueue;
-	struct workqueue_struct	*m_sync_workqueue;
 
 	/*
 	 * Generation of the filesysyem layout.  This is incremented by each
@@ -190,9 +207,8 @@ typedef struct xfs_mount {
 	 * to various other kinds of pain inflicted on the pNFS server.
 	 */
 	uint32_t		m_generation;
+	struct mutex		m_growlock;	/* growfs mutex */
 
-	bool			m_always_cow;
-	bool			m_fail_unmount;
 #ifdef DEBUG
 	/*
 	 * Frequency with which errors are injected.  Replaces xfs_etest; the
-- 
2.26.2.761.g0e0b3e54be

