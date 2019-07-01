Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E03ED21466
	for <lists+linux-xfs@lfdr.de>; Fri, 17 May 2019 09:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbfEQHcp (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 17 May 2019 03:32:45 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:44406 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728365AbfEQHcp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 May 2019 03:32:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=GDMbo+fmrqOMS04iSSUX2No4cXLLchnJELEr6VE6BJA=; b=Ns1fNEscoLdESyIP/wVQEgIju
        JO8TpkcXZx9FymUyIiYVYm5qrhRWdOipcj4u/jVRuvVxG0t2Bzm9KR1nAw8vldyYdu4DbCtBYvvcN
        vQdVTrQqF3FjTRmaxOaxi+Tfj4WdE9uRrD47HDbpuMwfjJhEBTu1pskUehdxzL8FLkE/IZNkgsyyZ
        MrwD1ep66HB/s8+UWP9mkBnSsJQxCnKvAhriSvZgdkUgsTwMtMhB3s2Vqgw/xGEV2MWadOgiuaHLG
        aWLDdXI0GhxJbSSi2J8TILvZtQKD7Vm64r0Ykyl0CcqMMIjfWGxG9/wkOSN38orcKrmNxk8r98wfG
        DdXkXxESA==;
Received: from 089144210233.atnat0019.highway.a1.net ([89.144.210.233] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hRXMB-0000oS-U8
        for linux-xfs@vger.kernel.org; Fri, 17 May 2019 07:32:44 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 14/20] xfs: merge xfs_cud_init into xfs_trans_get_cud
Date:   Fri, 17 May 2019 09:31:13 +0200
Message-Id: <20190517073119.30178-15-hch@lst.de>
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
 fs/xfs/xfs_refcount_item.c  | 14 ++++++--------
 fs/xfs/xfs_refcount_item.h  |  2 --
 fs/xfs/xfs_trans_refcount.c | 16 ----------------
 3 files changed, 6 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 2b2f6e7ad867..70dcdf40ac92 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -217,22 +217,20 @@ static const struct xfs_item_ops xfs_cud_item_ops = {
 	.iop_release	= xfs_cud_item_release,
 };
 
-/*
- * Allocate and initialize an cud item with the given number of extents.
- */
 struct xfs_cud_log_item *
-xfs_cud_init(
-	struct xfs_mount		*mp,
+xfs_trans_get_cud(
+	struct xfs_trans		*tp,
 	struct xfs_cui_log_item		*cuip)
-
 {
-	struct xfs_cud_log_item	*cudp;
+	struct xfs_cud_log_item		*cudp;
 
 	cudp = kmem_zone_zalloc(xfs_cud_zone, KM_SLEEP);
-	xfs_log_item_init(mp, &cudp->cud_item, XFS_LI_CUD, &xfs_cud_item_ops);
+	xfs_log_item_init(tp->t_mountp, &cudp->cud_item, XFS_LI_CUD,
+			  &xfs_cud_item_ops);
 	cudp->cud_cuip = cuip;
 	cudp->cud_format.cud_cui_id = cuip->cui_format.cui_id;
 
+	xfs_trans_add_item(tp, &cudp->cud_item);
 	return cudp;
 }
 
diff --git a/fs/xfs/xfs_refcount_item.h b/fs/xfs/xfs_refcount_item.h
index 3896dcc2368f..e47530f30489 100644
--- a/fs/xfs/xfs_refcount_item.h
+++ b/fs/xfs/xfs_refcount_item.h
@@ -78,8 +78,6 @@ extern struct kmem_zone	*xfs_cui_zone;
 extern struct kmem_zone	*xfs_cud_zone;
 
 struct xfs_cui_log_item *xfs_cui_init(struct xfs_mount *, uint);
-struct xfs_cud_log_item *xfs_cud_init(struct xfs_mount *,
-		struct xfs_cui_log_item *);
 void xfs_cui_item_free(struct xfs_cui_log_item *);
 void xfs_cui_release(struct xfs_cui_log_item *);
 int xfs_cui_recover(struct xfs_trans *parent_tp, struct xfs_cui_log_item *cuip);
diff --git a/fs/xfs/xfs_trans_refcount.c b/fs/xfs/xfs_trans_refcount.c
index 8d734728dd1b..d793fb500378 100644
--- a/fs/xfs/xfs_trans_refcount.c
+++ b/fs/xfs/xfs_trans_refcount.c
@@ -17,22 +17,6 @@
 #include "xfs_alloc.h"
 #include "xfs_refcount.h"
 
-/*
- * This routine is called to allocate a "refcount update done"
- * log item.
- */
-struct xfs_cud_log_item *
-xfs_trans_get_cud(
-	struct xfs_trans		*tp,
-	struct xfs_cui_log_item		*cuip)
-{
-	struct xfs_cud_log_item		*cudp;
-
-	cudp = xfs_cud_init(tp->t_mountp, cuip);
-	xfs_trans_add_item(tp, &cudp->cud_item);
-	return cudp;
-}
-
 /*
  * Finish an refcount update and log it to the CUD. Note that the
  * transaction is marked dirty regardless of whether the refcount
-- 
2.20.1

