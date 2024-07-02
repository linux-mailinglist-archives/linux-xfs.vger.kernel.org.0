Return-Path: <linux-xfs+bounces-10104-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E62E91EC74
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Jul 2024 03:13:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B0E741C21734
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Jul 2024 01:13:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E20BB664;
	Tue,  2 Jul 2024 01:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SVwsqxdu"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1086B64A
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 01:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719882830; cv=none; b=NqX1IhW5ab+Ig/RIcXsLL0am22dLbxjdF90ix6tqMKuHw0TZ6JSVAX7KPjz1EKoV4DUuocdEKzvKQkJvsfdFs3x6sWfwz+7s1ClWXIOo2F/Rhnb2/jrpvvCub+yO9+gN34uyyRdaGI0RpMsTdD58dPnyzis987p3vvfIcqWisAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719882830; c=relaxed/simple;
	bh=M5oLKLzDHuQZAm6KPyy4q/Sf5bAiLLsP/lsfmmT7FSs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ub1kRlxchxUWfxssp3i0MUpv7u2Ul6ZdXbCDcgz+oo02+/fZ1BmANduFDrJ2uLRv3GMD/03qtB8kFov9R0uK0ToTvNBiKSVnWlh+rtsK2IM75Z4O0IPo2vxXlTY9gbUkPkHGMpRxGN1BRuSECLEgNVQT+vAq15VVSy60b5iaEH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SVwsqxdu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3171C116B1;
	Tue,  2 Jul 2024 01:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719882829;
	bh=M5oLKLzDHuQZAm6KPyy4q/Sf5bAiLLsP/lsfmmT7FSs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SVwsqxduC4gPPTohlojYV5kUBqbaJP8EiEVQztCj7tU8blPlo+P8jFqwUjwrhHjkw
	 CZZOKoGe+qgMJ/FdOOIGt4r2O8oEVFkCUGz6jYuGEb6YYQSw+nB89ALW/yNPTY4Dw0
	 iv8UZMIdSSF1n0Bo5MbMJSGk9wA46tfZkifOLtp/OKaGC+3GmUpc9W3QO6iSZ26yRR
	 Fs0GSOlptuoRlP1EDQ6q5Yukly4DjCs8lUlp52sFGLIabLzS7fRKnnvUtJWFbYjeX/
	 tNKlPOF3+8Ao4w8AhOe8uYN4cJjcJx6HhnhLl39RtX91kCp+PdVKDSXh4uzg+NRh1G
	 DR0yh01/65Mjw==
Date: Mon, 01 Jul 2024 18:13:49 -0700
Subject: [PATCH 12/24] xfs_scrub: use parent pointers to report lost file data
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: catherine.hoang@oracle.com, linux-xfs@vger.kernel.org,
 allison.henderson@oracle.com, hch@lst.de
Message-ID: <171988121248.2009260.17262926858268275665.stgit@frogsfrogsfrogs>
In-Reply-To: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs>
References: <171988121023.2009260.1161835936170460985.stgit@frogsfrogsfrogs>
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

If parent pointers are enabled, compute the path to the file while we're
doing the fsmap scan and report that, instead of walking the entire
directory tree to print the paths of the (hopefully few) files that lost
data.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase6.c |   75 +++++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 63 insertions(+), 12 deletions(-)


diff --git a/scrub/phase6.c b/scrub/phase6.c
index 193d3b4e9083..a61853019e29 100644
--- a/scrub/phase6.c
+++ b/scrub/phase6.c
@@ -22,6 +22,7 @@
 #include "spacemap.h"
 #include "vfs.h"
 #include "common.h"
