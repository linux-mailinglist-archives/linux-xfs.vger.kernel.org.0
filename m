Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1947438DE90
	for <lists+linux-xfs@lfdr.de>; Mon, 24 May 2021 03:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232107AbhEXBCs (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 23 May 2021 21:02:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:42556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232050AbhEXBCr (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 23 May 2021 21:02:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5E746117A;
        Mon, 24 May 2021 01:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621818080;
        bh=ILtuqoRfvWpKTwKOzFAFw86KU90pybbHKrMvgmkVN1Y=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=oNU46ucV3K+FM73z06UbTGsiuR38NSByoEwiRrbsEkc9fkh0ijsnjUPpE9X6s4ypb
         711B5v1ck70FzhuNbOuhWgxuPkDOrn0PXQJeukou2CSGBgUvzF2l0xBACxgPN4fuHL
         9M0Oiq4CvlNyN3lOSX4S6Gl51mOB7R7i4MjDKWi4LMi7rbKIJ1fgMN9YetIb9dc6OM
         k6YF6cjbAKsl5EBtx/yMo1RhNrUvZdO0CY11fF4E01YiR6tFYyktzV7tFUpDZYfxf7
         Z68sys4Dhe3cfEtlF1RHOuGJNMEL+avToLPDh5iih0g0BeHcduqCml8Wk9Uk2CeXKi
         XRR/ZHmbafSZQ==
Subject: [PATCH 1/2] xfs: standardize extent size hint validation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org, bfoster@redhat.com, hch@infradead.org
Date:   Sun, 23 May 2021 18:01:20 -0700
Message-ID: <162181808035.202929.13906951692345898706.stgit@locust>
In-Reply-To: <162181807472.202929.18194381144862527586.stgit@locust>
References: <162181807472.202929.18194381144862527586.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

While chasing a bug involving invalid extent size hints being propagated
into newly created realtime files, I noticed that the xfs_ioctl_setattr
checks for the extent size hints weren't the same as the ones now
encoded in libxfs and used for validation in repair and mkfs.

Because the checks in libxfs are more stringent than the ones in the
ioctl, it's possible for a live system to set inode flags that
immediately result in corruption warnings.  Specifically, it's possible
to set an extent size hint on an rtinherit directory without checking if
the hint is aligned to the realtime extent size, which makes no sense
since that combination is used only to seed new realtime files.

Replace the open-coded and inadequate checks with the libxfs verifier
versions and update the code comments a bit.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_inode_buf.c |   24 +++++++++--
 fs/xfs/xfs_ioctl.c            |   90 ++++++++++-------------------------------
 2 files changed, 41 insertions(+), 73 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 5c9a7440d9e4..045118c7bf78 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -559,8 +559,17 @@ xfs_dinode_calc_crc(
 /*
  * Validate di_extsize hint.
  *
- * The rules are documented at xfs_ioctl_setattr_check_extsize().
- * These functions must be kept in sync with each other.
+ * 1. Extent size hint is only valid for directories and regular files.
+ * 2. FS_XFLAG_EXTSIZE is only valid for regular files.
+ * 3. FS_XFLAG_EXTSZINHERIT is only valid for directories.
+ * 4. Hint cannot be larger than MAXTEXTLEN.
+ * 5. Can be changed on directories at any time.
+ * 6. Hint value of 0 turns off hints, clears inode flags.
+ * 7. Extent size must be a multiple of the appropriate block size.
+ *    For realtime files, this is the rt extent size.
+ * 8. For non-realtime files, the extent size hint must be limited
+ *    to half the AG size to avoid alignment extending the extent beyond the
+ *    limits of the AG.
  */
 xfs_failaddr_t
 xfs_inode_validate_extsize(
@@ -616,8 +625,15 @@ xfs_inode_validate_extsize(
 /*
  * Validate di_cowextsize hint.
  *
- * The rules are documented at xfs_ioctl_setattr_check_cowextsize().
- * These functions must be kept in sync with each other.
+ * 1. CoW extent size hint can only be set if reflink is enabled on the fs.
+ *    The inode does not have to have any shared blocks, but it must be a v3.
+ * 2. FS_XFLAG_COWEXTSIZE is only valid for directories and regular files;
+ *    for a directory, the hint is propagated to new files.
+ * 3. Can be changed on files & directories at any time.
+ * 4. Hint value of 0 turns off hints, clears inode flags.
+ * 5. Extent size must be a multiple of the appropriate block size.
+ * 6. The extent size hint must be limited to half the AG size to avoid
+ *    alignment extending the extent beyond the limits of the AG.
  */
 xfs_failaddr_t
 xfs_inode_validate_cowextsize(
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 3925bfcb2365..6407921aca96 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1267,20 +1267,8 @@ xfs_ioctl_setattr_get_trans(
 }
 
 /*
- * extent size hint validation is somewhat cumbersome. Rules are:
- *
- * 1. extent size hint is only valid for directories and regular files
- * 2. FS_XFLAG_EXTSIZE is only valid for regular files
- * 3. FS_XFLAG_EXTSZINHERIT is only valid for directories.
- * 4. can only be changed on regular files if no extents are allocated
- * 5. can be changed on directories at any time
- * 6. extsize hint of 0 turns off hints, clears inode flags.
- * 7. Extent size must be a multiple of the appropriate block size.
- * 8. for non-realtime files, the extent size hint must be limited
- *    to half the AG size to avoid alignment extending the extent beyond the
- *    limits of the AG.
- *
- * Please keep this function in sync with xfs_scrub_inode_extsize.
+ * Validate a proposed extent size hint.  For regular files, the hint can only
+ * be changed if no extents are allocated.
  */
 static int
 xfs_ioctl_setattr_check_extsize(
@@ -1288,86 +1276,50 @@ xfs_ioctl_setattr_check_extsize(
 	struct fileattr		*fa)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	xfs_extlen_t		size;
-	xfs_fsblock_t		extsize_fsb;
+	xfs_failaddr_t		failaddr;
+	uint16_t		new_diflags;
 
 	if (!fa->fsx_valid)
 		return 0;
 
 	if (S_ISREG(VFS_I(ip)->i_mode) && ip->i_df.if_nextents &&
-	    ((ip->i_extsize << mp->m_sb.sb_blocklog) != fa->fsx_extsize))
+	    XFS_FSB_TO_B(mp, ip->i_extsize) != fa->fsx_extsize)
 		return -EINVAL;
 
-	if (fa->fsx_extsize == 0)
-		return 0;
-
-	extsize_fsb = XFS_B_TO_FSB(mp, fa->fsx_extsize);
-	if (extsize_fsb > MAXEXTLEN)
+	if (fa->fsx_extsize & mp->m_blockmask)
 		return -EINVAL;
 
-	if (XFS_IS_REALTIME_INODE(ip) ||
-	    (fa->fsx_xflags & FS_XFLAG_REALTIME)) {
-		size = mp->m_sb.sb_rextsize << mp->m_sb.sb_blocklog;
-	} else {
-		size = mp->m_sb.sb_blocksize;
-		if (extsize_fsb > mp->m_sb.sb_agblocks / 2)
-			return -EINVAL;
-	}
-
-	if (fa->fsx_extsize % size)
-		return -EINVAL;
+	new_diflags = xfs_flags2diflags(ip, fa->fsx_xflags);
 
-	return 0;
+	failaddr = xfs_inode_validate_extsize(ip->i_mount,
+			XFS_B_TO_FSB(mp, fa->fsx_extsize),
+			VFS_I(ip)->i_mode, new_diflags);
+	return failaddr != NULL ? -EINVAL : 0;
 }
 
-/*
- * CoW extent size hint validation rules are:
- *
- * 1. CoW extent size hint can only be set if reflink is enabled on the fs.
- *    The inode does not have to have any shared blocks, but it must be a v3.
- * 2. FS_XFLAG_COWEXTSIZE is only valid for directories and regular files;
- *    for a directory, the hint is propagated to new files.
- * 3. Can be changed on files & directories at any time.
- * 4. CoW extsize hint of 0 turns off hints, clears inode flags.
- * 5. Extent size must be a multiple of the appropriate block size.
- * 6. The extent size hint must be limited to half the AG size to avoid
- *    alignment extending the extent beyond the limits of the AG.
- *
- * Please keep this function in sync with xfs_scrub_inode_cowextsize.
- */
 static int
 xfs_ioctl_setattr_check_cowextsize(
 	struct xfs_inode	*ip,
 	struct fileattr		*fa)
 {
 	struct xfs_mount	*mp = ip->i_mount;
-	xfs_extlen_t		size;
-	xfs_fsblock_t		cowextsize_fsb;
+	xfs_failaddr_t		failaddr;
+	uint64_t		new_diflags2;
+	uint16_t		new_diflags;
 
 	if (!fa->fsx_valid)
 		return 0;
 
-	if (!(fa->fsx_xflags & FS_XFLAG_COWEXTSIZE))
-		return 0;
-
-	if (!xfs_sb_version_hasreflink(&ip->i_mount->m_sb))
-		return -EINVAL;
-
-	if (fa->fsx_cowextsize == 0)
-		return 0;
-
-	cowextsize_fsb = XFS_B_TO_FSB(mp, fa->fsx_cowextsize);
-	if (cowextsize_fsb > MAXEXTLEN)
+	if (fa->fsx_cowextsize & mp->m_blockmask)
 		return -EINVAL;
 
-	size = mp->m_sb.sb_blocksize;
-	if (cowextsize_fsb > mp->m_sb.sb_agblocks / 2)
-		return -EINVAL;
-
-	if (fa->fsx_cowextsize % size)
-		return -EINVAL;
+	new_diflags = xfs_flags2diflags(ip, fa->fsx_xflags);
+	new_diflags2 = xfs_flags2diflags2(ip, fa->fsx_xflags);
 
-	return 0;
+	failaddr = xfs_inode_validate_cowextsize(ip->i_mount,
+			XFS_B_TO_FSB(mp, fa->fsx_cowextsize),
+			VFS_I(ip)->i_mode, new_diflags, new_diflags2);
+	return failaddr != NULL ? -EINVAL : 0;
 }
 
 static int

