Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5955B8851B
	for <lists+linux-xfs@lfdr.de>; Fri,  9 Aug 2019 23:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbfHIVjX (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 9 Aug 2019 17:39:23 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57608 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbfHIVjX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Aug 2019 17:39:23 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LYaDF092809
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:39:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=+6kAFYbry7YJL6a5SWY+0JdO1x+2aYHPGbxbURcG+Q0=;
 b=VRmX3FgPDpg2rnzhrCY2BNzD8rHLdWVB1qbgeA5mCG52HTd2H8vS+qiF1DshbFu2xTGP
 IWfuXgKiaoe6fe15FqzwI8OHFJxS/9+sCYv9Rrm8lovczAxIgOJKikIidSxaa/jDe+Vm
 DtNtOFYPx3MLSLG/Ev1QOGI8RikKgzzjnTac+aymRJeoXNGFmtIHXBOFhKPkiKGgq16i
 Vj1kkaHv+nAF3iIIb1h41mv2d8pfgNamRvx5XtKR4ezBd4coQBHZ055TmhUWhoIcIqd7
 kPUTTequ40RwU/c62fihZb7STArcFxdXaUjpmpPmhis1QQ4YncCkUPUybl/8mtxNcPuy kQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=+6kAFYbry7YJL6a5SWY+0JdO1x+2aYHPGbxbURcG+Q0=;
 b=VzOwrPmovOQ3iqr/w/v7MvaU11PuwnxoWIkR40y/8X1XKvug4DhlT4r5fbyAM64B46Lj
 PijhBpeZUtSZEhO2FdmIDY/lgySnNS4dV2YN5u8MBrb5uTZWWLdzjpAaj4SxJBcDeo08
 7pfwmNIAS0gMqwLKV3voDKsEDEmqL55B9m0D++6CqOFDaqZQcsUiBtKsBZFStoJ/T+aF
 hCHBwAP4W02XtOfxBjs9gg5fVCxwOlY11tnQuWrFNJnWFp1Eq31FOa+fVTBhMQaYmBcO
 pInJX0/JhhSLwoTO3jtQk7behCq6M/HlhCwzNEt8T17QifpVl9RKbRHfFIqsTQVxSIU0 Dw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2u8hasj9ce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:39:21 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LdJA3047978
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:39:21 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2u8x1h6w3t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:39:20 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x79LcMaL019445
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:22 GMT
Received: from localhost.localdomain (/70.176.225.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 09 Aug 2019 14:38:22 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v1 16/19] xfsprogs: Roll delayed attr operations by returning EAGAIN
Date:   Fri,  9 Aug 2019 14:38:01 -0700
Message-Id: <20190809213804.32628-17-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190809213804.32628-1-allison.henderson@oracle.com>
References: <20190809213804.32628-1-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9344 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=4 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908090208
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
 libxfs/defer_item.c | 44 ++++++++++++++++++++++++++++----------------
 1 file changed, 28 insertions(+), 16 deletions(-)

diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index b3dacdc..7e842fc 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -124,6 +124,7 @@ int
 xfs_trans_attr(
 	struct xfs_da_args		*args,
 	struct xfs_attrd_log_item	*attrdp,
+	struct xfs_buf			**leaf_bp,
 	uint32_t			op_flags)
 {
 	int				error;
@@ -135,11 +136,11 @@ xfs_trans_attr(
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
@@ -207,30 +208,40 @@ xfs_attr_finish_item(
 	unsigned char			*name_value;
 	int				error;
 	int				local;
-	struct xfs_da_args		args;
+	struct xfs_da_args		*args;
 	struct xfs_name			name;
 	struct xfs_attrd_log_item	*attrdp;
 	struct xfs_attri_log_item	*attrip;
 
 	attr = container_of(item, struct xfs_attr_item, xattri_list);
-	name_value = ((unsigned char *)attr) + sizeof(struct xfs_attr_item);
+	args = &attr->xattri_args;
 
+	name_value = ((unsigned char *)attr) + sizeof(struct xfs_attr_item);
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
-		attr->xattri_op_flags);
+	error = xfs_trans_attr(args, done_item, &args->dc.leaf_bp,
+			       attr->xattri_op_flags);
 out:
 	/*
 	 * We are about to free the xfs_attr_item, so we need to remove any
@@ -243,7 +254,8 @@ out:
 	attrip->attri_name_len = 0;
 	attrip->attri_value_len = 0;
 
-	kmem_free(attr);
+	if (error != -EAGAIN)
+		kmem_free(attr);
 	return error;
 }
 
-- 
2.7.4

