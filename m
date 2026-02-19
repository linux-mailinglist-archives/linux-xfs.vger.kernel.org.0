Return-Path: <linux-xfs+bounces-31146-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KEJEGh+hl2nc3AIAu9opvQ
	(envelope-from <linux-xfs+bounces-31146-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Fri, 20 Feb 2026 00:47:43 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 1956D163AA5
	for <lists+linux-xfs@lfdr.de>; Fri, 20 Feb 2026 00:47:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 55EBC3008999
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 23:47:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B45B2E6CAB;
	Thu, 19 Feb 2026 23:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P6m3pBpi"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3822824729A
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 23:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771544861; cv=none; b=olilV5veEd3zso5uwAUIJJndVkD3EAJAEy8WCb6ygPEgjWC56rWWngEvmB7v8K+PZ9BTolKAbl83vTqAHAGuSTPTW/DIWHckfzWyhi27rs53VHz+HICOsaBkITtlJhmXnqR/9iW6yLReXOXiLeYZRY/ykOOfGa6UibuebXBZbZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771544861; c=relaxed/simple;
	bh=1kRzhs0Y/FL0MTnD9zSnJazQb0NBkz+/9i6/Iug1LaE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GV3cCGVDOfazRa/U6DoyZlGoBsMhAhtoWf/OyAorTrVWUb99nySBon+s5xlIQiK2KJwqYnSvS04/+5qX3B9ZCsZhYy8gvJLyVC7ZIA4Xm3n7HHlCtQrA42A3OdlUkKh7OYDrrWkJ/t+yAVrspHKEJq3oY6FCVpzWf31YinHEz08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P6m3pBpi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7DBFC4CEF7;
	Thu, 19 Feb 2026 23:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771544860;
	bh=1kRzhs0Y/FL0MTnD9zSnJazQb0NBkz+/9i6/Iug1LaE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=P6m3pBpi19zI9TbE0RIqSUC1Y2qgkCAIt6OCukq57fJixusNtuUmjs3I9RIEmYVX9
	 FQu3HF5D02vRJfLIOrU+p44dvjnWuHgfxj6lSCvyP8C0MkswbTFSY0HpSpIyBwm8U2
	 deSFhxpFonNfnsuYw+Uf8yWKMe795thVx7FfJkC6DeguRQbg1dvIiySBV8wZvefOxe
	 oBhZIYbgL6jaGQP+tzEg+Q5YwFAzjBdSHs92TjnpPyuAvPSuYDP6/5frpwzsOkArVT
	 Mq5zxUYWgJv53+8JeBfKpOrtDXteKrocTAOQ0x1488TYPdp+tKitnjN6lelvujOKCR
	 VNP8/XoeQh3Yg==
Date: Thu, 19 Feb 2026 15:47:40 -0800
Subject: [PATCH 4/6] xfs_mdrestore: fix restoration on filesystems with 4k
 sectors
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <177154457279.1286306.844676721127418456.stgit@frogsfrogsfrogs>
In-Reply-To: <177154457179.1286306.5487224679893352750.stgit@frogsfrogsfrogs>
References: <177154457179.1286306.5487224679893352750.stgit@frogsfrogsfrogs>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-31146-lists,linux-xfs=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djwong@kernel.org,linux-xfs@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5]
X-Rspamd-Queue-Id: 1956D163AA5
X-Rspamd-Action: no action

From: Darrick J. Wong <djwong@kernel.org>

Running xfs/129 on a disk with 4k LBAs produces the following failure:

 --- /run/fstests/bin/tests/xfs/129.out	2025-07-15 14:41:40.210489431 -0700
 +++ /run/fstests/logs/xfs/129.out.bad	2026-01-05 21:43:08.814485633 -0800
 @@ -2,3 +2,8 @@ QA output created by 129
  Create the original file blocks
  Reflink every other block
  Create metadump file, restore it and check restored fs
 +xfs_mdrestore: Invalid superblock disk address/length
 +mount: /opt: can't read superblock on /dev/loop0.
 +       dmesg(1) may have more information after failed mount system call.
 +mount /dev/loop0 /opt failed
 +(see /run/fstests/logs/xfs/129.full for details)

This is a failure to restore a v2 metadump to /dev/loop0.  Looking at
the metadump itself, the first xfs_meta_extent contains:

{
	.xme_addr = 0,
	.xme_len = 8,
}

Hrm.  This is the primary superblock on the data device, with a length
of 8x512B = 4K.  The original filesystem has this geometry:

# xfs_info /dev/sda4
meta-data=/dev/sda4              isize=512    agcount=4, agsize=2183680 blks
         =                       sectsz=4096  attr=2, projid32bit=1

In other words, a sector size of 4k because the device's LBA size is 4k.
Regrettably, the metadump validation in mdrestore assumes that the
primary superblock is only 512 bytes long, which is not correct for this
scenario.

Fix this by allowing an xme_len value of up to the maximum sector size
for xfs, which is 32k.  Also remove a redundant and confusing mask check
for the xme_addr.

Note that this error was masked (at least on little-endian platforms
that most of us test on) until recent commit 98f05de13e7815 ("mdrestore:
fix restore_v2() superblock length check") which is why I didn't spot it
earlier.

Cc: <linux-xfs@vger.kernel.org> # v6.6.0
Fixes: fa9f484b79123c ("mdrestore: Define mdrestore ops for v2 format")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 mdrestore/xfs_mdrestore.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)


diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index b6e8a6196a795a..90908fe0ff6c2c 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -437,13 +437,21 @@ restore_v2(
 	if (fread(&xme, sizeof(xme), 1, md_fp) != 1)
 		fatal("error reading from metadump file\n");
 
-	if (xme.xme_addr != 0 || be32_to_cpu(xme.xme_len) != 1 ||
-	    (be64_to_cpu(xme.xme_addr) & XME_ADDR_DEVICE_MASK) !=
-			XME_ADDR_DATA_DEVICE)
-		fatal("Invalid superblock disk address/length\n");
+	/*
+	 * The first block must be the primary super, which is at the start of
+	 * the data device, which is device 0.
+	 */
+	if (xme.xme_addr != 0)
+		fatal("Invalid superblock disk address 0x%llx\n",
+				be64_to_cpu(xme.xme_addr));
 
 	len = BBTOB(be32_to_cpu(xme.xme_len));
 
+	/* The primary superblock is always a single filesystem sector. */
+	if (len < BBTOB(1) || len > XFS_MAX_SECTORSIZE)
+		fatal("Invalid superblock disk length 0x%x\n",
+				be32_to_cpu(xme.xme_len));
+
 	if (fread(block_buffer, len, 1, md_fp) != 1)
 		fatal("error reading from metadump file\n");
 


