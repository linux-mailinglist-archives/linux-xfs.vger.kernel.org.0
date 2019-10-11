Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23751D3DF0
	for <lists+linux-xfs@lfdr.de>; Fri, 11 Oct 2019 13:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727653AbfJKLHs (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 11 Oct 2019 07:07:48 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:49958 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727198AbfJKLHs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 11 Oct 2019 07:07:48 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 84E421BF4096B01C14F3;
        Fri, 11 Oct 2019 19:07:45 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.439.0; Fri, 11 Oct 2019
 19:07:35 +0800
From:   yu kuai <yukuai3@huawei.com>
To:     <darrick.wong@oracle.com>, <bfoster@redhat.com>,
        <dchinner@redhat.com>
CC:     <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yukuai3@huawei.com>, <zhengbin13@huawei.com>,
        <yi.zhang@huawei.com>, <zhangxiaoxu5@huawei.com>
Subject: [PATCH] xfs: fix wrong struct type in ioctl definition whih cmd XFS_IOC_GETBMAPAX
Date:   Fri, 11 Oct 2019 19:14:46 +0800
Message-ID: <1570792486-84374-1-git-send-email-yukuai3@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

ioctl expect 'getbmapx' as the 'arg' when the cmd is XFS_IOC_GETBMAPX.
But the definition in 'xfs_fs.h' is 'getbmap'

So, change it to 'getbmapx'

Signed-off-by: yu kuai <yukuai3@huawei.com>
---
 fs/xfs/libxfs/xfs_fs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 39dd2b9..cad245a 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -764,7 +764,7 @@ struct xfs_scrub_metadata {
 #define XFS_IOC_FSGETXATTRA	_IOR ('X', 45, struct fsxattr)
 /*	XFS_IOC_SETBIOSIZE ---- deprecated 46	   */
 /*	XFS_IOC_GETBIOSIZE ---- deprecated 47	   */
-#define XFS_IOC_GETBMAPX	_IOWR('X', 56, struct getbmap)
+#define XFS_IOC_GETBMAPX	_IOWR('X', 56, struct getbmapx)
 #define XFS_IOC_ZERO_RANGE	_IOW ('X', 57, struct xfs_flock64)
 #define XFS_IOC_FREE_EOFBLOCKS	_IOR ('X', 58, struct xfs_fs_eofblocks)
 /*	XFS_IOC_GETFSMAP ------ hoisted 59         */
-- 
2.7.4

