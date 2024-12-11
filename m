Return-Path: <linux-xfs+bounces-16471-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 018019EC805
	for <lists+linux-xfs@lfdr.de>; Wed, 11 Dec 2024 09:58:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A9B2618896C0
	for <lists+linux-xfs@lfdr.de>; Wed, 11 Dec 2024 08:58:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01E5A1F2391;
	Wed, 11 Dec 2024 08:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JkWpXBsF"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E43B1F2389
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 08:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733907475; cv=none; b=qmUsLv/8R2Jj4bXYWZgl0wvLH0pb8sjTH1uyXw3F6Gi5HRqswaJN1Ruk1EuLGqgC2uQ26JLvPR02wvhklkWF0/URZiWP/hMUr48xFQH82ylPlKN68+g4GELI6zsLTtKV5zI7QzXobT5SGLah9JY8j7giTOf+PZQd3KqhIIDeSDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733907475; c=relaxed/simple;
	bh=C7RC4O+va423PfEhKnrZWO6WDZKph3Z2iU3axYHh6jo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FOdHrc+p4fcAVVuIJU8kmYhun1/y836iW19NzsAcpJa+oPD8kmMRrAztlT5tnrYnO5YPuTF6bVKd+T1WGSxz/J/wJQ0/fbOIDvSwQQ7IUqtw4/rCmw85MKioFTZ3KyErQBshP2Tv87J7vrzo6pQiWdGBiRX+6zEMK7FDVL3JrG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JkWpXBsF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=S8PWZRB+UEmk0PkvHx1wD5612DtFHeQB8HOAxfyhRfk=; b=JkWpXBsF3EehiyDhPpeLaR/Vvg
	na3eRsHptuJ/55bf0KKCs2SYHdZ2jao1g/iDmMPpmqf3vAmTfy8dcin05OjbCAejJ4VeAcqu3F9IX
	0HELyFxHxzZpO8lOCM4k52Qyz9+UI7f5TszFk7zMVihYl66kokCaOvS0Qugh9/zovimH7ZTacJ4xn
	0jJe/sdHZe7oyKxgdtfmhiWVvY8ET1v27YeaHgBCQU1Yh6ndyGyRjOHYzdEX87cwKs2AMWp9UZzRX
	vBNGRX2Lk0Yy3FV8A64gP4pVcJ1XNua2zIt0P3TYc8jedV+aDRASUqSSlEOE4Bioc86yZ/HcvszaE
	c7Mn4Xxw==;
Received: from [2001:4bb8:2ae:8817:935:3eb8:759c:c417] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tLIXY-0000000EJKx-2Aqo;
	Wed, 11 Dec 2024 08:57:53 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 27/43] xfs: implement buffered writes to zoned RT devices
Date: Wed, 11 Dec 2024 09:54:52 +0100
Message-ID: <20241211085636.1380516-28-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241211085636.1380516-1-hch@lst.de>
References: <20241211085636.1380516-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Implement buffered writes including page faults and block zeroing for
zoned RT devices.  Buffered writes to zoned RT devices are split into
three phases:

 1) a reservation for the worst case data block usage is taken before
    acquiring the iolock.  When there are enough free blocks but not
    enough available one, garbage collection is kicked of to free the
    space before continuing with the write.  If there isn't enough
    freeable space, the block reservation is reduced and a short write
    will happen as expected by normal Linux write semantics.
 2) with the iolock held, the generic iomap buffered write code is
    called, which through the iomap_begin operation usually just inserts
    delalloc extents for the range in a single iteration.  Only for
    overwrites of existing data that are not block aligned, or zeroing
    operations the existing extent mapping is read to fill out the srcmap
    and to figure out if zeroing is required.
 3) the ->map_blocks callback to the generic iomap writeback code
    calls into the zoned space allocator to actually allocate on-disk
    space for the range before kicking of the writeback.

Note that because all writes are out of place, truncate or hole punches
that are not aligned to block size boundaries need to allocate space.
For block zeroing from truncate, ->setattr is called with the iolock
(aka i_rwsem) already held, so a hacky deviation from the above
scheme is needed.  In this case the space reservations is called with
the iolock held, but is required not to block and can dip into the
reserved block pool.  This can lead to -ENOSPC when truncating a
file, which is unfortunate.  But fixing the calling conventions in
the VFS is probably much easier with code requiring it already in
mainline.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c      | 134 +++++++++++++++++++++++++--
 fs/xfs/xfs_bmap_util.c |  21 +++--
 fs/xfs/xfs_bmap_util.h |  12 ++-
 fs/xfs/xfs_file.c      | 202 +++++++++++++++++++++++++++++++++++++----
 fs/xfs/xfs_iomap.c     | 186 ++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_iomap.h     |   6 +-
 fs/xfs/xfs_iops.c      |  31 ++++++-
 fs/xfs/xfs_reflink.c   |   2 +-
 fs/xfs/xfs_trace.h     |   1 +
 9 files changed, 550 insertions(+), 45 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index d35ac4c19fb2..67392413216b 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
  * Copyright (c) 2000-2005 Silicon Graphics, Inc.
- * Copyright (c) 2016-2018 Christoph Hellwig.
+ * Copyright (c) 2016-2023 Christoph Hellwig.
  * All Rights Reserved.
  */
 #include "xfs.h"
@@ -19,6 +19,8 @@
 #include "xfs_reflink.h"
 #include "xfs_errortag.h"
 #include "xfs_error.h"
