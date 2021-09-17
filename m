Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9956410041
	for <lists+linux-xfs@lfdr.de>; Fri, 17 Sep 2021 22:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242703AbhIQUQ3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 17 Sep 2021 16:16:29 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59564 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S241879AbhIQUQZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Sep 2021 16:16:25 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18HJbOQ6025696;
        Fri, 17 Sep 2021 16:14:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=YhSq8ihP+Jjujv4uoiPcQWDTm94/Je2U4c2Jxa5Eadk=;
 b=nzmKhNO62ZE9kDnu5MXoeW+O3F1OidCC1DqALMtoQLV/JzHAl8CrMR7DY5ugx6FqqDco
 kpiv/Nd7K6D4aYc95+0QPxKY403jkid4i1AtQ18+HCaPjVojtji6RNE/jJUuKnqhNUa6
 JLxrJpnoXWHcPPHeKMo/ZjF/Fi/uKVacOmU47RjMu8XL8XfG4Ay2qth7y1SGLjP/x5Gw
 xnS3CLnHwonM5+o/cIRJVYP2EYOyaRRz/gEGWtfkrhADE+aXh61cmTbvcLUq6sf2NNY3
 gffubczE5OY73W8tEkHigVUdAZQa0YO4EQFqfpqMGEt4kPetKe3z8d/bN30vtgEU3IiE bA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b4ywgakfg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Sep 2021 16:14:57 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18HKEuJi023501;
        Fri, 17 Sep 2021 16:14:56 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3b4ywgakf0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Sep 2021 16:14:56 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18HKD33c026092;
        Fri, 17 Sep 2021 20:14:55 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma02fra.de.ibm.com with ESMTP id 3b0m3afsub-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 17 Sep 2021 20:14:54 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18HKEq8p18940298
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Sep 2021 20:14:52 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6F124A4040;
        Fri, 17 Sep 2021 20:14:52 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F05B9A4053;
        Fri, 17 Sep 2021 20:14:51 +0000 (GMT)
Received: from localhost (unknown [9.43.63.221])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 17 Sep 2021 20:14:51 +0000 (GMT)
Date:   Sat, 18 Sep 2021 01:44:51 +0530
From:   riteshh <riteshh@linux.ibm.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me, osandov@fb.com
Subject: Re: [PATCH 2/1] common/rc: use directio mode for the loop device
 when possible
Message-ID: <20210917201451.s7235mmlnsez3kqb@riteshh-domain>
References: <163174932046.379383.10637812567210248503.stgit@magnolia>
 <20210917004829.GD34874@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210917004829.GD34874@magnolia>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: W7ps-Hc38VhdUxumu1ZjWwtSS2Cds5SL
