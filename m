Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24E37672B76
	for <lists+linux-xfs@lfdr.de>; Wed, 18 Jan 2023 23:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbjARWpY (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 18 Jan 2023 17:45:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbjARWpQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Jan 2023 17:45:16 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8206461D4E
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:45:14 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id s3so91051pfd.12
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 14:45:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AVelVzwO91snn4PzAhF9uDHStdiBUaJ/Y7lIbfytOdE=;
        b=sEmh9qVSo7Zb+J7YJCCNKJ0exSKAHmBKTMO5sizLAEByvOICLyjsm5Ftu8yKK4YGsK
         MQGdtotkpeh5gAGttAAs4aCyGwE8qpPdzzHZ1fpNaYiDvaPoo0bkmmn0g1uTZag/aT9W
         QqCZzjXw17e2w7v0utYG/+zx0ScyTTYApZzk1vRvjs763r6KwvPV2Iy4WBS7YRiLM6gp
         hpNH2r+o6dP01FLdizXjrntSj/iUDmHMloFF1KZAyWYvhwCIt5biFNV2WBfBUBNei7/C
         hOHFfeChZveHP/HW05EUeyaVtm81YTBniSggE2xBtE7zkHJFb3O7wPg63viKVUhVCyuF
         gNNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AVelVzwO91snn4PzAhF9uDHStdiBUaJ/Y7lIbfytOdE=;
        b=64Ir3svex3ZRa3CBy6A22da+hW5Ya1yFMtR2k0w1wGcZO4vYVolaJg6QY6zhxhOt7s
         oEcXaCPycefzVdWLyVk94FJDON4iBYEs2Mxx1BIUS3k0bRPf8d5fS9y3EYtZwN2Spgae
         QTZx94vxuv+qgAIi4S1c8ekcza64IgSnfHBrQdv5pBN3q1KyD1upRvunCJRLd1z+f1f3
         Z04euPg77/zkfATXaE4/gtgc8SoOlOQUeizZHhIfut6vZ2erPkfHXa2ilFiE+NKFaAdN
         c8bOUsjztI8fikX3Ko5Khtr63AKYPtzeSRbMpI34WdgfxYGyn62YGjC7PehFRAfq5MmT
         /nfg==
X-Gm-Message-State: AFqh2kqhDnC61o7Wx7kUE+QCLLzVucg7ZHTMMo3LT8RkRwHoMrACXNCK
        lNZ998GM1pBYp4dVP3+YHmKtLGtSwZAmOFRy
X-Google-Smtp-Source: AMrXdXuzN+aUkRBmMd6FF66E6vwAigW0ubemPWXESWqXyIuKYvaB2zihlDefrPurPECFqlLeuj8TWQ==
X-Received: by 2002:a05:6a00:f07:b0:581:61a7:c8f0 with SMTP id cr7-20020a056a000f0700b0058161a7c8f0mr9531385pfb.4.1674081913878;
        Wed, 18 Jan 2023 14:45:13 -0800 (PST)
Received: from dread.disaster.area (pa49-186-146-207.pa.vic.optusnet.com.au. [49.186.146.207])
        by smtp.gmail.com with ESMTPSA id h28-20020a056a00001c00b0058bba6f06c5sm10112235pfk.8.2023.01.18.14.45.13
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 14:45:13 -0800 (PST)
Received: from [192.168.253.23] (helo=devoid.disaster.area)
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <dave@fromorbit.com>)
        id 1pIHB9-004iXD-5E
        for linux-xfs@vger.kernel.org; Thu, 19 Jan 2023 09:45:11 +1100
Received: from dave by devoid.disaster.area with local (Exim 4.96)
        (envelope-from <dave@devoid.disaster.area>)
        id 1pIHB9-008FDY-0W
        for linux-xfs@vger.kernel.org;
        Thu, 19 Jan 2023 09:45:11 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 13/42] xfs: perags need atomic operational state
