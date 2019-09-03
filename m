Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B534CA7769
	for <lists+linux-xfs@lfdr.de>; Wed,  4 Sep 2019 01:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbfICXHS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 3 Sep 2019 19:07:18 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43176 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbfICXHS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Sep 2019 19:07:18 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x83N3Zwt183426;
        Tue, 3 Sep 2019 23:07:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : mime-version : content-type; s=corp-2019-08-05;
 bh=tHuVk4TkGyopl9fzYU75+2XW2xtZfWofOJMLp4Vnn8c=;
 b=Dqygawpc/EQ1MAQ4ry3ZWaYUxOvT57fTKH9SsVgkb4LPNtIs2RtPkvk6uKBhn2lq7Wh1
 le7xDUgr6210y0conO/Exmts630fzvnFJzcYdUlJbl+fHXu2h01os7ykmAFP4kdmt5or
 CNLfwBBu6TRXNKO2Jd6vH4FTOq5G/OkbMiNfATrG8qdCVcwmpNkByzJrS5hq31c15eNX
 4I4DcjYXTuXFTcHw+B+1dhVGkjHQkcugi+AMs1JKifNQzOogAcjCWgF/19FnpjJwPbnt
 /5YntU04z2hU0ZWJ3+QU6xasFEH2+jTk35uQlZTEY62QErq4sGV2KgOPFVzLwuZgHmSr Vw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2ut1e7r11s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Sep 2019 23:07:16 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x83N5AEO136281;
        Tue, 3 Sep 2019 23:05:40 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2usu514vqu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Sep 2019 23:05:40 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x83N5cOx007910;
        Tue, 3 Sep 2019 23:05:39 GMT
Received: from localhost (/10.145.178.11)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Sep 2019 16:05:38 -0700
Date:   Tue, 3 Sep 2019 16:05:37 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     xfs <linux-xfs@vger.kernel.org>, Dave Chinner <david@fromorbit.com>
Subject: [PATCH v3] xfs: define a flags field for the AG geometry ioctl
 structure
Message-ID: <20190903230537.GI5340@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=849
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909030231
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=911 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909030231
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Define a flags field for the AG geometry ioctl structure.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v3: define ag_flags as an in/out field and check required zeroness
---
 fs/xfs/libxfs/xfs_fs.h |    2 +-
 fs/xfs/xfs_ioctl.c     |    4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 52d03a3a02a4..39dd2b908106 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -287,7 +287,7 @@ struct xfs_ag_geometry {
 	uint32_t	ag_ifree;	/* o: inodes free */
 	uint32_t	ag_sick;	/* o: sick things in ag */
 	uint32_t	ag_checked;	/* o: checked metadata in ag */
-	uint32_t	ag_reserved32;	/* o: zero */
+	uint32_t	ag_flags;	/* i/o: flags for this ag */
 	uint64_t	ag_reserved[12];/* o: zero */
 };
 #define XFS_AG_GEOM_SICK_SB	(1 << 0)  /* superblock */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 9a6823e29661..c93501f42675 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1038,6 +1038,10 @@ xfs_ioc_ag_geometry(
 
 	if (copy_from_user(&ageo, arg, sizeof(ageo)))
 		return -EFAULT;
+	if (ageo.ag_flags)
+		return -EINVAL;
+	if (memchr_inv(&ageo.ag_reserved, 0, sizeof(ageo.ag_reserved)))
+		return -EINVAL;
 
 	error = xfs_ag_get_geometry(mp, ageo.ag_number, &ageo);
 	if (error)
