Return-Path: <linux-xfs+bounces-5575-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AB37F88B83E
	for <lists+linux-xfs@lfdr.de>; Tue, 26 Mar 2024 04:16:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 65B622E2BC0
	for <lists+linux-xfs@lfdr.de>; Tue, 26 Mar 2024 03:16:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBCA9128823;
	Tue, 26 Mar 2024 03:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cBX+igC3"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DEFE57314
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711423000; cv=none; b=bhLPDNVu9QqcAIhMDvEwW4uDcw5tyMrl5rhnUv/pOprnvA0K4jEJTYhnrOwEGd6WP8/9zcH53QuhlBSAF9UNQPFtLGZBq33TLPbwoOyKOZWElHpVifJrMO0lrxRkzTNWxwkaXaZxQk6d+mSJ15LluUbU6IEgldbkzatnnC0XAxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711423000; c=relaxed/simple;
	bh=BDh0wLy/eV2Sl3lBtz39p9Aca1BUqV8RK8zF42cMHyI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KVa47MIpQP3fiDER4YPf8VtBDt99WFrDUz6YF6r3xXAZkr+FxLJcFk6JxfPM2HuU4d90/XM5MrlUi2nzdhZVEV5DnPFNWkHs/COHRFv0TUVhmnRK5WGHU+IKznicVBhb3vlQvXMbW6b0hAtYY4qG21+GQ15gpd86wn6/ZP/6cmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cBX+igC3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F2C4C433F1;
	Tue, 26 Mar 2024 03:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711423000;
	bh=BDh0wLy/eV2Sl3lBtz39p9Aca1BUqV8RK8zF42cMHyI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cBX+igC3+AjSD6q8ta1As4WIQ4PGDBpeg5MRiL89J1kLlIX+e1S8dufU7om4uZZS1
	 NrZODmJf+sq3jZV+Z484BtZMcgWnXfCxUa86dYDIEY/wgjWZ1gmuMMqfCO5svINt+U
	 ++zTMadUe7S2uQzVacDJgcW3H5KjTPxrzVz9dvAIeCDfRyax/kHNqVtDhxVl2MQ+6N
	 Q4NGjZWdrxhe5CKfEIwi6bGEP9m4kvmUVwb4J5S3QAYB7j1kB6U9bwoEJqs+VojITw
	 ljJ0XXOpda+kjtwIr1Rt+IYKpclX3DRwFkeXFBHJiGaln+n7p4ToSHp2YRQpfonl+U
	 N/ehPv8mQm8Kg==
Date: Mon, 25 Mar 2024 20:16:39 -0700
Subject: [PATCH 53/67] xfs: remove XFS_RTMIN/XFS_RTMAX
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Chandan Babu R <chandanbabu@kernel.org>,
 Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Message-ID: <171142127720.2212320.5102070527500452040.stgit@frogsfrogsfrogs>
In-Reply-To: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
References: <171142126868.2212320.6212071954549567554.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: a39f5ccc30d5a00b7e6d921aa387ad17d1e6d168

Use the kernel min/max helpers instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 libxfs/xfs_format.h   |    6 ------
 libxfs/xfs_rtbitmap.c |    8 ++++----
 mkfs/proto.c          |    4 ++--
 3 files changed, 6 insertions(+), 12 deletions(-)


diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index 7d2873a79a48..382ab1e71c0b 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1156,12 +1156,6 @@ static inline bool xfs_dinode_has_large_extent_counts(
 #define	XFS_DFL_RTEXTSIZE	(64 * 1024)	        /* 64kB */
 #define	XFS_MIN_RTEXTSIZE	(4 * 1024)		/* 4kB */
 
-/*
- * RT bit manipulation macros.
- */
-#define	XFS_RTMIN(a,b)	((a) < (b) ? (a) : (b))
-#define	XFS_RTMAX(a,b)	((a) > (b) ? (a) : (b))
-
 /*
  * Dquot and dquot block format definitions
  */
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index eefc45c64e20..79af7cda3441 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -182,7 +182,7 @@ xfs_rtfind_back(
 		 * Calculate first (leftmost) bit number to look at,
 		 * and mask for all the relevant bits in this word.
 		 */
-		firstbit = XFS_RTMAX((xfs_srtblock_t)(bit - len + 1), 0);
+		firstbit = max_t(xfs_srtblock_t, bit - len + 1, 0);
 		mask = (((xfs_rtword_t)1 << (bit - firstbit + 1)) - 1) <<
 			firstbit;
 		/*
@@ -336,7 +336,7 @@ xfs_rtfind_forw(
 		 * Calculate last (rightmost) bit number to look at,
 		 * and mask for all the relevant bits in this word.
 		 */
-		lastbit = XFS_RTMIN(bit + len, XFS_NBWORD);
+		lastbit = min(bit + len, XFS_NBWORD);
 		mask = (((xfs_rtword_t)1 << (lastbit - bit)) - 1) << bit;
 		/*
 		 * Calculate the difference between the value there
@@ -571,7 +571,7 @@ xfs_rtmodify_range(
 		/*
 		 * Compute first bit not changed and mask of relevant bits.
 		 */
-		lastbit = XFS_RTMIN(bit + len, XFS_NBWORD);
+		lastbit = min(bit + len, XFS_NBWORD);
 		mask = (((xfs_rtword_t)1 << (lastbit - bit)) - 1) << bit;
 		/*
 		 * Set/clear the active bits.
@@ -785,7 +785,7 @@ xfs_rtcheck_range(
 		/*
 		 * Compute first bit not examined.
 		 */
-		lastbit = XFS_RTMIN(bit + len, XFS_NBWORD);
+		lastbit = min(bit + len, XFS_NBWORD);
 		/*
 		 * Mask of relevant bits.
 		 */
diff --git a/mkfs/proto.c b/mkfs/proto.c
index f8e00c4b56f0..10b929b2ec37 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -793,8 +793,8 @@ rtfreesp_init(
 			res_failed(error);
 
 		libxfs_trans_ijoin(tp, mp->m_rbmip, 0);
-		ertx = XFS_RTMIN(mp->m_sb.sb_rextents,
-			rtx + NBBY * mp->m_sb.sb_blocksize);
+		ertx = min(mp->m_sb.sb_rextents,
+			   rtx + NBBY * mp->m_sb.sb_blocksize);
 
 		error = -libxfs_rtfree_extent(tp, rtx,
 				(xfs_rtxlen_t)(ertx - rtx));


