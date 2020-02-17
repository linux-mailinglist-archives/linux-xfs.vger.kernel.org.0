Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCAE9161A8F
	for <lists+linux-xfs@lfdr.de>; Mon, 17 Feb 2020 19:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729705AbgBQSqR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 17 Feb 2020 13:46:17 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:48006 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729402AbgBQSqQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Feb 2020 13:46:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=mqxD9lBY9utiLD/Gv5RY8e+xn8vGdjKkc/ZDF2zMRJo=; b=U3RYpyXF+Nrc4iI+IzimEj4Zj0
        cAIJ1pHGMiygc1Yhf1PNRoB3zlPkZDqQo4LK9WzX5mc2mQl/+XlSWx7cQ0pqUywCTpXq48kh8R8x8
        0msaRzAEczXYLwvRYX75BFYmOojvyZLzWlRU1qrQUIPlB9p0IympsxemGwLWeMqzWV2joWCE7Q0Un
        CuOlF2NUanM9CIU/uItF8a/d+/DN0Jl6CVJrL3QxVWuwG0YCGSu5sfWjWvdEplyigOU1PWTSPybh4
        lI2HpeyJL9ynzP7vT45g1a3Wc/NUOPBV8LTLtGj5m2qLpXkz8fFR3t2C6UcY7s5EMcao5LqO4l0sd
        sNTuwF7Q==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j3lPM-0005Du-HD; Mon, 17 Feb 2020 18:46:16 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     linux-fsdevel@vger.kernel.org
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com,
        linux-xfs@vger.kernel.org
Subject: [PATCH v6 18/19] iomap: Convert from readpages to readahead
Date:   Mon, 17 Feb 2020 10:46:12 -0800
Message-Id: <20200217184613.19668-32-willy@infradead.org>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200217184613.19668-1-willy@infradead.org>
References: <20200217184613.19668-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

Use the new readahead operation in iomap.  Convert XFS and ZoneFS to
use it.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/iomap/buffered-io.c | 91 +++++++++++++++---------------------------
 fs/iomap/trace.h       |  2 +-
 fs/xfs/xfs_aops.c      | 13 +++---
 fs/zonefs/super.c      |  7 ++--
 include/linux/iomap.h  |  3 +-
 5 files changed, 42 insertions(+), 74 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 44303f370b2d..2bfcd5242264 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -214,9 +214,8 @@ iomap_read_end_io(struct bio *bio)
 struct iomap_readpage_ctx {
 	struct page		*cur_page;
 	bool			cur_page_in_bio;
-	bool			is_readahead;
 	struct bio		*bio;
-	struct list_head	*pages;
+	struct readahead_control *rac;
 };
 
 static void
@@ -307,11 +306,11 @@ iomap_readpage_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 		if (ctx->bio)
 			submit_bio(ctx->bio);
 
-		if (ctx->is_readahead) /* same as readahead_gfp_mask */
+		if (ctx->rac) /* same as readahead_gfp_mask */
 			gfp |= __GFP_NORETRY | __GFP_NOWARN;
 		ctx->bio = bio_alloc(gfp, min(BIO_MAX_PAGES, nr_vecs));
 		ctx->bio->bi_opf = REQ_OP_READ;
-		if (ctx->is_readahead)
+		if (ctx->rac)
 			ctx->bio->bi_opf |= REQ_RAHEAD;
 		ctx->bio->bi_iter.bi_sector = sector;
 		bio_set_dev(ctx->bio, iomap->bdev);
@@ -367,36 +366,8 @@ iomap_readpage(struct page *page, const struct iomap_ops *ops)
 }
 EXPORT_SYMBOL_GPL(iomap_readpage);
 
