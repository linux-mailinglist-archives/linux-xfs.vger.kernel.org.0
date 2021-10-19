Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F283E433EC9
	for <lists+linux-xfs@lfdr.de>; Tue, 19 Oct 2021 20:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232717AbhJSSyL (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 19 Oct 2021 14:54:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:59140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231355AbhJSSyL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Oct 2021 14:54:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3450B61038;
        Tue, 19 Oct 2021 18:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634669518;
        bh=Z+d/4xqfg7SZCvFXuhr5ssXP3MVcZZumV3Cb6h0RTEo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ZmRVAnuoVYHYfS1hF7HEbWHOqGwvQaO11Uiebs+/HdpEvzoxlAy1ZP3QOdMvq6xr1
         LHTEYmxN8zv7NI7SCbudzjV0QiA+3rVaXedvueEocD8vwEG2N4L5QLvvAQjkyBlj5o
         yZfQQgR8llpZmL62y0YeZ/C6+HeQfgJIQPkODj5cKnG8M9+mSjNQ/3kksEy1ED/Brz
         I3UP0aYtTuP7GNNO/2VZyRMUSuc6ECjDKCW3tLV1r24ENOwfRz5C8kA5tdz0W/uHJJ
         ClW7A8ufJ5WaU1oEZNHlOzz4yGGeBB/V78Qd3OsSiLiIXf6+07sEHK/f7CuLezOQbE
         LOXcGZLwwM1Zw==
Subject: [PATCH 1/2] xfs: remove kmem_zone typedef
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 19 Oct 2021 11:51:57 -0700
Message-ID: <163466951789.2234337.5921537082518635597.stgit@magnolia>
In-Reply-To: <163466951226.2234337.10978241003370731405.stgit@magnolia>
References: <163466951226.2234337.10978241003370731405.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Remove these typedefs by referencing kmem_cache directly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/kmem.h                      |    4 ----
 fs/xfs/libxfs/xfs_alloc.c          |    2 +-
 fs/xfs/libxfs/xfs_alloc_btree.c    |    2 +-
 fs/xfs/libxfs/xfs_bmap.c           |    2 +-
 fs/xfs/libxfs/xfs_bmap.h           |    2 +-
 fs/xfs/libxfs/xfs_bmap_btree.c     |    2 +-
 fs/xfs/libxfs/xfs_btree.h          |    4 ++--
 fs/xfs/libxfs/xfs_da_btree.c       |    2 +-
 fs/xfs/libxfs/xfs_da_btree.h       |    2 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    2 +-
 fs/xfs/libxfs/xfs_inode_fork.c     |    2 +-
 fs/xfs/libxfs/xfs_inode_fork.h     |    2 +-
 fs/xfs/libxfs/xfs_refcount_btree.c |    2 +-
 fs/xfs/libxfs/xfs_rmap_btree.c     |    2 +-
 fs/xfs/xfs_bmap_item.c             |    4 ++--
 fs/xfs/xfs_bmap_item.h             |    6 +++---
 fs/xfs/xfs_buf.c                   |    2 +-
 fs/xfs/xfs_buf_item.c              |    2 +-
 fs/xfs/xfs_buf_item.h              |    2 +-
 fs/xfs/xfs_dquot.c                 |    4 ++--
 fs/xfs/xfs_extfree_item.c          |    4 ++--
 fs/xfs/xfs_extfree_item.h          |    6 +++---
 fs/xfs/xfs_icreate_item.c          |    2 +-
 fs/xfs/xfs_icreate_item.h          |    2 +-
 fs/xfs/xfs_inode.c                 |    2 +-
 fs/xfs/xfs_inode.h                 |    2 +-
 fs/xfs/xfs_inode_item.c            |    2 +-
 fs/xfs/xfs_inode_item.h            |    2 +-
 fs/xfs/xfs_log.c                   |    2 +-
 fs/xfs/xfs_log_priv.h              |    2 +-
 fs/xfs/xfs_qm.h                    |    2 +-
 fs/xfs/xfs_refcount_item.c         |    4 ++--
 fs/xfs/xfs_refcount_item.h         |    6 +++---
 fs/xfs/xfs_rmap_item.c             |    4 ++--
 fs/xfs/xfs_rmap_item.h             |    6 +++---
 fs/xfs/xfs_trans.c                 |    2 +-
 fs/xfs/xfs_trans.h                 |    2 +-
 37 files changed, 50 insertions(+), 54 deletions(-)


diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
index 54da6d717a06..b987dc2c6851 100644
--- a/fs/xfs/kmem.h
+++ b/fs/xfs/kmem.h
@@ -72,10 +72,6 @@ kmem_zalloc(size_t size, xfs_km_flags_t flags)
 /*
  * Zone interfaces
  */
-
-#define kmem_zone	kmem_cache
-#define kmem_zone_t	struct kmem_cache
-
 static inline struct page *
 kmem_to_page(void *addr)
 {
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 1a5684af8430..9bce5b258cd0 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -27,7 +27,7 @@
 #include "xfs_ag_resv.h"
 #include "xfs_bmap.h"
 
-extern kmem_zone_t	*xfs_bmap_free_item_zone;
+extern struct kmem_cache	*xfs_bmap_free_item_zone;
 
 struct workqueue_struct *xfs_alloc_wq;
 
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 609d349e7bd4..8c9f73cc0bee 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -20,7 +20,7 @@
 #include "xfs_trans.h"
 #include "xfs_ag.h"
 
-static kmem_zone_t	*xfs_allocbt_cur_cache;
+static struct kmem_cache	*xfs_allocbt_cur_cache;
 
 STATIC struct xfs_btree_cur *
 xfs_allocbt_dup_cursor(
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 321617e837ef..de106afb1bd7 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -38,7 +38,7 @@
 #include "xfs_iomap.h"
 
 
-kmem_zone_t		*xfs_bmap_free_item_zone;
+struct kmem_cache		*xfs_bmap_free_item_zone;
 
 /*
  * Miscellaneous helper functions
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 67641f669918..171a72ee9f31 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -13,7 +13,7 @@ struct xfs_inode;
 struct xfs_mount;
 struct xfs_trans;
 
-extern kmem_zone_t	*xfs_bmap_free_item_zone;
+extern struct kmem_cache	*xfs_bmap_free_item_zone;
 
 /*
  * Argument structure for xfs_bmap_alloc.
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 107ac1d127bf..3c9a45233e60 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -22,7 +22,7 @@
 #include "xfs_trace.h"
 #include "xfs_rmap.h"
 
-static kmem_zone_t	*xfs_bmbt_cur_cache;
+static struct kmem_cache	*xfs_bmbt_cur_cache;
 
 /*
  * Convert on-disk form of btree root to in-memory form.
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 7bc5a3796052..22d9f411fde6 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -230,7 +230,7 @@ struct xfs_btree_cur
 	struct xfs_trans	*bc_tp;	/* transaction we're in, if any */
 	struct xfs_mount	*bc_mp;	/* file system mount struct */
 	const struct xfs_btree_ops *bc_ops;
-	kmem_zone_t		*bc_cache; /* cursor cache */
+	struct kmem_cache	*bc_cache; /* cursor cache */
 	unsigned int		bc_flags; /* btree features - below */
 	xfs_btnum_t		bc_btnum; /* identifies which btree type */
 	union xfs_btree_irec	bc_rec;	/* current insert/search record value */
@@ -586,7 +586,7 @@ xfs_btree_alloc_cursor(
 	struct xfs_trans	*tp,
 	xfs_btnum_t		btnum,
 	uint8_t			maxlevels,
-	kmem_zone_t		*cache)
+	struct kmem_cache	*cache)
 {
 	struct xfs_btree_cur	*cur;
 
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index c062e2c85178..106776927b04 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -72,7 +72,7 @@ STATIC int	xfs_da3_blk_unlink(xfs_da_state_t *state,
 				  xfs_da_state_blk_t *save_blk);
 
 
-kmem_zone_t *xfs_da_state_zone;	/* anchor for state struct zone */
+struct kmem_cache *xfs_da_state_zone;	/* anchor for state struct zone */
 
 /*
  * Allocate a dir-state structure.
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index ad5dd324631a..da845e32a678 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -227,6 +227,6 @@ void	xfs_da3_node_hdr_from_disk(struct xfs_mount *mp,
 void	xfs_da3_node_hdr_to_disk(struct xfs_mount *mp,
 		struct xfs_da_intnode *to, struct xfs_da3_icnode_hdr *from);
 
-extern struct kmem_zone *xfs_da_state_zone;
+extern struct kmem_cache *xfs_da_state_zone;
 
 #endif	/* __XFS_DA_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 4a11024408e0..b2ad2fdc40f5 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -22,7 +22,7 @@
 #include "xfs_rmap.h"
 #include "xfs_ag.h"
 
-static kmem_zone_t	*xfs_inobt_cur_cache;
+static struct kmem_cache	*xfs_inobt_cur_cache;
 
 STATIC int
 xfs_inobt_get_minrecs(
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 08a390a25949..c60ed01a4cad 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -26,7 +26,7 @@
 #include "xfs_types.h"
 #include "xfs_errortag.h"
 
-kmem_zone_t *xfs_ifork_zone;
+struct kmem_cache *xfs_ifork_zone;
 
 void
 xfs_init_local_fork(
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index a6f7897b6887..cb296bd5baae 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -221,7 +221,7 @@ static inline bool xfs_iext_peek_prev_extent(struct xfs_ifork *ifp,
 	     xfs_iext_get_extent((ifp), (ext), (got));	\
 	     xfs_iext_next((ifp), (ext)))
 
-extern struct kmem_zone	*xfs_ifork_zone;
+extern struct kmem_cache	*xfs_ifork_zone;
 
 extern void xfs_ifork_init_cow(struct xfs_inode *ip);
 
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 6c4deb436c07..d14c1720b0fb 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -21,7 +21,7 @@
 #include "xfs_rmap.h"
 #include "xfs_ag.h"
 
-static kmem_zone_t	*xfs_refcountbt_cur_cache;
+static struct kmem_cache	*xfs_refcountbt_cur_cache;
 
 static struct xfs_btree_cur *
 xfs_refcountbt_dup_cursor(
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 3d4134eab8cf..69e104d0277f 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -22,7 +22,7 @@
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
 
-static kmem_zone_t	*xfs_rmapbt_cur_cache;
+static struct kmem_cache	*xfs_rmapbt_cur_cache;
 
 /*
  * Reverse map btree.
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index e66c85a75104..3d2725178eeb 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -25,8 +25,8 @@
 #include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
 
-kmem_zone_t	*xfs_bui_zone;
-kmem_zone_t	*xfs_bud_zone;
+struct kmem_cache	*xfs_bui_zone;
+struct kmem_cache	*xfs_bud_zone;
 
 static const struct xfs_item_ops xfs_bui_item_ops;
 
diff --git a/fs/xfs/xfs_bmap_item.h b/fs/xfs/xfs_bmap_item.h
index b9be62f8bd52..6af6b02d4b66 100644
--- a/fs/xfs/xfs_bmap_item.h
+++ b/fs/xfs/xfs_bmap_item.h
@@ -25,7 +25,7 @@
 /* kernel only BUI/BUD definitions */
 
 struct xfs_mount;
-struct kmem_zone;
+struct kmem_cache;
 
 /*
  * Max number of extents in fast allocation path.
@@ -65,7 +65,7 @@ struct xfs_bud_log_item {
 	struct xfs_bud_log_format	bud_format;
 };
 
-extern struct kmem_zone	*xfs_bui_zone;
-extern struct kmem_zone	*xfs_bud_zone;
+extern struct kmem_cache	*xfs_bui_zone;
+extern struct kmem_cache	*xfs_bud_zone;
 
 #endif	/* __XFS_BMAP_ITEM_H__ */
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 5fa6cd947dd4..1f4a1d63cb4a 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -20,7 +20,7 @@
 #include "xfs_error.h"
 #include "xfs_ag.h"
 
-static kmem_zone_t *xfs_buf_zone;
+static struct kmem_cache *xfs_buf_zone;
 
 /*
  * Locking orders
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index b1ab100c09e1..19f571b1a442 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -23,7 +23,7 @@
 #include "xfs_log.h"
 
 
-kmem_zone_t	*xfs_buf_item_zone;
+struct kmem_cache	*xfs_buf_item_zone;
 
 static inline struct xfs_buf_log_item *BUF_ITEM(struct xfs_log_item *lip)
 {
diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index 50aa0f5ef959..e70400dd7d16 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -71,6 +71,6 @@ static inline void xfs_buf_dquot_io_fail(struct xfs_buf *bp)
 void	xfs_buf_iodone(struct xfs_buf *);
 bool	xfs_buf_log_check_iovec(struct xfs_log_iovec *iovec);
 
-extern kmem_zone_t	*xfs_buf_item_zone;
+extern struct kmem_cache	*xfs_buf_item_zone;
 
 #endif	/* __XFS_BUF_ITEM_H__ */
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index c9e1f2c94bd4..283b6740afea 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -38,8 +38,8 @@
  * otherwise by the lowest id first, see xfs_dqlock2.
  */
 
-struct kmem_zone		*xfs_qm_dqtrxzone;
-static struct kmem_zone		*xfs_qm_dqzone;
+struct kmem_cache		*xfs_qm_dqtrxzone;
+static struct kmem_cache		*xfs_qm_dqzone;
 
 static struct lock_class_key xfs_dquot_group_class;
 static struct lock_class_key xfs_dquot_project_class;
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index ac67fc531315..a5bef52cc6b3 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -25,8 +25,8 @@
 #include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
 
-kmem_zone_t	*xfs_efi_zone;
-kmem_zone_t	*xfs_efd_zone;
+struct kmem_cache	*xfs_efi_zone;
+struct kmem_cache	*xfs_efd_zone;
 
 static const struct xfs_item_ops xfs_efi_item_ops;
 
diff --git a/fs/xfs/xfs_extfree_item.h b/fs/xfs/xfs_extfree_item.h
index cd2860c875bf..e8644945290e 100644
--- a/fs/xfs/xfs_extfree_item.h
+++ b/fs/xfs/xfs_extfree_item.h
@@ -9,7 +9,7 @@
 /* kernel only EFI/EFD definitions */
 
 struct xfs_mount;
-struct kmem_zone;
+struct kmem_cache;
 
 /*
  * Max number of extents in fast allocation path.
@@ -69,7 +69,7 @@ struct xfs_efd_log_item {
  */
 #define	XFS_EFD_MAX_FAST_EXTENTS	16
 
-extern struct kmem_zone	*xfs_efi_zone;
-extern struct kmem_zone	*xfs_efd_zone;
+extern struct kmem_cache	*xfs_efi_zone;
+extern struct kmem_cache	*xfs_efd_zone;
 
 #endif	/* __XFS_EXTFREE_ITEM_H__ */
diff --git a/fs/xfs/xfs_icreate_item.c b/fs/xfs/xfs_icreate_item.c
index 017904a34c02..7905518c4356 100644
--- a/fs/xfs/xfs_icreate_item.c
+++ b/fs/xfs/xfs_icreate_item.c
@@ -20,7 +20,7 @@
 #include "xfs_ialloc.h"
 #include "xfs_trace.h"
 
-kmem_zone_t	*xfs_icreate_zone;		/* inode create item zone */
+struct kmem_cache	*xfs_icreate_zone;		/* inode create item zone */
 
 static inline struct xfs_icreate_item *ICR_ITEM(struct xfs_log_item *lip)
 {
diff --git a/fs/xfs/xfs_icreate_item.h b/fs/xfs/xfs_icreate_item.h
index a50d0b01e15a..944427b33645 100644
--- a/fs/xfs/xfs_icreate_item.h
+++ b/fs/xfs/xfs_icreate_item.h
@@ -12,7 +12,7 @@ struct xfs_icreate_item {
 	struct xfs_icreate_log	ic_format;
 };
 
-extern kmem_zone_t *xfs_icreate_zone;	/* inode create item zone */
+extern struct kmem_cache *xfs_icreate_zone;	/* inode create item zone */
 
 void xfs_icreate_log(struct xfs_trans *tp, xfs_agnumber_t agno,
 			xfs_agblock_t agbno, unsigned int count,
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index a4f6f034fb81..91cc52b906cb 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -36,7 +36,7 @@
 #include "xfs_reflink.h"
 #include "xfs_ag.h"
 
-kmem_zone_t *xfs_inode_zone;
+struct kmem_cache *xfs_inode_zone;
 
 /*
  * Used in xfs_itruncate_extents().  This is the maximum number of extents
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index b21b177832d1..5cb495a16c34 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -504,7 +504,7 @@ static inline void xfs_setup_existing_inode(struct xfs_inode *ip)
 
 void xfs_irele(struct xfs_inode *ip);
 
-extern struct kmem_zone	*xfs_inode_zone;
+extern struct kmem_cache	*xfs_inode_zone;
 
 /* The default CoW extent size hint. */
 #define XFS_DEFAULT_COWEXTSZ_HINT 32
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 0659d19c211e..e2af36e93966 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -21,7 +21,7 @@
 
 #include <linux/iversion.h>
 
-kmem_zone_t	*xfs_ili_zone;		/* inode log item zone */
+struct kmem_cache	*xfs_ili_zone;		/* inode log item zone */
 
 static inline struct xfs_inode_log_item *INODE_ITEM(struct xfs_log_item *lip)
 {
diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
index 403b45ab9aa2..f9de34d3954a 100644
--- a/fs/xfs/xfs_inode_item.h
+++ b/fs/xfs/xfs_inode_item.h
@@ -47,6 +47,6 @@ extern void xfs_iflush_abort(struct xfs_inode *);
 extern int xfs_inode_item_format_convert(xfs_log_iovec_t *,
 					 struct xfs_inode_log_format *);
 
-extern struct kmem_zone	*xfs_ili_zone;
+extern struct kmem_cache	*xfs_ili_zone;
 
 #endif	/* __XFS_INODE_ITEM_H__ */
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index f6cd2d4aa770..011055375709 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -21,7 +21,7 @@
 #include "xfs_sb.h"
 #include "xfs_health.h"
 
-kmem_zone_t	*xfs_log_ticket_zone;
+struct kmem_cache	*xfs_log_ticket_zone;
 
 /* Local miscellaneous function prototypes */
 STATIC struct xlog *
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 844fbeec3545..1b03277029c1 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -497,7 +497,7 @@ xlog_recover_cancel(struct xlog *);
 extern __le32	 xlog_cksum(struct xlog *log, struct xlog_rec_header *rhead,
 			    char *dp, int size);
 
-extern kmem_zone_t *xfs_log_ticket_zone;
+extern struct kmem_cache *xfs_log_ticket_zone;
 struct xlog_ticket *
 xlog_ticket_alloc(
 	struct xlog	*log,
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index 442a0f97a9d4..5e8b70526538 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -11,7 +11,7 @@
 
 struct xfs_inode;
 
-extern struct kmem_zone	*xfs_qm_dqtrxzone;
+extern struct kmem_cache	*xfs_qm_dqtrxzone;
 
 /*
  * Number of bmaps that we ask from bmapi when doing a quotacheck.
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 61bbbe816b5e..0ca8da55053d 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -21,8 +21,8 @@
 #include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
 
-kmem_zone_t	*xfs_cui_zone;
-kmem_zone_t	*xfs_cud_zone;
+struct kmem_cache	*xfs_cui_zone;
+struct kmem_cache	*xfs_cud_zone;
 
 static const struct xfs_item_ops xfs_cui_item_ops;
 
diff --git a/fs/xfs/xfs_refcount_item.h b/fs/xfs/xfs_refcount_item.h
index f4f2e836540b..22c69c5a8394 100644
--- a/fs/xfs/xfs_refcount_item.h
+++ b/fs/xfs/xfs_refcount_item.h
@@ -25,7 +25,7 @@
 /* kernel only CUI/CUD definitions */
 
 struct xfs_mount;
-struct kmem_zone;
+struct kmem_cache;
 
 /*
  * Max number of extents in fast allocation path.
@@ -68,7 +68,7 @@ struct xfs_cud_log_item {
 	struct xfs_cud_log_format	cud_format;
 };
 
-extern struct kmem_zone	*xfs_cui_zone;
-extern struct kmem_zone	*xfs_cud_zone;
+extern struct kmem_cache	*xfs_cui_zone;
+extern struct kmem_cache	*xfs_cud_zone;
 
 #endif	/* __XFS_REFCOUNT_ITEM_H__ */
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 181cd24d2ba9..b65987f97b89 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -21,8 +21,8 @@
 #include "xfs_log_priv.h"
 #include "xfs_log_recover.h"
 
-kmem_zone_t	*xfs_rui_zone;
-kmem_zone_t	*xfs_rud_zone;
+struct kmem_cache	*xfs_rui_zone;
+struct kmem_cache	*xfs_rud_zone;
 
 static const struct xfs_item_ops xfs_rui_item_ops;
 
diff --git a/fs/xfs/xfs_rmap_item.h b/fs/xfs/xfs_rmap_item.h
index 31e6cdfff71f..b062b983a82f 100644
--- a/fs/xfs/xfs_rmap_item.h
+++ b/fs/xfs/xfs_rmap_item.h
@@ -28,7 +28,7 @@
 /* kernel only RUI/RUD definitions */
 
 struct xfs_mount;
-struct kmem_zone;
+struct kmem_cache;
 
 /*
  * Max number of extents in fast allocation path.
@@ -68,7 +68,7 @@ struct xfs_rud_log_item {
 	struct xfs_rud_log_format	rud_format;
 };
 
-extern struct kmem_zone	*xfs_rui_zone;
-extern struct kmem_zone	*xfs_rud_zone;
+extern struct kmem_cache	*xfs_rui_zone;
+extern struct kmem_cache	*xfs_rud_zone;
 
 #endif	/* __XFS_RMAP_ITEM_H__ */
diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index fcc797b5c113..3faa1baa5a89 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -25,7 +25,7 @@
 #include "xfs_dquot.h"
 #include "xfs_icache.h"
 
-kmem_zone_t	*xfs_trans_zone;
+struct kmem_cache	*xfs_trans_zone;
 
 #if defined(CONFIG_TRACEPOINTS)
 static void
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 3d2e89c4d446..88750576dd89 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -237,7 +237,7 @@ void		xfs_trans_buf_set_type(struct xfs_trans *, struct xfs_buf *,
 void		xfs_trans_buf_copy_type(struct xfs_buf *dst_bp,
 					struct xfs_buf *src_bp);
 
-extern kmem_zone_t	*xfs_trans_zone;
+extern struct kmem_cache	*xfs_trans_zone;
 
 static inline struct xfs_log_item *
 xfs_trans_item_relog(

