Return-Path: <linux-xfs+bounces-17262-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 312099F84A6
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Dec 2024 20:45:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EC1F71889C8B
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Dec 2024 19:45:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CC601B5EA4;
	Thu, 19 Dec 2024 19:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dLKQj/Ii"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F5E1B4F0D
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734637502; cv=none; b=OZkuUjWVKGPtkKdxlk3IqBjw7lJDZveBr3uhWrnUowcMY+zFvJNikrVPIieSAOD1W+mx/VVCqe3E64cZ/UU6gPmPx0XcqdDAWiL5+OXiFVm8k5AHd66+Shmelf65m8XhjDu6FQ5RF67TWOK9643XekWIFt9fUV4HbOSGUgq0yww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734637502; c=relaxed/simple;
	bh=zuZpHkqboysASAemrWVpwKx/+YapZ8jcK6MSaSAzO2o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QXn+uGXDog8njLCLcN8V2BnRvLCI6hLKbVUyJ2CdSFZKX/2hEDWRBM+nVCOMIC5eoVGHdGy0cKaJ0gHl0dFqulKuFPG4JkUhmJM3WrKOK5FpkUzkI44SVkVzc0O5p77lzBnrU9JP1T+jaqF5FRpwXZZx0RwxU6+brOE7VL9FxxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dLKQj/Ii; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84BBEC4CECE;
	Thu, 19 Dec 2024 19:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734637501;
	bh=zuZpHkqboysASAemrWVpwKx/+YapZ8jcK6MSaSAzO2o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dLKQj/Iiq4OlbfN28OJLHxi94yec6pLWYuA8N3IF7UYXh3nTeA2OY22fD4kCfTfmn
	 RuN52ObuNZMzylukexI0AzKXkDXDhWdEkU4q+/1GlV2N7XofcmgUR2pi+uJSKw69Xb
	 NLYRSJ/qlXSYgvYWSy+XSSEprPht1KKv6O+Kjk3kVDUHX6qax22B6xYlj9ioKeCmFf
	 6N69SdqObFaDGRWEac9dkvQjde5/iJp+0Y8d124+mMqpgdGU1whLmE8jGZryWLPDnJ
	 BfhHb5ANKAU8byZTVlKmB+pnb9ZqgA8E0IvObSqV8/0yyWyStBQ3o4OdvecpNLkQic
	 rxQOVhh/Qvbxw==
Date: Thu, 19 Dec 2024 11:45:01 -0800
Subject: [PATCH 3/3] xfs_mdrestore: restore rt group superblocks to realtime
 device
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463582943.1574879.4367794239821092582.stgit@frogsfrogsfrogs>
In-Reply-To: <173463582894.1574879.10113776916850781634.stgit@frogsfrogsfrogs>
References: <173463582894.1574879.10113776916850781634.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Support restoring realtime device metadata to the realtime device, if
the dumped filesystem had one.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 man/man8/xfs_mdrestore.8  |   10 ++++++++++
 mdrestore/xfs_mdrestore.c |   47 ++++++++++++++++++++++++++++++++++++---------
 2 files changed, 48 insertions(+), 9 deletions(-)


diff --git a/man/man8/xfs_mdrestore.8 b/man/man8/xfs_mdrestore.8
index f60e7b56ebf0d1..6f6e14e96c6a5c 100644
--- a/man/man8/xfs_mdrestore.8
+++ b/man/man8/xfs_mdrestore.8
@@ -8,6 +8,9 @@ .SH SYNOPSIS
 ] [
 .B \-l
 .I logdev
+] [
+.B \-r
+.I rtdev
 ]
 .I source
 .I target
@@ -17,6 +20,9 @@ .SH SYNOPSIS
 [
 .B \-l
 .I logdev
+] [
+.B \-r
+.I rtdev
 ]
 .I source
 .br
@@ -61,6 +67,10 @@ .SH OPTIONS
 In such a scenario, the user has to provide a device to which the log device
 contents from the metadump file are copied.
 .TP
+.BI \-r " rtdev"
+Restore realtime device metadata to this device.
+This is only required for a metadump in v2 format.
+.TP
 .B \-V
 Prints the version number and exits.
 .SH DIAGNOSTICS
diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index c5584fec68813e..d5014981b15a68 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -28,7 +28,8 @@ struct mdrestore_ops {
 	void (*show_info)(union mdrestore_headers *header, const char *md_file);
 	void (*restore)(union mdrestore_headers *header, FILE *md_fp,
 			const struct mdrestore_dev *ddev,
-			const struct mdrestore_dev *logdev);
+			const struct mdrestore_dev *logdev,
+			const struct mdrestore_dev *rtdev);
 };
 
 static struct mdrestore {
@@ -37,6 +38,7 @@ static struct mdrestore {
 	bool			show_info;
 	bool			progress_since_warning;
 	bool			external_log;
+	bool			realtime_data;
 } mdrestore;
 
 static void
@@ -212,7 +214,8 @@ restore_v1(
 	union mdrestore_headers		*h,
 	FILE				*md_fp,
 	const struct mdrestore_dev	*ddev,
-	const struct mdrestore_dev	*logdev)
+	const struct mdrestore_dev	*logdev,
+	const struct mdrestore_dev	*rtdev)
 {
 	struct xfs_metablock	*metablock;	/* header + index + blocks */
 	__be64			*block_index;
@@ -336,8 +339,9 @@ read_header_v2(
 	if (!mdrestore.external_log && (compat & XFS_MD2_COMPAT_EXTERNALLOG))
 		fatal("External Log device is required\n");
 
-	if (h->v2.xmh_incompat_flags & cpu_to_be32(XFS_MD2_INCOMPAT_RTDEVICE))
-		fatal("Realtime device not yet supported\n");
+	if ((h->v2.xmh_incompat_flags & cpu_to_be32(XFS_MD2_INCOMPAT_RTDEVICE)) &&
+	    !mdrestore.realtime_data)
+		fatal("Realtime device is required\n");
 }
 
 static void
@@ -346,14 +350,17 @@ show_info_v2(
 	const char		*md_file)
 {
 	uint32_t		compat_flags;
+	uint32_t		incompat_flags;
 
 	compat_flags = be32_to_cpu(h->v2.xmh_compat_flags);
+	incompat_flags = be32_to_cpu(h->v2.xmh_incompat_flags);
 
-	printf("%s: %sobfuscated, %s log, external log contents are %sdumped, %s metadata blocks,\n",
+	printf("%s: %sobfuscated, %s log, external log contents are %sdumped, rt device contents are %sdumped, %s metadata blocks,\n",
 		md_file,
 		compat_flags & XFS_MD2_COMPAT_OBFUSCATED ? "":"not ",
 		compat_flags & XFS_MD2_COMPAT_DIRTYLOG ? "dirty":"clean",
 		compat_flags & XFS_MD2_COMPAT_EXTERNALLOG ? "":"not ",
+		incompat_flags & XFS_MD2_INCOMPAT_RTDEVICE ? "":"not ",
 		compat_flags & XFS_MD2_COMPAT_FULLBLOCKS ? "full":"zeroed");
 }
 
@@ -390,7 +397,8 @@ restore_v2(
 	union mdrestore_headers		*h,
 	FILE				*md_fp,
 	const struct mdrestore_dev	*ddev,
-	const struct mdrestore_dev	*logdev)
+	const struct mdrestore_dev	*logdev,
+	const struct mdrestore_dev	*rtdev)
 {
 	struct xfs_sb		sb;
 	struct xfs_meta_extent	xme;
@@ -431,6 +439,11 @@ restore_v2(
 		verify_device_size(logdev, sb.sb_logblocks, sb.sb_blocksize);
 	}
 
+	if (sb.sb_rblocks > 0) {
+		ASSERT(mdrestore.realtime_data == true);
+		verify_device_size(rtdev, sb.sb_rblocks, sb.sb_blocksize);
+	}
+
 	if (pwrite(ddev->fd, block_buffer, len, 0) < 0)
 		fatal("error writing primary superblock: %s\n",
 			strerror(errno));
@@ -459,6 +472,10 @@ restore_v2(
 			device = "log";
 			fd = logdev->fd;
 			break;
+		case XME_ADDR_RT_DEVICE:
+			device = "rt";
+			fd = rtdev->fd;
+			break;
 		default:
 			fatal("Invalid device found in metadump\n");
 			break;
@@ -488,7 +505,7 @@ static struct mdrestore_ops mdrestore_ops_v2 = {
 static void
 usage(void)
 {
-	fprintf(stderr, "Usage: %s [-V] [-g] [-i] [-l logdev] source target\n",
+	fprintf(stderr, "Usage: %s [-V] [-g] [-i] [-l logdev] [-r rtdev] source target\n",
 		progname);
 	exit(1);
 }
@@ -501,18 +518,21 @@ main(
 	union mdrestore_headers	headers;
 	DEFINE_MDRESTORE_DEV(ddev);
 	DEFINE_MDRESTORE_DEV(logdev);
+	DEFINE_MDRESTORE_DEV(rtdev);
 	FILE			*src_f;
 	char			*logdev_path = NULL;
+	char			*rtdev_path = NULL;
 	int			c;
 
 	mdrestore.show_progress = false;
 	mdrestore.show_info = false;
 	mdrestore.progress_since_warning = false;
 	mdrestore.external_log = false;
+	mdrestore.realtime_data = false;
 
 	progname = basename(argv[0]);
 
-	while ((c = getopt(argc, argv, "gil:V")) != EOF) {
+	while ((c = getopt(argc, argv, "gil:r:V")) != EOF) {
 		switch (c) {
 			case 'g':
 				mdrestore.show_progress = true;
@@ -524,6 +544,10 @@ main(
 				logdev_path = optarg;
 				mdrestore.external_log = true;
 				break;
+			case 'r':
+				rtdev_path = optarg;
+				mdrestore.realtime_data = true;
+				break;
 			case 'V':
 				printf("%s version %s\n", progname, VERSION);
 				exit(0);
@@ -592,10 +616,15 @@ main(
 	if (mdrestore.external_log)
 		open_device(&logdev, logdev_path);
 
-	mdrestore.mdrops->restore(&headers, src_f, &ddev, &logdev);
+	/* check and open realtime device */
+	if (mdrestore.realtime_data)
+		open_device(&rtdev, rtdev_path);
+
+	mdrestore.mdrops->restore(&headers, src_f, &ddev, &logdev, &rtdev);
 
 	close_device(&ddev);
 	close_device(&logdev);
+	close_device(&rtdev);
 
 	if (src_f != stdin)
 		fclose(src_f);


