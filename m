Return-Path: <linux-xfs+bounces-10062-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 10EF091EC36
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Jul 2024 03:02:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B891F1F2223E
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Jul 2024 01:02:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D8BA79CC;
	Tue,  2 Jul 2024 01:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m3QyehWE"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A0E7462
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719882172; cv=none; b=gFFxiu0W5myeVMVLwpNe+cwI2+zfSM+VjLWOk6oTO63tTvzZnbdU6YDV6GztS0gNvZU1EWmXOHj+wp1rthyUHnNhqd+5R0zptM7RrkXuQYDdZmjzIlo5bJMwwiunEdwjxYNvHgtEJn6ulcpORgTWKZLsYRz/ZcsEYzDjCPcfKfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719882172; c=relaxed/simple;
	bh=RvS2mnRF1v6vBgSDTyVADgbiosGhmbT8sHw1VVt5Guw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lDIhzSZ9MiNfeKsgL50PB5oaQ3ysAeS4h+7U7JcbZPd3GKVagiJdbxjyi4jVMwVIxVTzUqwoNLrXQDIRZiMfW196PEOABZcMJJKswi1nw9ts4ueGaPmGo6kbDN6HhbpfRNDWf3StRRdi99k0pMkA/xwUhtFckAgWkSEwSxkayUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m3QyehWE; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FAE6C116B1;
	Tue,  2 Jul 2024 01:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719882172;
	bh=RvS2mnRF1v6vBgSDTyVADgbiosGhmbT8sHw1VVt5Guw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=m3QyehWEjRnQh9640mhj4ULtkuVV0DtY6TdJ6THMKwLxQp26QeXF5uxNxf7/bHFSD
	 URKwfUj/lbX14J5RUYCwwUMxmm6ZBIOePRN+hr1Zfl0j0AWqSEInhtIxbOOD1cAUQu
	 S9Q1dtI8+whW8CnCAtuML6I4nrmmxa7h2Bpy3NI2AHxHEzJMpM6/tlQhUI/LiFlHHt
	 GGIcRyIO8JVcOfu0ZV20psBgPJIFIjYcL1U9k2DonPzQle95mdDVcRqvY85dCwK3R0
	 gS/KIY5zANdlX+kX+tnmcyunr2oAScaozV6YfOesfCRXw8DQWgZPwA1qUhS9NCGFLG
	 NNHZTpukBn/yQ==
Date: Mon, 01 Jul 2024 18:02:52 -0700
Subject: [PATCH 8/8] xfs_scrub: improve progress meter for phase 8 fstrimming
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171988118250.2007602.17910306565917298331.stgit@frogsfrogsfrogs>
In-Reply-To: <171988118118.2007602.12196117098152792537.stgit@frogsfrogsfrogs>
References: <171988118118.2007602.12196117098152792537.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Currently, progress reporting in phase 8 is awful, because we stall at
0% until jumping to 100%.  Since we're now performing sub-AG fstrim
calls to limit the latency impacts to the rest of the system, we might
as well limit the FSTRIM scan size so that we can report status updates
to the user more regularly.  Doing so also facilitates CPU usage control
during phase 8.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase8.c |   59 ++++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 40 insertions(+), 19 deletions(-)


diff --git a/scrub/phase8.c b/scrub/phase8.c
index e5f5619a80b5..ae6d965c75e1 100644
--- a/scrub/phase8.c
+++ b/scrub/phase8.c
@@ -45,6 +45,13 @@ fstrim_ok(
 	return true;
 }
 
+/*
+ * Limit the amount of fstrim scanning that we let the kernel do in a single
+ * call so that we can implement decent progress reporting and CPU resource
+ * control.  Pick a prime number of gigabytes for interest.
+ */
+#define FSTRIM_MAX_BYTES	(11ULL << 30)
+
 /* Trim a certain range of the filesystem. */
 static int
 fstrim_fsblocks(
@@ -56,18 +63,31 @@ fstrim_fsblocks(
 	uint64_t		len = cvt_off_fsb_to_b(&ctx->mnt, fsbcount);
 	int			error;
 
-	error = fstrim(ctx, start, len);
-	if (error == EOPNOTSUPP)
-		return 0;
-	if (error) {
-		char		descr[DESCR_BUFSZ];
-
-		snprintf(descr, sizeof(descr) - 1,
-				_("fstrim start 0x%llx len 0x%llx"),
-				(unsigned long long)start,
-				(unsigned long long)len);
-		str_liberror(ctx, error, descr);
-		return error;
+	while (len > 0) {
+		uint64_t	run;
+
+		run = min(len, FSTRIM_MAX_BYTES);
+
+		error = fstrim(ctx, start, run);
+		if (error == EOPNOTSUPP) {
+			/* Pretend we finished all the work. */
+			progress_add(len);
+			return 0;
+		}
+		if (error) {
+			char		descr[DESCR_BUFSZ];
+
+			snprintf(descr, sizeof(descr) - 1,
+					_("fstrim start 0x%llx run 0x%llx"),
+					(unsigned long long)start,
+					(unsigned long long)run);
+			str_liberror(ctx, error, descr);
+			return error;
+		}
+
+		progress_add(run);
+		len -= run;
+		start += run;
 	}
 
 	return 0;
@@ -91,13 +111,13 @@ fstrim_datadev(
 		 * report trim progress to userspace in units smaller than
 		 * entire AGs.
 		 */
+		progress_add(geo->blocksize);
 		fsbcount = min(geo->datablocks - (fsbno + 1), geo->agblocks - 1);
 		error = fstrim_fsblocks(ctx, fsbno + 1, fsbcount);
 		if (error)
 			return error;
 	}
 
-	progress_add(1);
 	return 0;
 }
 
@@ -120,12 +140,13 @@ phase8_estimate(
 	unsigned int		*nr_threads,
 	int			*rshift)
 {
-	*items = 0;
-
-	if (fstrim_ok(ctx))
-		*items = 1;
-
+	if (fstrim_ok(ctx)) {
+		*items = cvt_off_fsb_to_b(&ctx->mnt,
+				ctx->mnt.fsgeom.datablocks);
+	} else {
+		*items = 0;
+	}
 	*nr_threads = 1;
-	*rshift = 0;
+	*rshift = 30; /* GiB */
 	return 0;
 }