X-Proofpoint-GUID: D8ibEv68TTvGtgRog6K-vcVZAgbnvPJ-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-17_08,2021-09-17_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=999 clxscore=1011 spamscore=0
 adultscore=0 impostorscore=0 mlxscore=0 suspectscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109170120
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 21/09/16 05:48PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Recently, I've been observing very high runtimes of tests that format a
> filesystem atop a loop device and write enough data to fill memory, such
> as generic/590 and generic/361.  Logging into the test VMs, I noticed
> that the writes to the file on the upper filesystem started fast, but
> soon slowed down to about 500KB/s and stayed that way for nearly 20
> minutes.  Looking through the D-state processes on the system revealed:
>
> /proc/4350/comm = xfs_io
> /proc/4350/stack : [<0>] balance_dirty_pages+0x332/0xda0
> [<0>] balance_dirty_pages_ratelimited+0x304/0x400
> [<0>] iomap_file_buffered_write+0x1ab/0x260
> [<0>] xfs_file_buffered_write+0xba/0x330 [xfs]
> [<0>] new_sync_write+0x119/0x1a0
> [<0>] vfs_write+0x274/0x310
> [<0>] __x64_sys_pwrite64+0x89/0xc0
> [<0>] do_syscall_64+0x35/0x80
> [<0>] entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> Here's the xfs_io process performing a buffered write to the file on the
> upper filesystem, which at this point has dirtied enough pages to be
> ratelimited.
>
> /proc/28/comm = u10:0+flush-8:80
> /proc/28/stack : [<0>] blk_mq_get_tag+0x11c/0x280
> [<0>] __blk_mq_alloc_request+0xce/0xf0
> [<0>] blk_mq_submit_bio+0x139/0x5b0
> [<0>] submit_bio_noacct+0x3ba/0x430
> [<0>] iomap_submit_ioend+0x4b/0x70
> [<0>] xfs_vm_writepages+0x86/0x170 [xfs]
> [<0>] do_writepages+0xcc/0x200
> [<0>] __writeback_single_inode+0x3d/0x300
> [<0>] writeback_sb_inodes+0x207/0x4a0
> [<0>] __writeback_inodes_wb+0x4c/0xe0
> [<0>] wb_writeback+0x1da/0x2c0
> [<0>] wb_workfn+0x2ad/0x4f0
> [<0>] process_one_work+0x1e2/0x3d0
> [<0>] worker_thread+0x53/0x3c0
> [<0>] kthread+0x149/0x170
> [<0>] ret_from_fork+0x1f/0x30
>
> This is a flusher thread that has invoked writeback on the upper
> filesystem to try to clean memory pages.
>
> /proc/89/comm = u10:7+loop0
> /proc/89/stack : [<0>] balance_dirty_pages+0x332/0xda0
> [<0>] balance_dirty_pages_ratelimited+0x304/0x400
> [<0>] iomap_file_buffered_write+0x1ab/0x260
> [<0>] xfs_file_buffered_write+0xba/0x330 [xfs]
> [<0>] do_iter_readv_writev+0x14f/0x1a0
> [<0>] do_iter_write+0x7b/0x1c0
> [<0>] lo_write_bvec+0x62/0x1c0
> [<0>] loop_process_work+0x3a4/0xba0
> [<0>] process_one_work+0x1e2/0x3d0
> [<0>] worker_thread+0x53/0x3c0
> [<0>] kthread+0x149/0x170
> [<0>] ret_from_fork+0x1f/0x30
>
> Here's the loop device worker handling the writeback IO submitted by the
> flusher thread.  Unfortunately, the loop device is using buffered write
> mode, which means that /writeback/ is dirtying pages and being throttled
> for that.  This is stupid.
>
> Fix this by trying to enable "directio" mode on the loop device, which
> delivers two performance benefits: setting directio mode also enables
> async io mode, which will allow multiple IOs at once; and using directio
> nearly eliminates the chance that writeback will get throttled.
>
> On the author's system with fast storage, this reduces the runtime of
> g/590 from 20 minutes to 12 seconds, and g/361 from ~30s to ~3s.
>

Above observations looked interesting to me. I then happen to test it on
my setup and also observe such behavior. But I really don't see the timings
improvements as such. Both before and after the test g/590 took 90-95secs.
I did verify that after this patch applied, I was mostly seeing DIO path for
writes to ext4 FS.

Note: I had ext4 as my root filesystem where fs images were kept for testfs and
scratchfs.

<pasting call stack observed>
PID: 6010   TASK: c000000030833380  CPU: 18  COMMAND: "kworker/u64:10"
 #0 [c00000002a787480] __schedule at c00000000139ba50
 #1 [c00000002a787550] schedule at c00000000139bcc4
 #2 [c00000002a787580] schedule_timeout at c0000000013a42bc
 #3 [c00000002a787650] io_schedule_timeout at c00000000139abe8
 #4 [c00000002a787680] balance_dirty_pages_ratelimited at c0000000004b01c0
 #5 [c00000002a787810] generic_perform_write at c0000000004965bc
 #6 [c00000002a787900] ext4_buffered_write_iter at c00000000077f3e4
 #7 [c00000002a787950] do_iter_readv_writev at c0000000005ef3a0
 #8 [c00000002a7879c0] do_iter_write at c0000000005f2568
 #9 [c00000002a787a10] lo_write_bvec at c000000000e506e8
#10 [c00000002a787ad0] loop_process_work at c000000000e523c4
#11 [c00000002a787c40] process_one_work at c00000000020e8d0
#12 [c00000002a787d10] worker_thread at c00000000020ef7c
#13 [c00000002a787da0] kthread at c00000000021cb74
#14 [c00000002a787e10] ret_from_kernel_thread at c00000000000cfd4

