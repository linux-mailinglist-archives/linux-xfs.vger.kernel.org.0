Return-Path: <linux-xfs+bounces-8966-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E17ED8D89DB
	for <lists+linux-xfs@lfdr.de>; Mon,  3 Jun 2024 21:18:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3EF54B273F2
	for <lists+linux-xfs@lfdr.de>; Mon,  3 Jun 2024 19:18:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D60A13B5B6;
	Mon,  3 Jun 2024 19:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ukBh734y"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E61E13B5AF
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717442210; cv=none; b=CBUbZ0LLpAFB6hJxiXHXFc8Gj/9T52nebmcQUrYzSigvj8E8LyAFSZMKgoxlXr5rHXnSIlOPAbhOkn3CshAZS1UWVyQ7O5pAVeWxHC5nfw0XJw7iZmldMIqe5Bs3AXKJwfUMca8Pxr0+3BVDZrZMZSbeaOcNitm6vIpMAZ43UXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717442210; c=relaxed/simple;
	bh=sDOubrHZlKPLgxizYtFPsI7wfNW1M0l3g1nDn7pJVeQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J+qHwdpVdXuW9BDXMRHrN4iUZ0zO8qJnuahAFyKVZSFeN6g1KO3nHhwSMPf2LvWB7GtIDm3RAoLVlNogMGqx6e0ZNa5cCFV5UtzZaZ7+qMtMO5/3EsPBhEflJN2cyHPU2OpoRwXc4KWsuFFyivLx7ECDRBZTsX19qiHu9iCqvOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ukBh734y; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CC20C4AF07;
	Mon,  3 Jun 2024 19:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717442209;
	bh=sDOubrHZlKPLgxizYtFPsI7wfNW1M0l3g1nDn7pJVeQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ukBh734ymm0AJP3IKxKE69ioc/R9hK7n7dX4LfCMYMxZ+ZEe430WqgTeNsp0aC4Xr
	 zIRHzz2c+UrThbDuMTqVWW4SaokuLV1uiqkdFFp3BuRGu/kLOav5TRlvKv6+fwMxdx
	 OV9KpAwDVbd96DdjYCP3pCYqEIkBbVKEcqs2tNajG2VToc+rTblwPmTjcFgaIVRsVf
	 40npp9/tTbL1GTHAcEjgwI3j9101rxm1cbD3DfmhBzF30JNZk6sjA37gkW2T5EYoHC
	 IlyxtrvNCIIoeRfhCgc+n/+AiQjefPEhJpuE/2TDON1WG48APsSM7rmd2Wzmk9YpOJ
	 OVeXi785IhZpA==
Date: Mon, 03 Jun 2024 12:16:49 -0700
Subject: [PATCH 095/111] xfs: launder in-memory btree buffers before
 transaction commit
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744040793.1443973.12305899348003265226.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
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

Source kernel commit: 0dc63c8a1ce39c1ac7da536ee9174cdc714afae2

As we've noted in various places, all current users of in-memory btrees
are online fsck.  Online fsck only stages a btree long enough to rebuild
an ondisk data structure, which means that the in-memory btree is
ephemeral.  Furthermore, if we encounter /any/ errors while updating an
in-memory btree, all we do is tear down all the staged data and return
an errno to userspace.  In-memory btrees need not be transactional, so
their buffers should not be committed to the ondisk log, nor should they
be checkpointed by the AIL.  That's just as well since the ephemeral
nature of the btree means that the buftarg and the buffers may disappear
quickly anyway.

Therefore, we need a way to launder the btree buffers that get attached
to the transaction by the generic btree code.  Because the buffers are
directly mapped to backing file pages, there's no need to bwrite them
back to the tmpfs file.  All we need to do is clean enough of the buffer
log item state so that the bli can be detached from the buffer, remove
the bli from the transaction's log item list, and reset the transaction
dirty state as if the laundered items had never been there.

For simplicity, create xfbtree transaction commit and cancel helpers
that launder the in-memory btree buffers for callers.  Once laundered,
call the write verifier on non-stale buffers to avoid integrity issues,
or punch a hole in the backing file for stale buffers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 include/xfs_trace.h      |    1 
 include/xfs_trans.h      |    1 
 libxfs/buf_mem.c         |   65 +++++++++++++++++++++++++
 libxfs/buf_mem.h         |    2 +
 libxfs/libxfs_api_defs.h |    1 
 libxfs/trans.c           |   40 +++++++++++++++
 libxfs/xfs_btree_mem.c   |  119 ++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_btree_mem.h   |    3 +
 8 files changed, 232 insertions(+)


diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index 6c8eeff1e..6b9d3358a 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -211,6 +211,7 @@
 #define trace_xfs_trans_cancel(a,b)		((void) 0)
 #define trace_xfs_trans_brelse(a)		((void) 0)
 #define trace_xfs_trans_binval(a)		((void) 0)
+#define trace_xfs_trans_bdetach(a)		((void) 0)
 #define trace_xfs_trans_bjoin(a)		((void) 0)
 #define trace_xfs_trans_bhold(a)		((void) 0)
 #define trace_xfs_trans_bhold_release(a)	((void) 0)
diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index ac82c3bc4..b7f01ff07 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -114,6 +114,7 @@ int	libxfs_trans_roll_inode (struct xfs_trans **, struct xfs_inode *);
 void	libxfs_trans_brelse(struct xfs_trans *, struct xfs_buf *);
 void	libxfs_trans_binval(struct xfs_trans *, struct xfs_buf *);
 void	libxfs_trans_bjoin(struct xfs_trans *, struct xfs_buf *);
+void	libxfs_trans_bdetach(struct xfs_trans *tp, struct xfs_buf *bp);
 void	libxfs_trans_bhold(struct xfs_trans *, struct xfs_buf *);
 void	libxfs_trans_bhold_release(struct xfs_trans *, struct xfs_buf *);
 void	libxfs_trans_dirty_buf(struct xfs_trans *, struct xfs_buf *);
diff --git a/libxfs/buf_mem.c b/libxfs/buf_mem.c
index 7a30afe27..e5b91d3cf 100644
--- a/libxfs/buf_mem.c
+++ b/libxfs/buf_mem.c
@@ -246,3 +246,68 @@ xmbuf_verify_daddr(
 
 	return daddr < (xf->maxbytes >> BBSHIFT);
 }
+
+/* Discard the page backing this buffer. */
+static void
+xmbuf_stale(
+	struct xfs_buf		*bp)
+{
+	struct xfile		*xf = bp->b_target->bt_xfile;
+	loff_t			pos;
+
+	ASSERT(xfs_buftarg_is_mem(bp->b_target));
+
+	pos = BBTOB(xfs_buf_daddr(bp)) + xf->partition_pos;
+	fallocate(xf->fcb->fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE, pos,
+			BBTOB(bp->b_length));
+}
+
+/*
+ * Finalize a buffer -- discard the backing page if it's stale, or run the
+ * write verifier to detect problems.
+ */
+int
+xmbuf_finalize(
+	struct xfs_buf		*bp)
+{
+	xfs_failaddr_t		fa;
+	int			error = 0;
+
+	if (bp->b_flags & LIBXFS_B_STALE) {
+		xmbuf_stale(bp);
+		return 0;
+	}
+
+	/*
+	 * Although this btree is ephemeral, validate the buffer structure so
+	 * that we can detect memory corruption errors and software bugs.
+	 */
+	fa = bp->b_ops->verify_struct(bp);
+	if (fa) {
+		error = -EFSCORRUPTED;
+		xfs_verifier_error(bp, error, fa);
+	}
+
+	return error;
+}
+
+/*
+ * Detach this xmbuf buffer from the transaction by any means necessary.
+ * All buffers are direct-mapped, so they do not need bwrite.
+ */
+void
+xmbuf_trans_bdetach(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp)
+{
+	struct xfs_buf_log_item	*bli = bp->b_log_item;
+
+	ASSERT(bli != NULL);
+
+	bli->bli_flags &= ~(XFS_BLI_DIRTY | XFS_BLI_ORDERED |
+			    XFS_BLI_STALE);
+	clear_bit(XFS_LI_DIRTY, &bli->bli_item.li_flags);
+
+	while (bp->b_log_item != NULL)
+		xfs_trans_bdetach(tp, bp);
+}
diff --git a/libxfs/buf_mem.h b/libxfs/buf_mem.h
index d40f9f9df..3829dd00d 100644
--- a/libxfs/buf_mem.h
+++ b/libxfs/buf_mem.h
@@ -24,5 +24,7 @@ int xmbuf_map_page(struct xfs_buf *bp);
 void xmbuf_unmap_page(struct xfs_buf *bp);
 
 bool xmbuf_verify_daddr(struct xfs_buftarg *btp, xfs_daddr_t daddr);
