Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 166DF22E913
	for <lists+linux-xfs@lfdr.de>; Mon, 27 Jul 2020 11:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgG0JfE (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 27 Jul 2020 05:35:04 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:12171 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726139AbgG0JfE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Jul 2020 05:35:04 -0400
X-IronPort-AV: E=Sophos;i="5.75,401,1589212800"; 
   d="scan'208";a="96909954"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 27 Jul 2020 17:35:02 +0800
Received: from G08CNEXMBPEKD05.g08.fujitsu.local (unknown [10.167.33.204])
        by cn.fujitsu.com (Postfix) with ESMTP id 555624CE2808;
        Mon, 27 Jul 2020 17:35:01 +0800 (CST)
Received: from G08CNEXCHPEKD05.g08.fujitsu.local (10.167.33.203) by
 G08CNEXMBPEKD05.g08.fujitsu.local (10.167.33.204) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Mon, 27 Jul 2020 17:35:04 +0800
Received: from Fedora-30.g08.fujitsu.local (10.167.220.106) by
 G08CNEXCHPEKD05.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.2 via Frontend Transport; Mon, 27 Jul 2020 17:35:04 +0800
From:   Xiao Yang <yangx.jy@cn.fujitsu.com>
To:     <darrick.wong@oracle.com>, <ira.weiny@intel.com>
CC:     <linux-xfs@vger.kernel.org>, Xiao Yang <yangx.jy@cn.fujitsu.com>
Subject: [PATCH] fs/xfs: Support that ioctl(SETXFLAGS/GETXFLAGS) can set/get inode DAX on XFS.
Date:   Mon, 27 Jul 2020 17:27:44 +0800
Message-ID: <20200727092744.2641-1-yangx.jy@cn.fujitsu.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-yoursite-MailScanner-ID: 555624CE2808.A7DC5
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: yangx.jy@cn.fujitsu.com
X-Spam-Status: No
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

1) FS_DAX_FL has been introduced by commit b383a73f2b83.
2) In future, chattr/lsattr command from e2fsprogs can set/get
   inode DAX on XFS by calling ioctl(SETXFLAGS/GETXFLAGS).

Signed-off-by: Xiao Yang <yangx.jy@cn.fujitsu.com>
---
 fs/xfs/xfs_ioctl.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index a190212ca85d..6f22a66777cd 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1075,13 +1075,18 @@ xfs_merge_ioc_xflags(
 		xflags |= FS_XFLAG_NODUMP;
 	else
 		xflags &= ~FS_XFLAG_NODUMP;
+	if (flags & FS_DAX_FL)
+		xflags |= FS_XFLAG_DAX;
+	else
+		xflags &= ~FS_XFLAG_DAX;
 
 	return xflags;
 }
 
 STATIC unsigned int
 xfs_di2lxflags(
-	uint16_t	di_flags)
+	uint16_t	di_flags,
+	uint64_t	di_flags2)
 {
 	unsigned int	flags = 0;
 
@@ -1095,6 +1100,9 @@ xfs_di2lxflags(
 		flags |= FS_NOATIME_FL;
 	if (di_flags & XFS_DIFLAG_NODUMP)
 		flags |= FS_NODUMP_FL;
+	if (di_flags2 & XFS_DIFLAG2_DAX) {
+		flags |= FS_DAX_FL;
+	}
 	return flags;
 }
 
@@ -1565,7 +1573,7 @@ xfs_ioc_getxflags(
 {
 	unsigned int		flags;
 
-	flags = xfs_di2lxflags(ip->i_d.di_flags);
+	flags = xfs_di2lxflags(ip->i_d.di_flags, ip->i_d.di_flags2);
 	if (copy_to_user(arg, &flags, sizeof(flags)))
 		return -EFAULT;
 	return 0;
@@ -1588,7 +1596,7 @@ xfs_ioc_setxflags(
 
 	if (flags & ~(FS_IMMUTABLE_FL | FS_APPEND_FL | \
 		      FS_NOATIME_FL | FS_NODUMP_FL | \
-		      FS_SYNC_FL))
+		      FS_SYNC_FL | FS_DAX_FL))
 		return -EOPNOTSUPP;
 
 	fa.fsx_xflags = xfs_merge_ioc_xflags(flags, xfs_ip2xflags(ip));
-- 
2.21.0



