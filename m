Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01A9C49449E
	for <lists+linux-xfs@lfdr.de>; Thu, 20 Jan 2022 01:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345543AbiATA1y (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 19 Jan 2022 19:27:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357657AbiATA1w (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:27:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C792C061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:27:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF2B561511
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:27:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56570C004E1;
        Thu, 20 Jan 2022 00:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638471;
        bh=86XKwfLlWsGTt1xv6NoLEKVHZAvpZ3bgbme9YsBYFOA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=E2n9qNqB9I9PiRemKn5nLXW8MZeA8pk25iJckH2TGhJ8Qbgq0/JKgSFTGz1NJb/DF
         8XWU5N5cYb1lIA9xDNWbo7kCr7u6mkFem0JRGsCmJkf/OrMUUMBbTaN7LJ0ac8TKHW
         mraIT0BKkVIyCeU9sijhZnHYk0K6n9H5SdGHoyxHZXqpNecee9DvfSCvOAAYpuONJ5
         6s9Qza6n/Wd24DbPXN6rc/r8qAjfJ/rSAFa2C7polE/mQNJnFHnvfqYOP7AD1Rpka6
         DwNxrFjnTBcTKb2rsIUU6fqFYCKPDdSRGcMdiSaI4EkWGD3Vx8qqEo+GhfwY+jf4Lm
         SETkDHqEIKsbQ==
Subject: [PATCH 2/2] xfs_repair: improve checking of existing rmap and
 refcount btrees
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:27:51 -0800
Message-ID: <164263847103.874349.12961662359159843135.stgit@magnolia>
In-Reply-To: <164263846006.874349.12874049913267940808.stgit@magnolia>
References: <164263846006.874349.12874049913267940808.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

There are a few deficiencies in the xfs_repair functions that check the
existing reverse mapping and reference count btrees.  First of all, we
don't report corruption or IO errors if we can't read the ondisk
metadata.  Second, we don't consistently warn if we cannot allocate
memory to perform the check.

Add the missing warnings, and simplify the calling convention since we
don't need the extra layer of do_error logging in phase4.c.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/phase4.c |   20 ++++-------------
 repair/rmap.c   |   65 ++++++++++++++++++++++++++++++++++++++-----------------
 repair/rmap.h   |    4 ++-
 3 files changed, 52 insertions(+), 37 deletions(-)


diff --git a/repair/phase4.c b/repair/phase4.c
index 2260f6a3..746e0ccd 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -173,11 +173,7 @@ _("unable to add AG %u metadata reverse-mapping data.\n"), agno);
 		do_error(
 _("unable to merge AG %u metadata reverse-mapping data.\n"), agno);
 
-	error = rmaps_verify_btree(wq->wq_ctx, agno);
-	if (error)
-		do_error(
-_("%s while checking reverse-mappings"),
-			 strerror(-error));
+	rmaps_verify_btree(wq->wq_ctx, agno);
 }
 
 static void
@@ -212,17 +208,11 @@ _("%s while fixing inode reflink flags.\n"),
 
 static void
 check_refcount_btrees(
-	struct workqueue*wq,
-	xfs_agnumber_t	agno,
-	void		*arg)
+	struct workqueue	*wq,
+	xfs_agnumber_t		agno,
+	void			*arg)
 {
-	int		error;
-
-	error = check_refcounts(wq->wq_ctx, agno);
-	if (error)
-		do_error(
-_("%s while checking reference counts"),
-			 strerror(-error));
+	check_refcounts(wq->wq_ctx, agno);
 }
 
 static void
