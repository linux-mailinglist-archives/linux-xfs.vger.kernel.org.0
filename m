Return-Path: <linux-xfs+bounces-17166-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E1329F83FB
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Dec 2024 20:20:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E909216672F
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Dec 2024 19:20:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCA7B19E98C;
	Thu, 19 Dec 2024 19:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n+oa+oQo"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89053198A08
	for <linux-xfs@vger.kernel.org>; Thu, 19 Dec 2024 19:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734636001; cv=none; b=XvVNYH4c9lg1l0ODs6G8FF7/ao964rlCQFD7jbFBmeIsG6iMwt5Fc8YSDQWK7BqzeCVPGMAi7tmO/b26xP3VDJF7hqNOThHFrO63eGZTwEr1RLaKgnQHtPhheyu0iJlXlHUwVUs5Ncbjxu7FtuX2s7XKRPGIVOJCsPDJwA3aR7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734636001; c=relaxed/simple;
	bh=auuGMsQBRM7YlZfI3tY04osP2VFtW7owdl+kBj8WcKw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fdw6/YEQBQ8Upa73Y7mUV7K5CKSA+SGpyxI8pTWLfkCPk4+pe1cdM4pFFT0X3kIeVbJXIvHNQ+kalnKMNNfn7dhO63OSXPAPHLtELQo0Vq/kisokRjqq3xhbJbwABxUisJsqH4bnhedlx9uhUeSQWWEx/RkAJN/w6OMev5BEZrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n+oa+oQo; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 003AFC4CECE;
	Thu, 19 Dec 2024 19:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734636001;
	bh=auuGMsQBRM7YlZfI3tY04osP2VFtW7owdl+kBj8WcKw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=n+oa+oQoaNfjaeAO/LtnQwehuHHhxvs+9a6SAb4lfIXsI8drZyvsi8bTn0LgMn/WC
	 uB3/lpPgW3dU5D9iMKK7j8tX8kwGHhqtBunZNRS0P6AxYIb2tTR/ZZbTk1fx21bPSn
	 SgwrHKCP/E5eNd8t3ihedQNgrRjr6m+3kiP4KW9jtgt3ORwMZVyOz77b5zzVzXME66
	 DtX0Qsip57wYrDT90pQqFsDjPYdY9nsIwNBzLx9YttAwLXeme56VkzdLefNFR19b5C
	 lbof3NJKmTRWhfxj4VF5QR9fh8sYQvKHWF6oDrZgWWEz9t/qRpOcG8rYSidanjtYU1
	 TKl073pbNfvRg==
Date: Thu, 19 Dec 2024 11:20:00 -0800
Subject: [PATCHSET v6.1 5/5] xfs: reflink on the realtime device
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <173463580863.1572761.14930951818251914429.stgit@frogsfrogsfrogs>
In-Reply-To: <20241219191553.GI6160@frogsfrogsfrogs>
References: <20241219191553.GI6160@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

This patchset enables use of the file data block sharing feature (i.e.
reflink) on the realtime device.  It follows the same basic sequence as
the realtime rmap series -- first a few cleanups; then  introduction of
the new btree format and inode fork format.  Next comes enabling CoW and
remapping for the rt device; new scrub, repair, and health reporting
code; and at the end we implement some code to lengthen write requests
so that rt extents are always CoWed fully.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-reflink

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-reflink

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-reflink

xfsdocs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git/log/?h=realtime-reflink
---
Commits in this patchset:
 * xfs: prepare refcount btree cursor tracepoints for realtime
 * xfs: namespace the maximum length/refcount symbols
 * xfs: introduce realtime refcount btree ondisk definitions
 * xfs: realtime refcount btree transaction reservations
 * xfs: add realtime refcount btree operations
 * xfs: prepare refcount functions to deal with rtrefcountbt
 * xfs: add a realtime flag to the refcount update log redo items
 * xfs: support recovering refcount intent items targetting realtime extents
 * xfs: add realtime refcount btree block detection to log recovery
 * xfs: add realtime refcount btree inode to metadata directory
 * xfs: add metadata reservations for realtime refcount btree
 * xfs: wire up a new metafile type for the realtime refcount
 * xfs: refactor xfs_reflink_find_shared
 * xfs: wire up realtime refcount btree cursors
 * xfs: create routine to allocate and initialize a realtime refcount btree inode
 * xfs: update rmap to allow cow staging extents in the rt rmap
 * xfs: compute rtrmap btree max levels when reflink enabled
 * xfs: refactor reflink quota updates
 * xfs: enable CoW for realtime data
 * xfs: enable sharing of realtime file blocks
 * xfs: allow inodes to have the realtime and reflink flags
 * xfs: recover CoW leftovers in the realtime volume
 * xfs: fix xfs_get_extsz_hint behavior with realtime alwayscow files
 * xfs: apply rt extent alignment constraints to CoW extsize hint
 * xfs: enable extent size hints for CoW operations
 * xfs: check that the rtrefcount maxlevels doesn't increase when growing fs
 * xfs: report realtime refcount btree corruption errors to the health system
 * xfs: scrub the realtime refcount btree
 * xfs: cross-reference checks with the rt refcount btree
 * xfs: allow overlapping rtrmapbt records for shared data extents
 * xfs: check reference counts of gaps between rt refcount records
 * xfs: allow dquot rt block count to exceed rt blocks on reflink fs
 * xfs: detect and repair misaligned rtinherit directory cowextsize hints
 * xfs: scrub the metadir path of rt refcount btree files
 * xfs: don't flag quota rt block usage on rtreflink filesystems
 * xfs: check new rtbitmap records against rt refcount btree
 * xfs: walk the rt reference count tree when rebuilding rmap
 * xfs: capture realtime CoW staging extents when rebuilding rt rmapbt
 * xfs: online repair of the realtime refcount btree
 * xfs: repair inodes that have a refcount btree in the data fork
 * xfs: check for shared rt extents when rebuilding rt file's data fork
 * xfs: fix CoW forks for realtime files
 * xfs: enable realtime reflink
