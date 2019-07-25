Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49BE875658
	for <lists+linux-xfs@lfdr.de>; Thu, 25 Jul 2019 19:55:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727772AbfGYRzy (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 Jul 2019 13:55:54 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45014 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727616AbfGYRzy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Jul 2019 13:55:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6PHs0TS057797;
        Thu, 25 Jul 2019 17:55:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type; s=corp-2018-07-02;
 bh=QIoCGXxF3Z4/WOoKastW3zWgRtdZSz7UCdv2kpff+ww=;
 b=C58NBLNgrcq5GDhrao+xduYp1kNPBjk6UejlejkfXG+1sSZyE9fkyvYp/ljMbeyOvXbf
 X7HaocMkBE0xFdEqEsxsF89yq7//0/0ObBFhzO3fGNBCzXqWmEiKFsHkvBM+xVEKFjoL
 52JhhYR4eSaRU9e/XM9/OXVX136Wawptexz/Ob5SjihO0E4Ue5n6988t06FDM3K6O2IG
 vNpw++EOTb/rKF3qjxvkED0S1YX0HGRb1YGSba7N2q0S2U80aRymXz0wGnriEVx0Q8VS
 12xtNT4VEbL90FP1rvH+gOO5RTVrMOjJOMwEaN1QVncazA73h9aRujJGgt/vTopM161G zQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2tx61c5p5f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jul 2019 17:55:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6PHrRAr164047;
        Thu, 25 Jul 2019 17:53:47 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2tyd3nqhm2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jul 2019 17:53:47 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6PHrl0h009593;
        Thu, 25 Jul 2019 17:53:47 GMT
Received: from localhost (/10.144.111.83)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Jul 2019 10:53:47 -0700
Date:   Thu, 25 Jul 2019 10:53:46 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     linux-xfs@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH v2] xfs: fix stack contents leakage in the v1 inumber ioctls
Message-ID: <20190725175346.GF1561054@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9329 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=839
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1907250211
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9329 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=885 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1907250211
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Explicitly initialize the onstack structures to zero so we don't leak
kernel memory into userspace when converting the in-core inumbers
structure to the v1 inogrp ioctl structure.  Add a comment about why we
have to use memset to ensure that the padding holes in the structures
are set to zero.

Fixes: 5f19c7fc6873351 ("xfs: introduce v5 inode group structure")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: add comments, use memset this time
---
 fs/xfs/xfs_itable.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 30fe17d25518..39374c680c49 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -283,6 +283,7 @@ xfs_bulkstat_to_bstat(
 	struct xfs_bstat		*bs1,
 	const struct xfs_bulkstat	*bstat)
 {
+	/* memset is needed here because of padding holes in the structure. */
 	memset(bs1, 0, sizeof(struct xfs_bstat));
 	bs1->bs_ino = bstat->bs_ino;
 	bs1->bs_mode = bstat->bs_mode;
@@ -399,6 +400,8 @@ xfs_inumbers_to_inogrp(
 	struct xfs_inogrp		*ig1,
 	const struct xfs_inumbers	*ig)
 {
+	/* memset is needed here because of padding holes in the structure. */
+	memset(ig1, 0, sizeof(struct xfs_inogrp));
 	ig1->xi_startino = ig->xi_startino;
 	ig1->xi_alloccount = ig->xi_alloccount;
 	ig1->xi_allocmask = ig->xi_allocmask;
