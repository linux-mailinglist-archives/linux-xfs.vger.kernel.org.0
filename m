Return-Path: <linux-xfs+bounces-5509-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E0FED88B7D4
	for <lists+linux-xfs@lfdr.de>; Tue, 26 Mar 2024 03:59:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 811851F3CE08
	for <lists+linux-xfs@lfdr.de>; Tue, 26 Mar 2024 02:59:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF51512882F;
	Tue, 26 Mar 2024 02:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dkgsPgmY"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80EBA128387
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 02:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711421982; cv=none; b=BWaXePO42YIrz9dUA7DXc3SL5MWIoC+liDfJkd/1AM/cv7gR6JRGHa5e5W3sXZFsI6S6pH/fKSEijUigTR0kiRGPFWbeCiDWEGQdq6y4AChFbZMTfQSg4Jei7pONholMK08CyBQ/K4UutICyqbos2cdxAGKKjNPTIOtdQdkiHdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711421982; c=relaxed/simple;
	bh=qfMP8tvVLZAoDkRmqI3ZwhMEx6csbe2+Xclngz+n+GI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O5h4CVWF9TsE/Yho55MGUjmR7zhvoPO0EhXK59BWm/HSUFB3D7vD+ozThDlpENzz0iLrKzdR6aPYBS78cRpOzAszO4ZnMf0HPbFlLmlsIHK/ha5XFPO2qrmLgOGUkKKZepgXIROIA9knDYpxuvlWHnOptPf9birJvyR0gztAEyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dkgsPgmY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A482C433C7;
	Tue, 26 Mar 2024 02:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711421982;
	bh=qfMP8tvVLZAoDkRmqI3ZwhMEx6csbe2+Xclngz+n+GI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dkgsPgmYjqxxC1yEflpaDSaicJ6J1MpL6wH2GNkbwb7jHMXma/nM8+TuJ7ITuHQGY
	 WXTMKAQFvTq29s+IWJaQZtuCfgH6cDQ3JTkRcjvg/OgSTo0X+aqxadBBnAjO4AP5/P
	 hX4gszw3hlZ8oDjMvW9Wl6nLyDmR82rshZOTF4hZfQ8mkbU3Vzcsg2QiPQQzzKgfon
	 3c/GxXIQ7V2jg37MBrPpNRYPvqBXWn1X/EkR0wuFiUtw9fTJ6Wyt0Vr6/vemAf2U+S
	 gwHkISopsTOE3k8cCYYf7LXqmtU3PLOOqWBDol6TkWe6OgIOMSljoytIkFq1up/zhz
	 LHrtnfD5yRlLg==
Date: Mon, 25 Mar 2024 19:59:41 -0700
Subject: [PATCH 01/13] libxfs: fix incorrect porting to 6.7
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171142126323.2211955.1239989461209318080.stgit@frogsfrogsfrogs>
In-Reply-To: <171142126291.2211955.14829143192552278353.stgit@frogsfrogsfrogs>
References: <171142126291.2211955.14829143192552278353.stgit@frogsfrogsfrogs>
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

Userspace libxfs is supposed to match the kernel libxfs except for the
preprocessor include directives.  Fix a few discrepancies that came up
for whatever reason.

To fix the build errors resulting from CONFIG_XFS_RT not being defined,
add it to libxfs.h and alter the Makefile to track xfs_rtbitmap.h.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 db/check.c            |    1 -
 include/libxfs.h      |    4 ++++
 libxfs/Makefile       |    1 +
 libxfs/xfs_rtbitmap.c |    2 +-
 libxfs/xfs_rtbitmap.h |    3 ---
 repair/rt.c           |    1 -
 6 files changed, 6 insertions(+), 6 deletions(-)


diff --git a/db/check.c b/db/check.c
index 9d5576c333b2..a47a5d9cb5b4 100644
--- a/db/check.c
+++ b/db/check.c
@@ -20,7 +20,6 @@
 #include "init.h"
 #include "malloc.h"
 #include "dir2.h"
-#include "xfs_rtbitmap.h"
 
 typedef enum {
 	IS_USER_QUOTA, IS_PROJECT_QUOTA, IS_GROUP_QUOTA,
diff --git a/include/libxfs.h b/include/libxfs.h
index 9cec394ca407..aeec2bc76126 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -7,6 +7,9 @@
 #ifndef __LIBXFS_H__
 #define __LIBXFS_H__
 
+/* For userspace XFS_RT is always defined */
+#define CONFIG_XFS_RT
+
 #include "libxfs_api_defs.h"
 #include "platform_defs.h"
 #include "xfs.h"
@@ -80,6 +83,7 @@ struct iomap;
 #include "xfs_refcount_btree.h"
 #include "xfs_refcount.h"
 #include "xfs_btree_staging.h"
+#include "xfs_rtbitmap.h"
 
 #ifndef ARRAY_SIZE
 #define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
diff --git a/libxfs/Makefile b/libxfs/Makefile
index 010ee68e2292..6f688c0ad25a 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -50,6 +50,7 @@ HFILES = \
 	xfs_refcount_btree.h \
 	xfs_rmap.h \
 	xfs_rmap_btree.h \
+	xfs_rtbitmap.h \
 	xfs_sb.h \
 	xfs_shared.h \
 	xfs_trans_resv.h \
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 8f313339e97f..fb083499070c 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -931,7 +931,7 @@ xfs_rtcheck_alloc_range(
  */
 int
 xfs_rtfree_extent(
-	xfs_trans_t		*tp,	/* transaction pointer */
+	struct xfs_trans	*tp,	/* transaction pointer */
 	xfs_rtxnum_t		start,	/* starting rtext number to free */
 	xfs_rtxlen_t		len)	/* length of extent freed */
 {
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index db2f8c924b05..c0637057d69c 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -6,9 +6,6 @@
 #ifndef __XFS_RTBITMAP_H__
 #define	__XFS_RTBITMAP_H__
 
-/* For userspace XFS_RT is always defined */
-#define CONFIG_XFS_RT
-
 struct xfs_rtalloc_args {
 	struct xfs_mount	*mp;
 	struct xfs_trans	*tp;
diff --git a/repair/rt.c b/repair/rt.c
index abe58b569c0c..9f3bc8d53ec6 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -13,7 +13,6 @@
 #include "protos.h"
 #include "err_protos.h"
 #include "rt.h"
-#include "xfs_rtbitmap.h"
 
 #define xfs_highbit64 libxfs_highbit64	/* for XFS_RTBLOCKLOG macro */
 


