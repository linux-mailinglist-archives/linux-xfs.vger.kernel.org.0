Return-Path: <linux-xfs+bounces-11000-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E5F739402C5
	for <lists+linux-xfs@lfdr.de>; Tue, 30 Jul 2024 02:52:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9B7572827FE
	for <lists+linux-xfs@lfdr.de>; Tue, 30 Jul 2024 00:52:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B601C443D;
	Tue, 30 Jul 2024 00:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aMsSRiYJ"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765A333D5
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jul 2024 00:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722300764; cv=none; b=nWtRrqpZwmRDsNTzKrega9/O0csFgMa3XbKyNRg5tWsjBcrRYOtxDh9/4b/73+yeGr1ESXcLQKqvnqBccWXEFCIf0z3IHvWo6vGk69I1OxhXKmhGfGenT+U+SY1srEttAb2ZCJ3S8EID+413/t1S07mXWxhGC5PF5tZK+hXhvys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722300764; c=relaxed/simple;
	bh=breDAnflR6HQIVbLDaUPIDL47Fl2Jo3qty8Gqo6yiuE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RYs6Jst4VHldk9r9YG/JEsRX+acMM1tACKMQBHSKqppKmsa3MkMW11yJx9k7fFjsPaYp2wICK9tS0O2ua1ZKA9qkUAvE7fjRIFQ/hBTsnXHyKtwumgsVn2w9L0pxzp6lDIpg79y+irGcOtcC+gYKW/RHYRUzdCjopGeybJ5jzkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aMsSRiYJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F70DC32786;
	Tue, 30 Jul 2024 00:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722300764;
	bh=breDAnflR6HQIVbLDaUPIDL47Fl2Jo3qty8Gqo6yiuE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=aMsSRiYJUmg+O+ggdXikisMTU0aJlNYAJcfCKYKZchKrQtYzQvsQa1zfGsnl5XgCR
	 NJ89EvkhmdY+wOTFxFV9kGWvXFGeOEAgD8W3VsSEXnuCO6B/8zQ+kei3dses6QYuEn
	 aWdOr7FUdmo3ubrdJLWA5GmRvcPTo/z5ke/grOicAD+RmD9YwsO9pzImJjPlMzarys
	 8PUdqLAxJma1xnuvBNQzqgp9dK7bE1xx+RLmr1h5+rPFuXFp+ZouXvLzRspjepfChn
	 GqjR5h0hcB/uVar0cyZPl9skifE8EiKE9cBRo7sbe1fUr23sbatgIOrLn3bKjlWzAg
	 VhYAD9ORvEUwg==
Date: Mon, 29 Jul 2024 17:52:43 -0700
Subject: [PATCH 111/115] xfs: Add cond_resched to block unmap range and
 reflink remap path
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Disha Goel <disgoel@linux.ibm.com>, Chandan Babu R <chandanbabu@kernel.org>,
 linux-xfs@vger.kernel.org
Message-ID: <172229844004.1338752.17870968518710908441.stgit@frogsfrogsfrogs>
In-Reply-To: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
References: <172229842329.1338752.683513668861748171.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

Source kernel commit: b0c6bcd58d44b1b843d1b7218db5a1efe917d27e

An async dio write to a sparse file can generate a lot of extents
and when we unlink this file (using rm), the kernel can be busy in umapping
and freeing those extents as part of transaction processing.

Similarly xfs reflink remapping path can also iterate over a million
extent entries in xfs_reflink_remap_blocks().

Since we can busy loop in these two functions, so let's add cond_resched()
to avoid softlockup messages like these.

