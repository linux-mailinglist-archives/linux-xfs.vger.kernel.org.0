Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE46306D41
	for <lists+linux-xfs@lfdr.de>; Thu, 28 Jan 2021 07:05:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbhA1GCy (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 28 Jan 2021 01:02:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:37900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229513AbhA1GCv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jan 2021 01:02:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6DAB64DD6;
        Thu, 28 Jan 2021 06:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611813730;
        bh=PRb78jqBavwXS/89i2uQrmWjLWZBLTdP7jHbuHCKYpU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=F1l8VqPqyVKJTsiYgDemjy/zex6oMBUhjsb3ZM2ShQ7uonzs0urMG727FOAa0oUzP
         9VF2U4SPNuL3ajo6373odWaXowH/MSpDAHweT14mIXN/kBJEB95pe2I9WSqrt4Zams
         OdX0PV6TwQTwC7cE2TVryDbnAi1hsSaKwAOy5zOlPrHFsuDbh+8yZw4xa4zTX0i57R
         D47ECdtdAGkuEAdqlcvsz8uFPE8dfiKkfWS0Ds5cTsznBja3Llt9JqeOHYaYNedXMG
         zpDxg/jbgnUOavfSuH0VecDn7Q5+d+TnAZsBMsNBM2IP5QxzVYdxw+5YPHu+m5GyVq
         NSzNp6TeTKpaA==
Subject: [PATCH 11/13] xfs: refactor inode creation transaction/inode/quota
 allocation idiom
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Date:   Wed, 27 Jan 2021 22:02:06 -0800
Message-ID: <161181372686.1523592.6379270446924577363.stgit@magnolia>
In-Reply-To: <161181366379.1523592.9213241916555622577.stgit@magnolia>
References: <161181366379.1523592.9213241916555622577.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

For file creation, create a new helper xfs_trans_alloc_icreate that
allocates a transaction and reserves the appropriate amount of quota
against that transction.  Replace all the open-coded idioms with a
single call to this helper so that we can contain the retry loops in the
next patchset.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_inode.c   |   28 ++++++++++------------------
 fs/xfs/xfs_symlink.c |   14 ++++----------
 fs/xfs/xfs_trans.c   |   33 +++++++++++++++++++++++++++++++++
 fs/xfs/xfs_trans.h   |    6 ++++++
 4 files changed, 53 insertions(+), 28 deletions(-)


diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 4bbd2fb628f7..636ac13b1df2 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1022,25 +1022,20 @@ xfs_create(
 	 * the case we'll drop the one we have and get a more
 	 * appropriate transaction later.
 	 */
-	error = xfs_trans_alloc(mp, tres, resblks, 0, 0, &tp);
+	error = xfs_trans_alloc_icreate(mp, tres, udqp, gdqp, pdqp, resblks,
+			&tp);
 	if (error == -ENOSPC) {
 		/* flush outstanding delalloc blocks and retry */
 		xfs_flush_inodes(mp);
-		error = xfs_trans_alloc(mp, tres, resblks, 0, 0, &tp);
+		error = xfs_trans_alloc_icreate(mp, tres, udqp, gdqp, pdqp,
+				resblks, &tp);
 	}
 	if (error)
-		goto out_release_inode;
+		goto out_release_dquots;
 
 	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
 	unlock_dp_on_error = true;
 
-	/*
-	 * Reserve disk quota and the inode.
-	 */
-	error = xfs_trans_reserve_quota_icreate(tp, udqp, gdqp, pdqp, resblks);
-	if (error)
-		goto out_trans_cancel;
-
 	error = xfs_iext_count_may_overflow(dp, XFS_DATA_FORK,
 			XFS_IEXT_DIR_MANIP_CNT(mp));
 	if (error)
@@ -1120,7 +1115,7 @@ xfs_create(
 		xfs_finish_inode_setup(ip);
 		xfs_irele(ip);
 	}
-
+ out_release_dquots:
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
 	xfs_qm_dqrele(pdqp);
@@ -1164,13 +1159,10 @@ xfs_create_tmpfile(
 	resblks = XFS_IALLOC_SPACE_RES(mp);
 	tres = &M_RES(mp)->tr_create_tmpfile;
 
-	error = xfs_trans_alloc(mp, tres, resblks, 0, 0, &tp);
+	error = xfs_trans_alloc_icreate(mp, tres, udqp, gdqp, pdqp, resblks,
+			&tp);
 	if (error)
-		goto out_release_inode;
-
-	error = xfs_trans_reserve_quota_icreate(tp, udqp, gdqp, pdqp, resblks);
-	if (error)
-		goto out_trans_cancel;
+		goto out_release_dquots;
 
 	error = xfs_dir_ialloc(&tp, dp, mode, 0, 0, prid, &ip);
 	if (error)
@@ -1213,7 +1205,7 @@ xfs_create_tmpfile(
 		xfs_finish_inode_setup(ip);
 		xfs_irele(ip);
 	}
-
+ out_release_dquots:
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
 	xfs_qm_dqrele(pdqp);
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index d5dee8f409b2..8565663b16cd 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -197,9 +197,10 @@ xfs_symlink(
 		fs_blocks = xfs_symlink_blocks(mp, pathlen);
 	resblks = XFS_SYMLINK_SPACE_RES(mp, link_name->len, fs_blocks);
 
-	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_symlink, resblks, 0, 0, &tp);
+	error = xfs_trans_alloc_icreate(mp, &M_RES(mp)->tr_symlink, udqp, gdqp,
+			pdqp, resblks, &tp);
 	if (error)
-		goto out_release_inode;
+		goto out_release_dquots;
 
 	xfs_ilock(dp, XFS_ILOCK_EXCL | XFS_ILOCK_PARENT);
 	unlock_dp_on_error = true;
@@ -212,13 +213,6 @@ xfs_symlink(
 		goto out_trans_cancel;
 	}
 
-	/*
-	 * Reserve disk quota : blocks and inode.
-	 */
-	error = xfs_trans_reserve_quota_icreate(tp, udqp, gdqp, pdqp, resblks);
-	if (error)
-		goto out_trans_cancel;
-
 	error = xfs_iext_count_may_overflow(dp, XFS_DATA_FORK,
 			XFS_IEXT_DIR_MANIP_CNT(mp));
 	if (error)
@@ -347,7 +341,7 @@ xfs_symlink(
 		xfs_finish_inode_setup(ip);
 		xfs_irele(ip);
 	}
-
+out_release_dquots:
 	xfs_qm_dqrele(udqp);
 	xfs_qm_dqrele(gdqp);
 	xfs_qm_dqrele(pdqp);
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 151f274eee43..bfb8b2a1594f 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -21,6 +21,8 @@
 #include "xfs_error.h"
 #include "xfs_defer.h"
 #include "xfs_inode.h"
+#include "xfs_dquot_item.h"
+#include "xfs_dquot.h"
 
 kmem_zone_t	*xfs_trans_zone;
 
@@ -1074,3 +1076,34 @@ xfs_trans_alloc_inode(
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 }
+
+/*
+ * Allocate an transaction in preparation for inode creation by reserving quota
+ * against the given dquots.
+ */
+int
+xfs_trans_alloc_icreate(
+	struct xfs_mount	*mp,
+	struct xfs_trans_res	*resv,
+	struct xfs_dquot	*udqp,
+	struct xfs_dquot	*gdqp,
+	struct xfs_dquot	*pdqp,
+	unsigned int		dblocks,
+	struct xfs_trans	**tpp)
+{
+	struct xfs_trans	*tp;
+	int			error;
+
+	error = xfs_trans_alloc(mp, resv, dblocks, 0, 0, &tp);
+	if (error)
+		return error;
+
+	error = xfs_trans_reserve_quota_icreate(tp, udqp, gdqp, pdqp, dblocks);
+	if (error) {
+		xfs_trans_cancel(tp);
+		return error;
+	}
+
+	*tpp = tp;
+	return 0;
+}
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 52bbd7e6a552..04c132c55e9b 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -268,8 +268,14 @@ xfs_trans_item_relog(
 	return lip->li_ops->iop_relog(lip, tp);
 }
 
+struct xfs_dquot;
+
 int xfs_trans_alloc_inode(struct xfs_inode *ip, struct xfs_trans_res *resv,
 		unsigned int dblocks, unsigned int rblocks, bool force,
 		struct xfs_trans **tpp);
+int xfs_trans_alloc_icreate(struct xfs_mount *mp, struct xfs_trans_res *resv,
+		struct xfs_dquot *udqp, struct xfs_dquot *gdqp,
+		struct xfs_dquot *pdqp, unsigned int dblocks,
+		struct xfs_trans **tpp);
 
 #endif	/* __XFS_TRANS_H__ */

