Return-Path: <linux-xfs+bounces-10863-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 615729401EC
	for <lists+linux-xfs@lfdr.de>; Tue, 30 Jul 2024 02:17:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 850EE1C21AB7
	for <lists+linux-xfs@lfdr.de>; Tue, 30 Jul 2024 00:17:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1117010F9;
	Tue, 30 Jul 2024 00:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fDsCJkXP"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E9610E3
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722298619; cv=none; b=tSgOHdrotbomCQhje3DO5X018uOE6XSflYC/2a9aNgWh7TRqyVhOy/QWKxd/0qKUwV1lkMbhhx8yO+ReBFhTCN3UCzZEF3WqFAkkXlRMD40fy93wUHyavUw25cV1eZFEwa7zFUiU4vTD5wWZatDPYWg3LBCr3fVKTROVqnJoc7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722298619; c=relaxed/simple;
	bh=5A4Cxqt0fcwg8QUjD3lMskVK61hrwr2wZIF6nLwPbmY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P+tyyaxLGW/LN8Qr+q3DxyxeAZnISEZaAraT/d17z542BL40M8IrXX2vqY7heFyLbNljN+VRjIpbdXI3+MIKN8JWQ8MQgsFNql8P2awX1IcdorDlr6j62kkM8kzkNga1OWnLzCTg9cJKMV0zFkTh+EgjS4bLF6Cd7LQ8SS9aouo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fDsCJkXP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F941C32786;
	Tue, 30 Jul 2024 00:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722298619;
	bh=5A4Cxqt0fcwg8QUjD3lMskVK61hrwr2wZIF6nLwPbmY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fDsCJkXPZ4I2/xPBnWee5ukNCVq/NluKWBw7iQsbnOGVENxxu9lsb4Tt6Dxv0qcv8
	 VSk4RygARr7NYsxdauHzmqO48N8MFXTAYVK24705aq43d54oQg7OJ0d/CB4gOCDeEc
	 d6sA4Iz2hj8Bq6e6yPjqAjdf7DBZxAjdi7O8RMmaQXYx3z7XlWdthLZlwVMJlxamRu
	 RRWsupimX871kVZ+F+GhPrtcacfuKzWMeFZ3EVirbFlO84J/kokJ/RJv1SNR12z3cd
	 25fOcaSSBvunb79vC2ZFBcD7gzIvJil1WUbrLRbRdnAZ71qLQ4fik0nXtf8DzZXJYj
	 M0nk0L2h/URNw==
Date: Mon, 29 Jul 2024 17:16:58 -0700
Subject: [PATCHSET 02/23] libxfs: sync with 6.10
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>,
 "Darrick J. Wong" <darrick.wong@oracle.com>, Zhang Yi <yi.zhang@huawei.com>,
 =?utf-8?b?5YiY6YCa?= <lyutoon@gmail.com>,
 Ojaswin Mujoo <ojaswin@linux.ibm.com>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Dave Chinner <dchinner@redhat.com>,
 Catherine Hoang <catherine.hoang@oracle.com>,
 John Garry <john.g.garry@oracle.com>,
 Andrey Albershteyn <aalbersh@redhat.com>, Disha Goel <disgoel@linux.ibm.com>,
 Chandan Babu R <chandanbabu@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Mark Tinguely <mark.tinguely@oracle.com>,
 Wengang Wang <wen.gang.wang@oracle.com>, linux-xfs@vger.kernel.org
Message-ID: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
In-Reply-To: <20240730001021.GD6352@frogsfrogsfrogs>
References: <20240730001021.GD6352@frogsfrogsfrogs>
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

