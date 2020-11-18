Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BEDD2B7C25
	for <lists+linux-xfs@lfdr.de>; Wed, 18 Nov 2020 12:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbgKRLMI (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 18 Nov 2020 06:12:08 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8108 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726780AbgKRLMH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Nov 2020 06:12:07 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Cbg9r6vQtzLq7D;
        Wed, 18 Nov 2020 19:11:44 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.487.0; Wed, 18 Nov 2020
 19:11:58 +0800
From:   Yu Kuai <yukuai3@huawei.com>
To:     <darrick.wong@oracle.com>, <linux-xfs@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <yukuai3@huawei.com>,
        <yi.zhang@huawei.com>, <zhangxiaoxu5@huawei.com>
Subject: [PATCH] xfs: return corresponding errcode if xfs_initialize_perag() fail
Date:   Wed, 18 Nov 2020 19:15:31 +0800
Message-ID: <20201118111531.455814-1-yukuai3@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In xfs_initialize_perag(), if kmem_zalloc(), xfs_buf_hash_init(), or
radix_tree_preload() failed, the returned value 'error' is not set
accordingly.

Fixes: commit 8b26c5825e02 ("xfs: handle ENOMEM correctly during initialisation of perag structures")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 fs/xfs/xfs_mount.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 150ee5cb8645..7110507a2b6b 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -194,20 +194,25 @@ xfs_initialize_perag(
 		}
 
 		pag = kmem_zalloc(sizeof(*pag), KM_MAYFAIL);
-		if (!pag)
+		if (!pag) {
+			error = -ENOMEM;
 			goto out_unwind_new_pags;
+		}
 		pag->pag_agno = index;
 		pag->pag_mount = mp;
 		spin_lock_init(&pag->pag_ici_lock);
 		INIT_RADIX_TREE(&pag->pag_ici_root, GFP_ATOMIC);
-		if (xfs_buf_hash_init(pag))
+
+		error = xfs_buf_hash_init(pag);
+		if (error)
 			goto out_free_pag;
 		init_waitqueue_head(&pag->pagb_wait);
 		spin_lock_init(&pag->pagb_lock);
 		pag->pagb_count = 0;
 		pag->pagb_tree = RB_ROOT;
 
-		if (radix_tree_preload(GFP_NOFS))
+		error = radix_tree_preload(GFP_NOFS);
+		if (error)
 			goto out_hash_destroy;
 
 		spin_lock(&mp->m_perag_lock);
-- 
2.25.4

