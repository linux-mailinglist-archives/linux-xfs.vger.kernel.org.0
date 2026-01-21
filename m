Return-Path: <linux-xfs+bounces-29993-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MIDPNEB1cGktYAAAu9opvQ
	(envelope-from <linux-xfs+bounces-29993-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 07:42:08 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FD6252353
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 07:42:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 6139E7228C2
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 06:39:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 139BD425CCB;
	Wed, 21 Jan 2026 06:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lf7XuFi0"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E001E407560
	for <linux-xfs@vger.kernel.org>; Wed, 21 Jan 2026 06:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768977572; cv=none; b=hHvJil8/nXGYCbbkC/vuusQvnjPXh4WW20iETtAM4fjr/sX9OVUIsoowCbBOzcHV+HDLLmbz+9EYkY14qyL0BR/GVP6w6EuSpkCnR4nafdgva5DaHUkPOEFHXgAu5GsWDW2rcS+JsqqoSdWuZjIKXpDOW8+FGYv1voERU6URZRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768977572; c=relaxed/simple;
	bh=RamkGgNGR4Eh3WUtTLfOmInwVTVZ73CmGTs2VCkC2aQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uXGPsUh/K6dWMbwKWs3hyIFYk6gziwY2OQXXOY/D2ad18UUnJKe8aqhHVGbbtf+pkDvn1eTzPGuuh++TC3VJ+dGExmF8G3UEt8wwPinpRGL5SwQzqO6TIWl8BPyBuLvn0cGNtGyQD0cDVN+Q3Qw+otdhp3HNlKTJg0LvNXa1h2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lf7XuFi0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C613C16AAE;
	Wed, 21 Jan 2026 06:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768977571;
	bh=RamkGgNGR4Eh3WUtTLfOmInwVTVZ73CmGTs2VCkC2aQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Lf7XuFi0KCSNmRiGIaX2j3m7u7l6X914X4w0lbBhuIZS7r4FLwoXDYfkTsls4WotL
	 utiFmZ8VAjZ+5jIMDDiZWAipiejYrsJ5fl31NLyo9zXswBx9Y01pmbX0sDQcS7BdSo
	 qpmcCGnsWKSnFu32NWFMPDkfEOKyz38l4eR6IjSQQmEXJRljU1zTdbdPyyHHeAzC0d
	 wnskxssKjhVYW4DNW2k1HnG9DyAJ6R7x1GuaqQXMbgj920IJRRpz0tQLHryGAuEuQd
	 mF8afPSOcsE1gwFvo9kiGBI6eYNqwfQ8FWMV7z85gZn2uqgigUTl+7bbAe9LqSpbHX
	 IkR753uwpFSkw==
Date: Tue, 20 Jan 2026 22:39:31 -0800
Subject: [PATCH 1/3] xfs: reduce xfs_attr_try_sf_addname parameters
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176897695951.202851.14154735292129291258.stgit@frogsfrogsfrogs>
In-Reply-To: <176897695913.202851.14051578860604932000.stgit@frogsfrogsfrogs>
References: <176897695913.202851.14051578860604932000.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[kernel.org,quarantine];
	TAGGED_FROM(0.00)[bounces-29993-lists,linux-xfs=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djwong@kernel.org,linux-xfs@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	TO_DN_NONE(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: 7FD6252353
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: Darrick J. Wong <djwong@kernel.org>

The dp parameter to this function is an alias of args->dp, so remove it
for clarity before we go adding new callers.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 8c04acd30d489c..c500fb6672f583 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -351,16 +351,14 @@ xfs_attr_set_resv(
  */
 STATIC int
 xfs_attr_try_sf_addname(
-	struct xfs_inode	*dp,
 	struct xfs_da_args	*args)
 {
-
 	int			error;
 
 	/*
 	 * Build initial attribute list (if required).
 	 */
-	if (dp->i_af.if_format == XFS_DINODE_FMT_EXTENTS)
+	if (args->dp->i_af.if_format == XFS_DINODE_FMT_EXTENTS)
 		xfs_attr_shortform_create(args);
 
 	error = xfs_attr_shortform_addname(args);
@@ -372,9 +370,9 @@ xfs_attr_try_sf_addname(
 	 * NOTE: this is also the error path (EEXIST, etc).
 	 */
 	if (!error)
-		xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
+		xfs_trans_ichgtime(args->trans, args->dp, XFS_ICHGTIME_CHG);
 
-	if (xfs_has_wsync(dp->i_mount))
+	if (xfs_has_wsync(args->dp->i_mount))
 		xfs_trans_set_sync(args->trans);
 
 	return error;
@@ -385,10 +383,9 @@ xfs_attr_sf_addname(
 	struct xfs_attr_intent		*attr)
 {
 	struct xfs_da_args		*args = attr->xattri_da_args;
-	struct xfs_inode		*dp = args->dp;
 	int				error = 0;
 
-	error = xfs_attr_try_sf_addname(dp, args);
+	error = xfs_attr_try_sf_addname(args);
 	if (error != -ENOSPC) {
 		ASSERT(!error || error == -EEXIST);
 		attr->xattri_dela_state = XFS_DAS_DONE;


