Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B808736466
	for <lists+linux-xfs@lfdr.de>; Wed,  5 Jun 2019 21:15:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbfFETP0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 5 Jun 2019 15:15:26 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:59658 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbfFETP0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jun 2019 15:15:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=TNYmELpVv67YkghvjpAjrVehuBVyBSeU02N5VZ0JS74=; b=tU7m8ja9oDydDqFpEB7/u53c7a
        BTioW20qknUXjpv5SA4B1pOCYKyozxMMgyUN6fkklrC7/OF/I6yjrDhly5iNw/QdSnyIpw8z3B4Ic
        KLWbz57GJaGznWzFnwqQvMTJaJQpWh4vKew9P5ulEKpQWqSAuMEkEjSj6f9tm/6S5YaashIT136KF
        ngNlH1vLqgZVsyOlukz4ZqY+YH+CKc8YCu73P0Sjp3LlXoFf+XJ27IN4URsdavH32mXugZ8Om4dgg
        2jVKSWoeKzK8o+X9wdFtyxGCaNTwvOo+ZxOP4Lo7C/qoaKY1t5uNX6byXcNiAqI8pOYtFfoSsrBTQ
        AtI2g6IQ==;
Received: from 089144193064.atnat0002.highway.a1.net ([89.144.193.64] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hYbNd-0002BQ-Cf; Wed, 05 Jun 2019 19:15:25 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 04/24] xfs: make mem_to_page available outside of xfs_buf.c
Date:   Wed,  5 Jun 2019 21:14:51 +0200
Message-Id: <20190605191511.32695-5-hch@lst.de>
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

Rename the function to kmem_to_page and move it to kmem.h together
with our kmem_large allocator that may either return kmalloced or
vmalloc pages.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/kmem.h    |  8 ++++++++
 fs/xfs/xfs_buf.c | 13 +------------
 2 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
index 8e6b3ba81c03..267655acd426 100644
--- a/fs/xfs/kmem.h
+++ b/fs/xfs/kmem.h
@@ -124,4 +124,12 @@ kmem_zone_zalloc(kmem_zone_t *zone, xfs_km_flags_t flags)
 	return kmem_zone_alloc(zone, flags | KM_ZERO);
 }
 
+static inline struct page *
+kmem_to_page(void *addr)
+{
+	if (is_vmalloc_addr(addr))
+		return vmalloc_to_page(addr);
+	return virt_to_page(addr);
+}
+
 #endif /* __XFS_SUPPORT_KMEM_H__ */
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 548344e25128..ade6ec28e1c9 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -933,17 +933,6 @@ xfs_buf_set_empty(
 	bp->b_maps[0].bm_len = bp->b_length;
 }
 
-static inline struct page *
-mem_to_page(
-	void			*addr)
-{
-	if ((!is_vmalloc_addr(addr))) {
-		return virt_to_page(addr);
-	} else {
-		return vmalloc_to_page(addr);
-	}
-}
-
 int
 xfs_buf_associate_memory(
 	xfs_buf_t		*bp,
@@ -976,7 +965,7 @@ xfs_buf_associate_memory(
 	bp->b_offset = offset;
 
 	for (i = 0; i < bp->b_page_count; i++) {
-		bp->b_pages[i] = mem_to_page((void *)pageaddr);
+		bp->b_pages[i] = kmem_to_page((void *)pageaddr);
 		pageaddr += PAGE_SIZE;
 	}
 
-- 
2.20.1

