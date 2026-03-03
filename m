Return-Path: <linux-xfs+bounces-31668-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mOQTBnAppmk+LQAAu9opvQ
	(envelope-from <linux-xfs+bounces-31668-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Tue, 03 Mar 2026 01:21:04 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 66D3C1E713A
	for <lists+linux-xfs@lfdr.de>; Tue, 03 Mar 2026 01:21:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9B41D3055820
	for <lists+linux-xfs@lfdr.de>; Tue,  3 Mar 2026 00:20:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36E681E8332;
	Tue,  3 Mar 2026 00:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K86eZ3Rq"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141601DF26E
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 00:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772497232; cv=none; b=MbWN+3BKsEtJIBJ3xMKYQ2Y9W0TUo3hJEz4uElZvIo1PXDC6WOGLvSJcET84PdKEdI9PkyFh0DxxFIwlWPDN9e0AsE9CEuDNImboO9DQOQNoDZIbFCt6ghXIO85HYNlZ3f/uEk6aAXlLaJQb93MyBNpQd9BePgkED3f3JEHdPHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772497232; c=relaxed/simple;
	bh=NWj/trDcJrOxWcoSQSbf/Esc+iQTleNHRqwwAUb2lo4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MeuEJ9xpwY/311PKAX3x3ExL5fGGedkR3KqD/2wzHx5PtgCimRsZhU8DkipY0/vH01Amp1QrylYH+5zSIM3F6Ae3LW+vLozjL0qc9c+26UblQwiQNFQhsziN2xHzWsRYoA9kvNqMlKTi6xdyp/DX0gadW1Bpk0twNDCgkRvKfA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K86eZ3Rq; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA180C2BC86;
	Tue,  3 Mar 2026 00:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772497232;
	bh=NWj/trDcJrOxWcoSQSbf/Esc+iQTleNHRqwwAUb2lo4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=K86eZ3RqgcBG6JVji9TKgbLum+wzi10ZfOv/7yBw8lQnCV+bS9VRHNgpnnjsrciQx
	 j6zOqYwSf93ug9kw6EhdIyS91+z5I/Mb5+6gaJr2vxyKtYfdnzcsrMpGzfcRmdYpeG
	 RX+RkQJTLCHduF/x9aehDsRkn9WVV30xHjzGObEKntGsaM3frWbm0CE7kuIRTwyeWG
	 d5f/J1ahv3NOUIAyeKptwN6KyUmmvWh3ikqHJrEDJdL++d4RcRMoPGG9yq1sacsG0v
	 VgRiwnkuHmTo4YtWzL4Q1ORFEXY+VnGi6gu8x+xkImBFZ1k5r6vKrJY40ZOTiUZYuy
	 kas4rEMHI2RCg==
Date: Mon, 02 Mar 2026 16:20:31 -0800
Subject: [PATCH 32/36] xfs: fix code alignment issues in xfs_ondisk.c
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: cem@kernel.org, hch@lst.de, wilfred.mallawa@wdc.com,
 linux-xfs@vger.kernel.org
Message-ID: <177249638367.457970.17483845481807313685.stgit@frogsfrogsfrogs>
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
X-Rspamd-Queue-Id: 66D3C1E713A
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-31668-lists,linux-xfs=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	TO_DN_NONE(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djwong@kernel.org,linux-xfs@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,lst.de:email,wdc.com:email]
X-Rspamd-Action: no action

From: Wilfred Mallawa <wilfred.mallawa@wdc.com>

Source kernel commit: fd81d3fd01a5ee4bd26a7dc440e7a2209277d14b

Fixup some code alignment issues in xfs_ondisk.c

Signed-off-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_ondisk.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_ondisk.h b/libxfs/xfs_ondisk.h
index 2e9715cc1641df..70605019383c32 100644
--- a/libxfs/xfs_ondisk.h
+++ b/libxfs/xfs_ondisk.h
@@ -73,7 +73,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dir3_free_hdr,		64);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dir3_leaf,		64);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dir3_leaf_hdr,		64);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_leaf_entry,		8);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_leaf_entry,	8);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_leaf_hdr,		32);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_leaf_map,		4);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_attr_leaf_name_local,	4);
@@ -116,7 +116,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_STRUCT_SIZE(struct xfs_da_intnode,		16);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_da_node_entry,		8);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_da_node_hdr,		16);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_data_free,		4);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_data_free,	4);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_dir2_data_hdr,		16);
 	XFS_CHECK_OFFSET(struct xfs_dir2_data_unused, freetag,	0);
 	XFS_CHECK_OFFSET(struct xfs_dir2_data_unused, length,	2);


