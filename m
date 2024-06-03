Return-Path: <linux-xfs+bounces-8963-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 017A38D89D6
	for <lists+linux-xfs@lfdr.de>; Mon,  3 Jun 2024 21:18:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 223421C247EE
	for <lists+linux-xfs@lfdr.de>; Mon,  3 Jun 2024 19:18:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CD17139D0B;
	Mon,  3 Jun 2024 19:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L2Cv9emA"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E15AF23A0
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717442163; cv=none; b=L+TukuxV/WwU8xVsYH1eXSlqiw4a4yXsvKA1iBrpnu5m69KzOxRbOZiqG45vfqZLxOFOV4YLUsS+ue+gntyzm5WkWCe92PiUnsCKFZ7MFTO88hiN7jowwT7QE0Dk9MvNzlvwV5SjzqmKfBrHp1OHDxZq8dYMz9/yGhwJ7sBjHxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717442163; c=relaxed/simple;
	bh=xM0T2qnAPeB8AKODTqZsPMsDD2AP2EubX5V3vHOcGlg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JOMH/bygcyr8LBgFPiSclmu+rLcC303sPROBlAMYzouuBmJSqsSlki0WWrr5HnJu5UdqNHyxwgfhzun88t4oZGiB0mvuKJ6n2Eudu2aW5fXX3td5CB9mZOZdMi6tcWukvqH0MG7WgZA+uJ+JH6w55AWPCRHpAeXWLrT3WEOJ7fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L2Cv9emA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC1B4C2BD10;
	Mon,  3 Jun 2024 19:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717442162;
	bh=xM0T2qnAPeB8AKODTqZsPMsDD2AP2EubX5V3vHOcGlg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=L2Cv9emAeon1/okSSgp/s/MBmQApgo+ejSosa2mT9C5VDi/l1J3+1AIt0847YKcy4
	 OkY33uCNpeubj3qOYNekBNTLW+HlSiFfz2bHCzJBis+Q+vxfcchnVEDUM8wyM/A6Lf
	 gdZcPhYWsNcqICIPH/gcNMZcnpFpZkSUeKjRCKaKT0tBEzn5XHtlNG7k05VjHOwa/l
	 WGroQu9eNzPUodKj/jiKeE2FeEsFP9o+6eDOoYmmAmHJ1Dh3MN2U46uyHcbz7mCnCr
	 pasL2QXqX0J2z4Rx+RpWZAqNZIZC3D0at+a8DRS9j254Ms5BNIuC+xunVJR2vzHzAX
	 WbkLtKeDamQCQ==
Date: Mon, 03 Jun 2024 12:16:02 -0700
Subject: [PATCH 092/111] libxfs: support in-memory buffer cache targets
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744040747.1443973.11744591949206973489.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
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

Allow the buffer cache to target in-memory files by connecting it to
xfiles.  The next few patches will enable creating xfs_btrees in memory.
Unlike the kernel version of this patch, we use a partitioned xfile to
avoid overflowing the fd table instead of opening a separate memfd for
each target.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/Makefile    |    4 +
 libxfs/buf_mem.c   |  235 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/buf_mem.h   |   26 ++++++
 libxfs/init.c      |    4 +
 libxfs/libxfs_io.h |   22 +++++
 libxfs/rdwr.c      |   41 ++++-----
 6 files changed, 310 insertions(+), 22 deletions(-)
 create mode 100644 libxfs/buf_mem.c
 create mode 100644 libxfs/buf_mem.h


diff --git a/libxfs/Makefile b/libxfs/Makefile
index 43e8ae183..8dc9a7905 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -26,6 +26,7 @@ HFILES = \
 	libxfs_priv.h \
 	linux-err.h \
 	topology.h \
+	buf_mem.h \
 	xfile.h \
 	xfs_ag_resv.h \
 	xfs_alloc.h \
@@ -58,7 +59,8 @@ HFILES = \
 	xfs_trans_space.h \
 	xfs_dir2_priv.h
 
-CFILES = cache.c \
+CFILES = buf_mem.c \
+	cache.c \
 	defer_item.c \
 	init.c \
 	kmem.c \
