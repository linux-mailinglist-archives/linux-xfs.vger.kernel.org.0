Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEB043523D
	for <lists+linux-xfs@lfdr.de>; Tue,  4 Jun 2019 23:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbfFDVuZ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 4 Jun 2019 17:50:25 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37330 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726373AbfFDVuZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jun 2019 17:50:25 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x54LnPp5059831
        for <linux-xfs@vger.kernel.org>; Tue, 4 Jun 2019 21:50:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=h2ecRESwHPlabpjcDJ2AUAyN30A/rTYte+st9045fQE=;
 b=An5nOWI2Sb5QOUd/INmyqO+W8fIb7N72xWI2WUm01+OpB4HDkEs2+84ytmEevv3spVN/
 QDgjWy+z+sk6PllcOBdtbZ79gWkrB1rVsSCM6Irw1RNjR3HHqCGjCylaP599iBi+PFGW
 whyJE+TT5zR6gIoBxFOumofAUT9p6Ys1S9/vFu8Q2xWUO57w5rtgeeffagTbKk/4gDOF
 wUOyyylcjzHk1baZNwLlSRSz6yRkrQczsrfNNAcO9Hw2e+VAO1fD/ZoGJuzC8vwCpvoG
 0yFrKp/AgXmpOxVL6IMtrM82t91A4FocVTaeb4n/EBEFYdOR+PUxFZvrl9DbZXskcO7o mQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2suj0qfjx4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 04 Jun 2019 21:50:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x54Lo2tF045125
        for <linux-xfs@vger.kernel.org>; Tue, 4 Jun 2019 21:50:22 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2swnghkjs8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 04 Jun 2019 21:50:22 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x54LoMTV009124
        for <linux-xfs@vger.kernel.org>; Tue, 4 Jun 2019 21:50:22 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 04 Jun 2019 14:50:21 -0700
Subject: [PATCH 08/10] xfs: multithreaded iwalk implementation
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 04 Jun 2019 14:50:20 -0700
Message-ID: <155968502066.1657646.3694276570612406995.stgit@magnolia>
In-Reply-To: <155968496814.1657646.13743491598480818627.stgit@magnolia>
References: <155968496814.1657646.13743491598480818627.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9278 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906040138
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9278 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906040138
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a parallel iwalk implementation and switch quotacheck to use it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Makefile      |    1 
 fs/xfs/xfs_globals.c |    3 +
 fs/xfs/xfs_iwalk.c   |   76 ++++++++++++++++++++++++++++++-
 fs/xfs/xfs_iwalk.h   |    2 +
 fs/xfs/xfs_pwork.c   |  122 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_pwork.h   |   50 ++++++++++++++++++++
 fs/xfs/xfs_qm.c      |    2 -
 fs/xfs/xfs_sysctl.h  |    6 ++
 fs/xfs/xfs_sysfs.c   |   40 ++++++++++++++++
 fs/xfs/xfs_trace.h   |   18 +++++++
 10 files changed, 317 insertions(+), 3 deletions(-)
 create mode 100644 fs/xfs/xfs_pwork.c
 create mode 100644 fs/xfs/xfs_pwork.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 74d30ef0dbce..48940a27d4aa 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -84,6 +84,7 @@ xfs-y				+= xfs_aops.o \
 				   xfs_message.o \
 				   xfs_mount.o \
 				   xfs_mru_cache.o \
+				   xfs_pwork.o \
 				   xfs_reflink.o \
 				   xfs_stats.o \
 				   xfs_super.o \
