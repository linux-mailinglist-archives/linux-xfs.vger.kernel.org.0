Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 405193BF1FA
	for <lists+linux-xfs@lfdr.de>; Thu,  8 Jul 2021 00:21:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbhGGWYK (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 7 Jul 2021 18:24:10 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:20220 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230508AbhGGWYI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Jul 2021 18:24:08 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 167MKQM5012937
        for <linux-xfs@vger.kernel.org>; Wed, 7 Jul 2021 22:21:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references : content-type :
 mime-version; s=corp-2020-01-29;
 bh=5Xf7w/phnPjxS0tnhaSLNMOVRay0vFx5hVN9RMloWpM=;
 b=ifWhhquTvcF6s1oacaegum2W+s4d8bumO1S9u15cDcCJ5xMXjC/6nsRoR4qCnHdrJMed
 mqoXJitkkFNCZoIBxbcmA3EfubSefY4ltxmWs7cyHUy6mk/QSZ/bKduDWcCz4nyeuf3D
 EOkjiPLKAhgxBho5RRiKsdTcvYGxNBnDJDw/OPXa69JGrjregPX40/yv8hyi+awtHFcg
 8EBzQWW7nVXcIAyvmBjeJmshr+aCXFEYvemcjg62S8dKtCCkT46YYxosGrvW/lr5FCPe
 sNOZzmrht98VICXHUSqF3ie2tTP0RrVU0sKHjxn8ArI8tw2CCXUg9VRc9sfrGv/U8tfR xA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 39nbsxs6rm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 07 Jul 2021 22:21:27 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 167MKX3G184633
        for <linux-xfs@vger.kernel.org>; Wed, 7 Jul 2021 22:21:26 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2043.outbound.protection.outlook.com [104.47.57.43])
        by aserp3030.oracle.com with ESMTP id 39nbg2yb5a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 07 Jul 2021 22:21:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J3RWLeEiQJEEd0GK0iGIHa8BiMQ5jkV3KBGLehQTW4OATls49ygKrbGp85lBQJLmfbzE/9dLangzjh4dEZxvuwijeai0klFL/olSE2c1g7wYDJYapC+IImKWXsUzb8yuKDNY4fTE98CVxWc3+FCndCSKkGa4hxCWgPld3mGSIJROpu81oTFfm6HtmEYgR0oYTllnVjuXBTbtKOwq2NNYzLfDNfoTqPurai9uQrJ27AC132NlfeihqDb9rYFNWgr6qC/HYbxfbOYYjhIG7rviecAK0Zyd92VhAwXASzroFi/1uMAz8cbWFiSouzXxE569E12yF3oWNgJiGQz7qkko2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Xf7w/phnPjxS0tnhaSLNMOVRay0vFx5hVN9RMloWpM=;
 b=BD/6w7yjT9qc9DdWfcSWlvUgK8DaEU6FlHozLcxeQ1XNMc9sx5eT5TuZO8VZEEnKMtLACUV1f3Pg2yucuL0nu50oBjwu9/GzhhFj18+pfeuMHFRU8Hk2SQ48+uAo3TMaP2feNl2a//3dVKbMvRtR7FPh8fxO6WSIG15kZH8+eFtRt6ClwoCZJnQoHMVGUhBsJ8S62PhwtB1Z/5DdQDfpRWw7yohMe7i/eI+Grn9gXx8h5QAxPpyii19ReaMfa3Vg3u/m5M5mXU1lx6zr8tZEixCYF1e7ct3qVlS0Mwy+EmOY+4cD7i0Owq3rnet7WAbZdDbZfLBQ7kLTpcHvrJ/Z9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Xf7w/phnPjxS0tnhaSLNMOVRay0vFx5hVN9RMloWpM=;
 b=VOkDS+s4EnfoVGlZi66J4wX1RgUPUPPxKzAFfyH7/OgKgIShZ9PnbTxG3dzoFPfbJGqY9hUaFGOwgrOBMmHqg9mvu7F3szmYXwZWvwvRLBtn5sjLQFM6d6NgiNUUCctqHF4OmWpLcFMTrIa/d8cDev8j7+a2hSlnx2gxjcvaOP4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4306.namprd10.prod.outlook.com (2603:10b6:a03:211::7)
 by BY5PR10MB4388.namprd10.prod.outlook.com (2603:10b6:a03:212::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.31; Wed, 7 Jul
 2021 22:21:24 +0000
Received: from BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89]) by BY5PR10MB4306.namprd10.prod.outlook.com
 ([fe80::20c4:32a4:24ac:df89%9]) with mapi id 15.20.4308.020; Wed, 7 Jul 2021
 22:21:24 +0000
From:   Allison Henderson <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v21 05/13] xfs: Set up infrastructure for deferred attribute operations
Date:   Wed,  7 Jul 2021 15:21:03 -0700
Message-Id: <20210707222111.16339-6-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210707222111.16339-1-allison.henderson@oracle.com>
References: <20210707222111.16339-1-allison.henderson@oracle.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0026.namprd13.prod.outlook.com
 (2603:10b6:a03:2c0::31) To BY5PR10MB4306.namprd10.prod.outlook.com
 (2603:10b6:a03:211::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (67.1.112.125) by SJ0PR13CA0026.namprd13.prod.outlook.com (2603:10b6:a03:2c0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.8 via Frontend Transport; Wed, 7 Jul 2021 22:21:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d5ab531a-f078-4392-f462-08d941958e5c
X-MS-TrafficTypeDiagnostic: BY5PR10MB4388:
X-Microsoft-Antispam-PRVS: <BY5PR10MB4388738E920E04B6A6959DF2951A9@BY5PR10MB4388.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z6FkW8NCiMOp77YKhVM55zQld9IS0/wXQbzKuuE2PAUiGv64FWcmeAeHVT5N8d0LmZCWBk6rX276xe804wOxn72nB94TO0gPZX8Zb2RdD5ozZuyIWhLlDUdekAU0pDg8dpsCpcMfzACSdHdCcyroadkEW8NTu+lyWM3ZAykgqjt2djK82OznuROIBAqWBIXlYgNlAvismyE7XX/f7g1wcFGqyvD9nyhXMkhgBJqa3j9oh9gQhSVSGM5bCY/1iu55eygOHP6aYwcT4AxYWQGmnZzU0iMevv5ARQhXgxV9LlhkgqIDb6w62QcfrjEcFW9b1Lo3yAumTd3bjD4rGLhhkKJBDy2hTX0IZ3WXuDyvK+igGeo20H2BlFwfwgQ98JsUFtdaEVcWbCbVS7IRDXfyYTKXhR2dLjZmwL40x31GSMgttPpx+hU5Q0lnuhiqh96I1B5p8HwWsrL32W8Ud2mcUfvvAOY3xGFe8JBjyf23CgHkBGNW4DAZwI7e6PUii242F2x4X7J7gUru9aNkiGJtldtykOK1GGCftl40aROBw1PeyhLYInYtpzrUIeOmXudbmRP0pt3nGInsk5SRi9i4UcMnn7Khq+za45KGoXMuGOD1qBH+QarjtgRXX9mz001LWcwVjZbNf9f5kX7+i4Ee6ueVzwFztZuochFu6UrFONSYnrFwtrMj53jDhORJWJ4i80r5cH3dZciOdUIIgfVxeA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4306.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(39860400002)(396003)(346002)(366004)(376002)(6512007)(44832011)(26005)(5660300002)(66476007)(66946007)(66556008)(6916009)(956004)(478600001)(30864003)(8676002)(1076003)(186003)(8936002)(83380400001)(52116002)(316002)(36756003)(2616005)(6666004)(38100700002)(6486002)(2906002)(6506007)(86362001)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uwMCobz0HTUYLrSSJ0UDD26QTgap7k+QVqnF+pzTDJAy17gcAuk3VRagnKQn?=
 =?us-ascii?Q?p448PLEMIwWhSzJeVhUW2oPL9ydla7eZlwNyP2BE0QN03dmR8UXmSFUygS3q?=
 =?us-ascii?Q?GSac0pFnNqxqWB5n4NTFpJzQkkoSmPK6O2W7+U4BcLw5LpgUAgockExIpEkm?=
 =?us-ascii?Q?EotazJ8B0aTEwHIu6gvogVcXiDoR2/+8+m6Qy3UWgNtDsz7FIVmL6BXacAwF?=
 =?us-ascii?Q?Np91dcIhkIaLPRCSMzykGICqiN7qyIxJcV7C3fkcvQcTVM8DQlSsfpgMG6qT?=
 =?us-ascii?Q?zgzO7BHrYcJcirk62plbvBo4l/dnP4RfwqEdhOCN6RNHA3Xl2gYc+AVj0gli?=
 =?us-ascii?Q?f0nrA5zXqwa33ax89w3q+3szJ+QkKxC9/S8b1y9be4j226KfsKQTWUSHUgOA?=
 =?us-ascii?Q?aTwEnd34GEDKUUFccxIxSfR852gmjDuuDV3tYWUB3MFb/EF/KzYtQeH9Al8i?=
 =?us-ascii?Q?vG5kFJrEnL21TMdbUhNAyI8FrMyWoPq2Ofdg3K6Jxl9eTQPbDNc4j14pv+zh?=
 =?us-ascii?Q?nNhEnOsr1W4jO1mcISWkaOG4C46YIehZFr2Sv5uJn2A0GjgaSVTpWRR3FzlH?=
 =?us-ascii?Q?hMZYN7HFpkxwhRvpAm18bZmDMMa3lnNsQIoXMaprZP1pJQh0kfyv/glFanki?=
 =?us-ascii?Q?Y62ZMs1gepEQnBuApFGDO2mjTzrQsnaT/6nEyQSRG7eU4v+vmebaac56fh4l?=
 =?us-ascii?Q?2aAFg0zoGAcqJR+mRkYNB3ZHvEsIMmAo2vdtaPPGdEfCi9N9xUX/HdJZbZeG?=
 =?us-ascii?Q?EOg7O91QZZpnHDT7B+NfHvb8lrNwvt6qoExW/gRwDTF7aOFMTnEAzD29E1B2?=
 =?us-ascii?Q?yu1OtnZNjz5n+CuR+ncP8MR/qisXs48YmZUXMYonwkQVP0Uk7K+i1NIylskG?=
 =?us-ascii?Q?kVsbaqLs3342GdQwn+JJYrGiL8kuIspLkAAnCVlXnE1Brttq8leyobdmR2DZ?=
 =?us-ascii?Q?tIy8KthdSFw9fi4iHEjbA5FSdY8ka8bv/Vb1GLDA1hp/dY8eQjcSZ6IY6ZRE?=
 =?us-ascii?Q?aDPI1B6LBMwDuyQny9ne2kRduQQ7X1SRf+hebyTSynuGwkuTCdkyTm5w9pJC?=
 =?us-ascii?Q?DFyfHeIHhACwgl93eaGSCGBmaqnUpEbZdWNGCIVHNFv2Zih8dpR5gqcDW01D?=
 =?us-ascii?Q?KBOl/P+j/jMsqhLNpUGKBChcnPdP+t11/cvFfMafSTrizdBzGcbA81AyMt8N?=
 =?us-ascii?Q?RZe7M4ZVQT6AXm8p00T+keW9tcjnnFvS017ZlfRN7Q5bemQ1Y7q5mNPLUMwy?=
 =?us-ascii?Q?9aZziUMo8rLSTgDYgGUrcWXi/IDvui/Ujs9WUFM2p3au1Z27a1PzkBChL1+j?=
 =?us-ascii?Q?CsTHytv7r8up+I1VCoA/i7Wr?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5ab531a-f078-4392-f462-08d941958e5c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4306.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2021 22:21:24.7370
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tt9NRrGzhJFz4E0v3bRltuTXUyCmoZy/q8az1fLTjbZ0WAmGl9fLSq2xVHylqRh8rDOqIf6N7DkR6h9rx3Z6G/r7mwI0g9KrHHcEbKAljkc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4388
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10037 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 suspectscore=0 spamscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107070128
X-Proofpoint-ORIG-GUID: gsDrMMlMzkLw0O0mnRqKdtVhRgWO6ILp
X-Proofpoint-GUID: gsDrMMlMzkLw0O0mnRqKdtVhRgWO6ILp
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Currently attributes are modified directly across one or more
transactions. But they are not logged or replayed in the event of an
error. The goal of delayed attributes is to enable logging and replaying
of attribute operations using the existing delayed operations
infrastructure.  This will later enable the attributes to become part of
larger multi part operations that also must first be recorded to the
log.  This is mostly of interest in the scheme of parent pointers which
would need to maintain an attribute containing parent inode information
any time an inode is moved, created, or removed.  Parent pointers would
then be of interest to any feature that would need to quickly derive an
inode path from the mount point. Online scrub, nfs lookups and fs grow
or shrink operations are all features that could take advantage of this.

This patch adds two new log item types for setting or removing
attributes as deferred operations.  The xfs_attri_log_item will log an
intent to set or remove an attribute.  The corresponding
xfs_attrd_log_item holds a reference to the xfs_attri_log_item and is
freed once the transaction is done.  Both log items use a generic
xfs_attr_log_format structure that contains the attribute name, value,
flags, inode, and an op_flag that indicates if the operations is a set
or remove.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/Makefile                 |   1 +
 fs/xfs/libxfs/xfs_attr.c        |   5 +-
 fs/xfs/libxfs/xfs_attr.h        |  31 +++
 fs/xfs/libxfs/xfs_defer.h       |   2 +
 fs/xfs/libxfs/xfs_log_format.h  |  44 +++-
 fs/xfs/libxfs/xfs_log_recover.h |   2 +
 fs/xfs/scrub/common.c           |   2 +
 fs/xfs/xfs_acl.c                |   2 +
 fs/xfs/xfs_attr_item.c          | 460 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_attr_item.h          |  52 +++++
 fs/xfs/xfs_attr_list.c          |   1 +
 fs/xfs/xfs_ioctl.c              |   2 +
 fs/xfs/xfs_ioctl32.c            |   2 +
 fs/xfs/xfs_iops.c               |   2 +
 fs/xfs/xfs_log_recover.c        |   2 +
 fs/xfs/xfs_ondisk.h             |   2 +
 fs/xfs/xfs_xattr.c              |   1 +
 17 files changed, 608 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 04611a1..b056cfc 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -102,6 +102,7 @@ xfs-y				+= xfs_log.o \
 				   xfs_buf_item_recover.o \
 				   xfs_dquot_item_recover.o \
 				   xfs_extfree_item.o \
+				   xfs_attr_item.o \
 				   xfs_icreate_item.o \
 				   xfs_inode_item.o \
 				   xfs_inode_item_recover.o \
diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 8d51607..bdcdadc 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -24,6 +24,7 @@
 #include "xfs_quota.h"
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
+#include "xfs_attr_item.h"
 
 /*
  * xfs_attr.c
@@ -61,8 +62,6 @@ STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
 				 struct xfs_da_state **state);
 STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
-STATIC int xfs_attr_set_iter(struct xfs_delattr_context *dac,
-			     struct xfs_buf **leaf_bp);
 STATIC int xfs_attr_node_removename(struct xfs_da_args *args,
 				    struct xfs_da_state *state);
 
@@ -166,7 +165,7 @@ xfs_attr_get(
 /*
  * Calculate how many blocks we need for the new attribute,
  */
-STATIC int
+int
 xfs_attr_calc_size(
 	struct xfs_da_args	*args,
 	int			*local)
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 8de5d1d..4ee5165 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -28,6 +28,11 @@ struct xfs_attr_list_context;
  */
 #define	ATTR_MAX_VALUELEN	(64*1024)	/* max length of a value */
 
+static inline bool xfs_hasdelattr(struct xfs_mount *mp)
+{
+	return false;
+}
+
 /*
  * Kernel-internal version of the attrlist cursor.
  */
@@ -454,6 +459,7 @@ enum xfs_delattr_state {
  */
 #define XFS_DAC_DEFER_FINISH		0x01 /* finish the transaction */
 #define XFS_DAC_LEAF_ADDNAME_INIT	0x02 /* xfs_attr_leaf_addname init*/
+#define XFS_DAC_DELAYED_OP_INIT		0x04 /* delayed operations init*/
 
 /*
  * Context used for keeping track of delayed attribute operations
@@ -461,6 +467,11 @@ enum xfs_delattr_state {
 struct xfs_delattr_context {
 	struct xfs_da_args      *da_args;
 
+	/*
+	 * Used by xfs_attr_set to hold a leaf buffer across a transaction roll
+	 */
+	struct xfs_buf		*leaf_bp;
+
 	/* Used in xfs_attr_rmtval_set_blk to roll through allocating blocks */
 	struct xfs_bmbt_irec	map;
 	xfs_dablk_t		lblkno;
@@ -474,6 +485,23 @@ struct xfs_delattr_context {
 	enum xfs_delattr_state  dela_state;
 };
 
+/*
+ * List of attrs to commit later.
+ */
+struct xfs_attr_item {
+	struct xfs_delattr_context	xattri_dac;
+
+	/*
+	 * Indicates if the attr operation is a set or a remove
+	 * XFS_ATTR_OP_FLAGS_{SET,REMOVE}
+	 */
+	uint32_t			xattri_op_flags;
+
+	/* used to log this item to an intent */
+	struct list_head		xattri_list;
+};
+
+
 /*========================================================================
  * Function prototypes for the kernel.
  *========================================================================*/
@@ -490,11 +518,14 @@ int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_args(struct xfs_da_args *args);
+int xfs_attr_set_iter(struct xfs_delattr_context *dac,
+		      struct xfs_buf **leaf_bp);
 int xfs_has_attr(struct xfs_da_args *args);
 int xfs_attr_remove_args(struct xfs_da_args *args);
 int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
 bool xfs_attr_namecheck(const void *name, size_t length);
 void xfs_delattr_context_init(struct xfs_delattr_context *dac,
 			      struct xfs_da_args *args);
+int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 
 #endif	/* __XFS_ATTR_H__ */
diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
index 05472f7..0ed9dfa 100644
--- a/fs/xfs/libxfs/xfs_defer.h
+++ b/fs/xfs/libxfs/xfs_defer.h
@@ -63,6 +63,8 @@ extern const struct xfs_defer_op_type xfs_refcount_update_defer_type;
 extern const struct xfs_defer_op_type xfs_rmap_update_defer_type;
 extern const struct xfs_defer_op_type xfs_extent_free_defer_type;
 extern const struct xfs_defer_op_type xfs_agfl_free_defer_type;
+extern const struct xfs_defer_op_type xfs_attr_defer_type;
+
 
 /*
  * This structure enables a dfops user to detach the chain of deferred
diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 78d5368..34011c8 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -113,7 +113,12 @@ struct xfs_unmount_log_format {
 #define XLOG_REG_TYPE_CUD_FORMAT	24
 #define XLOG_REG_TYPE_BUI_FORMAT	25
 #define XLOG_REG_TYPE_BUD_FORMAT	26
-#define XLOG_REG_TYPE_MAX		26
+#define XLOG_REG_TYPE_ATTRI_FORMAT	27
+#define XLOG_REG_TYPE_ATTRD_FORMAT	28
+#define XLOG_REG_TYPE_ATTR_NAME	29
+#define XLOG_REG_TYPE_ATTR_VALUE	30
+#define XLOG_REG_TYPE_MAX		30
+
 
 /*
  * Flags to log operation header
@@ -236,6 +241,8 @@ typedef struct xfs_trans_header {
 #define	XFS_LI_CUD		0x1243
 #define	XFS_LI_BUI		0x1244	/* bmbt update intent */
 #define	XFS_LI_BUD		0x1245
+#define	XFS_LI_ATTRI		0x1246  /* attr set/remove intent*/
+#define	XFS_LI_ATTRD		0x1247  /* attr set/remove done */
 
 #define XFS_LI_TYPE_DESC \
 	{ XFS_LI_EFI,		"XFS_LI_EFI" }, \
@@ -251,7 +258,9 @@ typedef struct xfs_trans_header {
 	{ XFS_LI_CUI,		"XFS_LI_CUI" }, \
 	{ XFS_LI_CUD,		"XFS_LI_CUD" }, \
 	{ XFS_LI_BUI,		"XFS_LI_BUI" }, \
-	{ XFS_LI_BUD,		"XFS_LI_BUD" }
+	{ XFS_LI_BUD,		"XFS_LI_BUD" }, \
+	{ XFS_LI_ATTRI,		"XFS_LI_ATTRI" }, \
+	{ XFS_LI_ATTRD,		"XFS_LI_ATTRD" }
 
 /*
  * Inode Log Item Format definitions.
@@ -859,4 +868,35 @@ struct xfs_icreate_log {
 	__be32		icl_gen;	/* inode generation number to use */
 };
 
+/*
+ * Flags for deferred attribute operations.
+ * Upper bits are flags, lower byte is type code
+ */
+#define XFS_ATTR_OP_FLAGS_SET		1	/* Set the attribute */
+#define XFS_ATTR_OP_FLAGS_REMOVE	2	/* Remove the attribute */
+#define XFS_ATTR_OP_FLAGS_TYPE_MASK	0x0FF	/* Flags type mask */
+
+/*
+ * This is the structure used to lay out an attr log item in the
+ * log.
+ */
+struct xfs_attri_log_format {
+	uint16_t	alfi_type;	/* attri log item type */
+	uint16_t	alfi_size;	/* size of this item */
+	uint32_t	__pad;		/* pad to 64 bit aligned */
+	uint64_t	alfi_id;	/* attri identifier */
+	uint64_t	alfi_ino;	/* the inode for this attr operation */
+	uint32_t	alfi_op_flags;	/* marks the op as a set or remove */
+	uint32_t	alfi_name_len;	/* attr name length */
+	uint32_t	alfi_value_len;	/* attr value length */
+	uint32_t	alfi_attr_flags;/* attr flags */
+};
+
+struct xfs_attrd_log_format {
+	uint16_t	alfd_type;	/* attrd log item type */
+	uint16_t	alfd_size;	/* size of this item */
+	uint32_t	__pad;		/* pad to 64 bit aligned */
+	uint64_t	alfd_alf_id;	/* id of corresponding attri */
+};
+
 #endif /* __XFS_LOG_FORMAT_H__ */
diff --git a/fs/xfs/libxfs/xfs_log_recover.h b/fs/xfs/libxfs/xfs_log_recover.h
index 3cca2bf..b6e5514 100644
--- a/fs/xfs/libxfs/xfs_log_recover.h
+++ b/fs/xfs/libxfs/xfs_log_recover.h
@@ -72,6 +72,8 @@ extern const struct xlog_recover_item_ops xlog_rui_item_ops;
 extern const struct xlog_recover_item_ops xlog_rud_item_ops;
 extern const struct xlog_recover_item_ops xlog_cui_item_ops;
 extern const struct xlog_recover_item_ops xlog_cud_item_ops;
+extern const struct xlog_recover_item_ops xlog_attri_item_ops;
+extern const struct xlog_recover_item_ops xlog_attrd_item_ops;
 
 /*
  * Macros, structures, prototypes for internal log manager use.
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index cadfd57..32e46f8 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -23,6 +23,8 @@
 #include "xfs_rmap_btree.h"
 #include "xfs_log.h"
 #include "xfs_trans_priv.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
 #include "xfs_attr.h"
 #include "xfs_reflink.h"
 #include "xfs_ag.h"
diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index d02bef2..b8673c6 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -10,6 +10,8 @@
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
 #include "xfs_attr.h"
 #include "xfs_trace.h"
 #include "xfs_error.h"
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
new file mode 100644
index 0000000..c9033e2
--- /dev/null
+++ b/fs/xfs/xfs_attr_item.c
@@ -0,0 +1,460 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2021 Oracle.  All Rights Reserved.
+ * Author: Allison Collins <allison.henderson@oracle.com>
+ */
+
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_bit.h"
+#include "xfs_shared.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_da_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_bmap.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_trans_priv.h"
+#include "xfs_buf_item.h"
+#include "xfs_attr_item.h"
+#include "xfs_log.h"
+#include "xfs_btree.h"
+#include "xfs_rmap.h"
+#include "xfs_inode.h"
+#include "xfs_icache.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_attr.h"
+#include "xfs_shared.h"
+#include "xfs_attr_item.h"
+#include "xfs_alloc.h"
+#include "xfs_bmap.h"
+#include "xfs_trace.h"
+#include "libxfs/xfs_da_format.h"
+#include "xfs_inode.h"
+#include "xfs_quota.h"
+#include "xfs_trans_space.h"
+#include "xfs_error.h"
+#include "xfs_log_priv.h"
+#include "xfs_log_recover.h"
+
+static const struct xfs_item_ops xfs_attri_item_ops;
+static const struct xfs_item_ops xfs_attrd_item_ops;
+
+/* iovec length must be 32-bit aligned */
+static inline size_t ATTR_NVEC_SIZE(size_t size)
+{
+	return size == sizeof(int32_t) ? size :
+	       sizeof(int32_t) + round_up(size, sizeof(int32_t));
+}
+
+static inline struct xfs_attri_log_item *ATTRI_ITEM(struct xfs_log_item *lip)
+{
+	return container_of(lip, struct xfs_attri_log_item, attri_item);
+}
+
+STATIC void
+xfs_attri_item_free(
+	struct xfs_attri_log_item	*attrip)
+{
+	kmem_free(attrip->attri_item.li_lv_shadow);
+	kmem_free(attrip);
+}
+
+/*
+ * Freeing the attrip requires that we remove it from the AIL if it has already
+ * been placed there. However, the ATTRI may not yet have been placed in the
+ * AIL when called by xfs_attri_release() from ATTRD processing due to the
+ * ordering of committed vs unpin operations in bulk insert operations. Hence
+ * the reference count to ensure only the last caller frees the ATTRI.
+ */
+STATIC void
+xfs_attri_release(
+	struct xfs_attri_log_item	*attrip)
+{
+	ASSERT(atomic_read(&attrip->attri_refcount) > 0);
+	if (atomic_dec_and_test(&attrip->attri_refcount)) {
+		xfs_trans_ail_delete(&attrip->attri_item,
+				     SHUTDOWN_LOG_IO_ERROR);
+		xfs_attri_item_free(attrip);
+	}
+}
+
+STATIC void
+xfs_attri_item_size(
+	struct xfs_log_item	*lip,
+	int			*nvecs,
+	int			*nbytes)
+{
+	struct xfs_attri_log_item       *attrip = ATTRI_ITEM(lip);
+
+	*nvecs += 1;
+	*nbytes += sizeof(struct xfs_attri_log_format);
+
+	/* Attr set and remove operations require a name */
+	ASSERT(attrip->attri_name_len > 0);
+
+	*nvecs += 1;
+	*nbytes += ATTR_NVEC_SIZE(attrip->attri_name_len);
+
+	/*
+	 * Set ops can accept a value of 0 len to clear an attr value.  Remove
+	 * ops do not need a value at all.  So only account for the value
+	 * when it is needed.
+	 */
+	if (attrip->attri_value_len > 0) {
+		*nvecs += 1;
+		*nbytes += ATTR_NVEC_SIZE(attrip->attri_value_len);
+	}
+}
+
+/*
+ * This is called to fill in the log iovecs for the given attri log
+ * item. We use  1 iovec for the attri_format_item, 1 for the name, and
+ * another for the value if it is present
+ */
+STATIC void
+xfs_attri_item_format(
+	struct xfs_log_item	*lip,
+	struct xfs_log_vec	*lv)
+{
+	struct xfs_attri_log_item	*attrip = ATTRI_ITEM(lip);
+	struct xfs_log_iovec		*vecp = NULL;
+
+	attrip->attri_format.alfi_type = XFS_LI_ATTRI;
+	attrip->attri_format.alfi_size = 1;
+
+	/*
+	 * This size accounting must be done before copying the attrip into the
+	 * iovec.  If we do it after, the wrong size will be recorded to the log
+	 * and we trip across assertion checks for bad region sizes later during
+	 * the log recovery.
+	 */
+
+	ASSERT(attrip->attri_name_len > 0);
+	attrip->attri_format.alfi_size++;
+
+	if (attrip->attri_value_len > 0)
+		attrip->attri_format.alfi_size++;
+
+	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTRI_FORMAT,
+			&attrip->attri_format,
+			sizeof(struct xfs_attri_log_format));
+	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_NAME,
+			attrip->attri_name,
+			ATTR_NVEC_SIZE(attrip->attri_name_len));
+	if (attrip->attri_value_len > 0)
+		xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTR_VALUE,
+				attrip->attri_value,
+				ATTR_NVEC_SIZE(attrip->attri_value_len));
+}
+
+/*
+ * The unpin operation is the last place an ATTRI is manipulated in the log. It
+ * is either inserted in the AIL or aborted in the event of a log I/O error. In
+ * either case, the ATTRI transaction has been successfully committed to make
+ * it this far. Therefore, we expect whoever committed the ATTRI to either
+ * construct and commit the ATTRD or drop the ATTRD's reference in the event of
+ * error. Simply drop the log's ATTRI reference now that the log is done with
+ * it.
+ */
+STATIC void
+xfs_attri_item_unpin(
+	struct xfs_log_item	*lip,
+	int			remove)
+{
+	xfs_attri_release(ATTRI_ITEM(lip));
+}
+
+
+STATIC void
+xfs_attri_item_release(
+	struct xfs_log_item	*lip)
+{
+	xfs_attri_release(ATTRI_ITEM(lip));
+}
+
+/*
+ * Allocate and initialize an attri item.  Caller may allocate an additional
+ * trailing buffer of the specified size
+ */
+STATIC struct xfs_attri_log_item *
+xfs_attri_init(
+	struct xfs_mount		*mp,
+	int				buffer_size)
+
+{
+	struct xfs_attri_log_item	*attrip;
+	uint				size;
+
+	size = sizeof(struct xfs_attri_log_item) + buffer_size;
+	attrip = kmem_alloc_large(size, KM_ZERO);
+	if (attrip == NULL)
+		return NULL;
+
+	xfs_log_item_init(mp, &attrip->attri_item, XFS_LI_ATTRI,
+			  &xfs_attri_item_ops);
+	attrip->attri_format.alfi_id = (uintptr_t)(void *)attrip;
+	atomic_set(&attrip->attri_refcount, 2);
+
+	return attrip;
+}
+
+/*
+ * Copy an attr format buffer from the given buf, and into the destination attr
+ * format structure.
+ */
+STATIC int
+xfs_attri_copy_format(
+	struct xfs_log_iovec		*buf,
+	struct xfs_attri_log_format	*dst_attr_fmt)
+{
+	struct xfs_attri_log_format	*src_attr_fmt = buf->i_addr;
+	uint				len;
+
+	len = sizeof(struct xfs_attri_log_format);
+	if (buf->i_len != len)
+		return -EFSCORRUPTED;
+
+	memcpy((char *)dst_attr_fmt, (char *)src_attr_fmt, len);
+	return 0;
+}
+
+static inline struct xfs_attrd_log_item *ATTRD_ITEM(struct xfs_log_item *lip)
+{
+	return container_of(lip, struct xfs_attrd_log_item, attrd_item);
+}
+
+STATIC void
+xfs_attrd_item_free(struct xfs_attrd_log_item *attrdp)
+{
+	kmem_free(attrdp->attrd_item.li_lv_shadow);
+	kmem_free(attrdp);
+}
+
+STATIC void
+xfs_attrd_item_size(
+	struct xfs_log_item		*lip,
+	int				*nvecs,
+	int				*nbytes)
+{
+	*nvecs += 1;
+	*nbytes += sizeof(struct xfs_attrd_log_format);
+}
+
+/*
+ * This is called to fill in the log iovecs for the given attrd log item. We use
+ * only 1 iovec for the attrd_format, and we point that at the attr_log_format
+ * structure embedded in the attrd item.
+ */
+STATIC void
+xfs_attrd_item_format(
+	struct xfs_log_item	*lip,
+	struct xfs_log_vec	*lv)
+{
+	struct xfs_attrd_log_item	*attrdp = ATTRD_ITEM(lip);
+	struct xfs_log_iovec		*vecp = NULL;
+
+	attrdp->attrd_format.alfd_type = XFS_LI_ATTRD;
+	attrdp->attrd_format.alfd_size = 1;
+
+	xlog_copy_iovec(lv, &vecp, XLOG_REG_TYPE_ATTRD_FORMAT,
+			&attrdp->attrd_format,
+			sizeof(struct xfs_attrd_log_format));
+}
+
+/*
+ * The ATTRD is either committed or aborted if the transaction is canceled. If
+ * the transaction is canceled, drop our reference to the ATTRI and free the
+ * ATTRD.
+ */
+STATIC void
+xfs_attrd_item_release(
+	struct xfs_log_item		*lip)
+{
+	struct xfs_attrd_log_item	*attrdp = ATTRD_ITEM(lip);
+
+	xfs_attri_release(attrdp->attrd_attrip);
+	xfs_attrd_item_free(attrdp);
+}
+
+STATIC xfs_lsn_t
+xfs_attri_item_committed(
+	struct xfs_log_item		*lip,
+	xfs_lsn_t			lsn)
+{
+	struct xfs_attri_log_item	*attrip;
+	/*
+	 * The attrip refers to xfs_attr_item memory to log the name and value
+	 * with the intent item. This already occurred when the intent was
+	 * committed so these fields are no longer accessed. Clear them out of
+	 * caution since we're about to free the xfs_attr_item.
+	 */
+	attrip = ATTRI_ITEM(lip);
+	attrip->attri_name = NULL;
+	attrip->attri_value = NULL;
+
+	/*
+	 * The ATTRI is logged only once and cannot be moved in the log, so
+	 * simply return the lsn at which it's been logged.
+	 */
+	return lsn;
+}
+
+STATIC bool
+xfs_attri_item_match(
+	struct xfs_log_item	*lip,
+	uint64_t		intent_id)
+{
+	return ATTRI_ITEM(lip)->attri_format.alfi_id == intent_id;
+}
+
+static const struct xfs_item_ops xfs_attrd_item_ops = {
+	.flags		= XFS_ITEM_RELEASE_WHEN_COMMITTED,
+	.iop_size	= xfs_attrd_item_size,
+	.iop_format	= xfs_attrd_item_format,
+	.iop_release    = xfs_attrd_item_release,
+};
+
+/* Is this recovered ATTRI ok? */
+static inline bool
+xfs_attri_validate(
+	struct xfs_mount		*mp,
+	struct xfs_attri_log_item	*attrip)
+{
+	struct xfs_attri_log_format     *attrp = &attrip->attri_format;
+
+	/* alfi_op_flags should be either a set or remove */
+	if (attrp->alfi_op_flags != XFS_ATTR_OP_FLAGS_SET &&
+	    attrp->alfi_op_flags != XFS_ATTR_OP_FLAGS_REMOVE)
+		return false;
+
+	if (attrp->alfi_value_len > XATTR_SIZE_MAX)
+		return false;
+
+	if ((attrp->alfi_name_len > XATTR_NAME_MAX) ||
+	    (attrp->alfi_name_len == 0))
+		return false;
+
+	if (!xfs_verify_ino(mp, attrp->alfi_ino))
+		return false;
+
+	return xfs_hasdelattr(mp);
+}
+
+static const struct xfs_item_ops xfs_attri_item_ops = {
+	.iop_size	= xfs_attri_item_size,
+	.iop_format	= xfs_attri_item_format,
+	.iop_unpin	= xfs_attri_item_unpin,
+	.iop_committed	= xfs_attri_item_committed,
+	.iop_release    = xfs_attri_item_release,
+	.iop_match	= xfs_attri_item_match,
+};
+
+
+
+STATIC int
+xlog_recover_attri_commit_pass2(
+	struct xlog                     *log,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item        *item,
+	xfs_lsn_t                       lsn)
+{
+	int                             error;
+	struct xfs_mount                *mp = log->l_mp;
+	struct xfs_attri_log_item       *attrip;
+	struct xfs_attri_log_format     *attri_formatp;
+	char				*name = NULL;
+	char				*value = NULL;
+	int				region = 0;
+	int				buffer_size;
+
+	attri_formatp = item->ri_buf[region].i_addr;
+
+	/* Validate xfs_attri_log_format */
+	if (attri_formatp->__pad != 0 || attri_formatp->alfi_name_len == 0 ||
+	    (attri_formatp->alfi_op_flags == XFS_ATTR_OP_FLAGS_REMOVE &&
+	    attri_formatp->alfi_value_len != 0)) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
+		return -EFSCORRUPTED;
+	}
+
+	buffer_size = attri_formatp->alfi_name_len +
+		      attri_formatp->alfi_value_len;
+
+	attrip = xfs_attri_init(mp, buffer_size);
+	if (attrip == NULL)
+		return -ENOMEM;
+
+	error = xfs_attri_copy_format(&item->ri_buf[region],
+				      &attrip->attri_format);
+	if (error) {
+		xfs_attri_item_free(attrip);
+		return error;
+	}
+
+	attrip->attri_name_len = attri_formatp->alfi_name_len;
+	attrip->attri_value_len = attri_formatp->alfi_value_len;
+	region++;
+	name = ((char *)attrip) + sizeof(struct xfs_attri_log_item);
+	memcpy(name, item->ri_buf[region].i_addr, attrip->attri_name_len);
+	attrip->attri_name = name;
+
+	if (attrip->attri_value_len > 0) {
+		region++;
+		value = ((char *)attrip) + sizeof(struct xfs_attri_log_item) +
+			attrip->attri_name_len;
+		memcpy(value, item->ri_buf[region].i_addr,
+			attrip->attri_value_len);
+		attrip->attri_value = value;
+	}
+
+	/*
+	 * The ATTRI has two references. One for the ATTRD and one for ATTRI to
+	 * ensure it makes it into the AIL. Insert the ATTRI into the AIL
+	 * directly and drop the ATTRI reference. Note that
+	 * xfs_trans_ail_update() drops the AIL lock.
+	 */
+	xfs_trans_ail_insert(log->l_ailp, &attrip->attri_item, lsn);
+	xfs_attri_release(attrip);
+	return 0;
+}
+
+const struct xlog_recover_item_ops xlog_attri_item_ops = {
+	.item_type	= XFS_LI_ATTRI,
+	.commit_pass2	= xlog_recover_attri_commit_pass2,
+};
+
+/*
+ * This routine is called when an ATTRD format structure is found in a committed
+ * transaction in the log. Its purpose is to cancel the corresponding ATTRI if
+ * it was still in the log. To do this it searches the AIL for the ATTRI with
+ * an id equal to that in the ATTRD format structure. If we find it we drop
+ * the ATTRD reference, which removes the ATTRI from the AIL and frees it.
+ */
+STATIC int
+xlog_recover_attrd_commit_pass2(
+	struct xlog			*log,
+	struct list_head		*buffer_list,
+	struct xlog_recover_item	*item,
+	xfs_lsn_t			lsn)
+{
+	struct xfs_attrd_log_format	*attrd_formatp;
+
+	attrd_formatp = item->ri_buf[0].i_addr;
+	ASSERT((item->ri_buf[0].i_len ==
+				(sizeof(struct xfs_attrd_log_format))));
+
+	xlog_recover_release_intent(log, XFS_LI_ATTRI,
+				    attrd_formatp->alfd_alf_id);
+	return 0;
+}
+
+const struct xlog_recover_item_ops xlog_attrd_item_ops = {
+	.item_type	= XFS_LI_ATTRD,
+	.commit_pass2	= xlog_recover_attrd_commit_pass2,
+};
diff --git a/fs/xfs/xfs_attr_item.h b/fs/xfs/xfs_attr_item.h
new file mode 100644
index 0000000..594a5dd
--- /dev/null
+++ b/fs/xfs/xfs_attr_item.h
@@ -0,0 +1,52 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later
+ *
+ * Copyright (C) 2019 Oracle.  All Rights Reserved.
+ * Author: Allison Collins <allison.henderson@oracle.com>
+ */
+#ifndef	__XFS_ATTR_ITEM_H__
+#define	__XFS_ATTR_ITEM_H__
+
+/* kernel only ATTRI/ATTRD definitions */
+
+struct xfs_mount;
+struct kmem_zone;
+
+/*
+ * Define ATTR flag bits. Manipulated by set/clear/test_bit operators.
+ */
+#define	XFS_ATTRI_RECOVERED	1
+
+
+/*
+ * This is the "attr intention" log item.  It is used to log the fact that some
+ * attribute operations need to be processed.  An operation is currently either
+ * a set or remove.  Set or remove operations are described by the xfs_attr_item
+ * which may be logged to this intent.
+ *
+ * During a normal attr operation, name and value point to the name and value
+ * fields of the calling functions xfs_da_args.  During a recovery, the name
+ * and value buffers are copied from the log, and stored in a trailing buffer
+ * attached to the xfs_attr_item until they are committed.  They are freed when
+ * the xfs_attr_item itself is freed when the work is done.
+ */
+struct xfs_attri_log_item {
+	struct xfs_log_item		attri_item;
+	atomic_t			attri_refcount;
+	int				attri_name_len;
+	int				attri_value_len;
+	void				*attri_name;
+	void				*attri_value;
+	struct xfs_attri_log_format	attri_format;
+};
+
+/*
+ * This is the "attr done" log item.  It is used to log the fact that some attrs
+ * earlier mentioned in an attri item have been freed.
+ */
+struct xfs_attrd_log_item {
+	struct xfs_attri_log_item	*attrd_attrip;
+	struct xfs_log_item		attrd_item;
+	struct xfs_attrd_log_format	attrd_format;
+};
+
+#endif	/* __XFS_ATTR_ITEM_H__ */
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 25dcc98..81e167a 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -15,6 +15,7 @@
 #include "xfs_inode.h"
 #include "xfs_trans.h"
 #include "xfs_bmap.h"
