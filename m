Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4196DA157
	for <lists+linux-xfs@lfdr.de>; Thu,  6 Apr 2023 21:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbjDFTc5 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 6 Apr 2023 15:32:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjDFTc4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:32:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DCCBC3
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:32:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D28260EFE
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:32:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07039C433EF;
        Thu,  6 Apr 2023 19:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680809573;
        bh=5XTb5nQH234SvOm3NHS2rzV0lSmqAYQarf7AGkeOk8Q=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=PEHeJkqtWe6UncBsYMbjPr3b9kpCor/4kVK6dOrhYO0LRmTeFuVkGYJwPWb7KviK4
         NPrEc0KO3Oi5hYlYtRZsLnOo1ijaBrJznDNFw8hdZwZb3Pmyj0bPg4LtBhZwOuh7wm
         qfuHMl+9acueikH0HUaPtnwrQiANa2/+S/fE1DalVu9pUT5F4w1j7EO27n4iwy/4Ml
         5GtffZIwaQA7jlW/nlMtW/Lhp3jGo+NxolxwhpFydegteVUwJnhqL1KWkBHdX0qdlk
         wpxi5N4QhVQsKQUv1bxeyUUs0eRNdNW5Livs8sg09cR9PojEZgPQOuUcj7W57wMLev
         kFr64qjsccAVA==
Date:   Thu, 06 Apr 2023 12:32:52 -0700
Subject: [PATCH 05/32] xfs: extend transaction reservations for parent
 attributes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080827623.616793.11046251915219134205.stgit@frogsfrogsfrogs>
In-Reply-To: <168080827546.616793.7264157843231723676.stgit@frogsfrogsfrogs>
References: <168080827546.616793.7264157843231723676.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

We need to add, remove or modify parent pointer attributes during
create/link/unlink/rename operations atomically with the dirents in the
parent directories being modified. This means they need to be modified
in the same transaction as the parent directories, and so we need to add
the required space for the attribute modifications to the transaction
reservations.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: fix indenting errors, adjust for new log format]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_priv.h    |    1 
 libxfs/xfs_trans_resv.c |  324 +++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 273 insertions(+), 52 deletions(-)


diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 98966f584..db6c40131 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -523,6 +523,7 @@ static inline int retzero(void) { return 0; }
 
 #define xfs_icreate_log(tp, agno, agbno, cnt, isize, len, gen) ((void) 0)
 #define xfs_sb_validate_fsb_count(sbp, nblks)		(0)
+#define xlog_calc_iovec_len(len)		roundup(len, sizeof(uint32_t))
 
 /*
  * Prototypes for kernel static functions that are aren't in their
diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index 04c444806..b555d455f 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -18,6 +18,7 @@
 #include "xfs_trans.h"
 #include "xfs_trans_space.h"
 #include "xfs_quota_defs.h"
+#include "xfs_da_format.h"
 
 #define _ALLOC	true
 #define _FREE	false
@@ -419,29 +420,110 @@ xfs_calc_itruncate_reservation_minlogsize(
 	return xfs_calc_itruncate_reservation(mp, true);
 }
 
+static inline unsigned int xfs_calc_pptr_link_overhead(void)
+{
+	return sizeof(struct xfs_attri_log_format) +
+			xlog_calc_iovec_len(sizeof(struct xfs_parent_name_rec)) +
+			xlog_calc_iovec_len(XFS_PARENT_DIRENT_NAME_MAX_SIZE);
+}
+static inline unsigned int xfs_calc_pptr_unlink_overhead(void)
+{
+	return sizeof(struct xfs_attri_log_format) +
+			xlog_calc_iovec_len(sizeof(struct xfs_parent_name_rec)) +
+			xlog_calc_iovec_len(XFS_PARENT_DIRENT_NAME_MAX_SIZE);
+}
+static inline unsigned int xfs_calc_pptr_replace_overhead(void)
+{
+	return sizeof(struct xfs_attri_log_format) +
+			xlog_calc_iovec_len(sizeof(struct xfs_parent_name_rec)) +
+			xlog_calc_iovec_len(XFS_PARENT_DIRENT_NAME_MAX_SIZE) +
+			xlog_calc_iovec_len(sizeof(struct xfs_parent_name_rec)) +
+			xlog_calc_iovec_len(XFS_PARENT_DIRENT_NAME_MAX_SIZE);
+}
+
 /*
  * In renaming a files we can modify:
  *    the five inodes involved: 5 * inode size
  *    the two directory btrees: 2 * (max depth + v2) * dir block size
  *    the two directory bmap btrees: 2 * max depth * block size
  * And the bmap_finish transaction can free dir and bmap blocks (two sets
- *	of bmap blocks) giving:
+ *	of bmap blocks) giving (t2):
  *    the agf for the ags in which the blocks live: 3 * sector size
  *    the agfl for the ags in which the blocks live: 3 * sector size
  *    the superblock for the free block count: sector size
  *    the allocation btrees: 3 exts * 2 trees * (2 * max depth - 1) * block size
+ * If parent pointers are enabled (t3), then each transaction in the chain
+ *    must be capable of setting or removing the extended attribute
+ *    containing the parent information.  It must also be able to handle
+ *    the three xattr intent items that track the progress of the parent
+ *    pointer update.
  */
 STATIC uint
 xfs_calc_rename_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
