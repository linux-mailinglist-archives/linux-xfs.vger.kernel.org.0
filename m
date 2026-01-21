Return-Path: <linux-xfs+bounces-30017-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ELBDMw94cGktYAAAu9opvQ
	(envelope-from <linux-xfs+bounces-30017-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 07:54:07 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 618EC52698
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 07:54:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 6E5FC7437E3
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 06:47:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 947AF44BCB7;
	Wed, 21 Jan 2026 06:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ReEJ0//X"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E8D144CF46
	for <linux-xfs@vger.kernel.org>; Wed, 21 Jan 2026 06:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768977941; cv=none; b=qW8jYG4kE1ku8SNNTGymX0ocoASbcRCddCazsjZNZuDew8vuDKrDVZyczROPqi8yh7s1YiifXslXtqP0kY1P/Bq57jRvytiEZLd7DLaS+0/N20tsDMIjfIvBXgybcthDRM/l4LU8sG6d+x2NAY7jIahAfU6Bx5jzKNH5gofJ4Yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768977941; c=relaxed/simple;
	bh=byVk9bF0UYd8FLKk2nKSJlhni2hickD32oSVRDjZ10w=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=MkXgCy+/ByTNb1pKe85edL2FSSiEo5YJk2uudx41zSsu4WFTwbGdZ2uoqq1kpttkPP0Gnw7/dxg2HEn0dR4zxSQfItXTqUR27bnn3a7bHLKgYU+mkPl3VXwfzS+fAIbG+h0wY8TU0EaXdbs/vv4xYv8IlKY8lNhhNafEuW3BqvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ReEJ0//X; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42AEBC116D0;
	Wed, 21 Jan 2026 06:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768977941;
	bh=byVk9bF0UYd8FLKk2nKSJlhni2hickD32oSVRDjZ10w=;
	h=Date:From:To:Cc:Subject:From;
	b=ReEJ0//X8z0kcGV/a0NH+5LmIVkwh6MWmt13a+vSSLHPiic3DfIGTyYnc5FFaX1eF
	 9QlcSTdKDGKcNxHW4gJaGNqH/KoGpQ95KMoac0PwLUpMGaFGt1j/AfMT0y6Sr4L+pW
	 QGAb8QHhv9U374Wblq5oc6hPZBSUFoKd/YYWf56pvaRLls1IIBEUtW9JQX9i4K5eP+
	 jj1oZGiC5F2CHPmHtYOf/SZtwmTMGAn0/h9GSt+DJKwaaSixAQdrb99hM2eIejQNRp
	 Pp+sxj206qGPKBT1X1CkazsX3o55pBV0W65NuiTuTe2M5TBrJdXzdU/spAcYhAwTWI
	 whUDcedEr1HQQ==
Date: Tue, 20 Jan 2026 22:45:40 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: promote metadata directories and large block support
Message-ID: <20260121064540.GA5945@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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
	TAGGED_FROM(0.00)[bounces-30017-lists,linux-xfs=lfdr.de];
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
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: 618EC52698
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: Darrick J. Wong <djwong@kernel.org>

Large block support was merged upstream in 6.12 (Dec 2024) and metadata
directories was merged in 6.13 (Jan 2025).  We've not received any
serious complaints about the ondisk formats of these two features in the
past year, so let's remove the experimental warnings.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_message.h |    2 --
 fs/xfs/xfs_message.c |    8 --------
 fs/xfs/xfs_super.c   |    4 ----
 3 files changed, 14 deletions(-)

diff --git a/fs/xfs/xfs_message.h b/fs/xfs/xfs_message.h
index d68e72379f9dd5..49b0ef40d299de 100644
--- a/fs/xfs/xfs_message.h
+++ b/fs/xfs/xfs_message.h
@@ -93,8 +93,6 @@ void xfs_buf_alert_ratelimited(struct xfs_buf *bp, const char *rlmsg,
 enum xfs_experimental_feat {
 	XFS_EXPERIMENTAL_SHRINK,
 	XFS_EXPERIMENTAL_LARP,
-	XFS_EXPERIMENTAL_LBS,
-	XFS_EXPERIMENTAL_METADIR,
 	XFS_EXPERIMENTAL_ZONED,
 
 	XFS_EXPERIMENTAL_MAX,
diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
index 19aba2c3d52544..5ac0ac3d4f39f9 100644
--- a/fs/xfs/xfs_message.c
+++ b/fs/xfs/xfs_message.c
@@ -149,14 +149,6 @@ xfs_warn_experimental(
 			.opstate	= XFS_OPSTATE_WARNED_LARP,
 			.name		= "logged extended attributes",
 		},
-		[XFS_EXPERIMENTAL_LBS] = {
-			.opstate	= XFS_OPSTATE_WARNED_LBS,
-			.name		= "large block size",
-		},
-		[XFS_EXPERIMENTAL_METADIR] = {
-			.opstate	= XFS_OPSTATE_WARNED_METADIR,
-			.name		= "metadata directory tree",
-		},
 		[XFS_EXPERIMENTAL_ZONED] = {
 			.opstate	= XFS_OPSTATE_WARNED_ZONED,
 			.name		= "zoned RT device",
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index bc71aa9dcee8d6..1f432d6645898e 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1835,8 +1835,6 @@ xfs_fs_fill_super(
 			error = -ENOSYS;
 			goto out_free_sb;
 		}
-
-		xfs_warn_experimental(mp, XFS_EXPERIMENTAL_LBS);
 	}
 
 	/* Ensure this filesystem fits in the page cache limits */
@@ -1922,8 +1920,6 @@ xfs_fs_fill_super(
 			goto out_filestream_unmount;
 		}
 		xfs_warn_experimental(mp, XFS_EXPERIMENTAL_ZONED);
-	} else if (xfs_has_metadir(mp)) {
-		xfs_warn_experimental(mp, XFS_EXPERIMENTAL_METADIR);
 	}
 
 	if (xfs_has_reflink(mp)) {

