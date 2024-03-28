Return-Path: <linux-xfs+bounces-5262-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5939687F29E
	for <lists+linux-xfs@lfdr.de>; Mon, 18 Mar 2024 22:53:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B4343B214EE
	for <lists+linux-xfs@lfdr.de>; Mon, 18 Mar 2024 21:53:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7DCB59B53;
	Mon, 18 Mar 2024 21:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VhstJViY"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71BA59B4C
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 21:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710798777; cv=none; b=PBD88f1N2YN1GinDCRmmY+VMN+HrFXL1WT5HcAobGBF/N91c9U3v0AnohuEIscW/4qnjYclL2x1Wz3pGt5zzfyKEgaJPlQXRhFhJmSrr6tLKamhpzIWJB9d4GPlYQM3h9g6Wl0Bqgb6ymnOhO+cs82k2RrLk/TUN4IMK5a72sHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710798777; c=relaxed/simple;
	bh=pNVSyFRbCTev1RHO5jqKDxefL+HM7kqFuebx6n2Pgl4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i3QP5WhP9xgm3/iyZc6q4xHe0FpGWE52SHCAovZwrgD7pCo7jKHY9DWaafcTR8IFFoVLiWt0UyR08H4cf1UNQHxtKuf6SASDtpWueS9oOEK2sWXfkZeAnJC/YTH1Pdpw+190Yiz+QEf9adVSBFneIIgO79xLXwxYzmGLNEWYq/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VhstJViY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B350C433C7;
	Mon, 18 Mar 2024 21:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710798777;
	bh=pNVSyFRbCTev1RHO5jqKDxefL+HM7kqFuebx6n2Pgl4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=VhstJViYRl1p9/F0rIFdQhlYNteA29K0WyR1TUiEqeF1PoUB/LZ1cTWhD34SHoDNI
	 nMzBObSFe2FnvJD+HJzHVanou9RuFASqJpH8it8aB/OZRsEiwis2FqIKe+Ak6IaR8x
	 SFkXJd37TUYUhqS9cJbZADn2mvfJdloEqiwcQGeU6oDF/+vvzmJ/jTzMi3r3/+k+GP
	 p7PMXsPoV4QooUgpEMDJtOc9kAi30J4z5gODryboh1exccHA+55wLp8lbgeg4MOfZz
	 FfKEGVr7WCoUPW/ViXL7HM3b43edG1iztBZ7ReYJc5yb4/X/IGbbc/pAKSRb3gWb9n
	 v4yylbLjdnhoA==
Date: Mon, 18 Mar 2024 14:52:57 -0700
Subject: [PATCH 19/23] xfs: split xfs_bmap_add_attrfork into two pieces
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: allison.henderson@oracle.com, catherine.hoang@oracle.com,
 linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171079803003.3808642.4919701143105996298.stgit@frogsfrogsfrogs>
In-Reply-To: <171079802637.3808642.13167687091088855153.stgit@frogsfrogsfrogs>
References: <171079802637.3808642.13167687091088855153.stgit@frogsfrogsfrogs>
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

Split this function into two pieces -- one to make the actual changes to
the inode core to add the attr fork, and another one to deal with
getting the transaction and locking the inodes.

The next couple of patches will need this to be split into two.  One
patch implements committing new parent pointer recordsets to damaged
files.  If one file has an attr fork and the other does not, we have to
create the missing attr fork before the atomic swap transaction, and can
use the behavior encoded in the current xfs_bmap_add_attrfork.

The second patch adapts /lost+found adoptions to handle parent pointers
correctly.  The adoption process will add a parent pointer to a child
that is being moved to /lost+found, but this requires that the attr fork
already exists.  We don't know if we're actually going to commit the
adoption until we've already reserved a transaction and taken the
ILOCKs, which means that we must have a way to bypass the start of the
current xfs_bmap_add_attrfork.

Therefore, create xfs_attr_add_fork as the helper that creates a
transaction and takes locks; and make xfs_bmap_add_attrfork the function
that updates the inode core and allocates the incore attr fork.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c |   39 ++++++++++++++++++++++++++++++++++++++-
 fs/xfs/libxfs/xfs_bmap.c |   36 ++++++++++--------------------------
 fs/xfs/libxfs/xfs_bmap.h |    3 ++-
 3 files changed, 50 insertions(+), 28 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 1c1ac2232dfad..c5fc3cafbe4e8 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -941,6 +941,43 @@ xfs_attr_defer_add(
 	trace_xfs_attr_defer_add(new->xattri_dela_state, args->dp);
 }
 
