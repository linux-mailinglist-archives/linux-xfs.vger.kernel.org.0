Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4321EF36D
	for <lists+linux-xfs@lfdr.de>; Fri,  5 Jun 2020 10:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgFEIw6 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 5 Jun 2020 04:52:58 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43271 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726096AbgFEIw6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Jun 2020 04:52:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591347174;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=b2qbX/7a/TWwe1pSwozPmZssRM/BY2bmpCV8oHAGcEU=;
        b=YAc8Mg8mOgVbMXgDj0jxVDW4KFPUpsX2SGRjE0gKaJ2lYxIpzls84mWyMQ43S94QS7JVos
        hQaVskT/hfZzZaLmoRc9RhEjv6V/PnWkZMcutKdFJmjk8dmY9ldmJ9NQ5UMLvpxXVlJPeI
        w7yPweXsfmPAcP5YHGNL9u+84qD/PQw=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-454-D4wB5nNnNTCyvR7zdYpo-Q-1; Fri, 05 Jun 2020 04:52:49 -0400
X-MC-Unique: D4wB5nNnNTCyvR7zdYpo-Q-1
Received: by mail-pj1-f72.google.com with SMTP id q38so347786pja.1
        for <linux-xfs@vger.kernel.org>; Fri, 05 Jun 2020 01:52:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=b2qbX/7a/TWwe1pSwozPmZssRM/BY2bmpCV8oHAGcEU=;
        b=l/Rj95VNeoQCx7wOWkkQAKhdEXeoHO0LhsXGK5bLps+qyN2Z6MVxFvNYGqHZAZKr8i
         8ckgtY0tRealRhsSQ9z8LYJHdEBBdRU6TM/yUCbubK9nYRbXMuHixR3nq/q4GRNrmeTr
         B6QrbQUKGydICkZwB+uRF+Ksj4E2eZ/0cq2ruQ+ofHRSaKCbWXIgH/nL9aM275+Hz+4M
         nSab2pDQYCGHJCJRSIiLaH5RE1+5GD+Nlko863538RDCTgeOkYQTHSnyo42RTbq/gyFe
         p06pPIHO6V79UowMiXaQRYxVueQcY/dmlJmxI76xG5KKmHv2Nt9s4B6s1vZZMn2gf8EZ
         1qoA==
X-Gm-Message-State: AOAM531uPh5deYszEflaoxcw3WT+PI0RfLdn6eor+klDNzDF94a6YpVj
        vPM6WNPnedcWxrWFp6/uoU0zZ8vwdXlBNCWQwxV22IR3qOOywmTKA78PJsmuDcAiS4MdQl8xVyj
        gCyYslvyk7V6pSfI2qFUW
X-Received: by 2002:aa7:8109:: with SMTP id b9mr8072610pfi.77.1591347168182;
        Fri, 05 Jun 2020 01:52:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyKq2qxcpEN2aYSMnXGYVAtr53F5gMjHqSvl7aialrTXAT9Ai3FGjRF2DOv3wFn4lcHUFc6Pw==
X-Received: by 2002:aa7:8109:: with SMTP id b9mr8072587pfi.77.1591347167674;
        Fri, 05 Jun 2020 01:52:47 -0700 (PDT)
Received: from xiangao.remote.csb ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a17sm4201304pfi.203.2020.06.05.01.52.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2020 01:52:46 -0700 (PDT)
From:   Gao Xiang <hsiangkao@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH v3] xfs: get rid of unnecessary xfs_perag_{get,put} pairs
Date:   Fri,  5 Jun 2020 16:52:00 +0800
Message-Id: <20200605085200.24989-1-hsiangkao@redhat.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20200603121156.3399-1-hsiangkao@redhat.com>
References: <20200603121156.3399-1-hsiangkao@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

In the course of some operations, we look up the perag from
the mount multiple times to get or change perag information.
These are often very short pieces of code, so while the
lookup cost is generally low, the cost of the lookup is far
higher than the cost of the operation we are doing on the
perag.

Since we changed buffers to hold references to the perag
they are cached in, many modification contexts already hold
active references to the perag that are held across these
operations. This is especially true for any operation that
is serialised by an allocation group header buffer.

In these cases, we can just use the buffer's reference to
the perag to avoid needing to do lookups to access the
perag. This means that many operations don't need to do
perag lookups at all to access the perag because they've
already looked up objects that own persistent references
and hence can use that reference instead.

