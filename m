Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1155A7CB3
	for <lists+linux-xfs@lfdr.de>; Wed, 31 Aug 2022 13:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbiHaL6i (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 31 Aug 2022 07:58:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbiHaL6f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Aug 2022 07:58:35 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC948D275B
        for <linux-xfs@vger.kernel.org>; Wed, 31 Aug 2022 04:58:33 -0700 (PDT)
Received: from kwepemi500019.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MHjK821Y8z1N7bF;
        Wed, 31 Aug 2022 19:54:52 +0800 (CST)
Received: from huawei.com (10.175.124.27) by kwepemi500019.china.huawei.com
 (7.221.188.117) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Wed, 31 Aug
 2022 19:58:30 +0800
From:   Guo Xuenan <guoxuenan@huawei.com>
To:     <linux-xfs@vger.kernel.org>, <djwong@kernel.org>,
        <dchinner@redhat.com>
CC:     <chandan.babu@oracle.com>, <yi.zhang@huawei.com>,
        <houtao1@huawei.com>, <zhengbin13@huawei.com>,
        <jack.qiu@huawei.com>, <guoxuenan@huawei.com>
Subject: [PATCH v2] xfs: fix uaf when leaf dir bestcount not match with dir data blocks
Date:   Wed, 31 Aug 2022 20:16:39 +0800
Message-ID: <20220831121639.3060527-1-guoxuenan@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemi500019.china.huawei.com (7.221.188.117)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

For leaf dir, In most cases, there should be as many bestfree slots
as the dir data blocks that can fit under i_size (except for [1]).

Root cause is we don't examin the number bestfree slots, when the slots
number less than dir data blocks, if we need to allocate new dir data
block and update the bestfree array, we will use the dir block number as
index to assign bestfree array, while we did not check the leaf buf
boundary which may cause UAF or other memory access problem. This issue
can also triggered with test cases xfs/473 from fstests.

Considering the special case [1] , only add check bestfree array boundary,
to avoid UAF or slab-out-of bound.

[1] https://lore.kernel.org/all/163961697197.3129691.1911552605195534271.stgit@magnolia/

Simplify the testcase xfs/473 with commands below:
DEV=/dev/sdb
MP=/mnt/sdb
WORKDIR=/mnt/sdb/341 #1. mkfs create new xfs image
mkfs.xfs -f ${DEV}
mount ${DEV} ${MP}
mkdir -p ${WORKDIR}
for i in `seq 1 341` #2. create leaf dir with 341 entries file name len 8
do
    touch ${WORKDIR}/$(printf "%08d" ${i})
done
inode=$(ls -i ${MP} | cut -d' ' -f1)
umount ${MP}         #3. xfs_db set bestcount to 0
xfs_db -x ${DEV} -c "inode ${inode}" -c "dblock 8388608" \
-c "write ltail.bestcount 0"
mount ${DEV} ${MP}
touch ${WORKDIR}/{1..100}.txt #4. touch new file, reproduce

The error log is shown as follows:
==================================================================
BUG: KASAN: use-after-free in xfs_dir2_leaf_addname+0x1995/0x1ac0
Write of size 2 at addr ffff88810168b000 by task touch/1552
CPU: 5 PID: 1552 Comm: touch Not tainted 6.0.0-rc3+ #101
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x4d/0x66
 print_report.cold+0xf6/0x691
 kasan_report+0xa8/0x120
 xfs_dir2_leaf_addname+0x1995/0x1ac0
 xfs_dir_createname+0x58c/0x7f0
 xfs_create+0x7af/0x1010
 xfs_generic_create+0x270/0x5e0
 path_openat+0x270b/0x3450
 do_filp_open+0x1cf/0x2b0
 do_sys_openat2+0x46b/0x7a0
 do_sys_open+0xb7/0x130
 do_syscall_64+0x35/0x80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fe4d9e9312b
Code: 25 00 00 41 00 3d 00 00 41 00 74 4b 64 8b 04 25 18 00 00 00 85 c0
75 67 44 89 e2 48 89 ee bf 9c ff ff ff b8 01 01 00 00 0f 05 <48> 3d 00
f0 ff ff 0f 87 91 00 00 00 48 8b 4c 24 28 64 48 33 0c 25
RSP: 002b:00007ffda4c16c20 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007fe4d9e9312b
RDX: 0000000000000941 RSI: 00007ffda4c17f33 RDI: 00000000ffffff9c
RBP: 00007ffda4c17f33 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000000001b6 R11: 0000000000000246 R12: 0000000000000941
R13: 00007fe4d9f631a4 R14: 00007ffda4c17f33 R15: 0000000000000000
 </TASK>

The buggy address belongs to the physical page:
page:ffffea000405a2c0 refcount:0 mapcount:0 mapping:0000000000000000
index:0x0 pfn:0x10168b
flags: 0x2fffff80000000(node=0|zone=2|lastcpupid=0x1fffff)
raw: 002fffff80000000 ffffea0004057788 ffffea000402dbc8 0000000000000000
raw: 0000000000000000 0000000000170000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff88810168af00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff88810168af80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>ffff88810168b000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                   ^
 ffff88810168b080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff88810168b100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
==================================================================
Disabling lock debugging due to kernel taint
00000000: 58 44 44 33 5b 53 35 c2 00 00 00 00 00 00 00 78
XDD3[S5........x
XFS (sdb): Internal error xfs_dir2_data_use_free at line 1200 of file
fs/xfs/libxfs/xfs_dir2_data.c.  Caller
xfs_dir2_data_use_free+0x28a/0xeb0
CPU: 5 PID: 1552 Comm: touch Tainted: G    B              6.0.0-rc3+
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.13.0-1ubuntu1.1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x4d/0x66
 xfs_corruption_error+0x132/0x150
 xfs_dir2_data_use_free+0x198/0xeb0
 xfs_dir2_leaf_addname+0xa59/0x1ac0
 xfs_dir_createname+0x58c/0x7f0
 xfs_create+0x7af/0x1010
 xfs_generic_create+0x270/0x5e0
 path_openat+0x270b/0x3450
 do_filp_open+0x1cf/0x2b0
 do_sys_openat2+0x46b/0x7a0
 do_sys_open+0xb7/0x130
 do_syscall_64+0x35/0x80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fe4d9e9312b
Code: 25 00 00 41 00 3d 00 00 41 00 74 4b 64 8b 04 25 18 00 00 00 85 c0
75 67 44 89 e2 48 89 ee bf 9c ff ff ff b8 01 01 00 00 0f 05 <48> 3d 00
f0 ff ff 0f 87 91 00 00 00 48 8b 4c 24 28 64 48 33 0c 25
RSP: 002b:00007ffda4c16c20 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007fe4d9e9312b
RDX: 0000000000000941 RSI: 00007ffda4c17f46 RDI: 00000000ffffff9c
RBP: 00007ffda4c17f46 R08: 0000000000000000 R09: 0000000000000001
R10: 00000000000001b6 R11: 0000000000000246 R12: 0000000000000941
R13: 00007fe4d9f631a4 R14: 00007ffda4c17f46 R15: 0000000000000000
 </TASK>
XFS (sdb): Corruption detected. Unmount and run xfs_repair

Signed-off-by: Guo Xuenan <guoxuenan@huawei.com>
Reviewed-by: Hou Tao <houtao1@huawei.com>
---
 fs/xfs/libxfs/xfs_dir2_leaf.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_dir2_leaf.c b/fs/xfs/libxfs/xfs_dir2_leaf.c
index d9b66306a9a7..4b2a72b3a6f3 100644
--- a/fs/xfs/libxfs/xfs_dir2_leaf.c
+++ b/fs/xfs/libxfs/xfs_dir2_leaf.c
@@ -819,6 +819,18 @@ xfs_dir2_leaf_addname(
 		 */
 		else
 			xfs_dir3_leaf_log_bests(args, lbp, use_block, use_block);
+		/*
+		 * An abnormal corner case, bestfree count less than data
+		 * blocks, add a condition to avoid UAF or slab-out-of bound.
+		 */
+		if ((char *)(&bestsp[use_block]) > (char *)ltp) {
+			xfs_trans_brelse(tp, lbp);
+			if (tp->t_flags & XFS_TRANS_DIRTY)
+				xfs_force_shutdown(tp->t_mountp,
+						SHUTDOWN_CORRUPT_ONDISK);
+			return -EFSCORRUPTED;
+		}
+
 		hdr = dbp->b_addr;
 		bf = xfs_dir2_data_bestfree_p(dp->i_mount, hdr);
 		bestsp[use_block] = bf[0].length;
-- 
2.25.1

