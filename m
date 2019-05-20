Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B32423D0A
	for <lists+linux-xfs@lfdr.de>; Mon, 20 May 2019 18:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389411AbfETQPU (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 May 2019 12:15:20 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37184 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389410AbfETQPU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 12:15:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ZM4t+ZjUtGvbIOH3EHSRkdb+gwYgbWhgwN2kyn8Aywc=; b=de/pnm1Eq/g2M96nSaLnW2pCq
        GABzdF+cRR+IUSWUQ7JKMUWN6dBFRllIbIWaWpPhMFoQcDtszqbTM9XeG6bwZDzSN0FDh7byFNQ2x
        8w31hrh277/U41iRGJWX82P7uYk3KyLyNiaoreszfbHIN9RsVhpeznhZy2I+mnRGj5rx61Em6unYc
        hILWLnHiDfNWQEN+Cfzy30twULWGyQKnUzpu8bmRW68dX6IaOse0A3GssUsGW7fsUMBKCzVKwB2LT
        PYQpHTe33vEc99Pljbxah6pt10kdEV6sy/Urez7TPV/QrhKkGjf0uZge+1DvzQ7wHpsPWwJcf0DkN
        BBX9UKJJg==;
Received: from 089144206147.atnat0015.highway.bob.at ([89.144.206.147] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hSkwa-0006vv-1r
        for linux-xfs@vger.kernel.org; Mon, 20 May 2019 16:15:20 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 13/17] xfs: return an offset instead of a pointer from xlog_align
Date:   Mon, 20 May 2019 18:13:43 +0200
Message-Id: <20190520161347.3044-14-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190520161347.3044-1-hch@lst.de>
References: <20190520161347.3044-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This simplifies both the helper and the callers.  We lost a bit of
size sanity checking, but that is already covered by KASAN if needed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log_recover.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 39e4f774d355..9519956b1ccf 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -151,20 +151,14 @@ xlog_put_bp(
  * Return the address of the start of the given block number's data
  * in a log buffer.  The buffer covers a log sector-aligned region.
  */
-STATIC char *
+static inline unsigned int
 xlog_align(
 	struct xlog	*log,
-	xfs_daddr_t	blk_no,
-	int		nbblks,
-	struct xfs_buf	*bp)
+	xfs_daddr_t	blk_no)
 {
-	xfs_daddr_t	offset = blk_no & ((xfs_daddr_t)log->l_sectBBsize - 1);
-
-	ASSERT(offset + nbblks <= bp->b_length);
-	return bp->b_addr + BBTOB(offset);
+	return BBTOB(blk_no & ((xfs_daddr_t)log->l_sectBBsize - 1));
 }
 
-
 /*
  * nbblks should be uint, but oh well.  Just want to catch that 32-bit length.
  */
@@ -216,7 +210,7 @@ xlog_bread(
 	if (error)
 		return error;
 
-	*offset = xlog_align(log, blk_no, nbblks, bp);
+	*offset = bp->b_addr + xlog_align(log, blk_no);
 	return 0;
 }
 
@@ -1713,7 +1707,7 @@ xlog_write_log_records(
 
 		}
 
-		offset = xlog_align(log, start_block, endcount, bp);
+		offset = bp->b_addr + xlog_align(log, start_block);
 		for (; j < endcount; j++) {
 			xlog_add_record(log, offset, cycle, i+j,
 					tail_cycle, tail_block);
-- 
2.20.1

