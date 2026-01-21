Return-Path: <linux-xfs+bounces-29990-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id OI9gN+10cGktYAAAu9opvQ
	(envelope-from <linux-xfs+bounces-29990-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 07:40:45 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 500E9522EC
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 07:40:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 12B2E70605D
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 06:38:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 292EB324B10;
	Wed, 21 Jan 2026 06:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i7LkMYyW"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E9D318EC7
	for <linux-xfs@vger.kernel.org>; Wed, 21 Jan 2026 06:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768977525; cv=none; b=QxMoEmsphuxzGOgFJgO4DvTv1nJ8HFZZ48VfGrNZ6LzIaQO0D0i/GTASRrM1QzxlAIHpJFXpA1qgyUmrW3/0qObcfKETV1fKpiak/Su6Cwdl/Yc/NZAzOz7tck7zlWQTwJsBsvjuXbmRedkctkKzSoolCo3MANY7bORpS57lWEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768977525; c=relaxed/simple;
	bh=NJsmIt8RKgQltx4Zv0zec++n4hhtLfHefO24WuYgs9k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VdHNP3JLcPEvVPzdij5Ak+jafs58cNetT0FAf3NP9qdaJty4aYZaaTY+Drbxl10gVNtqK6JRsNtMWu15iQvcs7OAMXWYh6C0BT86CpqDpha9RIit8CwpkkKmmGXd9NMHjd8X4FfVQZ6smj/nQHV3xw9w3pr2GNjxE4wrlnWHzEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i7LkMYyW; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 699B2C116D0;
	Wed, 21 Jan 2026 06:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768977524;
	bh=NJsmIt8RKgQltx4Zv0zec++n4hhtLfHefO24WuYgs9k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=i7LkMYyWP4uiit5tW2xT5hMPwotOvfQ1DFTxR0XPrudN5YMWGLQU3hJh3X7mDE2Rs
	 K2/81LpK2hIs2Fw2qrWerxf+IofyqnDJBUQK/kunlHSx2iugKGOscCIY+oQH2j+FxG
	 psOSJQ0Lz6c2CafpYeor1UPW9Zyg+3kelrRsIv1ZAXfId+qEtx814ZQLPF4lZ3zc1W
	 Bvb1xi1U32eEw7tjItXMUfr5VDQMjbkr3iB23/ktzuc4yeOaF5RC45l1vv+fhzZUT6
	 BVlB+IJ1hf70FvB7/GWb5/v4omh9zAMEne51oGUiDScrDs2k3+htTZPH3M/Ap8/JIa
	 QySmrvw71bbbQ==
Date: Tue, 20 Jan 2026 22:38:43 -0800
Subject: [PATCH 4/6] xfs: strengthen attr leaf block freemap checking
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176897695642.202569.3013555748365939096.stgit@frogsfrogsfrogs>
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
	TAGGED_FROM(0.00)[bounces-29990-lists,linux-xfs=lfdr.de];
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
X-Rspamd-Queue-Id: 500E9522EC
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

From: Darrick J. Wong <djwong@kernel.org>

Check for erroneous overlapping freemap regions and collisions between
freemap regions and the xattr leaf entry array.

Note that we must explicitly zero out the extra freemaps in
xfs_attr3_leaf_compact so that the in-memory buffer has a correctly
initialized freemap array to satisfy the new verification code, even if
subsequent code changes the contents before unlocking the buffer.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr_leaf.c |   55 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 55 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 776064eac5a090..f10479bf0c8f2b 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -85,6 +85,49 @@ xfs_attr_leaf_entries_end(
 			xfs_attr3_leaf_hdr_size(leaf);
 }
 
+static inline bool
+ichdr_freemaps_overlap(
+	const struct xfs_attr3_icleaf_hdr	*ichdr,
+	unsigned int				x,
+	unsigned int				y)
+{
+	const unsigned int			xend =
+		ichdr->freemap[x].base + ichdr->freemap[x].size;
+	const unsigned int			yend =
+		ichdr->freemap[y].base + ichdr->freemap[y].size;
+
+	/* empty slots do not overlap */
+	if (!ichdr->freemap[x].size || !ichdr->freemap[y].size)
+		return false;
+
+	return ichdr->freemap[x].base < yend && xend > ichdr->freemap[y].base;
+}
+
+static inline xfs_failaddr_t
+xfs_attr_leaf_ichdr_freemaps_verify(
+	const struct xfs_attr3_icleaf_hdr	*ichdr,
+	const struct xfs_attr_leafblock		*leaf)
+{
+	unsigned int				entries_end =
+		xfs_attr_leaf_entries_end(ichdr->count, leaf);
+	int					i;
+
+	if (ichdr_freemaps_overlap(ichdr, 0, 1))
+		return __this_address;
+	if (ichdr_freemaps_overlap(ichdr, 0, 2))
+		return __this_address;
+	if (ichdr_freemaps_overlap(ichdr, 1, 2))
+		return __this_address;
+
+	for (i = 0; i < XFS_ATTR_LEAF_MAPSIZE; i++) {
+		if (ichdr->freemap[i].size > 0 &&
+		    ichdr->freemap[i].base < entries_end)
+			return __this_address;
+	}
+
+	return NULL;
+}
+
 /*
  * attr3 block 'firstused' conversion helpers.
  *
@@ -228,6 +271,8 @@ xfs_attr3_leaf_hdr_to_disk(
 			hdr3->freemap[i].base = cpu_to_be16(from->freemap[i].base);
 			hdr3->freemap[i].size = cpu_to_be16(from->freemap[i].size);
 		}
+
+		ASSERT(xfs_attr_leaf_ichdr_freemaps_verify(from, to) == NULL);
 		return;
 	}
 	to->hdr.info.forw = cpu_to_be32(from->forw);
@@ -243,6 +288,8 @@ xfs_attr3_leaf_hdr_to_disk(
 		to->hdr.freemap[i].base = cpu_to_be16(from->freemap[i].base);
 		to->hdr.freemap[i].size = cpu_to_be16(from->freemap[i].size);
 	}
+
+	ASSERT(xfs_attr_leaf_ichdr_freemaps_verify(from, to) == NULL);
 }
 
 static xfs_failaddr_t
@@ -395,6 +442,10 @@ xfs_attr3_leaf_verify(
 			return __this_address;
 	}
 
+	fa = xfs_attr_leaf_ichdr_freemaps_verify(&ichdr, leaf);
+	if (fa)
+		return fa;
+
 	return NULL;
 }
 
@@ -1664,6 +1715,10 @@ xfs_attr3_leaf_compact(
 	ichdr_dst->freemap[0].base = xfs_attr3_leaf_hdr_size(leaf_src);
 	ichdr_dst->freemap[0].size = ichdr_dst->firstused -
 						ichdr_dst->freemap[0].base;
+	ichdr_dst->freemap[1].base = 0;
+	ichdr_dst->freemap[2].base = 0;
+	ichdr_dst->freemap[1].size = 0;
+	ichdr_dst->freemap[2].size = 0;
 
 	/* write the header back to initialise the underlying buffer */
 	xfs_attr3_leaf_hdr_to_disk(args->geo, leaf_dst, ichdr_dst);


