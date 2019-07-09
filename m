Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 974AC63A4B
	for <lists+linux-xfs@lfdr.de>; Tue,  9 Jul 2019 19:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbfGIRt6 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 9 Jul 2019 13:49:58 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45242 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726813AbfGIRt6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jul 2019 13:49:58 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x69HmXex129016;
        Tue, 9 Jul 2019 17:49:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=v09O5YxZ7Ir8oSQpiwAzQID2retGt4JKSGn9qVXVuEI=;
 b=t4ZItnCFgeuJb0hwq56PL0mMw+xRjV1pnItQImH6FCl1wAYkkt9SDHQN3DXokd9W+6Nk
 Q0IyD5LxRRewcMQ7/DA3CdA4uans4oU+59lBoRDwqMQMAsnihUBcII7keh4UR6IYkMr/
 a9INmlGbaJ5N77XVrPLFMV02nhT8ahp9bJ6IZ2nBNk1MFcHnzgUmniwA9SQUTrpi0k/M
 xblgJHKPmiVoFLt54PGzVAvKrIU39C0g27gb3BCE2WTdlEgY/1Z1GUIRL6KrL3ci4Jlx
 0u7B5re/PbkR9OJ5Uj0pHRVTYSlA2JxY76odkWkVt2NGNVP2wgqaCFr4yogV3s+yMhQT xA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2tjm9qns42-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Jul 2019 17:49:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x69Hm3Z2092569;
        Tue, 9 Jul 2019 17:49:55 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2tjjykxkqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Jul 2019 17:49:55 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x69Hnsxh031453;
        Tue, 9 Jul 2019 17:49:54 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 09 Jul 2019 10:49:54 -0700
Subject: [PATCH 3/3] xfs/119: fix MKFS_OPTIONS exporting
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>,
        fstests@vger.kernel.org
Date:   Tue, 09 Jul 2019 10:49:53 -0700
Message-ID: <156269459341.3039184.4748822543516667568.stgit@magnolia>
In-Reply-To: <156269457497.3039184.4886490143800432410.stgit@magnolia>
References: <156269457497.3039184.4886490143800432410.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9313 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907090210
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9313 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907090210
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
Reviewed-by: Allison Collins <allison.henderson@oracle.com>
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

