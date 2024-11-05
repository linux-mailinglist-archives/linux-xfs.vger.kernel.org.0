Return-Path: <linux-xfs+bounces-15106-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A0FED9BD8B5
	for <lists+linux-xfs@lfdr.de>; Tue,  5 Nov 2024 23:30:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E9C22284699
	for <lists+linux-xfs@lfdr.de>; Tue,  5 Nov 2024 22:30:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8299F1D14EF;
	Tue,  5 Nov 2024 22:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RwrnTY+/"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4162718E023
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730845826; cv=none; b=C5eVvXfOf2kSKlmTRLnV3IkDUqWqYjabRrfE7yH/NlX6dMeflpt4/AC7xVEEyQiIcbd9sRa7UYbqqk/0g4SSWbAQUzS0CXvmsTFnp5ZTyaVtm8gTsXEB9uAMSkG8ZIWoqmzFo1gOQBU+qkce2KXDWbZRILgCKlWX4yahosF3eK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730845826; c=relaxed/simple;
	bh=JQiqBA1JcY8CEaSKVTCEXZPlsYllbI/XDRDGysOgoGg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qf0g50xd2w3IKmGn+tjRfeSyonb9dD4IIiHNayLCsl1+jqwgCmmzsencW+Hb0L7PZxfCTTSvn9O8UamtW6A/Kafb+inwsC35MZpuSeh5k5kviC0EFeOHMj1TvE4bn6mDAPqSfWgberYl0edrzkz5Y4pl5DirDniM45F718cgLzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RwrnTY+/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12548C4CECF;
	Tue,  5 Nov 2024 22:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730845826;
	bh=JQiqBA1JcY8CEaSKVTCEXZPlsYllbI/XDRDGysOgoGg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RwrnTY+/wlH9tCE5hlmXNBC5BCx8uqFOzNXZQ81SGDAMS4+WFOPXJX45yGG0TQK12
	 R6STF96eE9SOTWddqklX0tkW4svl24wm1BDNjS8YBHwRM/4tLeiZMSMNeomQnZvj/d
	 p1ilimhKJUoZpLw0jw7h7eAwRqqOGN0FIYDKquaBvmwYVx4r3hdQ4lzHAMm9ieO+V8
	 tkPiqEQYsCGQK0/wS4kloW6tPE6BCJWT8V0MuryiGE1hYehaxvcDAOAdhlC5BgKvvC
	 wmzWKbYaCwEmtZmscg3D441sY/hjWDhUMmDQ9IhgGzxUDttuWa/0x4GIwPa3idnpJZ
	 hkMh9bGNgXjLQ==