Synchronize libxfs with the kernel.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=libxfs-sync-6.10
---
Commits in this patchset:
 * xfs: pass xfs_buf lookup flags to xfs_*read_agi
 * xfs: constify xfs_bmap_is_written_extent
 * xfs: introduce new file range exchange ioctl
 * xfs: create a incompat flag for atomic file mapping exchanges
 * xfs: introduce a file mapping exchange log intent item
 * xfs: create deferred log items for file mapping exchanges
 * xfs: add error injection to test file mapping exchange recovery
 * xfs: condense extended attributes after a mapping exchange operation
 * xfs: condense directories after a mapping exchange operation
 * xfs: condense symbolic links after a mapping exchange operation
 * xfs: make file range exchange support realtime files
 * xfs: capture inode generation numbers in the ondisk exchmaps log item
 * xfs: enable logged file mapping exchange feature
 * xfs: add an explicit owner field to xfs_da_args
 * xfs: use the xfs_da_args owner field to set new dir/attr block owner
 * xfs: validate attr leaf buffer owners
 * xfs: validate attr remote value buffer owners
 * xfs: validate dabtree node buffer owners
 * xfs: validate directory leaf buffer owners
 * xfs: validate explicit directory data buffer owners
 * xfs: validate explicit directory block buffer owners
 * xfs: validate explicit directory free block owners
 * xfs: use atomic extent swapping to fix user file fork data
 * xfs: repair extended attributes
 * xfs: expose xfs_bmap_local_to_extents for online repair
 * xfs: pass the owner to xfs_symlink_write_target
 * xfs: check unused nlink fields in the ondisk inode
 * xfs: try to avoid allocating from sick inode clusters
 * xfs: pin inodes that would otherwise overflow link count
 * xfs: Increase XFS_DEFER_OPS_NR_INODES to 5
 * xfs: make XFS_TRANS_LOWMODE match the other XFS_TRANS_ definitions
 * xfs: refactor realtime inode locking
 * xfs: free RT extents after updating the bmap btree
 * xfs: move RT inode locking out of __xfs_bunmapi
 * xfs: split xfs_mod_freecounter
 * xfs: reinstate RT support in xfs_bmapi_reserve_delalloc
 * xfs: cleanup fdblock/frextent accounting in xfs_bmap_del_extent_delay
 * xfs: support RT inodes in xfs_mod_delalloc
 * xfs: rework splitting of indirect block reservations
 * xfs: stop the steal (of data blocks for RT indirect blocks)
 * xfs: remove XFS_DA_OP_REMOVE
 * xfs: remove XFS_DA_OP_NOTIME
 * xfs: remove xfs_da_args.attr_flags
 * xfs: make attr removal an explicit operation
 * xfs: rearrange xfs_da_args a bit to use less space
 * xfs: attr fork iext must be loaded before calling xfs_attr_is_leaf
 * xfs: fix missing check for invalid attr flags
 * xfs: restructure xfs_attr_complete_op a bit
 * xfs: use helpers to extract xattr op from opflags
 * xfs: enforce one namespace per attribute
 * xfs: rearrange xfs_attr_match parameters
 * xfs: check the flags earlier in xfs_attr_match
 * xfs: move xfs_attr_defer_add to xfs_attr_item.c
 * xfs: create a separate hashname function for extended attributes
 * xfs: add parent pointer support to attribute code
 * xfs: define parent pointer ondisk extended attribute format
 * xfs: allow xattr matching on name and value for parent pointers
 * xfs: create attr log item opcodes and formats for parent pointers
 * xfs: record inode generation in xattr update log intent items
 * xfs: add parent pointer validator functions
 * xfs: extend transaction reservations for parent attributes
 * xfs: create a hashname function for parent pointers
 * xfs: parent pointer attribute creation
 * xfs: add parent attributes to link
 * xfs: add parent attributes to symlink
 * xfs: remove parent pointers in unlink
 * xfs: Add parent pointers to rename
 * xfs: don't return XFS_ATTR_PARENT attributes via listxattr
 * xfs: pass the attr value to put_listent when possible
 * xfs: split out handle management helpers a bit
 * xfs: add parent pointer ioctls
 * xfs: don't remove the attr fork when parent pointers are enabled
 * xfs: add a incompat feature bit for parent pointers
 * xfs: fix unit conversion error in xfs_log_calc_max_attrsetm_res
 * xfs: drop compatibility minimum log size computations for reflink
 * xfs: enable parent pointers
 * xfs: check dirents have parent pointers
 * xfs: remove some boilerplate from xfs_attr_set
 * xfs: make the reserved block permission flag explicit in xfs_attr_set
 * xfs: add raw parent pointer apis to support repair
 * xfs: remove pointless unlocked assertion
 * xfs: split xfs_bmap_add_attrfork into two pieces
 * xfs: actually rebuild the parent pointer xattrs
 * xfs: teach online scrub to find directory tree structure problems
 * xfs: report directory tree corruption in the health information
 * xfs: introduce vectored scrub mode
 * xfs: factor out a xfs_dir_lookup_args helper
 * xfs: factor out a xfs_dir_createname_args helper
 * xfs: factor out a xfs_dir_removename_args helper
 * xfs: factor out a xfs_dir_replace_args helper
 * xfs: refactor dir format helpers
 * xfs: make the seq argument to xfs_bmapi_convert_delalloc() optional
 * xfs: make xfs_bmapi_convert_delalloc() to allocate the target offset
 * xfs: fix error returns from xfs_bmapi_write
 * xfs: remove the unusued tmp_logflags variable in xfs_bmapi_allocate
 * xfs: lift a xfs_valid_startblock into xfs_bmapi_allocate
 * xfs: don't open code XFS_FILBLKS_MIN in xfs_bmapi_write
 * xfs: pass the actual offset and len to allocate to xfs_bmapi_allocate
 * xfs: remove the xfs_iext_peek_prev_extent call in xfs_bmapi_allocate
 * xfs: fix xfs_bmap_add_extent_delay_real for partial conversions
 * xfs: do not allocate the entire delalloc extent in xfs_bmapi_write
 * xfs: use unsigned ints for non-negative quantities in xfs_attr_remote.c
 * xfs: turn XFS_ATTR3_RMT_BUF_SPACE into a function
 * xfs: create a helper to compute the blockcount of a max sized remote value
 * xfs: minor cleanups of xfs_attr3_rmt_blocks
 * xfs: xfs_quota_unreserve_blkres can't fail
 * xfs: simplify iext overflow checking and upgrade
 * xfs: Stop using __maybe_unused in xfs_alloc.c
 * xfs: fix xfs_init_attr_trans not handling explicit operation codes
 * xfs: allow symlinks with short remote targets
 * xfs: Add cond_resched to block unmap range and reflink remap path
 * xfs: make sure sb_fdblocks is non-negative
 * xfs: restrict when we try to align cow fork delalloc to cowextsz hints
 * xfs: allow unlinked symlinks and dirs with zero size
 * xfs: fix direction in XFS_IOC_EXCHANGE_RANGE
