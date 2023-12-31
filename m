Return-Path: <linux-xfs+bounces-1647-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9327E820F21
	for <lists+linux-xfs@lfdr.de>; Sun, 31 Dec 2023 22:53:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4FB6C2826E8
	for <lists+linux-xfs@lfdr.de>; Sun, 31 Dec 2023 21:53:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6A10D51E;
	Sun, 31 Dec 2023 21:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tgu0rBBn"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32CDD50B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:53:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CF85C433C8;
	Sun, 31 Dec 2023 21:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059606;
	bh=RV5c9mQ5dHXqZREnqNyLxaVqTzzPPNx433+lW8OGg7U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Tgu0rBBng1eyH+2d+SxDSteKhSpGznnJ1OzCbkLgx7xKGQI3L2be+JLUsmeT+NiH5
	 61I2hEzmhJwOyHoL9h4m0pEEbytRdL91+U0/AGcqyEtX1sM//X+W4PSnAaA4N8N5PB
	 uAHDFGgWPIaKbVGJaHLp0MUtzD70aspdk+FJ0lHokMtxBkgVSSNDvbP3w1o1WOPrqX
	 6ecj1EwLcRX1PYimSJ6619cf2QRqmK5MvYNOCkEoSo7vwTwZPTZSKvW8NOFk/nq78k
	 wR8dVOl6rcHCnbNmVDQsu2dmsuRzP008bcFmEXW5bB5j7Rar6CEyur7kp/21VJRVg/
	 CNc/wi03w+c1g==
Date: Sun, 31 Dec 2023 13:53:26 -0800
Subject: [PATCH 34/44] xfs: detect and repair misaligned rtinherit directory
 cowextsize hints
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404852128.1766284.6785654642024257461.stgit@frogsfrogsfrogs>
In-Reply-To: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
References: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
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

If we encounter a directory that has been configured to pass on a CoW
extent size hint to a new realtime file and the hint isn't an integer
multiple of the rt extent size, we should flag the hint for
administrative review and/or turn it off because that is a
misconfiguration.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/inode.c        |   26 +++++++++++++++++---------
 fs/xfs/scrub/inode_repair.c |   15 +++++++++++++++
 2 files changed, 32 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index f746032a9db88..e52e12e9a1b4b 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -259,12 +259,7 @@ xchk_inode_extsize(
 		xchk_ino_set_warning(sc, ino);
 }
 
-/*
- * Validate di_cowextsize hint.
- *
- * The rules are documented at xfs_ioctl_setattr_check_cowextsize().
- * These functions must be kept in sync with each other.
- */
+/* Validate di_cowextsize hint. */
 STATIC void
 xchk_inode_cowextsize(
 	struct xfs_scrub	*sc,
@@ -275,12 +270,25 @@ xchk_inode_cowextsize(
 	uint64_t		flags2)
 {
 	xfs_failaddr_t		fa;
+	uint32_t		value = be32_to_cpu(dip->di_cowextsize);
 
-	fa = xfs_inode_validate_cowextsize(sc->mp,
-			be32_to_cpu(dip->di_cowextsize), mode, flags,
-			flags2);
+	fa = xfs_inode_validate_cowextsize(sc->mp, value, mode, flags, flags2);
 	if (fa)
 		xchk_ino_set_corrupt(sc, ino);
+
+	/*
+	 * XFS allows a sysadmin to change the rt extent size when adding a rt
+	 * section to a filesystem after formatting.  If there are any
+	 * directories with cowextsize and rtinherit set, the hint could become
+	 * misaligned with the new rextsize.  The verifier doesn't check this,
+	 * because we allow rtinherit directories even without an rt device.
+	 * Flag this as an administrative warning since we will clean this up
+	 * eventually.
+	 */
+	if ((flags & XFS_DIFLAG_RTINHERIT) &&
+	    (flags2 & XFS_DIFLAG2_COWEXTSIZE) &&
+	    value % sc->mp->m_sb.sb_rextsize > 0)
+		xchk_ino_set_warning(sc, ino);
 }
 
 /* Make sure the di_flags make sense for the inode. */
diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 8d67ae257e597..b6b37652c4a35 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -1836,6 +1836,20 @@ xrep_inode_pptr(
 			sizeof(struct xfs_attr_sf_hdr), true);
 }
 
+/* Fix COW extent size hint problems. */
+STATIC void
+xrep_inode_cowextsize(
+	struct xfs_scrub	*sc)
+{
+	/* Fix misaligned CoW extent size hints on a directory. */
+	if ((sc->ip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
+	    (sc->ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE) &&
+	    sc->ip->i_extsize % sc->mp->m_sb.sb_rextsize > 0) {
+		sc->ip->i_cowextsize = 0;
+		sc->ip->i_diflags2 &= ~XFS_DIFLAG2_COWEXTSIZE;
+	}
+}
+
 /* Fix any irregularities in an inode that the verifiers don't catch. */
 STATIC int
 xrep_inode_problems(
@@ -1859,6 +1873,7 @@ xrep_inode_problems(
 	if (S_ISDIR(VFS_I(sc->ip)->i_mode))
 		xrep_inode_dir_size(sc);
 	xrep_inode_extsize(sc);
+	xrep_inode_cowextsize(sc);
 
 	trace_xrep_inode_fixed(sc);
 	xfs_trans_log_inode(sc->tp, sc->ip, XFS_ILOG_CORE);


