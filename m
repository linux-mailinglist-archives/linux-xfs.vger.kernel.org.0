Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE50D7A3F
	for <lists+linux-xfs@lfdr.de>; Tue, 15 Oct 2019 17:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387485AbfJOPn6 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 15 Oct 2019 11:43:58 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:47974 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733306AbfJOPnz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Oct 2019 11:43:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=jqLd2FX8ncrNCXNwVN2+TR7VhCamerhq7ZlTz0d/1Fc=; b=S8WXb7IcqBuu9isx+miKL/U4cv
        h0a0qopgE9/3uFw/+z2/mCjGSq6Cr8glsuX5VFx9rvL2K4S78I9Me7JH6id7URginDx4EOpi6JVjh
        UCJWOPVTzX/gnHwrVu19tnpZmX0fxTfv4NCiTgPDUXUf4K7VgjOp/OD1lM0MdolUOx2TGs5bNjYas
        fqdStDDERf4YqqZSc2gccnwQ/B7PQnusYmm0zPiPL1ykXIt6Oq7UhBbfnseH163ZCvpNy127XkL8s
        1xG4WKf/WeRc5Ckz1a3OnOWCu2+hKACZxkhlZS4NVCxuNLcmU0gLIM337lO1zn3tTTSDDcQK+o8KA
        XBMnWXsg==;
Received: from [2001:4bb8:18c:d7b:c70:4a89:bc61:3] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iKOzJ-0007uF-Lt; Tue, 15 Oct 2019 15:43:54 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J . Wong" <darrick.wong@oracle.com>
Cc:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 01/12] xfs: initialize iomap->flags in xfs_bmbt_to_iomap
Date:   Tue, 15 Oct 2019 17:43:34 +0200
Message-Id: <20191015154345.13052-2-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191015154345.13052-1-hch@lst.de>
References: <20191015154345.13052-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Currently we don't overwrite the flags field in the iomap in
xfs_bmbt_to_iomap.  This works fine with 0-initialized iomaps on stack,
but is harmful once we want to be able to reuse an iomap in the
writeback code.  Replace the shared paramter with a set of initial
flags an thus ensures the flags field is always reinitialized.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iomap.c | 28 +++++++++++++++++-----------
 fs/xfs/xfs_iomap.h |  2 +-
 fs/xfs/xfs_pnfs.c  |  2 +-
 3 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index f780e223b118..54c9ec7ad337 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -54,7 +54,7 @@ xfs_bmbt_to_iomap(
 	struct xfs_inode	*ip,
 	struct iomap		*iomap,
 	struct xfs_bmbt_irec	*imap,
-	bool			shared)
+	u16			flags)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 
@@ -79,12 +79,11 @@ xfs_bmbt_to_iomap(
 	iomap->length = XFS_FSB_TO_B(mp, imap->br_blockcount);
 	iomap->bdev = xfs_find_bdev_for_inode(VFS_I(ip));
 	iomap->dax_dev = xfs_find_daxdev_for_inode(VFS_I(ip));
+	iomap->flags = flags;
 
 	if (xfs_ipincount(ip) &&
 	    (ip->i_itemp->ili_fsync_fields & ~XFS_ILOG_TIMESTAMP))
 		iomap->flags |= IOMAP_F_DIRTY;
-	if (shared)
-		iomap->flags |= IOMAP_F_SHARED;
 	return 0;
 }
 
