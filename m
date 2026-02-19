Return-Path: <linux-xfs+bounces-31143-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gI2mMryhl2nc3AIAu9opvQ
	(envelope-from <linux-xfs+bounces-31143-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Fri, 20 Feb 2026 00:50:20 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 51D96163B14
	for <lists+linux-xfs@lfdr.de>; Fri, 20 Feb 2026 00:50:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0F8593008210
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 23:46:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D3C62E6CAB;
	Thu, 19 Feb 2026 23:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FjIBLBXr"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A61C24729A
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 23:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771544814; cv=none; b=sE2UCaxbyuZrFVZJPmwES5oNVthoG/YGQnkrSfWRUZoQb9ngS7s1CjtZeQ6LZVGcU4Za0Ymx/buc66fxbct8vs3wRze5qPkfI/p66/JmaW4iOjcRWtW328fXenIcoDw4qCWaAGNXNGRt696ikP0hncQVKkG/7YQp2pToPmB/qy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771544814; c=relaxed/simple;
	bh=VfXnfV7WZ9ILOe9qbwt49ZUvIOMlzOms9BiQe3NJg5U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a1QriPwJCfgho9gQi1hus7LBvvOOvmU0sDebnGF01FJqweRbVDulpX2W0XizDMPBWCmcKFQHhTP8FCOhLbg5dQqXORw/xRmyFnjUepkZRK09BBNr+hnbFS1HZAnJRUyAZNc0uurMM67/E0agqcIBUz2yplY11NaIFYS00xGaezE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FjIBLBXr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5F89C4CEF7;
	Thu, 19 Feb 2026 23:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771544814;
	bh=VfXnfV7WZ9ILOe9qbwt49ZUvIOMlzOms9BiQe3NJg5U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FjIBLBXrllXdjNQZ7hh3qE+osfJZS7TNufQi7M21SIzwjxeerSMkjdb92z+HpEHKQ
	 sJhIYni8bRH/zbgl2ZUOSl/BNLI+YqYOgq4v8mwh1FCMCfpaC1Mn1hTAQW5fnJVFMP
	 GwXcQ+zoaDq7GQbHV5A7U29op3cAyvmghwCdYGv75AJW+IT1/RSdHRt9nbS0GYfIZk
	 UhEIpp9wF1dv8Q1HJJm12k3eRFFjny4jtQd55RuV5OobJP6PsRqHSkmWztT7XYaMj/
	 MaLo2pO+cmuvqgZ0QSCz6Z+Q9C6861D/AFSMpUuF1gZenzZlX45bmBg6HnjEAZPOEl
	 P40T0ftsFXSoA==
Date: Thu, 19 Feb 2026 15:46:53 -0800
Subject: [PATCH 1/6] mkfs: set rtstart from user-specified dblocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <177154457224.1286306.3676140728308498902.stgit@frogsfrogsfrogs>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-31143-lists,linux-xfs=lfdr.de];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djwong@kernel.org,linux-xfs@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5]
X-Rspamd-Queue-Id: 51D96163B14
X-Rspamd-Action: no action

From: Darrick J. Wong <djwong@kernel.org>

generic/211 fails to format the disk on a system with an internal zoned
device.  Poking through the shell scripts, it's apparently doing this:

# mkfs.xfs -d size=629145600 -r size=629145600 -b size=4096 -m metadir=1,autofsck=1,uquota,gquota,pquota, -r zoned=1 -d rtinherit=1 /dev/sdd
size 629145600 specified for data subvolume is too large, maximum is 131072 blocks

Strange -- we asked for 629M data and rt sections, the device is 20GB in
size, but it claims insufficient space in the data subvolume.

Further analysis shows that open_devices is setting rtstart to 1% of the
size of the data volume (or no less than 300M) and rounding that up to
the nearest power of two (512M).  Hence the 131072 number.

But wait, we said that we wanted a 629M data section.  Let's set rtstart
to the same value if the user didn't already provide one, instead of
using the default value.

Cc: <linux-xfs@vger.kernel.org> # v6.15.0
Fixes: 2e5a737a61d34e ("xfs_mkfs: support creating file system with zoned RT devices")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 mkfs/xfs_mkfs.c |   42 +++++++++++++++++++++++++++++++-----------
 1 file changed, 31 insertions(+), 11 deletions(-)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index b34407725f76df..a90160b26065b7 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3696,6 +3696,36 @@ _("log stripe unit (%d bytes) is too large (maximum is 256KiB)\n"
 
 }
 
+static uint64_t
+calc_rtstart(
+	const struct mkfs_params	*cfg,
+	const struct libxfs_init	*xi)
+{
+	uint64_t			rt_target_size;
+	uint64_t			rtstart = 1;
+
+	if (cfg->dblocks) {
+		/*
+		 * If the user specified the size of the data device but not
+		 * the start of the internal rt device, set the internal rt
+		 * volume to start at the end of the data device.
+		 */
+		return cfg->dblocks << (cfg->blocklog - BBSHIFT);
+	}
+
+	/*
+	 * By default reserve at 1% of the total capacity (rounded up to the
+	 * next power of two) for metadata, but match the minimum we enforce
+	 * elsewhere. This matches what SMR HDDs provide.
+	 */
+	rt_target_size = max((xi->data.size + 99) / 100,
+			     BTOBB(300 * 1024 * 1024));
+
+	while (rtstart < rt_target_size)
+		rtstart <<= 1;
+	return rtstart;
+}
+
 static void
 open_devices(
 	struct mkfs_params	*cfg,
@@ -3720,17 +3750,7 @@ open_devices(
 		zt->rt.zone_capacity = zt->data.zone_capacity;
 		zt->rt.nr_zones = zt->data.nr_zones - zt->data.nr_conv_zones;
 	} else if (cfg->sb_feat.zoned && !cfg->rtstart && !xi->rt.dev) {
-		/*
-		 * By default reserve at 1% of the total capacity (rounded up to
-		 * the next power of two) for metadata, but match the minimum we
-		 * enforce elsewhere. This matches what SMR HDDs provide.
-		 */
-		uint64_t rt_target_size = max((xi->data.size + 99) / 100,
-					      BTOBB(300 * 1024 * 1024));
-
-		cfg->rtstart = 1;
-		while (cfg->rtstart < rt_target_size)
-			cfg->rtstart <<= 1;
+		cfg->rtstart = calc_rtstart(cfg, xi);
 	}
 
 	if (cfg->rtstart) {


