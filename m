Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5A151247D
	for <lists+linux-xfs@lfdr.de>; Wed, 27 Apr 2022 23:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234532AbiD0V24 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 27 Apr 2022 17:28:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiD0V2z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 27 Apr 2022 17:28:55 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7C28A1DE
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 14:25:42 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-62-197.pa.nsw.optusnet.com.au [49.195.62.197])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id AD5A3539C08;
        Thu, 28 Apr 2022 07:25:40 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1njpAI-005Ics-Rm; Thu, 28 Apr 2022 07:25:38 +1000
Date:   Thu, 28 Apr 2022 07:25:38 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [ANNOUNCE] xfs: for-next tree updated to a44a027a8b2a
Message-ID: <20220427212538.GP1098723@dread.disaster.area>
References: <20220425231714.GK1544202@dread.disaster.area>
 <20220427183222.GJ17025@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427183222.GJ17025@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=6269b4d5
        a=KhGSFSjofVlN3/cgq4AT7A==:117 a=KhGSFSjofVlN3/cgq4AT7A==:17
        a=kj9zAlcOel0A:10 a=z0gMJWrwH1QA:10 a=7-415B0cAAAA:8
        a=dnl-0r17gHI2Vek3gbIA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 27, 2022 at 11:32:22AM -0700, Darrick J. Wong wrote:
> On Tue, Apr 26, 2022 at 09:17:14AM +1000, Dave Chinner wrote:
> > Hi folks,
> > 
> > I just pushed out a new for-next branch for the XFS tree. It
> > contains:
> > 
> > - pending fixes for 5.18
> > - various miscellaneous fixes
> > - xlog_write() rework
> > - conversions to unsigned for trace_printk flags
> > - large on-disk extent counts
> > 
> > This all passes my local regression testing, though further smoke
> > testing in different environments would be appreaciated.
> > 
> > I haven't pulled in fixes from late last week yet - I'll work
> > through those in the next couple of days to get them into the tree
> > as well.
> > 
> > If I've missed anything you were expecting to see in this update,
> > let me know and I'll get them sorted for the next update.
> 
> Hmm.  I saw the following crash on an arm64 VM with 64k page size and an
> 8k blocksize:

Ok, that's a whacky config I can't directly test here. 

> run fstests xfs/502 at 2022-04-26 20:54:15
> spectre-v4 mitigation disabled by command-line option
> XFS (sda2): Mounting V5 Filesystem
> XFS (sda2): Ending clean mount
> XFS (sda3): Mounting V5 Filesystem
> XFS (sda3): Ending clean mount
> XFS (sda3): Quotacheck needed: Please wait.
> XFS (sda3): Quotacheck: Done.
> XFS (sda3): Injecting error (false) at file fs/xfs/xfs_inode.c, line 1876, on filesystem "sda3"
> XFS (sda3): Injecting error (false) at file fs/xfs/xfs_inode.c, line 1876, on filesystem "sda3"
> XFS (sda3): Injecting error (false) at file fs/xfs/xfs_inode.c, line 1876, on filesystem "sda3"
> XFS (sda3): Injecting error (false) at file fs/xfs/xfs_inode.c, line 1876, on filesystem "sda3"
> XFS (sda3): Injecting error (false) at file fs/xfs/xfs_inode.c, line 1876, on filesystem "sda3"
> XFS (sda3): Injecting error (false) at file fs/xfs/xfs_inode.c, line 1876, on filesystem "sda3"
> XFS (sda3): Injecting error (false) at file fs/xfs/xfs_inode.c, line 1876, on filesystem "sda3"
> XFS (sda3): Injecting error (false) at file fs/xfs/xfs_inode.c, line 1876, on filesystem "sda3"
> XFS (sda3): Injecting error (false) at file fs/xfs/xfs_inode.c, line 1876, on filesystem "sda3"
> XFS (sda3): Injecting error (false) at file fs/xfs/xfs_inode.c, line 1876, on filesystem "sda3"
> XFS: Assertion failed: IS_ALIGNED((unsigned long)lv->lv_buf, sizeof(uint64_t)), file: fs/xfs/xfs_log_cil.c, line: 431

Huh. That implies that memory allocation for the shadow buffer
wasn't 8 byte aligned because:

                        lv->lv_buf = (char *)lv +
					xlog_cil_iovec_space(lv->lv_niovecs);

