Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1153821461
	for <lists+linux-xfs@lfdr.de>; Fri, 17 May 2019 09:32:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728363AbfEQHcc (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 17 May 2019 03:32:32 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:44094 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728143AbfEQHcc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 May 2019 03:32:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=NfQgqo/SoTNe1EL8t46cs3YX5Ixvs1uQR5GvMIPt2N8=; b=ItIIjC5zzaIJCsJ9XMAzZ7cvw
        4rB1ifZ1HDj04fxBQkOOihTQf5AZZVrGljZFKNMnsXatLxIm4ILqQBV3e8mGzquttzYqRQAt0kWI5
        fDPGxzJQEf8BcxQU9nxhuzDzcXRSJR2SrNqaGAYJe+GCT4cP1HOZoluGHpp63yBss3s+uABPHeRMV
        bId8meixpni9mPyHoMU5daNGhgPqflF+ga5LI0Xom8VUsHANc4SEGwB+z/FzA/04Eww8irnuNijxM
        AzvZqfI1rJkMGxooBnFZrxoG6R8rK5rM8ViN+gfKS7AFgWP1PR3OfYHKZjAxAclQ7fSsJmIYMp9Cx
        OkG80MkYQ==;
Received: from 089144210233.atnat0019.highway.a1.net ([89.144.210.233] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hRXLz-0000le-00
        for linux-xfs@vger.kernel.org; Fri, 17 May 2019 07:32:31 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 09/20] xfs: don't cast inode_log_items to get the log_item
Date:   Fri, 17 May 2019 09:31:08 +0200
Message-Id: <20190517073119.30178-10-hch@lst.de>
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

The cast is not type safe, and we can just dereference the first
member instead to start with.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 71d216cf6f87..419eae485ff3 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -485,7 +485,7 @@ xfs_lock_inodes(
 		 */
 		if (!try_lock) {
 			for (j = (i - 1); j >= 0 && !try_lock; j--) {
-				lp = (xfs_log_item_t *)ips[j]->i_itemp;
+				lp = &ips[j]->i_itemp->ili_item;
 				if (lp && test_bit(XFS_LI_IN_AIL, &lp->li_flags))
 					try_lock++;
 			}
@@ -585,7 +585,7 @@ xfs_lock_two_inodes(
 	 * the second lock. If we can't get it, we must release the first one
 	 * and try again.
 	 */
-	lp = (xfs_log_item_t *)ip0->i_itemp;
+	lp = &ip0->i_itemp->ili_item;
 	if (lp && test_bit(XFS_LI_IN_AIL, &lp->li_flags)) {
 		if (!xfs_ilock_nowait(ip1, xfs_lock_inumorder(ip1_mode, 1))) {
 			xfs_iunlock(ip0, ip0_mode);
-- 
2.20.1

