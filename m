Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AEE021458
	for <lists+linux-xfs@lfdr.de>; Fri, 17 May 2019 09:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728340AbfEQHcT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 17 May 2019 03:32:19 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:44054 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728334AbfEQHcT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 May 2019 03:32:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Yh3GGceWOq+eciyvhZkLEZKhW+W9Vp8LITXICwprIuE=; b=bQiz9+bGASt6vtBAokrw/uxT1
        cE7IB+s0KQKj3G0nCyY5gG8x/+0gZLTLR/a4Mjxi0GWwetaVJrsn+tDyJaSRi0HLQ/56XJcKLf+Zj
        Jj9oJf5XFbS/NwoHPmmI9cS7wgTQGuhHDnnCMRYXleAUhl8V/0aBC3eViec3BmR707zustWdSRg7p
        1E6XcPP3R3/p3ioPngpJo8/ves7T6IGigeBR3laJvJwnIejRCbQVAxEGByGX/PFMXhnrVSjMiFNd1
        YXN+DbQBUdjuA2sY1EZX/dZ53p/UamVz2HwAAw+h7i9ok3ma3CkJkprjiUVjnrY6PwqHDcYiLuFp5
        1K+4k1DPg==;
Received: from 089144210233.atnat0019.highway.a1.net ([89.144.210.233] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hRXLm-0000jV-Cx
        for linux-xfs@vger.kernel.org; Fri, 17 May 2019 07:32:18 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 04/20] xfs: remove the dummy iop_push implementation for inode creation items
Date:   Fri, 17 May 2019 09:31:03 +0200
Message-Id: <20190517073119.30178-5-hch@lst.de>
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

This method should never be called, so don't waste code on it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
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

