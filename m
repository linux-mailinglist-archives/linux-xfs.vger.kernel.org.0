Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 839E5884D3
	for <lists+linux-xfs@lfdr.de>; Fri,  9 Aug 2019 23:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbfHIVhu (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 9 Aug 2019 17:37:50 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58652 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728184AbfHIVhq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Aug 2019 17:37:46 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LYPp4084487
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:37:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=TIwVxjVy1yW0DhIxtqgVCvg7m+a3Q29j5KlIuLGnWzo=;
 b=ckOQpBhMBdBW2AOIWhHxZFlsv41t4Yby+IGVYMIwLqzZLuSTDlIS6h8gSw1QC05JOkPg
 G1YfrryX2CnaRqKSh7vkYmnQFX03yOcOkX+7QncP6aVRwI071AJ5jyoDR5RVyYaNyTJj
 ENieiu4U+F2Fbqf14JwoJd4y3JWsz4YVKUg/rCacC3tb9rUVUXrH4IxLe7aqgaCaHNRk
 eBJqsQ//9jSHlXe9hfcYdgfir/RJ9PvE4bpsd2UZupf1xvvzEeFamB98Vil8EuMnEv0K
 i+wS4cIkICVGa8gWGUZcG83ZDjoRjo2MasL5LAqQIUr5gyk3m6bB02NxgYv3RgS988k+ FQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=TIwVxjVy1yW0DhIxtqgVCvg7m+a3Q29j5KlIuLGnWzo=;
 b=dwuEl1fLfmUX0Ps6G6MIinkeM4DvUpNycfalkxARXiJjp8u+h5dBVInCeFdi9uWIc/zu
 XxHMmRVn6oxZFNMrbyX3qNUChcWAonEOg+iddalAvUeVc2vdF3jzWg9q+raic/AJhNMS
 NirGjAi51Ckbbf1oOo6LCSAV6jDxg//OxKyq2xrTzyd0s/kLDHBmokjxxuP2RVX26oF0
 zM8h090zIHLx8u6OUK04mTT3fj3i9zYreiLy1JS89w3xnCtWzSgi88sshsV0ReaXBM7X
 frr24fUTP+IkEknbYyJlEu0i+zsyO3FA4tQyZgfm725K0dj3UA6M5+86TYSwnZzl8eXn kw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2u8hgpa7wn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:37:45 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LNU6J056459
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:37:44 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2u8pj9m41q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:37:44 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x79LbhSc001890
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:37:43 GMT
Received: from localhost.localdomain (/70.176.225.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 09 Aug 2019 14:37:38 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 17/18] xfs: Enable delayed attributes
Date:   Fri,  9 Aug 2019 14:37:25 -0700
Message-Id: <20190809213726.32336-18-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190809213726.32336-1-allison.henderson@oracle.com>
References: <20190809213726.32336-1-allison.henderson@oracle.com>
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

Finally enable delayed attributes in xfs_attr_set and
xfs_attr_remove.  We only do this for v4 and up since we
cant add new log entries to old fs versions

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 9931e50..7023734 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -506,6 +506,7 @@ xfs_attr_set(
 	int			valuelen)
 {
 	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_sb		*sbp = &mp->m_sb;
 	struct xfs_da_args	args;
 	struct xfs_trans_res	tres;
 	int			rsvd = (name->type & ATTR_ROOT) != 0;
@@ -564,7 +565,20 @@ xfs_attr_set(
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
@@ -649,6 +663,7 @@ xfs_attr_remove(
 	struct xfs_name		*name)
 {
 	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_sb		*sbp = &mp->m_sb;
 	struct xfs_da_args	args;
 	int			error;
 
@@ -690,7 +705,14 @@ xfs_attr_remove(
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

