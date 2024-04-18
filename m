Return-Path: <linux-xfs+bounces-7195-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B2D738A8F39
	for <lists+linux-xfs@lfdr.de>; Thu, 18 Apr 2024 01:13:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E50F282948
	for <lists+linux-xfs@lfdr.de>; Wed, 17 Apr 2024 23:13:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 514C884E1B;
	Wed, 17 Apr 2024 23:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XtroggfV"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1265B28DB3
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 23:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713395633; cv=none; b=caIFSBopoqJh2QRdw4v+zESto+X6xkZknMMD0OYT0pl119gmkKwF/fMsob9fj7JW9GMgtXHCzUvW5KwoxieL7v2vz1N9vW2k2Cjui50ncXxmy+jNLZF+pAVELsitnhxGKAjstJ7dHElxT/bKI1sY44yS5zspvm7Qh/HJpPlHYTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713395633; c=relaxed/simple;
	bh=6XBTjlLiL2e8uw+cJZ8O5CXWGIBrzOp71GcOBeIoc5I=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sSb1wt8i9ds5KLqS91t0P4xLQ7ktOPSUZusaXGevohfiWdzWLmhb+vmD+OTbpbioamQCyQR+hZY8exUaXKH4cO8W3kAd++xYyi72WXVdeQjcTmpgATJA5xW5kpR68bKpbrTULQVAfBZESnbM+3PKTPwUTwXX5JXE4OWnJBXFLBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XtroggfV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D622C072AA;
	Wed, 17 Apr 2024 23:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713395632;
	bh=6XBTjlLiL2e8uw+cJZ8O5CXWGIBrzOp71GcOBeIoc5I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XtroggfVQoCvfomDrSjPoZrI97XraoSwZmb1WVGWlVfguHwUYjJ57U9TEqzBPvVB0
	 87YGslYvCtrRzHXkZUr7YPCHZr5prhmazw94MrWfghNhQ3kaUufpSp1k5FZNW5fv2T
	 w7LM/i6uDQYT2cgfvXdCahS7HEughlBSdQwEe9524ff5D8uCaBPYl5YkZOey49YN5L
	 fV5PyFqmFuGSJZpczxjxDKh3VcTO+AAMY2W2t761IlK6S7nqCttArZmdtzgwTIgxUd
	 a0LYMx5vT74WNrcujXON5GApODSKqnABz+jDmMvOCwWsyCTEGCqizgQZnTDTFWMTOj
	 iW4BOxCgqU/7g==
Date: Wed, 17 Apr 2024 16:13:52 -0700
Subject: [PATCH 1/2] xfs: use dontcache for grabbing inodes during scrub
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@infradead.org, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171339555581.1999874.6289959953441529247.stgit@frogsfrogsfrogs>
In-Reply-To: <171339555559.1999874.4456227116424200314.stgit@frogsfrogsfrogs>
References: <171339555559.1999874.4456227116424200314.stgit@frogsfrogsfrogs>
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

Back when I wrote commit a03297a0ca9f2, I had thought that we'd be doing
users a favor by only marking inodes dontcache at the end of a scrub
operation, and only if there's only one reference to that inode.  This
was more or less true back when I_DONTCACHE was an XFS iflag and the
only thing it did was change the outcome of xfs_fs_drop_inode to 1.

Note: If there are dentries pointing to the inode when scrub finishes,
the inode will have positive i_count and stay around in cache until
dentry reclaim.

But now we have d_mark_dontcache, which cause the inode *and* the
dentries attached to it all to be marked I_DONTCACHE, which means that
we drop the dentries ASAP, which drops the inode ASAP.

This is bad if scrub found problems with the inode, because now they can
be scheduled for inactivation, which can cause inodegc to trip on it and
shut down the filesystem.

Even if the inode isn't bad, this is still suboptimal because phases 3-7
each initiate inode scans.  Dropping the inode immediately during phase
3 is silly because phase 5 will reload it and drop it immediately, etc.
It's fine to mark the inodes dontcache, but if there have been accesses
to the file that set up dentries, we should keep them.

I validated this by setting up ftrace to capture xfs_iget_recycle*
tracepoints and ran xfs/285 for 30 seconds.  With current djwong-wtf I
saw ~30,000 recycle events.  I then dropped the d_mark_dontcache calls
and set XFS_IGET_DONTCACHE, and the recycle events dropped to ~5,000 per
30 seconds.

Therefore, grab the inode with XFS_IGET_DONTCACHE, which only has the
effect of setting I_DONTCACHE for cache misses.  Remove the
d_mark_dontcache call that can happen in xchk_irele.

