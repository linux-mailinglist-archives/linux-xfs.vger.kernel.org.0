Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C21FD1C4B54
	for <lists+linux-xfs@lfdr.de>; Tue,  5 May 2020 03:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727088AbgEEBL7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 4 May 2020 21:11:59 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37044 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbgEEBL7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 21:11:59 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04513uRa054816
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:11:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=ggpcDAvtzaC6kV4TEdv911IWnN9E5cQfmwn4u7hj5Dk=;
 b=MBe17b9CXyQdZ+cp6OsMi+omn71qiEBgxCrnpFJi7m2eQIPXh6KzgHvIXZa3HXPKDaKo
 SyiNwMX5N3wk3UdGCD/4ACGEbgKZdk78ld6ovMQ7mAzOUqs/cwo0qsX5Ht6JV9CDHnt7
 sweg9Kww9P/DVO+DHpfFKPlmzdy3+y7uphTPq9D21E0zwC+XEvkW9/1UqTokdMf9jT+U
 P4ZpNxmehzONRDGDtAlEEcQshWalLGrUJrhmsCOnmI4QJ0BUx/wSVHXK5+vx3MO0I/II
 beiZlLQCFIaDy8ie+QGfrZQTvytloFj91YPig/f5EjSURnyfFDUAAHdgYkBRcUcgxGpB RA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 30s0tma18a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 01:11:58 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04515knF057286
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:11:57 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 30t1r3qmek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 05 May 2020 01:11:57 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0451Bu7l027837
        for <linux-xfs@vger.kernel.org>; Tue, 5 May 2020 01:11:56 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 18:11:56 -0700
Subject: [PATCH 13/28] xfs: remove log recovery quotaoff item dispatch for
 pass2 commit functions
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 04 May 2020 18:11:53 -0700
Message-ID: <158864111362.182683.13426589599394215389.stgit@magnolia>
In-Reply-To: <158864103195.182683.2056162574447133617.stgit@magnolia>
References: <158864103195.182683.2056162574447133617.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 suspectscore=1
 spamscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005050005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 suspectscore=1
 phishscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005050005
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Quotaoff doesn't actually do anything, so take advantage of the
commit_pass2 pointer being optional and get rid of the switch
statement clause.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_dquot_item_recover.c |    1 +
 fs/xfs/xfs_log_recover.c        |   33 ++++++---------------------------
 2 files changed, 7 insertions(+), 27 deletions(-)


diff --git a/fs/xfs/xfs_dquot_item_recover.c b/fs/xfs/xfs_dquot_item_recover.c
index 07ff943972a3..a07c1c8344d8 100644
--- a/fs/xfs/xfs_dquot_item_recover.c
+++ b/fs/xfs/xfs_dquot_item_recover.c
@@ -197,4 +197,5 @@ xlog_recover_quotaoff_commit_pass1(
 const struct xlog_recover_item_ops xlog_quotaoff_item_ops = {
 	.item_type		= XFS_LI_QUOTAOFF,
 	.commit_pass1		= xlog_recover_quotaoff_commit_pass1,
+	.commit_pass2		= NULL, /* nothing to do in pass2 */
 };
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index a5158e9e0662..929e2caeeb42 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2034,31 +2034,6 @@ xlog_buf_readahead(
 		xfs_buf_readahead(log->l_mp->m_ddev_targp, blkno, len, ops);
 }
 
-STATIC int
-xlog_recover_commit_pass2(
-	struct xlog			*log,
-	struct xlog_recover		*trans,
-	struct list_head		*buffer_list,
-	struct xlog_recover_item	*item)
-{
-	trace_xfs_log_recover_item_recover(log, trans, item, XLOG_RECOVER_PASS2);
-
-	if (item->ri_ops && item->ri_ops->commit_pass2)
-		return item->ri_ops->commit_pass2(log, buffer_list, item,
-				trans->r_lsn);
-
-	switch (ITEM_TYPE(item)) {
-	case XFS_LI_QUOTAOFF:
-		/* nothing to do in pass2 */
-		return 0;
-	default:
-		xfs_warn(log->l_mp, "%s: invalid item type (%d)",
-			__func__, ITEM_TYPE(item));
-		ASSERT(0);
-		return -EFSCORRUPTED;
-	}
-}
-
 STATIC int
 xlog_recover_items_pass2(
 	struct xlog                     *log,
@@ -2070,8 +2045,12 @@ xlog_recover_items_pass2(
 	int				error = 0;
 
 	list_for_each_entry(item, item_list, ri_list) {
-		error = xlog_recover_commit_pass2(log, trans,
-					  buffer_list, item);
+		trace_xfs_log_recover_item_recover(log, trans, item,
+				XLOG_RECOVER_PASS2);
+
+		if (item->ri_ops->commit_pass2)
+			error = item->ri_ops->commit_pass2(log, buffer_list,
+					item, trans->r_lsn);
 		if (error)
 			return error;
 	}