@@ -540,6 +539,7 @@ xfs_file_iomap_begin_delay(
 	struct xfs_iext_cursor	icur, ccur;
 	xfs_fsblock_t		prealloc_blocks = 0;
 	bool			eof = false, cow_eof = false, shared = false;
+	u16			iomap_flags = 0;
 	int			whichfork = XFS_DATA_FORK;
 	int			error = 0;
 
@@ -707,7 +707,7 @@ xfs_file_iomap_begin_delay(
 	 * Flag newly allocated delalloc blocks with IOMAP_F_NEW so we punch
 	 * them out if the write happens to fail.
 	 */
-	iomap->flags |= IOMAP_F_NEW;
+	iomap_flags |= IOMAP_F_NEW;
 	trace_xfs_iomap_alloc(ip, offset, count, whichfork,
 			whichfork == XFS_DATA_FORK ? &imap : &cmap);
 done:
@@ -715,14 +715,17 @@ xfs_file_iomap_begin_delay(
 		if (imap.br_startoff > offset_fsb) {
 			xfs_trim_extent(&cmap, offset_fsb,
 					imap.br_startoff - offset_fsb);
-			error = xfs_bmbt_to_iomap(ip, iomap, &cmap, true);
+			error = xfs_bmbt_to_iomap(ip, iomap, &cmap,
+					IOMAP_F_SHARED);
 			goto out_unlock;
 		}
 		/* ensure we only report blocks we have a reservation for */
 		xfs_trim_extent(&imap, cmap.br_startoff, cmap.br_blockcount);
 		shared = true;
 	}
-	error = xfs_bmbt_to_iomap(ip, iomap, &imap, shared);
+	if (shared)
+		iomap_flags |= IOMAP_F_SHARED;
+	error = xfs_bmbt_to_iomap(ip, iomap, &imap, iomap_flags);
 out_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
@@ -930,6 +933,7 @@ xfs_file_iomap_begin(
 	xfs_fileoff_t		offset_fsb, end_fsb;
 	int			nimaps = 1, error = 0;
 	bool			shared = false;
+	u16			iomap_flags = 0;
 	unsigned		lockmode;
 
 	if (XFS_FORCED_SHUTDOWN(mp))
@@ -1045,11 +1049,13 @@ xfs_file_iomap_begin(
 	if (error)
 		return error;
 
-	iomap->flags |= IOMAP_F_NEW;
+	iomap_flags |= IOMAP_F_NEW;
 	trace_xfs_iomap_alloc(ip, offset, length, XFS_DATA_FORK, &imap);
 
 out_finish:
-	return xfs_bmbt_to_iomap(ip, iomap, &imap, shared);
+	if (shared)
+		iomap_flags |= IOMAP_F_SHARED;
+	return xfs_bmbt_to_iomap(ip, iomap, &imap, iomap_flags);
 
 out_found:
 	ASSERT(nimaps);
@@ -1193,7 +1199,7 @@ xfs_seek_iomap_begin(
 		if (data_fsb < cow_fsb + cmap.br_blockcount)
 			end_fsb = min(end_fsb, data_fsb);
 		xfs_trim_extent(&cmap, offset_fsb, end_fsb);
-		error = xfs_bmbt_to_iomap(ip, iomap, &cmap, true);
+		error = xfs_bmbt_to_iomap(ip, iomap, &cmap, IOMAP_F_SHARED);
 		/*
 		 * This is a COW extent, so we must probe the page cache
 		 * because there could be dirty page cache being backed
@@ -1215,7 +1221,7 @@ xfs_seek_iomap_begin(
 	imap.br_state = XFS_EXT_NORM;
 done:
 	xfs_trim_extent(&imap, offset_fsb, end_fsb);
-	error = xfs_bmbt_to_iomap(ip, iomap, &imap, false);
+	error = xfs_bmbt_to_iomap(ip, iomap, &imap, 0);
 out_unlock:
 	xfs_iunlock(ip, lockmode);
 	return error;
@@ -1261,7 +1267,7 @@ xfs_xattr_iomap_begin(
 	if (error)
 		return error;
 	ASSERT(nimaps);
-	return xfs_bmbt_to_iomap(ip, iomap, &imap, false);
+	return xfs_bmbt_to_iomap(ip, iomap, &imap, 0);
 }
 
 const struct iomap_ops xfs_xattr_iomap_ops = {
diff --git a/fs/xfs/xfs_iomap.h b/fs/xfs/xfs_iomap.h
index 5c2f6aa6d78f..71d0ae460c44 100644
--- a/fs/xfs/xfs_iomap.h
+++ b/fs/xfs/xfs_iomap.h
@@ -16,7 +16,7 @@ int xfs_iomap_write_direct(struct xfs_inode *, xfs_off_t, size_t,
 int xfs_iomap_write_unwritten(struct xfs_inode *, xfs_off_t, xfs_off_t, bool);
 
 int xfs_bmbt_to_iomap(struct xfs_inode *, struct iomap *,
-		struct xfs_bmbt_irec *, bool shared);
+		struct xfs_bmbt_irec *, u16);
 xfs_extlen_t xfs_eof_alignment(struct xfs_inode *ip, xfs_extlen_t extsize);
 
 static inline xfs_filblks_t
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index a339bd5fa260..9c96493be9e0 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -178,7 +178,7 @@ xfs_fs_map_blocks(
 	}
 	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
 
-	error = xfs_bmbt_to_iomap(ip, iomap, &imap, false);
+	error = xfs_bmbt_to_iomap(ip, iomap, &imap, 0);
 	*device_generation = mp->m_generation;
 	return error;
 out_unlock:
-- 
2.20.1

