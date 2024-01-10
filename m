Return-Path: <linux-xfs+bounces-2083-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BA83821169
	for <lists+linux-xfs@lfdr.de>; Mon,  1 Jan 2024 00:47:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 86EAB1F22324
	for <lists+linux-xfs@lfdr.de>; Sun, 31 Dec 2023 23:47:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B7E4C2C0;
	Sun, 31 Dec 2023 23:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nMMUaKDO"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07ED2C2C5
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:47:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87407C433C8;
	Sun, 31 Dec 2023 23:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066423;
	bh=wAlTItY/Amgzs9X3/2OA9HKvfXi8WoyBzZ3BAtRN0+M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nMMUaKDOuXqlYIyBijTQmO4Gq0qMRyNmhrCkN9Qv0NtfHiUAYLBO1whVI9Hx9E5gM
	 0//bJIGHF1knQFH8gqzKQRlP3A6cJ1LXjtJsmSqtBVs2ThHqiTAbq7HI1O9qsLQ0k4
	 7v/IhwdJXYitdRKH8bOgQIMgPrLMtwp1k3e/ZtqsOC6jxQwxVpDKlG3OlKHibQW3eU
	 W0E9de1891sh+3VrLouAERWTfcnl3lmjSpanIVQdSuhVIeD4PR2vuxzC6BnIBnYZsF
	 VzNvk2/PCDUTkQidDo6qfLaeDZmiLFHSPwTlV4/CBSpbmhm1LSq17yhgV7PaGD1deT
	 iJostOY3mNHXA==
Date: Sun, 31 Dec 2023 15:47:03 -0800
Subject: [PATCH 1/1] xfs_db: allow setting current address to log blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405011434.1811063.7438046909399237691.stgit@frogsfrogsfrogs>
In-Reply-To: <170405011421.1811063.2601536880760874799.stgit@frogsfrogsfrogs>
References: <170405011421.1811063.2601536880760874799.stgit@frogsfrogsfrogs>
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

Add commands so that users can target blocks on an external log device.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/block.c        |  103 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 man/man8/xfs_db.8 |   17 +++++++++
 2 files changed, 119 insertions(+), 1 deletion(-)


diff --git a/db/block.c b/db/block.c
index fff7f7d6f52..f234fcb4edc 100644
--- a/db/block.c
+++ b/db/block.c
@@ -29,6 +29,8 @@ static int	rtblock_f(int argc, char **argv);
 static void	rtblock_help(void);
 static int	rtextent_f(int argc, char **argv);
 static void	rtextent_help(void);
+static int	logblock_f(int argc, char **argv);
+static void	logblock_help(void);
 static void	print_rawdata(void *data, int len);
 
 static const cmdinfo_t	ablock_cmd =
@@ -49,6 +51,9 @@ static const cmdinfo_t	rtblock_cmd =
 static const cmdinfo_t	rtextent_cmd =
 	{ "rtextent", "rtx", rtextent_f, 0, 1, 1, N_("[rtxno]"),
 	  N_("set address to rtextent value"), rtextent_help };
+static const cmdinfo_t	logblock_cmd =
+	{ "logblock", "lsb", logblock_f, 0, 1, 1, N_("[logbno]"),
+	  N_("set address to logblock value"), logblock_help };
 
 static void
 ablock_help(void)
@@ -116,6 +121,7 @@ block_init(void)
 	add_command(&fsblock_cmd);
 	add_command(&rtblock_cmd);
 	add_command(&rtextent_cmd);
+	add_command(&logblock_cmd);
 }
 
 static void
@@ -132,6 +138,7 @@ daddr_help(void)
 enum daddr_target {
 	DT_DATA,
 	DT_RT,
+	DT_LOG,
 };
 
 static int
