Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEC2EE0BF0
	for <lists+linux-xfs@lfdr.de>; Tue, 22 Oct 2019 20:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732818AbfJVSv4 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 22 Oct 2019 14:51:56 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52414 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732322AbfJVSv4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Oct 2019 14:51:56 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIiAHf089119;
        Tue, 22 Oct 2019 18:51:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=zzWITVVxjy1Zjq/VSU89wd8QsMpujQyvolNVtGMFJ04=;
 b=gux/Tj9zRubdCVJJ09gOtch+u5xQFsTGDaYCyPXDkDVJjEh3qzZQ6VJ9FcHMxnscReDK
 mEVCs63mERHjptbhXALv6220yPB1knhWslsVLpbI95aQTXBzE45c41dUQvZQVUYUdZ+9
 OGQqf3plKRTRv6h8cEJfvgcrb+TlGHwGldJqFzhM+YklsSnmqY0km8C7OGpwoP0mmm1n
 B613l+JOr3h1xdsn4/YdVSR4aclWDMJrMG4G3WuviGp7qToZH64oiPzMRv/odhjDTN8B
 uPiAoyI2wOEUAZCurMhCTzcvn+XohXP5VLfFwLIVZPKc9qX4Od2FyvVyrcZrjlIHqwWg nQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2vqu4qrkqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:51:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9MIhNnf125173;
        Tue, 22 Oct 2019 18:49:51 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2vsx239t7q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Oct 2019 18:49:51 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9MInoQW030719;
        Tue, 22 Oct 2019 18:49:50 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 22 Oct 2019 11:49:50 -0700
Subject: [PATCH 2/3] xfs_scrub: implement deferred description string
 rendering
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 22 Oct 2019 11:49:49 -0700
Message-ID: <157177018914.1460581.6983232302876165323.stgit@magnolia>
In-Reply-To: <157177017664.1460581.13561167273786314634.stgit@magnolia>
References: <157177017664.1460581.13561167273786314634.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910220156
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9418 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910220156
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

A flamegraph analysis of xfs_scrub runtimes showed that we spend 7-10%
of the program's userspace runtime rendering prefix strings in case we
want to show a message about something we're checking, whether or not
that string ever actually gets used.

For a non-verbose run on a clean filesystem, this work is totally
unnecessary.  We could defer the message catalog lookup and snprintf
call until we actually need that message, so build enough of a function
closure mechanism so that we can capture some location information when
its convenient and push that all the way to the edge of the call graph
and only when we need it.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 scrub/Makefile    |    2 +
 scrub/descr.c     |  106 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 scrub/descr.h     |   29 +++++++++++++++
 scrub/scrub.c     |   73 +++++++++++++++++++++----------------
 scrub/xfs_scrub.c |    8 ++++
 5 files changed, 186 insertions(+), 32 deletions(-)
 create mode 100644 scrub/descr.c
 create mode 100644 scrub/descr.h


diff --git a/scrub/Makefile b/scrub/Makefile
index 882da8fd..47c887eb 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -34,6 +34,7 @@ endif	# scrub_prereqs
 HFILES = \
 common.h \
 counter.h \
+descr.h \
 disk.h \
 filemap.h \
 fscounters.h \
@@ -50,6 +51,7 @@ xfs_scrub.h
 CFILES = \
 common.c \
 counter.c \
+descr.c \
 disk.c \
 filemap.c \
 fscounters.c \
