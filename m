Return-Path: <linux-xfs+bounces-566-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B6CDD8081E4
	for <lists+linux-xfs@lfdr.de>; Thu,  7 Dec 2023 08:28:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 394001F220C8
	for <lists+linux-xfs@lfdr.de>; Thu,  7 Dec 2023 07:28:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B86A18040;
	Thu,  7 Dec 2023 07:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qeFFSPoK"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBB1E137;
	Wed,  6 Dec 2023 23:27:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=eP2j69RQkSSBlrpyFkvKUGmppCPnNSlAZvWEq85w0qQ=; b=qeFFSPoKvQ27gdmlEaaIiFWSkn
	w5Jos0UP7Zc8SSjkh4OdiocLaOk8kv2hzdp7lsM7Y2XgPLyTa4sF/NtA4VJu0Y6xh8FPLdl/rIZxX
	Tqyqrq6qxP4tkdtxn4YILtqUeQojcEwN2VAhm/Sm6fRMTNxsU2rtHHIKurqDkBdsOWAVcQeIXgaFR
	bqSvtKs7xkoLYAzBkyxK+2oYM0QpwPlC1UpJjpfCY/amDchRnhmWJf4haXHDlgjRo8B5mUtees6GB
	EAjWYHWyHFgIPMapBKPZSW3gKP6Dwgz/CwVnRBlQUDCfgzAjyZg/rBYWbtMOuJ14aivRKMKe9SHYh
	d4IhoQIA==;
Received: from [2001:4bb8:191:e7ca:4bf6:cea4:9bbf:8b02] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rB8nO-00C528-0c;
	Thu, 07 Dec 2023 07:27:42 +0000
From: Christoph Hellwig <hch@lst.de>
To: Christian Brauner <brauner@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Zhang Yi <yi.zhang@huaweicloud.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <jth@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-block@vger.kernel.org,
	gfs2@lists.linux.dev
Subject: [PATCH 09/14] iomap: don't chain bios
Date: Thu,  7 Dec 2023 08:27:05 +0100
Message-Id: <20231207072710.176093-10-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231207072710.176093-1-hch@lst.de>
References: <20231207072710.176093-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Back in the days when a single bio could only be filled to the hardware
limits, and we scheduled a work item for each bio completion, chaining
multiple bios for a single ioend made a lot of sense to reduce the number
of completions.  But these days bios can be filled until we reach the
number of vectors or total size limit, which means we can always fit at
least 1 megabyte worth of data in the worst case, but usually a lot more
due to large folios.  The only thing bio chaining is buying us now is
to reduce the size of the allocation from an ioend with an embedded bio
into a plain bio, which is a 52 bytes differences on 64-bit systems.

