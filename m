Return-Path: <linux-xfs+bounces-7354-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EAFD98AD24D
	for <lists+linux-xfs@lfdr.de>; Mon, 22 Apr 2024 18:41:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A00F0286E5A
	for <lists+linux-xfs@lfdr.de>; Mon, 22 Apr 2024 16:41:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 165C8153BD5;
	Mon, 22 Apr 2024 16:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I7crmtNf"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8C01514CA
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 16:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713804026; cv=none; b=XJdm2L7Ga0Ob+ANJTUkAUFBpWjat5S21HR//vm2kP0IQHU6sPpiX5kpM1OkfGnCQeKgk0SJdXyRZXAbgfVEP3ph8INedy0Z9syuK4HnLv9vkX5Eoq/lWdBf4mollfwaCt+aYz2Ywe6Z3RXPfsLWD13FfSEcB938d39mEhN9mGDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713804026; c=relaxed/simple;
	bh=fzOFol4cvr8odkknKZN2uyJTaiTxNXYam+nrknXWAwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TLdzLcI2CTk7OE+8UEiG+ItncNrIjJRid3tvQM8wEwW5dfLFOkVptEPgdzMVSwg1m/IQGlFrgToQ5XsOwDXjqvXFp2FCAzwmRt09UzjVQYAjcPcV8kViUcjJJa/uCxWzlyRFL3jJRSW3Rn9HOr8JLAvJGOP0eFcKhkcVML1cKC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I7crmtNf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5AB8C113CC;
	Mon, 22 Apr 2024 16:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713804026;
	bh=fzOFol4cvr8odkknKZN2uyJTaiTxNXYam+nrknXWAwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I7crmtNfhv0/vZfU3O9oBb72iR9xd0lQj8irTug4wM/E06y/0EM/Yxej3XNZIWkes
	 Xh6waqVQgoZxEYDp9T+OB4iU3WnBeK4rMacqZzmQ5KTWiEK7J/HTYmvojT5noDPpjh
	 7Bxr2Lw7GgSfbZZTLYDb9cSeluvQlTI9L2Tk1dvYknNLgFLX7vywlJNiIKPqqyctUf
	 A6Oo1mLMQGYx+jaiBm1d1EReQpoFZtcmusNFnwXweS+BFtIvH5zujfQ4vBgnwHsyYu
	 N8cSzMchq1jq0w2S7FK+VU/7nUK+w3UXutckgUGa2qJ3mu6QBdmMr+fSKlH2Ywa4v9
	 99Gkstar9ywsA==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 52/67] xfs: remove rt-wrappers from xfs_format.h
Date: Mon, 22 Apr 2024 18:26:14 +0200
Message-ID: <20240422163832.858420-54-cem@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240422163832.858420-2-cem@kernel.org>
References: <20240422163832.858420-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 3abfe6c2759e2e3000b13f8ce8a1a325e80987a1

