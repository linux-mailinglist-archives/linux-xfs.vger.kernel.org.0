Return-Path: <linux-xfs+bounces-13849-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FBE2999873
	for <lists+linux-xfs@lfdr.de>; Fri, 11 Oct 2024 02:55:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 77591B22018
	for <lists+linux-xfs@lfdr.de>; Fri, 11 Oct 2024 00:55:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 887F7FC0A;
	Fri, 11 Oct 2024 00:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WM+ZfHeT"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48DE2FBF0
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728608095; cv=none; b=GBNXOpdl6legbjeDCbhF6MNCgMAgzFdDnU6epfUVCywGYjcvuoPdOSD8GzTr98xjFbUEOQztIZgl90ybUidr09ua9LzviCZMG08HpKjU1o2CiMun/s40SGWXdj5HfKQ+ysL1zu+a/kDZOVIr1PpPd1lNEFv+LjIqQQ8DYEF1EBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728608095; c=relaxed/simple;
	bh=CU+6q1KgycnUmLnbg4L+UJrBntj+Up4MEZZD9TeneIg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EX6Qi6dKRUOio2AIeMIN4fn2xdtDKiOfk64lssr0/sWBBX0PlJNX8/tmdV4uEv+UNRxBwjyFCElyM7+D/qgT1SeLQJqIYqxxvgKr9TZILu+FcDNGiAO2SHjQonHCTtbHl2SCb3DY8rAYgSApcWizGJZOTFCZEROVun9q/Jxd+jY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WM+ZfHeT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5875C4CEC5;
	Fri, 11 Oct 2024 00:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728608094;
	bh=CU+6q1KgycnUmLnbg4L+UJrBntj+Up4MEZZD9TeneIg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WM+ZfHeTWr+j3dpxNS9RbhpVTCsbETxctKqplWIWbTl0uSbdKtBJH0YIVBYg0TdNC
	 wYNFcAIA/dXAzER+8u7Y6epr34SPEJ63OzWS4UEGgAN+70MGDFI1AYw5IbN3O3I5AZ
	 KAn1faVWyyXKACcYYp8997T+zMzp8jRkaeIROKwiIxGsXXW5+1M3FzxZVJjjeBcW8L
	 ChRF5Ul3lrt7+AYx9ADQcfsfnp4u6MZ+yykFK6UTUEzVJXtrMmYPN2h/SbUwIH1i5q
	 zxKIV2rj7T2R83rdb+bvLqHls8FwSOZRXRn1DfqSDNjcPSKd2dKlhtI6PLxrOTAcVx
	 Prv9wuhb434nQ==
Date: Thu, 10 Oct 2024 17:54:54 -0700
Subject: [PATCH 25/28] xfs: move repair temporary files to the metadata
 directory tree
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860642447.4176876.9452602607836516803.stgit@frogsfrogsfrogs>
In-Reply-To: <172860641935.4176876.5699259080908526243.stgit@frogsfrogsfrogs>
References: <172860641935.4176876.5699259080908526243.stgit@frogsfrogsfrogs>
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

Due to resource acquisition rules, we have to create the ondisk
temporary files used to stage a filesystem repair before we can acquire
a reference to the inode that we actually want to repair.  Therefore,
we do not know at tempfile creation time whether the tempfile will
belong to the regular directory tree or the metadata directory tree.

This distinction becomes important when the swapext code tries to figure
out the quota accounting of the two files whose mappings are being
swapped.  The swapext code assumes that accounting updates are required
for a file if dqattach attaches dquots.  Metadir files are never
accounted in quota, which means that swapext must not update the quota
accounting when swapping in a repaired directory/xattr/rtbitmap structure.

Prior to the swapext call, therefore, both files must be marked as
METADIR for dqattach so that dqattach will ignore them.  Add support for
a repair tempfile to be switched to the metadir tree and switched back
before being released so that ifree will just free the file.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/common.c   |    5 ++
 fs/xfs/scrub/tempfile.c |   97 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/tempfile.h |    3 +
 3 files changed, 105 insertions(+)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 671aca616f11ea..2bedc053400a83 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -39,6 +39,7 @@
 #include "scrub/trace.h"
 #include "scrub/repair.h"
 #include "scrub/health.h"
+#include "scrub/tempfile.h"
 
 /* Common code for the metadata scrubbers. */
 
