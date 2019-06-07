Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 940A73958E
	for <lists+linux-xfs@lfdr.de>; Fri,  7 Jun 2019 21:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729941AbfFGT2v (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 7 Jun 2019 15:28:51 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:54544 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729625AbfFGT2u (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Jun 2019 15:28:50 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x57JSdGt086514;
        Fri, 7 Jun 2019 19:28:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=+n6QKfpHBCCm1uFXimUIDVdGNUiG7PUFB9nzTOc6o7I=;
 b=osstoNVrfPo9tZT755lxp/7Ry0wyKtpbREiCEEM2t/KZftW/BE9u1XriIexYc0jEY21T
 pNj2aooGBbWLtHDEL4jCy1/JrGj1qwoSmpGgJF2R5LgARIT7lzPC3h7200mtHUyxVzQ6
 UbDCCS/KILC9sjDmuruBJUXb7W1CHSvE9rhSTTi7E4//9PYztneFcqUapWmWiOS+atSV
 VXffPPxhoni/cKw+1U59XlftEjdQ+lI/RKqpPmYxIXUPnLAxWTiyNFjJqfa1cDJQYxA9
 DHwwHHUWhYSJ5281XXRxwdXiyh4cJ5fpBR6fLo/190+fANrgkPdqd1aUiZvesMxQL9xZ kA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2suj0r02wf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jun 2019 19:28:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x57JSG9T169294;
        Fri, 7 Jun 2019 19:28:48 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2swngk6djb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 07 Jun 2019 19:28:47 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x57JSkor015114;
        Fri, 7 Jun 2019 19:28:46 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 07 Jun 2019 12:28:46 -0700
Subject: [PATCH 4/6] mkfs: validate start and end of aligned logs
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 07 Jun 2019 12:28:40 -0700
Message-ID: <155993572084.2343365.4641516689067243354.stgit@magnolia>
In-Reply-To: <155993569512.2343365.15510991248022865602.stgit@magnolia>
References: <155993569512.2343365.15510991248022865602.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9281 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906070130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9281 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906070130
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Validate that the start and end of the log stay within a single AG if
we adjust either end to align to stripe units.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 mkfs/xfs_mkfs.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index ddb25ecc..468b8fde 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3033,15 +3033,28 @@ align_internal_log(
 	struct xfs_mount	*mp,
 	int			sunit)
 {
+	uint64_t		logend;
+
 	/* round up log start if necessary */
 	if ((cfg->logstart % sunit) != 0)
 		cfg->logstart = ((cfg->logstart + (sunit - 1)) / sunit) * sunit;
 
+	/* If our log start overlaps the next AG's metadata, fail. */
+	if (!xfs_verify_fsbno(mp, cfg->logstart)) {
+			fprintf(stderr,
+_("Due to stripe alignment, the internal log start (%lld) cannot be aligned\n"
+  "within an allocation group.\n"),
+			(long long) cfg->logstart);
+		usage();
+	}
+
 	/* round up/down the log size now */
 	align_log_size(cfg, sunit);
 
 	/* check the aligned log still fits in an AG. */
-	if (cfg->logblocks > cfg->agsize - XFS_FSB_TO_AGBNO(mp, cfg->logstart)) {
+	logend = cfg->logstart + cfg->logblocks - 1;
+	if (XFS_FSB_TO_AGNO(mp, cfg->logstart) != XFS_FSB_TO_AGNO(mp, logend) ||
+	    !xfs_verify_fsbno(mp, logend)) {
 		fprintf(stderr,
 _("Due to stripe alignment, the internal log size (%lld) is too large.\n"
   "Must fit within an allocation group.\n"),

