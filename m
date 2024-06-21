Return-Path: <linux-xfs+bounces-9632-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D802911631
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Jun 2024 01:01:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D45B01F21E80
	for <lists+linux-xfs@lfdr.de>; Thu, 20 Jun 2024 23:01:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8449482D83;
	Thu, 20 Jun 2024 23:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ai7y9kc/"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43292C8FB
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 23:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718924508; cv=none; b=W9UEdY/k8oYYKuieL6Tf/FlAtMHwCPCGFNCspPhJZ5v4DeTuSQdSXw97i4f6i5mrBn7+Wcq/HPX+YKHw8TpDUYP3iUzmnAdL93m9B3UdAsxVaI+pH6lWvy65W1OpGZ28TW8tTzNfvWoed5JTpjxoz6h5fVzGlnQKzIEz2gTh3EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718924508; c=relaxed/simple;
	bh=g5ExS2BhJ2B8S7ugaz84F/nUX44UwyTk/cThEPRlJgk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R4+uJ73vUbccnNr6LyGQeRlnA8W5SQ00xZlNqNTN6hGiIlch6vm4UCJ9ekpQ/TassPkG3CjBx2c8C8V0uNCn+pZ9jaiN5JTA4I14jwWOgL8ev/O76TBHB9BB1VJZjbLWNIJCsR7o/57EOjP9lzKbuq6VXJw1/lLX+phB646rzpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ai7y9kc/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10525C32781;
	Thu, 20 Jun 2024 23:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718924508;
	bh=g5ExS2BhJ2B8S7ugaz84F/nUX44UwyTk/cThEPRlJgk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ai7y9kc/7uF9w6h5a9JZtbdJjwNgRlUvt74A5ZayhVLWZwLuNIW0rGaa82TLrLnAK
	 GCPI2XLl1b1gqnudJr/c2gI1342Rokns3onaCQAuwwuOe6yay824hDEa+mI84LWx8U
	 QqERbGAuoSvvyIix4amoCB3+4Jw80vqDRjR/SlMBoUCUrM6hZT+Xf54t8DxgaHipY0
	 iwisiaiqNeqfjRrgxf+bCyMGh6X0LpzUs3lOYDUTliM2xeSNe/s7ltC7KS6ehrKFKG
	 s9l3Po0PgYZEbapAh9E9b7TbNsDDGNrPUBfk47OD39tcr5FOcvBWODQfmgEIUqH28t
	 sMz4Aer8IyxQg==
Date: Thu, 20 Jun 2024 16:01:47 -0700
Subject: [PATCH 13/24] xfs: hoist xfs_iunlink to libxfs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892418120.3183075.7790758345120309903.stgit@frogsfrogsfrogs>
In-Reply-To: <171892417831.3183075.10759987417835165626.stgit@frogsfrogsfrogs>
References: <171892417831.3183075.10759987417835165626.stgit@frogsfrogsfrogs>
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

Move xfs_iunlink and xfs_iunlink_remove to libxfs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_inode_util.c |  282 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_util.h |    4 +
 fs/xfs/xfs_inode.c             |  280 ----------------------------------------
 fs/xfs/xfs_inode.h             |    5 -
 4 files changed, 289 insertions(+), 282 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
index 8654cb3d79efb..5739871ac3705 100644
--- a/fs/xfs/libxfs/xfs_inode_util.c
+++ b/fs/xfs/libxfs/xfs_inode_util.c
@@ -18,6 +18,10 @@
 #include "xfs_ialloc.h"
 #include "xfs_health.h"
 #include "xfs_bmap.h"
