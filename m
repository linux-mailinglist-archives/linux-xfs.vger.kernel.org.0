Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E642056B18D
	for <lists+linux-xfs@lfdr.de>; Fri,  8 Jul 2022 06:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232993AbiGHEbD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 8 Jul 2022 00:31:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbiGHEbC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Jul 2022 00:31:02 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 395EC21258
        for <linux-xfs@vger.kernel.org>; Thu,  7 Jul 2022 21:31:01 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 3EF4462C3BD;
        Fri,  8 Jul 2022 14:31:00 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1o9fdq-00FtPs-UN; Fri, 08 Jul 2022 14:30:58 +1000
Date:   Fri, 8 Jul 2022 14:30:58 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Subject: Re: [PATCH 2/3] xfs: make inode attribute forks a permanent part of
 struct xfs_inode
Message-ID: <20220708043058.GR227878@dread.disaster.area>
References: <165705897408.2826746.14673631830829415034.stgit@magnolia>
 <165705898555.2826746.14913566803667615290.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165705898555.2826746.14913566803667615290.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=62c7b304
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=RgO8CyIxsXoA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=z5bq4YqQdTx5g9xxtc0A:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 05, 2022 at 03:09:45PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Syzkaller reported a UAF bug a while back:
> 
> ==================================================================
> BUG: KASAN: use-after-free in xfs_ilock_attr_map_shared+0xe3/0xf6 fs/xfs/xfs_inode.c:127
> Read of size 4 at addr ffff88802cec919c by task syz-executor262/2958
> 
> CPU: 2 PID: 2958 Comm: syz-executor262 Not tainted
> 5.15.0-0.30.3-20220406_1406 #3
> Hardware name: Red Hat KVM, BIOS 1.13.0-2.module+el8.3.0+7860+a7792d29
> 04/01/2014
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0x82/0xa9 lib/dump_stack.c:106
>  print_address_description.constprop.9+0x21/0x2d5 mm/kasan/report.c:256
>  __kasan_report mm/kasan/report.c:442 [inline]
>  kasan_report.cold.14+0x7f/0x11b mm/kasan/report.c:459
>  xfs_ilock_attr_map_shared+0xe3/0xf6 fs/xfs/xfs_inode.c:127
>  xfs_attr_get+0x378/0x4c2 fs/xfs/libxfs/xfs_attr.c:159
>  xfs_xattr_get+0xe3/0x150 fs/xfs/xfs_xattr.c:36
>  __vfs_getxattr+0xdf/0x13d fs/xattr.c:399
>  cap_inode_need_killpriv+0x41/0x5d security/commoncap.c:300
>  security_inode_need_killpriv+0x4c/0x97 security/security.c:1408
>  dentry_needs_remove_privs.part.28+0x21/0x63 fs/inode.c:1912
>  dentry_needs_remove_privs+0x80/0x9e fs/inode.c:1908
>  do_truncate+0xc3/0x1e0 fs/open.c:56
>  handle_truncate fs/namei.c:3084 [inline]
>  do_open fs/namei.c:3432 [inline]
>  path_openat+0x30ab/0x396d fs/namei.c:3561
>  do_filp_open+0x1c4/0x290 fs/namei.c:3588
>  do_sys_openat2+0x60d/0x98c fs/open.c:1212
>  do_sys_open+0xcf/0x13c fs/open.c:1228
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x3a/0x7e arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0x0
> RIP: 0033:0x7f7ef4bb753d
> Code: 00 c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48
> 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73
> 01 c3 48 8b 0d 1b 79 2c 00 f7 d8 64 89 01 48
> RSP: 002b:00007f7ef52c2ed8 EFLAGS: 00000246 ORIG_RAX: 0000000000000055
> RAX: ffffffffffffffda RBX: 0000000000404148 RCX: 00007f7ef4bb753d
> RDX: 00007f7ef4bb753d RSI: 0000000000000000 RDI: 0000000020004fc0
> RBP: 0000000000404140 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0030656c69662f2e
> R13: 00007ffd794db37f R14: 00007ffd794db470 R15: 00007f7ef52c2fc0
>  </TASK>
> 
> Allocated by task 2953:
>  kasan_save_stack+0x19/0x38 mm/kasan/common.c:38
>  kasan_set_track mm/kasan/common.c:46 [inline]
>  set_alloc_info mm/kasan/common.c:434 [inline]
>  __kasan_slab_alloc+0x68/0x7c mm/kasan/common.c:467
>  kasan_slab_alloc include/linux/kasan.h:254 [inline]
>  slab_post_alloc_hook mm/slab.h:519 [inline]
>  slab_alloc_node mm/slub.c:3213 [inline]
>  slab_alloc mm/slub.c:3221 [inline]
>  kmem_cache_alloc+0x11b/0x3eb mm/slub.c:3226
>  kmem_cache_zalloc include/linux/slab.h:711 [inline]
>  xfs_ifork_alloc+0x25/0xa2 fs/xfs/libxfs/xfs_inode_fork.c:287
>  xfs_bmap_add_attrfork+0x3f2/0x9b1 fs/xfs/libxfs/xfs_bmap.c:1098
>  xfs_attr_set+0xe38/0x12a7 fs/xfs/libxfs/xfs_attr.c:746
>  xfs_xattr_set+0xeb/0x1a9 fs/xfs/xfs_xattr.c:59
>  __vfs_setxattr+0x11b/0x177 fs/xattr.c:180
>  __vfs_setxattr_noperm+0x128/0x5e0 fs/xattr.c:214
>  __vfs_setxattr_locked+0x1d4/0x258 fs/xattr.c:275
>  vfs_setxattr+0x154/0x33d fs/xattr.c:301
>  setxattr+0x216/0x29f fs/xattr.c:575
>  __do_sys_fsetxattr fs/xattr.c:632 [inline]
>  __se_sys_fsetxattr fs/xattr.c:621 [inline]
>  __x64_sys_fsetxattr+0x243/0x2fe fs/xattr.c:621
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x3a/0x7e arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0x0
> 
> Freed by task 2949:
>  kasan_save_stack+0x19/0x38 mm/kasan/common.c:38
>  kasan_set_track+0x1c/0x21 mm/kasan/common.c:46
>  kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:360
>  ____kasan_slab_free mm/kasan/common.c:366 [inline]
>  ____kasan_slab_free mm/kasan/common.c:328 [inline]
>  __kasan_slab_free+0xe2/0x10e mm/kasan/common.c:374
>  kasan_slab_free include/linux/kasan.h:230 [inline]
>  slab_free_hook mm/slub.c:1700 [inline]
>  slab_free_freelist_hook mm/slub.c:1726 [inline]
>  slab_free mm/slub.c:3492 [inline]
>  kmem_cache_free+0xdc/0x3ce mm/slub.c:3508
>  xfs_attr_fork_remove+0x8d/0x132 fs/xfs/libxfs/xfs_attr_leaf.c:773
>  xfs_attr_sf_removename+0x5dd/0x6cb fs/xfs/libxfs/xfs_attr_leaf.c:822
>  xfs_attr_remove_iter+0x68c/0x805 fs/xfs/libxfs/xfs_attr.c:1413
>  xfs_attr_remove_args+0xb1/0x10d fs/xfs/libxfs/xfs_attr.c:684
>  xfs_attr_set+0xf1e/0x12a7 fs/xfs/libxfs/xfs_attr.c:802
>  xfs_xattr_set+0xeb/0x1a9 fs/xfs/xfs_xattr.c:59
>  __vfs_removexattr+0x106/0x16a fs/xattr.c:468
>  cap_inode_killpriv+0x24/0x47 security/commoncap.c:324
>  security_inode_killpriv+0x54/0xa1 security/security.c:1414
>  setattr_prepare+0x1a6/0x897 fs/attr.c:146
>  xfs_vn_change_ok+0x111/0x15e fs/xfs/xfs_iops.c:682
>  xfs_vn_setattr_size+0x5f/0x15a fs/xfs/xfs_iops.c:1065
>  xfs_vn_setattr+0x125/0x2ad fs/xfs/xfs_iops.c:1093
>  notify_change+0xae5/0x10a1 fs/attr.c:410
>  do_truncate+0x134/0x1e0 fs/open.c:64
>  handle_truncate fs/namei.c:3084 [inline]
>  do_open fs/namei.c:3432 [inline]
>  path_openat+0x30ab/0x396d fs/namei.c:3561
>  do_filp_open+0x1c4/0x290 fs/namei.c:3588
>  do_sys_openat2+0x60d/0x98c fs/open.c:1212
>  do_sys_open+0xcf/0x13c fs/open.c:1228
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x3a/0x7e arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0x0
> 
> The buggy address belongs to the object at ffff88802cec9188
>  which belongs to the cache xfs_ifork of size 40
> The buggy address is located 20 bytes inside of
>  40-byte region [ffff88802cec9188, ffff88802cec91b0)
> The buggy address belongs to the page:
> page:00000000c3af36a1 refcount:1 mapcount:0 mapping:0000000000000000
> index:0x0 pfn:0x2cec9
> flags: 0xfffffc0000200(slab|node=0|zone=1|lastcpupid=0x1fffff)
> raw: 000fffffc0000200 ffffea00009d2580 0000000600000006 ffff88801a9ffc80
> raw: 0000000000000000 0000000080490049 00000001ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
> 
> Memory state around the buggy address:
>  ffff88802cec9080: fb fb fb fc fc fa fb fb fb fb fc fc fb fb fb fb
>  ffff88802cec9100: fb fc fc fb fb fb fb fb fc fc fb fb fb fb fb fc
> >ffff88802cec9180: fc fa fb fb fb fb fc fc fa fb fb fb fb fc fc fb
>                             ^
>  ffff88802cec9200: fb fb fb fb fc fc fb fb fb fb fb fc fc fb fb fb
>  ffff88802cec9280: fb fb fc fc fa fb fb fb fb fc fc fa fb fb fb fb
> ==================================================================
> 
> The root cause of this bug is the unlocked access to xfs_inode.i_afp
> from the getxattr code paths while trying to determine which ILOCK mode
> to use to stabilize the xattr data.  Unfortunately, the VFS does not
> acquire i_rwsem when vfs_getxattr (or listxattr) call into the
> filesystem, which means that getxattr can race with a removexattr that's
> tearing down the attr fork and crash:
> 
> xfs_attr_set:                          xfs_attr_get:
> xfs_attr_fork_remove:                  xfs_ilock_attr_map_shared:
> 
> xfs_idestroy_fork(ip->i_afp);
> kmem_cache_free(xfs_ifork_cache, ip->i_afp);
> 
>                                        if (ip->i_afp &&
> 
> ip->i_afp = NULL;
> 
>                                            xfs_need_iread_extents(ip->i_afp))
>                                        <KABOOM>
> 
> ip->i_forkoff = 0;
> 
> Regrettably, the VFS is much more lax about i_rwsem and getxattr than
> is immediately obvious -- not only does it not guarantee that we hold
> i_rwsem, it actually doesn't guarantee that we *don't* hold it either.
> The getxattr system call won't acquire the lock before calling XFS, but
> the file capabilities code calls getxattr with and without i_rwsem held
> to determine if the "security.capabilities" xattr is set on the file.
> 
> Fixing the VFS locking requires a treewide investigation into every code
> path that could touch an xattr and what i_rwsem state it expects or sets
> up.  That could take years or even prove impossible; fortunately, we
> can fix this UAF problem inside XFS.
> 
> An earlier version of this patch used smp_wmb in xfs_attr_fork_remove to
> ensure that i_forkoff is always zeroed before i_afp is set to null and
> changed the read paths to use smp_rmb before accessing i_forkoff and
> i_afp, which avoided these UAF problems.  However, the patch author was
> too busy dealing with other problems in the meantime, and by the time he
> came back to this issue, the situation had changed a bit.
> 
> On a modern system with selinux, each inode will always have at least
> one xattr for the selinux label, so it doesn't make much sense to keep
> incurring the extra pointer dereference.  Furthermore, Allison's
> upcoming parent pointer patchset will also cause nearly every inode in
> the filesystem to have extended attributes.  Therefore, make the inode
> attribute fork structure part of struct xfs_inode, at a cost of 40 more
> bytes.
> 
> This patch adds a clunky if_present field where necessary to maintain
> the existing logic of xattr fork null pointer testing in the existing
> codebase.  The next patch switches the logic over to XFS_IFORK_Q and it
> all goes away.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

After thinking about this for a little while, the little nits and
cleanups I was wondering about aren't worth holding this up.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
