Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01D27659F2C
	for <lists+linux-xfs@lfdr.de>; Sat, 31 Dec 2022 01:06:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235435AbiLaAGT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 19:06:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235850AbiLaAGS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:06:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C98441E3C3
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:06:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86CFDB81DEC
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:06:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 458B9C433EF;
        Sat, 31 Dec 2022 00:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672445174;
        bh=fAX0EHj69GwzC89bFxzPUE6s00AP9GzBs2oKwH2gbik=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=qsVGXDacY4arvQYqh9Y6Nighky1xpm/4c9vFo5Ypp4jBHd1+wZxtrLH0fHlZRJWUt
         91UHB2IlOyRRWCMPutAfJFWj9qDAiExv7HFRUHQluN9LuCAq7OGLO+OZtcYJpepsKS
         l9lIE5rx3nWkFwhpuDo+Kh17wG8ka/Fs7+YgubtKviPH9E3LZ3kdYalWxw4v6HFt5g
         hAXU0Oa07bFXO1GhmrLkP7q62IxzfcA67cn0yLvnwAUNgiJOdPkkLsbawpZlOy2Zpm
         WTjdBMyCkDlZGavRbu+oxRBU7F0OUdnRWcsmv/O8Rfpis1d+ZB7Q0g+za+6mrIe1nM
         BKclLdGCpKA1A==
Subject: [PATCH 5/5] xfs_repair: bulk load records into new btree blocks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:19 -0800
Message-ID: <167243863970.707598.5919935346304694103.stgit@magnolia>
In-Reply-To: <167243863904.707598.12385476439101029022.stgit@magnolia>
References: <167243863904.707598.12385476439101029022.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Amortize the cost of indirect calls further by loading a batch of
records into a new btree block instead of one record per ->get_record
call.  On a rmap btree with 3.9 million records, this reduces the
runtime of xfs_btree_bload by 3% for xfsprogs.  For the upcoming online
repair functionality, this will reduce runtime by 6% when spectre
mitigations are enabled in the kernel.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/agbtree.c |  161 ++++++++++++++++++++++++++++++------------------------
 1 file changed, 90 insertions(+), 71 deletions(-)


diff --git a/repair/agbtree.c b/repair/agbtree.c
index 70ad042f832..cba67c5fbf4 100644
--- a/repair/agbtree.c
+++ b/repair/agbtree.c
@@ -220,15 +220,19 @@ get_bnobt_records(
 	struct bt_rebuild		*btr = priv;
 	struct xfs_alloc_rec_incore	*arec = &cur->bc_rec.a;
 	union xfs_btree_rec		*block_rec;
+	unsigned int			loaded;
 
-	btr->bno_rec = get_bno_rec(cur, btr->bno_rec);
-	arec->ar_startblock = btr->bno_rec->ex_startblock;
-	arec->ar_blockcount = btr->bno_rec->ex_blockcount;
-	btr->freeblks += btr->bno_rec->ex_blockcount;
+	for (loaded = 0; loaded < nr_wanted; loaded++, idx++) {
+		btr->bno_rec = get_bno_rec(cur, btr->bno_rec);
+		arec->ar_startblock = btr->bno_rec->ex_startblock;
+		arec->ar_blockcount = btr->bno_rec->ex_blockcount;
+		btr->freeblks += btr->bno_rec->ex_blockcount;
 
-	block_rec = libxfs_btree_rec_addr(cur, idx, block);
-	cur->bc_ops->init_rec_from_cur(cur, block_rec);
-	return 1;
+		block_rec = libxfs_btree_rec_addr(cur, idx, block);
+		cur->bc_ops->init_rec_from_cur(cur, block_rec);
+	}
+
+	return loaded;
 }
 
 void
