Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3123E65A291
	for <lists+linux-xfs@lfdr.de>; Sat, 31 Dec 2022 04:29:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbiLaD3I (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 22:29:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236404AbiLaD3C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:29:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF911165A9
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 19:28:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BA02B81E64
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 03:28:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC53EC433D2;
        Sat, 31 Dec 2022 03:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672457335;
        bh=ihouD6mFGaQ90qPddLMN9fnzBGj59dWS9L+Ecgn+nvI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MsLuSMXhKXKSr4mtk87DzhBGKZOrZr+JzqrYaz0gD2DUgWiD60B5oCyEO8QGXD9cm
         h6DLqh2CfhW2X2vsRLGZDTZqf7kQ/3K+SiQvC27mVXT0oZIPedfhjo/0wiPhf0AAba
         iZPLj3pB4rRiBFj4GUu6oMeUSzTorXZ6jqIdz9UFDyOmpYjX4bT8BFveoOYtLuzN3V
         uuZecp+EYinKVClN4ENX9QTb4IWt8Sd67XUdMJUDrt7vHKYXLt42J8pfAWVd+s7rJy
         2aEz/2Z+QmaGu/BVPzNNsrETP2NE8Qo43/p7N4T6o0PFnnNNnH/4dTtxIE8N7URdRo
         PAMKI1ZTNdVrw==
Subject: [PATCH 4/5] xfs_spaceman: implement clearing free space
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:48 -0800
Message-ID: <167243884818.740087.2981858571326952921.stgit@magnolia>
In-Reply-To: <167243884763.740087.13414287212519500865.stgit@magnolia>
References: <167243884763.740087.13414287212519500865.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

First attempt at evacuating all the used blocks from part of a
filesystem.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 Makefile                |    2 
 libfrog/Makefile        |    6 
 libfrog/clearspace.c    | 2723 +++++++++++++++++++++++++++++++++++++++++++++++
 libfrog/clearspace.h    |   72 +
 man/man8/xfs_spaceman.8 |   17 
 spaceman/Makefile       |    6 
 spaceman/clearfree.c    |  164 +++
 spaceman/init.c         |    1 
 spaceman/space.h        |    2 
 9 files changed, 2989 insertions(+), 4 deletions(-)
 create mode 100644 libfrog/clearspace.c
 create mode 100644 libfrog/clearspace.h
 create mode 100644 spaceman/clearfree.c


diff --git a/Makefile b/Makefile
index 0edc2700933..c7c31444446 100644
--- a/Makefile
+++ b/Makefile
@@ -105,7 +105,7 @@ quota: libxcmd
 repair: libxlog libxcmd
 copy: libxlog
 mkfs: libxcmd
-spaceman: libxcmd
+spaceman: libhandle libxcmd
 scrub: libhandle libxcmd
 rtcp: libfrog
 
diff --git a/libfrog/Makefile b/libfrog/Makefile
index 04aecf1abf1..4031f07e422 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -61,6 +61,12 @@ ifeq ($(HAVE_FIEXCHANGE),yes)
 LCFLAGS += -DHAVE_FIEXCHANGE
 endif
 
+ifeq ($(HAVE_GETFSMAP),yes)
+CFILES+=clearspace.c
+HFILES+=clearspace.h
+endif
+
+
 LDIRT = gen_crc32table crc32table.h crc32selftest
 
 default: crc32selftest ltdepend $(LTLIBRARY)
diff --git a/libfrog/clearspace.c b/libfrog/clearspace.c
new file mode 100644
index 00000000000..601257022b8
--- /dev/null
+++ b/libfrog/clearspace.c
@@ -0,0 +1,2723 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include <linux/fsmap.h>
+#include "paths.h"
+#include "fsgeom.h"
+#include "fsrefcounts.h"
+#include "logging.h"
+#include "bulkstat.h"
+#include "bitmap.h"
+#include "fiexchange.h"
+#include "file_exchange.h"
+#include "clearspace.h"
+#include "handle.h"
+
+/* VFS helpers */
+
+#ifndef FALLOC_FL_MAP_FREE_SPACE
+#define FALLOC_FL_MAP_FREE_SPACE	0x8000
+#endif
+
+/* Remap the file range described by @fcr into fd, or return an errno. */
+static inline int
+clonerange(int fd, struct file_clone_range *fcr)
+{
+	int	ret;
+
+	ret = ioctl(fd, FICLONERANGE, fcr);
+	if (ret)
+		return errno;
+
+	return 0;
+}
+
+/* Exchange the file ranges described by @xchg into fd, or return an errno. */
+static inline int
+exchangerange(int fd, struct file_xchg_range *xchg)
+{
+	int	ret;
+
+	ret = ioctl(fd, FIEXCHANGE_RANGE, xchg);
+	if (ret)
+		return errno;
+
+	return 0;
+}
+
+/*
+ * Deduplicate part of fd into the file range described by fdr.  If the
+ * operation succeeded, we set @same to whether or not we deduped the data and
+ * return zero.  If not, return an errno.
+ */
+static inline int
+deduperange(int fd, struct file_dedupe_range *fdr, bool *same)
+{
+	struct file_dedupe_range_info *info = &fdr->info[0];
+	int	ret;
+
+	assert(fdr->dest_count == 1);
+	*same = false;
+
+	ret = ioctl(fd, FIDEDUPERANGE, fdr);
+	if (ret)
+		return errno;
+
+	if (info->status < 0)
+		return -info->status;
+
+	if (info->status == FILE_DEDUPE_RANGE_DIFFERS)
+		return 0;
+
+	/* The kernel should never dedupe more than it was asked. */
+	assert(fdr->src_length >= info->bytes_deduped);
+
+	*same = true;
+	return 0;
+}
+
+/* Space clearing operation control */
+
+#define QUERY_BATCH_SIZE		1024
+
+struct clearspace_tgt {
+	unsigned long long	start;
+	unsigned long long	length;
+	unsigned long long	owners;
+	unsigned long long	prio;
+	unsigned long long	evacuated;
+	bool			try_again;
+};
+
+struct clearspace_req {
+	struct xfs_fd		*xfd;
+
+	/* all the blocks that we've tried to clear */
+	struct bitmap		*visited;
+
+	/* stat buffer of the open file */
+	struct stat		statbuf;
+	struct stat		temp_statbuf;
+	struct stat		space_statbuf;
+
+	/* handle to this filesystem */
+	void			*fshandle;
+	size_t			fshandle_sz;
+
+	/* physical storage that we want to clear */
+	unsigned long long	start;
+	unsigned long long	length;
+	dev_t			dev;
+
+	/* convenience variable */
+	bool			realtime:1;
+	bool			use_reflink:1;
+	bool			can_evac_metadata:1;
+
+	/*
+	 * The "space capture" file.  Each extent in this file must be mapped
+	 * to the same byte offset as the byte address of the physical space.
+	 */
+	int			space_fd;
+
+	/* work file for migrating file data */
+	int			work_fd;
+
+	/* preallocated buffers for queries */
+	struct getbmapx		*bhead;
+	struct fsmap_head	*mhead;
+	struct fsrefs_head	*rhead;
+
+	/* buffer for copying data */
+	char			*buf;
+
+	/* buffer for deduping data */
+	struct file_dedupe_range *fdr;
+
+	/* tracing mask and indent level */
+	unsigned int		trace_mask;
+	unsigned int		trace_indent;
+};
+
+static inline bool
+csp_is_internal_owner(
+	const struct clearspace_req	*req,
+	unsigned long long		owner)
+{
+	return owner == req->temp_statbuf.st_ino ||
+	       owner == req->space_statbuf.st_ino;
+}
+
+/* Debugging stuff */
+
+static const struct csp_errstr {
+	unsigned int		mask;
+	const char		*tag;
+} errtags[] = {
+	{ CSP_TRACE_FREEZE,	"freeze" },
+	{ CSP_TRACE_GRAB,	"grab" },
+	{ CSP_TRACE_PREP,	"prep" },
+	{ CSP_TRACE_TARGET,	"target" },
+	{ CSP_TRACE_DEDUPE,	"dedupe" },
+	{ CSP_TRACE_FIEXCHANGE, "fiexchange" },
+	{ CSP_TRACE_XREBUILD,	"rebuild" },
+	{ CSP_TRACE_EFFICACY,	"efficacy" },
+	{ CSP_TRACE_SETUP,	"setup" },
+	{ CSP_TRACE_DUMPFILE,	"dumpfile" },
+	{ CSP_TRACE_BITMAP,	"bitmap" },
+
+	/* prioritize high level functions over low level queries for tagging */
+	{ CSP_TRACE_FSMAP,	"fsmap" },
+	{ CSP_TRACE_FSREFS,	"fsrefs" },
+	{ CSP_TRACE_BMAPX,	"bmapx" },
+	{ CSP_TRACE_FALLOC,	"falloc" },
+	{ CSP_TRACE_STATUS,	"status" },
+	{ 0, NULL },
+};
+
+static void
+csp_debug(
+	struct clearspace_req	*req,
+	unsigned int		mask,
+	const char		*func,
+	int			line,
+	const char		*format,
+	...)
+{
+	const struct csp_errstr	*et = errtags;
+	bool			debug = (req->trace_mask & ~CSP_TRACE_STATUS);
+	int			indent = req->trace_indent;
+	va_list			args;
+
+	if ((req->trace_mask & mask) != mask)
+		return;
+
+	if (debug) {
+		while (indent > 0) {
+			fprintf(stderr, "  ");
+			indent--;
+		}
+
+		for (; et->tag; et++) {
+			if (et->mask & mask) {
+				fprintf(stderr, "%s: ", et->tag);
+				break;
+			}
+		}
+	}
+
+	va_start(args, format);
+	vfprintf(stderr, format, args);
+	va_end(args);
+
+	if (debug)
+		fprintf(stderr, " (line %d)\n", line);
+	else
+		fprintf(stderr, "\n");
+	fflush(stderr);
+}
+
+#define trace_freeze(req, format, ...)	\
+	csp_debug((req), CSP_TRACE_FREEZE, __func__, __LINE__, format, __VA_ARGS__)
+
+#define trace_grabfree(req, format, ...)	\
+	csp_debug((req), CSP_TRACE_GRAB, __func__, __LINE__, format, __VA_ARGS__)
+
+#define trace_fsmap(req, format, ...)	\
+	csp_debug((req), CSP_TRACE_FSMAP, __func__, __LINE__, format, __VA_ARGS__)
+
+#define trace_fsmap_rec(req, mask, mrec)	\
+	while (!csp_is_internal_owner((req), (mrec)->fmr_owner)) { \
+		csp_debug((req), (mask) | CSP_TRACE_FSMAP, __func__, __LINE__, \
+"fsmap phys 0x%llx owner 0x%llx offset 0x%llx bytecount 0x%llx flags 0x%x", \
+				(unsigned long long)(mrec)->fmr_physical, \
+				(unsigned long long)(mrec)->fmr_owner, \
+				(unsigned long long)(mrec)->fmr_offset, \
+				(unsigned long long)(mrec)->fmr_length, \
+				(mrec)->fmr_flags); \
+		break; \
+	}
+
+#define trace_fsrefs(req, format, ...)	\
+	csp_debug((req), CSP_TRACE_FSREFS, __func__, __LINE__, format, __VA_ARGS__)
+
+#define trace_fsrefs_rec(req, mask, rrec)	\
+	csp_debug((req), (mask) | CSP_TRACE_FSREFS, __func__, __LINE__, \
+"fsref phys 0x%llx bytecount 0x%llx owners %llu flags 0x%x", \
+			(unsigned long long)(rrec)->fcr_physical, \
+			(unsigned long long)(rrec)->fcr_length, \
+			(unsigned long long)(rrec)->fcr_owners, \
+			(rrec)->fcr_flags)
+
+#define trace_bmapx(req, format, ...)	\
+	csp_debug((req), CSP_TRACE_BMAPX, __func__, __LINE__, format, __VA_ARGS__)
+
+#define trace_bmapx_rec(req, mask, brec)	\
+	csp_debug((req), (mask) | CSP_TRACE_BMAPX, __func__, __LINE__, \
+"bmapx pos 0x%llx bytecount 0x%llx phys 0x%llx flags 0x%x", \
+			(unsigned long long)BBTOB((brec)->bmv_offset), \
+			(unsigned long long)BBTOB((brec)->bmv_length), \
+			(unsigned long long)BBTOB((brec)->bmv_block), \
+			(brec)->bmv_oflags)
+
+#define trace_prep(req, format, ...)	\
+	csp_debug((req), CSP_TRACE_PREP, __func__, __LINE__, format, __VA_ARGS__)
+
+#define trace_target(req, format, ...)	\
+	csp_debug((req), CSP_TRACE_TARGET, __func__, __LINE__, format, __VA_ARGS__)
+
+#define trace_dedupe(req, format, ...)	\
+	csp_debug((req), CSP_TRACE_DEDUPE, __func__, __LINE__, format, __VA_ARGS__)
+
+#define trace_falloc(req, format, ...)	\
+	csp_debug((req), CSP_TRACE_FALLOC, __func__, __LINE__, format, __VA_ARGS__)
+
+#define trace_fiexchange(req, format, ...)	\
+	csp_debug((req), CSP_TRACE_FIEXCHANGE, __func__, __LINE__, format, __VA_ARGS__)
+
+#define trace_xrebuild(req, format, ...)	\
+	csp_debug((req), CSP_TRACE_XREBUILD, __func__, __LINE__, format, __VA_ARGS__)
+
+#define trace_setup(req, format, ...)	\
+	csp_debug((req), CSP_TRACE_SETUP, __func__, __LINE__, format, __VA_ARGS__)
+
+#define trace_status(req, format, ...)	\
+	csp_debug((req), CSP_TRACE_STATUS, __func__, __LINE__, format, __VA_ARGS__)
+
+#define trace_dumpfile(req, format, ...)	\
+	csp_debug((req), CSP_TRACE_DUMPFILE, __func__, __LINE__, format, __VA_ARGS__)
+
+#define trace_bitmap(req, format, ...)	\
+	csp_debug((req), CSP_TRACE_BITMAP, __func__, __LINE__, format, __VA_ARGS__)
+
+/* VFS Iteration helpers */
+
+static inline void
+start_spacefd_iter(struct clearspace_req *req)
+{
+	req->trace_indent++;
+}
+
+static inline void
+end_spacefd_iter(struct clearspace_req *req)
+{
+	req->trace_indent--;
+}
+
+/*
+ * Iterate each hole in the space-capture file.  Returns 1 if holepos/length
+ * has been set to a hole; 0 if there aren't any holes left, or -1 for error.
+ */
+static inline int
+spacefd_hole_iter(
+	const struct clearspace_req	*req,
+	loff_t			*holepos,
+	loff_t			*length)
+{
+	loff_t			end = req->start + req->length;
+	loff_t			h;
+	loff_t			d;
+
+	if (*length == 0)
+		d = req->start;
+	else
+		d = *holepos + *length;
+	if (d >= end)
+		return 0;
+
+	h = lseek(req->space_fd, d, SEEK_HOLE);
+	if (h < 0) {
+		perror(_("finding start of hole in space capture file"));
+		return h;
+	}
+	if (h >= end)
+		return 0;
+
+	d = lseek(req->space_fd, h, SEEK_DATA);
+	if (d < 0 && errno == ENXIO)
+		d = end;
+	if (d < 0) {
+		perror(_("finding end of hole in space capture file"));
+		return d;
+	}
+	if (d > end)
+		d = end;
+
+	*holepos = h;
+	*length = d - h;
+	return 1;
+}
+
+/*
+ * Iterate each written region in the space-capture file.  Returns 1 if
+ * datapos/length have been set to a data area; 0 if there isn't any data left,
+ * or -1 for error.
+ */
+static int
+spacefd_data_iter(
+	const struct clearspace_req	*req,
+	loff_t			*datapos,
+	loff_t			*length)
+{
+	loff_t			end = req->start + req->length;
+	loff_t			d;
+	loff_t			h;
+
+	if (*length == 0)
+		h = req->start;
+	else
+		h = *datapos + *length;
+	if (h >= end)
+		return 0;
+
+	d = lseek(req->space_fd, h, SEEK_DATA);
+	if (d < 0 && errno == ENXIO)
+		return 0;
+	if (d < 0) {
+		perror(_("finding start of data in space capture file"));
+		return d;
+	}
+	if (d >= end)
+		return 0;
+
+	h = lseek(req->space_fd, d, SEEK_HOLE);
+	if (h < 0) {
+		perror(_("finding end of data in space capture file"));
+		return h;
+	}
+	if (h > end)
+		h = end;
+
+	*datapos = d;
+	*length = h - d;
+	return 1;
+}
+
+/* Filesystem space usage queries */
+
+/* Allocate the structures needed for a fsmap query. */
+static void
+start_fsmap_query(
+	struct clearspace_req	*req,
+	dev_t			dev,
+	unsigned long long	physical,
+	unsigned long long	length)
+{
+	struct fsmap_head	*mhead = req->mhead;
+
+	assert(req->mhead->fmh_count == 0);
+	memset(mhead, 0, sizeof(struct fsmap_head));
+	mhead->fmh_count = QUERY_BATCH_SIZE;
+	mhead->fmh_keys[0].fmr_device = dev;
+	mhead->fmh_keys[0].fmr_physical = physical;
+	mhead->fmh_keys[1].fmr_device = dev;
+	mhead->fmh_keys[1].fmr_physical = physical + length;
+	mhead->fmh_keys[1].fmr_owner = ULLONG_MAX;
+	mhead->fmh_keys[1].fmr_flags = UINT_MAX;
+	mhead->fmh_keys[1].fmr_offset = ULLONG_MAX;
+
+	trace_fsmap(req, "dev %u:%u physical 0x%llx bytecount 0x%llx highkey 0x%llx",
+			major(dev), minor(dev),
+			(unsigned long long)physical,
+			(unsigned long long)length,
+			(unsigned long long)mhead->fmh_keys[1].fmr_physical);
+	req->trace_indent++;
+}
+
+static inline void
+end_fsmap_query(
+	struct clearspace_req	*req)
+{
+	req->trace_indent--;
+	req->mhead->fmh_count = 0;
+}
+
+/* Set us up for the next run_fsmap_query, or return false. */
+static inline bool
+advance_fsmap_cursor(struct fsmap_head *mhead)
+{
+	struct fsmap	*mrec;
+
+	mrec = &mhead->fmh_recs[mhead->fmh_entries - 1];
+	if (mrec->fmr_flags & FMR_OF_LAST)
+		return false;
+
+	fsmap_advance(mhead);
+	return true;
+}
+
+/*
+ * Run a GETFSMAP query.  Returns 1 if there are rows, 0 if there are no rows,
+ * or -1 for error.
+ */
+static inline int
+run_fsmap_query(
+	struct clearspace_req	*req)
+{
+	struct fsmap_head	*mhead = req->mhead;
+	int			ret;
+
+	if (mhead->fmh_entries > 0 && !advance_fsmap_cursor(mhead))
+		return 0;
+
+	trace_fsmap(req,
+ "ioctl dev %u:%u physical 0x%llx length 0x%llx highkey 0x%llx",
+			major(mhead->fmh_keys[0].fmr_device),
+			minor(mhead->fmh_keys[0].fmr_device),
+			(unsigned long long)mhead->fmh_keys[0].fmr_physical,
+			(unsigned long long)mhead->fmh_keys[0].fmr_length,
+			(unsigned long long)mhead->fmh_keys[1].fmr_physical);
+
+	ret = ioctl(req->xfd->fd, FS_IOC_GETFSMAP, mhead);
+	if (ret) {
+		perror(_("querying fsmap data"));
+		return -1;
+	}
+
+	if (!(mhead->fmh_oflags & FMH_OF_DEV_T)) {
+		fprintf(stderr, _("fsmap does not return dev_t.\n"));
+		return -1;
+	}
+
+	if (mhead->fmh_entries == 0)
+		return 0;
+
+	return 1;
+}
+
+#define for_each_fsmap_row(req, rec) \
+	for ((rec) = (req)->mhead->fmh_recs; \
+	     (rec) < (req)->mhead->fmh_recs + (req)->mhead->fmh_entries; \
+	     (rec)++)
+
+/* Allocate the structures needed for a fsrefcounts query. */
+static void
+start_fsrefs_query(
+	struct clearspace_req	*req,
+	dev_t			dev,
+	unsigned long long	physical,
+	unsigned long long	length)
+{
+	struct fsrefs_head	*rhead = req->rhead;
+
+	assert(req->rhead->fch_count == 0);
+	memset(rhead, 0, sizeof(struct fsrefs_head));
+	rhead->fch_count = QUERY_BATCH_SIZE;
+	rhead->fch_keys[0].fcr_device = dev;
+	rhead->fch_keys[0].fcr_physical = physical;
+	rhead->fch_keys[1].fcr_device = dev;
+	rhead->fch_keys[1].fcr_physical = physical + length;
+	rhead->fch_keys[1].fcr_owners = ULLONG_MAX;
+	rhead->fch_keys[1].fcr_flags = UINT_MAX;
+
+	trace_fsrefs(req, "dev %u:%u physical 0x%llx bytecount 0x%llx highkey 0x%llx",
+			major(dev), minor(dev),
+			(unsigned long long)physical,
+			(unsigned long long)length,
+			(unsigned long long)rhead->fch_keys[1].fcr_physical);
+	req->trace_indent++;
+}
+
+static inline void
+end_fsrefs_query(
+	struct clearspace_req	*req)
+{
+	req->trace_indent--;
+	req->rhead->fch_count = 0;
+}
+
+/* Set us up for the next run_fsrefs_query, or return false. */
+static inline bool
+advance_fsrefs_query(struct fsrefs_head *rhead)
+{
+	struct fsrefs	*rrec;
+
+	rrec = &rhead->fch_recs[rhead->fch_entries - 1];
+	if (rrec->fcr_flags & FCR_OF_LAST)
+		return false;
+
+	fsrefs_advance(rhead);
+	return true;
+}
+
+/*
+ * Run a GETFSREFCOUNTS query.  Returns 1 if there are rows, 0 if there are
+ * no rows, or -1 for error.
+ */
+static inline int
+run_fsrefs_query(
+	struct clearspace_req	*req)
+{
+	struct fsrefs_head	*rhead = req->rhead;
+	int			ret;
+
+	if (rhead->fch_entries > 0 && !advance_fsrefs_query(rhead))
+		return 0;
+
+	trace_fsrefs(req,
+ "ioctl dev %u:%u physical 0x%llx length 0x%llx highkey 0x%llx",
+			major(rhead->fch_keys[0].fcr_device),
+			minor(rhead->fch_keys[0].fcr_device),
+			(unsigned long long)rhead->fch_keys[0].fcr_physical,
+			(unsigned long long)rhead->fch_keys[0].fcr_length,
+			(unsigned long long)rhead->fch_keys[1].fcr_physical);
+
+	ret = ioctl(req->xfd->fd, FS_IOC_GETFSREFCOUNTS, rhead);
+	if (ret) {
+		perror(_("querying refcount data"));
+		abort();
+		return -1;
+	}
+
+	if (!(rhead->fch_oflags & FCH_OF_DEV_T)) {
+		fprintf(stderr, _("fsrefcounts does not return dev_t.\n"));
+		return -1;
+	}
+
+	if (rhead->fch_entries == 0)
+		return 0;
+
+	return 1;
+}
+
+#define for_each_fsref_row(req, rec) \
+	for ((rec) = (req)->rhead->fch_recs; \
+	     (rec) < (req)->rhead->fch_recs + (req)->rhead->fch_entries; \
+	     (rec)++)
+
+/* Allocate the structures needed for a bmapx query. */
+static void
+start_bmapx_query(
+	struct clearspace_req	*req,
+	unsigned int		fork,
+	unsigned long long	pos,
+	unsigned long long	length)
+{
+	struct getbmapx		*bhead = req->bhead;
+
+	assert(fork == BMV_IF_ATTRFORK || fork == BMV_IF_COWFORK || !fork);
+	assert(req->bhead->bmv_count == 0);
+
+	memset(bhead, 0, sizeof(struct getbmapx));
+	bhead[0].bmv_offset = BTOBB(pos);
+	bhead[0].bmv_length = BTOBB(length);
+	bhead[0].bmv_count = QUERY_BATCH_SIZE + 1;
+	bhead[0].bmv_iflags = fork | BMV_IF_PREALLOC | BMV_IF_DELALLOC;
+
+	trace_bmapx(req, "%s pos 0x%llx bytecount 0x%llx",
+			fork == BMV_IF_COWFORK ? "cow" : fork == BMV_IF_ATTRFORK ? "attr" : "data",
+			(unsigned long long)BBTOB(bhead[0].bmv_offset),
+			(unsigned long long)BBTOB(bhead[0].bmv_length));
+	req->trace_indent++;
+}
+
+static inline void
+end_bmapx_query(
+	struct clearspace_req	*req)
+{
+	req->trace_indent--;
+	req->bhead->bmv_count = 0;
+}
+
+/* Set us up for the next run_bmapx_query, or return false. */
+static inline bool
+advance_bmapx_query(struct getbmapx *bhead)
+{
+	struct getbmapx		*brec;
+	unsigned long long	next_offset;
+	unsigned long long	end = bhead->bmv_offset + bhead->bmv_length;
+
+	brec = &bhead[bhead->bmv_entries];
+	if (brec->bmv_oflags & BMV_OF_LAST)
+		return false;
+
+	next_offset = brec->bmv_offset + brec->bmv_length;
+	if (next_offset > end)
+		return false;
+
+	bhead->bmv_offset = next_offset;
+	bhead->bmv_length = end - next_offset;
+	return true;
+}
+
+/*
+ * Run a GETBMAPX query.  Returns 1 if there are rows, 0 if there are no rows,
+ * or -1 for error.
+ */
+static inline int
+run_bmapx_query(
+	struct clearspace_req	*req,
+	int			fd)
+{
+	struct getbmapx		*bhead = req->bhead;
+	unsigned int		fork;
+	int			ret;
+
+	if (bhead->bmv_entries > 0 && !advance_bmapx_query(bhead))
+		return 0;
+
+	fork = bhead[0].bmv_iflags & (BMV_IF_COWFORK | BMV_IF_ATTRFORK);
+	trace_bmapx(req, "ioctl %s pos 0x%llx bytecount 0x%llx",
+			fork == BMV_IF_COWFORK ? "cow" : fork == BMV_IF_ATTRFORK ? "attr" : "data",
+			(unsigned long long)BBTOB(bhead[0].bmv_offset),
+			(unsigned long long)BBTOB(bhead[0].bmv_length));
+
+	ret = ioctl(fd, XFS_IOC_GETBMAPX, bhead);
+	if (ret) {
+		perror(_("querying bmapx data"));
+		return -1;
+	}
+
+	if (bhead->bmv_entries == 0)
+		return 0;
+
+	return 1;
+}
+
+#define for_each_bmapx_row(req, rec) \
+	for ((rec) = (req)->bhead + 1; \
+	     (rec) < (req)->bhead + 1 + (req)->bhead->bmv_entries; \
+	     (rec)++)
+
+static inline void
+csp_dump_bmapx_row(
+	struct clearspace_req	*req,
+	unsigned int		nr,
+	const struct getbmapx	*brec)
+{
+	if (brec->bmv_block == -1) {
+		trace_dumpfile(req, "[%u]: pos 0x%llx len 0x%llx hole",
+				nr,
+				(unsigned long long)BBTOB(brec->bmv_offset),
+				(unsigned long long)BBTOB(brec->bmv_length));
+		return;
+	}
+
+	if (brec->bmv_block == -2) {
+		trace_dumpfile(req, "[%u]: pos 0x%llx len 0x%llx delalloc",
+				nr,
+				(unsigned long long)BBTOB(brec->bmv_offset),
+				(unsigned long long)BBTOB(brec->bmv_length));
+		return;
+	}
+
+	trace_dumpfile(req, "[%u]: pos 0x%llx len 0x%llx phys 0x%llx flags 0x%x",
+			nr,
+			(unsigned long long)BBTOB(brec->bmv_offset),
+			(unsigned long long)BBTOB(brec->bmv_length),
+			(unsigned long long)BBTOB(brec->bmv_block),
+			brec->bmv_oflags);
+}
+
+static inline void
+csp_dump_bmapx(
+	struct clearspace_req	*req,
+	int			fd,
+	unsigned int		indent,
+	const char		*tag)
+{
+	unsigned int		nr;
+	int			ret;
+
+	trace_dumpfile(req, "DUMP BMAP OF DATA FORK %s", tag);
+	start_bmapx_query(req, 0, req->start, req->length);
+	nr = 0;
+	while ((ret = run_bmapx_query(req, fd)) > 0) {
+		struct getbmapx	*brec;
+
+		for_each_bmapx_row(req, brec) {
+			csp_dump_bmapx_row(req, nr++, brec);
+			if (nr > 10)
+				goto dump_cow;
+		}
+	}
+
+dump_cow:
+	end_bmapx_query(req);
+	trace_dumpfile(req, "DUMP BMAP OF COW FORK %s", tag);
+	start_bmapx_query(req, BMV_IF_COWFORK, req->start, req->length);
+	nr = 0;
+	while ((ret = run_bmapx_query(req, fd)) > 0) {
+		struct getbmapx	*brec;
+
+		for_each_bmapx_row(req, brec) {
+			csp_dump_bmapx_row(req, nr++, brec);
+			if (nr > 10)
+				goto dump_attr;
+		}
+	}
+
+dump_attr:
+	end_bmapx_query(req);
+	trace_dumpfile(req, "DUMP BMAP OF ATTR FORK %s", tag);
+	start_bmapx_query(req, BMV_IF_ATTRFORK, req->start, req->length);
+	nr = 0;
+	while ((ret = run_bmapx_query(req, fd)) > 0) {
+		struct getbmapx	*brec;
+
+		for_each_bmapx_row(req, brec) {
+			csp_dump_bmapx_row(req, nr++, brec);
+			if (nr > 10)
+				goto stop;
+		}
+	}
+
+stop:
+	end_bmapx_query(req);
+	trace_dumpfile(req, "DONE DUMPING %s", tag);
+}
+
+/* Return the first bmapx for the given file range. */
+static int
+bmapx_one(
+	struct clearspace_req	*req,
+	int			fd,
+	unsigned long long	pos,
+	unsigned long long	length,
+	struct getbmapx		*brec)
+{
+	struct getbmapx		bhead[2];
+	int			ret;
+
+	memset(bhead, 0, sizeof(struct getbmapx) * 2);
+	bhead[0].bmv_offset = BTOBB(pos);
+	bhead[0].bmv_length = BTOBB(length);
+	bhead[0].bmv_count = 2;
+	bhead[0].bmv_iflags = BMV_IF_PREALLOC | BMV_IF_DELALLOC;
+
+	ret = ioctl(fd, XFS_IOC_GETBMAPX, bhead);
+	if (ret) {
+		perror(_("simple bmapx query"));
+		return -1;
+	}
+
+	if (bhead->bmv_entries > 0) {
+		memcpy(brec, &bhead[1], sizeof(struct getbmapx));
+		return 0;
+	}
+
+	memset(brec, 0, sizeof(struct getbmapx));
+	brec->bmv_offset = pos;
+	brec->bmv_block = -1;	/* hole */
+	brec->bmv_length = length;
+	return 0;
+}
+
+/* Constrain space map records. */
+static void
+__trim_fsmap(
+	uint64_t		start,
+	uint64_t		length,
+	struct fsmap		*fsmap)
+{
+	unsigned long long	delta, end;
+	bool			need_off;
+
+	need_off = (fsmap->fmr_flags & (FMR_OF_EXTENT_MAP |
+					FMR_OF_SPECIAL_OWNER));
+
+	if (fsmap->fmr_physical < start) {
+		delta = start - fsmap->fmr_physical;
+		fsmap->fmr_physical = start;
+		fsmap->fmr_length -= delta;
+		if (need_off)
+			fsmap->fmr_offset += delta;
+	}
+
+	end = fsmap->fmr_physical + fsmap->fmr_length;
+	if (end > start + length) {
+		delta = end - (start + length);
+		fsmap->fmr_length -= delta;
+	}
+}
+
+static inline void
+trim_target_fsmap(const struct clearspace_tgt *tgt, struct fsmap *fsmap)
+{
+	return __trim_fsmap(tgt->start, tgt->length, fsmap);
+}
+
+static inline void
+trim_request_fsmap(const struct clearspace_req *req, struct fsmap *fsmap)
+{
+	return __trim_fsmap(req->start, req->length, fsmap);
+}
+
+/* Actual space clearing code */
+
+/*
+ * Map all the free space in the region that we're clearing to the space
+ * catcher file.
+ */
+static int
+csp_grab_free_space(
+	struct clearspace_req	*req)
+{
+	int			ret;
+
+	trace_grabfree(req, "start 0x%llx length 0x%llx",
+			(unsigned long long)req->start,
+			(unsigned long long)req->length);
+
+	ret = fallocate(req->space_fd, FALLOC_FL_MAP_FREE_SPACE, req->start,
+			req->length);
+	if (ret) {
+		perror(_("map free space to space capture file"));
+		return -1;
+	}
+
+	return 0;
+}
+
+/*
+ * Rank a refcount record.  We prefer to tackle highly shared and longer
+ * extents first.
+ */
+static inline unsigned long long
+csp_space_prio(
+	const struct xfs_fsop_geom	*g,
+	const struct fsrefs		*p)
+{
+	unsigned long long		blocks = p->fcr_length / g->blocksize;
+	unsigned long long		ret = blocks * p->fcr_owners;
+
+	if (ret < blocks || ret < p->fcr_owners)
+		return UINT64_MAX;
+	return ret;
+}
+
+/* Make the current refcount record the clearing target if desirable. */
+static void
+csp_adjust_target(
+	struct clearspace_req		*req,
+	struct clearspace_tgt		*target,
+	const struct fsrefs		*rec,
+	unsigned long long		prio)
+{
+	if (prio < target->prio)
+		return;
+	if (prio == target->prio &&
+	    rec->fcr_length <= target->length)
+		return;
+
+	/* Ignore results that go beyond the end of what we wanted. */
+	if (rec->fcr_physical >= req->start + req->length)
+		return;
+
+	/* Ignore regions that we already tried to clear. */
+	if (bitmap_test(req->visited, rec->fcr_physical, rec->fcr_length))
+		return;
+
+	trace_target(req,
+ "set target, prio 0x%llx -> 0x%llx phys 0x%llx bytecount 0x%llx",
+			target->prio, prio,
+			(unsigned long long)rec->fcr_physical,
+			(unsigned long long)rec->fcr_length);
+
+	target->start = rec->fcr_physical;
+	target->length = rec->fcr_length;
+	target->owners = rec->fcr_owners;
+	target->prio = prio;
+}
+
+/*
+ * Decide if this refcount record maps to extents that are sufficiently
+ * interesting to target.
+ */
+static int
+csp_evaluate_refcount(
+	struct clearspace_req		*req,
+	const struct fsrefs		*rrec,
+	struct clearspace_tgt		*target)
+{
+	const struct xfs_fsop_geom	*fsgeom = &req->xfd->fsgeom;
+	unsigned long long		prio = csp_space_prio(fsgeom, rrec);
+	int				ret;
+
+	if (rrec->fcr_device != req->dev)
+		return 0;
+
+	if (prio < target->prio)
+		return 0;
+
+	/*
+	 * XFS only supports sharing data blocks.  If there's more than one
+	 * owner, we know that we can easily move the blocks.
+	 */
+	if (rrec->fcr_owners > 1) {
+		csp_adjust_target(req, target, rrec, prio);
+		return 0;
+	}
+
+	/*
+	 * Otherwise, this extent has single owners.  Walk the fsmap records to
+	 * figure out if they're movable or not.
+	 */
+	start_fsmap_query(req, rrec->fcr_device, rrec->fcr_physical,
+			rrec->fcr_length);
+	while ((ret = run_fsmap_query(req)) > 0) {
+		struct fsmap	*mrec;
+		uint64_t	next_phys = 0;
+
+		for_each_fsmap_row(req, mrec) {
+			struct fsrefs	fake_rec = { };
+
+			trace_fsmap_rec(req, CSP_TRACE_TARGET, mrec);
+
+			if (mrec->fmr_device != rrec->fcr_device)
+				continue;
+			if (mrec->fmr_flags & FMR_OF_SPECIAL_OWNER)
+				continue;
+			if (csp_is_internal_owner(req, mrec->fmr_owner))
+				continue;
+
+			/*
+			 * If the space has become shared since the fsrefs
+			 * query, just skip this record.  We might come back to
+			 * it in a later iteration.
+			 */
+			if (mrec->fmr_physical < next_phys)
+				continue;
+
+			/* Fake enough of a fsrefs to calculate the priority. */
+			fake_rec.fcr_physical = mrec->fmr_physical;
+			fake_rec.fcr_length = mrec->fmr_length;
+			fake_rec.fcr_owners = 1;
+			prio = csp_space_prio(fsgeom, &fake_rec);
+
+			/* Target unwritten extents first; they're cheap. */
+			if (mrec->fmr_flags & FMR_OF_PREALLOC)
+				prio |= (1ULL << 63);
+
+			csp_adjust_target(req, target, &fake_rec, prio);
+
+			next_phys = mrec->fmr_physical + mrec->fmr_length;
+		}
+	}
+	end_fsmap_query(req);
+
+	return ret;
+}
+
+/*
+ * Given a range of storage to search, find the most appealing target for space
+ * clearing.  If nothing suitable is found, the target will be zeroed.
+ */
+static int
+csp_find_target(
+	struct clearspace_req	*req,
+	struct clearspace_tgt	*target)
+{
+	int			ret;
+
+	memset(target, 0, sizeof(struct clearspace_tgt));
+
+	start_fsrefs_query(req, req->dev, req->start, req->length);
+	while ((ret = run_fsrefs_query(req)) > 0) {
+		struct fsrefs	*rrec;
+
+		for_each_fsref_row(req, rrec) {
+			trace_fsrefs_rec(req, CSP_TRACE_TARGET, rrec);
+			ret = csp_evaluate_refcount(req, rrec, target);
+			if (ret) {
+				end_fsrefs_query(req);
+				return ret;
+			}
+		}
+	}
+	end_fsrefs_query(req);
+
+	if (target->length != 0) {
+		/*
+		 * Mark this extent visited so that we won't try again this
+		 * round.
+		 */
+		trace_bitmap(req, "set filedata start 0x%llx length 0x%llx",
+				target->start, target->length);
+		ret = bitmap_set(req->visited, target->start, target->length);
+		if (ret) {
+			perror(_("marking file extent visited"));
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+/* Try to evacuate blocks by using online repair. */
+static int
+csp_evac_file_metadata(
+	struct clearspace_req		*req,
+	struct clearspace_tgt		*target,
+	const struct fsmap		*mrec,
+	int				fd,
+	const struct xfs_bulkstat	*bulkstat)
+{
+	struct xfs_scrub_metadata	scrub = {
+		.sm_type		= XFS_SCRUB_TYPE_PROBE,
+		.sm_flags		= XFS_SCRUB_IFLAG_REPAIR |
+					  XFS_SCRUB_IFLAG_FORCE_REBUILD,
+	};
+	struct xfs_fd			*xfd = req->xfd;
+	int				ret;
+
+	trace_xrebuild(req,
+ "ino 0x%llx pos 0x%llx bytecount 0x%llx phys 0x%llx flags 0x%llx",
+				(unsigned long long)mrec->fmr_owner,
+				(unsigned long long)mrec->fmr_offset,
+				(unsigned long long)mrec->fmr_physical,
+				(unsigned long long)mrec->fmr_length,
+				(unsigned long long)mrec->fmr_flags);
+
+	if (fd == -1) {
+		scrub.sm_ino = mrec->fmr_owner;
+		scrub.sm_gen = bulkstat->bs_gen;
+		fd = xfd->fd;
+	}
+
+	if (mrec->fmr_flags & FMR_OF_ATTR_FORK) {
+		if (mrec->fmr_flags & FMR_OF_EXTENT_MAP)
+			scrub.sm_type = XFS_SCRUB_TYPE_BMBTA;
+		else
+			scrub.sm_type = XFS_SCRUB_TYPE_XATTR;
+	} else if (mrec->fmr_flags & FMR_OF_EXTENT_MAP) {
+		scrub.sm_type = XFS_SCRUB_TYPE_BMBTD;
+	} else if (S_ISLNK(bulkstat->bs_mode)) {
+		scrub.sm_type = XFS_SCRUB_TYPE_SYMLINK;
+	} else if (S_ISDIR(bulkstat->bs_mode)) {
+		scrub.sm_type = XFS_SCRUB_TYPE_DIR;
+	}
+
+	if (scrub.sm_type == XFS_SCRUB_TYPE_PROBE)
+		return 0;
+
+	trace_xrebuild(req, "ino 0x%llx gen 0x%x type %u",
+			(unsigned long long)mrec->fmr_owner,
+			(unsigned int)bulkstat->bs_gen,
+			(unsigned int)scrub.sm_type);
+
+	ret = ioctl(fd, XFS_IOC_SCRUB_METADATA, &scrub);
+	if (ret) {
+		fprintf(stderr,
+	_("evacuating inode 0x%llx metadata type %u: %s\n"),
+				(unsigned long long)mrec->fmr_owner,
+				scrub.sm_type, strerror(errno));
+		return -1;
+	}
+
+	target->evacuated++;
+	return 0;
+}
+
+/*
+ * Open an inode via handle.  Returns a file descriptor, -2 if the file is
+ * gone, or -1 on error.
+ */
+static int
+csp_open_by_handle(
+	struct clearspace_req	*req,
+	int			oflags,
+	uint64_t		ino,
+	uint32_t		gen)
+{
+	struct xfs_handle	handle = { };
+	struct xfs_fsop_handlereq hreq = {
+		.oflags		= oflags | O_NOATIME | O_NOFOLLOW |
+				  O_NOCTTY | O_LARGEFILE,
+		.ihandle	= &handle,
+		.ihandlen	= sizeof(handle),
+	};
+	int			ret;
+
+	memcpy(&handle.ha_fsid, req->fshandle, sizeof(handle.ha_fsid));
+	handle.ha_fid.fid_len = sizeof(xfs_fid_t) -
+			sizeof(handle.ha_fid.fid_len);
+	handle.ha_fid.fid_pad = 0;
+	handle.ha_fid.fid_ino = ino;
+	handle.ha_fid.fid_gen = gen;
+
+	/*
+	 * Since we extracted the fshandle from the open file instead of using
+	 * path_to_fshandle, the fsid cache doesn't know about the fshandle.
+	 * Construct the open by handle request manually.
+	 */
+	ret = ioctl(req->xfd->fd, XFS_IOC_OPEN_BY_HANDLE, &hreq);
+	if (ret < 0) {
+		if (errno == ENOENT || errno == EINVAL)
+			return -2;
+
+		fprintf(stderr, _("open inode 0x%llx: %s\n"),
+				(unsigned long long)ino,
+				strerror(errno));
+		return -1;
+	}
+
+	return ret;
+}
+
+/*
+ * Open a file for evacuation.  Returns a positive errno on error; a fd in @fd
+ * if the caller is supposed to do something; or @fd == -1 if there's nothing
+ * further to do.
+ */
+static int
+csp_evac_open(
+	struct clearspace_req	*req,
+	struct clearspace_tgt	*target,
+	const struct fsmap	*mrec,
+	struct xfs_bulkstat	*bulkstat,
+	int			oflags,
+	int			*fd)
+{
+	struct xfs_bulkstat	__bs;
+	int			target_fd;
+	int			ret;
+
+	*fd = -1;
+
+	if (csp_is_internal_owner(req, mrec->fmr_owner) ||
+	    (mrec->fmr_flags & FMR_OF_SPECIAL_OWNER))
+		goto nothing_to_do;
+
+	if (bulkstat == NULL)
+		bulkstat = &__bs;
+
+	/*
+	 * Snapshot this file so that we can perform a fresh-only exchange.
+	 * For other types of files we just skip to the evacuation step.
+	 */
+	ret = -xfrog_bulkstat_single(req->xfd, mrec->fmr_owner, 0, bulkstat);
+	if (ret) {
+		if (ret == ENOENT || ret == EINVAL)
+			goto nothing_to_do;
+
+		fprintf(stderr, _("bulkstat inode 0x%llx: %s\n"),
+				(unsigned long long)mrec->fmr_owner,
+				strerror(ret));
+		return ret;
+	}
+
+	/*
+	 * If we get stats for a different inode, the file may have been freed
+	 * out from under us and there's nothing to do.
+	 */
+	if (bulkstat->bs_ino != mrec->fmr_owner)
+		goto nothing_to_do;
+
+	/*
+	 * We're only allowed to open regular files and directories via handle
+	 * so jump to online rebuild for all other file types.
+	 */
+	if (!S_ISREG(bulkstat->bs_mode) && !S_ISDIR(bulkstat->bs_mode))
+		return csp_evac_file_metadata(req, target, mrec, -1,
+				bulkstat);
+
+	if (S_ISDIR(bulkstat->bs_mode))
+		oflags = O_RDONLY;
+
+	target_fd = csp_open_by_handle(req, oflags, mrec->fmr_owner,
+			bulkstat->bs_gen);
+	if (target_fd == -2)
+		goto nothing_to_do;
+	if (target_fd < 0)
+		return -target_fd;
+
+	/*
+	 * Exchange only works for regular file data blocks.  If that isn't the
+	 * case, our only recourse is online rebuild.
+	 */
+	if (S_ISDIR(bulkstat->bs_mode) ||
+	    (mrec->fmr_flags & (FMR_OF_ATTR_FORK | FMR_OF_EXTENT_MAP))) {
+		int	ret2;
+
+		ret = csp_evac_file_metadata(req, target, mrec, target_fd,
+				bulkstat);
+		ret2 = close(target_fd);
+		if (!ret && ret2)
+			ret = ret2;
+		return ret;
+	}
+
+	*fd = target_fd;
+	return 0;
+
+nothing_to_do:
+	target->try_again = true;
+	return 0;
+}
+
+/* Unshare the space in the work file that we're using for deduplication. */
+static int
+csp_unshare_workfile(
+	struct clearspace_req	*req,
+	unsigned long long	start,
+	unsigned long long	length)
+{
+	int			ret;
+
+	trace_falloc(req, "funshare workfd pos 0x%llx bytecount 0x%llx",
+			start, length);
+
+	ret = fallocate(req->work_fd, FALLOC_FL_UNSHARE_RANGE, start, length);
+	if (ret) {
+		perror(_("unsharing work file"));
+		return ret;
+	}
+
+	ret = fsync(req->work_fd);
+	if (ret) {
+		perror(_("syncing work file"));
+		return ret;
+	}
+
+	/* Make sure we didn't get any space within the clearing range. */
+	start_bmapx_query(req, 0, start, length);
+	while ((ret = run_bmapx_query(req, req->work_fd)) > 0) {
+		struct getbmapx	*brec;
+
+		for_each_bmapx_row(req, brec) {
+			unsigned long long	p, l;
+
+			trace_bmapx_rec(req, CSP_TRACE_FALLOC, brec);
+			p = BBTOB(brec->bmv_block);
+			l = BBTOB(brec->bmv_length);
+
+			if (p + l < req->start || p >= req->start + req->length)
+				continue;
+
+			trace_prep(req,
+	"workfd has extent inside clearing range, phys 0x%llx fsbcount 0x%llx",
+					p, l);
+			end_bmapx_query(req);
+			return -1;
+		}
+	}
+	end_bmapx_query(req);
+
+	return 0;
+}
+
+/* Try to deduplicate every block in the fdr request, if we can. */
+static int
+csp_evac_dedupe_loop(
+	struct clearspace_req		*req,
+	struct clearspace_tgt		*target,
+	unsigned long long		ino,
+	int				max_reqlen)
+{
+	struct file_dedupe_range	*fdr = req->fdr;
+	struct file_dedupe_range_info	*info = &fdr->info[0];
+	loff_t				last_unshare_off = -1;
+	int				ret;
+
+	while (fdr->src_length > 0) {
+		struct getbmapx		brec;
+		bool			same;
+		unsigned int		old_reqlen = fdr->src_length;
+
+		if (max_reqlen && fdr->src_length > max_reqlen)
+			fdr->src_length = max_reqlen;
+
+		trace_dedupe(req, "ino 0x%llx pos 0x%llx bytecount 0x%llx",
+				ino,
+				(unsigned long long)info->dest_offset,
+				(unsigned long long)fdr->src_length);
+
+		ret = bmapx_one(req, req->work_fd, fdr->src_offset,
+				fdr->src_length, &brec);
+		if (ret)
+			return ret;
+
+		trace_dedupe(req, "workfd pos 0x%llx phys 0x%llx",
+				(unsigned long long)fdr->src_offset,
+				(unsigned long long)BBTOB(brec.bmv_block));
+
+		ret = deduperange(req->work_fd, fdr, &same);
+		if (ret == ENOSPC && last_unshare_off < fdr->src_offset) {
+			req->trace_indent++;
+			trace_dedupe(req, "funshare workfd at phys 0x%llx",
+					(unsigned long long)fdr->src_offset);
+			/*
+			 * If we ran out of space, it's possible that we have
+			 * reached the maximum sharing factor of the blocks in
+			 * the work file.  Try unsharing the range of the work
+			 * file to get a singly-owned range and loop again.
+			 */
+			ret = csp_unshare_workfile(req, fdr->src_offset,
+					fdr->src_length);
+			req->trace_indent--;
+			if (ret)
+				return ret;
+
+			ret = fsync(req->work_fd);
+			if (ret) {
+				perror(_("sync after unshare work file"));
+				return ret;
+			}
+
+			last_unshare_off = fdr->src_offset;
+			fdr->src_length = old_reqlen;
+			continue;
+		}
+		if (ret) {
+			fprintf(stderr, _("evacuating inode 0x%llx: %s\n"),
+					ino, strerror(ret));
+			return ret;
+		}
+
+		if (same) {
+			req->trace_indent++;
+			trace_dedupe(req,
+	"evacuated ino 0x%llx pos 0x%llx bytecount 0x%llx",
+					ino,
+					(unsigned long long)info->dest_offset,
+					(unsigned long long)info->bytes_deduped);
+			req->trace_indent--;
+
+			target->evacuated++;
+		} else {
+			req->trace_indent++;
+			trace_dedupe(req,
+	"failed evac ino 0x%llx pos 0x%llx bytecount 0x%llx",
+					ino,
+					(unsigned long long)info->dest_offset,
+					(unsigned long long)fdr->src_length);
+			req->trace_indent--;
+
+			target->try_again = true;
+
+			/*
+			 * If we aren't single-stepping the deduplication,
+			 * stop early so that the caller goes into single-step
+			 * mode.
+			 */
+			if (!max_reqlen) {
+				fdr->src_length = old_reqlen;
+				return 0;
+			}
+
+			/* Contents changed, move on to the next block. */
+			info->bytes_deduped = fdr->src_length;
+		}
+		fdr->src_length = old_reqlen;
+
+		fdr->src_offset += info->bytes_deduped;
+		info->dest_offset += info->bytes_deduped;
+		fdr->src_length -= info->bytes_deduped;
+	}
+
+	return 0;
+}
+
+/*
+ * Evacuate one fsmapping by using dedupe to remap data stored in the target
+ * range to a copy stored in the work file.
+ */
+static int
+csp_evac_dedupe_fsmap(
+	struct clearspace_req		*req,
+	struct clearspace_tgt		*target,
+	const struct fsmap		*mrec)
+{
+	struct file_dedupe_range	*fdr = req->fdr;
+	struct file_dedupe_range_info	*info = &fdr->info[0];
+	bool				can_single_step;
+	int				target_fd;
+	int				ret, ret2;
+
+	if (mrec->fmr_device != req->dev) {
+		fprintf(stderr, _("wrong fsmap device in results.\n"));
+		return -1;
+	}
+
+	ret = csp_evac_open(req, target, mrec, NULL, O_RDONLY, &target_fd);
+	if (ret || target_fd < 0)
+		return ret;
+
+	/*
+	 * Use dedupe to try to shift the target file's mappings to use the
+	 * copy of the data that's in the work file.
+	 */
+	fdr->src_offset = mrec->fmr_physical;
+	fdr->src_length = mrec->fmr_length;
+	fdr->dest_count = 1;
+	info->dest_fd = target_fd;
+	info->dest_offset = mrec->fmr_offset;
+
+	can_single_step = mrec->fmr_length > req->xfd->fsgeom.blocksize;
+
+	/* First we try to do the entire thing all at once. */
+	ret = csp_evac_dedupe_loop(req, target, mrec->fmr_owner, 0);
+	if (ret)
+		goto out_fd;
+
+	/* If there's any work left, try again one block at a time. */
+	if (can_single_step && fdr->src_length > 0) {
+		ret = csp_evac_dedupe_loop(req, target, mrec->fmr_owner,
+				req->xfd->fsgeom.blocksize);
+		if (ret)
+			goto out_fd;
+	}
+
+out_fd:
+	ret2 = close(target_fd);
+	if (!ret && ret2)
+		ret = ret2;
+	return ret;
+}
+
+/* Use deduplication to remap data extents away from where we're clearing. */
+static int
+csp_evac_dedupe(
+	struct clearspace_req	*req,
+	struct clearspace_tgt	*target)
+{
+	int			ret;
+
+	start_fsmap_query(req, req->dev, target->start, target->length);
+	while ((ret = run_fsmap_query(req)) > 0) {
+		struct fsmap	*mrec;
+
+		for_each_fsmap_row(req, mrec) {
+			trace_fsmap_rec(req, CSP_TRACE_DEDUPE, mrec);
+			trim_target_fsmap(target, mrec);
+
+			req->trace_indent++;
+			ret = csp_evac_dedupe_fsmap(req, target, mrec);
+			req->trace_indent--;
+			if (ret)
+				goto out;
+
+			ret = csp_grab_free_space(req);
+			if (ret)
+				goto out;
+		}
+	}
+
+out:
+	end_fsmap_query(req);
+	if (ret)
+		trace_dedupe(req, "ret %d", ret);
+	return ret;
+}
+
+#define BUFFERCOPY_BUFSZ		65536
+
+/*
+ * Use a memory buffer to copy part of src_fd to dst_fd, or return an errno. */
+static int
+csp_buffercopy(
+	struct clearspace_req	*req,
+	int			src_fd,
+	loff_t			src_off,
+	int			dst_fd,
+	loff_t			dst_off,
+	loff_t			len)
+{
+	int			ret = 0;
+
+	while (len > 0) {
+		size_t count = min(BUFFERCOPY_BUFSZ, len);
+		ssize_t bytes_read, bytes_written;
+
+		bytes_read = pread(src_fd, req->buf, count, src_off);
+		if (bytes_read < 0) {
+			ret = errno;
+			break;
+		}
+
+		bytes_written = pwrite(dst_fd, req->buf, bytes_read, dst_off);
+		if (bytes_written < 0) {
+			ret = errno;
+			break;
+		}
+
+		src_off += bytes_written;
+		dst_off += bytes_written;
+		len -= bytes_written;
+	}
+
+	return ret;
+}
+
+/*
+ * Prepare the work file to assist in evacuating file data by copying the
+ * contents of the frozen space into the work file.
+ */
+static int
+csp_prepare_for_dedupe(
+	struct clearspace_req	*req)
+{
+	struct file_clone_range	fcr;
+	struct stat		statbuf;
+	loff_t			datapos = 0;
+	loff_t			length = 0;
+	int			ret;
+
+	ret = fstat(req->space_fd, &statbuf);
+	if (ret) {
+		perror(_("space capture file"));
+		return ret;
+	}
+
+	ret = ftruncate(req->work_fd, 0);
+	if (ret) {
+		perror(_("truncate work file"));
+		return ret;
+	}
+
+	ret = ftruncate(req->work_fd, statbuf.st_size);
+	if (ret) {
+		perror(_("reset work file"));
+		return ret;
+	}
+
+	/* Make a working copy of the frozen file data. */
+	start_spacefd_iter(req);
+	while ((ret = spacefd_data_iter(req, &datapos, &length)) > 0) {
+		trace_prep(req, "clone spacefd data 0x%llx length 0x%llx",
+				(long long)datapos, (long long)length);
+
+		fcr.src_fd = req->space_fd;
+		fcr.src_offset = datapos;
+		fcr.src_length = length;
+		fcr.dest_offset = datapos;
+
+		ret = clonerange(req->work_fd, &fcr);
+		if (ret == ENOSPC) {
+			req->trace_indent++;
+			trace_prep(req,
+	"falling back to buffered copy at 0x%llx",
+					(long long)datapos);
+			req->trace_indent--;
+			ret = csp_buffercopy(req, req->space_fd, datapos,
+					req->work_fd, datapos, length);
+		}
+		if (ret) {
+			perror(
+	_("copying space capture file contents to work file"));
+			return ret;
+		}
+	}
+	end_spacefd_iter(req);
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * Unshare the work file so that it contains an identical copy of the
+	 * contents of the space capture file but mapped to different blocks.
+	 * This is key to using dedupe to migrate file space away from the
+	 * requested region.
+	 */
+	req->trace_indent++;
+	ret = csp_unshare_workfile(req, req->start, req->length);
+	req->trace_indent--;
+	return ret;
+}
+
+/*
+ * Evacuate one fsmapping by using dedupe to remap data stored in the target
+ * range to a copy stored in the work file.
+ */
+static int
+csp_evac_exchange_fsmap(
+	struct clearspace_req	*req,
+	struct clearspace_tgt	*target,
+	const struct fsmap	*mrec)
+{
+	struct xfs_bulkstat	bulkstat;
+	struct file_xchg_range	xchg = { };
+	struct getbmapx		brec;
+	int			target_fd;
+	int			ret, ret2;
+
+	if (mrec->fmr_device != req->dev) {
+		fprintf(stderr, _("wrong fsmap device in results.\n"));
+		return -1;
+	}
+
+	ret = csp_evac_open(req, target, mrec, &bulkstat, O_RDWR, &target_fd);
+	if (ret || target_fd < 0)
+		return ret;
+
+	ret = ftruncate(req->work_fd, 0);
+	if (ret) {
+		perror(_("truncating work file"));
+		goto out_fd;
+	}
+
+	/*
+	 * Copy the data from the original file to the work file.  We assume
+	 * that the work file will end up with different data blocks and that
+	 * they're outside of the requested range.
+	 */
+	ret = csp_buffercopy(req, target_fd, mrec->fmr_offset, req->work_fd,
+			mrec->fmr_offset, mrec->fmr_length);
+	if (ret) {
+		fprintf(stderr, _("copying target file to work file: %s\n"),
+				strerror(ret));
+		goto out_fd;
+	}
+
+	ret = fsync(req->work_fd);
+	if (ret) {
+		perror(_("flush work file for fiexchange"));
+		goto out_fd;
+	}
+
+	ret = bmapx_one(req, req->work_fd, mrec->fmr_physical,
+			mrec->fmr_length, &brec);
+	if (ret)
+		return ret;
+
+	trace_fiexchange(req, "workfd pos 0x%llx phys 0x%llx",
+			(unsigned long long)mrec->fmr_physical,
+			(unsigned long long)BBTOB(brec.bmv_block));
+
+	/*
+	 * Exchange the mappings, with the freshness check enabled.  This
+	 * should result in the target file being switched to new blocks unless
+	 * it has changed, in which case we bounce out and find a new target.
+	 */
+	xfrog_file_exchange_prep(NULL, FILE_XCHG_RANGE_NONATOMIC,
+			mrec->fmr_offset, req->work_fd, mrec->fmr_offset,
+			mrec->fmr_length, &xchg);
+	xfrog_file_exchange_require_file2_fresh(&xchg, &bulkstat);
+	ret = exchangerange(target_fd, &xchg);
+	if (ret) {
+		if (ret == EBUSY) {
+			req->trace_indent++;
+			trace_fiexchange(req,
+ "failed evac ino 0x%llx pos 0x%llx bytecount 0x%llx",
+					bulkstat.bs_ino,
+					(unsigned long long)mrec->fmr_offset,
+					(unsigned long long)mrec->fmr_length);
+			req->trace_indent--;
+			target->try_again = true;
+		} else {
+			fprintf(stderr,
+	_("exchanging target and work file contents: %s\n"),
+					strerror(ret));
+		}
+		goto out_fd;
+	}
+
+	req->trace_indent++;
+	trace_fiexchange(req,
+ "evacuated ino 0x%llx pos 0x%llx bytecount 0x%llx",
+			bulkstat.bs_ino,
+			(unsigned long long)mrec->fmr_offset,
+			(unsigned long long)mrec->fmr_length);
+	req->trace_indent--;
+	target->evacuated++;
+
+out_fd:
+	ret2 = close(target_fd);
+	if (!ret && ret2)
+		ret = ret2;
+	return ret;
+}
+
+/*
+ * Try to evacuate all data blocks in the target region by copying the contents
+ * to a new file and exchanging the extents.
+ */
+static int
+csp_evac_exchange(
+	struct clearspace_req	*req,
+	struct clearspace_tgt	*target)
+{
+	int			ret;
+
+	start_fsmap_query(req, req->dev, target->start, target->length);
+	while ((ret = run_fsmap_query(req)) > 0) {
+		struct fsmap	*mrec;
+
+		for_each_fsmap_row(req, mrec) {
+			trace_fsmap_rec(req, CSP_TRACE_FIEXCHANGE, mrec);
+			trim_target_fsmap(target, mrec);
+
+			req->trace_indent++;
+			ret = csp_evac_exchange_fsmap(req, target, mrec);
+			req->trace_indent--;
+			if (ret)
+				goto out;
+
+			ret = csp_grab_free_space(req);
+			if (ret)
+				goto out;
+		}
+	}
+out:
+	end_fsmap_query(req);
+	if (ret)
+		trace_fiexchange(req, "ret %d", ret);
+	return ret;
+}
+
+/* Try to evacuate blocks by using online repair to rebuild AG metadata. */
+static int
+csp_evac_ag_metadata(
+	struct clearspace_req	*req,
+	struct clearspace_tgt	*target,
+	uint32_t		agno,
+	uint32_t		mask)
+{
+	struct xfs_scrub_metadata scrub = {
+		.sm_flags	= XFS_SCRUB_IFLAG_REPAIR |
+				  XFS_SCRUB_IFLAG_FORCE_REBUILD,
+	};
+	unsigned int		i;
+	int			ret;
+
+	trace_xrebuild(req, "agno 0x%x mask 0x%x",
+			(unsigned int)agno,
+			(unsigned int)mask);
+
+	for (i = XFS_SCRUB_TYPE_AGFL; i < XFS_SCRUB_TYPE_REFCNTBT; i++) {
+
+		if (!(mask & (1U << i)))
+			continue;
+
+		scrub.sm_type = i;
+
+		req->trace_indent++;
+		trace_xrebuild(req, "agno %u type %u",
+				(unsigned int)agno,
+				(unsigned int)scrub.sm_type);
+		req->trace_indent--;
+
+		ret = ioctl(req->xfd->fd, XFS_IOC_SCRUB_METADATA, &scrub);
+		if (ret) {
+			if (errno == ENOENT || errno == ENOSPC)
+				continue;
+			fprintf(stderr, _("rebuilding ag %u type %u: %s\n"),
+					(unsigned int)agno, scrub.sm_type,
+					strerror(errno));
+			return -1;
+		}
+
+		target->evacuated++;
+
+		ret = csp_grab_free_space(req);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+/* Compute a scrub mask for a fsmap special owner. */
+static uint32_t
+fsmap_owner_to_scrub_mask(__u64 owner)
+{
+	switch (owner) {
+	case XFS_FMR_OWN_FREE:
+	case XFS_FMR_OWN_UNKNOWN:
+	case XFS_FMR_OWN_FS:
+	case XFS_FMR_OWN_LOG:
+		/* can't move these */
+		return 0;
+	case XFS_FMR_OWN_AG:
+		return (1U << XFS_SCRUB_TYPE_BNOBT) |
+		       (1U << XFS_SCRUB_TYPE_CNTBT) |
+		       (1U << XFS_SCRUB_TYPE_AGFL) |
+		       (1U << XFS_SCRUB_TYPE_RMAPBT);
+	case XFS_FMR_OWN_INOBT:
+		return (1U << XFS_SCRUB_TYPE_INOBT) |
+		       (1U << XFS_SCRUB_TYPE_FINOBT);
+	case XFS_FMR_OWN_REFC:
+		return (1U << XFS_SCRUB_TYPE_REFCNTBT);
+	case XFS_FMR_OWN_INODES:
+	case XFS_FMR_OWN_COW:
+		/* don't know how to get rid of these */
+		return 0;
+	case XFS_FMR_OWN_DEFECTIVE:
+		/* good, get rid of it */
+		return 0;
+	default:
+		return 0;
+	}
+}
+
+/* Try to clear all per-AG metadata from the requested range. */
+static int
+csp_evac_fs_metadata(
+	struct clearspace_req	*req,
+	struct clearspace_tgt	*target,
+	bool			*cleared_anything)
+{
+	uint32_t		curr_agno = -1U;
+	uint32_t		curr_mask = 0;
+	int			ret = 0;
+
+	if (req->realtime)
+		return 0;
+
+	start_fsmap_query(req, req->dev, target->start, target->length);
+	while ((ret = run_fsmap_query(req)) > 0) {
+		struct fsmap	*mrec;
+
+		for_each_fsmap_row(req, mrec) {
+			uint64_t	daddr;
+			uint32_t	agno;
+			uint32_t	mask;
+
+			if (mrec->fmr_device != req->dev)
+				continue;
+			if (!(mrec->fmr_flags & FMR_OF_SPECIAL_OWNER))
+				continue;
+
+			/* Ignore regions that we already tried to clear. */
+			if (bitmap_test(req->visited, mrec->fmr_physical,
+						mrec->fmr_length))
+				continue;
+
+			mask = fsmap_owner_to_scrub_mask(mrec->fmr_owner);
+			if (!mask)
+				continue;
+
+			trace_fsmap_rec(req, CSP_TRACE_XREBUILD, mrec);
+
+			daddr = BTOBB(mrec->fmr_physical);
+			agno = cvt_daddr_to_agno(req->xfd, daddr);
+
+			trace_xrebuild(req,
+	"agno 0x%x -> 0x%x mask 0x%x owner %lld",
+					curr_agno, agno, curr_mask,
+					(unsigned long long)mrec->fmr_owner);
+
+			if (curr_agno == -1U) {
+				curr_agno = agno;
+			} else if (curr_agno != agno) {
+				ret = csp_evac_ag_metadata(req, target,
+						curr_agno, curr_mask);
+				if (ret)
+					goto out;
+
+				*cleared_anything = true;
+				curr_agno = agno;
+				curr_mask = 0;
+			}
+
+			/* Put this on the list and try to clear it once. */
+			curr_mask |= mask;
+			ret = bitmap_set(req->visited, mrec->fmr_physical,
+					mrec->fmr_length);
+			if (ret) {
+				perror(_("marking metadata extent visited"));
+				goto out;
+			}
+		}
+	}
+
+	if (curr_agno != -1U && curr_mask != 0) {
+		ret = csp_evac_ag_metadata(req, target, curr_agno, curr_mask);
+		if (ret)
+			goto out;
+		*cleared_anything = true;
+	}
+
+	if (*cleared_anything)
+		trace_bitmap(req, "set metadata start 0x%llx length 0x%llx",
+				target->start, target->length);
+
+out:
+	end_fsmap_query(req);
+	if (ret)
+		trace_xrebuild(req, "ret %d", ret);
+	return ret;
+}
+
+/*
+ * Check that at least the start of the mapping was frozen into the work file
+ * at the correct offset.  Set @len to the number of bytes that were frozen.
+ * Returns -1 for error, zero if written extents are waiting to be mapped into
+ * the space capture file, or 1 if there's nothing to transfer to the space
+ * capture file.
+ */
+static int
+csp_freeze_check_attempt(
+	struct clearspace_req	*req,
+	const struct fsmap	*mrec,
+	unsigned long long	*len)
+{
+	struct getbmapx		brec;
+	int			ret;
+
+	*len = 0;
+
+	ret = bmapx_one(req, req->work_fd, mrec->fmr_physical,
+			mrec->fmr_length, &brec);
+	if (ret)
+		return ret;
+
+	trace_freeze(req,
+ "does workfd pos 0x%llx len 0x%llx map to phys 0x%llx len 0x%llx?",
+			(unsigned long long)mrec->fmr_physical,
+			(unsigned long long)mrec->fmr_length,
+			(unsigned long long)BBTOB(brec.bmv_block),
+			(unsigned long long)BBTOB(brec.bmv_length));
+
+	/* freeze of an unwritten extent punches a hole in the work file. */
+	if ((mrec->fmr_flags & FMR_OF_PREALLOC) && brec.bmv_block == -1) {
+		*len = BBTOB(brec.bmv_length);
+		return 1;
+	}
+
+	/*
+	 * freeze of a written extent must result in the same physical space
+	 * being mapped into the work file.
+	 */
+	if (!(mrec->fmr_flags & FMR_OF_PREALLOC) &&
+	    BBTOB(brec.bmv_block) == mrec->fmr_physical) {
+		*len = BBTOB(brec.bmv_length);
+		return 0;
+	}
+
+	/*
+	 * We didn't find what we were looking for, which implies that the
+	 * mapping changed out from under us.  Punch out everything that could
+	 * have been mapped into the work file.  Set @len to zero and return so
+	 * that we try again with the next mapping.
+	 */
+
+	trace_falloc(req, "fpunch workfd pos 0x%llx bytecount 0x%llx",
+			(unsigned long long)mrec->fmr_physical,
+			(unsigned long long)mrec->fmr_length);
+
+	ret = fallocate(req->work_fd,
+			FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
+			mrec->fmr_physical, mrec->fmr_length);
+	if (ret) {
+		perror(_("resetting work file after failed freeze"));
+		return ret;
+	}
+
+	return 1;
+}
+
+/*
+ * Open a file to try to freeze whatever data is in the requested range.
+ *
+ * Returns nonzero on error.  Returns zero and a file descriptor in @fd if the
+ * caller is supposed to do something; or returns zero and @fd == -1 if there's
+ * nothing to freeze.
+ */
+static int
+csp_freeze_open(
+	struct clearspace_req	*req,
+	const struct fsmap	*mrec,
+	int			*fd)
+{
+	struct xfs_bulkstat	bulkstat;
+	int			target_fd;
+	int			ret;
+
+	*fd = -1;
+
+	ret = -xfrog_bulkstat_single(req->xfd, mrec->fmr_owner, 0, &bulkstat);
+	if (ret) {
+		if (ret == ENOENT || ret == EINVAL)
+			return 0;
+
+		fprintf(stderr, _("bulkstat inode 0x%llx: %s\n"),
+				(unsigned long long)mrec->fmr_owner,
+				strerror(errno));
+		return ret;
+	}
+
+	/*
+	 * If we get stats for a different inode, the file may have been freed
+	 * out from under us and there's nothing to do.
+	 */
+	if (bulkstat.bs_ino != mrec->fmr_owner)
+		return 0;
+
+	/* Skip anything we can't freeze. */
+	if (!S_ISREG(bulkstat.bs_mode) && !S_ISDIR(bulkstat.bs_mode))
+		return 0;
+
+	target_fd = csp_open_by_handle(req, O_RDONLY, mrec->fmr_owner,
+			bulkstat.bs_gen);
+	if (target_fd == -2)
+		return 0;
+	if (target_fd < 0)
+		return target_fd;
+
+	/*
+	 * Skip mappings for directories, xattr data, and block mapping btree
+	 * blocks.  We still have to close the file though.
+	 */
+	if (S_ISDIR(bulkstat.bs_mode) ||
+	    (mrec->fmr_flags & (FMR_OF_ATTR_FORK | FMR_OF_EXTENT_MAP))) {
+		return close(target_fd);
+	}
+
+	*fd = target_fd;
+	return 0;
+}
+
+/*
+ * Given a fsmap, try to reflink the physical space into the space capture
+ * file.
+ */
+static int
+csp_freeze_req_fsmap(
+	struct clearspace_req	*req,
+	unsigned long long	*cursor,
+	const struct fsmap	*mrec)
+{
+	struct fsmap		short_mrec;
+	struct file_clone_range	fcr = { };
+	unsigned long long	frozen_len;
+	int			src_fd;
+	int			ret, ret2;
+
+	if (mrec->fmr_device != req->dev) {
+		fprintf(stderr, _("wrong fsmap device in results.\n"));
+		return -1;
+	}
+
+	/* Ignore mappings for our secret files. */
+	if (csp_is_internal_owner(req, mrec->fmr_owner))
+		return 0;
+
+	/* Ignore mappings before the cursor. */
+	if (mrec->fmr_physical + mrec->fmr_length < *cursor)
+		return 0;
+
+	/* Jump past mappings for metadata. */
+	if (mrec->fmr_flags & FMR_OF_SPECIAL_OWNER)
+		goto skip;
+
+	/*
+	 * Open this file so that we can try to freeze its data blocks.
+	 * For other types of files we just skip to the evacuation step.
+	 */
+	ret = csp_freeze_open(req, mrec, &src_fd);
+	if (ret)
+		return ret;
+	if (src_fd < 0)
+		goto skip;
+
+	/*
+	 * If the cursor is in the middle of this mapping, increase the start
+	 * of the mapping to start at the cursor.
+	 */
+	if (mrec->fmr_physical < *cursor) {
+		unsigned long long	delta = *cursor - mrec->fmr_physical;
+
+		short_mrec = *mrec;
+		short_mrec.fmr_physical = *cursor;
+		short_mrec.fmr_offset += delta;
+		short_mrec.fmr_length -= delta;
+
+		mrec = &short_mrec;
+	}
+
+	req->trace_indent++;
+	if (mrec->fmr_length == 0) {
+		trace_freeze(req, "skipping zero-length freeze", 0);
+		goto out_fd;
+	}
+
+	/*
+	 * Reflink the mapping from the source file into the work file.  If we
+	 * can't do that, we're sunk.  If the mapping is unwritten, we'll leave
+	 * a hole in the work file.
+	 */
+	fcr.src_fd = src_fd;
+	fcr.src_offset = mrec->fmr_offset;
+	fcr.src_length = mrec->fmr_length;
+	fcr.dest_offset = mrec->fmr_physical;
+
+	trace_freeze(req, "freeze to workfd pos 0x%llx",
+			(unsigned long long)fcr.dest_offset);
+
+	ret = clonerange(req->work_fd, &fcr);
+	if (ret) {
+		fprintf(stderr, _("freezing space to work file: %s\n"),
+				strerror(ret));
+		goto out_fd;
+	}
+
+	req->trace_indent++;
+	ret = csp_freeze_check_attempt(req, mrec, &frozen_len);
+	req->trace_indent--;
+	if (ret < 0)
+		goto out_fd;
+	if (ret == 1) {
+		ret = 0;
+		goto advance;
+	}
+
+	/*
+	 * We've frozen the mapping by reflinking it into the work file and
+	 * confirmed that the work file has the space we wanted.  Now we need
+	 * to map the same extent into the space capture file.  If reflink
+	 * fails because we're out of space, fall back to FIEXCHANGE.  The end
+	 * goal is to populate the space capture file; we don't care about
+	 * the contents of the work file.
+	 */
+	fcr.src_fd = req->work_fd;
+	fcr.src_offset = mrec->fmr_physical;
+	fcr.dest_offset = mrec->fmr_physical;
+	fcr.src_length = frozen_len;
+
+	trace_freeze(req, "link phys 0x%llx len 0x%llx to spacefd",
+			(unsigned long long)mrec->fmr_physical,
+			(unsigned long long)mrec->fmr_length);
+
+	ret = clonerange(req->space_fd, &fcr);
+	if (ret == ENOSPC) {
+		struct file_xchg_range	xchg;
+
+		xfrog_file_exchange_prep(NULL, FILE_XCHG_RANGE_NONATOMIC,
+				mrec->fmr_physical, req->work_fd,
+				mrec->fmr_physical, frozen_len, &xchg);
+		ret = exchangerange(req->space_fd, &xchg);
+	}
+	if (ret) {
+		fprintf(stderr, _("freezing space to space capture file: %s\n"),
+				strerror(ret));
+		goto out_fd;
+	}
+
+advance:
+	*cursor += frozen_len;
+out_fd:
+	ret2 = close(src_fd);
+	if (!ret && ret2)
+		ret = ret2;
+	req->trace_indent--;
+	if (ret)
+		trace_freeze(req, "ret %d", ret);
+	return ret;
+skip:
+	*cursor += mrec->fmr_length;
+	return 0;
+}
+
+/*
+ * Try to freeze all the space in the requested range against overwrites.
+ *
+ * For each file data fsmap within each hole in the part of the space capture
+ * file corresponding to the requested range, try to reflink the space into the
+ * space capture file so that any subsequent writes to the original owner are
+ * CoW and nobody else can allocate the space.  If we cannot use reflink to
+ * freeze all the space, we cannot proceed with the clearing.
+ */
+static int
+csp_freeze_req_range(
+	struct clearspace_req	*req)
+{
+	unsigned long long	cursor = req->start;
+	loff_t			holepos = 0;
+	loff_t			length = 0;
+	int			ret;
+
+	ret = ftruncate(req->space_fd, req->start + req->length);
+	if (ret) {
+		perror(_("setting up space capture file"));
+		return ret;
+	}
+
+	if (!req->use_reflink)
+		return 0;
+
+	start_spacefd_iter(req);
+	while ((ret = spacefd_hole_iter(req, &holepos, &length)) > 0) {
+		trace_freeze(req, "spacefd hole 0x%llx length 0x%llx",
+				(long long)holepos, (long long)length);
+
+		start_fsmap_query(req, req->dev, holepos, length);
+		while ((ret = run_fsmap_query(req)) > 0) {
+			struct fsmap	*mrec;
+
+			for_each_fsmap_row(req, mrec) {
+				trace_fsmap_rec(req, CSP_TRACE_FREEZE, mrec);
+				trim_request_fsmap(req, mrec);
+				ret = csp_freeze_req_fsmap(req, &cursor, mrec);
+				if (ret) {
+					end_fsmap_query(req);
+					goto out;
+				}
+			}
+		}
+		end_fsmap_query(req);
+	}
+out:
+	end_spacefd_iter(req);
+	return ret;
+}
+
+/*
+ * Dump all speculative preallocations, COW staging blocks, and inactive inodes
+ * to try to free up as much space as we can.
+ */
+static int
+csp_collect_garbage(
+	struct clearspace_req	*req)
+{
+	struct xfs_fs_eofblocks	eofb = {
+		.eof_version	= XFS_EOFBLOCKS_VERSION,
+		.eof_flags	= XFS_EOF_FLAGS_SYNC,
+	};
+	int			ret;
+
+	ret = ioctl(req->xfd->fd, XFS_IOC_FREE_EOFBLOCKS, &eofb);
+	if (ret) {
+		perror(_("xfs garbage collector"));
+		return -1;
+	}
+
+	return 0;
+}
+
+/* Set up the target to clear all metadata from the given range. */
+static inline void
+csp_target_metadata(
+	struct clearspace_req	*req,
+	struct clearspace_tgt	*target)
+{
+	target->start = req->start;
+	target->length = req->length;
+	target->prio = 0;
+	target->evacuated = 0;
+	target->owners = 0;
+	target->try_again = false;
+}
+
+/*
+ * Loop through the space to find the most appealing part of the device to
+ * clear, then try to evacuate everything within.
+ */
+int
+clearspace_run(
+	struct clearspace_req	*req)
+{
+	struct clearspace_tgt	target;
+	const struct csp_errstr	*es;
+	bool			cleared_anything;
+	int			ret;
+
+	if (req->trace_mask) {
+		fprintf(stderr, "debug flags 0x%x:", req->trace_mask);
+		for (es = errtags; es->tag; es++) {
+			if (req->trace_mask & es->mask)
+				fprintf(stderr, " %s", es->tag);
+		}
+		fprintf(stderr, "\n");
+	}
+
+	req->trace_indent = 0;
+	trace_status(req,
+ _("Clearing dev %u:%u physical 0x%llx bytecount 0x%llx."),
+			major(req->dev), minor(req->dev),
+			req->start, req->length);
+
+	if (req->trace_mask & ~CSP_TRACE_STATUS)
+		trace_status(req, "reflink? %d evac_metadata? %d",
+				req->use_reflink, req->can_evac_metadata);
+
+	ret = bitmap_alloc(&req->visited);
+	if (ret) {
+		perror(_("allocating visited bitmap"));
+		return ret;
+	}
+
+	/*
+	 * Empty out CoW forks and speculative post-EOF preallocations before
+	 * starting the clearing process.  This may be somewhat overkill.
+	 */
+	ret = syncfs(req->xfd->fd);
+	if (ret) {
+		perror(_("syncing filesystem"));
+		goto out_bitmap;
+	}
+
+	ret = csp_collect_garbage(req);
+	if (ret)
+		goto out_bitmap;
+
+	/*
+	 * Try to freeze as much of the requested range as we can, grab the
+	 * free space in that range, and run freeze again to pick up anything
+	 * that may have been allocated while all that was going on.
+	 */
+	ret = csp_freeze_req_range(req);
+	if (ret)
+		goto out_bitmap;
+
+	ret = csp_grab_free_space(req);
+	if (ret)
+		goto out_bitmap;
+
+	ret = csp_freeze_req_range(req);
+	if (ret)
+		goto out_bitmap;
+
+	/*
+	 * If reflink is enabled, our strategy is to dedupe to free blocks in
+	 * the area that we're clearing without making any user-visible changes
+	 * to the file contents.  For all the written file data blocks in area
+	 * we're clearing, make an identical copy in the work file that is
+	 * backed by blocks that are not in the clearing area.
+	 */
+	if (req->use_reflink) {
+		ret = csp_prepare_for_dedupe(req);
+		if (ret)
+			goto out_bitmap;
+	}
+
+	/* Evacuate as many file blocks as we can. */
+	do {
+		ret = csp_find_target(req, &target);
+		if (ret)
+			goto out_bitmap;
+
+		if (target.length == 0)
+			break;
+
+		trace_target(req,
+	"phys 0x%llx len 0x%llx owners 0x%llx prio 0x%llx",
+				target.start, target.length,
+				target.owners, target.prio);
+
+		if (req->use_reflink)
+			ret = csp_evac_dedupe(req, &target);
+		else
+			ret = csp_evac_exchange(req, &target);
+		if (ret)
+			goto out_bitmap;
+
+		trace_status(req, _("Evacuated %llu file items."),
+				target.evacuated);
+	} while (target.evacuated > 0 || target.try_again);
+
+	if (!req->can_evac_metadata)
+		goto out_bitmap;
+
+	/* Evacuate as many AG metadata blocks as we can. */
+	do {
+		csp_target_metadata(req, &target);
+
+		ret = csp_evac_fs_metadata(req, &target, &cleared_anything);
+		if (ret)
+			goto out_bitmap;
+
+		trace_status(req, "evacuated %llu metadata items",
+				target.evacuated);
+	} while (target.evacuated > 0 && cleared_anything);
+
+out_bitmap:
+	bitmap_free(&req->visited);
+	return ret;
+}
+
+/* How much space did we actually clear? */
+int
+clearspace_efficacy(
+	struct clearspace_req	*req,
+	unsigned long long	*cleared_bytes)
+{
+	unsigned long long	cleared = 0;
+	int			ret;
+
+	start_bmapx_query(req, 0, req->start, req->length);
+	while ((ret = run_bmapx_query(req, req->space_fd)) > 0) {
+		struct getbmapx	*brec;
+
+		for_each_bmapx_row(req, brec) {
+			if (brec->bmv_block == -1)
+				continue;
+
+			trace_bmapx_rec(req, CSP_TRACE_EFFICACY, brec);
+
+			if (brec->bmv_offset != brec->bmv_block) {
+				fprintf(stderr,
+	_("space capture file mapped incorrectly\n"));
+				end_bmapx_query(req);
+				return -1;
+			}
+			cleared += BBTOB(brec->bmv_length);
+		}
+	}
+	end_bmapx_query(req);
+	if (ret)
+		return ret;
+
+	*cleared_bytes = cleared;
+	return 0;
+}
+
+/*
+ * Create a temporary file on the same volume (data/rt) that we're trying to
+ * clear free space on.
+ */
+static int
+csp_open_tempfile(
+	struct clearspace_req	*req,
+	struct stat		*statbuf)
+{
+	struct fsxattr		fsx;
+	int			fd, ret;
+
+	fd = openat(req->xfd->fd, ".", O_TMPFILE | O_RDWR | O_EXCL, 0600);
+	if (fd < 0) {
+		perror(_("opening temp file"));
+		return -1;
+	}
+
+	/* Make sure we got the same filesystem as the open file. */
+	ret = fstat(fd, statbuf);
+	if (ret) {
+		perror(_("stat temp file"));
+		goto fail;
+	}
+	if (statbuf->st_dev != req->statbuf.st_dev) {
+		fprintf(stderr,
+	_("Cannot create temp file on same fs as open file.\n"));
+		goto fail;
+	}
+
+	/* Ensure this file targets the correct data/rt device. */
+	ret = ioctl(fd, FS_IOC_FSGETXATTR, &fsx);
+	if (ret) {
+		perror(_("FSGETXATTR temp file"));
+		goto fail;
+	}
+
+	if (!!(fsx.fsx_xflags & FS_XFLAG_REALTIME) != req->realtime) {
+		if (req->realtime)
+			fsx.fsx_xflags |= FS_XFLAG_REALTIME;
+		else
+			fsx.fsx_xflags &= ~FS_XFLAG_REALTIME;
+
+		ret = ioctl(fd, FS_IOC_FSSETXATTR, &fsx);
+		if (ret) {
+			perror(_("FSSETXATTR temp file"));
+			goto fail;
+		}
+	}
+
+	trace_setup(req, "opening temp inode 0x%llx as fd %d",
+			(unsigned long long)statbuf->st_ino, fd);
+
+	return fd;
+fail:
+	close(fd);
+	return -1;
+}
+
+/* Extract fshandle from the open file. */
+static int
+csp_install_file(
+	struct clearspace_req	*req,
+	struct xfs_fd		*xfd)
+{
+	void			*handle;
+	size_t			handle_sz;
+	int			ret;
+
+	ret = fstat(xfd->fd, &req->statbuf);
+	if (ret)
+		return ret;
+
+	if (!S_ISDIR(req->statbuf.st_mode)) {
+		errno = -ENOTDIR;
+		return -1;
+	}
+
+	ret = fd_to_handle(xfd->fd, &handle, &handle_sz);
+	if (ret)
+		return ret;
+
+	ret = handle_to_fshandle(handle, handle_sz, &req->fshandle,
+			&req->fshandle_sz);
+	if (ret)
+		return ret;
+
+	free_handle(handle, handle_sz);
+	req->xfd = xfd;
+	return 0;
+}
+
+/* Decide if we can use online repair to evacuate metadata. */
+static void
+csp_detect_evac_metadata(
+	struct clearspace_req		*req)
+{
+	struct xfs_scrub_metadata	scrub = {
+		.sm_type		= XFS_SCRUB_TYPE_PROBE,
+		.sm_flags		= XFS_SCRUB_IFLAG_REPAIR |
+					  XFS_SCRUB_IFLAG_FORCE_REBUILD,
+	};
+	int				ret;
+
+	ret = ioctl(req->xfd->fd, XFS_IOC_SCRUB_METADATA, &scrub);
+	if (ret)
+		return;
+
+	/*
+	 * We'll try to evacuate metadata if the probe works.  This doesn't
+	 * guarantee success; it merely means that the kernel call exists.
+	 */
+	req->can_evac_metadata = true;
+}
+
+/* Detect FALLOC_FL_MAP_FREE; this is critical for grabbing free space! */
+static int
+csp_detect_fallocate_map_free(
+	struct clearspace_req	*req)
+{
+	int			ret;
+
+	/*
+	 * A single-byte fallocate request will succeed without doing anything
+	 * to the filesystem.
+	 */
+	ret = fallocate(req->work_fd, FALLOC_FL_MAP_FREE_SPACE, 0, 1);
+	if (!ret)
+		return 0;
+
+	if (errno == EOPNOTSUPP) {
+		fprintf(stderr,
+	_("Filesystem does not support FALLOC_FL_MAP_FREE_SPACE\n"));
+		return -1;
+	}
+
+	perror(_("test FALLOC_FL_MAP_FREE_SPACE on work file"));
+	return -1;
+}
+
+/*
+ * Assemble operation information to clear the physical space in part of a
+ * filesystem.
+ */
+int
+clearspace_init(
+	struct clearspace_req		**reqp,
+	const struct clearspace_init	*attrs)
+{
+	struct clearspace_req		*req;
+	int				ret;
+
+	req = calloc(1, sizeof(struct clearspace_req));
+	if (!req) {
+		perror(_("malloc clearspace"));
+		return -1;
+	}
+
+	req->work_fd = -1;
+	req->space_fd = -1;
+	req->trace_mask = attrs->trace_mask;
+
+	req->realtime = attrs->is_realtime;
+	req->dev = attrs->dev;
+	req->start = attrs->start;
+	req->length = attrs->length;
+
+	ret = csp_install_file(req, attrs->xfd);
+	if (ret) {
+		perror(attrs->fname);
+		goto fail;
+	}
+
+	csp_detect_evac_metadata(req);
+
+	req->work_fd = csp_open_tempfile(req, &req->temp_statbuf);
+	if (req->work_fd < 0)
+		goto fail;
+
+	req->space_fd = csp_open_tempfile(req, &req->space_statbuf);
+	if (req->space_fd < 0)
+		goto fail;
+
+	ret = csp_detect_fallocate_map_free(req);
+	if (ret)
+		goto fail;
+
+	req->mhead = calloc(1, fsmap_sizeof(QUERY_BATCH_SIZE));
+	if (!req->mhead) {
+		perror(_("opening fs mapping query"));
+		goto fail;
+	}
+
+	req->rhead = calloc(1, fsrefs_sizeof(QUERY_BATCH_SIZE));
+	if (!req->rhead) {
+		perror(_("opening refcount query"));
+		goto fail;
+	}
+
+	req->bhead = calloc(QUERY_BATCH_SIZE + 1, sizeof(struct getbmapx));
+	if (!req->bhead) {
+		perror(_("opening file mapping query"));
+		goto fail;
+	}
+
+	req->buf = malloc(BUFFERCOPY_BUFSZ);
+	if (!req->buf) {
+		perror(_("allocating file copy buffer"));
+		goto fail;
+	}
+
+	req->fdr = calloc(1, sizeof(struct file_dedupe_range) +
+			     sizeof(struct file_dedupe_range_info));
+	if (!req->fdr) {
+		perror(_("allocating dedupe control buffer"));
+		goto fail;
+	}
+
+	req->use_reflink = req->xfd->fsgeom.flags & XFS_FSOP_GEOM_FLAGS_REFLINK;
+
+	*reqp = req;
+	return 0;
+fail:
+	clearspace_free(&req);
+	return -1;
+}
+
+/* Free all resources associated with a space clearing request. */
+int
+clearspace_free(
+	struct clearspace_req	**reqp)
+{
+	struct clearspace_req	*req = *reqp;
+	int			ret = 0;
+
+	if (!req)
+		return 0;
+
+	*reqp = NULL;
+	free(req->fdr);
+	free(req->buf);
+	free(req->bhead);
+	free(req->rhead);
+	free(req->mhead);
+
+	if (req->space_fd >= 0) {
+		ret = close(req->space_fd);
+		if (ret)
+			perror(_("closing space capture file"));
+	}
+
+	if (req->work_fd >= 0) {
+		int	ret2 = close(req->work_fd);
+
+		if (ret2) {
+			perror(_("closing work file"));
+			if (!ret && ret2)
+				ret = ret2;
+		}
+	}
+
+	if (req->fshandle)
+		free_handle(req->fshandle, req->fshandle_sz);
+	free(req);
+	return ret;
+}
diff --git a/libfrog/clearspace.h b/libfrog/clearspace.h
new file mode 100644
index 00000000000..4b12c9b0475
--- /dev/null
+++ b/libfrog/clearspace.h
@@ -0,0 +1,72 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2022 Oracle. Inc.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __LIBFROG_CLEARSPACE_H__
+#define __LIBFROG_CLEARSPACE_H__
+
+struct clearspace_req;
+
+struct clearspace_init {
+	/* Open file and its pathname */
+	struct xfs_fd		*xfd;
+	const char		*fname;
+
+	/* Which device do we want? */
+	bool			is_realtime;
+	dev_t			dev;
+
+	/* Range of device to clear. */
+	unsigned long long	start;
+	unsigned long long	length;
+
+	unsigned int		trace_mask;
+};
+
+int clearspace_init(struct clearspace_req **reqp,
+		const struct clearspace_init *init);
+int clearspace_free(struct clearspace_req **reqp);
+
+int clearspace_run(struct clearspace_req *req);
+
+int clearspace_efficacy(struct clearspace_req *req,
+		unsigned long long *cleared_bytes);
+
+/* Debugging levels */
+
+#define CSP_TRACE_FREEZE	(0x01)
+#define CSP_TRACE_GRAB		(0x02)
+#define CSP_TRACE_FSMAP		(0x04)
+#define CSP_TRACE_FSREFS	(0x08)
+#define CSP_TRACE_BMAPX		(0x10)
+#define CSP_TRACE_PREP		(0x20)
+#define CSP_TRACE_TARGET	(0x40)
+#define CSP_TRACE_DEDUPE	(0x80)
+#define CSP_TRACE_FALLOC	(0x100)
+#define CSP_TRACE_FIEXCHANGE	(0x200)
+#define CSP_TRACE_XREBUILD	(0x400)
+#define CSP_TRACE_EFFICACY	(0x800)
+#define CSP_TRACE_SETUP		(0x1000)
+#define CSP_TRACE_STATUS	(0x2000)
+#define CSP_TRACE_DUMPFILE	(0x4000)
+#define CSP_TRACE_BITMAP	(0x8000)
+
+#define CSP_TRACE_ALL		(CSP_TRACE_FREEZE | \
+				 CSP_TRACE_GRAB | \
+				 CSP_TRACE_FSMAP | \
+				 CSP_TRACE_FSREFS | \
+				 CSP_TRACE_BMAPX | \
+				 CSP_TRACE_PREP	 | \
+				 CSP_TRACE_TARGET | \
+				 CSP_TRACE_DEDUPE | \
+				 CSP_TRACE_FALLOC | \
+				 CSP_TRACE_FIEXCHANGE | \
+				 CSP_TRACE_XREBUILD | \
+				 CSP_TRACE_EFFICACY | \
+				 CSP_TRACE_SETUP | \
+				 CSP_TRACE_STATUS | \
+				 CSP_TRACE_DUMPFILE | \
+				 CSP_TRACE_BITMAP)
+
+#endif /* __LIBFROG_CLEARSPACE_H__ */
diff --git a/man/man8/xfs_spaceman.8 b/man/man8/xfs_spaceman.8
index 837fc497f27..7c11953d16b 100644
--- a/man/man8/xfs_spaceman.8
+++ b/man/man8/xfs_spaceman.8
@@ -25,6 +25,23 @@ then the program exits.
 
 .SH COMMANDS
 .TP
+.BI "clearfree [ \-n nr ] [ \-r ] [ \-v mask ] " start " " length
+Try to clear the specified physical range in the filesystem.
+The
+.B start
+and
+.B length
+arguments must be given in units of bytes.
+If the
+.B -n
+option is given, run the clearing algorithm this many times.
+If the
+.B -r
+option is given, clear the realtime device.
+If the
+.B -v
+option is given, print what's happening every step of the way.
+.TP
 .BI "freesp [ \-dgrs ] [-a agno]... [ \-b | \-e bsize | \-h bsize | \-m factor ]"
 With no arguments,
 .B freesp
diff --git a/spaceman/Makefile b/spaceman/Makefile
index 1f048d54a4d..75df4ce86c2 100644
--- a/spaceman/Makefile
+++ b/spaceman/Makefile
@@ -10,8 +10,8 @@ HFILES = init.h space.h
 CFILES = info.c init.c file.c health.c prealloc.c trim.c
 LSRCFILES = xfs_info.sh
 
-LLDLIBS = $(LIBXCMD) $(LIBFROG)
-LTDEPENDENCIES = $(LIBXCMD) $(LIBFROG)
+LLDLIBS = $(LIBHANDLE) $(LIBXCMD) $(LIBFROG)
+LTDEPENDENCIES = $(LIBHANDLE) $(LIBXCMD) $(LIBFROG)
 LLDFLAGS = -static
 
 ifeq ($(ENABLE_EDITLINE),yes)
@@ -19,7 +19,7 @@ LLDLIBS += $(LIBEDITLINE) $(LIBTERMCAP)
 endif
 
 ifeq ($(HAVE_GETFSMAP),yes)
-CFILES += freesp.c
+CFILES += freesp.c clearfree.c
 endif
 
 default: depend $(LTCOMMAND)
diff --git a/spaceman/clearfree.c b/spaceman/clearfree.c
new file mode 100644
index 00000000000..e944a07b887
--- /dev/null
+++ b/spaceman/clearfree.c
@@ -0,0 +1,164 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "platform_defs.h"
+#include "command.h"
+#include "init.h"
+#include "libfrog/paths.h"
+#include "input.h"
+#include "libfrog/fsgeom.h"
+#include "libfrog/clearspace.h"
+#include "handle.h"
+#include "space.h"
+
+static void
+clearfree_help(void)
+{
+	printf(_(
+"Evacuate the contents of the given range of physical storage in the filesystem"
+"\n"
+" -n -- Run the space clearing algorithm this many times.\n"
+" -r -- clear space on the realtime device.\n"
+" -v -- verbosity level, or \"all\" to print everything.\n"
+"\n"
+"The start and length arguments are required, and must be specified in units\n"
+"of bytes.\n"
+"\n"));
+}
+
+static int
+clearfree_f(
+	int			argc,
+	char			**argv)
+{
+	struct clearspace_init	attrs = {
+		.xfd		= &file->xfd,
+		.fname		= file->name,
+	};
+	struct clearspace_req	*req = NULL;
+	unsigned long long	cleared;
+	unsigned long		arg;
+	long long		lnum;
+	unsigned int		i, nr = 1;
+	int			c, ret;
+
+	while ((c = getopt(argc, argv, "n:rv:")) != EOF) {
+		switch (c) {
+		case 'n':
+			errno = 0;
+			arg = strtoul(optarg, NULL, 0);
+			if (errno) {
+				perror(optarg);
+				return 1;
+			}
+			if (arg > UINT_MAX)
+				arg = UINT_MAX;
+			nr = arg;
+			break;
+		case 'r':	/* rt device */
+			attrs.is_realtime = true;
+			break;
+		case 'v':	/* Verbose output */
+			if (!strcmp(optarg, "all")) {
+				attrs.trace_mask = CSP_TRACE_ALL;
+			} else {
+				errno = 0;
+				attrs.trace_mask = strtoul(optarg, NULL, 0);
+				if (errno) {
+					perror(optarg);
+					return 1;
+				}
+			}
+			break;
+		default:
+			exitcode = 1;
+			clearfree_help();
+			return 0;
+		}
+	}
+
+	if (attrs.trace_mask)
+		attrs.trace_mask |= CSP_TRACE_STATUS;
+
+	if (argc != optind + 2) {
+		clearfree_help();
+		goto fail;
+	}
+
+	if (attrs.is_realtime) {
+		if (file->xfd.fsgeom.rtblocks == 0) {
+			fprintf(stderr, _("No realtime volume present.\n"));
+			goto fail;
+		}
+		attrs.dev = file->fs_path.fs_rtdev;
+	} else {
+		attrs.dev = file->fs_path.fs_datadev;
+	}
+
+	lnum = cvtnum(file->xfd.fsgeom.blocksize, file->xfd.fsgeom.sectsize,
+			argv[optind]);
+	if (lnum < 0) {
+		fprintf(stderr, _("Bad clearfree start sector %s.\n"),
+				argv[optind]);
+		goto fail;
+	}
+	attrs.start = lnum;
+
+	lnum = cvtnum(file->xfd.fsgeom.blocksize, file->xfd.fsgeom.sectsize,
+			argv[optind + 1]);
+	if (lnum < 0) {
+		fprintf(stderr, _("Bad clearfree length %s.\n"),
+				argv[optind + 1]);
+		goto fail;
+	}
+	attrs.length = lnum;
+
+	ret = clearspace_init(&req, &attrs);
+	if (ret)
+		goto fail;
+
+	for (i = 0; i < nr; i++) {
+		ret = clearspace_run(req);
+		if (ret)
+			goto fail;
+	}
+
+	ret = clearspace_efficacy(req, &cleared);
+	if (ret)
+		goto fail;
+
+	printf(_("Cleared 0x%llx bytes (%.1f%%) from 0x%llx to 0x%llx.\n"),
+			cleared, 100.0 * cleared / attrs.length, attrs.start,
+			attrs.start + attrs.length);
+
+	ret = clearspace_free(&req);
+	if (ret)
+		goto fail;
+
+	fshandle_destroy();
+	return 0;
+fail:
+	fshandle_destroy();
+	exitcode = 1;
+	return 1;
+}
+
+static struct cmdinfo clearfree_cmd = {
+	.name		= "clearfree",
+	.cfunc		= clearfree_f,
+	.argmin		= 0,
+	.argmax		= -1,
+	.flags		= CMD_FLAG_ONESHOT,
+	.args		= "[-n runs] [-r] [-v mask] start length",
+	.help		= clearfree_help,
+};
+
+void
+clearfree_init(void)
+{
+	clearfree_cmd.oneline = _("clear free space in the filesystem");
+
+	add_command(&clearfree_cmd);
+}
diff --git a/spaceman/init.c b/spaceman/init.c
index cf1ff3cbb0e..bce62dec47f 100644
--- a/spaceman/init.c
+++ b/spaceman/init.c
@@ -35,6 +35,7 @@ init_commands(void)
 	trim_init();
 	freesp_init();
 	health_init();
+	clearfree_init();
 }
 
 static int
diff --git a/spaceman/space.h b/spaceman/space.h
index 723209edd99..be4a7426ebf 100644
--- a/spaceman/space.h
+++ b/spaceman/space.h
@@ -28,8 +28,10 @@ extern void	quit_init(void);
 extern void	trim_init(void);
 #ifdef HAVE_GETFSMAP
 extern void	freesp_init(void);
+extern void	clearfree_init(void);
 #else
 # define freesp_init()	do { } while (0)
+# define clearfree_init()	do { } while(0)
 #endif
 extern void	info_init(void);
 extern void	health_init(void);