---
 db/attr.c                   |    2 
 db/attrset.c                |   11 
 db/iunlink.c                |    4 
 db/metadump.c               |    8 
 db/namei.c                  |   23 -
 include/libxfs.h            |    1 
 include/xfs_inode.h         |   16 +
 include/xfs_mount.h         |    2 
 include/xfs_trace.h         |   15 +
 io/inject.c                 |    1 
 libxfs/Makefile             |    5 
 libxfs/defer_item.c         |  116 ++++
 libxfs/defer_item.h         |   13 
 libxfs/init.c               |    3 
 libxfs/libxfs_api_defs.h    |    6 
 libxfs/libxfs_priv.h        |   75 ++-
 libxfs/util.c               |    6 
 libxfs/xfs_ag.c             |   12 
 libxfs/xfs_ag_resv.c        |   24 -
 libxfs/xfs_ag_resv.h        |    2 
 libxfs/xfs_alloc.c          |   10 
 libxfs/xfs_attr.c           |  272 ++++++---
 libxfs/xfs_attr.h           |   49 +-
 libxfs/xfs_attr_leaf.c      |  154 ++++-
 libxfs/xfs_attr_leaf.h      |    4 
 libxfs/xfs_attr_remote.c    |  102 ++--
 libxfs/xfs_attr_remote.h    |    8 
 libxfs/xfs_attr_sf.h        |    1 
 libxfs/xfs_bmap.c           |  409 ++++++++------
 libxfs/xfs_bmap.h           |   13 
 libxfs/xfs_da_btree.c       |  189 ++++++-
 libxfs/xfs_da_btree.h       |   34 +
 libxfs/xfs_da_format.h      |   37 +
 libxfs/xfs_defer.c          |   12 
 libxfs/xfs_defer.h          |   10 
 libxfs/xfs_dir2.c           |  283 +++++-----
 libxfs/xfs_dir2.h           |   23 +
 libxfs/xfs_dir2_block.c     |   42 +
 libxfs/xfs_dir2_data.c      |   18 -
 libxfs/xfs_dir2_leaf.c      |  100 +++
 libxfs/xfs_dir2_node.c      |   44 +-
 libxfs/xfs_dir2_priv.h      |   15 -
 libxfs/xfs_errortag.h       |    4 
 libxfs/xfs_exchmaps.c       | 1232 +++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_exchmaps.h       |  124 ++++
 libxfs/xfs_format.h         |   34 +
 libxfs/xfs_fs.h             |  158 +++++-
 libxfs/xfs_health.h         |    4 
 libxfs/xfs_ialloc.c         |   56 ++
 libxfs/xfs_ialloc.h         |    5 
 libxfs/xfs_ialloc_btree.c   |    4 
 libxfs/xfs_inode_buf.c      |   55 ++
 libxfs/xfs_inode_fork.c     |   63 +-
 libxfs/xfs_inode_fork.h     |    6 
 libxfs/xfs_log_format.h     |   89 +++
 libxfs/xfs_log_rlimit.c     |   46 ++
 libxfs/xfs_ondisk.h         |    6 
 libxfs/xfs_parent.c         |  376 +++++++++++++
 libxfs/xfs_parent.h         |  110 ++++
 libxfs/xfs_rtbitmap.c       |   57 ++
 libxfs/xfs_rtbitmap.h       |   17 +
 libxfs/xfs_sb.c             |   15 -
 libxfs/xfs_shared.h         |    6 
 libxfs/xfs_symlink_remote.c |   54 ++
 libxfs/xfs_symlink_remote.h |    8 
 libxfs/xfs_trans_resv.c     |  324 +++++++++--
 libxfs/xfs_trans_space.c    |  121 ++++
 libxfs/xfs_trans_space.h    |   29 +
 mkfs/proto.c                |    3 
 repair/attr_repair.c        |    7 
 repair/phase6.c             |   35 +
 71 files changed, 4349 insertions(+), 873 deletions(-)
 create mode 100644 libxfs/xfs_exchmaps.c
 create mode 100644 libxfs/xfs_exchmaps.h
 create mode 100644 libxfs/xfs_parent.c
 create mode 100644 libxfs/xfs_parent.h
 create mode 100644 libxfs/xfs_trans_space.c