diff --git a/fs/xfs/xfs_globals.c b/fs/xfs/xfs_globals.c
index d0d377384120..4f93f2c4dc38 100644
--- a/fs/xfs/xfs_globals.c
+++ b/fs/xfs/xfs_globals.c
@@ -31,6 +31,9 @@ xfs_param_t xfs_params = {
 	.fstrm_timer	= {	1,		30*100,		3600*100},
 	.eofb_timer	= {	1,		300,		3600*24},
 	.cowb_timer	= {	1,		1800,		3600*24},
+#ifdef DEBUG
+	.pwork_threads	= {	0,		0,		NR_CPUS	},
+#endif
 };
 
 struct xfs_globals xfs_globals = {
diff --git a/fs/xfs/xfs_iwalk.c b/fs/xfs/xfs_iwalk.c
index 8595258b5001..71ee1628aa70 100644
--- a/fs/xfs/xfs_iwalk.c
+++ b/fs/xfs/xfs_iwalk.c
@@ -21,6 +21,7 @@
 #include "xfs_health.h"
 #include "xfs_trans.h"
 #include "xfs_iwalk.h"
+#include "xfs_pwork.h"
 
 /*
  * Walking Inodes in the Filesystem
@@ -46,6 +47,9 @@
  */
 
 struct xfs_iwalk_ag {
+	/* parallel work control data; will be null if single threaded */
+	struct xfs_pwork		pwork;
+
 	struct xfs_mount		*mp;
 	struct xfs_trans		*tp;
 
@@ -200,6 +204,9 @@ xfs_iwalk_ag_recs(
 		trace_xfs_iwalk_ag_rec(mp, agno, irec);
 
 		for (j = 0; j < XFS_INODES_PER_CHUNK; j++) {
+			if (xfs_pwork_want_abort(&iwag->pwork))
+				return 0;
+
 			/* Skip if this inode is free */
 			if (XFS_INOBT_MASK(j) & irec->ir_free)
 				continue;
@@ -360,7 +367,7 @@ xfs_iwalk_ag(
 	agino = XFS_INO_TO_AGINO(mp, iwag->startino);
 	error = xfs_iwalk_ag_start(iwag, agno, agino, &cur, &agi_bp, &has_more);
 
-	while (!error && has_more) {
+	while (!error && has_more && !xfs_pwork_want_abort(&iwag->pwork)) {
 		struct xfs_inobt_rec_incore	*irec;
 
 		cond_resched();
@@ -409,7 +416,7 @@ xfs_iwalk_ag(
 	xfs_iwalk_del_inobt(tp, &cur, &agi_bp, error);
 
 	/* Walk any records left behind in the cache. */
-	if (iwag->nr_recs == 0 || error)
+	if (iwag->nr_recs == 0 || error || xfs_pwork_want_abort(&iwag->pwork))
 		return error;
 
 	return xfs_iwalk_ag_recs(iwag);
@@ -465,6 +472,7 @@ xfs_iwalk(
 		.iwalk_fn	= iwalk_fn,
 		.data		= data,
 		.startino	= startino,
+		.pwork		= XFS_PWORK_SINGLE_THREADED,
 	};
 	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, startino);
 	int			error;
@@ -486,3 +494,67 @@ xfs_iwalk(
 	xfs_iwalk_free(&iwag);
 	return error;
 }
+
+/* Run per-thread iwalk work. */
+static int
+xfs_iwalk_ag_work(
+	struct xfs_mount	*mp,
+	struct xfs_pwork	*pwork)
+{
+	struct xfs_iwalk_ag	*iwag;
+	int			error;
+
+	iwag = container_of(pwork, struct xfs_iwalk_ag, pwork);
+	error = xfs_iwalk_alloc(iwag);
+	if (error)
+		goto out;
+
+	error = xfs_iwalk_ag(iwag);
+	xfs_iwalk_free(iwag);
+out:
+	kmem_free(iwag);
+	return error;
+}
+
+/*
+ * Walk all the inodes in the filesystem using multiple threads to process each
+ * AG.
+ */
+int
+xfs_iwalk_threaded(
+	struct xfs_mount	*mp,
+	xfs_ino_t		startino,
+	xfs_iwalk_fn		iwalk_fn,
+	unsigned int		max_prefetch,
+	void			*data)
+{
+	struct xfs_pwork_ctl	pctl;
+	xfs_agnumber_t		agno = XFS_INO_TO_AGNO(mp, startino);
+	unsigned int		nr_threads;
+	int			error;
+
+	ASSERT(agno < mp->m_sb.sb_agcount);
+
+	nr_threads = xfs_pwork_guess_datadev_parallelism(mp);
+	error = xfs_pwork_init(mp, &pctl, xfs_iwalk_ag_work, "xfs_iwalk",
+			nr_threads);
+	if (error)
+		return error;
+
+	for (; agno < mp->m_sb.sb_agcount; agno++) {
+		struct xfs_iwalk_ag	*iwag;
+
+		iwag = kmem_alloc(sizeof(struct xfs_iwalk_ag), KM_SLEEP);
+		iwag->mp = mp;
+		iwag->tp = NULL;
+		iwag->iwalk_fn = iwalk_fn;
+		iwag->data = data;
+		iwag->startino = startino;
+		iwag->recs = NULL;
+		xfs_iwalk_set_prefetch(iwag, max_prefetch);
+		xfs_pwork_queue(&pctl, &iwag->pwork);
+		startino = XFS_AGINO_TO_INO(mp, agno + 1, 0);
+	}
+
+	return xfs_pwork_destroy(&pctl);
+}
diff --git a/fs/xfs/xfs_iwalk.h b/fs/xfs/xfs_iwalk.h
index 45b1baabcd2d..40233a05a766 100644
--- a/fs/xfs/xfs_iwalk.h
+++ b/fs/xfs/xfs_iwalk.h
@@ -14,5 +14,7 @@ typedef int (*xfs_iwalk_fn)(struct xfs_mount *mp, struct xfs_trans *tp,
 
 int xfs_iwalk(struct xfs_mount *mp, struct xfs_trans *tp, xfs_ino_t startino,
 		xfs_iwalk_fn iwalk_fn, unsigned int max_prefetch, void *data);
+int xfs_iwalk_threaded(struct xfs_mount *mp, xfs_ino_t startino,
+		xfs_iwalk_fn iwalk_fn, unsigned int max_prefetch, void *data);
 
 #endif /* __XFS_IWALK_H__ */
diff --git a/fs/xfs/xfs_pwork.c b/fs/xfs/xfs_pwork.c
new file mode 100644
index 000000000000..19605a3a2482
--- /dev/null
+++ b/fs/xfs/xfs_pwork.c
@@ -0,0 +1,122 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (C) 2019 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_trace.h"
+#include "xfs_sysctl.h"
+#include "xfs_pwork.h"
+
+/*
+ * Parallel Work Queue
+ * ===================
+ *
+ * Abstract away the details of running a large and "obviously" parallelizable
+ * task across multiple CPUs.  Callers initialize the pwork control object with
+ * a desired level of parallelization and a work function.  Next, they embed
+ * struct xfs_pwork in whatever structure they use to pass work context to a
+ * worker thread and queue that pwork.  The work function will be passed the
+ * pwork item when it is run (from process context) and any returned error will
+ * cause all threads to abort.
+ * 
+ * This is the rough equivalent of the xfsprogs workqueue code, though we can't
+ * reuse that name here.
+ */
+
+/* Invoke our caller's function. */
+static void
+xfs_pwork_work(
+	struct work_struct	*work)
+{
+	struct xfs_pwork	*pwork;
+	struct xfs_pwork_ctl	*pctl;
+	int			error;
+
+	pwork = container_of(work, struct xfs_pwork, work);
+	pctl = pwork->pctl;
+	error = pctl->work_fn(pctl->mp, pwork);
+	if (error && !pctl->error)
+		pctl->error = error;
+}
+
+/*
+ * Set up control data for parallel work.  @work_fn is the function that will
+ * be called.  @tag will be written into the kernel threads.  @nr_threads is
+ * the level of parallelism desired, or 0 for no limit.
+ */
+int
+xfs_pwork_init(
+	struct xfs_mount	*mp,
+	struct xfs_pwork_ctl	*pctl,
+	xfs_pwork_work_fn	work_fn,
+	const char		*tag,
+	unsigned int		nr_threads)
+{
+#ifdef DEBUG
+	if (xfs_globals.pwork_threads > 0)
+		nr_threads = xfs_globals.pwork_threads;
+#endif
+	trace_xfs_pwork_init(mp, nr_threads, current->pid);
+
+	pctl->wq = alloc_workqueue("%s-%d", WQ_FREEZABLE, nr_threads, tag,
+			current->pid);
+	if (!pctl->wq)
+		return -ENOMEM;
+	pctl->work_fn = work_fn;
+	pctl->error = 0;
+	pctl->mp = mp;
+
+	return 0;
+}
+
+/* Queue some parallel work. */
+void
+xfs_pwork_queue(
+	struct xfs_pwork_ctl	*pctl,
+	struct xfs_pwork	*pwork)
+{
+	INIT_WORK(&pwork->work, xfs_pwork_work);
+	pwork->pctl = pctl;
+	queue_work(pctl->wq, &pwork->work);
+}
+
+/* Wait for the work to finish and tear down the control structure. */
+int
+xfs_pwork_destroy(
+	struct xfs_pwork_ctl	*pctl)
+{
+	destroy_workqueue(pctl->wq);
+	pctl->wq = NULL;
+	return pctl->error;
+}
+
+/*
+ * Return the amount of parallelism that the data device can handle, or 0 for
+ * no limit.
+ */
+unsigned int
+xfs_pwork_guess_datadev_parallelism(
+	struct xfs_mount	*mp)
+{
+	struct xfs_buftarg	*btp = mp->m_ddev_targp;
+	int			iomin;
+	int			ioopt;
+
+	if (blk_queue_nonrot(btp->bt_bdev->bd_queue))
+		return num_online_cpus();
+	if (mp->m_sb.sb_width && mp->m_sb.sb_unit)
+		return mp->m_sb.sb_width / mp->m_sb.sb_unit;
+	iomin = bdev_io_min(btp->bt_bdev);
+	ioopt = bdev_io_opt(btp->bt_bdev);
+	if (iomin && ioopt)
+		return ioopt / iomin;
+
+	return 1;
+}
diff --git a/fs/xfs/xfs_pwork.h b/fs/xfs/xfs_pwork.h
new file mode 100644
index 000000000000..e0c1354a2d8c
--- /dev/null
+++ b/fs/xfs/xfs_pwork.h
@@ -0,0 +1,50 @@
+// SPDX-License-Identifier: GPL-2.0+
+/*
+ * Copyright (C) 2019 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#ifndef __XFS_PWORK_H__
+#define __XFS_PWORK_H__
+
+struct xfs_pwork;
+struct xfs_mount;
+
+typedef int (*xfs_pwork_work_fn)(struct xfs_mount *mp, struct xfs_pwork *pwork);
+
+/*
+ * Parallel work coordination structure.
+ */
+struct xfs_pwork_ctl {
+	struct workqueue_struct	*wq;
+	struct xfs_mount	*mp;
+	xfs_pwork_work_fn	work_fn;
+	int			error;
+};
+
+/*
+ * Embed this parallel work control item inside your own work structure,
+ * then queue work with it.
+ */
+struct xfs_pwork {
+	struct work_struct	work;
+	struct xfs_pwork_ctl	*pctl;
+};
+
+#define XFS_PWORK_SINGLE_THREADED	{ .pctl = NULL }
+
+/* Have we been told to abort? */
+static inline bool
+xfs_pwork_want_abort(
+	struct xfs_pwork	*pwork)
+{
+	return pwork->pctl && pwork->pctl->error;
+}
+
+int xfs_pwork_init(struct xfs_mount *mp, struct xfs_pwork_ctl *pctl,
+		xfs_pwork_work_fn work_fn, const char *tag,
+		unsigned int nr_threads);
+void xfs_pwork_queue(struct xfs_pwork_ctl *pctl, struct xfs_pwork *pwork);
+int xfs_pwork_destroy(struct xfs_pwork_ctl *pctl);
+unsigned int xfs_pwork_guess_datadev_parallelism(struct xfs_mount *mp);
+
+#endif /* __XFS_PWORK_H__ */
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index a5b2260406a8..e4f3785f7a64 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1305,7 +1305,7 @@ xfs_qm_quotacheck(
 		flags |= XFS_PQUOTA_CHKD;
 	}
 
-	error = xfs_iwalk(mp, NULL, 0, xfs_qm_dqusage_adjust, 0, NULL);
+	error = xfs_iwalk_threaded(mp, 0, xfs_qm_dqusage_adjust, 0, NULL);
 	if (error)
 		goto error_return;
 
diff --git a/fs/xfs/xfs_sysctl.h b/fs/xfs/xfs_sysctl.h
index ad7f9be13087..b555e045e2f4 100644
--- a/fs/xfs/xfs_sysctl.h
+++ b/fs/xfs/xfs_sysctl.h
@@ -37,6 +37,9 @@ typedef struct xfs_param {
 	xfs_sysctl_val_t fstrm_timer;	/* Filestream dir-AG assoc'n timeout. */
 	xfs_sysctl_val_t eofb_timer;	/* Interval between eofb scan wakeups */
 	xfs_sysctl_val_t cowb_timer;	/* Interval between cowb scan wakeups */
+#ifdef DEBUG
+	xfs_sysctl_val_t pwork_threads;	/* Parallel workqueue thread count */
+#endif
 } xfs_param_t;
 
 /*
@@ -82,6 +85,9 @@ enum {
 extern xfs_param_t	xfs_params;
 
 struct xfs_globals {
+#ifdef DEBUG
+	int	pwork_threads;		/* parallel workqueue threads */
+#endif
 	int	log_recovery_delay;	/* log recovery delay (secs) */
 	int	mount_delay;		/* mount setup delay (secs) */
 	bool	bug_on_assert;		/* BUG() the kernel on assert failure */
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index cabda13f3c64..910e6b9cb1a7 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -206,11 +206,51 @@ always_cow_show(
 }
 XFS_SYSFS_ATTR_RW(always_cow);
 
+#ifdef DEBUG
+/*
+ * Override how many threads the parallel work queue is allowed to create.
+ * This has to be a debug-only global (instead of an errortag) because one of
+ * the main users of parallel workqueues is mount time quotacheck.
+ */
+STATIC ssize_t
+pwork_threads_store(
+	struct kobject	*kobject,
+	const char	*buf,
+	size_t		count)
+{
+	int		ret;
+	int		val;
+
+	ret = kstrtoint(buf, 0, &val);
+	if (ret)
+		return ret;
+
+	if (val < 0 || val > NR_CPUS)
+		return -EINVAL;
+
+	xfs_globals.pwork_threads = val;
+
+	return count;
+}
+
+STATIC ssize_t
+pwork_threads_show(
+	struct kobject	*kobject,
+	char		*buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%d\n", xfs_globals.pwork_threads);
+}
+XFS_SYSFS_ATTR_RW(pwork_threads);
+#endif /* DEBUG */
+
 static struct attribute *xfs_dbg_attrs[] = {
 	ATTR_LIST(bug_on_assert),
 	ATTR_LIST(log_recovery_delay),
 	ATTR_LIST(mount_delay),
 	ATTR_LIST(always_cow),
+#ifdef DEBUG
+	ATTR_LIST(pwork_threads),
+#endif
 	NULL,
 };
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index f9bb1d50bc0e..658cbade1998 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3556,6 +3556,24 @@ TRACE_EVENT(xfs_iwalk_ag_rec,
 		  __entry->startino, __entry->freemask)
 )
 
+TRACE_EVENT(xfs_pwork_init,
+	TP_PROTO(struct xfs_mount *mp, unsigned int nr_threads, pid_t pid),
+	TP_ARGS(mp, nr_threads, pid),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned int, nr_threads)
+		__field(pid_t, pid)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->nr_threads = nr_threads;
+		__entry->pid = pid;
+	),
+	TP_printk("dev %d:%d nr_threads %u pid %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->nr_threads, __entry->pid)
+)
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH

