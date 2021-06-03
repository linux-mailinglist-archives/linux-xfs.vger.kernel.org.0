Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEC9B3999D3
	for <lists+linux-xfs@lfdr.de>; Thu,  3 Jun 2021 07:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbhFCFYw (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 3 Jun 2021 01:24:52 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:56315 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229803AbhFCFYv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Jun 2021 01:24:51 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 237851043969
        for <linux-xfs@vger.kernel.org>; Thu,  3 Jun 2021 15:22:51 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lofog-008Mpy-AT
        for linux-xfs@vger.kernel.org; Thu, 03 Jun 2021 15:22:50 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lofog-000ilH-2S
        for linux-xfs@vger.kernel.org; Thu, 03 Jun 2021 15:22:50 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 02/39] xfs: separate CIL commit record IO
Date:   Thu,  3 Jun 2021 15:22:03 +1000
Message-Id: <20210603052240.171998-3-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210603052240.171998-1-david@fromorbit.com>
References: <20210603052240.171998-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=r6YtysWOX24A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
        a=yPCof4ZbAAAA:8 a=6GbAA9ItjH-Z6eHFJ-YA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

To allow for iclog IO device cache flush behaviour to be optimised,
we first need to separate out the commit record iclog IO from the
rest of the checkpoint so we can wait for the checkpoint IO to
complete before we issue the commit record.

This separation is only necessary if the commit record is being
written into a different iclog to the start of the checkpoint as the
upcoming cache flushing changes requires completion ordering against
the other iclogs submitted by the checkpoint.

If the entire checkpoint and commit is in the one iclog, then they
are both covered by the one set of cache flush primitives on the
iclog and hence there is no need to separate them for ordering.

Otherwise, we need to wait for all the previous iclogs to complete
so they are ordered correctly and made stable by the REQ_PREFLUSH
that the commit record iclog IO issues. This guarantees that if a
reader sees the commit record in the journal, they will also see the
entire checkpoint that commit record closes off.

This also provides the guarantee that when the commit record IO
completes, we can safely unpin all the log items in the checkpoint
so they can be written back because the entire checkpoint is stable
in the journal.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_log.c      | 8 +++++---
 fs/xfs/xfs_log_cil.c  | 9 +++++++++
 fs/xfs/xfs_log_priv.h | 2 ++
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 0e563ff8cd3b..4cd5840e953a 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -786,10 +786,12 @@ xfs_log_mount_cancel(
 }
 
 /*
- * Wait for the iclog to be written disk, or return an error if the log has been
- * shut down.
+ * Wait for the iclog and all prior iclogs to be written disk as required by the
+ * log force state machine. Waiting on ic_force_wait ensures iclog completions
+ * have been ordered and callbacks run before we are woken here, hence
+ * guaranteeing that all the iclogs up to this one are on stable storage.
  */
-static int
+int
 xlog_wait_on_iclog(
 	struct xlog_in_core	*iclog)
 		__releases(iclog->ic_log->l_icloglock)
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index b0ef071b3cb5..1e5fd6f268c2 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -870,6 +870,15 @@ xlog_cil_push_work(
 	wake_up_all(&cil->xc_commit_wait);
 	spin_unlock(&cil->xc_push_lock);
 
+	/*
+	 * If the checkpoint spans multiple iclogs, wait for all previous
+	 * iclogs to complete before we submit the commit_iclog.
+	 */
+	if (ctx->start_lsn != commit_lsn) {
+		spin_lock(&log->l_icloglock);
+		xlog_wait_on_iclog(commit_iclog->ic_prev);
+	}
+
 	/* release the hounds! */
 	xfs_log_release_iclog(commit_iclog);
 	return;
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 037950cf1061..ee7786b33da9 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -584,6 +584,8 @@ xlog_wait(
 	remove_wait_queue(wq, &wait);
 }
 
+int xlog_wait_on_iclog(struct xlog_in_core *iclog);
+
 /*
  * The LSN is valid so long as it is behind the current LSN. If it isn't, this
  * means that the next log record that includes this metadata could have a
-- 
2.31.1

