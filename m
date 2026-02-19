Return-Path: <linux-xfs+bounces-31139-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aIk3IqGhl2nc3AIAu9opvQ
	(envelope-from <linux-xfs+bounces-31139-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Fri, 20 Feb 2026 00:49:53 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D3F97163AFF
	for <lists+linux-xfs@lfdr.de>; Fri, 20 Feb 2026 00:49:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A16C730789CB
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 23:45:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5452B32D438;
	Thu, 19 Feb 2026 23:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JkdYqo7h"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E6F27B4F7
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 23:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771544751; cv=none; b=WS/j14++RguSw37OxoG0qY+ioJ1ap8Ju8VxYsUL85IWKg1uuNRbtVpGe13mjuu7s9Fbc46X7ZYAHolUUBjeXqJKV5VB6RONz6sSoy3UeaIRb0q+A3IbBUbYBgKoUhkEp1r2gV1lOEcQ+2X7lGl3RcJfIq1mHiBKABYRJ6L/v8Lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771544751; c=relaxed/simple;
	bh=FUNak+McDHOBzOF/kWSuHykp31CCwgvluwfmyvgudAE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XAeTmKjM2pNq4s6cjyoV34QkDYDyIfciow8JzKPHrzhlQkKpMySvab/HVD1UDAmJ/FBybMThIteP1ii/lAwrpL9d8TVN0P6gy11ii/MrWQfnIsF6iaG4ZVo/QvgiJ3K4zDavCHraCpQTsiukzGLxhFxQWJ1+JsWvz5cACr6zz6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JkdYqo7h; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F7BEC4CEF7;
	Thu, 19 Feb 2026 23:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771544751;
	bh=FUNak+McDHOBzOF/kWSuHykp31CCwgvluwfmyvgudAE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=JkdYqo7hC3/J56fRiJNt7JyS8C+99k+2v8D/CS9w1MBOLoeFMCvNkQuAZSMufJAS4
	 6RObeRx/Lve8mek8mKXrKhOhqDn2vrMlp0rge+wz0Yvl5gVydKoW//HWHkDu2N0VVT
	 eadUAUkG45KF5hp1UgILNTTeC7JVsp7/ENdFoBfKOyltVGhOFSCX2g62d/c2ZSPUdT
	 CmtnI465f3VKrQFoMU9rDQ7k0W7OlLO4mDGRhEBBJhiBVVD5lQ6BWqE5SjcBs11/UQ
	 UZRaTp6JaKrOCARxIivT8A1MTO4HzN7hABIrddbecr6y/IGX983aQN91siuZW5119h
	 XqzUi3yq0paeQ==
Date: Thu, 19 Feb 2026 15:45:50 -0800
Subject: [PATCH 09/12] xfs: validate that zoned RT devices are zone aligned
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177154456890.1285810.11146600955522147726.stgit@frogsfrogsfrogs>
In-Reply-To: <177154456673.1285810.13156117508727707417.stgit@frogsfrogsfrogs>
References: <177154456673.1285810.13156117508727707417.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-31139-lists,linux-xfs=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djwong@kernel.org,linux-xfs@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5]
X-Rspamd-Queue-Id: D3F97163AFF
X-Rspamd-Action: no action

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 982d2616a2906113e433fdc0cfcc122f8d1bb60a

Garbage collection assumes all zones contain the full amount of blocks.
Mkfs already ensures this happens, but make the kernel check it as well
to avoid getting into trouble due to fuzzers or mkfs bugs.

Fixes: 2167eaabe2fa ("xfs: define the zoned on-disk format")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_sb.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)


diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index dd14c3ab3b59e3..3e2d3c6da19631 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -299,6 +299,21 @@ xfs_validate_rt_geometry(
 	    sbp->sb_rbmblocks != xfs_expected_rbmblocks(sbp))
 		return false;
 
+	if (xfs_sb_is_v5(sbp) &&
+	    (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_ZONED)) {
+		uint32_t		mod;
+
+		/*
+		 * Zoned RT devices must be aligned to the RT group size,
+		 * because garbage collection assumes that all zones have the
+		 * same size to avoid insane complexity if that weren't the
+		 * case.
+		 */
+		div_u64_rem(sbp->sb_rextents, sbp->sb_rgextents, &mod);
+		if (mod)
+			return false;
+	}
+
 	return true;
 }
 


