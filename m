Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB0CB884DF
	for <lists+linux-xfs@lfdr.de>; Fri,  9 Aug 2019 23:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726727AbfHIViU (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 9 Aug 2019 17:38:20 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50280 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728240AbfHIViT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Aug 2019 17:38:19 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LYtpq072340
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2019-08-05;
 bh=AckHZ8966fg/eTbofbnykpMENpETqIkoodwNc4D90ao=;
 b=j5J+vGlh3+nmIRGLuRTpKDUMqJ5MohXa/j1dYTNUB1nFY9uPcVBDiAwdWbuVgMB6uQGk
 fej1ADgQE+PWWZkKT4zBK28aiuaq3VWPyOdtjVrVWVlJyz6bWPZVDg66D1y+pTfzkge0
 pwLmEt7hZ6ZHsgQCyH62UOQN4JCGH8tVcJPD9Ou9zH13Ws9vuSTxo9wwZwvslS1EZSvd
 anghnqmzgwqnd8FX9z6yDCW3RQm99h5NUfEKiE8ScJKnCn4STRahG/bPv+K6HPSm5qjx
 gBxkvIIPPien66Ww1cIBVtYCBYFUb0ZXlchnat851n9aLfF/0tEuc6QLrZzg87mfmh19 VA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : in-reply-to : references; s=corp-2018-07-02;
 bh=AckHZ8966fg/eTbofbnykpMENpETqIkoodwNc4D90ao=;
 b=F5hm+qS7UXaYqppddHQWgyVG9f28rELpW43XVPS7M59GJeHSDmACmPs5mcsvZmQ4uYlW
 M9xT7uj+mCSY90fJS1/LeCzaxsjaH7NTdAOd7L+rUI42RPfM8XNUwwZpcF4pyGhZKOGk
 65L64MME1Kwt3GBzt2D38N6SoiHCLHPL3Rdf8aJofw2mVi1Gk6/5eJnKNI4puDB7FdfL
 VaIU9MRwZcYcm20kGnX3re36x1fQnicZEkMfZii8sKdYq5FE1Ixza85MHqdW0v/cBsLg
 RmbxmO+0G+XzwrCJ8k08ibeQLei/BwYbsQ+d7L8GJBU+NadFbaeYjjDlhPjl1ajyoZ6Z CA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2u8hpsa4y9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:38:17 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x79LO3MD007966
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:17 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2u8x1h6w1k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 09 Aug 2019 21:38:17 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x79LcGXE019310
        for <linux-xfs@vger.kernel.org>; Fri, 9 Aug 2019 21:38:16 GMT
Received: from localhost.localdomain (/70.176.225.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 09 Aug 2019 14:38:15 -0700
From:   Allison Collins <allison.henderson@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v1 03/19] xfsprogs: Set up infastructure for deferred attribute operations
Date:   Fri,  9 Aug 2019 14:37:48 -0700
Message-Id: <20190809213804.32628-4-allison.henderson@oracle.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190809213804.32628-1-allison.henderson@oracle.com>
References: <20190809213804.32628-1-allison.henderson@oracle.com>
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

Currently attributes are modified directly across one or more
transactions.  But they are not logged or replayed in the event of
an error. The goal of delayed attributes is to enable logging and
replaying of attribute operations using the existing delayed
operations infrastructure.  This will later enable the attributes
to become part of larger multi part operations that also must first
be recorded to the log.  This is mostly of interest in the scheme of
parent pointers which would need to maintain an attribute containing
parent inode information any time an inode is moved, created, or
removed.  Parent pointers would then be of interest to any feature
that would need to quickly derive an inode path from the mount
point.  Online scrub, nfs lookups and fs grow or shrink operations
are all features that could take advantage of this.

This patch adds two new log item types for setting or removing
attributes as deferred operations.  The xfs_attri_log_item logs an
intent to set or remove an attribute.  The corresponding
xfs_attrd_log_item holds a reference to the xfs_attri_log_item and
is freed once the transaction is done.  Both log items use a generic
xfs_attr_log_format structure that contains the attribute name,
value, flags, inode, and an op_flag that indicates if the operations
is a set or remove.

Signed-off-by: Allison Collins <allison.henderson@oracle.com>
---
 libxfs/defer_item.c     | 162 +++++++++++++++++++++++++++++++++++++++++++++++-
 libxfs/libxfs_priv.h    |   1 +
 libxfs/xfs_attr.c       |   5 +-
 libxfs/xfs_attr.h       |  25 ++++++++
 libxfs/xfs_defer.c      |   1 +
 libxfs/xfs_defer.h      |   3 +
 libxfs/xfs_log_format.h |  44 ++++++++++++-
 libxfs/xfs_types.h      |   1 +
 8 files changed, 237 insertions(+), 5 deletions(-)

diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 2ebc12b..b3dacdc 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -16,10 +16,13 @@
 #include "xfs_trans.h"
 #include "xfs_bmap.h"
 #include "xfs_alloc.h"
+#include "xfs_attr_item.h"
 #include "xfs_rmap.h"
 #include "xfs_refcount.h"
-#include "xfs_bmap.h"
 #include "xfs_inode.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_attr.h"
 
 /* Dummy defer item ops, since we don't do logging. */
 
@@ -117,6 +120,163 @@ const struct xfs_defer_op_type xfs_extent_free_defer_type = {
 	.cancel_item	= xfs_extent_free_cancel_item,
 };
 
+int
+xfs_trans_attr(
+	struct xfs_da_args		*args,
+	struct xfs_attrd_log_item	*attrdp,
+	uint32_t			op_flags)
+{
+	int				error;
+
+	error = xfs_qm_dqattach_locked(args->dp, 0);
+	if (error)
+		return error;
+
+	switch (op_flags) {
+	case XFS_ATTR_OP_FLAGS_SET:
+		args->op_flags |= XFS_DA_OP_ADDNAME;
+		error = xfs_attr_set_args(args);
+		break;
+	case XFS_ATTR_OP_FLAGS_REMOVE:
+		ASSERT(XFS_IFORK_Q((args->dp)));
+		error = xfs_attr_remove_args(args);
+		break;
+	default:
+		error = -EFSCORRUPTED;
+	}
+
+	/*
+	 * Mark the transaction dirty, even on error. This ensures the
+	 * transaction is aborted, which:
+	 *
+	 * 1.) releases the ATTRI and frees the ATTRD
+	 * 2.) shuts down the filesystem
+	 */
+	args->trans->t_flags |= XFS_TRANS_DIRTY;
+	set_bit(XFS_LI_DIRTY, &attrdp->attrd_item.li_flags);
+
+	return error;
+}
+
+static int
+xfs_attr_diff_items(
+	void				*priv,
+	struct list_head		*a,
+	struct list_head		*b)
+{
+	return 0;
+}
+
+/* Get an ATTRI. */
+STATIC void *
+xfs_attr_create_intent(
+	struct xfs_trans		*tp,
+	unsigned int			count)
+{
+	return NULL;
+}
+
+/* Log an attr to the intent item. */
+STATIC void
+xfs_attr_log_item(
+	struct xfs_trans		*tp,
+	void				*intent,
+	struct list_head		*item)
+{
+}
+
+/* Get an ATTRD so we can process all the attrs. */
+STATIC void *
+xfs_attr_create_done(
+	struct xfs_trans		*tp,
+	void				*intent,
+	unsigned int			count)
+{
+	return NULL;
+}
+
+/* Process an attr. */
+STATIC int
+xfs_attr_finish_item(
+	struct xfs_trans		*tp,
+	struct list_head		*item,
+	void				*done_item,
+	void				**state)
+{
+	struct xfs_attr_item		*attr;
+	unsigned char			*name_value;
+	int				error;
+	int				local;
+	struct xfs_da_args		args;
+	struct xfs_name			name;
+	struct xfs_attrd_log_item	*attrdp;
+	struct xfs_attri_log_item	*attrip;
+
+	attr = container_of(item, struct xfs_attr_item, xattri_list);
+	name_value = ((unsigned char *)attr) + sizeof(struct xfs_attr_item);
+
+	name.name = name_value;
+	name.len = attr->xattri_name_len;
+	name.type = attr->xattri_flags;
+	error = xfs_attr_args_init(&args, attr->xattri_ip, &name);
+	if (error)
+		goto out;
+
+	args.hashval = xfs_da_hashname(args.name, args.namelen);
+	args.value = &name_value[attr->xattri_name_len];
+	args.valuelen = attr->xattri_value_len;
+	args.op_flags = XFS_DA_OP_OKNOENT;
+	args.total = xfs_attr_calc_size(&args, &local);
+	args.trans = tp;
+
+	error = xfs_trans_attr(&args, done_item,
+		attr->xattri_op_flags);
+out:
+	/*
+	 * We are about to free the xfs_attr_item, so we need to remove any
+	 * refrences that are currently pointing at its members
+	 */
+	attrdp = (struct xfs_attrd_log_item *)done_item;
+	attrip = attrdp->attrd_attrip;
+	attrip->attri_name = NULL;
+	attrip->attri_value = NULL;
+	attrip->attri_name_len = 0;
+	attrip->attri_value_len = 0;
+
+	kmem_free(attr);
+	return error;
+}
+
+/* Abort all pending ATTRs. */
+STATIC void
+xfs_attr_abort_intent(
+	void			    *intent)
+{
+}
+
+/* Cancel an attr */
+
+STATIC void
+xfs_attr_cancel_item(
+	struct list_head		*item)
+{
+	struct xfs_attr_item    *free;
+
+	free = container_of(item, struct xfs_attr_item, xattri_list);
+	kmem_free(free);
+}
+
+const struct xfs_defer_op_type xfs_attr_defer_type = {
+	.max_items	= XFS_ATTRI_MAX_FAST_ATTRS,
+	.diff_items     = xfs_attr_diff_items,
+	.create_intent  = xfs_attr_create_intent,
+	.abort_intent   = xfs_attr_abort_intent,
+	.log_item       = xfs_attr_log_item,
+	.create_done    = xfs_attr_create_done,
+	.finish_item    = xfs_attr_finish_item,
+	.cancel_item    = xfs_attr_cancel_item,
+};
+
 /*
  * AGFL blocks are accounted differently in the reserve pools and are not
  * inserted into the busy extent list.
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 31fb406..67b027a 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -462,6 +462,7 @@ roundup_64(uint64_t x, uint32_t y)
 #define xfs_trans_reserve_quota_nblks(t,i,b,n,f)	(0)
 #define xfs_trans_unreserve_quota_nblks(t,i,b,n,f)	((void) 0)
 #define xfs_qm_dqattach(i)				(0)
+#define xfs_qm_dqattach_locked(i,b)			(0)
 
 #define uuid_copy(s,d)		platform_uuid_copy((s),(d))
 #define uuid_equal(s,d)		(platform_uuid_compare((s),(d)) == 0)
diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 780cc0d..99a3a31 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -25,6 +25,7 @@
 #include "xfs_attr_remote.h"
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
+#include "xfs_attr_item.h"
 
 /*
  * xfs_attr.c
@@ -58,7 +59,7 @@ STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
 
 
-STATIC int
+int
 xfs_attr_args_init(
 	struct xfs_da_args	*args,
 	struct xfs_inode	*dp,
@@ -152,7 +153,7 @@ xfs_attr_get(
 /*
  * Calculate how many blocks we need for the new attribute,
  */
-STATIC int
+int
 xfs_attr_calc_size(
 	struct xfs_da_args	*args,
 	int			*local)
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 764db97..7089a80 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -78,6 +78,28 @@ typedef struct attrlist_ent {	/* data from attr_list() */
 } attrlist_ent_t;
 
 /*
+ * List of attrs to commit later.
+ */
+struct xfs_attr_item {
+	struct xfs_inode  *xattri_ip;
+	uint32_t	  xattri_op_flags;
+	void		  *xattri_value;      /* attr value */
+	uint32_t	  xattri_value_len;   /* length of value */
+	void		  *xattri_name;	      /* attr name */
+	uint32_t	  xattri_name_len;    /* length of name */
+	uint32_t	  xattri_flags;       /* attr flags */
+	struct list_head  xattri_list;
+
+	/*
+	 * A byte array follows the header containing the file name and
+	 * attribute value.
+	 */
+};
+
+#define XFS_ATTR_ITEM_SIZEOF(namelen, valuelen)	\
+	(sizeof(struct xfs_attr_item) + (namelen) + (valuelen))
+
+/*
  * Given a pointer to the (char*) buffer containing the attr_list() result,
  * and an index, return a pointer to the indicated attribute in the buffer.
  */
@@ -146,5 +168,8 @@ int xfs_attr_remove_args(struct xfs_da_args *args);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 		  int flags, struct attrlist_cursor_kern *cursor);
 bool xfs_attr_namecheck(const void *name, size_t length);