-static struct page *
-iomap_next_page(struct inode *inode, struct list_head *pages, loff_t pos,
-		loff_t length, loff_t *done)
-{
-	while (!list_empty(pages)) {
-		struct page *page = lru_to_page(pages);
-
-		if (page_offset(page) >= (u64)pos + length)
-			break;
-
-		list_del(&page->lru);
-		if (!add_to_page_cache_lru(page, inode->i_mapping, page->index,
-				GFP_NOFS))
-			return page;
-
-		/*
-		 * If we already have a page in the page cache at index we are
-		 * done.  Upper layers don't care if it is uptodate after the
-		 * readpages call itself as every page gets checked again once
-		 * actually needed.
-		 */
-		*done += PAGE_SIZE;
-		put_page(page);
-	}
-
-	return NULL;
-}
-
 static loff_t
-iomap_readpages_actor(struct inode *inode, loff_t pos, loff_t length,
+iomap_readahead_actor(struct inode *inode, loff_t pos, loff_t length,
 		void *data, struct iomap *iomap, struct iomap *srcmap)
 {
 	struct iomap_readpage_ctx *ctx = data;
@@ -404,10 +375,7 @@ iomap_readpages_actor(struct inode *inode, loff_t pos, loff_t length,
 
 	while (done < length) {
 		if (!ctx->cur_page) {
-			ctx->cur_page = iomap_next_page(inode, ctx->pages,
-					pos, length, &done);
-			if (!ctx->cur_page)
-				break;
+			ctx->cur_page = readahead_page(ctx->rac);
 			ctx->cur_page_in_bio = false;
 		}
 		ret = iomap_readpage_actor(inode, pos + done, length - done,
@@ -416,6 +384,7 @@ iomap_readpages_actor(struct inode *inode, loff_t pos, loff_t length,
 			break;
 		done += ret;
 		if (offset_in_page(pos + done) == 0) {
+			readahead_next(ctx->rac);
 			if (!ctx->cur_page_in_bio)
 				unlock_page(ctx->cur_page);
 			put_page(ctx->cur_page);
@@ -426,44 +395,48 @@ iomap_readpages_actor(struct inode *inode, loff_t pos, loff_t length,
 	return done;
 }
 
-int
-iomap_readpages(struct address_space *mapping, struct list_head *pages,
-		unsigned nr_pages, const struct iomap_ops *ops)
+/**
+ * iomap_readahead - Attempt to read pages from a file.
+ * @rac: Describes the pages to be read.
+ * @ops: The operations vector for the filesystem.
+ *
+ * This function is for filesystems to call to implement their readahead
+ * address_space operation.
+ *
+ * Context: The file is pinned by the caller, and the pages to be read are
+ * all locked and have an elevated refcount.  This function will unlock
+ * the pages (once I/O has completed on them, or I/O has been determined to
+ * not be necessary).  It will also decrease the refcount once the pages
+ * have been submitted for I/O.  After this point, the page may be removed
+ * from the page cache, and should not be referenced.
+ */
+void iomap_readahead(struct readahead_control *rac, const struct iomap_ops *ops)
 {
+	struct inode *inode = rac->mapping->host;
 	struct iomap_readpage_ctx ctx = {
-		.pages		= pages,
-		.is_readahead	= true,
+		.rac	= rac,
 	};
-	loff_t pos = page_offset(list_entry(pages->prev, struct page, lru));
-	loff_t last = page_offset(list_entry(pages->next, struct page, lru));
-	loff_t length = last - pos + PAGE_SIZE, ret = 0;
+	loff_t pos = readahead_offset(rac);
+	loff_t length = readahead_length(rac);
 
-	trace_iomap_readpages(mapping->host, nr_pages);
+	trace_iomap_readahead(inode, readahead_count(rac));
 
 	while (length > 0) {
-		ret = iomap_apply(mapping->host, pos, length, 0, ops,
-				&ctx, iomap_readpages_actor);
+		loff_t ret = iomap_apply(inode, pos, length, 0, ops,
+				&ctx, iomap_readahead_actor);
 		if (ret <= 0) {
 			WARN_ON_ONCE(ret == 0);
-			goto done;
+			break;
 		}
 		pos += ret;
 		length -= ret;
 	}
-	ret = 0;
-done:
+
 	if (ctx.bio)
 		submit_bio(ctx.bio);
 	BUG_ON(ctx.cur_page);
-
-	/*
-	 * Check that we didn't lose a page due to the arcance calling
-	 * conventions..
-	 */
-	WARN_ON_ONCE(!ret && !list_empty(ctx.pages));
-	return ret;
 }
-EXPORT_SYMBOL_GPL(iomap_readpages);
+EXPORT_SYMBOL_GPL(iomap_readahead);
 
 /*
  * iomap_is_partially_uptodate checks whether blocks within a page are
diff --git a/fs/iomap/trace.h b/fs/iomap/trace.h
index 6dc227b8c47e..d6ba705f938a 100644
--- a/fs/iomap/trace.h
+++ b/fs/iomap/trace.h
@@ -39,7 +39,7 @@ DEFINE_EVENT(iomap_readpage_class, name,	\
 	TP_PROTO(struct inode *inode, int nr_pages), \
 	TP_ARGS(inode, nr_pages))
 DEFINE_READPAGE_EVENT(iomap_readpage);
-DEFINE_READPAGE_EVENT(iomap_readpages);
+DEFINE_READPAGE_EVENT(iomap_readahead);
 
 DECLARE_EVENT_CLASS(iomap_page_class,
 	TP_PROTO(struct inode *inode, struct page *page, unsigned long off,
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 58e937be24ce..6e68eeb50b07 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -621,14 +621,11 @@ xfs_vm_readpage(
 	return iomap_readpage(page, &xfs_read_iomap_ops);
 }
 
-STATIC int
-xfs_vm_readpages(
-	struct file		*unused,
-	struct address_space	*mapping,
-	struct list_head	*pages,
-	unsigned		nr_pages)
+STATIC void
+xfs_vm_readahead(
+	struct readahead_control	*rac)
 {
-	return iomap_readpages(mapping, pages, nr_pages, &xfs_read_iomap_ops);
+	iomap_readahead(rac, &xfs_read_iomap_ops);
 }
 
 static int
@@ -644,7 +641,7 @@ xfs_iomap_swapfile_activate(
 
 const struct address_space_operations xfs_address_space_operations = {
 	.readpage		= xfs_vm_readpage,
-	.readpages		= xfs_vm_readpages,
+	.readahead		= xfs_vm_readahead,
 	.writepage		= xfs_vm_writepage,
 	.writepages		= xfs_vm_writepages,
 	.set_page_dirty		= iomap_set_page_dirty,
diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
index 8bc6ef82d693..8327a01d3bac 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -78,10 +78,9 @@ static int zonefs_readpage(struct file *unused, struct page *page)
 	return iomap_readpage(page, &zonefs_iomap_ops);
 }
 
-static int zonefs_readpages(struct file *unused, struct address_space *mapping,
-			    struct list_head *pages, unsigned int nr_pages)
+static void zonefs_readahead(struct readahead_control *rac)
 {
-	return iomap_readpages(mapping, pages, nr_pages, &zonefs_iomap_ops);
+	iomap_readahead(rac, &zonefs_iomap_ops);
 }
 
 /*
@@ -128,7 +127,7 @@ static int zonefs_writepages(struct address_space *mapping,
 
 static const struct address_space_operations zonefs_file_aops = {
 	.readpage		= zonefs_readpage,
-	.readpages		= zonefs_readpages,
+	.readahead		= zonefs_readahead,
 	.writepage		= zonefs_writepage,
 	.writepages		= zonefs_writepages,
 	.set_page_dirty		= iomap_set_page_dirty,
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 8b09463dae0d..bc20bd04c2a2 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -155,8 +155,7 @@ loff_t iomap_apply(struct inode *inode, loff_t pos, loff_t length,
 ssize_t iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *from,
 		const struct iomap_ops *ops);
 int iomap_readpage(struct page *page, const struct iomap_ops *ops);
-int iomap_readpages(struct address_space *mapping, struct list_head *pages,
-		unsigned nr_pages, const struct iomap_ops *ops);
+void iomap_readahead(struct readahead_control *, const struct iomap_ops *ops);
 int iomap_set_page_dirty(struct page *page);
 int iomap_is_partially_uptodate(struct page *page, unsigned long from,
 		unsigned long count);
-- 
2.25.0

