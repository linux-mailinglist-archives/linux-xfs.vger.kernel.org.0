Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED03324984
	for <lists+linux-xfs@lfdr.de>; Thu, 25 Feb 2021 04:38:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232727AbhBYDiN (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 24 Feb 2021 22:38:13 -0500
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:47031 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232960AbhBYDiI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Feb 2021 22:38:08 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 204741046C5
        for <linux-xfs@vger.kernel.org>; Thu, 25 Feb 2021 14:37:27 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lF7Sw-0038B9-LD
        for linux-xfs@vger.kernel.org; Thu, 25 Feb 2021 14:37:26 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lF7Sw-00Evjf-E2
        for linux-xfs@vger.kernel.org; Thu, 25 Feb 2021 14:37:26 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 12/12] xfs: avoid cil push lock if possible
Date:   Thu, 25 Feb 2021 14:37:25 +1100
Message-Id: <20210225033725.3558450-13-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210225033725.3558450-1-david@fromorbit.com>
References: <20210225033725.3558450-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=qa6Q16uM49sA:10 a=20KFwNOVAAAA:8 a=F6O72S5bnyPC6Df_giEA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Because now it hurts when the CIL fills up.

  - 37.20% __xfs_trans_commit
      - 35.84% xfs_log_commit_cil
         - 19.34% _raw_spin_lock
            - do_raw_spin_lock
                 19.01% __pv_queued_spin_lock_slowpath
         - 4.20% xfs_log_ticket_ungrant
              0.90% xfs_log_space_wake


Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_cil.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 79dc185f2dba..fe4547e78511 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -1110,10 +1110,18 @@ xlog_cil_push_background(
 	ASSERT(!test_bit(XLOG_CIL_EMPTY, &cil->xc_flags));
 
 	/*
-	 * Don't do a background push if we haven't used up all the
-	 * space available yet.
+	 * We are done if:
+	 * - we haven't used up all the space available yet; or
+	 * - we've already queued up a push; and
+	 * - we're not over the hard limit; and
+	 * - nothing has been over the hard limit.
+	 *
+	 * If so, we don't need to take the push lock as there's nothing to do.
 	 */
-	if (space_used < XLOG_CIL_SPACE_LIMIT(log)) {
+	if (space_used < XLOG_CIL_SPACE_LIMIT(log) ||
+	    (cil->xc_push_seq == cil->xc_current_sequence &&
+	     space_used < XLOG_CIL_BLOCKING_SPACE_LIMIT(log) &&
+	     !waitqueue_active(&cil->xc_push_wait))) {
 		up_read(&cil->xc_ctx_lock);
 		return;
 	}
-- 
2.28.0

