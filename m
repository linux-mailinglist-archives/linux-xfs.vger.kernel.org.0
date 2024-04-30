Return-Path: <linux-xfs+bounces-7840-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E45CA8B6847
	for <lists+linux-xfs@lfdr.de>; Tue, 30 Apr 2024 05:19:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 752A11F2219F
	for <lists+linux-xfs@lfdr.de>; Tue, 30 Apr 2024 03:19:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAD86DF6B;
	Tue, 30 Apr 2024 03:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KAo3C/cZ"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E0A12E47;
	Tue, 30 Apr 2024 03:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714447134; cv=none; b=f9VOhKl9FwHMlAVzhzISs7SH2Fn8GQrCK4sW5zmUlkocqRjgyuzOl7XxF5T9baKEXwUMhpTvieiLG1XACAEKh/HfIkoNO5Hv07h/NpWIGMwfYOKWmRIO2W9pjZ/2RysF5KD+RpYBasP6QnV1e503zhZXNTEhlS4nQZ040lwKn7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714447134; c=relaxed/simple;
	bh=HjZZQrp9uD/tMXSpT9bIEjQzS34U5AeccOyi0GO3lL0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cPk2FpL7judgQ/VvuSIMsJI39i+WyRc5Dgelt6PjcWXjQQkZB3Qhyrh+HJVTdYVwgjgRqSP6V0JPq2o1V8YCU5yr7qP0kaNds+C59yJCH8UkKXShfpmzg0WUFCmA647MK4S8DFQWh9B3T+8lKCG/YyWeZhaL7d9EVPIm4btWoWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KAo3C/cZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EDD7C116B1;
	Tue, 30 Apr 2024 03:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714447134;
	bh=HjZZQrp9uD/tMXSpT9bIEjQzS34U5AeccOyi0GO3lL0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=KAo3C/cZClJz+4pkqdNWS2/SgYsjz7vFn9bVCgvbkScwPAyHVhfcwVQSxTAbcQqr1
	 hMDhwUb4C/X9AcA0g4WLcTu+fI5Ni0J6fEJSaojBUnjlAipQk6CKRQoMWc3kpKVBw1
	 wZsOrEyc2y9aZVdnSJ7pFtyl0lXuD6/q7hUSeUm6oz5WsP1rAxroE0BmtjKol1AoGG
	 Z2euohIBeOB1QNKffykE+YoJLSqE2c9VgBAR5UanznxFknUiUceYbzFvv/Uo4LvCyL
	 n13sgYB5XhVUDh4i4Y2a+6YOZcPvWWbvDTXpJ6Cfc8tw8yk1ZPJ6BmY0CzbW20lVWj
	 YMouuCoGLgSKg==
Date: Mon, 29 Apr 2024 20:18:53 -0700
Subject: [PATCHSET v5.6 2/2] xfs: fs-verity support
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@redhat.com, ebiggers@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, alexl@redhat.com, walters@verbum.org,
 fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org
Message-ID: <171444680291.957659.15782417454902691461.stgit@frogsfrogsfrogs>
In-Reply-To: <20240430031134.GH360919@frogsfrogsfrogs>
References: <20240430031134.GH360919@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

This patchset adds support for fsverity to XFS.  In keeping with
Andrey's original design, XFS stores all fsverity metadata in the
extended attribute data.  However, I've made a few changes to the code:
First, it now caches merkle tree blocks directly instead of abusing the
buffer cache.  This reduces lookup overhead quite a bit, at a cost of
needing a new shrinker for cached merkle tree blocks.

To reduce the ondisk footprint further, I also made the verity
enablement code detect trailing zeroes whenever fsverity tells us to
write a buffer, and elide storing the zeroes.  To further reduce the
footprint of sparse files, I also skip writing merkle tree blocks if the
block contents are entirely hashes of zeroes.

Next, I implemented more of the tooling around verity, such as debugger
support, as much fsck support as I can manage without knowing the
internal format of the fsverity information; and added support for
xfs_scrub to read fsverity files to validate the consistency of the data
against the merkle tree.

