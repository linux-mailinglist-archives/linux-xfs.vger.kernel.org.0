Return-Path: <linux-xfs+bounces-8575-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 801808CB983
	for <lists+linux-xfs@lfdr.de>; Wed, 22 May 2024 05:11:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EDB111F23EE8
	for <lists+linux-xfs@lfdr.de>; Wed, 22 May 2024 03:11:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B44E28371;
	Wed, 22 May 2024 03:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OtxH6lYs"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A92028FD
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716347504; cv=none; b=t4IE/+BrsBescbdtFvVG0y/aYwWjxFY+zUbZPGxoig95Be9SnacAefX0R59h+gbFel6VyAypo5AfJ7xy3XGbBTFzPpG93C5+nd2PvR64H003r3aBNighAFAYWIyA+JaIzTNKMwBe1did9YHHlOXPuMSxgdCxsB1jj8xHXXyIMPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716347504; c=relaxed/simple;
	bh=LeCnPnfe+40LAGeiFnrJEJpBBJP+0epyD6wUaAb/cRQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LTY+zW2/IntxEyxgFkSD+sENgUffUU+TvKFEKzCSX/0qZ9Tx06/Sg8a5fO/Z4KJhXOZRiG77UrqNNmQYRLdOlk2bT4a4r5BBsbxgxN86Ty8cKXOESzF6s6Sw1Tq1t/RG6E8YqCvSPYJCm71qtaLLrHzdXz04KJAdjwGto3Knmpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OtxH6lYs; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C057C2BD11;
	Wed, 22 May 2024 03:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716347504;
	bh=LeCnPnfe+40LAGeiFnrJEJpBBJP+0epyD6wUaAb/cRQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OtxH6lYsvmKqUQuhe55xdEBVyuNVMZ9c08mSPVcSzHejUqiCdUXwJP6LFOAnVvI0E
	 qaqOFau6KdMSmWUrN6dZx8rO+iS5hucL+7CYnJrfN3GH//8DaI4lUV64GbEp1M5U0s
	 Y5X+cgJStobGuh4sgxb2csQjAI94PHe7FgoBGVEVEEMPbj4Jmj1MhXdFwqe7MGYyjM
	 jI0Og2P92EQwqX0SLs1h55/1+14/zbTqYLMcfULz3mJBd7tTL3KI4S32gn/9eiGzY0
	 AZWtBVsPjCXQaPaZpYNFTyY+t8Vp61geKQB/msNhBMtOkFLrLyCJUWasEveQ2yfxPf
	 ZkoRTRvw661+Q==
Date: Tue, 21 May 2024 20:11:43 -0700
Subject: [PATCH 088/111] libxfs: teach buftargs to maintain their own buffer
 hashtable
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634533020.2478931.8523684356641531856.stgit@frogsfrogsfrogs>
In-Reply-To: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
References: <171634531590.2478931.8474978645585392776.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Currently, cached buffers are indexed with a single global bcache
structure.  This works ok for the limited use case where we only support
reading from the data device, but will fail badly when we want to
support buffers from in-memory btrees.  Move the bcache structure into
the buftarg.

As a side effect, we don't need to compare buftarg->bt_bdev anymore
since libxfs is careful enough not to create more than one buftarg per
open fd.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/libxfs.h    |    1 -
 libxfs/init.c       |   48 +++++++++++++++++++++---------------------------
 libxfs/libxfs_io.h  |   10 ++++++----
 libxfs/logitem.c    |    2 +-
 libxfs/rdwr.c       |   45 +++++++++++++++++++++++++++++----------------
 mkfs/xfs_mkfs.c     |    2 +-
 repair/prefetch.c   |   12 ++++++++----
 repair/prefetch.h   |    1 +
 repair/progress.c   |   14 +++++++++-----
 repair/progress.h   |    2 +-
 repair/scan.c       |    2 +-
 repair/xfs_repair.c |   32 +++++++++++++++++---------------
 12 files changed, 95 insertions(+), 76 deletions(-)


diff --git a/include/libxfs.h b/include/libxfs.h
index aeec2bc76..60d3b7968 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -147,7 +147,6 @@ int		libxfs_init(struct libxfs_init *);
 void		libxfs_destroy(struct libxfs_init *li);
 
 extern int	libxfs_device_alignment (void);
-extern void	libxfs_report(FILE *);
 
 /* check or write log footer: specify device, log size in blocks & uuid */
 typedef char	*(libxfs_get_block_t)(char *, int, void *);
