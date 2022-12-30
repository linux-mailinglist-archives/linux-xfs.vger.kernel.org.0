Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A707659D1E
	for <lists+linux-xfs@lfdr.de>; Fri, 30 Dec 2022 23:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235643AbiL3Woj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 17:44:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235655AbiL3Woi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:44:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C220186E8
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:44:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9075761C0D
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:44:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E859BC433EF;
        Fri, 30 Dec 2022 22:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440276;
        bh=DnG3bpEMUiDnGTSKx/cSizE8j/o4WYD5Nz6aodCX0yc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=QIf4lR/ML4mjTcc8Sj1d+jSHx1c4QC32SFH6f9pdEBtqMe3B50bUdqvyIJ66MUKlz
         mkNrKOvhUMUebqQBnmBsEZ+2zOvYVn7BgpT1qLP+O/WRgrptEoNAI0W/hIU9EyBnR0
         Mf9lzy9WNrjgtwSdZBRcVzIUCjW3avmYAyETOo7be/R8k+RJJz7PrybKuKImjJUwMs
         +uYfS7qmyt68mmJrxecqTydhwi6UIGuMlts6KnwedFiru+GN2nQL5o6wzX/aO80KSX
         spmUQZzgMeddvOjypJIsjBIFIkuXl6BV+a7lhnvp/5lE7dP2Nofl5ew96VolbfqL0g
         GhhNVv9jU7o/Q==
Subject: [PATCH 1/2] xfs: teach scrub to check for sole ownership of metadata
 objects
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:32 -0800
Message-ID: <167243829255.684733.11550471248992059548.stgit@magnolia>
In-Reply-To: <167243829239.684733.6811272411929910504.stgit@magnolia>
References: <167243829239.684733.6811272411929910504.stgit@magnolia>
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

Strengthen online scrub's checking even further by enabling us to check
that a range of blocks are owned solely by a given owner.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rmap.c |  198 ++++++++++++++++++++++++++++++++--------------
 fs/xfs/libxfs/xfs_rmap.h |   18 +++-
 fs/xfs/scrub/agheader.c  |   10 +-
 fs/xfs/scrub/btree.c     |    2 
 fs/xfs/scrub/ialloc.c    |    4 -
 fs/xfs/scrub/inode.c     |    2 
 fs/xfs/scrub/rmap.c      |   45 ++++++----
 fs/xfs/scrub/scrub.h     |    2 
 8 files changed, 185 insertions(+), 96 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 308b81f321eb..a9f13d877822 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2735,65 +2735,141 @@ xfs_rmap_has_records(
 	return xfs_btree_has_records(cur, &low, &high, &mask, outcome);
 }
 
