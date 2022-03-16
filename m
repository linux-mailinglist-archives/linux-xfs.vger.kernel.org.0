Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1779E4DA640
	for <lists+linux-xfs@lfdr.de>; Wed, 16 Mar 2022 00:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352569AbiCOXZB (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 15 Mar 2022 19:25:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346865AbiCOXZA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Mar 2022 19:25:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0246AB12
        for <linux-xfs@vger.kernel.org>; Tue, 15 Mar 2022 16:23:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2698B818FB
        for <linux-xfs@vger.kernel.org>; Tue, 15 Mar 2022 23:23:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 590E5C340ED;
        Tue, 15 Mar 2022 23:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647386625;
        bh=aGhqUcvwEsIuRPEw2MOTaHsN1ZOO1MZDACAazGyfCnk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ZbghNW5nFnP5uI9OekxosLQ48llQnhJn5cxALmZxHXYjkwFBQWt5Hkt53jllLmCZa
         iqtby0lWUguucRc6LMQNWbA6ksBOYfYH9P9vM3ptZ0b3ONy1/zhNhLIHDl1xhh+vJx
         P3ZnyjqKBZNtZFMhOagDUlhcluz0UeQ2vjlma3ePNBc0wjEnbvdQe4+vYp6oFQVpDZ
         VZwL8xfzEeDx3ZK9vt61kHIDySt29aAks8zCfmKFOFGh9migjgMm6FEMYR/4MfgcD6
         hqiJs94jGyM46Bf5+QpR2ertG4cBlMWbEKsD0xpgEmxZ2VAwpc6yYq1nQGSaEjolxv
         9kD4AhXVfrqpw==
Subject: [PATCH 4/5] mkfs: stop allowing tiny filesystems
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Date:   Tue, 15 Mar 2022 16:23:44 -0700
Message-ID: <164738662491.3191861.15611882856331908607.stgit@magnolia>
In-Reply-To: <164738660248.3191861.2400129607830047696.stgit@magnolia>
References: <164738660248.3191861.2400129607830047696.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Refuse to format a filesystem that are "too small", because these
configurations are known to have performance and redundancy problems
that are not present on the volume sizes that XFS is best at handling.

Specifically, this means that we won't allow logs smaller than 64MB, we
won't allow single-AG filesystems, and we won't allow volumes smaller
than 300MB.  There are two exceptions: the first is an undocumented CLI
option that can be used for crafting debug filesystems.

The second exception is that if fstests is detected, because there are a
lot of fstests that use tiny filesystems to perform targeted regression
and functional testing in a controlled environment.  Fixing the ~40 or
so tests to run more slowly with larger filesystems isn't worth the risk
of breaking the tests.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/xfs_mkfs.c |   82 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 81 insertions(+), 1 deletion(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 84dbb799..239d529c 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -838,6 +838,7 @@ struct cli_params {
 	int64_t	logagno;
 	int	loginternal;
 	int	lsunit;
+	int	has_warranty;
 
 	/* parameters where 0 is not a valid value */
 	int64_t	agcount;
@@ -2463,6 +2464,68 @@ _("illegal CoW extent size hint %lld, must be less than %u.\n"),
 	}
 }
 
+/* Complain if this filesystem is not a supported configuration. */
+static void
+validate_warranty(
+	struct xfs_mount	*mp,
+	struct cli_params	*cli)
+{
+	/* Undocumented option to enable unsupported tiny filesystems. */
+	if (!cli->has_warranty) {
+		printf(
+ _("Filesystems formatted with --yes-i-know-what-i-am-doing are not supported!!\n"));
+		return;
+	}
+
+	/*
+	 * fstests has a large number of tests that create tiny filesystems to
+	 * perform specific regression and resource depletion tests in a
+	 * controlled environment.  Avoid breaking fstests by allowing
+	 * unsupported configurations if TEST_DIR, TEST_DEV, and QA_CHECK_FS
+	 * are all set.
+	 */
+	if (getenv("TEST_DIR") && getenv("TEST_DEV") && getenv("QA_CHECK_FS"))
+		return;
+
+	/*
+	 * We don't support filesystems smaller than 300MB anymore.  Tiny
+	 * filesystems have never been XFS' design target.  This limit has been
+	 * carefully calculated to prevent formatting with a log smaller than
+	 * the "realistic" size.
+	 *
+	 * If the realistic log size is 64MB, there are four AGs, and the log
+	 * AG should be at least 1/8 free after formatting, this gives us:
+	 *
+	 * 64MB * (8 / 7) * 4 = 293MB
+	 */
+	if (mp->m_sb.sb_dblocks < MEGABYTES(300, mp->m_sb.sb_blocklog)) {
+		fprintf(stderr,
+ _("Filesystem must be larger than 300MB.\n"));
+		usage();
+	}
+
+	/*
+	 * For best performance, we don't allow unrealistically small logs.
+	 * See the comment for XFS_MIN_REALISTIC_LOG_BLOCKS.
+	 */
+	if (mp->m_sb.sb_logblocks <
+			XFS_MIN_REALISTIC_LOG_BLOCKS(mp->m_sb.sb_blocklog)) {
+		fprintf(stderr,
+ _("Log size must be at least 64MB.\n"));
+		usage();
+	}
+
+	/*
+	 * Filesystems should not have fewer than two AGs, because we need to
+	 * have redundant superblocks.
+	 */
+	if (mp->m_sb.sb_agcount < 2) {
+		fprintf(stderr,
+ _("Filesystem must have redundant superblocks!\n"));
+		usage();
+	}
+}
+
 /*
  * Validate the configured stripe geometry, or is none is specified, pull
  * the configuration from the underlying device.
@@ -3892,9 +3955,21 @@ main(
 	struct cli_params	cli = {
 		.xi = &xi,
 		.loginternal = 1,
+		.has_warranty	= 1,
 	};
 	struct mkfs_params	cfg = {};
 
+	struct option		long_options[] = {
+	{
+		.name		= "yes-i-know-what-i-am-doing",
+		.has_arg	= no_argument,
+		.flag		= &cli.has_warranty,
+		.val		= 0,
+	},
+	{NULL, 0, NULL, 0 },
+	};
+	int			option_index = 0;
+
 	/* build time defaults */
 	struct mkfs_default_params	dft = {
 		.source = _("package build definitions"),
@@ -3953,8 +4028,11 @@ main(
 	memcpy(&cli.sb_feat, &dft.sb_feat, sizeof(cli.sb_feat));
 	memcpy(&cli.fsx, &dft.fsx, sizeof(cli.fsx));
 
-	while ((c = getopt(argc, argv, "b:c:d:i:l:L:m:n:KNp:qr:s:CfV")) != EOF) {
+	while ((c = getopt_long(argc, argv, "b:c:d:i:l:L:m:n:KNp:qr:s:CfV",
+					long_options, &option_index)) != EOF) {
 		switch (c) {
+		case 0:
+			break;
 		case 'C':
 		case 'f':
 			force_overwrite = 1;
@@ -4092,6 +4170,8 @@ main(
 	validate_extsize_hint(mp, &cli);
 	validate_cowextsize_hint(mp, &cli);
 
+	validate_warranty(mp, &cli);
+
 	/* Print the intended geometry of the fs. */
 	if (!quiet || dry_run) {
 		struct xfs_fsop_geom	geo;

