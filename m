Return-Path: <linux-xfs+bounces-13793-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ACC78999824
	for <lists+linux-xfs@lfdr.de>; Fri, 11 Oct 2024 02:40:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CE7B61C265D1
	for <lists+linux-xfs@lfdr.de>; Fri, 11 Oct 2024 00:40:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D3F110E9;
	Fri, 11 Oct 2024 00:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PzujIS9I"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B56A7E1
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728607218; cv=none; b=FitH2kN1eXtf6AZL/THNFspMJwQo73r3uHO4yz4vW43PD/o04DocQvJuCBCEyFlJ/rOEAIxTmyFkLYAf5A0I2oa2iqlOACL6A9v/ZLI1ct56tNXn+6q/3C8m9OEZrVYCAfbh7ahs/HnaoI0CtbCNDEa+pvguYtP6teS0tCuzOBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728607218; c=relaxed/simple;
	bh=c9b0c5y/O+QWwDkWfHhm/R6delXODz+tDu95FvBfaHk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aAdctojEYfUDWUQjJPUmIOVjoBhhDQqKWb7VhsXW5DjQwFfP86HCQ7FxNLZ6lHBrl0d5kkveQAUUWT3l7mqbHdOkKOsFMnAl+Dt8kx03JL0OEUFvDlUIwdYxbLAx3ubPMq3QHiCJ16JDhZrC8UAgAeweCkUOCBNXmAXRPa6YsTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PzujIS9I; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFE2DC4CEC5;
	Fri, 11 Oct 2024 00:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728607217;
	bh=c9b0c5y/O+QWwDkWfHhm/R6delXODz+tDu95FvBfaHk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PzujIS9IULYaXLu/i4wHuZ3jrlViGbsIOCglmo8TvR6Jd45IWVRf6Y5hEkmCxmlud
	 ZGMW9x/OCSkUtcCJnBVrSm1qLRkpSwD5QS85E5I/g+moqO189Do8uq88w9eQMMd2IZ
	 Ysp4TeocZmMKqTrNyzaam7VILg0fro87If18xSMiISSo19BVo2PpqmwWRMNDSEtcSQ
	 Wu5fzsaMrNCLxnsTj9VYdQcJRTAWczrG9Uev86hkRC8PNXWbhPrhhICni5wE1P97QL
	 D31UOIJcy5WHx6Z11YjiLVcaUjcOiuy7sDxGx0Wga037XO5SgtkxgpQTTFgd1duOBX
	 aAduKpcu0rH5Q==
Date: Thu, 10 Oct 2024 17:40:17 -0700
Subject: [PATCH 10/25] xfs: add a xfs_agino_to_ino helper
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860640582.4175438.4915782341207880541.stgit@frogsfrogsfrogs>
In-Reply-To: <172860640343.4175438.4901957495273325461.stgit@frogsfrogsfrogs>
References: <172860640343.4175438.4901957495273325461.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Add a helpers to convert an agino to an ino based on a pag structure.

This provides a simpler conversion and better type safety compared to the
existing code that passes the mount structure and the agno separately.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.h         |    8 ++++++++
 fs/xfs/libxfs/xfs_ialloc.c     |   24 +++++++++++-------------
 fs/xfs/scrub/agheader_repair.c |   16 ++++------------
 fs/xfs/scrub/common.c          |    2 +-
 fs/xfs/scrub/ialloc.c          |    3 +--
 fs/xfs/scrub/ialloc_repair.c   |    6 ++----
 fs/xfs/xfs_inode.c             |    5 ++---
 fs/xfs/xfs_iwalk.c             |   12 ++++++------
 fs/xfs/xfs_log_recover.c       |    5 ++---
 9 files changed, 37 insertions(+), 44 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index e8ed5a33caea0a..ef1f532673ea86 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -345,4 +345,12 @@ xfs_agbno_to_daddr(
 	return XFS_AGB_TO_DADDR(pag->pag_mount, pag->pag_agno, agbno);
 }
 