-		max((xfs_calc_inode_res(mp, 5) +
-		     xfs_calc_buf_res(2 * XFS_DIROP_LOG_COUNT(mp),
-				      XFS_FSB_TO_B(mp, 1))),
-		    (xfs_calc_buf_res(7, mp->m_sb.sb_sectsize) +
-		     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 3),
-				      XFS_FSB_TO_B(mp, 1))));
+	unsigned int		overhead = XFS_DQUOT_LOGRES(mp);
+	struct xfs_trans_resv	*resp = M_RES(mp);
+	unsigned int		t1, t2, t3 = 0;
+
+	t1 = xfs_calc_inode_res(mp, 5) +
+	     xfs_calc_buf_res(2 * XFS_DIROP_LOG_COUNT(mp),
+			XFS_FSB_TO_B(mp, 1));
+
+	t2 = xfs_calc_buf_res(7, mp->m_sb.sb_sectsize) +
+	     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 3),
+			XFS_FSB_TO_B(mp, 1));
+
+	if (xfs_has_parent(mp)) {
+		unsigned int	rename_overhead, exchange_overhead;
+
+		t3 = max(resp->tr_attrsetm.tr_logres,
+			 resp->tr_attrrm.tr_logres);
+
+		/*
+		 * For a standard rename, the three xattr intent log items
+		 * are (1) replacing the pptr for the source file; (2)
+		 * removing the pptr on the dest file; and (3) adding a
+		 * pptr for the whiteout file in the src dir.
+		 *
+		 * For an RENAME_EXCHANGE, there are two xattr intent
+		 * items to replace the pptr for both src and dest
+		 * files.  Link counts don't change and there is no
+		 * whiteout.
+		 *
+		 * In the worst case we can end up relogging all log
+		 * intent items to allow the log tail to move ahead, so
+		 * they become overhead added to each transaction in a
+		 * processing chain.
+		 */
+		rename_overhead = xfs_calc_pptr_replace_overhead() +
+				  xfs_calc_pptr_unlink_overhead() +
+				  xfs_calc_pptr_link_overhead();
+		exchange_overhead = 2 * xfs_calc_pptr_replace_overhead();
+
+		overhead += max(rename_overhead, exchange_overhead);
+	}
+
+	return overhead + max3(t1, t2, t3);
+}
+
+static inline unsigned int
+xfs_rename_log_count(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	/* One for the rename, one more for freeing blocks */
+	unsigned int		ret = XFS_RENAME_LOG_COUNT;
+
+	/*
+	 * Pre-reserve enough log reservation to handle the transaction
+	 * rolling needed to remove or add one parent pointer.
+	 */
+	if (xfs_has_parent(mp))
+		ret += max(resp->tr_attrsetm.tr_logcount,
+			   resp->tr_attrrm.tr_logcount);
+
+	return ret;
 }
 
 /*
@@ -458,6 +540,23 @@ xfs_calc_iunlink_remove_reservation(
 	       2 * M_IGEO(mp)->inode_cluster_size;
 }
 
+static inline unsigned int
+xfs_link_log_count(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	unsigned int		ret = XFS_LINK_LOG_COUNT;
+
+	/*
+	 * Pre-reserve enough log reservation to handle the transaction
+	 * rolling needed to add one parent pointer.
+	 */
+	if (xfs_has_parent(mp))
+		ret += resp->tr_attrsetm.tr_logcount;
+
+	return ret;
+}
+
 /*
  * For creating a link to an inode:
  *    the parent directory inode: inode size
@@ -474,14 +573,23 @@ STATIC uint
 xfs_calc_link_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
-		xfs_calc_iunlink_remove_reservation(mp) +
-		max((xfs_calc_inode_res(mp, 2) +
-		     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
-				      XFS_FSB_TO_B(mp, 1))),
-		    (xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
-		     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 1),
-				      XFS_FSB_TO_B(mp, 1))));
+	unsigned int		overhead = XFS_DQUOT_LOGRES(mp);
+	struct xfs_trans_resv	*resp = M_RES(mp);
+	unsigned int		t1, t2, t3 = 0;
+
+	overhead += xfs_calc_iunlink_remove_reservation(mp);
+	t1 = xfs_calc_inode_res(mp, 2) +
+	     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp), XFS_FSB_TO_B(mp, 1));
+	t2 = xfs_calc_buf_res(3, mp->m_sb.sb_sectsize) +
+	     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 1),
+			      XFS_FSB_TO_B(mp, 1));
+
+	if (xfs_has_parent(mp)) {
+		t3 = resp->tr_attrsetm.tr_logres;
+		overhead += xfs_calc_pptr_link_overhead();
+	}
+
+	return overhead + max3(t1, t2, t3);
 }
 
 /*
@@ -496,6 +604,23 @@ xfs_calc_iunlink_add_reservation(xfs_mount_t *mp)
 			M_IGEO(mp)->inode_cluster_size;
 }
 
+static inline unsigned int
+xfs_remove_log_count(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	unsigned int		ret = XFS_REMOVE_LOG_COUNT;
+
+	/*
+	 * Pre-reserve enough log reservation to handle the transaction
+	 * rolling needed to add one parent pointer.
+	 */
+	if (xfs_has_parent(mp))
+		ret += resp->tr_attrrm.tr_logcount;
+
+	return ret;
+}
+
 /*
  * For removing a directory entry we can modify:
  *    the parent directory inode: inode size
@@ -512,14 +637,24 @@ STATIC uint
 xfs_calc_remove_reservation(
 	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
-		xfs_calc_iunlink_add_reservation(mp) +
-		max((xfs_calc_inode_res(mp, 2) +
-		     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
-				      XFS_FSB_TO_B(mp, 1))),
-		    (xfs_calc_buf_res(4, mp->m_sb.sb_sectsize) +
-		     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 2),
-				      XFS_FSB_TO_B(mp, 1))));
+	unsigned int            overhead = XFS_DQUOT_LOGRES(mp);
+	struct xfs_trans_resv   *resp = M_RES(mp);
+	unsigned int            t1, t2, t3 = 0;
+
+	overhead += xfs_calc_iunlink_add_reservation(mp);
+
+	t1 = xfs_calc_inode_res(mp, 2) +
+	     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp), XFS_FSB_TO_B(mp, 1));
+	t2 = xfs_calc_buf_res(4, mp->m_sb.sb_sectsize) +
+	     xfs_calc_buf_res(xfs_allocfree_block_count(mp, 2),
+			      XFS_FSB_TO_B(mp, 1));
+
+	if (xfs_has_parent(mp)) {
+		t3 = resp->tr_attrrm.tr_logres;
+		overhead += xfs_calc_pptr_unlink_overhead();
+	}
+
+	return overhead + max3(t1, t2, t3);
 }
 
 /*
@@ -568,12 +703,40 @@ xfs_calc_icreate_resv_alloc(
 		xfs_calc_finobt_res(mp);
 }
 
+static inline unsigned int
+xfs_icreate_log_count(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	unsigned int		ret = XFS_CREATE_LOG_COUNT;
+
+	/*
+	 * Pre-reserve enough log reservation to handle the transaction
+	 * rolling needed to add one parent pointer.
+	 */
+	if (xfs_has_parent(mp))
+		ret += resp->tr_attrsetm.tr_logcount;
+
+	return ret;
+}
+
 STATIC uint
