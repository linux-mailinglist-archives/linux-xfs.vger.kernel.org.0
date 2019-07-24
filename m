Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0258725BA
	for <lists+linux-xfs@lfdr.de>; Wed, 24 Jul 2019 06:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbfGXENG (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 24 Jul 2019 00:13:06 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:53140 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725823AbfGXENG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Jul 2019 00:13:06 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6O4948b121316;
        Wed, 24 Jul 2019 04:13:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=OkIEDBKGJkwIgoSPBpimywKdfjEYgnI5gOpFNLXcNHw=;
 b=phEKu4h/AyNmlQlO1qRa0E8kst3CRQRvZmC1EhSmpSiBqozfEjRzNlbANvq8dVghLg08
 TcUwkHe54cIyoB5OBFo3+sDS5ZX1n6WB2scuFISfagGAro5Ac8rDckoGBugnT/8j+Xby
 K9a2ReAJ78wgRrDGI4VKgojOmYwLt4y4Yq96OutMdW9OfVz854qynj7b5gJnt/uUxcNJ
 AkYV2oxRTUOGmwe/5IyIYcxvmDZty6icouTQcpB/dkS4qOwNAvQ0AjPJ3wglt9odGswW
 pHGRVWg4jvDBumrO8MTaaWrg3XXVRl8fEyQpnLHcY5KILxez3+7FXe3YFou08wD6rzfm zg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2tx61btjhw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Jul 2019 04:13:03 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6O47kuA049634;
        Wed, 24 Jul 2019 04:13:03 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2tx60x08jt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Jul 2019 04:13:03 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6O4D170027358;
        Wed, 24 Jul 2019 04:13:02 GMT
Received: from localhost (/50.206.22.50)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 23 Jul 2019 21:13:01 -0700
Subject: [PATCH 2/3] xfs/504: fix bogus test description
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 23 Jul 2019 21:13:00 -0700
Message-ID: <156394158077.1850719.2222567081675874481.stgit@magnolia>
In-Reply-To: <156394156831.1850719.2997473679130010771.stgit@magnolia>
References: <156394156831.1850719.2997473679130010771.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9327 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1907240045
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9327 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1907240045
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Fix the description of this test to reflect what it actually checks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/504 |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)


diff --git a/tests/xfs/504 b/tests/xfs/504
index cc6088d1..c6435117 100755
--- a/tests/xfs/504
+++ b/tests/xfs/504
@@ -4,10 +4,10 @@
 #
 # FS QA Test No. 504
 #
-# Create a directory with multiple filenames that all appear the same
-# (in unicode, anyway) but point to different inodes.  In theory all
-# Linux filesystems should allow this (filenames are a sequence of
-# arbitrary bytes) even if the user implications are horrifying.
+# Create a filesystem label with emoji and confusing unicode characters
+# to make sure that these special things actually work on xfs.  In
+# theory it should allow this (labels are a sequence of arbitrary bytes)
+# even if the user implications are horrifying.
 #
 seq=`basename "$0"`
 seqres="$RESULT_DIR/$seq"

