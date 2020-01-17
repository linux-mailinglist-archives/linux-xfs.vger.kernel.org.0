Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2C28140191
	for <lists+linux-xfs@lfdr.de>; Fri, 17 Jan 2020 02:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729399AbgAQBun (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 16 Jan 2020 20:50:43 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9181 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729602AbgAQBun (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Jan 2020 20:50:43 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 72BF3EE69A289885EECF;
        Fri, 17 Jan 2020 09:50:39 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Fri, 17 Jan 2020
 09:50:31 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <darrick.wong@oracle.com>, <linux-xfs@vger.kernel.org>,
        <hch@lst.de>
CC:     <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] xfs: remove unused variable 'done'
Date:   Fri, 17 Jan 2020 09:50:11 +0800
Message-ID: <20200117015011.50412-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

fs/xfs/xfs_inode.c: In function 'xfs_itruncate_extents_flags':
fs/xfs/xfs_inode.c:1523:8: warning: unused variable 'done' [-Wunused-variable]

commit 4bbb04abb4ee ("xfs: truncate should remove
all blocks, not just to the end of the page cache")
left behind this, so remove it.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 fs/xfs/xfs_inode.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 1309f25..1979a00 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1520,7 +1520,6 @@ xfs_itruncate_extents_flags(
 	xfs_fileoff_t		first_unmap_block;
 	xfs_filblks_t		unmap_len;
 	int			error = 0;
-	int			done = 0;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(!atomic_read(&VFS_I(ip)->i_count) ||
-- 
2.7.4


