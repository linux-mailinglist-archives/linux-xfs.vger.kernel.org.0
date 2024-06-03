Return-Path: <linux-xfs+bounces-8983-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 389578D89F7
	for <lists+linux-xfs@lfdr.de>; Mon,  3 Jun 2024 21:21:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 88B62B25735
	for <lists+linux-xfs@lfdr.de>; Mon,  3 Jun 2024 19:21:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FA53250EC;
	Mon,  3 Jun 2024 19:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xl47GOcf"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0048F23A0
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717442476; cv=none; b=MLmqJkok5dM00taL5jv+NRblwNmNf8LE+kjk57wLatg/jwxV0CcYdXtioKRCE7S7ga7iitqL5JO3fp0V3pE3iW+WSa3Xi5kwt+YfyLwb4PSfa9uYrqusL3+g87hqQXaG0mw4Ci8SnmL6bOnDy4MqEZ7gNqkcuxCpfvVeZDY8kqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717442476; c=relaxed/simple;
	bh=LlD72zMPdAJnpRK9KH66WyehusDpwwrSazotfmy7SCI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=taWBfVq3pFfwkuMk9wzom8rT9KqCcBXflWyxIjcZpmW4chUzKU2o3nWwVdJ/fLL0x0/ENoNbQtf6rHrQraEaquUOED+OHT7C5gBQuApshghsiLRa+fUyI1KUUo5GPMpl0ZrlaFHPVR3H4Gtj3kxgMuqlddadLfnfji8RV6f5/WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xl47GOcf; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA9EFC4AF0A;
	Mon,  3 Jun 2024 19:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717442475;
	bh=LlD72zMPdAJnpRK9KH66WyehusDpwwrSazotfmy7SCI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Xl47GOcf6p57mw3ec5blw3K1Lxa4d8J3iZc+VUVFJps3H6jB12nspzGdw7vn6QCCN
	 FLoWwUCnFYVShtWNG/cmMewVTY/lZ+D4mmAepMYGu7DnuMGzF4Fl//U/P8lZiFCjEt
	 ZQJngA6DmrxPLk+EFbTIz/aU3beVrigul8C/D+XTNzTnGohOOW/FoxM+rmBkjim7AQ
	 R4hIKm+CEsNcpml3tbTO5EWjYs+S+0G9BPV4ED00MBtYFQa6bVSE15m4USvesjX05G
	 MYwSudABAITVbi7zJaVpkEa9DFzKwHQU15lT/uZMzEhOI1zchtrVTNtxTwod6DkmZx
	 4UNa46BF2H2nQ==
Date: Mon, 03 Jun 2024 12:21:15 -0700
Subject: [PATCH 1/4] libxfs: remove kmem_alloc, kmem_zalloc, and kmem_free
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171744041373.1447589.12117343060427706341.stgit@frogsfrogsfrogs>
In-Reply-To: <171744041355.1447589.2661742462217465267.stgit@frogsfrogsfrogs>
References: <171744041355.1447589.2661742462217465267.stgit@frogsfrogsfrogs>
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

Remove all three of these helpers now that the kernel has dropped them.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/bmap_inflate.c         |    2 +-
 include/kmem.h            |   10 +---------
 libxfs/defer_item.c       |    2 +-
 libxfs/init.c             |    2 +-
 libxfs/kmem.c             |   32 ++++++++++----------------------
 libxlog/xfs_log_recover.c |   19 +++++++++----------
 repair/bmap_repair.c      |    4 ++--
 7 files changed, 25 insertions(+), 46 deletions(-)


diff --git a/db/bmap_inflate.c b/db/bmap_inflate.c
index c85d5dc0d..00e1aff66 100644
--- a/db/bmap_inflate.c
+++ b/db/bmap_inflate.c
@@ -327,7 +327,7 @@ populate_btree(
 	/* Leak any unused blocks */
 	list_for_each_entry_safe(resv, n, &bd.resv_list, list) {
 		list_del(&resv->list);
-		kmem_free(resv);
+		kfree(resv);
 	}
 	return error;
 }
diff --git a/include/kmem.h b/include/kmem.h
index 6818a4047..386b4a6be 100644
--- a/include/kmem.h
+++ b/include/kmem.h
@@ -50,15 +50,7 @@ kmem_cache_free(struct kmem_cache *cache, void *ptr)
 	free(ptr);
 }
 
-extern void	*kmem_alloc(size_t, int);
 extern void	*kvmalloc(size_t, gfp_t);
-extern void	*kmem_zalloc(size_t, int);
-
-static inline void
-kmem_free(const void *ptr) {
-	free((void *)ptr);
-}
-
 extern void	*krealloc(void *, size_t, int);
 
 static inline void *kmalloc(size_t size, gfp_t flags)
@@ -70,7 +62,7 @@ static inline void *kmalloc(size_t size, gfp_t flags)
 
 static inline void kfree(const void *ptr)
 {
-	return kmem_free(ptr);
+	free((void *)ptr);
 }
 
 #endif
diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index d67032c26..680a72664 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -606,7 +606,7 @@ xfs_attr_free_item(
 	if (attr->xattri_da_state)
 		xfs_da_state_free(attr->xattri_da_state);
 	if (attr->xattri_da_args->op_flags & XFS_DA_OP_RECOVERY)
-		kmem_free(attr);
+		kfree(attr);
 	else
 		kmem_cache_free(xfs_attr_intent_cache, attr);
 }
