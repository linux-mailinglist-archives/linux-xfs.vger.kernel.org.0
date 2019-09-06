Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5159CAB14E
	for <lists+linux-xfs@lfdr.de>; Fri,  6 Sep 2019 05:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388647AbfIFDl5 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 5 Sep 2019 23:41:57 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:55240 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388602AbfIFDl5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 23:41:57 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863eo89114044;
        Fri, 6 Sep 2019 03:41:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=/SbA14fj1BNWf2eu6wlANDb94IiAMpTt067UXWmn8wA=;
 b=RuXWZ7zbIstedMC/IPokF0lB52Y+crqni2Wp6Us0aL6vQt2zfkOm/FsvWzNW2hfLS69v
 rEFy2ypgdzdSudadvaqURp7gVAH18fk63mwK+YxOjUyRxLcj3P4Id9g/V4wrLLIdv2LD
 A/nsK9tnA5MW/OOq0xrGSXYRFt+HpnZ9XJLTjYCVbnY1FRPOCaZJBPnn98iEfv4odwer
 jg3kErURYjl7fWLL08G/QhQlIlfRblB8e9BWeyuBrbUU0jry740VURUpAS4W9euyBJWQ
 948K3il5zV7YW2Ucainn3uuFRHxgrxZkuKQ8MNHHuRSI5reO99kXE8ptMOAx28oi9Vvd qg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2uufr08092-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:41:53 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x863cTku078248;
        Fri, 6 Sep 2019 03:41:29 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2utvr4k2sn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Sep 2019 03:41:28 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x863fSwo007135;
        Fri, 6 Sep 2019 03:41:28 GMT
Received: from localhost (/10.159.148.70)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Sep 2019 20:41:27 -0700
Subject: [PATCH 05/18] xfs_scrub: remove moveon from spacemap
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 Sep 2019 20:41:27 -0700
Message-ID: <156774128712.2646807.8457064239886218120.stgit@magnolia>
In-Reply-To: <156774125578.2646807.1183436616735969617.stgit@magnolia>
References: <156774125578.2646807.1183436616735969617.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909060040
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9371 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909060040
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Replace the moveon returns in the space map iteration code with a direct
integer return.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/phase6.c   |   35 ++++++-------
 scrub/phase7.c   |   21 ++++----
 scrub/spacemap.c |  145 +++++++++++++++++++++++++++++-------------------------
 scrub/spacemap.h |    8 +--
 4 files changed, 107 insertions(+), 102 deletions(-)


diff --git a/scrub/phase6.c b/scrub/phase6.c
index dd6e29af..49650a21 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -359,10 +359,9 @@ xfs_report_verify_dirent(
 }
 
 /* Report an IO error resulting from read-verify based off getfsmap. */
