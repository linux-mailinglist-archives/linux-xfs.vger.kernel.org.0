Return-Path: <linux-xfs+bounces-9677-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C6A091169C
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Jun 2024 01:16:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 725571C2282B
	for <lists+linux-xfs@lfdr.de>; Thu, 20 Jun 2024 23:15:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E39F4149C65;
	Thu, 20 Jun 2024 23:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ik7cuqq7"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A425614387F
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 23:14:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718925267; cv=none; b=tciC7//Q6tGKUcgjhIFbs9Y7PsCAXNvbPRlVoFJfkjQrwKBs4MpW7iN3f27WNtbL4SJZhcy5rmDtUbfj6PUE/1MzTMstLGxPHH+0A1XAlQv6WypSWVrNVXbxyByKZc4Xq6oA1xxPEB8EWXhPx1Y8o/QyxtD39YyDiUMTpI9mr0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718925267; c=relaxed/simple;
	bh=iWIuNxpT8hhSEvjJm7X4/TLhdW5h3KU8ghba7SOu3H4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z+S0HdD6VhC0a9ujJc9GytzDTP/0hZB/W30jDjc324j4JswPBmHgksEJxH+Xcl1SxUEay64BXBn0+8+Na0EjoftcoR36KmAvNhgKHRUFcXxvcZzV4SwelWTIgRs6I/WMcua14vBaggpzoD3LFinVxJttmEGhajiOK6LxoFELvpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ik7cuqq7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE55C32781;
	Thu, 20 Jun 2024 23:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718925267;
	bh=iWIuNxpT8hhSEvjJm7X4/TLhdW5h3KU8ghba7SOu3H4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ik7cuqq7Rv89q2jxKiKPUKXaABZwNaajPmkiK9oJU3OvdZ84KLm4vpX1kK0Hu5GNL
	 RQh6kPKrsEiA4imgglqBDZCSqx01HsTwYE8hKgdjMSs265wQ+QTXhITfbRTPrYX+gs
	 QhrG26hesjuo2hCok54gdBSkTC0+Z4vDOIIx4ArG5wM+ZWuwvAC4G6Fo1SYWWoA1vm
	 NorOXpEp/Y+TG/QLk9HPKL9hsu1Q7ifc1YJ3K871jjAYXW4tyyDfMmNshQ8bxn3Y++
	 kXUubdtLeUUblWCmZBvJZHiH3hH+5WtRZwKl4ZxtjMHd5+QUjagbKK8CqKumJn/yA8
	 3uwJWaZdW9o3g==
Date: Thu, 20 Jun 2024 16:14:26 -0700
Subject: [PATCH 4/6] xfs: verify buffer, inode,
 and dquot items every tx commit
From: "Darrick J. Wong" <djwong@kernel.org>
To: hch@lst.de, chandanbabu@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <171892459300.3192151.2332029602549409027.stgit@frogsfrogsfrogs>
In-Reply-To: <171892459218.3192151.10366641366672957906.stgit@frogsfrogsfrogs>
References: <171892459218.3192151.10366641366672957906.stgit@frogsfrogsfrogs>
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

generic/388 has an annoying tendency to fail like this during log
recovery:

XFS (sda4): Unmounting Filesystem 435fe39b-82b6-46ef-be56-819499585130
XFS (sda4): Mounting V5 Filesystem 435fe39b-82b6-46ef-be56-819499585130
XFS (sda4): Starting recovery (logdev: internal)
00000000: 49 4e 81 b6 03 02 00 00 00 00 00 07 00 00 00 07  IN..............
00000010: 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00 10  ................
00000020: 35 9a 8b c1 3e 6e 81 00 35 9a 8b c1 3f dc b7 00  5...>n..5...?...
00000030: 35 9a 8b c1 3f dc b7 00 00 00 00 00 00 3c 86 4f  5...?........<.O
00000040: 00 00 00 00 00 00 02 f3 00 00 00 00 00 00 00 00  ................
00000050: 00 00 1f 01 00 00 00 00 00 00 00 02 b2 74 c9 0b  .............t..
00000060: ff ff ff ff d7 45 73 10 00 00 00 00 00 00 00 2d  .....Es........-
00000070: 00 00 07 92 00 01 fe 30 00 00 00 00 00 00 00 1a  .......0........
00000080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
00000090: 35 9a 8b c1 3b 55 0c 00 00 00 00 00 04 27 b2 d1  5...;U.......'..
000000a0: 43 5f e3 9b 82 b6 46 ef be 56 81 94 99 58 51 30  C_....F..V...XQ0
XFS (sda4): Internal error Bad dinode after recovery at line 539 of file fs/xfs/xfs_inode_item_recover.c.  Caller xlog_recover_items_pass2+0x4e/0xc0 [xfs]
CPU: 0 PID: 2189311 Comm: mount Not tainted 6.9.0-rc4-djwx #rc4
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS ?-20171121_152543-x86-ol7-builder-01.us.oracle.com-4.el7.1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x4f/0x60
 xfs_corruption_error+0x90/0xa0
 xlog_recover_inode_commit_pass2+0x5f1/0xb00
 xlog_recover_items_pass2+0x4e/0xc0
 xlog_recover_commit_trans+0x2db/0x350
 xlog_recovery_process_trans+0xab/0xe0
 xlog_recover_process_data+0xa7/0x130
 xlog_do_recovery_pass+0x398/0x840
 xlog_do_log_recovery+0x62/0xc0
 xlog_do_recover+0x34/0x1d0
 xlog_recover+0xe9/0x1a0
 xfs_log_mount+0xff/0x260
 xfs_mountfs+0x5d9/0xb60
 xfs_fs_fill_super+0x76b/0xa30
 get_tree_bdev+0x124/0x1d0
 vfs_get_tree+0x17/0xa0
 path_mount+0x72b/0xa90
 __x64_sys_mount+0x112/0x150
 do_syscall_64+0x49/0x100
 entry_SYSCALL_64_after_hwframe+0x4b/0x53
 </TASK>
