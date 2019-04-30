Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DDD0FC85
	for <lists+linux-xfs@lfdr.de>; Tue, 30 Apr 2019 17:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbfD3PMJ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 30 Apr 2019 11:12:09 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:44360 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726086AbfD3PMI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Apr 2019 11:12:08 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3UF9Ujn096308;
        Tue, 30 Apr 2019 15:11:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2018-07-02;
 bh=83hxG6+OCrtcAQc1iFypRez11xIxYN4H3ZA18BWmsRQ=;
 b=djRa+RCCyZ/1hVv654VO3xJail+dpbxpk2UoDYuFTIzd52/1p9uuOp5zhlwcXIsSgt2l
 8bVidgdwJmDm4O+9dQuIH9Oh9vtjXF9fd4eXf1lJyXvK8uHVEbayhg/8mLCOLE1QCcCV
 EWaOpindFiiI4A2pISrct/LHpdls+KHJggH08rfJcyHsTtCWlrwgJfbfbOHB2065q9Wy
 ahnDIcSnguDrp6x/16Jiad0X5vGR0rrcxhyJ00M3a5yopUyHYG6i04w/clNGCpMW2yH8
 ypKYfu0E0fETPVzuu6JBs940cA1OCDbFTm/DKrAuSNodDxPQtjKeZQY5MdXBm5mrRYI9 DA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2s5j5u1w5n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Apr 2019 15:11:56 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x3UFBRgJ003542;
        Tue, 30 Apr 2019 15:11:56 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2s5u511ssn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Apr 2019 15:11:55 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x3UFBq6Z002697;
        Tue, 30 Apr 2019 15:11:55 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 30 Apr 2019 08:11:52 -0700