+#include "xfs_error.h"
+#include "xfs_trace.h"
+#include "xfs_ag.h"
+#include "xfs_iunlink_item.h"
 
 uint16_t
 xfs_flags2diflags(
@@ -344,3 +348,281 @@ xfs_inode_init(
 
 	xfs_trans_log_inode(tp, ip, flags);
 }
+
+/*
+ * In-Core Unlinked List Lookups
+ * =============================
+ *
+ * Every inode is supposed to be reachable from some other piece of metadata
+ * with the exception of the root directory.  Inodes with a connection to a
+ * file descriptor but not linked from anywhere in the on-disk directory tree
+ * are collectively known as unlinked inodes, though the filesystem itself
+ * maintains links to these inodes so that on-disk metadata are consistent.
+ *
+ * XFS implements a per-AG on-disk hash table of unlinked inodes.  The AGI
+ * header contains a number of buckets that point to an inode, and each inode
+ * record has a pointer to the next inode in the hash chain.  This
+ * singly-linked list causes scaling problems in the iunlink remove function
+ * because we must walk that list to find the inode that points to the inode
+ * being removed from the unlinked hash bucket list.
+ *
+ * Hence we keep an in-memory double linked list to link each inode on an
+ * unlinked list. Because there are 64 unlinked lists per AGI, keeping pointer
+ * based lists would require having 64 list heads in the perag, one for each
+ * list. This is expensive in terms of memory (think millions of AGs) and cache
+ * misses on lookups. Instead, use the fact that inodes on the unlinked list
+ * must be referenced at the VFS level to keep them on the list and hence we
+ * have an existence guarantee for inodes on the unlinked list.
+ *
+ * Given we have an existence guarantee, we can use lockless inode cache lookups
+ * to resolve aginos to xfs inodes. This means we only need 8 bytes per inode
+ * for the double linked unlinked list, and we don't need any extra locking to
+ * keep the list safe as all manipulations are done under the AGI buffer lock.
+ * Keeping the list up to date does not require memory allocation, just finding
+ * the XFS inode and updating the next/prev unlinked list aginos.
+ */
+
+/*
+ * Update the prev pointer of the next agino.  Returns -ENOLINK if the inode
+ * is not in cache.
+ */
+static int
+xfs_iunlink_update_backref(
+	struct xfs_perag	*pag,
+	xfs_agino_t		prev_agino,
+	xfs_agino_t		next_agino)
+{
+	struct xfs_inode	*ip;
+
+	/* No update necessary if we are at the end of the list. */
+	if (next_agino == NULLAGINO)
+		return 0;
+
+	ip = xfs_iunlink_lookup(pag, next_agino);
+	if (!ip)
+		return -ENOLINK;
+
+	ip->i_prev_unlinked = prev_agino;
+	return 0;
+}
+
+/*
+ * Point the AGI unlinked bucket at an inode and log the results.  The caller
+ * is responsible for validating the old value.
+ */
+STATIC int
+xfs_iunlink_update_bucket(
+	struct xfs_trans	*tp,
+	struct xfs_perag	*pag,
+	struct xfs_buf		*agibp,
+	unsigned int		bucket_index,
+	xfs_agino_t		new_agino)
+{
+	struct xfs_agi		*agi = agibp->b_addr;
+	xfs_agino_t		old_value;
+	int			offset;
+
+	ASSERT(xfs_verify_agino_or_null(pag, new_agino));
+
+	old_value = be32_to_cpu(agi->agi_unlinked[bucket_index]);
+	trace_xfs_iunlink_update_bucket(tp->t_mountp, pag->pag_agno, bucket_index,
+			old_value, new_agino);
+
+	/*
+	 * We should never find the head of the list already set to the value
+	 * passed in because either we're adding or removing ourselves from the
+	 * head of the list.
+	 */
+	if (old_value == new_agino) {
+		xfs_buf_mark_corrupt(agibp);
+		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
+		return -EFSCORRUPTED;
+	}
+
+	agi->agi_unlinked[bucket_index] = cpu_to_be32(new_agino);
+	offset = offsetof(struct xfs_agi, agi_unlinked) +
+			(sizeof(xfs_agino_t) * bucket_index);
+	xfs_trans_log_buf(tp, agibp, offset, offset + sizeof(xfs_agino_t) - 1);
+	return 0;
+}
+
+static int
+xfs_iunlink_insert_inode(
+	struct xfs_trans	*tp,
+	struct xfs_perag	*pag,
+	struct xfs_buf		*agibp,
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_agi		*agi = agibp->b_addr;
+	xfs_agino_t		next_agino;
+	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
+	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
+	int			error;
+
+	/*
+	 * Get the index into the agi hash table for the list this inode will
+	 * go on.  Make sure the pointer isn't garbage and that this inode
+	 * isn't already on the list.
+	 */
+	next_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
+	if (next_agino == agino ||
+	    !xfs_verify_agino_or_null(pag, next_agino)) {
+		xfs_buf_mark_corrupt(agibp);
+		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
+		return -EFSCORRUPTED;
+	}
+
+	/*
+	 * Update the prev pointer in the next inode to point back to this
+	 * inode.
+	 */
+	error = xfs_iunlink_update_backref(pag, agino, next_agino);
+	if (error == -ENOLINK)
+		error = xfs_iunlink_reload_next(tp, agibp, agino, next_agino);
+	if (error)
+		return error;
+
+	if (next_agino != NULLAGINO) {
+		/*
+		 * There is already another inode in the bucket, so point this
+		 * inode to the current head of the list.
+		 */
+		error = xfs_iunlink_log_inode(tp, ip, pag, next_agino);
+		if (error)
+			return error;
+		ip->i_next_unlinked = next_agino;
+	}
+
+	/* Point the head of the list to point to this inode. */
+	ip->i_prev_unlinked = NULLAGINO;
+	return xfs_iunlink_update_bucket(tp, pag, agibp, bucket_index, agino);
+}
+
+/*
+ * This is called when the inode's link count has gone to 0 or we are creating
+ * a tmpfile via O_TMPFILE.  The inode @ip must have nlink == 0.
+ *
+ * We place the on-disk inode on a list in the AGI.  It will be pulled from this
+ * list when the inode is freed.
+ */
+int
+xfs_iunlink(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_perag	*pag;
+	struct xfs_buf		*agibp;
+	int			error;
+
+	ASSERT(VFS_I(ip)->i_nlink == 0);
+	ASSERT(VFS_I(ip)->i_mode != 0);
+	trace_xfs_iunlink(ip);
+
+	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
+
+	/* Get the agi buffer first.  It ensures lock ordering on the list. */
+	error = xfs_read_agi(pag, tp, 0, &agibp);
+	if (error)
+		goto out;
+
+	error = xfs_iunlink_insert_inode(tp, pag, agibp, ip);
+out:
+	xfs_perag_put(pag);
+	return error;
+}
+
+static int
+xfs_iunlink_remove_inode(
+	struct xfs_trans	*tp,
+	struct xfs_perag	*pag,
+	struct xfs_buf		*agibp,
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_agi		*agi = agibp->b_addr;
+	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
+	xfs_agino_t		head_agino;
+	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
+	int			error;
+
+	trace_xfs_iunlink_remove(ip);
+
+	/*
+	 * Get the index into the agi hash table for the list this inode will
+	 * go on.  Make sure the head pointer isn't garbage.
+	 */
+	head_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
+	if (!xfs_verify_agino(pag, head_agino)) {
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				agi, sizeof(*agi));
+		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
+		return -EFSCORRUPTED;
+	}
+
+	/*
+	 * Set our inode's next_unlinked pointer to NULL and then return
+	 * the old pointer value so that we can update whatever was previous
+	 * to us in the list to point to whatever was next in the list.
+	 */
+	error = xfs_iunlink_log_inode(tp, ip, pag, NULLAGINO);
+	if (error)
+		return error;
+
+	/*
+	 * Update the prev pointer in the next inode to point back to previous
+	 * inode in the chain.
+	 */
+	error = xfs_iunlink_update_backref(pag, ip->i_prev_unlinked,
+			ip->i_next_unlinked);
+	if (error == -ENOLINK)
+		error = xfs_iunlink_reload_next(tp, agibp, ip->i_prev_unlinked,
+				ip->i_next_unlinked);
+	if (error)
+		return error;
+
+	if (head_agino != agino) {
+		struct xfs_inode	*prev_ip;
+
+		prev_ip = xfs_iunlink_lookup(pag, ip->i_prev_unlinked);
+		if (!prev_ip) {
+			xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
+			return -EFSCORRUPTED;
+		}
+
+		error = xfs_iunlink_log_inode(tp, prev_ip, pag,
+				ip->i_next_unlinked);
+		prev_ip->i_next_unlinked = ip->i_next_unlinked;
+	} else {
+		/* Point the head of the list to the next unlinked inode. */
+		error = xfs_iunlink_update_bucket(tp, pag, agibp, bucket_index,
+				ip->i_next_unlinked);
+	}
+
+	ip->i_next_unlinked = NULLAGINO;
+	ip->i_prev_unlinked = 0;
+	return error;
+}
+
+/*
+ * Pull the on-disk inode from the AGI unlinked list.
+ */
+int
+xfs_iunlink_remove(
+	struct xfs_trans	*tp,
+	struct xfs_perag	*pag,
+	struct xfs_inode	*ip)
+{
+	struct xfs_buf		*agibp;
+	int			error;
+
+	trace_xfs_iunlink_remove(ip);
+
+	/* Get the agi buffer first.  It ensures lock ordering on the list. */
+	error = xfs_read_agi(pag, tp, 0, &agibp);
+	if (error)
+		return error;
+
+	return xfs_iunlink_remove_inode(tp, pag, agibp, ip);
+}
diff --git a/fs/xfs/libxfs/xfs_inode_util.h b/fs/xfs/libxfs/xfs_inode_util.h
index bf5393db4fde6..42a032afe3cac 100644
--- a/fs/xfs/libxfs/xfs_inode_util.h
+++ b/fs/xfs/libxfs/xfs_inode_util.h
@@ -47,4 +47,8 @@ void xfs_trans_ichgtime(struct xfs_trans *tp, struct xfs_inode *ip, int flags);
 void xfs_inode_init(struct xfs_trans *tp, const struct xfs_icreate_args *args,
 		struct xfs_inode *ip);
 
