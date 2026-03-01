Return-Path: <linux-xfs+bounces-31486-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4HrHN5Kdo2k3IQUAu9opvQ
	(envelope-from <linux-xfs+bounces-31486-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Sun, 01 Mar 2026 02:59:46 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 476801CC87C
	for <lists+linux-xfs@lfdr.de>; Sun, 01 Mar 2026 02:59:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0297631DEA6E
	for <lists+linux-xfs@lfdr.de>; Sun,  1 Mar 2026 01:43:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2AE126FA6F;
	Sun,  1 Mar 2026 01:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="faoixRZN"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF4BB145A1F;
	Sun,  1 Mar 2026 01:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772329405; cv=none; b=VOVDoGlE8UNAi0xRoTxqcKPwSIFVst4qb1CaH0MRxGQuFO536kdeE4YrME8TNsyX6FthhZ+bJjuua9GOILwq3jSFbhA1PsR99BTQFkQfmasPRRkxpqgpn69hp4m4eLyAKO/9+dS0Q6sUr3AGdX9W0OkXy+K6/1FjuMVc8sBmkEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772329405; c=relaxed/simple;
	bh=UIgJpaffmdiJ9njvqxowhaNJQz4xetD64CxdmQgyFs0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=t6NYqizfYOFZhtTqhcn7798vhB05gCSLt0He5waEX+fYAIfGCUG6uiZ3zKAALsliv6NLVW5IX5zRHwIP1RHCbqgvbWMUI3X88z4XSFPYNHGZmqZLQMnn/BQrqZXw6MpfGDPg/qTzRmkZb38RgGz3OL/7ay2IvCoCsmuYlEAbqNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=faoixRZN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EA20C19421;
	Sun,  1 Mar 2026 01:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772329405;
	bh=UIgJpaffmdiJ9njvqxowhaNJQz4xetD64CxdmQgyFs0=;
	h=From:To:Cc:Subject:Date:From;
	b=faoixRZNANBRZ8KoFXFTTgoZR9xPbkbvUMSEsmJibg5NVygVQ5fpsW5W5mG9jxQLy
	 mrBfutqQEPiLReEUVdKrXCLa3+5l3xf7YUP14w2pzVMz9OuO28hi962PliEr2JW8q0
	 tshvM2X8uZDL77TFKGq+F032+IrUNb2Taxvsvx6jQeE4bfGW71gKRasL0hnCk91WKy
	 55kjzTCEymR4y71YMSMRM++sWwH1t6ICqQMuFSAg5lMwha2j+AUv7qkv9CyDvESqVL
	 5Srz0+dvTj+FJNoRHVZGXkLVbuYfepXHZy1KkUVpVukTwzCM3ds8+xxufs2Jfr5ncz
	 2kyxc54BZ4Qxw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>,
	linux-xfs@vger.kernel.org
Subject: FAILED: Patch "xfs: fix remote xattr valuelblk check" failed to apply to 6.1-stable tree
Date: Sat, 28 Feb 2026 20:43:23 -0500
Message-ID: <20260301014324.1705491-1-sashal@kernel.org>
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
	TAGGED_FROM(0.00)[bounces-31486-lists,linux-xfs=lfdr.de];
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
X-Rspamd-Queue-Id: 476801CC87C
X-Rspamd-Action: no action

The patch below does not apply to the 6.1-stable tree.
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