+#include "xfs_zone_alloc.h"
+#include "xfs_rtgroup.h"
 
 struct xfs_writepage_ctx {
 	struct iomap_writepage_ctx ctx;
@@ -85,6 +87,7 @@ xfs_end_ioend(
 {
 	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
 	struct xfs_mount	*mp = ip->i_mount;
+	bool			is_zoned = xfs_is_zoned_inode(ip);
 	xfs_off_t		offset = ioend->io_offset;
 	size_t			size = ioend->io_size;
 	unsigned int		nofs_flag;
@@ -115,9 +118,10 @@ xfs_end_ioend(
 	error = blk_status_to_errno(ioend->io_bio.bi_status);
 	if (unlikely(error)) {
 		if (ioend->io_flags & IOMAP_IOEND_SHARED) {
+			ASSERT(!is_zoned);
 			xfs_reflink_cancel_cow_range(ip, offset, size, true);
 			xfs_bmap_punch_delalloc_range(ip, XFS_DATA_FORK, offset,
-					offset + size);
+					offset + size, NULL);
 		}
 		goto done;
 	}
@@ -125,7 +129,10 @@ xfs_end_ioend(
 	/*
 	 * Success: commit the COW or unwritten blocks if needed.
 	 */
-	if (ioend->io_flags & IOMAP_IOEND_SHARED)
+	if (is_zoned)
+		error = xfs_zoned_end_io(ip, offset, size, ioend->io_sector,
+				NULLFSBLOCK);
+	else if (ioend->io_flags & IOMAP_IOEND_SHARED)
 		error = xfs_reflink_end_cow(ip, offset, size);
 	else if (ioend->io_flags & IOMAP_IOEND_UNWRITTEN)
 		error = xfs_iomap_write_unwritten(ip, offset, size, false);
@@ -175,17 +182,27 @@ xfs_end_io(
 	}
 }
 
-STATIC void
+static void
 xfs_end_bio(
 	struct bio		*bio)
 {
 	struct iomap_ioend	*ioend = iomap_ioend_from_bio(bio);
 	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
+	struct xfs_mount	*mp = ip->i_mount;
 	unsigned long		flags;
 
+	/*
+	 * For Appends record the actually written block number and set the
+	 * boundary flag if needed.
+	 */
+	if (IS_ENABLED(CONFIG_XFS_RT) && bio_is_zone_append(bio)) {
+		ioend->io_sector = bio->bi_iter.bi_sector;
+		xfs_mark_rtg_boundary(ioend);
+	}
+
 	spin_lock_irqsave(&ip->i_ioend_lock, flags);
 	if (list_empty(&ip->i_ioend_list))
-		WARN_ON_ONCE(!queue_work(ip->i_mount->m_unwritten_workqueue,
+		WARN_ON_ONCE(!queue_work(mp->m_unwritten_workqueue,
 					 &ip->i_ioend_work));
 	list_add_tail(&ioend->io_list, &ip->i_ioend_list);
 	spin_unlock_irqrestore(&ip->i_ioend_lock, flags);
@@ -462,7 +479,7 @@ xfs_discard_folio(
 	 * folio itself and not the start offset that is passed in.
 	 */
 	xfs_bmap_punch_delalloc_range(ip, XFS_DATA_FORK, pos,
-				folio_pos(folio) + folio_size(folio));
+				folio_pos(folio) + folio_size(folio), NULL);
 }
 
 static const struct iomap_writeback_ops xfs_writeback_ops = {
@@ -471,14 +488,117 @@ static const struct iomap_writeback_ops xfs_writeback_ops = {
 	.discard_folio		= xfs_discard_folio,
 };
 
+struct xfs_zoned_writepage_ctx {
+	struct iomap_writepage_ctx	ctx;
+	struct xfs_open_zone		*open_zone;
+};
+
+static inline struct xfs_zoned_writepage_ctx *
+XFS_ZWPC(struct iomap_writepage_ctx *ctx)
+{
+	return container_of(ctx, struct xfs_zoned_writepage_ctx, ctx);
+}
+
+static int
+xfs_zoned_map_blocks(
+	struct iomap_writepage_ctx *wpc,
+	struct inode		*inode,
+	loff_t			offset,
+	unsigned int		len)
+{
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
+	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, offset + len);
+	xfs_filblks_t		count_fsb;
+	struct xfs_bmbt_irec	imap, del;
+	struct xfs_iext_cursor	icur;
+
+	if (xfs_is_shutdown(mp))
+		return -EIO;
+
+	XFS_ERRORTAG_DELAY(mp, XFS_ERRTAG_WB_DELAY_MS);
+
+	/*
+	 * All dirty data must be covered by delalloc extents.  But truncate can
+	 * remove delalloc extents underneath us or reduce their size.
+	 * Returning a hole tells iomap to not write back any data from this
+	 * range, which is the right thing to do in that case.
+	 *
+	 * Otherwise just tell iomap to treat ranges previously covered by a
+	 * delalloc extent as mapped.  The actual block allocation will be done
+	 * just before submitting the bio.
+	 */
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	if (!xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb, &icur, &imap))
+		imap.br_startoff = end_fsb;	/* fake a hole past EOF */
+	if (imap.br_startoff > offset_fsb) {
+		imap.br_blockcount = imap.br_startoff - offset_fsb;
+		imap.br_startoff = offset_fsb;
+		imap.br_startblock = HOLESTARTBLOCK;
+		imap.br_state = XFS_EXT_NORM;
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		xfs_bmbt_to_iomap(ip, &wpc->iomap, &imap, 0, 0, 0);
+		return 0;
+	}
+	end_fsb = min(end_fsb, imap.br_startoff + imap.br_blockcount);
+	count_fsb = end_fsb - offset_fsb;
+
+	del = imap;
+	xfs_trim_extent(&del, offset_fsb, count_fsb);
+	xfs_bmap_del_extent_delay(ip, XFS_COW_FORK, &icur, &imap, &del,
+			XFS_BMAPI_REMAP);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+
+	wpc->iomap.type = IOMAP_MAPPED;
+	wpc->iomap.flags = IOMAP_F_DIRTY;
+	wpc->iomap.bdev = mp->m_rtdev_targp->bt_bdev;
+	wpc->iomap.offset = offset;
+	wpc->iomap.length = XFS_FSB_TO_B(mp, count_fsb);
+	wpc->iomap.flags = IOMAP_F_ZONE_APPEND;
+	wpc->iomap.addr = 0;
+
+	trace_xfs_zoned_map_blocks(ip, offset, wpc->iomap.length);
+	return 0;
+}
+
+static int
+xfs_zoned_submit_ioend(
+	struct iomap_writepage_ctx *wpc,
+	int			status)
+{
+	wpc->ioend->io_bio.bi_end_io = xfs_end_bio;
+	if (status)
+		return status;
+	xfs_zone_alloc_and_submit(wpc->ioend, &XFS_ZWPC(wpc)->open_zone);
+	return 0;
+}
+
+static const struct iomap_writeback_ops xfs_zoned_writeback_ops = {
+	.map_blocks		= xfs_zoned_map_blocks,
+	.submit_ioend		= xfs_zoned_submit_ioend,
+	.discard_folio		= xfs_discard_folio,
+};
+
 STATIC int
 xfs_vm_writepages(
 	struct address_space	*mapping,
 	struct writeback_control *wbc)
 {
+	struct xfs_inode	*ip = XFS_I(mapping->host);
 	struct xfs_writepage_ctx wpc = { };
+	int			error;
 
-	xfs_iflags_clear(XFS_I(mapping->host), XFS_ITRUNCATED);
+	xfs_iflags_clear(ip, XFS_ITRUNCATED);
+	if (xfs_is_zoned_inode(ip)) {
+		struct xfs_zoned_writepage_ctx xc = { };
+
+		error = iomap_writepages(mapping, wbc, &xc.ctx,
+					 &xfs_zoned_writeback_ops);
+		if (xc.open_zone)
+			xfs_open_zone_put(xc.open_zone);
+		return error;
+	}
 	return iomap_writepages(mapping, wbc, &wpc.ctx, &xfs_writeback_ops);
 }
 
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index c623688e457c..c87422de2d77 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -30,6 +30,7 @@
 #include "xfs_reflink.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_rtgroup.h"
+#include "xfs_zone_alloc.h"
 
 /* Kernel only BMAP related definitions and functions */
 
@@ -436,7 +437,8 @@ xfs_bmap_punch_delalloc_range(
 	struct xfs_inode	*ip,
 	int			whichfork,
 	xfs_off_t		start_byte,
-	xfs_off_t		end_byte)
+	xfs_off_t		end_byte,
+	struct xfs_zone_alloc_ctx *ac)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
@@ -467,7 +469,10 @@ xfs_bmap_punch_delalloc_range(
 			continue;
 		}
 
-		xfs_bmap_del_extent_delay(ip, whichfork, &icur, &got, &del, 0);
+		xfs_bmap_del_extent_delay(ip, whichfork, &icur, &got, &del,
+				ac ? XFS_BMAPI_REMAP : 0);
+		if (xfs_is_zoned_inode(ip) && ac)
+			ac->reserved_blocks += del.br_blockcount;
 		if (!xfs_iext_get_extent(ifp, &icur, &got))
 			break;
 	}
@@ -582,7 +587,7 @@ xfs_free_eofblocks(
 		if (ip->i_delayed_blks) {
 			xfs_bmap_punch_delalloc_range(ip, XFS_DATA_FORK,
 				round_up(XFS_ISIZE(ip), mp->m_sb.sb_blocksize),
-				LLONG_MAX);
+				LLONG_MAX, NULL);
 		}
 		xfs_inode_clear_eofblocks_tag(ip);
 		return 0;
@@ -825,7 +830,8 @@ int
 xfs_free_file_space(
 	struct xfs_inode	*ip,
 	xfs_off_t		offset,
-	xfs_off_t		len)
+	xfs_off_t		len,
+	struct xfs_zone_alloc_ctx *ac)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	xfs_fileoff_t		startoffset_fsb;
@@ -880,7 +886,7 @@ xfs_free_file_space(
 		return 0;
 	if (offset + len > XFS_ISIZE(ip))
 		len = XFS_ISIZE(ip) - offset;
-	error = xfs_zero_range(ip, offset, len, NULL);
+	error = xfs_zero_range(ip, offset, len, ac, NULL);
 	if (error)
 		return error;
 
@@ -968,7 +974,8 @@ int
 xfs_collapse_file_space(
 	struct xfs_inode	*ip,
 	xfs_off_t		offset,
-	xfs_off_t		len)
+	xfs_off_t		len,
+	struct xfs_zone_alloc_ctx *ac)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp;
@@ -981,7 +988,7 @@ xfs_collapse_file_space(
 
 	trace_xfs_collapse_file_space(ip);
 
-	error = xfs_free_file_space(ip, offset, len);
+	error = xfs_free_file_space(ip, offset, len, ac);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index b29760d36e1a..c477b3361630 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -15,6 +15,7 @@ struct xfs_inode;
 struct xfs_mount;
 struct xfs_trans;
 struct xfs_bmalloca;
+struct xfs_zone_alloc_ctx;
 
 #ifdef CONFIG_XFS_RT
 int	xfs_bmap_rtalloc(struct xfs_bmalloca *ap);
@@ -31,7 +32,8 @@ xfs_bmap_rtalloc(struct xfs_bmalloca *ap)
 #endif /* CONFIG_XFS_RT */
 
 void	xfs_bmap_punch_delalloc_range(struct xfs_inode *ip, int whichfork,
-		xfs_off_t start_byte, xfs_off_t end_byte);
+		xfs_off_t start_byte, xfs_off_t end_byte,
+		struct xfs_zone_alloc_ctx *ac);
 
 struct kgetbmap {
 	__s64		bmv_offset;	/* file offset of segment in blocks */
@@ -54,13 +56,13 @@ int	xfs_bmap_last_extent(struct xfs_trans *tp, struct xfs_inode *ip,
 
 /* preallocation and hole punch interface */
 int	xfs_alloc_file_space(struct xfs_inode *ip, xfs_off_t offset,
-			     xfs_off_t len);
+		xfs_off_t len);
 int	xfs_free_file_space(struct xfs_inode *ip, xfs_off_t offset,
-			    xfs_off_t len);
+		xfs_off_t len, struct xfs_zone_alloc_ctx *ac);
 int	xfs_collapse_file_space(struct xfs_inode *, xfs_off_t offset,
-				xfs_off_t len);
+		xfs_off_t len, struct xfs_zone_alloc_ctx *ac);
 int	xfs_insert_file_space(struct xfs_inode *, xfs_off_t offset,
-				xfs_off_t len);
+		xfs_off_t len);
 
 /* EOF block manipulation functions */
 bool	xfs_can_free_eofblocks(struct xfs_inode *ip);
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 827f7819df6a..195cf60a81b0 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -25,6 +25,7 @@
 #include "xfs_iomap.h"
 #include "xfs_reflink.h"
 #include "xfs_file.h"