diff --git a/libxfs/init.c b/libxfs/init.c
index b2d7bc136..eaeb0b666 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -36,7 +36,6 @@ pthread_mutex_t	atomic64_lock = PTHREAD_MUTEX_INITIALIZER;
 
 char *progname = "libxfs";	/* default, changed by each tool */
 
-struct cache *libxfs_bcache;	/* global buffer cache */
 int libxfs_bhash_size;		/* #buckets in bcache */
 
 int	use_xfs_buf_lock;	/* global flag: use xfs_buf locks for MT */
@@ -267,8 +266,6 @@ libxfs_init(struct libxfs_init *a)
 
 	if (!libxfs_bhash_size)
 		libxfs_bhash_size = LIBXFS_BHASHSIZE(sbp);
-	libxfs_bcache = cache_init(a->bcache_flags, libxfs_bhash_size,
-				   &libxfs_bcache_operations);
 	use_xfs_buf_lock = a->flags & LIBXFS_USEBUFLOCK;
 	xfs_dir_startup();
 	init_caches();
@@ -451,6 +448,7 @@ xfs_set_inode_alloc(
 static struct xfs_buftarg *
 libxfs_buftarg_alloc(
 	struct xfs_mount	*mp,
+	struct libxfs_init	*xi,
 	struct libxfs_dev	*dev,
 	unsigned long		write_fails)
 {
@@ -472,6 +470,9 @@ libxfs_buftarg_alloc(
 	}
 	pthread_mutex_init(&btp->lock, NULL);
 
+	btp->bcache = cache_init(xi->bcache_flags, libxfs_bhash_size,
+			&libxfs_bcache_operations);
+
 	return btp;
 }
 
@@ -568,12 +569,13 @@ libxfs_buftarg_init(
 		return;
 	}
 
-	mp->m_ddev_targp = libxfs_buftarg_alloc(mp, &xi->data, dfail);
+	mp->m_ddev_targp = libxfs_buftarg_alloc(mp, xi, &xi->data, dfail);
 	if (!xi->log.dev || xi->log.dev == xi->data.dev)
 		mp->m_logdev_targp = mp->m_ddev_targp;
 	else
-		mp->m_logdev_targp = libxfs_buftarg_alloc(mp, &xi->log, lfail);
-	mp->m_rtdev_targp = libxfs_buftarg_alloc(mp, &xi->rt, rfail);
+		mp->m_logdev_targp = libxfs_buftarg_alloc(mp, xi, &xi->log,
+				lfail);
+	mp->m_rtdev_targp = libxfs_buftarg_alloc(mp, xi, &xi->rt, rfail);
 }
 
 /* Compute maximum possible height for per-AG btree types for this fs. */
