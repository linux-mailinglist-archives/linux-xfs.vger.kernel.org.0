Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2FFA5627A5
	for <lists+linux-xfs@lfdr.de>; Fri,  1 Jul 2022 02:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbiGAAPT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 30 Jun 2022 20:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbiGAAPS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 30 Jun 2022 20:15:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CB0E38DB2
        for <linux-xfs@vger.kernel.org>; Thu, 30 Jun 2022 17:15:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB42161E69
        for <linux-xfs@vger.kernel.org>; Fri,  1 Jul 2022 00:15:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EA63C34115
        for <linux-xfs@vger.kernel.org>; Fri,  1 Jul 2022 00:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656634516;
        bh=9iRnFp2dQ3CgVZL4zSs5hqlK4Okdv2SQ81s3vdKyEDI=;
        h=Date:From:To:Subject:From;
        b=lgybkX8UutvK3X6zrzl+DExWEWaSyyAC4IGoRlvCTf+2QaF9FfUFg3b9Aci51XxAw
         VxMUJPyJju1JHPMDlFEWCIyxgeGXb4hBux7s/aFkYxcn+z+BmRBR3FV045MwHlt+VJ
         m6wIqPhUMawEANNhc19I5T8K8j88Nvqi6sZkILZRZb7rKPoRpweHMJ7BDs7LPdrOmT
         qh3HysWmH5Os9ZZFOAaNpX1/TNSl7TASpk6QWHmsx7vakfYrkqylO6Q5JAdVdDrDzl
         mvx+Ch4gc5yk2woruJCxaDVmLY3AWCtnoFK3yFMG53qkiSThXkxvpQWKg+wPcgCuFQ
         VDfwbYzD55alA==
Date:   Thu, 30 Jun 2022 17:15:15 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: prevent a UAF when log IO errors race with unmount
Message-ID: <Yr48k2DII3dhmaPM@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

KASAN reported the following use after free bug when running
generic/475:

 XFS (dm-0): Mounting V5 Filesystem
 XFS (dm-0): Starting recovery (logdev: internal)
 XFS (dm-0): Ending recovery (logdev: internal)
 Buffer I/O error on dev dm-0, logical block 20639616, async page read
 Buffer I/O error on dev dm-0, logical block 20639617, async page read
 XFS (dm-0): log I/O error -5
 XFS (dm-0): Filesystem has been shut down due to log error (0x2).
 XFS (dm-0): Unmounting Filesystem
 XFS (dm-0): Please unmount the filesystem and rectify the problem(s).
 ==================================================================
 BUG: KASAN: use-after-free in do_raw_spin_lock+0x246/0x270
 Read of size 4 at addr ffff888109dd84c4 by task 3:1H/136

 CPU: 3 PID: 136 Comm: 3:1H Not tainted 5.19.0-rc4-xfsx #rc4 8e53ab5ad0fddeb31cee5e7063ff9c361915a9c4
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1 04/01/2014
 Workqueue: xfs-log/dm-0 xlog_ioend_work [xfs]
 Call Trace:
  <TASK>
  dump_stack_lvl+0x34/0x44
  print_report.cold+0x2b8/0x661
  ? do_raw_spin_lock+0x246/0x270
  kasan_report+0xab/0x120
  ? do_raw_spin_lock+0x246/0x270
  do_raw_spin_lock+0x246/0x270
  ? rwlock_bug.part.0+0x90/0x90
  xlog_force_shutdown+0xf6/0x370 [xfs 4ad76ae0d6add7e8183a553e624c31e9ed567318]
  xlog_ioend_work+0x100/0x190 [xfs 4ad76ae0d6add7e8183a553e624c31e9ed567318]
  process_one_work+0x672/0x1040
  worker_thread+0x59b/0xec0
  ? __kthread_parkme+0xc6/0x1f0
  ? process_one_work+0x1040/0x1040
  ? process_one_work+0x1040/0x1040
  kthread+0x29e/0x340
  ? kthread_complete_and_exit+0x20/0x20
  ret_from_fork+0x1f/0x30
  </TASK>

 Allocated by task 154099:
  kasan_save_stack+0x1e/0x40
  __kasan_kmalloc+0x81/0xa0
  kmem_alloc+0x8d/0x2e0 [xfs]
  xlog_cil_init+0x1f/0x540 [xfs]
  xlog_alloc_log+0xd1e/0x1260 [xfs]
  xfs_log_mount+0xba/0x640 [xfs]
  xfs_mountfs+0xf2b/0x1d00 [xfs]
  xfs_fs_fill_super+0x10af/0x1910 [xfs]
  get_tree_bdev+0x383/0x670
  vfs_get_tree+0x7d/0x240
  path_mount+0xdb7/0x1890
  __x64_sys_mount+0x1fa/0x270
  do_syscall_64+0x2b/0x80
  entry_SYSCALL_64_after_hwframe+0x46/0xb0

 Freed by task 154151:
  kasan_save_stack+0x1e/0x40
  kasan_set_track+0x21/0x30
  kasan_set_free_info+0x20/0x30
  ____kasan_slab_free+0x110/0x190
  slab_free_freelist_hook+0xab/0x180
  kfree+0xbc/0x310
  xlog_dealloc_log+0x1b/0x2b0 [xfs]
  xfs_unmountfs+0x119/0x200 [xfs]
  xfs_fs_put_super+0x6e/0x2e0 [xfs]
  generic_shutdown_super+0x12b/0x3a0
  kill_block_super+0x95/0xd0
  deactivate_locked_super+0x80/0x130
  cleanup_mnt+0x329/0x4d0
  task_work_run+0xc5/0x160
  exit_to_user_mode_prepare+0xd4/0xe0
  syscall_exit_to_user_mode+0x1d/0x40
  entry_SYSCALL_64_after_hwframe+0x46/0xb0

