Return-Path: <linux-xfs+bounces-14909-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 12CF99B8712
	for <lists+linux-xfs@lfdr.de>; Fri,  1 Nov 2024 00:23:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 95D061F22BBE
	for <lists+linux-xfs@lfdr.de>; Thu, 31 Oct 2024 23:23:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DFE61E1A12;
	Thu, 31 Oct 2024 23:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ha32qtA2"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C911DFD81
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730416998; cv=none; b=EIkr5BeD2bbnmnnTZAhd7K8/7tLAuNEIzZm7YhxaBzNfhXGtKlIcGZuZj+yNRv3zEmy1WGg8LepXw5COCq8GiiySyV9WVACWCIp9teZc/r7wJDvFZbqOKjwLeGjOThocS2nusNqL6kq+RIy0tM49S+2i5QJiZkuNOiFyactPJh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730416998; c=relaxed/simple;
	bh=To2WTMOlLMOxIpwhvGmWidF/ZbPMofBP3P/EWYt95ng=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hRSXSeuItqEpHexpWus9PF+BqFCC4eh3bpmsSY8TloUp0tpdYCS90wa07cmuSvYX8ZYQyyoFMV6Z8a80hpxEsSHWoEgVTYw8cRaPM2VQaE9WUTiEPLD5x+t0ZPCJJxY8ht3pXLqmi6ihj7IWoNfoy2PYVNdbuxx3pWKikOTjbUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ha32qtA2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8448DC4CEC3;
	Thu, 31 Oct 2024 23:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730416997;
	bh=To2WTMOlLMOxIpwhvGmWidF/ZbPMofBP3P/EWYt95ng=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ha32qtA2i6WzBfkFZjfVrmCv9a6DlDEIQQfvOkH0dHA5tJ1kB3BybAC2oxTEqRyMl
	 M/vryFkYT3XhqPPymboeFsArzunbfxAr4hWhPT8Qx5QeF5fA8KvPdp/LibMVho9roo
	 iXZVTMrtU2rSCRviv/KwT9JDC2xygDBPZh57MUa21mT9dIEEG17Pvp9Xfsscp1jz1p
	 zuLrVSLPyJRvbSqmWG2MAOwUcBJo3/m+O2kRknGUgKVavHITQKbOiSKfxSW64VHc5l
	 t/KVO9zevTrZB0o77gPbVHkqMQbMv/nK8+HwrtSp+vKlVi2H+sI5tWNBxcQ0F8MGTL
	 dfrOBAoflO3Vg==
Date: Thu, 31 Oct 2024 16:23:17 -0700
Subject: [PATCH 8/8] xfs_db: convert rtsummary geometry
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173041567460.964205.16459457764430821254.stgit@frogsfrogsfrogs>
In-Reply-To: <173041567330.964205.623580785256778088.stgit@frogsfrogsfrogs>
References: <173041567330.964205.623580785256778088.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Teach the rtconvert command to be able to convert realtime blocks and
extents to locations within the rt summary.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/convert.c      |  161 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 man/man8/xfs_db.8 |   29 ++++++++++
 2 files changed, 182 insertions(+), 8 deletions(-)


diff --git a/db/convert.c b/db/convert.c
index 7c10690f574f7a..3014367e7d7652 100644
--- a/db/convert.c
+++ b/db/convert.c
@@ -53,6 +53,9 @@ typedef enum {
 	CT_RTX,			/* realtime extent */
 	CT_RBMBLOCK,		/* block within rt bitmap */
 	CT_RBMWORD,		/* word within rt bitmap */
+	CT_RSUMBLOCK,		/* block within rt summary */
+	CT_RSUMLOG,		/* log level for rtsummary computations */
+	CT_RSUMINFO,		/* info word within rt summary */
 	NCTS
 } ctype_t;
 
@@ -77,6 +80,7 @@ typedef union {
 	xfs_rtblock_t	rtx;
 	xfs_fileoff_t	rbmblock;
 	unsigned int	rbmword;
+	xfs_fileoff_t	rsumblock;
 } cval_t;
 
 static uint64_t		bytevalue(ctype_t ctype, cval_t *val);
@@ -105,6 +109,12 @@ static const char	*rtblock_names[] = { "rtblock", "rtb", "rtbno", NULL };
 static const char	*rtx_names[] = { "rtx", "rtextent", NULL };
 static const char	*rbmblock_names[] = { "rbmblock", "rbmb", NULL };
 static const char	*rbmword_names[] = { "rbmword", "rbmw", NULL };
