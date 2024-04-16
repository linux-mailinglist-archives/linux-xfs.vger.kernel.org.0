Return-Path: <linux-xfs+bounces-6691-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 97D9F8A5E78
	for <lists+linux-xfs@lfdr.de>; Tue, 16 Apr 2024 01:38:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3770E1F21540
	for <lists+linux-xfs@lfdr.de>; Mon, 15 Apr 2024 23:38:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBFDF1591F9;
	Mon, 15 Apr 2024 23:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="neCGee9K"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B587156974
	for <linux-xfs@vger.kernel.org>; Mon, 15 Apr 2024 23:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713224308; cv=none; b=XCUzbMUMrLPJBvfbiuFr8yhA4kmCwbuBdPVQMZCIR/dihi22LWNVgLTUU+N6OQI0WuQqCtjHSAJg7fxWOZIpEB3DRnbs1KzpKnBJ3MgBg0Vc3OS8xR1FLs3vx7A+6nY6ioXe5pswxywQmBPiLOeWRzRSL7eUFfhEhoUDWGlV5lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713224308; c=relaxed/simple;
	bh=kZ0RPs178J70O8Xq72F7Y8uDaodNzPkEXmX8xVAQepw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ga4+OvRcnHJDU7dzSVJyud1Dc8HIbnivi+TnrLrEpMuo29TZGtHHnoIOHvs+tHsuIsrZoo0S2Z2VaxnGXwEt1cn3vkPSBDMyiRfhsS9+SrGkB2fdRnJILxm/CnAgfiWxoOOzmS/P4WZqZBMft77xIb9ObP1qwDniJiL/O4tHekQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=neCGee9K; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17348C113CC;
	Mon, 15 Apr 2024 23:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713224308;
	bh=kZ0RPs178J70O8Xq72F7Y8uDaodNzPkEXmX8xVAQepw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=neCGee9K3lvCN2nvT0l6kujPf7ZCVuIpWzQiDbPahuYPP8q8P4K2k2laA1ni+UGZY
	 THPKgaRng2IA32RMxuGzj13F/605UKeOF3C36vdCTVPNOxfD578n4YfsH7m/8VHIC1
	 d1WrvLldwrhoH0O5uP6/cWoYUXPcc0+np7xUFQPNgaEgMPsclDVzZd8qrfeGiYWiKo
	 7GTtyApYh03/1p/krEpQnq9Vix465HAzOwIC/3GDD/Y7cudKIbXHcC+oTp5CO/zwcG
	 bdwexLVwkIKgU0opqppo5flCOnEDu4OMxZxM/J0w/MHa60sGyzhW7k7bPQMAhEqIGH
	 5PAYOmqk1o0iw==
Date: Mon, 15 Apr 2024 16:38:27 -0700
Subject: [PATCH 3/5] xfs: fix potential AGI <-> ILOCK ABBA deadlock in
 xrep_dinode_findmode_walk_directory
From: "Darrick J. Wong" <djwong@kernel.org>
To: chandanbabu@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171322380354.86847.4279480043295578044.stgit@frogsfrogsfrogs>
In-Reply-To: <171322380288.86847.5430338887776337667.stgit@frogsfrogsfrogs>
References: <171322380288.86847.5430338887776337667.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

xfs/399 found the following deadlock when fuzzing core.mode = ones:

