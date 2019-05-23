Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 820D228524
	for <lists+linux-xfs@lfdr.de>; Thu, 23 May 2019 19:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731334AbfEWRlq (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 23 May 2019 13:41:46 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:56360 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731331AbfEWRlq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 May 2019 13:41:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=dNLwC3WQ3fxMdAXrI18eIOquLCx/9VITpeg06zHpm0A=; b=Ao5tdVYJPVAh5TlkS3huCT61g
        5ZbaqptlVqpm6r/oOSGFLgc/371Bv6/rqsL680uHrlr5wLz64+qOeqF+QmQUs7IU5y4UWiHkX3SyE
        6vksKKQKesR5+0jpOZ7/WLg5VPyszuMBmZ6WcObRfcOCAijurxMVVzQpdCuXbZGEMTs+ST0+GvMwG
        aOtCox/slxW9CXpKGGT17d8ZkzFVTIxbKUsa5n/cjdzV1HgzoMPB4SgkHTYf4arl1fnZ6yqIne0tz
        8NhP2Bku7xMFHP0JNGzVjLIfvpl5yUWpwDUj896KsN1jfgzsso8Zmi64DerQjSU17qe89L/wX8TIh
        eiyZyG8mg==;
Received: from 213-225-10-46.nat.highway.a1.net ([213.225.10.46] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hTrir-0002Ry-8e
        for linux-xfs@vger.kernel.org; Thu, 23 May 2019 17:41:45 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 15/20] xfs: return an offset instead of a pointer from xlog_align
Date:   Thu, 23 May 2019 19:37:37 +0200
Message-Id: <20190523173742.15551-16-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190523173742.15551-1-hch@lst.de>
References: <20190523173742.15551-1-hch@lst.de>
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
index 4139b907e9cd..74fd3784bcb7 100644
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