Finally, I add the ability for administrators to turn off fsverity,
which might help recovering damaged data from an inconsistent file.

From Andrey Albershteyn:

Here's v5 of my patchset of adding fs-verity support to XFS.

This implementation uses extended attributes to store fs-verity
metadata. The Merkle tree blocks are stored in the remote extended
attributes. The names are offsets into the tree.

A few key points of this patchset:
- fs-verity can work with Merkle tree blocks based caching (xfs) and
  PAGE caching (ext4, f2fs, btrfs)
- iomap does fs-verity verification
- In XFS, fs-verity metadata is stored in extended attributes
- per-sb workqueue for verification processing
- Inodes with fs-verity have new on-disk diflag
- xfs_attr_get() can return a buffer with an extended attribute
- xfs_buf can allocate double space for Merkle tree blocks. Part of
  the space is used to store  the extended attribute data without
  leaf headers
- xfs_buf tracks verified status of merkle tree blocks

Testing:
The patchset is tested with xfstests -g verity on xfs_1k, xfs_4k,
xfs_1k_quota, xfs_4k_quota, ext4_4k, and ext4_4k_quota. With
KMEMLEAK and KASAN enabled. More testing on the way.

Changes from V4:
- Mainly fs-verity changes; removed unnecessary functions
- Replace XFS workqueue with per-sb workqueue created in
  fsverity_set_ops()
- Drop patch with readahead calculation in bytes
Changes from V3:
- redone changes to fs-verity core as previous version had an issue
  on ext4
- add blocks invalidation interface to fs-verity
- move memory ordering primitives out of block status check to fs
  read block function
- add fs-verity verification to iomap instead of general post read
  processing
Changes from V2:
- FS_XFLAG_VERITY extended attribute flag
- Change fs-verity to use Merkle tree blocks instead of expecting
  PAGE references from filesystem
- Change approach in iomap to filesystem provided bio_set and
  submit_io instead of just callouts to filesystem
- Add possibility for xfs_buf allocate more space for fs-verity
  extended attributes
- Make xfs_attr module to copy fs-verity blocks inside the xfs_buf,
  so XFS can get data without leaf headers
- Add Merkle tree removal for error path
- Makae scrub aware of new dinode flag
Changes from V1:
- Added parent pointer patches for easier testing
- Many issues and refactoring points fixed from the V1 review
- Adjusted for recent changes in fs-verity core (folios, non-4k)
- Dropped disabling of large folios
- Completely new fsverity patches (fix, callout, log_blocksize)
- Change approach to verification in iomap to the same one as in
  write path. Callouts to fs instead of direct fs-verity use.
- New XFS workqueue for post read folio verification
- xfs_attr_get() can return underlying xfs_buf
- xfs_bufs are marked with XBF_VERITY_CHECKED to track verified
  blocks

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=fsverity

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=fsverity

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=fsverity
---
Commits in this patchset:
 * xfs: use unsigned ints for non-negative quantities in xfs_attr_remote.c
 * xfs: turn XFS_ATTR3_RMT_BUF_SPACE into a function
 * xfs: create a helper to compute the blockcount of a max sized remote value
 * xfs: minor cleanups of xfs_attr3_rmt_blocks
 * xfs: use an empty transaction to protect xfs_attr_get from deadlocks
 * xfs: add attribute type for fs-verity
 * xfs: do not use xfs_attr3_rmt_hdr for remote verity value blocks
 * xfs: add fs-verity ro-compat flag
 * xfs: add inode on-disk VERITY flag
 * xfs: initialize fs-verity on file open and cleanup on inode destruction
 * xfs: don't allow to enable DAX on fs-verity sealed inode
 * xfs: disable direct read path for fs-verity files
 * xfs: widen flags argument to the xfs_iflags_* helpers
 * xfs: add fs-verity support
 * xfs: create a per-mount shrinker for verity inodes merkle tree blocks
 * xfs: shrink verity blob cache
 * xfs: don't store trailing zeroes of merkle tree blocks
 * xfs: use merkle tree offset as attr hash
 * xfs: don't bother storing merkle tree blocks for zeroed data blocks
 * xfs: add fs-verity ioctls
 * xfs: advertise fs-verity being available on filesystem
 * xfs: check and repair the verity inode flag state
 * xfs: teach online repair to evaluate fsverity xattrs
 * xfs: report verity failures through the health system
 * xfs: make it possible to disable fsverity
 * xfs: enable ro-compat fs-verity flag
