Return-Path: <linux-xfs+bounces-1272-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A8898820D6F
	for <lists+linux-xfs@lfdr.de>; Sun, 31 Dec 2023 21:16:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0BD75B215F5
	for <lists+linux-xfs@lfdr.de>; Sun, 31 Dec 2023 20:16:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF939B675;
	Sun, 31 Dec 2023 20:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OiH8MVH0"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78EF2BA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:15:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E08C1C433C7;
	Sun, 31 Dec 2023 20:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704053755;
	bh=XZajQR0aOOpWsVHC6mki6UXhpmfiuj2Khv2B/QrFaZA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OiH8MVH0FRGyk564wAe2lIHZvbNjTVrgg5eUiB11EIiPLj6iURExGuFG4I4E4nGQy
	 dihjQlXSjQvr7QuuKdHKEj6090iIb6BAUqvbOJFOcPqWm/7Z29NWgERdQyjQz80C7L
	 IcF9ejd8OgHTHkOZQv4PaG4u9IzdcRv/1dZaieL6Ja7MO6KIguLwBweFxNA+6tyrSF
	 WH7yyDsweupFFduryiu+lIz/Ii62sHHDgfZDE2PtBpIycAFEmeju6rD9kmeljvd0jM
	 BM0ptkrwiOsbw2aKdIjlX49G37RwJUBzWr+4FxvwbW88XVGbUAc919EowXw9N7KxS8
	 bB3t9+YSq9XOw==
Date: Sun, 31 Dec 2023 12:15:54 -0800
Subject: [PATCH 9/9] xfs: connect in-memory btrees to xfiles
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, willy@infradead.org
Message-ID: <170404829726.1748854.1262147267981918901.stgit@frogsfrogsfrogs>
In-Reply-To: <170404829556.1748854.13886473250848576704.stgit@frogsfrogsfrogs>
References: <170404829556.1748854.13886473250848576704.stgit@frogsfrogsfrogs>
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

Add to our stubbed-out in-memory btrees the ability to connect them with
an actual in-memory backing file (aka xfiles) and the necessary pieces
to track free space in the xfile and flush dirty xfbtree buffers on
demand, which we'll need for online repair.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree_mem.h |   41 +++
 fs/xfs/scrub/bitmap.c         |   28 ++
 fs/xfs/scrub/bitmap.h         |    3 
 fs/xfs/scrub/scrub.c          |    5 
 fs/xfs/scrub/scrub.h          |    3 
 fs/xfs/scrub/trace.c          |   11 +
 fs/xfs/scrub/trace.h          |  109 +++++++++
 fs/xfs/scrub/xfbtree.c        |  487 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/xfbtree.h        |   31 +++
 fs/xfs/scrub/xfile.c          |   83 +++++++
 fs/xfs/scrub/xfile.h          |    2 
 fs/xfs/xfs_trace.h            |    1 
 fs/xfs/xfs_trans.h            |    1 
 fs/xfs/xfs_trans_buf.c        |   42 ++++
 14 files changed, 845 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree_mem.h b/fs/xfs/libxfs/xfs_btree_mem.h
index 2c42ca85c58fb..29f97c5030465 100644
--- a/fs/xfs/libxfs/xfs_btree_mem.h
+++ b/fs/xfs/libxfs/xfs_btree_mem.h
@@ -8,6 +8,26 @@
 
 struct xfbtree;
 
+struct xfbtree_config {
+	/* Buffer ops for the btree root block */
+	const struct xfs_btree_ops	*btree_ops;
+
+	/* Buffer target for the xfile backing this btree. */
+	struct xfs_buftarg		*target;
+
+	/* Owner of this btree. */
+	unsigned long long		owner;
+
+	/* Btree type number */
+	xfs_btnum_t			btnum;
+
+	/* XFBTREE_CREATE_* flags */
+	unsigned int			flags;
+};
+
+/* btree has long pointers */
+#define XFBTREE_CREATE_LONG_PTRS	(1U << 0)
+
 #ifdef CONFIG_XFS_BTREE_IN_XFILE
 unsigned int xfs_btree_mem_head_nlevels(struct xfs_buf *head_bp);
 
@@ -35,6 +55,16 @@ xfs_failaddr_t xfbtree_lblock_verify(struct xfs_buf *bp, unsigned int max_recs);
 xfs_failaddr_t xfbtree_sblock_verify(struct xfs_buf *bp, unsigned int max_recs);
 unsigned long long xfbtree_buf_to_xfoff(struct xfs_btree_cur *cur,
 		struct xfs_buf *bp);
