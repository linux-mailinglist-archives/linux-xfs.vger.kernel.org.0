Return-Path: <linux-xfs+bounces-20243-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AA53CA465F8
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Feb 2025 17:04:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4DBCD19C7A6A
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Feb 2025 15:53:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 657F921CA09;
	Wed, 26 Feb 2025 15:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fkv5psBs"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5850118DB03
	for <linux-xfs@vger.kernel.org>; Wed, 26 Feb 2025 15:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740585169; cv=none; b=YdA9cfkJPxD6xlqPdFLnNR1Awbz/V3ysSKvAxdD6gLjC//B+0rjxvPcnJff9J2P3rJx9Gn3lg5GQdV75gsjZCuwqa05bgWWmOmt2QGqfYkg6PlCEKvL1oalqkUpujixOmnQtdVS7/XpCOfOPx33tCQ3UcT8hrU8EJRriZC/1jqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740585169; c=relaxed/simple;
	bh=XlIdEUv/YwLp1SLmKAG/B/zi8anv+iIRS4hrqlk1mIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mgcFfvdHTFTTTrOKrW8A4GfHQPG0dWtDJDmbLivNEd44YNtVjoWbMGVr/hPqLhh4xMMLd4nD2kDI/Gp6uUNzlyC3OR7ZXLpmgJKfU88cbMKpNzN3ObOyynB3uKs+IL0wGIAlb6QChr/xJAKpGj+2ObKz5svUvbglApFEMiqyCe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fkv5psBs; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=9+NPKx3NP3m3Fjsf9lqueX0O5QZHvpPlk2Trba14S4c=; b=fkv5psBs5NrY9b2ehFBjqlwRiK
	VxH0/qEldj0hYV4oxyP9hRbQD4Ghsk+LUVCgWoJXgFPykmNUp6I2WYAzw7lIqCaSEuasDlfp/Rv1y
	WJhPg5LqKmIrq5xRux4+mMnKS+ikNfHQwTDPGD5UdbT8uy/qm+0e4P7lIC6IBoK/koo/8gQd0So+G
	2rN5nhGlwK7PC3Uz+4lzfiCGaR3C/8fDU5i9IInG3GDAlNyr1jokJ4j1l05eh0U7+79BxmImGwPCN
	m2Yip6F63IXpiIaUbzYudw8mCXOAcmgAthytK+3tRfGsUttqv2yOoCfxYHfbkblQKiLuq253aN29u
	vJpldoHw==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tnJiI-00000004PMI-3UdB;
	Wed, 26 Feb 2025 15:52:46 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 07/12] xfs: convert buffer cache to use high order folios
Date: Wed, 26 Feb 2025 07:51:35 -0800
Message-ID: <20250226155245.513494-8-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250226155245.513494-1-hch@lst.de>
References: <20250226155245.513494-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Now that we have the buffer cache using the folio API, we can extend
the use of folios to allocate high order folios for multi-page
buffers rather than an array of single pages that are then vmapped
into a contiguous range.

This creates a new type of single folio buffers that can have arbitrary
order in addition to the existing multi-folio buffers made up of many
single page folios that get vmapped.  The single folio is for now
stashed into the existing b_pages array, but that will go away entirely
later in the series and remove the temporary page vs folio typing issues
that only work because the two structures currently can be used largely
interchangeable.

The code that allocates buffers will optimistically attempt a high
order folio allocation as a fast path if the buffer size is a power
of two and thus fits into a folio. If this high order allocation
fails, then we fall back to the existing multi-folio allocation
code. This now forms the slow allocation path, and hopefully will be
largely unused in normal conditions except for buffers with size
that are not a power of two like larger remote xattrs.

This should improve performance of large buffer operations (e.g.
large directory block sizes) as we should now mostly avoid the
expense of vmapping large buffers (and the vmap lock contention that
can occur) as well as avoid the runtime pressure that frequently
accessing kernel vmapped pages put on the TLBs.