This is not worth the added complexity, so remove the bio chaining and
only use the bio embedded into the ioend.  This will help to simplify
further changes to the iomap writeback code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/iomap/buffered-io.c | 90 +++++++++++-------------------------------
 fs/xfs/xfs_aops.c      |  6 +--
 include/linux/iomap.h  |  8 +++-
 3 files changed, 32 insertions(+), 72 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 78cd5c06ea9b77..7ed11eca7c7c9e 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1489,40 +1489,23 @@ static u32
 iomap_finish_ioend(struct iomap_ioend *ioend, int error)
 {
 	struct inode *inode = ioend->io_inode;
-	struct bio *bio = &ioend->io_inline_bio;
-	struct bio *last = ioend->io_bio, *next;
-	u64 start = bio->bi_iter.bi_sector;
-	loff_t offset = ioend->io_offset;
-	bool quiet = bio_flagged(bio, BIO_QUIET);
+	struct bio *bio = &ioend->io_bio;
+	struct folio_iter fi;
 	u32 folio_count = 0;
 
-	for (bio = &ioend->io_inline_bio; bio; bio = next) {
-		struct folio_iter fi;
-
-		/*
-		 * For the last bio, bi_private points to the ioend, so we
-		 * need to explicitly end the iteration here.
-		 */
-		if (bio == last)
-			next = NULL;
-		else
-			next = bio->bi_private;
-
-		/* walk all folios in bio, ending page IO on them */
-		bio_for_each_folio_all(fi, bio) {
-			iomap_finish_folio_write(inode, fi.folio, fi.length,
-					error);
-			folio_count++;
-		}
-		bio_put(bio);
+	/* walk all folios in bio, ending page IO on them */
+	bio_for_each_folio_all(fi, bio) {
+		iomap_finish_folio_write(inode, fi.folio, fi.length, error);
+		folio_count++;
 	}
-	/* The ioend has been freed by bio_put() */
 
-	if (unlikely(error && !quiet)) {
+	if (unlikely(error && !bio_flagged(bio, BIO_QUIET))) {
 		printk_ratelimited(KERN_ERR
 "%s: writeback error on inode %lu, offset %lld, sector %llu",
-			inode->i_sb->s_id, inode->i_ino, offset, start);
+			inode->i_sb->s_id, inode->i_ino,
+			ioend->io_offset, ioend->io_sector);
 	}
+	bio_put(bio);	/* frees the ioend */
 	return folio_count;
 }
 
@@ -1563,7 +1546,7 @@ EXPORT_SYMBOL_GPL(iomap_finish_ioends);
 static bool
 iomap_ioend_can_merge(struct iomap_ioend *ioend, struct iomap_ioend *next)
 {
-	if (ioend->io_bio->bi_status != next->io_bio->bi_status)
+	if (ioend->io_bio.bi_status != next->io_bio.bi_status)
 		return false;
 	if ((ioend->io_flags & IOMAP_F_SHARED) ^
 	    (next->io_flags & IOMAP_F_SHARED))
@@ -1628,9 +1611,8 @@ EXPORT_SYMBOL_GPL(iomap_sort_ioends);
 
 static void iomap_writepage_end_bio(struct bio *bio)
 {
-	struct iomap_ioend *ioend = bio->bi_private;
-
-	iomap_finish_ioend(ioend, blk_status_to_errno(bio->bi_status));
+	iomap_finish_ioend(iomap_ioend_from_bio(bio),
+			blk_status_to_errno(bio->bi_status));
 }
 
 /*
@@ -1645,9 +1627,6 @@ static int
 iomap_submit_ioend(struct iomap_writepage_ctx *wpc, struct iomap_ioend *ioend,
 		int error)
 {
-	ioend->io_bio->bi_private = ioend;
-	ioend->io_bio->bi_end_io = iomap_writepage_end_bio;
-
 	if (wpc->ops->prepare_ioend)
 		error = wpc->ops->prepare_ioend(ioend, error);
 	if (error) {
@@ -1657,12 +1636,12 @@ iomap_submit_ioend(struct iomap_writepage_ctx *wpc, struct iomap_ioend *ioend,
 		 * as there is only one reference to the ioend at this point in
 		 * time.
 		 */
-		ioend->io_bio->bi_status = errno_to_blk_status(error);
-		bio_endio(ioend->io_bio);
+		ioend->io_bio.bi_status = errno_to_blk_status(error);
+		bio_endio(&ioend->io_bio);
 		return error;
 	}
 
-	submit_bio(ioend->io_bio);
+	submit_bio(&ioend->io_bio);
 	return 0;
 }
 
@@ -1676,44 +1655,22 @@ static struct iomap_ioend *iomap_alloc_ioend(struct iomap_writepage_ctx *wpc,
 			       REQ_OP_WRITE | wbc_to_write_flags(wbc),
 			       GFP_NOFS, &iomap_ioend_bioset);
 	bio->bi_iter.bi_sector = iomap_sector(&wpc->iomap, pos);
+	bio->bi_end_io = iomap_writepage_end_bio;
 	wbc_init_bio(wbc, bio);
 
-	ioend = container_of(bio, struct iomap_ioend, io_inline_bio);
+	ioend = iomap_ioend_from_bio(bio);
 	INIT_LIST_HEAD(&ioend->io_list);
 	ioend->io_type = wpc->iomap.type;
 	ioend->io_flags = wpc->iomap.flags;
 	ioend->io_inode = inode;
 	ioend->io_size = 0;
 	ioend->io_offset = pos;
-	ioend->io_bio = bio;
 	ioend->io_sector = bio->bi_iter.bi_sector;
 
 	wpc->nr_folios = 0;
 	return ioend;
 }
 