+
+int xfbtree_get_minrecs(struct xfs_btree_cur *cur, int level);
+int xfbtree_get_maxrecs(struct xfs_btree_cur *cur, int level);
+
+int xfbtree_create(struct xfs_mount *mp, const struct xfbtree_config *cfg,
+		struct xfbtree **xfbtreep);
+int xfbtree_alloc_block(struct xfs_btree_cur *cur,
+		const union xfs_btree_ptr *start, union xfs_btree_ptr *ptr,
+		int *stat);
+int xfbtree_free_block(struct xfs_btree_cur *cur, struct xfs_buf *bp);
 #else
 static inline unsigned int xfs_btree_mem_head_nlevels(struct xfs_buf *head_bp)
 {
@@ -77,11 +107,22 @@ static inline unsigned int xfbtree_bbsize(void)
 #define xfbtree_set_root			NULL
 #define xfbtree_init_ptr_from_cur		NULL
 #define xfbtree_dup_cursor			NULL
+#define xfbtree_get_minrecs			NULL
+#define xfbtree_get_maxrecs			NULL
+#define xfbtree_alloc_block			NULL
+#define xfbtree_free_block			NULL
 #define xfbtree_verify_xfileoff(cur, xfoff)	(false)
 #define xfbtree_check_block_owner(cur, block)	NULL
 #define xfbtree_owner(cur)			(0ULL)
 #define xfbtree_buf_to_xfoff(cur, bp)		(-1)
 
+static inline int
+xfbtree_create(struct xfs_mount *mp, const struct xfbtree_config *cfg,
+		struct xfbtree **xfbtreep)
+{
+	return -EOPNOTSUPP;
+}
+
 #endif /* CONFIG_XFS_BTREE_IN_XFILE */
 
 #endif /* __XFS_BTREE_MEM_H__ */
diff --git a/fs/xfs/scrub/bitmap.c b/fs/xfs/scrub/bitmap.c
index 1449bb5262d95..a82e2e3f93706 100644
--- a/fs/xfs/scrub/bitmap.c
+++ b/fs/xfs/scrub/bitmap.c
@@ -293,6 +293,34 @@ xbitmap64_test(
 	return false;
 }
 
+/*
+ * Find the first set bit in this bitmap, clear it, and return the index of
+ * that bit in @valp.  Returns -ENODATA if no bits were set, or the usual
+ * negative errno.
+ */
+int
+xbitmap64_take_first_set(
+	struct xbitmap64	*bitmap,
+	uint64_t		start,
+	uint64_t		last,
+	uint64_t		*valp)
+{
+	struct xbitmap64_node	*bn;
+	uint64_t		val;
+	int			error;
+
+	bn = xbitmap64_tree_iter_first(&bitmap->xb_root, start, last);
+	if (!bn)
+		return -ENODATA;
+
+	val = bn->bn_start;
+	error = xbitmap64_clear(bitmap, bn->bn_start, 1);
+	if (error)
+		return error;
+	*valp = val;
+	return 0;
+}
+
 /* u32 bitmap */
 
 struct xbitmap32_node {
diff --git a/fs/xfs/scrub/bitmap.h b/fs/xfs/scrub/bitmap.h
index 2df8911606d6d..c88b7bda1b5d8 100644
--- a/fs/xfs/scrub/bitmap.h
+++ b/fs/xfs/scrub/bitmap.h
@@ -34,6 +34,9 @@ int xbitmap64_walk(struct xbitmap64 *bitmap, xbitmap64_walk_fn fn,
 bool xbitmap64_empty(struct xbitmap64 *bitmap);
 bool xbitmap64_test(struct xbitmap64 *bitmap, uint64_t start, uint64_t *len);
 
+int xbitmap64_take_first_set(struct xbitmap64 *bitmap, uint64_t start,
+		uint64_t last, uint64_t *valp);
+
 /* u32 bitmap */
 
 struct xbitmap32 {
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index aeac9cae4ad4c..4a6853accdf12 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -15,6 +15,7 @@
 #include "xfs_quota.h"
 #include "xfs_qm.h"
 #include "xfs_scrub.h"
+#include "xfs_buf_xfile.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -190,6 +191,10 @@ xchk_teardown(
 		sc->flags &= ~XCHK_HAVE_FREEZE_PROT;
 		mnt_drop_write_file(sc->file);
 	}
+	if (sc->xfile_buftarg) {
+		xfile_free_buftarg(sc->xfile_buftarg);
+		sc->xfile_buftarg = NULL;
+	}
 	if (sc->xfile) {
 		xfile_destroy(sc->xfile);
 		sc->xfile = NULL;
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index f99a3c21d02ea..1f0d655941e32 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -99,6 +99,9 @@ struct xfs_scrub {
 	/* xfile used by the scrubbers; freed at teardown. */
 	struct xfile			*xfile;
 
+	/* buffer target for the xfile; also freed at teardown. */
+	struct xfs_buftarg		*xfile_buftarg;
+
 	/* Lock flags for @ip. */
 	uint				ilock_flags;
 
diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
index b8f3795f7d9b4..bffe138abc057 100644
--- a/fs/xfs/scrub/trace.c
+++ b/fs/xfs/scrub/trace.c
@@ -12,6 +12,7 @@
 #include "xfs_mount.h"
 #include "xfs_inode.h"
 #include "xfs_btree.h"
+#include "xfs_btree_mem.h"
 #include "xfs_ag.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_quota.h"
@@ -25,6 +26,7 @@
 #include "scrub/iscan.h"
 #include "scrub/nlinks.h"
 #include "scrub/fscounters.h"
+#include "scrub/xfbtree.h"
 
 /* Figure out which block the btree cursor was pointing to. */
 static inline xfs_fsblock_t
@@ -43,6 +45,15 @@ xchk_btree_cur_fsbno(
 	return NULLFSBLOCK;
 }
 
+#ifdef CONFIG_XFS_BTREE_IN_XFILE
+static inline unsigned long
+xfbtree_ino(
+	struct xfbtree		*xfbt)
+{
+	return file_inode(xfbt->target->bt_xfile->file)->i_ino;
+}
+#endif /* CONFIG_XFS_BTREE_IN_XFILE */
+
 /*
  * We include this last to have the helpers above available for the trace
  * event implementations.
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 88e921f4efd26..acea536e09c38 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -25,6 +25,8 @@ struct xchk_dqiter;
 struct xchk_iscan;
 struct xchk_nlink;
 struct xchk_fscounters;
+struct xfbtree;
+struct xfbtree_config;
 
 /*
  * ftrace's __print_symbolic requires that all enum values be wrapped in the
@@ -958,6 +960,8 @@ DEFINE_XFILE_EVENT(xfile_pwrite);
 DEFINE_XFILE_EVENT(xfile_seek_data);
 DEFINE_XFILE_EVENT(xfile_get_page);
 DEFINE_XFILE_EVENT(xfile_put_page);
+DEFINE_XFILE_EVENT(xfile_discard);
+DEFINE_XFILE_EVENT(xfile_prealloc);
 
 TRACE_EVENT(xfarray_create,
 	TP_PROTO(struct xfarray *xfa, unsigned long long required_capacity),
@@ -2176,8 +2180,113 @@ DEFINE_XREP_DQUOT_EVENT(xrep_quotacheck_dquot);
 DEFINE_SCRUB_NLINKS_DIFF_EVENT(xrep_nlinks_update_inode);
 DEFINE_SCRUB_NLINKS_DIFF_EVENT(xrep_nlinks_unfixable_inode);
 
+TRACE_EVENT(xfbtree_create,
+	TP_PROTO(struct xfs_mount *mp, const struct xfbtree_config *cfg,
+		 struct xfbtree *xfbt),
+	TP_ARGS(mp, cfg, xfbt),
+	TP_STRUCT__entry(
+		__field(xfs_btnum_t, btnum)
+		__field(unsigned int, xfbtree_flags)
+		__field(unsigned long, xfino)
+		__field(unsigned int, leaf_mxr)
+		__field(unsigned int, leaf_mnr)
+		__field(unsigned int, node_mxr)
+		__field(unsigned int, node_mnr)
+		__field(unsigned long long, owner)
+	),
+	TP_fast_assign(
+		__entry->btnum = cfg->btnum;
+		__entry->xfbtree_flags = cfg->flags;
+		__entry->xfino = xfbtree_ino(xfbt);
+		__entry->leaf_mxr = xfbt->maxrecs[0];
+		__entry->node_mxr = xfbt->maxrecs[1];
+		__entry->leaf_mnr = xfbt->minrecs[0];
+		__entry->node_mnr = xfbt->minrecs[1];
+		__entry->owner = cfg->owner;
+	),
+	TP_printk("xfino 0x%lx btnum %s owner 0x%llx leaf_mxr %u leaf_mnr %u node_mxr %u node_mnr %u",
+		  __entry->xfino,
+		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
+		  __entry->owner,
+		  __entry->leaf_mxr,
+		  __entry->leaf_mnr,
+		  __entry->node_mxr,
+		  __entry->node_mnr)
+);
+
+DECLARE_EVENT_CLASS(xfbtree_buf_class,
+	TP_PROTO(struct xfbtree *xfbt, struct xfs_buf *bp),
+	TP_ARGS(xfbt, bp),
+	TP_STRUCT__entry(
+		__field(unsigned long, xfino)
+		__field(xfs_daddr_t, bno)
+		__field(int, nblks)
+		__field(int, hold)
+		__field(int, pincount)
+		__field(unsigned int, lockval)
+		__field(unsigned int, flags)
+	),
+	TP_fast_assign(
+		__entry->xfino = xfbtree_ino(xfbt);
+		__entry->bno = xfs_buf_daddr(bp);
+		__entry->nblks = bp->b_length;
+		__entry->hold = atomic_read(&bp->b_hold);
+		__entry->pincount = atomic_read(&bp->b_pin_count);
+		__entry->lockval = bp->b_sema.count;
+		__entry->flags = bp->b_flags;
+	),
+	TP_printk("xfino 0x%lx daddr 0x%llx bbcount 0x%x hold %d pincount %d lock %d flags %s",
+		  __entry->xfino,
+		  (unsigned long long)__entry->bno,
+		  __entry->nblks,
+		  __entry->hold,
+		  __entry->pincount,
+		  __entry->lockval,
+		  __print_flags(__entry->flags, "|", XFS_BUF_FLAGS))
+)
+
+#define DEFINE_XFBTREE_BUF_EVENT(name) \
+DEFINE_EVENT(xfbtree_buf_class, name, \
+	TP_PROTO(struct xfbtree *xfbt, struct xfs_buf *bp), \
+	TP_ARGS(xfbt, bp))
+DEFINE_XFBTREE_BUF_EVENT(xfbtree_create_root_buf);
+DEFINE_XFBTREE_BUF_EVENT(xfbtree_trans_commit_buf);
+DEFINE_XFBTREE_BUF_EVENT(xfbtree_trans_cancel_buf);
+
+DECLARE_EVENT_CLASS(xfbtree_freesp_class,
+	TP_PROTO(struct xfbtree *xfbt, struct xfs_btree_cur *cur,
+		 xfs_fileoff_t fileoff),
+	TP_ARGS(xfbt, cur, fileoff),
+	TP_STRUCT__entry(
+		__field(unsigned long, xfino)
+		__field(xfs_btnum_t, btnum)
+		__field(int, nlevels)
+		__field(xfs_fileoff_t, fileoff)
+	),
+	TP_fast_assign(
+		__entry->xfino = xfbtree_ino(xfbt);
+		__entry->btnum = cur->bc_btnum;
+		__entry->nlevels = cur->bc_nlevels;
+		__entry->fileoff = fileoff;
+	),
+	TP_printk("xfino 0x%lx btree %s nlevels %d fileoff 0x%llx",
+		  __entry->xfino,
+		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
+		  __entry->nlevels,
+		  (unsigned long long)__entry->fileoff)
+)
+
+#define DEFINE_XFBTREE_FREESP_EVENT(name) \
+DEFINE_EVENT(xfbtree_freesp_class, name, \
+	TP_PROTO(struct xfbtree *xfbt, struct xfs_btree_cur *cur, \
+		 xfs_fileoff_t fileoff), \
+	TP_ARGS(xfbt, cur, fileoff))
+DEFINE_XFBTREE_FREESP_EVENT(xfbtree_alloc_block);
+DEFINE_XFBTREE_FREESP_EVENT(xfbtree_free_block);
+
 #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */
 
+
 #endif /* _TRACE_XFS_SCRUB_TRACE_H */
 
 #undef TRACE_INCLUDE_PATH
diff --git a/fs/xfs/scrub/xfbtree.c b/fs/xfs/scrub/xfbtree.c
index b7b5aa52b40b4..8879b54068a75 100644
--- a/fs/xfs/scrub/xfbtree.c
+++ b/fs/xfs/scrub/xfbtree.c
@@ -9,14 +9,50 @@
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
+#include "xfs_bit.h"
 #include "xfs_mount.h"
 #include "xfs_trans.h"
+#include "xfs_buf_item.h"
 #include "xfs_btree.h"
 #include "xfs_error.h"
 #include "xfs_btree_mem.h"
 #include "xfs_ag.h"
+#include "scrub/scrub.h"
 #include "scrub/xfile.h"
 #include "scrub/xfbtree.h"
+#include "scrub/bitmap.h"
+#include "scrub/trace.h"
+
+/* Bitmaps, but for type-checked for xfileoff_t */
+
+static inline void xfboff_bitmap_init(struct xfboff_bitmap *bitmap)
+{
+	xbitmap64_init(&bitmap->xfoffbitmap);
+}
+
+static inline void xfboff_bitmap_destroy(struct xfboff_bitmap *bitmap)
+{
+	xbitmap64_destroy(&bitmap->xfoffbitmap);
+}
+
+static inline int xfboff_bitmap_set(struct xfboff_bitmap *bitmap,
+		xfs_fileoff_t start, xfs_filblks_t len)
+{
+	return xbitmap64_set(&bitmap->xfoffbitmap, start, len);
+}
+
+static inline int xfboff_bitmap_take_first_set(struct xfboff_bitmap *bitmap,
+		xfileoff_t *valp)
+{
+	uint64_t	val;
+	int		error;
+
+	error = xbitmap64_take_first_set(&bitmap->xfoffbitmap, 0, -1ULL, &val);
+	if (error)
+		return error;
+	*valp = val;
+	return 0;
+}
 
 /* btree ops functions for in-memory btrees. */
 
@@ -142,9 +178,18 @@ xfbtree_check_ptr(
 	else
 		bt_xfoff = be32_to_cpu(ptr->s);
 
-	if (!xfbtree_verify_xfileoff(cur, bt_xfoff))
+	if (!xfbtree_verify_xfileoff(cur, bt_xfoff)) {
 		fa = __this_address;
+		goto done;
+	}
 
+	/* Can't point to the head or anything before it */
+	if (bt_xfoff < XFBTREE_INIT_LEAF_BLOCK) {
+		fa = __this_address;
+		goto done;
+	}
+
+done:
 	if (fa) {
 		xfs_err(cur->bc_mp,
 "In-memory: Corrupt btree %d flags 0x%x pointer at level %d index %d fa %pS.",
@@ -350,3 +395,443 @@ xfbtree_sblock_verify(
 
 	return NULL;
 }
+
+/* Close the btree xfile and release all resources. */
+void
+xfbtree_destroy(
+	struct xfbtree		*xfbt)
+{
+	xfboff_bitmap_destroy(&xfbt->freespace);
+	xfs_buftarg_drain(xfbt->target);
+	kfree(xfbt);
+}
+
+/* Compute the number of bytes available for records. */
+static inline unsigned int
+xfbtree_rec_bytes(
+	struct xfs_mount		*mp,
+	const struct xfbtree_config	*cfg)
+{
+	unsigned int			blocklen = xfo_to_b(1);
+
+	if (cfg->flags & XFBTREE_CREATE_LONG_PTRS) {
+		if (xfs_has_crc(mp))
+			return blocklen - XFS_BTREE_LBLOCK_CRC_LEN;
+
+		return blocklen - XFS_BTREE_LBLOCK_LEN;
+	}
+
+	if (xfs_has_crc(mp))
+		return blocklen - XFS_BTREE_SBLOCK_CRC_LEN;
+
+	return blocklen - XFS_BTREE_SBLOCK_LEN;
+}
+
+/* Initialize an empty leaf block as the btree root. */
+STATIC int
+xfbtree_init_leaf_block(
+	struct xfs_mount		*mp,
+	struct xfbtree			*xfbt,
+	const struct xfbtree_config	*cfg)
+{
+	struct xfs_buf			*bp;
+	xfs_daddr_t			daddr;
+	int				error;
+	unsigned int			bc_flags = 0;
+
+	if (cfg->flags & XFBTREE_CREATE_LONG_PTRS)
+		bc_flags |= XFS_BTREE_LONG_PTRS;
+
+	daddr = xfo_to_daddr(XFBTREE_INIT_LEAF_BLOCK);
+	error = xfs_buf_get(xfbt->target, daddr, xfbtree_bbsize(), &bp);
+	if (error)
+		return error;
+
+	trace_xfbtree_create_root_buf(xfbt, bp);
+
+	bp->b_ops = cfg->btree_ops->buf_ops;
+	xfs_btree_init_block_int(mp, bp->b_addr, daddr, cfg->btnum, 0, 0,
+			cfg->owner, bc_flags);
+	error = xfs_bwrite(bp);
+	xfs_buf_relse(bp);
+	if (error)
+		return error;
+
+	xfbt->highest_offset++;
+	return 0;
+}
+
+/* Initialize the in-memory btree header block. */
+STATIC int
+xfbtree_init_head(
+	struct xfbtree		*xfbt)
+{
+	struct xfs_buf		*bp;
+	xfs_daddr_t		daddr;
+	int			error;
+
+	daddr = xfo_to_daddr(XFBTREE_HEAD_BLOCK);
+	error = xfs_buf_get(xfbt->target, daddr, xfbtree_bbsize(), &bp);
+	if (error)
+		return error;
+
+	xfs_btree_mem_head_init(bp, xfbt->owner, XFBTREE_INIT_LEAF_BLOCK);
+	error = xfs_bwrite(bp);
+	xfs_buf_relse(bp);
+	if (error)
+		return error;
+
+	xfbt->highest_offset++;
+	return 0;
+}
+
+/* Create an xfile btree backing thing that can be used for in-memory btrees. */
+int
+xfbtree_create(
+	struct xfs_mount		*mp,
+	const struct xfbtree_config	*cfg,
+	struct xfbtree			**xfbtreep)
+{
+	struct xfbtree			*xfbt;
+	unsigned int			blocklen = xfbtree_rec_bytes(mp, cfg);
+	unsigned int			keyptr_len = cfg->btree_ops->key_len;
+	int				error;
+
+	/* Requires an xfile-backed buftarg. */
+	if (!(cfg->target->bt_flags & XFS_BUFTARG_XFILE)) {
+		ASSERT(cfg->target->bt_flags & XFS_BUFTARG_XFILE);
+		return -EINVAL;
+	}
+
+	xfbt = kzalloc(sizeof(struct xfbtree), XCHK_GFP_FLAGS);
+	if (!xfbt)
+		return -ENOMEM;
+	xfbt->target = cfg->target;
+	xfboff_bitmap_init(&xfbt->freespace);
+
+	/* Set up min/maxrecs for this btree. */
+	if (cfg->flags & XFBTREE_CREATE_LONG_PTRS)
+		keyptr_len += sizeof(__be64);
+	else
+		keyptr_len += sizeof(__be32);
+	xfbt->maxrecs[0] = blocklen / cfg->btree_ops->rec_len;
+	xfbt->maxrecs[1] = blocklen / keyptr_len;
+	xfbt->minrecs[0] = xfbt->maxrecs[0] / 2;
+	xfbt->minrecs[1] = xfbt->maxrecs[1] / 2;
+	xfbt->owner = cfg->owner;
+
+	/* Initialize the empty btree. */
+	error = xfbtree_init_leaf_block(mp, xfbt, cfg);
+	if (error)
+		goto err_freesp;
+
+	error = xfbtree_init_head(xfbt);
+	if (error)
+		goto err_freesp;
+
+	trace_xfbtree_create(mp, cfg, xfbt);
+
+	*xfbtreep = xfbt;
+	return 0;
+
+err_freesp:
+	xfboff_bitmap_destroy(&xfbt->freespace);
+	xfs_buftarg_drain(xfbt->target);
+	kfree(xfbt);
+	return error;
+}
+
+/* Read the in-memory btree head. */
+int
+xfbtree_head_read_buf(
+	struct xfbtree		*xfbt,
+	struct xfs_trans	*tp,
+	struct xfs_buf		**bpp)
+{
+	struct xfs_buftarg	*btp = xfbt->target;
+	struct xfs_mount	*mp = btp->bt_mount;
+	struct xfs_btree_mem_head *mhead;
+	struct xfs_buf		*bp;
+	xfs_daddr_t		daddr;
+	int			error;
+
+	daddr = xfo_to_daddr(XFBTREE_HEAD_BLOCK);
+	error = xfs_trans_read_buf(mp, tp, btp, daddr, xfbtree_bbsize(), 0,
+			&bp, &xfs_btree_mem_head_buf_ops);
+	if (error)
+		return error;
+
+	mhead = bp->b_addr;
+	if (be64_to_cpu(mhead->mh_owner) != xfbt->owner) {
+		xfs_verifier_error(bp, -EFSCORRUPTED, __this_address);
+		xfs_trans_brelse(tp, bp);
+		return -EFSCORRUPTED;
+	}
+
+	*bpp = bp;
+	return 0;
+}
+
+static inline struct xfile *xfbtree_xfile(struct xfbtree *xfbt)
+{
+	return xfbt->target->bt_xfile;
+}
+
+/* Allocate a block to our in-memory btree. */
+int
+xfbtree_alloc_block(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_ptr	*start,
+	union xfs_btree_ptr		*new,
+	int				*stat)
+{
+	struct xfbtree			*xfbt = cur->bc_mem.xfbtree;
+	xfileoff_t			bt_xfoff;
+	loff_t				pos;
+	int				error;
+
+	ASSERT(cur->bc_flags & XFS_BTREE_IN_XFILE);
+
+	/*
+	 * Find the first free block in the free space bitmap and take it.  If
+	 * none are found, seek to end of the file.
+	 */
+	error = xfboff_bitmap_take_first_set(&xfbt->freespace, &bt_xfoff);
+	if (error == -ENODATA) {
+		bt_xfoff = xfbt->highest_offset++;
+		error = 0;
+	}
+	if (error)
+		return error;
+
+	trace_xfbtree_alloc_block(xfbt, cur, bt_xfoff);
+
+	/* Fail if the block address exceeds the maximum for short pointers. */
+	if (!(cur->bc_flags & XFS_BTREE_LONG_PTRS) && bt_xfoff >= INT_MAX) {
+		*stat = 0;
+		return 0;
+	}
+
+	/* Make sure we actually can write to the block before we return it. */
+	pos = xfo_to_b(bt_xfoff);
+	error = xfile_prealloc(xfbtree_xfile(xfbt), pos, xfo_to_b(1));
+	if (error)
+		return error;
+
+	if (cur->bc_flags & XFS_BTREE_LONG_PTRS)
+		new->l = cpu_to_be64(bt_xfoff);
+	else
+		new->s = cpu_to_be32(bt_xfoff);
+
+	*stat = 1;
+	return 0;
+}
+
+/* Free a block from our in-memory btree. */
+int
+xfbtree_free_block(
+	struct xfs_btree_cur	*cur,
+	struct xfs_buf		*bp)
+{
+	struct xfbtree		*xfbt = cur->bc_mem.xfbtree;
+	xfileoff_t		bt_xfoff, bt_xflen;
+
+	ASSERT(cur->bc_flags & XFS_BTREE_IN_XFILE);
+
+	bt_xfoff = xfs_daddr_to_xfot(xfs_buf_daddr(bp));
+	bt_xflen = xfs_daddr_to_xfot(bp->b_length);
+
+	trace_xfbtree_free_block(xfbt, cur, bt_xfoff);
+
+	return xfboff_bitmap_set(&xfbt->freespace, bt_xfoff, bt_xflen);
+}
+
+/* Return the minimum number of records for a btree block. */
+int
+xfbtree_get_minrecs(
+	struct xfs_btree_cur	*cur,
+	int			level)
+{
+	struct xfbtree		*xfbt = cur->bc_mem.xfbtree;
+
+	return xfbt->minrecs[level != 0];
+}
+
+/* Return the maximum number of records for a btree block. */
+int
+xfbtree_get_maxrecs(
+	struct xfs_btree_cur	*cur,
+	int			level)
+{
+	struct xfbtree		*xfbt = cur->bc_mem.xfbtree;
+
+	return xfbt->maxrecs[level != 0];
+}
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
+ * Detach this (probably dirty) xfbtree buffer from the transaction by any
+ * means necessary.  Returns true if the buffer needs to be written.
+ */
+STATIC bool
+xfbtree_trans_bdetach(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp)
+{
+	struct xfs_buf_log_item	*bli = bp->b_log_item;
+	bool			dirty;
+
+	ASSERT(bli != NULL);
+
+	dirty = bli->bli_flags & (XFS_BLI_DIRTY | XFS_BLI_ORDERED);
+
+	bli->bli_flags &= ~(XFS_BLI_DIRTY | XFS_BLI_ORDERED |
+			    XFS_BLI_LOGGED | XFS_BLI_STALE);
+	clear_bit(XFS_LI_DIRTY, &bli->bli_item.li_flags);
+
+	while (bp->b_log_item != NULL)
+		xfs_trans_bdetach(tp, bp);
+
+	return dirty;
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
+	LIST_HEAD(buffer_list);
+	struct xfs_log_item	*lip, *n;
+	bool			corrupt = false;
+	bool			tp_dirty = false;
+
+	/*
+	 * For each xfbtree buffer attached to the transaction, write the dirty
+	 * buffers to the xfile and release them.
+	 */
+	list_for_each_entry_safe(lip, n, &tp->t_items, li_trans) {
+		struct xfs_buf	*bp = xfbtree_buf_match(xfbt, lip);
+		bool		dirty;
+
+		if (!bp) {
+			if (test_bit(XFS_LI_DIRTY, &lip->li_flags))
+				tp_dirty |= true;
+			continue;
+		}
+
+		trace_xfbtree_trans_commit_buf(xfbt, bp);
+
+		dirty = xfbtree_trans_bdetach(tp, bp);
+		if (dirty && !corrupt) {
+			xfs_failaddr_t	fa = bp->b_ops->verify_struct(bp);
+
+			/*
+			 * Because this btree is ephemeral, validate the buffer
+			 * structure before delwri_submit so that we can return
+			 * corruption errors to the caller without shutting
+			 * down the filesystem.
+			 *
+			 * If the buffer fails verification, log the failure
+			 * but continue walking the transaction items so that
+			 * we remove all ephemeral btree buffers.
+			 */
+			if (fa) {
+				corrupt = true;
+				xfs_verifier_error(bp, -EFSCORRUPTED, fa);
+			} else {
+				xfs_buf_delwri_queue_here(bp, &buffer_list);
+			}
+		}
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
+	if (corrupt) {
+		xfs_buf_delwri_cancel(&buffer_list);
+		return -EFSCORRUPTED;
+	}
+
+	if (list_empty(&buffer_list))
+		return 0;
+
+	return xfs_buf_delwri_submit(&buffer_list);
+}
+
+/*
+ * Cancel changes to the incore btree by detaching all the xfbtree buffers.
+ * Changes are not written to the backing store.  This is needed for online
+ * repair btrees, which are by nature ephemeral.
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
+		xfbtree_trans_bdetach(tp, bp);
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
diff --git a/fs/xfs/scrub/xfbtree.h b/fs/xfs/scrub/xfbtree.h
index b8d2f628e6b7c..ed48981e6c347 100644
--- a/fs/xfs/scrub/xfbtree.h
+++ b/fs/xfs/scrub/xfbtree.h
@@ -8,6 +8,8 @@
 
 #ifdef CONFIG_XFS_BTREE_IN_XFILE
 
+#include "scrub/bitmap.h"
+
 /* Root block for an in-memory btree. */
 struct xfs_btree_mem_head {
 	__be32				mh_magic;
@@ -21,14 +23,41 @@ struct xfs_btree_mem_head {
 
 /* xfile-backed in-memory btrees */
 
+struct xfboff_bitmap {
+	struct xbitmap64		xfoffbitmap;
+};
+
 struct xfbtree {
-	/* buffer cache target for this in-memory btree */
+	/* buffer cache target for the xfile backing this in-memory btree */
 	struct xfs_buftarg		*target;
 
+	/* Bitmap of free space from pos to used */
+	struct xfboff_bitmap		freespace;
+
+	/* Highest xfile offset that has been written to. */
+	xfileoff_t			highest_offset;
+
 	/* Owner of this btree. */
 	unsigned long long		owner;
+
+	/* Minimum and maximum records per block. */
+	unsigned int			maxrecs[2];
+	unsigned int			minrecs[2];
 };
 
+/* The head of the in-memory btree is always at block 0 */
+#define XFBTREE_HEAD_BLOCK		0
+
+/* in-memory btrees are always created with an empty leaf block at block 1 */
+#define XFBTREE_INIT_LEAF_BLOCK		1
+
+int xfbtree_head_read_buf(struct xfbtree *xfbt, struct xfs_trans *tp,
+		struct xfs_buf **bpp);
+
+void xfbtree_destroy(struct xfbtree *xfbt);
+int xfbtree_trans_commit(struct xfbtree *xfbt, struct xfs_trans *tp);
+void xfbtree_trans_cancel(struct xfbtree *xfbt, struct xfs_trans *tp);
+
 #endif /* CONFIG_XFS_BTREE_IN_XFILE */
 
 #endif /* XFS_SCRUB_XFBTREE_H__ */
diff --git a/fs/xfs/scrub/xfile.c b/fs/xfs/scrub/xfile.c
index a76677cba6a3b..9ab5d87963be2 100644
--- a/fs/xfs/scrub/xfile.c
+++ b/fs/xfs/scrub/xfile.c
@@ -278,6 +278,89 @@ xfile_pwrite(
 	return error;
 }
 
+/* Discard pages backing a range of the xfile. */
+void
+xfile_discard(
+	struct xfile		*xf,
+	loff_t			pos,
+	u64			count)
+{
+	trace_xfile_discard(xf, pos, count);
+	shmem_truncate_range(file_inode(xf->file), pos, pos + count - 1);
+}
+
+/* Ensure that there is storage backing the given range. */
+int
+xfile_prealloc(
+	struct xfile		*xf,
+	loff_t			pos,
+	u64			count)
+{
+	struct inode		*inode = file_inode(xf->file);
+	struct address_space	*mapping = inode->i_mapping;
+	const struct address_space_operations *aops = mapping->a_ops;
+	struct page		*page = NULL;
+	unsigned int		pflags;
+	int			error = 0;
+
+	if (count > MAX_RW_COUNT)
+		return -E2BIG;
+	if (inode->i_sb->s_maxbytes - pos < count)
+		return -EFBIG;
+
+	trace_xfile_prealloc(xf, pos, count);
+
+	pflags = memalloc_nofs_save();
+	while (count > 0) {
+		void		*fsdata = NULL;
+		unsigned int	len;
+		int		ret;
+
+		len = min_t(ssize_t, count, PAGE_SIZE - offset_in_page(pos));
+
+		/*
+		 * We call write_begin directly here to avoid all the freezer
+		 * protection lock-taking that happens in the normal path.
+		 * shmem doesn't support fs freeze, but lockdep doesn't know
+		 * that and will trip over that.
+		 */
+		error = aops->write_begin(NULL, mapping, pos, len, &page,
+				&fsdata);
+		if (error)
+			break;
+
+		/*
+		 * xfile pages must never be mapped into userspace, so we skip
+		 * the dcache flush.  If the page is not uptodate, zero it to
+		 * ensure we never go lacking for space here.
+		 */
+		if (!PageUptodate(page)) {
+			void	*kaddr = kmap_local_page(page);
+
+			memset(kaddr, 0, PAGE_SIZE);
+			SetPageUptodate(page);
+			kunmap_local(kaddr);
+		}
+
+		ret = aops->write_end(NULL, mapping, pos, len, len, page,
+				fsdata);
+		if (ret < 0) {
+			error = ret;
+			break;
+		}
+		if (ret != len) {
+			error = -EIO;
+			break;
+		}
+
+		count -= len;
+		pos += len;
+	}
+	memalloc_nofs_restore(pflags);
+
+	return error;
+}
+
 /* Find the next written area in the xfile data for a given offset. */
 loff_t
 xfile_seek_data(
diff --git a/fs/xfs/scrub/xfile.h b/fs/xfs/scrub/xfile.h
index 8bdea8788a8a7..36061af2c1352 100644
--- a/fs/xfs/scrub/xfile.h
+++ b/fs/xfs/scrub/xfile.h
@@ -64,6 +64,8 @@ xfile_obj_store(struct xfile *xf, const void *buf, size_t count, loff_t pos)
 	return 0;
 }
 
+void xfile_discard(struct xfile *xf, loff_t pos, u64 count);
+int xfile_prealloc(struct xfile *xf, loff_t pos, u64 count);
 loff_t xfile_seek_data(struct xfile *xf, loff_t pos);
 
 struct xfile_stat {
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 4a2615db742aa..ba3eed23533f0 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -637,6 +637,7 @@ DEFINE_BUF_ITEM_EVENT(xfs_trans_read_buf);
 DEFINE_BUF_ITEM_EVENT(xfs_trans_read_buf_recur);
 DEFINE_BUF_ITEM_EVENT(xfs_trans_log_buf);
 DEFINE_BUF_ITEM_EVENT(xfs_trans_brelse);
+DEFINE_BUF_ITEM_EVENT(xfs_trans_bdetach);
 DEFINE_BUF_ITEM_EVENT(xfs_trans_bjoin);
 DEFINE_BUF_ITEM_EVENT(xfs_trans_bhold);
 DEFINE_BUF_ITEM_EVENT(xfs_trans_bhold_release);
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 08ce757c74545..3f7e3a09a49ff 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -215,6 +215,7 @@ struct xfs_buf	*xfs_trans_getsb(struct xfs_trans *);
 
 void		xfs_trans_brelse(xfs_trans_t *, struct xfs_buf *);
 void		xfs_trans_bjoin(xfs_trans_t *, struct xfs_buf *);
+void		xfs_trans_bdetach(struct xfs_trans *tp, struct xfs_buf *bp);
 void		xfs_trans_bhold(xfs_trans_t *, struct xfs_buf *);
 void		xfs_trans_bhold_release(xfs_trans_t *, struct xfs_buf *);
 void		xfs_trans_binval(xfs_trans_t *, struct xfs_buf *);
diff --git a/fs/xfs/xfs_trans_buf.c b/fs/xfs/xfs_trans_buf.c
index 6549e50d852c0..e28ab74af4f0e 100644
--- a/fs/xfs/xfs_trans_buf.c
+++ b/fs/xfs/xfs_trans_buf.c
@@ -392,6 +392,48 @@ xfs_trans_brelse(
 	xfs_buf_relse(bp);
 }
 
+/*
+ * Forcibly detach a buffer previously joined to the transaction.  The caller
+ * will retain its locked reference to the buffer after this function returns.
+ * The buffer must be completely clean and must not be held to the transaction.
+ */
+void
+xfs_trans_bdetach(
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp)
+{
+	struct xfs_buf_log_item	*bip = bp->b_log_item;
+
+	ASSERT(tp != NULL);
+	ASSERT(bp->b_transp == tp);
+	ASSERT(bip->bli_item.li_type == XFS_LI_BUF);
+	ASSERT(atomic_read(&bip->bli_refcount) > 0);
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
+	ASSERT(!(bip->bli_flags & XFS_BLI_LOGGED));
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
  * iop_committing() routine is called.  The buffer must already be locked


