Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4CCA2D7202
	for <lists+linux-xfs@lfdr.de>; Fri, 11 Dec 2020 09:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390972AbgLKImF (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 11 Dec 2020 03:42:05 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9513 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436982AbgLKIld (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Dec 2020 03:41:33 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CskkT2nTYzhn8F;
        Fri, 11 Dec 2020 16:40:17 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.487.0; Fri, 11 Dec 2020 16:40:45 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <linux-xfs@vger.kernel.org>, <darrick.wong@oracle.com>,
        <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH -next] fs/xfs: convert comma to semicolon
Date:   Fri, 11 Dec 2020 16:41:12 +0800
Message-ID: <20201211084112.1931-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Replace a comma between expression statements by a semicolon.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 fs/xfs/libxfs/xfs_btree.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 2d25bab68764..51dbff9b0908 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -4070,7 +4070,7 @@ xfs_btree_delrec(
 	 * surviving block, and log it.
 	 */
 	xfs_btree_set_numrecs(left, lrecs + rrecs);
-	xfs_btree_get_sibling(cur, right, &cptr, XFS_BB_RIGHTSIB),
+	xfs_btree_get_sibling(cur, right, &cptr, XFS_BB_RIGHTSIB);
 	xfs_btree_set_sibling(cur, left, &cptr, XFS_BB_RIGHTSIB);
 	xfs_btree_log_block(cur, lbp, XFS_BB_NUMRECS | XFS_BB_RIGHTSIB);
 
-- 
2.22.0

