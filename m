Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B07344A32
	for <lists+linux-xfs@lfdr.de>; Thu, 13 Jun 2019 20:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727640AbfFMSDf (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 13 Jun 2019 14:03:35 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:57510 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbfFMSDe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jun 2019 14:03:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=6mMMlaO5zBV4t2hwniHqPTEDmg2B2pLkEpjvDblfEHk=; b=oa/NWqKfWizQamI7q2MuRZ15t/
        2G3z2om3kDmDFGWEoevjkd2VX/FRiVBn6ovflfU/ccsiHAupZkVn6FdwSOOguW86cRg6gVeu2CoLi
        +DIPpGYTguITxy+S//y3Mc2d6GpJFPXzy2Yjq1+2DlqJxnolVdrP6kuCTwPcDaXy3ElFNbSgYOsCA
        QhEFKgtfTX+zFs2dt/mzrGQhwpTQQIWeFyWB+ECbx1twtfxwwm+f2sZi+00GmHpsLANGgTyRUL4uz
        UBv/BvFYWBocSsTzILEuhQiTeJNgyGh9AjpRzbRRILEURdtwPncYuf0pNxdoQEepAgfCd1oTROS5/
        J4DHpKcQ==;
Received: from [213.208.157.35] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hbU4U-0002kn-F8; Thu, 13 Jun 2019 18:03:34 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Brian Foster <bfoster@redhat.com>
Subject: [PATCH 14/20] xfs: merge xfs_cud_init into xfs_trans_get_cud
Date:   Thu, 13 Jun 2019 20:02:54 +0200
Message-Id: <20190613180300.30447-15-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190613180300.30447-1-hch@lst.de>
References: <20190613180300.30447-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

There is no good reason to keep these two functions separate.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_refcount_item.c  | 14 ++++++--------
 fs/xfs/xfs_refcount_item.h  |  2 --
 fs/xfs/xfs_trans_refcount.c | 16 ----------------
 3 files changed, 6 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index a4a2296546b6..fc2dfe92c43a 100644
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