xfs_format.h has a bunch odd wrappers for helper functions and mount
structure access using RT* prefixes.  Replace them with their open coded
versions (for those that weren't entirely unused) and remove the wrappers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 db/check.c            |  4 ++--
 libxfs/xfs_format.h   |  8 --------
 libxfs/xfs_rtbitmap.c | 24 ++++++++++++------------
 repair/rt.c           |  6 ++----
 4 files changed, 16 insertions(+), 26 deletions(-)

diff --git a/db/check.c b/db/check.c
index a47a5d9cb..36d82af0a 100644
--- a/db/check.c
+++ b/db/check.c
@@ -3647,7 +3647,7 @@ process_rtbitmap(
 			} else if (prevbit == 1) {
 				len = ((int)bmbno - start_bmbno) *
 					bitsperblock + (bit - start_bit);
-				log = XFS_RTBLOCKLOG(len);
+				log = xfs_highbit64(len);
 				offs = xfs_rtsumoffs(mp, log, start_bmbno);
 				sumcompute[offs]++;
 				prevbit = 0;
@@ -3660,7 +3660,7 @@ process_rtbitmap(
 	if (prevbit == 1) {
 		len = ((int)bmbno - start_bmbno) * bitsperblock +
 			(bit - start_bit);
-		log = XFS_RTBLOCKLOG(len);
+		log = xfs_highbit64(len);
 		offs = xfs_rtsumoffs(mp, log, start_bmbno);
 		sumcompute[offs]++;
 	}
diff --git a/libxfs/xfs_format.h b/libxfs/xfs_format.h
index e6ca188e2..7d2873a79 100644
--- a/libxfs/xfs_format.h
+++ b/libxfs/xfs_format.h
@@ -1156,20 +1156,12 @@ static inline bool xfs_dinode_has_large_extent_counts(
 #define	XFS_DFL_RTEXTSIZE	(64 * 1024)	        /* 64kB */
 #define	XFS_MIN_RTEXTSIZE	(4 * 1024)		/* 4kB */
 
-#define	XFS_BLOCKSIZE(mp)	((mp)->m_sb.sb_blocksize)
-#define	XFS_BLOCKMASK(mp)	((mp)->m_blockmask)
-
 /*
  * RT bit manipulation macros.
  */
 #define	XFS_RTMIN(a,b)	((a) < (b) ? (a) : (b))
 #define	XFS_RTMAX(a,b)	((a) > (b) ? (a) : (b))
 
-#define	XFS_RTLOBIT(w)	xfs_lowbit32(w)
-#define	XFS_RTHIBIT(w)	xfs_highbit32(w)
-
-#define	XFS_RTBLOCKLOG(b)	xfs_highbit64(b)
-
 /*
  * Dquot and dquot block format definitions
  */
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index bbf955be8..eefc45c64 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -193,7 +193,7 @@ xfs_rtfind_back(
 			/*
 			 * Different.  Mark where we are and return.
 			 */
-			i = bit - XFS_RTHIBIT(wdiff);
+			i = bit - xfs_highbit32(wdiff);
 			*rtx = start - i + 1;
 			return 0;
 		}
@@ -231,7 +231,7 @@ xfs_rtfind_back(
 			/*
 			 * Different, mark where we are and return.
 			 */
-			i += XFS_NBWORD - 1 - XFS_RTHIBIT(wdiff);
+			i += XFS_NBWORD - 1 - xfs_highbit32(wdiff);
 			*rtx = start - i + 1;
 			return 0;
 		}
@@ -270,7 +270,7 @@ xfs_rtfind_back(
 			/*
 			 * Different, mark where we are and return.
 			 */
-			i += XFS_NBWORD - 1 - XFS_RTHIBIT(wdiff);
+			i += XFS_NBWORD - 1 - xfs_highbit32(wdiff);
 			*rtx = start - i + 1;
 			return 0;
 		} else
@@ -346,7 +346,7 @@ xfs_rtfind_forw(
 			/*
 			 * Different.  Mark where we are and return.
 			 */
-			i = XFS_RTLOBIT(wdiff) - bit;
+			i = xfs_lowbit32(wdiff) - bit;
 			*rtx = start + i - 1;
 			return 0;
 		}
@@ -384,7 +384,7 @@ xfs_rtfind_forw(
 			/*
 			 * Different, mark where we are and return.
 			 */
-			i += XFS_RTLOBIT(wdiff);
+			i += xfs_lowbit32(wdiff);
 			*rtx = start + i - 1;
 			return 0;
 		}
@@ -421,7 +421,7 @@ xfs_rtfind_forw(
 			/*
 			 * Different, mark where we are and return.
 			 */
-			i += XFS_RTLOBIT(wdiff);
+			i += xfs_lowbit32(wdiff);
 			*rtx = start + i - 1;
 			return 0;
 		} else
@@ -706,7 +706,7 @@ xfs_rtfree_range(
 	 */
 	if (preblock < start) {
 		error = xfs_rtmodify_summary(args,
-				XFS_RTBLOCKLOG(start - preblock),
+				xfs_highbit64(start - preblock),
 				xfs_rtx_to_rbmblock(mp, preblock), -1);
 		if (error) {
 			return error;
@@ -718,7 +718,7 @@ xfs_rtfree_range(
 	 */
 	if (postblock > end) {
 		error = xfs_rtmodify_summary(args,
-				XFS_RTBLOCKLOG(postblock - end),
+				xfs_highbit64(postblock - end),
 				xfs_rtx_to_rbmblock(mp, end + 1), -1);
 		if (error) {
 			return error;
@@ -729,7 +729,7 @@ xfs_rtfree_range(
 	 * (new) free extent.
 	 */
 	return xfs_rtmodify_summary(args,
-			XFS_RTBLOCKLOG(postblock + 1 - preblock),
+			xfs_highbit64(postblock + 1 - preblock),
 			xfs_rtx_to_rbmblock(mp, preblock), 1);
 }
 
@@ -798,7 +798,7 @@ xfs_rtcheck_range(
 			/*
 			 * Different, compute first wrong bit and return.
 			 */
-			i = XFS_RTLOBIT(wdiff) - bit;
+			i = xfs_lowbit32(wdiff) - bit;
 			*new = start + i;
 			*stat = 0;
 			return 0;
@@ -837,7 +837,7 @@ xfs_rtcheck_range(
 			/*
 			 * Different, compute first wrong bit and return.
 			 */
-			i += XFS_RTLOBIT(wdiff);
+			i += xfs_lowbit32(wdiff);
 			*new = start + i;
 			*stat = 0;
 			return 0;
@@ -875,7 +875,7 @@ xfs_rtcheck_range(
 			/*
 			 * Different, compute first wrong bit and return.
 			 */
-			i += XFS_RTLOBIT(wdiff);
+			i += xfs_lowbit32(wdiff);
 			*new = start + i;
 			*stat = 0;
 			return 0;
diff --git a/repair/rt.c b/repair/rt.c
index 9f3bc8d53..d5283c57f 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -14,8 +14,6 @@
 #include "err_protos.h"
 #include "rt.h"
 
-#define xfs_highbit64 libxfs_highbit64	/* for XFS_RTBLOCKLOG macro */
-
 void
 rtinit(xfs_mount_t *mp)
 {
@@ -90,7 +88,7 @@ generate_rtinfo(xfs_mount_t	*mp,
 				}
 			} else if (in_extent == 1) {
 				len = (int) (extno - start_ext);
-				log = XFS_RTBLOCKLOG(len);
+				log = libxfs_highbit64(len);
 				offs = xfs_rtsumoffs(mp, log, start_bmbno);
 				sumcompute[offs]++;
 				in_extent = 0;
@@ -106,7 +104,7 @@ generate_rtinfo(xfs_mount_t	*mp,
 	}
 	if (in_extent == 1) {
 		len = (int) (extno - start_ext);
-		log = XFS_RTBLOCKLOG(len);
+		log = libxfs_highbit64(len);
 		offs = xfs_rtsumoffs(mp, log, start_bmbno);
 		sumcompute[offs]++;
 	}
-- 
2.44.0