-xfs_calc_icreate_reservation(xfs_mount_t *mp)
+xfs_calc_icreate_reservation(
+	struct xfs_mount	*mp)
 {
-	return XFS_DQUOT_LOGRES(mp) +
-		max(xfs_calc_icreate_resv_alloc(mp),
-		    xfs_calc_create_resv_modify(mp));
+	struct xfs_trans_resv	*resp = M_RES(mp);
+	unsigned int		overhead = XFS_DQUOT_LOGRES(mp);
+	unsigned int		t1, t2, t3 = 0;
+
+	t1 = xfs_calc_icreate_resv_alloc(mp);
+	t2 = xfs_calc_create_resv_modify(mp);
+
+	if (xfs_has_parent(mp)) {
+		t3 = resp->tr_attrsetm.tr_logres;
+		overhead += xfs_calc_pptr_link_overhead();
+	}
+
+	return overhead + max3(t1, t2, t3);
 }
 
 STATIC uint
@@ -586,6 +749,23 @@ xfs_calc_create_tmpfile_reservation(
 	return res + xfs_calc_iunlink_add_reservation(mp);
 }
 
+static inline unsigned int
+xfs_mkdir_log_count(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	unsigned int		ret = XFS_MKDIR_LOG_COUNT;
+
+	/*
+	 * Pre-reserve enough log reservation to handle the transaction
+	 * rolling needed to add one parent pointer.
+	 */
+	if (xfs_has_parent(mp))
+		ret += resp->tr_attrsetm.tr_logcount;
+
+	return ret;
+}
+
 /*
  * Making a new directory is the same as creating a new file.
  */
