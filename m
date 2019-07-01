Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8A621469
	for <lists+linux-xfs@lfdr.de>; Fri, 17 May 2019 09:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728372AbfEQHcu (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 17 May 2019 03:32:50 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:45110 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728365AbfEQHcu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 May 2019 03:32:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=g9klfympz54shoyZSCCl3wLaE3WEJe3wHosMdPNZnQA=; b=JLWihTSDCUQb58l2iRxkcnSkG
        6xa13fTfOCzda9e9yGCcaBWjP2Vw5ibsHW9sbQ5oTgFQysV1aX9+jul7l5+vuZq6y0hCWNnARet4m
        cT+oZYsoBdSXp8Xl/GXLseuwz3+syZtbRAEovxwcalQz3wKpTxw2tsHgQVvKDzvsszCrLk+a+pwcl
        0nS18kpL+et8391k2EMFOFfnF1GrzUvyL3vTLR6vzjjRYHluxJ6I8BkWvcEQ8H5/7q8nqcDZ74aCg
        +gDqUx6mTq2dzBbyl7AS9M4xFSErXiVBdmcabY99LHHSRc/PiI3agmzL68i7kcTDP+BbXbXc5DbCa
        BMMp73g2g==;
Received: from 089144210233.atnat0019.highway.a1.net ([89.144.210.233] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hRXMH-0000vS-7Z
        for linux-xfs@vger.kernel.org; Fri, 17 May 2019 07:32:49 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 16/20] xfs: merge xfs_bud_init into xfs_trans_get_bud
Date:   Fri, 17 May 2019 09:31:15 +0200
Message-Id: <20190517073119.30178-17-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190517073119.30178-1-hch@lst.de>
References: <20190517073119.30178-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

There is no good reason to keep these two functions separate.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_bmap_item.c  | 14 ++++++--------
 fs/xfs/xfs_bmap_item.h  |  2 --
 fs/xfs/xfs_trans_bmap.c | 16 ----------------
 3 files changed, 6 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 46dcadf790c2..40385c8b752a 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -212,22 +212,20 @@ static const struct xfs_item_ops xfs_bud_item_ops = {
 	.iop_release	= xfs_bud_item_release,
 };
 
-/*
- * Allocate and initialize an bud item with the given number of extents.
- */
 struct xfs_bud_log_item *
-xfs_bud_init(
-	struct xfs_mount		*mp,
+xfs_trans_get_bud(
+	struct xfs_trans		*tp,
 	struct xfs_bui_log_item		*buip)
-
 {
-	struct xfs_bud_log_item	*budp;
+	struct xfs_bud_log_item		*budp;
 
 	budp = kmem_zone_zalloc(xfs_bud_zone, KM_SLEEP);
-	xfs_log_item_init(mp, &budp->bud_item, XFS_LI_BUD, &xfs_bud_item_ops);
+	xfs_log_item_init(tp->t_mountp, &budp->bud_item, XFS_LI_BUD,
+			  &xfs_bud_item_ops);
 	budp->bud_buip = buip;
 	budp->bud_format.bud_bui_id = buip->bui_format.bui_id;
 
+	xfs_trans_add_item(tp, &budp->bud_item);
 	return budp;
 }
 
diff --git a/fs/xfs/xfs_bmap_item.h b/fs/xfs/xfs_bmap_item.h
index 89e043a88bb8..ad479cc73de8 100644
--- a/fs/xfs/xfs_bmap_item.h
+++ b/fs/xfs/xfs_bmap_item.h
@@ -75,8 +75,6 @@ extern struct kmem_zone	*xfs_bui_zone;
 extern struct kmem_zone	*xfs_bud_zone;
 
 struct xfs_bui_log_item *xfs_bui_init(struct xfs_mount *);
-struct xfs_bud_log_item *xfs_bud_init(struct xfs_mount *,
-		struct xfs_bui_log_item *);
 void xfs_bui_item_free(struct xfs_bui_log_item *);
 void xfs_bui_release(struct xfs_bui_log_item *);
 int xfs_bui_recover(struct xfs_trans *parent_tp, struct xfs_bui_log_item *buip);
diff --git a/fs/xfs/xfs_trans_bmap.c b/fs/xfs/xfs_trans_bmap.c
index e1c7d55b32c3..c6f5b217d17c 100644
--- a/fs/xfs/xfs_trans_bmap.c
+++ b/fs/xfs/xfs_trans_bmap.c
@@ -18,22 +18,6 @@
 #include "xfs_bmap.h"
 #include "xfs_inode.h"
 
-/*
- * This routine is called to allocate a "bmap update done"
- * log item.
- */
-struct xfs_bud_log_item *
-xfs_trans_get_bud(
-	struct xfs_trans		*tp,
-	struct xfs_bui_log_item		*buip)
-{
-	struct xfs_bud_log_item		*budp;
-
-	budp = xfs_bud_init(tp->t_mountp, buip);
-	xfs_trans_add_item(tp, &budp->bud_item);
-	return budp;
-}
-
 /*
  * Finish an bmap update and log it to the BUD. Note that the
  * transaction is marked dirty regardless of whether the bmap update
-- 
2.20.1

