Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFCBA44A454
	for <lists+linux-xfs@lfdr.de>; Tue,  9 Nov 2021 02:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241478AbhKIBze (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 8 Nov 2021 20:55:34 -0500
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:58520 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241524AbhKIBzc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Nov 2021 20:55:32 -0500
Received: from dread.disaster.area (pa49-195-103-97.pa.nsw.optusnet.com.au [49.195.103.97])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id B171946CA62
        for <linux-xfs@vger.kernel.org>; Tue,  9 Nov 2021 12:52:44 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mkGJY-006ZaC-2z
        for linux-xfs@vger.kernel.org; Tue, 09 Nov 2021 12:52:44 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1mkGJY-006Uik-1J
        for linux-xfs@vger.kernel.org;
        Tue, 09 Nov 2021 12:52:44 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 07/14] xfs: convert CIL busy extents to per-cpu
Date:   Tue,  9 Nov 2021 12:52:33 +1100
Message-Id: <20211109015240.1547991-8-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109015240.1547991-1-david@fromorbit.com>
References: <20211109015240.1547991-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6189d46c
        a=fP9RlOTWD4uZJjPSFnn6Ew==:117 a=fP9RlOTWD4uZJjPSFnn6Ew==:17
        a=vIxV3rELxO4A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=vUsicihHAahmRoZZVqUA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

To get them out from under the CIL lock.

This is an unordered list, so we can simply punt it to per-cpu lists
during transaction commits and reaggregate it back into a single
list during the CIL push work.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log_cil.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 74717bdd992b..32b445a541f7 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -95,6 +95,11 @@ xlog_cil_pcp_aggregate(
 		ctx->ticket->t_unit_res += cilpcp->space_reserved;
 		cilpcp->space_reserved = 0;
 
+		if (!list_empty(&cilpcp->busy_extents)) {
+			list_splice_init(&cilpcp->busy_extents,
+					&ctx->busy_extents);
+		}
+
 		/*
 		 * We're in the middle of switching cil contexts.  Reset the
 		 * counter we use to detect when the current context is nearing
@@ -537,6 +542,9 @@ xlog_cil_insert_items(
 		atomic_add(cilpcp->space_used, &ctx->space_used);
 		cilpcp->space_used = 0;
 	}
+	/* attach the transaction to the CIL if it has any busy extents */
+	if (!list_empty(&tp->t_busy))
+		list_splice_init(&tp->t_busy, &cilpcp->busy_extents);
 	put_cpu_ptr(cilpcp);
 
 	/*
@@ -576,9 +584,6 @@ xlog_cil_insert_items(
 			list_move_tail(&lip->li_cil, &cil->xc_cil);
 	}
 
-	/* attach the transaction to the CIL if it has any busy extents */
-	if (!list_empty(&tp->t_busy))
-		list_splice_init(&tp->t_busy, &ctx->busy_extents);
 	spin_unlock(&cil->xc_cil_lock);
 
 	if (tp->t_ticket->t_curr_res < 0)
@@ -1612,6 +1617,8 @@ xlog_cil_pcp_dead(
 	}
 	cilpcp->space_reserved = 0;
 
+	if (!list_empty(&cilpcp->busy_extents))
+		list_splice_init(&cilpcp->busy_extents, &ctx->busy_extents);
 	atomic_add(cilpcp->space_used, &ctx->space_used);
 	cilpcp->space_used = 0;
 	up_write(&cil->xc_ctx_lock);
@@ -1622,10 +1629,12 @@ xlog_cil_pcp_dead(
  */
 int
 xlog_cil_init(
-	struct xlog	*log)
+	struct xlog		*log)
 {
-	struct xfs_cil	*cil;
-	struct xfs_cil_ctx *ctx;
+	struct xfs_cil		*cil;
+	struct xfs_cil_ctx	*ctx;
+	struct xlog_cil_pcp	*cilpcp;
+	int			cpu;
 
 	cil = kmem_zalloc(sizeof(*cil), KM_MAYFAIL);
 	if (!cil)
@@ -1645,6 +1654,11 @@ xlog_cil_init(
 	if (!cil->xc_pcp)
 		goto out_destroy_wq;
 
+	for_each_possible_cpu(cpu) {
+		cilpcp = per_cpu_ptr(cil->xc_pcp, cpu);
+		INIT_LIST_HEAD(&cilpcp->busy_extents);
+	}
+
 	INIT_LIST_HEAD(&cil->xc_cil);
 	INIT_LIST_HEAD(&cil->xc_committing);
 	spin_lock_init(&cil->xc_cil_lock);
-- 
2.33.0

