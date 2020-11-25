Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEF1A2C3945
	for <lists+linux-xfs@lfdr.de>; Wed, 25 Nov 2020 07:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbgKYGqZ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 25 Nov 2020 01:46:25 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7678 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbgKYGqY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Nov 2020 01:46:24 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4Cgry20BZ6z15L7C;
        Wed, 25 Nov 2020 14:46:02 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Wed, 25 Nov 2020 14:46:13 +0800
From:   Qinglang Miao <miaoqinglang@huawei.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        <linux-xfs@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        Qinglang Miao <miaoqinglang@huawei.com>
Subject: [PATCH] xfs: check the return value of krealloc() in xfs_uuid_mount
Date:   Wed, 25 Nov 2020 14:50:36 +0800
Message-ID: <20201125065036.154312-1-miaoqinglang@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

krealloc() may fail to expand the memory space. Add sanity checks to it,
and WARN() if that really happened.

Fixes: 771915c4f688 ("xfs: remove kmem_realloc()")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
---
 fs/xfs/xfs_mount.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 150ee5cb8..c07f48c32 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -80,9 +80,13 @@ xfs_uuid_mount(
 	}
 
 	if (hole < 0) {
-		xfs_uuid_table = krealloc(xfs_uuid_table,
+		uuid_t *if_xfs_uuid_table;
+		if_xfs_uuid_table = krealloc(xfs_uuid_table,
 			(xfs_uuid_table_size + 1) * sizeof(*xfs_uuid_table),
 			GFP_KERNEL | __GFP_NOFAIL);
+		if (!if_xfs_uuid_table)
+			goto out_duplicate;
+		xfs_uuid_table = if_xfs_uuid_table;
 		hole = xfs_uuid_table_size++;
 	}
 	xfs_uuid_table[hole] = *uuid;
-- 
2.23.0