diff --git a/scrub/descr.c b/scrub/descr.c
new file mode 100644
index 00000000..7f65a4e0
--- /dev/null
+++ b/scrub/descr.c
@@ -0,0 +1,106 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2019 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#include "xfs.h"
+#include <assert.h>
+#include <sys/statvfs.h>
+#include "platform_defs.h"
+#include "input.h"
+#include "libfrog/paths.h"
+#include "libfrog/ptvar.h"
+#include "xfs_scrub.h"
+#include "common.h"
+#include "descr.h"
+
+/*
+ * Deferred String Description Renderer
+ * ====================================
+ * There are many places in xfs_scrub where some event occurred and we'd like
+ * to be able to print some sort of message describing what happened, and
+ * where.  However, we don't know whether we're going to need the description
+ * of where ahead of time and there's little point in spending any time looking
+ * up gettext strings and formatting buffers until we actually need to.
+ *
+ * This code provides enough of a function closure that we are able to record
+ * some information about the program status but defer rendering the textual
+ * description until we know that we need it.  Once we've rendered the string
+ * we can skip it for subsequent calls.  We use per-thread storage for the
+ * message buffer to amortize the memory allocation across calls.
+ *
+ * On a clean filesystem this can reduce the xfs_scrub runtime by 7-10% by
+ * avoiding unnecessary work.
+ */
+
+static struct ptvar *descr_ptvar;
+
+/* Global buffer for when we aren't running in threaded mode. */
+static char global_dsc_buf[DESCR_BUFSZ];
+
+/*
+ * Render a textual description string using the function and location stored
+ * in the description context.
+ */
+const char *
+__descr_render(
+	struct descr		*dsc,
+	const char		*file,
+	int			line)
+{
+	char			*dsc_buf;
+	int			ret;
+
+	if (descr_ptvar) {
+		dsc_buf = ptvar_get(descr_ptvar, &ret);
+		if (ret)
+			return _("error finding description buffer");
+	} else
+		dsc_buf = global_dsc_buf;
+
+	ret = dsc->fn(dsc->ctx, dsc_buf, DESCR_BUFSZ, dsc->where);
+	if (ret < 0) {
+		snprintf(dsc_buf, DESCR_BUFSZ,
+_("error %d while rendering description at %s line %d\n"),
+				ret, file, line);
+	}
+
+	return dsc_buf;
+}
+
+/*
+ * Set a new location for this deferred-rendering string and discard any
+ * old rendering.
+ */
+void
+descr_set(
+	struct descr		*dsc,
+	void			*where)
+{
+	dsc->where = where;
+}
+
+/* Allocate all the description string buffers. */
+int
+descr_init_phase(
+	struct scrub_ctx	*ctx,
+	unsigned int		nr_threads)
+{
+	int			ret;
+
+	assert(descr_ptvar == NULL);
+	ret = ptvar_alloc(nr_threads, DESCR_BUFSZ, &descr_ptvar);
+	if (ret)
+		str_liberror(ctx, ret, _("creating description buffer"));
+
+	return ret;
+}
+
+/* Free all the description string buffers. */
+void
+descr_end_phase(void)
+{
+	if (descr_ptvar)
+		ptvar_free(descr_ptvar);
+	descr_ptvar = NULL;
+}
diff --git a/scrub/descr.h b/scrub/descr.h
new file mode 100644
index 00000000..f1899b67
--- /dev/null
+++ b/scrub/descr.h
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (C) 2019 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#ifndef XFS_SCRUB_DESCR_H_
+#define XFS_SCRUB_DESCR_H_
+
+typedef int (*descr_fn)(struct scrub_ctx *ctx, char *buf, size_t buflen,
+			void *data);
+
+struct descr {
+	struct scrub_ctx	*ctx;
+	descr_fn		fn;
+	void			*where;
+};
+
+#define DEFINE_DESCR(_name, _ctx, _fn) \
+	struct descr _name = { .ctx = (_ctx), .fn = (_fn) }
+
+const char *__descr_render(struct descr *dsc, const char *file, int line);
+#define descr_render(dsc) __descr_render((dsc), __FILE__, __LINE__)
+
+void descr_set(struct descr *dsc, void *where);
+
+int descr_init_phase(struct scrub_ctx *ctx, unsigned int nr_threads);
+void descr_end_phase(void);
+
+#endif /* XFS_SCRUB_DESCR_H_ */
diff --git a/scrub/scrub.c b/scrub/scrub.c
index 718f09b8..d9df1e5b 100644
--- a/scrub/scrub.c
+++ b/scrub/scrub.c
@@ -20,37 +20,40 @@
 #include "scrub.h"
 #include "xfs_errortag.h"
 #include "repair.h"
