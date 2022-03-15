Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF3904D94C4
	for <lists+linux-xfs@lfdr.de>; Tue, 15 Mar 2022 07:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345271AbiCOGoI (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 15 Mar 2022 02:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345270AbiCOGoF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Mar 2022 02:44:05 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 63CFB25DF
        for <linux-xfs@vger.kernel.org>; Mon, 14 Mar 2022 23:42:52 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id D5769533062
        for <linux-xfs@vger.kernel.org>; Tue, 15 Mar 2022 17:42:44 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nU0tH-005elQ-NQ
        for linux-xfs@vger.kernel.org; Tue, 15 Mar 2022 17:42:43 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nU0tH-00D9KL-M1
        for linux-xfs@vger.kernel.org;
        Tue, 15 Mar 2022 17:42:43 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 6/7] xfs: AIL should be log centric
Date:   Tue, 15 Mar 2022 17:42:40 +1100
Message-Id: <20220315064241.3133751-7-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220315064241.3133751-1-david@fromorbit.com>
References: <20220315064241.3133751-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62303565
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=o8Y5sQTvuykA:10 a=20KFwNOVAAAA:8 a=XSbMu-zJpuptHPn39gwA:9
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The AIL operates purely on log items, so it is a log centric
subsystem. Divorce it from the xfs_mount and instead have it pass
around xlog pointers.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_trans.c      |  2 +-
 fs/xfs/xfs_trans_ail.c  | 26 +++++++++++++-------------
 fs/xfs/xfs_trans_priv.h |  3 ++-
 3 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index de87fb136b51..831d355c3258 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -773,7 +773,7 @@ xfs_trans_committed_bulk(
 		 * object into the AIL as we are in a shutdown situation.
 		 */
 		if (aborted) {
-			ASSERT(xfs_is_shutdown(ailp->ail_mount));
+			ASSERT(xlog_is_shutdown(ailp->ail_log));
 			if (lip->li_ops->iop_unpin)
 				lip->li_ops->iop_unpin(lip, 1);
 			continue;
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 1b52952097c1..c2ccb98c7bcd 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -398,7 +398,7 @@ xfsaild_push_item(
 	 * If log item pinning is enabled, skip the push and track the item as
 	 * pinned. This can help induce head-behind-tail conditions.
 	 */
-	if (XFS_TEST_ERROR(false, ailp->ail_mount, XFS_ERRTAG_LOG_ITEM_PIN))
+	if (XFS_TEST_ERROR(false, ailp->ail_log->l_mp, XFS_ERRTAG_LOG_ITEM_PIN))
 		return XFS_ITEM_PINNED;
 
 	/*
@@ -418,7 +418,7 @@ static long
 xfsaild_push(
 	struct xfs_ail		*ailp)
 {
-	xfs_mount_t		*mp = ailp->ail_mount;
+	struct xfs_mount	*mp = ailp->ail_log->l_mp;
 	struct xfs_ail_cursor	cur;
 	struct xfs_log_item	*lip;
 	xfs_lsn_t		lsn;
@@ -443,7 +443,7 @@ xfsaild_push(
 		ailp->ail_log_flush = 0;
 
 		XFS_STATS_INC(mp, xs_push_ail_flush);
-		xlog_cil_flush(mp->m_log);
+		xlog_cil_flush(ailp->ail_log);
 	}
 
 	spin_lock(&ailp->ail_lock);
@@ -632,7 +632,7 @@ xfsaild(
 			 * opportunity to release such buffers from the queue.
 			 */
 			ASSERT(list_empty(&ailp->ail_buf_list) ||
-			       xfs_is_shutdown(ailp->ail_mount));
+			       xlog_is_shutdown(ailp->ail_log));
 			xfs_buf_delwri_cancel(&ailp->ail_buf_list);
 			break;
 		}
@@ -695,7 +695,7 @@ xfs_ail_push(
 	struct xfs_log_item	*lip;
 
 	lip = xfs_ail_min(ailp);
-	if (!lip || xfs_is_shutdown(ailp->ail_mount) ||
+	if (!lip || xlog_is_shutdown(ailp->ail_log) ||
 	    XFS_LSN_CMP(threshold_lsn, ailp->ail_target) <= 0)
 		return;
 
@@ -751,7 +751,7 @@ xfs_ail_update_finish(
 	struct xfs_ail		*ailp,
 	xfs_lsn_t		old_lsn) __releases(ailp->ail_lock)
 {
-	struct xfs_mount	*mp = ailp->ail_mount;
+	struct xlog		*log = ailp->ail_log;
 
 	/* if the tail lsn hasn't changed, don't do updates or wakeups. */
 	if (!old_lsn || old_lsn == __xfs_ail_min_lsn(ailp)) {
@@ -759,13 +759,13 @@ xfs_ail_update_finish(
 		return;
 	}
 
-	if (!xfs_is_shutdown(mp))
-		xlog_assign_tail_lsn_locked(mp);
+	if (!xlog_is_shutdown(log))
+		xlog_assign_tail_lsn_locked(log->l_mp);
 
 	if (list_empty(&ailp->ail_head))
 		wake_up_all(&ailp->ail_empty);
 	spin_unlock(&ailp->ail_lock);
-	xfs_log_space_wake(mp);
+	xfs_log_space_wake(log->l_mp);
 }
 
 /*
@@ -873,13 +873,13 @@ xfs_trans_ail_delete(
 	int			shutdown_type)
 {
 	struct xfs_ail		*ailp = lip->li_ailp;
-	struct xfs_mount	*mp = ailp->ail_mount;
+	struct xfs_mount	*mp = ailp->ail_log->l_mp;
 	xfs_lsn_t		tail_lsn;
 
 	spin_lock(&ailp->ail_lock);
 	if (!test_bit(XFS_LI_IN_AIL, &lip->li_flags)) {
 		spin_unlock(&ailp->ail_lock);
-		if (shutdown_type && !xfs_is_shutdown(mp)) {
+		if (shutdown_type && !xlog_is_shutdown(ailp->ail_log)) {
 			xfs_alert_tag(mp, XFS_PTAG_AILDELETE,
 	"%s: attempting to delete a log item that is not in the AIL",
 					__func__);
@@ -904,7 +904,7 @@ xfs_trans_ail_init(
 	if (!ailp)
 		return -ENOMEM;
 
-	ailp->ail_mount = mp;
+	ailp->ail_log = mp->m_log;
 	INIT_LIST_HEAD(&ailp->ail_head);
 	INIT_LIST_HEAD(&ailp->ail_cursors);
 	spin_lock_init(&ailp->ail_lock);
@@ -912,7 +912,7 @@ xfs_trans_ail_init(
 	init_waitqueue_head(&ailp->ail_empty);
 
 	ailp->ail_task = kthread_run(xfsaild, ailp, "xfsaild/%s",
-			ailp->ail_mount->m_super->s_id);
+				mp->m_super->s_id);
 	if (IS_ERR(ailp->ail_task))
 		goto out_free_ailp;
 
diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
index 3004aeac9110..f0d79a9050ba 100644
--- a/fs/xfs/xfs_trans_priv.h
+++ b/fs/xfs/xfs_trans_priv.h
@@ -6,6 +6,7 @@
 #ifndef __XFS_TRANS_PRIV_H__
 #define	__XFS_TRANS_PRIV_H__
 
+struct xlog;
 struct xfs_log_item;
 struct xfs_mount;
 struct xfs_trans;
@@ -50,7 +51,7 @@ struct xfs_ail_cursor {
  * Eventually we need to drive the locking in here as well.
  */
 struct xfs_ail {
-	struct xfs_mount	*ail_mount;
+	struct xlog		*ail_log;
 	struct task_struct	*ail_task;
 	struct list_head	ail_head;
 	xfs_lsn_t		ail_target;
-- 
2.35.1

