Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B75A4ACF6
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Jun 2019 23:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731135AbfFRVHe (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 18 Jun 2019 17:07:34 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34964 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730791AbfFRVHe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jun 2019 17:07:34 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IL4QUO034959;
        Tue, 18 Jun 2019 21:07:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=XD9x3x9ptC27CgjT6JyrJ5jlZjiLlyTRByn7Afz/F50=;
 b=P+rsWC7xrzMFqmjibxcrMOQbj50p/dSZCOkEwKVLiJ4Px+/oisgfmQN2JlPmTzsMvqDj
 JCjo7aB2wf8rXUiIyHZNIiK8eAjLw8oMCFB8PBLT/43LFThodOsZTAYBWeF4rlAFYp1I
 So2aGLU6rjRR4GviDm7OpJHff2tmaMJl93DTWJGdHSSAU4R7wlk5RkUMG+EZYyHsyBZn
 sqW6hngKDPNr3bEe8gp7absBGBWP/C6P3Hyvxy7kUiLWTbJah+QAJNnMEAhSIO2X1o1U
 BaIX0V8cNIAAo9sV3nkSCpfGCJSbvachY2mLezFoYYciSxYG7kfrT+k39hwCINswjqPr kw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2t4r3tpuw5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 21:07:31 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5IL796w128942;
        Tue, 18 Jun 2019 21:07:31 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2t5h5tyqqc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 21:07:31 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5IL7Uvh028636;
        Tue, 18 Jun 2019 21:07:30 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Jun 2019 14:07:30 -0700
Subject: [PATCH 4/4] xfs/119: fix MKFS_OPTIONS exporting
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Date:   Tue, 18 Jun 2019 14:07:27 -0700
Message-ID: <156089204777.345809.18314859473454869520.stgit@magnolia>
In-Reply-To: <156089201978.345809.17444450351199726553.stgit@magnolia>
References: <156089201978.345809.17444450351199726553.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906180167
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9292 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906180167
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

This test originally exported its own MKFS_OPTIONS to force the tested
filesystem config to the mkfs defaults + test-specific log size options.
This overrides whatever the test runner might have set in MKFS_OPTIONS.

In commit 2fd273886b525 ("xfs: refactor minimum log size formatting
code") we fail to export our test-specific MKFS_OPTIONS before
calculating the minimum log size, which leads to the wrong min log size
being calculated once we fixed the helper to be smarter about mkfs options.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/119 |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/tests/xfs/119 b/tests/xfs/119
index 8825a5c3..f245a0a6 100755
--- a/tests/xfs/119
+++ b/tests/xfs/119
@@ -38,7 +38,8 @@ _require_scratch
 # this may hang
 sync
 
-logblks=$(_scratch_find_xfs_min_logblocks -l version=2,su=64k)
+export MKFS_OPTIONS="-l version=2,su=64k"
+logblks=$(_scratch_find_xfs_min_logblocks)
 export MKFS_OPTIONS="-l version=2,size=${logblks}b,su=64k"
 export MOUNT_OPTIONS="-o logbsize=64k"
 _scratch_mkfs_xfs >/dev/null