+void xmbuf_trans_bdetach(struct xfs_trans *tp, struct xfs_buf *bp);
+int xmbuf_finalize(struct xfs_buf *bp);
 
 #endif /* __XFS_BUF_MEM_H__ */
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index fe8a0dc40..de37d3050 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -224,6 +224,7 @@
 #define xfs_trans_alloc_empty		libxfs_trans_alloc_empty
 #define xfs_trans_alloc			libxfs_trans_alloc
 #define xfs_trans_alloc_inode		libxfs_trans_alloc_inode
+#define xfs_trans_bdetach		libxfs_trans_bdetach
 #define xfs_trans_bhold			libxfs_trans_bhold
 #define xfs_trans_bhold_release		libxfs_trans_bhold_release
 #define xfs_trans_binval		libxfs_trans_binval
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 8143a6a99..7fec2caff 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -614,6 +614,46 @@ libxfs_trans_brelse(
 	libxfs_buf_relse(bp);
 }
 
+/*
+ * Forcibly detach a buffer previously joined to the transaction.  The caller
+ * will retain its locked reference to the buffer after this function returns.
+ * The buffer must be completely clean and must not be held to the transaction.
+ */
+void
+libxfs_trans_bdetach(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp)
+{
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
+
+	ASSERT(tp != NULL);
+	ASSERT(bp->b_transp == tp);
+	ASSERT(bip->bli_item.li_type == XFS_LI_BUF);
+
+	trace_xfs_trans_bdetach(bip);
+
+	/*
+	 * Erase all recursion count, since we're removing this buffer from the
+	 * transaction.
+	 */
+	bip->bli_recur = 0;
+
+	/*
+	 * The buffer must be completely clean.  Specifically, it had better
+	 * not be dirty, stale, logged, ordered, or held to the transaction.
+	 */
+	ASSERT(!test_bit(XFS_LI_DIRTY, &bip->bli_item.li_flags));
+	ASSERT(!(bip->bli_flags & XFS_BLI_DIRTY));
+	ASSERT(!(bip->bli_flags & XFS_BLI_HOLD));
+	ASSERT(!(bip->bli_flags & XFS_BLI_ORDERED));
+	ASSERT(!(bip->bli_flags & XFS_BLI_STALE));
+
+	/* Unlink the log item from the transaction and drop the log item. */
+	xfs_trans_del_item(&bip->bli_item);
+	xfs_buf_item_put(bip);
+	bp->b_transp = NULL;
+}
+
 /*
  * Mark the buffer as not needing to be unlocked when the buf item's
  * iop_unlock() routine is called.  The buffer must already be locked
diff --git a/libxfs/xfs_btree_mem.c b/libxfs/xfs_btree_mem.c
index 31835e065..ae9302b90 100644
--- a/libxfs/xfs_btree_mem.c
+++ b/libxfs/xfs_btree_mem.c
@@ -225,3 +225,122 @@ xfbtree_get_maxrecs(
 
 	return xfbt->maxrecs[level != 0];
 }
+
+/* If this log item is a buffer item that came from the xfbtree, return it. */
+static inline struct xfs_buf *
+xfbtree_buf_match(
+	struct xfbtree			*xfbt,
+	const struct xfs_log_item	*lip)
+{
+	const struct xfs_buf_log_item	*bli;
+	struct xfs_buf			*bp;
+
+	if (lip->li_type != XFS_LI_BUF)
+		return NULL;
+
+	bli = container_of(lip, struct xfs_buf_log_item, bli_item);
+	bp = bli->bli_buf;
+	if (bp->b_target != xfbt->target)
+		return NULL;
+
+	return bp;
+}
+
+/*
+ * Commit changes to the incore btree immediately by writing all dirty xfbtree
+ * buffers to the backing xfile.  This detaches all xfbtree buffers from the
+ * transaction, even on failure.  The buffer locks are dropped between the
+ * delwri queue and submit, so the caller must synchronize btree access.
+ *
+ * Normally we'd let the buffers commit with the transaction and get written to
+ * the xfile via the log, but online repair stages ephemeral btrees in memory
+ * and uses the btree_staging functions to write new btrees to disk atomically.
+ * The in-memory btree (and its backing store) are discarded at the end of the
+ * repair phase, which means that xfbtree buffers cannot commit with the rest
+ * of a transaction.
+ *
+ * In other words, online repair only needs the transaction to collect buffer
+ * pointers and to avoid buffer deadlocks, not to guarantee consistency of
+ * updates.
+ */
+int
+xfbtree_trans_commit(
+	struct xfbtree		*xfbt,
+	struct xfs_trans	*tp)
+{
+	struct xfs_log_item	*lip, *n;
+	bool			tp_dirty = false;
+	int			error = 0;
+
+	/*
+	 * For each xfbtree buffer attached to the transaction, write the dirty
+	 * buffers to the xfile and release them.
+	 */
+	list_for_each_entry_safe(lip, n, &tp->t_items, li_trans) {
+		struct xfs_buf	*bp = xfbtree_buf_match(xfbt, lip);
+
+		if (!bp) {
+			if (test_bit(XFS_LI_DIRTY, &lip->li_flags))
+				tp_dirty |= true;
+			continue;
+		}
+
+		trace_xfbtree_trans_commit_buf(xfbt, bp);
+
+		xmbuf_trans_bdetach(tp, bp);
+
+		/*
+		 * If the buffer fails verification, note the failure but
+		 * continue walking the transaction items so that we remove all
+		 * ephemeral btree buffers.
+		 */
+		if (!error)
+			error = xmbuf_finalize(bp);
+
+		xfs_buf_relse(bp);
+	}
+
+	/*
+	 * Reset the transaction's dirty flag to reflect the dirty state of the
+	 * log items that are still attached.
+	 */
+	tp->t_flags = (tp->t_flags & ~XFS_TRANS_DIRTY) |
+			(tp_dirty ? XFS_TRANS_DIRTY : 0);
+
+	return error;
+}
+
+/*
+ * Cancel changes to the incore btree by detaching all the xfbtree buffers.
+ * Changes are not undone, so callers must not access the btree ever again.
+ */
+void
+xfbtree_trans_cancel(
+	struct xfbtree		*xfbt,
+	struct xfs_trans	*tp)
+{
+	struct xfs_log_item	*lip, *n;
+	bool			tp_dirty = false;
+
+	list_for_each_entry_safe(lip, n, &tp->t_items, li_trans) {
+		struct xfs_buf	*bp = xfbtree_buf_match(xfbt, lip);
+
+		if (!bp) {
+			if (test_bit(XFS_LI_DIRTY, &lip->li_flags))
+				tp_dirty |= true;
+			continue;
+		}
+
+		trace_xfbtree_trans_cancel_buf(xfbt, bp);
+
+		xmbuf_trans_bdetach(tp, bp);
+		xfs_buf_relse(bp);
+	}
+
+	/*
+	 * Reset the transaction's dirty flag to reflect the dirty state of the
+	 * log items that are still attached.
+	 */
+	tp->t_flags = (tp->t_flags & ~XFS_TRANS_DIRTY) |
+			(tp_dirty ? XFS_TRANS_DIRTY : 0);
+}
diff --git a/libxfs/xfs_btree_mem.h b/libxfs/xfs_btree_mem.h
index ecc2ceac3..1c3825786 100644
--- a/libxfs/xfs_btree_mem.h
+++ b/libxfs/xfs_btree_mem.h
@@ -65,6 +65,9 @@ int xfbtree_free_block(struct xfs_btree_cur *cur, struct xfs_buf *bp);
 int xfbtree_init(struct xfs_mount *mp, struct xfbtree *xfbt,
 		struct xfs_buftarg *btp, const struct xfs_btree_ops *ops);
 void xfbtree_destroy(struct xfbtree *xfbt);
+
+int xfbtree_trans_commit(struct xfbtree *xfbt, struct xfs_trans *tp);
+void xfbtree_trans_cancel(struct xfbtree *xfbt, struct xfs_trans *tp);
 #else
 # define xfbtree_verify_bno(...)	(false)
 #endif /* CONFIG_XFS_BTREE_IN_MEM */