+#include "xfs_zone_alloc.h"
 
 #include <linux/dax.h>
 #include <linux/falloc.h>
@@ -360,7 +361,8 @@ xfs_file_write_zero_eof(
 	struct iov_iter		*from,
 	unsigned int		*iolock,
 	size_t			count,
-	bool			*drained_dio)
+	bool			*drained_dio,
+	struct xfs_zone_alloc_ctx *ac)
 {
 	struct xfs_inode	*ip = XFS_I(iocb->ki_filp->f_mapping->host);
 	loff_t			isize;
@@ -414,7 +416,7 @@ xfs_file_write_zero_eof(
 	trace_xfs_zero_eof(ip, isize, iocb->ki_pos - isize);
 
 	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
-	error = xfs_zero_range(ip, isize, iocb->ki_pos - isize, NULL);
+	error = xfs_zero_range(ip, isize, iocb->ki_pos - isize, ac, NULL);
 	xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
 
 	return error;
@@ -431,7 +433,8 @@ STATIC ssize_t
 xfs_file_write_checks(
 	struct kiocb		*iocb,
 	struct iov_iter		*from,
-	unsigned int		*iolock)
+	unsigned int		*iolock,
+	struct xfs_zone_alloc_ctx *ac)
 {
 	struct inode		*inode = iocb->ki_filp->f_mapping->host;
 	size_t			count = iov_iter_count(from);
@@ -481,7 +484,7 @@ xfs_file_write_checks(
 	 */
 	if (iocb->ki_pos > i_size_read(inode)) {
 		error = xfs_file_write_zero_eof(iocb, from, iolock, count,
-				&drained_dio);
+				&drained_dio, ac);
 		if (error == 1)
 			goto restart;
 		if (error)
@@ -491,6 +494,48 @@ xfs_file_write_checks(
 	return kiocb_modified(iocb);
 }
 
+static ssize_t
+xfs_zoned_write_space_reserve(
+	struct xfs_inode		*ip,
+	struct kiocb			*iocb,
+	struct iov_iter			*from,
+	unsigned int			flags,
+	struct xfs_zone_alloc_ctx	*ac)
+{
+	loff_t				count = iov_iter_count(from);
+	int				error;
+
+	if (iocb->ki_flags & IOCB_NOWAIT)
+		flags |= XFS_ZR_NOWAIT;
+
+	/*
+	 * Check the rlimit and LFS boundary first so that we don't over-reserve
+	 * by possibly a lot.
+	 *
+	 * The generic write path will redo this check later, and it might have
+	 * changed by then.  If it got expanded we'll stick to our earlier
+	 * smaller limit, and if it is decreased the new smaller limit will be
+	 * used and our extra space reservation will be returned after finishing
+	 * the write.
+	 */
+	error = generic_write_check_limits(iocb->ki_filp, iocb->ki_pos, &count);
+	if (error)
+		return error;
+
+	/*
+	 * Sloppily round up count to file system blocks.
+	 *
+	 * This will often reserve an extra block, but that avoids having to look
+	 * at the start offset, which isn't stable for O_APPEND until taking the
+	 * iolock.  Also we need to reserve a block each for zeroing the old
+	 * EOF block and the new start block if they are unaligned.
+	 *
+	 * Any remaining block will be returned after the write.
+	 */
+	return xfs_zoned_space_reserve(ip,
+			XFS_B_TO_FSB(ip->i_mount, count) + 1 + 2, flags, ac);
+}
+
 static int
 xfs_dio_write_end_io(
 	struct kiocb		*iocb,
@@ -597,7 +642,7 @@ xfs_file_dio_write_aligned(
 	ret = xfs_ilock_iocb_for_write(iocb, &iolock);
 	if (ret)
 		return ret;
-	ret = xfs_file_write_checks(iocb, from, &iolock);
+	ret = xfs_file_write_checks(iocb, from, &iolock, NULL);
 	if (ret)
 		goto out_unlock;
 
@@ -675,7 +720,7 @@ xfs_file_dio_write_unaligned(
 		goto out_unlock;
 	}
 
-	ret = xfs_file_write_checks(iocb, from, &iolock);
+	ret = xfs_file_write_checks(iocb, from, &iolock, NULL);
 	if (ret)
 		goto out_unlock;
 
@@ -749,7 +794,7 @@ xfs_file_dax_write(
 	ret = xfs_ilock_iocb(iocb, iolock);
 	if (ret)
 		return ret;
-	ret = xfs_file_write_checks(iocb, from, &iolock);
+	ret = xfs_file_write_checks(iocb, from, &iolock, NULL);
 	if (ret)
 		goto out;
 
@@ -793,7 +838,7 @@ xfs_file_buffered_write(
 	if (ret)
 		return ret;
 
-	ret = xfs_file_write_checks(iocb, from, &iolock);
+	ret = xfs_file_write_checks(iocb, from, &iolock, NULL);
 	if (ret)
 		goto out;
 
@@ -840,6 +885,67 @@ xfs_file_buffered_write(
 	return ret;
 }
 
+STATIC ssize_t
+xfs_file_buffered_write_zoned(
+	struct kiocb		*iocb,
+	struct iov_iter		*from)
+{
+	struct xfs_inode	*ip = XFS_I(iocb->ki_filp->f_mapping->host);
+	struct xfs_mount	*mp = ip->i_mount;
+	unsigned int		iolock = XFS_IOLOCK_EXCL;
+	bool			cleared_space = false;
+	struct xfs_zone_alloc_ctx ac = { };
+	ssize_t			ret;
+
+	ret = xfs_zoned_write_space_reserve(ip, iocb, from, XFS_ZR_GREEDY, &ac);
+	if (ret < 0)
+		return ret;
+
+	ret = xfs_ilock_iocb(iocb, iolock);
+	if (ret)
+		goto out_unreserve;
+
+	ret = xfs_file_write_checks(iocb, from, &iolock, &ac);
+	if (ret)
+		goto out_unlock;
+
+	/*
+	 * Truncate the iter to the length that we were actually able to
+	 * allocate blocks for.  This needs to happen after
+	 * xfs_file_write_checks, because that assigns ki_pos for O_APPEND
+	 * writes.
+	 */
+	iov_iter_truncate(from,
+			XFS_FSB_TO_B(mp, ac.reserved_blocks) -
+			(iocb->ki_pos & mp->m_blockmask));
+	if (!iov_iter_count(from))
+		goto out_unlock;
+
+retry:
+	trace_xfs_file_buffered_write(iocb, from);
+	ret = iomap_file_buffered_write(iocb, from,
+			&xfs_buffered_write_iomap_ops, &ac);
+	if (ret == -ENOSPC && !cleared_space) {
+		/* 
+		 * Kick off writeback to convert delalloc space and release the
+		 * usually too pessimistic indirect block reservations.
+		 */
+		xfs_flush_inodes(mp);
+		cleared_space = true;
+		goto retry;
+	}
+
+out_unlock:
+	xfs_iunlock(ip, iolock);
+out_unreserve:
+	xfs_zoned_space_unreserve(ip, &ac);
+	if (ret > 0) {
+		XFS_STATS_ADD(mp, xs_write_bytes, ret);
+		ret = generic_write_sync(iocb, ret);
+	}
+	return ret;
+}
+
 STATIC ssize_t
 xfs_file_write_iter(
 	struct kiocb		*iocb,
@@ -887,6 +993,8 @@ xfs_file_write_iter(
 			return ret;
 	}
 
+	if (xfs_is_zoned_inode(ip))
+		return xfs_file_buffered_write_zoned(iocb, from);
 	return xfs_file_buffered_write(iocb, from);
 }
 
@@ -941,7 +1049,8 @@ static int
 xfs_falloc_collapse_range(
 	struct file		*file,
 	loff_t			offset,
-	loff_t			len)
+	loff_t			len,
+	struct xfs_zone_alloc_ctx *ac)
 {
 	struct inode		*inode = file_inode(file);
 	loff_t			new_size = i_size_read(inode) - len;
@@ -957,7 +1066,7 @@ xfs_falloc_collapse_range(
 	if (offset + len >= i_size_read(inode))
 		return -EINVAL;
 
-	error = xfs_collapse_file_space(XFS_I(inode), offset, len);
+	error = xfs_collapse_file_space(XFS_I(inode), offset, len, ac);
 	if (error)
 		return error;
 	return xfs_falloc_setsize(file, new_size);
@@ -1013,7 +1122,8 @@ xfs_falloc_zero_range(
 	struct file		*file,
 	int			mode,
 	loff_t			offset,
-	loff_t			len)
+	loff_t			len,
+	struct xfs_zone_alloc_ctx *ac)
 {
 	struct inode		*inode = file_inode(file);
 	unsigned int		blksize = i_blocksize(inode);
@@ -1026,7 +1136,7 @@ xfs_falloc_zero_range(
 	if (error)
 		return error;
 
-	error = xfs_free_file_space(XFS_I(inode), offset, len);
+	error = xfs_free_file_space(XFS_I(inode), offset, len, ac);
 	if (error)
 		return error;
 
@@ -1107,12 +1217,29 @@ xfs_file_fallocate(
 	struct xfs_inode	*ip = XFS_I(inode);
 	long			error;
 	uint			iolock = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
+	struct xfs_zone_alloc_ctx ac = { };
 
 	if (!S_ISREG(inode->i_mode))
 		return -EINVAL;
 	if (mode & ~XFS_FALLOC_FL_SUPPORTED)
 		return -EOPNOTSUPP;
 
+	/*
+	 * For zoned file systems, zeroing the first and last block of a hole
+	 * punch requires allocating a new block to rewrite the remaining data
+	 * and new zeroes out of place.  Get a reservations for those before
+	 * taking the iolock.  Dip into the reserved pool because we are
+	 * expected to be able to punch a hole even on a completely full
+	 * file system.
+	 */
+	if (xfs_is_zoned_inode(ip) &&
+	    (mode & (FALLOC_FL_PUNCH_HOLE | FALLOC_FL_ZERO_RANGE |
+		     FALLOC_FL_COLLAPSE_RANGE))) {
+		error = xfs_zoned_space_reserve(ip, 2, XFS_ZR_RESERVED, &ac);
+		if (error)
+			return error;
+	}
+
 	xfs_ilock(ip, iolock);
 	error = xfs_break_layouts(inode, &iolock, BREAK_UNMAP);
 	if (error)
@@ -1133,16 +1260,16 @@ xfs_file_fallocate(
 
 	switch (mode & FALLOC_FL_MODE_MASK) {
 	case FALLOC_FL_PUNCH_HOLE:
-		error = xfs_free_file_space(ip, offset, len);
+		error = xfs_free_file_space(ip, offset, len, &ac);
 		break;
 	case FALLOC_FL_COLLAPSE_RANGE:
-		error = xfs_falloc_collapse_range(file, offset, len);
+		error = xfs_falloc_collapse_range(file, offset, len, &ac);
 		break;
 	case FALLOC_FL_INSERT_RANGE:
 		error = xfs_falloc_insert_range(file, offset, len);
 		break;
 	case FALLOC_FL_ZERO_RANGE:
-		error = xfs_falloc_zero_range(file, mode, offset, len);
+		error = xfs_falloc_zero_range(file, mode, offset, len, &ac);
 		break;
 	case FALLOC_FL_UNSHARE_RANGE:
 		error = xfs_falloc_unshare_range(file, mode, offset, len);
@@ -1160,6 +1287,8 @@ xfs_file_fallocate(
 
 out_unlock:
 	xfs_iunlock(ip, iolock);
+	if (xfs_is_zoned_inode(ip))
+		xfs_zoned_space_unreserve(ip, &ac);
 	return error;
 }
 
@@ -1485,9 +1614,10 @@ xfs_dax_read_fault(
  *         i_lock (XFS - extent map serialisation)
  */
 static vm_fault_t
-xfs_write_fault(
+__xfs_write_fault(
 	struct vm_fault		*vmf,
-	unsigned int		order)
+	unsigned int		order,
+	struct xfs_zone_alloc_ctx *ac)
 {
 	struct inode		*inode = file_inode(vmf->vma->vm_file);
 	struct xfs_inode	*ip = XFS_I(inode);
@@ -1515,13 +1645,49 @@ xfs_write_fault(
 		ret = xfs_dax_fault_locked(vmf, order, true);
 	else
 		ret = iomap_page_mkwrite(vmf, &xfs_buffered_write_iomap_ops,
-				NULL);
+				ac);
 	xfs_iunlock(ip, lock_mode);
 
 	sb_end_pagefault(inode->i_sb);
 	return ret;
 }
 
+static vm_fault_t
+xfs_write_fault_zoned(
+	struct vm_fault		*vmf,
+	unsigned int		order)
+{
+	struct xfs_inode	*ip = XFS_I(file_inode(vmf->vma->vm_file));
+	unsigned int		len = folio_size(page_folio(vmf->page));
+	struct xfs_zone_alloc_ctx ac = { };
+	int			error;
+	vm_fault_t		ret;
+
+	/*
+	 * This could over-allocate as it doesn't check for truncation.
+	 *
+	 * But as the overallocation is limited to less than a folio and will be
+	 8 release instantly that's just fine.
+	 */
+	error = xfs_zoned_space_reserve(ip, XFS_B_TO_FSB(ip->i_mount, len), 0,
+			&ac);
+	if (error < 0)
+		return vmf_fs_error(error);
+	ret = __xfs_write_fault(vmf, order, &ac);
+	xfs_zoned_space_unreserve(ip, &ac);
+	return ret;
+}
+
+static vm_fault_t
+xfs_write_fault(
+	struct vm_fault		*vmf,
+	unsigned int		order)
+{
+	if (xfs_is_zoned_inode(XFS_I(file_inode(vmf->vma->vm_file))))
+		return xfs_write_fault_zoned(vmf, order);
+	return __xfs_write_fault(vmf, order, NULL);
+}
+
 static inline bool
 xfs_is_write_fault(
 	struct vm_fault		*vmf)
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index aa1db0dc1d98..402b253ce3a2 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -31,6 +31,7 @@
 #include "xfs_health.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_icache.h"
+#include "xfs_zone_alloc.h"
 
 #define XFS_ALLOC_ALIGN(mp, off) \
 	(((off) >> mp->m_allocsize_log) << mp->m_allocsize_log)
@@ -1270,6 +1271,176 @@ xfs_bmapi_reserve_delalloc(
 	return error;
 }
 
+static int
+xfs_zoned_buffered_write_iomap_begin(
+	struct inode		*inode,
+	loff_t			offset,
+	loff_t			count,
+	unsigned		flags,
+	struct iomap		*iomap,
+	struct iomap		*srcmap)
+{
+	struct iomap_iter	*iter =
+		container_of(iomap, struct iomap_iter, iomap);
+	struct xfs_zone_alloc_ctx *ac = iter->private;
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
+	xfs_fileoff_t		end_fsb = xfs_iomap_end_fsb(mp, offset, count);
+	u16			iomap_flags = IOMAP_F_SHARED;
+	unsigned int		lockmode = XFS_ILOCK_EXCL;
+	xfs_filblks_t		count_fsb;
+	xfs_extlen_t		indlen;
+	struct xfs_bmbt_irec	got;
+	struct xfs_iext_cursor	icur;
+	int			error = 0;
+
+	ASSERT(!xfs_get_extsz_hint(ip));
+	ASSERT(!(flags & IOMAP_UNSHARE));
+	ASSERT(ac);
+
+	if (xfs_is_shutdown(mp))
+		return -EIO;
+
+	error = xfs_qm_dqattach(ip);
+	if (error)
+		return error;
+
+	error = xfs_ilock_for_iomap(ip, flags, &lockmode);
+	if (error)
+		return error;
+
+	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(&ip->i_df)) ||
+	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
+		xfs_bmap_mark_sick(ip, XFS_DATA_FORK);
+		error = -EFSCORRUPTED;
+		goto out_unlock;
+	}
+
+	XFS_STATS_INC(mp, xs_blk_mapw);
+
+	error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
+	if (error)
+		goto out_unlock;
+
+	/*
+	 * For zeroing operations check if there is any data to zero first.
+	 *
+	 * For regular writes we always need to allocate new blocks, but need to
+	 * provide the source mapping when the range is unaligned to support
+	 * read-modify-write of the whole block in the page cache.
+	 *
+	 * In either case we need to limit the reported range to the boundaries
+	 * of the source map in the data fork.
+	 */
+	if (!IS_ALIGNED(offset, mp->m_sb.sb_blocksize) ||
+	    !IS_ALIGNED(offset + count, mp->m_sb.sb_blocksize) ||
+	    (flags & IOMAP_ZERO)) {
+		struct xfs_bmbt_irec	smap;
+		struct xfs_iext_cursor	scur;
+
+		if (!xfs_iext_lookup_extent(ip, &ip->i_df, offset_fsb, &scur,
+				&smap))
+			smap.br_startoff = end_fsb; /* fake hole until EOF */
+		if (smap.br_startoff > offset_fsb) {
+			/*
+			 * We never need to allocate blocks for zeroing a hole.
+			 */
+			if (flags & IOMAP_ZERO) {
+				xfs_hole_to_iomap(ip, iomap, offset_fsb,
+						smap.br_startoff);
+				goto out_unlock;
+			}
+			end_fsb = min(end_fsb, smap.br_startoff);
+		} else {
+			end_fsb = min(end_fsb,
+				smap.br_startoff + smap.br_blockcount);
+			xfs_trim_extent(&smap, offset_fsb,
+					end_fsb - offset_fsb);
+			error = xfs_bmbt_to_iomap(ip, srcmap, &smap, flags, 0,
+					xfs_iomap_inode_sequence(ip, 0));
+			if (error)
+				goto out_unlock;
+		}
+	}
+
+	if (!ip->i_cowfp)
+		xfs_ifork_init_cow(ip);
+
+	if (!xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb, &icur, &got))
+		got.br_startoff = end_fsb;
+	if (got.br_startoff <= offset_fsb) {
+		trace_xfs_reflink_cow_found(ip, &got);
+		goto done;
+	}
+
+	/*
+	 * Cap the maximum length to keep the chunks of work done here somewhat
+	 * symmetric with the work writeback does.
+	 */
+	end_fsb = min(end_fsb, got.br_startoff);
+	count_fsb = min3(end_fsb - offset_fsb, XFS_MAX_BMBT_EXTLEN,
+			 XFS_B_TO_FSB(mp, 1024 * PAGE_SIZE));
+
+	/*
+	 * The block reservation is supposed to cover all blocks that the
+	 * operation could possible write, but there is a nasty corner case
+	 * where blocks could be stolen from underneath us:
+	 *
+	 *  1) while this thread iterates over a larger buffered write,
+	 *  2) another thread is causing a write fault that calls into
+	 *     ->page_mkwrite in range this thread writes to, using up the
+	 *     delalloc reservation created by a previous call to this function.
+	 *  3) another thread does direct I/O on the range that the write fault
+	 *     happened on, which causes writeback of the dirty data.
+	 *  4) this then set the stale flag, which cuts the current iomap
+	 *     iteration short, causing the new call to ->iomap_begin that gets
+	 *     us here again, but now without a sufficient reservation.
+	 *
+	 * This is a very unusual I/O pattern, and nothing but generic/095 is
+	 * known to hit it. There's not really much we can do here, so turn this
+	 * into a short write.
+	 */
+	if (count_fsb > ac->reserved_blocks) {
+		xfs_warn_ratelimited(mp,
+"Short write on ino 0x%llx comm %.20s due to three-way race with write fault and direct I/O",
+			ip->i_ino, current->comm);
+		count_fsb = ac->reserved_blocks;
+		if (!count_fsb) {
+			error = -EIO;
+			goto out_unlock;
+		}
+	}
+
+	error = xfs_quota_reserve_blkres(ip, count_fsb);
+	if (error)
+		goto out_unlock;
+
+	indlen = xfs_bmap_worst_indlen(ip, count_fsb);
+	error = xfs_dec_fdblocks(mp, indlen, false);
+	if (error)
+		goto out_unlock;
+	ip->i_delayed_blks += count_fsb;
+	xfs_mod_delalloc(ip, count_fsb, indlen);
+
+	got.br_startoff = offset_fsb;
+	got.br_startblock = nullstartblock(indlen);
+	got.br_blockcount = count_fsb;
+	got.br_state = XFS_EXT_NORM;
+	xfs_bmap_add_extent_hole_delay(ip, XFS_COW_FORK, &icur, &got);
+	ac->reserved_blocks -= count_fsb;
+	iomap_flags |= IOMAP_F_NEW;
+
+	trace_xfs_iomap_alloc(ip, offset, XFS_FSB_TO_B(mp, count_fsb),
+			XFS_COW_FORK, &got);
+done:
+	error = xfs_bmbt_to_iomap(ip, iomap, &got, flags, iomap_flags,
+			xfs_iomap_inode_sequence(ip, IOMAP_F_SHARED));
+out_unlock:
+	xfs_iunlock(ip, lockmode);
+	return error;
+}
+
 static int
 xfs_buffered_write_iomap_begin(
 	struct inode		*inode,
@@ -1296,6 +1467,10 @@ xfs_buffered_write_iomap_begin(
 	if (xfs_is_shutdown(mp))
 		return -EIO;
 
+	if (xfs_is_zoned_inode(ip))
+		return xfs_zoned_buffered_write_iomap_begin(inode, offset,
+				count, flags, iomap, srcmap);
+
 	/* we can't use delayed allocations when using extent size hints */
 	if (xfs_get_extsz_hint(ip))
 		return xfs_direct_write_iomap_begin(inode, offset, count,
@@ -1528,10 +1703,13 @@ xfs_buffered_write_delalloc_punch(
 	loff_t			length,
 	struct iomap		*iomap)
 {
+	struct iomap_iter	*iter =
+		container_of(iomap, struct iomap_iter, iomap);
+
 	xfs_bmap_punch_delalloc_range(XFS_I(inode),
 			(iomap->flags & IOMAP_F_SHARED) ?
 				XFS_COW_FORK : XFS_DATA_FORK,
-			offset, offset + length);
+			offset, offset + length, iter->private);
 }
 
 static int
@@ -1768,6 +1946,7 @@ xfs_zero_range(
 	struct xfs_inode	*ip,
 	loff_t			pos,
 	loff_t			len,
+	struct xfs_zone_alloc_ctx *ac,
 	bool			*did_zero)
 {
 	struct inode		*inode = VFS_I(ip);
@@ -1778,13 +1957,14 @@ xfs_zero_range(
 		return dax_zero_range(inode, pos, len, did_zero,
 				      &xfs_dax_write_iomap_ops);
 	return iomap_zero_range(inode, pos, len, did_zero,
-				&xfs_buffered_write_iomap_ops, NULL);
+				&xfs_buffered_write_iomap_ops, ac);
 }
 
 int
 xfs_truncate_page(
 	struct xfs_inode	*ip,
 	loff_t			pos,
+	struct xfs_zone_alloc_ctx *ac,
 	bool			*did_zero)
 {
 	struct inode		*inode = VFS_I(ip);
@@ -1793,5 +1973,5 @@ xfs_truncate_page(
 		return dax_truncate_page(inode, pos, did_zero,
 					&xfs_dax_write_iomap_ops);
 	return iomap_truncate_page(inode, pos, did_zero,
-				   &xfs_buffered_write_iomap_ops, NULL);
+				   &xfs_buffered_write_iomap_ops, ac);
 }
diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index 8347268af727..bc8a00cad854 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -10,6 +10,7 @@
 
 struct xfs_inode;
 struct xfs_bmbt_irec;
+struct xfs_zone_alloc_ctx;
 
 int xfs_iomap_write_direct(struct xfs_inode *ip, xfs_fileoff_t offset_fsb,
 		xfs_fileoff_t count_fsb, unsigned int flags,
@@ -24,8 +25,9 @@ int xfs_bmbt_to_iomap(struct xfs_inode *ip, struct iomap *iomap,
 		u16 iomap_flags, u64 sequence_cookie);
 
 int xfs_zero_range(struct xfs_inode *ip, loff_t pos, loff_t len,
-		bool *did_zero);
-int xfs_truncate_page(struct xfs_inode *ip, loff_t pos, bool *did_zero);
+		struct xfs_zone_alloc_ctx *ac, bool *did_zero);
+int xfs_truncate_page(struct xfs_inode *ip, loff_t pos,
+		struct xfs_zone_alloc_ctx *ac, bool *did_zero);
 
 static inline xfs_filblks_t
 xfs_aligned_fsb_count(
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 990df072ba35..c382f6b6c9e3 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -29,6 +29,7 @@
 #include "xfs_xattr.h"
 #include "xfs_file.h"
 #include "xfs_bmap.h"
+#include "xfs_zone_alloc.h"
 
 #include <linux/posix_acl.h>
 #include <linux/security.h>
@@ -852,6 +853,7 @@ xfs_setattr_size(
 	uint			lock_flags = 0;
 	uint			resblks = 0;
 	bool			did_zeroing = false;
+	struct xfs_zone_alloc_ctx ac = { };
 
 	xfs_assert_ilocked(ip, XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL);
 	ASSERT(S_ISREG(inode->i_mode));
@@ -887,6 +889,28 @@ xfs_setattr_size(
 	 */
 	inode_dio_wait(inode);
 
+	/*
+	 * Normally xfs_zoned_space_reserve is supposed to be called outside the
+	 * IOLOCK.  For truncate we can't do that since ->setattr is called with
+	 * it already held by the VFS.  So for now chicken out and try to
+	 * allocate space under it.
+	 *
+	 * To avoid deadlocks this means we can't block waiting for space, which
+	 * can lead to spurious -ENOSPC if there are no directly available
+	 * blocks.  We mitigate this a bit by allowing zeroing to dip into the
+	 * reserved pool, but eventually the VFS calling convention needs to
+	 * change.
+	 */
+	if (xfs_is_zoned_inode(ip)) {
+		error = xfs_zoned_space_reserve(ip, 1,
+				XFS_ZR_NOWAIT | XFS_ZR_RESERVED, &ac);
+		if (error) {
+			if (error == -EAGAIN)
+				return -ENOSPC;
+			return error;
+		}
+	}
+
 	/*
 	 * File data changes must be complete before we start the transaction to
 	 * modify the inode.  This needs to be done before joining the inode to
@@ -900,11 +924,14 @@ xfs_setattr_size(
 	if (newsize > oldsize) {
 		trace_xfs_zero_eof(ip, oldsize, newsize - oldsize);
 		error = xfs_zero_range(ip, oldsize, newsize - oldsize,
-				&did_zeroing);
+				&ac, &did_zeroing);
 	} else {
-		error = xfs_truncate_page(ip, newsize, &did_zeroing);
+		error = xfs_truncate_page(ip, newsize, &ac, &did_zeroing);
 	}
 
+	if (xfs_is_zoned_inode(ip))
+		xfs_zoned_space_unreserve(ip, &ac);
+
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index b7dba5ad2f34..b8e55c3badfb 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1538,7 +1538,7 @@ xfs_reflink_zero_posteof(
 		return 0;
 
 	trace_xfs_zero_eof(ip, isize, pos - isize);
-	return xfs_zero_range(ip, isize, pos - isize, NULL);
+	return xfs_zero_range(ip, isize, pos - isize, NULL, NULL);
 }
 
 /*
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index bbaf9b2665c7..c03ec9bfec1f 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1694,6 +1694,7 @@ DEFINE_SIMPLE_IO_EVENT(xfs_end_io_direct_write);
 DEFINE_SIMPLE_IO_EVENT(xfs_end_io_direct_write_unwritten);
 DEFINE_SIMPLE_IO_EVENT(xfs_end_io_direct_write_append);
 DEFINE_SIMPLE_IO_EVENT(xfs_file_splice_read);
+DEFINE_SIMPLE_IO_EVENT(xfs_zoned_map_blocks);
 
 DECLARE_EVENT_CLASS(xfs_itrunc_class,
 	TP_PROTO(struct xfs_inode *ip, xfs_fsize_t new_size),
-- 
2.45.2


