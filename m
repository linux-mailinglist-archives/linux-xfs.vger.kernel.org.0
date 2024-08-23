Return-Path: <linux-xfs+bounces-11937-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 58AFD95C1E5
	for <lists+linux-xfs@lfdr.de>; Fri, 23 Aug 2024 02:05:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 166B9281EDE
	for <lists+linux-xfs@lfdr.de>; Fri, 23 Aug 2024 00:05:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EDB2469D;
	Fri, 23 Aug 2024 00:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cpWrPrUi"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F3AB3C36
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371472; cv=none; b=ExG2zscUd5hHT91tZ86dxkkyMhOqgx6/P6S55x/Jn9m0FVDUKZ6f0/1UCfpLyC3ABAEQ5LEgWFyqhvzT4XlPI3qCU1W9tyE+JciasXJIiXpZW3KtOYVHTuvF2QCoO6pNROnPjfkxbHDTM327d0mQTuK7Wfo9g5Hh2973Ckvs2rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371472; c=relaxed/simple;
	bh=NA73fT1VGqc30JC0K0zEgKRgceGq2MHDeb7y1AbK3fs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Cii66JP54TFPUSH/F/oxUYInLfeN32xCcPu3judc/nrdsYWUEVDiiEcFxOsdr51AbOXL1N0FZHhBf+MJOdsQsPxyfTcjxCTcuDnuc38Cen7ZUT74G61h3EGOPgR13iRdeV+Ny/R9FMmRyqdZGeMmY98HfouFsokTtc0iYF0p5g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cpWrPrUi; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CFACC4AF09;
	Fri, 23 Aug 2024 00:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371470;
	bh=NA73fT1VGqc30JC0K0zEgKRgceGq2MHDeb7y1AbK3fs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cpWrPrUileALxEl4Hjwpei2MmeCUhcim2j3OLRwNz6oK2EU5qvII5K5KJ7WR0vPOV
	 IqwUnh90qpn+9i5rKXYGtYTAB4CFKwDVg3hVt4mPbK9qdktYhngh2Jf/NaaqTKM6DK
	 JSuKXQZJDT9fxIkkBU2+tUAYeQaoZ8XeaHr9t98oO6DABi9cehp4l/WwIRjJmH2uIb
	 klVWFAgoAMMVJpWXbcT6xctBqRGNhW8/E+aUA/u4lQPbj/D0WPOcIMeCY94SSBD/WY
	 glJ2nvmTnLCu3rWM3gCN3CcJMA36Urf7alX74wYq/ECISst+Yii8qpy4iaCLUpPTnG
	 PapH0RCNCj/wQ==
Date: Thu, 22 Aug 2024 17:04:30 -0700
Subject: [PATCH 09/26] xfs: advertise metadata directory feature
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437085329.57482.14642494325904894193.stgit@frogsfrogsfrogs>
In-Reply-To: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
References: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
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

Advertise the existence of the metadata directory feature; this will be
used by scrub to decide if it needs to scan the metadir too.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h |    2 ++
 fs/xfs/libxfs/xfs_sb.c |    2 ++
 2 files changed, 4 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index c85c8077fac39..aba7fb0389bab 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -242,6 +242,8 @@ typedef struct xfs_fsop_resblks {
 #define XFS_FSOP_GEOM_FLAGS_EXCHANGE_RANGE (1 << 24) /* exchange range */
 #define XFS_FSOP_GEOM_FLAGS_PARENT	(1 << 25) /* linux parent pointers */
 
+#define XFS_FSOP_GEOM_FLAGS_METADIR	(1U << 30) /* metadata directories */
+
 /*
  * Minimum and maximum sizes need for growth checks.
  *
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 7afde477c0a79..1dcbf8ade39f8 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1279,6 +1279,8 @@ xfs_fs_geometry(
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_NREXT64;
 	if (xfs_has_exchange_range(mp))
 		geo->flags |= XFS_FSOP_GEOM_FLAGS_EXCHANGE_RANGE;
+	if (xfs_has_metadir(mp))
+		geo->flags |= XFS_FSOP_GEOM_FLAGS_METADIR;
 	geo->rtsectsize = sbp->sb_blocksize;
 	geo->dirblocksize = xfs_dir2_dirblock_bytes(sbp);
 


