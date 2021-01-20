Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A68E2FCA09
	for <lists+linux-xfs@lfdr.de>; Wed, 20 Jan 2021 05:35:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729951AbhATEee (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 19 Jan 2021 23:34:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:53948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729490AbhATEeM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Jan 2021 23:34:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E698B23131;
        Wed, 20 Jan 2021 04:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611117211;
        bh=qKnQKJQizNd1I5PhuHltR4rTVlfxCbY0Rfgkbt5rh00=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IbYyueCJN0x46eQBVDckJ5dQ+Ehb6uZ8LDB1EZUj0/CKTDoQ36MpCszUrC/Kj5SWN
         6b+lXFy20pmGKrd2N1A5RJ4pJCa/RUJszyrLsdW0iGBfhn72DusCMpM0JZPLcYWrQs
         fH8dZhsOC+djwZiUvHTyNbQKo+bAnqcE/3KKFEe7bill6oMAnSkQQirABhICWde1Az
         ko7rr3zso1DxZz3hp9aiNkFLSZlfwpCLqBfhYQW5zwP3DQ1H0GyCntgYKhWX8A9MXx
         mCkO6dhjP8D3gjezC4+tSZbaL7Ls47RUjZKEhRUFpR7b5AnUkHmwaVOw9B2f+Da9qS
         f95WkCoPWzvrg==
Date:   Tue, 19 Jan 2021 20:33:29 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     linux-xfs@vger.kernel.org
Cc:     Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v2.1 3/4] xfs: create convenience wrappers for incore quota
 block reservations
Message-ID: <20210120043329.GZ3134581@magnolia>
References: <161100789347.88678.17195697099723545426.stgit@magnolia>
 <161100791039.88678.6897577495997060048.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161100791039.88678.6897577495997060048.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a couple of convenience wrappers for creating and deleting quota
block reservations against future changes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
v2.1: change the third argument to an "is rt?" boolean from raw qmopt flags
---
 fs/xfs/libxfs/xfs_bmap.c |   12 ++++++------
 fs/xfs/xfs_quota.h       |   19 +++++++++++++++++++
 fs/xfs/xfs_reflink.c     |    6 +++---
 3 files changed, 28 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 21076ac2485a..d35e90db6135 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3970,9 +3970,12 @@ xfs_bmapi_reserve_delalloc(
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	xfs_extlen_t		alen;
 	xfs_extlen_t		indlen;
+	bool			isrt;
 	int			error;
 	xfs_fileoff_t		aoff = off;
 
+	isrt = (whichfork == XFS_DATA_FORK) && XFS_IS_REALTIME_INODE(ip);
+
 	/*
 	 * Cap the alloc length. Keep track of prealloc so we know whether to
 	 * tag the inode before we return.
@@ -4001,8 +4004,7 @@ xfs_bmapi_reserve_delalloc(
 	 * blocks.  This number gets adjusted later.  We return if we haven't
 	 * allocated blocks already inside this loop.
 	 */
-	error = xfs_trans_reserve_quota_nblks(NULL, ip, (long)alen, 0,
-						XFS_QMOPT_RES_REGBLKS);
+	error = xfs_quota_reserve_blkres(ip, alen, isrt);
 	if (error)
 		return error;
 
@@ -4048,8 +4050,7 @@ xfs_bmapi_reserve_delalloc(
 	xfs_mod_fdblocks(mp, alen, false);
 out_unreserve_quota:
 	if (XFS_IS_QUOTA_ON(mp))
-		xfs_trans_unreserve_quota_nblks(NULL, ip, (long)alen, 0,
-						XFS_QMOPT_RES_REGBLKS);
+		xfs_quota_unreserve_blkres(ip, alen, isrt);
 	return error;
 }
 
@@ -4826,8 +4827,7 @@ xfs_bmap_del_extent_delay(
 	 * sb counters as we might have to borrow some blocks for the
 	 * indirect block accounting.
 	 */
-	error = xfs_trans_unreserve_quota_nblks(NULL, ip, del->br_blockcount, 0,
-			isrt ? XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS);
+	error = xfs_quota_unreserve_blkres(ip, del->br_blockcount, isrt);
 	if (error)
 		return error;
 	ip->i_delayed_blks -= del->br_blockcount;
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index bd28d17941e7..a25e3ce04c60 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -108,6 +108,12 @@ extern void xfs_qm_mount_quotas(struct xfs_mount *);
 extern void xfs_qm_unmount(struct xfs_mount *);
 extern void xfs_qm_unmount_quotas(struct xfs_mount *);
 
+static inline int
+xfs_quota_reserve_blkres(struct xfs_inode *ip, int64_t nblks, bool isrt)
+{
+	return xfs_trans_reserve_quota_nblks(NULL, ip, nblks, 0,
+			isrt ? XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS);
+}
 #else
 static inline int
 xfs_qm_vop_dqalloc(struct xfs_inode *ip, kuid_t kuid, kgid_t kgid,
@@ -136,6 +142,13 @@ static inline int xfs_trans_reserve_quota_bydquots(struct xfs_trans *tp,
 {
 	return 0;
 }
+
+static inline int
+xfs_quota_reserve_blkres(struct xfs_inode *ip, int64_t nblks, bool isrt)
+{
+	return 0;
+}
+
 #define xfs_qm_vop_create_dqattach(tp, ip, u, g, p)
 #define xfs_qm_vop_rename_dqattach(it)					(0)
 #define xfs_qm_vop_chown(tp, ip, old, new)				(NULL)
@@ -162,6 +175,12 @@ xfs_trans_unreserve_quota_nblks(struct xfs_trans *tp, struct xfs_inode *ip,
 	xfs_trans_reserve_quota_bydquots(tp, mp, ud, gd, pd, nb, ni, \
 				f | XFS_QMOPT_RES_REGBLKS)
 
+static inline int
+xfs_quota_unreserve_blkres(struct xfs_inode *ip, int64_t nblks, bool isrt)
+{
+	return xfs_quota_reserve_blkres(ip, -nblks, isrt);
+}
+
 extern int xfs_mount_reset_sbqflags(struct xfs_mount *);
 
 #endif	/* __XFS_QUOTA_H__ */
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 20321d03e31c..afd1d5b0ad4c 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -508,9 +508,9 @@ xfs_reflink_cancel_cow_blocks(
 			xfs_bmap_del_extent_cow(ip, &icur, &got, &del);
 
 			/* Remove the quota reservation */
-			error = xfs_trans_unreserve_quota_nblks(NULL, ip,
-					del.br_blockcount, 0,
-					XFS_QMOPT_RES_REGBLKS);
+			error = xfs_quota_unreserve_blkres(ip,
+					del.br_blockcount,
+					XFS_IS_REALTIME_INODE(ip));
 			if (error)
 				break;
 		} else {
