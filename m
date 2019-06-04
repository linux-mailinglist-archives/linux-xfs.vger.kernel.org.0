Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4AD235235
	for <lists+linux-xfs@lfdr.de>; Tue,  4 Jun 2019 23:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbfFDVty (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 4 Jun 2019 17:49:54 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58436 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbfFDVtx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jun 2019 17:49:53 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x54LnaSM053362;
        Tue, 4 Jun 2019 21:49:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=1b7diM5WfN04GNY/lXdXD0MvTPr0mMD5odIP7dz4HGY=;
 b=Cq0qYJdxtbQZ+UsyGqXDcOtIEMn7gopcySC34MTFD1fuXPe4bf2OrEqMM8UkZ4yhjEBp
 MlDUIB5FY+Mxk7SAIttbPkK/GvvggXco7xgJNvr2X+prxUwr69BoIXZeH8zb/oEB9fH+
 LcfgV0sAfi4TH5URc8QXwPfU6P2BXK936h8mruvjwswGQKd9ZTNPu2fCoMThdQNkEYDQ
 GVSS6VBnaBSEd0daXSuX4361c9Q7+ZAFcjgjn2cpYdVqsD8UgnqldZvvejLr3fgahiXI
 LOlTUxjYBePnM+bXzaBE6Lsj04B0Hgm8BpPwNK6EXu8lZbNuaN5+kVhoQ7IK5uqjxZCH Hw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2sugstfp7e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Jun 2019 21:49:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x54Lluqi041491;
        Tue, 4 Jun 2019 21:49:43 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2swnghkjg2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Jun 2019 21:49:43 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x54Lngno024788;
        Tue, 4 Jun 2019 21:49:42 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Jun 2019 14:49:41 -0700
Subject: [PATCH 02/10] xfs: convert quotacheck to use the new iwalk functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Date:   Tue, 04 Jun 2019 14:49:40 -0700
Message-ID: <155968498085.1657646.3518168545540841602.stgit@magnolia>
In-Reply-To: <155968496814.1657646.13743491598480818627.stgit@magnolia>
References: <155968496814.1657646.13743491598480818627.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9278 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906040138
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9278 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906040138
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Convert quotacheck to use the new iwalk iterator to dig through the
inodes.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_qm.c |   62 ++++++++++++++++++-------------------------------------
 1 file changed, 20 insertions(+), 42 deletions(-)


diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index aa6b6db3db0e..a5b2260406a8 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -26,6 +26,7 @@
 #include "xfs_trace.h"
 #include "xfs_icache.h"
 #include "xfs_cksum.h"
+#include "xfs_iwalk.h"
 
 /*
  * The global quota manager. There is only one of these for the entire
@@ -1118,17 +1119,15 @@ xfs_qm_quotacheck_dqadjust(
 /* ARGSUSED */
 STATIC int
 xfs_qm_dqusage_adjust(
-	xfs_mount_t	*mp,		/* mount point for filesystem */
-	xfs_ino_t	ino,		/* inode number to get data for */
-	void		__user *buffer,	/* not used */
-	int		ubsize,		/* not used */
-	int		*ubused,	/* not used */
-	int		*res)		/* result code value */
+	struct xfs_mount	*mp,
+	struct xfs_trans	*tp,
+	xfs_ino_t		ino,
+	void			*data)
 {
-	xfs_inode_t	*ip;
-	xfs_qcnt_t	nblks;
-	xfs_filblks_t	rtblks = 0;	/* total rt blks */
-	int		error;
+	struct xfs_inode	*ip;
+	xfs_qcnt_t		nblks;
+	xfs_filblks_t		rtblks = 0;	/* total rt blks */
+	int			error;
 
 	ASSERT(XFS_IS_QUOTA_RUNNING(mp));
 
@@ -1136,20 +1135,18 @@ xfs_qm_dqusage_adjust(
 	 * rootino must have its resources accounted for, not so with the quota
 	 * inodes.
 	 */
-	if (xfs_is_quota_inode(&mp->m_sb, ino)) {
-		*res = BULKSTAT_RV_NOTHING;
-		return -EINVAL;
-	}
+	if (xfs_is_quota_inode(&mp->m_sb, ino))
+		return 0;
 
 	/*
 	 * We don't _need_ to take the ilock EXCL here because quotacheck runs
 	 * at mount time and therefore nobody will be racing chown/chproj.
 	 */
-	error = xfs_iget(mp, NULL, ino, XFS_IGET_DONTCACHE, 0, &ip);
-	if (error) {
-		*res = BULKSTAT_RV_NOTHING;
+	error = xfs_iget(mp, tp, ino, XFS_IGET_DONTCACHE, 0, &ip);
+	if (error == -EINVAL || error == -ENOENT)
+		return 0;
+	if (error)
 		return error;
-	}
 
 	ASSERT(ip->i_delayed_blks == 0);
 
@@ -1157,7 +1154,7 @@ xfs_qm_dqusage_adjust(
 		struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
 
 		if (!(ifp->if_flags & XFS_IFEXTENTS)) {
-			error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
+			error = xfs_iread_extents(tp, ip, XFS_DATA_FORK);
 			if (error)
 				goto error0;
 		}
@@ -1200,13 +1197,8 @@ xfs_qm_dqusage_adjust(
 			goto error0;
 	}
 
-	xfs_irele(ip);
-	*res = BULKSTAT_RV_DIDONE;
-	return 0;
-
 error0:
 	xfs_irele(ip);
-	*res = BULKSTAT_RV_GIVEUP;
 	return error;
 }
 
@@ -1270,18 +1262,13 @@ STATIC int
 xfs_qm_quotacheck(
 	xfs_mount_t	*mp)
 {
-	int			done, count, error, error2;
-	xfs_ino_t		lastino;
-	size_t			structsz;
+	int			error, error2;
 	uint			flags;
 	LIST_HEAD		(buffer_list);
 	struct xfs_inode	*uip = mp->m_quotainfo->qi_uquotaip;
 	struct xfs_inode	*gip = mp->m_quotainfo->qi_gquotaip;
 	struct xfs_inode	*pip = mp->m_quotainfo->qi_pquotaip;
 
-	count = INT_MAX;
-	structsz = 1;
-	lastino = 0;
 	flags = 0;
 
 	ASSERT(uip || gip || pip);
@@ -1318,18 +1305,9 @@ xfs_qm_quotacheck(
 		flags |= XFS_PQUOTA_CHKD;
 	}
 
-	do {
-		/*
-		 * Iterate thru all the inodes in the file system,
-		 * adjusting the corresponding dquot counters in core.
-		 */
-		error = xfs_bulkstat(mp, &lastino, &count,
-				     xfs_qm_dqusage_adjust,
-				     structsz, NULL, &done);
-		if (error)
-			break;
-
-	} while (!done);
+	error = xfs_iwalk(mp, NULL, 0, xfs_qm_dqusage_adjust, 0, NULL);
+	if (error)
+		goto error_return;
 
 	/*
 	 * We've made all the changes that we need to make incore.  Flush them

