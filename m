Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B34744A27
	for <lists+linux-xfs@lfdr.de>; Thu, 13 Jun 2019 20:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbfFMSDN (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 13 Jun 2019 14:03:13 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:57430 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726622AbfFMSDN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jun 2019 14:03:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=74KdNXhM1XngedvlYp6RAVoyKjUrCqqv6wWyGwMRWe4=; b=J5c+CPxXT0dz55FxS6ZkznD+b+
        IbfsJcjozlzOFsOOzWlwpU2c5n0PXoB6x2XYezbCg+ICctAc+9gJF4cW+3gUYqvvs7PcMV8+kKzfI
        xcg1ymbQflI1xc05fDEchgiMekT/M8GgA4VzEz66afTtn7pQ7kNCWR4SKFD0TO4M/wlvVllf99v0X
        Fxe/Krtii30SzP8r9UUqBCQXFp7CoMwwT0KIflHopE4ubafsFwBNRP1uHdzPrQ5DQxe+OFipSOOvn
        ROYCBLGjqGF/T2XbTAN78y1HVF5RGUDqknS7Gr5xW4vFtegtRiiYbNxCNUgQSOLRApnvpJ4SmIzlQ
        S9dznEqw==;
Received: from [213.208.157.35] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hbU49-0002gd-7m; Thu, 13 Jun 2019 18:03:13 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Brian Foster <bfoster@redhat.com>
Subject: [PATCH 04/20] xfs: remove the dummy iop_push implementation for inode creation items
Date:   Thu, 13 Jun 2019 20:02:44 +0200
Message-Id: <20190613180300.30447-5-hch@lst.de>
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

This method should never be called, so don't waste code on it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_icreate_item.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
index 03c174ff1ab3..cbaabc55f0c9 100644
--- a/fs/xfs/xfs_icreate_item.c
+++ b/fs/xfs/xfs_icreate_item.c
@@ -83,23 +83,12 @@ xfs_icreate_item_committed(
 	return (xfs_lsn_t)-1;
 }
 
-/* item can never get into the AIL */
-STATIC uint
-xfs_icreate_item_push(
-	struct xfs_log_item	*lip,
-	struct list_head	*buffer_list)
-{
-	ASSERT(0);
-	return XFS_ITEM_SUCCESS;
-}
-
 /*
  * This is the ops vector shared by all buf log items.
  */
 static const struct xfs_item_ops xfs_icreate_item_ops = {
 	.iop_size	= xfs_icreate_item_size,
 	.iop_format	= xfs_icreate_item_format,
-	.iop_push	= xfs_icreate_item_push,
 	.iop_unlock	= xfs_icreate_item_unlock,
 	.iop_committed	= xfs_icreate_item_committed,
 };
-- 
2.20.1