PID: 20175  TASK: c000000031de9980  CPU: 23  COMMAND: "kworker/u64:8"
 #0 [c000000023967360] __schedule at c00000000139ba50
 #1 [c000000023967430] schedule at c00000000139bcc4
 #2 [c000000023967460] schedule_timeout at c0000000013a42bc
 #3 [c000000023967530] io_schedule_timeout at c00000000139abe8
 #4 [c000000023967560] balance_dirty_pages_ratelimited at c0000000004b01c0
 #5 [c0000000239676f0] iomap_file_buffered_write at c0000000006e3018
 #6 [c0000000239678a0] xfs_file_buffered_write at c0000000009d9d20
 #7 [c000000023967950] do_iter_readv_writev at c0000000005ef3a0
 #8 [c0000000239679c0] do_iter_write at c0000000005f2568
 #9 [c000000023967a10] lo_write_bvec at c000000000e506e8
#10 [c000000023967ad0] loop_process_work at c000000000e523c4
#11 [c000000023967c40] process_one_work at c00000000020e8d0
#12 [c000000023967d10] worker_thread at c00000000020ef7c
#13 [c000000023967da0] kthread at c00000000021cb74
#14 [c000000023967e10] ret_from_kernel_thread at c00000000000cfd4

PID: 23482  TASK: c000000008e3cc80  CPU: 1   COMMAND: "kworker/u64:3"
 #0 [c0000000297c7160] __schedule at c00000000139ba50
 #1 [c0000000297c7230] schedule at c00000000139bcc4
 #2 [c0000000297c7260] io_schedule at c00000000139bdd4
 #3 [c0000000297c7290] blk_mq_get_tag at c000000000c4483c
 #4 [c0000000297c7320] __blk_mq_alloc_request at c000000000c3b038
 #5 [c0000000297c7360] blk_mq_submit_bio at c000000000c403dc
 #6 [c0000000297c7410] submit_bio_noacct at c000000000c2cc38
 #7 [c0000000297c74c0] iomap_do_writepage at c0000000006e2308
 #8 [c0000000297c75a0] write_cache_pages at c0000000004b0fb4
 #9 [c0000000297c76e0] iomap_writepages at c0000000006df2bc
#10 [c0000000297c7710] xfs_vm_writepages at c0000000009c2f2c
#11 [c0000000297c77d0] do_writepages at c0000000004b28e0
#12 [c0000000297c7890] __writeback_single_inode at c00000000064ea4c
#13 [c0000000297c7900] writeback_sb_inodes at c00000000064f954
#14 [c0000000297c79f0] __writeback_inodes_wb at c00000000064fdc4
#15 [c0000000297c7a50] wb_writeback at c0000000006500fc
#16 [c0000000297c7b00] wb_workfn at c000000000651908
#17 [c0000000297c7c40] process_one_work at c00000000020e8d0
#18 [c0000000297c7d10] worker_thread at c00000000020ef7c
#19 [c0000000297c7da0] kthread at c00000000021cb74
#20 [c0000000297c7e10] ret_from_kernel_thread at c00000000000cfd4

PID: 26082  TASK: c000000029740080  CPU: 3   COMMAND: "xfs_io"
 #0 [c000000031937610] __schedule at c00000000139ba50
 #1 [c0000000319376e0] schedule at c00000000139bcc4
 #2 [c000000031937710] schedule_timeout at c0000000013a42bc
 #3 [c0000000319377e0] io_schedule_timeout at c00000000139abe8
 #4 [c000000031937810] balance_dirty_pages_ratelimited at c0000000004b01c0
 #5 [c0000000319379a0] iomap_file_buffered_write at c0000000006e3018
 #6 [c000000031937b50] xfs_file_buffered_write at c0000000009d9d20
 #7 [c000000031937c00] new_sync_write at c0000000005ef194
 #8 [c000000031937ca0] vfs_write at c0000000005f3bb4
 #9 [c000000031937cf0] sys_pwrite64 at c0000000005f3f3c
#10 [c000000031937d50] system_call_exception at c000000000035ba0
#11 [c000000031937e10] system_call_common at c00000000000c764


-ritesh

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  common/rc |    8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/common/rc b/common/rc
> index 275b1f24..a174b695 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -3849,6 +3849,14 @@ _create_loop_device()
>  {
>  	local file=$1 dev
>  	dev=`losetup -f --show $file` || _fail "Cannot assign $file to a loop device"
> +
> +	# Try to enable asynchronous directio mode on the loopback device so
> +	# that writeback started by a filesystem mounted on the loop device
> +	# won't be throttled by buffered writes to the lower filesystem.  This
> +	# is a performance optimization for tests that want to write a lot of
> +	# data, so it isn't required to work.
> +	test -b "$dev" && losetup --direct-io=on $dev 2> /dev/null
> +
>  	echo $dev
>  }
>
