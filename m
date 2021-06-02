Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA49D3995E1
	for <lists+linux-xfs@lfdr.de>; Thu,  3 Jun 2021 00:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbhFBW0q (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 2 Jun 2021 18:26:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:43020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229576AbhFBW0q (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 Jun 2021 18:26:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB53E613AC;
        Wed,  2 Jun 2021 22:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622672702;
        bh=q6/HzbGNM1cHtz75NwaMucCqPONwxUICQSoVFnvWASU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=JXL0PWL2FxPncJF0zjBg97r1OiCmxq+pvsMlfzDqwUZQMOMThL1V/yrclyRUnn8+U
         fSOyKYx+IEKXxU0dLMVPTNNop8YSIihsjnYCqREuP2SaSr30b5zhPdrsUUpBJex5fY
         OwXsItvFZ0jrwGU3tEt3Kk5urfe7dXIpexehS25MxEjlg9r0iqFumR2aeKe8B6cnUi
         +o7L9o/ehDnOLS6bs1AYTt5ydEfoKNksKm34phYlAJlIneBQwfU0el26mXalpZE0fd
         3TtqOcQlihF0oop5+MWke7nXv6lbMGAmftovLZCOT/QzhDkvSykFFpL9zwWKzP8e9G
         gSgfsCtRxwWzQ==
Subject: [PATCH 01/15] xfs: move the quotaoff dqrele inode walk into
 xfs_icache.c
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        david@fromorbit.com, hch@infradead.org
Date:   Wed, 02 Jun 2021 15:25:02 -0700
Message-ID: <162267270255.2375284.1543209092353216258.stgit@locust>
In-Reply-To: <162267269663.2375284.15885514656776142361.stgit@locust>
References: <162267269663.2375284.15885514656776142361.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The only external caller of xfs_inode_walk* happens in quotaoff, when we
want to walk all the incore inodes to detach the dquots.  Move this code
to xfs_icache.c so that we can hide xfs_inode_walk as the starting step
in more cleanups of inode walks.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_icache.c      |   65 +++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_icache.h      |    8 ++++--
 fs/xfs/xfs_qm.h          |    1 -
 fs/xfs/xfs_qm_syscalls.c |   54 +-------------------------------------
 4 files changed, 71 insertions(+), 57 deletions(-)


diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 3c81daca0e9a..e2edbcf7a528 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -26,6 +26,18 @@
 
 #include <linux/iversion.h>
 
+/*
+ * Private inode cache walk flags for struct xfs_eofblocks.  Must not coincide
+ * with XFS_EOF_FLAGS_*.
+ */
+#define XFS_ICWALK_FLAG_DROP_UDQUOT	(1U << 31)
+#define XFS_ICWALK_FLAG_DROP_GDQUOT	(1U << 30)
+#define XFS_ICWALK_FLAG_DROP_PDQUOT	(1U << 29)
+
+#define XFS_ICWALK_PRIVATE_FLAGS	(XFS_ICWALK_FLAG_DROP_UDQUOT | \
+					 XFS_ICWALK_FLAG_DROP_GDQUOT | \
+					 XFS_ICWALK_FLAG_DROP_PDQUOT)
+
 /*
  * Allocate and initialise an xfs_inode.
  */
@@ -890,7 +902,7 @@ xfs_inode_walk_get_perag(
  * Call the @execute function on all incore inodes matching the radix tree
  * @tag.
  */
-int
+static int
 xfs_inode_walk(
 	struct xfs_mount	*mp,
 	int			iter_flags,
@@ -915,8 +927,59 @@ xfs_inode_walk(
 		}
 	}
 	return last_error;
+	BUILD_BUG_ON(XFS_ICWALK_PRIVATE_FLAGS & XFS_EOF_FLAGS_VALID);
 }
 
+#ifdef CONFIG_XFS_QUOTA
+/* Drop this inode's dquots. */
+static int
+xfs_dqrele_inode(
+	struct xfs_inode	*ip,
+	void			*priv)
+{
+	struct xfs_eofblocks	*eofb = priv;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+	if (eofb->eof_flags & XFS_ICWALK_FLAG_DROP_UDQUOT) {
+		xfs_qm_dqrele(ip->i_udquot);
+		ip->i_udquot = NULL;
+	}
+	if (eofb->eof_flags & XFS_ICWALK_FLAG_DROP_GDQUOT) {
+		xfs_qm_dqrele(ip->i_gdquot);
+		ip->i_gdquot = NULL;
+	}
+	if (eofb->eof_flags & XFS_ICWALK_FLAG_DROP_PDQUOT) {
+		xfs_qm_dqrele(ip->i_pdquot);
+		ip->i_pdquot = NULL;
+	}
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return 0;
+}
+
+/*
+ * Detach all dquots from incore inodes if we can.  The caller must already
+ * have dropped the relevant XFS_[UGP]QUOTA_ACTIVE flags so that dquots will
+ * not get reattached.
+ */
+int
+xfs_dqrele_all_inodes(
+	struct xfs_mount	*mp,
+	unsigned int		qflags)
+{
+	struct xfs_eofblocks	eofb = { .eof_flags = 0 };
+
+	if (qflags & XFS_UQUOTA_ACCT)
+		eofb.eof_flags |= XFS_ICWALK_FLAG_DROP_UDQUOT;
+	if (qflags & XFS_GQUOTA_ACCT)
+		eofb.eof_flags |= XFS_ICWALK_FLAG_DROP_GDQUOT;
+	if (qflags & XFS_PQUOTA_ACCT)
+		eofb.eof_flags |= XFS_ICWALK_FLAG_DROP_PDQUOT;
+
+	return xfs_inode_walk(mp, XFS_INODE_WALK_INEW_WAIT, xfs_dqrele_inode,
+			&eofb, XFS_ICI_NO_TAG);
+}
+#endif /* CONFIG_XFS_QUOTA */
+
 /*
  * Grab the inode for reclaim exclusively.
  *
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index d1fddb152420..d9baa6df1121 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -68,9 +68,11 @@ void xfs_inode_clear_cowblocks_tag(struct xfs_inode *ip);
 
 void xfs_blockgc_worker(struct work_struct *work);
 
-int xfs_inode_walk(struct xfs_mount *mp, int iter_flags,
-	int (*execute)(struct xfs_inode *ip, void *args),
-	void *args, int tag);
+#ifdef CONFIG_XFS_QUOTA
+int xfs_dqrele_all_inodes(struct xfs_mount *mp, unsigned int qflags);
+#else
+# define xfs_dqrele_all_inodes(mp, qflags)	(0)
+#endif
 
 int xfs_icache_inode_is_allocated(struct xfs_mount *mp, struct xfs_trans *tp,
 				  xfs_ino_t ino, bool *inuse);
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index e3dabab44097..ebbb484c49dc 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -142,7 +142,6 @@ extern void		xfs_qm_destroy_quotainfo(struct xfs_mount *);
 
 /* dquot stuff */
 extern void		xfs_qm_dqpurge_all(struct xfs_mount *, uint);
-extern void		xfs_qm_dqrele_all_inodes(struct xfs_mount *, uint);
 
 /* quota ops */
 extern int		xfs_qm_scall_trunc_qfiles(struct xfs_mount *, uint);
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 11f1e2fbf22f..13a56e1ea15c 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -201,7 +201,8 @@ xfs_qm_scall_quotaoff(
 	 * depend on the quota inodes (and other things) being valid as long as
 	 * we keep the lock(s).
 	 */
-	xfs_qm_dqrele_all_inodes(mp, flags);
+	error = xfs_dqrele_all_inodes(mp, flags);
+	ASSERT(!error);
 
 	/*
 	 * Next we make the changes in the quota flag in the mount struct.
@@ -747,54 +748,3 @@ xfs_qm_scall_getquota_next(
 	xfs_qm_dqput(dqp);
 	return error;
 }
-
-STATIC int
-xfs_dqrele_inode(
-	struct xfs_inode	*ip,
-	void			*args)
-{
-	uint			*flags = args;
-
-	/* skip quota inodes */
-	if (ip == ip->i_mount->m_quotainfo->qi_uquotaip ||
-	    ip == ip->i_mount->m_quotainfo->qi_gquotaip ||
-	    ip == ip->i_mount->m_quotainfo->qi_pquotaip) {
-		ASSERT(ip->i_udquot == NULL);
-		ASSERT(ip->i_gdquot == NULL);
-		ASSERT(ip->i_pdquot == NULL);
-		return 0;
-	}
-
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	if ((*flags & XFS_UQUOTA_ACCT) && ip->i_udquot) {
-		xfs_qm_dqrele(ip->i_udquot);
-		ip->i_udquot = NULL;
-	}
-	if ((*flags & XFS_GQUOTA_ACCT) && ip->i_gdquot) {
-		xfs_qm_dqrele(ip->i_gdquot);
-		ip->i_gdquot = NULL;
-	}
-	if ((*flags & XFS_PQUOTA_ACCT) && ip->i_pdquot) {
-		xfs_qm_dqrele(ip->i_pdquot);
-		ip->i_pdquot = NULL;
-	}
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	return 0;
-}
-
-
-/*
- * Go thru all the inodes in the file system, releasing their dquots.
- *
- * Note that the mount structure gets modified to indicate that quotas are off
- * AFTER this, in the case of quotaoff.
- */
-void
-xfs_qm_dqrele_all_inodes(
-	struct xfs_mount	*mp,
-	uint			flags)
-{
-	ASSERT(mp->m_quotainfo);
-	xfs_inode_walk(mp, XFS_INODE_WALK_INEW_WAIT, xfs_dqrele_inode,
-			&flags, XFS_ICI_NO_TAG);
-}

