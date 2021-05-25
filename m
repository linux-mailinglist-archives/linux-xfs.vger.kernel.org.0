Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4510C38FAB8
	for <lists+linux-xfs@lfdr.de>; Tue, 25 May 2021 08:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230387AbhEYGRB (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 May 2021 02:17:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:39352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230335AbhEYGRB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 May 2021 02:17:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C633F6140F;
        Tue, 25 May 2021 06:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621923331;
        bh=msgadYZaEEW/TY6GJRnfzIkOw+TMd+FXR/9rAFLp/pk=;
        h=Date:From:To:Subject:From;
        b=fVg2R9esg7PbeTuCZZWGOPk89xLejXOlRo9Ezvhfg3VsfAhDLbrck8c6nPJjg5Gib
         hum6FTKJs9aqOp86S0V8uoQTA450BW1zfO2WkcgEkIig3275y8FNz10u9sSR6486AC
         Z1xi7XADXi3LKgNPkgdQxHpiAB7Y5g++1vlfHGpW+USHQbhhDKRsbL7F9c7uWTe6mU
         PJgO1mLHQ5ilWo+J/tDPIuiKhqZKnEAQI+e+58pl/pJVDkm2cR0Dp3R3fJ4EVbY1HG
         /NOUu0+reYwFPrnJsI+ZzS67rYDCkSTPvUoy2O26xWDBDvh7OHFAYznZbh4jy5soPh
         YfgbYoks/y27A==
Date:   Mon, 24 May 2021 23:15:31 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     linux-xfs@vger.kernel.org, bfoster@redhat.com, hch@infradead.org
Subject: [PATCH v3] xfs: validate extsz hints against rt extent size when
 rtinherit is set
Message-ID: <20210525061531.GF202121@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The RTINHERIT bit can be set on a directory so that newly created
regular files will have the REALTIME bit set to store their data on the
realtime volume.  If an extent size hint (and EXTSZINHERIT) are set on
the directory, the hint will also be copied into the new file.

As pointed out in previous patches, for realtime files we require the
extent size hint be an integer multiple of the realtime extent, but we
don't perform the same validation on a directory with both RTINHERIT and
EXTSZINHERIT set, even though the only use-case of that combination is
to propagate extent size hints into new realtime files.  This leads to
inode corruption errors when the bad values are propagated.

Because there may be existing filesystems with such a configuration, we
cannot simply amend the inode verifier to trip on these directories and
call it a day because that will cause previously "working" filesystems
to start throwing errors abruptly.  Note that it's valid to have
directories with rtinherit set even if there is no realtime volume, in
which case the problem does not manifest because rtinherit is ignored if
there's no realtime device; and it's possible that someone set the flag,
crashed, repaired the filesystem (which clears the hint on the realtime
file) and continued.

Therefore, mitigate this issue in several ways: First, if we try to
write out an inode with both rtinherit/extszinherit set and an unaligned
extent size hint, turn off the hint to correct the error.  Second, if
someone tries to misconfigure a directory via the fssetxattr ioctl, fail
the ioctl.  Third, reverify both extent size hint values when we
propagate heritable inode attributes from parent to child, to prevent
misconfigurations from spreading.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
v2: disable incorrect hints at runtime instead of whacking filesystems
    with verifier errors
v3: revise the comment in the verifier to describe the source of the
    problem, the observable symptoms, and how the solution fits the
    historical context
---
 fs/xfs/libxfs/xfs_inode_buf.c   |   22 ++++++++++++++++++++++
 fs/xfs/libxfs/xfs_trans_inode.c |   15 +++++++++++++++
 fs/xfs/xfs_inode.c              |   29 +++++++++++++++++++++++++++++
 fs/xfs/xfs_ioctl.c              |   15 +++++++++++++++
 4 files changed, 81 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 045118c7bf78..f3254a4f4cb4 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -589,6 +589,28 @@ xfs_inode_validate_extsize(
 	inherit_flag = (flags & XFS_DIFLAG_EXTSZINHERIT);
 	extsize_bytes = XFS_FSB_TO_B(mp, extsize);
 
+	/*
+	 * This comment describes a historic gap in this verifier function.
+	 *
+	 * On older kernels, the extent size hint verifier doesn't check that
+	 * the extent size hint is an integer multiple of the realtime extent
+	 * size on a directory with both RTINHERIT and EXTSZINHERIT flags set.
+	 * The verifier has always enforced the alignment rule for regular
+	 * files with the REALTIME flag set.
+	 *
+	 * If a directory with a misaligned extent size hint is allowed to
+	 * propagate that hint into a new regular realtime file, the result
+	 * is that the inode cluster buffer verifier will trigger a corruption
+	 * shutdown the next time it is run.
+	 *
+	 * Unfortunately, there could be filesystems with these misconfigured
+	 * directories in the wild, so we cannot add a check to this verifier
+	 * at this time because that will result a new source of directory
+	 * corruption errors when reading an existing filesystem.  Instead, we
+	 * permit the misconfiguration to pass through the verifiers so that
+	 * callers of this function can correct and mitigate externally.
+	 */
+
 	if (rt_flag)
 		blocksize_bytes = mp->m_sb.sb_rextsize << mp->m_sb.sb_blocklog;
 	else
diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
index 78324e043e25..325f2dceec13 100644
--- a/fs/xfs/libxfs/xfs_trans_inode.c
+++ b/fs/xfs/libxfs/xfs_trans_inode.c
@@ -142,6 +142,21 @@ xfs_trans_log_inode(
 		flags |= XFS_ILOG_CORE;
 	}
 
+	/*
+	 * Inode verifiers on older kernels don't check that the extent size
+	 * hint is an integer multiple of the rt extent size on a directory
+	 * with both rtinherit and extszinherit flags set.  If we're logging a
+	 * directory that is misconfigured in this way, clear the hint.
+	 */
+	if ((ip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
+	    (ip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) &&
+	    (ip->i_extsize % ip->i_mount->m_sb.sb_rextsize) > 0) {
+		ip->i_diflags &= ~(XFS_DIFLAG_EXTSIZE |
+				   XFS_DIFLAG_EXTSZINHERIT);
+		ip->i_extsize = 0;
+		flags |= XFS_ILOG_CORE;
+	}
+
 	/*
 	 * Record the specific change for fdatasync optimisation. This allows
 	 * fdatasync to skip log forces for inodes that are only timestamp
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 0369eb22c1bb..e4c2da4566f1 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -690,6 +690,7 @@ xfs_inode_inherit_flags(
 	const struct xfs_inode	*pip)
 {
 	unsigned int		di_flags = 0;
+	xfs_failaddr_t		failaddr;
 	umode_t			mode = VFS_I(ip)->i_mode;
 
 	if (S_ISDIR(mode)) {
@@ -729,6 +730,24 @@ xfs_inode_inherit_flags(
 		di_flags |= XFS_DIFLAG_FILESTREAM;
 
 	ip->i_diflags |= di_flags;
+
+	/*
+	 * Inode verifiers on older kernels only check that the extent size
+	 * hint is an integer multiple of the rt extent size on realtime files.
+	 * They did not check the hint alignment on a directory with both
+	 * rtinherit and extszinherit flags set.  If the misaligned hint is
+	 * propagated from a directory into a new realtime file, new file
+	 * allocations will fail due to math errors in the rt allocator and/or
+	 * trip the verifiers.  Validate the hint settings in the new file so
+	 * that we don't let broken hints propagate.
+	 */
+	failaddr = xfs_inode_validate_extsize(ip->i_mount, ip->i_extsize,
+			VFS_I(ip)->i_mode, ip->i_diflags);
+	if (failaddr) {
+		ip->i_diflags &= ~(XFS_DIFLAG_EXTSIZE |
+				   XFS_DIFLAG_EXTSZINHERIT);
+		ip->i_extsize = 0;
+	}
 }
 
 /* Propagate di_flags2 from a parent inode to a child inode. */
@@ -737,12 +756,22 @@ xfs_inode_inherit_flags2(
 	struct xfs_inode	*ip,
 	const struct xfs_inode	*pip)
 {
+	xfs_failaddr_t		failaddr;
+
 	if (pip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE) {
 		ip->i_diflags2 |= XFS_DIFLAG2_COWEXTSIZE;
 		ip->i_cowextsize = pip->i_cowextsize;
 	}
 	if (pip->i_diflags2 & XFS_DIFLAG2_DAX)
 		ip->i_diflags2 |= XFS_DIFLAG2_DAX;
+
+	/* Don't let invalid cowextsize hints propagate. */
+	failaddr = xfs_inode_validate_cowextsize(ip->i_mount, ip->i_cowextsize,
+			VFS_I(ip)->i_mode, ip->i_diflags, ip->i_diflags2);
+	if (failaddr) {
+		ip->i_diflags2 &= ~XFS_DIFLAG2_COWEXTSIZE;
+		ip->i_cowextsize = 0;
+	}
 }
 
 /*
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 6407921aca96..1fe4c1fc0aea 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1291,6 +1291,21 @@ xfs_ioctl_setattr_check_extsize(
 
 	new_diflags = xfs_flags2diflags(ip, fa->fsx_xflags);
 
+	/*
+	 * Inode verifiers on older kernels don't check that the extent size
+	 * hint is an integer multiple of the rt extent size on a directory
+	 * with both rtinherit and extszinherit flags set.  Don't let sysadmins
+	 * misconfigure directories.
+	 */
+	if ((new_diflags & XFS_DIFLAG_RTINHERIT) &&
+	    (new_diflags & XFS_DIFLAG_EXTSZINHERIT)) {
+		unsigned int	rtextsize_bytes;
+
+		rtextsize_bytes = XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize);
+		if (fa->fsx_extsize % rtextsize_bytes)
+			return -EINVAL;
+	}
+
 	failaddr = xfs_inode_validate_extsize(ip->i_mount,
 			XFS_B_TO_FSB(mp, fa->fsx_extsize),
 			VFS_I(ip)->i_mode, new_diflags);
