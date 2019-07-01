Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EED523D0D
	for <lists+linux-xfs@lfdr.de>; Mon, 20 May 2019 18:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389156AbfETQP3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 May 2019 12:15:29 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37224 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732368AbfETQP3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 12:15:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=r5XSWpyDBSp2F3DML5+Mmy8OmCmd07Jfh6se71FQ+oI=; b=OEfMc+p9a2DUYe7xAfOx5yCAC
        TGS8kNnTcBddEZnbWqdt80zCODWV7OM+x9G1SXxPBAA9ZHNmjirIIvVhfDjZOX2MJaP4x+DvbVEuc
        TwMeDskQRs7P1wbTSS7V/FMm7Es8PCZzdOpNhQv+PACZ8s/OluDwfLR6gLBXSj9uMFIh2mKjuY765
        /kdppzjP0S6uf82msirchC88keZg5B9NJ5rspR2nPllCeqRZ5QybYPLP9QnGrNrMczPxVUWNYvwx9
        FKnQtubHfnN4p3RLSK5OQHQP/y+Kns1WgAIptDYw7BLTY8hhpp3rsCtGemWl5Wa3T7SAS4nMA5CMB
        U4pJ9yrGw==;
Received: from 089144206147.atnat0015.highway.bob.at ([89.144.206.147] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hSkwi-0006wz-Rz
        for linux-xfs@vger.kernel.org; Mon, 20 May 2019 16:15:29 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 16/17] xfs: properly type the b_log_item field in struct xfs_buf
Date:   Mon, 20 May 2019 18:13:46 +0200
Message-Id: <20190520161347.3044-17-hch@lst.de>
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

Now that the log code doesn't abuse this field any more we can
declare it as a struct xfs_buf_log_item pointer.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 2440c3ab85a8..27f05db07214 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -150,7 +150,7 @@ typedef struct xfs_buf {
 	struct work_struct	b_ioend_work;
 	xfs_buf_iodone_t	b_iodone;	/* I/O completion function */
 	struct completion	b_iowait;	/* queue for I/O waiters */
-	void			*b_log_item;
+	struct xfs_buf_log_item	*b_log_item;
 	struct list_head	b_li_list;	/* Log items list head */
 	struct xfs_trans	*b_transp;
 	struct page		**b_pages;	/* array of page pointers */
-- 
2.20.1

