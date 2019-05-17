Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECC5921468
	for <lists+linux-xfs@lfdr.de>; Fri, 17 May 2019 09:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728371AbfEQHcs (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 17 May 2019 03:32:48 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:44848 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728365AbfEQHcs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 May 2019 03:32:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=CuiXAPmlT3Ywjp09DMWsOJsSvJ+jtcIla5zfQ1h0I6c=; b=ixtPJ8T7a5azcvE9WjNz8WRfu
        NOWX2Sh6lKwRGBnqLyYC+HyMNfnh/hmIdwl359lMkMUfEpjZPeLAcDSEWSABz74sQ/FJ9SxOjGeGt
        70lgD4khrpMrK64No9l4dO0Cxw4Wc3FNiaAR7fCZbEl2Drf4NPTd6aw19rJHUHTjnV1DY6oqQVmZV
        DQJ2kMmzbEbkpCVYzX842wsrDcJbIh5mG8e9jXt2p/OLnWwF+tD9LWtIkPwTAk+1DA/rBM//jBJ4d
        fiAuFY1AafFCu7yjuvMy2VCqzxpuWQvqUWYpanSuMynKJRteX73mf7OQcrsEu5aThNE8Ygdhf+5qm
        uSsvTle8Q==;
Received: from 089144210233.atnat0019.highway.a1.net ([89.144.210.233] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hRXME-0000rf-H4
        for linux-xfs@vger.kernel.org; Fri, 17 May 2019 07:32:46 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 15/20] xfs: merge xfs_rud_init into xfs_trans_get_rud
Date:   Fri, 17 May 2019 09:31:14 +0200
Message-Id: <20190517073119.30178-16-hch@lst.de>
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
 fs/xfs/xfs_rmap_item.c  | 14 ++++++--------
 fs/xfs/xfs_rmap_item.h  |  2 --
 fs/xfs/xfs_trans_rmap.c | 12 ------------
 3 files changed, 6 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index dce1357aef88..5f11e6d43484 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -238,22 +238,20 @@ static const struct xfs_item_ops xfs_rud_item_ops = {
 	.iop_release	= xfs_rud_item_release,
 };
 
-/*
- * Allocate and initialize an rud item with the given number of extents.
- */
 struct xfs_rud_log_item *
-xfs_rud_init(
-	struct xfs_mount		*mp,
+xfs_trans_get_rud(
+	struct xfs_trans		*tp,
 	struct xfs_rui_log_item		*ruip)
-
 {
-	struct xfs_rud_log_item	*rudp;
+	struct xfs_rud_log_item		*rudp;
 
 	rudp = kmem_zone_zalloc(xfs_rud_zone, KM_SLEEP);
-	xfs_log_item_init(mp, &rudp->rud_item, XFS_LI_RUD, &xfs_rud_item_ops);
+	xfs_log_item_init(tp->t_mountp, &rudp->rud_item, XFS_LI_RUD,
+			  &xfs_rud_item_ops);
 	rudp->rud_ruip = ruip;
 	rudp->rud_format.rud_rui_id = ruip->rui_format.rui_id;
 
+	xfs_trans_add_item(tp, &rudp->rud_item);
 	return rudp;
 }
 
diff --git a/fs/xfs/xfs_rmap_item.h b/fs/xfs/xfs_rmap_item.h
index 7e482baa27f5..8708e4a5aa5c 100644
--- a/fs/xfs/xfs_rmap_item.h
+++ b/fs/xfs/xfs_rmap_item.h
@@ -78,8 +78,6 @@ extern struct kmem_zone	*xfs_rui_zone;
 extern struct kmem_zone	*xfs_rud_zone;
 
 struct xfs_rui_log_item *xfs_rui_init(struct xfs_mount *, uint);
-struct xfs_rud_log_item *xfs_rud_init(struct xfs_mount *,
-		struct xfs_rui_log_item *);
 int xfs_rui_copy_format(struct xfs_log_iovec *buf,
 		struct xfs_rui_log_format *dst_rui_fmt);
 void xfs_rui_item_free(struct xfs_rui_log_item *);
diff --git a/fs/xfs/xfs_trans_rmap.c b/fs/xfs/xfs_trans_rmap.c
index 5c7936b1be13..863e3281daaa 100644
--- a/fs/xfs/xfs_trans_rmap.c
+++ b/fs/xfs/xfs_trans_rmap.c
@@ -60,18 +60,6 @@ xfs_trans_set_rmap_flags(
 	}
 }
 
-struct xfs_rud_log_item *
-xfs_trans_get_rud(
-	struct xfs_trans		*tp,
-	struct xfs_rui_log_item		*ruip)
-{
-	struct xfs_rud_log_item		*rudp;
-
-	rudp = xfs_rud_init(tp->t_mountp, ruip);
-	xfs_trans_add_item(tp, &rudp->rud_item);
-	return rudp;
-}
-
 /*
  * Finish an rmap update and log it to the RUD. Note that the transaction is
  * marked dirty regardless of whether the rmap update succeeds or fails to
-- 
2.20.1

