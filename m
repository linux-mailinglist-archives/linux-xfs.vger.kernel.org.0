Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D758E93D4
	for <lists+linux-xfs@lfdr.de>; Wed, 30 Oct 2019 00:45:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726108AbfJ2Xpj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 29 Oct 2019 19:45:39 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53950 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbfJ2Xpj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Oct 2019 19:45:39 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9TNdhw3045015;
        Tue, 29 Oct 2019 23:45:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=nrf4jAdSbJ9V3uEv06LKoi9+8QMvZtWg38HBy315RlY=;
 b=hp0VWZ4Io8OeNHpgeqC4C+oMMvgNys7gxyrNhIftUGEs6t4cdDxcZLURmorIgJlGuuK2
 jSBdtkk7vpUzTuFxH9i/IlmMyLr2IaZswVoKGoDmHhVn1mneCVhqbQrgxQs+n7uM2m+r
 sBRp9oPdNEZKz6Wzt0/Z9viYI/Qg70t+EGgq+5F5E8WrIJYeEnzpXQLR4lB2I/pkgrB9
 7tZrxqgdEJJq2h1hmmZyfgsJt75Ds2HClF71AXoOzXYsDDheSLX0OFYy2O8tsxWG2Fde
 Bzx4DgojOkNasKCXqvP6P7kJIMdPL4pJuIn6t0kkDZFjbPCWRe5+et46/bD15v8+qt0t 0Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2vxwhfgc2b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Oct 2019 23:45:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9TNhk3j015687;
        Tue, 29 Oct 2019 23:45:34 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2vxwj84qpj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Oct 2019 23:45:34 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9TNjXOm013321;
        Tue, 29 Oct 2019 23:45:34 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 29 Oct 2019 16:45:33 -0700
Subject: [PATCH 1/9] xfs_repair: port the online repair newbt structure
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 29 Oct 2019 16:45:32 -0700
Message-ID: <157239273257.1277435.16517400921358869833.stgit@magnolia>
In-Reply-To: <157239272641.1277435.17698788915454836309.stgit@magnolia>
References: <157239272641.1277435.17698788915454836309.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9425 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910290208
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9425 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910290208
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Port the new btree staging context and related block reservation helper
code from the kernel to repair.  We'll use this in subsequent patches to
implement btree bulk loading.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_api_defs.h |    2 
 repair/Makefile          |    4 -
 repair/bload.c           |  276 ++++++++++++++++++++++++++++++++++++++++++++++
 repair/bload.h           |   79 +++++++++++++
 repair/xfs_repair.c      |   17 +++
 5 files changed, 376 insertions(+), 2 deletions(-)
 create mode 100644 repair/bload.c
 create mode 100644 repair/bload.h


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 645c9b1b..7631edf6 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -50,6 +50,8 @@
 #define xfs_attr_remove			libxfs_attr_remove
 #define xfs_attr_leaf_newentsize	libxfs_attr_leaf_newentsize
 
+#define xfs_alloc_vextent		libxfs_alloc_vextent
+#define __xfs_bmap_add_free		__libxfs_bmap_add_free
 #define xfs_agfl_walk			libxfs_agfl_walk
 #define xfs_alloc_fix_freelist		libxfs_alloc_fix_freelist
 #define xfs_alloc_min_freelist		libxfs_alloc_min_freelist
diff --git a/repair/Makefile b/repair/Makefile
index 0964499a..8cc1ee68 100644
--- a/repair/Makefile
+++ b/repair/Makefile
@@ -9,11 +9,11 @@ LSRCFILES = README
 
 LTCOMMAND = xfs_repair
 
-HFILES = agheader.h attr_repair.h avl.h bmap.h btree.h \
+HFILES = agheader.h attr_repair.h avl.h bload.h bmap.h btree.h \
 	da_util.h dinode.h dir2.h err_protos.h globals.h incore.h protos.h \
 	rt.h progress.h scan.h versions.h prefetch.h rmap.h slab.h threads.h
 
