Return-Path: <linux-xfs+bounces-13889-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E885E99989F
	for <lists+linux-xfs@lfdr.de>; Fri, 11 Oct 2024 03:05:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ECC421C22EF6
	for <lists+linux-xfs@lfdr.de>; Fri, 11 Oct 2024 01:05:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FFE6440C;
	Fri, 11 Oct 2024 01:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q2ErOEV+"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43EC7FD
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728608720; cv=none; b=Ab904PCaWhzdE3FPOVSxWd26E6OS54VW+iM/r/C7WQ2CHsBjOpoTzlwYBG4Op4Jfyyeb/SbG51oZ78VED6FcV3iOZJq+CaIkxS0iy1LMpN24ebHz5WBtyXgkvQfp9iU1Qtf+H5N4yWheOZA4vS7ZXeaIihR4rTjeg3/LSDmejxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728608720; c=relaxed/simple;
	bh=mbiy4mb6EAE03uCtTGtiCzrs6iCg0k3fMwNK1cArCTI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bmPg8l5+1VsnGGIJ70uwu59sryXT8SIjamazwjEno1oLcXlAdBlzTfUP/QhgLPT26hr6ZPpVBjSrUuBYIqudbA1gjFkaIMewXw0/aja2jJql5OyFglJ7WA24IgOGTayVPyii/XHEnuBD3oFc3yp4LZJnKmKtHdorfavUXXVSE7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q2ErOEV+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 602C2C4CEC5;
	Fri, 11 Oct 2024 01:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728608720;
	bh=mbiy4mb6EAE03uCtTGtiCzrs6iCg0k3fMwNK1cArCTI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=q2ErOEV+Bcr1iNkw0llmNJq2sTW0RnMig1hjWtj22WJVLaAJ7aLhNxTNML9D0ZK9m
	 5thqF1twBPuLRMJlz2WG1nmuihU9CZ1UK9yaJ1by9YXtLK6jZ22VlmP+5/Jck8qk99
	 cnndpXnlWF7w/SEPYvuVv4Inch37C6fLVqigMpbIkiJjNMlRbXpRWFcFpGrZ+tYVCQ
	 WXzJ7TbiCSuseGZ1wyCDOJR4rzj5mtTzdGDYYUzWObvbCmpf2F2fM/ukaatKS1v/u7
	 bD1Hw5ktBz2ygGc5oY+C3YcZ1ke6WIleoGZ7FHv7oscy2WjYP6RrIsN9ipwBgwgK/k
	 pFOnVzcn3gcyg==
Date: Thu, 10 Oct 2024 18:05:19 -0700
Subject: [PATCH 14/36] xfs: grow the realtime section when realtime groups are
 enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860644482.4178701.5468982943026708367.stgit@frogsfrogsfrogs>
In-Reply-To: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
References: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
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

Enable growing the rt section when realtime groups are enabled.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_shared.h |    1 
 fs/xfs/xfs_rtalloc.c       |  270 ++++++++++++++++++++++++++++++++++++++------
 fs/xfs/xfs_trans.c         |    9 +
 fs/xfs/xfs_trans.h         |    1 
 4 files changed, 244 insertions(+), 37 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index 9363f918675ac0..e7efdb9ceaf382 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -160,6 +160,7 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
 #define	XFS_TRANS_SB_RBLOCKS		0x00000800
 #define	XFS_TRANS_SB_REXTENTS		0x00001000
 #define	XFS_TRANS_SB_REXTSLOG		0x00002000