---
 Documentation/filesystems/fsverity.rst |   10 
 fs/verity/enable.c                     |   50 ++
 fs/xfs/Makefile                        |    2 
 fs/xfs/libxfs/xfs_ag.h                 |    8 
 fs/xfs/libxfs/xfs_attr.c               |   35 +
 fs/xfs/libxfs/xfs_attr_leaf.c          |    5 
 fs/xfs/libxfs/xfs_attr_remote.c        |  199 +++++-
 fs/xfs/libxfs/xfs_attr_remote.h        |   12 
 fs/xfs/libxfs/xfs_da_format.h          |   55 ++
 fs/xfs/libxfs/xfs_format.h             |   15 
 fs/xfs/libxfs/xfs_fs.h                 |    2 
 fs/xfs/libxfs/xfs_health.h             |    4 
 fs/xfs/libxfs/xfs_inode_buf.c          |    8 
 fs/xfs/libxfs/xfs_inode_util.c         |    2 
 fs/xfs/libxfs/xfs_log_format.h         |    1 
 fs/xfs/libxfs/xfs_ondisk.h             |    5 
 fs/xfs/libxfs/xfs_sb.c                 |    4 
 fs/xfs/libxfs/xfs_shared.h             |    1 
 fs/xfs/libxfs/xfs_verity.c             |   74 ++
 fs/xfs/libxfs/xfs_verity.h             |   14 
 fs/xfs/scrub/attr.c                    |  145 +++++
 fs/xfs/scrub/attr.h                    |    6 
 fs/xfs/scrub/attr_repair.c             |   51 ++
 fs/xfs/scrub/common.c                  |   68 ++
 fs/xfs/scrub/common.h                  |    3 
 fs/xfs/scrub/inode.c                   |    7 
 fs/xfs/scrub/inode_repair.c            |   36 +
 fs/xfs/scrub/reap.c                    |    4 
 fs/xfs/scrub/trace.c                   |    1 
 fs/xfs/scrub/trace.h                   |   31 +
 fs/xfs/xfs_attr_inactive.c             |    2 
 fs/xfs/xfs_file.c                      |   23 +
 fs/xfs/xfs_fsops.c                     |    6 
 fs/xfs/xfs_fsverity.c                  |  997 ++++++++++++++++++++++++++++++++
 fs/xfs/xfs_fsverity.h                  |   32 +
 fs/xfs/xfs_health.c                    |    1 
 fs/xfs/xfs_icache.c                    |    4 
 fs/xfs/xfs_inode.h                     |   16 -
 fs/xfs/xfs_ioctl.c                     |   22 +
 fs/xfs/xfs_iops.c                      |    4 
 fs/xfs/xfs_mount.c                     |   10 
 fs/xfs/xfs_mount.h                     |    8 
 fs/xfs/xfs_super.c                     |   24 +
 fs/xfs/xfs_trace.c                     |    1 
 fs/xfs/xfs_trace.h                     |   85 +++
 include/linux/fsverity.h               |   24 +
 include/trace/events/fsverity.h        |   13 
 include/uapi/linux/fsverity.h          |    1 
 48 files changed, 2048 insertions(+), 83 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_verity.c
 create mode 100644 fs/xfs/libxfs/xfs_verity.h
 create mode 100644 fs/xfs/xfs_fsverity.c
 create mode 100644 fs/xfs/xfs_fsverity.h


