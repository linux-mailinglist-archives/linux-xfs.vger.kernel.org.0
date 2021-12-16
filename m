Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 222BB47673C
	for <lists+linux-xfs@lfdr.de>; Thu, 16 Dec 2021 02:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229809AbhLPBJj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 15 Dec 2021 20:09:39 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45380 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbhLPBJi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Dec 2021 20:09:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EF2261BB8
        for <linux-xfs@vger.kernel.org>; Thu, 16 Dec 2021 01:09:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7725C36AE0;
        Thu, 16 Dec 2021 01:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639616977;
        bh=uzRA+0mCayJ5o2F7FFi9w1Kg2ICJjpMEAdvgHCNllJI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=piUOAjc7KH5jYJsrvmTZuGguZxYTDsNS+Qj02/Jq5sKuS5d6CYVYc7BiiocuMCHTL
         xxisD/IX1vm/LEC2Fz7If+miNCajD2KVg45DiH8uwiAtZwmCBsyyzS8WF50KRqQXzG
         RsraPcrrxOEVwOwG/2YQHBgMqVywQOjlJ64id8zRz+PgXstGymnHIsFHnqLGLr+MvZ
         YHT4FpB+c9h4mQTQ9DRDse+ahonzcWH5UQU2gZ84Z7xm2G7yhy/cEu+C5gGLfM0f3A
         HZT/dg3/9rd6O4GGPwbR4MlyYCmuJILUfQLZTj5Kw8o/Cu7vrEjaiv5SNAESevHHIn
         hPFiOA0dG4LUg==
Subject: [PATCH 4/7] xfs: prevent UAF in xfs_log_item_in_current_chkpt
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 15 Dec 2021 17:09:37 -0800
Message-ID: <163961697749.3129691.10072192517670663885.stgit@magnolia>
In-Reply-To: <163961695502.3129691.3496134437073533141.stgit@magnolia>
References: <163961695502.3129691.3496134437073533141.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

While I was running with KASAN and lockdep enabled, I stumbled upon an
KASAN report about a UAF to a freed CIL checkpoint.  Looking at the
comment for xfs_log_item_in_current_chkpt, it seems pretty obvious to me
that the original patch to xfs_defer_finish_noroll should have done
something to lock the CIL to prevent it from switching the CIL contexts
while the predicate runs.

For upper level code that needs to know if a given log item is new
enough not to need relogging, add a new wrapper that takes the CIL
context lock long enough to sample the current CIL context.  This is
kind of racy in that the CIL can switch the contexts immediately after
sampling, but that's ok because the consequence is that the defer ops
code is a little slow to relog items.

 ==================================================================
 BUG: KASAN: use-after-free in xfs_log_item_in_current_chkpt+0x139/0x160 [xfs]
 Read of size 8 at addr ffff88804ea5f608 by task fsstress/527999

 CPU: 1 PID: 527999 Comm: fsstress Tainted: G      D      5.16.0-rc4-xfsx #rc4
 Call Trace:
  <TASK>
  dump_stack_lvl+0x45/0x59
  print_address_description.constprop.0+0x1f/0x140
  kasan_report.cold+0x83/0xdf
  xfs_log_item_in_current_chkpt+0x139/0x160
  xfs_defer_finish_noroll+0x3bb/0x1e30
  __xfs_trans_commit+0x6c8/0xcf0
  xfs_reflink_remap_extent+0x66f/0x10e0
  xfs_reflink_remap_blocks+0x2dd/0xa90
  xfs_file_remap_range+0x27b/0xc30
  vfs_dedupe_file_range_one+0x368/0x420
  vfs_dedupe_file_range+0x37c/0x5d0
  do_vfs_ioctl+0x308/0x1260
  __x64_sys_ioctl+0xa1/0x170
  do_syscall_64+0x35/0x80
  entry_SYSCALL_64_after_hwframe+0x44/0xae
 RIP: 0033:0x7f2c71a2950b
 Code: 0f 1e fa 48 8b 05 85 39 0d 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff
ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01
f0 ff ff 73 01 c3 48 8b 0d 55 39 0d 00 f7 d8 64 89 01 48
 RSP: 002b:00007ffe8c0e03c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
 RAX: ffffffffffffffda RBX: 00005600862a8740 RCX: 00007f2c71a2950b
 RDX: 00005600862a7be0 RSI: 00000000c0189436 RDI: 0000000000000004
 RBP: 000000000000000b R08: 0000000000000027 R09: 0000000000000003
 R10: 0000000000000000 R11: 0000000000000246 R12: 000000000000005a
 R13: 00005600862804a8 R14: 0000000000016000 R15: 00005600862a8a20
  </TASK>

 Allocated by task 464064:
  kasan_save_stack+0x1e/0x50
  __kasan_kmalloc+0x81/0xa0
  kmem_alloc+0xcd/0x2c0 [xfs]
  xlog_cil_ctx_alloc+0x17/0x1e0 [xfs]
  xlog_cil_push_work+0x141/0x13d0 [xfs]
  process_one_work+0x7f6/0x1380
  worker_thread+0x59d/0x1040
  kthread+0x3b0/0x490
  ret_from_fork+0x1f/0x30

 Freed by task 51:
  kasan_save_stack+0x1e/0x50
  kasan_set_track+0x21/0x30
  kasan_set_free_info+0x20/0x30
  __kasan_slab_free+0xed/0x130
  slab_free_freelist_hook+0x7f/0x160
  kfree+0xde/0x340
  xlog_cil_committed+0xbfd/0xfe0 [xfs]
  xlog_cil_process_committed+0x103/0x1c0 [xfs]
  xlog_state_do_callback+0x45d/0xbd0 [xfs]
  xlog_ioend_work+0x116/0x1c0 [xfs]
  process_one_work+0x7f6/0x1380
  worker_thread+0x59d/0x1040
  kthread+0x3b0/0x490
  ret_from_fork+0x1f/0x30

 Last potentially related work creation:
  kasan_save_stack+0x1e/0x50
  __kasan_record_aux_stack+0xb7/0xc0
  insert_work+0x48/0x2e0
  __queue_work+0x4e7/0xda0
  queue_work_on+0x69/0x80
  xlog_cil_push_now.isra.0+0x16b/0x210 [xfs]
  xlog_cil_force_seq+0x1b7/0x850 [xfs]
  xfs_log_force_seq+0x1c7/0x670 [xfs]
  xfs_file_fsync+0x7c1/0xa60 [xfs]
  __x64_sys_fsync+0x52/0x80
  do_syscall_64+0x35/0x80
  entry_SYSCALL_64_after_hwframe+0x44/0xae

 The buggy address belongs to the object at ffff88804ea5f600
  which belongs to the cache kmalloc-256 of size 256
 The buggy address is located 8 bytes inside of
  256-byte region [ffff88804ea5f600, ffff88804ea5f700)
 The buggy address belongs to the page:
 page:ffffea00013a9780 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff88804ea5ea00 pfn:0x4ea5e
 head:ffffea00013a9780 order:1 compound_mapcount:0
 flags: 0x4fff80000010200(slab|head|node=1|zone=1|lastcpupid=0xfff)
 raw: 04fff80000010200 ffffea0001245908 ffffea00011bd388 ffff888004c42b40
 raw: ffff88804ea5ea00 0000000000100009 00000001ffffffff 0000000000000000
 page dumped because: kasan: bad access detected

 Memory state around the buggy address:
  ffff88804ea5f500: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff88804ea5f580: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 >ffff88804ea5f600: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                       ^
  ffff88804ea5f680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff88804ea5f700: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ==================================================================