/proc/20506/task/20558/stack :
[<0>] xfs_ilock+0xa0/0x240 [xfs]
[<0>] xfs_ilock_data_map_shared+0x1b/0x20 [xfs]
[<0>] xrep_dinode_findmode_walk_directory+0x69/0xe0 [xfs]
[<0>] xrep_dinode_find_mode+0x103/0x2a0 [xfs]
[<0>] xrep_dinode_mode+0x7c/0x120 [xfs]
[<0>] xrep_dinode_core+0xed/0x2b0 [xfs]
[<0>] xrep_dinode_problems+0x10/0x80 [xfs]
[<0>] xrep_inode+0x6c/0xc0 [xfs]
[<0>] xrep_attempt+0x64/0x1d0 [xfs]
[<0>] xfs_scrub_metadata+0x365/0x840 [xfs]
[<0>] xfs_scrubv_metadata+0x282/0x430 [xfs]
[<0>] xfs_ioc_scrubv_metadata+0x149/0x1a0 [xfs]
[<0>] xfs_file_ioctl+0xc68/0x1780 [xfs]
/proc/20506/task/20559/stack :
[<0>] xfs_buf_lock+0x3b/0x110 [xfs]
[<0>] xfs_buf_find_lock+0x66/0x1c0 [xfs]
[<0>] xfs_buf_get_map+0x208/0xc00 [xfs]
[<0>] xfs_buf_read_map+0x5d/0x2c0 [xfs]
[<0>] xfs_trans_read_buf_map+0x1b0/0x4c0 [xfs]
[<0>] xfs_read_agi+0xbd/0x190 [xfs]
[<0>] xfs_ialloc_read_agi+0x47/0x160 [xfs]
[<0>] xfs_imap_lookup+0x69/0x1f0 [xfs]
[<0>] xfs_imap+0x1fc/0x3d0 [xfs]
[<0>] xfs_iget+0x357/0xd50 [xfs]
[<0>] xchk_dir_actor+0x16e/0x330 [xfs]
[<0>] xchk_dir_walk_block+0x164/0x1e0 [xfs]
[<0>] xchk_dir_walk+0x13a/0x190 [xfs]
[<0>] xchk_directory+0x1a2/0x2b0 [xfs]
[<0>] xfs_scrub_metadata+0x2f4/0x840 [xfs]
[<0>] xfs_scrubv_metadata+0x282/0x430 [xfs]
[<0>] xfs_ioc_scrubv_metadata+0x149/0x1a0 [xfs]
[<0>] xfs_file_ioctl+0xc68/0x1780 [xfs]

Thread 20558 holds an AGI buffer and is trying to grab the ILOCK of the
root directory.  Thread 20559 holds the root directory ILOCK and is
trying to grab the AGI of an inode that is one of the root directory's
children.  The AGI held by 20558 is the same buffer that 20559 is trying
to acquire.  In other words, this is an ABBA deadlock.

In general, the lock order is ILOCK and then AGI -- rename does this
while preparing for an operation involving whiteouts or renaming files
out of existence; and unlink does this when moving an inode to the
unlinked list.  The only place where we do it in the opposite order is
on the child during an icreate, but at that point the child is marked
INEW and is not visible to other threads.

Work around this deadlock by replacing the blocking ilock attempt with a
nonblocking loop that aborts after 30 seconds.  Relax for a jiffy after
a failed lock attempt.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/inode_repair.c |   49 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 48 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index 35da0193c919..097afba3043f 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -282,6 +282,51 @@ xrep_dinode_findmode_dirent(
 	return 0;
 }
 
+/* Try to lock a directory, or wait a jiffy. */
+static inline int
+xrep_dinode_ilock_nowait(
+	struct xfs_inode	*dp,
+	unsigned int		lock_mode)
+{
+	if (xfs_ilock_nowait(dp, lock_mode))
+		return true;
+
+	schedule_timeout_killable(1);
+	return false;
+}
+
+/*
+ * Try to lock a directory to look for ftype hints.  Since we already hold the
+ * AGI buffer, we cannot block waiting for the ILOCK because rename can take
+ * the ILOCK and then try to lock AGIs.
+ */
+STATIC int
+xrep_dinode_trylock_directory(
+	struct xrep_inode	*ri,
+	struct xfs_inode	*dp,
+	unsigned int		*lock_modep)
+{
+	unsigned long		deadline = jiffies + msecs_to_jiffies(30000);
+	unsigned int		lock_mode;
+	int			error = 0;
+
+	do {
+		if (xchk_should_terminate(ri->sc, &error))
+			return error;
+
+		if (xfs_need_iread_extents(&dp->i_df))
+			lock_mode = XFS_ILOCK_EXCL;
+		else
+			lock_mode = XFS_ILOCK_SHARED;
+
+		if (xrep_dinode_ilock_nowait(dp, lock_mode)) {
+			*lock_modep = lock_mode;
+			return 0;
+		}
+	} while (!time_is_before_jiffies(deadline));
+	return -EBUSY;
+}
+
 /*
  * If this is a directory, walk the dirents looking for any that point to the
  * scrub target inode.
@@ -299,7 +344,9 @@ xrep_dinode_findmode_walk_directory(
 	 * Scan the directory to see if there it contains an entry pointing to
 	 * the directory that we are repairing.
 	 */
-	lock_mode = xfs_ilock_data_map_shared(dp);
+	error = xrep_dinode_trylock_directory(ri, dp, &lock_mode);
+	if (error)
+		return error;
 
 	/*
 	 * If this directory is known to be sick, we cannot scan it reliably


