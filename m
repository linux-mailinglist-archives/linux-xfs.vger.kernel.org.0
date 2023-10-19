Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F17F7CFF6B
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Oct 2023 18:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233187AbjJSQXK (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 19 Oct 2023 12:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235465AbjJSQXJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2023 12:23:09 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0268F136
        for <linux-xfs@vger.kernel.org>; Thu, 19 Oct 2023 09:23:06 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84885C433C8;
        Thu, 19 Oct 2023 16:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697732586;
        bh=MNxeo9RJ6sVSu/qIm7Idxss7yE3AZli4J1cXhHuSg+s=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=h3fWXCRzoth9+R3+gtoTFsiU5f5c+U/j5ui5XONq2tJBnZtVkieY5UIYkCHywMRUQ
         Mem7FdNiByjPH5BPiIpQU3sz2MSUz3NtVikiZskJqywZTZqxQAW9nMZoGwkKb9/JFO
         OfK33GAWEiNnvHbg/TcKTaAKd3icAHPE0DfE8nKfm2AsIBGjCn6RhTQN6EtjfSh5Xt
         Pz+hNNJGnexF8yKBsNvk+SUiNDpTSrD7qYfMjEXhEY8qB6y9yxSb+ldKIoY7ElMDyk
         D3zj3PYR9gFbXQASdtoyeXjCYvL8hkvtwQkVDY+OVnEyH1QAuZhWd5+fbhNFGtSkO6
         EGRy/hTic8GRw==
Date:   Thu, 19 Oct 2023 09:23:05 -0700
Subject: [PATCH 3/8] xfs: move the xfs_rtbitmap.c declarations to
 xfs_rtbitmap.h
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        osandov@fb.com, hch@lst.de
Message-ID: <169773210169.225045.14351336042168057248.stgit@frogsfrogsfrogs>
In-Reply-To: <169773210112.225045.8142885021045785858.stgit@frogsfrogsfrogs>
References: <169773210112.225045.8142885021045785858.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Move all the declarations for functionality in xfs_rtbitmap.c into a
separate xfs_rtbitmap.h header file.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c     |    2 +
 fs/xfs/libxfs/xfs_rtbitmap.c |    1 +
 fs/xfs/libxfs/xfs_rtbitmap.h |   82 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/fscounters.c    |    2 +
 fs/xfs/scrub/rtbitmap.c      |    2 +
 fs/xfs/scrub/rtsummary.c     |    2 +
 fs/xfs/xfs_fsmap.c           |    2 +
 fs/xfs/xfs_rtalloc.c         |    1 +
 fs/xfs/xfs_rtalloc.h         |   73 -------------------------------------
 9 files changed, 89 insertions(+), 78 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_rtbitmap.h


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 617cc7e78e38..a47da8d3d1bc 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -21,7 +21,7 @@
 #include "xfs_bmap.h"
 #include "xfs_bmap_util.h"
 #include "xfs_bmap_btree.h"
-#include "xfs_rtalloc.h"
+#include "xfs_rtbitmap.h"
 #include "xfs_errortag.h"
 #include "xfs_error.h"
 #include "xfs_quota.h"
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 655108a4cd05..9eb1b5aa7e35 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -16,6 +16,7 @@
 #include "xfs_trans.h"
 #include "xfs_rtalloc.h"
 #include "xfs_error.h"
+#include "xfs_rtbitmap.h"
 
 /*
  * Realtime allocator bitmap functions shared with userspace.
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
new file mode 100644
index 000000000000..546dea34bb37
--- /dev/null
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
@@ -0,0 +1,82 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+#ifndef __XFS_RTBITMAP_H__
+#define	__XFS_RTBITMAP_H__
+
+/*
+ * XXX: Most of the realtime allocation functions deal in units of realtime
+ * extents, not realtime blocks.  This looks funny when paired with the type
+ * name and screams for a larger cleanup.
+ */
+struct xfs_rtalloc_rec {
+	xfs_rtblock_t		ar_startext;
+	xfs_rtblock_t		ar_extcount;
+};
+
+typedef int (*xfs_rtalloc_query_range_fn)(
+	struct xfs_mount		*mp,
+	struct xfs_trans		*tp,
+	const struct xfs_rtalloc_rec	*rec,
+	void				*priv);
+
+#ifdef CONFIG_XFS_RT
+int xfs_rtbuf_get(struct xfs_mount *mp, struct xfs_trans *tp,
+		  xfs_rtblock_t block, int issum, struct xfs_buf **bpp);
+int xfs_rtcheck_range(struct xfs_mount *mp, struct xfs_trans *tp,
+		      xfs_rtblock_t start, xfs_extlen_t len, int val,
+		      xfs_rtblock_t *new, int *stat);
+int xfs_rtfind_back(struct xfs_mount *mp, struct xfs_trans *tp,
+		    xfs_rtblock_t start, xfs_rtblock_t limit,
+		    xfs_rtblock_t *rtblock);
+int xfs_rtfind_forw(struct xfs_mount *mp, struct xfs_trans *tp,
+		    xfs_rtblock_t start, xfs_rtblock_t limit,
+		    xfs_rtblock_t *rtblock);
+int xfs_rtmodify_range(struct xfs_mount *mp, struct xfs_trans *tp,
+		       xfs_rtblock_t start, xfs_extlen_t len, int val);
+int xfs_rtmodify_summary_int(struct xfs_mount *mp, struct xfs_trans *tp,
+			     int log, xfs_rtblock_t bbno, int delta,
+			     struct xfs_buf **rbpp, xfs_fsblock_t *rsb,
+			     xfs_suminfo_t *sum);
+int xfs_rtmodify_summary(struct xfs_mount *mp, struct xfs_trans *tp, int log,
+			 xfs_rtblock_t bbno, int delta, struct xfs_buf **rbpp,
+			 xfs_fsblock_t *rsb);
+int xfs_rtfree_range(struct xfs_mount *mp, struct xfs_trans *tp,
+		     xfs_rtblock_t start, xfs_extlen_t len,
+		     struct xfs_buf **rbpp, xfs_fsblock_t *rsb);
+int xfs_rtalloc_query_range(struct xfs_mount *mp, struct xfs_trans *tp,
+		const struct xfs_rtalloc_rec *low_rec,
+		const struct xfs_rtalloc_rec *high_rec,
+		xfs_rtalloc_query_range_fn fn, void *priv);
+int xfs_rtalloc_query_all(struct xfs_mount *mp, struct xfs_trans *tp,
+			  xfs_rtalloc_query_range_fn fn,
+			  void *priv);
+bool xfs_verify_rtbno(struct xfs_mount *mp, xfs_rtblock_t rtbno);
+int xfs_rtalloc_extent_is_free(struct xfs_mount *mp, struct xfs_trans *tp,
+			       xfs_rtblock_t start, xfs_extlen_t len,
+			       bool *is_free);
+/*
+ * Free an extent in the realtime subvolume.  Length is expressed in
+ * realtime extents, as is the block number.
+ */
+int					/* error */
+xfs_rtfree_extent(
+	struct xfs_trans	*tp,	/* transaction pointer */
+	xfs_rtblock_t		bno,	/* starting block number to free */
+	xfs_extlen_t		len);	/* length of extent freed */
+
+/* Same as above, but in units of rt blocks. */
+int xfs_rtfree_blocks(struct xfs_trans *tp, xfs_fsblock_t rtbno,
+		xfs_filblks_t rtlen);
+#else /* CONFIG_XFS_RT */
+# define xfs_rtfree_extent(t,b,l)			(-ENOSYS)
+# define xfs_rtfree_blocks(t,rb,rl)			(-ENOSYS)
+# define xfs_rtalloc_query_range(m,t,l,h,f,p)		(-ENOSYS)
+# define xfs_rtalloc_query_all(m,t,f,p)			(-ENOSYS)
+# define xfs_rtbuf_get(m,t,b,i,p)			(-ENOSYS)
+# define xfs_rtalloc_extent_is_free(m,t,s,l,i)		(-ENOSYS)
+#endif /* CONFIG_XFS_RT */
+
+#endif /* __XFS_RTBITMAP_H__ */
diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index 05be757668bb..5799e9a94f1f 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -16,7 +16,7 @@
 #include "xfs_health.h"
 #include "xfs_btree.h"
 #include "xfs_ag.h"
-#include "xfs_rtalloc.h"
+#include "xfs_rtbitmap.h"
 #include "xfs_inode.h"
 #include "xfs_icache.h"
 #include "scrub/scrub.h"
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 008ddb599e13..2e5fd52f7af3 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -11,7 +11,7 @@
 #include "xfs_mount.h"
 #include "xfs_log_format.h"
 #include "xfs_trans.h"
-#include "xfs_rtalloc.h"
+#include "xfs_rtbitmap.h"
 #include "xfs_inode.h"
 #include "xfs_bmap.h"
 #include "scrub/scrub.h"
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index 437ed9acbb27..f4635a920470 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -13,7 +13,7 @@
 #include "xfs_inode.h"
 #include "xfs_log_format.h"
 #include "xfs_trans.h"
-#include "xfs_rtalloc.h"
+#include "xfs_rtbitmap.h"
 #include "xfs_bit.h"
 #include "xfs_bmap.h"
 #include "scrub/scrub.h"
diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 736e5545f584..8982c5d6cbd0 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -23,7 +23,7 @@
 #include "xfs_refcount.h"
 #include "xfs_refcount_btree.h"
 #include "xfs_alloc_btree.h"
-#include "xfs_rtalloc.h"
+#include "xfs_rtbitmap.h"
 #include "xfs_ag.h"
 
 /* Convert an xfs_fsmap to an fsmap. */
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 0e4e2df08aed..f2eb0c8b595d 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -19,6 +19,7 @@
 #include "xfs_icache.h"
 #include "xfs_rtalloc.h"
 #include "xfs_sb.h"
+#include "xfs_rtbitmap.h"
 
 /*
  * Read and return the summary information for a given extent size,
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index 65c284e9d33e..11859c259a1c 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -11,22 +11,6 @@
 struct xfs_mount;
 struct xfs_trans;
 
-/*
- * XXX: Most of the realtime allocation functions deal in units of realtime
- * extents, not realtime blocks.  This looks funny when paired with the type
- * name and screams for a larger cleanup.
- */
-struct xfs_rtalloc_rec {
-	xfs_rtblock_t		ar_startext;
-	xfs_rtblock_t		ar_extcount;
-};
-
-typedef int (*xfs_rtalloc_query_range_fn)(
-	struct xfs_mount		*mp,
-	struct xfs_trans		*tp,
-	const struct xfs_rtalloc_rec	*rec,
-	void				*priv);
-
 #ifdef CONFIG_XFS_RT
 /*
  * Function prototypes for exported functions.
@@ -48,19 +32,6 @@ xfs_rtallocate_extent(
 	xfs_extlen_t		prod,	/* extent product factor */
 	xfs_rtblock_t		*rtblock); /* out: start block allocated */
 
