Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9AA39D04D
	for <lists+linux-xfs@lfdr.de>; Sun,  6 Jun 2021 19:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbhFFR40 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 6 Jun 2021 13:56:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:57952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229474AbhFFR4Z (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 6 Jun 2021 13:56:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD6386136D;
        Sun,  6 Jun 2021 17:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623002075;
        bh=tlEAtTZECabH3JcVOE3DnzIPmjKij0UHofnk6OXQj5w=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Ozo/rXYrArQjYwAKdGB1iskdfZhKjdwLf9JxOVUHF8cBMC/+1ZLbq45f5Q9oWuJB4
         gHjxDAVyvzxrmdLrMrFFlURJfkcKWr6yjhYLsVa/SU+v8/FR8OMnUJsne4ikRHH2QW
         lLmOucJbHRQSM+s8hmZZkFCcbyaGfWj8twTycIt+5gQnx3320W+NkvHyCZBPV5buaG
         sirj3xUfonXU9LrrsnNBvJOfUf0gSH1QrGDGIr9m97hqgxN/OzEbVmnNwfy32vdVGc
         nqJ71ZWEgtZsPicHiSw/YIrQSkwuzSBnT+dFt7ch9t8GXEpVbXiX+XWCAUrhrAZy6T
         dl0URPmuYMmGg==
Subject: [PATCH 2/2] xfs: rename struct xfs_eofblocks to xfs_icwalk
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Sun, 06 Jun 2021 10:54:35 -0700
Message-ID: <162300207545.1202657.10696106148369657206.stgit@locust>
In-Reply-To: <162300206433.1202657.5753685964265403056.stgit@locust>
References: <162300206433.1202657.5753685964265403056.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The xfs_eofblocks structure is no longer well-named -- nowadays it
provides optional filtering criteria to any walk of the incore inode
cache.  Only one of the cache walk goals has anything to do with
clearing of speculative post-EOF preallocations, so change the name to
be more appropriate.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c   |    6 +-
 fs/xfs/xfs_icache.c |  164 ++++++++++++++++++++++++++-------------------------
 fs/xfs/xfs_icache.h |   14 ++--
 fs/xfs/xfs_ioctl.c  |   40 ++++++------
 fs/xfs/xfs_trace.h  |   36 ++++++-----
 5 files changed, 130 insertions(+), 130 deletions(-)


diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index eb39c3777491..9fd5a82a814c 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -773,14 +773,14 @@ xfs_file_buffered_write(
 		cleared_space = true;
 		goto write_retry;
 	} else if (ret == -ENOSPC && !cleared_space) {
-		struct xfs_eofblocks eofb = {0};
+		struct xfs_icwalk	icw = {0};
 
 		cleared_space = true;
 		xfs_flush_inodes(ip->i_mount);
 
 		xfs_iunlock(ip, iolock);
-		eofb.eof_flags = XFS_ICWALK_FLAG_SYNC;
-		xfs_blockgc_free_space(ip->i_mount, &eofb);
+		icw.icw_flags = XFS_ICWALK_FLAG_SYNC;
+		xfs_blockgc_free_space(ip->i_mount, &icw);
 		goto write_retry;
 	}
 
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index ce6ac32a0c29..a2dcf31522db 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -56,13 +56,13 @@ xfs_icwalk_tag(enum xfs_icwalk_goal goal)
 }
 
 static int xfs_icwalk(struct xfs_mount *mp,
-		enum xfs_icwalk_goal goal, struct xfs_eofblocks *eofb);
+		enum xfs_icwalk_goal goal, struct xfs_icwalk *icw);
 static int xfs_icwalk_ag(struct xfs_perag *pag,
-		enum xfs_icwalk_goal goal, struct xfs_eofblocks *eofb);
+		enum xfs_icwalk_goal goal, struct xfs_icwalk *icw);
 
 /*
- * Private inode cache walk flags for struct xfs_eofblocks.  Must not coincide
- * with XFS_ICWALK_FLAGS_VALID.
+ * Private inode cache walk flags for struct xfs_icwalk.  Must not
+ * coincide with XFS_ICWALK_FLAGS_VALID.
  */
 #define XFS_ICWALK_FLAG_DROP_UDQUOT	(1U << 31)
 #define XFS_ICWALK_FLAG_DROP_GDQUOT	(1U << 30)
