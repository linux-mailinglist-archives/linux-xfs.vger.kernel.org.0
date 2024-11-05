Return-Path: <linux-xfs+bounces-15107-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C8149BD8B6
	for <lists+linux-xfs@lfdr.de>; Tue,  5 Nov 2024 23:30:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8CC0B1F23AAE
	for <lists+linux-xfs@lfdr.de>; Tue,  5 Nov 2024 22:30:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6582F1D150C;
	Tue,  5 Nov 2024 22:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jB4znb6E"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B341CCB2D
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730845842; cv=none; b=d7uMr8bflNJLiN38W8dsS/CmMUF+lLqq1x+vygAtLW4yt93iUG9nqUz+LPexX0T5L8cNfUWcSIKduXDEArSruuINJ6h8eQm78B87wucv7HOqmNPyPd/0E4Zg0ZZzByC31lWQ/fwVZyAIfyJXd5W4i1hMe93rote/s6zLt8E7Rz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730845842; c=relaxed/simple;
	bh=o9jqYwlBaCUQDEkJ0Vp4F4TzCP369O1zeJX3isbvmPg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F+FvsmclDdxpR3syAqeuytO9XvlhHRRg7QA1vgpFQP9QX/ccB1jzjgG16hQOsS72pcR0TjMthqpRsWlIK3qG6xAP77S5y8edaHS38gwEPrF/0TSb6PNcuvIHLeN6xaN2JWp+nXHsb48oQIpe/jHzKKz2vXDVOZJ0/tyYC7TGj5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jB4znb6E; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B85CC4CECF;
	Tue,  5 Nov 2024 22:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730845841;
	bh=o9jqYwlBaCUQDEkJ0Vp4F4TzCP369O1zeJX3isbvmPg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jB4znb6EdiPcCyiPZYiYagYz/oMY5XI9nVSShqo5qu4cLeN1MMZFsu04K+gf6vsyn
	 GcKXykqWKj1mtYDIddGfa8tBJB2OAjQEa5ZrXWwnX2rk6f0khEf+4tygZ1Q6QXlETK
	 1dd2wj3P7LX8p7d0DNajSPpYSa54bUQUF6bGh0CNDU1A8hgGKoMjg+jWQOBO6WcAeG
	 urMBf/89pPQ4qXUZFshdaF5RW7e+DFnynk6CvHRju3cmZSjd9QBFYr1f483HswSlR+
	 JCW+PxLC1rPfFSTAVf226978KIHkFFzhxHSRm3Daw+w+LjfJJbIGfxEYkTOjomGhtJ
	 gjag4FLtTN+aw==
Date: Tue, 05 Nov 2024 14:30:41 -0800
Subject: [PATCH 03/34] xfs: update realtime super every time we update the
 primary fs super
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084398236.1871887.513255394857158192.stgit@frogsfrogsfrogs>
In-Reply-To: <173084398097.1871887.5832278892963229059.stgit@frogsfrogsfrogs>
References: <173084398097.1871887.5832278892963229059.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Every time we update parts of the primary filesystem superblock that are
echoed in the rt superblock, we must update the rt super.  Avoid
changing the log to support logging to the rt device by using ordered
buffers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_rtgroup.c   |   60 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtgroup.h   |    7 +++++
 fs/xfs/libxfs/xfs_sb.c        |   14 +++++++++-
 fs/xfs/libxfs/xfs_sb.h        |    2 +
 fs/xfs/xfs_buf_item_recover.c |   12 ++++++++
 fs/xfs/xfs_ioctl.c            |    4 ++-
 fs/xfs/xfs_trans.c            |    1 +
 fs/xfs/xfs_trans.h            |    1 +
 fs/xfs/xfs_trans_buf.c        |   25 ++++++++++++++---
 9 files changed, 118 insertions(+), 8 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index 9e2ca61559f45e..470260c911c8d1 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -564,3 +564,63 @@ const struct xfs_buf_ops xfs_rtsb_buf_ops = {
 	.verify_write	= xfs_rtsb_write_verify,
 	.verify_struct	= xfs_rtsb_verify_all,
 };
