Return-Path: <linux-xfs+bounces-13127-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DB07983F7A
	for <lists+linux-xfs@lfdr.de>; Tue, 24 Sep 2024 09:42:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 54197281F74
	for <lists+linux-xfs@lfdr.de>; Tue, 24 Sep 2024 07:42:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74C1D14A084;
	Tue, 24 Sep 2024 07:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="j5v3J2X6"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1FBE1487DC;
	Tue, 24 Sep 2024 07:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727163702; cv=none; b=Cx9oegnWuz/5qtoKb9c/03aewR5/iwQqvkGMu3Qzh5yKKhAS18513N9RtY4JU6QNTERhVWSpkS8o2yCLmHe6s2zdmN0DseFnjNoi4W5mXdEKgGDAXm4ObbSKhI+Vh8Hy5aw9b8re8dTEoIFfpO3Wuo8OqqeATSxOqT1JHkdj5Ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727163702; c=relaxed/simple;
	bh=V9Jz/6LVLpqA/dtultxlwZ9m1FcOSqUllqpPGWGDT9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rQzOrHYEJ47KBU8Xfz5hIXIhud+1HufvZ1N+S/njmZ84m7gYVb2PYw6eJKTSRa+8bSukUvl4uOg6K7dj4q6c0EGB3BHKO6Q0sgwx5QH4gsYxThKv50RfcasoQh042NeOwQOLbcxlyCk2QXBG3hjazKFlZkiu3PCtFEeRYati34Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=j5v3J2X6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=OwCqzl82yaTEWOGRQclLTI1lTfAlTt+iwgHf0T8p794=; b=j5v3J2X6k+RdRLSZWMM2+MPPzP
	rtUIJTmKl6HEkvT0SjuMfM9sXZEsS34bfl2Rckh+PVQzh1CmY0i0lh+kPmCQVGOpDnurZ3hQOtJQs
	4JPx6qa8QI5ll5F2nJoAKHKeb5s2k/zZrOxdzd32zXHnOAhpGK9xupi4U1tO1De3p+HaOALqkTdWy
	vNUFizXBqO8MRtF0DW3jvUkjoK3JYomRUMu43x9uMvrn0rMs3NhrJIEkzM/WNIyWU2qytDHchN6bE
	FdUkUENEu4RbyMUamnu9LGeMY5IsfIwQZNQceIiDaa2CfzN9N4kN57cqtCeZfXHB8GhBq/pbyHY/2
	48dwjvjA==;
Received: from 2a02-8389-2341-5b80-b62d-f525-8e84-d569.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:b62d:f525:8e84:d569] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1st0B1-00000001SML-3Pyt;
	Tue, 24 Sep 2024 07:41:40 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	Carlos Maiolino <cem@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 07/10] xfs: support the COW fork in xfs_bmap_punch_delalloc_range
Date: Tue, 24 Sep 2024 09:40:49 +0200
Message-ID: <20240924074115.1797231-8-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240924074115.1797231-1-hch@lst.de>
References: <20240924074115.1797231-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

xfs_buffered_write_iomap_begin can also create delallocate reservations
that need cleaning up, prepare for that by adding support for the COW
fork in xfs_bmap_punch_delalloc_range.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_aops.c      |  4 ++--
 fs/xfs/xfs_bmap_util.c | 10 +++++++---
 fs/xfs/xfs_bmap_util.h |  2 +-
 fs/xfs/xfs_iomap.c     |  3 ++-
 4 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 6dead20338e24c..559a3a57709748 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -116,7 +116,7 @@ xfs_end_ioend(
 	if (unlikely(error)) {
 		if (ioend->io_flags & IOMAP_F_SHARED) {
 			xfs_reflink_cancel_cow_range(ip, offset, size, true);
-			xfs_bmap_punch_delalloc_range(ip, offset,
+			xfs_bmap_punch_delalloc_range(ip, XFS_DATA_FORK, offset,
 					offset + size);
 		}
 		goto done;
@@ -456,7 +456,7 @@ xfs_discard_folio(
 	 * byte of the next folio. Hence the end offset is only dependent on the
 	 * folio itself and not the start offset that is passed in.
 	 */
-	xfs_bmap_punch_delalloc_range(ip, pos,
+	xfs_bmap_punch_delalloc_range(ip, XFS_DATA_FORK, pos,
 				folio_pos(folio) + folio_size(folio));
 }
 
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 053d567c910840..4719ec90029cb7 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -442,11 +442,12 @@ xfs_getbmap(
 void
 xfs_bmap_punch_delalloc_range(
 	struct xfs_inode	*ip,
+	int			whichfork,
 	xfs_off_t		start_byte,
 	xfs_off_t		end_byte)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_ifork	*ifp = &ip->i_df;
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 	xfs_fileoff_t		start_fsb = XFS_B_TO_FSBT(mp, start_byte);
 	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, end_byte);
 	struct xfs_bmbt_irec	got, del;
@@ -474,11 +475,14 @@ xfs_bmap_punch_delalloc_range(
 			continue;
 		}
 
-		xfs_bmap_del_extent_delay(ip, XFS_DATA_FORK, &icur, &got, &del);
+		xfs_bmap_del_extent_delay(ip, whichfork, &icur, &got, &del);
 		if (!xfs_iext_get_extent(ifp, &icur, &got))
 			break;
 	}
 
+	if (whichfork == XFS_COW_FORK && !ifp->if_bytes)
+		xfs_inode_clear_cowblocks_tag(ip);
+
 out_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 }
@@ -580,7 +584,7 @@ xfs_free_eofblocks(
 	 */
 	if (ip->i_diflags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)) {
 		if (ip->i_delayed_blks) {
-			xfs_bmap_punch_delalloc_range(ip,
+			xfs_bmap_punch_delalloc_range(ip, XFS_DATA_FORK,
 				round_up(XFS_ISIZE(ip), mp->m_sb.sb_blocksize),
 				LLONG_MAX);
 		}
diff --git a/fs/xfs/xfs_bmap_util.h b/fs/xfs/xfs_bmap_util.h
index eb0895bfb9dae4..b29760d36e1ab1 100644
--- a/fs/xfs/xfs_bmap_util.h
+++ b/fs/xfs/xfs_bmap_util.h
@@ -30,7 +30,7 @@ xfs_bmap_rtalloc(struct xfs_bmalloca *ap)
 }
 #endif /* CONFIG_XFS_RT */
 
-void	xfs_bmap_punch_delalloc_range(struct xfs_inode *ip,
+void	xfs_bmap_punch_delalloc_range(struct xfs_inode *ip, int whichfork,
 		xfs_off_t start_byte, xfs_off_t end_byte);
 
 struct kgetbmap {
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 0f5fa3de6d3ecc..abc3b9f1115ce7 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1215,7 +1215,8 @@ xfs_buffered_write_delalloc_punch(
 	loff_t			length,
 	struct iomap		*iomap)
 {
-	xfs_bmap_punch_delalloc_range(XFS_I(inode), offset, offset + length);
+	xfs_bmap_punch_delalloc_range(XFS_I(inode), XFS_DATA_FORK, offset,
+			offset + length);
 }
 
 static int
-- 
2.45.2