@@ -388,65 +392,72 @@ get_inobt_records(
 {
 	struct bt_rebuild		*btr = priv;
 	struct xfs_inobt_rec_incore	*irec = &cur->bc_rec.i;
-	struct ino_tree_node		*ino_rec;
-	union xfs_btree_rec		*block_rec;
-	int				inocnt = 0;
-	int				finocnt = 0;
-	int				k;
-
-	btr->ino_rec = ino_rec = get_ino_rec(cur, btr->ino_rec);
-
-	/* Transform the incore record into an on-disk record. */
-	irec->ir_startino = ino_rec->ino_startnum;
-	irec->ir_free = ino_rec->ir_free;
-
-	for (k = 0; k < sizeof(xfs_inofree_t) * NBBY; k++)  {
-		ASSERT(is_inode_confirmed(ino_rec, k));
-
-		if (is_inode_sparse(ino_rec, k))
-			continue;
-		if (is_inode_free(ino_rec, k))
-			finocnt++;
-		inocnt++;
-	}
+	unsigned int			loaded = 0;
+
+	while (loaded < nr_wanted) {
+		struct ino_tree_node	*ino_rec;
+		union xfs_btree_rec	*block_rec;
+		int			inocnt = 0;
+		int			finocnt = 0;
+		int			k;
+
+		btr->ino_rec = ino_rec = get_ino_rec(cur, btr->ino_rec);
 
-	irec->ir_count = inocnt;
-	irec->ir_freecount = finocnt;
-
-	if (xfs_has_sparseinodes(cur->bc_mp)) {
-		uint64_t		sparse;
-		int			spmask;
-		uint16_t		holemask;
-
-		/*
-		 * Convert the 64-bit in-core sparse inode state to the
-		 * 16-bit on-disk holemask.
-		 */
-		holemask = 0;
-		spmask = (1 << XFS_INODES_PER_HOLEMASK_BIT) - 1;
-		sparse = ino_rec->ir_sparse;
-		for (k = 0; k < XFS_INOBT_HOLEMASK_BITS; k++) {
-			if (sparse & spmask) {
-				ASSERT((sparse & spmask) == spmask);
-				holemask |= (1 << k);
-			} else
-				ASSERT((sparse & spmask) == 0);
-			sparse >>= XFS_INODES_PER_HOLEMASK_BIT;
+		/* Transform the incore record into an on-disk record. */
+		irec->ir_startino = ino_rec->ino_startnum;
+		irec->ir_free = ino_rec->ir_free;
+
+		for (k = 0; k < sizeof(xfs_inofree_t) * NBBY; k++)  {
+			ASSERT(is_inode_confirmed(ino_rec, k));
+
+			if (is_inode_sparse(ino_rec, k))
+				continue;
+			if (is_inode_free(ino_rec, k))
+				finocnt++;
+			inocnt++;
 		}
 
-		irec->ir_holemask = holemask;
-	} else {
-		irec->ir_holemask = 0;
-	}
+		irec->ir_count = inocnt;
+		irec->ir_freecount = finocnt;
 
-	if (btr->first_agino == NULLAGINO)
-		btr->first_agino = ino_rec->ino_startnum;
-	btr->freecount += finocnt;
-	btr->count += inocnt;
+		if (xfs_has_sparseinodes(cur->bc_mp)) {
+			uint64_t		sparse;
+			int			spmask;
+			uint16_t		holemask;
+
+			/*
+			 * Convert the 64-bit in-core sparse inode state to the
+			 * 16-bit on-disk holemask.
+			 */
+			holemask = 0;
+			spmask = (1 << XFS_INODES_PER_HOLEMASK_BIT) - 1;
+			sparse = ino_rec->ir_sparse;
+			for (k = 0; k < XFS_INOBT_HOLEMASK_BITS; k++) {
+				if (sparse & spmask) {
+					ASSERT((sparse & spmask) == spmask);
+					holemask |= (1 << k);
+				} else
+					ASSERT((sparse & spmask) == 0);
+				sparse >>= XFS_INODES_PER_HOLEMASK_BIT;
+			}
+
+			irec->ir_holemask = holemask;
+		} else {
+			irec->ir_holemask = 0;
+		}
+
+		if (btr->first_agino == NULLAGINO)
+			btr->first_agino = ino_rec->ino_startnum;
+		btr->freecount += finocnt;
+		btr->count += inocnt;
+
+		block_rec = libxfs_btree_rec_addr(cur, idx, block);
+		cur->bc_ops->init_rec_from_cur(cur, block_rec);
+		loaded++;
+		idx++;
+	}
 
-	block_rec = libxfs_btree_rec_addr(cur, idx, block);
-	cur->bc_ops->init_rec_from_cur(cur, block_rec);
-	return 1;
+	return loaded;
 }
 
 /* Initialize both inode btree cursors as needed. */
@@ -585,13 +596,17 @@ get_rmapbt_records(
 	struct xfs_rmap_irec		*rec;
 	struct bt_rebuild		*btr = priv;
 	union xfs_btree_rec		*block_rec;
+	unsigned int			loaded;
 
-	rec = pop_slab_cursor(btr->slab_cursor);
-	memcpy(&cur->bc_rec.r, rec, sizeof(struct xfs_rmap_irec));
+	for (loaded = 0; loaded < nr_wanted; loaded++, idx++) {
+		rec = pop_slab_cursor(btr->slab_cursor);
+		memcpy(&cur->bc_rec.r, rec, sizeof(struct xfs_rmap_irec));
 
-	block_rec = libxfs_btree_rec_addr(cur, idx, block);
-	cur->bc_ops->init_rec_from_cur(cur, block_rec);
-	return 1;
+		block_rec = libxfs_btree_rec_addr(cur, idx, block);
+		cur->bc_ops->init_rec_from_cur(cur, block_rec);
+	}
+
+	return loaded;
 }
 
 /* Set up the rmap rebuild parameters. */
@@ -663,13 +678,17 @@ get_refcountbt_records(
 	struct xfs_refcount_irec	*rec;
 	struct bt_rebuild		*btr = priv;
 	union xfs_btree_rec		*block_rec;
+	unsigned int			loaded;
 
-	rec = pop_slab_cursor(btr->slab_cursor);
-	memcpy(&cur->bc_rec.rc, rec, sizeof(struct xfs_refcount_irec));
+	for (loaded = 0; loaded < nr_wanted; loaded++, idx++) {
+		rec = pop_slab_cursor(btr->slab_cursor);
+		memcpy(&cur->bc_rec.rc, rec, sizeof(struct xfs_refcount_irec));
 
-	block_rec = libxfs_btree_rec_addr(cur, idx, block);
-	cur->bc_ops->init_rec_from_cur(cur, block_rec);
-	return 1;
+		block_rec = libxfs_btree_rec_addr(cur, idx, block);
+		cur->bc_ops->init_rec_from_cur(cur, block_rec);
+	}
+
+	return loaded;
 }
 
 /* Set up the refcount rebuild parameters. */

