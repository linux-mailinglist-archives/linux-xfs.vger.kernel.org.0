Return-Path: <linux-xfs+bounces-80-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 935557F8870
	for <lists+linux-xfs@lfdr.de>; Sat, 25 Nov 2023 06:13:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AD42F1C20C0E
	for <lists+linux-xfs@lfdr.de>; Sat, 25 Nov 2023 05:13:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65E861371;
	Sat, 25 Nov 2023 05:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="P9cLs8qo"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04279D72
	for <linux-xfs@vger.kernel.org>; Fri, 24 Nov 2023 21:13:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=VOUj/FFKLnrnzq+axZk6oxhA6SDpEnoanRKmULDfrsQ=; b=P9cLs8qoQOvgNVZxgH0GGDEJsg
	uZtjnmPuicZ2B9Je6vbwrSPWS6QFQBpK6TSufAy7De+VQdvIVbPt5PKK9mkmD7vCIpG7fa0i3DwJ+
	cdtwsmy0DZp0pD5jUJ6vc//c7h+8XEGCp+/Z6Rmwuf14OEGJ3/gJXwybrjPafvkEYkMy2j8eddHEz
	Po1jIV2ACmlNYSyJzjYm6Dd4BmTOvcgzU6KjD34LzoJ0NiSGriXjWIc/vmGJXeV2fhsoEWkR3ZIDg
	jztdWKRzaYaIOYLm7hHTPvigWQUiulFnr3vySAajWy0IghxXfy+L+Ho4yFQrf8xSwH+NNX0/3bmc0
	+8edBceg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1r6kyo-008aMx-28;
	Sat, 25 Nov 2023 05:13:22 +0000
Date: Fri, 24 Nov 2023 21:13:22 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 7/7] xfs: force small EFIs for reaping btree extents
Message-ID: <ZWGCcotfoJNbeol6@infradead.org>
References: <170086926113.2768790.10021834422326302654.stgit@frogsfrogsfrogs>
 <170086926238.2768790.8811874509215907711.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170086926238.2768790.8811874509215907711.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This generally looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

But as mentioned earlier I think it would be nice to share some
code between the normal xfs_defer_add and xfs_defer_add_barrier.

This would be the fold for this patch on top of the one previously
posted and a light merge fix for the pausing between:

diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
index e70dc347074dc5..5d621e445e8ab9 100644
--- a/fs/xfs/libxfs/xfs_defer.c
+++ b/fs/xfs/libxfs/xfs_defer.c
@@ -753,6 +753,22 @@ xfs_defer_can_append(
 	return true;
 }
 
+/* Create a new pending item at the end of the intake list. */
+static struct xfs_defer_pending *
+xfs_defer_alloc(
+	struct xfs_trans		*tp,
+	enum xfs_defer_ops_type		type)
+{
+	struct xfs_defer_pending	*dfp;
+
+	dfp = kmem_cache_zalloc(xfs_defer_pending_cache,
+			GFP_NOFS | __GFP_NOFAIL);
+	dfp->dfp_type = type;
+	INIT_LIST_HEAD(&dfp->dfp_work);
+	list_add_tail(&dfp->dfp_list, &tp->t_dfops);
+	return dfp;
+};
+
 /* Add an item for later deferred processing. */
 struct xfs_defer_pending *
 xfs_defer_add(
@@ -760,29 +776,18 @@ xfs_defer_add(
 	enum xfs_defer_ops_type		type,
 	struct list_head		*li)
 {
-	struct xfs_defer_pending	*dfp = NULL;
 	const struct xfs_defer_op_type	*ops = defer_op_types[type];
+	struct xfs_defer_pending	*dfp;
 
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 	BUILD_BUG_ON(ARRAY_SIZE(defer_op_types) != XFS_DEFER_OPS_TYPE_MAX);
 
 	dfp = xfs_defer_find(tp, type);
-	if (!dfp || !xfs_defer_can_append(dfp, ops)) {
-		/* Create a new pending item at the end of the intake list. */
-		dfp = kmem_cache_zalloc(xfs_defer_pending_cache,
-				GFP_NOFS | __GFP_NOFAIL);
-		dfp->dfp_type = type;
-		dfp->dfp_intent = NULL;
-		dfp->dfp_done = NULL;
-		dfp->dfp_count = 0;
-		INIT_LIST_HEAD(&dfp->dfp_work);
-		list_add_tail(&dfp->dfp_list, &tp->t_dfops);
-	}
-
+	if (!dfp || !xfs_defer_can_append(dfp, ops))
+		dfp = xfs_defer_alloc(tp, type);
 	list_add_tail(li, &dfp->dfp_work);
 	trace_xfs_defer_add_item(tp->t_mountp, dfp, li);
 	dfp->dfp_count++;
-
 	return dfp;
 }
 
@@ -1106,19 +1111,10 @@ xfs_defer_add_barrier(
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 
 	/* If the last defer op added was a barrier, we're done. */
-	if (!list_empty(&tp->t_dfops)) {
-		dfp = list_last_entry(&tp->t_dfops,
-				struct xfs_defer_pending, dfp_list);
-		if (dfp->dfp_type == XFS_DEFER_OPS_TYPE_BARRIER)
-			return;
-	}
-
-	dfp = kmem_cache_zalloc(xfs_defer_pending_cache,
-			GFP_NOFS | __GFP_NOFAIL);
-	dfp->dfp_type = XFS_DEFER_OPS_TYPE_BARRIER;
-	INIT_LIST_HEAD(&dfp->dfp_work);
-	list_add_tail(&dfp->dfp_list, &tp->t_dfops);
-
+	dfp = xfs_defer_find(tp, XFS_DEFER_OPS_TYPE_BARRIER);
+	if (dfp)
+		return;
+	dfp = xfs_defer_alloc(tp, XFS_DEFER_OPS_TYPE_BARRIER);
 	trace_xfs_defer_add_item(tp->t_mountp, dfp, NULL);
 	dfp->dfp_count++;
 }