+#include "libfrog/bulkstat.h"
 
 /*
  * Phase 6: Verify data file integrity.
@@ -381,6 +382,24 @@ report_dirent_loss(
 	return error;
 }
 
+struct ioerr_filerange {
+	uint64_t		physical;
+	uint64_t		length;
+};
+
+/*
+ * If reverse mapping and parent pointers are enabled, we can map media errors
+ * directly back to a filename and a file position without needing to walk the
+ * directory tree.
+ */
+static inline bool
+can_use_pptrs(
+	const struct scrub_ctx	*ctx)
+{
+	return  (ctx->mnt.fsgeom.flags & XFS_FSOP_GEOM_FLAGS_PARENT) &&
+		(ctx->mnt.fsgeom.flags & XFS_FSOP_GEOM_FLAGS_RMAPBT);
+}
+
 /* Use a fsmap to report metadata lost to a media error. */
 static int
 report_ioerr_fsmap(
@@ -389,16 +408,18 @@ report_ioerr_fsmap(
 	void			*arg)
 {
 	const char		*type;
+	struct xfs_bulkstat	bs = { };
 	char			buf[DESCR_BUFSZ];
-	uint64_t		err_physical = *(uint64_t *)arg;
+	struct ioerr_filerange	*fr = arg;
 	uint64_t		err_off;
+	int			ret;
 
 	/* Don't care about unwritten extents. */
 	if (map->fmr_flags & FMR_OF_PREALLOC)
 		return 0;
 
-	if (err_physical > map->fmr_physical)
-		err_off = err_physical - map->fmr_physical;
+	if (fr->physical > map->fmr_physical)
+		err_off = fr->physical - map->fmr_physical;
 	else
 		err_off = 0;
 
@@ -421,23 +442,43 @@ report_ioerr_fsmap(
 		}
 	}
 
+	if (can_use_pptrs(ctx)) {
+		ret = -xfrog_bulkstat_single(&ctx->mnt, map->fmr_owner, 0, &bs);
+		if (ret)
+			str_liberror(ctx, ret,
+					_("bulkstat for media error report"));
+	}
+
 	/* Report extent maps */
 	if (map->fmr_flags & FMR_OF_EXTENT_MAP) {
 		bool		attr = (map->fmr_flags & FMR_OF_ATTR_FORK);
 
 		scrub_render_ino_descr(ctx, buf, DESCR_BUFSZ,
-				map->fmr_owner, 0, " %s",
+				map->fmr_owner, bs.bs_gen, " %s",
 				attr ? _("extended attribute") :
 				       _("file data"));
 		str_corrupt(ctx, buf, _("media error in extent map"));
 	}
 
 	/*
-	 * XXX: If we had a getparent() call we could report IO errors
-	 * efficiently.  Until then, we'll have to scan the dir tree
-	 * to find the bad file's pathname.
+	 * If directory parent pointers are available, use that to find the
+	 * pathname to a file, and report that path as having lost its
+	 * extended attributes, or the precise offset of the lost file data.
 	 */
+	if (!can_use_pptrs(ctx))
+		return 0;
 
+	scrub_render_ino_descr(ctx, buf, DESCR_BUFSZ, map->fmr_owner,
+			bs.bs_gen, NULL);
+
+	if (map->fmr_flags & FMR_OF_ATTR_FORK) {
+		str_corrupt(ctx, buf, _("media error in extended attributes"));
+		return 0;
+	}
+
+	str_unfixable_error(ctx, buf,
+ _("media error at data offset %llu length %llu."),
+			err_off, fr->length);
 	return 0;
 }
 
@@ -452,6 +493,10 @@ report_ioerr(
 	void				*arg)
 {
 	struct fsmap			keys[2];
+	struct ioerr_filerange		fr = {
+		.physical		= start,
+		.length			= length,
+	};
 	struct disk_ioerr_report	*dioerr = arg;
 	dev_t				dev;
 
@@ -467,7 +512,7 @@ report_ioerr(
 	(keys + 1)->fmr_offset = ULLONG_MAX;
 	(keys + 1)->fmr_flags = UINT_MAX;
 	return -scrub_iterate_fsmap(dioerr->ctx, keys, report_ioerr_fsmap,
-			&start);
+			&fr);
 }
 
 /* Report all the media errors found on a disk. */
@@ -511,10 +556,16 @@ report_all_media_errors(
 		return ret;
 	}
 
-	/* Scan the directory tree to get file paths. */
-	ret = scan_fs_tree(ctx, report_dir_loss, report_dirent_loss, vs);
-	if (ret)
-		return ret;
+	/*
+	 * Scan the directory tree to get file paths if we didn't already use
+	 * directory parent pointers to report the loss.
+	 */
+	if (!can_use_pptrs(ctx)) {
+		ret = scan_fs_tree(ctx, report_dir_loss, report_dirent_loss,
+				vs);
+		if (ret)
+			return ret;
+	}
 
 	/* Scan for unlinked files. */
 	return scrub_scan_all_inodes(ctx, report_inode_loss, vs);


