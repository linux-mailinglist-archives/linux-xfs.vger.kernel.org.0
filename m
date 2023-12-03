Return-Path: <linux-xfs+bounces-327-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C3FA780266A
	for <lists+linux-xfs@lfdr.de>; Sun,  3 Dec 2023 20:00:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 653F0280C54
	for <lists+linux-xfs@lfdr.de>; Sun,  3 Dec 2023 19:00:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2761E17992;
	Sun,  3 Dec 2023 19:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V3WkQ29y"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D781517735
	for <linux-xfs@vger.kernel.org>; Sun,  3 Dec 2023 19:00:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46996C433C7;
	Sun,  3 Dec 2023 19:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701630034;
	bh=a6wB57QzO9tclEU95nRRe8zDbxu4gg5aRBE+joK/SME=;
	h=Date:Subject:From:To:Cc:From;
	b=V3WkQ29ySJ30piWauvB4jsRL0ESXb5oL9HM80DLp6kZSn13lQjlAr6BahD2P4gkyL
	 quV0KeBnDzY/4VzBAl9EOilEEoMjcS6omty3TOKG1/oeKAg874k7NOokqlh6d2XFc9
	 nXs/Z+xALbj7CQbDFMM9awDrMwq5YMS5iqqWbXSYT+ymyNus7FsufxGHRMWPCKj6vf
	 BcoilO7C7ThUwVBbsbwGHTi6DK8KEmvgR5neQjYCM1GYFsfJzdTMCiuFthtAK6yMj1
	 W8YLHJZtLlBDN03cUQOQf9yPFZ2MNWu7Sg4eINeYQfch/FP9e1522gCNNtV+9UTqi5
	 AsGgci967dwhQ==
Date: Sun, 03 Dec 2023 11:00:33 -0800
Subject: [PATCHSET v2 0/8] xfs: log intent item recovery should reconstruct
 defer work state
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org, hch@lst.de,
 leo.lilong@huawei.com
Cc: linux-xfs@vger.kernel.org
Message-ID: <170162989691.3037528.5056861908451814336.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi all,

Long Li reported a KASAN report from a UAF when intent recovery fails:

 ==================================================================
 BUG: KASAN: slab-use-after-free in xfs_cui_release+0xb7/0xc0
 Read of size 4 at addr ffff888012575e60 by task kworker/u8:3/103
 CPU: 3 PID: 103 Comm: kworker/u8:3 Not tainted 6.4.0-rc7-next-20230619-00003-g94543a53f9a4-dirty #166
 Workqueue: xfs-cil/sda xlog_cil_push_work
 Call Trace:
  <TASK>
  dump_stack_lvl+0x50/0x70
  print_report+0xc2/0x600
  kasan_report+0xb6/0xe0
  xfs_cui_release+0xb7/0xc0
  xfs_cud_item_release+0x3c/0x90
  xfs_trans_committed_bulk+0x2d5/0x7f0
  xlog_cil_committed+0xaba/0xf20
  xlog_cil_push_work+0x1a60/0x2360
  process_one_work+0x78e/0x1140
  worker_thread+0x58b/0xf60
  kthread+0x2cd/0x3c0
  ret_from_fork+0x1f/0x30
  </TASK>

 Allocated by task 531:
  kasan_save_stack+0x22/0x40
  kasan_set_track+0x25/0x30
  __kasan_slab_alloc+0x55/0x60
  kmem_cache_alloc+0x195/0x5f0
  xfs_cui_init+0x198/0x1d0
  xlog_recover_cui_commit_pass2+0x133/0x5f0
  xlog_recover_items_pass2+0x107/0x230
  xlog_recover_commit_trans+0x3e7/0x9c0
  xlog_recovery_process_trans+0x140/0x1d0
  xlog_recover_process_ophdr+0x1a0/0x3d0
  xlog_recover_process_data+0x108/0x2d0
  xlog_recover_process+0x1f6/0x280
  xlog_do_recovery_pass+0x609/0xdb0
  xlog_do_log_recovery+0x84/0xe0
  xlog_do_recover+0x7d/0x470
  xlog_recover+0x25f/0x490
  xfs_log_mount+0x2dd/0x6f0
  xfs_mountfs+0x11ce/0x1e70
  xfs_fs_fill_super+0x10ec/0x1b20
  get_tree_bdev+0x3c8/0x730
  vfs_get_tree+0x89/0x2c0
  path_mount+0xecf/0x1800
  do_mount+0xf3/0x110
  __x64_sys_mount+0x154/0x1f0
  do_syscall_64+0x39/0x80
  entry_SYSCALL_64_after_hwframe+0x63/0xcd

 Freed by task 531:
  kasan_save_stack+0x22/0x40
  kasan_set_track+0x25/0x30
  kasan_save_free_info+0x2b/0x40
  __kasan_slab_free+0x114/0x1b0
  kmem_cache_free+0xf8/0x510
  xfs_cui_item_free+0x95/0xb0
  xfs_cui_release+0x86/0xc0
  xlog_recover_cancel_intents.isra.0+0xf8/0x210
  xlog_recover_finish+0x7e7/0x980
  xfs_log_mount_finish+0x2bb/0x4a0
  xfs_mountfs+0x14bf/0x1e70
  xfs_fs_fill_super+0x10ec/0x1b20
  get_tree_bdev+0x3c8/0x730
  vfs_get_tree+0x89/0x2c0
  path_mount+0xecf/0x1800
  do_mount+0xf3/0x110
  __x64_sys_mount+0x154/0x1f0
  do_syscall_64+0x39/0x80
  entry_SYSCALL_64_after_hwframe+0x63/0xcd

 The buggy address belongs to the object at ffff888012575dc8
  which belongs to the cache xfs_cui_item of size 432
 The buggy address is located 152 bytes inside of
  freed 432-byte region [ffff888012575dc8, ffff888012575f78)

 The buggy address belongs to the physical page:
 page:ffffea0000495d00 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff888012576208 pfn:0x12574
 head:ffffea0000495d00 order:2 entire_mapcount:0 nr_pages_mapped:0 pincount:0
 flags: 0x1fffff80010200(slab|head|node=0|zone=1|lastcpupid=0x1fffff)
 page_type: 0xffffffff()
 raw: 001fffff80010200 ffff888012092f40 ffff888014570150 ffff888014570150
 raw: ffff888012576208 00000000001e0010 00000001ffffffff 0000000000000000
 page dumped because: kasan: bad access detected

 Memory state around the buggy address:
  ffff888012575d00: fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc fc
  ffff888012575d80: fc fc fc fc fc fc fc fc fc fa fb fb fb fb fb fb
 >ffff888012575e00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                        ^
  ffff888012575e80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff888012575f00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fc
 ==================================================================