Fixes: 4e919af7827a ("xfs: periodically relog deferred intent items")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_buf_item.c |    2 +-
 fs/xfs/xfs_log.h      |    1 +
 fs/xfs/xfs_log_cil.c  |   25 ++++++++++++++++++++++---
 3 files changed, 24 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index a7a8e4528881..41a77f4e42ab 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -430,7 +430,7 @@ xfs_buf_item_format(
 	if (bip->bli_flags & XFS_BLI_INODE_BUF) {
 		if (xfs_has_v3inodes(lip->li_mountp) ||
 		    !((bip->bli_flags & XFS_BLI_INODE_ALLOC_BUF) &&
-		      xfs_log_item_in_current_chkpt(lip)))
+		      __xfs_log_item_in_current_chkpt(lip)))
 			bip->__bli_format.blf_flags |= XFS_BLF_INODE_BUF;
 		bip->bli_flags &= ~XFS_BLI_INODE_BUF;
 	}
diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
index dc1b77b92fc1..6c7b6981c443 100644
--- a/fs/xfs/xfs_log.h
+++ b/fs/xfs/xfs_log.h
@@ -132,6 +132,7 @@ struct xlog_ticket *xfs_log_ticket_get(struct xlog_ticket *ticket);
 void	  xfs_log_ticket_put(struct xlog_ticket *ticket);
 
 void	xlog_cil_process_committed(struct list_head *list);
+bool	__xfs_log_item_in_current_chkpt(struct xfs_log_item *lip);
 bool	xfs_log_item_in_current_chkpt(struct xfs_log_item *lip);
 
 void	xfs_log_work_queue(struct xfs_mount *mp);
diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
index 6c93c8ada6f3..62e84e040642 100644
--- a/fs/xfs/xfs_log_cil.c
+++ b/fs/xfs/xfs_log_cil.c
@@ -1441,10 +1441,10 @@ xlog_cil_force_seq(
  * transaction commit process when deciding what to format into the item.
  */
 bool
-xfs_log_item_in_current_chkpt(
-	struct xfs_log_item *lip)
+__xfs_log_item_in_current_chkpt(
+	struct xfs_log_item	*lip)
 {
-	struct xfs_cil_ctx *ctx = lip->li_mountp->m_log->l_cilp->xc_ctx;
+	struct xfs_cil_ctx	*ctx = lip->li_mountp->m_log->l_cilp->xc_ctx;
 
 	if (list_empty(&lip->li_cil))
 		return false;
@@ -1457,6 +1457,25 @@ xfs_log_item_in_current_chkpt(
 	return lip->li_seq == ctx->sequence;
 }
 
+/*
+ * Check if the current log item was first committed in this sequence.
+ * This version locks out CIL flushes, but can only be used to gather
+ * a rough estimate of the answer.
+ */
+bool
+xfs_log_item_in_current_chkpt(
+	struct xfs_log_item	*lip)
+{
+	struct xfs_cil		*cil = lip->li_mountp->m_log->l_cilp;
+	bool			ret;
+
+	down_read(&cil->xc_ctx_lock);
+	ret = __xfs_log_item_in_current_chkpt(lip);
+	up_read(&cil->xc_ctx_lock);
+
+	return ret;
+}
+
 /*
  * Perform initial CIL structure initialisation.
  */

