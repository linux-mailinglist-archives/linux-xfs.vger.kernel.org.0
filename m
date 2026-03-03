Return-Path: <linux-xfs+bounces-31670-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kI+9CXYppmk+LQAAu9opvQ
	(envelope-from <linux-xfs+bounces-31670-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Tue, 03 Mar 2026 01:21:10 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 27E351E7141
	for <lists+linux-xfs@lfdr.de>; Tue, 03 Mar 2026 01:21:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 38D9C30080A6
	for <lists+linux-xfs@lfdr.de>; Tue,  3 Mar 2026 00:21:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC9085474F;
	Tue,  3 Mar 2026 00:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eI1btB4W"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9988C390991
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 00:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772497263; cv=none; b=MJxXR2nNQaqOw025OWAiN71WMkfKdSwx+Cq+bzOkENciD8yf/CKJOBRKgTEG2nl2OGaABlihmymGjWPa80flRqRtgYOtr11lKB1Wl6XzeVQi/tncxqVK0o+OxrE2rBn+VRnVVo1NdMnJk1xyl3XpY+Oqt5mHg32vp6whUfDRhRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772497263; c=relaxed/simple;
	bh=fDWuJ93+zfmNGO7umEHtDSQfBNFARQZHU6QcPQ0q8OY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=porMZcE4fYKYLM3Wcn1O2syrwAJDNUJDBonvRWMFdESqPUDoJnnTUoR5ClC0tlgiijTrqj+EB7sUqDyOOS1R19TY3VzAizjjbEDmo2d8Ty9KYdvEmbK1rEiKr5XCmN3ZjcanaMmBaJSo3mrH3wVR4S5wLPXQ5It/bS1ajRfCCBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eI1btB4W; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A861C19423;
	Tue,  3 Mar 2026 00:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772497263;
	bh=fDWuJ93+zfmNGO7umEHtDSQfBNFARQZHU6QcPQ0q8OY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eI1btB4Wwlh6eZwT1LD6gPDjIt7pP36/hOBsi6LbV1yRN4VrF28Py9dwP1YU4Od71
	 vqXZ+Dw3DLUJDaX82RXCjpYbxaTy1P4Mpsr8tkzh6ejFd+gj6RlBGu/8CmYgKs5nbo
	 eE/g2QecVth0I8yV6wzBrJf4XkYngqjbfGmT5OEVScNBLzRI6yBxFt768bnlyBuz0B
	 s2dxaQpWoFSVOA/AQoF6ncvh79RMmC5T4EK3cn3RT1EsLRsd3LmY6aloOPCKMOKkzu
	 o9zKIpoqsoIBomo+aRsLg8jhj3pKj7+jX4xkPpj4ljT20cQkLRWOllha8+G/fQsf2U
	 OoH5ByIOAXQaw==
Date: Mon, 02 Mar 2026 16:21:02 -0800
Subject: [PATCH 34/36] xfs: Add a comment in xfs_log_sb()
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, hch@lst.de, nirjhar.roy.lists@gmail.com,
 linux-xfs@vger.kernel.org
Message-ID: <177249638403.457970.14548064570115566557.stgit@frogsfrogsfrogs>
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
X-Rspamd-Queue-Id: 27E351E7141
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-31670-lists,linux-xfs=lfdr.de];
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
	NEURAL_HAM(-0.00)[-0.998];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	RCPT_COUNT_FIVE(0.00)[6];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lst.de:email,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

From: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>

Source kernel commit: ac1d977096a17d56c55bd7f90be48e81ac4cec3f

Add a comment explaining why the sb_frextents are updated outside the
if (xfs_has_lazycount(mp) check even though it is a lazycounter.
RT groups are supported only in v5 filesystems which always have
lazycounter enabled - so putting it inside the if(xfs_has_lazycount(mp)
check is redundant.

Suggested-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_sb.c |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/libxfs/xfs_sb.c b/libxfs/xfs_sb.c
index b29077dcd0aed7..7a1d85b86e59ea 100644
--- a/libxfs/xfs_sb.c
+++ b/libxfs/xfs_sb.c
@@ -1345,6 +1345,9 @@ xfs_log_sb(
 	 * feature was introduced.  This counter can go negative due to the way
 	 * we handle nearly-lockless reservations, so we must use the _positive
 	 * variant here to avoid writing out nonsense frextents.
+	 *
+	 * RT groups are only supported on v5 file systems, which always
+	 * have lazy SB counters.
 	 */
 	if (xfs_has_rtgroups(mp) && !xfs_has_zoned(mp)) {
 		mp->m_sb.sb_frextents =


