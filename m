Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A39921465
	for <lists+linux-xfs@lfdr.de>; Fri, 17 May 2019 09:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728367AbfEQHcm (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 17 May 2019 03:32:42 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:44122 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728365AbfEQHcm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 May 2019 03:32:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=fiOraFnc1GrGliV8yt15MxbJQFsq7S3nSdsDW8fmfU8=; b=DyPVp+rIcq2ykRpctId0a1ZjI
        29zgd+6HimQq0KfkWnbik/Og6WphDMfBVL5faOJ9VgY5ve/RkmowV9yMJTXPM6s4diknJPyihffrD
        CFPm+n8yXTFnvD4tQpml/U1fyeVfNZdvF06S0NT1oSYA7/x8Li1DY5+Y0utojXMYM1V9KfFALaJP3
        4h/wZesadocP/EXwUdT59CtHP0wj5gsNou9PszHWSZJDokKcdXYe5Rkid/7I6+AlHO1J/yD0QBDxn
        OVKgGl1rePEQ7rpaS4xhtACGHKCXYG40C+5wpL5AipbPNWN1+B5+w7J4lBj9liPh59Aqw0E9V5b1o
        hcM+gWMwA==;
Received: from 089144210233.atnat0019.highway.a1.net ([89.144.210.233] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hRXM9-0000nm-AC
        for linux-xfs@vger.kernel.org; Fri, 17 May 2019 07:32:41 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 13/20] xfs: merge xfs_efd_init into xfs_trans_get_efd
Date:   Fri, 17 May 2019 09:31:12 +0200
Message-Id: <20190517073119.30178-14-hch@lst.de>
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
 fs/xfs/xfs_extfree_item.c  | 27 +++++++++++++++------------
 fs/xfs/xfs_extfree_item.h  |  2 --
 fs/xfs/xfs_trans_extfree.c | 26 --------------------------
 3 files changed, 15 insertions(+), 40 deletions(-)

diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index bb0b1e942d00..ccf95cb8234c 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -312,32 +312,35 @@ static const struct xfs_item_ops xfs_efd_item_ops = {
 };
 
 /*
- * Allocate and initialize an efd item with the given number of extents.
+ * Allocate an "extent free done" log item that will hold nextents worth of
+ * extents.  The caller must use all nextents extents, because we are not
+ * flexible about this at all.
  */
 struct xfs_efd_log_item *
-xfs_efd_init(
-	struct xfs_mount	*mp,
-	struct xfs_efi_log_item	*efip,
-	uint			nextents)
-
+xfs_trans_get_efd(
+	struct xfs_trans		*tp,
+	struct xfs_efi_log_item		*efip,
+	unsigned int			nextents)
 {
-	struct xfs_efd_log_item	*efdp;
-	uint			size;
+	struct xfs_efd_log_item		*efdp;
 
 	ASSERT(nextents > 0);
+
 	if (nextents > XFS_EFD_MAX_FAST_EXTENTS) {
-		size = (uint)(sizeof(xfs_efd_log_item_t) +
-			((nextents - 1) * sizeof(xfs_extent_t)));
-		efdp = kmem_zalloc(size, KM_SLEEP);
+		efdp = kmem_zalloc(sizeof(struct xfs_efd_log_item) +
+				(nextents - 1) * sizeof(struct xfs_extent),
+				KM_SLEEP);
 	} else {
 		efdp = kmem_zone_zalloc(xfs_efd_zone, KM_SLEEP);
 	}
 
-	xfs_log_item_init(mp, &efdp->efd_item, XFS_LI_EFD, &xfs_efd_item_ops);
+	xfs_log_item_init(tp->t_mountp, &efdp->efd_item, XFS_LI_EFD,
+			  &xfs_efd_item_ops);
 	efdp->efd_efip = efip;
 	efdp->efd_format.efd_nextents = nextents;
 	efdp->efd_format.efd_efi_id = efip->efi_format.efi_id;
 
+	xfs_trans_add_item(tp, &efdp->efd_item);
 	return efdp;
 }
 
diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
index b0dc4ebe8892..16aaab06d4ec 100644
--- a/fs/xfs/xfs_extfree_item.h
+++ b/fs/xfs/xfs_extfree_item.h
@@ -79,8 +79,6 @@ extern struct kmem_zone	*xfs_efi_zone;
 extern struct kmem_zone	*xfs_efd_zone;
 
 xfs_efi_log_item_t	*xfs_efi_init(struct xfs_mount *, uint);
-xfs_efd_log_item_t	*xfs_efd_init(struct xfs_mount *, xfs_efi_log_item_t *,
-				      uint);
 int			xfs_efi_copy_format(xfs_log_iovec_t *buf,
 					    xfs_efi_log_format_t *dst_efi_fmt);
 void			xfs_efi_item_free(xfs_efi_log_item_t *);
diff --git a/fs/xfs/xfs_trans_extfree.c b/fs/xfs/xfs_trans_extfree.c
index 8ee7a3f8bb20..20ab1c9d758f 100644
--- a/fs/xfs/xfs_trans_extfree.c
+++ b/fs/xfs/xfs_trans_extfree.c
@@ -19,32 +19,6 @@
 #include "xfs_bmap.h"
 #include "xfs_trace.h"
 
-/*
- * This routine is called to allocate an "extent free done"
- * log item that will hold nextents worth of extents.  The
- * caller must use all nextents extents, because we are not
- * flexible about this at all.
- */
-struct xfs_efd_log_item *
-xfs_trans_get_efd(struct xfs_trans		*tp,
-		  struct xfs_efi_log_item	*efip,
-		  uint				nextents)
-{
-	struct xfs_efd_log_item			*efdp;
-
-	ASSERT(tp != NULL);
-	ASSERT(nextents > 0);
-
-	efdp = xfs_efd_init(tp->t_mountp, efip, nextents);
-	ASSERT(efdp != NULL);
-
-	/*
-	 * Get a log_item_desc to point at the new item.
-	 */
-	xfs_trans_add_item(tp, &efdp->efd_item);
-	return efdp;
-}
-
 /*
  * Free an extent and log it to the EFD. Note that the transaction is marked
  * dirty regardless of whether the extent free succeeds or fails to support the
-- 
2.20.1