Cc: Dave Chinner <dchinner@redhat.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
---
changes since v2:
  kill unneeded ASSERTs, leaving which first brought
  into a context pointed out by Dave (including callback
  entrances).

 fs/xfs/libxfs/xfs_ag.c             |  4 ++--
 fs/xfs/libxfs/xfs_ag_resv.h        | 12 ----------
 fs/xfs/libxfs/xfs_alloc.c          | 23 +++++++-----------
 fs/xfs/libxfs/xfs_alloc_btree.c    | 10 ++++----
 fs/xfs/libxfs/xfs_ialloc.c         | 29 +++++++----------------
 fs/xfs/libxfs/xfs_refcount_btree.c |  5 ++--
 fs/xfs/libxfs/xfs_rmap_btree.c     | 11 +++++----
 fs/xfs/xfs_inode.c                 | 38 +++++++++---------------------
 8 files changed, 41 insertions(+), 91 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 9d84007a5c65..8cf73fe4338e 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -563,7 +563,8 @@ xfs_ag_get_geometry(
 	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agf_bp);
 	if (error)
 		goto out_agi;
-	pag = xfs_perag_get(mp, agno);
+
+	pag = agi_bp->b_pag;
 
 	/* Fill out form. */
 	memset(ageo, 0, sizeof(*ageo));
