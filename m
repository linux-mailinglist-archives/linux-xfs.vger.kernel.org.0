Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C61C62C2334
	for <lists+linux-xfs@lfdr.de>; Tue, 24 Nov 2020 11:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731947AbgKXKp7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 24 Nov 2020 05:45:59 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8021 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726775AbgKXKp7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Nov 2020 05:45:59 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CgLJy2H6xzhYYk;
        Tue, 24 Nov 2020 18:45:38 +0800 (CST)
Received: from thunder-town.china.huawei.com (10.174.178.208) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.487.0; Tue, 24 Nov 2020 18:45:48 +0800
From:   Zhen Lei <thunder.leizhen@huawei.com>
To:     "Darrick J . Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC:     Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 2/2] xfs: remove the extra processing of zero size in xfs_idata_realloc()
Date:   Tue, 24 Nov 2020 18:45:31 +0800
Message-ID: <20201124104531.561-3-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
In-Reply-To: <20201124104531.561-1-thunder.leizhen@huawei.com>
References: <20201124104531.561-1-thunder.leizhen@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.174.178.208]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

krealloc() does the free operation when the parameter new_size is 0, with
ZERO_SIZE_PTR returned. Because all other places use NULL to check whether
if_data is available or not, so covert it from ZERO_SIZE_PTR to NULL.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 fs/xfs/libxfs/xfs_inode_fork.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 4e457aea8493..518af4088e79 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -492,13 +492,6 @@ xfs_idata_realloc(
 	if (byte_diff == 0)
 		return;
 
-	if (new_size == 0) {
-		kmem_free(ifp->if_u1.if_data);
-		ifp->if_u1.if_data = NULL;
-		ifp->if_bytes = 0;
-		return;
-	}
-
 	/*
 	 * For inline data, the underlying buffer must be a multiple of 4 bytes
 	 * in size so that it can be logged and stay on word boundaries.
@@ -510,7 +503,7 @@ xfs_idata_realloc(
 		WARN(1, "if_data realloc failed\n");
 		return;
 	}
-	ifp->if_u1.if_data = if_data;
+	ifp->if_u1.if_data = ZERO_OR_NULL_PTR(if_data) ? NULL : if_data;
 	ifp->if_bytes = new_size;
 }
 
-- 
2.26.0.106.g9fadedd


