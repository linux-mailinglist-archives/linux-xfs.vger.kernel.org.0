Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F3EA2A2766
	for <lists+linux-xfs@lfdr.de>; Mon,  2 Nov 2020 10:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728005AbgKBJvB (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 2 Nov 2020 04:51:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727992AbgKBJvB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Nov 2020 04:51:01 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D74B1C0617A6
        for <linux-xfs@vger.kernel.org>; Mon,  2 Nov 2020 01:50:59 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id h6so10330623pgk.4
        for <linux-xfs@vger.kernel.org>; Mon, 02 Nov 2020 01:50:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Eu2Ruo5Ydx3ZQQNi3GggJMn/kizBTMFYoIa5auV/8JY=;
        b=WYw6wUvHnWHD4cr3JSth6mpeRDlsj7WPhDYBazOWQXmoN17xm/CkKCTTh7QwG0cuXW
         XSnDy1UEHBeP9Botha6GPbaY27xUOlo2ildp+sQaThfsFEsDhHaZNXu3BvZb91bW7ibJ
         pvcGtIK6LyjMvmjRxrmMX7jlw+xRYH6lrlbuKgd7dP5y5W200/H3uWisWZiyyZaW1Eiv
         kON/VpkPJdG+1Kxz2mckrefRBS8KnRH4Z7bW2zK/lxu/LaSDcHqjMK3mBE1+XU/1PZXy
         hXK0+jJVNGB/a5jTUI9HkgNuArvT7yYQP5kmLGYv5CbdAcJLHHH3+SoI0NNEmpzmOZ4X
         U9BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Eu2Ruo5Ydx3ZQQNi3GggJMn/kizBTMFYoIa5auV/8JY=;
        b=XNMeFKzoaB6n2zeu0z3CXI0x5WKg0lAfzN0WnGSqGlNJJmNFbY5YhbGUl5TzznblLN
         0A706M/RnTYZmXVScW23ua69Wt/ZagWV81jwR07WnvdkEGRI+Z3QvKQFIhXrpHsREtY8
         6PF2LEGRN3OeT4HfvCH3ndNiYwfj9BjUrhxfpoUtQQPTz4PArPOvnBQcCIiuPBX2hNW5
         4ws8Q1Q2Jef7bvj8KUWQetWdzOuKdnE/yG5IkAJNMO2y8mK1MHnzE5UZakSbCwIGaMFO
         EyNLSdTvxJs83KISeFHX0X1fYuOBXAXWqcBgY8+Uzpnt+s0zZBSplleZqLqeHeVGjhO5
         e8+g==
X-Gm-Message-State: AOAM533ow8k22TMspzvav1PBw9MhlqrMqLn7PGPCJicsWcaY9e0d1QQZ
        +q7gSsAu8syP6/2MG9pS2SZFKBKpJXQ=
X-Google-Smtp-Source: ABdhPJzSC1Fslmz0d8/hRsovV6GQ5disgk3kNkD5N8hGTTiPxCdn2p0aSNdkj2UJtmBtM2dsG99lyQ==
X-Received: by 2002:a63:354c:: with SMTP id c73mr13311407pga.315.1604310658846;
        Mon, 02 Nov 2020 01:50:58 -0800 (PST)
Received: from localhost.localdomain ([122.179.32.56])
        by smtp.gmail.com with ESMTPSA id x15sm467062pjh.21.2020.11.02.01.50.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 01:50:57 -0800 (PST)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     Chandan Babu R <chandanrlinux@gmail.com>, darrick.wong@oracle.com,
        david@fromorbit.com, hch@infradead.org,
        allison.henderson@oracle.com
Subject: [PATCH V9 00/14] Bail out if transaction can cause extent count to overflow
Date:   Mon,  2 Nov 2020 15:20:34 +0530
Message-Id: <20201102095048.100956-1-chandanrlinux@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

XFS does not check for possible overflow of per-inode extent counter
fields when adding extents to either data or attr fork.

For e.g.
1. Insert 5 million xattrs (each having a value size of 255 bytes) and
   then delete 50% of them in an alternating manner.

2. On a 4k block sized XFS filesystem instance, the above causes 98511
   extents to be created in the attr fork of the inode.

   xfsaild/loop0  2008 [003]  1475.127209: probe:xfs_inode_to_disk: (ffffffffa43fb6b0) if_nextents=98511 i_ino=131

3. The incore inode fork extent counter is a signed 32-bit
   quantity. However, the on-disk extent counter is an unsigned 16-bit
   quantity and hence cannot hold 98511 extents.

4. The following incorrect value is stored in the xattr extent counter,
   # xfs_db -f -c 'inode 131' -c 'print core.naextents' /dev/loop0
   core.naextents = -32561

This patchset adds a new helper function
(i.e. xfs_iext_count_may_overflow()) to check for overflow of the
per-inode data and xattr extent counters and invokes it before
starting an fs operation (e.g. creating a new directory entry). With
this patchset applied, XFS detects counter overflows and returns with
an error rather than causing a silent corruption.

The patchset has been tested by executing xfstests with the following
mkfs.xfs options,
1. -m crc=0 -b size=1k
2. -m crc=0 -b size=4k
3. -m crc=0 -b size=512
4. -m rmapbt=1,reflink=1 -b size=1k
5. -m rmapbt=1,reflink=1 -b size=4k

The patches can also be obtained from
https://github.com/chandanr/linux.git at branch xfs-reserve-extent-count-v9.

I have two patches that define the newly introduced error injection
tags in xfsprogs
(https://github.com/chandanr/xfsprogs-dev/commit/7fd7aeef1cefbcc9abd6dd5887e710c80e48079d
and
https://github.com/chandanr/xfsprogs-dev/commit/3cbe12f6fdf306de06c4096eb50641fa2d834dc5).

I have also written tests
(https://github.com/chandanr/xfstests/commits/extent-overflow-tests)
for verifying the checks introduced in the kernel. They depend on
error tags introduced in these patches . Hence, I am planning to post
the changes for xfsprogs and xfstests if other developers are fine
with the changes made in this patchset.

Changelog:
V8 -> V9:
  1. Enabling XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT error tag will
     always allocate single block sized free extents (if
     available).
  2. xfs_bmap_compute_alignments() now returns stripe alignment as its
     return value.
  3. Dropped Allison's RVB tag for "xfs: Compute bmap extent
     alignments in a separate function" and "xfs: Introduce error
     injection to allocate only minlen size extents for files".

V7 -> V8:
  1. Rename local variable in xfs_alloc_fix_freelist() from "i" to "stat".

V6 -> V7:
  1. Create new function xfs_bmap_exact_minlen_extent_alloc() (enabled
     only when CONFIG_XFS_DEBUG is set to y) which issues allocation
     requests for minlen sized extents only. In order to achieve this,
     common code from xfs_bmap_btalloc() have been refactored into new
     functions.
  2. All major functions implementing logic associated with
     XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT error tag are compiled only
     when CONFIG_XFS_DEBUG is set to y.
  3. Remove XFS_IEXT_REFLINK_REMAP_CNT macro and replace it with an
     integer which holds the number of new extents to be
     added to the data fork.

V5 -> V6:
  1. Rebased the patchset on xfs-linux/for-next branch.
  2. Drop "xfs: Set tp->t_firstblock only once during a transaction's
     lifetime" patch from the patchset.
  3. Add a comment to xfs_bmap_btalloc() describing why it was chosen
     to start "free space extent search" from AG 0 when
     XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT is enabled and when the
     transaction is allocating its first extent.
  4. Fix review comments associated with coding style.

V4 -> V5:
  1. Introduce new error tag XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT to
     let user space programs to be able to guarantee that free space
     requests for files are satisfied by allocating minlen sized
     extents.
  2. Change xfs_bmap_btalloc() and xfs_alloc_vextent() to allocate
     minlen sized extents when XFS_ERRTAG_BMAP_ALLOC_MINLEN_EXTENT is
     enabled.
  3. Introduce a new patch that causes tp->t_firstblock to be assigned
     to a value only when its previous value is NULLFSBLOCK.
  4. Replace the previously introduced MAXERRTAGEXTNUM (maximum inode
     fork extent count) with the hardcoded value of 10.
  5. xfs_bui_item_recover(): Use XFS_IEXT_ADD_NOSPLIT_CNT when mapping
     an extent.
  6. xfs_swap_extent_rmap(): Use xfs_bmap_is_real_extent() instead of
     xfs_bmap_is_update_needed() to assess if the extent really needs
     to be swapped.

V3 -> V4:
  1. Introduce new patch which lets userspace programs to test "extent
     count overflow detection" by injecting an error tag. The new
     error tag reduces the maximum allowed extent count to 10.
  2. Injecting the newly defined error tag prevents
     xfs_bmap_add_extent_hole_real() from merging a new extent with
     its neighbours to allow writing deterministic tests for testing
     extent count overflow for Directories, Xattr and growing realtime
     devices. This is required because the new extent being allocated
     can be contiguous with its neighbours (w.r.t both file and disk
     offsets).
  3. Injecting the newly defined error tag forces block sized extents
     to be allocated for summary/bitmap files when growing a realtime
     device. This is required because xfs_growfs_rt_alloc() allocates
     as large an extent as possible for summary/bitmap files and hence
     it would be impossible to write deterministic tests.
  4. Rename XFS_IEXT_REMOVE_CNT to XFS_IEXT_PUNCH_HOLE_CNT to reflect
     the actual meaning of the fs operation.
  5. Fold XFS_IEXT_INSERT_HOLE_CNT code into that associated with
     XFS_IEXT_PUNCH_HOLE_CNT since both perform the same job.
  6. xfs_swap_extent_rmap(): Check for extent overflow should be made
     on the source file only if the donor file extent has a valid
     on-disk mapping and vice versa.

V2 -> V3:
  1. Move the definition of xfs_iext_count_may_overflow() from
     libxfs/xfs_trans_resv.c to libxfs/xfs_inode_fork.c. Also, I tried
     to make xfs_iext_count_may_overflow() an inline function by
     placing the definition in libxfs/xfs_inode_fork.h. However this
     required that the definition of 'struct xfs_inode' be available,
     since xfs_iext_count_may_overflow() uses a 'struct xfs_inode *'
     type variable.
  2. Handle XFS_COW_FORK within xfs_iext_count_may_overflow() by
     returning a success value.
  3. Rename XFS_IEXT_ADD_CNT to XFS_IEXT_ADD_NOSPLIT_CNT. Thanks to
     Darrick for the suggesting the new name.
  4. Expand comments to make use of 80 columns.

V1 -> V2:
  1. Rename helper function from xfs_trans_resv_ext_cnt() to
     xfs_iext_count_may_overflow().
  2. Define and use macros to represent fs operations and the
     corresponding increase in extent count.
  3. Split the patches based on the fs operation being performed.

Chandan Babu R (14):
  xfs: Add helper for checking per-inode extent count overflow
  xfs: Check for extent overflow when trivally adding a new extent
  xfs: Check for extent overflow when punching a hole
  xfs: Check for extent overflow when adding/removing xattrs
  xfs: Check for extent overflow when adding/removing dir entries
  xfs: Check for extent overflow when writing to unwritten extent
  xfs: Check for extent overflow when moving extent from cow to data
    fork
  xfs: Check for extent overflow when remapping an extent
  xfs: Check for extent overflow when swapping extents
  xfs: Introduce error injection to reduce maximum inode fork extent
    count
  xfs: Remove duplicate assert statement in xfs_bmap_btalloc()
  xfs: Compute bmap extent alignments in a separate function
  xfs: Process allocated extent in a separate function
  xfs: Introduce error injection to allocate only minlen size extents
    for files

 fs/xfs/libxfs/xfs_alloc.c      |  50 +++++++
 fs/xfs/libxfs/xfs_alloc.h      |   3 +
 fs/xfs/libxfs/xfs_attr.c       |  13 ++
 fs/xfs/libxfs/xfs_bmap.c       | 266 +++++++++++++++++++++++----------
 fs/xfs/libxfs/xfs_errortag.h   |   6 +-
 fs/xfs/libxfs/xfs_inode_fork.c |  27 ++++
 fs/xfs/libxfs/xfs_inode_fork.h |  62 ++++++++
 fs/xfs/xfs_bmap_item.c         |  10 ++
 fs/xfs/xfs_bmap_util.c         |  31 ++++
 fs/xfs/xfs_dquot.c             |   8 +-
 fs/xfs/xfs_error.c             |   6 +
 fs/xfs/xfs_inode.c             |  27 ++++
 fs/xfs/xfs_iomap.c             |  10 ++
 fs/xfs/xfs_reflink.c           |  16 ++
 fs/xfs/xfs_rtalloc.c           |   5 +
 fs/xfs/xfs_symlink.c           |   5 +
 16 files changed, 466 insertions(+), 79 deletions(-)

-- 
2.28.0

