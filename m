Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63AC3336A5A
	for <lists+linux-xfs@lfdr.de>; Thu, 11 Mar 2021 04:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhCKDGg (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 10 Mar 2021 22:06:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:45888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229928AbhCKDGb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Mar 2021 22:06:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07C3264FC4;
        Thu, 11 Mar 2021 03:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615431991;
        bh=1VrstQJy5J9ECetOJMSTJJz1514eIi30YkNmcMekSaQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WLnZovycUGMw/dPorb3Nv/lJ2JNlC9IgHIa3vw/CK/HEGjNX+i5inWtT2GI9sTZJY
         vGQFfmY0MnHPwqvCb4AxVV0HMYD7d0216xKiXjSXoG2yG71jhZs17iiwcExrmPxDBG
         rzDCpDGj3hmMxQzy7/JYU0qopow93CXAyxWhgTDkoZDbS/eoYuK0pNoIn9ozyMuFu3
         quZV4NF9YvTkvLUz6EFXWB11uIp+mY5ExSrKeiA/H7a1rNTf83626LDDqvnvUzKnDl
         HATNKwm8L+9jfqaeGPdipUNpj8VdAglGjvu2DoFDyQdp4QC6GfDyA9TYgpTl9EtjVX
         fREwfM6/N+6FQ==
Subject: [PATCH 09/11] xfs: force inode garbage collection before fallocate
 when space is low
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 10 Mar 2021 19:06:30 -0800
Message-ID: <161543199062.1947934.17280004993407696065.stgit@magnolia>
In-Reply-To: <161543194009.1947934.9910987247994410125.stgit@magnolia>
References: <161543194009.1947934.9910987247994410125.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Generally speaking, when a user calls fallocate, they're looking to
preallocate space in a file in the largest contiguous chunks possible.
If free space is low, it's possible that the free space will look
unnecessarily fragmented because there are unlinked inodes that are
holding on to space that we could allocate.  When this happens,
fallocate makes suboptimal allocation decisions for the sake of deleted
files, which doesn't make much sense, so scan the filesystem for dead
items to delete to try to avoid this.

Note that there are a handful of fstests that fill a filesystem, delete
just enough files to allow a single large allocation, and check that
fallocate actually gets the allocation.  These tests regress because the
test runs fallocate before the inode gc has a chance to run, so add this
behavior to maintain as much of the old behavior as possible.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_bmap_util.c |   44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)


diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 21aa38183ae9..6d2fece45bdc 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -28,6 +28,7 @@
 #include "xfs_icache.h"
 #include "xfs_iomap.h"
 #include "xfs_reflink.h"
+#include "xfs_sb.h"
 
 /* Kernel only BMAP related definitions and functions */
 
@@ -733,6 +734,44 @@ xfs_free_eofblocks(
 	return error;
 }
 
+/*
+ * If we suspect that the target device is full enough that it isn't to be able
+ * to satisfy the entire request, try a non-sync inode inactivation scan to
+ * free up space.  While it's perfectly fine to fill a preallocation request
+ * with a bunch of short extents, we'd prefer to do the inactivation work now
+ * to combat long term fragmentation in new file data.  This is purely for
+ * optimization, so we don't take any blocking locks and we only look for space
+ * that is already on the reclaim list (i.e. we don't zap speculative
+ * preallocations).
+ */
+static int
+xfs_alloc_reclaim_inactive_space(
+	struct xfs_mount	*mp,
+	bool			is_rt,
+	xfs_filblks_t		allocatesize_fsb)
+{
+	struct xfs_perag	*pag;
+	struct xfs_sb		*sbp = &mp->m_sb;
+	xfs_extlen_t		free;
+	xfs_agnumber_t		agno;
+
+	if (is_rt) {
+		if (sbp->sb_frextents * sbp->sb_rextsize >= allocatesize_fsb)
+			return 0;
+	} else {
+		for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+			pag = xfs_perag_get(mp, agno);
+			free = pag->pagf_freeblks;
+			xfs_perag_put(pag);
+
+			if (free >= allocatesize_fsb)
+				return 0;
+		}
+	}
+
+	return xfs_inodegc_free_space(mp, NULL);
+}
+
 int
 xfs_alloc_file_space(
 	struct xfs_inode	*ip,
@@ -817,6 +856,11 @@ xfs_alloc_file_space(
 			rblocks = 0;
 		}
 
+		error = xfs_alloc_reclaim_inactive_space(mp, rt,
+				allocatesize_fsb);
+		if (error)
+			break;
+
 		/*
 		 * Allocate and setup the transaction.
 		 */