+int xfs_attr_args_init(struct xfs_da_args *args, struct xfs_inode *dp,
+		       struct xfs_name *name);
+int xfs_attr_calc_size(struct xfs_da_args *args, int *local);
 
 #endif	/* __XFS_ATTR_H__ */
diff --git a/libxfs/xfs_defer.c b/libxfs/xfs_defer.c
index 1cb5eea..d6b6dce 100644
--- a/libxfs/xfs_defer.c
+++ b/libxfs/xfs_defer.c
@@ -176,6 +176,7 @@ static const struct xfs_defer_op_type *defer_op_types[] = {
 	[XFS_DEFER_OPS_TYPE_RMAP]	= &xfs_rmap_update_defer_type,
 	[XFS_DEFER_OPS_TYPE_FREE]	= &xfs_extent_free_defer_type,
 	[XFS_DEFER_OPS_TYPE_AGFL_FREE]	= &xfs_agfl_free_defer_type,
+	[XFS_DEFER_OPS_TYPE_ATTR]	= &xfs_attr_defer_type,
 };
 
 /*
diff --git a/libxfs/xfs_defer.h b/libxfs/xfs_defer.h
index 7c28d76..b9ff7b9 100644
--- a/libxfs/xfs_defer.h
+++ b/libxfs/xfs_defer.h
@@ -17,6 +17,7 @@ enum xfs_defer_ops_type {
 	XFS_DEFER_OPS_TYPE_RMAP,
 	XFS_DEFER_OPS_TYPE_FREE,
 	XFS_DEFER_OPS_TYPE_AGFL_FREE,
+	XFS_DEFER_OPS_TYPE_ATTR,
 	XFS_DEFER_OPS_TYPE_MAX,
 };
 
@@ -60,5 +61,7 @@ extern const struct xfs_defer_op_type xfs_refcount_update_defer_type;
 extern const struct xfs_defer_op_type xfs_rmap_update_defer_type;
 extern const struct xfs_defer_op_type xfs_extent_free_defer_type;
 extern const struct xfs_defer_op_type xfs_agfl_free_defer_type;
+extern const struct xfs_defer_op_type xfs_attr_defer_type;
+
 
 #endif /* __XFS_DEFER_H__ */