-/*
- * Is there a record for this owner completely covering a given physical
- * extent?  If so, *has_rmap will be set to true.  If there is no record
- * or the record only covers part of the range, we set *has_rmap to false.
- * This function doesn't perform range lookups or offset checks, so it is
- * not suitable for checking data fork blocks.
- */
-int
-xfs_rmap_record_exists(
-	struct xfs_btree_cur		*cur,
-	xfs_agblock_t			bno,
-	xfs_extlen_t			len,
-	const struct xfs_owner_info	*oinfo,
-	bool				*has_rmap)
-{
-	uint64_t			owner;
-	uint64_t			offset;
-	unsigned int			flags;
-	int				has_record;
-	struct xfs_rmap_irec		irec;
-	int				error;
+struct xfs_rmap_ownercount {
+	/* Owner that we're looking for. */
+	struct xfs_rmap_irec	good;
 
-	xfs_owner_info_unpack(oinfo, &owner, &offset, &flags);
-	ASSERT(XFS_RMAP_NON_INODE_OWNER(owner) ||
-	       (flags & XFS_RMAP_BMBT_BLOCK));
+	/* rmap search keys */
+	struct xfs_rmap_irec	low;
+	struct xfs_rmap_irec	high;
 
-	error = xfs_rmap_lookup_le(cur, bno, owner, offset, flags, &irec,
-			&has_record);
-	if (error)
-		return error;
-	if (!has_record) {
-		*has_rmap = false;
-		return 0;
-	}
+	struct xfs_rmap_matches	*results;
 
-	*has_rmap = (irec.rm_owner == owner && irec.rm_startblock <= bno &&
-		     irec.rm_startblock + irec.rm_blockcount >= bno + len);
-	return 0;
-}
-
-struct xfs_rmap_key_state {
-	uint64_t			owner;
-	uint64_t			offset;
-	unsigned int			flags;
+	/* Stop early if we find a nonmatch? */
+	bool			stop_on_nonmatch;
 };
 
-/* For each rmap given, figure out if it doesn't match the key we want. */
+/* Does this rmap represent space that can have multiple owners? */
+static inline bool
+xfs_rmap_shareable(
+	struct xfs_mount		*mp,
+	const struct xfs_rmap_irec	*rmap)
+{
+	if (!xfs_has_reflink(mp))
+		return false;
+	if (XFS_RMAP_NON_INODE_OWNER(rmap->rm_owner))
+		return false;
+	if (rmap->rm_flags & (XFS_RMAP_ATTR_FORK |
+			      XFS_RMAP_BMBT_BLOCK))
+		return false;
+	return true;
+}
+
+static inline void
+xfs_rmap_ownercount_init(
+	struct xfs_rmap_ownercount	*roc,
+	xfs_agblock_t			bno,
+	xfs_extlen_t			len,
+	const struct xfs_owner_info	*oinfo,
+	struct xfs_rmap_matches		*results)
+{
+	memset(roc, 0, sizeof(*roc));
+	roc->results = results;
+
+	roc->low.rm_startblock = bno;
+	memset(&roc->high, 0xFF, sizeof(roc->high));
+	roc->high.rm_startblock = bno + len - 1;
+
+	memset(results, 0, sizeof(*results));
+	roc->good.rm_startblock = bno;
+	roc->good.rm_blockcount = len;
+	roc->good.rm_owner = oinfo->oi_owner;
+	roc->good.rm_offset = oinfo->oi_offset;
+	if (oinfo->oi_flags & XFS_OWNER_INFO_ATTR_FORK)
+		roc->good.rm_flags |= XFS_RMAP_ATTR_FORK;
+	if (oinfo->oi_flags & XFS_OWNER_INFO_BMBT_BLOCK)
+		roc->good.rm_flags |= XFS_RMAP_BMBT_BLOCK;
+}
+
+/* Figure out if this is a match for the owner. */
 STATIC int
-xfs_rmap_has_other_keys_helper(
+xfs_rmap_count_owners_helper(
 	struct xfs_btree_cur		*cur,
 	const struct xfs_rmap_irec	*rec,
 	void				*priv)
 {
-	struct xfs_rmap_key_state	*rks = priv;
+	struct xfs_rmap_ownercount	*roc = priv;
+	struct xfs_rmap_irec		check = *rec;
+	unsigned int			keyflags;
+	bool				filedata;
+	int64_t				delta;
 
-	if (rks->owner == rec->rm_owner && rks->offset == rec->rm_offset &&
-	    ((rks->flags & rec->rm_flags) & XFS_RMAP_KEY_FLAGS) == rks->flags)
-		return 0;
-	return -ECANCELED;
+	filedata = !XFS_RMAP_NON_INODE_OWNER(check.rm_owner) &&
+		   !(check.rm_flags & XFS_RMAP_BMBT_BLOCK);
+
+	/* Trim the part of check that comes before the comparison range. */
+	delta = (int64_t)roc->good.rm_startblock - check.rm_startblock;
+	if (delta > 0) {
+		check.rm_startblock += delta;
+		check.rm_blockcount -= delta;
+		if (filedata)
+			check.rm_offset += delta;
+	}
+
+	/* Trim the part of check that comes after the comparison range. */
+	delta = (check.rm_startblock + check.rm_blockcount) -
+		(roc->good.rm_startblock + roc->good.rm_blockcount);
+	if (delta > 0)
+		check.rm_blockcount -= delta;
+
+	/* Don't care about unwritten status for establishing ownership. */
+	keyflags = check.rm_flags & (XFS_RMAP_ATTR_FORK | XFS_RMAP_BMBT_BLOCK);
+
+	if (check.rm_startblock	== roc->good.rm_startblock &&
+	    check.rm_blockcount	== roc->good.rm_blockcount &&
+	    check.rm_owner	== roc->good.rm_owner &&
+	    check.rm_offset	== roc->good.rm_offset &&
+	    keyflags		== roc->good.rm_flags) {
+		roc->results->matches++;
+	} else {
+		roc->results->nono_matches++;
+		if (xfs_rmap_shareable(cur->bc_mp, &roc->good) ^
+		    xfs_rmap_shareable(cur->bc_mp, &check))
+			roc->results->badno_matches++;
+	}
+
+	if (roc->results->nono_matches && roc->stop_on_nonmatch)
+		return -ECANCELED;
+
+	return 0;
+}
+
+/* Count the number of owners and non-owners of this range of blocks. */
+int
+xfs_rmap_count_owners(
+	struct xfs_btree_cur		*cur,
+	xfs_agblock_t			bno,
+	xfs_extlen_t			len,
+	const struct xfs_owner_info	*oinfo,
+	struct xfs_rmap_matches		*results)
+{
+	struct xfs_rmap_ownercount	roc;
+	int				error;
+
+	xfs_rmap_ownercount_init(&roc, bno, len, oinfo, results);
+	error = xfs_rmap_query_range(cur, &roc.low, &roc.high,
+			xfs_rmap_count_owners_helper, &roc);
+	if (error)
+		return error;
+
+	/*
+	 * There can't be any non-owner rmaps that conflict with the given
+	 * owner if we didn't find any rmaps matching the owner.
+	 */
+	if (!results->matches)
+		results->badno_matches = 0;
+
+	return 0;
 }
 
 /*
@@ -2806,28 +2882,26 @@ xfs_rmap_has_other_keys(
 	xfs_agblock_t			bno,
 	xfs_extlen_t			len,
 	const struct xfs_owner_info	*oinfo,
-	bool				*has_rmap)
+	bool				*has_other)
 {
-	struct xfs_rmap_irec		low = {0};
-	struct xfs_rmap_irec		high;
-	struct xfs_rmap_key_state	rks;
+	struct xfs_rmap_matches		res;
+	struct xfs_rmap_ownercount	roc;
 	int				error;
 
-	xfs_owner_info_unpack(oinfo, &rks.owner, &rks.offset, &rks.flags);
-	*has_rmap = false;
+	xfs_rmap_ownercount_init(&roc, bno, len, oinfo, &res);
+	roc.stop_on_nonmatch = true;
 
-	low.rm_startblock = bno;
-	memset(&high, 0xFF, sizeof(high));
-	high.rm_startblock = bno + len - 1;
-
-	error = xfs_rmap_query_range(cur, &low, &high,
-			xfs_rmap_has_other_keys_helper, &rks);
+	error = xfs_rmap_query_range(cur, &roc.low, &roc.high,
+			xfs_rmap_count_owners_helper, &roc);
 	if (error == -ECANCELED) {
-		*has_rmap = true;
+		*has_other = true;
 		return 0;
 	}
+	if (error)
+		return error;
 
-	return error;
+	*has_other = false;
+	return 0;
 }
 
 const struct xfs_owner_info XFS_RMAP_OINFO_SKIP_UPDATE = {
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index 4cbe50cf522e..ced605d69324 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -200,12 +200,24 @@ xfs_failaddr_t xfs_rmap_check_irec(struct xfs_btree_cur *cur,
 
 int xfs_rmap_has_records(struct xfs_btree_cur *cur, xfs_agblock_t bno,
 		xfs_extlen_t len, enum xbtree_recpacking *outcome);
-int xfs_rmap_record_exists(struct xfs_btree_cur *cur, xfs_agblock_t bno,
+
+struct xfs_rmap_matches {
+	/* Number of owner matches. */
+	unsigned long long	matches;
+
+	/* Number of non-owner matches. */
+	unsigned long long	nono_matches;
+
+	/* Number of non-owner matches that conflict with the owner matches. */
+	unsigned long long	badno_matches;
+};
+
+int xfs_rmap_count_owners(struct xfs_btree_cur *cur, xfs_agblock_t bno,
 		xfs_extlen_t len, const struct xfs_owner_info *oinfo,
-		bool *has_rmap);
+		struct xfs_rmap_matches *rmatch);
 int xfs_rmap_has_other_keys(struct xfs_btree_cur *cur, xfs_agblock_t bno,
 		xfs_extlen_t len, const struct xfs_owner_info *oinfo,
-		bool *has_rmap);
+		bool *has_other);
 int xfs_rmap_map_raw(struct xfs_btree_cur *cur, struct xfs_rmap_irec *rmap);
 
 extern const struct xfs_owner_info XFS_RMAP_OINFO_SKIP_UPDATE;
diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 520ec054e4a6..75de0ba4fcef 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -51,7 +51,7 @@ xchk_superblock_xref(
 
 	xchk_xref_is_used_space(sc, agbno, 1);
 	xchk_xref_is_not_inode_chunk(sc, agbno, 1);
-	xchk_xref_is_owned_by(sc, agbno, 1, &XFS_RMAP_OINFO_FS);
+	xchk_xref_is_only_owned_by(sc, agbno, 1, &XFS_RMAP_OINFO_FS);
 	xchk_xref_is_not_shared(sc, agbno, 1);
 	xchk_xref_is_not_cow_staging(sc, agbno, 1);
 
@@ -515,7 +515,7 @@ xchk_agf_xref(
 	xchk_agf_xref_freeblks(sc);
 	xchk_agf_xref_cntbt(sc);
 	xchk_xref_is_not_inode_chunk(sc, agbno, 1);
-	xchk_xref_is_owned_by(sc, agbno, 1, &XFS_RMAP_OINFO_FS);
+	xchk_xref_is_only_owned_by(sc, agbno, 1, &XFS_RMAP_OINFO_FS);
 	xchk_agf_xref_btreeblks(sc);
 	xchk_xref_is_not_shared(sc, agbno, 1);
 	xchk_xref_is_not_cow_staging(sc, agbno, 1);
@@ -644,7 +644,7 @@ xchk_agfl_block_xref(
 
 	xchk_xref_is_used_space(sc, agbno, 1);
 	xchk_xref_is_not_inode_chunk(sc, agbno, 1);
-	xchk_xref_is_owned_by(sc, agbno, 1, &XFS_RMAP_OINFO_AG);
+	xchk_xref_is_only_owned_by(sc, agbno, 1, &XFS_RMAP_OINFO_AG);
 	xchk_xref_is_not_shared(sc, agbno, 1);
 	xchk_xref_is_not_cow_staging(sc, agbno, 1);
 }
@@ -701,7 +701,7 @@ xchk_agfl_xref(
 
 	xchk_xref_is_used_space(sc, agbno, 1);
 	xchk_xref_is_not_inode_chunk(sc, agbno, 1);
-	xchk_xref_is_owned_by(sc, agbno, 1, &XFS_RMAP_OINFO_FS);
+	xchk_xref_is_only_owned_by(sc, agbno, 1, &XFS_RMAP_OINFO_FS);
 	xchk_xref_is_not_shared(sc, agbno, 1);
 	xchk_xref_is_not_cow_staging(sc, agbno, 1);
 
@@ -857,7 +857,7 @@ xchk_agi_xref(
 	xchk_xref_is_used_space(sc, agbno, 1);
 	xchk_xref_is_not_inode_chunk(sc, agbno, 1);
 	xchk_agi_xref_icounts(sc);
-	xchk_xref_is_owned_by(sc, agbno, 1, &XFS_RMAP_OINFO_FS);
+	xchk_xref_is_only_owned_by(sc, agbno, 1, &XFS_RMAP_OINFO_FS);
 	xchk_xref_is_not_shared(sc, agbno, 1);
 	xchk_xref_is_not_cow_staging(sc, agbno, 1);
 	xchk_agi_xref_fiblocks(sc);
diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index 8ae42dff632f..24ea77e46ebd 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -402,7 +402,7 @@ xchk_btree_check_block_owner(
 	if (!bs->sc->sa.bno_cur && btnum == XFS_BTNUM_BNO)
 		bs->cur = NULL;
 
-	xchk_xref_is_owned_by(bs->sc, agbno, 1, bs->oinfo);
+	xchk_xref_is_only_owned_by(bs->sc, agbno, 1, bs->oinfo);
 	if (!bs->sc->sa.rmap_cur && btnum == XFS_BTNUM_RMAP)
 		bs->cur = NULL;
 
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 598112471d07..f690143af0c0 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -276,7 +276,7 @@ xchk_iallocbt_chunk(
 		xchk_inobt_chunk_xref_finobt(sc, irec, agino, nr_inodes);
 	else
 		xchk_finobt_chunk_xref_inobt(sc, irec, agino, nr_inodes);
-	xchk_xref_is_owned_by(sc, agbno, len, &XFS_RMAP_OINFO_INODES);
+	xchk_xref_is_only_owned_by(sc, agbno, len, &XFS_RMAP_OINFO_INODES);
 	xchk_xref_is_not_shared(sc, agbno, len);
 	xchk_xref_is_not_cow_staging(sc, agbno, len);
 	return true;
@@ -428,7 +428,7 @@ xchk_iallocbt_check_cluster(
 		return 0;
 	}
 
-	xchk_xref_is_owned_by(bs->sc, agbno, M_IGEO(mp)->blocks_per_cluster,
+	xchk_xref_is_only_owned_by(bs->sc, agbno, M_IGEO(mp)->blocks_per_cluster,
 			&XFS_RMAP_OINFO_INODES);
 
 	/* Grab the inode cluster buffer. */
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 95694eca3851..3b272c86d0ad 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -556,7 +556,7 @@ xchk_inode_xref(
 
 	xchk_xref_is_used_space(sc, agbno, 1);
 	xchk_inode_xref_finobt(sc, ino);
-	xchk_xref_is_owned_by(sc, agbno, 1, &XFS_RMAP_OINFO_INODES);
+	xchk_xref_is_only_owned_by(sc, agbno, 1, &XFS_RMAP_OINFO_INODES);
 	xchk_xref_is_not_shared(sc, agbno, 1);
 	xchk_xref_is_not_cow_staging(sc, agbno, 1);
 	xchk_inode_xref_bmap(sc, dip);
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index 9ac3bc760d6c..7b0ad8f846ab 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -167,38 +167,29 @@ xchk_rmapbt(
 			&XFS_RMAP_OINFO_AG, NULL);
 }
 
-/* xref check that the extent is owned by a given owner */
-static inline void
-xchk_xref_check_owner(
+/* xref check that the extent is owned only by a given owner */
+void
+xchk_xref_is_only_owned_by(
 	struct xfs_scrub		*sc,
 	xfs_agblock_t			bno,
 	xfs_extlen_t			len,
-	const struct xfs_owner_info	*oinfo,
-	bool				should_have_rmap)
+	const struct xfs_owner_info	*oinfo)
 {
-	bool				has_rmap;
+	struct xfs_rmap_matches		res;
 	int				error;
 
 	if (!sc->sa.rmap_cur || xchk_skip_xref(sc->sm))
 		return;
 
-	error = xfs_rmap_record_exists(sc->sa.rmap_cur, bno, len, oinfo,
-			&has_rmap);
+	error = xfs_rmap_count_owners(sc->sa.rmap_cur, bno, len, oinfo, &res);
 	if (!xchk_should_check_xref(sc, &error, &sc->sa.rmap_cur))
 		return;
-	if (has_rmap != should_have_rmap)
+	if (res.matches != 1)
+		xchk_btree_xref_set_corrupt(sc, sc->sa.rmap_cur, 0);
+	if (res.badno_matches)
+		xchk_btree_xref_set_corrupt(sc, sc->sa.rmap_cur, 0);
+	if (res.nono_matches)
 		xchk_btree_xref_set_corrupt(sc, sc->sa.rmap_cur, 0);
-}
-
-/* xref check that the extent is owned by a given owner */
-void
-xchk_xref_is_owned_by(
-	struct xfs_scrub		*sc,
-	xfs_agblock_t			bno,
-	xfs_extlen_t			len,
-	const struct xfs_owner_info	*oinfo)
-{
-	xchk_xref_check_owner(sc, bno, len, oinfo, true);
 }
 
 /* xref check that the extent is not owned by a given owner */
@@ -209,7 +200,19 @@ xchk_xref_is_not_owned_by(
 	xfs_extlen_t			len,
 	const struct xfs_owner_info	*oinfo)
 {
-	xchk_xref_check_owner(sc, bno, len, oinfo, false);
+	struct xfs_rmap_matches		res;
+	int				error;
+
+	if (!sc->sa.rmap_cur || xchk_skip_xref(sc->sm))
+		return;
+
+	error = xfs_rmap_count_owners(sc->sa.rmap_cur, bno, len, oinfo, &res);
+	if (!xchk_should_check_xref(sc, &error, &sc->sa.rmap_cur))
+		return;
+	if (res.matches != 0)
+		xchk_btree_xref_set_corrupt(sc, sc->sa.rmap_cur, 0);
+	if (res.badno_matches)
+		xchk_btree_xref_set_corrupt(sc, sc->sa.rmap_cur, 0);
 }
 
 /* xref check that the extent has no reverse mapping at all */
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index a331838e22ff..20e74179d8a7 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -156,7 +156,7 @@ void xchk_xref_is_not_inode_chunk(struct xfs_scrub *sc, xfs_agblock_t agbno,
 		xfs_extlen_t len);
 void xchk_xref_is_inode_chunk(struct xfs_scrub *sc, xfs_agblock_t agbno,
 		xfs_extlen_t len);
-void xchk_xref_is_owned_by(struct xfs_scrub *sc, xfs_agblock_t agbno,
+void xchk_xref_is_only_owned_by(struct xfs_scrub *sc, xfs_agblock_t agbno,
 		xfs_extlen_t len, const struct xfs_owner_info *oinfo);
 void xchk_xref_is_not_owned_by(struct xfs_scrub *sc, xfs_agblock_t agbno,
 		xfs_extlen_t len, const struct xfs_owner_info *oinfo);

