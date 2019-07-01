Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BACA255E9C
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Jun 2019 04:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbfFZCd7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Jun 2019 22:33:59 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53630 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726646AbfFZCd6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jun 2019 22:33:58 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5Q2TSGd026675
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 02:33:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=ee0uFfM349vghmnXwO0fhxtd9iBghXRqFR+n6aJPZvM=;
 b=RfLHaSIXZRBU8rieNLDJqjaMH1sUm0R6GsLF9p5/sQ+eCwyPK8RKqj2QXSJscJE/uoDU
 f4uKh58w94KNmfKsxSWTGfCj03wZ/fQZ6WUImahno6144qHS0smzMrWZtLLhmCg8O1XG
 WhUYxM/MpSGIDI7vt/vXgAoz/iKou59K5C+fVJG9+jp1FGOc0T+a93QtmACNQhDHbC/N
 OJ32UFidOncMbRybX9cD466h9Yk3+GYjsEXTPXwy+oDuj+GJM4e4blfCpGXtgOVI9tCI
 w6+YG2K5mRPdvZqMXphCH8unl1Al0qlnA7PhkBlgfDBV9yp88WE2QbIq7R1I9GGrlw0m IA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2t9c9pqjn6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 02:33:57 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5Q2WkMf020695
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 02:33:56 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2t9p6uh2p7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 02:33:56 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5Q2Xtrj024620
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 02:33:55 GMT
Received: from localhost (/10.159.230.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 25 Jun 2019 19:33:55 -0700
Subject: [PATCH 3/3] xfs: make the dax inode flag advisory
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 25 Jun 2019 19:33:54 -0700
Message-ID: <156151643447.2283767.3325726340667217253.stgit@magnolia>
In-Reply-To: <156151641630.2283767.9637137346807567604.stgit@magnolia>
References: <156151641630.2283767.9637137346807567604.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9299 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906260028
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9299 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906260027
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
index c28f4263bac2..caa90d65aa74 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1002,12 +1002,6 @@ xfs_diflags_to_linux(
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
@@ -1078,63 +1072,6 @@ xfs_ioctl_setattr_drain_writes(
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
@@ -1347,19 +1284,6 @@ xfs_ioctl_setattr(
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