---
 fs/xfs/Makefile                      |    3 
 fs/xfs/libxfs/xfs_bmap.c             |   23 +
 fs/xfs/libxfs/xfs_btree.c            |    5 
 fs/xfs/libxfs/xfs_btree.h            |    2 
 fs/xfs/libxfs/xfs_defer.h            |    1 
 fs/xfs/libxfs/xfs_format.h           |   25 +
 fs/xfs/libxfs/xfs_fs.h               |    7 
 fs/xfs/libxfs/xfs_health.h           |    4 
 fs/xfs/libxfs/xfs_inode_buf.c        |   33 +
 fs/xfs/libxfs/xfs_inode_fork.c       |    6 
 fs/xfs/libxfs/xfs_log_format.h       |    6 
 fs/xfs/libxfs/xfs_log_recover.h      |    2 
 fs/xfs/libxfs/xfs_ondisk.h           |    2 
 fs/xfs/libxfs/xfs_refcount.c         |  276 ++++++++++--
 fs/xfs/libxfs/xfs_refcount.h         |   23 +
 fs/xfs/libxfs/xfs_rmap.c             |    7 
 fs/xfs/libxfs/xfs_rtgroup.c          |   19 +
 fs/xfs/libxfs/xfs_rtgroup.h          |   11 
 fs/xfs/libxfs/xfs_rtrefcount_btree.c |  757 +++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_rtrefcount_btree.h |  189 ++++++++
 fs/xfs/libxfs/xfs_rtrmap_btree.c     |   28 +
 fs/xfs/libxfs/xfs_sb.c               |    8 
 fs/xfs/libxfs/xfs_shared.h           |    7 
 fs/xfs/libxfs/xfs_trans_resv.c       |   25 +
 fs/xfs/scrub/agheader_repair.c       |    2 
 fs/xfs/scrub/bmap.c                  |   30 +
 fs/xfs/scrub/bmap_repair.c           |   21 +
 fs/xfs/scrub/common.c                |   10 
 fs/xfs/scrub/common.h                |    5 
 fs/xfs/scrub/cow_repair.c            |  180 +++++++-
 fs/xfs/scrub/health.c                |    1 
 fs/xfs/scrub/inode.c                 |   31 +
 fs/xfs/scrub/inode_repair.c          |   57 ++
 fs/xfs/scrub/metapath.c              |    3 
 fs/xfs/scrub/quota.c                 |    8 
 fs/xfs/scrub/quota_repair.c          |    2 
 fs/xfs/scrub/reap.c                  |  247 ++++++++++-
 fs/xfs/scrub/reap.h                  |    7 
 fs/xfs/scrub/refcount.c              |    2 
 fs/xfs/scrub/refcount_repair.c       |    6 
 fs/xfs/scrub/repair.c                |    6 
 fs/xfs/scrub/repair.h                |    7 
 fs/xfs/scrub/rgb_bitmap.h            |   37 ++
 fs/xfs/scrub/rmap_repair.c           |    7 
 fs/xfs/scrub/rtb_bitmap.h            |   37 ++
 fs/xfs/scrub/rtbitmap.c              |    2 
 fs/xfs/scrub/rtbitmap_repair.c       |   24 +
 fs/xfs/scrub/rtrefcount.c            |  661 +++++++++++++++++++++++++++++
 fs/xfs/scrub/rtrefcount_repair.c     |  783 ++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/rtrmap.c                |   54 ++
 fs/xfs/scrub/rtrmap_repair.c         |  103 ++++
 fs/xfs/scrub/scrub.c                 |    7 
 fs/xfs/scrub/scrub.h                 |   12 +
 fs/xfs/scrub/stats.c                 |    1 
 fs/xfs/scrub/trace.h                 |   54 +-
 fs/xfs/xfs_buf_item_recover.c        |    4 
 fs/xfs/xfs_fsmap.c                   |   25 +
 fs/xfs/xfs_fsops.c                   |    2 
 fs/xfs/xfs_health.c                  |    1 
 fs/xfs/xfs_inode_item.c              |   14 +
 fs/xfs/xfs_inode_item_recover.c      |    4 
 fs/xfs/xfs_ioctl.c                   |   21 +
 fs/xfs/xfs_log_recover.c             |    2 
 fs/xfs/xfs_mount.c                   |    5 
 fs/xfs/xfs_mount.h                   |    9 
 fs/xfs/xfs_refcount_item.c           |  240 ++++++++++
 fs/xfs/xfs_reflink.c                 |  325 ++++++++++----
 fs/xfs/xfs_reflink.h                 |    4 
 fs/xfs/xfs_rtalloc.c                 |   24 +
 fs/xfs/xfs_rtalloc.h                 |    5 
 fs/xfs/xfs_stats.c                   |    3 
 fs/xfs/xfs_stats.h                   |    1 
 fs/xfs/xfs_super.c                   |    6 
 fs/xfs/xfs_trace.h                   |  111 +++--
 74 files changed, 4330 insertions(+), 352 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_rtrefcount_btree.c
 create mode 100644 fs/xfs/libxfs/xfs_rtrefcount_btree.h
 create mode 100644 fs/xfs/scrub/rgb_bitmap.h
 create mode 100644 fs/xfs/scrub/rtb_bitmap.h
 create mode 100644 fs/xfs/scrub/rtrefcount.c
 create mode 100644 fs/xfs/scrub/rtrefcount_repair.c


