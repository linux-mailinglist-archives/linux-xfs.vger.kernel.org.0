Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2C64D2687
	for <lists+linux-xfs@lfdr.de>; Wed,  9 Mar 2022 05:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbiCIB4Q (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 8 Mar 2022 20:56:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231264AbiCIB4P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Mar 2022 20:56:15 -0500
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E5A43419A6
        for <linux-xfs@vger.kernel.org>; Tue,  8 Mar 2022 17:55:16 -0800 (PST)
Received: from dread.disaster.area (pa49-186-17-0.pa.vic.optusnet.com.au [49.186.17.0])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 0C16B10E262B
        for <linux-xfs@vger.kernel.org>; Wed,  9 Mar 2022 12:55:15 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nRlXn-003DPO-58
        for linux-xfs@vger.kernel.org; Wed, 09 Mar 2022 12:55:15 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nRlXn-00B723-44
        for linux-xfs@vger.kernel.org;
        Wed, 09 Mar 2022 12:55:15 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/4] xfs: log worker needs to start before intent/unlink recovery
Date:   Wed,  9 Mar 2022 12:55:09 +1100
Message-Id: <20220309015512.2648074-2-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220309015512.2648074-1-david@fromorbit.com>
References: <20220309015512.2648074-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62280904
        a=+dVDrTVfsjPpH/ci3UuFng==:117 a=+dVDrTVfsjPpH/ci3UuFng==:17
        a=o8Y5sQTvuykA:10 a=20KFwNOVAAAA:8 a=9zfcJeoDbhBuSCwZ9u8A:9
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

After 963 iterations of generic/530, it deadlocked during recovery
on a pinned inode cluster buffer like so:

XFS (pmem1): Starting recovery (logdev: internal)
INFO: task kworker/8:0:306037 blocked for more than 122 seconds.
      Not tainted 5.17.0-rc6-dgc+ #975
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/8:0     state:D stack:13024 pid:306037 ppid:     2 flags:0x00004000
Workqueue: xfs-inodegc/pmem1 xfs_inodegc_worker
Call Trace:
 <TASK>
 __schedule+0x30d/0x9e0
 schedule+0x55/0xd0
 schedule_timeout+0x114/0x160
 __down+0x99/0xf0
 down+0x5e/0x70
 xfs_buf_lock+0x36/0xf0
 xfs_buf_find+0x418/0x850
 xfs_buf_get_map+0x47/0x380
 xfs_buf_read_map+0x54/0x240
 xfs_trans_read_buf_map+0x1bd/0x490
 xfs_imap_to_bp+0x4f/0x70
 xfs_iunlink_map_ino+0x66/0xd0
 xfs_iunlink_map_prev.constprop.0+0x148/0x2f0
 xfs_iunlink_remove_inode+0xf2/0x1d0
 xfs_inactive_ifree+0x1a3/0x900
 xfs_inode_unlink+0xcc/0x210
 xfs_inodegc_worker+0x1ac/0x2f0
 process_one_work+0x1ac/0x390
 worker_thread+0x56/0x3c0
 kthread+0xf6/0x120
 ret_from_fork+0x1f/0x30
 </TASK>
task:mount           state:D stack:13248 pid:324509 ppid:324233 flags:0x00004000
Call Trace:
 <TASK>
 __schedule+0x30d/0x9e0
 schedule+0x55/0xd0
 schedule_timeout+0x114/0x160
 __down+0x99/0xf0
 down+0x5e/0x70
 xfs_buf_lock+0x36/0xf0
 xfs_buf_find+0x418/0x850
 xfs_buf_get_map+0x47/0x380
 xfs_buf_read_map+0x54/0x240
 xfs_trans_read_buf_map+0x1bd/0x490
 xfs_imap_to_bp+0x4f/0x70
 xfs_iget+0x300/0xb40
 xlog_recover_process_one_iunlink+0x4c/0x170
 xlog_recover_process_iunlinks.isra.0+0xee/0x130
 xlog_recover_finish+0x57/0x110
 xfs_log_mount_finish+0xfc/0x1e0
 xfs_mountfs+0x540/0x910
 xfs_fs_fill_super+0x495/0x850
 get_tree_bdev+0x171/0x270
 xfs_fs_get_tree+0x15/0x20
 vfs_get_tree+0x24/0xc0
 path_mount+0x304/0xba0
 __x64_sys_mount+0x108/0x140
 do_syscall_64+0x35/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
 </TASK>
task:xfsaild/pmem1   state:D stack:14544 pid:324525 ppid:     2 flags:0x00004000
Call Trace:
 <TASK>
 __schedule+0x30d/0x9e0
 schedule+0x55/0xd0
 io_schedule+0x4b/0x80
 xfs_buf_wait_unpin+0x9e/0xf0
 __xfs_buf_submit+0x14a/0x230
 xfs_buf_delwri_submit_buffers+0x107/0x280
 xfs_buf_delwri_submit_nowait+0x10/0x20
 xfsaild+0x27e/0x9d0
 kthread+0xf6/0x120
 ret_from_fork+0x1f/0x30

We have the mount process waiting on an inode cluster buffer read,
inodegc doing unlink waiting on the same inode cluster buffer, and
the AIL push thread blocked in writeback waiting for the inode to
become unpinned.

What has happened here is that the AIL push thread has raced with
the inodegc process modifying, committing and pinning the inode
cluster buffer here in xfs_buf_delwri_submit_buffers() here:

	blk_start_plug(&plug);
	list_for_each_entry_safe(bp, n, buffer_list, b_list) {
		if (!wait_list) {
			if (xfs_buf_ispinned(bp)) {
				pinned++;
				continue;
			}
Here >>>>>>
			if (!xfs_buf_trylock(bp))
				continue;

Basically, the AIL has found the buffer wasn't pinned and got the
lock without blocking, but then the buffer was pinned. This implies
the processing here was pre-empted between the pin check and the
lock, because the pin count can only be increased while holding the
buffer locked. Hence when it has gone to submit the IO, it has
blocked waiting for the buffer to be unpinned.

With all executing threads now waiting on the buffer to be unpinned,
we normally get out of situations like this via the background log
worker issuing a log force which will unpinned stuck buffers like
this. But at this point in recovery, we haven't started the log
worker. In fact, the first thing we do after processing intents and
unlinked inodes is *start the log worker*. IOWs, we start it too
late to have it break deadlocks like this.

Avoid this and any other similar deadlock vectors in intent and
unlinked inode recovery by starting the log worker before we recover
intents and unlinked inodes. This part of recovery runs as though
the filesystem is fully active, so we really should have the same
infrastructure running as we normally do at runtime.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 89fec9a18c34..ffd928cf9a9a 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -812,10 +812,9 @@ xfs_log_mount_finish(
 	 * mount failure occurs.
 	 */
 	mp->m_super->s_flags |= SB_ACTIVE;
+	xfs_log_work_queue(mp);
 	if (xlog_recovery_needed(log))
 		error = xlog_recover_finish(log);
-	if (!error)
-		xfs_log_work_queue(mp);
 	mp->m_super->s_flags &= ~SB_ACTIVE;
 	evict_inodes(mp->m_super);
 
-- 
2.33.0