diff --git a/libxfs/buf_mem.c b/libxfs/buf_mem.c
new file mode 100644
index 000000000..7c8fa1d2c
--- /dev/null
+++ b/libxfs/buf_mem.c
@@ -0,0 +1,235 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2023-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "libxfs_priv.h"
+#include "libxfs.h"
+#include "libxfs/xfile.h"
+#include "libxfs/buf_mem.h"
+#include <sys/mman.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+
+/*
+ * Buffer Cache for In-Memory Files
+ * ================================
+ *
+ * Offline fsck wants to create ephemeral ordered recordsets.  The existing
+ * btree infrastructure can do this, but we need the buffer cache to target
+ * memory instead of block devices.
+ *
+ * xfiles meet those requirements.  Therefore, the xmbuf mechanism uses a
+ * partition on an xfile to store the staging data.
+ *
+ * xmbufs assume that the caller will handle all required concurrency
+ * management.  The resulting xfs_buf objects are kept private to the xmbuf
+ * (they are not recycled to the LRU) because b_addr is mapped directly to the
+ * memfd file.
+ *
+ * The only supported block size is the system page size.
+ */
+
+/* Figure out the xfile buffer cache block size here */
+unsigned int	XMBUF_BLOCKSIZE;
+unsigned int	XMBUF_BLOCKSHIFT;
+
+void
+xmbuf_libinit(void)
+{
+	long		ret = sysconf(_SC_PAGESIZE);
+
+	/* If we don't find a power-of-two page size, go with 4k. */
+	if (ret < 0 || !is_power_of_2(ret))
+		ret = 4096;
+
+	XMBUF_BLOCKSIZE = ret;
+	XMBUF_BLOCKSHIFT = libxfs_highbit32(XMBUF_BLOCKSIZE);
+}
+
+/* Allocate a new cache node (aka a xfs_buf) */
+static struct cache_node *
+xmbuf_cache_alloc(
+	cache_key_t		key)
+{
+	struct xfs_bufkey	*bufkey = (struct xfs_bufkey *)key;
+	struct xfs_buf		*bp;
+	int			error;
+
+	bp = kmem_cache_zalloc(xfs_buf_cache, 0);
+	if (!bp)
+		return NULL;
+
+	bp->b_cache_key = bufkey->blkno;
+	bp->b_length = bufkey->bblen;
+	bp->b_target = bufkey->buftarg;
+	bp->b_mount = bufkey->buftarg->bt_mount;
+
+	pthread_mutex_init(&bp->b_lock, NULL);
+	INIT_LIST_HEAD(&bp->b_li_list);
+	bp->b_maps = &bp->__b_map;
+
+	bp->b_nmaps = 1;
+	bp->b_maps[0].bm_bn = bufkey->blkno;
+	bp->b_maps[0].bm_len = bp->b_length;
+
+	error = xmbuf_map_page(bp);
+	if (error) {
+		fprintf(stderr,
+ _("%s: %s can't mmap %u bytes at xfile offset %llu: %s\n"),
+				progname, __FUNCTION__, BBTOB(bp->b_length),
+				(unsigned long long)BBTOB(bufkey->blkno),
+				strerror(error));
+
+		kmem_cache_free(xfs_buf_cache, bp);
+		return NULL;
+	}
+
+	return &bp->b_node;
+}
+
+/* Flush a buffer to disk before purging the cache node */
+static int
+xmbuf_cache_flush(
+	struct cache_node	*node)
+{
+	/* direct mapped buffers do not need writing */
+	return 0;
+}
+
+/* Release resources, free the buffer. */
+static void
+xmbuf_cache_relse(
+	struct cache_node	*node)
+{
+	struct xfs_buf		*bp;
+
+	bp = container_of(node, struct xfs_buf, b_node);
+	xmbuf_unmap_page(bp);
+	kmem_cache_free(xfs_buf_cache, bp);
+}
+
+/* Release a bunch of buffers */
+static unsigned int
+xmbuf_cache_bulkrelse(
+	struct cache		*cache,
+	struct list_head	*list)
+{
+	struct cache_node	*cn, *n;
+	int			count = 0;
+
+	if (list_empty(list))
+		return 0;
+
+	list_for_each_entry_safe(cn, n, list, cn_mru) {
+		xmbuf_cache_relse(cn);
+		count++;
+	}
+
+	return count;
+}
+
+static struct cache_operations xmbuf_bcache_operations = {
+	.hash		= libxfs_bhash,
+	.alloc		= xmbuf_cache_alloc,
+	.flush		= xmbuf_cache_flush,
+	.relse		= xmbuf_cache_relse,
+	.compare	= libxfs_bcompare,
+	.bulkrelse	= xmbuf_cache_bulkrelse
+};
+
+/*
+ * Allocate a buffer cache target for a memory-backed file and set up the
+ * buffer target.
+ */
+int
+xmbuf_alloc(
+	struct xfs_mount	*mp,
+	const char		*descr,
+	unsigned long long	maxpos,
+	struct xfs_buftarg	**btpp)
+{
+	struct xfs_buftarg	*btp;
+	struct xfile		*xfile;
+	struct cache		*cache;
+	int			error;
+
+	btp = kzalloc(sizeof(*btp), GFP_KERNEL);
+	if (!btp)
+		return -ENOMEM;
+
+	error = xfile_create(descr, maxpos, &xfile);
+	if (error)
+		goto out_btp;
+
+	cache = cache_init(0, LIBXFS_BHASHSIZE(NULL), &xmbuf_bcache_operations);
+	if (!cache) {
+		error = -ENOMEM;
+		goto out_xfile;
+	}
+
+	/* Initialize buffer target */
+	btp->bt_mount = mp;
+	btp->bt_bdev = (dev_t)-1;
+	btp->bt_bdev_fd = -1;
+	btp->bt_xfile = xfile;
+	btp->bcache = cache;
+
+	error = pthread_mutex_init(&btp->lock, NULL);
+	if (error)
+		goto out_cache;
+
+	*btpp = btp;
+	return 0;
+
+out_cache:
+	cache_destroy(cache);
+out_xfile:
+	xfile_destroy(xfile);
+out_btp:
+	kfree(btp);
+	return error;
+}
+
+/* Free a buffer cache target for a memory-backed file. */
+void
+xmbuf_free(
+	struct xfs_buftarg	*btp)
+{
+	ASSERT(xfs_buftarg_is_mem(btp));
+
+	cache_destroy(btp->bcache);
+	pthread_mutex_destroy(&btp->lock);
+	xfile_destroy(btp->bt_xfile);
+	kfree(btp);
+}
+
+/* Directly map a memfd page into the buffer cache. */
+int
+xmbuf_map_page(
+	struct xfs_buf		*bp)
+{
+	struct xfile		*xfile = bp->b_target->bt_xfile;
+	void			*p;
+	loff_t			pos;
+
+	pos = xfile->partition_pos + BBTOB(xfs_buf_daddr(bp));
+	p = mmap(NULL, BBTOB(bp->b_length), PROT_READ | PROT_WRITE, MAP_SHARED,
+			xfile->fcb->fd, pos);
+	if (p == MAP_FAILED)
+		return -errno;
+
+	bp->b_addr = p;
+	bp->b_flags |= LIBXFS_B_UPTODATE | LIBXFS_B_UNCHECKED;
+	bp->b_error = 0;
+	return 0;
+}
+
+/* Unmap a memfd page that was mapped into the buffer cache. */
+void
+xmbuf_unmap_page(
+	struct xfs_buf		*bp)
+{
+	munmap(bp->b_addr, BBTOB(bp->b_length));
+	bp->b_addr = NULL;
+}
diff --git a/libxfs/buf_mem.h b/libxfs/buf_mem.h
new file mode 100644
index 000000000..d2be2c424
--- /dev/null
+++ b/libxfs/buf_mem.h
@@ -0,0 +1,26 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2023-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_BUF_MEM_H__
+#define __XFS_BUF_MEM_H__
+
+extern unsigned int		XMBUF_BLOCKSIZE;
+extern unsigned int		XMBUF_BLOCKSHIFT;
+
+void xmbuf_libinit(void);
+
+static inline bool xfs_buftarg_is_mem(const struct xfs_buftarg *target)
+{
+	return target->bt_xfile != NULL;
+}
+
+int xmbuf_alloc(struct xfs_mount *mp, const char *descr,
+		unsigned long long maxpos, struct xfs_buftarg **btpp);
+void xmbuf_free(struct xfs_buftarg *btp);
+
+int xmbuf_map_page(struct xfs_buf *bp);
+void xmbuf_unmap_page(struct xfs_buf *bp);
+
+#endif /* __XFS_BUF_MEM_H__ */
diff --git a/libxfs/init.c b/libxfs/init.c
index eaeb0b666..82618a07e 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -22,6 +22,8 @@
 #include "xfs_rmap_btree.h"
 #include "xfs_refcount_btree.h"
 #include "libfrog/platform.h"