-static bool
+static int
 ioerr_fsmap_report(
 	struct scrub_ctx	*ctx,
-	const char		*descr,
 	struct fsmap		*map,
 	void			*arg)
 {
@@ -373,7 +372,7 @@ ioerr_fsmap_report(
 
 	/* Don't care about unwritten extents. */
 	if (scrub_data < 3 && (map->fmr_flags & FMR_OF_PREALLOC))
-		return true;
+		return 0;
 
 	if (err_physical > map->fmr_physical)
 		err_off = err_physical - map->fmr_physical;
@@ -405,7 +404,7 @@ ioerr_fsmap_report(
 	 * to find the bad file's pathname.
 	 */
 
-	return true;
+	return 0;
 }
 
 static struct bitmap *
@@ -466,15 +465,10 @@ walk_ioerr(
 {
 	struct walk_ioerr	*wioerr = arg;
 	struct fsmap		keys[2];
-	char			descr[DESCR_BUFSZ];
 	dev_t			dev;
 
 	dev = xfs_disk_to_dev(wioerr->ctx, wioerr->disk);
 
-	snprintf(descr, DESCR_BUFSZ,
-_("dev %d:%d ioerr @ %"PRIu64":%"PRIu64" "),
-			major(dev), minor(dev), start, length);
-
 	/* Go figure out which blocks are bad from the fsmap. */
 	memset(keys, 0, sizeof(struct fsmap) * 2);
 	keys->fmr_device = dev;
@@ -484,9 +478,8 @@ _("dev %d:%d ioerr @ %"PRIu64":%"PRIu64" "),
 	(keys + 1)->fmr_owner = ULLONG_MAX;
 	(keys + 1)->fmr_offset = ULLONG_MAX;
 	(keys + 1)->fmr_flags = UINT_MAX;
-	xfs_iterate_fsmap(wioerr->ctx, descr, keys, ioerr_fsmap_report,
+	return scrub_iterate_fsmap(wioerr->ctx, keys, ioerr_fsmap_report,
 			&start);
-	return 0;
 }
 
 static int
@@ -541,10 +534,9 @@ xfs_report_verify_errors(
 }
 
 /* Schedule a read-verify of a (data block) extent. */
-static bool
-xfs_check_rmap(
+static int
+check_rmap(
 	struct scrub_ctx		*ctx,
-	const char			*descr,
 	struct fsmap			*map,
 	void				*arg)
 {
@@ -574,7 +566,7 @@ xfs_check_rmap(
 	 */
 	if (map->fmr_flags & (FMR_OF_PREALLOC | FMR_OF_ATTR_FORK |
 			      FMR_OF_EXTENT_MAP | FMR_OF_SPECIAL_OWNER))
-		return true;
+		return 0;
 
 	/* XXX: Filter out directory data blocks. */
 
@@ -582,11 +574,11 @@ xfs_check_rmap(
 	ret = read_verify_schedule_io(rvp, map->fmr_physical, map->fmr_length,
 			vs);
 	if (ret) {
-		str_liberror(ctx, ret, descr);
-		return false;
+		str_liberror(ctx, ret, _("scheduling media verify command"));
+		return ret;
 	}
 
-	return true;
+	return 0;
 }
 
 /* Wait for read/verify actions to finish, then return # bytes checked. */
@@ -720,8 +712,11 @@ xfs_scan_blocks(
 
 	if (scrub_data > 1)
 		moveon = verify_all_disks(ctx, &vs);
-	else
-		moveon = xfs_scan_all_spacemaps(ctx, xfs_check_rmap, &vs);
+	else {
+		ret = scrub_scan_all_spacemaps(ctx, check_rmap, &vs);
+		if (ret)
+			moveon = false;
+	}
 	if (!moveon)
 		goto out_rtpool;
 
diff --git a/scrub/phase7.c b/scrub/phase7.c
index 64e52359..4314904f 100644
--- a/scrub/phase7.c
+++ b/scrub/phase7.c
@@ -27,10 +27,9 @@ struct summary_counts {
 };
 
 /* Record block usage. */
-static bool
-xfs_record_block_summary(
+static int
+count_block_summary(
 	struct scrub_ctx	*ctx,
-	const char		*descr,
 	struct fsmap		*fsmap,
 	void			*arg)
 {
@@ -41,13 +40,13 @@ xfs_record_block_summary(
 	counts = ptvar_get((struct ptvar *)arg, &ret);
 	if (ret) {
 		str_liberror(ctx, ret, _("retrieving summary counts"));
-		return false;
+		return ret;
 	}
 	if (fsmap->fmr_device == ctx->fsinfo.fs_logdev)
-		return true;
+		return 0;
 	if ((fsmap->fmr_flags & FMR_OF_SPECIAL_OWNER) &&
 	    fsmap->fmr_owner == XFS_FMR_OWN_FREE)
-		return true;
+		return 0;
 
 	len = fsmap->fmr_length;
 
@@ -62,14 +61,14 @@ xfs_record_block_summary(
 	} else {
 		/* Count datadev extents. */
 		if (counts->next_phys >= fsmap->fmr_physical + len)
-			return true;
+			return 0;
 		else if (counts->next_phys > fsmap->fmr_physical)
 			len = counts->next_phys - fsmap->fmr_physical;
 		counts->dbytes += len;
 		counts->next_phys = fsmap->fmr_physical + fsmap->fmr_length;
 	}
 
-	return true;
+	return 0;
 }
 
 /* Add all the summaries in the per-thread counter */
@@ -145,9 +144,11 @@ xfs_scan_summary(
 	}
 
 	/* Use fsmap to count blocks. */
-	moveon = xfs_scan_all_spacemaps(ctx, xfs_record_block_summary, ptvar);
-	if (!moveon)
+	error = scrub_scan_all_spacemaps(ctx, count_block_summary, ptvar);
+	if (error) {
+		moveon = false;
 		goto out_free;
+	}
 	error = ptvar_foreach(ptvar, xfs_add_summaries, &totalcount);
 	if (error) {
 		str_liberror(ctx, error, _("counting blocks"));
diff --git a/scrub/spacemap.c b/scrub/spacemap.c
index 91e8badb..e56f090d 100644
--- a/scrub/spacemap.c
+++ b/scrub/spacemap.c
@@ -31,26 +31,25 @@
 
 #define FSMAP_NR	65536
 
-/* Iterate all the fs block mappings between the two keys. */
-bool
-xfs_iterate_fsmap(
+/*
+ * Iterate all the fs block mappings between the two keys.  Returns 0 or a
+ * positive error number.
+ */
+int
+scrub_iterate_fsmap(
 	struct scrub_ctx	*ctx,
-	const char		*descr,
 	struct fsmap		*keys,
-	xfs_fsmap_iter_fn	fn,
+	scrub_fsmap_iter_fn	fn,
 	void			*arg)
 {
 	struct fsmap_head	*head;
 	struct fsmap		*p;
-	bool			moveon = true;
 	int			i;
 	int			error;
 
 	head = malloc(fsmap_sizeof(FSMAP_NR));
-	if (!head) {
-		str_errno(ctx, descr);
-		return false;
-	}
+	if (!head)
+		return errno;
 
 	memset(head, 0, sizeof(*head));
 	memcpy(head->fmh_keys, keys, sizeof(struct fsmap) * 2);
@@ -60,13 +59,11 @@ xfs_iterate_fsmap(
 		for (i = 0, p = head->fmh_recs;
 		     i < head->fmh_entries;
 		     i++, p++) {
-			moveon = fn(ctx, descr, p, arg);
-			if (!moveon)
+			error = fn(ctx, p, arg);
+			if (error)
 				goto out;
-			if (xfs_scrub_excessive_errors(ctx)) {
-				moveon = false;
+			if (xfs_scrub_excessive_errors(ctx))
 				goto out;
-			}
 		}
 
 		if (head->fmh_entries == 0)
@@ -76,45 +73,36 @@ xfs_iterate_fsmap(
 			break;
 		fsmap_advance(head);
 	}
-
-	if (error) {
-		str_errno(ctx, descr);
-		moveon = false;
-	}
+	if (error)
+		error = errno;
 out:
 	free(head);
-	return moveon;
+	return error;
 }
 
 /* GETFSMAP wrappers routines. */
-struct xfs_scan_blocks {
-	xfs_fsmap_iter_fn	fn;
+struct scan_blocks {
+	scrub_fsmap_iter_fn	fn;
 	void			*arg;
-	bool			moveon;
+	bool			aborted;
 };
 
 /* Iterate all the reverse mappings of an AG. */
 static void
-xfs_scan_ag_blocks(
+scan_ag_rmaps(
 	struct workqueue	*wq,
 	xfs_agnumber_t		agno,
 	void			*arg)
 {
 	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
-	struct xfs_scan_blocks	*sbx = arg;
-	char			descr[DESCR_BUFSZ];
+	struct scan_blocks	*sbx = arg;
 	struct fsmap		keys[2];
 	off64_t			bperag;
-	bool			moveon;
+	int			ret;
 
 	bperag = (off64_t)ctx->mnt.fsgeom.agblocks *
 		 (off64_t)ctx->mnt.fsgeom.blocksize;
 
-	snprintf(descr, DESCR_BUFSZ, _("dev %d:%d AG %u fsmap"),
-				major(ctx->fsinfo.fs_datadev),
-				minor(ctx->fsinfo.fs_datadev),
-				agno);
-
 	memset(keys, 0, sizeof(struct fsmap) * 2);
 	keys->fmr_device = ctx->fsinfo.fs_datadev;
 	keys->fmr_physical = agno * bperag;
@@ -124,25 +112,32 @@ xfs_scan_ag_blocks(
 	(keys + 1)->fmr_offset = ULLONG_MAX;
 	(keys + 1)->fmr_flags = UINT_MAX;
 
-	moveon = xfs_iterate_fsmap(ctx, descr, keys, sbx->fn, sbx->arg);
-	if (!moveon)
-		sbx->moveon = false;
+	if (sbx->aborted)
+		return;
+
+	ret = scrub_iterate_fsmap(ctx, keys, sbx->fn, sbx->arg);
+	if (ret) {
+		char		descr[DESCR_BUFSZ];
+
+		snprintf(descr, DESCR_BUFSZ, _("dev %d:%d AG %u fsmap"),
+					major(ctx->fsinfo.fs_datadev),
+					minor(ctx->fsinfo.fs_datadev),
+					agno);
+		str_liberror(ctx, ret, descr);
+		sbx->aborted = true;
+	}
 }
 
 /* Iterate all the reverse mappings of a standalone device. */
 static void
-xfs_scan_dev_blocks(
+scan_dev_rmaps(
 	struct scrub_ctx	*ctx,
 	int			idx,
 	dev_t			dev,
-	struct xfs_scan_blocks	*sbx)
+	struct scan_blocks	*sbx)
 {
 	struct fsmap		keys[2];
-	char			descr[DESCR_BUFSZ];
-	bool			moveon;
-
-	snprintf(descr, DESCR_BUFSZ, _("dev %d:%d fsmap"),
-			major(dev), minor(dev));
+	int			ret;
 
 	memset(keys, 0, sizeof(struct fsmap) * 2);
 	keys->fmr_device = dev;
@@ -152,79 +147,90 @@ xfs_scan_dev_blocks(
 	(keys + 1)->fmr_offset = ULLONG_MAX;
 	(keys + 1)->fmr_flags = UINT_MAX;
 
-	moveon = xfs_iterate_fsmap(ctx, descr, keys, sbx->fn, sbx->arg);
-	if (!moveon)
-		sbx->moveon = false;
+	if (sbx->aborted)
+		return;
+
+	ret = scrub_iterate_fsmap(ctx, keys, sbx->fn, sbx->arg);
+	if (ret) {
+		char		descr[DESCR_BUFSZ];
+
+		snprintf(descr, DESCR_BUFSZ, _("dev %d:%d fsmap"),
+				major(dev), minor(dev));
+		str_liberror(ctx, ret, descr);
+		sbx->aborted = true;
+	}
 }
 
 /* Iterate all the reverse mappings of the realtime device. */
 static void
-xfs_scan_rt_blocks(
+scan_rt_rmaps(
 	struct workqueue	*wq,
 	xfs_agnumber_t		agno,
 	void			*arg)
 {
 	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
 
-	xfs_scan_dev_blocks(ctx, agno, ctx->fsinfo.fs_rtdev, arg);
+	scan_dev_rmaps(ctx, agno, ctx->fsinfo.fs_rtdev, arg);
 }
 
 /* Iterate all the reverse mappings of the log device. */
 static void
-xfs_scan_log_blocks(
+scan_log_rmaps(
 	struct workqueue	*wq,
 	xfs_agnumber_t		agno,
 	void			*arg)
 {
 	struct scrub_ctx	*ctx = (struct scrub_ctx *)wq->wq_ctx;
 
-	xfs_scan_dev_blocks(ctx, agno, ctx->fsinfo.fs_logdev, arg);
+	scan_dev_rmaps(ctx, agno, ctx->fsinfo.fs_logdev, arg);
 }
 
-/* Scan all the blocks in a filesystem. */
-bool
-xfs_scan_all_spacemaps(
+/*
+ * Scan all the blocks in a filesystem.  If errors occur, this function will
+ * log them and return nonzero.
+ */
+int
+scrub_scan_all_spacemaps(
 	struct scrub_ctx	*ctx,
-	xfs_fsmap_iter_fn	fn,
+	scrub_fsmap_iter_fn	fn,
 	void			*arg)
 {
 	struct workqueue	wq;
-	struct xfs_scan_blocks	sbx;
+	struct scan_blocks	sbx = {
+		.fn		= fn,
+		.arg		= arg,
+	};
 	xfs_agnumber_t		agno;
 	int			ret;
 
-	sbx.moveon = true;
-	sbx.fn = fn;
-	sbx.arg = arg;
-
 	ret = workqueue_create(&wq, (struct xfs_mount *)ctx,
 			scrub_nproc_workqueue(ctx));
 	if (ret) {
 		str_liberror(ctx, ret, _("creating fsmap workqueue"));
-		return false;
+		return ret;
 	}
 	if (ctx->fsinfo.fs_rt) {
-		ret = workqueue_add(&wq, xfs_scan_rt_blocks,
+		ret = workqueue_add(&wq, scan_rt_rmaps,
 				ctx->mnt.fsgeom.agcount + 1, &sbx);
 		if (ret) {
-			sbx.moveon = false;
+			sbx.aborted = true;
 			str_liberror(ctx, ret, _("queueing rtdev fsmap work"));
 			goto out;
 		}
 	}
 	if (ctx->fsinfo.fs_log) {
-		ret = workqueue_add(&wq, xfs_scan_log_blocks,
+		ret = workqueue_add(&wq, scan_log_rmaps,
 				ctx->mnt.fsgeom.agcount + 2, &sbx);
 		if (ret) {
-			sbx.moveon = false;
+			sbx.aborted = true;
 			str_liberror(ctx, ret, _("queueing logdev fsmap work"));
 			goto out;
 		}
 	}
 	for (agno = 0; agno < ctx->mnt.fsgeom.agcount; agno++) {
-		ret = workqueue_add(&wq, xfs_scan_ag_blocks, agno, &sbx);
+		ret = workqueue_add(&wq, scan_ag_rmaps, agno, &sbx);
 		if (ret) {
-			sbx.moveon = false;
+			sbx.aborted = true;
 			str_liberror(ctx, ret, _("queueing per-AG fsmap work"));
 			break;
 		}
@@ -232,10 +238,13 @@ xfs_scan_all_spacemaps(
 out:
 	ret = workqueue_terminate(&wq);
 	if (ret) {
-		sbx.moveon = false;
+		sbx.aborted = true;
 		str_liberror(ctx, ret, _("finishing fsmap work"));
 	}
 	workqueue_destroy(&wq);
 
-	return sbx.moveon;
+	if (!ret && sbx.aborted)
+		ret = -1;
+
+	return ret;
 }
diff --git a/scrub/spacemap.h b/scrub/spacemap.h
index 8f2f0a01..1291cf3c 100644
--- a/scrub/spacemap.h
+++ b/scrub/spacemap.h
@@ -6,12 +6,12 @@
 #ifndef XFS_SCRUB_SPACEMAP_H_
 #define XFS_SCRUB_SPACEMAP_H_
 
-typedef bool (*xfs_fsmap_iter_fn)(struct scrub_ctx *ctx, const char *descr,
+typedef int (*scrub_fsmap_iter_fn)(struct scrub_ctx *ctx,
 		struct fsmap *fsr, void *arg);
 
-bool xfs_iterate_fsmap(struct scrub_ctx *ctx, const char *descr,
-		struct fsmap *keys, xfs_fsmap_iter_fn fn, void *arg);
-bool xfs_scan_all_spacemaps(struct scrub_ctx *ctx, xfs_fsmap_iter_fn fn,
+int scrub_iterate_fsmap(struct scrub_ctx *ctx, struct fsmap *keys,
+		scrub_fsmap_iter_fn fn, void *arg);
+int scrub_scan_all_spacemaps(struct scrub_ctx *ctx, scrub_fsmap_iter_fn fn,
 		void *arg);
 
 #endif /* XFS_SCRUB_SPACEMAP_H_ */

