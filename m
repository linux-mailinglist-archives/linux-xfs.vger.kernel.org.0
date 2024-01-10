Return-Path: <linux-xfs+bounces-2119-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 867C4821190
	for <lists+linux-xfs@lfdr.de>; Mon,  1 Jan 2024 00:56:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 29D94B21A6B
	for <lists+linux-xfs@lfdr.de>; Sun, 31 Dec 2023 23:56:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFF37C2D4;
	Sun, 31 Dec 2023 23:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X8yr1VC1"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC15C2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:56:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ACE1C433C8;
	Sun, 31 Dec 2023 23:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066986;
	bh=HOoIANRlDXFX90KRM/6d2Wo2tKQUd8PAUJ6q/yss3yc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=X8yr1VC13Ktzcr92PgdS2BYELRfKE57vGcxSNgwpbIXoFTJ6o/ufKvt1GWuzHIqZC
	 aq9Irgav5NFiBDZw9onLm7NAdiU0h+O9mR+Bl8FuHDSqmp57M7erQxtlX1vxAei/aB
	 C3+i5W1vTfjC7pT/kJjYvBNZ/v+ULueHyXXzHe7Q8caa7pGwxZJrJIKND63OCTjU2p
	 uAB2HqOzKUkpIxjZ4RZrs7h+/oG4T4h5uCB6TwdNP9krTEnV0iCi+4LkLTJG8P5xnP
	 5to7rEQviWkHLNinTPQKRiMNEdKAymx/8Sr453WNKwfqosXiT3F56KSkT9Hznt76EG
	 YMjazvS4vxF8g==
Date: Sun, 31 Dec 2023 15:56:25 -0800
Subject: [PATCH 34/52] xfs_db: enable conversion of rt space units
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405012619.1811243.9609690695932217691.stgit@frogsfrogsfrogs>
In-Reply-To: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
References: <170405012128.1811243.5724050972228209086.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Teach the xfs_db convert function about realtime extents, blocks, and
realtime group numbers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/convert.c      |   38 +++++++++++++++++++++++++++++++++++++-
 man/man8/xfs_db.8 |   17 +++++++++++++++++
 2 files changed, 54 insertions(+), 1 deletion(-)


diff --git a/db/convert.c b/db/convert.c
index 7c0b1edc235..71d4a7f31b0 100644
--- a/db/convert.c
+++ b/db/convert.c
@@ -34,6 +34,10 @@
 	rtblock_to_bytes(rtx_to_rtblock(xfs_rbmblock_to_rtx(mp, (uint64_t)x)))
 #define rbmword_to_bytes(x)	\
 	rtblock_to_bytes(rtx_to_rtblock((uint64_t)(x) << XFS_NBWORDLOG))