@@ -596,6 +776,22 @@ xfs_calc_mkdir_reservation(
 	return xfs_calc_icreate_reservation(mp);
 }
 
+static inline unsigned int
+xfs_symlink_log_count(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	unsigned int		ret = XFS_SYMLINK_LOG_COUNT;
+
+	/*
+	 * Pre-reserve enough log reservation to handle the transaction
+	 * rolling needed to add one parent pointer.
+	 */
+	if (xfs_has_parent(mp))
+		ret += resp->tr_attrsetm.tr_logcount;
+
+	return ret;
+}
 
 /*
  * Making a new symplink is the same as creating a new file, but
@@ -908,6 +1104,52 @@ xfs_calc_sb_reservation(
 	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize);
 }
 
+/*
+ * Namespace reservations.
+ *
+ * These get tricky when parent pointers are enabled as we have attribute
+ * modifications occurring from within these transactions. Rather than confuse
+ * each of these reservation calculations with the conditional attribute
+ * reservations, add them here in a clear and concise manner. This requires that
+ * the attribute reservations have already been calculated.
+ *
+ * Note that we only include the static attribute reservation here; the runtime
+ * reservation will have to be modified by the size of the attributes being
+ * added/removed/modified. See the comments on the attribute reservation
+ * calculations for more details.
+ */
+STATIC void
+xfs_calc_namespace_reservations(
+	struct xfs_mount	*mp,
+	struct xfs_trans_resv	*resp)
+{
+	ASSERT(resp->tr_attrsetm.tr_logres > 0);
+
+	resp->tr_rename.tr_logres = xfs_calc_rename_reservation(mp);
+	resp->tr_rename.tr_logcount = xfs_rename_log_count(mp, resp);
+	resp->tr_rename.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+
+	resp->tr_link.tr_logres = xfs_calc_link_reservation(mp);
+	resp->tr_link.tr_logcount = xfs_link_log_count(mp, resp);
+	resp->tr_link.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+
+	resp->tr_remove.tr_logres = xfs_calc_remove_reservation(mp);
+	resp->tr_remove.tr_logcount = xfs_remove_log_count(mp, resp);
+	resp->tr_remove.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+
+	resp->tr_symlink.tr_logres = xfs_calc_symlink_reservation(mp);
+	resp->tr_symlink.tr_logcount = xfs_symlink_log_count(mp, resp);
+	resp->tr_symlink.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+
+	resp->tr_create.tr_logres = xfs_calc_icreate_reservation(mp);
+	resp->tr_create.tr_logcount = xfs_icreate_log_count(mp, resp);
+	resp->tr_create.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+
+	resp->tr_mkdir.tr_logres = xfs_calc_mkdir_reservation(mp);
+	resp->tr_mkdir.tr_logcount = xfs_mkdir_log_count(mp, resp);
+	resp->tr_mkdir.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
+}
+
 void
 xfs_trans_resv_calc(
 	struct xfs_mount	*mp,
@@ -927,35 +1169,11 @@ xfs_trans_resv_calc(
 	resp->tr_itruncate.tr_logcount = XFS_ITRUNCATE_LOG_COUNT;
 	resp->tr_itruncate.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
-	resp->tr_rename.tr_logres = xfs_calc_rename_reservation(mp);
-	resp->tr_rename.tr_logcount = XFS_RENAME_LOG_COUNT;
-	resp->tr_rename.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
-
-	resp->tr_link.tr_logres = xfs_calc_link_reservation(mp);
-	resp->tr_link.tr_logcount = XFS_LINK_LOG_COUNT;
-	resp->tr_link.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
-
-	resp->tr_remove.tr_logres = xfs_calc_remove_reservation(mp);
-	resp->tr_remove.tr_logcount = XFS_REMOVE_LOG_COUNT;
-	resp->tr_remove.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
-
-	resp->tr_symlink.tr_logres = xfs_calc_symlink_reservation(mp);
-	resp->tr_symlink.tr_logcount = XFS_SYMLINK_LOG_COUNT;
-	resp->tr_symlink.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
-
-	resp->tr_create.tr_logres = xfs_calc_icreate_reservation(mp);
-	resp->tr_create.tr_logcount = XFS_CREATE_LOG_COUNT;
-	resp->tr_create.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
-
 	resp->tr_create_tmpfile.tr_logres =
 			xfs_calc_create_tmpfile_reservation(mp);
 	resp->tr_create_tmpfile.tr_logcount = XFS_CREATE_TMPFILE_LOG_COUNT;
 	resp->tr_create_tmpfile.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
-	resp->tr_mkdir.tr_logres = xfs_calc_mkdir_reservation(mp);
-	resp->tr_mkdir.tr_logcount = XFS_MKDIR_LOG_COUNT;
-	resp->tr_mkdir.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
-
 	resp->tr_ifree.tr_logres = xfs_calc_ifree_reservation(mp);
 	resp->tr_ifree.tr_logcount = XFS_INACTIVE_LOG_COUNT;
 	resp->tr_ifree.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
@@ -985,6 +1203,8 @@ xfs_trans_resv_calc(
 	resp->tr_qm_dqalloc.tr_logcount = XFS_WRITE_LOG_COUNT;
 	resp->tr_qm_dqalloc.tr_logflags |= XFS_TRANS_PERM_LOG_RES;
 
+	xfs_calc_namespace_reservations(mp, resp);
+
 	/*
 	 * The following transactions are logged in logical format with
 	 * a default log count.

