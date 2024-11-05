Return-Path: <linux-xfs+bounces-15006-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 92B899BD80D
	for <lists+linux-xfs@lfdr.de>; Tue,  5 Nov 2024 23:04:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 583542835EF
	for <lists+linux-xfs@lfdr.de>; Tue,  5 Nov 2024 22:04:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0572A1FBCA3;
	Tue,  5 Nov 2024 22:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eX1N2qek"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B74A353365
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730844264; cv=none; b=LYv43ZABWC04LHMXLnUfSSfl1DjhZ1DuU2wGuUdjE1atJ2Kz2fufQ/xev3IfQQJdQpQg8H14npoy7rdqHeTYHMV/+nIz1yGw33NsCjGm1LCZhDGp2Hu8qYD35Ix+KvsjlPQ7BpcdKnzfspu4QpCZLw8E5JKOEbyni3BLf+Mt4t4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730844264; c=relaxed/simple;
	bh=C82KJfp7WUpkMdGw5SB/KG+9mml75gfRkmstBeWXVQI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fhizd2TwCTv3vm8W9cofg1een3mLcUlunGQike+G5f/0+llbiIwBOL+EYX1Lth2XhS8/g+kOSYxVH3Znt/t+hELfwo6zc7JTMdaKu0GHa39GAVgAy0BsuKpG6wZ7BdYpKdlSdIFWZCwN0lCdQ2D3IJYDtWSbS5hNF65o5ENIXYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eX1N2qek; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FC81C4CECF;
	Tue,  5 Nov 2024 22:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730844264;
	bh=C82KJfp7WUpkMdGw5SB/KG+9mml75gfRkmstBeWXVQI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=eX1N2qek7YKCLoQXlcGvv8+OFX/gHSsNQEQCrBW2mfc4fT1Dv21GN9Sz7PhnlHEk2
	 FHsOl9g0h8958CjaxghPCMQQFdX2MNSAdS3fIz3TWu8iqT5Eo7bwsLdvXlu67ZwP27
	 C3ILAQVLZttW0klKUNncNJqy26MSB7w0xKZN9BepIBmpDYdA5tdHGWuLRO+8AlW/kt
	 Xh5A/6CDxj3VglPzI7fcS3Upa22xTX2d8IcPSU4b/U9xClfJYPMsKOwpbxtn9RXbxS
	 axKToGDn4uWXF5hdu7RSPQMBsdahTtwlqs9XTzqQztqXMf/FOQOEcSHVBqRX4EU5se
	 UMPZ5BqmNzxaw==
Date: Tue, 05 Nov 2024 14:04:23 -0800
Subject: [PATCHSET v5.5 02/10] xfs: create a generic allocation group
 structure
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084395220.1869491.11426383276644234025.stgit@frogsfrogsfrogs>
In-Reply-To: <20241105215840.GK2386201@frogsfrogsfrogs>
References: <20241105215840.GK2386201@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Soon we'll be sharding the realtime volume into separate allocation
groups.  These rt groups will /mostly/ behave the same as the ones on
the data device, but since rt groups don't have quite the same set of
struct fields as perags, let's hoist the parts that will be shared by
both into a common xfs_group object.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=generic-groups-6.13
---
Commits in this patchset:
 * xfs: factor out a xfs_iwalk_args helper
 * xfs: factor out a generic xfs_group structure
 * xfs: add a xfs_group_next_range helper
 * xfs: switch perag iteration from the for_each macros to a while based iterator
 * xfs: move metadata health tracking to the generic group structure
 * xfs: mark xfs_perag_intent_{hold,rele} static
 * xfs: move draining of deferred operations to the generic group structure
 * xfs: move the online repair rmap hooks to the generic group structure
 * xfs: return the busy generation from xfs_extent_busy_list_empty
 * xfs: convert extent busy tracepoints to the generic group structure
 * xfs: convert busy extent tracking to the generic group structure
 * xfs: add a generic group pointer to the btree cursor
 * xfs: store a generic xfs_group pointer in xfs_getfsmap_info
 * xfs: add group based bno conversion helpers
 * xfs: remove xfs_group_intent_hold and xfs_group_intent_rele
 * xfs: store a generic group structure in the intents