+#include "xfs_da_btree.h"
 #include "xfs_attr.h"
 #include "xfs_attr_sf.h"
 #include "xfs_attr_leaf.h"
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 0f67943..ff635f9 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -15,6 +15,8 @@
 #include "xfs_iwalk.h"
 #include "xfs_itable.h"
 #include "xfs_error.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
 #include "xfs_attr.h"
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index e650677..cb9f036 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -17,6 +17,8 @@
 #include "xfs_itable.h"
 #include "xfs_fsops.h"
 #include "xfs_rtalloc.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
 #include "xfs_attr.h"
 #include "xfs_ioctl.h"
 #include "xfs_ioctl32.h"
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 93c082d..6f15cad 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -13,6 +13,8 @@
 #include "xfs_inode.h"
 #include "xfs_acl.h"
 #include "xfs_quota.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
 #include "xfs_attr.h"
 #include "xfs_trans.h"
 #include "xfs_trace.h"
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 6ab467b..ef038f0 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -1776,6 +1776,8 @@ static const struct xlog_recover_item_ops *xlog_recover_item_ops[] = {
 	&xlog_cud_item_ops,
 	&xlog_bui_item_ops,
 	&xlog_bud_item_ops,
+	&xlog_attri_item_ops,
+	&xlog_attrd_item_ops,
 };
 
 static const struct xlog_recover_item_ops *
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 2599192..758702b 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -132,6 +132,8 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_inode_log_format,	56);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_qoff_logformat,	20);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_trans_header,		16);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_attri_log_format,	40);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_attrd_log_format,	16);
 
 	/*
 	 * The v5 superblock format extended several v4 header structures with
diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index 0d050f8..66b334f 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -12,6 +12,7 @@
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
 #include "xfs_inode.h"
+#include "xfs_da_btree.h"
 #include "xfs_attr.h"
 #include "xfs_acl.h"
 #include "xfs_da_btree.h"
-- 
2.7.4

