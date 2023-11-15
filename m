Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8C827EA86A
	for <lists+linux-xfs@lfdr.de>; Tue, 14 Nov 2023 02:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231970AbjKNBx4 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 13 Nov 2023 20:53:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231713AbjKNBxz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Nov 2023 20:53:55 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FBC9D44
        for <linux-xfs@vger.kernel.org>; Mon, 13 Nov 2023 17:53:52 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id d9443c01a7336-1cc938f9612so32893725ad.1
        for <linux-xfs@vger.kernel.org>; Mon, 13 Nov 2023 17:53:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699926831; x=1700531631; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TZ4/sHcptjfXgYs4wjxdLIXPGb/MxIb6ECUkbNFIOws=;
        b=WKYzkDJq8rMhTdedpAFgUVFq4R/GJ92fiYCqSGkfnj52ebgTji9GD7+EdLVOblGzDa
         CGIgzvPmdnlJVur4u6v7H3pcd3kfikgv0c8hMPpna14CqpABxgp5msYdkYxW0TMP4yom
         qfXsrOrfFnA6xGuFQARo3kt+R44lNOPNbxLU4FFYRD13LJhutPkYwce4pLT5Rtt/YHuM
         czHr/px0sVlx8zGPC8aEnfyU7bgg4G+NIQtsgaxddHUO43VO8fYqy3nmIlPGIwGm4R1i
         kKM81I97EK7MF1NNtls0/d5Z1+DJnKikKoeZf65vCEIyDhMvAhrjKIVfnL6f87FmqO3I
         mO1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699926831; x=1700531631;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TZ4/sHcptjfXgYs4wjxdLIXPGb/MxIb6ECUkbNFIOws=;
        b=mWWUOIcCUsFrB1eLKiXXCkgNpTHR6/JW8yKXEjXoyDyCgwfYIEuCTOBAuJRtZliz9C
         wqVWOLHo0o7VeHUUclYri2Vejw46+nG9lSodrVN2c3SYzAc7J3BjVWSL3ghfDTx/nN3Q
         0a+GdwMAfptb1MMtorB4hloCU+rb2FMb9XLwNbwXm6SbUgfNVeIs8/KapYourNzgh46S
         c+JrIDX8gxz0Gskub87Bl9QxubM1Ast4XBKwuPMi2P7ZpsUxo5CYY/JGQ147YVqcYzTI
         wJ1VJI9+qtx13ZR/MYP3KqYcmFTARMA7XLXkDmWIkAW+PctFuepN3gDHNI1OVkjskNSk
         NHRg==
X-Gm-Message-State: AOJu0Yy0Y8X7snvVGkI+IZDy7/nXqYyrae1qGs+MJaQ6demNyIpJb787
        4W57PmtuFfsJ9W1uZQsu6W9Fb2PAmFg8XQ==
X-Google-Smtp-Source: AGHT+IHAWhqmop+gWUTz5/v+OTE2B9map4v57eNxipm42lZeYE3tJm7D/47LD6s0Rlcriq9VvqI0Rg==
X-Received: by 2002:a17:902:7c8f:b0:1c0:bcbc:d64 with SMTP id y15-20020a1709027c8f00b001c0bcbc0d64mr910456pll.51.1699926831381;
        Mon, 13 Nov 2023 17:53:51 -0800 (PST)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:d177:a8ad:804f:74f1])
        by smtp.gmail.com with ESMTPSA id a17-20020a170902ecd100b001c9cb2fb8d8sm4668592plh.49.2023.11.13.17.53.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Nov 2023 17:53:51 -0800 (PST)
From:   Leah Rumancik <leah.rumancik@gmail.com>
To:     linux-xfs@vger.kernel.org
Cc:     amir73il@gmail.com, chandan.babu@oracle.com, fred@cloudflare.com,
        "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 5.15 CANDIDATE 05/17] xfs: prevent a UAF when log IO errors race with unmount
Date:   Mon, 13 Nov 2023 17:53:26 -0800
Message-ID: <20231114015339.3922119-6-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.43.0.rc0.421.g78406f8d94-goog
In-Reply-To: <20231114015339.3922119-1-leah.rumancik@gmail.com>
References: <20231114015339.3922119-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit 7561cea5dbb97fecb952548a0fb74fb105bf4664 ]

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
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/xfs/xfs_log.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 0fb7d05ca308..eba295f666ac 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2061,8 +2061,6 @@ xlog_dealloc_log(
 	xlog_in_core_t	*iclog, *next_iclog;
 	int		i;
 
-	xlog_cil_destroy(log);
-
 	/*
 	 * Cycle all the iclogbuf locks to make sure all log IO completion
 	 * is done before we tear down these buffers.
@@ -2074,6 +2072,13 @@ xlog_dealloc_log(
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
-- 
2.43.0.rc0.421.g78406f8d94-goog

