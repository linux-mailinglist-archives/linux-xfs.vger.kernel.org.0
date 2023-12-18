Return-Path: <linux-xfs+bounces-900-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CE0A28166E8
	for <lists+linux-xfs@lfdr.de>; Mon, 18 Dec 2023 07:54:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3915EB20BFB
	for <lists+linux-xfs@lfdr.de>; Mon, 18 Dec 2023 06:54:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6D6DDF45;
	Mon, 18 Dec 2023 06:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ogFP2k4+"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAEDFD51B;
	Mon, 18 Dec 2023 06:54:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72881C433CC;
	Mon, 18 Dec 2023 06:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702882454;
	bh=sVQXNCB7xxh4g/T7lVDJkGAGxVYD8lR69ueBWfCzB4U=;
	h=From:To:Cc:Subject:Date:From;
	b=ogFP2k4+rgLtctoHHeZ+Axtu2SOURqcGUN5k/QNPm17946IG4Z6vbCbHoBgVvuDb5
	 Eg6UlZ09ZvmuP3Je98ecWZoTaYf4/LygbB10MCCIzacejlSuwqb4WE5+qFsHpSAzr4
	 4zPF6wx3AS/OTXe60EVBg5g3hFfwmDDNyi7zbWIoAXF41oD1siRz8dZoUsA7S1r4R0
	 HV90v3VzZW4eyIA2Iwr6hyOqsgnfIExVlo3HdWYIgrRxwZTlofnQroxVOS95GRwvRV
	 T58e93YN4BusvgaMS7sO/cKl/vb0b7P/ftvsizAdnvPHr84/xepRliB7fvtmqb9JwJ
	 z8hkkFmUXJ6Dg==
User-agent: mu4e 1.8.10; emacs 27.1
From: Chandan Babu R <chandanbabu@kernel.org>
To: chandanbabu@kernel.org
Cc: bagasdotme@gmail.com,bodonnel@redhat.com,cmaiolino@redhat.com,dan.j.williams@intel.com,david@fromorbit.com,dchinner@redhat.com,djwong@kernel.org,glider@google.com,hch@lst.de,linux-fsdevel@vger.kernel.org,linux-xfs@vger.kernel.org,ruansy.fnst@fujitsu.com,sandeen@redhat.com,zhangjiachen.jaycee@bytedance.com,zhangtianci.1997@bytedance.com
Subject: [ANNOUNCE] xfs-linux: for-next updated to 98bdbf60cca8
Date: Mon, 18 Dec 2023 12:22:27 +0530
Message-ID: <87ttogngq4.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Hi folks,

The for-next branch of the xfs-linux repository at:

	https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

98bdbf60cca8 Merge tag 'repair-quota-6.8_2023-12-15' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-6.8-mergeB

101 new commits:

Bagas Sanjaya (1):
      [011f129fee4b] Documentation: xfs: consolidate XFS docs into its own subdirectory

Chandan Babu R (13):
      [6b4ffe97e913] Merge tag 'reconstruct-defer-work-6.8_2023-12-06' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-6.8-mergeA
      [34d386666819] Merge tag 'reconstruct-defer-cleanups-6.8_2023-12-06' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-6.8-mergeA
      [47c460efc467] Merge tag 'fix-rtmount-overflows-6.8_2023-12-06' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-6.8-mergeA
      [9f334526ee0a] Merge tag 'defer-elide-create-done-6.8_2023-12-06' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-6.8-mergeA
      [dec0224bae8b] Merge tag 'scrub-livelock-prevention-6.8_2023-12-06' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-6.8-mergeA
      [49391d1349da] Merge tag 'repair-auto-reap-space-reservations-6.8_2023-12-06' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-6.8-mergeA
      [19b366dae1c1] Merge tag 'fix-growfsrt-failures-6.8_2023-12-13' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-6.8-mergeB
      [5e60ca3fada4] Merge tag 'repair-prep-for-bulk-loading-6.8_2023-12-15' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-6.8-mergeB
      [6e1d7b894129] Merge tag 'repair-ag-btrees-6.8_2023-12-15' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-6.8-mergeB
      [7b63ce86f9d4] Merge tag 'repair-inodes-6.8_2023-12-15' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-6.8-mergeB
      [98e63b91cd43] Merge tag 'repair-file-mappings-6.8_2023-12-15' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-6.8-mergeB
      [5bb4ad95c1c6] Merge tag 'repair-rtbitmap-6.8_2023-12-15' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-6.8-mergeB
      [98bdbf60cca8] Merge tag 'repair-quota-6.8_2023-12-15' of https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux into xfs-6.8-mergeB