XFS (sda4): Corruption detected. Unmount and run xfs_repair
XFS (sda4): Metadata corruption detected at xfs_dinode_verify.part.0+0x739/0x920 [xfs], inode 0x427b2d1
XFS (sda4): Filesystem has been shut down due to log error (0x2).
XFS (sda4): Please unmount the filesystem and rectify the problem(s).
XFS (sda4): log mount/recovery failed: error -117
XFS (sda4): log mount failed

This inode log item recovery failing the dinode verifier after
replaying the contents of the inode log item into the ondisk inode.
Looking back into what the kernel was doing at the time of the fs
shutdown, a thread was in the middle of running a series of
transactions, each of which committed changes to the inode.

At some point in the middle of that chain, an invalid (at least
according to the verifier) change was committed.  Had the filesystem not
shut down in the middle of the chain, a subsequent transaction would
have corrected the invalid state and nobody would have noticed.  But
that's not what happened here.  Instead, the invalid inode state was
committed to the ondisk log, so log recovery tripped over it.

The actual defect here was an overzealous inode verifier, which was
fixed in a separate patch.  This patch adds some transaction precommit
functions for CONFIG_XFS_DEBUG=y mode so that we can detect these kinds
of transient errors at transaction commit time, where it's much easier
to find the root cause.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/Kconfig          |   12 ++++++++++++
 fs/xfs/xfs.h            |    4 ++++
 fs/xfs/xfs_buf_item.c   |   32 ++++++++++++++++++++++++++++++++
 fs/xfs/xfs_dquot_item.c |   31 +++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode_item.c |   32 ++++++++++++++++++++++++++++++++
 5 files changed, 111 insertions(+)


diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index d41edd30388b..fffd6fffdce0 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -217,6 +217,18 @@ config XFS_DEBUG
 
 	  Say N unless you are an XFS developer, or you play one on TV.
 
+config XFS_DEBUG_EXPENSIVE
+	bool "XFS expensive debugging checks"
+	depends on XFS_FS && XFS_DEBUG
+	help
+	  Say Y here to get an XFS build with expensive debugging checks
+	  enabled.  These checks may affect performance significantly.
+
+	  Note that the resulting code will be HUGER and SLOWER, and probably
+	  not useful unless you are debugging a particular problem.
+
+	  Say N unless you are an XFS developer, or you play one on TV.
+
 config XFS_ASSERT_FATAL
 	bool "XFS fatal asserts"
 	default y
diff --git a/fs/xfs/xfs.h b/fs/xfs/xfs.h
index f6ffb4f248f7..9355ccad9503 100644
--- a/fs/xfs/xfs.h
+++ b/fs/xfs/xfs.h
@@ -10,6 +10,10 @@
 #define DEBUG 1
 #endif
 
+#ifdef CONFIG_XFS_DEBUG_EXPENSIVE
+#define DEBUG_EXPENSIVE 1
+#endif
+
 #ifdef CONFIG_XFS_ASSERT_FATAL
 #define XFS_ASSERT_FATAL 1
 #endif
diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 43031842341a..47549cfa61cd 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -22,6 +22,7 @@
 #include "xfs_trace.h"
 #include "xfs_log.h"
 #include "xfs_log_priv.h"
+#include "xfs_error.h"
 
 
 struct kmem_cache	*xfs_buf_item_cache;
@@ -781,8 +782,39 @@ xfs_buf_item_committed(
 	return lsn;
 }
 
