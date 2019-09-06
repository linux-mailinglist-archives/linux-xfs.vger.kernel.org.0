Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8B1BAB25E
	for <lists+linux-xfs@lfdr.de>; Fri,  6 Sep 2019 08:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389455AbfIFGUM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 6 Sep 2019 02:20:12 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:40232 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726525AbfIFGUM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 6 Sep 2019 02:20:12 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id F0203237696BBB70532A;
        Fri,  6 Sep 2019 14:20:09 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Fri, 6 Sep 2019
 14:20:00 +0800
From:   yu kuai <yukuai3@huawei.com>
To:     <darrick.wong@oracle.com>, <sandeen@redhat.com>,
        <billodo@redhat.com>
CC:     <linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yukuai3@huawei.com>, <yi.zhang@huawei.com>,
        <zhengbin13@huawei.com>
Subject: [PATCH] xfs: include QUOTA, FATAL ASSERT build options in XFS_BUILD_OPTIONS
Date:   Fri, 6 Sep 2019 14:26:46 +0800
Message-ID: <1567751206-128735-1-git-send-email-yukuai3@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In commit d03a2f1b9fa8 ("xfs: include WARN, REPAIR build options in
XFS_BUILD_OPTIONS"), Eric pointed out that the XFS_BUILD_OPTIONS string,
shown at module init time and in modinfo output, does not currently
include all available build options. So, he added in CONFIG_XFS_WARN and
CONFIG_XFS_REPAIR. However, this is not enough, add in CONFIG_XFS_QUOTA
and CONFIG_XFS_ASSERT_FATAL. 

Signed-off-by: yu kuai <yukuai3@huawei.com>
---
 fs/xfs/xfs_super.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/xfs/xfs_super.h b/fs/xfs/xfs_super.h
index 763e43d..b552cf6 100644
--- a/fs/xfs/xfs_super.h
+++ b/fs/xfs/xfs_super.h
@@ -11,9 +11,11 @@
 #ifdef CONFIG_XFS_QUOTA
 extern int xfs_qm_init(void);
 extern void xfs_qm_exit(void);
+# define XFS_QUOTA_STRING	"quota, "
 #else
 # define xfs_qm_init()	(0)
 # define xfs_qm_exit()	do { } while (0)
+# define XFS_QUOTA_STRING
 #endif
 
 #ifdef CONFIG_XFS_POSIX_ACL
@@ -50,6 +52,12 @@ extern void xfs_qm_exit(void);
 # define XFS_WARN_STRING
 #endif
 
+#ifdef CONFIG_XFS_ASSERT_FATAL
+# define XFS_ASSERT_FATAL_STRING	"fatal assert, "
+#else
+# define XFS_ASSERT_FATAL_STRING
+#endif
+
 #ifdef DEBUG
 # define XFS_DBG_STRING		"debug"
 #else
@@ -63,6 +71,8 @@ extern void xfs_qm_exit(void);
 				XFS_SCRUB_STRING \
 				XFS_REPAIR_STRING \
 				XFS_WARN_STRING \
+				XFS_QUOTA_STRING \
+				XFS_ASSERT_FATAL_STRING \
 				XFS_DBG_STRING /* DBG must be last */
 
 struct xfs_inode;
-- 
2.7.4