+STATIC int
+xfs_attr_add_fork(
+	struct xfs_inode	*ip,		/* incore inode pointer */
+	int			size,		/* space new attribute needs */
+	int			rsvd)		/* xact may use reserved blks */
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_trans	*tp;		/* transaction pointer */
+	unsigned int		blks;		/* space reservation */
+	int			error;		/* error return value */
+
+	ASSERT(!XFS_NOT_DQATTACHED(mp, ip));
+
+	blks = XFS_ADDAFORK_SPACE_RES(mp);
+
+	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_addafork, blks, 0,
+			rsvd, &tp);
+	if (error)
+		return error;
+
+	if (xfs_inode_has_attr_fork(ip))
+		goto trans_cancel;
+
+	error = xfs_bmap_add_attrfork(tp, ip, size, rsvd);
+	if (error)
+		goto trans_cancel;
+
+	error = xfs_trans_commit(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return error;
+
+trans_cancel:
+	xfs_trans_cancel(tp);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return error;
+}
+
 /*
  * Note: If args->value is NULL the attribute will be removed, just like the
  * Linux ->setattr API.
@@ -992,7 +1029,7 @@ xfs_attr_set(
 				xfs_attr_sf_entsize_byname(args->namelen,
 						args->valuelen);
 
-			error = xfs_bmap_add_attrfork(dp, sf_size, rsvd);
+			error = xfs_attr_add_fork(dp, sf_size, rsvd);
 			if (error)
 				return error;
 		}
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 83cbefc54e1f3..85194a831b445 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1025,38 +1025,29 @@ xfs_bmap_set_attrforkoff(
 }
 
 /*
- * Convert inode from non-attributed to attributed.
- * Must not be in a transaction, ip must not be locked.
+ * Convert inode from non-attributed to attributed.  Caller must hold the
+ * ILOCK_EXCL and the file cannot have an attr fork.
  */
 int						/* error code */
 xfs_bmap_add_attrfork(
-	xfs_inode_t		*ip,		/* incore inode pointer */
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,		/* incore inode pointer */
 	int			size,		/* space new attribute needs */
 	int			rsvd)		/* xact may use reserved blks */
 {
-	xfs_mount_t		*mp;		/* mount structure */
-	xfs_trans_t		*tp;		/* transaction pointer */
-	int			blks;		/* space reservation */
+	struct xfs_mount	*mp = tp->t_mountp;
 	int			version = 1;	/* superblock attr version */
 	int			logflags;	/* logging flags */
 	int			error;		/* error return value */
 
-	mp = ip->i_mount;
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(!XFS_NOT_DQATTACHED(mp, ip));
-
-	blks = XFS_ADDAFORK_SPACE_RES(mp);
-
-	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_addafork, blks, 0,
-			rsvd, &tp);
-	if (error)
-		return error;
-	if (xfs_inode_has_attr_fork(ip))
-		goto trans_cancel;
+	ASSERT(!xfs_inode_has_attr_fork(ip));
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	error = xfs_bmap_set_attrforkoff(ip, size, &version);
 	if (error)
-		goto trans_cancel;
+		return error;
 
 	xfs_ifork_init_attr(ip, XFS_DINODE_FMT_EXTENTS, 0);
 	logflags = 0;
@@ -1077,7 +1068,7 @@ xfs_bmap_add_attrfork(
 	if (logflags)
 		xfs_trans_log_inode(tp, ip, logflags);
 	if (error)
-		goto trans_cancel;
+		return error;
 	if (!xfs_has_attr(mp) ||
 	   (!xfs_has_attr2(mp) && version == 2)) {
 		bool log_sb = false;
@@ -1096,14 +1087,7 @@ xfs_bmap_add_attrfork(
 			xfs_log_sb(tp);
 	}
 
-	error = xfs_trans_commit(tp);
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	return error;
-
-trans_cancel:
-	xfs_trans_cancel(tp);
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	return error;
+	return 0;
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 32fb2a455c294..e98849eb9bbae 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -176,7 +176,8 @@ int	xfs_bmap_longest_free_extent(struct xfs_perag *pag,
 void	xfs_trim_extent(struct xfs_bmbt_irec *irec, xfs_fileoff_t bno,
 		xfs_filblks_t len);
 unsigned int xfs_bmap_compute_attr_offset(struct xfs_mount *mp);
-int	xfs_bmap_add_attrfork(struct xfs_inode *ip, int size, int rsvd);
+int	xfs_bmap_add_attrfork(struct xfs_trans *tp, struct xfs_inode *ip,
+		int size, int rsvd);
 void	xfs_bmap_local_to_extents_empty(struct xfs_trans *tp,
 		struct xfs_inode *ip, int whichfork);
 int xfs_bmap_local_to_extents(struct xfs_trans *tp, struct xfs_inode *ip,