@@ -848,21 +848,21 @@ xfs_dqrele_igrab(
 static void
 xfs_dqrele_inode(
 	struct xfs_inode	*ip,
-	struct xfs_eofblocks	*eofb)
+	struct xfs_icwalk	*icw)
 {
 	if (xfs_iflags_test(ip, XFS_INEW))
 		xfs_inew_wait(ip);
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	if (eofb->eof_flags & XFS_ICWALK_FLAG_DROP_UDQUOT) {
+	if (icw->icw_flags & XFS_ICWALK_FLAG_DROP_UDQUOT) {
 		xfs_qm_dqrele(ip->i_udquot);
 		ip->i_udquot = NULL;
 	}
-	if (eofb->eof_flags & XFS_ICWALK_FLAG_DROP_GDQUOT) {
+	if (icw->icw_flags & XFS_ICWALK_FLAG_DROP_GDQUOT) {
 		xfs_qm_dqrele(ip->i_gdquot);
 		ip->i_gdquot = NULL;
 	}
-	if (eofb->eof_flags & XFS_ICWALK_FLAG_DROP_PDQUOT) {
+	if (icw->icw_flags & XFS_ICWALK_FLAG_DROP_PDQUOT) {
 		xfs_qm_dqrele(ip->i_pdquot);
 		ip->i_pdquot = NULL;
 	}
@@ -880,16 +880,16 @@ xfs_dqrele_all_inodes(
 	struct xfs_mount	*mp,
 	unsigned int		qflags)
 {
-	struct xfs_eofblocks	eofb = { .eof_flags = 0 };
+	struct xfs_icwalk	icw = { .icw_flags = 0 };
 
 	if (qflags & XFS_UQUOTA_ACCT)
-		eofb.eof_flags |= XFS_ICWALK_FLAG_DROP_UDQUOT;
+		icw.icw_flags |= XFS_ICWALK_FLAG_DROP_UDQUOT;
 	if (qflags & XFS_GQUOTA_ACCT)
-		eofb.eof_flags |= XFS_ICWALK_FLAG_DROP_GDQUOT;
+		icw.icw_flags |= XFS_ICWALK_FLAG_DROP_GDQUOT;
 	if (qflags & XFS_PQUOTA_ACCT)
-		eofb.eof_flags |= XFS_ICWALK_FLAG_DROP_PDQUOT;
+		icw.icw_flags |= XFS_ICWALK_FLAG_DROP_PDQUOT;
 
-	return xfs_icwalk(mp, XFS_ICWALK_DQRELE, &eofb);
+	return xfs_icwalk(mp, XFS_ICWALK_DQRELE, &icw);
 }
 #else
 # define xfs_dqrele_igrab(ip)		(false)
@@ -916,7 +916,7 @@ xfs_dqrele_all_inodes(
 static bool
 xfs_reclaim_igrab(
 	struct xfs_inode	*ip,
-	struct xfs_eofblocks	*eofb)
+	struct xfs_icwalk	*icw)
 {
 	ASSERT(rcu_read_lock_held());
 
@@ -930,7 +930,7 @@ xfs_reclaim_igrab(
 
 	/* Don't reclaim a sick inode unless the caller asked for it. */
 	if (ip->i_sick &&
-	    (!eofb || !(eofb->eof_flags & XFS_ICWALK_FLAG_RECLAIM_SICK))) {
+	    (!icw || !(icw->icw_flags & XFS_ICWALK_FLAG_RECLAIM_SICK))) {
 		spin_unlock(&ip->i_flags_lock);
 		return false;
 	}
@@ -1049,16 +1049,16 @@ void
 xfs_reclaim_inodes(
 	struct xfs_mount	*mp)
 {
-	struct xfs_eofblocks	eofb = {
-		.eof_flags	= 0,
+	struct xfs_icwalk	icw = {
+		.icw_flags	= 0,
 	};
 
 	if (xfs_want_reclaim_sick(mp))
-		eofb.eof_flags |= XFS_ICWALK_FLAG_RECLAIM_SICK;
+		icw.icw_flags |= XFS_ICWALK_FLAG_RECLAIM_SICK;
 
 	while (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_RECLAIM_TAG)) {
 		xfs_ail_push_all_sync(mp->m_ail);
-		xfs_icwalk(mp, XFS_ICWALK_RECLAIM, &eofb);
+		xfs_icwalk(mp, XFS_ICWALK_RECLAIM, &icw);
 	}
 }
 
@@ -1074,19 +1074,19 @@ xfs_reclaim_inodes_nr(
 	struct xfs_mount	*mp,
 	int			nr_to_scan)
 {
-	struct xfs_eofblocks	eofb = {
-		.eof_flags	= XFS_ICWALK_FLAG_SCAN_LIMIT,
+	struct xfs_icwalk	icw = {
+		.icw_flags	= XFS_ICWALK_FLAG_SCAN_LIMIT,
 		.icw_scan_limit	= nr_to_scan,
 	};
 
 	if (xfs_want_reclaim_sick(mp))
-		eofb.eof_flags |= XFS_ICWALK_FLAG_RECLAIM_SICK;
+		icw.icw_flags |= XFS_ICWALK_FLAG_RECLAIM_SICK;
 
 	/* kick background reclaimer and push the AIL */
 	xfs_reclaim_work_queue(mp);
 	xfs_ail_push_all(mp->m_ail);
 
-	xfs_icwalk(mp, XFS_ICWALK_RECLAIM, &eofb);
+	xfs_icwalk(mp, XFS_ICWALK_RECLAIM, &icw);
 	return 0;
 }
 
@@ -1111,20 +1111,20 @@ xfs_reclaim_inodes_count(
 }
 
 STATIC bool
-xfs_inode_match_id(
+xfs_icwalk_match_id(
 	struct xfs_inode	*ip,
-	struct xfs_eofblocks	*eofb)
+	struct xfs_icwalk	*icw)
 {
-	if ((eofb->eof_flags & XFS_ICWALK_FLAG_UID) &&
-	    !uid_eq(VFS_I(ip)->i_uid, eofb->eof_uid))
+	if ((icw->icw_flags & XFS_ICWALK_FLAG_UID) &&
+	    !uid_eq(VFS_I(ip)->i_uid, icw->icw_uid))
 		return false;
 
-	if ((eofb->eof_flags & XFS_ICWALK_FLAG_GID) &&
-	    !gid_eq(VFS_I(ip)->i_gid, eofb->eof_gid))
+	if ((icw->icw_flags & XFS_ICWALK_FLAG_GID) &&
+	    !gid_eq(VFS_I(ip)->i_gid, icw->icw_gid))
 		return false;
 
-	if ((eofb->eof_flags & XFS_ICWALK_FLAG_PRID) &&
-	    ip->i_projid != eofb->eof_prid)
+	if ((icw->icw_flags & XFS_ICWALK_FLAG_PRID) &&
+	    ip->i_projid != icw->icw_prid)
 		return false;
 
 	return true;
@@ -1135,20 +1135,20 @@ xfs_inode_match_id(
  * criteria match. This is for global/internal scans only.
  */
 STATIC bool
-xfs_inode_match_id_union(
+xfs_icwalk_match_id_union(
 	struct xfs_inode	*ip,
-	struct xfs_eofblocks	*eofb)
+	struct xfs_icwalk	*icw)
 {
-	if ((eofb->eof_flags & XFS_ICWALK_FLAG_UID) &&
-	    uid_eq(VFS_I(ip)->i_uid, eofb->eof_uid))
+	if ((icw->icw_flags & XFS_ICWALK_FLAG_UID) &&
+	    uid_eq(VFS_I(ip)->i_uid, icw->icw_uid))
 		return true;
 
-	if ((eofb->eof_flags & XFS_ICWALK_FLAG_GID) &&
-	    gid_eq(VFS_I(ip)->i_gid, eofb->eof_gid))
+	if ((icw->icw_flags & XFS_ICWALK_FLAG_GID) &&
+	    gid_eq(VFS_I(ip)->i_gid, icw->icw_gid))
 		return true;
 
-	if ((eofb->eof_flags & XFS_ICWALK_FLAG_PRID) &&
-	    ip->i_projid == eofb->eof_prid)
+	if ((icw->icw_flags & XFS_ICWALK_FLAG_PRID) &&
+	    ip->i_projid == icw->icw_prid)
 		return true;
 
 	return false;
@@ -1156,29 +1156,29 @@ xfs_inode_match_id_union(
 
 /*
  * Is this inode @ip eligible for eof/cow block reclamation, given some
- * filtering parameters @eofb?  The inode is eligible if @eofb is null or
+ * filtering parameters @icw?  The inode is eligible if @icw is null or
  * if the predicate functions match.
  */
 static bool
-xfs_inode_matches_eofb(
+xfs_icwalk_match(
 	struct xfs_inode	*ip,
-	struct xfs_eofblocks	*eofb)
+	struct xfs_icwalk	*icw)
 {
 	bool			match;
 
-	if (!eofb)
+	if (!icw)
 		return true;
 
-	if (eofb->eof_flags & XFS_ICWALK_FLAG_UNION)
-		match = xfs_inode_match_id_union(ip, eofb);
+	if (icw->icw_flags & XFS_ICWALK_FLAG_UNION)
+		match = xfs_icwalk_match_id_union(ip, icw);
 	else
-		match = xfs_inode_match_id(ip, eofb);
+		match = xfs_icwalk_match_id(ip, icw);
 	if (!match)
 		return false;
 
 	/* skip the inode if the file size is too small */
-	if ((eofb->eof_flags & XFS_ICWALK_FLAG_MINFILESIZE) &&
-	    XFS_ISIZE(ip) < eofb->eof_min_file_size)
+	if ((icw->icw_flags & XFS_ICWALK_FLAG_MINFILESIZE) &&
+	    XFS_ISIZE(ip) < icw->icw_min_file_size)
 		return false;
 
 	return true;
@@ -1204,12 +1204,12 @@ xfs_reclaim_worker(
 STATIC int
 xfs_inode_free_eofblocks(
 	struct xfs_inode	*ip,
-	struct xfs_eofblocks	*eofb,
+	struct xfs_icwalk	*icw,
 	unsigned int		*lockflags)
 {
 	bool			wait;
 
-	wait = eofb && (eofb->eof_flags & XFS_ICWALK_FLAG_SYNC);
+	wait = icw && (icw->icw_flags & XFS_ICWALK_FLAG_SYNC);
 
 	if (!xfs_iflags_test(ip, XFS_IEOFBLOCKS))
 		return 0;
@@ -1221,7 +1221,7 @@ xfs_inode_free_eofblocks(
 	if (!wait && mapping_tagged(VFS_I(ip)->i_mapping, PAGECACHE_TAG_DIRTY))
 		return 0;
 
-	if (!xfs_inode_matches_eofb(ip, eofb))
+	if (!xfs_icwalk_match(ip, icw))
 		return 0;
 
 	/*
@@ -1366,13 +1366,13 @@ xfs_prep_free_cowblocks(
 STATIC int
 xfs_inode_free_cowblocks(
 	struct xfs_inode	*ip,
-	struct xfs_eofblocks	*eofb,
+	struct xfs_icwalk	*icw,
 	unsigned int		*lockflags)
 {
 	bool			wait;
 	int			ret = 0;
 
-	wait = eofb && (eofb->eof_flags & XFS_ICWALK_FLAG_SYNC);
+	wait = icw && (icw->icw_flags & XFS_ICWALK_FLAG_SYNC);
 
 	if (!xfs_iflags_test(ip, XFS_ICOWBLOCKS))
 		return 0;
@@ -1380,7 +1380,7 @@ xfs_inode_free_cowblocks(
 	if (!xfs_prep_free_cowblocks(ip))
 		return 0;
 
-	if (!xfs_inode_matches_eofb(ip, eofb))
+	if (!xfs_icwalk_match(ip, icw))
 		return 0;
 
 	/*
@@ -1505,16 +1505,16 @@ xfs_blockgc_igrab(
 static int
 xfs_blockgc_scan_inode(
 	struct xfs_inode	*ip,
-	struct xfs_eofblocks	*eofb)
+	struct xfs_icwalk	*icw)
 {
 	unsigned int		lockflags = 0;
 	int			error;
 
-	error = xfs_inode_free_eofblocks(ip, eofb, &lockflags);
+	error = xfs_inode_free_eofblocks(ip, icw, &lockflags);
 	if (error)
 		goto unlock;
 
-	error = xfs_inode_free_cowblocks(ip, eofb, &lockflags);
+	error = xfs_inode_free_cowblocks(ip, icw, &lockflags);
 unlock:
 	if (lockflags)
 		xfs_iunlock(ip, lockflags);
@@ -1548,11 +1548,11 @@ xfs_blockgc_worker(
 int
 xfs_blockgc_free_space(
 	struct xfs_mount	*mp,
-	struct xfs_eofblocks	*eofb)
+	struct xfs_icwalk	*icw)
 {
-	trace_xfs_blockgc_free_space(mp, eofb, _RET_IP_);
+	trace_xfs_blockgc_free_space(mp, icw, _RET_IP_);
 
-	return xfs_icwalk(mp, XFS_ICWALK_BLOCKGC, eofb);
+	return xfs_icwalk(mp, XFS_ICWALK_BLOCKGC, icw);
 }
 
 /*
@@ -1573,7 +1573,7 @@ xfs_blockgc_free_dquots(
 	struct xfs_dquot	*pdqp,
 	unsigned int		iwalk_flags)
 {
-	struct xfs_eofblocks	eofb = {0};
+	struct xfs_icwalk	icw = {0};
 	bool			do_work = false;
 
 	if (!udqp && !gdqp && !pdqp)
@@ -1583,30 +1583,30 @@ xfs_blockgc_free_dquots(
 	 * Run a scan to free blocks using the union filter to cover all
 	 * applicable quotas in a single scan.
 	 */
-	eofb.eof_flags = XFS_ICWALK_FLAG_UNION | iwalk_flags;
+	icw.icw_flags = XFS_ICWALK_FLAG_UNION | iwalk_flags;
 
 	if (XFS_IS_UQUOTA_ENFORCED(mp) && udqp && xfs_dquot_lowsp(udqp)) {
-		eofb.eof_uid = make_kuid(mp->m_super->s_user_ns, udqp->q_id);
-		eofb.eof_flags |= XFS_ICWALK_FLAG_UID;
+		icw.icw_uid = make_kuid(mp->m_super->s_user_ns, udqp->q_id);
+		icw.icw_flags |= XFS_ICWALK_FLAG_UID;
 		do_work = true;
 	}
 
 	if (XFS_IS_UQUOTA_ENFORCED(mp) && gdqp && xfs_dquot_lowsp(gdqp)) {
-		eofb.eof_gid = make_kgid(mp->m_super->s_user_ns, gdqp->q_id);
-		eofb.eof_flags |= XFS_ICWALK_FLAG_GID;
+		icw.icw_gid = make_kgid(mp->m_super->s_user_ns, gdqp->q_id);
+		icw.icw_flags |= XFS_ICWALK_FLAG_GID;
 		do_work = true;
 	}
 
 	if (XFS_IS_PQUOTA_ENFORCED(mp) && pdqp && xfs_dquot_lowsp(pdqp)) {
-		eofb.eof_prid = pdqp->q_id;
-		eofb.eof_flags |= XFS_ICWALK_FLAG_PRID;
+		icw.icw_prid = pdqp->q_id;
+		icw.icw_flags |= XFS_ICWALK_FLAG_PRID;
 		do_work = true;
 	}
 
 	if (!do_work)
 		return 0;
 
-	return xfs_blockgc_free_space(mp, &eofb);
+	return xfs_blockgc_free_space(mp, &icw);
 }
 
 /* Run cow/eofblocks scans on the quotas attached to the inode. */
@@ -1640,7 +1640,7 @@ static inline bool
 xfs_icwalk_igrab(
 	enum xfs_icwalk_goal	goal,
 	struct xfs_inode	*ip,
-	struct xfs_eofblocks	*eofb)
+	struct xfs_icwalk	*icw)
 {
 	switch (goal) {
 	case XFS_ICWALK_DQRELE:
@@ -1648,7 +1648,7 @@ xfs_icwalk_igrab(
 	case XFS_ICWALK_BLOCKGC:
 		return xfs_blockgc_igrab(ip);
 	case XFS_ICWALK_RECLAIM:
-		return xfs_reclaim_igrab(ip, eofb);
+		return xfs_reclaim_igrab(ip, icw);
 	default:
 		return false;
 	}
@@ -1663,16 +1663,16 @@ xfs_icwalk_process_inode(
 	enum xfs_icwalk_goal	goal,
 	struct xfs_inode	*ip,
 	struct xfs_perag	*pag,
-	struct xfs_eofblocks	*eofb)
+	struct xfs_icwalk	*icw)
 {
 	int			error = 0;
 
 	switch (goal) {
 	case XFS_ICWALK_DQRELE:
-		xfs_dqrele_inode(ip, eofb);
+		xfs_dqrele_inode(ip, icw);
 		break;
 	case XFS_ICWALK_BLOCKGC:
-		error = xfs_blockgc_scan_inode(ip, eofb);
+		error = xfs_blockgc_scan_inode(ip, icw);
 		break;
 	case XFS_ICWALK_RECLAIM:
 		xfs_reclaim_inode(ip, pag);
@@ -1689,7 +1689,7 @@ static int
 xfs_icwalk_ag(
 	struct xfs_perag	*pag,
 	enum xfs_icwalk_goal	goal,
-	struct xfs_eofblocks	*eofb)
+	struct xfs_icwalk	*icw)
 {
 	struct xfs_mount	*mp = pag->pag_mount;
 	uint32_t		first_index;
@@ -1737,7 +1737,7 @@ xfs_icwalk_ag(
 		for (i = 0; i < nr_found; i++) {
 			struct xfs_inode *ip = batch[i];
 
-			if (done || !xfs_icwalk_igrab(goal, ip, eofb))
+			if (done || !xfs_icwalk_igrab(goal, ip, icw))
 				batch[i] = NULL;
 
 			/*
@@ -1766,7 +1766,7 @@ xfs_icwalk_ag(
 			if (!batch[i])
 				continue;
 			error = xfs_icwalk_process_inode(goal, batch[i], pag,
-					eofb);
+					icw);
 			if (error == -EAGAIN) {
 				skipped++;
 				continue;
@@ -1781,9 +1781,9 @@ xfs_icwalk_ag(
 
 		cond_resched();
 
-		if (eofb && (eofb->eof_flags & XFS_ICWALK_FLAG_SCAN_LIMIT)) {
-			eofb->icw_scan_limit -= XFS_LOOKUP_BATCH;
-			if (eofb->icw_scan_limit <= 0)
+		if (icw && (icw->icw_flags & XFS_ICWALK_FLAG_SCAN_LIMIT)) {
+			icw->icw_scan_limit -= XFS_LOOKUP_BATCH;
+			if (icw->icw_scan_limit <= 0)
 				break;
 		}
 	} while (nr_found && !done);
@@ -1820,7 +1820,7 @@ static int
 xfs_icwalk(
 	struct xfs_mount	*mp,
 	enum xfs_icwalk_goal	goal,
-	struct xfs_eofblocks	*eofb)
+	struct xfs_icwalk	*icw)
 {
 	struct xfs_perag	*pag;
 	int			error = 0;
@@ -1829,7 +1829,7 @@ xfs_icwalk(
 
 	while ((pag = xfs_icwalk_get_perag(mp, agno, goal))) {
 		agno = pag->pag_agno + 1;
-		error = xfs_icwalk_ag(pag, goal, eofb);
+		error = xfs_icwalk_ag(pag, goal, icw);
 		xfs_perag_put(pag);
 		if (error) {
 			last_error = error;
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index b29048c493b6..00dc98a92835 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -9,12 +9,12 @@
 struct xfs_mount;
 struct xfs_perag;
 
-struct xfs_eofblocks {
-	__u32		eof_flags;
-	kuid_t		eof_uid;
-	kgid_t		eof_gid;
-	prid_t		eof_prid;
-	__u64		eof_min_file_size;
+struct xfs_icwalk {
+	__u32		icw_flags;
+	kuid_t		icw_uid;
+	kgid_t		icw_gid;
+	prid_t		icw_prid;
+	__u64		icw_min_file_size;
 	int		icw_scan_limit;
 };
 
@@ -58,7 +58,7 @@ int xfs_blockgc_free_dquots(struct xfs_mount *mp, struct xfs_dquot *udqp,
 		struct xfs_dquot *gdqp, struct xfs_dquot *pdqp,
 		unsigned int iwalk_flags);
 int xfs_blockgc_free_quota(struct xfs_inode *ip, unsigned int iwalk_flags);
-int xfs_blockgc_free_space(struct xfs_mount *mp, struct xfs_eofblocks *eofb);
+int xfs_blockgc_free_space(struct xfs_mount *mp, struct xfs_icwalk *icm);
 
 void xfs_inode_set_eofblocks_tag(struct xfs_inode *ip);
 void xfs_inode_clear_eofblocks_tag(struct xfs_inode *ip);
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index c6450fd059f1..0f6794333b01 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1875,7 +1875,7 @@ xfs_ioc_setlabel(
 static inline int
 xfs_fs_eofblocks_from_user(
 	struct xfs_fs_eofblocks		*src,
-	struct xfs_eofblocks		*dst)
+	struct xfs_icwalk		*dst)
 {
 	if (src->eof_version != XFS_EOFBLOCKS_VERSION)
 		return -EINVAL;
@@ -1887,32 +1887,32 @@ xfs_fs_eofblocks_from_user(
 	    memchr_inv(src->pad64, 0, sizeof(src->pad64)))
 		return -EINVAL;
 
-	dst->eof_flags = 0;
+	dst->icw_flags = 0;
 	if (src->eof_flags & XFS_EOF_FLAGS_SYNC)
-		dst->eof_flags |= XFS_ICWALK_FLAG_SYNC;
+		dst->icw_flags |= XFS_ICWALK_FLAG_SYNC;
 	if (src->eof_flags & XFS_EOF_FLAGS_UID)
-		dst->eof_flags |= XFS_ICWALK_FLAG_UID;
+		dst->icw_flags |= XFS_ICWALK_FLAG_UID;
 	if (src->eof_flags & XFS_EOF_FLAGS_GID)
-		dst->eof_flags |= XFS_ICWALK_FLAG_GID;
+		dst->icw_flags |= XFS_ICWALK_FLAG_GID;
 	if (src->eof_flags & XFS_EOF_FLAGS_PRID)
-		dst->eof_flags |= XFS_ICWALK_FLAG_PRID;
+		dst->icw_flags |= XFS_ICWALK_FLAG_PRID;
 	if (src->eof_flags & XFS_EOF_FLAGS_MINFILESIZE)
-		dst->eof_flags |= XFS_ICWALK_FLAG_MINFILESIZE;
+		dst->icw_flags |= XFS_ICWALK_FLAG_MINFILESIZE;
 
-	dst->eof_prid = src->eof_prid;
-	dst->eof_min_file_size = src->eof_min_file_size;
+	dst->icw_prid = src->eof_prid;
+	dst->icw_min_file_size = src->eof_min_file_size;
 
-	dst->eof_uid = INVALID_UID;
+	dst->icw_uid = INVALID_UID;
 	if (src->eof_flags & XFS_EOF_FLAGS_UID) {
-		dst->eof_uid = make_kuid(current_user_ns(), src->eof_uid);
-		if (!uid_valid(dst->eof_uid))
+		dst->icw_uid = make_kuid(current_user_ns(), src->eof_uid);
+		if (!uid_valid(dst->icw_uid))
 			return -EINVAL;
 	}
 
-	dst->eof_gid = INVALID_GID;
+	dst->icw_gid = INVALID_GID;
 	if (src->eof_flags & XFS_EOF_FLAGS_GID) {
-		dst->eof_gid = make_kgid(current_user_ns(), src->eof_gid);
-		if (!gid_valid(dst->eof_gid))
+		dst->icw_gid = make_kgid(current_user_ns(), src->eof_gid);
+		if (!gid_valid(dst->icw_gid))
 			return -EINVAL;
 	}
 	return 0;
@@ -2175,8 +2175,8 @@ xfs_file_ioctl(
 		return xfs_errortag_clearall(mp);
 
 	case XFS_IOC_FREE_EOFBLOCKS: {
-		struct xfs_fs_eofblocks eofb;
-		struct xfs_eofblocks keofb;
+		struct xfs_fs_eofblocks	eofb;
+		struct xfs_icwalk	icw;
 
 		if (!capable(CAP_SYS_ADMIN))
 			return -EPERM;
@@ -2187,14 +2187,14 @@ xfs_file_ioctl(
 		if (copy_from_user(&eofb, arg, sizeof(eofb)))
 			return -EFAULT;
 
-		error = xfs_fs_eofblocks_from_user(&eofb, &keofb);
+		error = xfs_fs_eofblocks_from_user(&eofb, &icw);
 		if (error)
 			return error;
 
-		trace_xfs_ioc_free_eofblocks(mp, &keofb, _RET_IP_);
+		trace_xfs_ioc_free_eofblocks(mp, &icw, _RET_IP_);
 
 		sb_start_write(mp->m_super);
-		error = xfs_blockgc_free_space(mp, &keofb);
+		error = xfs_blockgc_free_space(mp, &icw);
 		sb_end_write(mp->m_super);
 		return error;
 	}
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 0171d93239a2..f5b241b23941 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -37,7 +37,7 @@ struct xfs_trans_res;
 struct xfs_inobt_rec_incore;
 union xfs_btree_ptr;
 struct xfs_dqtrx;
-struct xfs_eofblocks;
+struct xfs_icwalk;
 
 #define XFS_ATTR_FILTER_FLAGS \
 	{ XFS_ATTR_ROOT,	"ROOT" }, \
@@ -3885,10 +3885,10 @@ DEFINE_EVENT(xfs_timestamp_range_class, name, \
 DEFINE_TIMESTAMP_RANGE_EVENT(xfs_inode_timestamp_range);
 DEFINE_TIMESTAMP_RANGE_EVENT(xfs_quota_expiry_range);
 
-DECLARE_EVENT_CLASS(xfs_eofblocks_class,
-	TP_PROTO(struct xfs_mount *mp, struct xfs_eofblocks *eofb,
+DECLARE_EVENT_CLASS(xfs_icwalk_class,
+	TP_PROTO(struct xfs_mount *mp, struct xfs_icwalk *icw,
 		 unsigned long caller_ip),
-	TP_ARGS(mp, eofb, caller_ip),
+	TP_ARGS(mp, icw, caller_ip),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(__u32, flags)
@@ -3901,14 +3901,14 @@ DECLARE_EVENT_CLASS(xfs_eofblocks_class,
 	),
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
-		__entry->flags = eofb ? eofb->eof_flags : 0;
-		__entry->uid = eofb ? from_kuid(mp->m_super->s_user_ns,
-						eofb->eof_uid) : 0;
-		__entry->gid = eofb ? from_kgid(mp->m_super->s_user_ns,
-						eofb->eof_gid) : 0;
-		__entry->prid = eofb ? eofb->eof_prid : 0;
-		__entry->min_file_size = eofb ? eofb->eof_min_file_size : 0;
-		__entry->scan_limit = eofb ? eofb->icw_scan_limit : 0;
+		__entry->flags = icw ? icw->icw_flags : 0;
+		__entry->uid = icw ? from_kuid(mp->m_super->s_user_ns,
+						icw->icw_uid) : 0;
+		__entry->gid = icw ? from_kgid(mp->m_super->s_user_ns,
+						icw->icw_gid) : 0;
+		__entry->prid = icw ? icw->icw_prid : 0;
+		__entry->min_file_size = icw ? icw->icw_min_file_size : 0;
+		__entry->scan_limit = icw ? icw->icw_scan_limit : 0;
 		__entry->caller_ip = caller_ip;
 	),
 	TP_printk("dev %d:%d flags 0x%x uid %u gid %u prid %u minsize %llu scan_limit %d caller %pS",
@@ -3921,13 +3921,13 @@ DECLARE_EVENT_CLASS(xfs_eofblocks_class,
 		  __entry->scan_limit,
 		  (char *)__entry->caller_ip)
 );
-#define DEFINE_EOFBLOCKS_EVENT(name)	\
-DEFINE_EVENT(xfs_eofblocks_class, name,	\
-	TP_PROTO(struct xfs_mount *mp, struct xfs_eofblocks *eofb, \
+#define DEFINE_ICWALK_EVENT(name)	\
+DEFINE_EVENT(xfs_icwalk_class, name,	\
+	TP_PROTO(struct xfs_mount *mp, struct xfs_icwalk *icw, \
 		 unsigned long caller_ip), \
-	TP_ARGS(mp, eofb, caller_ip))
-DEFINE_EOFBLOCKS_EVENT(xfs_ioc_free_eofblocks);
-DEFINE_EOFBLOCKS_EVENT(xfs_blockgc_free_space);
+	TP_ARGS(mp, icw, caller_ip))
+DEFINE_ICWALK_EVENT(xfs_ioc_free_eofblocks);
+DEFINE_ICWALK_EVENT(xfs_blockgc_free_space);
 
 #endif /* _TRACE_XFS_H */
 