+#include "libxfs/xfile.h"
+#include "libxfs/buf_mem.h"
 
 #include "xfs_format.h"
 #include "xfs_da_format.h"
@@ -253,6 +255,7 @@ int
 libxfs_init(struct libxfs_init *a)
 {
 	xfs_check_ondisk_structs();
+	xmbuf_libinit();
 	rcu_init();
 	rcu_register_thread();
 	radix_tree_init();
@@ -463,6 +466,7 @@ libxfs_buftarg_alloc(
 	btp->bt_mount = mp;
 	btp->bt_bdev = dev->dev;
 	btp->bt_bdev_fd = dev->fd;
+	btp->bt_xfile = NULL;
 	btp->flags = 0;
 	if (write_fails) {
 		btp->writes_left = write_fails;
diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 7877e1768..ae3c4a948 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -27,6 +27,7 @@ struct xfs_buftarg {
 	unsigned long		writes_left;
 	dev_t			bt_bdev;
 	int			bt_bdev_fd;
+	struct xfile		*bt_xfile;
 	unsigned int		flags;
 	struct cache		*bcache;	/* buffer cache */
 };
@@ -58,6 +59,27 @@ xfs_buftarg_trip_write(
 void libxfs_buftarg_init(struct xfs_mount *mp, struct libxfs_init *xi);
 int libxfs_blkdev_issue_flush(struct xfs_buftarg *btp);
 
+/*
+ * The bufkey is used to pass the new buffer information to the cache object
+ * allocation routine. Because discontiguous buffers need to pass different
+ * information, we need fields to pass that information. However, because the
+ * blkno and bblen is needed for the initial cache entry lookup (i.e. for
+ * bcompare) the fact that the map/nmaps is non-null to switch to discontiguous
+ * buffer initialisation instead of a contiguous buffer.
+ */
+struct xfs_bufkey {
+	struct xfs_buftarg	*buftarg;
+	xfs_daddr_t		blkno;
+	unsigned int		bblen;
+	struct xfs_buf_map	*map;
+	int			nmaps;
+};
+
+/* for buf_mem.c only: */
+unsigned int libxfs_bhash(cache_key_t key, unsigned int hashsize,
+		unsigned int hashshift);
+int libxfs_bcompare(struct cache_node *node, cache_key_t key);
+
 #define LIBXFS_BBTOOFF64(bbs)	(((xfs_off_t)(bbs)) << BBSHIFT)
 
 #define XB_PAGES        2
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index cf986a7e7..50760cd86 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -18,7 +18,8 @@
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "libfrog/platform.h"
-
+#include "libxfs/xfile.h"
+#include "libxfs/buf_mem.h"
 #include "libxfs.h"
 
 static void libxfs_brelse(struct cache_node *node);
@@ -69,6 +70,9 @@ libxfs_device_zero(struct xfs_buftarg *btp, xfs_daddr_t start, uint len)
 	char		*z;
 	int		error;
 
+	if (xfs_buftarg_is_mem(btp))
+		return -EOPNOTSUPP;
+
 	start_offset = LIBXFS_BBTOOFF64(start);
 
 	/* try to use special zeroing methods, fall back to writes if needed */
@@ -167,26 +171,10 @@ static struct cache_mru		xfs_buf_freelist =
 	{{&xfs_buf_freelist.cm_list, &xfs_buf_freelist.cm_list},
 	 0, PTHREAD_MUTEX_INITIALIZER };
 
-/*
- * The bufkey is used to pass the new buffer information to the cache object
- * allocation routine. Because discontiguous buffers need to pass different
- * information, we need fields to pass that information. However, because the
- * blkno and bblen is needed for the initial cache entry lookup (i.e. for
- * bcompare) the fact that the map/nmaps is non-null to switch to discontiguous
- * buffer initialisation instead of a contiguous buffer.
- */
-struct xfs_bufkey {
-	struct xfs_buftarg	*buftarg;
-	xfs_daddr_t		blkno;
-	unsigned int		bblen;
-	struct xfs_buf_map	*map;
-	int			nmaps;
-};
-
 /*  2^63 + 2^61 - 2^57 + 2^54 - 2^51 - 2^18 + 1 */
 #define GOLDEN_RATIO_PRIME	0x9e37fffffffc0001UL
 #define CACHE_LINE_SIZE		64
-static unsigned int
+unsigned int
 libxfs_bhash(cache_key_t key, unsigned int hashsize, unsigned int hashshift)
 {
 	uint64_t	hashval = ((struct xfs_bufkey *)key)->blkno;
@@ -197,7 +185,7 @@ libxfs_bhash(cache_key_t key, unsigned int hashsize, unsigned int hashshift)
 	return tmp % hashsize;
 }
 
-static int
+int
 libxfs_bcompare(
 	struct cache_node	*node,
 	cache_key_t		key)
@@ -231,6 +219,8 @@ static void
 __initbuf(struct xfs_buf *bp, struct xfs_buftarg *btp, xfs_daddr_t bno,
 		unsigned int bytes)
 {
+	ASSERT(!xfs_buftarg_is_mem(btp));
+
 	bp->b_flags = 0;
 	bp->b_cache_key = bno;
 	bp->b_length = BTOBB(bytes);
@@ -577,7 +567,6 @@ libxfs_balloc(
 	return &bp->b_node;
 }
 
-
 static int
 __read_buf(int fd, void *buf, int len, off_t offset, int flags)
 {
@@ -607,6 +596,9 @@ libxfs_readbufr(struct xfs_buftarg *btp, xfs_daddr_t blkno, struct xfs_buf *bp,
 
 	ASSERT(len <= bp->b_length);
 
+	if (xfs_buftarg_is_mem(btp))
+		return 0;
+
 	error = __read_buf(fd, bp->b_addr, bytes, LIBXFS_BBTOOFF64(blkno), flags);
 	if (!error &&
 	    bp->b_target == btp &&
@@ -639,6 +631,9 @@ libxfs_readbufr_map(struct xfs_buftarg *btp, struct xfs_buf *bp, int flags)
 	void	*buf;
 	int	i;
 
+	if (xfs_buftarg_is_mem(btp))
+		return 0;
+
 	buf = bp->b_addr;
 	for (i = 0; i < bp->b_nmaps; i++) {
 		off_t	offset = LIBXFS_BBTOOFF64(bp->b_maps[i].bm_bn);
@@ -857,7 +852,9 @@ libxfs_bwrite(
 		}
 	}
 
-	if (!(bp->b_flags & LIBXFS_B_DISCONTIG)) {
+	if (xfs_buftarg_is_mem(bp->b_target)) {
+		bp->b_error = 0;
+	} else if (!(bp->b_flags & LIBXFS_B_DISCONTIG)) {
 		bp->b_error = __write_buf(fd, bp->b_addr, BBTOB(bp->b_length),
 				    LIBXFS_BBTOOFF64(xfs_buf_daddr(bp)),
 				    bp->b_flags);
@@ -917,6 +914,8 @@ libxfs_buf_prepare_mru(
 		xfs_perag_put(bp->b_pag);
 	bp->b_pag = NULL;
 
+	ASSERT(!xfs_buftarg_is_mem(btp));
+
 	if (!(bp->b_flags & LIBXFS_B_DIRTY))
 		return;
 


