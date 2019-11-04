Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16B1AEDDB3
	for <lists+linux-xfs@lfdr.de>; Mon,  4 Nov 2019 12:29:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727771AbfKDL3V (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 4 Nov 2019 06:29:21 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:5699 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726364AbfKDL3V (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 4 Nov 2019 06:29:21 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 6023DD631EBB6FB0997D;
        Mon,  4 Nov 2019 19:29:17 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Mon, 4 Nov 2019 19:29:09 +0800
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
To:     <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Yang Guo <guoyang2@huawei.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>
Subject: [PATCH] xfs: optimise xfs_mod_icount/ifree when delta < 0
Date:   Mon, 4 Nov 2019 19:29:40 +0800
Message-ID: <1572866980-13001-1-git-send-email-zhangshaokun@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Yang Guo <guoyang2@huawei.com>

percpu_counter_compare will be called by xfs_mod_icount/ifree to check
whether the counter less than 0 and it is a expensive function.
let's check it only when delta < 0, it will be good for xfs's performance.

Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Signed-off-by: Yang Guo <guoyang2@huawei.com>
Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
---
 fs/xfs/xfs_mount.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index ba5b6f3b2b88..5e8314e6565e 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1174,6 +1174,9 @@ xfs_mod_icount(
 	int64_t			delta)
 {
 	percpu_counter_add_batch(&mp->m_icount, delta, XFS_ICOUNT_BATCH);
+	if (delta > 0)
+		return 0;
+
 	if (__percpu_counter_compare(&mp->m_icount, 0, XFS_ICOUNT_BATCH) < 0) {
 		ASSERT(0);
 		percpu_counter_add(&mp->m_icount, -delta);
@@ -1188,6 +1191,9 @@ xfs_mod_ifree(
 	int64_t			delta)
 {
 	percpu_counter_add(&mp->m_ifree, delta);
+	if (delta > 0)
+		return 0;
+
 	if (percpu_counter_compare(&mp->m_ifree, 0) < 0) {
 		ASSERT(0);
 		percpu_counter_add(&mp->m_ifree, -delta);
-- 
2.7.4

