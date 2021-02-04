Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1A6430B506
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Feb 2021 03:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbhBBCFO (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 1 Feb 2021 21:05:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:55530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230009AbhBBCFN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 1 Feb 2021 21:05:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26EC064EDB;
        Tue,  2 Feb 2021 02:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612231472;
        bh=rjqVskahRDJRqHUMLC7mDihae0skfWpZ6dsmrCqeI8k=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kcQ6W05MK97fwj/4ROcUF/AWBCasOoaeKGTn/1E9dkZOZ8qIf9ijp5GewQR42URzp
         fPid93hxr4gtWVMwivEaQg7K9qUszolbsL+UrYja++j9We7B1VxSY3dEjww4sLJ1rH
         qBSG1NX9YzUtODp9rzZQ2pvE3cEmDP+0SlluZu3dZKhdE0y8c9IkS/mynULZnytrXq
         WEZJemioklvEmrqiiwYY2ayYEzquueyxj5zTM0yH/2XnDX1oc7Bd0cJqBssTh4t+V0
         jKXQH74ayFCt54auVTGIJaLoUilStOngm1xyWIA02PS8xDls0yPhZFOyIc/uk6yR8I
         VJf9+3beqJNgg==
Subject: [PATCH 13/16] xfs: refactor inode ownership change
 transaction/inode/quota allocation idiom
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Date:   Mon, 01 Feb 2021 18:04:31 -0800
Message-ID: <161223147171.491593.1153393231638526420.stgit@magnolia>
In-Reply-To: <161223139756.491593.10895138838199018804.stgit@magnolia>
References: <161223139756.491593.10895138838199018804.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

For file ownership (uid, gid, prid) changes, create a new helper
xfs_trans_alloc_ichange that allocates a transaction and reserves the
appropriate amount of quota against that transction in preparation for a
change of user, group, or project id.  Replace all the open-coded idioms
with a single call to this helper so that we can contain the retry loops
in the next patchset.

This changes the locking behavior for ichange transactions slightly.
Since tr_ichange does not have a permanent reservation and cannot roll,
we pass XFS_ILOCK_EXCL to ijoin so that the inode will be unlocked
automatically at commit time.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_ioctl.c |   29 ++++++++----------------
 fs/xfs/xfs_iops.c  |   26 ++--------------------
 fs/xfs/xfs_trans.c |   62 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trans.h |    3 +++
 4 files changed, 77 insertions(+), 43 deletions(-)


diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 3fbd98f61ea5..78ee201eb7cb 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1275,24 +1275,23 @@ xfs_ioctl_setattr_prepare_dax(
  */
 static struct xfs_trans *
 xfs_ioctl_setattr_get_trans(
-	struct xfs_inode	*ip)
+	struct xfs_inode	*ip,
+	struct xfs_dquot	*pdqp)
 {
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_trans	*tp;
 	int			error = -EROFS;
 
 	if (mp->m_flags & XFS_MOUNT_RDONLY)
-		goto out_unlock;
+		goto out_error;
 	error = -EIO;
 	if (XFS_FORCED_SHUTDOWN(mp))
-		goto out_unlock;
+		goto out_error;
 
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 0, 0, 0, &tp);
+	error = xfs_trans_alloc_ichange(ip, NULL, NULL, pdqp,
+			capable(CAP_FOWNER), &tp);
 	if (error)
-		goto out_unlock;
-
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+		goto out_error;
 
 	/*
 	 * CAP_FOWNER overrides the following restrictions:
@@ -1312,7 +1311,7 @@ xfs_ioctl_setattr_get_trans(
 
 out_cancel:
 	xfs_trans_cancel(tp);
-out_unlock:
+out_error:
 	return ERR_PTR(error);
 }
 
@@ -1462,20 +1461,12 @@ xfs_ioctl_setattr(
 
 	xfs_ioctl_setattr_prepare_dax(ip, fa);
 
-	tp = xfs_ioctl_setattr_get_trans(ip);
+	tp = xfs_ioctl_setattr_get_trans(ip, pdqp);
 	if (IS_ERR(tp)) {
 		code = PTR_ERR(tp);
 		goto error_free_dquots;
 	}
 
-	if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_PQUOTA_ON(mp) &&
-	    ip->i_d.di_projid != fa->fsx_projid) {
-		code = xfs_qm_vop_chown_reserve(tp, ip, NULL, NULL, pdqp,
-				capable(CAP_FOWNER) ?  XFS_QMOPT_FORCE_RES : 0);
-		if (code)	/* out of quota */
-			goto error_trans_cancel;
-	}
-
 	xfs_fill_fsxattr(ip, false, &old_fa);
 	code = vfs_ioc_fssetxattr_check(VFS_I(ip), &old_fa, fa);
 	if (code)
