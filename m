Return-Path: <linux-xfs+bounces-30000-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wK6QBaV1cGktYAAAu9opvQ
	(envelope-from <linux-xfs+bounces-30000-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 07:43:49 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A8CA523E2
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 07:43:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id EE3F27094DD
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 06:41:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C8B44279E1;
	Wed, 21 Jan 2026 06:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="if01dR4a"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03AED421A17;
	Wed, 21 Jan 2026 06:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768977671; cv=none; b=SaJ6f8iH4h9gYPsS+RW6xJZG7bAWObkg+YCTXtjfsEhsjSQgCVMLkHh5qfD4mY8KxK9o4kW3ViS3gBjMRztRmlLgw173QhBD3Cc5hpYKujUGFDT+Llc7uM9aMSF2/R8LTmF1YtYzjHe1jYYSCl0PuttLKtjwmZtIrRX608GOKQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768977671; c=relaxed/simple;
	bh=WCvy2J/5Yd+yxRCyIPIvWSJ5p2TjLbLiYQapWfLRGcM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=N8eKxH57l79YYVfF6xSseotuMIiAzaZU7g5soIYnL6GYEhhK0zGHDz1dkWLk+9uapOLdOy4qFXzSR/sEtVCC7IgZjQBWaCCV2hGrh52B5vBYiGdN7WoNJmSH3YvIAuR23JAOTsi04vDN/GHLhTNQDW82vTvUbwVcDQ1AgMqYe7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=if01dR4a; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3A8BC116D0;
	Wed, 21 Jan 2026 06:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768977670;
	bh=WCvy2J/5Yd+yxRCyIPIvWSJ5p2TjLbLiYQapWfLRGcM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=if01dR4a36lhGw4bK3J9lMqAUb0JqKpnwU4SqNT/p1+Qjjxm7LQoB++WgbEunEYb2
	 IhkkvxXz1WZ9AU1GCRlbPh3HSbw/FYNBg0/SldmyNLCjnJNXEIrU7CN5devt/E/UuU
	 7fIMm7pRwUQIcJaWn3zKWMe3DJuC0MSDC6cy0L0ABGAtW/Yk1dCtSOpQ4OdbOdZtXL
	 msQp0iha+ntVizwRaTAfhCXm23TaU7zQxw2Q15H3L9A+BgtgOFiyFtO0IoUr1quMWE
	 s/BANk29cqlN6i53tfAtE0zQIKlNnMTlvZJqryFi9FTs63kS00tZLFg495Hb1+ivLr
	 CKLsLgWp6RTgQ==
Date: Tue, 20 Jan 2026 22:41:10 -0800
Subject: [PATCH 4/4] xfs: fix UAF in xchk_btree_check_block_owner
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: r772577952@gmail.com, stable@vger.kernel.org, r772577952@gmail.com,
 hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <176897723630.207608.15659392786155037540.stgit@frogsfrogsfrogs>
In-Reply-To: <176897723519.207608.4983293162799232099.stgit@frogsfrogsfrogs>
References: <176897723519.207608.4983293162799232099.stgit@frogsfrogsfrogs>
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
	DMARC_POLICY_ALLOW(0.00)[kernel.org,quarantine];
	DKIM_TRACE(0.00)[kernel.org:+];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,lst.de];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-30000-lists,linux-xfs=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djwong@kernel.org,linux-xfs@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	RCPT_COUNT_SEVEN(0.00)[7];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: 6A8CA523E2
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: Darrick J. Wong <djwong@kernel.org>

We cannot dereference bs->cur when trying to determine if bs->cur
aliases bs->sc->sa.{bno,rmap}_cur after the latter has been freed.
Fix this by sampling before type before any freeing could happen.
The correct temporal ordering was broken when we removed xfs_btnum_t.

Cc: r772577952@gmail.com
Cc: <stable@vger.kernel.org> # v6.9
Fixes: ec793e690f801d ("xfs: remove xfs_btnum_t")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/btree.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index cd6f0ff382a7c8..acade92c5fce1a 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -370,12 +370,15 @@ xchk_btree_check_block_owner(
 {
 	xfs_agnumber_t		agno;
 	xfs_agblock_t		agbno;
+	bool			is_bnobt, is_rmapbt;
 	bool			init_sa;
 	int			error = 0;
 
 	if (!bs->cur)
 		return 0;
 
+	is_bnobt = xfs_btree_is_bno(bs->cur->bc_ops);
+	is_rmapbt = xfs_btree_is_rmap(bs->cur->bc_ops);
 	agno = xfs_daddr_to_agno(bs->cur->bc_mp, daddr);
 	agbno = xfs_daddr_to_agbno(bs->cur->bc_mp, daddr);
 
@@ -398,11 +401,11 @@ xchk_btree_check_block_owner(
 	 * have to nullify it (to shut down further block owner checks) if
 	 * self-xref encounters problems.
 	 */
-	if (!bs->sc->sa.bno_cur && xfs_btree_is_bno(bs->cur->bc_ops))
+	if (!bs->sc->sa.bno_cur && is_bnobt)
 		bs->cur = NULL;
 
 	xchk_xref_is_only_owned_by(bs->sc, agbno, 1, bs->oinfo);
-	if (!bs->sc->sa.rmap_cur && xfs_btree_is_rmap(bs->cur->bc_ops))
+	if (!bs->sc->sa.rmap_cur && is_rmapbt)
 		bs->cur = NULL;
 
 out_free:


