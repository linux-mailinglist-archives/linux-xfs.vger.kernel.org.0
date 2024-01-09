Return-Path: <linux-xfs+bounces-2680-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AC77A8283DD
	for <lists+linux-xfs@lfdr.de>; Tue,  9 Jan 2024 11:21:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4E0EDB24563
	for <lists+linux-xfs@lfdr.de>; Tue,  9 Jan 2024 10:21:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAD3E36AEE;
	Tue,  9 Jan 2024 10:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kl7pbz8g"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11E236AED;
	Tue,  9 Jan 2024 10:21:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A89B2C433C7;
	Tue,  9 Jan 2024 10:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704795673;
	bh=KrcwIHRNBrvWhmypIQpphTw4zTRmmmsGsm5ScFnFkyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kl7pbz8ggowixp5kKgBkCUyxefzap8swHixtvYFYsUwFtKbphO01KydBXxJ39oT+x
	 9mb6boRd4sRhcQc9Ad9QGR4ma8/XyMF1Ap/iefvDQsa4197xXEaxyBu4zgGMDepujI
	 ikGYd4I0wY3GYAWiGBnSnJ8XBNYPJMq+vXNf1SJ299UF9dsnEiupDlIMCe6S6vOkvP
	 hhclPimR2sMZiAadPWSeno7gGSW2FVRTSf2b3xkiXre+Y3VLxfNOyS5EIldLQXPE2M
	 4F310scKnzu3DrzyFfLnrxGVmVeifIN4009YyojsnzC7A/gqH475eScMbBIFwzK97p
	 oSvksNLI4zrzQ==
From: Chandan Babu R <chandanbabu@kernel.org>
To: fstests@vger.kernel.org
Cc: Chandan Babu R <chandanbabu@kernel.org>,
	linux-xfs@vger.kernel.org,
	djwong@kernel.org,
	zlang@redhat.com
Subject: [PATCH V2 2/5] common/xfs: Add function to detect support for metadump v2
Date: Tue,  9 Jan 2024 15:50:44 +0530
Message-ID: <20240109102054.1668192-3-chandanbabu@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240109102054.1668192-1-chandanbabu@kernel.org>
References: <20240109102054.1668192-1-chandanbabu@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This commit defines a new function to help detect support for metadump v2.

Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 common/xfs | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/common/xfs b/common/xfs
index 38094828..fc744489 100644
--- a/common/xfs
+++ b/common/xfs
@@ -698,6 +698,12 @@ _xfs_mdrestore() {
 	$XFS_MDRESTORE_PROG $options "${metadump}" "${device}"
 }
 
+_scratch_metadump_v2_supported()
+{
+	$XFS_DB_PROG -c "help metadump" $SCRATCH_DEV | \
+		grep -q "Metadump version to be used"
+}
+
 # Snapshot the metadata on the scratch device
 _scratch_xfs_metadump()
 {
-- 
2.43.0


