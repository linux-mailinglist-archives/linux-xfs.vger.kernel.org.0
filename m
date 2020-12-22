Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 048012DD680
	for <lists+linux-xfs@lfdr.de>; Thu, 17 Dec 2020 18:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727388AbgLQRpf (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 17 Dec 2020 12:45:35 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:52449 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728487AbgLQRpf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 17 Dec 2020 12:45:35 -0500
Received: from [192.168.0.8] (ip5f5aeed4.dynamic.kabel-deutschland.de [95.90.238.212])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: buczek)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 1ABDA20647B5E;
        Thu, 17 Dec 2020 18:44:52 +0100 (CET)
To:     linux-xfs@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        it+linux-xfs@molgen.mpg.de
From:   Donald Buczek <buczek@molgen.mpg.de>
Subject: v5.10.1 xfs deadlock
Message-ID: <b8da4aed-ee44-5d9f-88dc-3d32f0298564@molgen.mpg.de>
Date:   Thu, 17 Dec 2020 18:44:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Dear xfs developer,

I was doing some testing on a Linux 5.10.1 system with two 100 TB xfs filesystems on md raid6 raids.

The stress test was essentially `cp -a`ing a Linux source repository with two threads in parallel on each filesystem.

After about on hour, the processes to one filesystem (md1) blocked, 30 minutes later the process to the other filesystem (md0) did.

     root      7322  2167  0 Dec16 pts/1    00:00:06 cp -a /jbod/M8068/scratch/linux /jbod/M8068/scratch/1/linux.018.TMP
     root      7329  2169  0 Dec16 pts/1    00:00:05 cp -a /jbod/M8068/scratch/linux /jbod/M8068/scratch/2/linux.019.TMP
     root     13856  2170  0 Dec16 pts/1    00:00:08 cp -a /jbod/M8067/scratch/linux /jbod/M8067/scratch/2/linux.028.TMP
     root     13899  2168  0 Dec16 pts/1    00:00:05 cp -a /jbod/M8067/scratch/linux /jbod/M8067/scratch/1/linux.027.TMP

Some info from the system (all stack traces, slabinfo) is available here: https://owww.molgen.mpg.de/~buczek/2020-12-16.info.txt

It stands out, that there are many (549 for md0, but only 10 for md1)  "xfs-conv" threads all with stacks like this

     [<0>] xfs_log_commit_cil+0x6cc/0x7c0
     [<0>] __xfs_trans_commit+0xab/0x320
     [<0>] xfs_iomap_write_unwritten+0xcb/0x2e0
     [<0>] xfs_end_ioend+0xc6/0x110
     [<0>] xfs_end_io+0xad/0xe0
     [<0>] process_one_work+0x1dd/0x3e0
     [<0>] worker_thread+0x2d/0x3b0
     [<0>] kthread+0x118/0x130
     [<0>] ret_from_fork+0x22/0x30

xfs_log_commit_cil+0x6cc is

   xfs_log_commit_cil()
     xlog_cil_push_background(log)
       xlog_wait(&cil->xc_push_wait, &cil->xc_push_lock);

Some other threads, including the four "cp" commands are also blocking at xfs_log_commit_cil+0x6cc

There are also single "flush" process for each md device with this stack signature:

     [<0>] xfs_map_blocks+0xbf/0x400
     [<0>] iomap_do_writepage+0x15e/0x880
     [<0>] write_cache_pages+0x175/0x3f0
     [<0>] iomap_writepages+0x1c/0x40
     [<0>] xfs_vm_writepages+0x59/0x80
     [<0>] do_writepages+0x4b/0xe0
     [<0>] __writeback_single_inode+0x42/0x300
     [<0>] writeback_sb_inodes+0x198/0x3f0
     [<0>] __writeback_inodes_wb+0x5e/0xc0
     [<0>] wb_writeback+0x246/0x2d0
     [<0>] wb_workfn+0x26e/0x490
     [<0>] process_one_work+0x1dd/0x3e0
     [<0>] worker_thread+0x2d/0x3b0
     [<0>] kthread+0x118/0x130
     [<0>] ret_from_fork+0x22/0x30

xfs_map_blocks+0xbf is the

     xfs_ilock(ip, XFS_ILOCK_SHARED);

in xfs_map_blocks().

The system is low on free memory

     MemTotal:       197587764 kB
     MemFree:          2196496 kB
     MemAvailable:   189895408 kB

but responsive.

I have an out of tree driver for the HBA ( smartpqi 2.1.6-005 pulled from linux-scsi) , but it is unlikely that this blocking is related to that, because the md block devices itself are responsive (`xxd /dev/md0` )

I can keep the system in the state for a while. Is there an idea what was going from or an idea what data I could collect from the running system to help? I have full debug info and could walk lists or retrieve data structures with gdb.

Best
   Donald
