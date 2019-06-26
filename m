Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71B9655E91
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Jun 2019 04:33:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbfFZCdu (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Jun 2019 22:33:50 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58204 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbfFZCdq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jun 2019 22:33:46 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5Q2Stk9116586
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 02:33:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=7zhpIODEEv8qOAC5Apa/NANkySKQwuE1Y3ev3GJ07jc=;
 b=cLgkEebbef1MGrQN6l5OPo5LV8+JhXBgR/bHYW+Wj7NI0EYvIWSRxs4NCWb1jy+YCb2m
 QArY/fGGaW3VCKpGBeQFuQzjDmlRRigoNzHDR14OEYLqEZV8DIVQp10DNQTU4YpGjdBa
 Tg3SxtwimmEOTsapiNn/rl1i1S1o6DZvEzpxamhKqWJGsaQj4pNF/W4ComKMprsA1iyH
 v1DYSOlddg0/3jILOcTCFAxCjZXxbQo2zeGLFdKODPxweImDm1SMCUu9ui/8sxhvKjOC
 3fmH8IaBsZ+sb3HTQbDsx81Y5CItceGYQRJGwFEK5N3eZacoEj1QQYEeHS4im0Yr/H/5 zw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2t9brt7mnq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 02:33:44 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5Q2WYQA021227
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 02:33:44 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2t99f4719w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 02:33:44 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5Q2XhZB020665
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 02:33:43 GMT
Received: from localhost (/10.159.230.235)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 25 Jun 2019 19:33:43 -0700
Subject: [PATCH 1/3] xfs: refactor setflags to use setattr code directly
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 25 Jun 2019 19:33:42 -0700
Message-ID: <156151642236.2283767.1842673695620969733.stgit@magnolia>
In-Reply-To: <156151641630.2283767.9637137346807567604.stgit@magnolia>
References: <156151641630.2283767.9637137346807567604.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9299 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906260028
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9299 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906260027
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
index 723550c8a2e4..7a9076867a30 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1491,11 +1491,8 @@ xfs_ioc_setxflags(
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
@@ -1506,52 +1503,13 @@ xfs_ioc_setxflags(
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