-/*
- * Allocate a new bio, and chain the old bio to the new one.
- *
- * Note that we have to perform the chaining in this unintuitive order
- * so that the bi_private linkage is set up in the right direction for the
- * traversal in iomap_finish_ioend().
- */
-static struct bio *
-iomap_chain_bio(struct bio *prev)
-{
-	struct bio *new;
-
-	new = bio_alloc(prev->bi_bdev, BIO_MAX_VECS, prev->bi_opf, GFP_NOFS);
-	bio_clone_blkg_association(new, prev);
-	new->bi_iter.bi_sector = bio_end_sector(prev);
-
-	bio_chain(prev, new);
-	bio_get(prev);		/* for iomap_finish_ioend */
-	submit_bio(prev);
-	return new;
-}
-
 static bool iomap_can_add_to_ioend(struct iomap_writepage_ctx *wpc, loff_t pos)
 {
 	if ((wpc->iomap.flags & IOMAP_F_SHARED) !=
@@ -1724,7 +1681,7 @@ static bool iomap_can_add_to_ioend(struct iomap_writepage_ctx *wpc, loff_t pos)
 	if (pos != wpc->ioend->io_offset + wpc->ioend->io_size)
 		return false;
 	if (iomap_sector(&wpc->iomap, pos) !=
-	    bio_end_sector(wpc->ioend->io_bio))
+	    bio_end_sector(&wpc->ioend->io_bio))
 		return false;
 	/*
 	 * Limit ioend bio chain lengths to minimise IO completion latency. This
@@ -1749,15 +1706,14 @@ static void iomap_add_to_ioend(struct iomap_writepage_ctx *wpc,
 	size_t poff = offset_in_folio(folio, pos);
 
 	if (!wpc->ioend || !iomap_can_add_to_ioend(wpc, pos)) {
+new_ioend:
 		if (wpc->ioend)
 			list_add(&wpc->ioend->io_list, iolist);
 		wpc->ioend = iomap_alloc_ioend(wpc, wbc, inode, pos);
 	}
 
-	if (!bio_add_folio(wpc->ioend->io_bio, folio, len, poff)) {
-		wpc->ioend->io_bio = iomap_chain_bio(wpc->ioend->io_bio);
-		bio_add_folio_nofail(wpc->ioend->io_bio, folio, len, poff);
-	}
+	if (!bio_add_folio(&wpc->ioend->io_bio, folio, len, poff))
+		goto new_ioend;
 
 	if (ifs)
 		atomic_add(len, &ifs->write_bytes_pending);
@@ -1988,7 +1944,7 @@ EXPORT_SYMBOL_GPL(iomap_writepages);
 static int __init iomap_init(void)
 {
 	return bioset_init(&iomap_ioend_bioset, 4 * (PAGE_SIZE / SECTOR_SIZE),
-			   offsetof(struct iomap_ioend, io_inline_bio),
+			   offsetof(struct iomap_ioend, io_bio),
 			   BIOSET_NEED_BVECS);
 }
 fs_initcall(iomap_init);
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 465d7630bb2185..b45ee6cbbdaab2 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -112,7 +112,7 @@ xfs_end_ioend(
 	 * longer dirty. If we don't remove delalloc blocks here, they become
 	 * stale and can corrupt free space accounting on unmount.
 	 */
-	error = blk_status_to_errno(ioend->io_bio->bi_status);
+	error = blk_status_to_errno(ioend->io_bio.bi_status);
 	if (unlikely(error)) {
 		if (ioend->io_flags & IOMAP_F_SHARED) {
 			xfs_reflink_cancel_cow_range(ip, offset, size, true);
@@ -179,7 +179,7 @@ STATIC void
 xfs_end_bio(
 	struct bio		*bio)
 {
-	struct iomap_ioend	*ioend = bio->bi_private;
+	struct iomap_ioend	*ioend = iomap_ioend_from_bio(bio);
 	struct xfs_inode	*ip = XFS_I(ioend->io_inode);
 	unsigned long		flags;
 
@@ -444,7 +444,7 @@ xfs_prepare_ioend(
 	/* send ioends that might require a transaction to the completion wq */
 	if (xfs_ioend_is_append(ioend) || ioend->io_type == IOMAP_UNWRITTEN ||
 	    (ioend->io_flags & IOMAP_F_SHARED))
-		ioend->io_bio->bi_end_io = xfs_end_bio;
+		ioend->io_bio.bi_end_io = xfs_end_bio;
 	return status;
 }
 
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index b2a05dff914d0c..b8d3b658ad2b03 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -297,10 +297,14 @@ struct iomap_ioend {
 	size_t			io_size;	/* size of the extent */
 	loff_t			io_offset;	/* offset in the file */
 	sector_t		io_sector;	/* start sector of ioend */
-	struct bio		*io_bio;	/* bio being built */
-	struct bio		io_inline_bio;	/* MUST BE LAST! */
+	struct bio		io_bio;		/* MUST BE LAST! */
 };
 
+static inline struct iomap_ioend *iomap_ioend_from_bio(struct bio *bio)
+{
+	return container_of(bio, struct iomap_ioend, io_bio);
+}
+
 struct iomap_writeback_ops {
 	/*
 	 * Required, maps the blocks so that writeback can be performed on
-- 
2.39.2


