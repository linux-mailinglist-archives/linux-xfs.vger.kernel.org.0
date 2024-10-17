Return-Path: <linux-xfs+bounces-14412-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 133589A2D38
	for <lists+linux-xfs@lfdr.de>; Thu, 17 Oct 2024 21:05:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C617D285C33
	for <lists+linux-xfs@lfdr.de>; Thu, 17 Oct 2024 19:05:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31F8821BB0B;
	Thu, 17 Oct 2024 19:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LeWHSvXn"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E537B219CA6
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 19:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191948; cv=none; b=r8+rdGdZ+tZkadSdzRSmHpRNVYMEqpYOiWQ3dbwXi7OTJrVTbawt7K+YLQ93Xv548FZQP/0++hROA/YaAwhrbGn2kk+fkWjseUYRQm42yN/MKUiEEG9cERoQ1N0LWB+OmGpa49ME1OXYDCCwcUlO6/yQrdY8vqoQ0sgPtatY6EQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191948; c=relaxed/simple;
	bh=veTTCUYBKo7jq1CcLimn3qO0UjOeP5Ic9q6wheARyws=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J3xusRrLiz4EdeanlO/JTL6FiDH8YHZgRKCwQP4LE/wnYLr4jRmayZ+JvU171ZAhWp5eTBLmSE/+kFc3j1I5kLvEQplpJIMFXT6S9Oxrc9Pbk5oDWDThyOqFkLY2Eyw21zkmfgIlVLWYjAB6ImjXH15kcRWLRS9v2sJ84DGL+rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LeWHSvXn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F424C4CEC3;
	Thu, 17 Oct 2024 19:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191947;
	bh=veTTCUYBKo7jq1CcLimn3qO0UjOeP5Ic9q6wheARyws=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LeWHSvXn6veGT7FH8lHKZE1VgxGVXOURrqF+12a6diXPY9L1R5VzYk/ZLPA6Wv8mY
	 ZiovgO7Q+OEJOGDNKWtGGScOVjQJbwWiHMN3tfNj2sMY3xuLkqipGaBI5Jeu83zzrA
	 zKuMuWZsNvg8+pJHUe0AlJrlNSeBaX8U9ym95TSDM1i6BAquk31IO5DlgIqY7OcvSN
	 VIeH/rNJNIpryl8LxQLNN5CYzFZvHLsTOZ7it+bxgGmtd33m3EnMv8ySjULCLVma9+
	 BMd0RYTr7i84WiYLZDFFl1ptJCkv0LM58WxH/UvFw5FY88y1rIr1UBWUlAtqHhEOzu
	 zTM2JqWm4qO9g==
Date: Thu, 17 Oct 2024 12:05:47 -0700
Subject: [PATCH 11/34] xfs: add block headers to realtime bitmap and summary
 blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919071856.3453179.15686688404316046753.stgit@frogsfrogsfrogs>
In-Reply-To: <172919071571.3453179.15753475627202483418.stgit@frogsfrogsfrogs>
References: <172919071571.3453179.15753475627202483418.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Upgrade rtbitmap and rtsummary blocks to have self describing metadata
like most every other thing in XFS.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_format.h      |   18 +++++
 fs/xfs/libxfs/xfs_ondisk.h      |    1 
 fs/xfs/libxfs/xfs_rtbitmap.c    |  146 +++++++++++++++++++++++++++++++++++----
 fs/xfs/libxfs/xfs_rtbitmap.h    |   50 +++++++++++++
 fs/xfs/libxfs/xfs_sb.c          |   21 +++++-
 fs/xfs/libxfs/xfs_shared.h      |    2 +
 fs/xfs/scrub/rtsummary_repair.c |   15 +++-
 fs/xfs/xfs_buf_item_recover.c   |   25 ++++++-
 fs/xfs/xfs_discard.c            |    2 -
 fs/xfs/xfs_mount.h              |    3 +
 fs/xfs/xfs_rtalloc.c            |    2 -
 11 files changed, 257 insertions(+), 28 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 3cf044a2d5f2a9..016ee4ff537440 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -1278,6 +1278,24 @@ static inline bool xfs_dinode_is_metadir(const struct xfs_dinode *dip)
 #define	XFS_DFL_RTEXTSIZE	(64 * 1024)	        /* 64kB */
 #define	XFS_MIN_RTEXTSIZE	(4 * 1024)		/* 4kB */
 
