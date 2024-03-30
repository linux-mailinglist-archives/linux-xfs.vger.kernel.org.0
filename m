Return-Path: <linux-xfs+bounces-6099-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F08798928A1
	for <lists+linux-xfs@lfdr.de>; Sat, 30 Mar 2024 02:00:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AB2E52832E2
	for <lists+linux-xfs@lfdr.de>; Sat, 30 Mar 2024 01:00:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA4C5A953;
	Sat, 30 Mar 2024 01:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uwcdS32s"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99ADBA94B;
	Sat, 30 Mar 2024 01:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711760435; cv=none; b=KbvEQyTy0lnq86SqkRPJA91528/mdEzW/30CWuDMcgivAQ8Vtu5MLJlt1nqWX5DUhRSREVmqE/CqAwtuUWmR9TtI6RRBd9CwVKYFn5cpTNas8uUHMt5G3W+c4t36AG4u7pqpmP7qed3a+pdVZMyW2mkO+onm08iPrhoYSNxpPNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711760435; c=relaxed/simple;
	bh=XF0+li0F9HMsX2i2D7o4wMkgoesOL6yjPc2F5Ji3HAA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EADtLbL0GE7IkLegqGbxs9n47OCWV0xE3HCka8u90AsoKB1At141GakxU+Yez8FkMZFH3w3PvX2TSS0n9l82td094UX5CmUzPwyWwHZaOpY/Oznw7mDMZyno1e15CyStQlV2Wdxj4RO29H8XrcBj9S9yZDgzERHw0QehjKM8X44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uwcdS32s; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 741A3C433F1;
	Sat, 30 Mar 2024 01:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711760435;
	bh=XF0+li0F9HMsX2i2D7o4wMkgoesOL6yjPc2F5Ji3HAA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uwcdS32sx2xseo16O3WHL3dw2d67jg1z425fthJK86c+ZPXxni6ZcQT2IOTn2uDUE
	 Ohta0HM9sDCLPxQjymI39VqxVgpNajSkl0/vXN8rPNVXdxq77EVPPZRPSQd03JNBpx
	 uXB4foJ//QT8DJbqfbty3TxJ7HOdHDc97KMKR/BwwZNcoJf8homgMRkIsocE9BsJls
	 hazsd2sHBD3NOf26nJ8mQLFi17L+YoGvwfI1/InpOiKKaLlwDLQo7dVakTpXUzBsgO
	 X2jEQ66sb6EaIoULzXZOl95FjZDrnlaICiSKg9f2mbrPSq4Ihfc1mNHmj6sJZsL56/
	 iUay52konUdGw==
Date: Fri, 29 Mar 2024 18:00:34 -0700
Subject: [PATCH 14/14] xfs: enable logged file mapping exchange feature
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-fsdevel@vger.kernel.org, hch@lst.de,
 linux-xfs@vger.kernel.org
Message-ID: <171176018908.2014991.16160550038783958101.stgit@frogsfrogsfrogs>
In-Reply-To: <171176018639.2014991.12163554496963657299.stgit@frogsfrogsfrogs>
References: <171176018639.2014991.12163554496963657299.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add the XFS_SB_FEAT_INCOMPAT_LOG_EXCHMAPS feature to the set of features
that we will permit when mounting a filesystem.  This turns on support
for the file range exchange feature.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_format.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 753adde56a2d0..aa2ad7e04202b 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -398,7 +398,8 @@ xfs_sb_has_incompat_feature(
  */
 #define XFS_SB_FEAT_INCOMPAT_LOG_EXCHMAPS (1 << 1)
 #define XFS_SB_FEAT_INCOMPAT_LOG_ALL \
-	(XFS_SB_FEAT_INCOMPAT_LOG_XATTRS)
+		(XFS_SB_FEAT_INCOMPAT_LOG_XATTRS | \
+		 XFS_SB_FEAT_INCOMPAT_LOG_EXCHMAPS)
 #define XFS_SB_FEAT_INCOMPAT_LOG_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_LOG_ALL
 static inline bool
 xfs_sb_has_incompat_log_feature(