@@ -583,7 +584,6 @@ xfs_ag_get_geometry(
 	xfs_ag_geom_health(pag, ageo);
 
 	/* Release resources. */
-	xfs_perag_put(pag);
 	xfs_buf_relse(agf_bp);
 out_agi:
 	xfs_buf_relse(agi_bp);
diff --git a/fs/xfs/libxfs/xfs_ag_resv.h b/fs/xfs/libxfs/xfs_ag_resv.h
index f3fd0ee9a7f7..8a8eb4bc48bb 100644
--- a/fs/xfs/libxfs/xfs_ag_resv.h
+++ b/fs/xfs/libxfs/xfs_ag_resv.h
@@ -37,16 +37,4 @@ xfs_ag_resv_rmapbt_alloc(
 	xfs_perag_put(pag);
 }
 
-static inline void
-xfs_ag_resv_rmapbt_free(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		agno)
-{
-	struct xfs_perag	*pag;
-
-	pag = xfs_perag_get(mp, agno);
-	xfs_ag_resv_free_extent(pag, XFS_AG_RESV_RMAPBT, NULL, 1);
-	xfs_perag_put(pag);
-}
-
 #endif	/* __XFS_AG_RESV_H__ */
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 203e74fa64aa..6c40b0cb4fcc 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -710,13 +710,12 @@ xfs_alloc_read_agfl(
 STATIC int
 xfs_alloc_update_counters(
 	struct xfs_trans	*tp,
-	struct xfs_perag	*pag,
 	struct xfs_buf		*agbp,
 	long			len)
 {
 	struct xfs_agf		*agf = agbp->b_addr;
 
-	pag->pagf_freeblks += len;
+	agbp->b_pag->pagf_freeblks += len;
 	be32_add_cpu(&agf->agf_freeblks, len);
 
 	xfs_trans_agblocks_delta(tp, len);
@@ -1175,8 +1174,7 @@ xfs_alloc_ag_vextent(
 	}
 
 	if (!args->wasfromfl) {
-		error = xfs_alloc_update_counters(args->tp, args->pag,
-						  args->agbp,
+		error = xfs_alloc_update_counters(args->tp, args->agbp,
 						  -((long)(args->len)));
 		if (error)
 			return error;
@@ -1887,7 +1885,6 @@ xfs_free_ag_extent(
 	enum xfs_ag_resv_type		type)
 {
 	struct xfs_mount		*mp;
-	struct xfs_perag		*pag;
 	struct xfs_btree_cur		*bno_cur;
 	struct xfs_btree_cur		*cnt_cur;
 	xfs_agblock_t			gtbno; /* start of right neighbor */
@@ -2167,10 +2164,8 @@ xfs_free_ag_extent(
 	/*
 	 * Update the freespace totals in the ag and superblock.
 	 */
-	pag = xfs_perag_get(mp, agno);
-	error = xfs_alloc_update_counters(tp, pag, agbp, len);
-	xfs_ag_resv_free_extent(pag, type, tp, len);
-	xfs_perag_put(pag);
+	error = xfs_alloc_update_counters(tp, agbp, len);
+	xfs_ag_resv_free_extent(agbp->b_pag, type, tp, len);
 	if (error)
 		goto error0;
 
@@ -2689,7 +2684,7 @@ xfs_alloc_get_freelist(
 	if (be32_to_cpu(agf->agf_flfirst) == xfs_agfl_size(mp))
 		agf->agf_flfirst = 0;
 
-	pag = xfs_perag_get(mp, be32_to_cpu(agf->agf_seqno));
+	pag = agbp->b_pag;
 	ASSERT(!pag->pagf_agflreset);
 	be32_add_cpu(&agf->agf_flcount, -1);
 	xfs_trans_agflist_delta(tp, -1);
@@ -2701,7 +2696,6 @@ xfs_alloc_get_freelist(
 		pag->pagf_btreeblks++;
 		logflags |= XFS_AGF_BTREEBLKS;
 	}
-	xfs_perag_put(pag);
 
 	xfs_alloc_log_agf(tp, agbp, logflags);
 	*bnop = bno;
@@ -2797,7 +2791,7 @@ xfs_alloc_put_freelist(
 	if (be32_to_cpu(agf->agf_fllast) == xfs_agfl_size(mp))
 		agf->agf_fllast = 0;
 
-	pag = xfs_perag_get(mp, be32_to_cpu(agf->agf_seqno));
+	pag = agbp->b_pag;
 	ASSERT(!pag->pagf_agflreset);
 	be32_add_cpu(&agf->agf_flcount, 1);
 	xfs_trans_agflist_delta(tp, 1);
@@ -2809,7 +2803,6 @@ xfs_alloc_put_freelist(
 		pag->pagf_btreeblks--;
 		logflags |= XFS_AGF_BTREEBLKS;
 	}
-	xfs_perag_put(pag);
 
 	xfs_alloc_log_agf(tp, agbp, logflags);
 
@@ -3006,7 +2999,8 @@ xfs_alloc_read_agf(
 	ASSERT(!(*bpp)->b_error);
 
 	agf = (*bpp)->b_addr;
-	pag = xfs_perag_get(mp, agno);
+	pag = (*bpp)->b_pag;
+	ASSERT(pag->pag_agno == agno);
 	if (!pag->pagf_init) {
 		pag->pagf_freeblks = be32_to_cpu(agf->agf_freeblks);
 		pag->pagf_btreeblks = be32_to_cpu(agf->agf_btreeblks);
@@ -3034,7 +3028,6 @@ xfs_alloc_read_agf(
 		       be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]));
 	}
 #endif
-	xfs_perag_put(pag);
 	return 0;
 }
 
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 60c453cb3ee3..c1d276f791ea 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -38,16 +38,15 @@ xfs_allocbt_set_root(
 {
 	struct xfs_buf		*agbp = cur->bc_ag.agbp;
 	struct xfs_agf		*agf = agbp->b_addr;
-	xfs_agnumber_t		seqno = be32_to_cpu(agf->agf_seqno);
 	int			btnum = cur->bc_btnum;
-	struct xfs_perag	*pag = xfs_perag_get(cur->bc_mp, seqno);
+	struct xfs_perag	*pag = agbp->b_pag;
 
 	ASSERT(ptr->s != 0);
+	ASSERT(pag->pag_agno == be32_to_cpu(agf->agf_seqno));
 
 	agf->agf_roots[btnum] = ptr->s;
 	be32_add_cpu(&agf->agf_levels[btnum], inc);
 	pag->pagf_levels[btnum] += inc;
-	xfs_perag_put(pag);
 
 	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_ROOTS | XFS_AGF_LEVELS);
 }
@@ -115,7 +114,6 @@ xfs_allocbt_update_lastrec(
 	int			reason)
 {
 	struct xfs_agf		*agf = cur->bc_ag.agbp->b_addr;
-	xfs_agnumber_t		seqno = be32_to_cpu(agf->agf_seqno);
 	struct xfs_perag	*pag;
 	__be32			len;
 	int			numrecs;
@@ -160,9 +158,9 @@ xfs_allocbt_update_lastrec(
 	}
 
 	agf->agf_longest = len;
-	pag = xfs_perag_get(cur->bc_mp, seqno);
+	pag = cur->bc_ag.agbp->b_pag;
+	ASSERT(pag->pag_agno == be32_to_cpu(agf->agf_seqno));
 	pag->pagf_longest = be32_to_cpu(len);
-	xfs_perag_put(pag);
 	xfs_alloc_log_agf(cur->bc_tp, cur->bc_ag.agbp, XFS_AGF_LONGEST);
 }
 
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 7fcf62b324b0..14aa1faaa081 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -888,10 +888,9 @@ xfs_ialloc_ag_alloc(
 	 */
 	be32_add_cpu(&agi->agi_count, newlen);
 	be32_add_cpu(&agi->agi_freecount, newlen);
-	pag = xfs_perag_get(args.mp, agno);
+	pag = agbp->b_pag;
 	pag->pagi_freecount += newlen;
 	pag->pagi_count += newlen;
-	xfs_perag_put(pag);
 	agi->agi_newino = cpu_to_be32(newino);
 
 	/*
@@ -1134,7 +1133,7 @@ xfs_dialloc_ag_inobt(
 	xfs_agnumber_t		agno = be32_to_cpu(agi->agi_seqno);
 	xfs_agnumber_t		pagno = XFS_INO_TO_AGNO(mp, parent);
 	xfs_agino_t		pagino = XFS_INO_TO_AGINO(mp, parent);
-	struct xfs_perag	*pag;
+	struct xfs_perag	*pag = agbp->b_pag;
 	struct xfs_btree_cur	*cur, *tcur;
 	struct xfs_inobt_rec_incore rec, trec;
 	xfs_ino_t		ino;
@@ -1143,8 +1142,6 @@ xfs_dialloc_ag_inobt(
 	int			i, j;
 	int			searchdistance = 10;
 
-	pag = xfs_perag_get(mp, agno);
-
 	ASSERT(pag->pagi_init);
 	ASSERT(pag->pagi_inodeok);
 	ASSERT(pag->pagi_freecount > 0);
@@ -1384,14 +1381,12 @@ xfs_dialloc_ag_inobt(
 
 	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
 	xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, -1);
-	xfs_perag_put(pag);
 	*inop = ino;
 	return 0;
 error1:
 	xfs_btree_del_cursor(tcur, XFS_BTREE_ERROR);
 error0:
 	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
-	xfs_perag_put(pag);
 	return error;
 }
 
@@ -1587,7 +1582,6 @@ xfs_dialloc_ag(
 	xfs_agnumber_t			agno = be32_to_cpu(agi->agi_seqno);
 	xfs_agnumber_t			pagno = XFS_INO_TO_AGNO(mp, parent);
 	xfs_agino_t			pagino = XFS_INO_TO_AGINO(mp, parent);
-	struct xfs_perag		*pag;
 	struct xfs_btree_cur		*cur;	/* finobt cursor */
 	struct xfs_btree_cur		*icur;	/* inobt cursor */
 	struct xfs_inobt_rec_incore	rec;
@@ -1599,8 +1593,6 @@ xfs_dialloc_ag(
 	if (!xfs_sb_version_hasfinobt(&mp->m_sb))
 		return xfs_dialloc_ag_inobt(tp, agbp, parent, inop);
 
-	pag = xfs_perag_get(mp, agno);
-
 	/*
 	 * If pagino is 0 (this is the root inode allocation) use newino.
 	 * This must work because we've just allocated some.
@@ -1667,7 +1659,7 @@ xfs_dialloc_ag(
 	 */
 	be32_add_cpu(&agi->agi_freecount, -1);
 	xfs_ialloc_log_agi(tp, agbp, XFS_AGI_FREECOUNT);
-	pag->pagi_freecount--;
+	agbp->b_pag->pagi_freecount--;
 
 	xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, -1);
 
@@ -1680,7 +1672,6 @@ xfs_dialloc_ag(
 
 	xfs_btree_del_cursor(icur, XFS_BTREE_NOERROR);
 	xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
-	xfs_perag_put(pag);
 	*inop = ino;
 	return 0;
 
@@ -1688,7 +1679,6 @@ xfs_dialloc_ag(
 	xfs_btree_del_cursor(icur, XFS_BTREE_ERROR);
 error_cur:
 	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
-	xfs_perag_put(pag);
 	return error;
 }
 
@@ -1945,7 +1935,6 @@ xfs_difree_inobt(
 {
 	struct xfs_agi			*agi = agbp->b_addr;
 	xfs_agnumber_t			agno = be32_to_cpu(agi->agi_seqno);
-	struct xfs_perag		*pag;
 	struct xfs_btree_cur		*cur;
 	struct xfs_inobt_rec_incore	rec;
 	int				ilen;
@@ -2007,6 +1996,8 @@ xfs_difree_inobt(
 	if (!(mp->m_flags & XFS_MOUNT_IKEEP) &&
 	    rec.ir_free == XFS_INOBT_ALL_FREE &&
 	    mp->m_sb.sb_inopblock <= XFS_INODES_PER_CHUNK) {
+		struct xfs_perag	*pag = agbp->b_pag;
+
 		xic->deleted = true;
 		xic->first_ino = XFS_AGINO_TO_INO(mp, agno, rec.ir_startino);
 		xic->alloc = xfs_inobt_irec_to_allocmask(&rec);
@@ -2020,10 +2011,8 @@ xfs_difree_inobt(
 		be32_add_cpu(&agi->agi_count, -ilen);
 		be32_add_cpu(&agi->agi_freecount, -(ilen - 1));
 		xfs_ialloc_log_agi(tp, agbp, XFS_AGI_COUNT | XFS_AGI_FREECOUNT);
-		pag = xfs_perag_get(mp, agno);
 		pag->pagi_freecount -= ilen - 1;
 		pag->pagi_count -= ilen;
-		xfs_perag_put(pag);
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_ICOUNT, -ilen);
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, -(ilen - 1));
 
@@ -2049,9 +2038,7 @@ xfs_difree_inobt(
 		 */
 		be32_add_cpu(&agi->agi_freecount, 1);
 		xfs_ialloc_log_agi(tp, agbp, XFS_AGI_FREECOUNT);
-		pag = xfs_perag_get(mp, agno);
-		pag->pagi_freecount++;
-		xfs_perag_put(pag);
+		agbp->b_pag->pagi_freecount++;
 		xfs_trans_mod_sb(tp, XFS_TRANS_SB_IFREE, 1);
 	}
 
@@ -2661,7 +2648,8 @@ xfs_ialloc_read_agi(
 		return error;
 
 	agi = (*bpp)->b_addr;
-	pag = xfs_perag_get(mp, agno);
+	pag = (*bpp)->b_pag;
+	ASSERT(pag->pag_agno == agno);
 	if (!pag->pagi_init) {
 		pag->pagi_freecount = be32_to_cpu(agi->agi_freecount);
 		pag->pagi_count = be32_to_cpu(agi->agi_count);
@@ -2674,7 +2662,6 @@ xfs_ialloc_read_agi(
 	 */
 	ASSERT(pag->pagi_freecount == be32_to_cpu(agi->agi_freecount) ||
 		XFS_FORCED_SHUTDOWN(mp));
-	xfs_perag_put(pag);
 	return 0;
 }
 
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 7fd6044a4f78..f445a8e2d04e 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -37,15 +37,14 @@ xfs_refcountbt_set_root(
 {
 	struct xfs_buf		*agbp = cur->bc_ag.agbp;
 	struct xfs_agf		*agf = agbp->b_addr;
-	xfs_agnumber_t		seqno = be32_to_cpu(agf->agf_seqno);
-	struct xfs_perag	*pag = xfs_perag_get(cur->bc_mp, seqno);
+	struct xfs_perag	*pag = agbp->b_pag;
 
 	ASSERT(ptr->s != 0);
+	ASSERT(pag->pag_agno == be32_to_cpu(agf->agf_seqno));
 
 	agf->agf_refcount_root = ptr->s;
 	be32_add_cpu(&agf->agf_refcount_level, inc);
 	pag->pagf_refcount_level += inc;
-	xfs_perag_put(pag);
 
 	xfs_alloc_log_agf(cur->bc_tp, agbp,
 			XFS_AGF_REFCOUNT_ROOT | XFS_AGF_REFCOUNT_LEVEL);
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index b7c05314d07c..be660b2fd422 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -63,16 +63,15 @@ xfs_rmapbt_set_root(
 {
 	struct xfs_buf		*agbp = cur->bc_ag.agbp;
 	struct xfs_agf		*agf = agbp->b_addr;
-	xfs_agnumber_t		seqno = be32_to_cpu(agf->agf_seqno);
 	int			btnum = cur->bc_btnum;
-	struct xfs_perag	*pag = xfs_perag_get(cur->bc_mp, seqno);
+	struct xfs_perag	*pag = agbp->b_pag;
 
 	ASSERT(ptr->s != 0);
+	ASSERT(pag->pag_agno == be32_to_cpu(agf->agf_seqno));
 
 	agf->agf_roots[btnum] = ptr->s;
 	be32_add_cpu(&agf->agf_levels[btnum], inc);
 	pag->pagf_levels[btnum] += inc;
-	xfs_perag_put(pag);
 
 	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_ROOTS | XFS_AGF_LEVELS);
 }
@@ -123,6 +122,7 @@ xfs_rmapbt_free_block(
 {
 	struct xfs_buf		*agbp = cur->bc_ag.agbp;
 	struct xfs_agf		*agf = agbp->b_addr;
+	struct xfs_perag	*pag;
 	xfs_agblock_t		bno;
 	int			error;
 
@@ -139,8 +139,9 @@ xfs_rmapbt_free_block(
 			      XFS_EXTENT_BUSY_SKIP_DISCARD);
 	xfs_trans_agbtree_delta(cur->bc_tp, -1);
 
-	xfs_ag_resv_rmapbt_free(cur->bc_mp, cur->bc_ag.agno);
-
+	pag = cur->bc_ag.agbp->b_pag;
+	ASSERT(pag->pag_agno == cur->bc_ag.agno);
+	xfs_ag_resv_free_extent(pag, XFS_AG_RESV_RMAPBT, NULL, 1);
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 64f5f9a440ae..d0e7db7a2c32 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2248,7 +2248,6 @@ xfs_iunlink(
 	}
 
 	if (next_agino != NULLAGINO) {
-		struct xfs_perag	*pag;
 		xfs_agino_t		old_agino;
 
 		/*
@@ -2265,9 +2264,7 @@ xfs_iunlink(
 		 * agino has been unlinked, add a backref from the next inode
 		 * back to agino.
 		 */
-		pag = xfs_perag_get(mp, agno);
-		error = xfs_iunlink_add_backref(pag, agino, next_agino);
-		xfs_perag_put(pag);
+		error = xfs_iunlink_add_backref(agibp->b_pag, agino, next_agino);
 		if (error)
 			return error;
 	}
@@ -2403,7 +2400,6 @@ xfs_iunlink_remove(
 	struct xfs_buf		*agibp;
 	struct xfs_buf		*last_ibp;
 	struct xfs_dinode	*last_dip = NULL;
-	struct xfs_perag	*pag = NULL;
 	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, ip->i_ino);
 	xfs_agino_t		agino = XFS_INO_TO_AGINO(mp, ip->i_ino);
 	xfs_agino_t		next_agino;
@@ -2447,32 +2443,22 @@ xfs_iunlink_remove(
 	 * this inode's backref to point from the next inode.
 	 */
 	if (next_agino != NULLAGINO) {
-		pag = xfs_perag_get(mp, agno);
-		error = xfs_iunlink_change_backref(pag, next_agino,
+		error = xfs_iunlink_change_backref(agibp->b_pag, next_agino,
 				NULLAGINO);
 		if (error)
-			goto out;
+			return error;
 	}
 
-	if (head_agino == agino) {
-		/* Point the head of the list to the next unlinked inode. */
-		error = xfs_iunlink_update_bucket(tp, agno, agibp, bucket_index,
-				next_agino);
-		if (error)
-			goto out;
-	} else {
+	if (head_agino != agino) {
 		struct xfs_imap	imap;
 		xfs_agino_t	prev_agino;
 
-		if (!pag)
-			pag = xfs_perag_get(mp, agno);
-
 		/* We need to search the list for the inode being freed. */
 		error = xfs_iunlink_map_prev(tp, agno, head_agino, agino,
 				&prev_agino, &imap, &last_dip, &last_ibp,
-				pag);
+				agibp->b_pag);
 		if (error)
-			goto out;
+			return error;
 
 		/* Point the previous inode on the list to the next inode. */
 		xfs_iunlink_update_dinode(tp, agno, prev_agino, last_ibp,
@@ -2486,15 +2472,13 @@ xfs_iunlink_remove(
 		 * change_backref takes care of deleting the backref if
 		 * next_agino is NULLAGINO.
 		 */
-		error = xfs_iunlink_change_backref(pag, agino, next_agino);
-		if (error)
-			goto out;
+		return xfs_iunlink_change_backref(agibp->b_pag, agino,
+				next_agino);
 	}
 
-out:
-	if (pag)
-		xfs_perag_put(pag);
-	return error;
+	/* Point the head of the list to the next unlinked inode. */
+	return xfs_iunlink_update_bucket(tp, agno, agibp, bucket_index,
+			next_agino);
 }
 
 /*
-- 
2.18.1

