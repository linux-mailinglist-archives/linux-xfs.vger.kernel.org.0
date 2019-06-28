Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A24695A3DB
	for <lists+linux-xfs@lfdr.de>; Fri, 28 Jun 2019 20:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbfF1Sfk (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 28 Jun 2019 14:35:40 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54224 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727015AbfF1Sfh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Jun 2019 14:35:37 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5SIYLol027892
        for <linux-xfs@vger.kernel.org>; Fri, 28 Jun 2019 18:35:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=g3Q2BzagA5RCgg60C+p3MWOnsvTH+2igiPYXy6Kk2Uc=;
 b=2x06ReB9xl1R8lCWb05NvGafDCzdH3u6yClxW1YbQI4A2q0qWBHCe7btjPBJCTP+QYzf
 QX1QJep1orlp/I0aZQoVrT4uGU1yrTfOYuhKqutnfy/nAgwtfQXfMtlO8uB6/GhMCR5S
 b83BTxIMScl5HuB2TkiwOEh1hlRiwkH/EoRkmaD5wonSckh1RkyDUYEyYqzZtC8l5siN
 /MIcpCnbyoFotDM2w/ZPxYIKghUx7vV+eLlg/LHvJxfbcu896XlXfjlLptOoJY13TPD9
 mCbV4Ac7UfWDW+O7Z9jtx+ME/A5sBmU3u3rW4QoiWNYnLp21B2qfT9ou5ZkHamFSDtfZ Sw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2t9c9q72ue-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 28 Jun 2019 18:35:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5SIYqFL152196
        for <linux-xfs@vger.kernel.org>; Fri, 28 Jun 2019 18:35:35 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2t9p6w23at-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 28 Jun 2019 18:35:35 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5SIZYVM029431
        for <linux-xfs@vger.kernel.org>; Fri, 28 Jun 2019 18:35:34 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Jun 2019 11:35:34 -0700
Subject: [PATCH 1/3] xfs: refactor setflags to use setattr code directly
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 28 Jun 2019 11:35:33 -0700
Message-ID: <156174693300.1557952.1660572699951099381.stgit@magnolia>
In-Reply-To: <156174692684.1557952.3770482995772643434.stgit@magnolia>
References: <156174692684.1557952.3770482995772643434.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9302 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906280209
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9302 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906280210
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Refactor the SETFLAGS implementation to use the SETXATTR code directly
instead of partially constructing a struct fsxattr and calling bits and
pieces of the setxattr code.  This reduces code size with no functional
change.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_ioctl.c |   48 +++---------------------------------------------
 1 file changed, 3 insertions(+), 45 deletions(-)


diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 552f18554c48..6f55cd7eb34f 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1490,11 +1490,8 @@ xfs_ioc_setxflags(
 	struct file		*filp,
 	void			__user *arg)
 {
-	struct xfs_trans	*tp;
 	struct fsxattr		fa;
-	struct fsxattr		old_fa;
 	unsigned int		flags;
-	int			join_flags = 0;
 	int			error;
 
 	if (copy_from_user(&flags, arg, sizeof(flags)))
@@ -1505,52 +1502,13 @@ xfs_ioc_setxflags(
 		      FS_SYNC_FL))
 		return -EOPNOTSUPP;
 
-	fa.fsx_xflags = xfs_merge_ioc_xflags(flags, xfs_ip2xflags(ip));
+	xfs_fill_fsxattr(ip, false, &fa);
+	fa.fsx_xflags = xfs_merge_ioc_xflags(flags, fa.fsx_xflags);
 
 	error = mnt_want_write_file(filp);
 	if (error)
 		return error;
-
-	error = xfs_ioctl_setattr_drain_writes(ip, &fa, &join_flags);
-	if (error) {
-		xfs_iunlock(ip, join_flags);
-		goto out_drop_write;
-	}
-
-	/*
-	 * Changing DAX config may require inode locking for mapping
-	 * invalidation. These need to be held all the way to transaction commit
-	 * or cancel time, so need to be passed through to
-	 * xfs_ioctl_setattr_get_trans() so it can apply them to the join call
-	 * appropriately.
-	 */
-	error = xfs_ioctl_setattr_dax_invalidate(ip, &fa, &join_flags);
-	if (error) {
-		xfs_iunlock(ip, join_flags);
-		goto out_drop_write;
-	}
-
-	tp = xfs_ioctl_setattr_get_trans(ip, join_flags);
-	if (IS_ERR(tp)) {
-		error = PTR_ERR(tp);
-		goto out_drop_write;
-	}
-
-	xfs_fill_fsxattr(ip, false, &old_fa);
-	error = vfs_ioc_fssetxattr_check(VFS_I(ip), &old_fa, &fa);
-	if (error) {
-		xfs_trans_cancel(tp);
-		goto out_drop_write;
-	}
-
-	error = xfs_ioctl_setattr_xflags(tp, ip, &fa);
-	if (error) {
-		xfs_trans_cancel(tp);
-		goto out_drop_write;
-	}
-
-	error = xfs_trans_commit(tp);
-out_drop_write:
+	error = xfs_ioctl_setattr(ip, &fa);
 	mnt_drop_write_file(filp);
 	return error;
 }