+int xfs_iunlink(struct xfs_trans *tp, struct xfs_inode *ip);
+int xfs_iunlink_remove(struct xfs_trans *tp, struct xfs_perag *pag,
+		struct xfs_inode *ip);
+
 #endif /* __XFS_INODE_UTIL_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 1d7febda38c16..182c63ee36b0e 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1738,39 +1738,6 @@ xfs_inactive(
 	return error;
 }
 
-/*
- * In-Core Unlinked List Lookups
- * =============================
- *
- * Every inode is supposed to be reachable from some other piece of metadata
- * with the exception of the root directory.  Inodes with a connection to a
- * file descriptor but not linked from anywhere in the on-disk directory tree
- * are collectively known as unlinked inodes, though the filesystem itself
- * maintains links to these inodes so that on-disk metadata are consistent.
- *
- * XFS implements a per-AG on-disk hash table of unlinked inodes.  The AGI
- * header contains a number of buckets that point to an inode, and each inode
- * record has a pointer to the next inode in the hash chain.  This
- * singly-linked list causes scaling problems in the iunlink remove function
- * because we must walk that list to find the inode that points to the inode
- * being removed from the unlinked hash bucket list.
- *
- * Hence we keep an in-memory double linked list to link each inode on an
- * unlinked list. Because there are 64 unlinked lists per AGI, keeping pointer
- * based lists would require having 64 list heads in the perag, one for each
- * list. This is expensive in terms of memory (think millions of AGs) and cache
- * misses on lookups. Instead, use the fact that inodes on the unlinked list
- * must be referenced at the VFS level to keep them on the list and hence we
- * have an existence guarantee for inodes on the unlinked list.
- *
- * Given we have an existence guarantee, we can use lockless inode cache lookups
- * to resolve aginos to xfs inodes. This means we only need 8 bytes per inode
- * for the double linked unlinked list, and we don't need any extra locking to
- * keep the list safe as all manipulations are done under the AGI buffer lock.
- * Keeping the list up to date does not require memory allocation, just finding
- * the XFS inode and updating the next/prev unlinked list aginos.
- */
-
 /*
  * Find an inode on the unlinked list. This does not take references to the
  * inode as we have existence guarantees by holding the AGI buffer lock and that
@@ -1805,76 +1772,12 @@ xfs_iunlink_lookup(
 	return ip;
 }
 
-/*
- * Update the prev pointer of the next agino.  Returns -ENOLINK if the inode
- * is not in cache.
- */
-static int
-xfs_iunlink_update_backref(
-	struct xfs_perag	*pag,
-	xfs_agino_t		prev_agino,
-	xfs_agino_t		next_agino)
-{
-	struct xfs_inode	*ip;
-
-	/* No update necessary if we are at the end of the list. */
-	if (next_agino == NULLAGINO)
-		return 0;
-
-	ip = xfs_iunlink_lookup(pag, next_agino);
-	if (!ip)
-		return -ENOLINK;
-
-	ip->i_prev_unlinked = prev_agino;
-	return 0;
-}
-
-/*
- * Point the AGI unlinked bucket at an inode and log the results.  The caller
- * is responsible for validating the old value.
- */
-STATIC int
-xfs_iunlink_update_bucket(
-	struct xfs_trans	*tp,
-	struct xfs_perag	*pag,
-	struct xfs_buf		*agibp,
-	unsigned int		bucket_index,
-	xfs_agino_t		new_agino)
-{
-	struct xfs_agi		*agi = agibp->b_addr;
-	xfs_agino_t		old_value;
-	int			offset;
-
-	ASSERT(xfs_verify_agino_or_null(pag, new_agino));
-
-	old_value = be32_to_cpu(agi->agi_unlinked[bucket_index]);
-	trace_xfs_iunlink_update_bucket(tp->t_mountp, pag->pag_agno, bucket_index,
-			old_value, new_agino);
-
-	/*
-	 * We should never find the head of the list already set to the value
-	 * passed in because either we're adding or removing ourselves from the
-	 * head of the list.
-	 */
-	if (old_value == new_agino) {
-		xfs_buf_mark_corrupt(agibp);
-		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
-		return -EFSCORRUPTED;
-	}
-
-	agi->agi_unlinked[bucket_index] = cpu_to_be32(new_agino);
-	offset = offsetof(struct xfs_agi, agi_unlinked) +
-			(sizeof(xfs_agino_t) * bucket_index);
-	xfs_trans_log_buf(tp, agibp, offset, offset + sizeof(xfs_agino_t) - 1);
-	return 0;
-}
-
 /*
  * Load the inode @next_agino into the cache and set its prev_unlinked pointer
  * to @prev_agino.  Caller must hold the AGI to synchronize with other changes
  * to the unlinked list.
  */
