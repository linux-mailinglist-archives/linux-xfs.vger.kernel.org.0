Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 064041F28FF
	for <lists+linux-xfs@lfdr.de>; Tue,  9 Jun 2020 02:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731263AbgFHXWK (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 8 Jun 2020 19:22:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:46494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731258AbgFHXWG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Jun 2020 19:22:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E2902072F;
        Mon,  8 Jun 2020 23:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658526;
        bh=nAqE/UkC7AZepCdaZzWVyYxfV3/Td4rE4o2tcZbMb5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lBPoYGhIYT3ktTR4WvKzGX9GGMPwv6gLHHJbbNVXYXme+zhhLZ53FzQx0GVF9ERTH
         zwh6M9NW3ebRrtI2mH5wShMWBLlgqRaB8zhMjzrrWum5w9dFnFO5kSt21MTMqu9dHW
         r1VwcnDTTYNR+sUOaqLplSacWJgoWP0cinPQlXFY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>,
        Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-xfs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 151/175] xfs: gut error handling in xfs_trans_unreserve_and_mod_sb()
Date:   Mon,  8 Jun 2020 19:18:24 -0400
Message-Id: <20200608231848.3366970-151-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231848.3366970-1-sashal@kernel.org>
References: <20200608231848.3366970-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <david@fromorbit.com>

[ Upstream commit dc3ffbb14060c943469d5e12900db3a60bc3fa64 ]

xfs: gut error handling in xfs_trans_unreserve_and_mod_sb()

From: Dave Chinner <dchinner@redhat.com>

The error handling in xfs_trans_unreserve_and_mod_sb() is largely
incorrect - rolling back the changes in the transaction if only one
counter underruns makes all the other counters incorrect. We still
allow the change to proceed and committing the transaction, except
now we have multiple incorrect counters instead of a single
underflow.

Further, we don't actually report the error to the caller, so this
is completely silent except on debug kernels that will assert on
failure before we even get to the rollback code.  Hence this error
handling is broken, untested, and largely unnecessary complexity.

Just remove it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_trans.c | 163 ++++++---------------------------------------
 1 file changed, 20 insertions(+), 143 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index f4795fdb7389..1b053f6b18a9 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -527,57 +527,9 @@ xfs_trans_apply_sb_deltas(
 				  sizeof(sbp->sb_frextents) - 1);
 }
 
-STATIC int
-xfs_sb_mod8(
-	uint8_t			*field,
-	int8_t			delta)
-{
-	int8_t			counter = *field;
-
-	counter += delta;
-	if (counter < 0) {
-		ASSERT(0);
-		return -EINVAL;
-	}
-	*field = counter;
-	return 0;
-}
-
-STATIC int
-xfs_sb_mod32(
-	uint32_t		*field,
-	int32_t			delta)
-{
-	int32_t			counter = *field;
-
-	counter += delta;
-	if (counter < 0) {
-		ASSERT(0);
-		return -EINVAL;
-	}
-	*field = counter;
-	return 0;
-}
-
-STATIC int
-xfs_sb_mod64(
-	uint64_t		*field,
-	int64_t			delta)
-{
-	int64_t			counter = *field;
-
-	counter += delta;
-	if (counter < 0) {
-		ASSERT(0);
-		return -EINVAL;
-	}
-	*field = counter;
-	return 0;
-}
-
 /*
- * xfs_trans_unreserve_and_mod_sb() is called to release unused reservations
- * and apply superblock counter changes to the in-core superblock.  The
+ * xfs_trans_unreserve_and_mod_sb() is called to release unused reservations and
+ * apply superblock counter changes to the in-core superblock.  The
  * t_res_fdblocks_delta and t_res_frextents_delta fields are explicitly NOT
  * applied to the in-core superblock.  The idea is that that has already been
  * done.
@@ -622,20 +574,17 @@ xfs_trans_unreserve_and_mod_sb(
 	/* apply the per-cpu counters */
 	if (blkdelta) {
 		error = xfs_mod_fdblocks(mp, blkdelta, rsvd);
-		if (error)
-			goto out;
+		ASSERT(!error);
 	}
 
 	if (idelta) {
 		error = xfs_mod_icount(mp, idelta);
-		if (error)
-			goto out_undo_fdblocks;
+		ASSERT(!error);
 	}
 
 	if (ifreedelta) {
 		error = xfs_mod_ifree(mp, ifreedelta);
-		if (error)
-			goto out_undo_icount;
+		ASSERT(!error);
 	}
 
 	if (rtxdelta == 0 && !(tp->t_flags & XFS_TRANS_SB_DIRTY))
