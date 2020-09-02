Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28BC325A45E
	for <lists+linux-xfs@lfdr.de>; Wed,  2 Sep 2020 06:24:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgIBEYA (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 2 Sep 2020 00:24:00 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:36698 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725808AbgIBEX7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Sep 2020 00:23:59 -0400
X-IronPort-AV: E=Sophos;i="5.76,381,1592841600"; 
   d="scan'208";a="98820807"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 02 Sep 2020 12:23:58 +0800
Received: from G08CNEXMBPEKD05.g08.fujitsu.local (unknown [10.167.33.204])
        by cn.fujitsu.com (Postfix) with ESMTP id D3C1948990C9;
        Wed,  2 Sep 2020 12:23:56 +0800 (CST)
Received: from G08CNEXCHPEKD06.g08.fujitsu.local (10.167.33.205) by
 G08CNEXMBPEKD05.g08.fujitsu.local (10.167.33.204) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Wed, 2 Sep 2020 12:23:53 +0800
Received: from Fedora-31.g08.fujitsu.local (10.167.220.31) by
 G08CNEXCHPEKD06.g08.fujitsu.local (10.167.33.205) with Microsoft SMTP Server
 id 15.0.1497.2 via Frontend Transport; Wed, 2 Sep 2020 12:23:52 +0800
From:   Xiao Yang <yangx.jy@cn.fujitsu.com>
To:     <linux-xfs@vger.kernel.org>
CC:     <darrick.wong@oracle.com>, <ira.weiny@intel.com>,
        Xiao Yang <yangx.jy@cn.fujitsu.com>
Subject: [PATCH v2] xfs: Add check for unsupported xflags
Date:   Wed, 2 Sep 2020 12:06:01 +0800
Message-ID: <20200902040601.10293-1-yangx.jy@cn.fujitsu.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-yoursite-MailScanner-ID: D3C1948990C9.A9E44
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: yangx.jy@cn.fujitsu.com
X-Spam-Status: No
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Current ioctl(FSSETXATTR) ignores unsupported xflags silently
so it is not clear for user to know unsupported xflags.
For example, use ioctl(FSSETXATTR) to set dax flag on kernel
v4.4 which doesn't support dax flag:
--------------------------------
0
----------------X testfile
--------------------------------

Add check to return -EOPNOTSUPP as ext4/f2fs/btrfs does.

Signed-off-by: Xiao Yang <yangx.jy@cn.fujitsu.com>
---
 fs/xfs/xfs_ioctl.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 6f22a66777cd..e188e81961bd 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1425,6 +1425,14 @@ xfs_ioctl_setattr_check_projid(
 	return 0;
 }
 
+#define XFS_SUPPORTED_FS_XFLAGS \
+	(FS_XFLAG_REALTIME | FS_XFLAG_PREALLOC | FS_XFLAG_IMMUTABLE | \
+	 FS_XFLAG_APPEND | FS_XFLAG_SYNC | FS_XFLAG_NOATIME | FS_XFLAG_NODUMP | \
+	 FS_XFLAG_RTINHERIT | FS_XFLAG_PROJINHERIT | FS_XFLAG_NOSYMLINKS | \
+	 FS_XFLAG_EXTSIZE | FS_XFLAG_EXTSZINHERIT | FS_XFLAG_NODEFRAG | \
+	 FS_XFLAG_FILESTREAM | FS_XFLAG_DAX | FS_XFLAG_COWEXTSIZE | \
+	 FS_XFLAG_HASATTR)
+
 STATIC int
 xfs_ioctl_setattr(
 	xfs_inode_t		*ip,
@@ -1439,6 +1447,10 @@ xfs_ioctl_setattr(
 
 	trace_xfs_ioctl_setattr(ip);
 
+	/* Check if fsx_xflags has unsupported xflags */
+	if (fa->fsx_xflags & ~XFS_SUPPORTED_FS_XFLAGS)
+                return -EOPNOTSUPP;
+
 	code = xfs_ioctl_setattr_check_projid(ip, fa);
 	if (code)
 		return code;
-- 
2.25.1