Fixes: a03297a0ca9f2 ("xfs: manage inode DONTCACHE status at irele time")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/common.c |   12 +++---------
 fs/xfs/scrub/iscan.c  |   13 +++++++++++--
 fs/xfs/scrub/scrub.h  |    7 +++++++
 3 files changed, 21 insertions(+), 11 deletions(-)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 48302532d10d1..c3612419c9f8a 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -782,7 +782,7 @@ xchk_iget(
 {
 	ASSERT(sc->tp != NULL);
 
-	return xfs_iget(sc->mp, sc->tp, inum, XFS_IGET_UNTRUSTED, 0, ipp);
+	return xfs_iget(sc->mp, sc->tp, inum, XCHK_IGET_FLAGS, 0, ipp);
 }
 
 /*
@@ -833,8 +833,8 @@ xchk_iget_agi(
 	if (error)
 		return error;
 
-	error = xfs_iget(mp, tp, inum,
-			XFS_IGET_NORETRY | XFS_IGET_UNTRUSTED, 0, ipp);
+	error = xfs_iget(mp, tp, inum, XFS_IGET_NORETRY | XCHK_IGET_FLAGS, 0,
+			ipp);
 	if (error == -EAGAIN) {
 		/*
 		 * The inode may be in core but temporarily unavailable and may
@@ -1061,12 +1061,6 @@ xchk_irele(
 		spin_lock(&VFS_I(ip)->i_lock);
 		VFS_I(ip)->i_state &= ~I_DONTCACHE;
 		spin_unlock(&VFS_I(ip)->i_lock);
-	} else if (atomic_read(&VFS_I(ip)->i_count) == 1) {
-		/*
-		 * If this is the last reference to the inode and the caller
-		 * permits it, set DONTCACHE to avoid thrashing.
-		 */
-		d_mark_dontcache(VFS_I(ip));
 	}
 
 	xfs_irele(ip);
diff --git a/fs/xfs/scrub/iscan.c b/fs/xfs/scrub/iscan.c
index c380207702e26..cf9d983667cec 100644
--- a/fs/xfs/scrub/iscan.c
+++ b/fs/xfs/scrub/iscan.c
@@ -407,6 +407,15 @@ xchk_iscan_iget_retry(
 	return -EAGAIN;
 }
 
+/*
+ * For an inode scan, we hold the AGI and want to try to grab a batch of
+ * inodes.  Holding the AGI prevents inodegc from clearing freed inodes,
+ * so we must use noretry here.  For every inode after the first one in the
+ * batch, we don't want to wait, so we use retry there too.  Finally, use
+ * dontcache to avoid polluting the cache.
+ */
+#define ISCAN_IGET_FLAGS	(XFS_IGET_NORETRY | XFS_IGET_DONTCACHE)
+
 /*
  * Grab an inode as part of an inode scan.  While scanning this inode, the
  * caller must ensure that no other threads can modify the inode until a call
@@ -434,7 +443,7 @@ xchk_iscan_iget(
 	ASSERT(iscan->__inodes[0] == NULL);
 
 	/* Fill the first slot in the inode array. */
-	error = xfs_iget(sc->mp, sc->tp, ino, XFS_IGET_NORETRY, 0,
+	error = xfs_iget(sc->mp, sc->tp, ino, ISCAN_IGET_FLAGS, 0,
 			&iscan->__inodes[idx]);
 
 	trace_xchk_iscan_iget(iscan, error);
@@ -507,7 +516,7 @@ xchk_iscan_iget(
 
 		ASSERT(iscan->__inodes[idx] == NULL);
 
-		error = xfs_iget(sc->mp, sc->tp, ino, XFS_IGET_NORETRY, 0,
+		error = xfs_iget(sc->mp, sc->tp, ino, ISCAN_IGET_FLAGS, 0,
 				&iscan->__inodes[idx]);
 		if (error)
 			break;
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 4e7e3edb6350c..1da10182f7f42 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -60,6 +60,13 @@ static inline int xchk_maybe_relax(struct xchk_relax *widget)
 #define XCHK_GFP_FLAGS	((__force gfp_t)(GFP_KERNEL | __GFP_NOWARN | \
 					 __GFP_RETRY_MAYFAIL))
 
+/*
+ * For opening files by handle for fsck operations, we don't trust the inumber
+ * or the allocation state; therefore, perform an untrusted lookup.  We don't
+ * want these inodes to pollute the cache, so mark them for immediate removal.
+ */
+#define XCHK_IGET_FLAGS	(XFS_IGET_UNTRUSTED | XFS_IGET_DONTCACHE)
+
 /* Type info and names for the scrub types. */
 enum xchk_type {
 	ST_NONE = 1,	/* disabled */


