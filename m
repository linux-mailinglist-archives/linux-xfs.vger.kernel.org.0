Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 721FD336A4
	for <lists+linux-xfs@lfdr.de>; Mon,  3 Jun 2019 19:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbfFCR3y (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 3 Jun 2019 13:29:54 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53536 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726784AbfFCR3y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Jun 2019 13:29:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=aSOiHRIm8aSgv4c25SUp/HEp0VKiCR8zgq0qLWdvm48=; b=A1Ysg+5a86D+8vNmVpJ/15SJaH
        26TUXq41TUOjrvNEjZoEHtJVighoNNDGrBi5dkazkeuzKPCfdbAuItXgsjm8ukebr45YYkZMvDbaq
        TiUqyRDSFEB6/L0iIwNN7FKDGAsNLkJ2WKYFCU5QANsgo7IyaVbopjj9s2nv5uOMHs0otK+fYPnDh
        fKAG0i0a3YnXYTrM87yIRsZiUZfernTIlfMnl70srmK3qgi6gF2rhJCtWbHNjyIXb9wCAH7RE5fUg
        yISTtcV7FKdqG2Z/JJjiCNxSQvWGdi9GixBIEsGEDPU9xfhL23mIySGEB8IcQtz9fuAB+lKvj8Z43
        SPOrlxtQ==;
Received: from 089144193064.atnat0002.highway.a1.net ([89.144.193.64] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hXqmP-0002No-Nf; Mon, 03 Jun 2019 17:29:54 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 02/20] xfs: remove the never used _XBF_COMPOUND flag
Date:   Mon,  3 Jun 2019 19:29:27 +0200
Message-Id: <20190603172945.13819-3-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190603172945.13819-1-hch@lst.de>
References: <20190603172945.13819-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf.h | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index d0b96e071cec..4f2c2bc43003 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -49,7 +49,6 @@ typedef enum {
 #define _XBF_PAGES	 (1 << 20)/* backed by refcounted pages */
 #define _XBF_KMEM	 (1 << 21)/* backed by heap memory */
 #define _XBF_DELWRI_Q	 (1 << 22)/* buffer on a delwri queue */
-#define _XBF_COMPOUND	 (1 << 23)/* compound buffer */
 
 typedef unsigned int xfs_buf_flags_t;
 
@@ -69,8 +68,7 @@ typedef unsigned int xfs_buf_flags_t;
 	{ XBF_UNMAPPED,		"UNMAPPED" },	/* ditto */\
 	{ _XBF_PAGES,		"PAGES" }, \
 	{ _XBF_KMEM,		"KMEM" }, \
-	{ _XBF_DELWRI_Q,	"DELWRI_Q" }, \
-	{ _XBF_COMPOUND,	"COMPOUND" }
+	{ _XBF_DELWRI_Q,	"DELWRI_Q" }
 
 
 /*
-- 
2.20.1

