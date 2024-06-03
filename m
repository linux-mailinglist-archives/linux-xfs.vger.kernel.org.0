Return-Path: <linux-xfs+bounces-8860-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 92EA38D88E2
	for <lists+linux-xfs@lfdr.de>; Mon,  3 Jun 2024 20:49:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BEA26B244F0
	for <lists+linux-xfs@lfdr.de>; Mon,  3 Jun 2024 18:49:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2CEF137C31;
	Mon,  3 Jun 2024 18:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F2qDmEPP"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA1D137902
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 18:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717440551; cv=none; b=YlD2lw8Q9B1G+I29CnM8YqYlFaFxn1uBJyRxdkBS+4vzY6eKF7YLse7Lu7ZpRsNeQYjugBjlirXw0YUGpbWggSKxx6mgujvUFghuM3vIqLbn9k1DKN0EhSRlmY+JPxR534Bkq1PHZ5wfeEwCWF4geTUSsL8Yh8gyvBvcbBbnbsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717440551; c=relaxed/simple;
	bh=XGXvZVRpnGZLkZwV1vyN2OdMkF1drXwyBK27qktqb50=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AZsKnIgWVEdG1licgK66a7xcVLghwvatxX5r84EUVk8v4ywUUnq2tyL46lyuVe1sgrZD5DKD4MPX78EzHIwAThrXKnHpYX+oc8q5g4C7TPcSLFZJFMSc+sYXDamwDbH+MUptGDicTFfwiPVLgp3sV+1m9bOeIIhnOI6kOrmZL50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F2qDmEPP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34568C2BD10;
	Mon,  3 Jun 2024 18:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717440551;
	bh=XGXvZVRpnGZLkZwV1vyN2OdMkF1drXwyBK27qktqb50=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=F2qDmEPPPXww59yxKMKiPsepCgrXHsMWOF00cL6vM18ytgr/uBG6UVrfTQMfNFxL2
	 eIMIJliP+EKDTCSDV7pE+8kZrm89YLHjiNLemQw6/5qFW7CXE0DMbbknZ1+1kUOqpN
	 yP4AFjBw2kKt8fiNHdk8zg9BeD+qj8EJ3qnqdQG/n7sRxE0poIIFQnAKckzTVtUtN4
	 l8vQfBkINTwJI5f2x4rjcDZwyg6F/DycAN+794Dhz7ZmpSR5FFeV5S52DSTZAhPqfz
	 ip2TsMHdD8uQgiB6p0NGoi7FAyNX8DnE1jSHdHmOVDnTjRYPAW5I4HwQLoJK0QJfeR
	 BFdD8d976tYKg==
Date: Mon, 03 Jun 2024 11:49:10 -0700
Subject: [PATCHSET v30.5 02/10] libxfs: sync with 6.9
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Carlos Maiolino <cmaiolino@redhat.com>,
 Chandan Babu R <chandanbabu@kernel.org>, Christoph Hellwig <hch@lst.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Gao Xiang <hsiangkao@linux.alibaba.com>, Dave Chinner <dchinner@redhat.com>,
 Dan Carpenter <dan.carpenter@linaro.org>, linux-xfs@vger.kernel.org