@@ -1608,7 +1599,7 @@ xfs_ioc_setxflags(
 
 	xfs_ioctl_setattr_prepare_dax(ip, &fa);
 
-	tp = xfs_ioctl_setattr_get_trans(ip);
+	tp = xfs_ioctl_setattr_get_trans(ip, NULL);
 	if (IS_ERR(tp)) {
 		error = PTR_ERR(tp);
 		goto out_drop_write;
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index f1e21b6cfa48..00369502fe25 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -700,13 +700,11 @@ xfs_setattr_nonsize(
 			return error;
 	}
 
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 0, 0, 0, &tp);
+	error = xfs_trans_alloc_ichange(ip, udqp, gdqp, NULL,
+			capable(CAP_FOWNER), &tp);
 	if (error)
 		goto out_dqrele;
 
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, ip, 0);
-
 	/*
 	 * Change file ownership.  Must be the owner or privileged.
 	 */
@@ -722,21 +720,6 @@ xfs_setattr_nonsize(
 		gid = (mask & ATTR_GID) ? iattr->ia_gid : igid;
 		uid = (mask & ATTR_UID) ? iattr->ia_uid : iuid;
 
-		/*
-		 * Do a quota reservation only if uid/gid is actually
-		 * going to change.
-		 */
-		if (XFS_IS_QUOTA_RUNNING(mp) &&
-		    ((XFS_IS_UQUOTA_ON(mp) && !uid_eq(iuid, uid)) ||
-		     (XFS_IS_GQUOTA_ON(mp) && !gid_eq(igid, gid)))) {
-			ASSERT(tp);
-			error = xfs_qm_vop_chown_reserve(tp, ip, udqp, gdqp,
-						NULL, capable(CAP_FOWNER) ?
-						XFS_QMOPT_FORCE_RES : 0);
-			if (error)	/* out of quota */
-				goto out_cancel;
-		}
-
 		/*
 		 * CAP_FSETID overrides the following restrictions:
 		 *
@@ -786,8 +769,6 @@ xfs_setattr_nonsize(
 		xfs_trans_set_sync(tp);
 	error = xfs_trans_commit(tp);
 
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-
 	/*
 	 * Release any dquot(s) the inode had kept before chown.
 	 */
@@ -814,9 +795,6 @@ xfs_setattr_nonsize(
 
 	return 0;
 
-out_cancel:
-	xfs_trans_cancel(tp);
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 out_dqrele:
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 6c68635cc6ac..60672b5545c9 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1107,3 +1107,65 @@ xfs_trans_alloc_icreate(
 	*tpp = tp;
 	return 0;
 }
+
+/*
+ * Allocate an transaction, lock and join the inode to it, and reserve quota
+ * in preparation for inode attribute changes that include uid, gid, or prid
+ * changes.
+ *
+ * The caller must ensure that the on-disk dquots attached to this inode have
+ * already been allocated and initialized.  The ILOCK will be dropped when the
+ * transaction is committed or cancelled.
+ */
+int
+xfs_trans_alloc_ichange(
+	struct xfs_inode	*ip,
+	struct xfs_dquot	*udqp,
+	struct xfs_dquot	*gdqp,
+	struct xfs_dquot	*pdqp,
+	bool			force,
+	struct xfs_trans	**tpp)
+{
+	struct xfs_trans	*tp;
+	struct xfs_mount	*mp = ip->i_mount;
+	int			error;
+
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 0, 0, 0, &tp);
+	if (error)
+		return error;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+
+	error = xfs_qm_dqattach_locked(ip, false);
+	if (error) {
+		/* Caller should have allocated the dquots! */
+		ASSERT(error != -ENOENT);
+		goto out_cancel;
+	}
+
+	/*
+	 * For each quota type, skip quota reservations if the inode's dquots
+	 * now match the ones that came from the caller, or the caller didn't
+	 * pass one in.
+	 */
+	if (udqp == ip->i_udquot)
+		udqp = NULL;
+	if (gdqp == ip->i_gdquot)
+		gdqp = NULL;
+	if (pdqp == ip->i_pdquot)
+		pdqp = NULL;
+	if (udqp || gdqp || pdqp) {
+		error = xfs_qm_vop_chown_reserve(tp, ip, udqp, gdqp, pdqp,
+				force ? XFS_QMOPT_FORCE_RES : 0);
+		if (error)
+			goto out_cancel;
+	}
+
+	*tpp = tp;
+	return 0;
+
+out_cancel:
+	xfs_trans_cancel(tp);
+	return error;
+}
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 04c132c55e9b..8b03fbfe9a1b 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -277,5 +277,8 @@ int xfs_trans_alloc_icreate(struct xfs_mount *mp, struct xfs_trans_res *resv,
 		struct xfs_dquot *udqp, struct xfs_dquot *gdqp,
 		struct xfs_dquot *pdqp, unsigned int dblocks,
 		struct xfs_trans **tpp);
+int xfs_trans_alloc_ichange(struct xfs_inode *ip, struct xfs_dquot *udqp,
+		struct xfs_dquot *gdqp, struct xfs_dquot *pdqp, bool force,
+		struct xfs_trans **tpp);
 
 #endif	/* __XFS_TRANS_H__ */