-STATIC int
+int
 xfs_iunlink_reload_next(
 	struct xfs_trans	*tp,
 	struct xfs_buf		*agibp,
@@ -1930,187 +1833,6 @@ xfs_iunlink_reload_next(
 	return error;
 }
 
-static int
-xfs_iunlink_insert_inode(
-	struct xfs_trans	*tp,
-	struct xfs_perag	*pag,
-	struct xfs_buf		*agibp,
-	struct xfs_inode	*ip)
-{
-	struct xfs_mount	*mp = tp->t_mountp;
-	struct xfs_agi		*agi = agibp->b_addr;
-	xfs_agino_t		next_agino;
-	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
-	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
-	int			error;
-
-	/*
-	 * Get the index into the agi hash table for the list this inode will
-	 * go on.  Make sure the pointer isn't garbage and that this inode
-	 * isn't already on the list.
-	 */
-	next_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
-	if (next_agino == agino ||
-	    !xfs_verify_agino_or_null(pag, next_agino)) {
-		xfs_buf_mark_corrupt(agibp);
-		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
-		return -EFSCORRUPTED;
-	}
-
-	/*
-	 * Update the prev pointer in the next inode to point back to this
-	 * inode.
-	 */
-	error = xfs_iunlink_update_backref(pag, agino, next_agino);
-	if (error == -ENOLINK)
-		error = xfs_iunlink_reload_next(tp, agibp, agino, next_agino);
-	if (error)
-		return error;
-
-	if (next_agino != NULLAGINO) {
-		/*
-		 * There is already another inode in the bucket, so point this
-		 * inode to the current head of the list.
-		 */
-		error = xfs_iunlink_log_inode(tp, ip, pag, next_agino);
-		if (error)
-			return error;
-		ip->i_next_unlinked = next_agino;
-	}
-
-	/* Point the head of the list to point to this inode. */
-	ip->i_prev_unlinked = NULLAGINO;
-	return xfs_iunlink_update_bucket(tp, pag, agibp, bucket_index, agino);
-}
-
-/*
- * This is called when the inode's link count has gone to 0 or we are creating
- * a tmpfile via O_TMPFILE.  The inode @ip must have nlink == 0.
- *
- * We place the on-disk inode on a list in the AGI.  It will be pulled from this
- * list when the inode is freed.
- */
-int
-xfs_iunlink(
-	struct xfs_trans	*tp,
-	struct xfs_inode	*ip)
-{
-	struct xfs_mount	*mp = tp->t_mountp;
-	struct xfs_perag	*pag;
-	struct xfs_buf		*agibp;
-	int			error;
-
-	ASSERT(VFS_I(ip)->i_nlink == 0);
-	ASSERT(VFS_I(ip)->i_mode != 0);
-	trace_xfs_iunlink(ip);
-
-	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
-
-	/* Get the agi buffer first.  It ensures lock ordering on the list. */
-	error = xfs_read_agi(pag, tp, 0, &agibp);
-	if (error)
-		goto out;
-
-	error = xfs_iunlink_insert_inode(tp, pag, agibp, ip);
-out:
-	xfs_perag_put(pag);
-	return error;
-}
-
-static int
-xfs_iunlink_remove_inode(
-	struct xfs_trans	*tp,
-	struct xfs_perag	*pag,
-	struct xfs_buf		*agibp,
-	struct xfs_inode	*ip)
-{
-	struct xfs_mount	*mp = tp->t_mountp;
-	struct xfs_agi		*agi = agibp->b_addr;
-	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
-	xfs_agino_t		head_agino;
-	short			bucket_index = agino % XFS_AGI_UNLINKED_BUCKETS;
-	int			error;
-
-	trace_xfs_iunlink_remove(ip);
-
-	/*
-	 * Get the index into the agi hash table for the list this inode will
-	 * go on.  Make sure the head pointer isn't garbage.
-	 */
-	head_agino = be32_to_cpu(agi->agi_unlinked[bucket_index]);
-	if (!xfs_verify_agino(pag, head_agino)) {
-		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
-				agi, sizeof(*agi));
-		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
-		return -EFSCORRUPTED;
-	}
-
-	/*
-	 * Set our inode's next_unlinked pointer to NULL and then return
-	 * the old pointer value so that we can update whatever was previous
-	 * to us in the list to point to whatever was next in the list.
-	 */
-	error = xfs_iunlink_log_inode(tp, ip, pag, NULLAGINO);
-	if (error)
-		return error;
-
-	/*
-	 * Update the prev pointer in the next inode to point back to previous
-	 * inode in the chain.
-	 */
-	error = xfs_iunlink_update_backref(pag, ip->i_prev_unlinked,
-			ip->i_next_unlinked);
-	if (error == -ENOLINK)
-		error = xfs_iunlink_reload_next(tp, agibp, ip->i_prev_unlinked,
-				ip->i_next_unlinked);
-	if (error)
-		return error;
-
-	if (head_agino != agino) {
-		struct xfs_inode	*prev_ip;
-
-		prev_ip = xfs_iunlink_lookup(pag, ip->i_prev_unlinked);
-		if (!prev_ip) {
-			xfs_inode_mark_sick(ip, XFS_SICK_INO_CORE);
-			return -EFSCORRUPTED;
-		}
-
-		error = xfs_iunlink_log_inode(tp, prev_ip, pag,
-				ip->i_next_unlinked);
-		prev_ip->i_next_unlinked = ip->i_next_unlinked;
-	} else {
-		/* Point the head of the list to the next unlinked inode. */
-		error = xfs_iunlink_update_bucket(tp, pag, agibp, bucket_index,
-				ip->i_next_unlinked);
-	}
-
-	ip->i_next_unlinked = NULLAGINO;
-	ip->i_prev_unlinked = 0;
-	return error;
-}
-
-/*
- * Pull the on-disk inode from the AGI unlinked list.
- */
-int
-xfs_iunlink_remove(
-	struct xfs_trans	*tp,
-	struct xfs_perag	*pag,
-	struct xfs_inode	*ip)
-{
-	struct xfs_buf		*agibp;
-	int			error;
-
-	trace_xfs_iunlink_remove(ip);
-
-	/* Get the agi buffer first.  It ensures lock ordering on the list. */
-	error = xfs_read_agi(pag, tp, 0, &agibp);
-	if (error)
-		return error;
-
-	return xfs_iunlink_remove_inode(tp, pag, agibp, ip);
-}
-
 /*
  * Look up the inode number specified and if it is not already marked XFS_ISTALE
  * mark it stale. We should only find clean inodes in this lookup that aren't
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index a905929494bd5..47d3a11a0e7ef 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -606,10 +606,9 @@ extern struct kmem_cache	*xfs_inode_cache;
 
 bool xfs_inode_needs_inactive(struct xfs_inode *ip);
 
-int xfs_iunlink(struct xfs_trans *tp, struct xfs_inode *ip);
-int xfs_iunlink_remove(struct xfs_trans *tp, struct xfs_perag *pag,
-		struct xfs_inode *ip);
 struct xfs_inode *xfs_iunlink_lookup(struct xfs_perag *pag, xfs_agino_t agino);
+int xfs_iunlink_reload_next(struct xfs_trans *tp, struct xfs_buf *agibp,
+		xfs_agino_t prev_agino, xfs_agino_t next_agino);
 
 void xfs_end_io(struct work_struct *work);
 