@@ -856,7 +858,7 @@ libxfs_flush_mount(
 	 * LOST_WRITE flag to be set in the buftarg.  Once that's done,
 	 * instruct the disks to persist their write caches.
 	 */
-	libxfs_bcache_flush();
+	libxfs_bcache_flush(mp);
 
 	/* Flush all kernel and disk write caches, and report failures. */
 	if (mp->m_ddev_targp) {
@@ -882,6 +884,14 @@ libxfs_flush_mount(
 	return error;
 }
 
+static void
+libxfs_buftarg_free(
+	struct xfs_buftarg	*btp)
+{
+	cache_destroy(btp->bcache);
+	kmem_free(btp);
+}
+
 /*
  * Release any resource obtained during a mount.
  */
@@ -898,7 +908,7 @@ libxfs_umount(
 	 * all incore buffers, then pick up the outcome when we tell the disks
 	 * to persist their write caches.
 	 */
-	libxfs_bcache_purge();
+	libxfs_bcache_purge(mp);
 	error = libxfs_flush_mount(mp);
 
 	/*
@@ -913,10 +923,10 @@ libxfs_umount(
 	free(mp->m_fsname);
 	mp->m_fsname = NULL;
 
-	kmem_free(mp->m_rtdev_targp);
+	libxfs_buftarg_free(mp->m_rtdev_targp);
 	if (mp->m_logdev_targp != mp->m_ddev_targp)
-		kmem_free(mp->m_logdev_targp);
-	kmem_free(mp->m_ddev_targp);
+		libxfs_buftarg_free(mp->m_logdev_targp);
+	libxfs_buftarg_free(mp->m_ddev_targp);
 
 	return error;
 }
@@ -932,10 +942,7 @@ libxfs_destroy(
 
 	libxfs_close_devices(li);
 
-	/* Free everything from the buffer cache before freeing buffer cache */
-	libxfs_bcache_purge();
 	libxfs_bcache_free();
-	cache_destroy(libxfs_bcache);
 	leaked = destroy_caches();
 	rcu_unregister_thread();
 	if (getenv("LIBXFS_LEAK_CHECK") && leaked)
@@ -947,16 +954,3 @@ libxfs_device_alignment(void)
 {
 	return platform_align_blockdev();
 }
-
-void
-libxfs_report(FILE *fp)
-{
-	time_t t;
-	char *c;
-
-	cache_report(fp, "libxfs_bcache", libxfs_bcache);
-
-	t = time(NULL);
-	c = asctime(localtime(&t));
-	fprintf(fp, "%s", c);
-}
diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 259c6a7cf..7877e1768 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -28,6 +28,7 @@ struct xfs_buftarg {
 	dev_t			bt_bdev;
 	int			bt_bdev_fd;
 	unsigned int		flags;
+	struct cache		*bcache;	/* buffer cache */
 };
 
 /* We purged a dirty buffer and lost a write. */
@@ -36,6 +37,8 @@ struct xfs_buftarg {
 #define XFS_BUFTARG_CORRUPT_WRITE	(1 << 1)
 /* Simulate failure after a certain number of writes. */
 #define XFS_BUFTARG_INJECT_WRITE_FAIL	(1 << 2)
+/* purge buffers when lookups find a size mismatch */
+#define XFS_BUFTARG_MISCOMPARE_PURGE	(1 << 3)
 
 /* Simulate the system crashing after a certain number of writes. */
 static inline void
@@ -140,7 +143,6 @@ int libxfs_buf_priority(struct xfs_buf *bp);
 
 /* Buffer Cache Interfaces */
 
-extern struct cache	*libxfs_bcache;
 extern struct cache_operations	libxfs_bcache_operations;
 
 #define LIBXFS_GETBUF_TRYLOCK	(1 << 0)
@@ -184,10 +186,10 @@ libxfs_buf_read(
 
 int libxfs_readbuf_verify(struct xfs_buf *bp, const struct xfs_buf_ops *ops);
 struct xfs_buf *libxfs_getsb(struct xfs_mount *mp);
-extern void	libxfs_bcache_purge(void);
+extern void	libxfs_bcache_purge(struct xfs_mount *mp);
 extern void	libxfs_bcache_free(void);
-extern void	libxfs_bcache_flush(void);
-extern int	libxfs_bcache_overflowed(void);
+extern void	libxfs_bcache_flush(struct xfs_mount *mp);
+extern int	libxfs_bcache_overflowed(struct xfs_mount *mp);
 
 /* Buffer (Raw) Interfaces */
 int		libxfs_bwrite(struct xfs_buf *bp);
diff --git a/libxfs/logitem.c b/libxfs/logitem.c
index 3ce2d7574..7757259df 100644
--- a/libxfs/logitem.c
+++ b/libxfs/logitem.c
@@ -46,7 +46,7 @@ xfs_trans_buf_item_match(
 	list_for_each_entry(lip, &tp->t_items, li_trans) {
 		blip = (struct xfs_buf_log_item *)lip;
 		if (blip->bli_item.li_type == XFS_LI_BUF &&
-		    blip->bli_buf->b_target->bt_bdev == btp->bt_bdev &&
+		    blip->bli_buf->b_target == btp &&
 		    xfs_buf_daddr(blip->bli_buf) == map[0].bm_bn &&
 		    blip->bli_buf->b_length == len) {
 			ASSERT(blip->bli_buf->b_map_count == nmaps);
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 153007d5f..cf986a7e7 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -198,18 +198,20 @@ libxfs_bhash(cache_key_t key, unsigned int hashsize, unsigned int hashshift)
 }
 
 static int
-libxfs_bcompare(struct cache_node *node, cache_key_t key)
+libxfs_bcompare(
+	struct cache_node	*node,
+	cache_key_t		key)
 {
 	struct xfs_buf		*bp = container_of(node, struct xfs_buf,
 						   b_node);
 	struct xfs_bufkey	*bkey = (struct xfs_bufkey *)key;
+	struct cache		*bcache = bkey->buftarg->bcache;
 
-	if (bp->b_target->bt_bdev == bkey->buftarg->bt_bdev &&
-	    bp->b_cache_key == bkey->blkno) {
+	if (bp->b_cache_key == bkey->blkno) {
 		if (bp->b_length == bkey->bblen)
 			return CACHE_HIT;
 #ifdef IO_BCOMPARE_CHECK
-		if (!(libxfs_bcache->c_flags & CACHE_MISCOMPARE_PURGE)) {
+		if (!(bcache->c_flags & CACHE_MISCOMPARE_PURGE)) {
 			fprintf(stderr,
 	"%lx: Badness in key lookup (length)\n"
 	"bp=(bno 0x%llx, len %u bytes) key=(bno 0x%llx, len %u bytes)\n",
@@ -399,11 +401,12 @@ __cache_lookup(
 	struct xfs_buf		**bpp)
 {
 	struct cache_node	*cn = NULL;
+	struct cache		*bcache = key->buftarg->bcache;
 	struct xfs_buf		*bp;
 
 	*bpp = NULL;
 
-	cache_node_get(libxfs_bcache, key, &cn);
+	cache_node_get(bcache, key, &cn);
 	if (!cn)
 		return -ENOMEM;
 	bp = container_of(cn, struct xfs_buf, b_node);
@@ -415,7 +418,7 @@ __cache_lookup(
 		if (ret) {
 			ASSERT(ret == EAGAIN);
 			if (flags & LIBXFS_GETBUF_TRYLOCK) {
-				cache_node_put(libxfs_bcache, cn);
+				cache_node_put(bcache, cn);
 				return -EAGAIN;
 			}
 
@@ -434,7 +437,7 @@ __cache_lookup(
 		bp->b_holder = pthread_self();
 	}
 
-	cache_node_set_priority(libxfs_bcache, cn,
+	cache_node_set_priority(bcache, cn,
 			cache_node_get_priority(cn) - CACHE_PREFETCH_PRIORITY);
 	*bpp = bp;
 	return 0;
@@ -550,7 +553,7 @@ libxfs_buf_relse(
 	}
 
 	if (!list_empty(&bp->b_node.cn_hash))
-		cache_node_put(libxfs_bcache, &bp->b_node);
+		cache_node_put(bp->b_target->bcache, &bp->b_node);
 	else if (--bp->b_node.cn_count == 0) {
 		if (bp->b_flags & LIBXFS_B_DIRTY)
 			libxfs_bwrite(bp);
@@ -606,7 +609,7 @@ libxfs_readbufr(struct xfs_buftarg *btp, xfs_daddr_t blkno, struct xfs_buf *bp,
 
 	error = __read_buf(fd, bp->b_addr, bytes, LIBXFS_BBTOOFF64(blkno), flags);
 	if (!error &&
-	    bp->b_target->bt_bdev == btp->bt_bdev &&
+	    bp->b_target == btp &&
 	    bp->b_cache_key == blkno &&
 	    bp->b_length == len)
 		bp->b_flags |= LIBXFS_B_UPTODATE;
@@ -1003,21 +1006,31 @@ libxfs_bflush(
 }
 
 void
-libxfs_bcache_purge(void)
+libxfs_bcache_purge(struct xfs_mount *mp)
 {
-	cache_purge(libxfs_bcache);
+	if (!mp)
+		return;
+	cache_purge(mp->m_ddev_targp->bcache);
+	cache_purge(mp->m_logdev_targp->bcache);
+	cache_purge(mp->m_rtdev_targp->bcache);
 }
 
 void
-libxfs_bcache_flush(void)
+libxfs_bcache_flush(struct xfs_mount *mp)
 {
-	cache_flush(libxfs_bcache);
+	if (!mp)
+		return;
+	cache_flush(mp->m_ddev_targp->bcache);
+	cache_flush(mp->m_logdev_targp->bcache);
+	cache_flush(mp->m_rtdev_targp->bcache);
 }
 
 int
-libxfs_bcache_overflowed(void)
+libxfs_bcache_overflowed(struct xfs_mount *mp)
 {
-	return cache_overflowed(libxfs_bcache);
+	return cache_overflowed(mp->m_ddev_targp->bcache) ||
+		cache_overflowed(mp->m_logdev_targp->bcache) ||
+		cache_overflowed(mp->m_rtdev_targp->bcache);
 }
 
 struct cache_operations libxfs_bcache_operations = {
@@ -1466,7 +1479,7 @@ libxfs_buf_set_priority(
 	struct xfs_buf	*bp,
 	int		priority)
 {
-	cache_node_set_priority(libxfs_bcache, &bp->b_node, priority);
+	cache_node_set_priority(bp->b_target->bcache, &bp->b_node, priority);
 }
 
 int
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index f4a9bf20f..d6fa48ede 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -4613,7 +4613,7 @@ main(
 	 * Need to drop references to inodes we still hold, first.
 	 */
 	libxfs_rtmount_destroy(mp);
-	libxfs_bcache_purge();
+	libxfs_bcache_purge(mp);
 
 	/*
 	 * Mark the filesystem ok.
diff --git a/repair/prefetch.c b/repair/prefetch.c
index b0dd19775..de36c5fe2 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -886,10 +886,12 @@ init_prefetch(
 
 prefetch_args_t *
 start_inode_prefetch(
+	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno,
 	int			dirs_only,
 	prefetch_args_t		*prev_args)
 {
+	struct cache		*bcache = mp->m_ddev_targp->bcache;
 	prefetch_args_t		*args;
 	long			max_queue;
 	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
@@ -914,7 +916,7 @@ start_inode_prefetch(
 	 * and not any other associated metadata like directories
 	 */
 
-	max_queue = libxfs_bcache->c_maxcount / thread_count / 8;
+	max_queue = bcache->c_maxcount / thread_count / 8;
 	if (igeo->inode_cluster_size > mp->m_sb.sb_blocksize)
 		max_queue = max_queue * igeo->blocks_per_cluster /
 				igeo->ialloc_blks;
@@ -970,14 +972,16 @@ prefetch_ag_range(
 	void			(*func)(struct workqueue *,
 					xfs_agnumber_t, void *))
 {
+	struct xfs_mount	*mp = work->wq_ctx;
 	int			i;
 	struct prefetch_args	*pf_args[2];
 
-	pf_args[start_ag & 1] = start_inode_prefetch(start_ag, dirs_only, NULL);
+	pf_args[start_ag & 1] = start_inode_prefetch(mp, start_ag, dirs_only,
+			NULL);
 	for (i = start_ag; i < end_ag; i++) {
 		/* Don't prefetch end_ag */
 		if (i + 1 < end_ag)
-			pf_args[(~i) & 1] = start_inode_prefetch(i + 1,
+			pf_args[(~i) & 1] = start_inode_prefetch(mp, i + 1,
 						dirs_only, pf_args[i & 1]);
 		func(work, i, pf_args[i & 1]);
 	}
@@ -1027,7 +1031,7 @@ do_inode_prefetch(
 	 * filesystem - it's all in the cache. In that case, run a thread per
 	 * CPU to maximise parallelism of the queue to be processed.
 	 */
-	if (check_cache && !libxfs_bcache_overflowed()) {
+	if (check_cache && !libxfs_bcache_overflowed(mp)) {
 		queue.wq_ctx = mp;
 		create_work_queue(&queue, mp, platform_nproc());
 		for (i = 0; i < mp->m_sb.sb_agcount; i++)
diff --git a/repair/prefetch.h b/repair/prefetch.h
index 54ece48ad..a8c52a119 100644
--- a/repair/prefetch.h
+++ b/repair/prefetch.h
@@ -39,6 +39,7 @@ init_prefetch(
 
 prefetch_args_t *
 start_inode_prefetch(
+	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno,
 	int			dirs_only,
 	prefetch_args_t		*prev_args);
diff --git a/repair/progress.c b/repair/progress.c
index 2ce36cef0..084afa63c 100644
--- a/repair/progress.c
+++ b/repair/progress.c
@@ -384,14 +384,18 @@ timediff(int phase)
 **  array.
 */
 char *
-timestamp(int end, int phase, char *buf)
+timestamp(
+	struct xfs_mount	*mp,
+	int			end,
+	int			phase,
+	char			*buf)
 {
 
-	time_t    now;
-	struct tm *tmp;
+	time_t			now;
+	struct tm		*tmp;
 
-	if (verbose > 1)
-		cache_report(stderr, "libxfs_bcache", libxfs_bcache);
+	if (verbose > 1 && mp && mp->m_ddev_targp)
+		cache_report(stderr, "libxfs_bcache", mp->m_ddev_targp->bcache);
 
 	now = time(NULL);
 
diff --git a/repair/progress.h b/repair/progress.h
index 9575df164..0b06b2c4f 100644
--- a/repair/progress.h
+++ b/repair/progress.h
@@ -37,7 +37,7 @@ extern void stop_progress_rpt(void);
 extern void summary_report(void);
 extern int  set_progress_msg(int report, uint64_t total);
 extern uint64_t print_final_rpt(void);
-extern char *timestamp(int end, int phase, char *buf);
+extern char *timestamp(struct xfs_mount *mp, int end, int phase, char *buf);
 extern char *duration(time_t val, char *buf);
 extern int do_parallel;
 
diff --git a/repair/scan.c b/repair/scan.c
index 7e6d94cfa..715be1166 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -42,7 +42,7 @@ struct aghdr_cnts {
 void
 set_mp(xfs_mount_t *mpp)
 {
-	libxfs_bcache_purge();
+	libxfs_bcache_purge(mp);
 	mp = mpp;
 }
 
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 2fc89dac3..ae3d2fcb0 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -980,9 +980,11 @@ repair_capture_writeback(
 }
 
 static inline void
-phase_end(int phase)
+phase_end(
+	struct xfs_mount	*mp,
+	int			phase)
 {
-	timestamp(PHASE_END, phase, NULL);
+	timestamp(mp, PHASE_END, phase, NULL);
 
 	/* Fail if someone injected an post-phase error. */
 	if (fail_after_phase && phase == fail_after_phase)
@@ -1017,8 +1019,8 @@ main(int argc, char **argv)
 
 	msgbuf = malloc(DURATION_BUF_SIZE);
 
-	timestamp(PHASE_START, 0, NULL);
-	phase_end(0);
+	timestamp(temp_mp, PHASE_START, 0, NULL);
+	phase_end(temp_mp, 0);
 
 	/* -f forces this, but let's be nice and autodetect it, as well. */
 	if (!isa_file) {
@@ -1040,7 +1042,7 @@ main(int argc, char **argv)
 
 	/* do phase1 to make sure we have a superblock */
 	phase1(temp_mp);
-	phase_end(1);
+	phase_end(temp_mp, 1);
 
 	if (no_modify && primary_sb_modified)  {
 		do_warn(_("Primary superblock would have been modified.\n"
@@ -1177,8 +1179,8 @@ main(int argc, char **argv)
 		unsigned long	max_mem;
 		struct rlimit	rlim;
 
-		libxfs_bcache_purge();
-		cache_destroy(libxfs_bcache);
+		libxfs_bcache_purge(mp);
+		cache_destroy(mp->m_ddev_targp->bcache);
 
 		mem_used = (mp->m_sb.sb_icount >> (10 - 2)) +
 					(mp->m_sb.sb_dblocks >> (10 + 1)) +
@@ -1238,7 +1240,7 @@ main(int argc, char **argv)
 			do_log(_("        - block cache size set to %d entries\n"),
 				libxfs_bhash_size * HASH_CACHE_RATIO);
 
-		libxfs_bcache = cache_init(0, libxfs_bhash_size,
+		mp->m_ddev_targp->bcache = cache_init(0, libxfs_bhash_size,
 						&libxfs_bcache_operations);
 	}
 
@@ -1266,16 +1268,16 @@ main(int argc, char **argv)
 
 	/* make sure the per-ag freespace maps are ok so we can mount the fs */
 	phase2(mp, phase2_threads);
-	phase_end(2);
+	phase_end(mp, 2);
 
 	if (do_prefetch)
 		init_prefetch(mp);
 
 	phase3(mp, phase2_threads);
-	phase_end(3);
+	phase_end(mp, 3);
 
 	phase4(mp);
-	phase_end(4);
+	phase_end(mp, 4);
 
 	if (no_modify) {
 		printf(_("No modify flag set, skipping phase 5\n"));
@@ -1285,7 +1287,7 @@ main(int argc, char **argv)
 	} else {
 		phase5(mp);
 	}
-	phase_end(5);
+	phase_end(mp, 5);
 
 	/*
 	 * Done with the block usage maps, toss them...
@@ -1295,10 +1297,10 @@ main(int argc, char **argv)
 
 	if (!bad_ino_btree)  {
 		phase6(mp);
-		phase_end(6);
+		phase_end(mp, 6);
 
 		phase7(mp, phase2_threads);
-		phase_end(7);
+		phase_end(mp, 7);
 	} else  {
 		do_warn(
 _("Inode allocation btrees are too corrupted, skipping phases 6 and 7\n"));
@@ -1423,7 +1425,7 @@ _("Note - stripe unit (%d) and width (%d) were copied from a backup superblock.\
 	 * verifiers are run (where we discover the max metadata LSN), reformat
 	 * the log if necessary and unmount.
 	 */
-	libxfs_bcache_flush();
+	libxfs_bcache_flush(mp);
 	format_log_max_lsn(mp);
 
 	if (xfs_sb_version_needsrepair(&mp->m_sb))