+#include "descr.h"
 
 /* Online scrub and repair wrappers. */
 
 /* Format a scrub description. */
-static void
+static int
 format_scrub_descr(
 	struct scrub_ctx		*ctx,
 	char				*buf,
 	size_t				buflen,
-	struct xfs_scrub_metadata	*meta)
+	void				*where)
 {
+	struct xfs_scrub_metadata	*meta = where;
 	const struct xfrog_scrub_descr	*sc = &xfrog_scrubbers[meta->sm_type];
 
 	switch (sc->type) {
 	case XFROG_SCRUB_TYPE_AGHEADER:
 	case XFROG_SCRUB_TYPE_PERAG:
-		snprintf(buf, buflen, _("AG %u %s"), meta->sm_agno,
+		return snprintf(buf, buflen, _("AG %u %s"), meta->sm_agno,
 				_(sc->descr));
 		break;
 	case XFROG_SCRUB_TYPE_INODE:
-		scrub_render_ino_descr(ctx, buf, buflen,
+		return scrub_render_ino_descr(ctx, buf, buflen,
 				meta->sm_ino, meta->sm_gen, "%s",
 				_(sc->descr));
 		break;
 	case XFROG_SCRUB_TYPE_FS:
-		snprintf(buf, buflen, _("%s"), _(sc->descr));
+		return snprintf(buf, buflen, _("%s"), _(sc->descr));
 		break;
 	case XFROG_SCRUB_TYPE_NONE:
 		assert(0);
 		break;
 	}
+	return -1;
 }
 
 /* Predicates for scrub flag state. */
@@ -95,21 +98,24 @@ static inline bool needs_repair(struct xfs_scrub_metadata *sm)
 static inline void
 xfs_scrub_warn_incomplete_scrub(
 	struct scrub_ctx		*ctx,
-	const char			*descr,
+	struct descr			*dsc,
 	struct xfs_scrub_metadata	*meta)
 {
 	if (is_incomplete(meta))
-		str_info(ctx, descr, _("Check incomplete."));
+		str_info(ctx, descr_render(dsc), _("Check incomplete."));
 
 	if (is_suspicious(meta)) {
 		if (debug)
-			str_info(ctx, descr, _("Possibly suspect metadata."));
+			str_info(ctx, descr_render(dsc),
+					_("Possibly suspect metadata."));
 		else
-			str_warn(ctx, descr, _("Possibly suspect metadata."));
+			str_warn(ctx, descr_render(dsc),
+					_("Possibly suspect metadata."));
 	}
 
 	if (xref_failed(meta))
-		str_info(ctx, descr, _("Cross-referencing failed."));
+		str_info(ctx, descr_render(dsc),
+				_("Cross-referencing failed."));
 }
 
 /* Do a read-only check of some metadata. */
@@ -119,16 +125,16 @@ xfs_check_metadata(
 	struct xfs_scrub_metadata	*meta,
 	bool				is_inode)
 {
-	char				buf[DESCR_BUFSZ];
+	DEFINE_DESCR(dsc, ctx, format_scrub_descr);
 	unsigned int			tries = 0;
 	int				code;
 	int				error;
 
 	assert(!debug_tweak_on("XFS_SCRUB_NO_KERNEL"));
 	assert(meta->sm_type < XFS_SCRUB_TYPE_NR);
-	format_scrub_descr(ctx, buf, DESCR_BUFSZ, meta);
+	descr_set(&dsc, meta);
 
-	dbg_printf("check %s flags %xh\n", buf, meta->sm_flags);
+	dbg_printf("check %s flags %xh\n", descr_render(&dsc), meta->sm_flags);
 retry:
 	error = xfrog_scrub_metadata(&ctx->mnt, meta);
 	if (debug_tweak_on("XFS_SCRUB_FORCE_REPAIR") && !error)
@@ -141,13 +147,13 @@ xfs_check_metadata(
 			return CHECK_DONE;
 		case ESHUTDOWN:
 			/* FS already crashed, give up. */
-			str_error(ctx, buf,
+			str_error(ctx, descr_render(&dsc),
 _("Filesystem is shut down, aborting."));
 			return CHECK_ABORT;
 		case EIO:
 		case ENOMEM:
 			/* Abort on I/O errors or insufficient memory. */
-			str_errno(ctx, buf);
+			str_errno(ctx, descr_render(&dsc));
 			return CHECK_ABORT;
 		case EDEADLOCK:
 		case EBUSY:
@@ -161,7 +167,7 @@ _("Filesystem is shut down, aborting."));
 			/* fall through */
 		default:
 			/* Operational error. */
-			str_errno(ctx, buf);
+			str_errno(ctx, descr_render(&dsc));
 			return CHECK_DONE;
 		}
 	}
@@ -179,7 +185,7 @@ _("Filesystem is shut down, aborting."));
 	}
 
 	/* Complain about incomplete or suspicious metadata. */