@@ -1090,6 +1091,10 @@ xchk_setup_inode_contents(
 	if (error)
 		return error;
 
+	error = xrep_tempfile_adjust_directory_tree(sc);
+	if (error)
+		return error;
+
 	/* Lock the inode so the VFS cannot touch this file. */
 	xchk_ilock(sc, XFS_IOLOCK_EXCL);
 
diff --git a/fs/xfs/scrub/tempfile.c b/fs/xfs/scrub/tempfile.c
index 3c5a1d77fefae9..4b7f7860e37ece 100644
--- a/fs/xfs/scrub/tempfile.c
+++ b/fs/xfs/scrub/tempfile.c
@@ -22,6 +22,7 @@
 #include "xfs_exchmaps.h"
 #include "xfs_defer.h"
 #include "xfs_symlink_remote.h"
+#include "xfs_metafile.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/repair.h"
@@ -182,6 +183,101 @@ xrep_tempfile_create(
 	return error;
 }
 
+/*
+ * Temporary files have to be created before we even know which inode we're
+ * going to scrub, so we assume that they will be part of the regular directory
+ * tree.  If it turns out that we're actually scrubbing a file from the
+ * metadata directory tree, we have to subtract the temp file from the root
+ * dquots and detach the dquots.
+ */
+int
+xrep_tempfile_adjust_directory_tree(
+	struct xfs_scrub	*sc)
+{
+	int			error;
+
+	if (!sc->tempip)
+		return 0;
+
+	ASSERT(sc->tp == NULL);
+	ASSERT(!xfs_is_metadir_inode(sc->tempip));
+
+	if (!sc->ip || !xfs_is_metadir_inode(sc->ip))
+		return 0;
+
+	xfs_ilock(sc->tempip, XFS_IOLOCK_EXCL);
+	sc->temp_ilock_flags |= XFS_IOLOCK_EXCL;
+
+	error = xchk_trans_alloc(sc, 0);
+	if (error)
+		goto out_iolock;
+
+	xrep_tempfile_ilock(sc);
+	xfs_trans_ijoin(sc->tp, sc->tempip, 0);
+
+	/* Metadir files are not accounted in quota, so drop icount */
+	xfs_trans_mod_dquot_byino(sc->tp, sc->tempip, XFS_TRANS_DQ_ICOUNT, -1L);
+	xfs_metafile_set_iflag(sc->tp, sc->tempip, XFS_METAFILE_UNKNOWN);
+
+	error = xrep_trans_commit(sc);
+	if (error)
+		goto out_ilock;
+
+	xfs_qm_dqdetach(sc->tempip);
+out_ilock:
+	xrep_tempfile_iunlock(sc);
+out_iolock:
+	xrep_tempfile_iounlock(sc);
+	return error;
+}
+
+/*
+ * Remove this temporary file from the metadata directory tree so that it can
+ * be inactivated the normal way.
+ */
+STATIC int
+xrep_tempfile_remove_metadir(
+	struct xfs_scrub	*sc)
+{
+	int			error;
+
+	if (!sc->tempip || !xfs_is_metadir_inode(sc->tempip))
+		return 0;
+
+	ASSERT(sc->tp == NULL);
+
+	xfs_ilock(sc->tempip, XFS_IOLOCK_EXCL);
+	sc->temp_ilock_flags |= XFS_IOLOCK_EXCL;
+
+	error = xchk_trans_alloc(sc, 0);
+	if (error)
+		goto out_iolock;
+
+	xrep_tempfile_ilock(sc);
+	xfs_trans_ijoin(sc->tp, sc->tempip, 0);
+
+	xfs_metafile_clear_iflag(sc->tp, sc->tempip);
+
+	/* Non-metadir files are accounted in quota, so bump bcount/icount */
+	error = xfs_qm_dqattach_locked(sc->tempip, false);
+	if (error)
+		goto out_cancel;
+
+	xfs_trans_mod_dquot_byino(sc->tp, sc->tempip, XFS_TRANS_DQ_ICOUNT, 1L);
+	xfs_trans_mod_dquot_byino(sc->tp, sc->tempip, XFS_TRANS_DQ_BCOUNT,
+			sc->tempip->i_nblocks);
+	error = xrep_trans_commit(sc);
+	goto out_ilock;
+
+out_cancel:
+	xchk_trans_cancel(sc);
+out_ilock:
+	xrep_tempfile_iunlock(sc);
+out_iolock:
+	xrep_tempfile_iounlock(sc);
+	return error;
+}
+
 /* Take IOLOCK_EXCL on the temporary file, maybe. */
 bool
 xrep_tempfile_iolock_nowait(
@@ -290,6 +386,7 @@ xrep_tempfile_rele(
 		sc->temp_ilock_flags = 0;
 	}
 
+	xrep_tempfile_remove_metadir(sc);
 	xchk_irele(sc, sc->tempip);
 	sc->tempip = NULL;
 }
diff --git a/fs/xfs/scrub/tempfile.h b/fs/xfs/scrub/tempfile.h
index e51399f595fe9a..71c1b54599c306 100644
--- a/fs/xfs/scrub/tempfile.h
+++ b/fs/xfs/scrub/tempfile.h
@@ -10,6 +10,8 @@
 int xrep_tempfile_create(struct xfs_scrub *sc, uint16_t mode);
 void xrep_tempfile_rele(struct xfs_scrub *sc);
 
+int xrep_tempfile_adjust_directory_tree(struct xfs_scrub *sc);
+
 bool xrep_tempfile_iolock_nowait(struct xfs_scrub *sc);
 int xrep_tempfile_iolock_polled(struct xfs_scrub *sc);
 void xrep_tempfile_iounlock(struct xfs_scrub *sc);
@@ -42,6 +44,7 @@ static inline void xrep_tempfile_iolock_both(struct xfs_scrub *sc)
 	xchk_ilock(sc, XFS_IOLOCK_EXCL);
 }
 # define xrep_is_tempfile(ip)		(false)
+# define xrep_tempfile_adjust_directory_tree(sc)	(0)
 # define xrep_tempfile_rele(sc)
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 