And:

static inline int
xlog_cil_iovec_space(
        uint    niovecs)
{
        return round_up((sizeof(struct xfs_log_vec) +
                                        niovecs * sizeof(struct xfs_log_iovec)),
                        sizeof(uint64_t));
}

So the length returned by xlog_cil_iovec_space() is always a
multiple of 8 bytes. Hence the only way lv->lv_buf would not be
aligned to 8 bytes is if the original allocation was not aligned.

That buffer comes from:

static inline void *
xlog_cil_kvmalloc(
        size_t          buf_size)
{
        gfp_t           flags = GFP_KERNEL;
        void            *p;

        flags &= ~__GFP_DIRECT_RECLAIM;
        flags |= __GFP_NOWARN | __GFP_NORETRY;
        do {
                p = kmalloc(buf_size, flags);
                if (!p)
                        p = vmalloc(buf_size);
        } while (!p);

        return p;
}

vmalloc() guarantees alignment of the returned buffer, so this must
have come from a heap allocation via kmalloc() and that must have
returned something that is not 8 byte aligned...

Oh, after the XFS assert, a second oops happened, this time in
kmalloc():

> Unable to handle kernel paging request at virtual address 9ac7c01eb06874e8
> Mem abort info:
>   ESR = 0x96000004
>   EC = 0x25: DABT (current EL), IL = 32 bits
>   SET = 0, FnV = 0
>   EA = 0, S1PTW = 0
>   FSC = 0x04: level 0 translation fault
> Data abort info:
>   ISV = 0, ISS = 0x00000004
>   CM = 0, WnR = 0
> [9ac7c01eb06874e8] address between user and kernel address ranges
> Internal error: Oops: 96000004 [#1] PREEMPT SMP
> Dumping ftrace buffer:
>    (ftrace buffer empty)
> Modules linked in: xfs dm_delay dm_zero dm_flakey dm_snapshot dm_thin_pool dm_persistent_data dm_bio_prison dm_bufio libcrc32c xt_REDIRECT iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 rputh_rpcgss xt_tcpudp ip_set_hash_ip ip_set_hash_net xt_set ip_set_hash_mac ip6table_filter ip6_tables bfq iptable_filter crct10dif_ce sch_fq_codel efivarfs ip_tables x_tables overlay nfsv4 [last unloaded: xfs]
> CPU: 1 PID: 3168300 Comm: t_open_tmpfiles Tainted: G        W         5.17.0-xfsa #5.17.0 0288cc936a4dc1878aaf6a4c6fa6235f949bf1e9
> Hardware name: QEMU KVM Virtual Machine, BIOS 1.5.1 06/16/2021
> pstate: a0401005 (NzCv daif +PAN -UAO -TCO -DIT +SSBS BTYPE=--)
> pc : __kmalloc+0x120/0x3f0
> lr : __kmalloc+0xe8/0x3f0
> sp : fffffe00213ef840
> x29: fffffe00213ef840 x28: 0000000000000002 x27: fffffe0008fe6000
> x26: fffffc00e8740000 x25: fffffe00090e9000 x24: fffffe0001523c44
> x23: 0000000000000150 x22: 00000000000128c0 x21: 0000000000000000
> x20: 9ac7c01eb06874e8 x19: fffffc00e0010400 x18: 0000000000000000
> x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
> x14: 0000000000000000 x13: 0000f0ffffffffff x12: 0000000000000040
> x11: fffffc0133b5c678 x10: fffffc0133b5c67a x9 : fffffe0008294814
> x8 : 0000000000000001 x7 : fffffe01f68d0000 x6 : 8d4857517c5941da
> x5 : 00000000019ff6ec x4 : 0000000000000100 x3 : 0000000000000000
> x2 : e87468b01ec0c79a x1 : 0000000003a724a9 x0 : 9ac7c01eb06873e8
> Call trace:
>  __kmalloc+0x120/0x3f0
>  xlog_cil_commit+0x144/0x9b0 [xfs afa05b7bcc3355e0f6d54fdf0bba6e6ddd5eafff]

This smells like heap corruption has occurred and the CIL commit
code was the unfortunate victim that tripped over it first. That
would explain the unaligned object being returned from kmalloc().

Did you have any memory debugging options turned on?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
