Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6E121C30D
	for <lists+linux-xfs@lfdr.de>; Sat, 11 Jul 2020 09:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbgGKHa4 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 11 Jul 2020 03:30:56 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:7294 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727984AbgGKHa4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 11 Jul 2020 03:30:56 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 8B7A4AF53CFD87EFBA87;
        Sat, 11 Jul 2020 15:30:53 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Sat, 11 Jul 2020 15:30:42 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     "Darrick J . Wong" <darrick.wong@oracle.com>
CC:     YueHaibing <yuehaibing@huawei.com>, <linux-xfs@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH -next] xfs: remove duplicated include from xfs_buf_item.c
Date:   Sat, 11 Jul 2020 07:34:58 +0000
Message-ID: <20200711073458.27029-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Remove duplicated include.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 fs/xfs/xfs_buf_item.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index e9428c30862a..ed1bf1d99483 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -19,7 +19,6 @@
 #include "xfs_quota.h"
 #include "xfs_dquot_item.h"
 #include "xfs_dquot.h"
-#include "xfs_trans_priv.h"
 #include "xfs_trace.h"
 #include "xfs_log.h"
 





