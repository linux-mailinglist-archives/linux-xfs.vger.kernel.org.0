Return-Path: <linux-xfs+bounces-2121-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 70F8D821192
	for <lists+linux-xfs@lfdr.de>; Mon,  1 Jan 2024 00:57:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 89A931C21C4F
	for <lists+linux-xfs@lfdr.de>; Sun, 31 Dec 2023 23:57:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D47C3C2CC;
	Sun, 31 Dec 2023 23:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KH/dAaxB"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01F4C2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:56:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E3C7C433C8;
	Sun, 31 Dec 2023 23:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704067017;
	bh=fE2v5a6hyP/yC45S0sJw1abNhApH+knrVOvIaNsfIDU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KH/dAaxBe1hxLetsHreyolPtUEAmG9t1ztQWKSrSPfTqonfm6Xqufe0EPfrv5P3NL
	 yCI4btANsx5eq+U5+mDrpZ92KtVybtKAxcojOsgfB5ErdLvnzJnA0G2Wr7o7J8JagU
	 2/hbmX5SQKzCOXInX2iX2VaHLK7OgA72vjB65yweOqJNcOR37TSeylT7PwRmJe0CI1
	 7wkR7xdUpDOiF8ajVvTWzGF8t33hC+rtcmhymbDpELihd57LEVu02GlYXcBKfAIzwJ
	 jPB+mpVkAzxFDag9XO8AzZdzSMuOLzD2LJvt+7dH2VDf0bIHEm84t5PMRCHXabkDiA
	 Ob8DNxqcvSrsw==
Date: Sun, 31 Dec 2023 15:56:57 -0800
Subject: [PATCH 36/52] xfs_db: metadump realtime devices
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405012645.1811243.12388251737381651061.stgit@frogsfrogsfrogs>
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

Teach the metadump device to dump the filesystem metadata of a realtime
device to the metadump file.  Currently, this is limited to the rt group
superblocks.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/metadump.c             |   61 +++++++++++++++++++++++++++++++++++++++++++++
 db/xfs_metadump.sh        |    5 ++--
 include/xfs_metadump.h    |    8 ++++++
 man/man8/xfs_metadump.8   |   11 ++++++++
 mdrestore/xfs_mdrestore.c |    5 +++-
 5 files changed, 87 insertions(+), 3 deletions(-)


