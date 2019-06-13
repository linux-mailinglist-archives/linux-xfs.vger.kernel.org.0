Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0B9E44A33
	for <lists+linux-xfs@lfdr.de>; Thu, 13 Jun 2019 20:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727757AbfFMSDh (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 13 Jun 2019 14:03:37 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:57518 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbfFMSDh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jun 2019 14:03:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=0znfR0kHaGcSLnw/T754re2pIAee9BLbcXc+XryYvbg=; b=QjTwB0o+NjQQEyxn7+QiJb+Iiw
        b6f6p+WBm6AouDtLtzo0sJV6vWfDaIia63+dyNiLsdeD+bYeHgVx9LzU/gH3ihO89GC5sbvzNSi7E
        HAHCw4PKCKB7KyHVLOek/XGgu+vMB7EDl7wJStb58/e52tLn4zDGfCyEq/oNGoL6IBsVXYPcL8w+7
        6oOnzeBrnWd89lN5v7LDGJ52f+BEFxjiWVX7OrIlQZWVxC2oJpwLgCNmksANzFh1S7WiXy5f9xz9t
        rnO9XJoNP9Vye45V7OE+EZXJjhe6qW8LVZcP6MNXKy8S9aij5BmlPRqUbHrFYeYuYBlWebf4kMkXI
        rKjRwmjw==;
Received: from [213.208.157.35] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hbU4W-0002lD-L8; Thu, 13 Jun 2019 18:03:36 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Brian Foster <bfoster@redhat.com>
Subject: [PATCH 15/20] xfs: merge xfs_rud_init into xfs_trans_get_rud
Date:   Thu, 13 Jun 2019 20:02:55 +0200
Message-Id: <20190613180300.30447-16-hch@lst.de>
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
 fs/xfs/xfs_rmap_item.c  | 14 ++++++--------
 fs/xfs/xfs_rmap_item.h  |  2 --
 fs/xfs/xfs_trans_rmap.c | 12 ------------
 3 files changed, 6 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index c2f6acdc593d..7f903de481df 100644
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