@@ -145,18 +152,27 @@ daddr_f(
 	xfs_rfsblock_t	max_daddrs = mp->m_sb.sb_dblocks;
 	enum daddr_target tgt = DT_DATA;
 
-	while ((c = getopt(argc, argv, "r")) != -1) {
+	while ((c = getopt(argc, argv, "rl")) != -1) {
 		switch (c) {
 		case 'r':
 			tgt = DT_RT;
 			max_daddrs = mp->m_sb.sb_rblocks;
 			break;
+		case 'l':
+			tgt = DT_LOG;
+			max_daddrs = mp->m_sb.sb_logblocks;
+			break;
 		default:
 			daddr_help();
 			return 0;
 		}
 	}
 
+	if (tgt == DT_LOG && mp->m_sb.sb_logstart > 0) {
+		dbprintf(_("filesystem has internal log\n"));
+		return 0;
+	}
+
 	if (optind == argc) {
 		xfs_daddr_t	daddr = iocur_top->off >> BBSHIFT;
 
@@ -191,6 +207,9 @@ daddr_f(
 	case DT_RT:
 		set_rt_cur(&typtab[TYP_DATA], d, 1, DB_RING_ADD, NULL);
 		break;
+	case DT_LOG:
+		set_log_cur(&typtab[TYP_DATA], d, 1, DB_RING_ADD, NULL);
+		break;
 	}
 	return 0;
 }
@@ -406,6 +425,88 @@ rtextent_f(
 	return 0;
 }
 
+static void
+logblock_help(void)
+{
+	dbprintf(_(
+"\n Example:\n"
+"\n"
+" 'logblock 1023' - sets the file position to the 1023rd log block.\n"
+" The external log device or the block offset within the internal log will be\n"
+" chosen as appropriate.\n"
+));
+}
+
+static int
+logblock_f(
+	int		argc,
+	char		**argv)
+{
+	xfs_fsblock_t	logblock;
+	char		*p;
+
+	if (argc == 1) {
+		if (mp->m_sb.sb_logstart > 0 && iocur_is_ddev(iocur_top)) {
+			logblock = XFS_DADDR_TO_FSB(mp,
+						iocur_top->off >> BBSHIFT);
+
+			if (logblock < mp->m_sb.sb_logstart ||
+			    logblock >= mp->m_sb.sb_logstart +
+					mp->m_sb.sb_logblocks) {
+				dbprintf(
+ _("current address not within internal log\n"));
+				return 0;
+			}
+
+			dbprintf(_("current logblock is %lld\n"),
+					logblock - mp->m_sb.sb_logstart);
+			return 0;
+		}
+
+		if (mp->m_sb.sb_logstart == 0 &&
+		    iocur_is_extlogdev(iocur_top)) {
+			logblock = XFS_BB_TO_FSB(mp,
+						iocur_top->off >> BBSHIFT);
+
+			if (logblock >= mp->m_sb.sb_logblocks) {
+				dbprintf(
+ _("current address not within external log\n"));
+				return 0;
+			}
+
+			dbprintf(_("current logblock is %lld\n"), logblock);
+			return 0;
+		}
+
+		dbprintf(_("current address does not point to log\n"));
+		return 0;
+	}
+
+	logblock = strtoull(argv[1], &p, 0);
+	if (*p != '\0') {
+		dbprintf(_("bad logblock %s\n"), argv[1]);
+		return 0;
+	}
+
+	if (logblock >= mp->m_sb.sb_logblocks) {
+		dbprintf(_("bad logblock %s\n"), argv[1]);
+		return 0;
+	}
+
+	ASSERT(typtab[TYP_DATA].typnm == TYP_DATA);
+
+	if (mp->m_sb.sb_logstart) {
+		logblock += mp->m_sb.sb_logstart;
+		set_cur(&typtab[TYP_DATA], XFS_FSB_TO_DADDR(mp, logblock),
+				blkbb, DB_RING_ADD, NULL);
+	} else {
+		set_log_cur(&typtab[TYP_DATA], XFS_FSB_TO_BB(mp, logblock),
+				blkbb, DB_RING_ADD, NULL);
+	}
+
+	return 0;
+}
+
 void
 print_block(
 	const field_t	*fields,
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 91e9e0ed9a5..15a30c11ae5 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -600,6 +600,9 @@ The type is set to
 .B data
 (uninterpreted).
 
+If an address and the
+.B \-l
+option are specified, the current address is set to the external log device.
 If an address and the
 .B \-r
 option are specified, the current address is set to the realtime device.
@@ -925,6 +928,20 @@ Start logging output to
 .IR filename ,
 stop logging, or print the current logging status.
 .TP
+.BI "logblock [" logbno ]
+Set current address to the log block value given by
+.IR logbno .
+If no value for
+.I logbno
+is given the current address is printed, expressed as an fsb.
+The type is set to
+.B data
+(uninterpreted).
+If the filesystem has an external log, then the address will be within the log
+device.
+If the filesystem has an internal log, then the address will be within the
+internal log.
+.TP
 .BI "logformat [\-c " cycle "] [\-s " sunit "]"
 Reformats the log to the specified log cycle and log stripe unit.
 This has the effect of clearing the log destructively.


