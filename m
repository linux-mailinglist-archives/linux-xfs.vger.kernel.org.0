Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7044C884EB
	for <lists+linux-xfs@lfdr.de>; Fri,  9 Aug 2019 23:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbfHIVi1 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 9 Aug 2019 17:38:27 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59498 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726652AbfHIVi1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Aug 2019 17:38:27 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LYShK084522
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=wr1uUXmGkqszOuWEaX01Mt0qYKWjwwd/hGmqu7n0URM=;
 b=E6gEnaUhjPSpgMs0Zeq3l0yBorg/eCUM62H7Gi1nvQzTua3lMkwr/afQQ7VbFDYDMZE8
 PkwMQ3r82/nO46IVYSr6ziMcuXsRUZ1A2yCG8tc3JJjuQPFEc7yL0IBZ+IHYW5SdUNAm
 miPp9S0fYERNMMYna7jgR+on2IU0/0b9Ntk5jOAULXVVhweabJdWO2YVpfYkQW7KS/iV
 9p/inEiL0vQqNIGd4XlrQkuiNhI4DiLGI8oa41k3GHc5HKe2fvAPySKIkCOhzuM7vQUw
 Y4xwJVQKFJ7BA/4hBgJCef7VEsfTCkuzPFCqSEkcXz4gfFu/yWWllMm2Bo3HyDt6pwTB gg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=wr1uUXmGkqszOuWEaX01Mt0qYKWjwwd/hGmqu7n0URM=;
 b=ssENfZ+hEWF9evdwph8FbfaOX7xvRHY1bNL08Ofekgz8EdrAt620TQ7GuY2HWtxZ0Dx/
 0F2ovm+acyu2CN2Wt2k/anj0j+qrYz3q6w/udqbpN+VdE66YYmMd43P3kFOqFaGZzs/D
 yJmHT0obNYeaXkRTmJoSs5EE+myyxDJqdS76dCiGGfUuAwsN2OzZIsQX6OwRdUWJPvZZ
 B80bYtBRAC/mEnEDPF32VfiFxMV7mBugm/Im2rtLqaJO205FPbWHkEc4Zx5ETkgA8wSz
 U5xURSuZ4O3CYa74mXErHDjDXMoVF38ixWzladDw0fc+64BhVcNosTY/Tv3LGg28Zqib dg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2u8hgpa7y8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:38:25 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LcPhw112258
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:25 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2u8x9fxkbv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:38:25 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x79LcMAc010621
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:23 GMT
Received: from localhost.localdomain (/70.176.225.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 09 Aug 2019 14:38:22 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v1 17/19] xfsprogs: Enable delayed attributes
Date:   Fri,  9 Aug 2019 14:38:02 -0700
Message-Id: <20190809213804.32628-18-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190809213804.32628-1-allison.henderson@oracle.com>
References: <20190809213804.32628-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9344 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908090208
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

Finally enable delayed attributes in xfs_attr_set and
xfs_attr_remove.  We only do this for v4 and up since we
cant add new log entries to old fs versions

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/xfs_attr.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index ecc525c..dc38715 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -507,6 +507,7 @@ xfs_attr_set(
 	int			valuelen)
 {
 	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_sb		*sbp = &mp->m_sb;
 	struct xfs_da_args	args;
 	struct xfs_trans_res	tres;
 	int			rsvd = (name->type & ATTR_ROOT) != 0;
@@ -565,7 +566,20 @@ xfs_attr_set(
 		goto out_trans_cancel;
 
 	xfs_trans_ijoin(args.trans, dp, 0);
-	error = xfs_attr_set_args(&args);
+	if (XFS_SB_VERSION_NUM(sbp) < XFS_SB_VERSION_4)
+		error = xfs_attr_set_args(&args);
+	else {
+		error = xfs_has_attr(&args);
+
+		if (error == -EEXIST && (name->type & ATTR_CREATE))
+			goto out_trans_cancel;
+
+		if (error == -ENOATTR && (name->type & ATTR_REPLACE))
+			goto out_trans_cancel;
+
+		error = xfs_attr_set_deferred(dp, args.trans, name, value,
+					      valuelen);
+	}
 	if (error)
 		goto out_trans_cancel;
 	if (!args.trans) {
@@ -650,6 +664,7 @@ xfs_attr_remove(
 	struct xfs_name		*name)
 {
 	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_sb		*sbp = &mp->m_sb;
 	struct xfs_da_args	args;
 	int			error;
 
@@ -691,7 +706,14 @@ xfs_attr_remove(
 	 */
 	xfs_trans_ijoin(args.trans, dp, 0);
 
-	error = xfs_attr_remove_args(&args);
+	error = xfs_has_attr(&args);
+	if (error == -ENOATTR)
+		goto out;
+
+	if (XFS_SB_VERSION_NUM(sbp) < XFS_SB_VERSION_4)
+		error = xfs_attr_remove_args(&args);
+	else
+		error = xfs_attr_remove_deferred(dp, args.trans, name);
 	if (error)
 		goto out;
 
-- 
2.7.4

