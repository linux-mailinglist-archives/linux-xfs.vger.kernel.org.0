Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9564711D22
	for <lists+linux-xfs@lfdr.de>; Fri, 26 May 2023 03:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234388AbjEZBwb (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 May 2023 21:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbjEZBwa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:52:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58619189
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:52:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E893B64C45
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:52:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 527D2C433D2;
        Fri, 26 May 2023 01:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685065947;
        bh=RpHMKSqSW/JeqZRst8T+eJDOyW4X3z5YKa/msbv/h0o=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=R1gUZHZvcxnh26ox1hxtjiATRhRr7mdUhL9l+pRGRRyCFIwE767xPrQAeH1do0shn
         f0zjuiYvAMkXO0564rpwq8aVaPvtUBf5MsGTohbd2uc6nPMCG5cQqYKdw967WNVt8Z
         ILYjX4KKLCSTjwfpy8tysMWOgbOh/3WPPvk0bmpAoS/C6tLpC/Qd//A1I3/Naqrhrb
         uHtIxQkiUjr0HpIqsQravxP71NMhMx7Tqxh7WUgxnVuRQeehvgA4mxriDtN5LXlHhc
         smmhNDoSH0PYjcjymgTj9QNyEeEtCaug1k/KByirTjiI8BQVfDyTH8Qa5ABik5/e9n
         4PDpKnomxv8sA==
Date:   Thu, 25 May 2023 18:52:26 -0700
Subject: [PATCH 7/7] xfs_scrub: tune fstrim minlen parameter based on free
 space histograms
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506073559.3745433.7362514369666970378.stgit@frogsfrogsfrogs>
In-Reply-To: <168506073466.3745433.1072164718437572976.stgit@frogsfrogsfrogs>
References: <168506073466.3745433.1072164718437572976.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Currently, phase 8 runs very slowly on filesystems with a lot of small
free space extents.  To reduce the amount of time spent on fstrim
activities during phase 8, we want to balance estimated runtime against
completeness of the trim.  In short, the goal is to reduce runtime by
avoiding small trim requests.

At the start of phase 8, a CDF is computed in decreasing order of extent
length from the histogram buckets created during the fsmap scan in phase
7.  A point corresponding to the fstrim percentage target is chosen from
the CDF and mapped back to a histogram bucket, and free space extents
smaller than that amount are ommitted from fstrim.

On my aging /home filesystem, the free space histogram reported by
xfs_spaceman looks like this:

   from      to extents    blocks    pct blkcdf extcdf
      1       1  121953    121953   0.04 100.00 100.00
      2       3  124741    299694   0.09  99.96  81.16
      4       7  113492    593763   0.18  99.87  61.89
      8      15  109215   1179524   0.36  99.69  44.36
     16      31   76972   1695455   0.52  99.33  27.48
     32      63   48655   2219667   0.68  98.82  15.59
     64     127   31398   2876898   0.88  98.14   8.08
    128     255    8014   1447920   0.44  97.27   3.23
    256     511    4142   1501758   0.46  96.82   1.99
    512    1023    2433   1768732   0.54  96.37   1.35
   1024    2047    1795   2648460   0.81  95.83   0.97
   2048    4095    1429   4206103   1.28  95.02   0.69
   4096    8191    1045   6162111   1.88  93.74   0.47
   8192   16383     791   9242745   2.81  91.87   0.31
  16384   32767     473  10883977   3.31  89.06   0.19
  32768   65535     272  12385566   3.77  85.74   0.12
  65536  131071     192  18098739   5.51  81.98   0.07
 131072  262143     108  20675199   6.29  76.47   0.04
 262144  524287      80  29061285   8.84  70.18   0.03
 524288 1048575      39  29002829   8.83  61.33   0.02
1048576 2097151      25  36824985  11.21  52.51   0.01
2097152 4194303      32 101727192  30.95  41.30   0.01
4194304 8388607       7  34007410  10.35  10.35   0.00

From this table, we see that free space extents that are 16 blocks or
longer constitute 99.3% of the free space in the filesystem but only
27.5% of the extents.  If we set the fstrim minlen parameter to 16
blocks, that means that we can trim over 99% of the space in one third
of the time it would take to trim everything.

Add a new -o fstrim_pct= option to xfs_scrub just in case there are
users out there who want a different percentage.  For example, accepting
a 95% trim would net us a speed increase of nearly two orders of
magnitude, ignoring system call overhead.  Setting it to 100% will trim
everything, just like fstrim(8).

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/histogram.c  |    2 +
 libfrog/histogram.h  |    1 +
 man/man8/xfs_scrub.8 |   31 +++++++++++++++++++++
 scrub/phase8.c       |   75 +++++++++++++++++++++++++++++++++++++++++++++++---
 scrub/vfs.c          |    4 ++-
 scrub/vfs.h          |    2 +
 scrub/xfs_scrub.c    |   70 +++++++++++++++++++++++++++++++++++++++++++++--
 scrub/xfs_scrub.h    |   12 ++++++++
 8 files changed, 187 insertions(+), 10 deletions(-)


diff --git a/libfrog/histogram.c b/libfrog/histogram.c
index 1f6c490b66e..6fece03a378 100644
--- a/libfrog/histogram.c
+++ b/libfrog/histogram.c
@@ -109,7 +109,7 @@ hist_free(
  * of small extents, e.g. 98% of the free space extents are larger than 31
  * blocks.
  */
-static int
+int
 hist_cdf(
 	const struct histogram	*hs,
 	struct histogram	*cdf)
diff --git a/libfrog/histogram.h b/libfrog/histogram.h
index 0cda747bc98..76b3dd41890 100644
--- a/libfrog/histogram.h
+++ b/libfrog/histogram.h
@@ -39,6 +39,7 @@ void hist_add(struct histogram *hs, long long len);
 void hist_init(struct histogram *hs);
 void hist_prepare(struct histogram *hs, long long maxlen);
 void hist_free(struct histogram *hs);
+int hist_cdf(const struct histogram *hs, struct histogram *cdf);
 void hist_print(const struct histogram *hs);
 void hist_summarize(const struct histogram *hs);
 
diff --git a/man/man8/xfs_scrub.8 b/man/man8/xfs_scrub.8
index e881ae76acb..eb0235af9e0 100644
--- a/man/man8/xfs_scrub.8
+++ b/man/man8/xfs_scrub.8
@@ -85,6 +85,37 @@ Search this file for mounted filesystems instead of /etc/mtab.
 .B \-n
 Only check filesystem metadata.
 Do not repair or optimize anything.
+.HP
+.B \-o
+.I subopt\c
+[\c
+.B =\c
+.IR value ]
+.br
+Override what the program might conclude about the filesystem
+if left to its own devices.
+.IP
+The
+.IR subopt ions
+supported are:
+.RS 1.0i
+.TP
+.BI fstrim_pct= percentage
+To constrain the amount of time spent on fstrim activities during phase 8,
+this program tries to balance estimated runtime against completeness of the
+trim.
+In short, the program avoids small trim requests to save time.
+
+During phase 7, a log-scale histogram of free space extents is constructed.
+At the start of phase 8, a CDF is computed in decreasing order of extent
+length from the histogram buckets.
+A point corresponding to the fstrim percentage target is chosen from the CDF
+and mapped back to a histogram bucket.
+Free space extents at least as long as the bucket size are trimmed.
+Smaller extents are ignored.
+
+By default, the percentage threshold is 99%.
+.RE
 .TP
 .BI \-T
 Print timing and memory usage information for each phase.
diff --git a/scrub/phase8.c b/scrub/phase8.c
index 5d2a57c83f9..1a2462476c7 100644
--- a/scrub/phase8.c
+++ b/scrub/phase8.c
@@ -11,6 +11,7 @@
 #include "list.h"
 #include "libfrog/paths.h"
 #include "libfrog/workqueue.h"
+#include "libfrog/histogram.h"
 #include "xfs_scrub.h"
 #include "common.h"
 #include "progress.h"
@@ -57,10 +58,12 @@ static int
 fstrim_fsblocks(
 	struct scrub_ctx	*ctx,
 	uint64_t		start_fsb,
-	uint64_t		fsbcount)
+	uint64_t		fsbcount,
+	uint64_t		minlen_fsb)
 {
 	uint64_t		start = cvt_off_fsb_to_b(&ctx->mnt, start_fsb);
 	uint64_t		len = cvt_off_fsb_to_b(&ctx->mnt, fsbcount);
+	uint64_t		minlen = cvt_off_fsb_to_b(&ctx->mnt, minlen_fsb);
 	int			error;
 
 	while (len > 0) {
@@ -68,7 +71,7 @@ fstrim_fsblocks(
 
 		run = min(len, FSTRIM_MAX_BYTES);
 
-		error = fstrim(ctx, start, run);
+		error = fstrim(ctx, start, run, minlen);
 		if (error == EOPNOTSUPP) {
 			/* Pretend we finished all the work. */
 			progress_add(len);
@@ -78,9 +81,10 @@ fstrim_fsblocks(
 			char		descr[DESCR_BUFSZ];
 
 			snprintf(descr, sizeof(descr) - 1,
-					_("fstrim start 0x%llx run 0x%llx"),
+					_("fstrim start 0x%llx run 0x%llx minlen 0x%llx"),
 					(unsigned long long)start,
-					(unsigned long long)run);
+					(unsigned long long)run,
+					(unsigned long long)minlen);
 			str_liberror(ctx, error, descr);
 			return error;
 		}
@@ -93,6 +97,64 @@ fstrim_fsblocks(
 	return 0;
 }
 
+/* Compute a suitable minlen parameter for fstrim. */
+static uint64_t
+fstrim_compute_minlen(
+	const struct scrub_ctx	*ctx,
+	const struct histogram	*freesp_hist)
+{
+	struct histogram	cdf;
+	uint64_t		ret = 0;
+	double			blk_threshold = 0;
+	unsigned int		i;
+	unsigned int		ag_max_usable;
+	int			error;
+
+	/*
+	 * The kernel will reject a minlen that's larger than m_ag_max_usable.
+	 * We can't calculate or query that value directly, so we guesstimate
+	 * that it's 95% of the AG size.
+	 */
+	ag_max_usable = ctx->mnt.fsgeom.agblocks * 95 / 100;
+
+	if (freesp_hist->totexts == 0)
+		goto out;
+
+	if (debug > 1)
+		hist_print(freesp_hist);
+
+	/* Insufficient samples to make a meaningful histogram */
+	if (freesp_hist->totexts < freesp_hist->nr_buckets * 10)
+		goto out;
+
+	hist_init(&cdf);
+	error = hist_cdf(freesp_hist, &cdf);
+	if (error)
+		goto out_free;
+
+	blk_threshold = freesp_hist->totblocks * ctx->fstrim_block_pct;
+	for (i = 1; i < freesp_hist->nr_buckets; i++) {
+		if (cdf.buckets[i].blocks < blk_threshold) {
+			ret = freesp_hist->buckets[i - 1].low;
+			break;
+		}
+	}
+
+out_free:
+	hist_free(&cdf);
+out:
+	if (debug > 1)
+		printf(_("fstrim minlen %lld threshold %lld ag_max_usable %u\n"),
+				(unsigned long long)ret,
+				(unsigned long long)blk_threshold,
+				ag_max_usable);
+	if (ret > ag_max_usable)
+		ret = ag_max_usable;
+	if (ret == 1)
+		ret = 0;
+	return ret;
+}
+
 /* Trim each AG on the data device. */
 static int
 fstrim_datadev(
@@ -100,8 +162,11 @@ fstrim_datadev(
 {
 	struct xfs_fsop_geom	*geo = &ctx->mnt.fsgeom;
 	uint64_t		fsbno;
+	uint64_t		minlen_fsb;
 	int			error;
 
+	minlen_fsb = fstrim_compute_minlen(ctx, &ctx->datadev_hist);
+
 	for (fsbno = 0; fsbno < geo->datablocks; fsbno += geo->agblocks) {
 		uint64_t	fsbcount;
 
@@ -112,7 +177,7 @@ fstrim_datadev(
 		 */
 		progress_add(geo->blocksize);
 		fsbcount = min(geo->datablocks - fsbno + 1, geo->agblocks);
-		error = fstrim_fsblocks(ctx, fsbno + 1, fsbcount);
+		error = fstrim_fsblocks(ctx, fsbno + 1, fsbcount, minlen_fsb);
 		if (error)
 			return error;
 	}
diff --git a/scrub/vfs.c b/scrub/vfs.c
index c47db5890a5..69b4a22d211 100644
--- a/scrub/vfs.c
+++ b/scrub/vfs.c
@@ -300,11 +300,13 @@ int
 fstrim(
 	struct scrub_ctx	*ctx,
 	uint64_t		start,
-	uint64_t		len)
+	uint64_t		len,
+	uint64_t		minlen)
 {
 	struct fstrim_range	range = {
 		.start		= start,
 		.len		= len,
+		.minlen		= minlen,
 	};
 
 	if (ioctl(ctx->mnt.fd, FITRIM, &range) == 0)
diff --git a/scrub/vfs.h b/scrub/vfs.h
index db222d9c7ee..88b052f335f 100644
--- a/scrub/vfs.h
+++ b/scrub/vfs.h
@@ -24,6 +24,6 @@ typedef int (*scan_fs_tree_dirent_fn)(struct scrub_ctx *, const char *,
 int scan_fs_tree(struct scrub_ctx *ctx, scan_fs_tree_dir_fn dir_fn,
 		scan_fs_tree_dirent_fn dirent_fn, void *arg);
 
-int fstrim(struct scrub_ctx *ctx, uint64_t start, uint64_t len);
+int fstrim(struct scrub_ctx *ctx, uint64_t start, uint64_t len, uint64_t minlen);
 
 #endif /* XFS_SCRUB_VFS_H_ */
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index e59e478a674..04b423c7211 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -614,12 +614,75 @@ report_outcome(
 # define XFS_SCRUB_HAVE_UNICODE	"-"
 #endif
 
+/*
+ * -o: user-supplied override options
+ */
+enum o_opt_nums {
+	FSTRIM_PCT = 0,
+	O_MAX_OPTS,
+};
+
+static char *o_opts[] = {
+	[FSTRIM_PCT]		= "fstrim_pct",
+	[O_MAX_OPTS]		= NULL,
+};
+
+static void
+parse_o_opts(
+	struct scrub_ctx	*ctx,
+	char			*p)
+{
+	double			dval;
+
+	while (*p != '\0')  {
+		char		*val;
+		char		*endp;
+
+		switch (getsubopt(&p, o_opts, &val))  {
+		case FSTRIM_PCT:
+			if (!val) {
+				fprintf(stderr,
+ _("-o fstrim_pct requires a parameter\n"));
+				usage();
+			}
+
+			errno = 0;
+			dval = strtod(val, &endp);
+
+			if (*endp) {
+				fprintf(stderr,
+ _("-o fstrim_pct must be a floating point number\n"));
+				usage();
+			}
+			if (errno) {
+				fprintf(stderr,
+ _("-o fstrim_pct: %s\n"),
+						strerror(errno));
+				usage();
+			}
+			if (dval <= 0 || dval > 100) {
+				fprintf(stderr,
+ _("-o fstrim_pct must be larger than 0 and less than 100\n"));
+				usage();
+			}
+
+			ctx->fstrim_block_pct = dval / 100.0;
+			break;
+		default:
+			usage();
+			break;
+		}
+	}
+}
+
 int
 main(
 	int			argc,
 	char			**argv)
 {
-	struct scrub_ctx	ctx = {0};
+	struct scrub_ctx	ctx = {
+		.fstrim_block_pct = FSTRIM_BLOCK_PCT_DEFAULT,
+	};
 	struct phase_rusage	all_pi;
 	char			*mtab = NULL;
 	FILE			*progress_fp = NULL;
@@ -649,7 +712,7 @@ main(
 	pthread_mutex_init(&ctx.lock, NULL);
 	ctx.mode = SCRUB_MODE_REPAIR;
 	ctx.error_action = ERRORS_CONTINUE;
-	while ((c = getopt(argc, argv, "a:bC:de:km:nTvxV")) != EOF) {
+	while ((c = getopt(argc, argv, "a:bC:de:km:no:TvxV")) != EOF) {
 		switch (c) {
 		case 'a':
 			ctx.max_errors = cvt_u64(optarg, 10);
@@ -699,6 +762,9 @@ main(
 		case 'n':
 			ctx.mode = SCRUB_MODE_DRY_RUN;
 			break;
+		case 'o':
+			parse_o_opts(&ctx, optarg);
+			break;
 		case 'T':
 			display_rusage = true;
 			break;
diff --git a/scrub/xfs_scrub.h b/scrub/xfs_scrub.h
index b001a074a8f..dc45e486719 100644
--- a/scrub/xfs_scrub.h
+++ b/scrub/xfs_scrub.h
@@ -89,8 +89,20 @@ struct scrub_ctx {
 
 	/* Free space histograms, in fsb */
 	struct histogram	datadev_hist;
+
+	/*
+	 * Pick the largest value for fstrim minlen such that we trim at least
+	 * this much space per volume.
+	 */
+	double			fstrim_block_pct;
 };
 
+/*
+ * Trim only enough free space extents (in order of decreasing length) to
+ * ensure that this percentage of the free space is trimmed.
+ */
+#define FSTRIM_BLOCK_PCT_DEFAULT	(99.0 / 100.0)
+
 /* Phase helper functions */
 void xfs_shutdown_fs(struct scrub_ctx *ctx);
 int scrub_cleanup(struct scrub_ctx *ctx);

