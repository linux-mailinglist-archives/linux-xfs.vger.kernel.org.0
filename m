Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5309239C6E1
	for <lists+linux-xfs@lfdr.de>; Sat,  5 Jun 2021 10:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbhFEIy4 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 5 Jun 2021 04:54:56 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3439 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbhFEIyz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 5 Jun 2021 04:54:55 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FxtcY3fQqz6tpN;
        Sat,  5 Jun 2021 16:50:05 +0800 (CST)
Received: from dggpeml500023.china.huawei.com (7.185.36.114) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 5 Jun 2021 16:53:05 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 5 Jun 2021 16:53:05 +0800
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
To:     <linux-xfs@vger.kernel.org>
CC:     Shaokun Zhang <zhangshaokun@hisilicon.com>,
        "Darrick J. Wong" <djwong@kernel.org>
Subject: [PATCH] xfs: remove redundant initialization of variable error
Date:   Sat, 5 Jun 2021 16:52:50 +0800
Message-ID: <1622883170-33317-1-git-send-email-zhangshaokun@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

'error' will be initialized, so clean up the redundant initialization.

Cc: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
---
 fs/xfs/xfs_buf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 592800c8852f..59991c8c7127 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -707,7 +707,7 @@ xfs_buf_get_map(
 {
 	struct xfs_buf		*bp;
 	struct xfs_buf		*new_bp;
-	int			error = 0;
+	int			error;
 
 	*bpp = NULL;
 	error = xfs_buf_find(target, map, nmaps, flags, NULL, &bp);
-- 
2.7.4