diff --git a/libxfs/xfs_log_format.h b/libxfs/xfs_log_format.h
index e5f97c6..acdb8ad 100644
--- a/libxfs/xfs_log_format.h
+++ b/libxfs/xfs_log_format.h
@@ -117,7 +117,12 @@ struct xfs_unmount_log_format {
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
@@ -240,6 +245,8 @@ typedef struct xfs_trans_header {
 #define	XFS_LI_CUD		0x1243
 #define	XFS_LI_BUI		0x1244	/* bmbt update intent */
 #define	XFS_LI_BUD		0x1245
+#define	XFS_LI_ATTRI		0x1246  /* attr set/remove intent*/
+#define	XFS_LI_ATTRD		0x1247  /* attr set/remove done */
 
 #define XFS_LI_TYPE_DESC \
 	{ XFS_LI_EFI,		"XFS_LI_EFI" }, \
@@ -255,7 +262,9 @@ typedef struct xfs_trans_header {
 	{ XFS_LI_CUI,		"XFS_LI_CUI" }, \
 	{ XFS_LI_CUD,		"XFS_LI_CUD" }, \
 	{ XFS_LI_BUI,		"XFS_LI_BUI" }, \
-	{ XFS_LI_BUD,		"XFS_LI_BUD" }
+	{ XFS_LI_BUD,		"XFS_LI_BUD" }, \
+	{ XFS_LI_ATTRI,		"XFS_LI_ATTRI" }, \
+	{ XFS_LI_ATTRD,		"XFS_LI_ATTRD" }
 
 /*
  * Inode Log Item Format definitions.
@@ -853,4 +862,35 @@ struct xfs_icreate_log {
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
+	xfs_ino_t       alfi_ino;	/* the inode for this attr operation */
+	uint32_t        alfi_op_flags;	/* marks the op as a set or remove */
+	uint32_t        alfi_name_len;	/* attr name length */
+	uint32_t        alfi_value_len;	/* attr value length */
+	uint32_t        alfi_attr_flags;/* attr flags */
+};
+
+struct xfs_attrd_log_format {
+	uint16_t	alfd_type;	/* attrd log item type */
+	uint16_t	alfd_size;	/* size of this item */
+	uint32_t	__pad;		/* pad to 64 bit aligned */
+	uint64_t	alfd_alf_id;	/* id of corresponding attrd */
+};
+
 #endif /* __XFS_LOG_FORMAT_H__ */
diff --git a/libxfs/xfs_types.h b/libxfs/xfs_types.h
index 802b34c..5e1dce5 100644
--- a/libxfs/xfs_types.h
+++ b/libxfs/xfs_types.h
@@ -11,6 +11,7 @@ typedef uint32_t	prid_t;		/* project ID */
 typedef uint32_t	xfs_agblock_t;	/* blockno in alloc. group */
 typedef uint32_t	xfs_agino_t;	/* inode # within allocation grp */
 typedef uint32_t	xfs_extlen_t;	/* extent length in blocks */
+typedef uint32_t	xfs_attrlen_t;	/* attr length */
 typedef uint32_t	xfs_agnumber_t;	/* allocation group number */
 typedef int32_t		xfs_extnum_t;	/* # of extents in a file */
 typedef int16_t		xfs_aextnum_t;	/* # extents in an attribute fork */
-- 
2.7.4