+#define XFS_TRANS_SB_RGCOUNT		0x00004000
 
 /*
  * Here we centralize the specification of XFS meta-data buffer reference count
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 38062c10293d6b..2093cab0cf8cb5 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -766,6 +766,31 @@ xfs_growfs_rt_alloc_fake_mount(
 	return nmp;
 }
 
+/* Free all the new space and return the number of extents actually freed. */
+static int
+xfs_growfs_rt_free_new(
+	struct xfs_rtgroup	*rtg,
+	struct xfs_rtalloc_args	*nargs,
+	xfs_rtbxlen_t		*freed_rtx)
+{
+	struct xfs_mount	*mp = rtg_mount(rtg);
+	xfs_rgnumber_t		rgno = rtg_rgno(rtg);
+	xfs_rtxnum_t		start_rtx = 0, end_rtx;
+
+	if (rgno < mp->m_sb.sb_rgcount)
+		start_rtx = xfs_rtgroup_extents(mp, rgno);
+	end_rtx = xfs_rtgroup_extents(nargs->mp, rgno);
+
+	/*
+	 * Compute the first new extent that we want to free, being careful to
+	 * skip past a realtime superblock at the start of the realtime volume.
+	 */
+	if (xfs_has_rtsb(nargs->mp) && rgno == 0 && start_rtx == 0)
+		start_rtx++;
+	*freed_rtx = end_rtx - start_rtx;
+	return xfs_rtfree_range(nargs, start_rtx, *freed_rtx);
+}
+
 static xfs_rfsblock_t
 xfs_growfs_rt_nrblocks(
 	struct xfs_rtgroup	*rtg,
@@ -786,6 +811,43 @@ xfs_growfs_rt_nrblocks(
 	return min(nrblocks, step);
 }
 
+/*
+ * If the post-grow filesystem will have an rtsb; we're initializing the first
+ * rtgroup; and the filesystem didn't have a realtime section, write the rtsb
+ * now, and attach the rtsb buffer to the real mount.
+ */
+static int
+xfs_growfs_rt_init_rtsb(
+	const struct xfs_rtalloc_args	*nargs,
+	const struct xfs_rtgroup	*rtg,
+	const struct xfs_rtalloc_args	*args)
+{
+	struct xfs_mount		*mp = args->mp;
+	struct xfs_buf			*rtsb_bp;
+	int				error;
+
+	if (!xfs_has_rtsb(nargs->mp))
+		return 0;
+	if (rtg_rgno(rtg) > 0)
+		return 0;
+	if (mp->m_sb.sb_rblocks)
+		return 0;
+
+	error = xfs_buf_get_uncached(mp->m_rtdev_targp, XFS_FSB_TO_BB(mp, 1),
+			0, &rtsb_bp);
+	if (error)
+		return error;
+
+	rtsb_bp->b_maps[0].bm_bn = XFS_RTSB_DADDR;
+	rtsb_bp->b_ops = &xfs_rtsb_buf_ops;
+
+	xfs_update_rtsb(rtsb_bp, mp->m_sb_bp);
+	mp->m_rtsb_bp = rtsb_bp;
+	error = xfs_bwrite(rtsb_bp);
+	xfs_buf_unlock(rtsb_bp);
+	return error;
+}
+
 static int
 xfs_growfs_rt_bmblock(
 	struct xfs_rtgroup	*rtg,
@@ -808,7 +870,8 @@ xfs_growfs_rt_bmblock(
 	int			error;
 
 	/*
-	 * Calculate new sb and mount fields for this round.
+	 * Calculate new sb and mount fields for this round.  Also ensure the
+	 * rtg_extents value is uptodate as the rtbitmap code relies on it.
 	 */
 	nmp = nargs.mp = xfs_growfs_rt_alloc_fake_mount(mp,
 			xfs_growfs_rt_nrblocks(rtg, nrblocks, rextsize, bmbno),
@@ -861,6 +924,10 @@ xfs_growfs_rt_bmblock(
 			goto out_cancel;
 	}
 
+	error = xfs_growfs_rt_init_rtsb(&nargs, rtg, &args);
+	if (error)
+		goto out_cancel;
+
 	/*
 	 * Update superblock fields.
 	 */
@@ -879,12 +946,14 @@ xfs_growfs_rt_bmblock(
 	if (nmp->m_sb.sb_rextslog != mp->m_sb.sb_rextslog)
 		xfs_trans_mod_sb(args.tp, XFS_TRANS_SB_REXTSLOG,
 			nmp->m_sb.sb_rextslog - mp->m_sb.sb_rextslog);
+	if (nmp->m_sb.sb_rgcount != mp->m_sb.sb_rgcount)
+		xfs_trans_mod_sb(args.tp, XFS_TRANS_SB_RGCOUNT,
+			nmp->m_sb.sb_rgcount - mp->m_sb.sb_rgcount);
 
 	/*
 	 * Free the new extent.
 	 */
-	freed_rtx = nmp->m_sb.sb_rextents - mp->m_sb.sb_rextents;
-	error = xfs_rtfree_range(&nargs, mp->m_sb.sb_rextents, freed_rtx);
+	error = xfs_growfs_rt_free_new(rtg, &nargs, &freed_rtx);
 	xfs_rtbuf_cache_relse(&nargs);
 	if (error)
 		goto out_cancel;
@@ -925,6 +994,15 @@ xfs_growfs_rt_bmblock(
 	return error;
 }
 
+static xfs_rtxnum_t
+xfs_last_rtgroup_extents(
+	struct xfs_mount	*mp)
+{
+	return mp->m_sb.sb_rextents -
+		((xfs_rtxnum_t)(mp->m_sb.sb_rgcount - 1) *
+		 mp->m_sb.sb_rgextents);
+}
+
 /*
  * Calculate the last rbmblock currently used.
  *
@@ -935,11 +1013,20 @@ xfs_last_rt_bmblock(
 	struct xfs_rtgroup	*rtg)
 {
 	struct xfs_mount	*mp = rtg_mount(rtg);
-	xfs_fileoff_t		bmbno = mp->m_sb.sb_rbmblocks;
+	xfs_rgnumber_t		rgno = rtg_rgno(rtg);
+	xfs_fileoff_t		bmbno = 0;
+
+	ASSERT(!mp->m_sb.sb_rgcount || rgno >= mp->m_sb.sb_rgcount - 1);
+
+	if (mp->m_sb.sb_rgcount && rgno == mp->m_sb.sb_rgcount - 1) {
+		xfs_rtxnum_t	nrext = xfs_last_rtgroup_extents(mp);
+
+		/* Also fill up the previous block if not entirely full. */
+		bmbno = xfs_rtbitmap_blockcount_len(mp, nrext);
+		if (xfs_rtx_to_rbmword(mp, nrext) != 0)
+			bmbno--;
+	}
 
-	/* Skip the current block if it is exactly full. */
-	if (xfs_rtx_to_rbmword(mp, mp->m_sb.sb_rextents) != 0)
-		bmbno--;
 	return bmbno;
 }
 
@@ -956,38 +1043,56 @@ xfs_growfs_rt_alloc_blocks(
 	struct xfs_mount	*mp = rtg_mount(rtg);
 	struct xfs_inode	*rbmip = rtg->rtg_inodes[XFS_RTGI_BITMAP];
 	struct xfs_inode	*rsumip = rtg->rtg_inodes[XFS_RTGI_SUMMARY];
-	xfs_extlen_t		orbmblocks;
-	xfs_extlen_t		orsumblocks;
-	xfs_extlen_t		nrsumblocks;
+	xfs_extlen_t		orbmblocks = 0;
+	xfs_extlen_t		orsumblocks = 0;
 	struct xfs_mount	*nmp;
-	int			error;
-
-	/*
-	 * Get the old block counts for bitmap and summary inodes.
-	 * These can't change since other growfs callers are locked out.
-	 */
-	orbmblocks = XFS_B_TO_FSB(mp, rbmip->i_disk_size);
-	orsumblocks = XFS_B_TO_FSB(mp, rsumip->i_disk_size);
+	int			error = 0;
 
 	nmp = xfs_growfs_rt_alloc_fake_mount(mp, nrblocks, rextsize);
 	if (!nmp)
 		return -ENOMEM;
-
 	*nrbmblocks = nmp->m_sb.sb_rbmblocks;
-	nrsumblocks = nmp->m_rsumblocks;
-	kfree(nmp);
+
+	if (xfs_has_rtgroups(mp)) {
+		/*
+		 * For file systems with the rtgroups feature, the RT bitmap and
+		 * summary are always fully allocated, which means that we never
+		 * need to grow the existing files.
+		 *
+		 * But we have to be careful to only fill the bitmap until the
+		 * end of the actually used range.
+		 */
+		if (rtg_rgno(rtg) == nmp->m_sb.sb_rgcount - 1)
+			*nrbmblocks = xfs_rtbitmap_blockcount_len(nmp,
+					xfs_last_rtgroup_extents(nmp));
+
+		if (mp->m_sb.sb_rgcount &&
+		    rtg_rgno(rtg) == mp->m_sb.sb_rgcount - 1)
+			goto out_free;
+	} else {
+		/*
+		 * Get the old block counts for bitmap and summary inodes.
+		 * These can't change since other growfs callers are locked out.
+		 */
+		orbmblocks = XFS_B_TO_FSB(mp, rbmip->i_disk_size);
+		orsumblocks = XFS_B_TO_FSB(mp, rsumip->i_disk_size);
+	}
 
 	error = xfs_rtfile_initialize_blocks(rtg, XFS_RTGI_BITMAP, orbmblocks,
-			*nrbmblocks, NULL);
+			nmp->m_sb.sb_rbmblocks, NULL);
 	if (error)
-		return error;
-	return xfs_rtfile_initialize_blocks(rtg, XFS_RTGI_SUMMARY, orsumblocks,
-			nrsumblocks, NULL);
+		goto out_free;
+	error = xfs_rtfile_initialize_blocks(rtg, XFS_RTGI_SUMMARY, orsumblocks,
+			nmp->m_rsumblocks, NULL);
+out_free:
+	kfree(nmp);
+	return error;
 }
 
 static int
 xfs_growfs_rtg(
 	struct xfs_mount	*mp,
+	xfs_rgnumber_t		rgno,
 	xfs_rfsblock_t		nrblocks,
 	xfs_agblock_t		rextsize)
 {
@@ -998,7 +1103,7 @@ xfs_growfs_rtg(
 	unsigned int		i;
 	int			error;
 
-	rtg = xfs_rtgroup_grab(mp, 0);
+	rtg = xfs_rtgroup_grab(mp, rgno);
 	if (!rtg)
 		return -EINVAL;
 
@@ -1069,14 +1174,67 @@ xfs_growfs_check_rtgeom(
 	return error;
 }
 
+/*
+ * Compute the new number of rt groups and ensure that /rtgroups exists.
+ *
+ * Changing the rtgroup size is not allowed (even if the rt volume hasn't yet
+ * been initialized) because the userspace ABI doesn't support it.
+ */
+static int
+xfs_growfs_rt_prep_groups(
+	struct xfs_mount	*mp,
+	xfs_rfsblock_t		rblocks,
+	xfs_extlen_t		rextsize,
+	xfs_rgnumber_t		*new_rgcount)
+{
+	int			error;
+
+	*new_rgcount = howmany_64(rblocks, mp->m_sb.sb_rgextents * rextsize);
+	if (*new_rgcount > XFS_MAX_RGNUMBER)
+		return -EINVAL;
+
+	/* Make sure the /rtgroups dir has been created */
+	if (!mp->m_rtdirip) {
+		struct xfs_trans	*tp;
+
+		error = xfs_trans_alloc_empty(mp, &tp);
+		if (error)
+			return error;
+		error = xfs_rtginode_load_parent(tp);
+		xfs_trans_cancel(tp);
+
+		if (error == -ENOENT)
+			error = xfs_rtginode_mkdir_parent(mp);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
+
+static bool
+xfs_grow_last_rtg(
+	struct xfs_mount	*mp)
+{
+	if (!xfs_has_rtgroups(mp))
+		return true;
+	if (mp->m_sb.sb_rgcount == 0)
+		return false;
+	return xfs_rtgroup_extents(mp, mp->m_sb.sb_rgcount - 1) <=
+			mp->m_sb.sb_rgextents;
+}
+
 /*
  * Grow the realtime area of the filesystem.
  */
 int
 xfs_growfs_rt(
-	xfs_mount_t	*mp,		/* mount point for filesystem */
-	xfs_growfs_rt_t	*in)		/* growfs rt input struct */
+	struct xfs_mount	*mp,
+	struct xfs_growfs_rt	*in)
 {
+	xfs_rgnumber_t		old_rgcount = mp->m_sb.sb_rgcount;
+	xfs_rgnumber_t		new_rgcount = 1;
+	xfs_rgnumber_t		rgno;
 	struct xfs_buf		*bp;
 	xfs_agblock_t		old_rextsize = mp->m_sb.sb_rextsize;
 	int			error;
@@ -1134,19 +1292,57 @@ xfs_growfs_rt(
 	if (error)
 		goto out_unlock;
 
-	error = xfs_growfs_rtg(mp, in->newblocks, in->extsize);
-	if (error)
-		goto out_unlock;
+	if (xfs_has_rtgroups(mp)) {
+		error = xfs_growfs_rt_prep_groups(mp, in->newblocks,
+				in->extsize, &new_rgcount);
+		if (error)
+			goto out_unlock;
+	}
 
-	if (old_rextsize != in->extsize) {
+	if (xfs_grow_last_rtg(mp)) {
+		error = xfs_growfs_rtg(mp, old_rgcount - 1, in->newblocks,
+				in->extsize);
+		if (error)
+			goto out_unlock;
+	}
+
+	for (rgno = old_rgcount; rgno < new_rgcount; rgno++) {
+		xfs_rtbxlen_t	rextents = div_u64(in->newblocks, in->extsize);
+
+		error = xfs_rtgroup_alloc(mp, rgno, new_rgcount, rextents);
+		if (error)
+			goto out_unlock;
+
+		error = xfs_growfs_rtg(mp, rgno, in->newblocks, in->extsize);
+		if (error) {
+			struct xfs_rtgroup	*rtg;
+
+			rtg = xfs_rtgroup_grab(mp, rgno);
+			if (!WARN_ON_ONCE(!rtg)) {
+				xfs_rtunmount_rtg(rtg);
+				xfs_rtgroup_rele(rtg);
+				xfs_rtgroup_free(mp, rgno);
+			}
+			break;
+		}
+	}
+
+	if (!error && old_rextsize != in->extsize)
 		error = xfs_growfs_rt_fixup_extsize(mp);
-		if (error)
-			goto out_unlock;
+
+	/*
+	 * Update secondary superblocks now the physical grow has completed.
+	 *
+	 * Also do this in case of an error as we might have already
+	 * successfully updated one or more RTGs and incremented sb_rgcount.
+	 */
+	if (!xfs_is_shutdown(mp)) {
+		int error2 = xfs_update_secondary_sbs(mp);
+
+		if (!error)
+			error = error2;
 	}
 
-	/* Update secondary superblocks now the physical grow has completed */
-	error = xfs_update_secondary_sbs(mp);
-
 out_unlock:
 	mutex_unlock(&mp->m_growlock);
 	return error;
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 01b5f5b32af467..a29a181e684041 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -460,6 +460,10 @@ xfs_trans_mod_sb(
 	case XFS_TRANS_SB_REXTSLOG:
 		tp->t_rextslog_delta += delta;
 		break;
+	case XFS_TRANS_SB_RGCOUNT:
+		ASSERT(delta > 0);
+		tp->t_rgcount_delta += delta;
+		break;
 	default:
 		ASSERT(0);
 		return;
@@ -561,6 +565,10 @@ xfs_trans_apply_sb_deltas(
 		sbp->sb_rextslog += tp->t_rextslog_delta;
 		whole = 1;
 	}
+	if (tp->t_rgcount_delta) {
+		be32_add_cpu(&sbp->sb_rgcount, tp->t_rgcount_delta);
+		whole = 1;
+	}
 
 	xfs_trans_buf_set_type(tp, bp, XFS_BLFT_SB_BUF);
 	if (whole)
@@ -674,6 +682,7 @@ xfs_trans_unreserve_and_mod_sb(
 	mp->m_sb.sb_rblocks += tp->t_rblocks_delta;
 	mp->m_sb.sb_rextents += tp->t_rextents_delta;
 	mp->m_sb.sb_rextslog += tp->t_rextslog_delta;
+	mp->m_sb.sb_rgcount += tp->t_rgcount_delta;
 	spin_unlock(&mp->m_sb_lock);
 
 	/*
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index f97e5c416efad1..71c2e82e4dadff 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -148,6 +148,7 @@ typedef struct xfs_trans {
 	int64_t			t_rblocks_delta;/* superblock rblocks change */
 	int64_t			t_rextents_delta;/* superblocks rextents chg */
 	int64_t			t_rextslog_delta;/* superblocks rextslog chg */
+	int64_t			t_rgcount_delta; /* realtime group count */
 	struct list_head	t_items;	/* log item descriptors */
 	struct list_head	t_busy;		/* list of busy extents */
 	struct list_head	t_dfops;	/* deferred operations */