Message-ID: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
In-Reply-To: <20240603184512.GD52987@frogsfrogsfrogs>
References: <20240603184512.GD52987@frogsfrogsfrogs>
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
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=libxfs-sync-6.9
---
Commits in this patchset:
 * xfs: convert kmem_zalloc() to kzalloc()
 * xfs: convert kmem_alloc() to kmalloc()
 * xfs: convert remaining kmem_free() to kfree()
 * xfs: use __GFP_NOLOCKDEP instead of GFP_NOFS
 * xfs: use GFP_KERNEL in pure transaction contexts
 * xfs: clean up remaining GFP_NOFS users
 * xfs: use xfs_defer_alloc a bit more
 * xfs: Replace xfs_isilocked with xfs_assert_ilocked
 * xfs: create a static name for the dot entry too
 * xfs: create a predicate to determine if two xfs_names are the same
 * xfs: create a macro for decoding ftypes in tracepoints
 * xfs: report the health of quota counts
 * xfs: implement live quotacheck inode scan
 * xfs: report health of inode link counts
 * xfs: teach scrub to check file nlinks
 * xfs: separate the marking of sick and checked metadata
 * xfs: report fs corruption errors to the health tracking system
 * xfs: report ag header corruption errors to the health tracking system
 * xfs: report block map corruption errors to the health tracking system
 * xfs: report btree block corruption errors to the health system
 * xfs: report dir/attr block corruption errors to the health system
 * xfs: report inode corruption errors to the health system
 * xfs: report realtime metadata corruption errors to the health system
 * xfs: report XFS_IS_CORRUPT errors to the health system
 * xfs: add secondary and indirect classes to the health tracking system
 * xfs: remember sick inodes that get inactivated
 * xfs: update health status if we get a clean bill of health
 * xfs: consolidate btree block freeing tracepoints
 * xfs: consolidate btree block allocation tracepoints
 * xfs: set the btree cursor bc_ops in xfs_btree_alloc_cursor
 * xfs: drop XFS_BTREE_CRC_BLOCKS
 * xfs: encode the btree geometry flags in the btree ops structure
 * xfs: remove bc_ino.flags
 * xfs: consolidate the xfs_alloc_lookup_* helpers
 * xfs: turn the allocbt cursor active field into a btree flag
 * xfs: extern some btree ops structures
 * xfs: initialize btree blocks using btree_ops structure
 * xfs: rename btree block/buffer init functions
 * xfs: btree convert xfs_btree_init_block to xfs_btree_init_buf calls
 * xfs: remove the unnecessary daddr paramter to _init_block
 * xfs: set btree block buffer ops in _init_buf
 * xfs: move lru refs to the btree ops structure
 * xfs: move the btree stats offset into struct btree_ops
 * xfs: factor out a xfs_btree_owner helper
 * xfs: factor out a btree block owner check
 * xfs: store the btree pointer length in struct xfs_btree_ops
 * xfs: split out a btree type from the btree ops geometry flags
 * xfs: split the per-btree union in struct xfs_btree_cur
 * xfs: create predicate to determine if cursor is at inode root level
 * xfs: move comment about two 2 keys per pointer in the rmap btree
 * xfs: add a xfs_btree_init_ptr_from_cur
 * xfs: don't override bc_ops for staging btrees
 * xfs: fold xfs_allocbt_init_common into xfs_allocbt_init_cursor
 * xfs: remove xfs_allocbt_stage_cursor
 * xfs: fold xfs_inobt_init_common into xfs_inobt_init_cursor
 * xfs: remove xfs_inobt_stage_cursor
 * xfs: fold xfs_refcountbt_init_common into xfs_refcountbt_init_cursor
 * xfs: remove xfs_refcountbt_stage_cursor
 * xfs: fold xfs_rmapbt_init_common into xfs_rmapbt_init_cursor
 * xfs: remove xfs_rmapbt_stage_cursor
 * xfs: make full use of xfs_btree_stage_ifakeroot in xfs_bmbt_stage_cursor
 * xfs: make staging file forks explicit
 * xfs: fold xfs_bmbt_init_common into xfs_bmbt_init_cursor
 * xfs: remove xfs_bmbt_stage_cursor
 * xfs: split the agf_roots and agf_levels arrays
 * xfs: add a name field to struct xfs_btree_ops
 * xfs: add a sick_mask to struct xfs_btree_ops
 * xfs: split xfs_allocbt_init_cursor
 * xfs: remove xfs_inobt_cur
 * xfs: remove the btnum argument to xfs_inobt_count_blocks
 * xfs: split xfs_inobt_insert_sprec
 * xfs: split xfs_inobt_init_cursor
 * xfs: pass a 'bool is_finobt' to xfs_inobt_insert
 * xfs: remove xfs_btnum_t
 * xfs: simplify xfs_btree_check_sblock_siblings
 * xfs: simplify xfs_btree_check_lblock_siblings
 * xfs: open code xfs_btree_check_lptr in xfs_bmap_btree_to_extents
 * xfs: consolidate btree ptr checking
 * xfs: misc cleanups for __xfs_btree_check_sblock
 * xfs: remove the crc variable in __xfs_btree_check_lblock
 * xfs: tighten up validation of root block in inode forks
 * xfs: consolidate btree block verification
 * xfs: rename btree helpers that depends on the block number representation
 * xfs: factor out a __xfs_btree_check_lblock_hdr helper
 * xfs: remove xfs_btree_reada_bufl
 * xfs: remove xfs_btree_reada_bufs
 * xfs: move and rename xfs_btree_read_bufl
 * libxfs: teach buftargs to maintain their own buffer hashtable
 * libxfs: add xfile support
 * libxfs: partition memfd files to avoid using too many fds
 * xfs: teach buftargs to maintain their own buffer hashtable
 * libxfs: support in-memory buffer cache targets
 * xfs: add a xfs_btree_ptrs_equal helper
 * xfs: support in-memory btrees
 * xfs: launder in-memory btree buffers before transaction commit
 * xfs: create a helper to decide if a file mapping targets the rt volume
 * xfs: repair the rmapbt
 * xfs: create a shadow rmap btree during rmap repair
 * xfs: hook live rmap operations during a repair operation
 * xfs: clean up bmap log intent item tracepoint callsites
 * xfs: move xfs_bmap_defer_add to xfs_bmap_item.c
 * xfs: fix xfs_bunmapi to allow unmapping of partial rt extents
 * xfs: add a realtime flag to the bmap update log redo items
 * xfs: support deferred bmap updates on the attr fork
 * xfs: xfs_bmap_finish_one should map unwritten extents properly
 * xfs: move xfs_symlink_remote.c declarations to xfs_symlink_remote.h
 * xfs: move remote symlink target read function to libxfs
 * xfs: move symlink target write function to libxfs
 * xfs: xfs_btree_bload_prep_block() should use __GFP_NOFAIL
 * xfs: shrink failure needs to hold AGI buffer
 * xfs: allow sunit mount option to repair bad primary sb stripe values