+static const char	*rsumblock_names[] = { "rsumblock", "rsmb", NULL };
+static const char	*rsumlog_names[] = { "rsumlog", "rsml", NULL };
+static const char	*rsumword_names[] = { "rsuminfo", "rsmi", NULL };
+
+static int		rsuminfo;
+static int		rsumlog;
 
 static const ctydesc_t	ctydescs[NCTS] = {
 	[CT_AGBLOCK] = {
@@ -181,39 +191,60 @@ static const ctydesc_t	ctydescs[NCTS] = {
 static const ctydesc_t	ctydescs_rt[NCTS] = {
 	[CT_BBOFF] = {
 		.allowed = M(DADDR) |
-			   M(RTBLOCK),
+			   M(RTBLOCK) |
+			   M(RSUMLOG),
 		.names   = bboff_names,
 	},
 	[CT_BLKOFF] = {
-		.allowed = M(RTBLOCK),
+		.allowed = M(RTBLOCK) |
+			   M(RSUMLOG),
 		.names   = rtblkoff_names,
 	},
 	[CT_BYTE] = {
-		.allowed = 0,
+		.allowed = M(RSUMLOG),
 		.names   = byte_names,
 	},
 	[CT_DADDR] = {
-		.allowed = M(BBOFF),
+		.allowed = M(BBOFF) |
+			   M(RSUMLOG),
 		.names   = daddr_names,
 	},
 	[CT_RTBLOCK] = {
 		.allowed = M(BBOFF) |
-			   M(BLKOFF),
+			   M(BLKOFF) |
+			   M(RSUMLOG),
 		.names   = rtblock_names,
 	},
 	[CT_RTX] = {
 		.allowed = M(BBOFF) |
-			   M(BLKOFF),
+			   M(BLKOFF) |
+			   M(RSUMLOG),
 		.names   = rtx_names,
 	},
 	[CT_RBMBLOCK] = {
-		.allowed = M(RBMWORD),
+		.allowed = M(RBMWORD) |
+			   M(RSUMLOG),
 		.names   = rbmblock_names,
 	},
 	[CT_RBMWORD] = {
-		.allowed = M(RBMBLOCK),
+		.allowed = M(RBMBLOCK) |
+			   M(RSUMLOG),
 		.names   = rbmword_names,
 	},
+	/* must be specified in order rsumlog -> rsuminfo -> rsumblock */
+	[CT_RSUMBLOCK] = {
+		.allowed = 0,
+		.names   = rsumblock_names,
+	},
+	[CT_RSUMLOG] = {
+		.allowed = M(RSUMINFO) |
+			   M(RSUMBLOCK),
+		.names   = rsumlog_names,
+	},
+	[CT_RSUMINFO] = {
+		.allowed = M(RSUMBLOCK),
+		.names   = rsumword_names,
+	},
 };
 
 static const cmdinfo_t	convert_cmd =
@@ -224,6 +255,39 @@ static const cmdinfo_t	rtconvert_cmd =
 	{ "rtconvert", NULL, rtconvert_f, 3, 9, 0, "type num [type num]... type",
 	  "convert from one realtime address form to another", NULL };
 
+static inline uint64_t
+rsumblock_to_bytes(
+	xfs_fileoff_t	rsumblock)
+{
+	/*
+	 * We compute the rt summary file block with this formula:
+	 *   sumoffs = (log2len * sb_rbmblocks) + rbmblock;
+	 *   sumblock = sumoffs / blockwsize;
+	 *
+	 * Hence the return value is the inverse of this:
+	 *   sumoffs = (rsumblock * blockwsize) + rsuminfo;
+	 *   rbmblock = sumoffs % (log2len * sb_rbmblocks);
+	 */
+	xfs_rtsumoff_t	sumoff;
+	xfs_fileoff_t	rbmblock;
+
+	if (rsumlog < 0) {
+		dbprintf(_("need to set rsumlog\n"));
+		return 0;
+	}
+	if (rsuminfo < 0) {
+		dbprintf(_("need to set rsuminfo\n"));
+		return 0;
+	}
+
+	sumoff = rsuminfo + (rsumblock * mp->m_blockwsize);
+	if (rsumlog)
+		rbmblock = sumoff % (rsumlog * mp->m_sb.sb_rbmblocks);
+	else
+		rbmblock = sumoff;
+	return rbmblock_to_bytes(rbmblock);
+}
+
 static uint64_t
 bytevalue(ctype_t ctype, cval_t *val)
 {
@@ -258,6 +322,16 @@ bytevalue(ctype_t ctype, cval_t *val)
 		return rbmblock_to_bytes(val->rbmblock);
 	case CT_RBMWORD:
 		return rbmword_to_bytes(val->rbmword);
+	case CT_RSUMBLOCK:
+		return rsumblock_to_bytes(val->rbmblock);
+	case CT_RSUMLOG:
+	case CT_RSUMINFO:
+		/*
+		 * These have to specified before rsumblock, and are stored in
+		 * global variables.  Hence they do not adjust the disk address
+		 * value.
+		 */
+		return 0;
 	case CT_NONE:
 	case NCTS:
 		break;
@@ -361,6 +435,9 @@ convert_f(int argc, char **argv)
 	case CT_RTX:
 	case CT_RBMBLOCK:
 	case CT_RBMWORD:
+	case CT_RSUMBLOCK:
+	case CT_RSUMLOG:
+	case CT_RSUMINFO:
 		/* shouldn't get here */
 		ASSERT(0);
 		break;
@@ -373,6 +450,52 @@ convert_f(int argc, char **argv)
 	return 0;
 }
 
+static inline uint64_t
+rt_daddr_to_rsumblock(
+	struct xfs_mount	*mp,
+	uint64_t		input)
+{
+	xfs_rtblock_t		rtbno;
+	xfs_rtxnum_t		rtx;
+	xfs_fileoff_t		rbmblock;
+	xfs_rtsumoff_t		rsumoff;
+
+	if (rsumlog < 0) {
+		dbprintf(_("need to set rsumlog\n"));
+		return 0;
+	}
+
+	rtbno = xfs_daddr_to_rtb(mp, input >> BBSHIFT);
+	rtx = xfs_rtb_to_rtx(mp, rtbno);
+	rbmblock = xfs_rtx_to_rbmblock(mp, rtx);
+	rsumoff = xfs_rtsumoffs(mp, rsumlog, rbmblock);
+
+	return xfs_rtsumoffs_to_block(mp, rsumoff);
+}
+
+static inline uint64_t
+rt_daddr_to_rsuminfo(
+	struct xfs_mount	*mp,
+	uint64_t		input)
+{
+	xfs_rtblock_t		rtbno;
+	xfs_rtxnum_t		rtx;
+	xfs_fileoff_t		rbmblock;
+	xfs_rtsumoff_t		rsumoff;
+
+	if (rsumlog < 0) {
+		dbprintf(_("need to set rsumlog\n"));
+		return 0;
+	}
+
+	rtbno = xfs_daddr_to_rtb(mp, input >> BBSHIFT);
+	rtx = xfs_rtb_to_rtx(mp, rtbno);
+	rbmblock = xfs_rtx_to_rbmblock(mp, rtx);
+	rsumoff = xfs_rtsumoffs(mp, rsumlog, rbmblock);
+
+	return xfs_rtsumoffs_to_infoword(mp, rsumoff);
+}
+
 static int
 rtconvert_f(int argc, char **argv)
 {
@@ -384,6 +507,9 @@ rtconvert_f(int argc, char **argv)
 	uint64_t	v;
 	ctype_t		wtype;
 
+	rsumlog = -1;
+	rsuminfo = -1;
+
 	/* move past the "rtconvert" command */
 	argc--;
 	argv++;
@@ -452,6 +578,16 @@ rtconvert_f(int argc, char **argv)
 				xfs_rtb_to_rtx(mp,
 					xfs_daddr_to_rtb(mp, v >> BBSHIFT)));
 		break;
+	case CT_RSUMBLOCK:
+		v = rt_daddr_to_rsumblock(mp, v);
+		break;
+	case CT_RSUMLOG:
+		dbprintf(_("cannot convert to rsumlog\n"));
+		return 0;
+		break;
+	case CT_RSUMINFO:
+		v = rt_daddr_to_rsuminfo(mp, v);
+		break;
 	case CT_AGBLOCK:
 	case CT_AGINO:
 	case CT_AGNUMBER:
@@ -535,6 +671,15 @@ getvalue(char *s, ctype_t ctype, cval_t *val)
 	case CT_RBMWORD:
 		val->rbmword = (unsigned int)v;
 		break;
+	case CT_RSUMBLOCK:
+		val->rsumblock = (xfs_fileoff_t)v;
+		break;
+	case CT_RSUMLOG:
+		rsumlog = (unsigned int)v;
+		break;
+	case CT_RSUMINFO:
+		rsuminfo = (unsigned int)v;
+		break;
 	case CT_NONE:
 	case NCTS:
 		/* NOTREACHED */
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 12fc4f3b51016b..ffa04879ce76c8 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -1183,10 +1183,39 @@ .SH COMMANDS
 or
 .B rbmw
 (32-bit word within a realtime bitmap block)
+.HP
+.B rsumblock
+or
+.B rsmb
+(realtime summary file block)
+.HP
+.B rsuminfo
+or
+.B rsmi
+(32-bit counter within a realtime summary block)
+.HP
+.B rsumlog
+or
+.B rsml
+(log2len parameter used for summary file offset computations)
 .PD
 .RE
 .IP
 Only conversions that "make sense" are allowed.
+
+Realtime summary file location conversions have the following rules:
+Each info word in the rt summary file counts the number of free extents of a
+given log2(length) that start in a given rt bitmap block.
+
+To compute summary file location information for a given rt bitmap block, a
+log2(extent length) must be specified as the last type/number pair before the
+conversion type, and the type must be
+.BR rsumlog .
+
+To compute the rt bitmap block from summary file location, the type/number pairs
+must be specified exactly in the order
+.BR rsumlog ", " rsuminfo ", " rsumblock .
+
 .TP
 .BI "sb [" agno ]
 Set current address to SB header in allocation group