+#define	rgblock_to_bytes(x)	\
+	((uint64_t)(x) << mp->m_sb.sb_blocklog)
+#define	rgnumber_to_bytes(x)	\
+	rgblock_to_bytes((uint64_t)(x) * mp->m_sb.sb_rgblocks)
 
 typedef enum {
 	CT_NONE = -1,
@@ -55,6 +59,8 @@ typedef enum {
 	CT_RSUMBLOCK,		/* block within rt summary */
 	CT_RSUMLOG,		/* log level for rtsummary computations */
 	CT_RSUMINFO,		/* info word within rt summary */
+	CT_RGBLOCK,		/* xfs_rgblock_t */
+	CT_RGNUMBER,		/* xfs_rgno_t */
 	NCTS
 } ctype_t;
 
@@ -80,6 +86,8 @@ typedef union {
 	xfs_fileoff_t	rbmblock;
 	unsigned int	rbmword;
 	xfs_fileoff_t	rsumblock;
+	xfs_rgnumber_t	rgnumber;
+	xfs_rgblock_t	rgblock;
 } cval_t;
 
 static uint64_t		bytevalue(ctype_t ctype, cval_t *val);
@@ -95,7 +103,7 @@ static const char	*agnumber_names[] = { "agnumber", "agno", NULL };
 static const char	*bboff_names[] = { "bboff", "daddroff", NULL };
 static const char	*blkoff_names[] = { "blkoff", "fsboff", "agboff",
 					    NULL };
-static const char	*rtblkoff_names[] = { "blkoff", "rtboff",
+static const char	*rtblkoff_names[] = { "blkoff", "rtboff", "rgboff",
 					    NULL };
 static const char	*byte_names[] = { "byte", "fsbyte", NULL };
 static const char	*daddr_names[] = { "daddr", "bb", NULL };
@@ -111,6 +119,8 @@ static const char	*rbmword_names[] = { "rbmword", "rbmw", NULL };
 static const char	*rsumblock_names[] = { "rsumblock", "rsmb", NULL };
 static const char	*rsumlog_names[] = { "rsumlog", "rsml", NULL };
 static const char	*rsumword_names[] = { "rsuminfo", "rsmi", NULL };
+static const char	*rgblock_names[] = { "rgblock", "rgbno", NULL };
+static const char	*rgnumber_names[] = { "rgnumber", "rgno", NULL };
 
 static int		rsuminfo;
 static int		rsumlog;
@@ -208,6 +218,14 @@ static const ctydesc_t	ctydescs_rt[NCTS] = {
 		.allowed = M(RSUMBLOCK),
 		.names   = rsumword_names,
 	},
+	[CT_RGBLOCK] = {
+		.allowed = M(RGNUMBER)|M(BBOFF)|M(BLKOFF)|M(RSUMLOG),
+		.names   = rgblock_names,
+	},
+	[CT_RGNUMBER] = {
+		.allowed = M(RGBLOCK)|M(BBOFF)|M(BLKOFF)|M(RSUMLOG),
+		.names   = rgnumber_names,
+	},
 };
 
 static const cmdinfo_t	convert_cmd =
@@ -295,6 +313,10 @@ bytevalue(ctype_t ctype, cval_t *val)
 		 * value.
 		 */
 		return 0;
+	case CT_RGBLOCK:
+		return rgblock_to_bytes(val->rgblock);
+	case CT_RGNUMBER:
+		return rgnumber_to_bytes(val->rgnumber);
 	case CT_NONE:
 	case NCTS:
 		break;
@@ -401,6 +423,8 @@ convert_f(int argc, char **argv)
 	case CT_RSUMBLOCK:
 	case CT_RSUMLOG:
 	case CT_RSUMINFO:
+	case CT_RGBLOCK:
+	case CT_RGNUMBER:
 		/* shouldn't get here */
 		ASSERT(0);
 		break;
@@ -551,6 +575,12 @@ rtconvert_f(int argc, char **argv)
 	case CT_RSUMINFO:
 		v = rt_daddr_to_rsuminfo(mp, v);
 		break;
+	case CT_RGBLOCK:
+		v = xfs_daddr_to_rgbno(mp, v >> BBSHIFT);
+		break;
+	case CT_RGNUMBER:
+		v = xfs_daddr_to_rgno(mp, v >> BBSHIFT);
+		break;
 	case CT_AGBLOCK:
 	case CT_AGINO:
 	case CT_AGNUMBER:
@@ -643,6 +673,12 @@ getvalue(char *s, ctype_t ctype, cval_t *val)
 	case CT_RSUMINFO:
 		rsuminfo = (unsigned int)v;
 		break;
+	case CT_RGBLOCK:
+		val->rgblock = (xfs_rgblock_t)v;
+		break;
+	case CT_RGNUMBER:
+		val->rgnumber = (xfs_rgnumber_t)v;
+		break;
 	case CT_NONE:
 	case NCTS:
 		/* NOTREACHED */
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 15a30c11ae5..d0115075888 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -1077,6 +1077,16 @@ with alternate names, are:
 .RS 1.0i
 .PD 0
 .HP
+.B rgblock
+or
+.B rgbno
+(realtime block within a realtime group)
+.HP
+.B rgnumber
+or
+.B rgno
+(realtime group number)
+.HP
 .B bboff
 or
 .B daddroff
@@ -1144,6 +1154,13 @@ or
 .RE
 .IP
 Only conversions that "make sense" are allowed.
+The compound form (with more than three arguments) is useful for
+conversions such as
+.B convert rgno
+.I rg
+.B rgbno
+.I rgb
+.BR rtblock .
 
 Realtime summary file location conversions have the following rules:
 Each info word in the rt summary file counts the number of free extents of a