Date:   Thu, 19 Jan 2023 09:44:36 +1100
Message-Id: <20230118224505.1964941-14-david@fromorbit.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230118224505.1964941-1-david@fromorbit.com>
References: <20230118224505.1964941-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We currently don't have any flags or operational state in the
xfs_perag except for the pagf_init and pagi_init flags. And the
agflreset flag. Oh, there's also the pagf_metadata and pagi_inodeok
flags, too.

For controlling per-ag operations, we are going to need some atomic
state flags. Hence add an opstate field similar to what we already
have in the mount and log, and convert all these state flags across
to atomic bit operations.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_ag.h             | 27 ++++++++++++++----
 fs/xfs/libxfs/xfs_alloc.c          | 23 ++++++++-------
 fs/xfs/libxfs/xfs_alloc_btree.c    |  2 +-
 fs/xfs/libxfs/xfs_bmap.c           |  2 +-
 fs/xfs/libxfs/xfs_ialloc.c         | 14 ++++-----
 fs/xfs/libxfs/xfs_ialloc_btree.c   |  4 +--
 fs/xfs/libxfs/xfs_refcount_btree.c |  2 +-
 fs/xfs/libxfs/xfs_rmap_btree.c     |  2 +-
 fs/xfs/scrub/agheader_repair.c     | 28 +++++++++---------
 fs/xfs/scrub/fscounters.c          |  9 ++++--
 fs/xfs/scrub/repair.c              |  2 +-
 fs/xfs/xfs_filestream.c            |  5 ++--
 fs/xfs/xfs_super.c                 | 46 ++++++++++++++++++------------
 13 files changed, 101 insertions(+), 65 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index aeb21c8df201..187d30d9bb13 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -35,13 +35,9 @@ struct xfs_perag {
 	atomic_t	pag_ref;	/* passive reference count */
 	atomic_t	pag_active_ref;	/* active reference count */
 	wait_queue_head_t pag_active_wq;/* woken active_ref falls to zero */
-	char		pagf_init;	/* this agf's entry is initialized */
-	char		pagi_init;	/* this agi's entry is initialized */
-	char		pagf_metadata;	/* the agf is preferred to be metadata */
-	char		pagi_inodeok;	/* The agi is ok for inodes */
+	unsigned long	pag_opstate;
 	uint8_t		pagf_levels[XFS_BTNUM_AGF];
 					/* # of levels in bno & cnt btree */
-	bool		pagf_agflreset; /* agfl requires reset before use */
 	uint32_t	pagf_flcount;	/* count of blocks in freelist */
 	xfs_extlen_t	pagf_freeblks;	/* total free blocks */
 	xfs_extlen_t	pagf_longest;	/* longest free space */
@@ -108,6 +104,27 @@ struct xfs_perag {
 #endif /* __KERNEL__ */
 };
 
+/*
+ * Per-AG operational state. These are atomic flag bits.
+ */
+#define XFS_AGSTATE_AGF_INIT		0
+#define XFS_AGSTATE_AGI_INIT		1
+#define XFS_AGSTATE_PREFERS_METADATA	2
+#define XFS_AGSTATE_ALLOWS_INODES	3
+#define XFS_AGSTATE_AGFL_NEEDS_RESET	4
+
+#define __XFS_AG_OPSTATE(name, NAME) \
+static inline bool xfs_perag_ ## name (struct xfs_perag *pag) \
+{ \
+	return test_bit(XFS_AGSTATE_ ## NAME, &pag->pag_opstate); \
+}
+
+__XFS_AG_OPSTATE(initialised_agf, AGF_INIT)
+__XFS_AG_OPSTATE(initialised_agi, AGI_INIT)
+__XFS_AG_OPSTATE(prefers_metadata, PREFERS_METADATA)
+__XFS_AG_OPSTATE(allows_inodes, ALLOWS_INODES)
+__XFS_AG_OPSTATE(agfl_needs_reset, AGFL_NEEDS_RESET)
+
 int xfs_initialize_perag(struct xfs_mount *mp, xfs_agnumber_t agcount,
 			xfs_rfsblock_t dcount, xfs_agnumber_t *maxagi);
 int xfs_initialize_perag_data(struct xfs_mount *mp, xfs_agnumber_t agno);
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 9f26a9368eeb..246c2e7d9e7a 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2435,7 +2435,7 @@ xfs_agfl_reset(
 	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_agf		*agf = agbp->b_addr;
 
-	ASSERT(pag->pagf_agflreset);
+	ASSERT(xfs_perag_agfl_needs_reset(pag));
 	trace_xfs_agfl_reset(mp, agf, 0, _RET_IP_);
 
 	xfs_warn(mp,
@@ -2450,7 +2450,7 @@ xfs_agfl_reset(
 				    XFS_AGF_FLCOUNT);
 
 	pag->pagf_flcount = 0;
-	pag->pagf_agflreset = false;
+	clear_bit(XFS_AGSTATE_AGFL_NEEDS_RESET, &pag->pag_opstate);
 }
 
 /*
@@ -2605,7 +2605,7 @@ xfs_alloc_fix_freelist(
 	/* deferred ops (AGFL block frees) require permanent transactions */
 	ASSERT(tp->t_flags & XFS_TRANS_PERM_LOG_RES);
 
-	if (!pag->pagf_init) {
+	if (!xfs_perag_initialised_agf(pag)) {
 		error = xfs_alloc_read_agf(pag, tp, flags, &agbp);
 		if (error) {
 			/* Couldn't lock the AGF so skip this AG. */
@@ -2620,7 +2620,8 @@ xfs_alloc_fix_freelist(
 	 * somewhere else if we are not being asked to try harder at this
 	 * point
 	 */
-	if (pag->pagf_metadata && (args->datatype & XFS_ALLOC_USERDATA) &&
+	if (xfs_perag_prefers_metadata(pag) &&
+	    (args->datatype & XFS_ALLOC_USERDATA) &&
 	    (flags & XFS_ALLOC_FLAG_TRYLOCK)) {
 		ASSERT(!(flags & XFS_ALLOC_FLAG_FREEING));
 		goto out_agbp_relse;
@@ -2646,7 +2647,7 @@ xfs_alloc_fix_freelist(
 	}
 
 	/* reset a padding mismatched agfl before final free space check */
-	if (pag->pagf_agflreset)
+	if (xfs_perag_agfl_needs_reset(pag))
 		xfs_agfl_reset(tp, agbp, pag);
 
 	/* If there isn't enough total space or single-extent, reject it. */
@@ -2803,7 +2804,7 @@ xfs_alloc_get_freelist(
 	if (be32_to_cpu(agf->agf_flfirst) == xfs_agfl_size(mp))
 		agf->agf_flfirst = 0;
 
-	ASSERT(!pag->pagf_agflreset);
+	ASSERT(!xfs_perag_agfl_needs_reset(pag));
 	be32_add_cpu(&agf->agf_flcount, -1);
 	pag->pagf_flcount--;
 
@@ -2892,7 +2893,7 @@ xfs_alloc_put_freelist(
 	if (be32_to_cpu(agf->agf_fllast) == xfs_agfl_size(mp))
 		agf->agf_fllast = 0;
 
-	ASSERT(!pag->pagf_agflreset);
+	ASSERT(!xfs_perag_agfl_needs_reset(pag));
 	be32_add_cpu(&agf->agf_flcount, 1);
 	pag->pagf_flcount++;
 
@@ -3099,7 +3100,7 @@ xfs_alloc_read_agf(
 		return error;
 
 	agf = agfbp->b_addr;
-	if (!pag->pagf_init) {
+	if (!xfs_perag_initialised_agf(pag)) {
 		pag->pagf_freeblks = be32_to_cpu(agf->agf_freeblks);
 		pag->pagf_btreeblks = be32_to_cpu(agf->agf_btreeblks);
 		pag->pagf_flcount = be32_to_cpu(agf->agf_flcount);
@@ -3111,8 +3112,8 @@ xfs_alloc_read_agf(
 		pag->pagf_levels[XFS_BTNUM_RMAPi] =
 			be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAPi]);
 		pag->pagf_refcount_level = be32_to_cpu(agf->agf_refcount_level);
-		pag->pagf_init = 1;
-		pag->pagf_agflreset = xfs_agfl_needs_reset(pag->pag_mount, agf);
+		if (xfs_agfl_needs_reset(pag->pag_mount, agf))
+			set_bit(XFS_AGSTATE_AGFL_NEEDS_RESET, &pag->pag_opstate);
 
 		/*
 		 * Update the in-core allocbt counter. Filter out the rmapbt
@@ -3127,6 +3128,8 @@ xfs_alloc_read_agf(
 		if (allocbt_blks > 0)
 			atomic64_add(allocbt_blks,
 					&pag->pag_mount->m_allocbt_blks);
+
+		set_bit(XFS_AGSTATE_AGF_INIT, &pag->pag_opstate);
 	}
 #ifdef DEBUG
 	else if (!xfs_is_shutdown(pag->pag_mount)) {
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 549a3cba0234..0f29c7b1b39f 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -315,7 +315,7 @@ xfs_allocbt_verify(
 	level = be16_to_cpu(block->bb_level);
 	if (bp->b_ops->magic[0] == cpu_to_be32(XFS_ABTC_MAGIC))
 		btnum = XFS_BTNUM_CNTi;
-	if (pag && pag->pagf_init) {
+	if (pag && xfs_perag_initialised_agf(pag)) {
 		if (level >= pag->pagf_levels[btnum])
 			return __this_address;
 	} else if (level >= mp->m_alloc_maxlevels)
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index f15d45af661f..6aad0ea5e606 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3147,7 +3147,7 @@ xfs_bmap_longest_free_extent(
 	int			error = 0;
 
 	pag = xfs_perag_get(mp, ag);
-	if (!pag->pagf_init) {
+	if (!xfs_perag_initialised_agf(pag)) {
 		error = xfs_alloc_read_agf(pag, tp, XFS_ALLOC_FLAG_TRYLOCK,
 				NULL);
 		if (error) {
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index c8d837d8876f..2a323ffa5ba9 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -998,8 +998,8 @@ xfs_dialloc_ag_inobt(
 	int			i, j;
 	int			searchdistance = 10;
 
-	ASSERT(pag->pagi_init);
-	ASSERT(pag->pagi_inodeok);
+	ASSERT(xfs_perag_initialised_agi(pag));
+	ASSERT(xfs_perag_allows_inodes(pag));
 	ASSERT(pag->pagi_freecount > 0);
 
  restart_pagno:
@@ -1592,10 +1592,10 @@ xfs_dialloc_good_ag(
 
 	if (!pag)
 		return false;
-	if (!pag->pagi_inodeok)
+	if (!xfs_perag_allows_inodes(pag))
 		return false;
 
-	if (!pag->pagi_init) {
+	if (!xfs_perag_initialised_agi(pag)) {
 		error = xfs_ialloc_read_agi(pag, tp, NULL);
 		if (error)
 			return false;
@@ -1606,7 +1606,7 @@ xfs_dialloc_good_ag(
 	if (!ok_alloc)
 		return false;
 
-	if (!pag->pagf_init) {
+	if (!xfs_perag_initialised_agf(pag)) {
 		error = xfs_alloc_read_agf(pag, tp, flags, NULL);
 		if (error)
 			return false;
@@ -2603,10 +2603,10 @@ xfs_ialloc_read_agi(
 		return error;
 
 	agi = agibp->b_addr;
-	if (!pag->pagi_init) {
+	if (!xfs_perag_initialised_agi(pag)) {
 		pag->pagi_freecount = be32_to_cpu(agi->agi_freecount);
 		pag->pagi_count = be32_to_cpu(agi->agi_count);
-		pag->pagi_init = 1;
+		set_bit(XFS_AGSTATE_AGI_INIT, &pag->pag_opstate);
 	}
 
 	/*
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index d657af2ec350..3675a0d29310 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -291,8 +291,8 @@ xfs_inobt_verify(
 	 * Similarly, during log recovery we will have a perag structure
 	 * attached, but the agi information will not yet have been initialised
 	 * from the on disk AGI. We don't currently use any of this information,
-	 * but beware of the landmine (i.e. need to check pag->pagi_init) if we
-	 * ever do.
+	 * but beware of the landmine (i.e. need to check
+	 * xfs_perag_initialised_agi(pag)) if we ever do.
 	 */
 	if (xfs_has_crc(mp)) {
 		fa = xfs_btree_sblock_v5hdr_verify(bp);
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index e1f789866683..d20abf0390fc 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -227,7 +227,7 @@ xfs_refcountbt_verify(
 		return fa;
 
 	level = be16_to_cpu(block->bb_level);
-	if (pag && pag->pagf_init) {
+	if (pag && xfs_perag_initialised_agf(pag)) {
 		if (level >= pag->pagf_refcount_level)
 			return __this_address;
 	} else if (level >= mp->m_refc_maxlevels)
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 7f83f62e51e0..d3285684bb5e 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -313,7 +313,7 @@ xfs_rmapbt_verify(
 		return fa;
 
 	level = be16_to_cpu(block->bb_level);
-	if (pag && pag->pagf_init) {
+	if (pag && xfs_perag_initialised_agf(pag)) {
 		if (level >= pag->pagf_levels[XFS_BTNUM_RMAPi])
 			return __this_address;
 	} else if (level >= mp->m_rmap_maxlevels)
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index b80b9111e781..c37e6d72760b 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -191,14 +191,15 @@ xrep_agf_init_header(
 	struct xfs_agf		*old_agf)
 {
 	struct xfs_mount	*mp = sc->mp;
+	struct xfs_perag	*pag = sc->sa.pag;
 	struct xfs_agf		*agf = agf_bp->b_addr;
 
 	memcpy(old_agf, agf, sizeof(*old_agf));
 	memset(agf, 0, BBTOB(agf_bp->b_length));
 	agf->agf_magicnum = cpu_to_be32(XFS_AGF_MAGIC);
 	agf->agf_versionnum = cpu_to_be32(XFS_AGF_VERSION);
-	agf->agf_seqno = cpu_to_be32(sc->sa.pag->pag_agno);
-	agf->agf_length = cpu_to_be32(sc->sa.pag->block_count);
+	agf->agf_seqno = cpu_to_be32(pag->pag_agno);
+	agf->agf_length = cpu_to_be32(pag->block_count);
 	agf->agf_flfirst = old_agf->agf_flfirst;
 	agf->agf_fllast = old_agf->agf_fllast;
 	agf->agf_flcount = old_agf->agf_flcount;
@@ -206,8 +207,8 @@ xrep_agf_init_header(
 		uuid_copy(&agf->agf_uuid, &mp->m_sb.sb_meta_uuid);
 
 	/* Mark the incore AGF data stale until we're done fixing things. */
-	ASSERT(sc->sa.pag->pagf_init);
-	sc->sa.pag->pagf_init = 0;
+	ASSERT(xfs_perag_initialised_agf(pag));
+	clear_bit(XFS_AGSTATE_AGF_INIT, &pag->pag_opstate);
 }
 
 /* Set btree root information in an AGF. */
@@ -333,7 +334,7 @@ xrep_agf_commit_new(
 	pag->pagf_levels[XFS_BTNUM_RMAPi] =
 			be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAPi]);
 	pag->pagf_refcount_level = be32_to_cpu(agf->agf_refcount_level);
-	pag->pagf_init = 1;
+	set_bit(XFS_AGSTATE_AGF_INIT, &pag->pag_opstate);
 
 	return 0;
 }
@@ -434,7 +435,7 @@ xrep_agf(
 
 out_revert:
 	/* Mark the incore AGF state stale and revert the AGF. */
-	sc->sa.pag->pagf_init = 0;
+	clear_bit(XFS_AGSTATE_AGF_INIT, &sc->sa.pag->pag_opstate);
 	memcpy(agf, &old_agf, sizeof(old_agf));
 	return error;
 }
@@ -618,7 +619,7 @@ xrep_agfl_update_agf(
 	xfs_force_summary_recalc(sc->mp);
 
 	/* Update the AGF counters. */
-	if (sc->sa.pag->pagf_init)
+	if (xfs_perag_initialised_agf(sc->sa.pag))
 		sc->sa.pag->pagf_flcount = flcount;
 	agf->agf_flfirst = cpu_to_be32(0);
 	agf->agf_flcount = cpu_to_be32(flcount);
@@ -822,14 +823,15 @@ xrep_agi_init_header(
 	struct xfs_agi		*old_agi)
 {
 	struct xfs_agi		*agi = agi_bp->b_addr;
+	struct xfs_perag	*pag = sc->sa.pag;
 	struct xfs_mount	*mp = sc->mp;
 
 	memcpy(old_agi, agi, sizeof(*old_agi));
 	memset(agi, 0, BBTOB(agi_bp->b_length));
 	agi->agi_magicnum = cpu_to_be32(XFS_AGI_MAGIC);
 	agi->agi_versionnum = cpu_to_be32(XFS_AGI_VERSION);
-	agi->agi_seqno = cpu_to_be32(sc->sa.pag->pag_agno);
-	agi->agi_length = cpu_to_be32(sc->sa.pag->block_count);
+	agi->agi_seqno = cpu_to_be32(pag->pag_agno);
+	agi->agi_length = cpu_to_be32(pag->block_count);
 	agi->agi_newino = cpu_to_be32(NULLAGINO);
 	agi->agi_dirino = cpu_to_be32(NULLAGINO);
 	if (xfs_has_crc(mp))
@@ -840,8 +842,8 @@ xrep_agi_init_header(
 			sizeof(agi->agi_unlinked));
 
 	/* Mark the incore AGF data stale until we're done fixing things. */
-	ASSERT(sc->sa.pag->pagi_init);
-	sc->sa.pag->pagi_init = 0;
+	ASSERT(xfs_perag_initialised_agi(pag));
+	clear_bit(XFS_AGSTATE_AGI_INIT, &pag->pag_opstate);
 }
 
 /* Set btree root information in an AGI. */
@@ -928,7 +930,7 @@ xrep_agi_commit_new(
 	pag = sc->sa.pag;
 	pag->pagi_count = be32_to_cpu(agi->agi_count);
 	pag->pagi_freecount = be32_to_cpu(agi->agi_freecount);
-	pag->pagi_init = 1;
+	set_bit(XFS_AGSTATE_AGI_INIT, &pag->pag_opstate);
 
 	return 0;
 }
@@ -993,7 +995,7 @@ xrep_agi(
 
 out_revert:
 	/* Mark the incore AGI state stale and revert the AGI. */
-	sc->sa.pag->pagi_init = 0;
+	clear_bit(XFS_AGSTATE_AGI_INIT, &sc->sa.pag->pag_opstate);
 	memcpy(agi, &old_agi, sizeof(old_agi));
 	return error;
 }
diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index ef97670970c3..f0c7f41897b9 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -86,7 +86,8 @@ xchk_fscount_warmup(
 	for_each_perag(mp, agno, pag) {
 		if (xchk_should_terminate(sc, &error))
 			break;
-		if (pag->pagi_init && pag->pagf_init)
+		if (xfs_perag_initialised_agi(pag) &&
+		    xfs_perag_initialised_agf(pag))
 			continue;
 
 		/* Lock both AG headers. */
@@ -101,7 +102,8 @@ xchk_fscount_warmup(
 		 * These are supposed to be initialized by the header read
 		 * function.
 		 */
-		if (!pag->pagi_init || !pag->pagf_init) {
+		if (!xfs_perag_initialised_agi(pag) ||
+		    !xfs_perag_initialised_agf(pag)) {
 			error = -EFSCORRUPTED;
 			break;
 		}
@@ -220,7 +222,8 @@ xchk_fscount_aggregate_agcounts(
 			break;
 
 		/* This somehow got unset since the warmup? */
-		if (!pag->pagi_init || !pag->pagf_init) {
+		if (!xfs_perag_initialised_agi(pag) ||
+		    !xfs_perag_initialised_agf(pag)) {
 			error = -EFSCORRUPTED;
 			break;
 		}
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 4b92f9253ccd..d0b1644efb89 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -206,7 +206,7 @@ xrep_calc_ag_resblks(
 		return 0;
 
 	pag = xfs_perag_get(mp, sm->sm_agno);
-	if (pag->pagi_init) {
+	if (xfs_perag_initialised_agi(pag)) {
 		/* Use in-core icount if possible. */
 		icount = pag->pagi_count;
 	} else {
diff --git a/fs/xfs/xfs_filestream.c b/fs/xfs/xfs_filestream.c
index 34b21a29c39b..7e8b25ab6c46 100644
--- a/fs/xfs/xfs_filestream.c
+++ b/fs/xfs/xfs_filestream.c
@@ -125,7 +125,7 @@ xfs_filestream_pick_ag(
 
 		pag = xfs_perag_get(mp, ag);
 
-		if (!pag->pagf_init) {
+		if (!xfs_perag_initialised_agf(pag)) {
 			err = xfs_alloc_read_agf(pag, NULL, trylock, NULL);
 			if (err) {
 				if (err != -EAGAIN) {
@@ -159,7 +159,8 @@ xfs_filestream_pick_ag(
 				xfs_ag_resv_needed(pag, XFS_AG_RESV_NONE));
 		if (((minlen && longest >= minlen) ||
 		     (!minlen && pag->pagf_freeblks >= minfree)) &&
-		    (!pag->pagf_metadata || !(flags & XFS_PICK_USERDATA) ||
+		    (!xfs_perag_prefers_metadata(pag) ||
+		     !(flags & XFS_PICK_USERDATA) ||
 		     (flags & XFS_PICK_LOWSPACE))) {
 
 			/* Break out, retaining the reference on the AG. */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 96375b5622fd..2479b5cbd75e 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -247,6 +247,32 @@ xfs_fs_show_options(
 	return 0;
 }
 
+static bool
+xfs_set_inode_alloc_perag(
+	struct xfs_perag	*pag,
+	xfs_ino_t		ino,
+	xfs_agnumber_t		max_metadata)
+{
+	if (!xfs_is_inode32(pag->pag_mount)) {
+		set_bit(XFS_AGSTATE_ALLOWS_INODES, &pag->pag_opstate);
+		clear_bit(XFS_AGSTATE_PREFERS_METADATA, &pag->pag_opstate);
+		return false;
+	}
+
+	if (ino > XFS_MAXINUMBER_32) {
+		clear_bit(XFS_AGSTATE_ALLOWS_INODES, &pag->pag_opstate);
+		clear_bit(XFS_AGSTATE_PREFERS_METADATA, &pag->pag_opstate);
+		return false;
+	}
+
+	set_bit(XFS_AGSTATE_ALLOWS_INODES, &pag->pag_opstate);
+	if (pag->pag_agno < max_metadata)
+		set_bit(XFS_AGSTATE_PREFERS_METADATA, &pag->pag_opstate);
+	else
+		clear_bit(XFS_AGSTATE_PREFERS_METADATA, &pag->pag_opstate);
+	return true;
+}
+
 /*
  * Set parameters for inode allocation heuristics, taking into account
  * filesystem size and inode32/inode64 mount options; i.e. specifically
@@ -310,24 +336,8 @@ xfs_set_inode_alloc(
 		ino = XFS_AGINO_TO_INO(mp, index, agino);
 
 		pag = xfs_perag_get(mp, index);
-
-		if (xfs_is_inode32(mp)) {
-			if (ino > XFS_MAXINUMBER_32) {
-				pag->pagi_inodeok = 0;
-				pag->pagf_metadata = 0;
-			} else {
-				pag->pagi_inodeok = 1;
-				maxagi++;
-				if (index < max_metadata)
-					pag->pagf_metadata = 1;
-				else
-					pag->pagf_metadata = 0;
-			}
-		} else {
-			pag->pagi_inodeok = 1;
-			pag->pagf_metadata = 0;
-		}
-
+		if (xfs_set_inode_alloc_perag(pag, ino, max_metadata))
+			maxagi++;
 		xfs_perag_put(pag);
 	}
 
-- 
2.39.0

