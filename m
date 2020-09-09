Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0D9F262E46
	for <lists+linux-xfs@lfdr.de>; Wed,  9 Sep 2020 14:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729993AbgIIMCH (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 9 Sep 2020 08:02:07 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:55368 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730140AbgIIMAp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 9 Sep 2020 08:00:45 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 658D98FDACFF76C07082;
        Wed,  9 Sep 2020 20:00:43 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Wed, 9 Sep 2020
 20:00:37 +0800
From:   Zheng Bin <zhengbin13@huawei.com>
To:     <darrick.wong@oracle.com>, <linux-xfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <zhengbin13@huawei.com>
Subject: [PATCH -next] xfs: Remove unneeded semicolon
Date:   Wed, 9 Sep 2020 20:07:32 +0800
Message-ID: <20200909120733.115415-1-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.26.0.106.g9fadedd
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Fixes coccicheck warning:

fs/xfs/xfs_icache.c:1214:2-3: Unneeded semicolon

Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
---
 fs/xfs/xfs_icache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 101028ebb571..5e926912e507 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1211,7 +1211,7 @@ xfs_reclaim_inodes(
 	while (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_RECLAIM_TAG)) {
 		xfs_ail_push_all_sync(mp->m_ail);
 		xfs_reclaim_inodes_ag(mp, &nr_to_scan);
-	};
+	}
 }

 /*
--
2.26.0.106.g9fadedd

