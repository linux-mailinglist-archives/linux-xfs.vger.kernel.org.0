Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70E78E0BF8
	for <lists+linux-xfs@lfdr.de>; Tue, 22 Oct 2019 20:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732630AbfJVSw3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 22 Oct 2019 14:52:29 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55676 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731740AbfJVSw2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 14:52:28 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIigrj091471;
        Tue, 22 Oct 2019 18:52:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=otJ62tl57YUwH56XCELuHYXKmHSoRlXkxl1VIXDXiOQ=;
 b=LNDjXRcdrStUKAVfd8s7cBWMufWEwg5SYpBjwSQGuU2rcWaRTofIjz5tGnixodeqYsUN
 ueatsIATKKuzt0GMJlMJHnCaS/Vkf7uk782qUDfNe54p37CiCE4tvIfo+ws9hq0ylvYb
 sicDuQk1+YFjFDOG36RS4WrSVkHxQgiSL2tnTOXfxhBMjY5++aX1a8WZOyq+pnTXwc0S
 OindIzs+p8PUl1LYNtyvhqnyzij/2eyW6+8pIjWKb92m3UL/JfQBMMIg/L/q3JJOtq+3
 uxg5mesrP5FISrUUPN+oXX10znqwAVSPygcy4clGN7zDpWL990tuC8pMw7pl+wvjK080 +g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2vqteprrtf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:52:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIhOTU125187;
        Tue, 22 Oct 2019 18:52:25 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2vsx23a00k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:52:25 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x9MIqOnI005533;
        Tue, 22 Oct 2019 18:52:24 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 11:52:24 -0700
Subject: [PATCH 18/18] xfs_scrub: remove moveon from main program
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 22 Oct 2019 11:52:22 -0700
Message-ID: <157177034195.1461658.13733200864081311796.stgit@magnolia>
In-Reply-To: <157177022106.1461658.18024534947316119946.stgit@magnolia>
References: <157177022106.1461658.18024534947316119946.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910220156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910220156
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Replace the moveon returns in xfs_scrub.c to e with a direct integer
error return.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/phase1.c    |    7 ----
 scrub/phase2.c    |   17 ---------
 scrub/phase3.c    |   17 ---------
 scrub/phase4.c    |   17 ---------
 scrub/phase5.c    |   15 ++++++--
 scrub/phase6.c    |   17 ---------
 scrub/phase7.c    |    7 ----
 scrub/xfs_scrub.c |   95 +++++++++++++++++++++++++----------------------------
 scrub/xfs_scrub.h |   33 +++++++++---------
 9 files changed, 73 insertions(+), 152 deletions(-)


diff --git a/scrub/phase1.c b/scrub/phase1.c
index 75ae3b00..e0382b04 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -206,10 +206,3 @@ _("Unable to find realtime device path."));
 	ctx->scrub_setup_succeeded = true;
 	return 0;
 }
-
-bool
-xfs_setup_fs(
-	struct scrub_ctx		*ctx)
-{
-	return phase1_func(ctx) == 0;
-}
diff --git a/scrub/phase2.c b/scrub/phase2.c
index 81b2b3dc..45e0d712 100644
--- a/scrub/phase2.c
+++ b/scrub/phase2.c
@@ -179,13 +179,6 @@ phase2_func(
 	return ret;
 }
 