+
+/* Update a realtime superblock from the primary fs super */
+void
+xfs_update_rtsb(
+	struct xfs_buf		*rtsb_bp,
+	const struct xfs_buf	*sb_bp)
+{
+	const struct xfs_dsb	*dsb = sb_bp->b_addr;
+	struct xfs_rtsb		*rsb = rtsb_bp->b_addr;
+	const uuid_t		*meta_uuid;
+
+	rsb->rsb_magicnum = cpu_to_be32(XFS_RTSB_MAGIC);
+
+	rsb->rsb_pad = 0;
+	memcpy(&rsb->rsb_fname, &dsb->sb_fname, XFSLABEL_MAX);
+
+	memcpy(&rsb->rsb_uuid, &dsb->sb_uuid, sizeof(rsb->rsb_uuid));
+
+	/*
+	 * The metadata uuid is the fs uuid if the metauuid feature is not
+	 * enabled.
+	 */
+	if (dsb->sb_features_incompat &
+				cpu_to_be32(XFS_SB_FEAT_INCOMPAT_META_UUID))
+		meta_uuid = &dsb->sb_meta_uuid;
+	else
+		meta_uuid = &dsb->sb_uuid;
+	memcpy(&rsb->rsb_meta_uuid, meta_uuid, sizeof(rsb->rsb_meta_uuid));
+}
+
+/*
+ * Update the realtime superblock from a filesystem superblock and log it to
+ * the given transaction.
+ */
+struct xfs_buf *
+xfs_log_rtsb(
+	struct xfs_trans	*tp,
+	const struct xfs_buf	*sb_bp)
+{
+	struct xfs_buf		*rtsb_bp;
+
+	if (!xfs_has_rtsb(tp->t_mountp))
+		return NULL;
+
+	rtsb_bp = xfs_trans_getrtsb(tp);
+	if (!rtsb_bp) {
+		/*
+		 * It's possible for the rtgroups feature to be enabled but
+		 * there is no incore rt superblock buffer if the rt geometry
+		 * was specified at mkfs time but the rt section has not yet
+		 * been attached.  In this case, rblocks must be zero.
+		 */
+		ASSERT(tp->t_mountp->m_sb.sb_rblocks == 0);
+		return NULL;
+	}
+
+	xfs_update_rtsb(rtsb_bp, sb_bp);
+	xfs_trans_ordered_buf(tp, rtsb_bp);
+	return rtsb_bp;
+}
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index 6ccf31bb6bc7a7..e7679fafff8ce7 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -251,6 +251,11 @@ static inline const char *xfs_rtginode_path(xfs_rgnumber_t rgno,
 {
 	return kasprintf(GFP_KERNEL, "%u.%s", rgno, xfs_rtginode_name(type));
 }
+
+void xfs_update_rtsb(struct xfs_buf *rtsb_bp,
+		const struct xfs_buf *sb_bp);
+struct xfs_buf *xfs_log_rtsb(struct xfs_trans *tp,
+		const struct xfs_buf *sb_bp);
 #else
 static inline void xfs_free_rtgroups(struct xfs_mount *mp,
 		xfs_rgnumber_t first_rgno, xfs_rgnumber_t end_rgno)
@@ -269,6 +274,8 @@ static inline int xfs_initialize_rtgroups(struct xfs_mount *mp,
 # define xfs_rtgroup_lock(rtg, gf)		((void)0)
 # define xfs_rtgroup_unlock(rtg, gf)		((void)0)
 # define xfs_rtgroup_trans_join(tp, rtg, gf)	((void)0)
+# define xfs_update_rtsb(bp, sb_bp)	((void)0)
+# define xfs_log_rtsb(tp, sb_bp)	(NULL)
 #endif /* CONFIG_XFS_RT */
 
 #endif /* __LIBXFS_RTGROUP_H */
diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index b5f798d01dba05..6b0757d60cf3af 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -27,6 +27,7 @@
 #include "xfs_ag.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_exchrange.h"
+#include "xfs_rtgroup.h"
 
 /*
  * Physical superblock buffer manipulations. Shared with libxfs in userspace.
@@ -1276,10 +1277,12 @@ xfs_update_secondary_sbs(
  */
 int
 xfs_sync_sb_buf(
-	struct xfs_mount	*mp)
+	struct xfs_mount	*mp,
+	bool			update_rtsb)
 {
 	struct xfs_trans	*tp;
 	struct xfs_buf		*bp;
+	struct xfs_buf		*rtsb_bp = NULL;
 	int			error;
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_sb, 0, 0, 0, &tp);
@@ -1289,6 +1292,11 @@ xfs_sync_sb_buf(
 	bp = xfs_trans_getsb(tp);
 	xfs_log_sb(tp);
 	xfs_trans_bhold(tp, bp);
+	if (update_rtsb) {
+		rtsb_bp = xfs_log_rtsb(tp, bp);
+		if (rtsb_bp)
+			xfs_trans_bhold(tp, rtsb_bp);
+	}
 	xfs_trans_set_sync(tp);
 	error = xfs_trans_commit(tp);
 	if (error)
@@ -1297,7 +1305,11 @@ xfs_sync_sb_buf(
 	 * write out the sb buffer to get the changes to disk
 	 */
 	error = xfs_bwrite(bp);
+	if (!error && rtsb_bp)
+		error = xfs_bwrite(rtsb_bp);
 out:
+	if (rtsb_bp)
+		xfs_buf_relse(rtsb_bp);
 	xfs_buf_relse(bp);
 	return error;
 }
diff --git a/fs/xfs/libxfs/xfs_sb.h b/fs/xfs/libxfs/xfs_sb.h
index 885c837559914d..999dcfccdaf960 100644
--- a/fs/xfs/libxfs/xfs_sb.h
+++ b/fs/xfs/libxfs/xfs_sb.h
@@ -15,7 +15,7 @@ struct xfs_perag;
 
 extern void	xfs_log_sb(struct xfs_trans *tp);
 extern int	xfs_sync_sb(struct xfs_mount *mp, bool wait);
-extern int	xfs_sync_sb_buf(struct xfs_mount *mp);
+extern int	xfs_sync_sb_buf(struct xfs_mount *mp, bool update_rtsb);
 extern void	xfs_sb_mount_common(struct xfs_mount *mp, struct xfs_sb *sbp);
 void		xfs_mount_sb_set_rextsize(struct xfs_mount *mp,
 			struct xfs_sb *sbp);
diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index c8259ee482fd86..feb3db2e891614 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -1061,6 +1061,18 @@ xlog_recover_buf_commit_pass2(
 				current_lsn);
 		if (error)
 			goto out_release;
+
+		/* Update the rt superblock if we have one. */
+		if (xfs_has_rtsb(mp) && mp->m_rtsb_bp) {
+			struct xfs_buf	*rtsb_bp = mp->m_rtsb_bp;
+
+			xfs_buf_lock(rtsb_bp);
+			xfs_buf_hold(rtsb_bp);
+			xfs_update_rtsb(rtsb_bp, bp);
+			rtsb_bp->b_flags |= _XBF_LOGRECOVERY;
+			xfs_buf_delwri_queue(rtsb_bp, buffer_list);
+			xfs_buf_relse(rtsb_bp);
+		}
 	} else {
 		xlog_recover_do_reg_buffer(mp, item, bp, buf_f, current_lsn);
 	}
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index f36fd8db388cca..1e233abed7ce6d 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1028,7 +1028,7 @@ xfs_ioc_setlabel(
 	 * buffered reads from userspace (i.e. from blkid) are invalidated,
 	 * and userspace will see the newly-written label.
 	 */
-	error = xfs_sync_sb_buf(mp);
+	error = xfs_sync_sb_buf(mp, true);
 	if (error)
 		goto out;
 	/*
@@ -1039,6 +1039,8 @@ xfs_ioc_setlabel(
 	mutex_unlock(&mp->m_growlock);
 
 	invalidate_bdev(mp->m_ddev_targp->bt_bdev);
+	if (xfs_has_rtsb(mp) && mp->m_rtdev_targp)
+		invalidate_bdev(mp->m_rtdev_targp->bt_bdev);
 
 out:
 	mnt_drop_write_file(filp);
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index cee7f0564409bd..118d31e11127be 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -25,6 +25,7 @@
 #include "xfs_dquot.h"
 #include "xfs_icache.h"
 #include "xfs_rtbitmap.h"
+#include "xfs_rtgroup.h"
 
 struct kmem_cache	*xfs_trans_cache;
 
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index f06cc0f41665ad..f97e5c416efad1 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -214,6 +214,7 @@ xfs_trans_read_buf(
 }
 
 struct xfs_buf	*xfs_trans_getsb(struct xfs_trans *);
+struct xfs_buf	*xfs_trans_getrtsb(struct xfs_trans *tp);
 
 void		xfs_trans_brelse(xfs_trans_t *, struct xfs_buf *);
 void		xfs_trans_bjoin(xfs_trans_t *, struct xfs_buf *);
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index e28ab74af4f0e1..8e886ecfd69a3b 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -168,12 +168,11 @@ xfs_trans_get_buf_map(
 /*
  * Get and lock the superblock buffer for the given transaction.
  */
-struct xfs_buf *
-xfs_trans_getsb(
-	struct xfs_trans	*tp)
+static struct xfs_buf *
+__xfs_trans_getsb(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp)
 {
-	struct xfs_buf		*bp = tp->t_mountp->m_sb_bp;
-
 	/*
 	 * Just increment the lock recursion count if the buffer is already
 	 * attached to this transaction.
@@ -197,6 +196,22 @@ xfs_trans_getsb(
 	return bp;
 }
 
+struct xfs_buf *
+xfs_trans_getsb(
+	struct xfs_trans	*tp)
+{
+	return __xfs_trans_getsb(tp, tp->t_mountp->m_sb_bp);
+}
+
+struct xfs_buf *
+xfs_trans_getrtsb(
+	struct xfs_trans	*tp)
+{
+	if (!tp->t_mountp->m_rtsb_bp)
+		return NULL;
+	return __xfs_trans_getsb(tp, tp->t_mountp->m_rtsb_bp);
+}
+
 /*
  * Get and lock the buffer for the caller if it is not already
  * locked within the given transaction.  If it has not yet been