Date: Tue, 05 Nov 2024 14:30:25 -0800
Subject: [PATCH 02/34] xfs: check the realtime superblock at mount time
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084398219.1871887.2230657953768654047.stgit@frogsfrogsfrogs>
In-Reply-To: <173084398097.1871887.5832278892963229059.stgit@frogsfrogsfrogs>
References: <173084398097.1871887.5832278892963229059.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Check the realtime superblock at mount time, to ensure that the label
and uuids actually match the primary superblock on the data device.  If
the rt superblock is good, attach it to the xfs_mount so that the log
can use ordered buffers to keep this primary in sync with the primary
super on the data device.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_mount.h   |    1 +
 fs/xfs/xfs_rtalloc.c |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_rtalloc.h |    6 ++++++
 fs/xfs/xfs_super.c   |   12 ++++++++++--
 4 files changed, 67 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index c8ac858dc95bc5..33fb03547c88ac 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -119,6 +119,7 @@ typedef struct xfs_mount {
 	struct super_block	*m_super;
 	struct xfs_ail		*m_ail;		/* fs active log item list */
 	struct xfs_buf		*m_sb_bp;	/* buffer for superblock */
+	struct xfs_buf		*m_rtsb_bp;	/* realtime superblock */
 	char			*m_rtname;	/* realtime device name */
 	char			*m_logname;	/* external log device name */
 	struct xfs_da_geometry	*m_dir_geo;	/* directory block geometry */
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index b4687a8759b171..abeedc848b3bd2 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1152,6 +1152,56 @@ xfs_growfs_rt(
 	return error;
 }
 
+/* Read the realtime superblock and attach it to the mount. */
+int
+xfs_rtmount_readsb(
+	struct xfs_mount	*mp)
+{
+	struct xfs_buf		*bp;
+	int			error;
+
+	if (!xfs_has_rtsb(mp))
+		return 0;
+	if (mp->m_sb.sb_rblocks == 0)
+		return 0;
+	if (mp->m_rtdev_targp == NULL) {
+		xfs_warn(mp,
+	"Filesystem has a realtime volume, use rtdev=device option");
+		return -ENODEV;
+	}
+
+	/* m_blkbb_log is not set up yet */
+	error = xfs_buf_read_uncached(mp->m_rtdev_targp, XFS_RTSB_DADDR,
+			mp->m_sb.sb_blocksize >> BBSHIFT, XBF_NO_IOACCT, &bp,
+			&xfs_rtsb_buf_ops);
+	if (error) {
+		xfs_warn(mp, "rt sb validate failed with error %d.", error);
+		/* bad CRC means corrupted metadata */
+		if (error == -EFSBADCRC)
+			error = -EFSCORRUPTED;
+		return error;
+	}
+
+	mp->m_rtsb_bp = bp;
+	xfs_buf_unlock(bp);
+	return 0;
+}
+
+/* Detach the realtime superblock from the mount and free it. */
+void
+xfs_rtmount_freesb(
+	struct xfs_mount	*mp)
+{
+	struct xfs_buf		*bp = mp->m_rtsb_bp;
+
+	if (!bp)
+		return;
+
+	xfs_buf_lock(bp);
+	mp->m_rtsb_bp = NULL;
+	xfs_buf_relse(bp);
+}
+
 /*
  * Initialize realtime fields in the mount structure.
  */
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index a6836da9bebef5..8e2a07b8174b74 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -12,6 +12,10 @@ struct xfs_mount;
 struct xfs_trans;
 
 #ifdef CONFIG_XFS_RT
+/* rtgroup superblock initialization */
+int xfs_rtmount_readsb(struct xfs_mount *mp);
+void xfs_rtmount_freesb(struct xfs_mount *mp);
+
 /*
  * Initialize realtime fields in the mount structure.
  */
@@ -42,6 +46,8 @@ int xfs_rtalloc_reinit_frextents(struct xfs_mount *mp);
 #else
 # define xfs_growfs_rt(mp,in)				(-ENOSYS)
 # define xfs_rtalloc_reinit_frextents(m)		(0)
+# define xfs_rtmount_readsb(mp)				(0)
+# define xfs_rtmount_freesb(mp)				((void)0)
 static inline int		/* error */
 xfs_rtmount_init(
 	xfs_mount_t	*mp)	/* file system mount structure */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 9ae352dfdd6c57..3afeab6844680a 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -45,6 +45,7 @@
 #include "xfs_rtbitmap.h"
 #include "xfs_exchmaps_item.h"
 #include "xfs_parent.h"
+#include "xfs_rtalloc.h"
 #include "scrub/stats.h"
 #include "scrub/rcbag_btree.h"
 
@@ -1145,6 +1146,7 @@ xfs_fs_put_super(
 	xfs_filestream_unmount(mp);
 	xfs_unmountfs(mp);
 
+	xfs_rtmount_freesb(mp);
 	xfs_freesb(mp);
 	xchk_mount_stats_free(mp);
 	free_percpu(mp->m_stats.xs_stats);
@@ -1690,9 +1692,13 @@ xfs_fs_fill_super(
 		goto out_free_sb;
 	}
 
+	error = xfs_rtmount_readsb(mp);
+	if (error)
+		goto out_free_sb;
+
 	error = xfs_filestream_mount(mp);
 	if (error)
-		goto out_free_sb;
+		goto out_free_rtsb;
 
 	/*
 	 * we must configure the block size in the superblock before we run the
@@ -1781,6 +1787,8 @@ xfs_fs_fill_super(
 
  out_filestream_unmount:
 	xfs_filestream_unmount(mp);
+ out_free_rtsb:
+	xfs_rtmount_freesb(mp);
  out_free_sb:
 	xfs_freesb(mp);
  out_free_scrub_stats:
@@ -1800,7 +1808,7 @@ xfs_fs_fill_super(
  out_unmount:
 	xfs_filestream_unmount(mp);
 	xfs_unmountfs(mp);
-	goto out_free_sb;
+	goto out_free_rtsb;
 }
 
 static int


