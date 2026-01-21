Return-Path: <linux-xfs+bounces-29992-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EL91CxB1cGktYAAAu9opvQ
	(envelope-from <linux-xfs+bounces-29992-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 07:41:20 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id CA49B52319
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 07:41:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id EE29B4C9354
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 06:39:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54BFA43E481;
	Wed, 21 Jan 2026 06:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NYUGuCdJ"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27DFB4266B1;
	Wed, 21 Jan 2026 06:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768977556; cv=none; b=ipkLbIzXzsV4p3j7jAfad3DDUIKcJtaJbZPfjVnl/epptIKSM+g9j//5O0U/IwQfDuA6ImN/lB0R4kmzwiqmHBCVXxi8KEPaCX2QLZEeSSu47+GiHT/WHXlhLDBcED+SC/c2XyTWwDoWPBQdK+en10EJ9zd0AYJ7PTt+1FJ6EHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768977556; c=relaxed/simple;
	bh=qM4Dy+WX5SpLvVt3PkrNfzh2qSLNkaWSj8Dzb4ACTN4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CBErmoaYbKs1vS8UReCMUwzWy/uAYMZqpLjrKI6FIMLBoX2HN0Oo8NLir3hMRitoSW1/CXcn1iiW5xI/he5Vs3eDLUNtscIVtbzliLMDrj3IAkIFvtl7vHVOciuO3aLHAH+AwI9AKXDVTSCWrqHnJfTpui8STaPE152ksna+wcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NYUGuCdJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE917C116D0;
	Wed, 21 Jan 2026 06:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768977555;
	bh=qM4Dy+WX5SpLvVt3PkrNfzh2qSLNkaWSj8Dzb4ACTN4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NYUGuCdJIMaRtilPdp+XrEFI8BN2go+hiUba2J1NTA+zI8rYim8kDP9HmrilmKsKj
	 vzpYOGc884NkwMfmEv1VpuuLkdTh+kg6tkKtSptUt78ysesGtGFGLDlwjSWbts+a0m
	 hSdVR6q8scYIzgd1mkTPXlISJOEXhI8AknvQhNbaLWu/lnA7rSf5GMdgAnQafFuXiq
	 lzKVvsgboETwXdLbgh5A0/CpVP5ss4ZP+Ju4EBqsJlQ0erg3vPsyMkZfCDaqU+OzcN
	 Rh0cfhc7e1GavqGQKgX1xO1W0Ai9MMSjYCdO6RNtF+jP9qlmiREcFlSDnNHWU0PBXP
	 UVv1p0kyO9WHA==
Date: Tue, 20 Jan 2026 22:39:15 -0800
Subject: [PATCH 6/6] xfs: fix remote xattr valuelblk check
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <176897695685.202569.16435015345442663590.stgit@frogsfrogsfrogs>
In-Reply-To: <176897695523.202569.10735226881884087217.stgit@frogsfrogsfrogs>
References: <176897695523.202569.10735226881884087217.stgit@frogsfrogsfrogs>
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
	TAGGED_FROM(0.00)[bounces-29992-lists,linux-xfs=lfdr.de];
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
	RCPT_COUNT_THREE(0.00)[4];
	TO_DN_NONE(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	DBL_BLOCKED_OPENRESOLVER(0.00)[ams.mirrors.kernel.org:rdns,ams.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: CA49B52319
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: Darrick J. Wong <djwong@kernel.org>

In debugging other problems with generic/753, it turns out that it's
possible for the system go to down in the middle of a remote xattr set
operation such that the leaf block entry is marked incomplete and
valueblk is set to zero.  Make this no longer a failure.

Cc: <stable@vger.kernel.org> # v4.15
Fixes: 13791d3b833428 ("xfs: scrub extended attribute leaf space")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/attr.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index ef299be01de5ea..a0878fdbcf3866 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -338,7 +338,10 @@ xchk_xattr_entry(
 		rentry = xfs_attr3_leaf_name_remote(leaf, idx);
 		namesize = xfs_attr_leaf_entsize_remote(rentry->namelen);
 		name_end = (char *)rentry + namesize;
-		if (rentry->namelen == 0 || rentry->valueblk == 0)
+		if (rentry->namelen == 0)
+			xchk_da_set_corrupt(ds, level);
+		if (rentry->valueblk == 0 &&
+		    !(ent->flags & XFS_ATTR_INCOMPLETE))
 			xchk_da_set_corrupt(ds, level);
 	}
 	if (name_end > buf_end)


