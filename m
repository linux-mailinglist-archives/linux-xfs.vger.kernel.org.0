Return-Path: <linux-xfs+bounces-31302-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +COuOmt9n2mrcQQAu9opvQ
	(envelope-from <linux-xfs+bounces-31302-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 25 Feb 2026 23:53:31 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B31619E7B9
	for <lists+linux-xfs@lfdr.de>; Wed, 25 Feb 2026 23:53:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F13E23008211
	for <lists+linux-xfs@lfdr.de>; Wed, 25 Feb 2026 22:52:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92EE836605D;
	Wed, 25 Feb 2026 22:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DTDYkwOg"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7033A1E5B63
	for <linux-xfs@vger.kernel.org>; Wed, 25 Feb 2026 22:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772059923; cv=none; b=ASmh5Bi13wA6AJ++Ppct7g1DkXIWUluNpfNJwr51OkTe2gqPm8Bq+sB0a6Yfv3oKBOx9ee3O/7s3TvlIzIKHl8y3VKH3h5qHgXR57dUUQpYY8BzlIeteKRntjh5PVioaSQN3kkltOWrIK4z7wDod09T7fRyloCoIGnt3CzQGvIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772059923; c=relaxed/simple;
	bh=kOBvUrZskBebD2BO+DyiLdRhKidjAj4UFUN0Ea6rVkQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=MQMR1qIFJQUcXSXkCuMy4kjzwR/njWQM354c5V7f+4HL5t9EyBHiqDoVS8iLdDLnXSzys6IAg+3Y2uUzcElxEgVO0F7D8XiLEvgQYDD7jjafL2ZNxtAOd4XFJIWWTLYGIiAdz53TDd87xm/Eseah/N1i+XtOy3QwrHy9IG3LZRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DTDYkwOg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D56C6C116D0;
	Wed, 25 Feb 2026 22:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772059923;
	bh=kOBvUrZskBebD2BO+DyiLdRhKidjAj4UFUN0Ea6rVkQ=;
	h=From:To:Subject:Date:From;
	b=DTDYkwOgkMIbxb8CRiiOQgtDet0NvqKIZ1MSwfRyNl08onXzIuboG2ZzS40v6+x9w
	 RxggLam8bmii2SJFW+7UUABcUULQWMwZjUL04tS+K22OHKb5LpaCkw+7ELQWhb9ffJ
	 QKr6fn0ntxZuxRA5BoIOksdZWwP0ZrgUT/UZo2Qgj8EEoiOZe+54/P2r44hqG241cq
	 6ck9Yx2fjQBBxMmjjGCqpZd7L0vjKftG26ja/An3t3RvyeW7fmReiO/S8H2dgwplFm
	 BzgFF4RSL+Ssh0wjC6Ss1ZqsrjKUxsNIRzZ26YL6zFAIkbzPkjrAoFvepr1hSl1cAL
	 mBCdbA8xcqAJw==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH] xfs: remove scratch field from struct xfs_gc_bio
Date: Thu, 26 Feb 2026 07:46:46 +0900
Message-ID: <20260225224646.2103434-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWO(0.00)[2];
	TAGGED_FROM(0.00)[bounces-31302-lists,linux-xfs=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dlemoal@kernel.org,linux-xfs@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 7B31619E7B9
X-Rspamd-Action: no action

The scratch field in struct xfs_gc_bio is unused. Remove it.

Fixes: 102f444b57b3 ("xfs: rework zone GC buffer management")
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 fs/xfs/xfs_zone_gc.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index 48c6cf584447..d78e29cdcc45 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -96,7 +96,6 @@ struct xfs_gc_bio {
 	 */
 	xfs_fsblock_t			old_startblock;
 	xfs_daddr_t			new_daddr;
-	struct xfs_zone_scratch		*scratch;
 
 	/* Are we writing to a sequential write required zone? */
 	bool				is_seq;
@@ -779,7 +778,6 @@ xfs_zone_gc_split_write(
 	ihold(VFS_I(chunk->ip));
 	split_chunk->ip = chunk->ip;
 	split_chunk->is_seq = chunk->is_seq;
-	split_chunk->scratch = chunk->scratch;
 	split_chunk->offset = chunk->offset;
 	split_chunk->len = split_len;
 	split_chunk->old_startblock = chunk->old_startblock;
-- 
2.53.0


