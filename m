Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58954388DBF
	for <lists+linux-xfs@lfdr.de>; Wed, 19 May 2021 14:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353390AbhESMOv (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 19 May 2021 08:14:51 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:49324 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241571AbhESMOp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 May 2021 08:14:45 -0400
Received: from dread.disaster.area (pa49-195-118-180.pa.nsw.optusnet.com.au [49.195.118.180])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id E7ADF861568
        for <linux-xfs@vger.kernel.org>; Wed, 19 May 2021 22:13:20 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ljL4i-002m1k-Fo
        for linux-xfs@vger.kernel.org; Wed, 19 May 2021 22:13:20 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1ljL4i-002SHq-8M
        for linux-xfs@vger.kernel.org; Wed, 19 May 2021 22:13:20 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 29/39] xfs: introduce per-cpu CIL tracking structure
Date:   Wed, 19 May 2021 22:13:07 +1000
Message-Id: <20210519121317.585244-30-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519121317.585244-1-david@fromorbit.com>
References: <20210519121317.585244-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=xcwBwyABtj18PbVNKPPJDQ==:117 a=xcwBwyABtj18PbVNKPPJDQ==:17
        a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=ctKYPObigYSo-yGFUx4A:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The CIL push lock is highly contended on larger machines, becoming a
hard bottleneck that about 700,000 transaction commits/s on >16p
machines. To address this, start moving the CIL tracking
infrastructure to utilise per-CPU structures.

We need to track the space used, the amount of log reservation space
reserved to write the CIL, the log items in the CIL and the busy
extents that need to be completed by the CIL commit.  This requires
a couple of per-cpu counters, an unordered per-cpu list and a
globally ordered per-cpu list.

Create a per-cpu structure to hold these and all the management
interfaces needed, as well as the hooks to handle hotplug CPUs.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_cil.c       | 106 +++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_log_priv.h      |  15 ++++++
 include/linux/cpuhotplug.h |   1 +
 3 files changed, 122 insertions(+)

diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 87d4eb321fdc..ba1c6979a4c7 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -1370,6 +1370,105 @@ xfs_log_item_in_current_chkpt(
 	return lip->li_seq == cil->xc_ctx->sequence;
 }
 
+#ifdef CONFIG_HOTPLUG_CPU
+static LIST_HEAD(xlog_cil_pcp_list);
+static DEFINE_SPINLOCK(xlog_cil_pcp_lock);
+static bool xlog_cil_pcp_init;
+
+/*
+ * Move dead percpu state to the relevant CIL context structures.
+ *
+ * We have to lock the CIL context here to ensure that nothing is modifying
+ * the percpu state, either addition or removal. Both of these are done under
+ * the CIL context lock, so grabbing that exclusively here will ensure we can
+ * safely drain the cilpcp for the CPU that is dying.
+ */
+static int
+xlog_cil_pcp_dead(
+	unsigned int		cpu)
+{
+	struct xfs_cil		*cil, *n;
+
+	spin_lock(&xlog_cil_pcp_lock);
+	list_for_each_entry_safe(cil, n, &xlog_cil_pcp_list, xc_pcp_list) {
+		spin_unlock(&xlog_cil_pcp_lock);
+		down_write(&cil->xc_ctx_lock);
+		/* move stuff on dead CPU to context */
+		up_write(&cil->xc_ctx_lock);
+		spin_lock(&xlog_cil_pcp_lock);
+	}
+	spin_unlock(&xlog_cil_pcp_lock);
+	return 0;
+}
+
+static int
+xlog_cil_pcp_hpadd(
+	struct xfs_cil		*cil)
+{
+	if (!xlog_cil_pcp_init) {
+		int	ret;
+		ret = cpuhp_setup_state_nocalls(CPUHP_XFS_CIL_DEAD,
+						"xfs/cil_pcp:dead", NULL,
+						xlog_cil_pcp_dead);
+		if (ret < 0) {
+			xfs_warn(cil->xc_log->l_mp,
+	"Failed to initialise CIL hotplug, error %d. XFS is non-functional.",
+				ret);
+			ASSERT(0);
+			return -ENOMEM;
+		}
+		xlog_cil_pcp_init = true;
+	}
+
+	INIT_LIST_HEAD(&cil->xc_pcp_list);
+	spin_lock(&xlog_cil_pcp_lock);
+	list_add(&cil->xc_pcp_list, &xlog_cil_pcp_list);
+	spin_unlock(&xlog_cil_pcp_lock);
+	return 0;
+}
+
+static void
+xlog_cil_pcp_hpremove(
+	struct xfs_cil		*cil)
+{
+	spin_lock(&xlog_cil_pcp_lock);
+	list_del(&cil->xc_pcp_list);
+	spin_unlock(&xlog_cil_pcp_lock);
+}
+
+#else /* !CONFIG_HOTPLUG_CPU */
+static inline void xlog_cil_pcp_hpadd(struct xfs_cil *cil) {}
+static inline void xlog_cil_pcp_hpremove(struct xfs_cil *cil) {}
+#endif
+
+static void __percpu *
+xlog_cil_pcp_alloc(
+	struct xfs_cil		*cil)
+{
+	void __percpu		*pcp;
+
+	pcp = alloc_percpu(struct xlog_cil_pcp);
+	if (!pcp)
+		return NULL;
+
+	if (xlog_cil_pcp_hpadd(cil) < 0) {
+		free_percpu(pcp);
+		return NULL;
+	}
+	return pcp;
+}
+
+static void
+xlog_cil_pcp_free(
+	struct xfs_cil		*cil,
+	void __percpu		*pcp)
+{
+	if (!pcp)
+		return;
+	xlog_cil_pcp_hpremove(cil);
+	free_percpu(pcp);
+}
+
 /*
  * Perform initial CIL structure initialisation.
  */