-CFILES = agheader.c attr_repair.c avl.c bmap.c btree.c \
+CFILES = agheader.c attr_repair.c avl.c bload.c bmap.c btree.c \
 	da_util.c dino_chunks.c dinode.c dir2.c globals.c incore.c \
 	incore_bmc.c init.c incore_ext.c incore_ino.c phase1.c \
 	phase2.c phase3.c phase4.c phase5.c phase6.c phase7.c \
diff --git a/repair/bload.c b/repair/bload.c
new file mode 100644
index 00000000..160a240a
--- /dev/null
+++ b/repair/bload.c
@@ -0,0 +1,276 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2019 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#include <libxfs.h>
+#include "bload.h"
+
+#define trace_xrep_newbt_alloc_block(...)	((void) 0)
+#define trace_xrep_newbt_reserve_space(...)	((void) 0)
+#define trace_xrep_newbt_unreserve_space(...)	((void) 0)
+#define trace_xrep_newbt_alloc_block(...)	((void) 0)
+
+int bload_leaf_slack = -1;
+int bload_node_slack = -1;
+
+/* Ported routines from fs/xfs/scrub/repair.c */
+
+/*
+ * Roll a transaction, keeping the AG headers locked and reinitializing
+ * the btree cursors.
+ */
+int
+xrep_roll_ag_trans(
+	struct repair_ctx	*sc)
+{
+	int			error;
+
+	/* Keep the AG header buffers locked so we can keep going. */
+	if (sc->agi_bp)
+		libxfs_trans_bhold(sc->tp, sc->agi_bp);
+	if (sc->agf_bp)
+		libxfs_trans_bhold(sc->tp, sc->agf_bp);
+	if (sc->agfl_bp)
+		libxfs_trans_bhold(sc->tp, sc->agfl_bp);
+
+	/*
+	 * Roll the transaction.  We still own the buffer and the buffer lock
+	 * regardless of whether or not the roll succeeds.  If the roll fails,
+	 * the buffers will be released during teardown on our way out of the
+	 * kernel.  If it succeeds, we join them to the new transaction and
+	 * move on.
+	 */
+	error = -libxfs_trans_roll(&sc->tp);
+	if (error)
+		return error;
+
+	/* Join AG headers to the new transaction. */
+	if (sc->agi_bp)
+		libxfs_trans_bjoin(sc->tp, sc->agi_bp);
+	if (sc->agf_bp)
+		libxfs_trans_bjoin(sc->tp, sc->agf_bp);
+	if (sc->agfl_bp)
+		libxfs_trans_bjoin(sc->tp, sc->agfl_bp);
+
+	return 0;
+}
+
+/* Initialize accounting resources for staging a new AG btree. */
+void
+xrep_newbt_init_ag(
+	struct xrep_newbt		*xnr,
+	struct repair_ctx		*sc,
+	const struct xfs_owner_info	*oinfo,
+	xfs_fsblock_t			alloc_hint,
+	enum xfs_ag_resv_type		resv)
+{
+	memset(xnr, 0, sizeof(struct xrep_newbt));
+	xnr->sc = sc;
+	xnr->oinfo = *oinfo; /* structure copy */
+	xnr->alloc_hint = alloc_hint;
+	xnr->resv = resv;
+	INIT_LIST_HEAD(&xnr->reservations);
+}
+
+/* Initialize accounting resources for staging a new inode fork btree. */
+void
+xrep_newbt_init_inode(
+	struct xrep_newbt		*xnr,
+	struct repair_ctx		*sc,
+	int				whichfork,
+	const struct xfs_owner_info	*oinfo)
+{
+	memset(xnr, 0, sizeof(struct xrep_newbt));
+	xnr->sc = sc;
+	xnr->oinfo = *oinfo; /* structure copy */
+	xnr->alloc_hint = XFS_INO_TO_FSB(sc->mp, sc->ip->i_ino);
+	xnr->resv = XFS_AG_RESV_NONE;
+	xnr->ifake.if_fork = kmem_zone_zalloc(xfs_ifork_zone, 0);
+	xnr->ifake.if_fork_size = XFS_IFORK_SIZE(sc->ip, whichfork);
+	INIT_LIST_HEAD(&xnr->reservations);
+}
+
+/*
+ * Initialize accounting resources for staging a new btree.  Callers are
+ * expected to add their own reservations (and clean them up) manually.
+ */
+void
+xrep_newbt_init_bare(
+	struct xrep_newbt		*xnr,
+	struct repair_ctx		*sc)
+{
+	xrep_newbt_init_ag(xnr, sc, &XFS_RMAP_OINFO_ANY_OWNER, NULLFSBLOCK,
+			XFS_AG_RESV_NONE);
+}
+
+/* Add a space reservation manually. */
+int
+xrep_newbt_add_reservation(
+	struct xrep_newbt		*xnr,
+	xfs_fsblock_t			fsbno,
+	xfs_extlen_t			len,
+	void				*priv)
+{
+	struct xrep_newbt_resv	*resv;
+
+	resv = kmem_alloc(sizeof(struct xrep_newbt_resv), KM_MAYFAIL);
+	if (!resv)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&resv->list);
+	resv->fsbno = fsbno;
+	resv->len = len;
+	resv->used = 0;
+	resv->priv = priv;
+	list_add_tail(&resv->list, &xnr->reservations);
+	return 0;
+}
+
+/* Reserve disk space for our new btree. */
+int
+xrep_newbt_reserve_space(
+	struct xrep_newbt	*xnr,
+	uint64_t		nr_blocks)
+{
+	struct repair_ctx	*sc = xnr->sc;
+	xfs_alloctype_t		type;
+	xfs_fsblock_t		alloc_hint = xnr->alloc_hint;
+	int			error = 0;
+
+	type = sc->ip ? XFS_ALLOCTYPE_START_BNO : XFS_ALLOCTYPE_NEAR_BNO;
+
+	while (nr_blocks > 0 && !error) {
+		struct xfs_alloc_arg	args = {
+			.tp		= sc->tp,
+			.mp		= sc->mp,
+			.type		= type,
+			.fsbno		= alloc_hint,
+			.oinfo		= xnr->oinfo,
+			.minlen		= 1,
+			.maxlen		= nr_blocks,
+			.prod		= nr_blocks,
+			.resv		= xnr->resv,
+		};
+
+		error = -libxfs_alloc_vextent(&args);
+		if (error)
+			return error;
+		if (args.fsbno == NULLFSBLOCK)
+			return -ENOSPC;
+
+		trace_xrep_newbt_reserve_space(sc->mp,
+				XFS_FSB_TO_AGNO(sc->mp, args.fsbno),
+				XFS_FSB_TO_AGBNO(sc->mp, args.fsbno),
+				args.len, xnr->oinfo.oi_owner);
+
+		/* We don't have real EFIs here so skip that. */
+
+		error = xrep_newbt_add_reservation(xnr, args.fsbno, args.len,
+				NULL);
+		if (error)
+			break;
+
+		nr_blocks -= args.len;
+		alloc_hint = args.fsbno + args.len - 1;
+
+		if (sc->ip)
+			error = -libxfs_trans_roll_inode(&sc->tp, sc->ip);
+		else
+			error = xrep_roll_ag_trans(sc);
+	}
+
+	return error;
+}
+
+/* Free all the accounting infor and disk space we reserved for a new btree. */
+void
+xrep_newbt_destroy(
+	struct xrep_newbt	*xnr,
+	int			error)
+{
+	struct repair_ctx	*sc = xnr->sc;
+	struct xrep_newbt_resv	*resv, *n;
+
+	if (error)
+		goto junkit;
+
+	list_for_each_entry_safe(resv, n, &xnr->reservations, list) {
+		/* We don't have EFIs here so skip the EFD. */
+
+		/* Free every block we didn't use. */
+		resv->fsbno += resv->used;
+		resv->len -= resv->used;
+		resv->used = 0;
+
+		if (resv->len > 0) {
+			trace_xrep_newbt_unreserve_space(sc->mp,
+					XFS_FSB_TO_AGNO(sc->mp, resv->fsbno),
+					XFS_FSB_TO_AGBNO(sc->mp, resv->fsbno),
+					resv->len, xnr->oinfo.oi_owner);
+
+			__libxfs_bmap_add_free(sc->tp, resv->fsbno, resv->len,
+					&xnr->oinfo, true);
+		}
+
+		list_del(&resv->list);
+		kmem_free(resv);
+	}
+
+junkit:
+	list_for_each_entry_safe(resv, n, &xnr->reservations, list) {
+		list_del(&resv->list);
+		kmem_free(resv);
+	}
+
+	if (sc->ip) {
+		kmem_zone_free(xfs_ifork_zone, xnr->ifake.if_fork);
+		xnr->ifake.if_fork = NULL;
+	}
+}
+
+/* Feed one of the reserved btree blocks to the bulk loader. */
+int
+xrep_newbt_alloc_block(
+	struct xfs_btree_cur	*cur,
+	struct xrep_newbt	*xnr,
+	union xfs_btree_ptr	*ptr)
+{
+	struct xrep_newbt_resv	*resv;
+	xfs_fsblock_t		fsb;
+
+	/*
+	 * If last_resv doesn't have a block for us, move forward until we find
+	 * one that does (or run out of reservations).
+	 */
+	if (xnr->last_resv == NULL) {
+		list_for_each_entry(resv, &xnr->reservations, list) {
+			if (resv->used < resv->len) {
+				xnr->last_resv = resv;
+				break;
+			}
+		}
+		if (xnr->last_resv == NULL)
+			return -ENOSPC;
+	} else if (xnr->last_resv->used == xnr->last_resv->len) {
+		if (xnr->last_resv->list.next == &xnr->reservations)
+			return -ENOSPC;
+		xnr->last_resv = list_entry(xnr->last_resv->list.next,
+				struct xrep_newbt_resv, list);
+	}
+
+	/* Nab the block. */
+	fsb = xnr->last_resv->fsbno + xnr->last_resv->used;
+	xnr->last_resv->used++;
+
+	trace_xrep_newbt_alloc_block(cur->bc_mp,
+			XFS_FSB_TO_AGNO(cur->bc_mp, fsb),
+			XFS_FSB_TO_AGBNO(cur->bc_mp, fsb),
+			xnr->oinfo.oi_owner);
+
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
+		ptr->l = cpu_to_be64(fsb);
+	else
+		ptr->s = cpu_to_be32(XFS_FSB_TO_AGBNO(cur->bc_mp, fsb));
+	return 0;
+}
diff --git a/repair/bload.h b/repair/bload.h
new file mode 100644
index 00000000..8f890157
--- /dev/null
+++ b/repair/bload.h
@@ -0,0 +1,79 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2019 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#ifndef __XFS_REPAIR_BLOAD_H__
+#define __XFS_REPAIR_BLOAD_H__
+
+extern int bload_leaf_slack;
+extern int bload_node_slack;
+
+struct repair_ctx {
+	struct xfs_mount	*mp;
+	struct xfs_inode	*ip;
+	struct xfs_trans	*tp;
+
+	struct xfs_buf		*agi_bp;
+	struct xfs_buf		*agf_bp;
+	struct xfs_buf		*agfl_bp;
+};
+
+struct xrep_newbt_resv {
+	/* Link to list of extents that we've reserved. */
+	struct list_head	list;
+
+	void			*priv;
+
+	/* FSB of the block we reserved. */
+	xfs_fsblock_t		fsbno;
+
+	/* Length of the reservation. */
+	xfs_extlen_t		len;
+
+	/* How much of this reservation we've used. */
+	xfs_extlen_t		used;
+};
+
+struct xrep_newbt {
+	struct repair_ctx	*sc;
+
+	/* List of extents that we've reserved. */
+	struct list_head	reservations;
+
+	/* Fake root for new btree. */
+	union {
+		struct xbtree_afakeroot	afake;
+		struct xbtree_ifakeroot	ifake;
+	};
+
+	/* rmap owner of these blocks */
+	struct xfs_owner_info	oinfo;
+
+	/* The last reservation we allocated from. */
+	struct xrep_newbt_resv	*last_resv;
+
+	/* Allocation hint */
+	xfs_fsblock_t		alloc_hint;
+
+	/* per-ag reservation type */
+	enum xfs_ag_resv_type	resv;
+};
+
+#define for_each_xrep_newbt_reservation(xnr, resv, n)	\
+	list_for_each_entry_safe((resv), (n), &(xnr)->reservations, list)
+
+void xrep_newbt_init_bare(struct xrep_newbt *xba, struct repair_ctx *sc);
+void xrep_newbt_init_ag(struct xrep_newbt *xba, struct repair_ctx *sc,
+		const struct xfs_owner_info *oinfo, xfs_fsblock_t alloc_hint,
+		enum xfs_ag_resv_type resv);
+void xrep_newbt_init_inode(struct xrep_newbt *xba, struct repair_ctx *sc,
+		int whichfork, const struct xfs_owner_info *oinfo);
+int xrep_newbt_add_reservation(struct xrep_newbt *xba, xfs_fsblock_t fsbno,
+		xfs_extlen_t len, void *priv);
+int xrep_newbt_reserve_space(struct xrep_newbt *xba, uint64_t nr_blocks);
+void xrep_newbt_destroy(struct xrep_newbt *xba, int error);
+int xrep_newbt_alloc_block(struct xfs_btree_cur *cur, struct xrep_newbt *xba,
+		union xfs_btree_ptr *ptr);
+
+#endif /* __XFS_REPAIR_BLOAD_H__ */
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 9295673d..ec8b615b 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -24,6 +24,7 @@
 #include "rmap.h"
 #include "libfrog/fsgeom.h"
 #include "libfrog/platform.h"
