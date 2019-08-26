Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E79739D032
	for <lists+linux-xfs@lfdr.de>; Mon, 26 Aug 2019 15:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729808AbfHZNPP (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 26 Aug 2019 09:15:15 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:5215 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729535AbfHZNPO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 26 Aug 2019 09:15:14 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 83D8263EBA05C5D9B066;
        Mon, 26 Aug 2019 21:15:10 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Mon, 26 Aug 2019
 21:15:03 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <darrick.wong@oracle.com>, <sandeen@sandeen.net>,
        <bfoster@redhat.com>, <david@fromorbit.com>,
        <linux-xfs@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <zhengbin13@huawei.com>
Subject: [PATCH] xfs: remove excess function parameter description in 'xfs_btree_sblock_v5hdr_verify'
Date:   Mon, 26 Aug 2019 21:21:35 +0800
Message-ID: <1566825695-90533-1-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Fixes gcc warning:

fs/xfs/libxfs/xfs_btree.c:4475: warning: Excess function parameter 'max_recs' description in 'xfs_btree_sblock_v5hdr_verify'
fs/xfs/libxfs/xfs_btree.c:4475: warning: Excess function parameter 'pag_max_level' description in 'xfs_btree_sblock_v5hdr_verify'

Fixes: c5ab131ba0df ("libxfs: refactor short btree block verification")
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 fs/xfs/libxfs/xfs_btree.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index f1048ef..802eb53 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -4466,8 +4466,6 @@ xfs_btree_lblock_verify(
  *				      btree block
  *
  * @bp: buffer containing the btree block
- * @max_recs: pointer to the m_*_mxr max records field in the xfs mount
- * @pag_max_level: pointer to the per-ag max level field
  */
 xfs_failaddr_t
 xfs_btree_sblock_v5hdr_verify(
--
2.7.4