diff --git a/db/metadump.c b/db/metadump.c
index 714be862231..be4cc01ff26 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -85,6 +85,7 @@ static struct metadump {
 	bool			dirty_log;
 	bool			external_log;
 	bool			stdout_metadump;
+	bool			realtime_data;
 	xfs_ino_t		cur_ino;
 	/* Metadump file */
 	FILE			*outf;
@@ -3099,6 +3100,7 @@ init_metadump_v2(void)
 {
 	struct xfs_metadump_header	xmh = {0};
 	uint32_t			compat_flags = 0;
+	uint32_t			incompat_flags = 0;
 
 	xmh.xmh_magic = cpu_to_be32(XFS_MD_MAGIC_V2);
 	xmh.xmh_version = cpu_to_be32(2);
@@ -3111,8 +3113,11 @@ init_metadump_v2(void)
 		compat_flags |= XFS_MD2_COMPAT_DIRTYLOG;
 	if (metadump.external_log)
 		compat_flags |= XFS_MD2_COMPAT_EXTERNALLOG;
+	if (metadump.realtime_data)
+		incompat_flags |= XFS_MD2_INCOMPAT_RTDEVICE;
 
 	xmh.xmh_compat_flags = cpu_to_be32(compat_flags);
+	xmh.xmh_incompat_flags = cpu_to_be32(incompat_flags);
 
 	if (fwrite(&xmh, sizeof(xmh), 1, metadump.outf) != 1) {
 		print_warning("error writing to target file");
@@ -3122,6 +3127,39 @@ init_metadump_v2(void)
 	return 0;
 }
 
+static int
+copy_rtsupers(void)
+{
+	int		error;
+	xfs_rtblock_t	rtbno;
+	xfs_rgnumber_t	rgno = 0;
+
+	if (metadump.show_progress)
+		print_progress("Copying realtime superblocks");
+
+	for (rgno = 0; rgno < mp->m_sb.sb_rgcount; rgno++) {
+		rtbno = xfs_rgbno_to_rtb(mp, rgno, 0);
+
+		push_cur();
+		error = set_rt_cur(&typtab[TYP_RTSB],
+				xfs_rtb_to_daddr(mp, rtbno),
+				XFS_FSB_TO_BB(mp, 1), DB_RING_ADD, NULL);
+		if (error)
+			return 0;
+		if (iocur_top->data == NULL) {
+			pop_cur();
+			print_warning("cannot read rt super %u", rgno);
+			return !metadump.stop_on_read_error;
+		}
+		error = write_buf(iocur_top);
+		pop_cur();
+		if (error)
+			return 0;
+	}
+
+	return 1;
+}
+
 static int
 write_metadump_v2(
 	enum typnm		type,
@@ -3136,6 +3174,8 @@ write_metadump_v2(
 	if (type == TYP_LOG &&
 	    mp->m_logdev_targp->bt_bdev != mp->m_ddev_targp->bt_bdev)
 		addr |= XME_ADDR_LOG_DEVICE;
+	else if (type == TYP_RTSB)
+		addr |= XME_ADDR_RT_DEVICE;
 	else
 		addr |= XME_ADDR_DATA_DEVICE;
 
@@ -3184,6 +3224,7 @@ metadump_f(
 	metadump.zero_stale_data = true;
 	metadump.dirty_log = false;
 	metadump.external_log = false;
+	metadump.realtime_data = false;
 
 	if (mp->m_sb.sb_magicnum != XFS_SB_MAGIC) {
 		print_warning("bad superblock magic number %x, giving up",
@@ -3262,6 +3303,20 @@ metadump_f(
 		return 1;
 	}
 
+	/* The realtime device only contains metadata if rtgroups is enabled. */
+	if (mp->m_rtdev_targp->bt_bdev && xfs_has_rtgroups(mp))
+		metadump.realtime_data = true;
+
+	if (metadump.realtime_data && !version_opt_set)
+		metadump.version = 2;
+
+	if (metadump.version == 2 && xfs_has_realtime(mp) &&
+	    xfs_has_rtgroups(mp) &&
+	    !metadump.realtime_data) {
+		print_warning("realtime device not loaded, use -R");
+		return 1;
+	}
+
 	/*
 	 * If we'll copy the log, see if the log is dirty.
 	 *
@@ -3365,6 +3420,12 @@ metadump_f(
 	if (!exitcode && !(metadump.version == 1 && metadump.external_log))
 		exitcode = !copy_log();
 
+	/* copy rt sueprblocks */
+	if (!exitcode && metadump.realtime_data) {
+		if (!copy_rtsupers())
+			exitcode = 1;
+	}
+
 	/* write the remaining index */
 	if (!exitcode && metadump.mdops->finish_dump)
 		exitcode = metadump.mdops->finish_dump() < 0;
diff --git a/db/xfs_metadump.sh b/db/xfs_metadump.sh
index 9e8f86e53eb..b5c6959f200 100755
--- a/db/xfs_metadump.sh
+++ b/db/xfs_metadump.sh
@@ -6,9 +6,9 @@
 
 OPTS=" "
 DBOPTS=" "
-USAGE="Usage: xfs_metadump [-aefFogwV] [-m max_extents] [-l logdev] source target"
+USAGE="Usage: xfs_metadump [-aefFogwV] [-m max_extents] [-l logdev] [-r rtdev] [-v version] source target"
 
-while getopts "aefgl:m:owFv:V" c
+while getopts "aefFgl:m:or:wv:V" c
 do
 	case $c in
 	a)	OPTS=$OPTS"-a ";;
@@ -25,6 +25,7 @@ do
 		status=$?
 		exit $status
 		;;
+	r)	DBOPTS=$DBOPTS"-R "$OPTARG" ";;
 	\?)	echo $USAGE 1>&2
 		exit 2
 		;;
diff --git a/include/xfs_metadump.h b/include/xfs_metadump.h
index e9c3dcb8f71..e35f791573e 100644
--- a/include/xfs_metadump.h
+++ b/include/xfs_metadump.h
@@ -68,12 +68,18 @@ struct xfs_metadump_header {
 /* Dump contains external log contents. */
 #define XFS_MD2_COMPAT_EXTERNALLOG	(1 << 3)
 
+/* Dump contains realtime device contents. */
+#define XFS_MD2_INCOMPAT_RTDEVICE	(1U << 0)
+
+#define XFS_MD2_INCOMPAT_ALL		(XFS_MD2_INCOMPAT_RTDEVICE)
+
 struct xfs_meta_extent {
 	/*
 	 * Lowest 54 bits are used to store 512 byte addresses.
 	 * Next 2 bits is used for indicating the device.
 	 * 00 - Data device
 	 * 01 - External log
+	 * 10 - Realtime device
 	 */
 	__be64 xme_addr;
 	/* In units of 512 byte blocks */
@@ -88,6 +94,8 @@ struct xfs_meta_extent {
 #define XME_ADDR_DATA_DEVICE	(0ULL << XME_ADDR_DEVICE_SHIFT)
 /* Extent was copied from the log device */
 #define XME_ADDR_LOG_DEVICE	(1ULL << XME_ADDR_DEVICE_SHIFT)
+/* Extent was copied from the rt device */
+#define XME_ADDR_RT_DEVICE	(2ULL << XME_ADDR_DEVICE_SHIFT)
 
 #define XME_ADDR_DEVICE_MASK	(3ULL << XME_ADDR_DEVICE_SHIFT)
 
diff --git a/man/man8/xfs_metadump.8 b/man/man8/xfs_metadump.8
index 496b5926603..8618ea99b9a 100644
--- a/man/man8/xfs_metadump.8
+++ b/man/man8/xfs_metadump.8
@@ -12,6 +12,9 @@ xfs_metadump \- copy XFS filesystem metadata to a file
 .B \-l
 .I logdev
 ] [
+.B \-r
+.I rtdev
+] [
 .B \-v
 .I version
 ]
@@ -146,6 +149,14 @@ this value.  The default size is 2097151 blocks.
 .B \-o
 Disables obfuscation of file names and extended attributes.
 .TP
+.BI \-r  " rtdev"
+For filesystems that have a realtime section, this specifies the device where
+the realtime section resides.
+If the v2 metadump format is selected, the realtime group superblocks will be
+copied to the metadump.
+The v2 metadump format will be selected automatically if the filesystem
+contains realtime groups.
+.TP
 .B \-v
 The format of the metadump file to be produced.
 Valid values are 1 and 2.
diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
index 6465a481ce3..e0572b31e2c 100644
--- a/mdrestore/xfs_mdrestore.c
+++ b/mdrestore/xfs_mdrestore.c
@@ -314,7 +314,7 @@ read_header_v2(
 			sizeof(h->v2) - sizeof(h->v2.xmh_magic), 1, md_fp) != 1)
 		fatal("error reading from metadump file\n");
 
-	if (h->v2.xmh_incompat_flags != 0)
+	if (h->v2.xmh_incompat_flags & cpu_to_be32(~XFS_MD2_INCOMPAT_ALL))
 		fatal("Metadump header has unknown incompat flags set\n");
 
 	if (h->v2.xmh_reserved != 0)
@@ -324,6 +324,9 @@ read_header_v2(
 
 	if (!mdrestore.external_log && (compat & XFS_MD2_COMPAT_EXTERNALLOG))
 		fatal("External Log device is required\n");
+
+	if (h->v2.xmh_incompat_flags & cpu_to_be32(XFS_MD2_INCOMPAT_RTDEVICE))
+		fatal("Realtime device not yet supported\n");
 }
 
 static void


