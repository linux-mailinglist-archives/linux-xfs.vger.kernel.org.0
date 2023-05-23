Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A305D70D841
	for <lists+linux-xfs@lfdr.de>; Tue, 23 May 2023 11:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236274AbjEWJB0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 23 May 2023 05:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236259AbjEWJBW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 May 2023 05:01:22 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 347F5FF
        for <linux-xfs@vger.kernel.org>; Tue, 23 May 2023 02:01:22 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34N6Emb4031422;
        Tue, 23 May 2023 09:01:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2023-03-30;
 bh=9umQXpUT71+kSXH7mck7+o/L2LiQCN5JiptwDu9MxJA=;
 b=MThOjPUwU+azY4gKmmp4AgbDViQr9kIcfo9JsZ7lX4PKr9kD7aYSk/p8FqUhR6x02XrY
 8GhU6KFUbi4AO53FeXg8np+2QaFYGE+YAA/DJD4axSA3bQRxdD0f0hQq9VR+lWQ4VI4O
 NlnDNunVf5fdCNB3B4zaTPWYkA9Cfygx01WR6GCMLsrtCk6L6oWTDXGz7wL1gEbrescV
 i4Og846xZ+1xbneckjmLtAHJLZlFdNbL6gsFhex4z5hH2mJNVETyFOzQY7RqUvAEh3zb
 FYZZFepKRDOWQ/1Hau8ofZnlH90CwCn1m1pl3ECHJ+UCoBKis9SpNqxpXkrXUuY/CWLX Uw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qpp3mmn40-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 May 2023 09:01:19 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34N8wvPD029361;
        Tue, 23 May 2023 09:01:19 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qqk2aj7q5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 May 2023 09:01:19 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34N8xwrx007681;
        Tue, 23 May 2023 09:01:18 GMT
Received: from chanbabu-fstest.osdevelopmeniad.oraclevcn.com (chanbabu-fstesting.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.250.50])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3qqk2aj76a-19;
        Tue, 23 May 2023 09:01:18 +0000
From:   Chandan Babu R <chandan.babu@oracle.com>
To:     cem@kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: [PATCH 18/24] mdrestore: Introduce struct mdrestore_ops
Date:   Tue, 23 May 2023 14:30:44 +0530
Message-Id: <20230523090050.373545-19-chandan.babu@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230523090050.373545-1-chandan.babu@oracle.com>
References: <20230523090050.373545-1-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-23_05,2023-05-22_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 phishscore=0 bulkscore=0 suspectscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305230074
X-Proofpoint-ORIG-GUID: Y8k6Usy0rSjlG43iUlT5AFEPLZ5sJ_5c
X-Proofpoint-GUID: Y8k6Usy0rSjlG43iUlT5AFEPLZ5sJ_5c
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We will need two sets of functions to work with two versions of metadump
formats. This commit adds the definition for 'struct mdrestore_ops' to hold
pointers to version specific mdrestore functions.

Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
---
 mdrestore/xfs_mdrestore.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 8c847c5a3..895e5cdab 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -7,10 +7,18 @@
 #include "libxfs.h"
 #include "xfs_metadump.h"
 
+struct mdrestore_ops {
+	void (*read_header)(void *header, FILE *mdfp);
+	void (*show_info)(void *header, const char *mdfile);
+	void (*restore)(void *header, FILE *mdfp, int data_fd,
+			bool is_target_file);
+};
+
 static struct mdrestore {
-	int	show_progress;
-	int	show_info;
-	int	progress_since_warning;
+	struct mdrestore_ops	*mdrops;
+	int			show_progress;
+	int			show_info;
+	int			progress_since_warning;
 } mdrestore;
 
 static void
-- 
2.39.1

