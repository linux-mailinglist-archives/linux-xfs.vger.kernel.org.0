Return-Path: <linux-xfs+bounces-13890-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B6BC9998A0
	for <lists+linux-xfs@lfdr.de>; Fri, 11 Oct 2024 03:05:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0A2DF1F232FA
	for <lists+linux-xfs@lfdr.de>; Fri, 11 Oct 2024 01:05:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD2E75228;
	Fri, 11 Oct 2024 01:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Jrw1AtFy"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D9704C7D
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 01:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728608736; cv=none; b=RhulDyCj7UIsoicNdb2F0PIlddOIzksVhpj1f5bx9cYRF/UDDXnI8xA2PPUPt+E1q7b7B7ZfTKOz/henWBZtiQ8UjcoHpQrv0j1ERH6aFiAWJMh/MoGUrl9hluqGbUbOHDYi3QOPNSwtasN/+Wcl+lNxpqF/I8fOAwHyKxhjdyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728608736; c=relaxed/simple;
	bh=+5UvUfs0VcsHzG/e1412WTRgrxnzUBvqMZq74Hj7qGU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TY4a7YWSgSgBxfEhwl0GjMLOZ8FkNqjxoAM9zwMAwQdYwBl1sJF9INEQ8KkRL2m3TwEuLWBkRwLMe8d3canhJC54NLUl2mGLCWeaoQqJrdrQdEdTdlLADbflzXA6PIDVtyrmqgGfnmouQLZsBP0mdiwBwcQS0rTf/1oO0UKTjcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Jrw1AtFy; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00DACC4CEC5;
	Fri, 11 Oct 2024 01:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728608736;
	bh=+5UvUfs0VcsHzG/e1412WTRgrxnzUBvqMZq74Hj7qGU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Jrw1AtFytm5NEJzqhuQVuxNhHP6385QTvU0HIVQpuHWwacQ8WiXiiFFgJM+8/gk6i
	 SygS2LtYZfDyxGoYxdLRHrogccoQUPKBKcYAVGfSoYejchJKuE0VcKKJWQqhuAHo/4
	 lHpc40n/P43RGmgCWC1YQ3tOxkrQVuKziUMIhZeOq8R0EUnjy0dO5AjK3A2oPeXpRy
	 Su+SxZZjk/n6CtPhxajhv5yha09SJE1gnDJ5Fhvu0uznBLe3KnR60UxPRYDl1Tk1XX
	 nLHk5BL8hwbCCLcgJqixDl+uMujo4N7aUk3CgnOU7eJxcR53s5Mbc3m6zOYaJpGRzk
	 aQWmKgUWtFukQ==
Date: Thu, 10 Oct 2024 18:05:35 -0700
Subject: [PATCH 15/36] xfs: store rtgroup information with a bmap intent
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860644500.4178701.5897856828553646962.stgit@frogsfrogsfrogs>
In-Reply-To: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
References: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
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

Make the bmap intent items take an active reference to the rtgroup
containing the space that is being mapped or unmapped.  We will need
this functionality once we start enabling rmap and reflink on the rt
volume.  Technically speaking we need it even for !rtgroups filesystems
to prevent the (dummy) rtgroup 0 from going away, even though this will
never happen.

As a bonus, we can rework the xfs_bmap_deferred_class tracepoint to use
the xfs_group object to figure out the type and group number, widen the
group block number field to fit 64-bit quantities, and get rid of the
now redundant opdev and rtblock fields.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_bmap_item.c |   25 ++++++++-----------------
 fs/xfs/xfs_trace.h     |   43 +++++++++++++++++++++++++------------------
 2 files changed, 33 insertions(+), 35 deletions(-)


diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index 37dab184c2dfc2..3d52e9d7ad571a 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -318,14 +318,16 @@ xfs_bmap_update_create_done(
 	return &budp->bud_item;
 }
 
-/* Take a passive ref to the AG containing the space we're mapping. */
+/* Take a passive ref to the group containing the space we're mapping. */
 static inline void
 xfs_bmap_update_get_group(
 	struct xfs_mount	*mp,
 	struct xfs_bmap_intent	*bi)
 {
+	enum xfs_group_type	type = XG_TYPE_AG;
+
 	if (xfs_ifork_is_realtime(bi->bi_owner, bi->bi_whichfork))
-		return;
+		type = XG_TYPE_RTG;
 
 	/*
 	 * Bump the intent count on behalf of the deferred rmap and refcount
@@ -335,7 +337,7 @@ xfs_bmap_update_get_group(
 	 * remains nonzero across the transaction roll.
 	 */
 	bi->bi_group = xfs_group_intent_get(mp, bi->bi_bmap.br_startblock,
-			XG_TYPE_AG);
+				type);
 }
 
 /* Add this deferred BUI to the transaction. */