This appears to be a race between the unmount process, which frees the
CIL and waits for in-flight iclog IO; and the iclog IO completion.  When
generic/475 runs, it starts fsstress in the background, waits a few
seconds, and substitutes a dm-error device to simulate a disk falling
out of a machine.  If the fsstress encounters EIO on a pure data write,
it will exit but the filesystem will still be online.

The next thing the test does is unmount the filesystem, which tries to
clean the log, free the CIL, and wait for iclog IO completion.  If an
iclog was being written when the dm-error switch occurred, it can race
with log unmounting as follows:

Thread 1				Thread 2

					xfs_log_unmount
					xfs_log_clean
					xfs_log_quiesce
xlog_ioend_work
<observe error>
xlog_force_shutdown
test_and_set_bit(XLOG_IOERROR)
					xfs_log_force
					<log is shut down, nop>
					xfs_log_umount_write
					<log is shut down, nop>
					xlog_dealloc_log
					xlog_cil_destroy
					<wait for iclogs>
spin_lock(&log->l_cilp->xc_push_lock)
<KABOOM>

Therefore, free the CIL after waiting for the iclogs to complete.  I
/think/ this race has existed for quite a few years now, though I don't
remember the ~2014 era logging code well enough to know if it was a real
threat then or if the actual race was exposed only more recently.

Fixes: ac983517ec59 ("xfs: don't sleep in xlog_cil_force_lsn on shutdown")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_log.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 81940a99f8aa..498cbb49392b 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2105,8 +2105,6 @@ xlog_dealloc_log(
 	xlog_in_core_t	*iclog, *next_iclog;
 	int		i;
 
-	xlog_cil_destroy(log);
-
 	/*
 	 * Cycle all the iclogbuf locks to make sure all log IO completion
 	 * is done before we tear down these buffers.
@@ -2118,6 +2116,13 @@ xlog_dealloc_log(
 		iclog = iclog->ic_next;
 	}
 
+	/*
+	 * Destroy the CIL after waiting for iclog IO completion because an
+	 * iclog EIO error will try to shut down the log, which accesses the
+	 * CIL to wake up the waiters.
+	 */
+	xlog_cil_destroy(log);
+
 	iclog = log->l_iclog;
 	for (i = 0; i < log->l_iclog_bufs; i++) {
 		next_iclog = iclog->ic_next;