Christoph Hellwig (11):
      [64f08b152a3b] xfs: clean up the XFS_IOC_{GS}ET_RESBLKS handler
      [c2c2620de757] xfs: clean up the XFS_IOC_FSCOUNTS handler
      [646ddf0c4df5] xfs: clean up the xfs_reserve_blocks interface
      [08e54ca42d6a] xfs: clean up xfs_fsops.h
      [c12c50393c1f] xfs: use static_assert to check struct sizes and offsets
      [18793e050504] xfs: move xfs_ondisk.h to libxfs/
      [c00eebd09e95] xfs: consolidate the xfs_attr_defer_* helpers
      [2e8f7b6f4a15] xfs: move xfs_attr_defer_type up in xfs_attr_item.c
      [7f2f7531e0d4] xfs: store an ops pointer in struct xfs_defer_pending
      [dc22af643682] xfs: pass the defer ops instead of type to xfs_defer_start_recovery
      [603ce8ab1209] xfs: pass the defer ops directly to xfs_defer_add

Darrick J. Wong (70):
      [07bcbdf020c9] xfs: don't leak recovered attri intent items
      [03f7767c9f61] xfs: use xfs_defer_pending objects to recover intent items
      [a050acdfa800] xfs: pass the xfs_defer_pending object to iop_recover
      [deb4cd8ba87f] xfs: transfer recovered intent item ownership in ->iop_recover
      [e70fb328d527] xfs: recreate work items when recovering intent items
      [a51489e140d3] xfs: dump the recovered xattri log item if corruption happens
      [172538beba82] xfs: don't set XFS_TRANS_HAS_INTENT_DONE when there's no ATTRD log item
      [e5f1a5146ec3] xfs: use xfs_defer_finish_one to finish recovered work items
      [3dd75c8db1c1] xfs: hoist intent done flag setting to ->finish_item callsite
      [db7ccc0bac2a] xfs: move ->iop_recover to xfs_defer_op_type
      [e6e5299fcbf0] xfs: collapse the ->finish_item helpers
      [f3fd7f6fce1c] xfs: hoist ->create_intent boilerplate to its callsite
      [bd3a88f6b71c] xfs: use xfs_defer_create_done for the relogging operation
      [3e0958be2156] xfs: clean out XFS_LI_DIRTY setting boilerplate from ->iop_relog
      [b28852a5bd08] xfs: hoist xfs_trans_add_item calls to defer ops functions
      [8a9aa763e17c] xfs: collapse the ->create_done functions
      [a6a38f309afc] xfs: make rextslog computation consistent with mkfs
      [cf8f0e6c1429] xfs: fix 32-bit truncation in xfs_compute_rextslog
      [94da54d582e6] xfs: document what LARP means
      [a49c708f9a44] xfs: move ->iop_relog to struct xfs_defer_op_type
      [e14293803f4e] xfs: don't allow overly small or large realtime volumes
      [9c07bca793b4] xfs: elide ->create_done calls for unlogged deferred work
      [3f113c2739b1] xfs: make xchk_iget safer in the presence of corrupt inode btrees
      [6b126139401a] xfs: don't append work items to logged xfs_defer_pending objects
      [4dffb2cbb483] xfs: allow pausing of pending deferred work items
      [4c88fef3af4a] xfs: remove __xfs_free_extent_later
      [e3042be36c34] xfs: automatic freeing of freshly allocated unwritten space
      [4c8ecd1cfdd0] xfs: remove unused fields from struct xbtree_ifakeroot
      [be4084176304] xfs: implement block reservation accounting for btrees we're staging
      [6bb9ea8ecd2c] xfs: log EFIs for all btree blocks being used to stage a btree
      [3f3cec031099] xfs: force small EFIs for reaping btree extents
      [578bd4ce7100] xfs: recompute growfsrtfree transaction reservation while growing rt volume
      [c0e37f07d2bd] xfs: fix an off-by-one error in xreap_agextent_binval
      [13ae04d8d452] xfs: force all buffers to be written during btree bulk load
      [c1e0f8e6fb06] xfs: set XBF_DONE on newly formatted btree block that are ready for writing
      [26de64629d8b] xfs: read leaf blocks when computing keys for bulkloading into node blocks
      [a20ffa7d9f86] xfs: add debug knobs to control btree bulk load slack factors
      [6dfeb0c2ecde] xfs: move btree bulkload record initialization to ->get_record implementations
      [e069d549705e] xfs: constrain dirty buffers while formatting a staged btree
      [6ece924b9522] xfs: create separate structures and code for u32 bitmaps
      [0f08af0f9f3e] xfs: move the per-AG datatype bitmaps to separate files
      [efb43b355457] xfs: roll the scrub transaction after completing a repair
      [8bd0bf570bd7] xfs: remove trivial bnobt/inobt scrub helpers
      [4bdfd7d15747] xfs: repair free space btrees
      [dbfbf3bdf639] xfs: repair inode btrees
      [d5aa62de1efe] xfs: disable online repair quota helpers when quota not enabled
      [9099cd38002f] xfs: repair refcount btrees
      [259ba1d36f55] xfs: try to attach dquots to files before repairing them
      [576d30ecb620] xfs: add missing nrext64 inode flag check to scrub
      [6b5d91778021] xfs: dont cast to char * for XFS_DFORK_*PTR macros
      [d9041681dd2f] xfs: set inode sick state flags when we zap either ondisk fork
      [2d295fe65776] xfs: repair inode records
      [e744cef20605] xfs: zap broken inode forks
      [6c7289528d3c] xfs: abort directory parent scrub scans if we encounter a zapped directory
      [66da11280f7e] xfs: reintroduce reaping of file metadata blocks to xrep_reap_extents
      [c3a22c2e4b45] xfs: skip the rmapbt search on an empty attr fork unless we know it was zapped
      [8f71bede8efd] xfs: repair inode fork block mapping data structures
      [48a72f60861f] xfs: refactor repair forcing tests into a repair.c helper
      [d12bf8bac87a] xfs: create a ranged query function for refcount btrees
      [dbbdbd008632] xfs: repair problems in CoW forks
      [41991cf29891] xfs: check rt bitmap file geometry more thoroughly
      [04f0c3269b41] xfs: check rt summary file geometry more thoroughly
      [20cc0d398e89] xfs: always check the rtbitmap and rtsummary files
      [5a8e07e79972] xfs: repair the inode core and forks of a metadata inode
      [a59eb5fc21b2] xfs: create a new inode fork block unmap helper
      [ffd37b22bd2b] xfs: online repair of realtime bitmaps
      [7d1f0e167a06] xfs: check the ondisk space mapping behind a dquot
      [774b5c0a5152] xfs: check dquot resource timers
      [21d7500929c8] xfs: improve dquot iteration for scrub
      [a5b91555403e] xfs: repair quotas

