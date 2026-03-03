Return-Path: <linux-xfs+bounces-31667-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uOC6JEIppmk+LQAAu9opvQ
	(envelope-from <linux-xfs+bounces-31667-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Tue, 03 Mar 2026 01:20:18 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B7E91E710E
	for <lists+linux-xfs@lfdr.de>; Tue, 03 Mar 2026 01:20:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8CEEB3015D9E
	for <lists+linux-xfs@lfdr.de>; Tue,  3 Mar 2026 00:20:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88AC516DC28;
	Tue,  3 Mar 2026 00:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Camn06fm"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 668B3390991
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 00:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772497216; cv=none; b=IoHzrotbJPydvEs1r5kRPDhXGKgB5KgkQ3ar3BaR2SiXFNTVbI+1R+tYt2kgEUxdc/gXPHzTqzu2s+OtzGq4ZSo3s3cIOtiY2P/fC3mmY6+vrtotsqd/WCMWD0FbgTYPuQ84oSCUqvLYPxL3Tc0aR/LHQRnKBsG76mxo5iOBbfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772497216; c=relaxed/simple;
	bh=7yKUnmuRtM/IY3yXYDfjJ9HtPUKM1QeuDszBDFh1GPI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hL49nwhg0a+8K6P5tE13kERFprOUQl5Bjm1F/OmsW7+xv4VG90q6FXTYLlsLJlZzTraFF4/xQw2006ILjlQnJ1FAW86pYX0WuMLFyTI8Jg2pG4kSllppwpk9/Ot5Rtw8gZwjOjX8RK1GLHfzW9x2WZ2ph7mt61YAtfRCBfLqaLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Camn06fm; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4157DC19423;
	Tue,  3 Mar 2026 00:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772497216;
	bh=7yKUnmuRtM/IY3yXYDfjJ9HtPUKM1QeuDszBDFh1GPI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Camn06fmUPJe4ER1xjALWPQ0nhsxLtLjgiMO7DPl2F7Tribx49E2vBLXQ87eNSg2m
	 1Ya31CeEsMUbtygPmMLCMxxvT5EeCci3bdOjIpcmVCi/GZX5zdYyMqFitgGbyA1iiR
	 /h8aBJPsicpFN7rcs42rUSjEAUMeXWQXMOsU04IZ53pAgm7HzPu+bezA5N5QHM6ZOl
	 +jaO5s/mjfZHJHrVgkz65NxZe+xIfiC2bk8n2+KjP6UrVOB+6I4wWbzwvFkZmas3B9
	 6Zw/TOac/8fuFGWZFGsUqjupytS8x2EvRmm5eeEIqbmny/UQ96TpoAn2iUqb1of0/g
	 96PRJNkgEgA3Q==
Date: Mon, 02 Mar 2026 16:20:15 -0800
Subject: [PATCH 31/36] xfs: Refactoring the nagcount and delta calculation
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, hch@lst.de, nirjhar.roy.lists@gmail.com,
 linux-xfs@vger.kernel.org
Message-ID: <177249638348.457970.5654862938602819163.stgit@frogsfrogsfrogs>
In-Reply-To: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
References: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3B7E91E710E
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-31667-lists,linux-xfs=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.org,lst.de,gmail.com,vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djwong@kernel.org,linux-xfs@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-0.997];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	RCPT_COUNT_FIVE(0.00)[6];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lst.de:email,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

From: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>

Source kernel commit: a49b7ff63f98ba1c4503869c568c99ecffa478f2

Introduce xfs_growfs_compute_delta() to calculate the nagcount
and delta blocks and refactor the code from xfs_growfs_data_private().
No functional changes.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_ag.h |    3 +++
 libxfs/xfs_ag.c |   28 ++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)


diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index 1f24cfa2732172..3cd4790768ff91 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -331,6 +331,9 @@ struct aghdr_init_data {
 int xfs_ag_init_headers(struct xfs_mount *mp, struct aghdr_init_data *id);
 int xfs_ag_shrink_space(struct xfs_perag *pag, struct xfs_trans **tpp,
 			xfs_extlen_t delta);
+void
+xfs_growfs_compute_deltas(struct xfs_mount *mp, xfs_rfsblock_t nb,
+			int64_t *deltap, xfs_agnumber_t *nagcountp);
 int xfs_ag_extend_space(struct xfs_perag *pag, struct xfs_trans *tp,
 			xfs_extlen_t len);
 int xfs_ag_get_geometry(struct xfs_perag *pag, struct xfs_ag_geometry *ageo);
diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
index 5742d59a2659da..fd5f902b052435 100644
--- a/libxfs/xfs_ag.c
+++ b/libxfs/xfs_ag.c
@@ -870,6 +870,34 @@ xfs_ag_shrink_space(
 	return err2;
 }
 
+void
+xfs_growfs_compute_deltas(
+	struct xfs_mount	*mp,
+	xfs_rfsblock_t		nb,
+	int64_t			*deltap,
+	xfs_agnumber_t		*nagcountp)
+{
+	xfs_rfsblock_t	nb_div, nb_mod;
+	int64_t		delta;
+	xfs_agnumber_t	nagcount;
+
+	nb_div = nb;
+	nb_mod = do_div(nb_div, mp->m_sb.sb_agblocks);
+	if (nb_mod && nb_mod >= XFS_MIN_AG_BLOCKS)
+		nb_div++;
+	else if (nb_mod)
+		nb = nb_div * mp->m_sb.sb_agblocks;
+
+	if (nb_div > XFS_MAX_AGNUMBER + 1) {
+		nb_div = XFS_MAX_AGNUMBER + 1;
+		nb = nb_div * mp->m_sb.sb_agblocks;
+	}
+	nagcount = nb_div;
+	delta = nb - mp->m_sb.sb_dblocks;
+	*deltap = delta;
+	*nagcountp = nagcount;
+}
+
 /*
  * Extent the AG indicated by the @id by the length passed in
  */


