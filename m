Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FA8057C70
	for <lists+linux-xfs@lfdr.de>; Thu, 27 Jun 2019 08:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbfF0GuH (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 27 Jun 2019 02:50:07 -0400
Received: from mail-io1-f69.google.com ([209.85.166.69]:40518 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726052AbfF0GuH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jun 2019 02:50:07 -0400
Received: by mail-io1-f69.google.com with SMTP id v11so1508136iop.7
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jun 2019 23:50:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Nxit/g7Ykx29lGaYdx6aqLLQUOwt+05rBgigMbRNMck=;
        b=FoNpqKzXOaKu9s3vnP8HomjolNEJbchE0xAO57Lj4RSKHD4UmZ9sUOOuzRM0dvth1t
         KOLpt8bBO4IOU0QKbWl0va3kY0aRKfp1jORdQ4ehdUVDQP5tjuKtsGpjKA6Ms0NlzwMd
         ycQ/WLhwrc/I6TuuAm9vm4wQR2XnGusX+dqrrxP0gMPxd88Ms2B2nHLydt9JQJwNCsmI
         VM/JRnIGwKG4OEcLgcrL3xhpuwVtLFiK7weO6wKoPqI9mK292LpdP8lfWoJF9JrOwB4R
         2TfK9WxK09WRZeb3FJFDybSd+pkKyPpVnwxKWIVUALDbppbQd+BS0dqYpI4lArRlTDdU
         6EtQ==
X-Gm-Message-State: APjAAAX6g2jDhgMqaVeJi86xikl5AA3M9rF7fApemWzmCBs7cLLA/THm
        HQFJUTQZ80ohaMYYawZK/btuo+GwGDfKim36GVMFZhZHNEsj
X-Google-Smtp-Source: APXvYqx7uqAqHG/vl7tHGuZxqssFsA1F76413L/t2nfnfgLnTmp3MlgHoI/jDgXSucVOBZHgr4ki4Do/LiIz3KfPTr3n/OHZ7TEs
MIME-Version: 1.0
X-Received: by 2002:a5e:d615:: with SMTP id w21mr2903087iom.0.1561618206437;
 Wed, 26 Jun 2019 23:50:06 -0700 (PDT)
Date:   Wed, 26 Jun 2019 23:50:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000783d99058c489257@google.com>
Subject: KASAN: use-after-free Read in xlog_alloc_log
From:   syzbot <syzbot+b75afdbe271a0d7ac4f6@syzkaller.appspotmail.com>
To:     darrick.wong@oracle.com, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    1dd45f17 Add linux-next specific files for 20190626
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=172479e9a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c1222640552e42a5
dashboard link: https://syzkaller.appspot.com/bug?extid=b75afdbe271a0d7ac4f6
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+b75afdbe271a0d7ac4f6@syzkaller.appspotmail.com

XFS (loop5): Mounting V4 Filesystem
==================================================================
BUG: KASAN: use-after-free in xlog_alloc_log+0x1266/0x1380  
fs/xfs/xfs_log.c:1478
Read of size 8 at addr ffff8880693e2990 by task syz-executor.5/12241

CPU: 1 PID: 12241 Comm: syz-executor.5 Not tainted 5.2.0-rc6-next-20190626  
#23
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  print_address_description.cold+0xd4/0x306 mm/kasan/report.c:351
  __kasan_report.cold+0x1b/0x36 mm/kasan/report.c:482
  kasan_report+0x12/0x17 mm/kasan/common.c:614
  __asan_report_load8_noabort+0x14/0x20 mm/kasan/generic_report.c:132
  xlog_alloc_log+0x1266/0x1380 fs/xfs/xfs_log.c:1478
  xfs_log_mount+0xdc/0x780 fs/xfs/xfs_log.c:580
  xfs_mountfs+0xdb9/0x1be0 fs/xfs/xfs_mount.c:815
  xfs_fs_fill_super+0xca6/0x16c0 fs/xfs/xfs_super.c:1740
  mount_bdev+0x304/0x3c0 fs/super.c:1346
  xfs_fs_mount+0x35/0x40 fs/xfs/xfs_super.c:1814
  legacy_get_tree+0x108/0x220 fs/fs_context.c:661
  vfs_get_tree+0x8e/0x390 fs/super.c:1476
  do_new_mount fs/namespace.c:2791 [inline]
  do_mount+0x138c/0x1c00 fs/namespace.c:3111
  ksys_mount+0xdb/0x150 fs/namespace.c:3320
  __do_sys_mount fs/namespace.c:3334 [inline]
  __se_sys_mount fs/namespace.c:3331 [inline]
  __x64_sys_mount+0xbe/0x150 fs/namespace.c:3331
  do_syscall_64+0xfd/0x6a0 arch/x86/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x45bf6a
Code: b8 a6 00 00 00 0f 05 48 3d 01 f0 ff ff 0f 83 9d 8d fb ff c3 66 2e 0f  
1f 84 00 00 00 00 00 66 90 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 7a 8d fb ff c3 66 0f 1f 84 00 00 00 00 00
RSP: 002b:00007fac99605a88 EFLAGS: 00000206 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007fac99605b40 RCX: 000000000045bf6a
RDX: 00007fac99605ae0 RSI: 0000000020000000 RDI: 00007fac99605b00
RBP: 0000000000000001 R08: 00007fac99605b40 R09: 00007fac99605ae0
R10: 0000000000000000 R11: 0000000000000206 R12: 0000000000000004
R13: 00000000004c858e R14: 00000000004df0e0 R15: 00000000ffffffff

Allocated by task 12241:
  save_stack+0x23/0x90 mm/kasan/common.c:71
  set_track mm/kasan/common.c:79 [inline]
  __kasan_kmalloc mm/kasan/common.c:489 [inline]
  __kasan_kmalloc.constprop.0+0xcf/0xe0 mm/kasan/common.c:462
  kasan_kmalloc+0x9/0x10 mm/kasan/common.c:503
  __do_kmalloc mm/slab.c:3656 [inline]
  __kmalloc+0x163/0x770 mm/slab.c:3665
  kmalloc include/linux/slab.h:556 [inline]
  kmem_alloc+0xd2/0x200 fs/xfs/kmem.c:24
  kmem_zalloc fs/xfs/kmem.h:73 [inline]
  xlog_alloc_log+0xbf4/0x1380 fs/xfs/xfs_log.c:1420
  xfs_log_mount+0xdc/0x780 fs/xfs/xfs_log.c:580
  xfs_mountfs+0xdb9/0x1be0 fs/xfs/xfs_mount.c:815
  xfs_fs_fill_super+0xca6/0x16c0 fs/xfs/xfs_super.c:1740
  mount_bdev+0x304/0x3c0 fs/super.c:1346
  xfs_fs_mount+0x35/0x40 fs/xfs/xfs_super.c:1814
  legacy_get_tree+0x108/0x220 fs/fs_context.c:661
  vfs_get_tree+0x8e/0x390 fs/super.c:1476
  do_new_mount fs/namespace.c:2791 [inline]
  do_mount+0x138c/0x1c00 fs/namespace.c:3111
  ksys_mount+0xdb/0x150 fs/namespace.c:3320
  __do_sys_mount fs/namespace.c:3334 [inline]
  __se_sys_mount fs/namespace.c:3331 [inline]
  __x64_sys_mount+0xbe/0x150 fs/namespace.c:3331
  do_syscall_64+0xfd/0x6a0 arch/x86/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 12241:
  save_stack+0x23/0x90 mm/kasan/common.c:71
  set_track mm/kasan/common.c:79 [inline]
  __kasan_slab_free+0x102/0x150 mm/kasan/common.c:451
  kasan_slab_free+0xe/0x10 mm/kasan/common.c:459
  __cache_free mm/slab.c:3426 [inline]
  kfree+0x10a/0x2c0 mm/slab.c:3757
  kvfree+0x61/0x70 mm/util.c:488
  kmem_free fs/xfs/kmem.h:66 [inline]
  xlog_alloc_log+0xea9/0x1380 fs/xfs/xfs_log.c:1480
  xfs_log_mount+0xdc/0x780 fs/xfs/xfs_log.c:580
  xfs_mountfs+0xdb9/0x1be0 fs/xfs/xfs_mount.c:815
  xfs_fs_fill_super+0xca6/0x16c0 fs/xfs/xfs_super.c:1740
  mount_bdev+0x304/0x3c0 fs/super.c:1346
  xfs_fs_mount+0x35/0x40 fs/xfs/xfs_super.c:1814
  legacy_get_tree+0x108/0x220 fs/fs_context.c:661
  vfs_get_tree+0x8e/0x390 fs/super.c:1476
  do_new_mount fs/namespace.c:2791 [inline]
  do_mount+0x138c/0x1c00 fs/namespace.c:3111
  ksys_mount+0xdb/0x150 fs/namespace.c:3320
  __do_sys_mount fs/namespace.c:3334 [inline]
  __se_sys_mount fs/namespace.c:3331 [inline]
  __x64_sys_mount+0xbe/0x150 fs/namespace.c:3331
  do_syscall_64+0xfd/0x6a0 arch/x86/entry/common.c:301
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff8880693e2900
  which belongs to the cache kmalloc-1k of size 1024
The buggy address is located 144 bytes inside of
  1024-byte region [ffff8880693e2900, ffff8880693e2d00)
The buggy address belongs to the page:
page:ffffea0001a4f880 refcount:1 mapcount:0 mapping:ffff8880aa400c40  
index:0x0 compound_mapcount: 0
flags: 0x1fffc0000010200(slab|head)
raw: 01fffc0000010200 ffffea00018ec788 ffffea0002473908 ffff8880aa400c40
raw: 0000000000000000 ffff8880693e2000 0000000100000007 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
  ffff8880693e2880: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
  ffff8880693e2900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff8880693e2980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                          ^
  ffff8880693e2a00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
  ffff8880693e2a80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
