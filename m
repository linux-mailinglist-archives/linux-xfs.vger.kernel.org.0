Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B21F884D0
	for <lists+linux-xfs@lfdr.de>; Fri,  9 Aug 2019 23:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728064AbfHIVht (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 9 Aug 2019 17:37:49 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58648 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728127AbfHIVhq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Aug 2019 17:37:46 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LYw5O084876
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:37:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=8pxqqbbuImS596V1USt3N4/8VS42Psa0OiU1FRY56rE=;
 b=gglCFZzrnKpxM1DEtLewKxX/OnpNScrixZIXYnW+hHPIfAWFGuJ8UMwVwK8b4tAezaYY
 9GLrkZqw83MiNVoYNWUOdczqp88HmIDdEVpVeLsEnDFecUcDcbIOfP2d8MHS1JajVNpu
 SnV7EDxeS3mK1meQGzulq9nzI4ttKyihRZ/cLZTpeRqoz5yPJ1zGddI6FI7hLokrWmqq
 4zOeOof0141pas3XBlekMsMi72AxVjA9WBsCT/jhYEiJWDPo/lcqbT1nJZxXcSTgTqRd
 tCgaqEYheeK8SCX4gqTb19x1VaeH/HA+D5nZQQNIJmd1Y56x4bOXQU/V37Mbwzi9YXo3 +w== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=8pxqqbbuImS596V1USt3N4/8VS42Psa0OiU1FRY56rE=;
 b=ngsdntO2uPMjo+QWrZXzilTzP+040Yuy9BBaIlZ5iCahbQO/qhDxLjXiPKTWs6326pLL
 WYZl90/6wNuS2bj9UgHYlzl56dPLjvrZSehak+mTyeYqjztyY924NYrxnftWbE9M8E17
 RWNf1yjo2DHtbkZpB/8C0mpJy+8i/1KAVZb449Z6iALzfH+yn+upRAAbMz2o/muHWp8C
 18GbkoR4m0XutBl9w09g1T6i+tl9OvsGll5BdVIZ9TYnx1nlAlKnurLhovu8gv4HUqWd
 yG6CDrXvDskWLhmFx8Z8cVZkrEYZVj1yxRF/LDgvwklPQDfZmBdmou1WnHJa+XAd4Wqq vg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2u8hgpa7wm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:37:44 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LNUnG056402
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:37:44 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2u8pj9m41t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:37:44 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x79LbhID010363
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:37:43 GMT
Received: from localhost.localdomain (/70.176.225.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 09 Aug 2019 14:37:37 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 16/18] xfs: Roll delayed attr operations by returning EAGAIN
Date:   Fri,  9 Aug 2019 14:37:24 -0700
Message-Id: <20190809213726.32336-17-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190809213726.32336-1-allison.henderson@oracle.com>
References: <20190809213726.32336-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9344 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=4 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908090207
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9344 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=4 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908090208
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Modify delayed operations to use the new xfs_attr_da*
routines

In this patch, xfs_trans_attr is modified to use the new
xfs_attr_da_* scheme, and pass the -EAGAIN back to the
calling function.  The leaf_bp is also factored up to
be released after the transactions are handled.

xfs_attri_recover will need to handle the -EAGAIN by
logging and committing the transaction before recalling
xfs_trans_attr.

xfs_attr_finish_item does not need to handle the -EAGAIN
since it is handled by its calling function.  But it
does need to plumb in xfs_da_args from the log item since
it cant keep args instantiated in its own function context.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 fs/xfs/xfs_attr_item.c | 83 +++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 62 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 88efaf9..6693880 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -65,6 +65,7 @@ int
 xfs_trans_attr(
 	struct xfs_da_args		*args,
 	struct xfs_attrd_log_item	*attrdp,
+	struct xfs_buf			**leaf_bp,
 	uint32_t			op_flags)
 {
 	int				error;
@@ -76,11 +77,11 @@ xfs_trans_attr(
 	switch (op_flags) {
 	case XFS_ATTR_OP_FLAGS_SET:
 		args->op_flags |= XFS_DA_OP_ADDNAME;
-		error = xfs_attr_set_args(args);
+		error = xfs_attr_da_set_args(args, leaf_bp);
 		break;
 	case XFS_ATTR_OP_FLAGS_REMOVE:
 		ASSERT(XFS_IFORK_Q((args->dp)));
-		error = xfs_attr_remove_args(args);
+		error = xfs_attr_da_remove_args(args);
 		break;
 	default:
 		error = -EFSCORRUPTED;
@@ -187,29 +188,40 @@ xfs_attr_finish_item(
 	char				*name_value;
 	int				error;
 	int				local;
-	struct xfs_da_args		args;
+	struct xfs_da_args		*args;
 	struct xfs_name			name;
 	struct xfs_attrd_log_item	*attrdp;
 	struct xfs_attri_log_item	*attrip;
 
 	attr = container_of(item, struct xfs_attr_item, xattri_list);
-	name_value = ((char *)attr) + sizeof(struct xfs_attr_item);
+	args = &attr->xattri_args;
 
+	name_value = ((char *)attr) + sizeof(struct xfs_attr_item);
 	name.name = name_value;
 	name.len = attr->xattri_name_len;
 	name.type = attr->xattri_flags;
-	error = xfs_attr_args_init(&args, attr->xattri_ip, &name);
-	if (error)
-		goto out;
 
-	args.hashval = xfs_da_hashname(args.name, args.namelen);
-	args.value = &name_value[attr->xattri_name_len];
-	args.valuelen = attr->xattri_value_len;
-	args.op_flags = XFS_DA_OP_OKNOENT;
-	args.total = xfs_attr_calc_size(&args, &local);
-	args.trans = tp;
+	if (!(args->dc.flags & XFS_DC_INIT)) {
+		/* Only need to initialize args context once */
+		error = xfs_attr_args_init(args, attr->xattri_ip, &name);
+		if (error)
+			goto out;
+
+		args->hashval = xfs_da_hashname(args->name, args->namelen);
+		args->value = &name_value[attr->xattri_name_len];
+		args->valuelen = attr->xattri_value_len;
+		args->op_flags = XFS_DA_OP_OKNOENT;
+		args->total = xfs_attr_calc_size(args, &local);
+		args->dc.flags |= XFS_DC_INIT;
+	}
+
+	/*
+	 * Always reset trans after EAGAIN cycle
+	 * since the transaction is new
+	 */
+	args->trans = tp;
 
-	error = xfs_trans_attr(&args, done_item,
+	error = xfs_trans_attr(args, done_item, &args->dc.leaf_bp,
 			attr->xattri_op_flags);
 out:
 	/*
@@ -223,7 +235,9 @@ xfs_attr_finish_item(
 	attrip->attri_name_len = 0;
 	attrip->attri_value_len = 0;
 
-	kmem_free(attr);
+	if (error != -EAGAIN)
+		kmem_free(attr);
+
 	return error;
 }
 
@@ -678,9 +692,10 @@ xfs_attri_recover(
 	struct xfs_attri_log_format	*attrp;
 	struct xfs_trans_res		tres;
 	int				local;
-	int				error = 0;
+	int				error, err2 = 0;
 	int				rsvd = 0;
 	struct xfs_name			name;
+	struct xfs_buf			*leaf_bp = NULL;
 
 	ASSERT(!test_bit(XFS_ATTRI_RECOVERED, &attrip->attri_flags));
 
@@ -737,14 +752,40 @@ xfs_attri_recover(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 
 	xfs_trans_ijoin(args.trans, ip, 0);
-	error = xfs_trans_attr(&args, attrdp, attrp->alfi_op_flags);
-	if (error)
-		goto abort_error;
 
+	do {
+		leaf_bp = NULL;
+
+		error = xfs_trans_attr(&args, attrdp, &leaf_bp,
+				       attrp->alfi_op_flags);
+		if (error && error != -EAGAIN)
+			goto abort_error;
+
+		xfs_trans_log_inode(args.trans, ip,
+				XFS_ILOG_CORE | XFS_ILOG_ADATA);
+
+		err2 = xfs_trans_commit(args.trans);
+		if (err2) {
+			error = err2;
+			goto abort_error;
+		}
+
+		if (error == -EAGAIN) {
+			err2 = xfs_trans_alloc(mp, &tres, args.total, 0,
+				XFS_TRANS_PERM_LOG_RES, &args.trans);
+			if (err2) {
+				error = err2;
+				goto abort_error;
+			}
+			xfs_trans_ijoin(args.trans, ip, 0);
+		}
+
+	} while (error == -EAGAIN);
+
+	if (leaf_bp)
+		xfs_trans_brelse(args.trans, leaf_bp);
 
 	set_bit(XFS_ATTRI_RECOVERED, &attrip->attri_flags);
-	xfs_trans_log_inode(args.trans, ip, XFS_ILOG_CORE | XFS_ILOG_ADATA);
-	error = xfs_trans_commit(args.trans);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 
-- 
2.7.4

