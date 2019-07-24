Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB1A67332F
	for <lists+linux-xfs@lfdr.de>; Wed, 24 Jul 2019 17:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbfGXPzr (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 24 Jul 2019 11:55:47 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50860 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfGXPzr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jul 2019 11:55:47 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6OFn83v038975;
        Wed, 24 Jul 2019 15:55:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=2kF+fA9q3kgCJsUPvbU/03EiMt2/k7q/8VjBwchvVpU=;
 b=wAZQTMXw540UJ/cmO4q+ufZVEM1PiBExX/GJGZpYn/HBAvddJA4U1A7xN64LQ9TyLgF4
 nxOBZYTBrG1f6Ex2n+PdQ+ekA/3xoI8wYy5VG6wVkmTQkddRuc+VAmoQU+lPexV9QLBm
 XNPeD8/V55jatQC//DwR4jXnW60JOs5zC29aSucGSPxPAM7M7C+KJakWXOutuG6Jb/eU
 fo0K3wt9BPYrybxml69bA9lUAY9x4OpktxQtm7Y7N9OZSPyztK2ioOHLKsNlL78B7mup
 vyCs9fXNk3u5pFGRbfIwUiH62BLbaHWJQi1GGVhAoEv//8G+AhwQFau3DizrTikz0lox Ew== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2tx61bxdsu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Jul 2019 15:55:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6OFr4mv053693;
        Wed, 24 Jul 2019 15:55:44 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2tx60y60k9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Jul 2019 15:55:44 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6OFtimt014689;
        Wed, 24 Jul 2019 15:55:44 GMT
Received: from localhost (/50.206.22.50)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 24 Jul 2019 08:55:43 -0700
Date:   Wed, 24 Jul 2019 08:55:43 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH 4/3] generic/506: mount scratch fs before testing for
 prjquota presence
Message-ID: <20190724155543.GE7084@magnolia>
References: <156394156831.1850719.2997473679130010771.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156394156831.1850719.2997473679130010771.stgit@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9327 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=943
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1907240172
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9327 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=988 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1907240172
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

On XFS, the _require_prjquota helper takes a path to a block device,
but (unintuitively) requires the block device to be mounted for the
detection to work properly.  Fix the detection code in generic/506.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/quota      |    3 ++-
 tests/generic/506 |    2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/common/quota b/common/quota
index f19f81a1..8a22f815 100644
--- a/common/quota
+++ b/common/quota
@@ -68,7 +68,8 @@ _require_xfs_quota_foreign()
 }
 
 #
-# checks that the project quota support in the kernel is enabled.
+# Checks that the project quota support in the kernel is enabled.
+# The device must be mounted for detection to work properly.
 #
 _require_prjquota()
 {
diff --git a/tests/generic/506 b/tests/generic/506
index 7002c00c..e8d0ca24 100755
--- a/tests/generic/506
+++ b/tests/generic/506
@@ -51,7 +51,9 @@ _require_scratch_shutdown
 
 _scratch_mkfs >/dev/null 2>&1
 _require_metadata_journaling $SCRATCH_DEV
+_scratch_mount
 _require_prjquota $SCRATCH_DEV
+_scratch_unmount
 
 testfile=$SCRATCH_MNT/testfile
 