---
 copy/xfs_copy.c             |    4 
 db/agf.c                    |   28 -
 db/bmap_inflate.c           |    8 
 db/check.c                  |   14 -
 db/freesp.c                 |    8 
 db/metadump.c               |   12 
 include/kmem.h              |    5 
 include/libxfs.h            |    4 
 include/xfs_mount.h         |    5 
 include/xfs_trace.h         |   17 -
 include/xfs_trans.h         |    1 
 libxfs/Makefile             |    9 
 libxfs/buf_mem.c            |  313 ++++++++++++
 libxfs/buf_mem.h            |   30 +
 libxfs/defer_item.c         |   15 +
 libxfs/defer_item.h         |   13 +
 libxfs/init.c               |   52 +-
 libxfs/libxfs_api_defs.h    |   10 
 libxfs/libxfs_io.h          |   42 +-
 libxfs/libxfs_priv.h        |   19 -
 libxfs/logitem.c            |    2 
 libxfs/rdwr.c               |   86 ++-
 libxfs/trans.c              |   40 ++
 libxfs/util.c               |   10 
 libxfs/xfile.c              |  393 +++++++++++++++
 libxfs/xfile.h              |   34 +
 libxfs/xfs_ag.c             |   79 ++-
 libxfs/xfs_ag.h             |   18 -
 libxfs/xfs_alloc.c          |  258 ++++++----
 libxfs/xfs_alloc_btree.c    |  191 ++++---
 libxfs/xfs_alloc_btree.h    |   10 
 libxfs/xfs_attr.c           |    5 
 libxfs/xfs_attr_leaf.c      |   22 +
 libxfs/xfs_attr_remote.c    |   37 +
 libxfs/xfs_bmap.c           |  365 ++++++++++----
 libxfs/xfs_bmap.h           |   19 +
 libxfs/xfs_bmap_btree.c     |  152 ++----
 libxfs/xfs_bmap_btree.h     |    5 
 libxfs/xfs_btree.c          | 1097 ++++++++++++++++++++++++++-----------------
 libxfs/xfs_btree.h          |  274 +++++------
 libxfs/xfs_btree_mem.c      |  346 ++++++++++++++
 libxfs/xfs_btree_mem.h      |   75 +++
 libxfs/xfs_btree_staging.c  |  133 +----
 libxfs/xfs_btree_staging.h  |   10 
 libxfs/xfs_da_btree.c       |   59 ++
 libxfs/xfs_da_format.h      |   11 
 libxfs/xfs_defer.c          |   25 -
 libxfs/xfs_dir2.c           |   59 +-
 libxfs/xfs_dir2.h           |   13 +
 libxfs/xfs_dir2_block.c     |    8 
 libxfs/xfs_dir2_data.c      |    3 
 libxfs/xfs_dir2_leaf.c      |    3 
 libxfs/xfs_dir2_node.c      |    7 
 libxfs/xfs_dir2_sf.c        |   16 -
 libxfs/xfs_format.h         |   21 -
 libxfs/xfs_fs.h             |    8 
 libxfs/xfs_health.h         |   95 ++++
 libxfs/xfs_ialloc.c         |  232 ++++++---
 libxfs/xfs_ialloc_btree.c   |  173 +++----
 libxfs/xfs_ialloc_btree.h   |   11 
 libxfs/xfs_iext_tree.c      |   26 +
 libxfs/xfs_inode_buf.c      |   12 
 libxfs/xfs_inode_fork.c     |   49 +-
 libxfs/xfs_inode_fork.h     |    1 
 libxfs/xfs_log_format.h     |    4 
 libxfs/xfs_refcount.c       |   69 ++-
 libxfs/xfs_refcount_btree.c |   78 +--
 libxfs/xfs_refcount_btree.h |    2 
 libxfs/xfs_rmap.c           |  284 +++++++++--
 libxfs/xfs_rmap.h           |   31 +
 libxfs/xfs_rmap_btree.c     |  240 +++++++--
 libxfs/xfs_rmap_btree.h     |    8 
 libxfs/xfs_rtbitmap.c       |   11 
 libxfs/xfs_sb.c             |   42 +-
 libxfs/xfs_sb.h             |    5 
 libxfs/xfs_shared.h         |   67 ++-
 libxfs/xfs_symlink_remote.c |  155 ++++++
 libxfs/xfs_symlink_remote.h |   26 +
 libxfs/xfs_trans_inode.c    |    6 
 libxfs/xfs_types.h          |   26 -
 logprint/log_misc.c         |    8 
 logprint/log_print_all.c    |    8 
 mkfs/xfs_mkfs.c             |    8 
 repair/agbtree.c            |   28 +
 repair/bmap_repair.c        |    4 
 repair/bulkload.c           |    2 
 repair/phase5.c             |   28 +
 repair/phase6.c             |    4 
 repair/prefetch.c           |   12 
 repair/prefetch.h           |    1 
 repair/progress.c           |   14 -
 repair/progress.h           |    2 
 repair/scan.c               |   18 -
 repair/xfs_repair.c         |   47 +-
 94 files changed, 4425 insertions(+), 1915 deletions(-)
 create mode 100644 libxfs/buf_mem.c
 create mode 100644 libxfs/buf_mem.h
 create mode 100644 libxfs/defer_item.h
 create mode 100644 libxfs/xfile.c
 create mode 100644 libxfs/xfile.h
 create mode 100644 libxfs/xfs_btree_mem.c
 create mode 100644 libxfs/xfs_btree_mem.h
 create mode 100644 libxfs/xfs_symlink_remote.h


