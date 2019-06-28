Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04DC15A3DE
	for <lists+linux-xfs@lfdr.de>; Fri, 28 Jun 2019 20:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbfF1Sfu (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 28 Jun 2019 14:35:50 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54520 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726720AbfF1Sft (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Jun 2019 14:35:49 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5SIYMgP027898
        for <linux-xfs@vger.kernel.org>; Fri, 28 Jun 2019 18:35:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=fya9Obsx3ZSRYnp8K1DlvxRJi8CYOHUQy/GK4nVo/DQ=;
 b=TQpMsdkrJ4mqedVW5uw7MyfpcYtIK3RnflXNqdUbMigkLHYJIMZFH5UTdqYEN+WD2diY
 K6HJknlvqo6UDKlabPaDhj21a3A+Fmoj/e2EKJcFbmJu3e5ePbJy1nsEnSjqH2wicSDp
 T/AAqoqkYDI+8SS0a8FDiAyuTCViQ1yHxhMsYJ2WZZgveGFeItzazQMM5C1n4ZpxLQeU
 gL248ZmiaDydPIjV7oG3mL9g0fMyAWr1dmba80eE3inbaCPbsBVsehXcsc6rzC5g0TvO
 yeexxRsr0h1VQnSyztP9FM35uSdqQYW4d1wWDw9cn9FErtQM4Fw3rvr16P2T3xhMp2gS lg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2t9c9q72vf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 28 Jun 2019 18:35:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5SIY2qS141486
        for <linux-xfs@vger.kernel.org>; Fri, 28 Jun 2019 18:35:47 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2t99f5qv7f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 28 Jun 2019 18:35:47 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5SIZkeq029512
        for <linux-xfs@vger.kernel.org>; Fri, 28 Jun 2019 18:35:46 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Jun 2019 11:35:46 -0700
Subject: [PATCH 3/3] xfs: make the dax inode flag advisory
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 28 Jun 2019 11:35:45 -0700
Message-ID: <156174694534.1557952.14317442337573957232.stgit@magnolia>
In-Reply-To: <156174692684.1557952.3770482995772643434.stgit@magnolia>
References: <156174692684.1557952.3770482995772643434.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9302 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906280209
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9302 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906280210
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

We have no ability to change S_DAX on an inode, which means that this
flag is purely advisory.  Remove all the (broken) code that tried to
change the state since it's cluttering up the code for no good reason.
If the kernel ever gains the ability to change S_DAX on the fly we can
always add this back.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_ioctl.c |   76 ----------------------------------------------------
 1 file changed, 76 deletions(-)


diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index d2526d9070d2..dda681698555 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1001,12 +1001,6 @@ xfs_diflags_to_linux(
 		inode->i_flags |= S_NOATIME;
 	else
 		inode->i_flags &= ~S_NOATIME;
-#if 0	/* disabled until the flag switching races are sorted out */
-	if (xflags & FS_XFLAG_DAX)
-		inode->i_flags |= S_DAX;
-	else
-		inode->i_flags &= ~S_DAX;
-#endif
 }
 
 static int
@@ -1077,63 +1071,6 @@ xfs_ioctl_setattr_drain_writes(
 	return inode_drain_writes(inode);
 }
 
-/*
- * If we are changing DAX flags, we have to ensure the file is clean and any
- * cached objects in the address space are invalidated and removed. This
- * requires us to lock out other IO and page faults similar to a truncate
- * operation. The locks need to be held until the transaction has been committed
- * so that the cache invalidation is atomic with respect to the DAX flag
- * manipulation.
- *
- * The caller must use @join_flags to release the locks which are held on @ip
- * regardless of return value.
- */
-static int
-xfs_ioctl_setattr_dax_invalidate(
-	struct xfs_inode	*ip,
-	struct fsxattr		*fa,
-	int			*join_flags)
-{
-	struct inode		*inode = VFS_I(ip);
-	struct super_block	*sb = inode->i_sb;
-	int			error;
-
-	/*
-	 * It is only valid to set the DAX flag on regular files and
-	 * directories on filesystems where the block size is equal to the page
-	 * size. On directories it serves as an inherited hint so we don't
-	 * have to check the device for dax support or flush pagecache.
-	 */
-	if (fa->fsx_xflags & FS_XFLAG_DAX) {
-		if (!(S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode)))
-			return -EINVAL;
-		if (S_ISREG(inode->i_mode) &&
-		    !bdev_dax_supported(xfs_find_bdev_for_inode(VFS_I(ip)),
-				sb->s_blocksize))
-			return -EINVAL;
-	}
-
-	/* If the DAX state is not changing, we have nothing to do here. */
-	if ((fa->fsx_xflags & FS_XFLAG_DAX) && IS_DAX(inode))
-		return 0;
-	if (!(fa->fsx_xflags & FS_XFLAG_DAX) && !IS_DAX(inode))
-		return 0;
-
-	if (S_ISDIR(inode->i_mode))
-		return 0;
-
-	/* lock, flush and invalidate mapping in preparation for flag change */
-	if (*join_flags == 0) {
-		*join_flags = XFS_MMAPLOCK_EXCL | XFS_IOLOCK_EXCL;
-		xfs_ilock(ip, *join_flags);
-		error = filemap_write_and_wait(inode->i_mapping);
-		if (error)
-			return error;
-	}
-
-	return invalidate_inode_pages2(inode->i_mapping);
-}
-
 /*
  * Set up the transaction structure for the setattr operation, checking that we
  * have permission to do so. On success, return a clean transaction and the
@@ -1346,19 +1283,6 @@ xfs_ioctl_setattr(
 		goto error_free_dquots;
 	}
 
-	/*
-	 * Changing DAX config may require inode locking for mapping
-	 * invalidation. These need to be held all the way to transaction commit
-	 * or cancel time, so need to be passed through to
-	 * xfs_ioctl_setattr_get_trans() so it can apply them to the join call
-	 * appropriately.
-	 */
-	code = xfs_ioctl_setattr_dax_invalidate(ip, fa, &join_flags);
-	if (code) {
-		xfs_iunlock(ip, join_flags);
-		goto error_free_dquots;
-	}
-
 	tp = xfs_ioctl_setattr_get_trans(ip, join_flags);
 	if (IS_ERR(tp)) {
 		code = PTR_ERR(tp);

