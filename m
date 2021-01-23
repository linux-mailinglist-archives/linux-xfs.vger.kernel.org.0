Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40D603017E3
	for <lists+linux-xfs@lfdr.de>; Sat, 23 Jan 2021 19:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbhAWSyN (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 23 Jan 2021 13:54:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:35512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbhAWSyJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 23 Jan 2021 13:54:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8DA723340;
        Sat, 23 Jan 2021 18:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611428033;
        bh=SkleBSCUyE8WQhA1UPce6ss4ukvQ+8MZrVbmockvp80=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=TPO3jrD/L+iw0PhmTM1lJ8l6mR2k7nC9ueMdLUibBCiWCOGCEk3f10AnGL7UICCeM
         QoZo1JNXyxqvqzLnbMxyOqMekKByPhKcwFntoVNYhQ70b8a3f9ocJnJYbt/V0SnnWP
         3tXMC7a02SClAV7lUBaclKxLbE2wsTDDU/eAbrfNJ3WzoGVVZEToVmEAKb1P5BzchV
         37oVcqj0ClbCesHAzdMRrP8kvoLc47HthgBjbev2YOhjKiMygRrW7wnibHxLWnxMQ3
         PT4/4Z0g8IMdm3tB/JeG8QhDMZzzFLbVa6DdSSRmgF6eAMXymEoArxnQk3J0z7hH3O
         EbHFlUBe4XKdA==
Subject: [PATCH 6/9] xfs: consolidate the eofblocks and cowblocks workers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com
Date:   Sat, 23 Jan 2021 10:53:55 -0800
Message-ID: <161142803536.2173480.15960879269785652095.stgit@magnolia>
In-Reply-To: <161142800187.2173480.17415824680111946713.stgit@magnolia>
References: <161142800187.2173480.17415824680111946713.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Remove the separate cowblocks work items and knob so that we can control
and run everything from a single blockgc work queue.  Note that the
speculative_prealloc_lifetime sysfs knob retains its historical name
even though the functions move to prefix xfs_blockgc_*.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_globals.c |    7 ++--
 fs/xfs/xfs_icache.c  |   96 ++++++++++++++++----------------------------------
 fs/xfs/xfs_icache.h  |    6 +--
 fs/xfs/xfs_linux.h   |    3 +-
 fs/xfs/xfs_mount.h   |    6 +--
 fs/xfs/xfs_super.c   |   11 +++---
 fs/xfs/xfs_sysctl.c  |   15 ++------
 fs/xfs/xfs_sysctl.h  |    3 +-
 8 files changed, 48 insertions(+), 99 deletions(-)


diff --git a/fs/xfs/xfs_globals.c b/fs/xfs/xfs_globals.c
index fa55ab8b8d80..f62fa652c2fd 100644
--- a/fs/xfs/xfs_globals.c
+++ b/fs/xfs/xfs_globals.c
@@ -8,8 +8,8 @@
 /*
  * Tunable XFS parameters.  xfs_params is required even when CONFIG_SYSCTL=n,
  * other XFS code uses these values.  Times are measured in centisecs (i.e.
- * 100ths of a second) with the exception of eofb_timer and cowb_timer, which
- * are measured in seconds.
+ * 100ths of a second) with the exception of blockgc_timer, which is measured
+ * in seconds.
  */
 xfs_param_t xfs_params = {
 			  /*	MIN		DFLT		MAX	*/
@@ -28,8 +28,7 @@ xfs_param_t xfs_params = {
 	.rotorstep	= {	1,		1,		255	},
 	.inherit_nodfrg	= {	0,		1,		1	},
 	.fstrm_timer	= {	1,		30*100,		3600*100},
-	.eofb_timer	= {	1,		300,		3600*24},
-	.cowb_timer	= {	1,		1800,		3600*24},
+	.blockgc_timer	= {	1,		300,		3600*24},
 };
 
 struct xfs_globals xfs_globals = {
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 1bc05cf4a263..038e0b764aa8 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1328,41 +1328,24 @@ xfs_inode_free_eofblocks(
 }
 
 /*
- * Background scanning to trim post-EOF preallocated space. This is queued
- * based on the 'speculative_prealloc_lifetime' tunable (5m by default).
+ * Background scanning to trim preallocated space. This is queued based on the
+ * 'speculative_prealloc_lifetime' tunable (5m by default).
  */
-void
-xfs_queue_eofblocks(
-	struct xfs_mount *mp)
+static inline void
+xfs_blockgc_queue(
+	struct xfs_mount	*mp)
 {
 	rcu_read_lock();
 	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_BLOCKGC_TAG))
-		queue_delayed_work(mp->m_eofblocks_workqueue,
-				   &mp->m_eofblocks_work,
-				   msecs_to_jiffies(xfs_eofb_secs * 1000));
+		queue_delayed_work(mp->m_blockgc_workqueue,
+				   &mp->m_blockgc_work,
+				   msecs_to_jiffies(xfs_blockgc_secs * 1000));
 	rcu_read_unlock();
 }
 
-void
-xfs_eofblocks_worker(
-	struct work_struct *work)
-{
-	struct xfs_mount *mp = container_of(to_delayed_work(work),
-				struct xfs_mount, m_eofblocks_work);
-
-	if (!sb_start_write_trylock(mp->m_super))
-		return;
-	xfs_inode_walk(mp, 0, xfs_inode_free_eofblocks, NULL,
-			XFS_ICI_BLOCKGC_TAG);
-	sb_end_write(mp->m_super);
-
-	xfs_queue_eofblocks(mp);
-}
-
 static void
 xfs_blockgc_set_iflag(
 	struct xfs_inode	*ip,
-	void			(*execute)(struct xfs_mount *mp),
 	unsigned long		iflag)
 {
 	struct xfs_mount	*mp = ip->i_mount;
@@ -1397,7 +1380,7 @@ xfs_blockgc_set_iflag(
 		spin_unlock(&ip->i_mount->m_perag_lock);
 
 		/* kick off background trimming */
-		execute(ip->i_mount);
+		xfs_blockgc_queue(ip->i_mount);
 
 		trace_xfs_perag_set_blockgc(ip->i_mount, pag->pag_agno, -1,
 				_RET_IP_);
@@ -1412,7 +1395,7 @@ xfs_inode_set_eofblocks_tag(
 	xfs_inode_t	*ip)
 {
 	trace_xfs_inode_set_eofblocks_tag(ip);
-	return xfs_blockgc_set_iflag(ip, xfs_queue_eofblocks, XFS_IEOFBLOCKS);
+	return xfs_blockgc_set_iflag(ip, XFS_IEOFBLOCKS);
 }
 
 static void
@@ -1556,45 +1539,12 @@ xfs_inode_free_cowblocks(
 	return ret;
 }
 
-/*
- * Background scanning to trim preallocated CoW space. This is queued
- * based on the 'speculative_cow_prealloc_lifetime' tunable (5m by default).
- * (We'll just piggyback on the post-EOF prealloc space workqueue.)
- */
-void
-xfs_queue_cowblocks(
-	struct xfs_mount *mp)
-{
-	rcu_read_lock();
-	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_BLOCKGC_TAG))
-		queue_delayed_work(mp->m_eofblocks_workqueue,
-				   &mp->m_cowblocks_work,
-				   msecs_to_jiffies(xfs_cowb_secs * 1000));
-	rcu_read_unlock();
-}
-
-void
-xfs_cowblocks_worker(
-	struct work_struct *work)
-{
-	struct xfs_mount *mp = container_of(to_delayed_work(work),
-				struct xfs_mount, m_cowblocks_work);
-
-	if (!sb_start_write_trylock(mp->m_super))
-		return;
-	xfs_inode_walk(mp, 0, xfs_inode_free_cowblocks, NULL,
-			XFS_ICI_BLOCKGC_TAG);
-	sb_end_write(mp->m_super);
-
-	xfs_queue_cowblocks(mp);
-}
-
 void
 xfs_inode_set_cowblocks_tag(
 	xfs_inode_t	*ip)
 {
 	trace_xfs_inode_set_cowblocks_tag(ip);
-	return xfs_blockgc_set_iflag(ip, xfs_queue_cowblocks, XFS_ICOWBLOCKS);
+	return xfs_blockgc_set_iflag(ip, XFS_ICOWBLOCKS);
 }
 
 void
@@ -1610,8 +1560,7 @@ void
 xfs_stop_block_reaping(
 	struct xfs_mount	*mp)
 {
-	cancel_delayed_work_sync(&mp->m_eofblocks_work);
-	cancel_delayed_work_sync(&mp->m_cowblocks_work);
+	cancel_delayed_work_sync(&mp->m_blockgc_work);
 }
 
 /* Enable post-EOF and CoW block auto-reclamation. */
@@ -1619,8 +1568,7 @@ void
 xfs_start_block_reaping(
 	struct xfs_mount	*mp)
 {
-	xfs_queue_eofblocks(mp);
-	xfs_queue_cowblocks(mp);
+	xfs_blockgc_queue(mp);
 }
 
 /* Scan all incore inodes for block preallocations that we can remove. */
@@ -1644,6 +1592,24 @@ xfs_blockgc_scan(
 	return 0;
 }
 
+/* Background worker that trims preallocated space. */
+void
+xfs_blockgc_worker(
+	struct work_struct	*work)
+{
+	struct xfs_mount	*mp = container_of(to_delayed_work(work),
+					struct xfs_mount, m_blockgc_work);
+	int			error;
+
+	if (!sb_start_write_trylock(mp->m_super))
+		return;
+	error = xfs_blockgc_scan(mp, NULL);
+	if (error)
+		xfs_info(mp, "preallocation gc worker failed, err=%d", error);
+	sb_end_write(mp->m_super);
+	xfs_blockgc_queue(mp);
+}
+
 /*
  * Try to free space in the filesystem by purging eofblocks and cowblocks.
  */
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index d2ef1ef75e7a..d781703af025 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -61,13 +61,11 @@ int xfs_blockgc_free_space(struct xfs_mount *mp, struct xfs_eofblocks *eofb);
 
 void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
 void xfs_inode_clear_eofblocks_tag(struct xfs_inode *ip);
-void xfs_eofblocks_worker(struct work_struct *);
-void xfs_queue_eofblocks(struct xfs_mount *);
 
 void xfs_inode_set_cowblocks_tag(struct xfs_inode *ip);
 void xfs_inode_clear_cowblocks_tag(struct xfs_inode *ip);
-void xfs_cowblocks_worker(struct work_struct *);
-void xfs_queue_cowblocks(struct xfs_mount *);
+
+void xfs_blockgc_worker(struct work_struct *work);
 
 int xfs_inode_walk(struct xfs_mount *mp, int iter_flags,
 	int (*execute)(struct xfs_inode *ip, void *args),
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 5b7a1e201559..af6be9b9ccdf 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -98,8 +98,7 @@ typedef __u32			xfs_nlink_t;
 #define xfs_rotorstep		xfs_params.rotorstep.val
 #define xfs_inherit_nodefrag	xfs_params.inherit_nodfrg.val
 #define xfs_fstrm_centisecs	xfs_params.fstrm_timer.val
-#define xfs_eofb_secs		xfs_params.eofb_timer.val
-#define xfs_cowb_secs		xfs_params.cowb_timer.val
+#define xfs_blockgc_secs	xfs_params.blockgc_timer.val
 
 #define current_cpu()		(raw_smp_processor_id())
 #define current_set_flags_nested(sp, f)		\
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 452ca7654dc5..316e0d79cc40 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -93,7 +93,7 @@ typedef struct xfs_mount {
 	struct workqueue_struct	*m_unwritten_workqueue;
 	struct workqueue_struct	*m_cil_workqueue;
 	struct workqueue_struct	*m_reclaim_workqueue;
-	struct workqueue_struct *m_eofblocks_workqueue;
+	struct workqueue_struct *m_blockgc_workqueue;
 	struct workqueue_struct	*m_sync_workqueue;
 
 	int			m_bsize;	/* fs logical block size */
@@ -177,9 +177,7 @@ typedef struct xfs_mount {
 	uint64_t		m_resblks_avail;/* available reserved blocks */
 	uint64_t		m_resblks_save;	/* reserved blks @ remount,ro */
 	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
-	struct delayed_work	m_eofblocks_work; /* background eof blocks
-						     trimming */
-	struct delayed_work	m_cowblocks_work; /* background cow blocks
+	struct delayed_work	m_blockgc_work; /* background prealloc blocks
 						     trimming */
 	struct xfs_kobj		m_kobj;
 	struct xfs_kobj		m_error_kobj;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index e440065ec503..143d54f61974 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -518,10 +518,10 @@ xfs_init_mount_workqueues(
 	if (!mp->m_reclaim_workqueue)
 		goto out_destroy_cil;
 
-	mp->m_eofblocks_workqueue = alloc_workqueue("xfs-eofblocks/%s",
+	mp->m_blockgc_workqueue = alloc_workqueue("xfs-blockgc/%s",
 			WQ_SYSFS | WQ_MEM_RECLAIM | WQ_FREEZABLE, 0,
 			mp->m_super->s_id);
-	if (!mp->m_eofblocks_workqueue)
+	if (!mp->m_blockgc_workqueue)
 		goto out_destroy_reclaim;
 
 	mp->m_sync_workqueue = alloc_workqueue("xfs-sync/%s",
@@ -532,7 +532,7 @@ xfs_init_mount_workqueues(
 	return 0;
 
 out_destroy_eofb:
-	destroy_workqueue(mp->m_eofblocks_workqueue);
+	destroy_workqueue(mp->m_blockgc_workqueue);
 out_destroy_reclaim:
 	destroy_workqueue(mp->m_reclaim_workqueue);
 out_destroy_cil:
@@ -550,7 +550,7 @@ xfs_destroy_mount_workqueues(
 	struct xfs_mount	*mp)
 {
 	destroy_workqueue(mp->m_sync_workqueue);
-	destroy_workqueue(mp->m_eofblocks_workqueue);
+	destroy_workqueue(mp->m_blockgc_workqueue);
 	destroy_workqueue(mp->m_reclaim_workqueue);
 	destroy_workqueue(mp->m_cil_workqueue);
 	destroy_workqueue(mp->m_unwritten_workqueue);
@@ -1842,8 +1842,7 @@ static int xfs_init_fs_context(
 	mutex_init(&mp->m_growlock);
 	INIT_WORK(&mp->m_flush_inodes_work, xfs_flush_inodes_worker);
 	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
-	INIT_DELAYED_WORK(&mp->m_eofblocks_work, xfs_eofblocks_worker);
-	INIT_DELAYED_WORK(&mp->m_cowblocks_work, xfs_cowblocks_worker);
+	INIT_DELAYED_WORK(&mp->m_blockgc_work, xfs_blockgc_worker);
 	mp->m_kobj.kobject.kset = xfs_kset;
 	/*
 	 * We don't create the finobt per-ag space reservation until after log
diff --git a/fs/xfs/xfs_sysctl.c b/fs/xfs/xfs_sysctl.c
index fac9de7ee6d0..145e06c47744 100644
--- a/fs/xfs/xfs_sysctl.c
+++ b/fs/xfs/xfs_sysctl.c
@@ -194,21 +194,12 @@ static struct ctl_table xfs_table[] = {
 	},
 	{
 		.procname	= "speculative_prealloc_lifetime",
-		.data		= &xfs_params.eofb_timer.val,
+		.data		= &xfs_params.blockgc_timer.val,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &xfs_params.eofb_timer.min,
-		.extra2		= &xfs_params.eofb_timer.max,
-	},
-	{
-		.procname	= "speculative_cow_prealloc_lifetime",
-		.data		= &xfs_params.cowb_timer.val,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &xfs_params.cowb_timer.min,
-		.extra2		= &xfs_params.cowb_timer.max,
+		.extra1		= &xfs_params.blockgc_timer.min,
+		.extra2		= &xfs_params.blockgc_timer.max,
 	},
 	/* please keep this the last entry */
 #ifdef CONFIG_PROC_FS
diff --git a/fs/xfs/xfs_sysctl.h b/fs/xfs/xfs_sysctl.h
index 8abf4640f1d5..7692e76ead33 100644
--- a/fs/xfs/xfs_sysctl.h
+++ b/fs/xfs/xfs_sysctl.h
@@ -35,8 +35,7 @@ typedef struct xfs_param {
 	xfs_sysctl_val_t rotorstep;	/* inode32 AG rotoring control knob */
 	xfs_sysctl_val_t inherit_nodfrg;/* Inherit the "nodefrag" inode flag. */
 	xfs_sysctl_val_t fstrm_timer;	/* Filestream dir-AG assoc'n timeout. */
-	xfs_sysctl_val_t eofb_timer;	/* Interval between eofb scan wakeups */
-	xfs_sysctl_val_t cowb_timer;	/* Interval between cowb scan wakeups */
+	xfs_sysctl_val_t blockgc_timer;	/* Interval between blockgc scans */
 } xfs_param_t;
 
 /*