+/*
+ * RT bit manipulation macros.
+ */
+#define XFS_RTBITMAP_MAGIC	0x424D505A	/* BMPZ */
+#define XFS_RTSUMMARY_MAGIC	0x53554D59	/* SUMY */
+
+struct xfs_rtbuf_blkinfo {
+	__be32		rt_magic;	/* validity check on block */
+	__be32		rt_crc;		/* CRC of block */
+	__be64		rt_owner;	/* inode that owns the block */
+	__be64		rt_blkno;	/* first block of the buffer */
+	__be64		rt_lsn;		/* sequence number of last write */
+	uuid_t		rt_uuid;	/* filesystem we belong to */
+};
+
+#define XFS_RTBUF_CRC_OFF \
+	offsetof(struct xfs_rtbuf_blkinfo, rt_crc)
+
 /*
  * Dquot and dquot block format definitions
  */
diff --git a/fs/xfs/libxfs/xfs_ondisk.h b/fs/xfs/libxfs/xfs_ondisk.h
index 38b314113d8f24..6a2bcbc392842c 100644
--- a/fs/xfs/libxfs/xfs_ondisk.h
+++ b/fs/xfs/libxfs/xfs_ondisk.h
@@ -76,6 +76,7 @@ xfs_check_ondisk_structs(void)
 	/* realtime structures */
 	XFS_CHECK_STRUCT_SIZE(union xfs_rtword_raw,		4);
 	XFS_CHECK_STRUCT_SIZE(union xfs_suminfo_raw,		4);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_rtbuf_blkinfo,		48);
 
 	/*
 	 * m68k has problems with xfs_attr_leaf_name_remote_t, but we pad it to
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index e201064764d489..cae0b22397d007 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -21,28 +21,84 @@
 #include "xfs_rtbitmap.h"
 #include "xfs_health.h"
 #include "xfs_sb.h"
+#include "xfs_log.h"
+#include "xfs_buf_item.h"
 
 /*
  * Realtime allocator bitmap functions shared with userspace.
  */
 
