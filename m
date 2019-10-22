Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79239E0BE4
	for <lists+linux-xfs@lfdr.de>; Tue, 22 Oct 2019 20:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730186AbfJVSvX (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 22 Oct 2019 14:51:23 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54294 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbfJVSvX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 14:51:23 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiRXi091122;
        Tue, 22 Oct 2019 18:51:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=WXKjfqbztmje1/ZqXlj0QoI9pY33LWjUofQfqzKmgNA=;
 b=BhkE4yDEGFAz8fcbeWrH0oRvsV11w62gDkywWfsb/QBR+alUPVqvB0ptEJH5ijqc7j7E
 Xetn4CW06NvjgfGZGnNX+JFIcBAGL+Nz/PfNwQCKznSy51O2i0YcoVyZM0Y8j6j6qZkz
 kH4Kr2NkTaa9TwztSkChhqM4LUESsJ0S58+6/DG1jyM82Qx8FHyo5POitLOPBzUSZhTC
 VcRMTa5OreANpPPVev1k0QUkxzekNCS1Hviia08vfu/8YcdoFMkKdfhXgEZG9Zuo8MRH
 lAZHQ5fXR5jplE6ggUluWwkIIsmqsvqscEITSOWRpbOMZtDoYt1HOYqXGuIMup/CppV9 0A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2vqteprrkp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:51:19 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIhnnP148236;
        Tue, 22 Oct 2019 18:51:18 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2vsp4014yg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:51:18 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9MIpHDX031553;
        Tue, 22 Oct 2019 18:51:17 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 11:51:17 -0700
Subject: [PATCH 08/18] xfs_scrub: remove moveon from scrub ioctl wrappers
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 22 Oct 2019 11:51:16 -0700
Message-ID: <157177027613.1461658.11661079417630138991.stgit@magnolia>
In-Reply-To: <157177022106.1461658.18024534947316119946.stgit@magnolia>
References: <157177022106.1461658.18024534947316119946.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910220156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910220156
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Replace the moveon returns in the scrub ioctl wrapper functions
with a direct integer error return.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/phase2.c    |   23 ++++++++-------
 scrub/phase3.c    |   38 +++++++++++++-----------
 scrub/phase4.c    |    8 +++--
 scrub/phase5.c    |    4 +--
 scrub/phase7.c    |    4 +--
 scrub/scrub.c     |   84 ++++++++++++++++++++++++++++++-----------------------
 scrub/scrub.h     |   26 ++++++++--------
 scrub/xfs_scrub.h |    2 +
 8 files changed, 102 insertions(+), 87 deletions(-)


diff --git a/scrub/phase2.c b/scrub/phase2.c
index d92b7e29..016d8ec5 100644
--- a/scrub/phase2.c
+++ b/scrub/phase2.c
@@ -32,6 +32,7 @@ xfs_scan_ag_metadata(
 	unsigned long long		broken_secondaries;
 	bool				moveon;
 	char				descr[DESCR_BUFSZ];
+	int				ret;
 
 	xfs_action_list_init(&alist);
 	xfs_action_list_init(&immediate_alist);
@@ -41,8 +42,8 @@ xfs_scan_ag_metadata(
 	 * First we scrub and fix the AG headers, because we need
 	 * them to work well enough to check the AG btrees.
 	 */
-	moveon = xfs_scrub_ag_headers(ctx, agno, &alist);
-	if (!moveon)
+	ret = xfs_scrub_ag_headers(ctx, agno, &alist);
+	if (ret)
 		goto err;
 
 	/* Repair header damage. */
@@ -51,8 +52,8 @@ xfs_scan_ag_metadata(
 		goto err;
 
 	/* Now scrub the AG btrees. */
-	moveon = xfs_scrub_ag_metadata(ctx, agno, &alist);
-	if (!moveon)
+	ret = xfs_scrub_ag_metadata(ctx, agno, &alist);
+	if (ret)
 		goto err;
 
 	/*
@@ -100,11 +101,11 @@ xfs_scan_fs_metadata(
 	struct scrub_ctx		*ctx = (struct scrub_ctx *)wq->wq_ctx;
 	bool				*pmoveon = arg;
 	struct xfs_action_list		alist;
-	bool				moveon;
+	int				ret;
 
 	xfs_action_list_init(&alist);
-	moveon = xfs_scrub_fs_metadata(ctx, &alist);
-	if (!moveon)
+	ret = xfs_scrub_fs_metadata(ctx, &alist);
+	if (ret)
 		*pmoveon = false;
 
 	xfs_action_list_defer(ctx, agno, &alist);
@@ -134,9 +135,11 @@ xfs_scan_metadata(
 	 * anything else.
 	 */
 	xfs_action_list_init(&alist);
-	moveon = xfs_scrub_primary_super(ctx, &alist);
-	if (!moveon)
+	ret = xfs_scrub_primary_super(ctx, &alist);
+	if (ret) {
+		moveon = false;
 		goto out;
+	}
 	moveon = xfs_action_list_process_or_defer(ctx, 0, &alist);
 	if (!moveon)
 		goto out;
@@ -178,7 +181,7 @@ xfs_estimate_metadata_work(
 	unsigned int		*nr_threads,
 	int			*rshift)
 {
-	*items = xfs_scrub_estimate_ag_work(ctx);
+	*items = scrub_estimate_ag_work(ctx);
 	*nr_threads = scrub_nproc(ctx);
 	*rshift = 0;
 	return true;
diff --git a/scrub/phase3.c b/scrub/phase3.c
index 171be3fd..4248e85f 100644
--- a/scrub/phase3.c
+++ b/scrub/phase3.c
@@ -25,10 +25,10 @@
  * ensure that the inode we're checking matches what the inode scan
  * told us to look at.
  */
-static bool
-xfs_scrub_fd(
+static int
+scrub_fd(
 	struct scrub_ctx	*ctx,
-	bool			(*fn)(struct scrub_ctx *ctx, uint64_t ino,
+	int			(*fn)(struct scrub_ctx *ctx, uint64_t ino,
 				      uint32_t gen, struct xfs_action_list *a),
 	struct xfs_bulkstat	*bs,
 	struct xfs_action_list	*alist)
@@ -85,8 +85,8 @@ xfs_scrub_inode(
 	}
 
 	/* Scrub the inode. */
-	moveon = xfs_scrub_fd(ctx, xfs_scrub_inode_fields, bstat, &alist);
-	if (!moveon)
+	error = scrub_fd(ctx, xfs_scrub_inode_fields, bstat, &alist);
+	if (error)
 		goto out;
 
 	moveon = xfs_action_list_process_or_defer(ctx, agno, &alist);
@@ -94,14 +94,14 @@ xfs_scrub_inode(
 		goto out;
 
 	/* Scrub all block mappings. */
-	moveon = xfs_scrub_fd(ctx, xfs_scrub_data_fork, bstat, &alist);
-	if (!moveon)
+	error = scrub_fd(ctx, xfs_scrub_data_fork, bstat, &alist);
+	if (error)
 		goto out;
-	moveon = xfs_scrub_fd(ctx, xfs_scrub_attr_fork, bstat, &alist);
-	if (!moveon)
+	error = scrub_fd(ctx, xfs_scrub_attr_fork, bstat, &alist);
+	if (error)
 		goto out;
-	moveon = xfs_scrub_fd(ctx, xfs_scrub_cow_fork, bstat, &alist);
-	if (!moveon)
+	error = scrub_fd(ctx, xfs_scrub_cow_fork, bstat, &alist);
+	if (error)
 		goto out;
 
 	moveon = xfs_action_list_process_or_defer(ctx, agno, &alist);
@@ -110,23 +110,23 @@ xfs_scrub_inode(
 
 	if (S_ISLNK(bstat->bs_mode)) {
 		/* Check symlink contents. */
-		moveon = xfs_scrub_symlink(ctx, bstat->bs_ino, bstat->bs_gen,
+		error = xfs_scrub_symlink(ctx, bstat->bs_ino, bstat->bs_gen,
 				&alist);
 	} else if (S_ISDIR(bstat->bs_mode)) {
 		/* Check the directory entries. */
-		moveon = xfs_scrub_fd(ctx, xfs_scrub_dir, bstat, &alist);
+		error = scrub_fd(ctx, xfs_scrub_dir, bstat, &alist);
 	}
-	if (!moveon)
+	if (error)
 		goto out;
 
 	/* Check all the extended attributes. */
-	moveon = xfs_scrub_fd(ctx, xfs_scrub_attr, bstat, &alist);
-	if (!moveon)
+	error = scrub_fd(ctx, xfs_scrub_attr, bstat, &alist);
+	if (error)
 		goto out;
 
 	/* Check parent pointers. */
-	moveon = xfs_scrub_fd(ctx, xfs_scrub_parent, bstat, &alist);
-	if (!moveon)
+	error = scrub_fd(ctx, xfs_scrub_parent, bstat, &alist);
+	if (error)
 		goto out;
 
 	/* Try to repair the file while it's open. */
@@ -135,6 +135,8 @@ xfs_scrub_inode(
 		goto out;
 
 out:
+	if (error)
+		moveon = false;
 	error = ptcounter_add(icount, 1);
 	if (error) {
 		str_liberror(ctx, error,
diff --git a/scrub/phase4.c b/scrub/phase4.c
index a276bc32..a121df02 100644
--- a/scrub/phase4.c
+++ b/scrub/phase4.c
@@ -114,9 +114,9 @@ xfs_process_action_items(
 /* Fix everything that needs fixing. */
 bool
 xfs_repair_fs(
-	struct scrub_ctx		*ctx)
+	struct scrub_ctx	*ctx)
 {
-	bool				moveon;
+	int			ret;
 
 	/*
 	 * Check the summary counters early.  Normally we do this during phase
@@ -124,8 +124,8 @@ xfs_repair_fs(
 	 * counters, so counter repairs have to be put on the list now so that
 	 * they get fixed before we stop retrying unfixed metadata repairs.
 	 */
-	moveon = xfs_scrub_fs_summary(ctx, &ctx->action_lists[0]);
-	if (!moveon)
+	ret = xfs_scrub_fs_summary(ctx, &ctx->action_lists[0]);
+	if (ret)
 		return false;
 
 	return xfs_process_action_items(ctx);
diff --git a/scrub/phase5.c b/scrub/phase5.c
index e752a0c4..c2cccd76 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -390,8 +390,8 @@ _("Filesystem has errors, skipping connectivity checks."));
 		return true;
 	}
 
-	moveon = xfs_scrub_fs_label(ctx);
-	if (!moveon)
+	ret = xfs_scrub_fs_label(ctx);
+	if (ret)
 		return false;
 
 	ret = scrub_scan_all_inodes(ctx, xfs_scrub_connections, &moveon);
diff --git a/scrub/phase7.c b/scrub/phase7.c
index 4314904f..b5f77b36 100644
--- a/scrub/phase7.c
+++ b/scrub/phase7.c
@@ -121,8 +121,8 @@ xfs_scan_summary(
 
 	/* Check and fix the fs summary counters. */
 	xfs_action_list_init(&alist);
-	moveon = xfs_scrub_fs_summary(ctx, &alist);
-	if (!moveon)
+	error = xfs_scrub_fs_summary(ctx, &alist);
+	if (error)
 		return false;
 	moveon = xfs_action_list_process(ctx, ctx->mnt.fd, &alist,
 			ALP_COMPLAIN_IF_UNFIXED | ALP_NOPROGRESS);
diff --git a/scrub/scrub.c b/scrub/scrub.c
index d9df1e5b..2bda5054 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -249,7 +249,7 @@ _("Optimizations of %s are possible."), _(xfrog_scrubbers[i].descr));
 }
 
 /* Save a scrub context for later repairs. */
-static bool
+static int
 xfs_scrub_save_repair(
 	struct scrub_ctx		*ctx,
 	struct xfs_action_list		*alist,
@@ -260,9 +260,10 @@ xfs_scrub_save_repair(
 	/* Schedule this item for later repairs. */
 	aitem = malloc(sizeof(struct action_item));
 	if (!aitem) {
-		str_errno(ctx, _("repair list"));
-		return false;
+		str_errno(ctx, _("adding item to repair list"));
+		return errno;
 	}
+
 	memset(aitem, 0, sizeof(*aitem));
 	aitem->type = meta->sm_type;
 	aitem->flags = meta->sm_flags;
@@ -280,10 +281,15 @@ xfs_scrub_save_repair(
 	}
 
 	xfs_action_list_add(alist, aitem);
-	return true;
+	return 0;
 }
 
-/* Scrub a single XFS_SCRUB_TYPE_*, saving corruption reports for later. */
+/*
+ * Scrub a single XFS_SCRUB_TYPE_*, saving corruption reports for later.
+ *
+ * Returns 0 for success.  If errors occur, this function will log them and
+ * return a positive error code.
+ */
 static int
 xfs_scrub_meta_type(
 	struct scrub_ctx		*ctx,
@@ -296,6 +302,7 @@ xfs_scrub_meta_type(
 		.sm_agno		= agno,
 	};
 	enum check_outcome		fix;
+	int				ret;
 
 	background_sleep();
 
@@ -307,8 +314,9 @@ xfs_scrub_meta_type(
 	case CHECK_ABORT:
 		return ECANCELED;
 	case CHECK_REPAIR:
-		if (!xfs_scrub_save_repair(ctx, alist, &meta))
-			return ENOMEM;
+		ret = xfs_scrub_save_repair(ctx, alist, &meta);
+		if (ret)
+			return ret;
 		/* fall through */
 	case CHECK_DONE:
 		return 0;
@@ -344,30 +352,28 @@ xfs_scrub_all_types(
 
 		ret = xfs_scrub_meta_type(ctx, type, agno, alist);
 		if (ret)
-			return false;
+			return ret;
 	}
 
-	return true;
+	return 0;
 }
 
 /*
  * Scrub primary superblock.  This will be useful if we ever need to hook
  * a filesystem-wide pre-scrub activity off of the sb 0 scrubber (which
- * currently does nothing).
+ * currently does nothing).  If errors occur, this function will log them and
+ * return nonzero.
  */
-bool
+int
 xfs_scrub_primary_super(
 	struct scrub_ctx		*ctx,
 	struct xfs_action_list		*alist)
 {
-	int				ret;
-
-	ret = xfs_scrub_meta_type(ctx, XFS_SCRUB_TYPE_SB, 0, alist);
-	return ret == 0;
+	return xfs_scrub_meta_type(ctx, XFS_SCRUB_TYPE_SB, 0, alist);
 }
 
 /* Scrub each AG's header blocks. */
-bool
+int
 xfs_scrub_ag_headers(
 	struct scrub_ctx		*ctx,
 	xfs_agnumber_t			agno,
@@ -377,7 +383,7 @@ xfs_scrub_ag_headers(
 }
 
 /* Scrub each AG's metadata btrees. */
-bool
+int
 xfs_scrub_ag_metadata(
 	struct scrub_ctx		*ctx,
 	xfs_agnumber_t			agno,
@@ -387,7 +393,7 @@ xfs_scrub_ag_metadata(
 }
 
 /* Scrub whole-FS metadata btrees. */
-bool
+int
 xfs_scrub_fs_metadata(
 	struct scrub_ctx		*ctx,
 	struct xfs_action_list		*alist)
@@ -396,20 +402,17 @@ xfs_scrub_fs_metadata(
 }
 
 /* Scrub FS summary metadata. */
-bool
+int
 xfs_scrub_fs_summary(
 	struct scrub_ctx		*ctx,
 	struct xfs_action_list		*alist)
 {
-	int				ret;
-
-	ret = xfs_scrub_meta_type(ctx, XFS_SCRUB_TYPE_FSCOUNTERS, 0, alist);
-	return ret == 0;
+	return xfs_scrub_meta_type(ctx, XFS_SCRUB_TYPE_FSCOUNTERS, 0, alist);
 }
 
 /* How many items do we have to check? */
 unsigned int
-xfs_scrub_estimate_ag_work(
+scrub_estimate_ag_work(
 	struct scrub_ctx		*ctx)
 {
 	const struct xfrog_scrub_descr	*sc;
@@ -433,8 +436,11 @@ xfs_scrub_estimate_ag_work(
 	return estimate;
 }
 
-/* Scrub inode metadata. */
-static bool
+/*
+ * Scrub inode metadata.  If errors occur, this function will log them and
+ * return nonzero.
+ */
+static int
 __xfs_scrub_file(
 	struct scrub_ctx		*ctx,
 	uint64_t			ino,
@@ -455,14 +461,14 @@ __xfs_scrub_file(
 	/* Scrub the piece of metadata. */
 	fix = xfs_check_metadata(ctx, &meta, true);
 	if (fix == CHECK_ABORT)
-		return false;
+		return ECANCELED;
 	if (fix == CHECK_DONE)
-		return true;
+		return 0;
 
 	return xfs_scrub_save_repair(ctx, alist, &meta);
 }
 
-bool
+int
 xfs_scrub_inode_fields(
 	struct scrub_ctx	*ctx,
 	uint64_t		ino,
@@ -472,7 +478,7 @@ xfs_scrub_inode_fields(
 	return __xfs_scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_INODE, alist);
 }
 
-bool
+int
 xfs_scrub_data_fork(
 	struct scrub_ctx	*ctx,
 	uint64_t		ino,
@@ -482,7 +488,7 @@ xfs_scrub_data_fork(
 	return __xfs_scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_BMBTD, alist);
 }
 
-bool
+int
 xfs_scrub_attr_fork(
 	struct scrub_ctx	*ctx,
 	uint64_t		ino,
@@ -492,7 +498,7 @@ xfs_scrub_attr_fork(
 	return __xfs_scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_BMBTA, alist);
 }
 
-bool
+int
 xfs_scrub_cow_fork(
 	struct scrub_ctx	*ctx,
 	uint64_t		ino,
@@ -502,7 +508,7 @@ xfs_scrub_cow_fork(
 	return __xfs_scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_BMBTC, alist);
 }
 
-bool
+int
 xfs_scrub_dir(
 	struct scrub_ctx	*ctx,
 	uint64_t		ino,
@@ -512,7 +518,7 @@ xfs_scrub_dir(
 	return __xfs_scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_DIR, alist);
 }
 
-bool
+int
 xfs_scrub_attr(
 	struct scrub_ctx	*ctx,
 	uint64_t		ino,
@@ -522,7 +528,7 @@ xfs_scrub_attr(
 	return __xfs_scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_XATTR, alist);
 }
 
-bool
+int
 xfs_scrub_symlink(
 	struct scrub_ctx	*ctx,
 	uint64_t		ino,
@@ -532,7 +538,7 @@ xfs_scrub_symlink(
 	return __xfs_scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_SYMLINK, alist);
 }
 
-bool
+int
 xfs_scrub_parent(
 	struct scrub_ctx	*ctx,
 	uint64_t		ino,
@@ -542,7 +548,11 @@ xfs_scrub_parent(
 	return __xfs_scrub_file(ctx, ino, gen, XFS_SCRUB_TYPE_PARENT, alist);
 }
 
-/* Test the availability of a kernel scrub command. */
+/*
+ * Test the availability of a kernel scrub command.  If errors occur (or the
+ * scrub ioctl is rejected) the errors will be logged and this function will
+ * return false.
+ */
 static bool
 __xfs_scrub_test(
 	struct scrub_ctx		*ctx,
diff --git a/scrub/scrub.h b/scrub/scrub.h
index d407abb0..bfb3f8e3 100644
--- a/scrub/scrub.h
+++ b/scrub/scrub.h
@@ -17,15 +17,15 @@ enum check_outcome {
 struct action_item;
 
 void xfs_scrub_report_preen_triggers(struct scrub_ctx *ctx);
-bool xfs_scrub_primary_super(struct scrub_ctx *ctx,
+int xfs_scrub_primary_super(struct scrub_ctx *ctx,
 		struct xfs_action_list *alist);
-bool xfs_scrub_ag_headers(struct scrub_ctx *ctx, xfs_agnumber_t agno,
+int xfs_scrub_ag_headers(struct scrub_ctx *ctx, xfs_agnumber_t agno,
 		struct xfs_action_list *alist);
-bool xfs_scrub_ag_metadata(struct scrub_ctx *ctx, xfs_agnumber_t agno,
+int xfs_scrub_ag_metadata(struct scrub_ctx *ctx, xfs_agnumber_t agno,
 		struct xfs_action_list *alist);
-bool xfs_scrub_fs_metadata(struct scrub_ctx *ctx,
+int xfs_scrub_fs_metadata(struct scrub_ctx *ctx,
 		struct xfs_action_list *alist);
-bool xfs_scrub_fs_summary(struct scrub_ctx *ctx,
+int xfs_scrub_fs_summary(struct scrub_ctx *ctx,
 		struct xfs_action_list *alist);
 
 bool xfs_can_scrub_fs_metadata(struct scrub_ctx *ctx);
@@ -37,21 +37,21 @@ bool xfs_can_scrub_symlink(struct scrub_ctx *ctx);
 bool xfs_can_scrub_parent(struct scrub_ctx *ctx);
 bool xfs_can_repair(struct scrub_ctx *ctx);
 
-bool xfs_scrub_inode_fields(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
+int xfs_scrub_inode_fields(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
 		struct xfs_action_list *alist);
-bool xfs_scrub_data_fork(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
+int xfs_scrub_data_fork(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
 		struct xfs_action_list *alist);
-bool xfs_scrub_attr_fork(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
+int xfs_scrub_attr_fork(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
 		struct xfs_action_list *alist);
-bool xfs_scrub_cow_fork(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
+int xfs_scrub_cow_fork(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
 		struct xfs_action_list *alist);
-bool xfs_scrub_dir(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
+int xfs_scrub_dir(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
 		struct xfs_action_list *alist);
-bool xfs_scrub_attr(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
+int xfs_scrub_attr(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
 		struct xfs_action_list *alist);
-bool xfs_scrub_symlink(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
+int xfs_scrub_symlink(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
 		struct xfs_action_list *alist);
-bool xfs_scrub_parent(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
+int xfs_scrub_parent(struct scrub_ctx *ctx, uint64_t ino, uint32_t gen,
 		struct xfs_action_list *alist);
 
 /* Repair parameters are the scrub inputs and retry count. */
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index ed0e63b8..d8032e3d 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -99,7 +99,7 @@ bool xfs_repair_fs(struct scrub_ctx *ctx);
 
 /* Progress estimator functions */
 uint64_t xfs_estimate_inodes(struct scrub_ctx *ctx);
-unsigned int xfs_scrub_estimate_ag_work(struct scrub_ctx *ctx);
+unsigned int scrub_estimate_ag_work(struct scrub_ctx *ctx);
 bool xfs_estimate_metadata_work(struct scrub_ctx *ctx, uint64_t *items,
 				unsigned int *nr_threads, int *rshift);
 bool xfs_estimate_inodes_work(struct scrub_ctx *ctx, uint64_t *items,