---
 fs/xfs/Makefile                    |    1 
 fs/xfs/libxfs/xfs_ag.c             |  149 ++++-------------------
 fs/xfs/libxfs/xfs_ag.h             |  165 ++++++++++++++-----------
 fs/xfs/libxfs/xfs_ag_resv.c        |   19 ++-
 fs/xfs/libxfs/xfs_alloc.c          |   74 ++++++-----
 fs/xfs/libxfs/xfs_alloc.h          |    2 
 fs/xfs/libxfs/xfs_alloc_btree.c    |   30 ++---
 fs/xfs/libxfs/xfs_bmap.c           |    2 
 fs/xfs/libxfs/xfs_bmap.h           |    2 
 fs/xfs/libxfs/xfs_btree.c          |   37 ++----
 fs/xfs/libxfs/xfs_btree.h          |    3 
 fs/xfs/libxfs/xfs_btree_mem.c      |    6 -
 fs/xfs/libxfs/xfs_group.c          |  225 ++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_group.h          |  131 ++++++++++++++++++++
 fs/xfs/libxfs/xfs_health.h         |   45 +++----
 fs/xfs/libxfs/xfs_ialloc.c         |   50 ++++----
 fs/xfs/libxfs/xfs_ialloc_btree.c   |   27 ++--
 fs/xfs/libxfs/xfs_refcount.c       |   26 ++--
 fs/xfs/libxfs/xfs_refcount.h       |    2 
 fs/xfs/libxfs/xfs_refcount_btree.c |   14 +-
 fs/xfs/libxfs/xfs_rmap.c           |   42 +++---
 fs/xfs/libxfs/xfs_rmap.h           |    6 -
 fs/xfs/libxfs/xfs_rmap_btree.c     |   28 ++--
 fs/xfs/libxfs/xfs_sb.c             |   28 ++--
 fs/xfs/libxfs/xfs_types.c          |    5 -
 fs/xfs/libxfs/xfs_types.h          |    8 +
 fs/xfs/scrub/agheader_repair.c     |   22 ++-
 fs/xfs/scrub/alloc.c               |    2 
 fs/xfs/scrub/alloc_repair.c        |   12 +-
 fs/xfs/scrub/bmap.c                |    8 +
 fs/xfs/scrub/bmap_repair.c         |    9 +
 fs/xfs/scrub/common.c              |    4 -
 fs/xfs/scrub/common.h              |    3 
 fs/xfs/scrub/cow_repair.c          |    9 +
 fs/xfs/scrub/fscounters.c          |   10 +-
 fs/xfs/scrub/health.c              |   21 +--
 fs/xfs/scrub/ialloc.c              |   14 +-
 fs/xfs/scrub/ialloc_repair.c       |    2 
 fs/xfs/scrub/inode_repair.c        |    5 -
 fs/xfs/scrub/iscan.c               |    4 -
 fs/xfs/scrub/newbt.c               |    8 +
 fs/xfs/scrub/reap.c                |    2 
 fs/xfs/scrub/refcount.c            |    3 
 fs/xfs/scrub/repair.c              |    4 -
 fs/xfs/scrub/rmap.c                |    4 -
 fs/xfs/scrub/rmap_repair.c         |   16 +-
 fs/xfs/scrub/trace.h               |   82 ++++++------
 fs/xfs/xfs_bmap_item.c             |    5 -
 fs/xfs/xfs_discard.c               |   20 ++-
 fs/xfs/xfs_drain.c                 |   78 +++++-------
 fs/xfs/xfs_drain.h                 |   22 +--
 fs/xfs/xfs_extent_busy.c           |  201 ++++++++++++++++++------------
 fs/xfs/xfs_extent_busy.h           |   59 +++------
 fs/xfs/xfs_extfree_item.c          |   14 +-
 fs/xfs/xfs_filestream.c            |    8 +
 fs/xfs/xfs_fsmap.c                 |   49 ++++---
 fs/xfs/xfs_fsops.c                 |   10 +-
 fs/xfs/xfs_health.c                |   99 +++++++--------
 fs/xfs/xfs_icache.c                |   60 +++------
 fs/xfs/xfs_inode.c                 |    6 -
 fs/xfs/xfs_iwalk.c                 |   99 ++++++---------
 fs/xfs/xfs_iwalk.h                 |    7 -
 fs/xfs/xfs_log_recover.c           |   11 +-
 fs/xfs/xfs_mount.h                 |   36 +++++
 fs/xfs/xfs_refcount_item.c         |    9 +
 fs/xfs/xfs_reflink.c               |    7 -
 fs/xfs/xfs_rmap_item.c             |    9 +
 fs/xfs/xfs_super.c                 |   11 +-
 fs/xfs/xfs_trace.c                 |    1 
 fs/xfs/xfs_trace.h                 |  238 ++++++++++++++++++++++--------------
 70 files changed, 1380 insertions(+), 1050 deletions(-)
 create mode 100644 fs/xfs/libxfs/xfs_group.c
 create mode 100644 fs/xfs/libxfs/xfs_group.h


