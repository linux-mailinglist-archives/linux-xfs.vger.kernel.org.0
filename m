Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED61650C32
	for <lists+linux-xfs@lfdr.de>; Mon, 24 Jun 2019 15:43:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728933AbfFXNnU (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 24 Jun 2019 09:43:20 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:38530 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729607AbfFXNnU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 09:43:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=xuz8htDajqDj6rm1owXRxsH3d3FZGi2klv1VrBcKiFo=; b=ZeafQoLNFcJCRnPDoDdShQ7Nvb
        fwcFokryR+DBangreuIK2LhJfAf9j5ht8OtigwUJYiXxJhUCZdBcPLm9+ut3xQpw4l0m/GXi9e5aJ
        lxWSMjUe16hapG9yLsafHWD6ezYu5eTiMl7TUVi35Vdi8OUV/K5K9BOXxjuil/6HPqwyshvPI5YBe
        X7ZMJjMoJ3/xjIlAsxzeZF3mhu11wuf+vyOkVwvGGEZi1HMfHtZVbVTRHERVjo0HQyT6YL/7odBfB
        kNk764vjariig76o1zihfvfWSVOwTThz/J5ZZ5xnEUY1DW1bzFAp5+sSfIE9bikSFJJuBWi7NshL+
        61QmAONA==;
Received: from clnet-p19-102.ikbnet.co.at ([83.175.77.102] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hfPFf-00079P-Ov; Mon, 24 Jun 2019 13:43:20 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: [PATCH 1/2] xfs: simplify xfs_chain_bio
Date:   Mon, 24 Jun 2019 15:43:14 +0200
Message-Id: <20190624134315.21307-2-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190624134315.21307-1-hch@lst.de>
References: <20190624134315.21307-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Move setting up operation and write hint to xfs_alloc_ioend, and
then just copy over all needed information from the previous bio
in xfs_chain_bio and stop passing various parameters to it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c | 35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index a6f0f4761a37..9cceb90e77c5 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -665,7 +665,6 @@ xfs_submit_ioend(
 
 	ioend->io_bio->bi_private = ioend;
 	ioend->io_bio->bi_end_io = xfs_end_bio;
-	ioend->io_bio->bi_opf = REQ_OP_WRITE | wbc_to_write_flags(wbc);
 
 	/*
 	 * If we are failing the IO now, just mark the ioend with an
@@ -679,7 +678,6 @@ xfs_submit_ioend(
 		return status;
 	}
 
-	ioend->io_bio->bi_write_hint = ioend->io_inode->i_write_hint;
 	submit_bio(ioend->io_bio);
 	return 0;
 }
@@ -691,7 +689,8 @@ xfs_alloc_ioend(
 	xfs_exntst_t		state,
 	xfs_off_t		offset,
 	struct block_device	*bdev,
-	sector_t		sector)
+	sector_t		sector,
+	struct writeback_control *wbc)
 {
 	struct xfs_ioend	*ioend;
 	struct bio		*bio;
@@ -699,6 +698,8 @@ xfs_alloc_ioend(
 	bio = bio_alloc_bioset(GFP_NOFS, BIO_MAX_PAGES, &xfs_ioend_bioset);
 	bio_set_dev(bio, bdev);
 	bio->bi_iter.bi_sector = sector;
+	bio->bi_opf = REQ_OP_WRITE | wbc_to_write_flags(wbc);
+	bio->bi_write_hint = inode->i_write_hint;
 
 	ioend = container_of(bio, struct xfs_ioend, io_inline_bio);
 	INIT_LIST_HEAD(&ioend->io_list);
@@ -719,24 +720,22 @@ xfs_alloc_ioend(
  * so that the bi_private linkage is set up in the right direction for the
  * traversal in xfs_destroy_ioend().
  */
-static void
+static struct bio *
 xfs_chain_bio(
-	struct xfs_ioend	*ioend,
-	struct writeback_control *wbc,
-	struct block_device	*bdev,
-	sector_t		sector)
+	struct bio		*prev)
 {
 	struct bio *new;
 
 	new = bio_alloc(GFP_NOFS, BIO_MAX_PAGES);
-	bio_set_dev(new, bdev);
-	new->bi_iter.bi_sector = sector;
-	bio_chain(ioend->io_bio, new);
-	bio_get(ioend->io_bio);		/* for xfs_destroy_ioend */
-	ioend->io_bio->bi_opf = REQ_OP_WRITE | wbc_to_write_flags(wbc);
-	ioend->io_bio->bi_write_hint = ioend->io_inode->i_write_hint;
-	submit_bio(ioend->io_bio);
-	ioend->io_bio = new;
+	bio_copy_dev(new, prev);
+	new->bi_iter.bi_sector = bio_end_sector(prev);
+	new->bi_opf = prev->bi_opf;
+	new->bi_write_hint = prev->bi_write_hint;
+
+	bio_chain(prev, new);
+	bio_get(prev);		/* for xfs_destroy_ioend */
+	submit_bio(prev);
+	return new;
 }
 
 /*
@@ -771,14 +770,14 @@ xfs_add_to_ioend(
 		if (wpc->ioend)
 			list_add(&wpc->ioend->io_list, iolist);
 		wpc->ioend = xfs_alloc_ioend(inode, wpc->fork,
-				wpc->imap.br_state, offset, bdev, sector);
+				wpc->imap.br_state, offset, bdev, sector, wbc);
 	}
 
 	if (!__bio_try_merge_page(wpc->ioend->io_bio, page, len, poff, true)) {
 		if (iop)
 			atomic_inc(&iop->write_count);
 		if (bio_full(wpc->ioend->io_bio))
-			xfs_chain_bio(wpc->ioend, wbc, bdev, sector);
+			wpc->ioend->io_bio = xfs_chain_bio(wpc->ioend->io_bio);
 		bio_add_page(wpc->ioend->io_bio, page, len, poff);
 	}
 
-- 
2.20.1