-/*
- * Real time buffers need verifiers to avoid runtime warnings during IO.
- * We don't have anything to verify, however, so these are just dummy
- * operations.
- */
+static xfs_failaddr_t
+xfs_rtbuf_verify(
+	struct xfs_buf			*bp)
+{
+	struct xfs_mount		*mp = bp->b_mount;
+	struct xfs_rtbuf_blkinfo	*hdr = bp->b_addr;
+
+	if (!xfs_verify_magic(bp, hdr->rt_magic))
+		return __this_address;
+	if (!xfs_has_rtgroups(mp))
+		return __this_address;
+	if (!xfs_has_crc(mp))
+		return __this_address;
+	if (!uuid_equal(&hdr->rt_uuid, &mp->m_sb.sb_meta_uuid))
+		return __this_address;
+	if (hdr->rt_blkno != cpu_to_be64(xfs_buf_daddr(bp)))
+		return __this_address;
+	return NULL;
+}
+
 static void
 xfs_rtbuf_verify_read(
-	struct xfs_buf	*bp)
+	struct xfs_buf			*bp)
 {
+	struct xfs_mount		*mp = bp->b_mount;
+	struct xfs_rtbuf_blkinfo	*hdr = bp->b_addr;
+	xfs_failaddr_t			fa;
+
+	if (!xfs_has_rtgroups(mp))
+		return;
+
+	if (!xfs_log_check_lsn(mp, be64_to_cpu(hdr->rt_lsn))) {
+		fa = __this_address;
+		goto fail;
+	}
+
+	if (!xfs_buf_verify_cksum(bp, XFS_RTBUF_CRC_OFF)) {
+		fa = __this_address;
+		goto fail;
+	}
+
+	fa = xfs_rtbuf_verify(bp);
+	if (fa)
+		goto fail;
+
 	return;
+fail:
+	xfs_verifier_error(bp, -EFSCORRUPTED, fa);
 }
 
 static void
 xfs_rtbuf_verify_write(
 	struct xfs_buf	*bp)
 {
-	return;
+	struct xfs_mount		*mp = bp->b_mount;
+	struct xfs_rtbuf_blkinfo	*hdr = bp->b_addr;
+	struct xfs_buf_log_item		*bip = bp->b_log_item;
+	xfs_failaddr_t			fa;
+
+	if (!xfs_has_rtgroups(mp))
+		return;
+
+	fa = xfs_rtbuf_verify(bp);
+	if (fa) {
+		xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+		return;
+	}
+
+	if (bip)
+		hdr->rt_lsn = cpu_to_be64(bip->bli_item.li_lsn);
+	xfs_buf_update_cksum(bp, XFS_RTBUF_CRC_OFF);
 }
 
 const struct xfs_buf_ops xfs_rtbuf_ops = {
@@ -51,6 +107,22 @@ const struct xfs_buf_ops xfs_rtbuf_ops = {
 	.verify_write = xfs_rtbuf_verify_write,
 };
 
+const struct xfs_buf_ops xfs_rtbitmap_buf_ops = {
+	.name		= "xfs_rtbitmap",
+	.magic		= { 0, cpu_to_be32(XFS_RTBITMAP_MAGIC) },
+	.verify_read	= xfs_rtbuf_verify_read,
+	.verify_write	= xfs_rtbuf_verify_write,
+	.verify_struct	= xfs_rtbuf_verify,
+};
+
+const struct xfs_buf_ops xfs_rtsummary_buf_ops = {
+	.name		= "xfs_rtsummary",
+	.magic		= { 0, cpu_to_be32(XFS_RTSUMMARY_MAGIC) },
+	.verify_read	= xfs_rtbuf_verify_read,
+	.verify_write	= xfs_rtbuf_verify_write,
+	.verify_struct	= xfs_rtbuf_verify,
+};
+
 /* Release cached rt bitmap and summary buffers. */
 void
 xfs_rtbuf_cache_relse(
@@ -130,12 +202,24 @@ xfs_rtbuf_get(
 	ASSERT(map.br_startblock != NULLFSBLOCK);
 	error = xfs_trans_read_buf(mp, args->tp, mp->m_ddev_targp,
 				   XFS_FSB_TO_DADDR(mp, map.br_startblock),
-				   mp->m_bsize, 0, &bp, &xfs_rtbuf_ops);
+				   mp->m_bsize, 0, &bp,
+				   xfs_rtblock_ops(mp, type));
 	if (xfs_metadata_is_sick(error))
 		xfs_rtginode_mark_sick(args->rtg, type);
 	if (error)
 		return error;
 
+	if (xfs_has_rtgroups(mp)) {
+		struct xfs_rtbuf_blkinfo	*hdr = bp->b_addr;
+
+		if (hdr->rt_owner != cpu_to_be64(ip->i_ino)) {
+			xfs_buf_mark_corrupt(bp);
+			xfs_trans_brelse(args->tp, bp);
+			xfs_rtginode_mark_sick(args->rtg, type);
+			return -EFSCORRUPTED;
+		}
+	}
+
 	xfs_trans_buf_set_type(args->tp, bp, buf_type);
 	*cbpp = bp;
 	*coffp = block;
@@ -1146,6 +1230,19 @@ xfs_rtalloc_extent_is_free(
 	return 0;
 }
 
+/* Compute the number of rt extents tracked by a single bitmap block. */
+xfs_rtxnum_t
+xfs_rtbitmap_rtx_per_rbmblock(
+	struct xfs_mount	*mp)
+{
+	unsigned int		rbmblock_bytes = mp->m_sb.sb_blocksize;
+
+	if (xfs_has_rtgroups(mp))
+		rbmblock_bytes -= sizeof(struct xfs_rtbuf_blkinfo);
+
+	return rbmblock_bytes * NBBY;
+}
+
 /*
  * Compute the number of rtbitmap blocks needed to track the given number of rt
  * extents.
@@ -1155,7 +1252,7 @@ xfs_rtbitmap_blockcount_len(
 	struct xfs_mount	*mp,
 	xfs_rtbxlen_t		rtextents)
 {
-	return howmany_64(rtextents, NBBY * mp->m_sb.sb_blocksize);
+	return howmany_64(rtextents, xfs_rtbitmap_rtx_per_rbmblock(mp));
 }
 
 /* How many rt extents does each rtbitmap file track? */
@@ -1192,11 +1289,12 @@ xfs_rtsummary_blockcount(
 	struct xfs_mount	*mp,
 	unsigned int		*rsumlevels)
 {
+	xfs_rtbxlen_t		rextents = xfs_rtbitmap_bitcount(mp);
 	unsigned long long	rsumwords;
 
-	*rsumlevels = xfs_compute_rextslog(xfs_rtbitmap_bitcount(mp)) + 1;
-	rsumwords = xfs_rtbitmap_blockcount(mp) * (*rsumlevels);
-	return XFS_B_TO_FSB(mp, rsumwords << XFS_WORDLOG);
+	*rsumlevels = xfs_compute_rextslog(rextents) + 1;
+	rsumwords = xfs_rtbitmap_blockcount_len(mp, rextents) * (*rsumlevels);
+	return howmany_64(rsumwords, mp->m_blockwsize);
 }
 
 static int
@@ -1248,6 +1346,7 @@ xfs_rtfile_initialize_block(
 	struct xfs_inode	*ip = rtg->rtg_inodes[type];
 	struct xfs_trans	*tp;
 	struct xfs_buf		*bp;
+	void			*bufdata;
 	const size_t		copylen = mp->m_blockwsize << XFS_WORDLOG;
 	enum xfs_blft		buf_type;
 	int			error;
@@ -1271,13 +1370,30 @@ xfs_rtfile_initialize_block(
 		xfs_trans_cancel(tp);
 		return error;
 	}
+	bufdata = bp->b_addr;
 
 	xfs_trans_buf_set_type(tp, bp, buf_type);
-	bp->b_ops = &xfs_rtbuf_ops;
+	bp->b_ops = xfs_rtblock_ops(mp, type);
+
+	if (xfs_has_rtgroups(mp)) {
+		struct xfs_rtbuf_blkinfo	*hdr = bp->b_addr;
+
+		if (type == XFS_RTGI_BITMAP)
+			hdr->rt_magic = cpu_to_be32(XFS_RTBITMAP_MAGIC);
+		else
+			hdr->rt_magic = cpu_to_be32(XFS_RTSUMMARY_MAGIC);
+		hdr->rt_owner = cpu_to_be64(ip->i_ino);
+		hdr->rt_blkno = cpu_to_be64(XFS_FSB_TO_DADDR(mp, fsbno));
+		hdr->rt_lsn = 0;
+		uuid_copy(&hdr->rt_uuid, &mp->m_sb.sb_meta_uuid);
+
+		bufdata += sizeof(*hdr);
+	}
+
 	if (data)
-		memcpy(bp->b_addr, data, copylen);
+		memcpy(bufdata, data, copylen);
 	else
-		memset(bp->b_addr, 0, copylen);
+		memset(bufdata, 0, copylen);
 	xfs_trans_log_buf(tp, bp, 0, mp->m_sb.sb_blocksize - 1);
 	return xfs_trans_commit(tp);
 }
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index b2b9e59a87a278..2286a98ecb32bb 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -150,6 +150,9 @@ xfs_rtx_to_rbmblock(
 	struct xfs_mount	*mp,
 	xfs_rtxnum_t		rtx)
 {
+	if (xfs_has_rtgroups(mp))
+		return div_u64(rtx, mp->m_rtx_per_rbmblock);
+
 	return rtx >> mp->m_blkbit_log;
 }
 
@@ -159,6 +162,13 @@ xfs_rtx_to_rbmword(
 	struct xfs_mount	*mp,
 	xfs_rtxnum_t		rtx)
 {
+	if (xfs_has_rtgroups(mp)) {
+		unsigned int	mod;
+
+		div_u64_rem(rtx >> XFS_NBWORDLOG, mp->m_blockwsize, &mod);
+		return mod;
+	}
+
 	return (rtx >> XFS_NBWORDLOG) & (mp->m_blockwsize - 1);
 }
 
@@ -168,6 +178,9 @@ xfs_rbmblock_to_rtx(
 	struct xfs_mount	*mp,
 	xfs_fileoff_t		rbmoff)
 {
+	if (xfs_has_rtgroups(mp))
+		return rbmoff * mp->m_rtx_per_rbmblock;
+
 	return rbmoff << mp->m_blkbit_log;
 }
 
@@ -177,7 +190,14 @@ xfs_rbmblock_wordptr(
 	struct xfs_rtalloc_args	*args,
 	unsigned int		index)
 {
-	union xfs_rtword_raw	*words = args->rbmbp->b_addr;
+	struct xfs_mount	*mp = args->mp;
+	union xfs_rtword_raw	*words;
+	struct xfs_rtbuf_blkinfo *hdr = args->rbmbp->b_addr;
+
+	if (xfs_has_rtgroups(mp))
+		words = (union xfs_rtword_raw *)(hdr + 1);
+	else
+		words = args->rbmbp->b_addr;
 
 	return words + index;
 }
@@ -227,6 +247,9 @@ xfs_rtsumoffs_to_block(
 	struct xfs_mount	*mp,
 	xfs_rtsumoff_t		rsumoff)
 {
+	if (xfs_has_rtgroups(mp))
+		return rsumoff / mp->m_blockwsize;
+
 	return XFS_B_TO_FSBT(mp, rsumoff * sizeof(xfs_suminfo_t));
 }
 
@@ -241,6 +264,9 @@ xfs_rtsumoffs_to_infoword(
 {
 	unsigned int		mask = mp->m_blockmask >> XFS_SUMINFOLOG;
 
+	if (xfs_has_rtgroups(mp))
+		return rsumoff % mp->m_blockwsize;
+
 	return rsumoff & mask;
 }
 
@@ -250,7 +276,13 @@ xfs_rsumblock_infoptr(
 	struct xfs_rtalloc_args	*args,
 	unsigned int		index)
 {
-	union xfs_suminfo_raw	*info = args->sumbp->b_addr;
+	union xfs_suminfo_raw	*info;
+	struct xfs_rtbuf_blkinfo *hdr = args->sumbp->b_addr;
+
+	if (xfs_has_rtgroups(args->mp))
+		info = (union xfs_suminfo_raw *)(hdr + 1);
+	else
+		info = args->sumbp->b_addr;
 
 	return info + index;
 }
@@ -279,6 +311,19 @@ xfs_suminfo_add(
 	return info->old;
 }
 
+static inline const struct xfs_buf_ops *
+xfs_rtblock_ops(
+	struct xfs_mount	*mp,
+	enum xfs_rtg_inodes	type)
+{
+	if (xfs_has_rtgroups(mp)) {
+		if (type == XFS_RTGI_SUMMARY)
+			return &xfs_rtsummary_buf_ops;
+		return &xfs_rtbitmap_buf_ops;
+	}
+	return &xfs_rtbuf_ops;
+}
+
 /*
  * Functions for walking free space rtextents in the realtime bitmap.
  */
@@ -324,6 +369,7 @@ int xfs_rtfree_extent(struct xfs_trans *tp, struct xfs_rtgroup *rtg,
 int xfs_rtfree_blocks(struct xfs_trans *tp, struct xfs_rtgroup *rtg,
 		xfs_fsblock_t rtbno, xfs_filblks_t rtlen);
 
+xfs_rtxnum_t xfs_rtbitmap_rtx_per_rbmblock(struct xfs_mount *mp);
 xfs_filblks_t xfs_rtbitmap_blockcount(struct xfs_mount *mp);
 xfs_filblks_t xfs_rtbitmap_blockcount_len(struct xfs_mount *mp,
 		xfs_rtbxlen_t rtextents);
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index d5bf886e18ab9e..c55ccecaccbda4 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -246,11 +246,26 @@ xfs_extents_per_rbm(
 	return sbp->sb_rextents;
 }
 
+/*
+ * Return the payload size of a single rt bitmap block (without the metadata
+ * header if any).
+ */
+static inline unsigned int
+xfs_rtbmblock_size(
+	struct xfs_sb		*sbp)
+{
+	if (xfs_sb_is_v5(sbp) &&
+	    (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR))
+		return sbp->sb_blocksize - sizeof(struct xfs_rtbuf_blkinfo);
+	return sbp->sb_blocksize;
+}
+
 static uint64_t
 xfs_expected_rbmblocks(
 	struct xfs_sb		*sbp)
 {
-	return howmany_64(xfs_extents_per_rbm(sbp), NBBY * sbp->sb_blocksize);
+	return howmany_64(xfs_extents_per_rbm(sbp),
+			  NBBY * xfs_rtbmblock_size(sbp));
 }
 
 /* Validate the realtime geometry */
@@ -1098,8 +1113,8 @@ xfs_sb_mount_common(
 	mp->m_sectbb_log = sbp->sb_sectlog - BBSHIFT;
 	mp->m_agno_log = xfs_highbit32(sbp->sb_agcount - 1) + 1;
 	mp->m_blockmask = sbp->sb_blocksize - 1;
-	mp->m_blockwsize = sbp->sb_blocksize >> XFS_WORDLOG;
-	mp->m_blockwmask = mp->m_blockwsize - 1;
+	mp->m_blockwsize = xfs_rtbmblock_size(sbp) >> XFS_WORDLOG;
+	mp->m_rtx_per_rbmblock = mp->m_blockwsize << XFS_NBWORDLOG;
 
 	ags->blocks = mp->m_sb.sb_agblocks;
 	ags->blklog = mp->m_sb.sb_agblklog;
diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index 552365d212ea26..9363f918675ac0 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -38,6 +38,8 @@ extern const struct xfs_buf_ops xfs_inode_buf_ops;
 extern const struct xfs_buf_ops xfs_inode_buf_ra_ops;
 extern const struct xfs_buf_ops xfs_refcountbt_buf_ops;
 extern const struct xfs_buf_ops xfs_rmapbt_buf_ops;
+extern const struct xfs_buf_ops xfs_rtbitmap_buf_ops;
+extern const struct xfs_buf_ops xfs_rtsummary_buf_ops;
 extern const struct xfs_buf_ops xfs_rtbuf_ops;
 extern const struct xfs_buf_ops xfs_rtsb_buf_ops;
 extern const struct xfs_buf_ops xfs_sb_buf_ops;
diff --git a/fs/xfs/scrub/rtsummary_repair.c b/fs/xfs/scrub/rtsummary_repair.c
index 1688380988007f..8198ea84ad70e5 100644
--- a/fs/xfs/scrub/rtsummary_repair.c
+++ b/fs/xfs/scrub/rtsummary_repair.c
@@ -83,12 +83,23 @@ xrep_rtsummary_prep_buf(
 	ondisk = xfs_rsumblock_infoptr(&rts->args, 0);
 	rts->args.sumbp = NULL;
 
-	bp->b_ops = &xfs_rtbuf_ops;
-
 	error = xfsum_copyout(sc, rts->prep_wordoff, ondisk, mp->m_blockwsize);
 	if (error)
 		return error;
 
+	if (xfs_has_rtgroups(sc->mp)) {
+		struct xfs_rtbuf_blkinfo	*hdr = bp->b_addr;
+
+		hdr->rt_magic = cpu_to_be32(XFS_RTSUMMARY_MAGIC);
+		hdr->rt_owner = cpu_to_be64(sc->ip->i_ino);
+		hdr->rt_blkno = cpu_to_be64(xfs_buf_daddr(bp));
+		hdr->rt_lsn = 0;
+		uuid_copy(&hdr->rt_uuid, &sc->mp->m_sb.sb_meta_uuid);
+		bp->b_ops = &xfs_rtsummary_buf_ops;
+	} else {
+		bp->b_ops = &xfs_rtbuf_ops;
+	}
+
 	rts->prep_wordoff += mp->m_blockwsize;
 	xfs_trans_buf_set_type(sc->tp, bp, XFS_BLFT_RTSUMMARY_BUF);
 	return 0;
diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index feb3db2e891614..3d0c6402cb3634 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -26,6 +26,7 @@
 #include "xfs_ag.h"
 #include "xfs_sb.h"
 #include "xfs_rtgroup.h"
+#include "xfs_rtbitmap.h"
 
 /*
  * This is the number of entries in the l_buf_cancel_table used during
@@ -394,9 +395,18 @@ xlog_recover_validate_buf_type(
 		break;
 #ifdef CONFIG_XFS_RT
 	case XFS_BLFT_RTBITMAP_BUF:
+		if (xfs_has_rtgroups(mp) && magic32 != XFS_RTBITMAP_MAGIC) {
+			warnmsg = "Bad rtbitmap magic!";
+			break;
+		}
+		bp->b_ops = xfs_rtblock_ops(mp, XFS_RTGI_BITMAP);
+		break;
 	case XFS_BLFT_RTSUMMARY_BUF:
-		/* no magic numbers for verification of RT buffers */
-		bp->b_ops = &xfs_rtbuf_ops;
+		if (xfs_has_rtgroups(mp) && magic32 != XFS_RTSUMMARY_MAGIC) {
+			warnmsg = "Bad rtsummary magic!";
+			break;
+		}
+		bp->b_ops = xfs_rtblock_ops(mp, XFS_RTGI_SUMMARY);
 		break;
 #endif /* CONFIG_XFS_RT */
 	default:
@@ -815,11 +825,20 @@ xlog_recover_get_buf_lsn(
 	 * UUIDs, so we must recover them immediately.
 	 */
 	blft = xfs_blft_from_flags(buf_f);
-	if (blft == XFS_BLFT_RTBITMAP_BUF || blft == XFS_BLFT_RTSUMMARY_BUF)
+	if (!xfs_has_rtgroups(mp) && (blft == XFS_BLFT_RTBITMAP_BUF ||
+				      blft == XFS_BLFT_RTSUMMARY_BUF))
 		goto recover_immediately;
 
 	magic32 = be32_to_cpu(*(__be32 *)blk);
 	switch (magic32) {
+	case XFS_RTSUMMARY_MAGIC:
+	case XFS_RTBITMAP_MAGIC: {
+		struct xfs_rtbuf_blkinfo	*hdr = blk;
+
+		lsn = be64_to_cpu(hdr->rt_lsn);
+		uuid = &hdr->rt_uuid;
+		break;
+	}
 	case XFS_ABTB_CRC_MAGIC:
 	case XFS_ABTC_CRC_MAGIC:
 	case XFS_ABTB_MAGIC:
diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index 42b8b5e0e931b7..e71bd64685f900 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -572,7 +572,7 @@ xfs_trim_rtextents(
 	 * trims the extents returned.
 	 */
 	do {
-		tr.stop_rtx = low + (mp->m_sb.sb_blocksize * NBBY);
+		tr.stop_rtx = low + xfs_rtbitmap_rtx_per_rbmblock(mp);
 		xfs_rtgroup_lock(rtg, XFS_RTGLOCK_BITMAP_SHARED);
 		error = xfs_rtalloc_query_range(rtg, tp, low, high,
 				xfs_trim_gather_rtextent, &tr);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 06d67089b91f33..e0902c08510d80 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -150,7 +150,8 @@ typedef struct xfs_mount {
 	int8_t			m_rgblklog;	/* log2 of rt group sz if possible */
 	uint			m_blockmask;	/* sb_blocksize-1 */
 	uint			m_blockwsize;	/* sb_blocksize in words */
-	uint			m_blockwmask;	/* blockwsize-1 */
+	/* number of rt extents per rt bitmap block if rtgroups enabled */
+	unsigned int		m_rtx_per_rbmblock;
 	uint			m_alloc_mxr[2];	/* max alloc btree records */
 	uint			m_alloc_mnr[2];	/* min alloc btree records */
 	uint			m_bmap_dmxr[2];	/* max bmap btree records */
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 27186fcfdcde73..38062c10293d6b 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -776,7 +776,7 @@ xfs_growfs_rt_nrblocks(
 	struct xfs_mount	*mp = rtg_mount(rtg);
 	xfs_rfsblock_t		step;
 
-	step = (bmbno + 1) * NBBY * mp->m_sb.sb_blocksize * rextsize;
+	step = (bmbno + 1) * mp->m_rtx_per_rbmblock * rextsize;
 	if (xfs_has_rtgroups(mp)) {
 		xfs_rfsblock_t	rgblocks = mp->m_sb.sb_rgextents * rextsize;
 