+#include "bload.h"
 
 /*
  * option tables for getsubopt calls
@@ -39,6 +40,8 @@ enum o_opt_nums {
 	AG_STRIDE,
 	FORCE_GEO,
 	PHASE2_THREADS,
+	BLOAD_LEAF_SLACK,
+	BLOAD_NODE_SLACK,
 	O_MAX_OPTS,
 };
 
@@ -49,6 +52,8 @@ static char *o_opts[] = {
 	[AG_STRIDE]		= "ag_stride",
 	[FORCE_GEO]		= "force_geometry",
 	[PHASE2_THREADS]	= "phase2_threads",
+	[BLOAD_LEAF_SLACK]	= "debug_bload_leaf_slack",
+	[BLOAD_NODE_SLACK]	= "debug_bload_node_slack",
 	[O_MAX_OPTS]		= NULL,
 };
 
@@ -260,6 +265,18 @@ process_args(int argc, char **argv)
 		_("-o phase2_threads requires a parameter\n"));
 					phase2_threads = (int)strtol(val, NULL, 0);
 					break;
+				case BLOAD_LEAF_SLACK:
+					if (!val)
+						do_abort(
+		_("-o debug_bload_leaf_slack requires a parameter\n"));
+					bload_leaf_slack = (int)strtol(val, NULL, 0);
+					break;
+				case BLOAD_NODE_SLACK:
+					if (!val)
+						do_abort(
+		_("-o debug_bload_node_slack requires a parameter\n"));
+					bload_node_slack = (int)strtol(val, NULL, 0);
+					break;
 				default:
 					unknown('o', val);
 					break;