@@ -344,8 +346,6 @@ xfs_bmap_defer_add(
 	struct xfs_trans	*tp,
 	struct xfs_bmap_intent	*bi)
 {
-	trace_xfs_bmap_defer(bi);
-
 	xfs_bmap_update_get_group(tp->t_mountp, bi);
 
 	/*
@@ -358,20 +358,11 @@ xfs_bmap_defer_add(
 	 */
 	if (bi->bi_type == XFS_BMAP_MAP)
 		bi->bi_owner->i_delayed_blks += bi->bi_bmap.br_blockcount;
+
+	trace_xfs_bmap_defer(bi);
 	xfs_defer_add(tp, &bi->bi_list, &xfs_bmap_update_defer_type);
 }
 
-/* Release a passive AG ref after finishing mapping work. */
-static inline void
-xfs_bmap_update_put_group(
-	struct xfs_bmap_intent	*bi)
-{
-	if (xfs_ifork_is_realtime(bi->bi_owner, bi->bi_whichfork))
-		return;
-
-	xfs_group_intent_put(bi->bi_group);
-}
-
 /* Cancel a deferred bmap update. */
 STATIC void
 xfs_bmap_update_cancel_item(
@@ -382,7 +373,7 @@ xfs_bmap_update_cancel_item(
 	if (bi->bi_type == XFS_BMAP_MAP)
 		bi->bi_owner->i_delayed_blks -= bi->bi_bmap.br_blockcount;
 
-	xfs_bmap_update_put_group(bi);
+	xfs_group_intent_put(bi->bi_group);
 	kmem_cache_free(xfs_bmap_intent_cache, bi);
 }
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index deb23a91883ad7..5256b9cccf2e9b 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3086,11 +3086,10 @@ DECLARE_EVENT_CLASS(xfs_bmap_deferred_class,
 	TP_ARGS(bi),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
-		__field(dev_t, opdev)
+		__field(enum xfs_group_type, type)
 		__field(xfs_agnumber_t, agno)
 		__field(xfs_ino_t, ino)
-		__field(xfs_agblock_t, agbno)
-		__field(xfs_fsblock_t, rtbno)
+		__field(unsigned long long, gbno)
 		__field(int, whichfork)
 		__field(xfs_fileoff_t, l_loff)
 		__field(xfs_filblks_t, l_len)
@@ -3099,20 +3098,29 @@ DECLARE_EVENT_CLASS(xfs_bmap_deferred_class,
 	),
 	TP_fast_assign(
 		struct xfs_inode	*ip = bi->bi_owner;
+		struct xfs_mount	*mp = ip->i_mount;
 
-		__entry->dev = ip->i_mount->m_super->s_dev;
-		if (xfs_ifork_is_realtime(ip, bi->bi_whichfork)) {
-			__entry->agno = 0;
-			__entry->agbno = 0;
-			__entry->rtbno = bi->bi_bmap.br_startblock;
-			__entry->opdev = ip->i_mount->m_rtdev_targp->bt_dev;
-		} else {
-			__entry->agno = XFS_FSB_TO_AGNO(ip->i_mount,
+		__entry->dev = mp->m_super->s_dev;
+		__entry->type = bi->bi_group->xg_type;
+		__entry->agno = bi->bi_group->xg_index;
+		switch (__entry->type) {
+		case XG_TYPE_RTG:
+			/*
+			 * Use the 64-bit version of xfs_rtb_to_rgbno because
+			 * legacy rt filesystems can have group block numbers
+			 * that exceed the size of an xfs_rgblock_t.
+			 */
+			__entry->gbno = __xfs_rtb_to_rgbno(mp,
 						bi->bi_bmap.br_startblock);
-			__entry->agbno = XFS_FSB_TO_AGBNO(ip->i_mount,
+			break;
+		case XG_TYPE_AG:
+			__entry->gbno = XFS_FSB_TO_AGBNO(mp,
 						bi->bi_bmap.br_startblock);
-			__entry->rtbno = 0;
-			__entry->opdev = __entry->dev;
+			break;
+		default:
+			/* should never happen */
+			__entry->gbno = -1ULL;
+			break;
 		}
 		__entry->ino = ip->i_ino;
 		__entry->whichfork = bi->bi_whichfork;
@@ -3121,14 +3129,13 @@ DECLARE_EVENT_CLASS(xfs_bmap_deferred_class,
 		__entry->l_state = bi->bi_bmap.br_state;
 		__entry->op = bi->bi_type;
 	),
-	TP_printk("dev %d:%d op %s opdev %d:%d ino 0x%llx agno 0x%x agbno 0x%x rtbno 0x%llx %s fileoff 0x%llx fsbcount 0x%llx state %d",
+	TP_printk("dev %d:%d op %s ino 0x%llx %sno 0x%x gbno 0x%llx %s fileoff 0x%llx fsbcount 0x%llx state %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __print_symbolic(__entry->op, XFS_BMAP_INTENT_STRINGS),
-		  MAJOR(__entry->opdev), MINOR(__entry->opdev),
 		  __entry->ino,
+		  __print_symbolic(__entry->type, XG_TYPE_STRINGS),
 		  __entry->agno,
-		  __entry->agbno,
-		  __entry->rtbno,
+		  __entry->gbno,
 		  __print_symbolic(__entry->whichfork, XFS_WHICHFORK_STRINGS),
 		  __entry->l_loff,
 		  __entry->l_len,


