Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1713D884E2
	for <lists+linux-xfs@lfdr.de>; Fri,  9 Aug 2019 23:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728240AbfHIViV (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 9 Aug 2019 17:38:21 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59372 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbfHIViV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Aug 2019 17:38:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LYbFJ084554
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=U9XMJqXhQibvtTMkmIJR5mBnccMnyWRKhK+DpGer+Rw=;
 b=lUHCRBf3sWUdJ+m6gqAhUYCRRykjnNqE0ucd30s8uz2tVxHKaHQLRo+rW+X3aqJkKtZi
 FTdYaqkcgE/l9UCqllVrlnLOrD125/pG1s4CTeutJUO1bNJilnJe6gOtH5wVr9VgAFF6
 RCDKZeczCfz9nVd1hooS872Fzizs9bSA4aWhXqpaQ0mzJLYQyOFgH+qHk2iEF4jgg38N
 qjfU3ficNENRJ8CKMyEPJ4ut4sVgGkGfjyvpp7Ye9ocftGfteOyNmjIfQWSSBjrXtmY9
 iqo9jcscSc90LzzboxByiLmpRLY4ACS4f2DVStm4mEP7or/hE9y5Hv8S/SFTJDO4PRFX 7w== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=U9XMJqXhQibvtTMkmIJR5mBnccMnyWRKhK+DpGer+Rw=;
 b=S7/b6P4kzIm8/9x3NjPXoJC9rSQyGZAjSCEghLTTvEhq1OTM1zJpBcQZsOr/JtjbsWqv
 FPW2aXxYIcpJRtcGzozwXWtWg3xXJaijr/94IFxqrAnfMQWgpMTRiuh18d/p6/9LcXjG
 c/dPxYEV3Yl/Ci14x+eyRtfdr7yFzuGGMCkJJY0w+Nmk+s+bKASJurjNt3nPTzhXVisd
 +kQ5H1va8r50wdTMLFzZjYFRz0lDdjRUDIz7PmXUnJtWp/GlE0rDoJF8EjL4QYqPabNf
 EMav9Y2llWeYTAtfcsD/gGCT7dli1R7hlkdJlOSrg/4UI6dov9DVnNoux2lkl6cuXvX2 /w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2u8hgpa7y5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:38:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LNTr2056356
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:19 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2u8pj9m4j4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:38:19 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x79LcIMq010601
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:18 GMT
Received: from localhost.localdomain (/70.176.225.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 09 Aug 2019 14:38:18 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v1 07/19] xfsprogs: Factor up trans handling in xfs_attr3_leaf_flipflags
Date:   Fri,  9 Aug 2019 14:37:52 -0700
Message-Id: <20190809213804.32628-8-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190809213804.32628-1-allison.henderson@oracle.com>
References: <20190809213804.32628-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9344 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908090207
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9344 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908090208
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Since delayed operations cannot roll transactions, factor
up the transaction handling into the calling function

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c      | 10 ++++++++++
 libxfs/xfs_attr_leaf.c |  5 -----
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index f082b30..8b3d6a3 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -753,6 +753,11 @@ xfs_attr_leaf_addname(
 		error = xfs_attr3_leaf_flipflags(args);
 		if (error)
 			return error;
+		/*
+		 * Commit the flag value change and start the next trans in
+		 * series.
+		 */
+		error = xfs_trans_roll_inode(&args->trans, args->dp);
 
 		/*
 		 * Dismantle the "old" attribute/value pair by removing
@@ -1091,6 +1096,11 @@ restart:
 		error = xfs_attr3_leaf_flipflags(args);
 		if (error)
 			goto out;
+		/*
+		 * Commit the flag value change and start the next trans in
+		 * series
+		 */
+		error = xfs_trans_roll_inode(&args->trans, args->dp);
 
 		/*
 		 * Dismantle the "old" attribute/value pair by removing
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 2ebe2c6..1ac64dd 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -2890,10 +2890,5 @@ xfs_attr3_leaf_flipflags(
 			 XFS_DA_LOGRANGE(leaf2, name_rmt, sizeof(*name_rmt)));
 	}
 
-	/*
-	 * Commit the flag value change and start the next trans in series.
-	 */
-	error = xfs_trans_roll_inode(&args->trans, args->dp);
-
 	return error;
 }
-- 
2.7.4

