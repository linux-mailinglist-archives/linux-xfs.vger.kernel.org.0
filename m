Return-Path: <linux-xfs+bounces-26301-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DCF8BD1505
	for <lists+linux-xfs@lfdr.de>; Mon, 13 Oct 2025 05:12:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8CFC0189596A
	for <lists+linux-xfs@lfdr.de>; Mon, 13 Oct 2025 03:12:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8E8323D7F4;
	Mon, 13 Oct 2025 03:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dud/xxIk"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97DAA1C8FBA
	for <linux-xfs@vger.kernel.org>; Mon, 13 Oct 2025 03:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760325117; cv=none; b=Vfqtk31mro/k4DVqftY2anoeyQTcMOaDHXp5Jo2xSn2Ljk440NSl1je4tQexxCcecadxYPnlylY7MeEmPCtGGb08GGb/xH6Dv8Ftc/c0vm4NhT6ml46kQmJgB/BdDK2G4saVP4aGl9Dwzn21GgWppg9/DyH2lSmJw1N+9TBPvFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760325117; c=relaxed/simple;
	bh=Qdl2UhBv90JLBMPURmb9wureGlDEVSToD2iFAoSio8U=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=e6vcQsWi8VNjTIUD5jS1ZXOAIDAH6uyHe9blkohxDAHDds9xK3fcVURa8oidMXMRgjVeene1aEmvq/BnY0VU8xPKEIavmKHLVaWfmVw+mxiLye3kM81VcKDkchbXAwC6ntpKx4lFaJO3Ls3mUGUxFA7/flm36z6kBzxjtVR3lYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dud/xxIk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5FDDC4CEE7;
	Mon, 13 Oct 2025 03:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760325117;
	bh=Qdl2UhBv90JLBMPURmb9wureGlDEVSToD2iFAoSio8U=;
	h=From:To:Subject:Date:From;
	b=dud/xxIkSnv4fEnuk4u5EzQtGbLYLc7uK7q+ESt8yEGIQTorPwT+qFyGWAwkJR1pl
	 VqtRU8sovL5l8YoRA6lStc/JJWml12aN6zvSXbevKVmf3Yx5/dYsaEx+m6dF0cQWf7
	 sp94jmMDCH8hKQeyjA0U5S2HLRBrUeW2q+U5oO9b3vQkqdZypHdFQ9j8vTfdKXTawR
	 F8rSAExm2nwlZEeNGxalHeHAupZi33xGVoHfuLLY7HYg65ccKVESRsxJqiNSgTGeSZ
	 oodUcdw4rRrENRYp+HPYP+GkM+oCx09z4SqaDH9QP0isrt+E132RxAXkjqR19dAsze
	 fzEkoZTxCBzUw==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH] xfs: Improve CONFIG_XFS_RT Kconfig help
Date: Mon, 13 Oct 2025 12:08:29 +0900
Message-ID: <20251013030829.672060-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Improve the description of the XFS_RT configuration option to document
that this option is required for zoned block devices.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/Kconfig | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index 8930d5254e1d..d66d517c99a9 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -119,6 +119,15 @@ config XFS_RT
 
 	  See the xfs man page in section 5 for additional information.
 
+	  This option is mandatory to support zoned block devices. For these
+	  devices, the realtime subvolume must be backed by a zoned block
+	  device and a regular block device used as the main device (for
+	  metadata). If the zoned block device is a host-managed SMR hard-disk
+	  containing conventional zones at the beginning of its address space,
+	  XFS will use the disk conventional zones as the main device and the
+	  remaining sequential write required zones as the backing storage for
+	  the realtime subvolume.
+
 	  If unsure, say N.
 
 config XFS_DRAIN_INTENTS
-- 
2.51.0


