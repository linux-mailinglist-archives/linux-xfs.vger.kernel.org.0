Return-Path: <linux-xfs+bounces-2046-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B9D8821140
	for <lists+linux-xfs@lfdr.de>; Mon,  1 Jan 2024 00:37:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A2C9A1C21C22
	for <lists+linux-xfs@lfdr.de>; Sun, 31 Dec 2023 23:37:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62648C2DA;
	Sun, 31 Dec 2023 23:37:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZPGKfG0A"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6C7C2CC
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:37:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0B8EC433C7;
	Sun, 31 Dec 2023 23:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065845;
	bh=ZJLA3wGzvbr5Kx1tGYi37vRiY6nQCe6HUeLQHWadUWA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZPGKfG0Axxlcj7RW1WD+p9FgfbfkacwtPun3FHHfwhb0CI5rrXI6XPex12w454HTm
	 GuqV8yNiAYM2MEJoZ4+ZFTpyfUOOUPIJ54HPNUo+SvXIj8JQQSyu97nFrnDuBeEzHw
	 dQqkkbtaFg1C6bLzHrb++Me31xfDJ8PsOSBB34KifXPmLliVT3poHrgU9I+vDygLYK
	 2VWnYvM1/XhqX4Vn5KotZcIQKCnl3AZ6vn+1KBE1H5PXFzpisVw3zlVzmIyuSY9Xkj
	 lDU/cWA8mvIWF2CwBDB67+LWUkxA0jr7b6BUgMIswlazSqixTyxy9a1jLHZ+DnudFc
	 a7G9S95WZ2mZw==
Date: Sun, 31 Dec 2023 15:37:24 -0800
Subject: [PATCH 30/58] xfs_db: mask superblock fields when metadir feature is
 enabled
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405010347.1809361.15324047232203894359.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
References: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
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

When the metadata directory feature is enabled, mask the superblock
fields (rt, quota inodes) that got migrated to the directory tree.
Similarly, hide the 'metadirino' field when the feature is disabled.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/sb.c |   41 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 36 insertions(+), 5 deletions(-)


diff --git a/db/sb.c b/db/sb.c
index 002736b02b7..2ad032cc81a 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -50,6 +50,30 @@ sb_init(void)
 	add_command(&version_cmd);
 }
 
+/*
+ * Counts superblock fields that only exist when the metadata directory feature
+ * is enabled.
+ */
+static int
+metadirino_count(
+	void		*obj,
+	int		startoff)
+{
+	return xfs_has_metadir(mp) ? 1 : 0;
+}
+
+/*
+ * Counts superblock fields that only existed before the metadata directory
+ * feature came along.
+ */
+static int
+rootino_count(
+	void		*obj,
+	int		startoff)
+{
+	return xfs_has_metadir(mp) ? 0 : 1;
+}
+
 #define	OFF(f)	bitize(offsetof(struct xfs_dsb, sb_ ## f))
 #define	SZC(f)	szcount(struct xfs_dsb, sb_ ## f)
 const field_t	sb_flds[] = {
@@ -61,8 +85,12 @@ const field_t	sb_flds[] = {
 	{ "uuid", FLDT_UUID, OI(OFF(uuid)), C1, 0, TYP_NONE },
 	{ "logstart", FLDT_DFSBNO, OI(OFF(logstart)), C1, 0, TYP_LOG },
 	{ "rootino", FLDT_INO, OI(OFF(rootino)), C1, 0, TYP_INODE },
-	{ "rbmino", FLDT_INO, OI(OFF(rbmino)), C1, 0, TYP_INODE },
-	{ "rsumino", FLDT_INO, OI(OFF(rsumino)), C1, 0, TYP_INODE },
+	{ "metadirino", FLDT_INO, OI(OFF(rbmino)), metadirino_count,
+	  FLD_COUNT, TYP_INODE },
+	{ "rbmino", FLDT_INO, OI(OFF(rbmino)), rootino_count, FLD_COUNT,
+	  TYP_INODE },
+	{ "rsumino", FLDT_INO, OI(OFF(rsumino)), rootino_count, FLD_COUNT,
+	  TYP_INODE },
 	{ "rextsize", FLDT_AGBLOCK, OI(OFF(rextsize)), C1, 0, TYP_NONE },
 	{ "agblocks", FLDT_AGBLOCK, OI(OFF(agblocks)), C1, 0, TYP_NONE },
 	{ "agcount", FLDT_AGNUMBER, OI(OFF(agcount)), C1, 0, TYP_NONE },
@@ -85,8 +113,10 @@ const field_t	sb_flds[] = {
 	{ "ifree", FLDT_UINT64D, OI(OFF(ifree)), C1, 0, TYP_NONE },
 	{ "fdblocks", FLDT_UINT64D, OI(OFF(fdblocks)), C1, 0, TYP_NONE },
 	{ "frextents", FLDT_UINT64D, OI(OFF(frextents)), C1, 0, TYP_NONE },
-	{ "uquotino", FLDT_INO, OI(OFF(uquotino)), C1, 0, TYP_INODE },
-	{ "gquotino", FLDT_INO, OI(OFF(gquotino)), C1, 0, TYP_INODE },
+	{ "uquotino", FLDT_INO, OI(OFF(uquotino)), rootino_count, FLD_COUNT,
+	  TYP_INODE },
+	{ "gquotino", FLDT_INO, OI(OFF(gquotino)), rootino_count, FLD_COUNT,
+	  TYP_INODE },
 	{ "qflags", FLDT_UINT16X, OI(OFF(qflags)), C1, 0, TYP_NONE },
 	{ "flags", FLDT_UINT8X, OI(OFF(flags)), C1, 0, TYP_NONE },
 	{ "shared_vn", FLDT_UINT8D, OI(OFF(shared_vn)), C1, 0, TYP_NONE },
@@ -110,7 +140,8 @@ const field_t	sb_flds[] = {
 		C1, 0, TYP_NONE },
 	{ "crc", FLDT_CRC, OI(OFF(crc)), C1, 0, TYP_NONE },
 	{ "spino_align", FLDT_EXTLEN, OI(OFF(spino_align)), C1, 0, TYP_NONE },
-	{ "pquotino", FLDT_INO, OI(OFF(pquotino)), C1, 0, TYP_INODE },
+	{ "pquotino", FLDT_INO, OI(OFF(pquotino)), rootino_count, FLD_COUNT,
+	  TYP_INODE },
 	{ "lsn", FLDT_UINT64X, OI(OFF(lsn)), C1, 0, TYP_NONE },
 	{ "meta_uuid", FLDT_UUID, OI(OFF(meta_uuid)), C1, 0, TYP_NONE },
 	{ NULL }


