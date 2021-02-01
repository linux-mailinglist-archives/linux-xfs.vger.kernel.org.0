Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1C0030A022
	for <lists+linux-xfs@lfdr.de>; Mon,  1 Feb 2021 03:04:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbhBACEw (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 31 Jan 2021 21:04:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:33800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231136AbhBACEt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 31 Jan 2021 21:04:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9744064E2A;
        Mon,  1 Feb 2021 02:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612145045;
        bh=+jHiDoEKbkF93coRyyuduiXisHBVXtQU/fZn2yOYzd4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=GGHw1jnFeLj65lKa6WtnyVUV+lOqq9F/E3MaTlKziUj76hEF/+vLLYxNPAauVk2Im
         MoIL65HjQYj6LZh2J0cqH9WVABn2nXY7/8vngvQgbn9TcuNeZ9302ZU9C1tBSjM3Vt
         GcQEBLpGD1DJke2MZmdjIHrdiA2svW59Fk5eQq5QRRO0orUV9Who5Kpzegr+7mqsDf
         xbhpgD4ChU+1YFpWNICmhy4s6wUi5gp9Ys1khNGwZFm7M5NYfXkciuYDu4Lwu+Wras
         0Fw5fKnHe1bIXxB7tn6sIIMr2orHDYwzjo3YiYwwqeneWiOEpS01NRIIsJnpE+/NJX
         17UvRoDUztbvg==
Subject: [PATCH 03/17] xfs: create convenience wrappers for incore quota block
 reservations
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Date:   Sun, 31 Jan 2021 18:04:05 -0800
Message-ID: <161214504573.139387.9145835824861508301.stgit@magnolia>
In-Reply-To: <161214502818.139387.7678025647736002500.stgit@magnolia>
References: <161214502818.139387.7678025647736002500.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create a couple of convenience wrappers for creating and deleting quota
block reservations against future changes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_bmap.c |   10 ++++------
 fs/xfs/xfs_quota.h       |   19 +++++++++++++++++++
 fs/xfs/xfs_reflink.c     |    5 ++---
 3 files changed, 25 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index c730288b5981..94d582a9587d 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4097,8 +4097,7 @@ xfs_bmapi_reserve_delalloc(
 	 * blocks.  This number gets adjusted later.  We return if we haven't
 	 * allocated blocks already inside this loop.
 	 */
-	error = xfs_trans_reserve_quota_nblks(NULL, ip, (long)alen, 0,
-						XFS_QMOPT_RES_REGBLKS);
+	error = xfs_quota_reserve_blkres(ip, alen);
 	if (error)
 		return error;
 
@@ -4144,8 +4143,7 @@ xfs_bmapi_reserve_delalloc(
 	xfs_mod_fdblocks(mp, alen, false);
 out_unreserve_quota:
 	if (XFS_IS_QUOTA_ON(mp))
-		xfs_trans_unreserve_quota_nblks(NULL, ip, (long)alen, 0,
-						XFS_QMOPT_RES_REGBLKS);
+		xfs_quota_unreserve_blkres(ip, alen);
 	return error;
 }
 
@@ -4937,8 +4935,8 @@ xfs_bmap_del_extent_delay(
 	 * sb counters as we might have to borrow some blocks for the
 	 * indirect block accounting.
 	 */
-	error = xfs_trans_unreserve_quota_nblks(NULL, ip, del->br_blockcount, 0,
-			isrt ? XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS);
+	ASSERT(!isrt);
+	error = xfs_quota_unreserve_blkres(ip, del->br_blockcount);
 	if (error)
 		return error;
 	ip->i_delayed_blks -= del->br_blockcount;
diff --git a/fs/xfs/xfs_quota.h b/fs/xfs/xfs_quota.h
index 5a62398940d0..1d1a1634ea29 100644
--- a/fs/xfs/xfs_quota.h
+++ b/fs/xfs/xfs_quota.h
@@ -108,6 +108,12 @@ extern void xfs_qm_mount_quotas(struct xfs_mount *);
 extern void xfs_qm_unmount(struct xfs_mount *);
 extern void xfs_qm_unmount_quotas(struct xfs_mount *);
 
+static inline int
+xfs_quota_reserve_blkres(struct xfs_inode *ip, int64_t blocks)
+{
+	return xfs_trans_reserve_quota_nblks(NULL, ip, blocks, 0,
+			XFS_QMOPT_RES_REGBLKS);
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
+xfs_quota_reserve_blkres(struct xfs_inode *ip, int64_t blocks)
+{
+	return 0;
+}
+
 #define xfs_qm_vop_create_dqattach(tp, ip, u, g, p)
 #define xfs_qm_vop_rename_dqattach(it)					(0)
 #define xfs_qm_vop_chown(tp, ip, old, new)				(NULL)
@@ -157,6 +170,12 @@ static inline int xfs_trans_reserve_quota_bydquots(struct xfs_trans *tp,
 	xfs_trans_reserve_quota_bydquots(tp, mp, ud, gd, pd, nb, ni, \
 				f | XFS_QMOPT_RES_REGBLKS)
 
+static inline int
+xfs_quota_unreserve_blkres(struct xfs_inode *ip, int64_t blocks)
+{
+	return xfs_quota_reserve_blkres(ip, -blocks);
+}
+
 extern int xfs_mount_reset_sbqflags(struct xfs_mount *);
 
 #endif	/* __XFS_QUOTA_H__ */
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 183142fd0961..bea64ed5a57f 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -508,9 +508,8 @@ xfs_reflink_cancel_cow_blocks(
 			xfs_bmap_del_extent_cow(ip, &icur, &got, &del);
 
 			/* Remove the quota reservation */
-			error = xfs_trans_unreserve_quota_nblks(NULL, ip,
-					del.br_blockcount, 0,
-					XFS_QMOPT_RES_REGBLKS);
+			error = xfs_quota_unreserve_blkres(ip,
+					del.br_blockcount);
 			if (error)
 				break;
 		} else {

