Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C14E033E8A1
	for <lists+linux-xfs@lfdr.de>; Wed, 17 Mar 2021 05:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbhCQE5p (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 17 Mar 2021 00:57:45 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:33673 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229847AbhCQE5X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 17 Mar 2021 00:57:23 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id A294F105E
        for <linux-xfs@vger.kernel.org>; Wed, 17 Mar 2021 15:57:11 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lMOF3-003R8Y-C0
        for linux-xfs@vger.kernel.org; Wed, 17 Mar 2021 15:57:09 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lMOF3-002jaF-3W
        for linux-xfs@vger.kernel.org; Wed, 17 Mar 2021 15:57:09 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 8/8] xfs: __percpu_counter_compare() inode count debug too expensive
Date:   Wed, 17 Mar 2021 15:57:06 +1100
Message-Id: <20210317045706.651306-9-david@fromorbit.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317045706.651306-1-david@fromorbit.com>
References: <20210317045706.651306-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_d
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=dESyimp9J3IA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=sMu_4l5kZS4VzaOAmzIA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

 - 21.92% __xfs_trans_commit
     - 21.62% xfs_log_commit_cil
	- 11.69% xfs_trans_unreserve_and_mod_sb
	   - 11.58% __percpu_counter_compare
	      - 11.45% __percpu_counter_sum
		 - 10.29% _raw_spin_lock_irqsave
		    - 10.28% do_raw_spin_lock
			 __pv_queued_spin_lock_slowpath

We debated just getting rid of it last time this came up and
there was no real objection to removing it. Now it's the biggest
scalability limitation for debug kernels even on smallish machines,
so let's just get rid of it.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_trans.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index b22a09e9daee..631cca73198f 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -618,19 +618,12 @@ xfs_trans_unreserve_and_mod_sb(
 		ASSERT(!error);
 	}
 
-	if (idelta) {
+	if (idelta)
 		percpu_counter_add_batch(&mp->m_icount, idelta,
 					 XFS_ICOUNT_BATCH);
-		if (idelta < 0)
-			ASSERT(__percpu_counter_compare(&mp->m_icount, 0,
-							XFS_ICOUNT_BATCH) >= 0);
-	}
 
-	if (ifreedelta) {
+	if (ifreedelta)
 		percpu_counter_add(&mp->m_ifree, ifreedelta);
-		if (ifreedelta < 0)
-			ASSERT(percpu_counter_compare(&mp->m_ifree, 0) >= 0);
-	}
 
 	if (rtxdelta == 0 && !(tp->t_flags & XFS_TRANS_SB_DIRTY))
 		return;
-- 
2.30.1

