Return-Path: <linux-xfs+bounces-17504-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 57ED79FB71E
	for <lists+linux-xfs@lfdr.de>; Mon, 23 Dec 2024 23:24:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D5FF11633DB
	for <lists+linux-xfs@lfdr.de>; Mon, 23 Dec 2024 22:24:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 004D5192B86;
	Mon, 23 Dec 2024 22:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UFeWd9q+"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3457188596
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 22:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734992657; cv=none; b=MfPe8YHsi5z3fWLF5VteYOFmADL407TLRjJBV2TjWkljvdDZpam+GPFQpohho/dFYZ/eeaooF1bb9JreGkiNP2Hi63P5++UPzDQ8hs/2dik0XPqLXYAmIy0ThltV8XDsdwYg3taG6JcdPqfQkoGh9RCJWvQUei4+YMty+M7NZMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734992657; c=relaxed/simple;
	bh=xr3Bsg1iR1m4ja8V0V9J2OxHhEpkC0+LUcvHbNO/8Uo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HlD9sWMisPSOBPYhrfubV+roLWTP2uXm4aLd//6znhaVTj3MaQwbbfybKeD7IUTmkBPK5R3yjESDDx8KwC1prYSJKweyuoNuOsIjVUO66PelOdfkCtpBHRTT6vKMI04jKgFCeEczd3AGSLLMyY2CUJ7RCNuteYJTivnmv+sOPUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UFeWd9q+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A266C4CED3;
	Mon, 23 Dec 2024 22:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734992657;
	bh=xr3Bsg1iR1m4ja8V0V9J2OxHhEpkC0+LUcvHbNO/8Uo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=UFeWd9q+2PDmojusDHkEOLZbFjXh30D+K9AgioiNy7omNc3wgPwkzNAKtYiJxee6P
	 l11avA48l/4FLlC5np0GO7uWSjxTdiYzJXR+ckIH9URz2pj45C5R9998qeDehJrsLb
	 4dNsRPia2Oe6FK94Lh2AayqlsfWPR8tdxggWCC5cKbF+anAbIF/wKcXGiOxy8/jWm9
	 esDJlQQaFcl0Xl/j3/TPk4M31mZ/upKxSUQCPNHV85+wCHnWuz77y4bd2RLN+1AjwJ
	 rVWLUgqXZ/o9toCgb3dvukLaR5KuXKxg5bUTr0N+DraOXUkMjJqkulWbep4brVfWP4
	 lPLeynZrVTfnA==
Date: Mon, 23 Dec 2024 14:24:17 -0800
Subject: [PATCH 48/51] xfs_scrub: trim realtime volumes too
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498944538.2297565.780848807747771972.stgit@frogsfrogsfrogs>
In-Reply-To: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
References: <173498943717.2297565.4022811207967161638.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

On the kernel side, the XFS realtime groups patchset added support for
FITRIM of the realtime volume.  This support doesn't actually require
there to be any realtime groups, so teach scrub to run through the whole
region.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 scrub/phase8.c |   32 +++++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)


diff --git a/scrub/phase8.c b/scrub/phase8.c
index 1c88460c33962b..adb177ecdafbeb 100644
--- a/scrub/phase8.c
+++ b/scrub/phase8.c
@@ -59,7 +59,8 @@ fstrim_fsblocks(
 	struct scrub_ctx	*ctx,
 	uint64_t		start_fsb,
 	uint64_t		fsbcount,
-	uint64_t		minlen_fsb)
+	uint64_t		minlen_fsb,
+	bool			ignore_einval)
 {
 	uint64_t		start = cvt_off_fsb_to_b(&ctx->mnt, start_fsb);
 	uint64_t		len = cvt_off_fsb_to_b(&ctx->mnt, fsbcount);
@@ -72,6 +73,8 @@ fstrim_fsblocks(
 		run = min(len, FSTRIM_MAX_BYTES);
 
 		error = fstrim(ctx, start, run, minlen);
+		if (error == EINVAL && ignore_einval)
+			error = EOPNOTSUPP;
 		if (error == EOPNOTSUPP) {
 			/* Pretend we finished all the work. */
 			progress_add(len);
@@ -193,7 +196,8 @@ fstrim_datadev(
 		 */
 		progress_add(geo->blocksize);
 		fsbcount = min(geo->datablocks - fsbno, geo->agblocks);
-		error = fstrim_fsblocks(ctx, fsbno, fsbcount, minlen_fsb);
+		error = fstrim_fsblocks(ctx, fsbno, fsbcount, minlen_fsb,
+				false);
 		if (error)
 			return error;
 	}
@@ -201,15 +205,35 @@ fstrim_datadev(
 	return 0;
 }
 
+/* Trim the realtime device. */
+static int
+fstrim_rtdev(
+	struct scrub_ctx	*ctx)
+{
+	struct xfs_fsop_geom	*geo = &ctx->mnt.fsgeom;
+
+	/*
+	 * The fstrim ioctl pretends that the realtime volume is in the address
+	 * space immediately after the data volume.  Ignore EINVAL if someone
+	 * tries to run us on an older kernel.
+	 */
+	return fstrim_fsblocks(ctx, geo->datablocks, geo->rtblocks, 0, true);
+}
+
 /* Trim the filesystem, if desired. */
 int
 phase8_func(
 	struct scrub_ctx	*ctx)
 {
+	int			error;
+
 	if (!fstrim_ok(ctx))
 		return 0;
 
-	return fstrim_datadev(ctx);
+	error = fstrim_datadev(ctx);
+	if (error)
+		return error;
+	return fstrim_rtdev(ctx);
 }
 
 /* Estimate how much work we're going to do. */
@@ -223,6 +247,8 @@ phase8_estimate(
 	if (fstrim_ok(ctx)) {
 		*items = cvt_off_fsb_to_b(&ctx->mnt,
 				ctx->mnt.fsgeom.datablocks);
+		*items += cvt_off_fsb_to_b(&ctx->mnt,
+				ctx->mnt.fsgeom.rtblocks);
 	} else {
 		*items = 0;
 	}