diff --git a/libxfs/init.c b/libxfs/init.c
index 82618a07e..de91bbf3c 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -893,7 +893,7 @@ libxfs_buftarg_free(
 	struct xfs_buftarg	*btp)
 {
 	cache_destroy(btp->bcache);
-	kmem_free(btp);
+	kfree(btp);
 }
 
 /*
diff --git a/libxfs/kmem.c b/libxfs/kmem.c
index c264be018..a2a3935d0 100644
--- a/libxfs/kmem.c
+++ b/libxfs/kmem.c
@@ -65,33 +65,21 @@ kmem_cache_zalloc(struct kmem_cache *cache, gfp_t flags)
 	return ptr;
 }
 
-void *
-kmem_alloc(size_t size, int flags)
-{
-	void	*ptr = malloc(size);
-
-	if (ptr == NULL) {
-		fprintf(stderr, _("%s: malloc failed (%d bytes): %s\n"),
-			progname, (int)size, strerror(errno));
-		exit(1);
-	}
-	return ptr;
-}
-
 void *
 kvmalloc(size_t size, gfp_t flags)
 {
+	void	*ptr;
+
 	if (flags & __GFP_ZERO)
-		return kmem_zalloc(size, 0);
-	return kmem_alloc(size, 0);
-}
+		ptr = calloc(1, size);
+	else
+		ptr = malloc(size);
 
-void *
-kmem_zalloc(size_t size, int flags)
-{
-	void	*ptr = kmem_alloc(size, flags);
-
-	memset(ptr, 0, size);
+	if (ptr == NULL) {
+		fprintf(stderr, _("%s: malloc failed (%d bytes): %s\n"),
+			progname, (int)size, strerror(errno));
+		exit(1);
+	}
 	return ptr;
 }
 
diff --git a/libxlog/xfs_log_recover.c b/libxlog/xfs_log_recover.c
index 99f759d5c..31b11fee9 100644
--- a/libxlog/xfs_log_recover.c
+++ b/libxlog/xfs_log_recover.c
@@ -991,7 +991,7 @@ xlog_recover_new_tid(
 {
 	struct xlog_recover	*trans;
 
-	trans = kmem_zalloc(sizeof(struct xlog_recover), 0);
+	trans = kzalloc(sizeof(struct xlog_recover), 0);
 	trans->r_log_tid   = tid;
 	trans->r_lsn	   = lsn;
 	INIT_LIST_HEAD(&trans->r_itemq);
@@ -1006,7 +1006,7 @@ xlog_recover_add_item(
 {
 	struct xlog_recover_item *item;
 
-	item = kmem_zalloc(sizeof(struct xlog_recover_item), 0);
+	item = kzalloc(sizeof(struct xlog_recover_item), 0);
 	INIT_LIST_HEAD(&item->ri_list);
 	list_add_tail(&item->ri_list, head);
 }
@@ -1085,7 +1085,7 @@ xlog_recover_add_to_trans(
 		return 0;
 	}
 
-	ptr = kmem_alloc(len, 0);
+	ptr = kmalloc(len, 0);
 	memcpy(ptr, dp, len);
 	in_f = (struct xfs_inode_log_format *)ptr;
 
@@ -1107,13 +1107,12 @@ xlog_recover_add_to_trans(
 		"bad number of regions (%d) in inode log format",
 				  in_f->ilf_size);
 			ASSERT(0);
-			kmem_free(ptr);
+			kfree(ptr);
 			return XFS_ERROR(EIO);
 		}
 
 		item->ri_total = in_f->ilf_size;
-		item->ri_buf =
-			kmem_zalloc(item->ri_total * sizeof(xfs_log_iovec_t),
+		item->ri_buf = kzalloc(item->ri_total * sizeof(xfs_log_iovec_t),
 				    0);
 	}
 	ASSERT(item->ri_total > item->ri_cnt);
@@ -1141,13 +1140,13 @@ xlog_recover_free_trans(
 		/* Free the regions in the item. */
 		list_del(&item->ri_list);
 		for (i = 0; i < item->ri_cnt; i++)
-			kmem_free(item->ri_buf[i].i_addr);
+			kfree(item->ri_buf[i].i_addr);
 		/* Free the item itself */
-		kmem_free(item->ri_buf);
-		kmem_free(item);
+		kfree(item->ri_buf);
+		kfree(item);
 	}
 	/* Free the transaction recover structure */
-	kmem_free(trans);
+	kfree(trans);
 }
 
 /*
diff --git a/repair/bmap_repair.c b/repair/bmap_repair.c
index 845584f18..317061aa5 100644
--- a/repair/bmap_repair.c
+++ b/repair/bmap_repair.c
@@ -595,7 +595,7 @@ xrep_bmap(
 	if (error)
 		return error;
 
-	rb = kmem_zalloc(sizeof(struct xrep_bmap), KM_NOFS | KM_MAYFAIL);
+	rb = kzalloc(sizeof(struct xrep_bmap), 0);
 	if (!rb)
 		return ENOMEM;
 	rb->sc = sc;
@@ -622,7 +622,7 @@ xrep_bmap(
 out_bitmap:
 	free_slab(&rb->bmap_records);
 out_rb:
-	kmem_free(rb);
+	kfree(rb);
 	return error;
 }
 