-/*
- * Free an extent in the realtime subvolume.  Length is expressed in
- * realtime extents, as is the block number.
- */
-int					/* error */
-xfs_rtfree_extent(
-	struct xfs_trans	*tp,	/* transaction pointer */
-	xfs_rtblock_t		bno,	/* starting block number to free */
-	xfs_extlen_t		len);	/* length of extent freed */
-
-/* Same as above, but in units of rt blocks. */
-int xfs_rtfree_blocks(struct xfs_trans *tp, xfs_fsblock_t rtbno,
-		xfs_filblks_t rtlen);
 
 /*
  * Initialize realtime fields in the mount structure.
@@ -102,55 +73,11 @@ xfs_growfs_rt(
 	struct xfs_mount	*mp,	/* file system mount structure */
 	xfs_growfs_rt_t		*in);	/* user supplied growfs struct */
 
-/*
- * From xfs_rtbitmap.c
- */
-int xfs_rtbuf_get(struct xfs_mount *mp, struct xfs_trans *tp,
-		  xfs_rtblock_t block, int issum, struct xfs_buf **bpp);
-int xfs_rtcheck_range(struct xfs_mount *mp, struct xfs_trans *tp,
-		      xfs_rtblock_t start, xfs_extlen_t len, int val,
-		      xfs_rtblock_t *new, int *stat);
-int xfs_rtfind_back(struct xfs_mount *mp, struct xfs_trans *tp,
-		    xfs_rtblock_t start, xfs_rtblock_t limit,
-		    xfs_rtblock_t *rtblock);
-int xfs_rtfind_forw(struct xfs_mount *mp, struct xfs_trans *tp,
-		    xfs_rtblock_t start, xfs_rtblock_t limit,
-		    xfs_rtblock_t *rtblock);
-int xfs_rtmodify_range(struct xfs_mount *mp, struct xfs_trans *tp,
-		       xfs_rtblock_t start, xfs_extlen_t len, int val);
-int xfs_rtmodify_summary_int(struct xfs_mount *mp, struct xfs_trans *tp,
-			     int log, xfs_rtblock_t bbno, int delta,
-			     struct xfs_buf **rbpp, xfs_fsblock_t *rsb,
-			     xfs_suminfo_t *sum);
-int xfs_rtmodify_summary(struct xfs_mount *mp, struct xfs_trans *tp, int log,
-			 xfs_rtblock_t bbno, int delta, struct xfs_buf **rbpp,
-			 xfs_fsblock_t *rsb);
-int xfs_rtfree_range(struct xfs_mount *mp, struct xfs_trans *tp,
-		     xfs_rtblock_t start, xfs_extlen_t len,
-		     struct xfs_buf **rbpp, xfs_fsblock_t *rsb);
-int xfs_rtalloc_query_range(struct xfs_mount *mp, struct xfs_trans *tp,
-		const struct xfs_rtalloc_rec *low_rec,
-		const struct xfs_rtalloc_rec *high_rec,
-		xfs_rtalloc_query_range_fn fn, void *priv);
-int xfs_rtalloc_query_all(struct xfs_mount *mp, struct xfs_trans *tp,
-			  xfs_rtalloc_query_range_fn fn,
-			  void *priv);
-bool xfs_verify_rtbno(struct xfs_mount *mp, xfs_rtblock_t rtbno);
-int xfs_rtalloc_extent_is_free(struct xfs_mount *mp, struct xfs_trans *tp,
-			       xfs_rtblock_t start, xfs_extlen_t len,
-			       bool *is_free);
 int xfs_rtalloc_reinit_frextents(struct xfs_mount *mp);
 #else
 # define xfs_rtallocate_extent(t,b,min,max,l,f,p,rb)	(-ENOSYS)
-# define xfs_rtfree_extent(t,b,l)			(-ENOSYS)
-# define xfs_rtfree_blocks(t,rb,rl)			(-ENOSYS)
 # define xfs_rtpick_extent(m,t,l,rb)			(-ENOSYS)
 # define xfs_growfs_rt(mp,in)				(-ENOSYS)
-# define xfs_rtalloc_query_range(m,t,l,h,f,p)		(-ENOSYS)
-# define xfs_rtalloc_query_all(m,t,f,p)			(-ENOSYS)
-# define xfs_rtbuf_get(m,t,b,i,p)			(-ENOSYS)
-# define xfs_verify_rtbno(m, r)				(false)
-# define xfs_rtalloc_extent_is_free(m,t,s,l,i)		(-ENOSYS)
 # define xfs_rtalloc_reinit_frextents(m)		(0)
 static inline int		/* error */
 xfs_rtmount_init(

