Return-Path: <linux-xfs+bounces-31145-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2MBRARGhl2nc3AIAu9opvQ
	(envelope-from <linux-xfs+bounces-31145-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Fri, 20 Feb 2026 00:47:29 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 97A9A163A90
	for <lists+linux-xfs@lfdr.de>; Fri, 20 Feb 2026 00:47:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id F3978300832C
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 23:47:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB9282E6CAB;
	Thu, 19 Feb 2026 23:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qwYuELIs"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98FFC24729A
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 23:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771544845; cv=none; b=FpfBb5XsivwmR/0Yt98vLOnoaVc52zr1bo2U7nKnD2j484jNsvXknzYbRxTdDxhBnZALqI4dxe0f1pD8AvyO5hvWbg0soM95Qmg9wzjd4Ng4L2VHyEuTntuNAEyKNLTKBs80b+PF7q2kh28zQvmNVAGUWUPUQHtH9KWomHysO6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771544845; c=relaxed/simple;
	bh=raPsc5E7xCEZVWitMbpQAbDSFIXC5uNFmBfPGQR/SVE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JbvWMoyOdzXMuRf/NovwK+BXSKNeNndR5osHEKvGzrZNL0NsfEt5Ff3uHVVVO7tzsjKdoR+hfP64BCbiWhw8JMZ4bnq9iq4vGNM2WNKkCLDI6fbx6cryxr0q1TkCdLH3GGXwcqgIjRjEvQ6LP+lWU1HzD0pJNVyIfeMcnyqVMy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qwYuELIs; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 320D8C4CEF7;
	Thu, 19 Feb 2026 23:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771544845;
	bh=raPsc5E7xCEZVWitMbpQAbDSFIXC5uNFmBfPGQR/SVE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qwYuELIs9wtv4ax8AIKyqGsQsh19DOaI514EddtvyaL2v/qX9eoc7ylJSE52OgWmU
	 M/ypL9TIPAc9yYATANlb2k+UAk4ALSEbqVzlrTw8zXqotJY+hMpVPmkEu9WmXBxioh
	 bWAw/LGJDic0lhlFSPcNNElRZr5aBOZsoWn4KOzDvBpvCxuNpVkhwOUGDSSwN/+eQq
	 JXZjDUQnTkRBF/2pWNgs82tHCCjUpGcb0giuPrOtkL+l7zYTTW0Xcls9gbwA9AWRnk
	 qL+iNxo7KWS9bEpsaMsnkt7wacpncaO5ZJmcClZnGWW7Q+hyjiw5uX18qwwPrR3ymR
	 8Q8mbdrmQ+nYg==
Date: Thu, 19 Feb 2026 15:47:24 -0800
Subject: [PATCH 3/6] mkfs: quiet down warning about insufficient write zones
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <177154457261.1286306.1799786827639995258.stgit@frogsfrogsfrogs>
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
	TAGGED_FROM(0.00)[bounces-31145-lists,linux-xfs=lfdr.de];
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
X-Rspamd-Queue-Id: 97A9A163A90
X-Rspamd-Action: no action

From: Darrick J. Wong <djwong@kernel.org>

xfs/067 fails with the following weird mkfs message:

 --- tests/xfs/067.out	2025-07-15 14:41:40.191273467 -0700
 +++ /run/fstests/logs/xfs/067.out.bad	2026-01-06 16:59:11.907677987 -0800
 @@ -1,4 +1,8 @@
  QA output created by 067
 +Warning: not enough zones (134/133) for backing requested rt size due to
 +over-provisioning needs, writable size will be less than (null)
 +Warning: not enough zones (134/133) for backing requested rt size due to
 +over-provisioning needs, writable size will be less than (null)

In this case, MKFS_OPTIONS is set to: "-rrtdev=/dev/sdb4 -m
metadir=1,autofsck=1,uquota,gquota,pquota -d rtinherit=1 -r zoned=1
/dev/sda4"

In other words, we didn't pass an explicit rt volume size to mkfs, so
the message is a bit bogus.  Let's skip printing the message when
the user did not provide an explicit rtsize parameter.

Cc: <linux-xfs@vger.kernel.org> # v6.18.0
Fixes: b5d372d96db1ad ("mkfs: adjust_nr_zones for zoned file system on conventional devices")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 mkfs/xfs_mkfs.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index a90160b26065b7..f539c91db251fd 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -4579,10 +4579,11 @@ adjust_nr_zones(
 				cfg->rgsize;
 
 	if (cfg->rgcount > max_zones) {
-		fprintf(stderr,
+		if (cli->rtsize)
+			fprintf(stderr,
 _("Warning: not enough zones (%lu/%u) for backing requested rt size due to\n"
   "over-provisioning needs, writable size will be less than %s\n"),
-			cfg->rgcount, max_zones, cli->rtsize);
+				cfg->rgcount, max_zones, cli->rtsize);
 		cfg->rgcount = max_zones;
 	}
 	new_rtblocks = (cfg->rgcount * cfg->rgsize);