-bool
-xfs_scan_metadata(
-	struct scrub_ctx	*ctx)
-{
-	return phase2_func(ctx) == 0;
-}
-
 /* Estimate how much work we're going to do. */
 int
 phase2_estimate(
@@ -199,13 +192,3 @@ phase2_estimate(
 	*rshift = 0;
 	return 0;
 }
-
-bool
-xfs_estimate_metadata_work(
-	struct scrub_ctx	*ctx,
-	uint64_t		*items,
-	unsigned int		*nr_threads,
-	int			*rshift)
-{
-	return phase2_estimate(ctx, items, nr_threads, rshift) == 0;
-}
diff --git a/scrub/phase3.c b/scrub/phase3.c
index eed8f46f..223f1caf 100644
--- a/scrub/phase3.c
+++ b/scrub/phase3.c
@@ -194,13 +194,6 @@ phase3_func(
 	return err;
 }
 
-bool
-xfs_scan_inodes(
-	struct scrub_ctx	*ctx)
-{
-	return phase3_func(ctx) == 0;
-}
-
 /* Estimate how much work we're going to do. */
 int
 phase3_estimate(
@@ -214,13 +207,3 @@ phase3_estimate(
 	*rshift = 0;
 	return 0;
 }
-
-bool
-xfs_estimate_inodes_work(
-	struct scrub_ctx	*ctx,
-	uint64_t		*items,
-	unsigned int		*nr_threads,
-	int			*rshift)
-{
-	return phase3_estimate(ctx, items, nr_threads, rshift) == 0;
-}
diff --git a/scrub/phase4.c b/scrub/phase4.c
index f9dcf9c8..1c1de906 100644
--- a/scrub/phase4.c
+++ b/scrub/phase4.c
@@ -126,13 +126,6 @@ phase4_func(
 	return repair_everything(ctx);
 }
 
-bool
-xfs_repair_fs(
-	struct scrub_ctx	*ctx)
-{
-	return phase4_func(ctx) == 0;
-}
-
 /* Estimate how much work we're going to do. */
 int
 phase4_estimate(
@@ -152,13 +145,3 @@ phase4_estimate(
 	*rshift = 0;
 	return 0;
 }
-
-bool
-xfs_estimate_repair_work(
-	struct scrub_ctx	*ctx,
-	uint64_t		*items,
-	unsigned int		*nr_threads,
-	int			*rshift)
-{
-	return phase4_estimate(ctx, items, nr_threads, rshift) == 0;
-}
diff --git a/scrub/phase5.c b/scrub/phase5.c
index 2641a7fb..540b840d 100644
--- a/scrub/phase5.c
+++ b/scrub/phase5.c
@@ -406,9 +406,16 @@ _("Filesystem has errors, skipping connectivity checks."));
 	return 0;
 }
 
-bool
-xfs_scan_connections(
-	struct scrub_ctx	*ctx)
+/* Estimate how much work we're going to do. */
+int
+phase5_estimate(
+	struct scrub_ctx	*ctx,
+	uint64_t		*items,
+	unsigned int		*nr_threads,
+	int			*rshift)
 {
-	return phase5_func(ctx) == 0;
+	*items = ctx->mnt_sv.f_files - ctx->mnt_sv.f_ffree;
+	*nr_threads = scrub_nproc(ctx);
+	*rshift = 0;
+	return 0;
 }
diff --git a/scrub/phase6.c b/scrub/phase6.c
index 2aa3fd10..6dbadcee 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -756,13 +756,6 @@ phase6_func(
 	return ret;
 }
 
-bool
-xfs_scan_blocks(
-	struct scrub_ctx		*ctx)
-{
-	return phase6_func(ctx) == 0;
-}
-
 /* Estimate how much work we're going to do. */
 int
 phase6_estimate(
@@ -793,13 +786,3 @@ phase6_estimate(
 	*rshift = 20;
 	return 0;
 }
-
-bool
-xfs_estimate_verify_work(
-	struct scrub_ctx	*ctx,
-	uint64_t		*items,
-	unsigned int		*nr_threads,
-	int			*rshift)
-{
-	return phase6_estimate(ctx, items, nr_threads, rshift) == 0;
-}
diff --git a/scrub/phase7.c b/scrub/phase7.c
index ff51c634..f25a8765 100644
--- a/scrub/phase7.c
+++ b/scrub/phase7.c
@@ -278,10 +278,3 @@ _("%.1f%s data counted; %.1f%s file data media verified.\n"),
 	ptvar_free(ptvar);
 	return error;
 }
-
-bool
-xfs_scan_summary(
-	struct scrub_ctx	*ctx)
-{
-	return phase7_func(ctx) == 0;
-}
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index 3751e5af..55645370 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -245,14 +245,14 @@ struct phase_rusage {
 #define REPAIR_DUMMY_FN		((void *)2)
 struct phase_ops {
 	char		*descr;
-	bool		(*fn)(struct scrub_ctx *);
-	bool		(*estimate_work)(struct scrub_ctx *, uint64_t *,
-					 unsigned int *, int *);
+	int		(*fn)(struct scrub_ctx *ctx);
+	int		(*estimate_work)(struct scrub_ctx *ctx, uint64_t *items,
+					 unsigned int *threads, int *rshift);
 	bool		must_run;
 };
 
 /* Start tracking resource usage for a phase. */
-static bool
+static int
 phase_start(
 	struct phase_rusage	*pi,
 	unsigned int		phase,
@@ -264,14 +264,14 @@ phase_start(
 	error = scrub_getrusage(&pi->ruse);
 	if (error) {
 		perror(_("getrusage"));
-		return false;
+		return error;
 	}
 	pi->brk_start = sbrk(0);
 
 	error = gettimeofday(&pi->time, NULL);
 	if (error) {
 		perror(_("gettimeofday"));
-		return false;
+		return error;
 	}
 
 	pi->descr = descr;
@@ -279,11 +279,11 @@ phase_start(
 		fprintf(stdout, _("Phase %u: %s\n"), phase, descr);
 		fflush(stdout);
 	}
-	return true;
+	return error;
 }
 
 /* Report usage stats. */
-static bool
+static int
 phase_end(
 	struct phase_rusage	*pi,
 	unsigned int		phase)
@@ -303,19 +303,19 @@ phase_end(
 	int			error;
 
 	if (!display_rusage)
-		return true;
+		return 0;
 
 	error = gettimeofday(&time_now, NULL);
 	if (error) {
 		perror(_("gettimeofday"));
-		return false;
+		return error;
 	}
 	dt = timeval_subtract(&time_now, &pi->time);
 
 	error = scrub_getrusage(&ruse_now);
 	if (error) {
 		perror(_("getrusage"));
-		return false;
+		return error;
 	}
 
 	if (phase)
@@ -366,7 +366,7 @@ _("%sI/O rate: %.1f%s/s in, %.1f%s/s out, %.1f%s/s tot\n"),
 	}
 	fflush(stdout);
 
-	return true;
+	return 0;
 }
 
 /* Run all the phases of the scrubber. */
@@ -379,37 +379,37 @@ run_scrub_phases(
 	{
 		{
 			.descr = _("Find filesystem geometry."),
-			.fn = xfs_setup_fs,
+			.fn = phase1_func,
 			.must_run = true,
 		},
 		{
 			.descr = _("Check internal metadata."),
-			.fn = xfs_scan_metadata,
-			.estimate_work = xfs_estimate_metadata_work,
+			.fn = phase2_func,
+			.estimate_work = phase2_estimate,
 		},
 		{
 			.descr = _("Scan all inodes."),
-			.fn = xfs_scan_inodes,
-			.estimate_work = xfs_estimate_inodes_work,
+			.fn = phase3_func,
+			.estimate_work = phase3_estimate,
 		},
 		{
 			.descr = _("Defer filesystem repairs."),
 			.fn = REPAIR_DUMMY_FN,
-			.estimate_work = xfs_estimate_repair_work,
+			.estimate_work = phase4_estimate,
 		},
 		{
 			.descr = _("Check directory tree."),
-			.fn = xfs_scan_connections,
-			.estimate_work = xfs_estimate_inodes_work,
+			.fn = phase5_func,
+			.estimate_work = phase5_estimate,
 		},
 		{
 			.descr = _("Verify data file integrity."),
 			.fn = DATASCAN_DUMMY_FN,
-			.estimate_work = xfs_estimate_verify_work,
+			.estimate_work = phase6_estimate,
 		},
 		{
 			.descr = _("Check summary counters."),
-			.fn = xfs_scan_summary,
+			.fn = phase7_func,
 			.must_run = true,
 		},
 		{
@@ -419,7 +419,6 @@ run_scrub_phases(
 	struct phase_rusage	pi;
 	struct phase_ops	*sp;
 	uint64_t		max_work;
-	bool			moveon = true;
 	unsigned int		debug_phase = 0;
 	unsigned int		phase;
 	int			rshift;
@@ -432,13 +431,13 @@ run_scrub_phases(
 	for (phase = 1, sp = phases; sp->fn; sp++, phase++) {
 		/* Turn on certain phases if user said to. */
 		if (sp->fn == DATASCAN_DUMMY_FN && scrub_data) {
-			sp->fn = xfs_scan_blocks;
+			sp->fn = phase6_func;
 			if (scrub_data > 1)
 				sp->descr = _("Verify disk integrity.");
 		} else if (sp->fn == REPAIR_DUMMY_FN &&
 			   ctx->mode == SCRUB_MODE_REPAIR) {
 			sp->descr = _("Repair filesystem.");
-			sp->fn = xfs_repair_fs;
+			sp->fn = phase4_func;
 			sp->must_run = true;
 		}
 
@@ -452,15 +451,15 @@ run_scrub_phases(
 			continue;
 
 		/* Run this phase. */
-		moveon = phase_start(&pi, phase, sp->descr);
-		if (!moveon)
+		ret = phase_start(&pi, phase, sp->descr);
+		if (ret)
 			break;
 		if (sp->estimate_work) {
 			unsigned int		work_threads;
 
-			moveon = sp->estimate_work(ctx, &max_work,
+			ret = sp->estimate_work(ctx, &max_work,
 					&work_threads, &rshift);
-			if (!moveon)
+			if (ret)
 				break;
 
 			/*
@@ -471,23 +470,19 @@ run_scrub_phases(
 			work_threads++;
 			ret = progress_init_phase(ctx, progress_fp, phase,
 					max_work, rshift, work_threads);
-			if (ret) {
-				moveon = false;
+			if (ret)
 				break;
-			}
-			moveon = descr_init_phase(ctx, work_threads) == 0;
+			ret = descr_init_phase(ctx, work_threads);
 		} else {
 			ret = progress_init_phase(ctx, NULL, phase, 0, 0, 0);
-			if (ret) {
-				moveon = false;
+			if (ret)
 				break;
-			}
-			moveon = descr_init_phase(ctx, 1) == 0;
+			ret = descr_init_phase(ctx, 1);
 		}
-		if (!moveon)
+		if (ret)
 			break;
-		moveon = sp->fn(ctx);
-		if (!moveon) {
+		ret = sp->fn(ctx);
+		if (ret) {
 			str_info(ctx, ctx->mntpoint,
 _("Scrub aborted after phase %d."),
 					phase);
@@ -495,17 +490,18 @@ _("Scrub aborted after phase %d."),
 		}
 		progress_end_phase();
 		descr_end_phase();
-		moveon = phase_end(&pi, phase);
-		if (!moveon)
+		ret = phase_end(&pi, phase);
+		if (ret)
 			break;
 
 		/* Too many errors? */
-		moveon = !xfs_scrub_excessive_errors(ctx);
-		if (!moveon)
+		if (xfs_scrub_excessive_errors(ctx)) {
+			ret = ECANCELED;
 			break;
+		}
 	}
 
-	return moveon;
+	return ret;
 }
 
 static void
@@ -598,7 +594,6 @@ main(
 	char			*mtab = NULL;
 	FILE			*progress_fp = NULL;
 	struct fs_path		*fsp;
-	bool			moveon = true;
 	int			c;
 	int			fd;
 	int			ret = SCRUB_RET_SUCCESS;
@@ -713,8 +708,8 @@ main(
 		is_service = true;
 
 	/* Initialize overall phase stats. */
-	moveon = phase_start(&all_pi, 0, NULL);
-	if (!moveon)
+	error = phase_start(&all_pi, 0, NULL);
+	if (error)
 		return SCRUB_RET_OPERROR;
 
 	/* Find the mount record for the passed-in argument. */
@@ -761,8 +756,8 @@ main(
 		ctx.mode = SCRUB_MODE_REPAIR;
 
 	/* Scrub a filesystem. */
-	moveon = run_scrub_phases(&ctx, progress_fp);
-	if (!moveon && ctx.runtime_errors == 0)
+	error = run_scrub_phases(&ctx, progress_fp);
+	if (error && ctx.runtime_errors == 0)
 		ctx.runtime_errors++;
 
 	/*
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index 5e7f94f5..36b5bbdc 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -89,24 +89,25 @@ struct scrub_ctx {
 /* Phase helper functions */
 void xfs_shutdown_fs(struct scrub_ctx *ctx);
 int scrub_cleanup(struct scrub_ctx *ctx);
-bool xfs_setup_fs(struct scrub_ctx *ctx);
-bool xfs_scan_metadata(struct scrub_ctx *ctx);
-bool xfs_scan_inodes(struct scrub_ctx *ctx);
-bool xfs_scan_connections(struct scrub_ctx *ctx);
-bool xfs_scan_blocks(struct scrub_ctx *ctx);
-bool xfs_scan_summary(struct scrub_ctx *ctx);
-bool xfs_repair_fs(struct scrub_ctx *ctx);
+int phase1_func(struct scrub_ctx *ctx);
+int phase2_func(struct scrub_ctx *ctx);
+int phase3_func(struct scrub_ctx *ctx);
+int phase4_func(struct scrub_ctx *ctx);
+int phase5_func(struct scrub_ctx *ctx);
+int phase6_func(struct scrub_ctx *ctx);
+int phase7_func(struct scrub_ctx *ctx);
 
 /* Progress estimator functions */
-uint64_t xfs_estimate_inodes(struct scrub_ctx *ctx);
 unsigned int scrub_estimate_ag_work(struct scrub_ctx *ctx);
-bool xfs_estimate_metadata_work(struct scrub_ctx *ctx, uint64_t *items,
-				unsigned int *nr_threads, int *rshift);
-bool xfs_estimate_inodes_work(struct scrub_ctx *ctx, uint64_t *items,
-			      unsigned int *nr_threads, int *rshift);
-bool xfs_estimate_repair_work(struct scrub_ctx *ctx, uint64_t *items,
-			      unsigned int *nr_threads, int *rshift);
-bool xfs_estimate_verify_work(struct scrub_ctx *ctx, uint64_t *items,
-			      unsigned int *nr_threads, int *rshift);
+int phase2_estimate(struct scrub_ctx *ctx, uint64_t *items,
+		    unsigned int *nr_threads, int *rshift);
+int phase3_estimate(struct scrub_ctx *ctx, uint64_t *items,
+		    unsigned int *nr_threads, int *rshift);
+int phase4_estimate(struct scrub_ctx *ctx, uint64_t *items,
+		    unsigned int *nr_threads, int *rshift);
+int phase5_estimate(struct scrub_ctx *ctx, uint64_t *items,
+		    unsigned int *nr_threads, int *rshift);
+int phase6_estimate(struct scrub_ctx *ctx, uint64_t *items,
+		    unsigned int *nr_threads, int *rshift);
 
 #endif /* XFS_SCRUB_XFS_SCRUB_H_ */

