Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4728A3541
	for <lists+linux-xfs@lfdr.de>; Fri, 30 Aug 2019 12:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbfH3KxQ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Aug 2019 06:53:16 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:5257 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726726AbfH3KxQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 30 Aug 2019 06:53:16 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 85263DCBE0562A62B2F4;
        Fri, 30 Aug 2019 18:53:13 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Fri, 30 Aug 2019
 18:53:06 +0800
From:   yu kuai <yukuai3@huawei.com>
To:     <darrick.wong@oracle.com>, <linux-xfs@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <yukuai3@huawei.com>, <zhengbin13@huawei.com>,
        <yi.zhang@huawei.com>
Subject: [PATCH] xfs: add function name in xfs_trans_ail_delete function header comments
Date:   Fri, 30 Aug 2019 18:59:49 +0800
Message-ID: <1567162789-137056-1-git-send-email-yukuai3@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Fix following warning:
make W=1 fs/xfs/xfs_trans_ail.o
fs/xfs/xfs_trans_ail.c:793: warning: Function parameter or member 
'ailp' not described in 'xfs_trans_ail_delete'
fs/xfs/xfs_trans_ail.c:793: warning: Function parameter or member
'lip' not described in 'xfs_trans_ail_delete'
fs/xfs/xfs_trans_ail.c:793: warning: Function parameter or member
'shutdown_type' not described in 'xfs_trans_ail_delete'

Since function parameters are described in the comments aready,
there is no need to add parameter comments.
Signed-off-by: yu kuai <yukuai3@huawei.com>
---
 fs/xfs/xfs_trans_ail.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 6ccfd75..b69cf59 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -764,8 +764,8 @@ xfs_ail_delete_one(
 	return mlip == lip;
 }
 
-/**
- * Remove a log items from the AIL
+/*
+ * xfs_trans_ail_delete - remove a log items from the AIL
  *
  * @xfs_trans_ail_delete_bulk takes an array of log items that all need to
  * removed from the AIL. The caller is already holding the AIL lock, and done
-- 
2.7.4

