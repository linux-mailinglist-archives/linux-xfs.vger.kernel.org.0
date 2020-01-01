Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C41AB12DCF2
	for <lists+linux-xfs@lfdr.de>; Wed,  1 Jan 2020 02:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727139AbgAABNb (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 31 Dec 2019 20:13:31 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:55430 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727134AbgAABNb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:13:31 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118xIx109445
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:13:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Ls2f+rBQjIbv91yMJVOYAWhQPA98hEEYqv/LqhEc1do=;
 b=El/WNwszZ4qth7DTL0HUgojrAx8F6MhpgDFrjmeJm7dLhcYuSXUYldUTRZljXmhKi8IB
 MNcttdT8Fok6ZntmrMWTvmyxVw2XrGS61wzdTHPMO2SrcckfOrqu83THX4Ek6cOJW+QU
 48CRCFuuqGOdYF8CkhC8Bd8jjfV07PvxQcGAPNu8uxFRy/tP9KzVLavSt1aNaklTWUXH
 TlUlvO6wJj2Q3/XcdBrrfWZcNcipY7FWkOATktnth7JkpP6PMQ5HeCeXP9CLJ2XgBee6
 7SIy6Ez9pjGSri2D+ByT8sJbTGAXYazM2VtxPdOvi51imLp8Oft+L0huzqDex7gDZWFK 1w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2x5xftk2j4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:13:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118x2c012476
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:13:28 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2x8guef3n3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:13:28 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0011DSL4007287
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:13:28 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:13:28 -0800
Subject: [PATCH 08/21] xfs: delegate post-allocation iget
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:13:25 -0800
Message-ID: <157784120578.1365473.11920528262279415127.stgit@magnolia>
In-Reply-To: <157784115560.1365473.15056496428451670757.stgit@magnolia>
References: <157784115560.1365473.15056496428451670757.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010009
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a post-allocation iget helper so that the upcoming libxfs hoist
doesn't have to determine the xfs_iget interface.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_inode.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 75a0a22c605d..7832ee9550e5 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -617,6 +617,21 @@ xfs_lookup(
 	return error;
 }
 
+/*
+ * Create in-core inode for a newly allocated on-disk inode.  Get the in-core
+ * inode with the lock held exclusively because we're setting fields here and
+ * need to prevent others from looking at the inode until we're done.
+ */
+static int
+xfs_ialloc_iget(
+	struct xfs_trans	*tp,
+	xfs_ino_t		ino,
+	struct xfs_inode	**ipp)
+{
+	return xfs_iget(tp->t_mountp, tp, ino, XFS_IGET_CREATE, XFS_ILOCK_EXCL,
+			ipp);
+}
+
 /*
  * Initialize a newly allocated inode with the given arguments.  Heritable
  * inode properties will be copied from the parent if one is supplied and the
@@ -851,8 +866,7 @@ xfs_ialloc(
 	 * This is because we're setting fields here we need
 	 * to prevent others from looking at until we're done.
 	 */
-	error = xfs_iget(mp, tp, ino, XFS_IGET_CREATE,
-			 XFS_ILOCK_EXCL, &ip);
+	error = xfs_ialloc_iget(tp, ino, &ip);
 	if (error)
 		return error;
 	ASSERT(ip != NULL);