Based on a patch from Dave Chinner <dchinner@redhat.com>, but mutilated
beyond recognition.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 58 +++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 52 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index f327bf5b04c0..3c582eaa656d 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -261,9 +261,10 @@ xfs_buf_free_pages(
 
 	for (i = 0; i < bp->b_page_count; i++) {
 		if (bp->b_pages[i])
-			__free_page(bp->b_pages[i]);
+			folio_put(page_folio(bp->b_pages[i]));
 	}
-	mm_account_reclaimed_pages(bp->b_page_count);
+	mm_account_reclaimed_pages(
+			DIV_ROUND_UP(BBTOB(bp->b_length), PAGE_SIZE));
 
 	if (bp->b_pages != bp->b_page_array)
 		kfree(bp->b_pages);
@@ -336,12 +337,17 @@ xfs_buf_alloc_kmem(
  * For tmpfs-backed buffers used by in-memory btrees this directly maps the
  * tmpfs page cache folios.
  *
- * For real file system buffers there are two different kinds backing memory:
+ * For real file system buffers there are three different kinds backing memory:
  *
  * The first type backs the buffer by a kmalloc allocation.  This is done for
  * less than PAGE_SIZE allocations to avoid wasting memory.
  *
- * The second type of buffer is the multi-page buffer. These are always made
+ * The second type is a single folio buffer - this may be a high order folio or
+ * just a single page sized folio, but either way they get treated the same way
+ * by the rest of the code - the buffer memory spans a single contiguous memory
+ * region that we don't have to map and unmap to access the data directly.
+ *
+ * The third type of buffer is the multi-page buffer. These are always made
  * up of single pages so that they can be fed to vmap_ram() to return a
  * contiguous memory region we can access the data through, or mark it as
  * XBF_UNMAPPED and access the data directly through individual page_address()
@@ -354,6 +360,7 @@ xfs_buf_alloc_backing_mem(
 {
 	size_t		size = BBTOB(bp->b_length);
 	gfp_t		gfp_mask = GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOWARN;
+	struct folio	*folio;
 	long		filled = 0;
 
 	if (xfs_buftarg_is_mem(bp->b_target))
@@ -375,7 +382,46 @@ xfs_buf_alloc_backing_mem(
 	if (size < PAGE_SIZE && is_power_of_2(size))
 		return xfs_buf_alloc_kmem(bp, size, gfp_mask);
 
-	/* Make sure that we have a page list */
+	/* Assure zeroed buffer for non-read cases. */
+	if (!(flags & XBF_READ))
+		gfp_mask |= __GFP_ZERO;
+
+	/*
+	 * Don't bother with the retry loop for single PAGE allocations, there
+	 * is litte changes this can be better than the VM version.
+	 */
+	if (size <= PAGE_SIZE)
+		gfp_mask |= __GFP_NOFAIL;
+
+	/*
+	 * Optimistically attempt a single high order folio allocation for
+	 * larger than PAGE_SIZE buffers.
+	 *
+	 * Allocating a high order folio makes the assumption that buffers are a
+	 * power-of-2 size, matching the power-of-2 folios sizes available.
+	 *
+	 * The exception here are user xattr data buffers, which can be arbitrarily
+	 * sized up to 64kB plus structure metadata, skip straight to the vmalloc
+	 * path for them instead of wasting memory.
+	 * here.
+	 */
+	if (size > PAGE_SIZE && !is_power_of_2(size))
+		goto fallback;
+	folio = folio_alloc(gfp_mask, get_order(size));
+	if (!folio) {
+		if (size <= PAGE_SIZE)
+			return -ENOMEM;
+		goto fallback;
+	}
+	bp->b_addr = folio_address(folio);
+	bp->b_page_array[0] = &folio->page;
+	bp->b_pages = bp->b_page_array;
+	bp->b_page_count = 1;
+	bp->b_flags |= _XBF_PAGES;
+	return 0;
+
+fallback:
+	/* Fall back to allocating an array of single page folios. */
 	bp->b_page_count = DIV_ROUND_UP(size, PAGE_SIZE);
 	if (bp->b_page_count <= XB_PAGES) {
 		bp->b_pages = bp->b_page_array;
@@ -1529,7 +1575,7 @@ xfs_buf_submit_bio(
 	bio->bi_private = bp;
 	bio->bi_end_io = xfs_buf_bio_end_io;
 
-	if (bp->b_flags & _XBF_KMEM) {
+	if (bp->b_page_count == 1) {
 		__bio_add_page(bio, virt_to_page(bp->b_addr), size,
 				offset_in_page(bp->b_addr));
 	} else {
-- 
2.45.2


