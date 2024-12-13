Return-Path: <linux-xfs+bounces-16642-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E5F489F0193
	for <lists+linux-xfs@lfdr.de>; Fri, 13 Dec 2024 02:07:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5295E188CCCA
	for <lists+linux-xfs@lfdr.de>; Fri, 13 Dec 2024 01:07:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A23A853BE;
	Fri, 13 Dec 2024 01:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YsNvcZJI"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 628468BEC
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734052042; cv=none; b=haXr1gIXFBmis3W4102lDzkZpBxChfvn7Va5z9QYs0WKSRuCnd/YS1p6OFkYeDln9/Ifsl0A+kMxYS5brKjGrMEGLNWGdWo4YGZ/H+pzCDe4VcNH//mxd+rVXZeWNuWT9BQjhOFPRtDK87czg+K+pwK4XrPANdFoXq79Hc2BD84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734052042; c=relaxed/simple;
	bh=OjXP98YAQyPTIXahu4LOjqi/HWos/hs+77xWhRz1mmk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qFo0gUIRyXI+vFLDzTof5gZAhBbTM4X2ewJSvvpCHG3ccoiBy0kYiQ3N7Y+BrfVcwSgVTDqDCR6VorzTqdpbFJP9eC0q71phvsZa7FhemBVmnACo/VSTcmBhZ5TMkJsK+TV/EB9Lrx9sGK//8Lq/TUzaW6duWgf7/WZEPu0Ie2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YsNvcZJI; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0465AC4CED3;
	Fri, 13 Dec 2024 01:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734052042;
	bh=OjXP98YAQyPTIXahu4LOjqi/HWos/hs+77xWhRz1mmk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YsNvcZJIpQWNSl9MSgrDhWA50/Ln1XmiScrapgu6kYNYo+y7o2A8rYF6NFkejTH9O
	 l9atG68CYPie6ZLyyzBfO8ae4dtU8r7ggo1SsOwCuIT+x2cTb/VLYD143Z9kAEQnxE
	 00DIR8nHByKFfJb3toMUghSY/guOQeGTCWULD1/OtOI0aU6uvXDx1ccmAsEOlg1ly+
	 5mAZzcuAKPAdmwxkNMSz2hrpsSPzJMZCHOqls7M9WJCZQjDbCcrxaLik0VegiEtfru
	 xlejmn7N42MTvDGr21UshhBSH1i9jdSpeSsV2iH7LH43pZMjPOB8/t6amHrbvFeIh+
	 V6vaMkSmuV3+g==
Date: Thu, 12 Dec 2024 17:07:21 -0800
Subject: [PATCH 26/37] xfs: walk the rt reverse mapping tree when rebuilding
 rmap
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405123761.1181370.4118391090133986822.stgit@frogsfrogsfrogs>
In-Reply-To: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

When we're rebuilding the data device rmap, if we encounter an "rmap"
format fork, we have to walk the (realtime) rmap btree inode to build
the appropriate mappings.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/rmap_repair.c |   53 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 52 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/rmap_repair.c b/fs/xfs/scrub/rmap_repair.c
index 2a0b9e3d0fbaee..91c17feb49768b 100644
--- a/fs/xfs/scrub/rmap_repair.c
+++ b/fs/xfs/scrub/rmap_repair.c
@@ -31,6 +31,8 @@
 #include "xfs_refcount.h"
 #include "xfs_refcount_btree.h"
 #include "xfs_ag.h"
+#include "xfs_rtrmap_btree.h"
+#include "xfs_rtgroup.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -504,7 +506,56 @@ xrep_rmap_scan_meta_btree(
 	struct xrep_rmap_ifork	*rf,
 	struct xfs_inode	*ip)
 {
-	return -EFSCORRUPTED; /* XXX placeholder */
+	struct xfs_scrub	*sc = rf->rr->sc;
+	struct xfs_rtgroup	*rtg = NULL;
+	struct xfs_btree_cur	*cur = NULL;
+	enum xfs_rtg_inodes	type;
+	int			error;
+
+	if (rf->whichfork != XFS_DATA_FORK)
+		return -EFSCORRUPTED;
+
+	switch (ip->i_metatype) {
+	case XFS_METAFILE_RTRMAP:
+		type = XFS_RTGI_RMAP;
+		break;
+	default:
+		ASSERT(0);
+		return -EFSCORRUPTED;
+	}
+
+	while ((rtg = xfs_rtgroup_next(sc->mp, rtg))) {
+		if (ip == rtg->rtg_inodes[type])
+			goto found;
+	}
+
+	/*
+	 * We should never find an rt metadata btree inode that isn't
+	 * associated with an rtgroup yet has ondisk blocks allocated to it.
+	 */
+	if (ip->i_nblocks) {
+		ASSERT(0);
+		return -EFSCORRUPTED;
+	}
+
+	return 0;
+
+found:
+	switch (ip->i_metatype) {
+	case XFS_METAFILE_RTRMAP:
+		cur = xfs_rtrmapbt_init_cursor(sc->tp, rtg);
+		break;
+	default:
+		ASSERT(0);
+		error = -EFSCORRUPTED;
+		goto out_rtg;
+	}
+
+	error = xrep_rmap_scan_iroot_btree(rf, cur);
+	xfs_btree_del_cursor(cur, error);
+out_rtg:
+	xfs_rtgroup_rele(rtg);
+	return error;
 }
 
 /* Find all the extents from a given AG in an inode fork. */


