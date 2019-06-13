Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09C7344A31
	for <lists+linux-xfs@lfdr.de>; Thu, 13 Jun 2019 20:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727602AbfFMSDc (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 13 Jun 2019 14:03:32 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:57496 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbfFMSDc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jun 2019 14:03:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=g+3FVFC+BCfK2g8dc+OjI304Gr9kfWyzJTrZYeXyhxo=; b=XTFA3xF3BPiV8Gjwak+7NIoMp6
        HYZFalY8BjkW1jQu2tAZ6gouvVB0jt2Xtp6PEWEW1gJXMdvEPrKhnPLEWVy5FH8i0n19va8KGrFt9
        LZvSy1higwyJWobQTJeGujdR9jcq2kKtJsz6CIl0HzD1xoY4/RX3QedH9QJaXJFiRqRXpfZyFGuwb
        C42ppm8YAIkqtNGU9M2Ov1c9DujuxizLYzAQsgHopYcO+nH8stCWvmQExH0fmKZT/wqac3g5MgqOr
        Q5gfl2aOGNHOk8bRVAE5NWbO7ltWpA1zaG7adBGhftxwVVxtT0iNn4CbXLcU9q6HMWmE9ux6mMaxR
        vTuXpltQ==;
Received: from [213.208.157.35] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hbU4S-0002kE-33; Thu, 13 Jun 2019 18:03:32 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Brian Foster <bfoster@redhat.com>
Subject: [PATCH 13/20] xfs: merge xfs_efd_init into xfs_trans_get_efd
Date:   Thu, 13 Jun 2019 20:02:53 +0200
Message-Id: <20190613180300.30447-14-hch@lst.de>
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
 fs/xfs/xfs_extfree_item.c  | 27 +++++++++++++++------------
 fs/xfs/xfs_extfree_item.h  |  2 --
 fs/xfs/xfs_trans_extfree.c | 26 --------------------------
 3 files changed, 15 insertions(+), 40 deletions(-)

diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index e625df2eb09e..b797db8b9967 100644
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

