Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8D153E9BC4
	for <lists+linux-xfs@lfdr.de>; Thu, 12 Aug 2021 02:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233111AbhHLA7M (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 11 Aug 2021 20:59:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:36428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233084AbhHLA7M (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 11 Aug 2021 20:59:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06AD560FE6;
        Thu, 12 Aug 2021 00:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628729928;
        bh=m27Uzkh5BF+9Td2mrbyqQ59muNinCeO33EqbBG/UTMQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=FHeXhAWW413aGGy3zu4IayOdos+jREsgCpstYRom/2myJhX5j/wM34M8/doGAVNHg
         /bmalG5byw8IvooS7V5bh4PXODMHUkL0OCsAtqAywRtdiMATbRGk2+AEJ5jNArkVQG
         ebRF4XOwOlXJcNjDi2CLouF1r34T6WUQZdAZZDalWPqlBzCTw/XeMIiinD35q16LRr
         FzjksWlqG//xgpx5W+RrXYVyR0NqcOzQYoIX8fhJZqbahrQIC7RXDDJ05pVRMQiHyd
         VjlO+EEeUQBKByvsrLUSFdY6Mh3WubPZxCWHTxnAHJtC9YuauzsBHSAv7C7LjAF8PA
         lIFNOc7fi883w==
Subject: [PATCH 2/3] xfs: fix off-by-one error when the last rt extent is in
 use
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 11 Aug 2021 17:58:47 -0700
Message-ID: <162872992772.1220643.10308054638747493338.stgit@magnolia>
In-Reply-To: <162872991654.1220643.136984377220187940.stgit@magnolia>
References: <162872991654.1220643.136984377220187940.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The fsmap implementation for realtime devices uses the gap between
info->next_daddr and a free rtextent reported by xfs_rtalloc_query_range
to feed userspace fsmap records with an "unknown" owner.  We use this
trick to report to userspace when the last rtextent in the filesystem is
in use by synthesizing a null rmap record starting at the next block
after the query range.

Unfortunately, there's a minor accounting bug in the way that we
construct the null rmap record.  Originally, ahigh.ar_startext contains
the last rtextent for which the user wants records.  It's entirely
possible that number is beyond the end of the rt volume, so the location
synthesized rmap record /must/ be constrained to the minimum of the high
key and the number of extents in the rt volume.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsmap.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)


diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 7d0b09c1366e..a0e8ab58124b 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -523,27 +523,39 @@ xfs_getfsmap_rtdev_rtbitmap_query(
 {
 	struct xfs_rtalloc_rec		alow = { 0 };
 	struct xfs_rtalloc_rec		ahigh = { 0 };
+	struct xfs_mount		*mp = tp->t_mountp;
 	int				error;
 
-	xfs_ilock(tp->t_mountp->m_rbmip, XFS_ILOCK_SHARED);
+	xfs_ilock(mp->m_rbmip, XFS_ILOCK_SHARED);
 
+	/*
+	 * Set up query parameters to return free extents covering the range we
+	 * want.
+	 */
 	alow.ar_startext = info->low.rm_startblock;
+	do_div(alow.ar_startext, mp->m_sb.sb_rextsize);
+
 	ahigh.ar_startext = info->high.rm_startblock;
-	do_div(alow.ar_startext, tp->t_mountp->m_sb.sb_rextsize);
-	if (do_div(ahigh.ar_startext, tp->t_mountp->m_sb.sb_rextsize))
+	if (do_div(ahigh.ar_startext, mp->m_sb.sb_rextsize))
 		ahigh.ar_startext++;
+
 	error = xfs_rtalloc_query_range(tp, &alow, &ahigh,
 			xfs_getfsmap_rtdev_rtbitmap_helper, info);
 	if (error)
 		goto err;
 
-	/* Report any gaps at the end of the rtbitmap */
+	/*
+	 * Report any gaps at the end of the rtbitmap by simulating a null
+	 * rmap starting at the block after the end of the query range.
+	 */
 	info->last = true;
+	ahigh.ar_startext = min(mp->m_sb.sb_rextents, ahigh.ar_startext);
+
 	error = xfs_getfsmap_rtdev_rtbitmap_helper(tp, &ahigh, info);
 	if (error)
 		goto err;
 err:
-	xfs_iunlock(tp->t_mountp->m_rbmip, XFS_ILOCK_SHARED);
+	xfs_iunlock(mp->m_rbmip, XFS_ILOCK_SHARED);
 	return error;
 }
 