Dave Chinner (1):
      [0573676fdde7] xfs: initialise di_crc in xfs_log_dinode

Eric Sandeen (1):
      [84712492e6da] xfs: short circuit xfs_growfs_data_private() if delta is zero

Jiachen Zhang (1):
      [e6af9c98cbf0] xfs: ensure logflagsp is initialized in xfs_bmap_del_extent_real

Shiyang Ruan (1):
      [fa422b353d21] mm, pmem, xfs: Introduce MF_MEM_PRE_REMOVE for unbind

Zhang Tianci (2):
      [5759aa4f9560] xfs: update dir3 leaf block metadata after swap
      [fd45ddb9dd60] xfs: extract xfs_da_buf_copy() helper function

Code Diffstat:

 Documentation/filesystems/index.rst                                  |    5 +-
 Documentation/filesystems/xfs/index.rst                              |   14 +
 Documentation/filesystems/{ => xfs}/xfs-delayed-logging-design.rst   |    0
 Documentation/filesystems/{ => xfs}/xfs-maintainer-entry-profile.rst |    0
 Documentation/filesystems/{ => xfs}/xfs-online-fsck-design.rst       |    2 +-
 Documentation/filesystems/{ => xfs}/xfs-self-describing-metadata.rst |    0
 Documentation/maintainer/maintainer-entry-profile.rst                |    2 +-
 MAINTAINERS                                                          |    4 +-
 drivers/dax/super.c                                                  |    3 +-
 fs/xfs/Makefile                                                      |   21 +-
 fs/xfs/libxfs/xfs_ag.c                                               |    2 +-
 fs/xfs/libxfs/xfs_ag.h                                               |   10 +
 fs/xfs/libxfs/xfs_ag_resv.c                                          |    2 +
 fs/xfs/libxfs/xfs_alloc.c                                            |  116 +++++-
 fs/xfs/libxfs/xfs_alloc.h                                            |   24 +-
 fs/xfs/libxfs/xfs_alloc_btree.c                                      |   13 +-
 fs/xfs/libxfs/xfs_attr.c                                             |   92 ++---
 fs/xfs/libxfs/xfs_attr_leaf.c                                        |   25 +-
 fs/xfs/libxfs/xfs_attr_leaf.h                                        |    3 +-
 fs/xfs/libxfs/xfs_bmap.c                                             |  142 +++++---
 fs/xfs/libxfs/xfs_bmap.h                                             |    7 +-
 fs/xfs/libxfs/xfs_bmap_btree.c                                       |  123 +++++--
 fs/xfs/libxfs/xfs_bmap_btree.h                                       |    5 +
 fs/xfs/libxfs/xfs_btree.c                                            |   28 +-
 fs/xfs/libxfs/xfs_btree.h                                            |    5 +
 fs/xfs/libxfs/xfs_btree_staging.c                                    |   89 +++--
 fs/xfs/libxfs/xfs_btree_staging.h                                    |   33 +-
 fs/xfs/libxfs/xfs_da_btree.c                                         |   69 ++--
 fs/xfs/libxfs/xfs_da_btree.h                                         |    2 +
 fs/xfs/libxfs/xfs_defer.c                                            |  456 +++++++++++++++++++-----
 fs/xfs/libxfs/xfs_defer.h                                            |   59 ++-
 fs/xfs/libxfs/xfs_dir2_priv.h                                        |    3 +-
 fs/xfs/libxfs/xfs_dir2_sf.c                                          |   13 +-
 fs/xfs/libxfs/xfs_format.h                                           |    5 +-
 fs/xfs/libxfs/xfs_health.h                                           |   10 +
 fs/xfs/libxfs/xfs_ialloc.c                                           |   36 +-
 fs/xfs/libxfs/xfs_ialloc.h                                           |    3 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c                                     |    2 +-
 fs/xfs/libxfs/xfs_iext_tree.c                                        |   23 +-
 fs/xfs/libxfs/xfs_inode_fork.c                                       |   34 +-
 fs/xfs/libxfs/xfs_inode_fork.h                                       |    3 +
 fs/xfs/libxfs/xfs_log_recover.h                                      |    8 +
 fs/xfs/{ => libxfs}/xfs_ondisk.h                                     |    8 +-
 fs/xfs/libxfs/xfs_refcount.c                                         |   57 ++-
 fs/xfs/libxfs/xfs_refcount.h                                         |   12 +-
 fs/xfs/libxfs/xfs_refcount_btree.c                                   |   15 +-
 fs/xfs/libxfs/xfs_rmap.c                                             |    2 +-
 fs/xfs/libxfs/xfs_rtbitmap.c                                         |   14 +
 fs/xfs/libxfs/xfs_rtbitmap.h                                         |   16 +
 fs/xfs/libxfs/xfs_sb.c                                               |    6 +-
 fs/xfs/libxfs/xfs_shared.h                                           |    2 +-
 fs/xfs/libxfs/xfs_symlink_remote.c                                   |    8 +-
 fs/xfs/libxfs/xfs_types.h                                            |    7 +
 fs/xfs/scrub/agb_bitmap.c                                            |  103 ++++++
 fs/xfs/scrub/agb_bitmap.h                                            |   68 ++++
 fs/xfs/scrub/agheader_repair.c                                       |   19 +-
 fs/xfs/scrub/alloc.c                                                 |   52 +--
 fs/xfs/scrub/alloc_repair.c                                          |  934 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/bitmap.c                                                |  509 +++++++++++++++++---------
 fs/xfs/scrub/bitmap.h                                                |  111 ++----
 fs/xfs/scrub/bmap.c                                                  |  162 +++++++--
 fs/xfs/scrub/bmap_repair.c                                           |  867 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/common.c                                                |   35 +-
 fs/xfs/scrub/common.h                                                |   56 +++
 fs/xfs/scrub/cow_repair.c                                            |  614 ++++++++++++++++++++++++++++++++
 fs/xfs/scrub/dir.c                                                   |   42 ++-
 fs/xfs/scrub/dqiterate.c                                             |  211 +++++++++++
 fs/xfs/scrub/fsb_bitmap.h                                            |   37 ++
 fs/xfs/scrub/health.c                                                |   32 ++
 fs/xfs/scrub/health.h                                                |    2 +
 fs/xfs/scrub/ialloc.c                                                |   39 +-
 fs/xfs/scrub/ialloc_repair.c                                         |  884 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/inode.c                                                 |   20 +-
 fs/xfs/scrub/inode_repair.c                                          | 1525 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/newbt.c                                                 |  559 +++++++++++++++++++++++++++++
 fs/xfs/scrub/newbt.h                                                 |   68 ++++
 fs/xfs/scrub/off_bitmap.h                                            |   37 ++
 fs/xfs/scrub/parent.c                                                |   17 +
 fs/xfs/scrub/quota.c                                                 |  107 +++++-
 fs/xfs/scrub/quota.h                                                 |   36 ++
 fs/xfs/scrub/quota_repair.c                                          |  575 ++++++++++++++++++++++++++++++
 fs/xfs/scrub/reap.c                                                  |  168 ++++++++-
 fs/xfs/scrub/reap.h                                                  |    5 +
 fs/xfs/scrub/refcount.c                                              |    2 +-
 fs/xfs/scrub/refcount_repair.c                                       |  794 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.c                                                |  391 +++++++++++++++++++-
 fs/xfs/scrub/repair.h                                                |   99 +++++
 fs/xfs/scrub/rmap.c                                                  |    1 +
 fs/xfs/scrub/rtbitmap.c                                              |  107 +++++-
 fs/xfs/scrub/rtbitmap.h                                              |   22 ++
 fs/xfs/scrub/rtbitmap_repair.c                                       |  202 +++++++++++
 fs/xfs/scrub/rtsummary.c                                             |  141 ++++++--
 fs/xfs/scrub/scrub.c                                                 |   62 ++--
 fs/xfs/scrub/scrub.h                                                 |   15 +-
 fs/xfs/scrub/symlink.c                                               |   20 +-
 fs/xfs/scrub/trace.c                                                 |    3 +
 fs/xfs/scrub/trace.h                                                 |  488 +++++++++++++++++++++++--
 fs/xfs/scrub/xfarray.h                                               |   22 ++
 fs/xfs/xfs_attr_item.c                                               |  295 ++++++---------
 fs/xfs/xfs_bmap_item.c                                               |  218 +++++-------
 fs/xfs/xfs_buf.c                                                     |   44 ++-
 fs/xfs/xfs_buf.h                                                     |    1 +
 fs/xfs/xfs_dir2_readdir.c                                            |    3 +
 fs/xfs/xfs_dquot.c                                                   |   37 +-
 fs/xfs/xfs_dquot.h                                                   |    8 +-
 fs/xfs/xfs_extent_busy.c                                             |   13 +
 fs/xfs/xfs_extent_busy.h                                             |    2 +
 fs/xfs/xfs_extfree_item.c                                            |  356 ++++++++----------
 fs/xfs/xfs_fsops.c                                                   |   54 +--
 fs/xfs/xfs_fsops.h                                                   |   14 +-
 fs/xfs/xfs_globals.c                                                 |   12 +
 fs/xfs/xfs_health.c                                                  |    8 +-
 fs/xfs/xfs_inode.c                                                   |   59 +--
 fs/xfs/xfs_inode.h                                                   |    2 +
 fs/xfs/xfs_inode_item.c                                              |    3 +
 fs/xfs/xfs_ioctl.c                                                   |  115 +++---
 fs/xfs/xfs_log.c                                                     |    1 +
 fs/xfs/xfs_log_priv.h                                                |    1 +
 fs/xfs/xfs_log_recover.c                                             |  129 +++----
 fs/xfs/xfs_mount.c                                                   |    8 +-
 fs/xfs/xfs_notify_failure.c                                          |  108 +++++-
 fs/xfs/xfs_refcount_item.c                                           |  252 ++++---------
 fs/xfs/xfs_reflink.c                                                 |    2 +-
 fs/xfs/xfs_rmap_item.c                                               |  275 ++++++--------
 fs/xfs/xfs_rtalloc.c                                                 |   11 +-
 fs/xfs/xfs_super.c                                                   |    6 +-
 fs/xfs/xfs_symlink.c                                                 |    3 +
 fs/xfs/xfs_sysctl.h                                                  |    2 +
 fs/xfs/xfs_sysfs.c                                                   |   63 ++++
 fs/xfs/xfs_trace.h                                                   |   27 +-
 fs/xfs/xfs_trans.c                                                   |   62 ++++
 fs/xfs/xfs_trans.h                                                   |   16 +-
 fs/xfs/xfs_xattr.c                                                   |    6 +
 include/linux/mm.h                                                   |    1 +
 mm/memory-failure.c                                                  |   21 +-
 135 files changed, 12099 insertions(+), 2045 deletions(-)
 create mode 100644 Documentation/filesystems/xfs/index.rst
 rename Documentation/filesystems/{ => xfs}/xfs-delayed-logging-design.rst (100%)
 rename Documentation/filesystems/{ => xfs}/xfs-maintainer-entry-profile.rst (100%)
 rename Documentation/filesystems/{ => xfs}/xfs-online-fsck-design.rst (99%)
 rename Documentation/filesystems/{ => xfs}/xfs-self-describing-metadata.rst (100%)
 rename fs/xfs/{ => libxfs}/xfs_ondisk.h (97%)
 create mode 100644 fs/xfs/scrub/agb_bitmap.c
 create mode 100644 fs/xfs/scrub/agb_bitmap.h
 create mode 100644 fs/xfs/scrub/alloc_repair.c
 create mode 100644 fs/xfs/scrub/bmap_repair.c
 create mode 100644 fs/xfs/scrub/cow_repair.c
 create mode 100644 fs/xfs/scrub/dqiterate.c
 create mode 100644 fs/xfs/scrub/fsb_bitmap.h
 create mode 100644 fs/xfs/scrub/ialloc_repair.c
 create mode 100644 fs/xfs/scrub/inode_repair.c
 create mode 100644 fs/xfs/scrub/newbt.c
 create mode 100644 fs/xfs/scrub/newbt.h
 create mode 100644 fs/xfs/scrub/off_bitmap.h
 create mode 100644 fs/xfs/scrub/quota.h
 create mode 100644 fs/xfs/scrub/quota_repair.c
 create mode 100644 fs/xfs/scrub/refcount_repair.c
 create mode 100644 fs/xfs/scrub/rtbitmap.h
 create mode 100644 fs/xfs/scrub/rtbitmap_repair.c