+#ifdef DEBUG_EXPENSIVE
+static int
+xfs_buf_item_precommit(
+	struct xfs_trans	*tp,
+	struct xfs_log_item	*lip)
+{
+	struct xfs_buf_log_item	*bip = BUF_ITEM(lip);
+	struct xfs_buf		*bp = bip->bli_buf;
+	struct xfs_mount	*mp = bp->b_mount;
+	xfs_failaddr_t		fa;
+
+	if (!bp->b_ops || !bp->b_ops->verify_struct)
+		return 0;
+	if (bip->bli_flags & XFS_BLI_STALE)
+		return 0;
+
+	fa = bp->b_ops->verify_struct(bp);
+	if (fa) {
+		xfs_buf_verifier_error(bp, -EFSCORRUPTED, bp->b_ops->name,
+				bp->b_addr, BBTOB(bp->b_length), fa);
+		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+		ASSERT(fa == NULL);
+	}
+
+	return 0;
+}
+#else
+# define xfs_buf_item_precommit	NULL
+#endif
+
 static const struct xfs_item_ops xfs_buf_item_ops = {
 	.iop_size	= xfs_buf_item_size,
+	.iop_precommit	= xfs_buf_item_precommit,
 	.iop_format	= xfs_buf_item_format,
 	.iop_pin	= xfs_buf_item_pin,
 	.iop_unpin	= xfs_buf_item_unpin,
diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
index 6a1aae799cf1..7d19091215b0 100644
--- a/fs/xfs/xfs_dquot_item.c
+++ b/fs/xfs/xfs_dquot_item.c
@@ -17,6 +17,7 @@
 #include "xfs_trans_priv.h"
 #include "xfs_qm.h"
 #include "xfs_log.h"
+#include "xfs_error.h"
 
 static inline struct xfs_dq_logitem *DQUOT_ITEM(struct xfs_log_item *lip)
 {
@@ -193,8 +194,38 @@ xfs_qm_dquot_logitem_committing(
 	return xfs_qm_dquot_logitem_release(lip);
 }
 
+#ifdef DEBUG_EXPENSIVE
+static int
+xfs_qm_dquot_logitem_precommit(
+	struct xfs_trans	*tp,
+	struct xfs_log_item	*lip)
+{
+	struct xfs_dquot	*dqp = DQUOT_ITEM(lip)->qli_dquot;
+	struct xfs_mount	*mp = dqp->q_mount;
+	struct xfs_disk_dquot	ddq = { };
+	xfs_failaddr_t		fa;
+
+	xfs_dquot_to_disk(&ddq, dqp);
+	fa = xfs_dquot_verify(mp, &ddq, dqp->q_id);
+	if (fa) {
+		XFS_CORRUPTION_ERROR("Bad dquot during logging",
+				XFS_ERRLEVEL_LOW, mp, &ddq, sizeof(ddq));
+		xfs_alert(mp,
+ "Metadata corruption detected at %pS, dquot 0x%x",
+				fa, dqp->q_id);
+		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+		ASSERT(fa == NULL);
+	}
+
+	return 0;
+}
+#else
+# define xfs_qm_dquot_logitem_precommit	NULL
+#endif
+
 static const struct xfs_item_ops xfs_dquot_item_ops = {
 	.iop_size	= xfs_qm_dquot_logitem_size,
+	.iop_precommit	= xfs_qm_dquot_logitem_precommit,
 	.iop_format	= xfs_qm_dquot_logitem_format,
 	.iop_pin	= xfs_qm_dquot_logitem_pin,
 	.iop_unpin	= xfs_qm_dquot_logitem_unpin,
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index f28d653300d1..ef05cbbe116c 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -37,6 +37,36 @@ xfs_inode_item_sort(
 	return INODE_ITEM(lip)->ili_inode->i_ino;
 }
 
+#ifdef DEBUG_EXPENSIVE
+static void
+xfs_inode_item_precommit_check(
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_dinode	*dip;
+	xfs_failaddr_t		fa;
+
+	dip = kzalloc(mp->m_sb.sb_inodesize, GFP_KERNEL | GFP_NOFS);
+	if (!dip) {
+		ASSERT(dip != NULL);
+		return;
+	}
+
+	xfs_inode_to_disk(ip, dip, 0);
+	xfs_dinode_calc_crc(mp, dip);
+	fa = xfs_dinode_verify(mp, ip->i_ino, dip);
+	if (fa) {
+		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, dip,
+				sizeof(*dip), fa);
+		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
+		ASSERT(fa == NULL);
+	}
+	kfree(dip);
+}
+#else
+# define xfs_inode_item_precommit_check(ip)	((void)0)
+#endif
+
 /*
  * Prior to finally logging the inode, we have to ensure that all the
  * per-modification inode state changes are applied. This includes VFS inode
@@ -169,6 +199,8 @@ xfs_inode_item_precommit(
 	iip->ili_fields |= (flags | iip->ili_last_fields);
 	spin_unlock(&iip->ili_lock);
 
+	xfs_inode_item_precommit_check(ip);
+
 	/*
 	 * We are done with the log item transaction dirty state, so clear it so
 	 * that it doesn't pollute future transactions.


