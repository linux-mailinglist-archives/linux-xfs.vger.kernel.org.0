Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A72B732D9
	for <lists+linux-xfs@lfdr.de>; Wed, 24 Jul 2019 17:35:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbfGXPft (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 24 Jul 2019 11:35:49 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39966 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbfGXPft (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jul 2019 11:35:49 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6OFUJwS132701
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2019 15:35:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=yubeYa96gyilS8Zn2jToJYexOPP82pY8Cnl0a0K3CgU=;
 b=n/A0wYfPryrKOsEynQtjt4Q+LbBq06xuqzGW8pbmjQG7odQvSEH5pWjEGCO39W4nVpjl
 BcZ3lLLWYcFqvlxglIbmk9Rwdk/fT+k2l31V49c67jn31ifvq4ujCxLswRf6HqQemSUU
 xYi9pePsPi/DT526BANVdObK9G/3TDipJLK4nHEvqgOti1uGOJwQ/2nyZu6Af3kvB6S/
 5vuoL9b9mZDj5eTN04OdbFWNxptgumWLovMcgY2p84QckYaTf9B/+FEv9gonJUpj15d6
 x6KAYIEKrKcx3RJyULVrdVEmseFE0cK8CBrCOto8UvB2CneMJVGLcy5jS8uTAQrjsR5g nA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2tx61bx9k2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2019 15:35:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6OFMaff145920
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2019 15:35:47 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2tx60y27hv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2019 15:35:47 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6OFZkf5014778
        for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2019 15:35:47 GMT
Received: from localhost (/50.206.22.50)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 24 Jul 2019 08:35:46 -0700
Date:   Wed, 24 Jul 2019 08:35:45 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] xfs: fix stack contents leakage in the v1 bulkstat/inumbers
 ioctls
Message-ID: <20190724153545.GC1561054@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9327 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=973
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1907240171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9327 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1907240171
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Explicitly initialize the onstack structures to zero so we don't leak
kernel memory into userspace when converting the in-core structure to
the v1 ioctl structure.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_ioctl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index f193f7b288ca..44e1a290f053 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -719,7 +719,7 @@ xfs_fsbulkstat_one_fmt(
 	struct xfs_ibulk		*breq,
 	const struct xfs_bulkstat	*bstat)
 {
-	struct xfs_bstat		bs1;
+	struct xfs_bstat		bs1 = { 0 };
 
 	xfs_bulkstat_to_bstat(breq->mp, &bs1, bstat);
 	if (copy_to_user(breq->ubuffer, &bs1, sizeof(bs1)))
@@ -732,7 +732,7 @@ xfs_fsinumbers_fmt(
 	struct xfs_ibulk		*breq,
 	const struct xfs_inumbers	*igrp)
 {
-	struct xfs_inogrp		ig1;
+	struct xfs_inogrp		ig1 = { 0 };
 
 	xfs_inumbers_to_inogrp(&ig1, igrp);
 	if (copy_to_user(breq->ubuffer, &ig1, sizeof(struct xfs_inogrp)))