Date:   Tue, 30 Apr 2019 08:11:51 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Andre Noll <maan@tuebingen.mpg.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: xfs: Assertion failed in xfs_ag_resv_init()
Message-ID: <20190430151151.GF5207@magnolia>
References: <20190430121420.GW2780@tuebingen.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190430121420.GW2780@tuebingen.mpg.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9242 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1904300094
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9242 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1904300094
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 30, 2019 at 02:14:20PM +0200, Andre Noll wrote:
> Hi
> 
> I'm hitting the assertion below when mounting an xfs filesystem
> stored on a thin LV. The mount command segfaults, the machine
> is unusable afterwards and requires a hard reset. This is 100%
> reproducible. xfs_repair did not report any inconsistencies and did
> not fix the issue.
> 
> [  546.622715] XFS (dm-6): Mounting V5 Filesystem
> [  546.867893] XFS (dm-6): Ending clean mount
> [  546.898846] XFS: Assertion failed: xfs_perag_resv(pag, XFS_AG_RESV_METADATA)->ar_reserved + xfs_perag_resv(pag, XFS_AG_RESV_AGFL)->ar_reserved <= pag->pagf_freeblks + pag->pagf_flcount, file: /ebio/maan/scm/OTHER/linux/fs/xfs/libxfs/xfs_ag_resv.c, line: 308
> [  546.899089] ------------[ cut here ]------------
> [  546.899177] kernel BUG at /ebio/maan/scm/OTHER/linux/fs/xfs/xfs_message.c:113!
> [  546.899303] invalid opcode: 0000 [#1] SMP
> [  546.899392] CPU: 6 PID: 3196 Comm: mount Not tainted 4.9.171 #16
> [  546.899485] Hardware name: Supermicro Super Server/H11SSL-i, BIOS 1.0c 10/04/2018
> [  546.899611] task: ffff881ffb56de00 task.stack: ffffc9000dd04000
> [  546.899704] RIP: 0010:[<ffffffff8130c81b>]  [<ffffffff8130c81b>] assfail+0x1b/0x20
> [  546.899882] RSP: 0018:ffffc9000dd07c98  EFLAGS: 00010282
> [  546.899972] RAX: 00000000ffffffea RBX: ffff881ff519c000 RCX: 0000000000000000
> [  546.900069] RDX: 00000000ffffffc0 RSI: 000000000000000a RDI: ffffffff8192384b
> [  546.900167] RBP: ffffc9000dd07c98 R08: 0000000000000000 R09: 0000000000000000
> [  546.900264] R10: 000000000000000a R11: f000000000000000 R12: ffff881ffbbe0000
> [  546.900360] R13: 0000000000000064 R14: ffff881ffbbe0000 R15: 0000000000000000
> [  546.900458] FS:  00007fec47b56080(0000) GS:ffff88201fa00000(0000) knlGS:0000000000000000
> [  546.900585] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  546.900677] CR2: 00007fec4633b000 CR3: 00000007f6aa1000 CR4: 00000000003406f0
> [  546.900773] Stack:
> [  546.900852]  ffffc9000dd07cd0 ffffffff812dd46d 0000000000000064 0000000000000000
> [  546.901157]  0000000000000064 ffff881ff519c000 0000000000000000 ffffc9000dd07d08
> [  546.901462]  ffffffff812faac5 ffff881ffbbe0000 ffff881ffbbe0640 ffff881ffbbe0928
> [  546.901766] Call Trace:
> [  546.901850]  [<ffffffff812dd46d>] xfs_ag_resv_init+0x16d/0x180
> [  546.901947]  [<ffffffff812faac5>] xfs_fs_reserve_ag_blocks+0x35/0xb0
> [  546.902041]  [<ffffffff8130de21>] xfs_mountfs+0x891/0x9c0
> [  546.902133]  [<ffffffff8131433d>] xfs_fs_fill_super+0x3fd/0x550
> [  546.902229]  [<ffffffff8113ede7>] mount_bdev+0x177/0x1b0
> [  546.902321]  [<ffffffff81313f40>] ? xfs_finish_flags+0x130/0x130
> [  546.902415]  [<ffffffff813126e0>] xfs_fs_mount+0x10/0x20
> [  546.902505]  [<ffffffff8113efff>] mount_fs+0xf/0xa0
> [  546.902598]  [<ffffffff81159328>] vfs_kern_mount.part.11+0x58/0x100
> [  546.902692]  [<ffffffff8115b5f0>] do_mount+0x1a0/0xc50
> [  546.902784]  [<ffffffff8110860d>] ? memdup_user+0x3d/0x70
> [  546.902876]  [<ffffffff8115c395>] SyS_mount+0x55/0xe0
> [  546.902968]  [<ffffffff810018e6>] do_syscall_64+0x56/0xc0
> [  546.903063]  [<ffffffff8169771b>] entry_SYSCALL_64_after_swapgs+0x58/0xc2
> [  546.903159] Code: 48 c7 c7 10 04 95 81 e8 c4 42 d4 ff 5d c3 66 90 55 48 89 f1 41 89 d0 48 c7 c6 40 04 95 81 48 89 fa 31 ff 48 89 e5 e8 65 fa ff ff <0f> 0b 0f 1f 00 55 48 63 f6 49 89 f9 41 b8 01 00 00 00 b9 10 00 
> [  546.906798] RIP  [<ffffffff8130c81b>] assfail+0x1b/0x20
> [  546.906934]  RSP <ffffc9000dd07c98>
> [  546.907029] ---[ end trace deeb8384ab04a23c ]---
> 
> To see why the assertion triggers, I added
> 
>         xfs_warn(NULL, "a: %u", xfs_perag_resv(pag, XFS_AG_RESV_METADATA)->ar_reserved);
>         xfs_warn(NULL, "b: %u", xfs_perag_resv(pag, XFS_AG_RESV_AGFL)->ar_reserved);
>         xfs_warn(NULL, "c: %u", pag->pagf_freeblks);
>         xfs_warn(NULL, "d: %u", pag->pagf_flcount);
> 
> right before the ASSERT() in xfs_ag_resv.c. Looks like
> pag->pagf_freeblks is way too small:
> 
> [  149.777035] XFS: a: 267367
> [  149.777036] XFS: b: 0
> [  149.777036] XFS: c: 6388
> [  149.777037] XFS: d: 4
> 
> Fortunately, this is new hardware which is not yet in production use,
> and the filesystem in question only contains a few dummy files. So
> I can test patches.

The assert (and your very helpful debugging xfs_warns) indicate that for
the kernel was trying to reserve 267,367 blocks to guarantee space for
metadata btrees in an allocation group (AG) that has only 6,392 blocks
remaining.

This per-AG block reservation exists to avoid running out of space for
metadata in worst case situations (needing space midway through a
transaction on a nearly full fs).  The assert your machine hit is a
debugging warning to alert developers to the per-AG block reservation
system deciding that it won't be able to handle all cases.

Hmmm, what features does this filesystem have enabled?

Given that XFS_AG_RESV_METADATA > 0 and there's no warning about the
experimental reflink feature, that implies that the free inode btree
(finobt) feature is enabled?

The awkward thing about the finobt reservation is that it was added long
after the finobt feature was enabled, to fix a corner case in that code.
If you're coming from an older kernel, there might not be enough free
space in the AG to guarantee space for the finobt.

(Maybe we ought to turn that ASSERT into a xfs_warn or something...?)

In any case, if you're /not/ trying to debug the XFS code itself, you
could set CONFIG_XFS_DEBUG=n to turn off all the programmer debugging
pieces (which will improve fs performance substantially).

If you want all the verbose debugging checks without the kernel hang
behavior you could set CONFIG_XFS_DEBUG=n and CONFIG_XFS_WARN=y.

--D

> 
> Best
> Andre
> -- 
> Max Planck Institute for Developmental Biology
> Max-Planck-Ring 5, 72076 Tübingen, Germany. Phone: (+49) 7071 601 829
> http://people.tuebingen.mpg.de/maan/