+static inline xfs_ino_t
+xfs_agino_to_ino(
+	struct xfs_perag	*pag,
+	xfs_agino_t		agino)
+{
+	return XFS_AGINO_TO_INO(pag->pag_mount, pag->pag_agno, agino);
+}
+
 #endif /* __LIBXFS_AG_H */
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 6deb8346d1c34b..c072317a0fe514 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -914,8 +914,7 @@ xfs_ialloc_ag_alloc(
 		if (error == -EFSCORRUPTED) {
 			xfs_alert(args.mp,
 	"invalid sparse inode record: ino 0x%llx holemask 0x%x count %u",
-				  XFS_AGINO_TO_INO(args.mp, pag->pag_agno,
-						   rec.ir_startino),
+				  xfs_agino_to_ino(pag, rec.ir_startino),
 				  rec.ir_holemask, rec.ir_count);
 			xfs_force_shutdown(args.mp, SHUTDOWN_CORRUPT_INCORE);
 		}
@@ -1334,7 +1333,7 @@ xfs_dialloc_ag_inobt(
 	ASSERT(offset < XFS_INODES_PER_CHUNK);
 	ASSERT((XFS_AGINO_TO_OFFSET(mp, rec.ir_startino) %
 				   XFS_INODES_PER_CHUNK) == 0);
-	ino = XFS_AGINO_TO_INO(mp, pag->pag_agno, rec.ir_startino + offset);
+	ino = xfs_agino_to_ino(pag, rec.ir_startino + offset);
 
 	if (xfs_ag_has_sickness(pag, XFS_SICK_AG_INODES)) {
 		error = xfs_dialloc_check_ino(pag, tp, ino);
@@ -1615,7 +1614,7 @@ xfs_dialloc_ag(
 	ASSERT(offset < XFS_INODES_PER_CHUNK);
 	ASSERT((XFS_AGINO_TO_OFFSET(mp, rec.ir_startino) %
 				   XFS_INODES_PER_CHUNK) == 0);
-	ino = XFS_AGINO_TO_INO(mp, pag->pag_agno, rec.ir_startino + offset);
+	ino = xfs_agino_to_ino(pag, rec.ir_startino + offset);
 
 	if (xfs_ag_has_sickness(pag, XFS_SICK_AG_INODES)) {
 		error = xfs_dialloc_check_ino(pag, tp, ino);
@@ -2122,8 +2121,7 @@ xfs_difree_inobt(
 	if (!xfs_has_ikeep(mp) && rec.ir_free == XFS_INOBT_ALL_FREE &&
 	    mp->m_sb.sb_inopblock <= XFS_INODES_PER_CHUNK) {
 		xic->deleted = true;
-		xic->first_ino = XFS_AGINO_TO_INO(mp, pag->pag_agno,
-				rec.ir_startino);
+		xic->first_ino = xfs_agino_to_ino(pag, rec.ir_startino);
 		xic->alloc = xfs_inobt_irec_to_allocmask(&rec);
 
 		/*
@@ -2322,10 +2320,10 @@ xfs_difree(
 		return -EINVAL;
 	}
 	agino = XFS_INO_TO_AGINO(mp, inode);
-	if (inode != XFS_AGINO_TO_INO(mp, pag->pag_agno, agino))  {
-		xfs_warn(mp, "%s: inode != XFS_AGINO_TO_INO() (%llu != %llu).",
+	if (inode != xfs_agino_to_ino(pag, agino))  {
+		xfs_warn(mp, "%s: inode != xfs_agino_to_ino() (%llu != %llu).",
 			__func__, (unsigned long long)inode,
-			(unsigned long long)XFS_AGINO_TO_INO(mp, pag->pag_agno, agino));
+			(unsigned long long)xfs_agino_to_ino(pag, agino));
 		ASSERT(0);
 		return -EINVAL;
 	}
@@ -2456,7 +2454,7 @@ xfs_imap(
 	agino = XFS_INO_TO_AGINO(mp, ino);
 	agbno = XFS_AGINO_TO_AGBNO(mp, agino);
 	if (agbno >= mp->m_sb.sb_agblocks ||
-	    ino != XFS_AGINO_TO_INO(mp, pag->pag_agno, agino)) {
+	    ino != xfs_agino_to_ino(pag, agino)) {
 		error = -EINVAL;
 #ifdef DEBUG
 		/*
@@ -2471,11 +2469,11 @@ xfs_imap(
 				__func__, (unsigned long long)agbno,
 				(unsigned long)mp->m_sb.sb_agblocks);
 		}
-		if (ino != XFS_AGINO_TO_INO(mp, pag->pag_agno, agino)) {
+		if (ino != xfs_agino_to_ino(pag, agino)) {
 			xfs_alert(mp,
-		"%s: ino (0x%llx) != XFS_AGINO_TO_INO() (0x%llx)",
+		"%s: ino (0x%llx) != xfs_agino_to_ino() (0x%llx)",
 				__func__, ino,
-				XFS_AGINO_TO_INO(mp, pag->pag_agno, agino));
+				xfs_agino_to_ino(pag, agino));
 		}
 		xfs_stack_trace();
 #endif /* DEBUG */
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 2f98d90d7fd66d..82a850eba6c88c 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -1038,12 +1038,10 @@ xrep_iunlink_reload_next(
 {
 	struct xfs_scrub	*sc = ragi->sc;
 	struct xfs_inode	*ip;
-	xfs_ino_t		ino;
 	xfs_agino_t		ret = NULLAGINO;
 	int			error;
 
-	ino = XFS_AGINO_TO_INO(sc->mp, sc->sa.pag->pag_agno, agino);
-	error = xchk_iget(ragi->sc, ino, &ip);
+	error = xchk_iget(ragi->sc, xfs_agino_to_ino(sc->sa.pag, agino), &ip);
 	if (error)
 		return ret;
 
@@ -1278,9 +1276,7 @@ xrep_iunlink_mark_ondisk_rec(
 		 * on because we haven't actually scrubbed the inobt or the
 		 * inodes yet.
 		 */
-		error = xchk_iget(ragi->sc,
-				XFS_AGINO_TO_INO(mp, sc->sa.pag->pag_agno,
-						 agino),
+		error = xchk_iget(ragi->sc, xfs_agino_to_ino(sc->sa.pag, agino),
 				&ip);
 		if (error)
 			continue;
@@ -1539,15 +1535,13 @@ xrep_iunlink_relink_next(
 
 	ip = xfs_iunlink_lookup(pag, agino);
 	if (!ip) {
-		xfs_ino_t	ino;
 		xfs_agino_t	prev_agino;
 
 		/*
 		 * No inode exists in cache.  Load it off the disk so that we
 		 * can reinsert it into the incore unlinked list.
 		 */
-		ino = XFS_AGINO_TO_INO(sc->mp, pag->pag_agno, agino);
-		error = xchk_iget(sc, ino, &ip);
+		error = xchk_iget(sc, xfs_agino_to_ino(pag, agino), &ip);
 		if (error)
 			return -EFSCORRUPTED;
 
@@ -1601,15 +1595,13 @@ xrep_iunlink_relink_prev(
 
 	ip = xfs_iunlink_lookup(pag, agino);
 	if (!ip) {
-		xfs_ino_t	ino;
 		xfs_agino_t	next_agino;
 
 		/*
 		 * No inode exists in cache.  Load it off the disk so that we
 		 * can reinsert it into the incore unlinked list.
 		 */
-		ino = XFS_AGINO_TO_INO(sc->mp, pag->pag_agno, agino);
-		error = xchk_iget(sc, ino, &ip);
+		error = xchk_iget(sc, xfs_agino_to_ino(pag, agino), &ip);
 		if (error)
 			return -EFSCORRUPTED;
 
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 22f5f1a9d3f09b..28095ed490fbf6 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -1336,7 +1336,7 @@ xchk_inode_is_allocated(
 	}
 
 	/* reject inode numbers outside existing AGs */
-	ino = XFS_AGINO_TO_INO(sc->mp, pag->pag_agno, agino);
+	ino = xfs_agino_to_ino(pag, agino);
 	if (!xfs_verify_ino(mp, ino))
 		return -EINVAL;
 
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index 26938b90d22efc..c1c798076d66ab 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -303,7 +303,6 @@ xchk_iallocbt_check_cluster_ifree(
 	unsigned int			irec_ino,
 	struct xfs_dinode		*dip)
 {
-	struct xfs_mount		*mp = bs->cur->bc_mp;
 	xfs_ino_t			fsino;
 	xfs_agino_t			agino;
 	bool				irec_free;
@@ -319,7 +318,7 @@ xchk_iallocbt_check_cluster_ifree(
 	 * the record, compute which fs inode we're talking about.
 	 */
 	agino = irec->ir_startino + irec_ino;
-	fsino = XFS_AGINO_TO_INO(mp, bs->cur->bc_ag.pag->pag_agno, agino);
+	fsino = xfs_agino_to_ino(bs->cur->bc_ag.pag, agino);
 	irec_free = (irec->ir_free & XFS_INOBT_MASK(irec_ino));
 
 	if (be16_to_cpu(dip->di_magic) != XFS_DINODE_MAGIC ||
diff --git a/fs/xfs/scrub/ialloc_repair.c b/fs/xfs/scrub/ialloc_repair.c
index 7e9a4062a1c048..98e0ee46375dab 100644
--- a/fs/xfs/scrub/ialloc_repair.c
+++ b/fs/xfs/scrub/ialloc_repair.c
@@ -146,15 +146,12 @@ xrep_ibt_check_ifree(
 	struct xfs_scrub	*sc = ri->sc;
 	struct xfs_mount	*mp = sc->mp;
 	struct xfs_dinode	*dip;
-	xfs_ino_t		fsino;
 	xfs_agino_t		agino;
-	xfs_agnumber_t		agno = ri->sc->sa.pag->pag_agno;
 	unsigned int		cluster_buf_base;
 	unsigned int		offset;
 	int			error;
 
 	agino = cluster_ag_base + cluster_index;
-	fsino = XFS_AGINO_TO_INO(mp, agno, agino);
 
 	/* Inode uncached or half assembled, read disk buffer */
 	cluster_buf_base = XFS_INO_TO_OFFSET(mp, cluster_ag_base);
@@ -165,7 +162,8 @@ xrep_ibt_check_ifree(
 	if (be16_to_cpu(dip->di_magic) != XFS_DINODE_MAGIC)
 		return -EFSCORRUPTED;
 
-	if (dip->di_version >= 3 && be64_to_cpu(dip->di_ino) != fsino)
+	if (dip->di_version >= 3 &&
+	    be64_to_cpu(dip->di_ino) != xfs_agino_to_ino(ri->sc->sa.pag, agino))
 		return -EFSCORRUPTED;
 
 	/* Will the in-core inode tell us if it's in use? */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index bcc277fc0a83e9..a787dce6e081ce 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1516,7 +1516,6 @@ xfs_iunlink_reload_next(
 	struct xfs_perag	*pag = agibp->b_pag;
 	struct xfs_mount	*mp = pag->pag_mount;
 	struct xfs_inode	*next_ip = NULL;
-	xfs_ino_t		ino;
 	int			error;
 
 	ASSERT(next_agino != NULLAGINO);
@@ -1538,8 +1537,8 @@ xfs_iunlink_reload_next(
 	 * but we'd rather shut down now since we're already running in a weird
 	 * situation.
 	 */
-	ino = XFS_AGINO_TO_INO(mp, pag->pag_agno, next_agino);
-	error = xfs_iget(mp, tp, ino, XFS_IGET_UNTRUSTED, 0, &next_ip);
+	error = xfs_iget(mp, tp, xfs_agino_to_ino(pag, next_agino),
+			XFS_IGET_UNTRUSTED, 0, &next_ip);
 	if (error) {
 		xfs_ag_mark_sick(pag, XFS_SICK_AG_AGI);
 		return error;
diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index 894318886a5670..ab5252f19509a6 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -176,7 +176,6 @@ xfs_iwalk_ag_recs(
 	struct xfs_mount	*mp = iwag->mp;
 	struct xfs_trans	*tp = iwag->tp;
 	struct xfs_perag	*pag = iwag->pag;
-	xfs_ino_t		ino;
 	unsigned int		i, j;
 	int			error;
 
@@ -207,9 +206,10 @@ xfs_iwalk_ag_recs(
 				continue;
 
 			/* Otherwise call our function. */
-			ino = XFS_AGINO_TO_INO(mp, pag->pag_agno,
-						irec->ir_startino + j);
-			error = iwag->iwalk_fn(mp, tp, ino, iwag->data);
+			error = iwag->iwalk_fn(mp, tp,
+					xfs_agino_to_ino(pag,
+						irec->ir_startino + j),
+					iwag->data);
 			if (error)
 				return error;
 		}
@@ -304,7 +304,7 @@ xfs_iwalk_ag_start(
 		return -EFSCORRUPTED;
 	}
 
-	iwag->lastino = XFS_AGINO_TO_INO(mp, pag->pag_agno,
+	iwag->lastino = xfs_agino_to_ino(pag,
 				irec->ir_startino + XFS_INODES_PER_CHUNK - 1);
 
 	/*
@@ -424,7 +424,7 @@ xfs_iwalk_ag(
 			break;
 
 		/* Make sure that we always move forward. */
-		rec_fsino = XFS_AGINO_TO_INO(mp, pag->pag_agno, irec->ir_startino);
+		rec_fsino = xfs_agino_to_ino(pag, irec->ir_startino);
 		if (iwag->lastino != NULLFSINO &&
 		    XFS_IS_CORRUPT(mp, iwag->lastino >= rec_fsino)) {
 			xfs_btree_mark_sick(cur);
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 6a165ca55da1a8..58f5e194266c7c 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2726,9 +2726,8 @@ xlog_recover_iunlink_bucket(
 
 	agino = be32_to_cpu(agi->agi_unlinked[bucket]);
 	while (agino != NULLAGINO) {
-		error = xfs_iget(mp, NULL,
-				XFS_AGINO_TO_INO(mp, pag->pag_agno, agino),
-				0, 0, &ip);
+		error = xfs_iget(mp, NULL, xfs_agino_to_ino(pag, agino), 0, 0,
+				&ip);
 		if (error)
 			break;
 


