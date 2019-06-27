Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FAB157D2F
	for <lists+linux-xfs@lfdr.de>; Thu, 27 Jun 2019 09:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbfF0Hd4 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 27 Jun 2019 03:33:56 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:19086 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726059AbfF0Hd4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 Jun 2019 03:33:56 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 582B4B17A415822EB0EA;
        Thu, 27 Jun 2019 15:33:53 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Thu, 27 Jun 2019
 15:33:44 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <darrick.wong@oracle.com>, <hch@lst.de>, <dchinner@redhat.com>
CC:     <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] xfs: remove duplicated include
Date:   Thu, 27 Jun 2019 15:33:23 +0800
Message-ID: <20190627073323.45516-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Remove duplicated include.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 fs/xfs/xfs_extfree_item.c | 1 -
 fs/xfs/xfs_filestream.c   | 1 -
 fs/xfs/xfs_pnfs.c         | 1 -
 3 files changed, 3 deletions(-)

diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 99fd40eb..e515506 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -13,7 +13,6 @@
 #include "xfs_mount.h"
 #include "xfs_defer.h"
 #include "xfs_trans.h"
-#include "xfs_trans.h"
 #include "xfs_trans_priv.h"
 #include "xfs_buf_item.h"
 #include "xfs_extfree_item.h"
diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index b1869ae..a6d228c 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -21,7 +21,6 @@
 #include "xfs_trace.h"
 #include "xfs_ag_resv.h"
 #include "xfs_trans.h"
-#include "xfs_shared.h"
 
 struct xfs_fstrm_item {
 	struct xfs_mru_cache_elem	mru;
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index 2d95355..6018e1c 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -17,7 +17,6 @@
 #include "xfs_bmap_util.h"
 #include "xfs_error.h"
 #include "xfs_iomap.h"
-#include "xfs_shared.h"
 #include "xfs_bit.h"
 #include "xfs_pnfs.h"
 
-- 
2.7.4