@@ -643,95 +592,23 @@ xfs_trans_unreserve_and_mod_sb(
 
 	/* apply remaining deltas */
 	spin_lock(&mp->m_sb_lock);
-	if (rtxdelta) {
-		error = xfs_sb_mod64(&mp->m_sb.sb_frextents, rtxdelta);
-		if (error)
-			goto out_undo_ifree;
-	}
-
-	if (tp->t_dblocks_delta != 0) {
-		error = xfs_sb_mod64(&mp->m_sb.sb_dblocks, tp->t_dblocks_delta);
-		if (error)
-			goto out_undo_frextents;
-	}
-	if (tp->t_agcount_delta != 0) {
-		error = xfs_sb_mod32(&mp->m_sb.sb_agcount, tp->t_agcount_delta);
-		if (error)
-			goto out_undo_dblocks;
-	}
-	if (tp->t_imaxpct_delta != 0) {
-		error = xfs_sb_mod8(&mp->m_sb.sb_imax_pct, tp->t_imaxpct_delta);
-		if (error)
-			goto out_undo_agcount;
-	}
-	if (tp->t_rextsize_delta != 0) {
-		error = xfs_sb_mod32(&mp->m_sb.sb_rextsize,
-				     tp->t_rextsize_delta);
-		if (error)
-			goto out_undo_imaxpct;
-	}
-	if (tp->t_rbmblocks_delta != 0) {
-		error = xfs_sb_mod32(&mp->m_sb.sb_rbmblocks,
-				     tp->t_rbmblocks_delta);
-		if (error)
-			goto out_undo_rextsize;
-	}
-	if (tp->t_rblocks_delta != 0) {
-		error = xfs_sb_mod64(&mp->m_sb.sb_rblocks, tp->t_rblocks_delta);
-		if (error)
-			goto out_undo_rbmblocks;
-	}
-	if (tp->t_rextents_delta != 0) {
-		error = xfs_sb_mod64(&mp->m_sb.sb_rextents,
-				     tp->t_rextents_delta);
-		if (error)
-			goto out_undo_rblocks;
-	}
-	if (tp->t_rextslog_delta != 0) {
-		error = xfs_sb_mod8(&mp->m_sb.sb_rextslog,
-				     tp->t_rextslog_delta);
-		if (error)
-			goto out_undo_rextents;
-	}
+	mp->m_sb.sb_frextents += rtxdelta;
+	mp->m_sb.sb_dblocks += tp->t_dblocks_delta;
+	mp->m_sb.sb_agcount += tp->t_agcount_delta;
+	mp->m_sb.sb_imax_pct += tp->t_imaxpct_delta;
+	mp->m_sb.sb_rextsize += tp->t_rextsize_delta;
+	mp->m_sb.sb_rbmblocks += tp->t_rbmblocks_delta;
+	mp->m_sb.sb_rblocks += tp->t_rblocks_delta;
+	mp->m_sb.sb_rextents += tp->t_rextents_delta;
+	mp->m_sb.sb_rextslog += tp->t_rextslog_delta;
 	spin_unlock(&mp->m_sb_lock);
-	return;
 
-out_undo_rextents:
-	if (tp->t_rextents_delta)
-		xfs_sb_mod64(&mp->m_sb.sb_rextents, -tp->t_rextents_delta);
-out_undo_rblocks:
-	if (tp->t_rblocks_delta)
-		xfs_sb_mod64(&mp->m_sb.sb_rblocks, -tp->t_rblocks_delta);
-out_undo_rbmblocks:
-	if (tp->t_rbmblocks_delta)
-		xfs_sb_mod32(&mp->m_sb.sb_rbmblocks, -tp->t_rbmblocks_delta);
-out_undo_rextsize:
-	if (tp->t_rextsize_delta)
-		xfs_sb_mod32(&mp->m_sb.sb_rextsize, -tp->t_rextsize_delta);
-out_undo_imaxpct:
-	if (tp->t_rextsize_delta)
-		xfs_sb_mod8(&mp->m_sb.sb_imax_pct, -tp->t_imaxpct_delta);
-out_undo_agcount:
-	if (tp->t_agcount_delta)
-		xfs_sb_mod32(&mp->m_sb.sb_agcount, -tp->t_agcount_delta);
-out_undo_dblocks:
-	if (tp->t_dblocks_delta)
-		xfs_sb_mod64(&mp->m_sb.sb_dblocks, -tp->t_dblocks_delta);
-out_undo_frextents:
-	if (rtxdelta)
-		xfs_sb_mod64(&mp->m_sb.sb_frextents, -rtxdelta);
-out_undo_ifree:
-	spin_unlock(&mp->m_sb_lock);
-	if (ifreedelta)
-		xfs_mod_ifree(mp, -ifreedelta);
-out_undo_icount:
-	if (idelta)
-		xfs_mod_icount(mp, -idelta);
-out_undo_fdblocks:
-	if (blkdelta)
-		xfs_mod_fdblocks(mp, -blkdelta, rsvd);
-out:
-	ASSERT(error == 0);
+	/*
+	 * Debug checks outside of the spinlock so they don't lock up the
+	 * machine if they fail.
+	 */
+	ASSERT(mp->m_sb.sb_imax_pct >= 0);
+	ASSERT(mp->m_sb.sb_rextslog >= 0);
 	return;
 }
 
-- 
2.25.1

