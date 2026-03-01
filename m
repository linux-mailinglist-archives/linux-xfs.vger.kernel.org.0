Return-Path: <linux-xfs+bounces-31481-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kKpEEsKno2mJJQUAu9opvQ
	(envelope-from <linux-xfs+bounces-31481-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Sun, 01 Mar 2026 03:43:14 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B19251CDD80
	for <lists+linux-xfs@lfdr.de>; Sun, 01 Mar 2026 03:43:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 315E630B12DA
	for <lists+linux-xfs@lfdr.de>; Sun,  1 Mar 2026 01:35:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C06F2F3C3E;
	Sun,  1 Mar 2026 01:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oJj00S21"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192F22E7F39;
	Sun,  1 Mar 2026 01:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772328874; cv=none; b=A/Wz6rusjiuCY/T2v+5/Lg/S4TXu0ypiOq9bWAtbfMJtGM2cdKX1B/ut08S9LhvwXYHHUA9o46d3A63M/Tv29VWj7Nn0EM0R8d0VBHgoy4j0HiKEzJkTyg7Z31tLcOZP+ax80zrpvZECP4kB0wYdPslzq0lkWMuzUhor7WFx9wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772328874; c=relaxed/simple;
	bh=oR5YewzSBGYJbkaEpd88tB15mnQ/P51gX9ZgmXeJkQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=reEyPCZl2uQ9yOUQMh+bTv/slLSHR40h6bPL/4wXnENAfOIbb2grGWlExMGE35DwQ/9DYlOXh+froEc1WxgFj20dJTY3eeQJeizY5h+fsnhErHa6ErbbjDgROftp0uGvyyJnUSbR28/SAri+tfHiNv6K4+XQZyqjwgrHx4F8eEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oJj00S21; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D128C19421;
	Sun,  1 Mar 2026 01:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772328874;
	bh=oR5YewzSBGYJbkaEpd88tB15mnQ/P51gX9ZgmXeJkQ4=;
	h=From:To:Cc:Subject:Date:From;
	b=oJj00S21SxPd4G6JRRnzXL3KtoUQHuxSFdXDWrM5T7PVsJRCPbI5LT7xWghtyCRhv
	 VzWVILhJ16IzKzm7GzPJKYUkkusd0wf95oASUVs94oos+IlR8ak+vcnPRl9iD2ygw4
	 M71trFGO5emUYKZCG2gcz5tGrb2BDI9YnxrngvSy6ynk1VzOti2e8d9ZNRtT4Ko0IC
	 zkS7w5OwZWsPZl+oCpo3omdARionVRR71yhPIhnj2Du4mRE0VKHPmlFy+seklwxmo3
	 g+qFEJuHiaY6l7PwydD14ka4tUQN3UTLeijPePFV5uGaPZAV5bT+xVaCkF1/8aGCBA
	 wRXQdlRIHkEIA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org
Subject: FAILED: Patch "xfs: fix remote xattr valuelblk check" failed to apply to 6.6-stable tree
Date: Sat, 28 Feb 2026 20:34:32 -0500
Message-ID: <20260301013432.1694049-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-31481-lists,linux-xfs=lfdr.de];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_THREE(0.00)[4];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sashal@kernel.org,linux-xfs@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B19251CDD80
X-Rspamd-Action: no action

The patch below does not apply to the 6.6-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From bd3138e8912c9db182eac5fed1337645a98b7a4f Mon Sep 17 00:00:00 2001
From: "Darrick J. Wong" <djwong@kernel.org>
Date: Fri, 23 Jan 2026 09:27:33 -0800
Subject: [PATCH] xfs: fix remote xattr valuelblk check

In debugging other problems with generic/753, it turns out that it's
possible for the system go to down in the middle of a remote xattr set
operation such that the leaf block entry is marked incomplete and
valueblk is set to zero.  Make this no longer a failure.

Cc: <stable@vger.kernel.org> # v4.15
Fixes: 13791d3b833428 ("xfs: scrub extended attribute leaf space")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/attr.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index a397c50b77943..c3c122ea2d322 100644
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
-- 
2.51.0