-	xfs_scrub_warn_incomplete_scrub(ctx, buf, meta);
+	xfs_scrub_warn_incomplete_scrub(ctx, &dsc, meta);
 
 	/*
 	 * If we need repairs or there were discrepancies, schedule a
@@ -187,7 +193,7 @@ _("Filesystem is shut down, aborting."));
 	 */
 	if (is_corrupt(meta) || xref_disagrees(meta)) {
 		if (ctx->mode < SCRUB_MODE_REPAIR) {
-			str_corrupt(ctx, buf,
+			str_corrupt(ctx, descr_render(&dsc),
 _("Repairs are required."));
 			return CHECK_DONE;
 		}
@@ -203,7 +209,7 @@ _("Repairs are required."));
 		if (ctx->mode != SCRUB_MODE_REPAIR) {
 			if (!is_inode) {
 				/* AG or FS metadata, always warn. */
-				str_info(ctx, buf,
+				str_info(ctx, descr_render(&dsc),
 _("Optimization is possible."));
 			} else if (!ctx->preen_triggers[meta->sm_type]) {
 				/* File metadata, only warn once per type. */
@@ -656,9 +662,9 @@ xfs_repair_metadata(
 	struct action_item		*aitem,
 	unsigned int			repair_flags)
 {
-	char				buf[DESCR_BUFSZ];
 	struct xfs_scrub_metadata	meta = { 0 };
 	struct xfs_scrub_metadata	oldm;
+	DEFINE_DESCR(dsc, ctx, format_scrub_descr);
 	int				error;
 
 	assert(aitem->type < XFS_SCRUB_TYPE_NR);
@@ -682,12 +688,13 @@ xfs_repair_metadata(
 		return CHECK_RETRY;
 
 	memcpy(&oldm, &meta, sizeof(oldm));
-	format_scrub_descr(ctx, buf, DESCR_BUFSZ, &meta);
+	descr_set(&dsc, &oldm);
 
 	if (needs_repair(&meta))
-		str_info(ctx, buf, _("Attempting repair."));
+		str_info(ctx, descr_render(&dsc), _("Attempting repair."));
 	else if (debug || verbose)
-		str_info(ctx, buf, _("Attempting optimization."));
+		str_info(ctx, descr_render(&dsc),
+				_("Attempting optimization."));
 
 	error = xfrog_scrub_metadata(&ctx->mnt, &meta);
 	if (error) {
@@ -696,12 +703,12 @@ xfs_repair_metadata(
 		case EBUSY:
 			/* Filesystem is busy, try again later. */
 			if (debug || verbose)
-				str_info(ctx, buf,
+				str_info(ctx, descr_render(&dsc),
 _("Filesystem is busy, deferring repair."));
 			return CHECK_RETRY;
 		case ESHUTDOWN:
 			/* Filesystem is already shut down, abort. */
-			str_error(ctx, buf,
+			str_error(ctx, descr_render(&dsc),
 _("Filesystem is shut down, aborting."));
 			return CHECK_ABORT;
 		case ENOTTY:
@@ -726,13 +733,13 @@ _("Filesystem is shut down, aborting."));
 			/* fall through */
 		case EINVAL:
 			/* Kernel doesn't know how to repair this? */
-			str_corrupt(ctx, buf,
+			str_corrupt(ctx, descr_render(&dsc),
 _("Don't know how to fix; offline repair required."));
 			return CHECK_DONE;
 		case EROFS:
 			/* Read-only filesystem, can't fix. */
 			if (verbose || debug || needs_repair(&oldm))
-				str_error(ctx, buf,
+				str_error(ctx, descr_render(&dsc),
 _("Read-only filesystem; cannot make changes."));
 			return CHECK_ABORT;
 		case ENOENT:
@@ -753,12 +760,12 @@ _("Read-only filesystem; cannot make changes."));
 			 */
 			if (!(repair_flags & XRM_COMPLAIN_IF_UNFIXED))
 				return CHECK_RETRY;
-			str_errno(ctx, buf);
+			str_errno(ctx, descr_render(&dsc));
 			return CHECK_DONE;
 		}
 	}
 	if (repair_flags & XRM_COMPLAIN_IF_UNFIXED)
-		xfs_scrub_warn_incomplete_scrub(ctx, buf, &meta);
+		xfs_scrub_warn_incomplete_scrub(ctx, &dsc, &meta);
 	if (needs_repair(&meta)) {
 		/*
 		 * Still broken; if we've been told not to complain then we
@@ -767,14 +774,16 @@ _("Read-only filesystem; cannot make changes."));
 		 */
 		if (!(repair_flags & XRM_COMPLAIN_IF_UNFIXED))
 			return CHECK_RETRY;
-		str_corrupt(ctx, buf,
+		str_corrupt(ctx, descr_render(&dsc),
 _("Repair unsuccessful; offline repair required."));
 	} else {
 		/* Clean operation, no corruption detected. */
 		if (needs_repair(&oldm))
-			record_repair(ctx, buf, _("Repairs successful."));
+			record_repair(ctx, descr_render(&dsc),
+					_("Repairs successful."));
 		else
-			record_preen(ctx, buf, _("Optimization successful."));
+			record_preen(ctx, descr_render(&dsc),
+					_("Optimization successful."));
 	}
 	return CHECK_DONE;
 }
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index fe76d075..9945c7f4 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -15,6 +15,7 @@
 #include "libfrog/paths.h"
 #include "xfs_scrub.h"
 #include "common.h"
+#include "descr.h"
 #include "unicrash.h"
 #include "progress.h"
 
@@ -467,8 +468,14 @@ run_scrub_phases(
 			work_threads++;
 			moveon = progress_init_phase(ctx, progress_fp, phase,
 					max_work, rshift, work_threads);
+			if (!moveon)
+				break;
+			moveon = descr_init_phase(ctx, work_threads) == 0;
 		} else {
 			moveon = progress_init_phase(ctx, NULL, phase, 0, 0, 0);
+			if (!moveon)
+				break;
+			moveon = descr_init_phase(ctx, 1) == 0;
 		}
 		if (!moveon)
 			break;
@@ -480,6 +487,7 @@ _("Scrub aborted after phase %d."),
 			break;
 		}
 		progress_end_phase();
+		descr_end_phase();
 		moveon = phase_end(&pi, phase);
 		if (!moveon)
 			break;

