Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA423647B
	for <lists+linux-xfs@lfdr.de>; Wed,  5 Jun 2019 21:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbfFETQ2 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 5 Jun 2019 15:16:28 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:59754 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbfFETQ1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jun 2019 15:16:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=HBfWWPkgauamUKKVDRP4AP/vcTn8bpF+z3xQ7zG+a6c=; b=mkQ2LKWT9OP2E8rKmjjqMmsJHD
        Fe8zm4fYHu0AgRlXUCQQovd47A3M/apC/wH16+wPOkaAoWD1kwwAANpePXpuacriBu0OceNkBd6oe
        eSiras2BKNLORd4JKTOKDlVJPaFP+fZ5viapA0Zp26jrd1g+EooZemq4FowylSo77ecbqLEcMZvZS
        cmfnzl7E1dep98eGxrdOJeiMSeuexIjI0DtobJBOMlRr3us1V7eKFEthz+N+t+AwQ0DdmBJggcHOe
        hvioS7MSmxGnQxj97G9BqQufINd+8j8UoQflQBP/uOBkKZ+7o+GasUwcSYCvcoxQWRiKSCxtabNdX
        EW5pXc6g==;
Received: from 089144193064.atnat0002.highway.a1.net ([89.144.193.64] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hYbOd-0002FX-0a; Wed, 05 Jun 2019 19:16:27 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 23/24] xfs: remove the b_io_length field in struct xfs_buf
Date:   Wed,  5 Jun 2019 21:15:10 +0200
Message-Id: <20190605191511.32695-24-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190605191511.32695-1-hch@lst.de>
References: <20190605191511.32695-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This field is now always idential to b_length.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.c         | 5 ++---
 fs/xfs/xfs_buf.h         | 1 -
 fs/xfs/xfs_log_recover.c | 9 ++++-----
 3 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 68444d20d2ed..26027a93bdd3 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -263,7 +263,6 @@ _xfs_buf_alloc(
 		bp->b_maps[i].bm_len = map[i].bm_len;
 		bp->b_length += map[i].bm_len;
 	}
-	bp->b_io_length = bp->b_length;
 
 	atomic_set(&bp->b_pin_count, 0);
 	init_waitqueue_head(&bp->b_waiters);
@@ -1407,7 +1406,7 @@ _xfs_buf_ioapply(
 	 * subsequent call.
 	 */
 	offset = bp->b_offset;
-	size = BBTOB(bp->b_io_length);
+	size = BBTOB(bp->b_length);
 	blk_start_plug(&plug);
 	for (i = 0; i < bp->b_map_count; i++) {
 		xfs_buf_ioapply_map(bp, i, &offset, &size, op, op_flags);
@@ -1545,7 +1544,7 @@ xfs_buf_iomove(
 		page_offset = (boff + bp->b_offset) & ~PAGE_MASK;
 		page = bp->b_pages[page_index];
 		csize = min_t(size_t, PAGE_SIZE - page_offset,
-				      BBTOB(bp->b_io_length) - boff);
+				      BBTOB(bp->b_length) - boff);
 
 		ASSERT((csize + page_offset) <= PAGE_SIZE);
 
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 2abd2435d6aa..f95cf810126e 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -164,7 +164,6 @@ typedef struct xfs_buf {
 	struct xfs_buf_map	*b_maps;	/* compound buffer map */
 	struct xfs_buf_map	__b_map;	/* inline compound buffer map */
 	int			b_map_count;
-	int			b_io_length;	/* IO size in BBs */
 	atomic_t		b_pin_count;	/* pin count */
 	atomic_t		b_io_remaining;	/* #outstanding I/O requests */
 	unsigned int		b_page_count;	/* size of page array */
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 403c2c96ed71..bbe5e38e2932 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2086,7 +2086,7 @@ xlog_recover_do_inode_buffer(
 	if (xfs_sb_version_hascrc(&mp->m_sb))
 		bp->b_ops = &xfs_inode_buf_ops;
 
-	inodes_per_buf = BBTOB(bp->b_io_length) >> mp->m_sb.sb_inodelog;
+	inodes_per_buf = BBTOB(bp->b_length) >> mp->m_sb.sb_inodelog;
 	for (i = 0; i < inodes_per_buf; i++) {
 		next_unlinked_offset = (i * mp->m_sb.sb_inodesize) +
 			offsetof(xfs_dinode_t, di_next_unlinked);
@@ -2128,8 +2128,7 @@ xlog_recover_do_inode_buffer(
 
 		ASSERT(item->ri_buf[item_index].i_addr != NULL);
 		ASSERT((item->ri_buf[item_index].i_len % XFS_BLF_CHUNK) == 0);
-		ASSERT((reg_buf_offset + reg_buf_bytes) <=
-							BBTOB(bp->b_io_length));
+		ASSERT((reg_buf_offset + reg_buf_bytes) <= BBTOB(bp->b_length));
 
 		/*
 		 * The current logged region contains a copy of the
@@ -2594,7 +2593,7 @@ xlog_recover_do_reg_buffer(
 		ASSERT(nbits > 0);
 		ASSERT(item->ri_buf[i].i_addr != NULL);
 		ASSERT(item->ri_buf[i].i_len % XFS_BLF_CHUNK == 0);
-		ASSERT(BBTOB(bp->b_io_length) >=
+		ASSERT(BBTOB(bp->b_length) >=
 		       ((uint)bit << XFS_BLF_SHIFT) + (nbits << XFS_BLF_SHIFT));
 
 		/*
@@ -2817,7 +2816,7 @@ xlog_recover_buffer_pass2(
 	 */
 	if (XFS_DINODE_MAGIC ==
 	    be16_to_cpu(*((__be16 *)xfs_buf_offset(bp, 0))) &&
-	    (BBTOB(bp->b_io_length) != max(log->l_mp->m_sb.sb_blocksize,
+	    (BBTOB(bp->b_length) != max(log->l_mp->m_sb.sb_blocksize,
 			(uint32_t)log->l_mp->m_inode_cluster_size))) {
 		xfs_buf_stale(bp);
 		error = xfs_bwrite(bp);
-- 
2.20.1