"If process intents fails, intent items left in AIL will be delete
from AIL and freed in error handling, even intent items that have been
recovered and created done items. After this, uaf will be triggered when
done item committed, because at this point the released intent item will
be accessed.

xlog_recover_finish                     xlog_cil_push_work
----------------------------            ---------------------------
xlog_recover_process_intents
  xfs_cui_item_recover//cui_refcount == 1
    xfs_trans_get_cud
    xfs_trans_commit
      <add cud item to cil>
  xfs_cui_item_recover
    <error occurred and return>
xlog_recover_cancel_intents
  xfs_cui_release     //cui_refcount == 0
    xfs_cui_item_free //free cui
  <release other intent items>
xlog_force_shutdown   //shutdown
                               <...>
                                        <push items in cil>
                                        xlog_cil_committed
                                          xfs_cud_item_release
                                            xfs_cui_release // UAF

"Intent log items are created with a reference count of 2, one for the
creator, and one for the intent done object. Log recovery explicitly
drops the creator reference after it is inserted into the AIL, but it
then processes the log item as if it also owns the intent-done reference.

"The code in ->iop_recovery should assume that it passes the reference
to the done intent, we can remove the intent item from the AIL after
creating the done-intent, but if that code fails before creating the
done-intent then it needs to release the intent reference by log recovery
itself.

"That way when we go to cancel the intent, the only intents we find in
the AIL are the ones we know have not been processed yet and hence we
can safely drop both the creator and the intent done reference from
xlog_recover_cancel_intents().

"Hence if we remove the intent from the list of intents that need to
be recovered after we have done the initial recovery, we acheive two
things:

"1. the tail of the log can be moved forward with the commit of the
done intent or new intent to continue the operation, and

"2. We avoid the problem of trying to determine how many reference
counts we need to drop from intent recovery cancelling because we
never come across intents we've actually attempted recovery on."

Restated: The cause of the UAF is that xlog_recover_cancel_intents
thinks that it owns the refcount on any intent item in the AIL, and that
it's always safe to release these intent items.  This is not true after
the recovery function creates an log intent done item and points it at
the log intent item because releasing the done item always releases the
intent item.

The runtime defer ops code avoids all this by tracking both the log
intent and the intent done items, and releasing only the intent done
item if both have been created.  Long Li proposed fixing this by adding
state flags, but I have a more comprehensive fix.

First, observe that the latter half of the intent _recover functions are
nearly open-coded versions of the corresponding _finish_one function
that uses an onstack deferred work item to single-step through the item.

Second, notice that the recover function is not an exact match because
of the odd behavior that unfinished recovered work items are relogged
with separate log intent items instead of a single new log intent item,
which is what the defer ops machinery does.

Dave and I have long suspected that recovery should be reconstructing
the defer work state from what's in the recovered intent item.  Now we
finally have an excuse to refactor the code to do that.

This series starts by fixing a resource leak in LARP recovery.  We fix
the bug that Long Li reported by switching the intent recovery code to
construct chains of xfs_defer_pending objects and then using the defer
pending objects to track the intent/done item ownership.  Finally, we
clean up the code to reconstruct the exact incore state, which means we
can remove all the opencoded _recover code, which makes maintaining log
items much easier.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been lightly tested with fstests.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=reconstruct-defer-work-6.7
---
 fs/xfs/libxfs/xfs_defer.c       |  127 +++++++++++++++++++++++--------
 fs/xfs/libxfs/xfs_defer.h       |   19 +++++
 fs/xfs/libxfs/xfs_log_recover.h |    7 ++
 fs/xfs/xfs_attr_item.c          |  131 ++++++++++++++++----------------
 fs/xfs/xfs_bmap_item.c          |   89 +++++++++++-----------
 fs/xfs/xfs_extfree_item.c       |  127 +++++++++++++------------------
 fs/xfs/xfs_log.c                |    1 
 fs/xfs/xfs_log_priv.h           |    1 
 fs/xfs/xfs_log_recover.c        |  129 +++++++++++++++++--------------
 fs/xfs/xfs_refcount_item.c      |  138 +++++++++++----------------------
 fs/xfs/xfs_rmap_item.c          |  161 +++++++++++++++++++--------------------
 fs/xfs/xfs_trans.h              |    2 
 12 files changed, 483 insertions(+), 449 deletions(-)


