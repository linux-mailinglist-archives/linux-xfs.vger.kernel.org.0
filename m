Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B68FD16B665
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Feb 2020 01:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728320AbgBYAMO (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 24 Feb 2020 19:12:14 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:60064 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726651AbgBYAMO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 19:12:14 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P08jQx130035;
        Tue, 25 Feb 2020 00:12:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=iQ9UABiNe7217r8Or1v/OUYLMQamDiXLlv9S1w5gxC4=;
 b=I6fcfLvcYIHx/dgfGiwWqE0w4OdWwRflk/GBlV27IFVRuOAAONRhQRldOWpLzFwKVRri
 wsGdaDlwhD5tR63mBzmIALnpZs/uzWc07076ETE7wuJw2cMQAcaFxxmbFoDPxikRyGkb
 innl+DScBV3l3iO/EqbxFtHmCfMbYvnY9zs3U7XO8PWH6gVKoxsr2Xf28FSE8jXvbRAW
 PVC7P+dG6mf1n8oEQkiX+43n/u8XtAPNNRJhlzrBBjyE+XSpArSBETD+Y/KctFkut88I
 WIDwXtIwn2frT2EXoLok4l0bdwWrVNjOP4dAzIGqxZlJyvbBck9FnCBWmcVVZX2z8cc9 iQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2yavxrjrrt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:12:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01P07wj5109442;
        Tue, 25 Feb 2020 00:12:09 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2ybe12epmd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Feb 2020 00:12:09 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01P0C8eL031235;
        Tue, 25 Feb 2020 00:12:08 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Feb 2020 16:12:08 -0800
Subject: [PATCH 06/25] libxfs: replace libxfs_readbuf with libxfs_buf_read
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Date:   Mon, 24 Feb 2020 16:12:07 -0800
Message-ID: <158258952711.451378.86626666742773740.stgit@magnolia>
In-Reply-To: <158258948821.451378.9298492251721116455.stgit@magnolia>
References: <158258948821.451378.9298492251721116455.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 suspectscore=2 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002240181
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9541 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 spamscore=0 clxscore=1015 suspectscore=2 bulkscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 adultscore=0 priorityscore=1501 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002240181
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Change all the libxfs_readbuf calls to libxfs_buf_read to match the
kernel interface.  This enables us to hide libxfs_readbuf and simplify
the userspace buffer interface further.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 copy/xfs_copy.c          |    4 ++-
 db/init.c                |    2 +-
 db/io.c                  |    2 +-
 libxfs/init.c            |    8 +++----
 libxfs/libxfs_api_defs.h |    1 +
 libxfs/libxfs_io.h       |   25 +++++++++++++++------
 libxfs/rdwr.c            |   56 +++++++++++++++++++++++-----------------------
 mkfs/xfs_mkfs.c          |    4 ++-
 repair/attr_repair.c     |    6 ++---
 repair/dino_chunks.c     |    4 ++-
 repair/dinode.c          |    6 ++---
 repair/phase3.c          |    2 +-
 repair/prefetch.c        |    2 +-
 repair/rt.c              |    4 ++-
 repair/scan.c            |   12 +++++-----
 15 files changed, 75 insertions(+), 63 deletions(-)


diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 3e519471..9e9719a0 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -710,7 +710,7 @@ main(int argc, char **argv)
 
 	/* We don't yet know the sector size, so read maximal size */
 	libxfs_buftarg_init(&mbuf, xargs.ddev, xargs.logdev, xargs.rtdev);
-	sbp = libxfs_readbuf(mbuf.m_ddev_targp, XFS_SB_DADDR,
+	sbp = libxfs_buf_read(mbuf.m_ddev_targp, XFS_SB_DADDR,
 			     1 << (XFS_MAX_SECTORSIZE_LOG - BBSHIFT), 0, NULL);
 	sb = &mbuf.m_sb;
 	libxfs_sb_from_disk(sb, XFS_BUF_TO_SBP(sbp));
@@ -718,7 +718,7 @@ main(int argc, char **argv)
 	/* Do it again, now with proper length and verifier */
 	libxfs_buf_relse(sbp);
 	libxfs_purgebuf(sbp);
-	sbp = libxfs_readbuf(mbuf.m_ddev_targp, XFS_SB_DADDR,
+	sbp = libxfs_buf_read(mbuf.m_ddev_targp, XFS_SB_DADDR,
 			     1 << (sb->sb_sectlog - BBSHIFT),
 			     0, &xfs_sb_buf_ops);
 	libxfs_buf_relse(sbp);
diff --git a/db/init.c b/db/init.c
index 15b4ec0c..8bad7e53 100644
--- a/db/init.c
+++ b/db/init.c
@@ -112,7 +112,7 @@ init(
 	 */
 	memset(&xmount, 0, sizeof(struct xfs_mount));
 	libxfs_buftarg_init(&xmount, x.ddev, x.logdev, x.rtdev);
-	bp = libxfs_readbuf(xmount.m_ddev_targp, XFS_SB_DADDR,
+	bp = libxfs_buf_read(xmount.m_ddev_targp, XFS_SB_DADDR,
 			    1 << (XFS_MAX_SECTORSIZE_LOG - BBSHIFT), 0, NULL);
 
 	if (!bp || bp->b_error) {
diff --git a/db/io.c b/db/io.c
index a11b7bb1..163ccc89 100644
--- a/db/io.c
+++ b/db/io.c
@@ -545,7 +545,7 @@ set_cur(
 		bp = libxfs_readbuf_map(mp->m_ddev_targp, bbmap->b,
 					bbmap->nmaps, 0, ops);
 	} else {
-		bp = libxfs_readbuf(mp->m_ddev_targp, blknum, len, 0, ops);
+		bp = libxfs_buf_read(mp->m_ddev_targp, blknum, len, 0, ops);
 		iocur_top->bbmap = NULL;
 	}
 
diff --git a/libxfs/init.c b/libxfs/init.c
index 4efe1099..328f46ac 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -450,7 +450,7 @@ rtmount_init(
 			(unsigned long long) mp->m_sb.sb_rblocks);
 		return -1;
 	}
-	bp = libxfs_readbuf(mp->m_rtdev,
+	bp = libxfs_buf_read(mp->m_rtdev,
 			d - XFS_FSB_TO_BB(mp, 1), XFS_FSB_TO_BB(mp, 1), 0, NULL);
 	if (bp == NULL) {
 		fprintf(stderr, _("%s: realtime size check failed\n"),
@@ -730,7 +730,7 @@ libxfs_mount(
 		return mp;
 
 	/* device size checks must pass unless we're a debugger. */
-	bp = libxfs_readbuf(mp->m_dev, d - XFS_FSS_TO_BB(mp, 1),
+	bp = libxfs_buf_read(mp->m_dev, d - XFS_FSS_TO_BB(mp, 1),
 			XFS_FSS_TO_BB(mp, 1), 0, NULL);
 	if (!bp) {
 		fprintf(stderr, _("%s: data size check failed\n"), progname);
@@ -743,7 +743,7 @@ libxfs_mount(
 	    mp->m_logdev_targp->dev != mp->m_ddev_targp->dev) {
 		d = (xfs_daddr_t) XFS_FSB_TO_BB(mp, mp->m_sb.sb_logblocks);
 		if ( (XFS_BB_TO_FSB(mp, d) != mp->m_sb.sb_logblocks) ||
-		     (!(bp = libxfs_readbuf(mp->m_logdev_targp,
+		     (!(bp = libxfs_buf_read(mp->m_logdev_targp,
 					d - XFS_FSB_TO_BB(mp, 1),
 					XFS_FSB_TO_BB(mp, 1), 0, NULL)))) {
 			fprintf(stderr, _("%s: log size checks failed\n"),
@@ -770,7 +770,7 @@ libxfs_mount(
 	 * read the first one and let the user know to check the geometry.
 	 */
 	if (sbp->sb_agcount > 1000000) {
-		bp = libxfs_readbuf(mp->m_dev,
+		bp = libxfs_buf_read(mp->m_dev,
 				XFS_AG_DADDR(mp, sbp->sb_agcount - 1, 0), 1,
 				0, NULL);
 		if (bp->b_error) {
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 6d86774f..57cf5f83 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -45,6 +45,7 @@
 #define xfs_btree_init_block		libxfs_btree_init_block
 #define xfs_buf_delwri_submit		libxfs_buf_delwri_submit
 #define xfs_buf_get			libxfs_buf_get
+#define xfs_buf_read			libxfs_buf_read
 #define xfs_buf_relse			libxfs_buf_relse
 #define xfs_bunmapi			libxfs_bunmapi
 #define xfs_calc_dquots_per_chunk	libxfs_calc_dquots_per_chunk
diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 50b7cef8..1b8318af 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -130,7 +130,7 @@ extern struct cache_operations	libxfs_bcache_operations;
 
 #ifdef XFS_BUF_TRACING
 
-#define libxfs_readbuf(dev, daddr, len, flags, ops) \
+#define libxfs_buf_read(dev, daddr, len, flags, ops) \
 	libxfs_trace_readbuf(__FUNCTION__, __FILE__, __LINE__, \
 			    (dev), (daddr), (len), (flags), (ops))
 #define libxfs_readbuf_map(dev, map, nmaps, flags, ops) \
@@ -151,9 +151,9 @@ extern struct cache_operations	libxfs_bcache_operations;
 #define libxfs_buf_relse(buf) \
 	libxfs_trace_putbuf(__FUNCTION__, __FILE__, __LINE__, (buf))
 
-extern xfs_buf_t *libxfs_trace_readbuf(const char *, const char *, int,
-			struct xfs_buftarg *, xfs_daddr_t, int, int,
-			const struct xfs_buf_ops *);
+struct xfs_buf *libxfs_trace_readbuf(const char *func, const char *file,
+			int line, struct xfs_buftarg *btp, xfs_daddr_t daddr,
+			size_t len, int flags, const struct xfs_buf_ops *ops);
 extern xfs_buf_t *libxfs_trace_readbuf_map(const char *, const char *, int,
 			struct xfs_buftarg *, struct xfs_buf_map *, int, int,
 			const struct xfs_buf_ops *);
@@ -171,8 +171,6 @@ extern void	libxfs_trace_putbuf (const char *, const char *, int,
 
 #else
 
-extern xfs_buf_t *libxfs_readbuf(struct xfs_buftarg *, xfs_daddr_t, int, int,
-			const struct xfs_buf_ops *);
 extern xfs_buf_t *libxfs_readbuf_map(struct xfs_buftarg *, struct xfs_buf_map *,
 			int, int, const struct xfs_buf_ops *);
 extern int	libxfs_writebuf(xfs_buf_t *, int);
@@ -193,11 +191,24 @@ libxfs_buf_get(
 	return libxfs_getbuf_map(target, &map, 1, 0);
 }
 
+static inline struct xfs_buf*
+libxfs_buf_read(
+	struct xfs_buftarg	*target,
+	xfs_daddr_t		blkno,
+	size_t			numblks,
+	xfs_buf_flags_t		flags,
+	const struct xfs_buf_ops *ops)
+{
+	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
+
+	return libxfs_readbuf_map(target, &map, 1, flags, ops);
+}
+
 #endif /* XFS_BUF_TRACING */
 
 extern void	libxfs_readbuf_verify(struct xfs_buf *bp,
 			const struct xfs_buf_ops *ops);
-extern xfs_buf_t *libxfs_getsb(struct xfs_mount *);
+struct xfs_buf *libxfs_getsb(struct xfs_mount *mp);
 extern void	libxfs_bcache_purge(void);
 extern void	libxfs_bcache_free(void);
 extern void	libxfs_bcache_flush(void);
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 99b48db2..fbd6f322 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -44,7 +44,7 @@
  *
  * IOWs, userspace is behaving quite differently to the kernel and as a result
  * it leaks errors from reads, invalidations and writes through
- * libxfs_buf_get/libxfs_readbuf.
+ * libxfs_buf_get/libxfs_buf_read.
  *
  * The result of this is that until the userspace code outside libxfs is cleaned
  * up, functions that release buffers from userspace control (i.e
@@ -381,14 +381,11 @@ libxfs_log_header(
 
 #ifdef XFS_BUF_TRACING
 
-#undef libxfs_readbuf
 #undef libxfs_readbuf_map
 #undef libxfs_writebuf
 #undef libxfs_getbuf_map
 #undef libxfs_getbuf_flags
 
-xfs_buf_t	*libxfs_readbuf(struct xfs_buftarg *, xfs_daddr_t, int, int,
-				const struct xfs_buf_ops *);
 xfs_buf_t	*libxfs_readbuf_map(struct xfs_buftarg *, struct xfs_buf_map *,
 				int, int, const struct xfs_buf_ops *);
 int		libxfs_writebuf(xfs_buf_t *, int);
@@ -409,22 +406,21 @@ do {						\
 	}					\
 } while (0)
 
-xfs_buf_t *
-libxfs_trace_readbuf(const char *func, const char *file, int line,
-		struct xfs_buftarg *btp, xfs_daddr_t blkno, int len, int flags,
-		const struct xfs_buf_ops *ops)
+struct xfs_buf *
+libxfs_trace_readbuf(
+	const char		*func,
+	const char		*file,
+	int			line,
+	struct xfs_buftarg	*btp,
+	xfs_daddr_t		blkno,
+	size_t			len,
+	int			flags,
+	const struct xfs_buf_ops *ops)
 {
-	xfs_buf_t	*bp = libxfs_readbuf(btp, blkno, len, flags, ops);
-	__add_trace(bp, func, file, line);
-	return bp;
-}
+	struct xfs_buf		*bp;
+	DEFINE_SINGLE_BUF_MAP(map, blkno, numblks);
 
-xfs_buf_t *
-libxfs_trace_readbuf_map(const char *func, const char *file, int line,
-		struct xfs_buftarg *btp, struct xfs_buf_map *map, int nmaps, int flags,
-		const struct xfs_buf_ops *ops)
-{
-	xfs_buf_t	*bp = libxfs_readbuf_map(btp, map, nmaps, flags, ops);
+	bp = libxfs_readbuf_map(btp, &map, 1, flags, ops);
 	__add_trace(bp, func, file, line);
 	return bp;
 }
@@ -483,11 +479,12 @@ libxfs_trace_putbuf(const char *func, const char *file, int line, xfs_buf_t *bp)
 #endif
 
 
-xfs_buf_t *
-libxfs_getsb(xfs_mount_t *mp)
+struct xfs_buf *
+libxfs_getsb(
+	struct xfs_mount	*mp)
 {
-	return libxfs_readbuf(mp->m_ddev_targp, XFS_SB_DADDR,
-				XFS_FSS_TO_BB(mp, 1), 0, &xfs_sb_buf_ops);
+	return libxfs_buf_read(mp->m_ddev_targp, XFS_SB_DADDR,
+			XFS_FSS_TO_BB(mp, 1), 0, &xfs_sb_buf_ops);
 }
 
 kmem_zone_t			*xfs_buf_zone;
@@ -952,13 +949,16 @@ libxfs_readbuf_verify(struct xfs_buf *bp, const struct xfs_buf_ops *ops)
 	bp->b_flags &= ~LIBXFS_B_UNCHECKED;
 }
 
-
-xfs_buf_t *
-libxfs_readbuf(struct xfs_buftarg *btp, xfs_daddr_t blkno, int len, int flags,
-		const struct xfs_buf_ops *ops)
+static struct xfs_buf *
+libxfs_readbuf(
+	struct xfs_buftarg	*btp,
+	xfs_daddr_t		blkno,
+	size_t			len,
+	int			flags,
+	const struct xfs_buf_ops *ops)
 {
-	xfs_buf_t	*bp;
-	int		error;
+	struct xfs_buf		*bp;
+	int			error;
 
 	bp = libxfs_getbuf_flags(btp, blkno, len, 0);
 	if (!bp)
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 4e757ee1..3827b410 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3574,7 +3574,7 @@ rewrite_secondary_superblocks(
 	struct xfs_buf		*buf;
 
 	/* rewrite the last superblock */
-	buf = libxfs_readbuf(mp->m_dev,
+	buf = libxfs_buf_read(mp->m_dev,
 			XFS_AGB_TO_DADDR(mp, mp->m_sb.sb_agcount - 1,
 				XFS_SB_DADDR),
 			XFS_FSS_TO_BB(mp, 1), 0, &xfs_sb_buf_ops);
@@ -3590,7 +3590,7 @@ rewrite_secondary_superblocks(
 	if (mp->m_sb.sb_agcount <= 2)
 		return;
 
-	buf = libxfs_readbuf(mp->m_dev,
+	buf = libxfs_buf_read(mp->m_dev,
 			XFS_AGB_TO_DADDR(mp, (mp->m_sb.sb_agcount - 1) / 2,
 				XFS_SB_DADDR),
 			XFS_FSS_TO_BB(mp, 1), 0, &xfs_sb_buf_ops);
diff --git a/repair/attr_repair.c b/repair/attr_repair.c
index ec068ba2..cc20b1a1 100644
--- a/repair/attr_repair.c
+++ b/repair/attr_repair.c
@@ -405,7 +405,7 @@ rmtval_get(xfs_mount_t *mp, xfs_ino_t ino, blkmap_t *blkmap,
 			clearit = 1;
 			break;
 		}
-		bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, bno),
+		bp = libxfs_buf_read(mp->m_dev, XFS_FSB_TO_DADDR(mp, bno),
 				    XFS_FSB_TO_BB(mp, 1), 0,
 				    &xfs_attr3_rmt_buf_ops);
 		if (!bp) {
@@ -763,7 +763,7 @@ process_leaf_attr_level(xfs_mount_t	*mp,
 			goto error_out;
 		}
 
-		bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, dev_bno),
+		bp = libxfs_buf_read(mp->m_dev, XFS_FSB_TO_DADDR(mp, dev_bno),
 				    XFS_FSB_TO_BB(mp, 1), 0,
 				    &xfs_attr3_leaf_buf_ops);
 		if (!bp) {
@@ -1093,7 +1093,7 @@ process_longform_attr(
 		return 1;
 	}
 
-	bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, bno),
+	bp = libxfs_buf_read(mp->m_dev, XFS_FSB_TO_DADDR(mp, bno),
 				XFS_FSB_TO_BB(mp, 1), 0, &xfs_da3_node_buf_ops);
 	if (!bp) {
 		do_warn(
diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c
index 863c4531..76e9f773 100644
--- a/repair/dino_chunks.c
+++ b/repair/dino_chunks.c
@@ -39,7 +39,7 @@ check_aginode_block(xfs_mount_t	*mp,
 	 * tree and we wouldn't be here and we stale the buffers out
 	 * so no one else will overlap them.
 	 */
-	bp = libxfs_readbuf(mp->m_dev, XFS_AGB_TO_DADDR(mp, agno, agbno),
+	bp = libxfs_buf_read(mp->m_dev, XFS_AGB_TO_DADDR(mp, agno, agbno),
 			XFS_FSB_TO_BB(mp, 1), 0, NULL);
 	if (!bp) {
 		do_warn(_("cannot read agbno (%u/%u), disk block %" PRId64 "\n"),
@@ -656,7 +656,7 @@ process_inode_chunk(
 		pftrace("about to read off %llu in AG %d",
 			XFS_AGB_TO_DADDR(mp, agno, agbno), agno);
 
-		bplist[bp_index] = libxfs_readbuf(mp->m_dev,
+		bplist[bp_index] = libxfs_buf_read(mp->m_dev,
 					XFS_AGB_TO_DADDR(mp, agno, agbno),
 					XFS_FSB_TO_BB(mp,
 						M_IGEO(mp)->blocks_per_cluster),
diff --git a/repair/dinode.c b/repair/dinode.c
index 928698cb..848eac09 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -748,7 +748,7 @@ get_agino_buf(
 		cluster_agino, cluster_daddr, cluster_blks);
 #endif
 
-	bp = libxfs_readbuf(mp->m_dev, cluster_daddr, cluster_blks,
+	bp = libxfs_buf_read(mp->m_dev, cluster_daddr, cluster_blks,
 			0, &xfs_inode_buf_ops);
 	if (!bp) {
 		do_warn(_("cannot read inode (%u/%u), disk block %" PRIu64 "\n"),
@@ -1179,7 +1179,7 @@ process_quota_inode(
 		fsbno = blkmap_get(blkmap, qbno);
 		dqid = (xfs_dqid_t)qbno * dqperchunk;
 
-		bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, fsbno),
+		bp = libxfs_buf_read(mp->m_dev, XFS_FSB_TO_DADDR(mp, fsbno),
 				    dqchunklen, 0, &xfs_dquot_buf_ops);
 		if (!bp) {
 			do_warn(
@@ -1284,7 +1284,7 @@ _("cannot read inode %" PRIu64 ", file block %d, NULL disk block\n"),
 
 		byte_cnt = XFS_FSB_TO_B(mp, blk_cnt);
 
-		bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, fsbno),
+		bp = libxfs_buf_read(mp->m_dev, XFS_FSB_TO_DADDR(mp, fsbno),
 				    BTOBB(byte_cnt), 0, &xfs_symlink_buf_ops);
 		if (!bp) {
 			do_warn(
diff --git a/repair/phase3.c b/repair/phase3.c
index 1c6929ac..886acd1f 100644
--- a/repair/phase3.c
+++ b/repair/phase3.c
@@ -28,7 +28,7 @@ process_agi_unlinked(
 	xfs_agnumber_t		i;
 	int			agi_dirty = 0;
 
-	bp = libxfs_readbuf(mp->m_dev,
+	bp = libxfs_buf_read(mp->m_dev,
 			XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
 			mp->m_sb.sb_sectsize/BBSIZE, 0, &xfs_agi_buf_ops);
 	if (!bp)
diff --git a/repair/prefetch.c b/repair/prefetch.c
index f7ea9c8f..12272932 100644
--- a/repair/prefetch.c
+++ b/repair/prefetch.c
@@ -271,7 +271,7 @@ pf_scan_lbtree(
 	xfs_buf_t		*bp;
 	int			rc;
 
-	bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, dbno),
+	bp = libxfs_buf_read(mp->m_dev, XFS_FSB_TO_DADDR(mp, dbno),
 			XFS_FSB_TO_BB(mp, 1), 0, &xfs_bmbt_buf_ops);
 	if (!bp)
 		return 0;
diff --git a/repair/rt.c b/repair/rt.c
index 3319829c..b514998d 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -193,7 +193,7 @@ process_rtbitmap(xfs_mount_t	*mp,
 			error = 1;
 			continue;
 		}
-		bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, bno),
+		bp = libxfs_buf_read(mp->m_dev, XFS_FSB_TO_DADDR(mp, bno),
 				XFS_FSB_TO_BB(mp, 1), NULL);
 		if (!bp) {
 			do_warn(_("can't read block %d for rtbitmap inode\n"),
@@ -255,7 +255,7 @@ process_rtsummary(xfs_mount_t	*mp,
 			error++;
 			continue;
 		}
-		bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, bno),
+		bp = libxfs_buf_read(mp->m_dev, XFS_FSB_TO_DADDR(mp, bno),
 				XFS_FSB_TO_BB(mp, 1), NULL);
 		if (!bp) {
 			do_warn(_("can't read block %d for rtsummary inode\n"),
diff --git a/repair/scan.c b/repair/scan.c
index c961e843..f4e4fef5 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -68,7 +68,7 @@ scan_sbtree(
 {
 	xfs_buf_t	*bp;
 
-	bp = libxfs_readbuf(mp->m_dev, XFS_AGB_TO_DADDR(mp, agno, root),
+	bp = libxfs_buf_read(mp->m_dev, XFS_AGB_TO_DADDR(mp, agno, root),
 			XFS_FSB_TO_BB(mp, 1), 0, ops);
 	if (!bp) {
 		do_error(_("can't read btree block %d/%d\n"), agno, root);
@@ -123,7 +123,7 @@ scan_lbtree(
 	int		dirty = 0;
 	bool		badcrc = false;
 
-	bp = libxfs_readbuf(mp->m_dev, XFS_FSB_TO_DADDR(mp, root),
+	bp = libxfs_buf_read(mp->m_dev, XFS_FSB_TO_DADDR(mp, root),
 		      XFS_FSB_TO_BB(mp, 1), 0, ops);
 	if (!bp)  {
 		do_error(_("can't read btree block %d/%d\n"),
@@ -2111,7 +2111,7 @@ scan_freelist(
 	if (be32_to_cpu(agf->agf_flcount) == 0)
 		return;
 
-	agflbuf = libxfs_readbuf(mp->m_dev,
+	agflbuf = libxfs_buf_read(mp->m_dev,
 				 XFS_AG_DADDR(mp, agno, XFS_AGFL_DADDR(mp)),
 				 XFS_FSS_TO_BB(mp, 1), 0, &xfs_agfl_buf_ops);
 	if (!agflbuf)  {
@@ -2335,7 +2335,7 @@ scan_ag(
 		return;
 	}
 
-	sbbuf = libxfs_readbuf(mp->m_dev, XFS_AG_DADDR(mp, agno, XFS_SB_DADDR),
+	sbbuf = libxfs_buf_read(mp->m_dev, XFS_AG_DADDR(mp, agno, XFS_SB_DADDR),
 				XFS_FSS_TO_BB(mp, 1), 0, &xfs_sb_buf_ops);
 	if (!sbbuf)  {
 		objname = _("root superblock");
@@ -2343,7 +2343,7 @@ scan_ag(
 	}
 	libxfs_sb_from_disk(sb, XFS_BUF_TO_SBP(sbbuf));
 
-	agfbuf = libxfs_readbuf(mp->m_dev,
+	agfbuf = libxfs_buf_read(mp->m_dev,
 			XFS_AG_DADDR(mp, agno, XFS_AGF_DADDR(mp)),
 			XFS_FSS_TO_BB(mp, 1), 0, &xfs_agf_buf_ops);
 	if (!agfbuf)  {
@@ -2352,7 +2352,7 @@ scan_ag(
 	}
 	agf = XFS_BUF_TO_AGF(agfbuf);
 
-	agibuf = libxfs_readbuf(mp->m_dev,
+	agibuf = libxfs_buf_read(mp->m_dev,
 			XFS_AG_DADDR(mp, agno, XFS_AGI_DADDR(mp)),
 			XFS_FSS_TO_BB(mp, 1), 0, &xfs_agi_buf_ops);
 	if (!agibuf)  {