diff --git a/repair/rmap.c b/repair/rmap.c
index e48f6c1e..b76a149d 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -974,7 +974,7 @@ rmap_is_good(
 /*
  * Compare the observed reverse mappings against what's in the ag btree.
  */
-int
+void
 rmaps_verify_btree(
 	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno)
@@ -989,21 +989,26 @@ rmaps_verify_btree(
 	int			error;
 
 	if (!xfs_has_rmapbt(mp))
-		return 0;
+		return;
 	if (rmapbt_suspect) {
 		if (no_modify && agno == 0)
 			do_warn(_("would rebuild corrupt rmap btrees.\n"));
-		return 0;
+		return;
 	}
 
 	/* Create cursors to refcount structures */
 	error = rmap_init_cursor(agno, &rm_cur);
-	if (error)
-		return error;
+	if (error) {
+		do_warn(_("Not enough memory to check reverse mappings.\n"));
+		return;
+	}
 
 	error = -libxfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
-	if (error)
+	if (error) {
+		do_warn(_("Could not read AGF %u to check rmap btree.\n"),
+				agno);
 		goto err;
+	}
 
 	/* Leave the per-ag data "uninitialized" since we rewrite it later */
 	pag = libxfs_perag_get(mp, agno);
@@ -1011,15 +1016,20 @@ rmaps_verify_btree(
 
 	bt_cur = libxfs_rmapbt_init_cursor(mp, NULL, agbp, pag);
 	if (!bt_cur) {
-		error = -ENOMEM;
+		do_warn(_("Not enough memory to check reverse mappings.\n"));
 		goto err;
 	}
 
 	rm_rec = pop_slab_cursor(rm_cur);
 	while (rm_rec) {
 		error = rmap_lookup(bt_cur, rm_rec, &tmp, &have);
-		if (error)
+		if (error) {
+			do_warn(
+_("Could not read reverse-mapping record for (%u/%u).\n"),
+					agno, rm_rec->rm_startblock);
 			goto err;
+		}
+
 		/*
 		 * Using the range query is expensive, so only do it if
 		 * the regular lookup doesn't find anything or if it doesn't
@@ -1029,8 +1039,12 @@ rmaps_verify_btree(
 				(!have || !rmap_is_good(rm_rec, &tmp))) {
 			error = rmap_lookup_overlapped(bt_cur, rm_rec,
 					&tmp, &have);
-			if (error)
+			if (error) {
+				do_warn(
+_("Could not read reverse-mapping record for (%u/%u).\n"),
+						agno, rm_rec->rm_startblock);
 				goto err;
+			}
 		}
 		if (!have) {
 			do_warn(
@@ -1088,7 +1102,6 @@ _("Incorrect reverse-mapping: saw (%u/%u) %slen %u owner %"PRId64" %s%soff \
 	if (agbp)
 		libxfs_buf_relse(agbp);
 	free_slab_cursor(&rm_cur);
-	return 0;
 }
 
 /*
@@ -1335,7 +1348,7 @@ refcount_avoid_check(void)
 /*
  * Compare the observed reference counts against what's in the ag btree.
  */
-int
+void
 check_refcounts(
 	struct xfs_mount		*mp,
 	xfs_agnumber_t			agno)
@@ -1351,21 +1364,26 @@ check_refcounts(
 	int				error;
 
 	if (!xfs_has_reflink(mp))
-		return 0;
+		return;
 	if (refcbt_suspect) {
 		if (no_modify && agno == 0)
 			do_warn(_("would rebuild corrupt refcount btrees.\n"));
-		return 0;
+		return;
 	}
 
 	/* Create cursors to refcount structures */
 	error = init_refcount_cursor(agno, &rl_cur);
-	if (error)
-		return error;
+	if (error) {
+		do_warn(_("Not enough memory to check refcount data.\n"));
+		return;
+	}
 
 	error = -libxfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
-	if (error)
+	if (error) {
+		do_warn(_("Could not read AGF %u to check refcount btree.\n"),
+				agno);
 		goto err;
+	}
 
 	/* Leave the per-ag data "uninitialized" since we rewrite it later */
 	pag = libxfs_perag_get(mp, agno);
@@ -1373,7 +1391,7 @@ check_refcounts(
 
 	bt_cur = libxfs_refcountbt_init_cursor(mp, NULL, agbp, pag);
 	if (!bt_cur) {
-		error = -ENOMEM;
+		do_warn(_("Not enough memory to check refcount data.\n"));
 		goto err;
 	}
 
@@ -1382,8 +1400,12 @@ check_refcounts(
 		/* Look for a refcount record in the btree */
 		error = -libxfs_refcount_lookup_le(bt_cur,
 				rl_rec->rc_startblock, &have);
-		if (error)
+		if (error) {
+			do_warn(
+_("Could not read reference count record for (%u/%u).\n"),
+					agno, rl_rec->rc_startblock);
 			goto err;
+		}
 		if (!have) {
 			do_warn(
 _("Missing reference count record for (%u/%u) len %u count %u\n"),
@@ -1393,8 +1415,12 @@ _("Missing reference count record for (%u/%u) len %u count %u\n"),
 		}
 
 		error = -libxfs_refcount_get_rec(bt_cur, &tmp, &i);
-		if (error)
+		if (error) {
+			do_warn(
+_("Could not read reference count record for (%u/%u).\n"),
+					agno, rl_rec->rc_startblock);
 			goto err;
+		}
 		if (!i) {
 			do_warn(
 _("Missing reference count record for (%u/%u) len %u count %u\n"),
@@ -1425,7 +1451,6 @@ _("Incorrect reference count: saw (%u/%u) len %u nlinks %u; should be (%u/%u) le
 	if (agbp)
 		libxfs_buf_relse(agbp);
 	free_slab_cursor(&rl_cur);
-	return 0;
 }
 
 /*
diff --git a/repair/rmap.h b/repair/rmap.h
index e5a6a3b4..8d176cb3 100644
--- a/repair/rmap.h
+++ b/repair/rmap.h
@@ -28,7 +28,7 @@ extern int rmap_store_ag_btree_rec(struct xfs_mount *, xfs_agnumber_t);
 extern size_t rmap_record_count(struct xfs_mount *, xfs_agnumber_t);
 extern int rmap_init_cursor(xfs_agnumber_t, struct xfs_slab_cursor **);
 extern void rmap_avoid_check(void);
-extern int rmaps_verify_btree(struct xfs_mount *, xfs_agnumber_t);
+void rmaps_verify_btree(struct xfs_mount *mp, xfs_agnumber_t agno);
 
 extern int64_t rmap_diffkeys(struct xfs_rmap_irec *kp1,
 		struct xfs_rmap_irec *kp2);
@@ -39,7 +39,7 @@ extern int compute_refcounts(struct xfs_mount *, xfs_agnumber_t);
 extern size_t refcount_record_count(struct xfs_mount *, xfs_agnumber_t);
 extern int init_refcount_cursor(xfs_agnumber_t, struct xfs_slab_cursor **);
 extern void refcount_avoid_check(void);
-extern int check_refcounts(struct xfs_mount *, xfs_agnumber_t);
+void check_refcounts(struct xfs_mount *mp, xfs_agnumber_t agno);
 
 extern void record_inode_reflink_flag(struct xfs_mount *, struct xfs_dinode *,
 	xfs_agnumber_t, xfs_agino_t, xfs_ino_t);

