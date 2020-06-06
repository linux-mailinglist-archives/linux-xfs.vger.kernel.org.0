Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 235EE1F05C8
	for <lists+linux-xfs@lfdr.de>; Sat,  6 Jun 2020 10:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728632AbgFFI2X (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 6 Jun 2020 04:28:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgFFI2U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 6 Jun 2020 04:28:20 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2384C08C5C2
        for <linux-xfs@vger.kernel.org>; Sat,  6 Jun 2020 01:28:19 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id p21so6264611pgm.13
        for <linux-xfs@vger.kernel.org>; Sat, 06 Jun 2020 01:28:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cGwjIzOF/wLm6AC3DNPM0M+L+3oZz86vyou6DH5FeNQ=;
        b=I4tiR3XvXKeCbZrbxqIZeRhs/8N/YxznIBBxsrk+ucrMkWVK1OaTg5Mg0OCNp8JxTs
         ANkeKcpahEq5RUycLJsMRcRe15lJrmzdRS53YJed+v3aKn3jFugv3DUC+J8AZxPymVbT
         YgOIJrFfpxeXpKkdF4Yt8Nx23Asb1U44k/DE/eUPQxxb/cSwqhkwFoZ3sXBTbLpjmSVm
         CCdnq8BUAtktBxZ6kELadNl34BJfwM3dgHdtkCLR4gzEa0R+cuswM2sRqAtwXmjbP1Fr
         xXL9GgJSaW9z4/JhYHhJ8tSRjGYGLCWap+Dz4hi2pyxy4jXu4Er+PUOZvb08N3gAy4rE
         wCQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cGwjIzOF/wLm6AC3DNPM0M+L+3oZz86vyou6DH5FeNQ=;
        b=aB8Idav+OJs0tC1d6qiEI5IkPLMl6AWmtM+b4pGifVKOYy2JE+Z4A83wtHILEH82SO
         mj/PwwY2eyASxHpLRuV4y8sGLxQ94a2bMPwuDl2h1mJ0LC5O7MFbLm5ltL9GXZ2y9kz9
         jUjVeL2aRdh6ZH/59loZM+iJJa61AgLumLRkS3xUhXUFJim+0k+MGXynM8ph4asSEEtm
         Bn9t5QyujSUYk+7TnMa2BIyEHww6vl50GWQtE/ahUjeRyShRggblMjpkmwoF8Lxfuf63
         IwljV+IqP45qmVVxC0ZiGRW9Xtgk+/Fmzv+WvJRDbTFM/RnQdv2N/MIuIpMiDFC+5Oes
         GJKA==
X-Gm-Message-State: AOAM5315SpBxaklYPXPXBRIolmksjCBEfbWCQYkQs0NLHBL15TiZF+58
        El5sEvatKkrwvbl19J6x4c5ZCH0c
X-Google-Smtp-Source: ABdhPJxZTV1OvkkMzhkIjNjI4XltkdPux7XjtXbA2oB4kSVoxaeri758xzqAoahLKAR6tDOHjXZobQ==
X-Received: by 2002:aa7:804a:: with SMTP id y10mr12776849pfm.186.1591432099260;
        Sat, 06 Jun 2020 01:28:19 -0700 (PDT)
Received: from localhost.localdomain ([122.167.144.243])
        by smtp.gmail.com with ESMTPSA id j3sm1678130pfh.87.2020.06.06.01.28.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Jun 2020 01:28:18 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, david@fromorbit.com,
        darrick.wong@oracle.com, bfoster@redhat.com, hch@infradead.org
Subject: [PATCH 3/7] xfs: Compute maximum height of directory BMBT separately
Date:   Sat,  6 Jun 2020 13:57:41 +0530
Message-Id: <20200606082745.15174-4-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200606082745.15174-1-chandanrlinux@gmail.com>
References: <20200606082745.15174-1-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs/306 causes the following call trace when using a data fork with a
maximum extent count of 2^47,

 XFS (loop0): Mounting V5 Filesystem
 XFS (loop0): Log size 8906 blocks too small, minimum size is 9075 blocks
 XFS (loop0): AAIEEE! Log failed size checks. Abort!
 XFS: Assertion failed: 0, file: fs/xfs/xfs_log.c, line: 711
 ------------[ cut here ]------------
 WARNING: CPU: 0 PID: 12821 at fs/xfs/xfs_message.c:112 assfail+0x25/0x28
 Modules linked in:
 CPU: 0 PID: 12821 Comm: mount Tainted: G        W         5.6.0-rc6-next-20200320-chandan-00003-g071c2af3f4de #1
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014
 RIP: 0010:assfail+0x25/0x28
 Code: ff ff 0f 0b c3 0f 1f 44 00 00 41 89 c8 48 89 d1 48 89 f2 48 c7 c6 40 b7 4b b3 e8 82 f9 ff ff 80 3d 83 d6 64 01 00 74 02 0f $
 RSP: 0018:ffffb05b414cbd78 EFLAGS: 00010246
 RAX: 0000000000000000 RBX: ffff9d9d501d5000 RCX: 0000000000000000
 RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffffb346dc65
 RBP: ffff9da444b49a80 R08: 0000000000000000 R09: 0000000000000000
 R10: 000000000000000a R11: f000000000000000 R12: 00000000ffffffea
 R13: 000000000000000e R14: 0000000000004594 R15: ffff9d9d501d5628
 FS:  00007fd6c5d17c80(0000) GS:ffff9da44d800000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000000002 CR3: 00000008a48c0000 CR4: 00000000000006f0
 Call Trace:
  xfs_log_mount+0xf8/0x300
  xfs_mountfs+0x46e/0x950
  xfs_fc_fill_super+0x318/0x510
  ? xfs_mount_free+0x30/0x30
  get_tree_bdev+0x15c/0x250
  vfs_get_tree+0x25/0xb0
  do_mount+0x740/0x9b0
  ? memdup_user+0x41/0x80
  __x64_sys_mount+0x8e/0xd0
  do_syscall_64+0x48/0x110
  entry_SYSCALL_64_after_hwframe+0x44/0xa9
 RIP: 0033:0x7fd6c5f2ccda
 Code: 48 8b 0d b9 e1 0b 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 49 89 ca b8 a5 00 00 00 0f $
 RSP: 002b:00007ffe00dfb9f8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
 RAX: ffffffffffffffda RBX: 0000560c1aaa92c0 RCX: 00007fd6c5f2ccda
 RDX: 0000560c1aaae110 RSI: 0000560c1aaad040 RDI: 0000560c1aaa94d0
 RBP: 00007fd6c607d204 R08: 0000000000000000 R09: 0000560c1aaadde0
 R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
 R13: 0000000000000000 R14: 0000560c1aaa94d0 R15: 0000560c1aaae110
 ---[ end trace 6436391b468bc652 ]---
 XFS (loop0): log mount failed

The corresponding filesystem was created using mkfs options
"-m rmapbt=1,reflink=1 -b size=1k -d size=20m -n size=64k".

i.e. We have a filesystem of size 20MiB, data block size of 1KiB and
directory block size of 64KiB. Filesystems of size < 1GiB can have less
than 10MiB on-disk log (Please refer to calculate_log_size() in
xfsprogs).

The largest reservation space was contributed by the rename
operation. The corresponding calculation is done inside
xfs_calc_rename_reservation(). In this case, the value returned by this
function is,

xfs_calc_inode_res(mp, 4)
+ xfs_calc_buf_res(2 * XFS_DIROP_LOG_COUNT(mp), XFS_FSB_TO_B(mp, 1))

xfs_calc_inode_res(mp, 4) returns a constant value of 3040 bytes
regardless of the maximum data fork extent count.

The largest contribution to the rename operation was by "2 *
XFS_DIROP_LOG_COUNT(mp)" and it is a function of maximum height of a
directory's BMBT tree.

XFS_DIROP_LOG_COUNT() is a sum of,

1. The maximum number of dabtree blocks that needs to be logged
   i.e. XFS_DAENTER_BLOCKS() = XFS_DAENTER_1B(mp,w) *
   XFS_DAENTER_DBS(mp,w).  For directories, this evaluates
   to (64 * (XFS_DA_NODE_MAXDEPTH + 2)) = (64 * (5 + 2)) = 448.

2. The corresponding maximum number of BMBT blocks that needs to be
   logged i.e. XFS_DAENTER_BMAPS() = XFS_DAENTER_DBS(mp,w) *
   XFS_DAENTER_BMAP1B(mp,w)

   XFS_DAENTER_DBS(mp,w) = XFS_DA_NODE_MAXDEPTH + 2 = 7

   XFS_DAENTER_BMAP1B(mp,w)
   = XFS_NEXTENTADD_SPACE_RES(mp, XFS_DAENTER_1B(mp, w), w)
   = XFS_NEXTENTADD_SPACE_RES(mp, 64, w)
   = ((64 + XFS_MAX_CONTIG_EXTENTS_PER_BLOCK(mp) - 1) /
   XFS_MAX_CONTIG_EXTENTS_PER_BLOCK(mp)) * XFS_EXTENTADD_SPACE_RES(mp, w)

   XFS_MAX_CONTIG_EXTENTS_PER_BLOCK() =
   mp->m_alloc_mxr[0] - mp->m_alloc_mnr[0] = 121 - 60 = 61

   XFS_DAENTER_BMAP1B(mp,w) =
   ((64 + XFS_MAX_CONTIG_EXTENTS_PER_BLOCK(mp) - 1) /
   XFS_MAX_CONTIG_EXTENTS_PER_BLOCK(mp)) * XFS_EXTENTADD_SPACE_RES(mp, w)
   = ((64 + 61 - 1) / 61) * XFS_EXTENTADD_SPACE_RES(mp, w)
   = 2 * XFS_EXTENTADD_SPACE_RES(mp, w)
   = 2 * (XFS_BM_MAXLEVELS(mp,w) - 1)
   = 2 * (8 - 1)
   = 14

   With 2^32 as the maximum extent count the maximum height of the bmap btree
   was 7. Now with 2^47 maximum extent count, the height has increased to 8.

   Therefore, XFS_DAENTER_BMAPS() = 7 * 14 = 98.

XFS_DIROP_LOG_COUNT() = 448 + 98 = 546.
2 * XFS_DIROP_LOG_COUNT() = 2 * 546 = 1092.

With 2^32 max extent count, XFS_DIROP_LOG_COUNT() evaluates to
533. Hence 2 * XFS_DIROP_LOG_COUNT() = 2 * 533 = 1066.

This small difference of 1092 - 1066 = 26 fs blocks is sufficient to
trip us over the minimum log size check.

A future commit in this series will use 2^27 as the maximum directory
extent count. This will result in a shorter directory BMBT tree.  Log
reservation calculations that are applicable only to
directories (e.g. XFS_DIROP_LOG_COUNT()) can then choose this instead of
non-dir data fork BMBT height.

This commit introduces a new member in 'struct xfs_mount' to hold the
maximum BMBT height of a directory. At present, the maximum height of a
directory BMBT is the same as a the maximum height of a non-directory
BMBT. A future commit will change the parameters used as input for
computing the maximum height of a directory BMBT.

Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
---
 fs/xfs/libxfs/xfs_bmap.c | 17 ++++++++++++++---
 fs/xfs/libxfs/xfs_bmap.h |  3 ++-
 fs/xfs/xfs_mount.c       |  5 +++--
 fs/xfs/xfs_mount.h       |  1 +
 4 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 798fca5c52af..01e2b543b139 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -50,7 +50,8 @@ kmem_zone_t		*xfs_bmap_free_item_zone;
 void
 xfs_bmap_compute_maxlevels(
 	xfs_mount_t	*mp,		/* file system mount structure */
-	int		whichfork)	/* data or attr fork */
+	int		whichfork,	/* data or attr fork */
+	int		dir_bmbt)	/* Dir or non-dir data fork */
 {
 	int		level;		/* btree level */
 	uint		maxblocks;	/* max blocks at this level */
@@ -60,6 +61,9 @@ xfs_bmap_compute_maxlevels(
 	int		minnoderecs;	/* min records in node block */
 	int		sz;		/* root block size */
 
+	if (whichfork == XFS_ATTR_FORK)
+		ASSERT(dir_bmbt == 0);
+
 	/*
 	 * The maximum number of extents in a file, hence the maximum number of
 	 * leaf entries, is controlled by the size of the on-disk extent count,
@@ -75,8 +79,11 @@ xfs_bmap_compute_maxlevels(
 	 * of a minimum size available.
 	 */
 	if (whichfork == XFS_DATA_FORK) {
-		maxleafents = MAXEXTNUM;
 		sz = XFS_BMDR_SPACE_CALC(MINDBTPTRS);
+		if (dir_bmbt)
+			maxleafents = MAXEXTNUM;
+		else
+			maxleafents = MAXEXTNUM;
 	} else {
 		maxleafents = MAXAEXTNUM;
 		sz = XFS_BMDR_SPACE_CALC(MINABTPTRS);
@@ -91,7 +98,11 @@ xfs_bmap_compute_maxlevels(
 		else
 			maxblocks = (maxblocks + minnoderecs - 1) / minnoderecs;
 	}
-	mp->m_bm_maxlevels[whichfork] = level;
+
+	if (whichfork == XFS_DATA_FORK && dir_bmbt)
+		mp->m_bm_dir_maxlevel = level;
+	else
+		mp->m_bm_maxlevels[whichfork] = level;
 }
 
 STATIC int				/* error */
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 6028a3c825ba..4250c9ab4b75 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -187,7 +187,8 @@ void	xfs_bmap_local_to_extents_empty(struct xfs_trans *tp,
 void	__xfs_bmap_add_free(struct xfs_trans *tp, xfs_fsblock_t bno,
 		xfs_filblks_t len, const struct xfs_owner_info *oinfo,
 		bool skip_discard);
-void	xfs_bmap_compute_maxlevels(struct xfs_mount *mp, int whichfork);
+void	xfs_bmap_compute_maxlevels(struct xfs_mount *mp, int whichfork,
+		int dir_bmbt);
 int	xfs_bmap_first_unused(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_extlen_t len, xfs_fileoff_t *unused, int whichfork);
 int	xfs_bmap_last_before(struct xfs_trans *tp, struct xfs_inode *ip,
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index bb91f04266b9..d8ebfc67bb63 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -711,8 +711,9 @@ xfs_mountfs(
 		goto out;
 
 	xfs_alloc_compute_maxlevels(mp);
-	xfs_bmap_compute_maxlevels(mp, XFS_DATA_FORK);
-	xfs_bmap_compute_maxlevels(mp, XFS_ATTR_FORK);
+	xfs_bmap_compute_maxlevels(mp, XFS_DATA_FORK, 0);
+	xfs_bmap_compute_maxlevels(mp, XFS_DATA_FORK, 1);
+	xfs_bmap_compute_maxlevels(mp, XFS_ATTR_FORK, 0);
 	xfs_ialloc_setup_geometry(mp);
 	xfs_rmapbt_compute_maxlevels(mp);
 	xfs_refcountbt_compute_maxlevels(mp);
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index aba5a1579279..9dbf036ddace 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -133,6 +133,7 @@ typedef struct xfs_mount {
 	uint			m_refc_mnr[2];	/* min refc btree records */
 	uint			m_ag_maxlevels;	/* XFS_AG_MAXLEVELS */
 	uint			m_bm_maxlevels[2]; /* XFS_BM_MAXLEVELS */
+	uint			m_bm_dir_maxlevel;
 	uint			m_rmap_maxlevels; /* max rmap btree levels */
 	uint			m_refc_maxlevels; /* max refcount btree level */
 	xfs_extlen_t		m_ag_prealloc_blocks; /* reserved ag blocks */
-- 
2.20.1

