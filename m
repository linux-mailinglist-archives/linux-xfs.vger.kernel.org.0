Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7803254D432
	for <lists+linux-xfs@lfdr.de>; Thu, 16 Jun 2022 00:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242770AbiFOWEY (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 15 Jun 2022 18:04:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346327AbiFOWEX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Jun 2022 18:04:23 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CDCDE562F2
        for <linux-xfs@vger.kernel.org>; Wed, 15 Jun 2022 15:04:20 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id E07DB5ECAA0
        for <linux-xfs@vger.kernel.org>; Thu, 16 Jun 2022 08:04:19 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o1b7a-00768R-9d
        for linux-xfs@vger.kernel.org; Thu, 16 Jun 2022 08:04:18 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1o1b7a-00FS1P-84
        for linux-xfs@vger.kernel.org;
        Thu, 16 Jun 2022 08:04:18 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs: introduce xfs_inodegc_push()
Date:   Thu, 16 Jun 2022 08:04:16 +1000
Message-Id: <20220615220416.3681870-3-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220615220416.3681870-1-david@fromorbit.com>
References: <20220615220416.3681870-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62aa5764
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=JPEYwPQDsx4A:10 a=20KFwNOVAAAA:8 a=N8xf_ed3AAAA:8
        a=NnqXlVpJ2G-Su3j_ZPkA:9 a=sE4t997d3Q9FUvws1cBB:22
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The current blocking mechanism for pushing the inodegc queue out to
disk can result in systems becoming unusable when there is a long
running inodegc operation. This is because the statfs()
implementation currently issues a blocking flush of the inodegc
queue and a significant number of common system utilities will call
statfs() to discover something about the underlying filesystem.

This can result in userspace operations getting stuck on inodegc
progress, and when trying to remove a heavily reflinked file on slow
storage with a full journal, this can result in delays measuring in
hours.

Avoid this problem by adding "push" function that expedites the
flushing of the inodegc queue, but doesn't wait for it to complete.

Convert xfs_fs_statfs() and xfs_qm_scall_getquota() to use this
mechanism so they don't block but still ensure that queued
operations are expedited.

Fixes: ab23a7768739 ("xfs: per-cpu deferred inode inactivation queues")
Reported-by: Chris Dunlop <chris@onthe.net.au>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_icache.c      | 20 +++++++++++++++-----
 fs/xfs/xfs_icache.h      |  1 +
 fs/xfs/xfs_qm_syscalls.c |  7 +++++--
 fs/xfs/xfs_super.c       |  7 +++++--
 fs/xfs/xfs_trace.h       |  1 +
 5 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 46b30ecf498c..aef4097ffd3e 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1865,19 +1865,29 @@ xfs_inodegc_worker(
 }
 
 /*
- * Force all currently queued inode inactivation work to run immediately and
- * wait for the work to finish.
+ * Expedite all pending inodegc work to run immediately. This does not wait for
+ * completion of the work.
  */
 void
-xfs_inodegc_flush(
+xfs_inodegc_push(
 	struct xfs_mount	*mp)
 {
 	if (!xfs_is_inodegc_enabled(mp))
 		return;
+	trace_xfs_inodegc_push(mp, __return_address);
+	xfs_inodegc_queue_all(mp);
+}
 
+/*
+ * Force all currently queued inode inactivation work to run immediately and
+ * wait for the work to finish.
+ */
+void
+xfs_inodegc_flush(
+	struct xfs_mount	*mp)
+{
+	xfs_inodegc_push(mp);
 	trace_xfs_inodegc_flush(mp, __return_address);
-
-	xfs_inodegc_queue_all(mp);
 	flush_workqueue(mp->m_inodegc_wq);
 }
 
diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
index 2e4cfddf8b8e..6cd180721659 100644
--- a/fs/xfs/xfs_icache.h
+++ b/fs/xfs/xfs_icache.h
@@ -76,6 +76,7 @@ void xfs_blockgc_stop(struct xfs_mount *mp);
 void xfs_blockgc_start(struct xfs_mount *mp);
 
 void xfs_inodegc_worker(struct work_struct *work);
+void xfs_inodegc_push(struct xfs_mount *mp);
 void xfs_inodegc_flush(struct xfs_mount *mp);
 void xfs_inodegc_stop(struct xfs_mount *mp);
 void xfs_inodegc_start(struct xfs_mount *mp);
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index 74ac9ca9e119..a30f4d067746 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -454,9 +454,12 @@ xfs_qm_scall_getquota(
 	struct xfs_dquot	*dqp;
 	int			error;
 
-	/* Flush inodegc work at the start of a quota reporting scan. */
+	/*
+	 * Expedite pending inodegc work at the start of a quota reporting
+	 * scan but don't block waiting for it to complete.
+	 */
 	if (id == 0)
-		xfs_inodegc_flush(mp);
+		xfs_inodegc_push(mp);
 
 	/*
 	 * Try to get the dquot. We don't want it allocated on disk, so don't
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 651ae75a7e23..4edee1d3784a 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -798,8 +798,11 @@ xfs_fs_statfs(
 	xfs_extlen_t		lsize;
 	int64_t			ffree;
 
-	/* Wait for whatever inactivations are in progress. */
-	xfs_inodegc_flush(mp);
+	/*
+	 * Expedite background inodegc but don't wait. We do not want to block
+	 * here waiting hours for a billion extent file to be truncated.
+	 */
+	xfs_inodegc_push(mp);
 
 	statp->f_type = XFS_SUPER_MAGIC;
 	statp->f_namelen = MAXNAMELEN - 1;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index d32026585c1b..0fa1b7a2918c 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -240,6 +240,7 @@ DEFINE_EVENT(xfs_fs_class, name,					\
 	TP_PROTO(struct xfs_mount *mp, void *caller_ip), \
 	TP_ARGS(mp, caller_ip))
 DEFINE_FS_EVENT(xfs_inodegc_flush);
+DEFINE_FS_EVENT(xfs_inodegc_push);
 DEFINE_FS_EVENT(xfs_inodegc_start);
 DEFINE_FS_EVENT(xfs_inodegc_stop);
 DEFINE_FS_EVENT(xfs_inodegc_queue);
-- 
2.35.1