@@ -1384,6 +1483,12 @@ xlog_cil_init(
 	if (!cil)
 		return -ENOMEM;
 
+	cil->xc_pcp = xlog_cil_pcp_alloc(cil);
+	if (!cil->xc_pcp) {
+		kmem_free(cil);
+		return -ENOMEM;
+	}
+
 	INIT_LIST_HEAD(&cil->xc_cil);
 	INIT_LIST_HEAD(&cil->xc_committing);
 	spin_lock_init(&cil->xc_cil_lock);
@@ -1414,6 +1519,7 @@ xlog_cil_destroy(
 
 	ASSERT(list_empty(&cil->xc_cil));
 	ASSERT(test_bit(XLOG_CIL_EMPTY, &cil->xc_flags));
+	xlog_cil_pcp_free(cil, cil->xc_pcp);
 	kmem_free(cil);
 }
 
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 85a85ab569fe..aaa1e7f7fb66 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -227,6 +227,16 @@ struct xfs_cil_ctx {
 	struct work_struct	push_work;
 };
 
+/*
+ * Per-cpu CIL tracking items
+ */
+struct xlog_cil_pcp {
+	uint32_t		space_used;
+	uint32_t		curr_res;
+	struct list_head	busy_extents;
+	struct list_head	log_items;
+};
+
 /*
  * Committed Item List structure
  *
@@ -260,6 +270,11 @@ struct xfs_cil {
 	wait_queue_head_t	xc_commit_wait;
 	xfs_csn_t		xc_current_sequence;
 	wait_queue_head_t	xc_push_wait;	/* background push throttle */
+
+	void __percpu		*xc_pcp;	/* percpu CIL structures */
+#ifdef CONFIG_HOTPLUG_CPU
+	struct list_head	xc_pcp_list;
+#endif
 } ____cacheline_aligned_in_smp;
 
 /* xc_flags bit values */
diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
index 4a62b3980642..3d3ccde9e9c8 100644
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -52,6 +52,7 @@ enum cpuhp_state {
 	CPUHP_FS_BUFF_DEAD,
 	CPUHP_PRINTK_DEAD,
 	CPUHP_MM_MEMCQ_DEAD,
+	CPUHP_XFS_CIL_DEAD,
 	CPUHP_PERCPU_CNT_DEAD,
 	CPUHP_RADIX_DEAD,
 	CPUHP_PAGE_ALLOC_DEAD,
-- 
2.31.1