watchdog: BUG: soft lockup - CPU#1 stuck for 22s! [kworker/1:0:82435]
CPU: 1 PID: 82435 Comm: kworker/1:0 Tainted: G S  L   6.9.0-rc5-0-default #1
Workqueue: xfs-inodegc/sda2 xfs_inodegc_worker
NIP [c000000000beea10] xfs_extent_busy_trim+0x100/0x290
LR [c000000000bee958] xfs_extent_busy_trim+0x48/0x290
Call Trace:
xfs_alloc_get_rec+0x54/0x1b0 (unreliable)
xfs_alloc_compute_aligned+0x5c/0x144
xfs_alloc_ag_vextent_size+0x238/0x8d4
xfs_alloc_fix_freelist+0x540/0x694
xfs_free_extent_fix_freelist+0x84/0xe0
__xfs_free_extent+0x74/0x1ec
xfs_extent_free_finish_item+0xcc/0x214
xfs_defer_finish_one+0x194/0x388
xfs_defer_finish_noroll+0x1b4/0x5c8
xfs_defer_finish+0x2c/0xc4
xfs_bunmapi_range+0xa4/0x100
xfs_itruncate_extents_flags+0x1b8/0x2f4
xfs_inactive_truncate+0xe0/0x124
xfs_inactive+0x30c/0x3e0
xfs_inodegc_worker+0x140/0x234
process_scheduled_works+0x240/0x57c
worker_thread+0x198/0x468
kthread+0x138/0x140
start_kernel_thread+0x14/0x18

run fstests generic/175 at 2024-02-02 04:40:21
[   C17] watchdog: BUG: soft lockup - CPU#17 stuck for 23s! [xfs_io:7679]
watchdog: BUG: soft lockup - CPU#17 stuck for 23s! [xfs_io:7679]
CPU: 17 PID: 7679 Comm: xfs_io Kdump: loaded Tainted: G X 6.4.0
NIP [c008000005e3ec94] xfs_rmapbt_diff_two_keys+0x54/0xe0 [xfs]
LR [c008000005e08798] xfs_btree_get_leaf_keys+0x110/0x1e0 [xfs]
Call Trace:
0xc000000014107c00 (unreliable)
__xfs_btree_updkeys+0x8c/0x2c0 [xfs]
xfs_btree_update_keys+0x150/0x170 [xfs]
xfs_btree_lshift+0x534/0x660 [xfs]
xfs_btree_make_block_unfull+0x19c/0x240 [xfs]
xfs_btree_insrec+0x4e4/0x630 [xfs]
xfs_btree_insert+0x104/0x2d0 [xfs]
xfs_rmap_insert+0xc4/0x260 [xfs]
xfs_rmap_map_shared+0x228/0x630 [xfs]
xfs_rmap_finish_one+0x2d4/0x350 [xfs]
xfs_rmap_update_finish_item+0x44/0xc0 [xfs]
xfs_defer_finish_noroll+0x2e4/0x740 [xfs]
__xfs_trans_commit+0x1f4/0x400 [xfs]
xfs_reflink_remap_extent+0x2d8/0x650 [xfs]
xfs_reflink_remap_blocks+0x154/0x320 [xfs]
xfs_file_remap_range+0x138/0x3a0 [xfs]
do_clone_file_range+0x11c/0x2f0
vfs_clone_file_range+0x60/0x1c0
ioctl_file_clone+0x78/0x140
sys_ioctl+0x934/0x1270
system_call_exception+0x158/0x320
system_call_vectored_common+0x15c/0x2ec

Cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Tested-by: Disha Goel<disgoel@linux.ibm.com>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/libxfs_priv.h |    2 ++
 libxfs/xfs_bmap.c    |    1 +
 2 files changed, 3 insertions(+)


diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 90b2db091..64bc10e10 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -639,4 +639,6 @@ int xfs_bmap_last_extent(struct xfs_trans *tp, struct xfs_inode *ip,
  */
 #define lower_32_bits(n) ((uint32_t)((n) & 0xffffffff))
 
+#define cond_resched()	((void)0)
+
 #endif	/* __LIBXFS_INTERNAL_XFS_H__ */
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 347b44423..a0dda4640 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -6377,6 +6377,7 @@ xfs_bunmapi_range(
 		error = xfs_defer_finish(tpp);
 		if (error)
 			goto out;
+		cond_resched();
 	}
 out:
 	return error;


