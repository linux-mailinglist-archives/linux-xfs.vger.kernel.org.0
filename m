Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4528A24408
	for <lists+linux-xfs@lfdr.de>; Tue, 21 May 2019 01:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbfETXSH (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 May 2019 19:18:07 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:37692 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726384AbfETXSH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 19:18:07 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KNDb22149372;
        Mon, 20 May 2019 23:18:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=fSsafg5B6X8PioS+zyWRWryY6XtT/BzF7ejne+2Hjv8=;
 b=MUYrEdxh/1A4Lju1iCn0ZA45Z2/6IhbOuZiNY6m0jgFjhQr8zDuJuZEDVa5uUWp0C7Z/
 5t2v8CKxyZGOIwN1r0BYxfC/MNgWq/x9fPpOeCPPJsL8PGI1/OrNHYibazo+gTL1c+11
 9FfNJjcWzyYxsBlNd2TuFABK7Ni19GTXx27U95oTPi6/s65gRhGbrRMs/zzfUGRT431d
 OA2wukFvP34pzHA9hU8sXqeKQ0lGnHQc2GAGoY0bYW36xIwPhfx9fofCOy0jTFPncHSB
 awjZmzoLX9RzkHovyWMxbqLzRqBPwu+Wpsxo2/IDMMpYJrdU8Wj20xWrxzrv3s0fgdJM qA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 2sj7jdj5p4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 23:18:05 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4KNHgr6065599;
        Mon, 20 May 2019 23:18:04 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2sks1j496c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 May 2019 23:18:04 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4KNI3Cu022507;
        Mon, 20 May 2019 23:18:03 GMT
Received: from localhost (/10.159.247.197)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 May 2019 23:18:03 +0000
Subject: [PATCH 12/12] mkfs: enable reflink by default
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 20 May 2019 16:18:00 -0700
Message-ID: <155839428076.68606.9379127257564633311.stgit@magnolia>
In-Reply-To: <155839420081.68606.4573219764134939943.stgit@magnolia>
References: <155839420081.68606.4573219764134939943.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=946
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905200143
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9263 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=978 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905200142
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Data block sharing (a.k.a. reflink) has been stable for a while, so turn
it on by default.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 mkfs/xfs_mkfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 8f84536e..afed46d0 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2015,7 +2015,7 @@ _("rmapbt not supported without CRC support\n"));
 		}
 		cli->sb_feat.rmapbt = false;
 
-		if (cli->sb_feat.reflink) {
+		if (cli->sb_feat.reflink && cli_opt_set(&mopts, M_REFLINK)) {
 			fprintf(stderr,
 _("reflink not supported without CRC support\n"));
 			usage();
@@ -3900,7 +3900,7 @@ main(
 			.finobt = true,
 			.spinodes = true,
 			.rmapbt = false,
-			.reflink = false,
+			.reflink = true,
 			.parent_pointers = false,
 			.nodalign = false,
 			.nortalign = false,

