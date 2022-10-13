Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4F75FE160
	for <lists+linux-xfs@lfdr.de>; Thu, 13 Oct 2022 20:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232063AbiJMSgI (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 13 Oct 2022 14:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232049AbiJMSfj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Oct 2022 14:35:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33F4B167243;
        Thu, 13 Oct 2022 11:32:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF5C9B81CFF;
        Thu, 13 Oct 2022 18:30:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC0FC433C1;
        Thu, 13 Oct 2022 18:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665685857;
        bh=y3OVZLGZlMFxQ3e0DSSQKZ5EO2w0bPirGWp8DPkVRQs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mMLf6H72QTgZ4D+KLEFrD+Fg+rNyCUbt+0gfNXi32s4C/h9YAk8JEoXYLgNns0tRA
         IR9eIPbmrseCHKxGmorGPAZ7wHij+ERLyXs1mbf6LTVrE22VzxXc7J1fFpF8hwQDr/
         +gDen5jyWdPa0as5D1x5uqe5+lQG8uUBkI2cEDwyQENKX26wv/RugvQm66rfNrRdVV
         6e35kmzepyN4f5IPfqnjszxhi7KvppyqPIV82NSc9ouKzO0cFALQeWIoymsOJ9wxgq
         ESZo5Ao9pMU5SXvEnVk9/fDNMBjqA4w0P/KGaj+tCaW+RqO+L1/jvxx4ISVfN8di2b
         zKjIYooAMznLg==
Date:   Thu, 13 Oct 2022 11:30:56 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        dan.j.williams@intel.com
Subject: Re: [RFC PATCH] xfs: drop experimental warning for fsdax
Message-ID: <Y0hZYCL3+no9qSSW@magnolia>
References: <1663234002-17-1-git-send-email-ruansy.fnst@fujitsu.com>
 <20220919045003.GJ3600936@dread.disaster.area>
 <20220919211533.GK3600936@dread.disaster.area>
 <f10de555-370b-f236-1107-e3089258ebbc@fujitsu.com>
 <YzMeqNg56v0/t/8x@magnolia>
 <20220927235129.GC3600936@dread.disaster.area>
 <2428b01d-afc7-7b33-1088-e34d68029e19@fujitsu.com>
 <YzXsavOWMSuwTBEC@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YzXsavOWMSuwTBEC@magnolia>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75 autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 29, 2022 at 12:05:14PM -0700, Darrick J. Wong wrote:
> On Wed, Sep 28, 2022 at 10:46:17PM +0800, Shiyang Ruan wrote:
> > 
> > 
> > 在 2022/9/28 7:51, Dave Chinner 写道:
> > > On Tue, Sep 27, 2022 at 09:02:48AM -0700, Darrick J. Wong wrote:
> > > > On Tue, Sep 27, 2022 at 02:53:14PM +0800, Shiyang Ruan wrote:
> > ...
> > > > > 
> > > > > I have tested these two mode for many times:
> > > > > 
> > > > > xfs_dax mode did failed so many cases.  (If you tested with this "drop"
> > > > > patch, some warning around "dax_dedupe_file_range_compare()" won't occur any
> > > > > more.)  I think warning around "dax_disassociate_entry()" is a problem with
> > > > > concurrency.  Still looking into it.
> > > > > 
> > > > > But xfs_dax_noreflink didn't have so many failure, just 3 in my environment:
> > > > > Failures: generic/471 generic/519 xfs/148.  I am thinking that did you
> > > > > forget to reformat the TEST_DEV to be non-reflink before run the test?  If
> > > > > so it will make sense.
> > > 
> > > No, I did not forget to turn off reflink for the test device:
> > > 
> > > # ./run_check.sh --mkfs-opts "-m reflink=0,rmapbt=1" --run-opts "-s xfs_dax_noreflink -g auto"
> > > umount: /mnt/test: not mounted.
> > > umount: /mnt/scratch: not mounted.
> > > wrote 8589934592/8589934592 bytes at offset 0
> > > 8.000 GiB, 8192 ops; 0:00:03.99 (2.001 GiB/sec and 2049.0850 ops/sec)
> > > wrote 8589934592/8589934592 bytes at offset 0
> > > 8.000 GiB, 8192 ops; 0:00:04.13 (1.936 GiB/sec and 1982.5453 ops/sec)
> > > meta-data=/dev/pmem0             isize=512    agcount=4, agsize=524288 blks
> > >           =                       sectsz=4096  attr=2, projid32bit=1
> > >           =                       crc=1        finobt=1, sparse=1, rmapbt=1
> > >           =                       reflink=0    bigtime=1 inobtcount=1 nrext64=0
> > > data     =                       bsize=4096   blocks=2097152, imaxpct=25
> > >           =                       sunit=0      swidth=0 blks
> > > naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> > > log      =internal log           bsize=4096   blocks=16384, version=2
> > >           =                       sectsz=4096  sunit=1 blks, lazy-count=1
> > > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > > .....
> > > Running: MOUNT_OPTIONS= ./check -R xunit -b -s xfs_dax_noreflink -g auto
> > > SECTION       -- xfs_dax_noreflink
> > > FSTYP         -- xfs (debug)
> > > PLATFORM      -- Linux/x86_64 test3 6.0.0-rc6-dgc+ #1543 SMP PREEMPT_DYNAMIC Mon Sep 19 07:46:37 AEST 2022
> > > MKFS_OPTIONS  -- -f -m reflink=0,rmapbt=1 /dev/pmem1
> > > MOUNT_OPTIONS -- -o dax=always -o context=system_u:object_r:root_t:s0 /dev/pmem1 /mnt/scratch
> > > 
> > > So, yeah, reflink was turned off on both test and scratch devices,
> > > and dax=always on both the test and scratch devices was used to
> > > ensure that DAX was always in use.
> > > 
> > > 
> > > > FWIW I saw dmesg failures in xfs/517 and xfs/013 starting with 6.0-rc5,
> > > > and I haven't even turned on reflink yet:
> > > > 
> > > > run fstests xfs/517 at 2022-09-26 19:53:34
> > > > XFS (pmem1): EXPERIMENTAL Large extent counts feature in use. Use at your own risk!
> > > > XFS (pmem1): Mounting V5 Filesystem
> > > > XFS (pmem1): Ending clean mount
> > > > XFS (pmem1): Quotacheck needed: Please wait.
> > > > XFS (pmem1): Quotacheck: Done.
> > > > XFS (pmem1): Unmounting Filesystem
> > > > XFS (pmem0): EXPERIMENTAL online scrub feature in use. Use at your own risk!
> > > > XFS (pmem1): EXPERIMENTAL Large extent counts feature in use. Use at your own risk!
> > > > XFS (pmem1): Mounting V5 Filesystem
> > > > XFS (pmem1): Ending clean mount
> > > > XFS (pmem1): Quotacheck needed: Please wait.
> > > > XFS (pmem1): Quotacheck: Done.
> > > > ------------[ cut here ]------------
> > > > WARNING: CPU: 1 PID: 415317 at fs/dax.c:380 dax_insert_entry+0x22d/0x320

Ping?

This time around I replaced the WARN_ON with this:

	if (page->mapping)
		printk(KERN_ERR "%s:%d ino 0x%lx index 0x%lx page 0x%llx mapping 0x%llx <- 0x%llx\n", __func__, __LINE__, mapping->host->i_ino, index + i, (unsigned long long)page, (unsigned long long)page->mapping, (unsigned long long)mapping);

and promptly started seeing scary things like this:

[   37.576598] dax_associate_entry:381 ino 0x1807870 index 0x370 page 0xffffea00133f1480 mapping 0x1 <- 0xffff888042fbb528
[   37.577570] dax_associate_entry:381 ino 0x1807870 index 0x371 page 0xffffea00133f1500 mapping 0x1 <- 0xffff888042fbb528
[   37.698657] dax_associate_entry:381 ino 0x180044a index 0x5f8 page 0xffffea0013244900 mapping 0xffff888042eaf128 <- 0xffff888042dda128
[   37.699349] dax_associate_entry:381 ino 0x800808 index 0x136 page 0xffffea0013245640 mapping 0xffff888042eaf128 <- 0xffff888042d3ce28
[   37.699680] dax_associate_entry:381 ino 0x180044a index 0x5f9 page 0xffffea0013245680 mapping 0xffff888042eaf128 <- 0xffff888042dda128
[   37.700684] dax_associate_entry:381 ino 0x800808 index 0x137 page 0xffffea00132456c0 mapping 0xffff888042eaf128 <- 0xffff888042d3ce28
[   37.701611] dax_associate_entry:381 ino 0x180044a index 0x5fa page 0xffffea0013245700 mapping 0xffff888042eaf128 <- 0xffff888042dda128
[   37.764126] dax_associate_entry:381 ino 0x103c52c index 0x28a page 0xffffea001345afc0 mapping 0x1 <- 0xffff888019c14928
[   37.765078] dax_associate_entry:381 ino 0x103c52c index 0x28b page 0xffffea001345b000 mapping 0x1 <- 0xffff888019c14928
[   39.193523] dax_associate_entry:381 ino 0x184657f index 0x124 page 0xffffea000e2a4440 mapping 0xffff8880120d7628 <- 0xffff888019ca3528
[   39.194692] dax_associate_entry:381 ino 0x184657f index 0x125 page 0xffffea000e2a4480 mapping 0xffff8880120d7628 <- 0xffff888019ca3528
[   39.195716] dax_associate_entry:381 ino 0x184657f index 0x126 page 0xffffea000e2a44c0 mapping 0xffff8880120d7628 <- 0xffff888019ca3528
[   39.196736] dax_associate_entry:381 ino 0x184657f index 0x127 page 0xffffea000e2a4500 mapping 0xffff8880120d7628 <- 0xffff888019ca3528
[   39.197906] dax_associate_entry:381 ino 0x184657f index 0x128 page 0xffffea000e2a5040 mapping 0xffff8880120d7628 <- 0xffff888019ca3528
[   39.198924] dax_associate_entry:381 ino 0x184657f index 0x129 page 0xffffea000e2a5080 mapping 0xffff8880120d7628 <- 0xffff888019ca3528
[   39.247053] dax_associate_entry:381 ino 0x5dd1e index 0x2d page 0xffffea0015a0e640 mapping 0x1 <- 0xffff88804af88828
[   39.248006] dax_associate_entry:381 ino 0x5dd1e index 0x2e page 0xffffea0015a0e680 mapping 0x1 <- 0xffff88804af88828
[   39.490880] dax_associate_entry:381 ino 0x1a9dc index 0x7d page 0xffffea000e7012c0 mapping 0xffff888042fd1728 <- 0xffff88804afaec28
[   39.492038] dax_associate_entry:381 ino 0x1a9dc index 0x7e page 0xffffea000e701300 mapping 0xffff888042fd1728 <- 0xffff88804afaec28
[   39.493099] dax_associate_entry:381 ino 0x1a9dc index 0x7f page 0xffffea000e701340 mapping 0xffff888042fd1728 <- 0xffff88804afaec28
[   40.926247] dax_associate_entry:381 ino 0x182e265 index 0x54c page 0xffffea0015da0840 mapping 0x1 <- 0xffff888019c0dd28
[   41.675459] dax_associate_entry:381 ino 0x15e5d index 0x29 page 0xffffea000e4350c0 mapping 0x1 <- 0xffff888019c05828
[   41.676418] dax_associate_entry:381 ino 0x15e5d index 0x2a page 0xffffea000e435100 mapping 0x1 <- 0xffff888019c05828
[   41.677352] dax_associate_entry:381 ino 0x15e5d index 0x2b page 0xffffea000e435180 mapping 0x1 <- 0xffff888019c05828
[   41.678372] dax_associate_entry:381 ino 0x15e5d index 0x2c page 0xffffea000e4351c0 mapping 0x1 <- 0xffff888019c05828
[   41.965026] dax_associate_entry:381 ino 0x185adb4 index 0x87 page 0xffffea000e616d00 mapping 0x1 <- 0xffff88801a83b528
[   41.966065] dax_associate_entry:381 ino 0x185adb4 index 0x88 page 0xffffea000e616d40 mapping 0x1 <- 0xffff88801a83b528
[   43.565384] dax_associate_entry:381 ino 0x804d9d index 0x229 page 0xffffea0013653fc0 mapping 0x1 <- 0xffff88804bd97128
[   43.566399] dax_associate_entry:381 ino 0x804d9d index 0x22a page 0xffffea0013654000 mapping 0x1 <- 0xffff88804bd97128
[   43.567343] dax_associate_entry:381 ino 0x804d9d index 0x22b page 0xffffea0013654040 mapping 0x1 <- 0xffff88804bd97128
[   45.512017] dax_associate_entry:381 ino 0x18192bb index 0x1f page 0xffffea00133f1300 mapping 0x1 <- 0xffff88804bcdb528
[   45.512974] dax_associate_entry:381 ino 0x18192bb index 0x20 page 0xffffea00133f1340 mapping 0x1 <- 0xffff88804bcdb528
[   45.513942] dax_associate_entry:381 ino 0x18192bb index 0x21 page 0xffffea00133f1380 mapping 0x1 <- 0xffff88804bcdb528
[   45.514857] dax_associate_entry:381 ino 0x18192bb index 0x22 page 0xffffea00133f13c0 mapping 0x1 <- 0xffff88804bcdb528
[   45.515760] dax_associate_entry:381 ino 0x18192bb index 0x23 page 0xffffea00133f1400 mapping 0x1 <- 0xffff88804bcdb528
[   45.516673] dax_associate_entry:381 ino 0x18192bb index 0x24 page 0xffffea00133f1440 mapping 0x1 <- 0xffff88804bcdb528

I'm not sure what's going on here, but we're clearly turning COW daxpages
back into single-mapping daxpages.  I'm not sure what's going on for the
cases where we're replacing one mapping with another.  My dimwitted
guess is that dax_fault_is_cow() is incorrectly returning false in some
cases.

Replacing the contents of that function with:

	if (iter->srcmap.type != IOMAP_HOLE)
		return true;
	if (iter->iomap.flags & IOMAP_F_SHARED)
		return true;
	return false;

Doesn't make the errors go away.  Curiously, replacing the entire
function body with "return true;" fixes /that/ problem though...

...but generic/649 still fails with things like:

[  571.224285] run fstests generic/649 at 2022-10-13 11:26:59
[  571.796353] XFS (pmem0): Mounting V5 Filesystem
[  571.799059] XFS (pmem0): Ending clean mount
[  572.378624] ------------[ cut here ]------------
[  572.379598] WARNING: CPU: 1 PID: 48538 at fs/dax.c:930 dax_writeback_mapping_range+0x2f1/0x600

Which comes from this warning in dax_writeback_one:

	/*
	 * A page got tagged dirty in DAX mapping? Something is seriously
	 * wrong.
	 */
	if (WARN_ON(!xa_is_value(entry)))
		return -EIO;

Help?

--D

> > > > Modules linked in: xfs nft_chain_nat xt_REDIRECT nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_tcpudp ip_set_hash_ip ip_set_hash_net xt_set nft_compat ip_set_hash_mac ip_set nf_tables libcrc32c bfq nfnetlink pvpanic_mmio pvpanic nd_pmem dax_pmem nd_btt sch_fq_codel fuse configfs ip_tables x_tables overlay nfsv4 af_packet [last unloaded: scsi_d
> > > > 
> > > > CPU: 1 PID: 415317 Comm: fsstress Tainted: G        W          6.0.0-rc7-xfsx #rc7 727341edbd0773a36b78b09dab448fa1896eb3a5
> > > > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1 04/01/2014
> > > > RIP: 0010:dax_insert_entry+0x22d/0x320
> > > > Code: e0 48 83 c4 20 5b 5d 41 5c 41 5d 41 5e 41 5f c3 48 8b 58 20 48 8d 53 01 e9 62 ff ff ff 48 8b 58 20 48 8d 53 01 e9 4d ff ff ff <0f> 0b e9 6d ff ff ff 31 f6 48 89 ef e8 72 74 12 00 eb a1 83 e0 02
> > > > RSP: 0000:ffffc90004693b28 EFLAGS: 00010002
> > > > RAX: ffffea0010a20480 RBX: 0000000000000001 RCX: 0000000000000001
> > > > RDX: ffffea0000000000 RSI: 0000000000000033 RDI: ffffea0010a204c0
> > > > RBP: ffffc90004693c08 R08: 0000000000000000 R09: 0000000000000000
> > > > R10: ffff88800c226228 R11: 0000000000000001 R12: 0000000000000011
> > > > R13: ffff88800c226228 R14: ffffc90004693e08 R15: 0000000000000000
> > > > FS:  00007f3aad8db740(0000) GS:ffff88803ed00000(0000) knlGS:0000000000000000
> > > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > CR2: 00007f3aad8d1000 CR3: 0000000043104003 CR4: 00000000001706e0
> > > > Call Trace:
> > > >   <TASK>
> > > >   dax_fault_iter+0x26e/0x670
> > > >   dax_iomap_pte_fault+0x1ab/0x3e0
> > > >   __xfs_filemap_fault+0x32f/0x5a0 [xfs c617487f99e14abfa5deb24e923415b927df3d4b]
> > > >   __do_fault+0x30/0x1e0
> > > >   do_fault+0x316/0x6d0
> > > >   ? mmap_region+0x2a5/0x620
> > > >   __handle_mm_fault+0x649/0x1250
> > > >   handle_mm_fault+0xc1/0x220
> > > >   do_user_addr_fault+0x1ac/0x610
> > > >   ? _copy_to_user+0x63/0x80
> > > >   exc_page_fault+0x63/0x130
> > > >   asm_exc_page_fault+0x22/0x30
> > > > RIP: 0033:0x7f3aada7f1ca
> > > > Code: c5 fe 7f 07 c5 fe 7f 47 20 c5 fe 7f 47 40 c5 fe 7f 47 60 c5 f8 77 c3 66 0f 1f 84 00 00 00 00 00 40 0f b6 c6 48 89 d1 48 89 fa <f3> aa 48 89 d0 c5 f8 77 c3 66 66 2e 0f 1f 84 00 00 00 00 00 66 90
> > > > RSP: 002b:00007ffe47afa688 EFLAGS: 00010206
> > > > RAX: 000000000000002e RBX: 0000000000033000 RCX: 000000000000999c
> > > > RDX: 00007f3aad8d1000 RSI: 000000000000002e RDI: 00007f3aad8d1000
> > > > RBP: 0000558851e13240 R08: 0000000000000000 R09: 0000000000033000
> > > > R10: 0000000000000008 R11: 0000000000000246 R12: 028f5c28f5c28f5c
> > > > R13: 8f5c28f5c28f5c29 R14: 000000000000999c R15: 0000000000001c81
> > > >   </TASK>
> > > > ---[ end trace 0000000000000000 ]---
> > > > XFS (pmem0): Unmounting Filesystem
> > > > XFS (pmem1): EXPERIMENTAL online scrub feature in use. Use at your own risk!
> > > > XFS (pmem1): *** REPAIR SUCCESS ino 0x80 type probe agno 0x0 inum 0x0 gen 0x0 flags 0x80000001 error 0
> > > > XFS (pmem1): Unmounting Filesystem
> > > > XFS (pmem1): EXPERIMENTAL Large extent counts feature in use. Use at your own risk!
> > > > XFS (pmem1): Mounting V5 Filesystem
> > > > XFS (pmem1): Ending clean mount
> > > > XFS (pmem1): Unmounting Filesystem
> > > 
> > > Yup, that's the same as what I'm seeing.
> > 
> > Could you send me your kernel config (or other configs needed for the test)?
> > I still cannot reproduce this warning when reflink is off, even without this
> > drop patch.  Maybe something different in config file?
> > 
> > 
> > PS: I specifically tried the two cases Darrick mentioned (on v6.0-rc6):
> > 
> > [root@f33 xfstests-dev]# mkfs.xfs -m reflink=0,rmapbt=1 /dev/pmem0.1 -f
> > meta-data=/dev/pmem0.1           isize=512    agcount=4, agsize=257920 blks
> >          =                       sectsz=4096  attr=2, projid32bit=1
> >          =                       crc=1        finobt=1, sparse=1, rmapbt=1
> >          =                       reflink=0    bigtime=1 inobtcount=1
> > nrext64=0
> > data     =                       bsize=4096   blocks=1031680, imaxpct=25
> >          =                       sunit=0      swidth=0 blks
> > naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> > log      =internal log           bsize=4096   blocks=16384, version=2
> >          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > [root@f33 xfstests-dev]# mkfs.xfs -m reflink=0,rmapbt=1 /dev/pmem0 -f
> > meta-data=/dev/pmem0             isize=512    agcount=4, agsize=257920 blks
> >          =                       sectsz=4096  attr=2, projid32bit=1
> >          =                       crc=1        finobt=1, sparse=1, rmapbt=1
> >          =                       reflink=0    bigtime=1 inobtcount=1
> > nrext64=0
> > data     =                       bsize=4096   blocks=1031680, imaxpct=25
> >          =                       sunit=0      swidth=0 blks
> > naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> > log      =internal log           bsize=4096   blocks=16384, version=2
> >          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > [root@f33 xfstests-dev]# ./check xfs/013 xfs/517
> > FSTYP         -- xfs (debug)
> > PLATFORM      -- Linux/x86_64 f33 6.0.0-rc6 #84 SMP PREEMPT_DYNAMIC Wed Sep
> > 28 18:27:33 CST 2022
> > MKFS_OPTIONS  -- -f -m reflink=0,rmapbt=1 /dev/pmem0.1
> > MOUNT_OPTIONS -- -o dax -o context=system_u:object_r:root_t:s0 /dev/pmem0.1
> > /mnt/scratch
> > 
> > xfs/013 127s ...  166s
> > xfs/517 66s ...  66s
> > Ran: xfs/013 xfs/517
> > Passed all 2 tests
> 
> I'm not sure what exactly is going weird here -- I tried it on my dev
> machine just now and it passed, but the similarly configured testcloud
> failed it last night.
> 
> FSTYP         -- xfs (debug)
> PLATFORM      -- Linux/x86_64 ca-nfsdev6-mtr03 6.0.0-rc7-xfsx #rc7 SMP
> PREEMPT_DYNAMIC Wed Sep 28 15:35:58 PDT 2022
> MKFS_OPTIONS  -- -f -m reflink=0, -d daxinherit=1, /dev/pmem1
> MOUNT_OPTIONS -- -o usrquota,grpquota,prjquota, /dev/pmem1 /opt
> 
> Note that I use libvirt to configure pmem in the VMs.  This is an
> excerpt of the end of domain xml file:
> 
>     <memory model='nvdimm' access='shared'>
>       <source>
>         <path>/run/mtrdisk/g.mem</path>
>       </source>
>       <target>
>         <size unit='KiB'>21104640</size>
>         <node>0</node>
>       </target>
>       <address type='dimm' slot='0'/>
>     </memory>
>     <memory model='nvdimm' access='shared'>
>       <source>
>         <path>/run/mtrdisk/h.mem</path>
>       </source>
>       <target>
>         <size unit='KiB'>21104640</size>
>         <node>1</node>
>       </target>
>       <address type='dimm' slot='1'/>
>     </memory>
>   </devices>
> </domain>
> 
> --D
> 
> #
> # Automatically generated file; DO NOT EDIT.
> # Linux/x86_64 6.0.0-rc7 xfs:xfsx Kernel
> #
> CONFIG_CC_VERSION_TEXT="x86_64-linux-gnu-gcc (Ubuntu 11.2.0-19ubuntu1) 11.2.0"
> CONFIG_CC_IS_GCC=y
> CONFIG_GCC_VERSION=110200
> CONFIG_CLANG_VERSION=0
> CONFIG_AS_IS_GNU=y
> CONFIG_AS_VERSION=23800
> CONFIG_LD_IS_BFD=y
> CONFIG_LD_VERSION=23800
> CONFIG_LLD_VERSION=0
> CONFIG_CC_CAN_LINK=y
> CONFIG_CC_CAN_LINK_STATIC=y
> CONFIG_CC_HAS_ASM_GOTO_OUTPUT=y
> CONFIG_CC_HAS_ASM_INLINE=y
> CONFIG_CC_HAS_NO_PROFILE_FN_ATTR=y
> CONFIG_PAHOLE_VERSION=122
> CONFIG_IRQ_WORK=y
> CONFIG_BUILDTIME_TABLE_SORT=y
> CONFIG_THREAD_INFO_IN_TASK=y
> 
> #
> # General setup
> #
> CONFIG_INIT_ENV_ARG_LIMIT=32
> # CONFIG_COMPILE_TEST is not set
> # CONFIG_WERROR is not set
> CONFIG_LOCALVERSION=""
> # CONFIG_LOCALVERSION_AUTO is not set
> CONFIG_BUILD_SALT=""
> CONFIG_HAVE_KERNEL_GZIP=y
> CONFIG_HAVE_KERNEL_BZIP2=y
> CONFIG_HAVE_KERNEL_LZMA=y
> CONFIG_HAVE_KERNEL_XZ=y
> CONFIG_HAVE_KERNEL_LZO=y
> CONFIG_HAVE_KERNEL_LZ4=y
> CONFIG_HAVE_KERNEL_ZSTD=y
> # CONFIG_KERNEL_GZIP is not set
> # CONFIG_KERNEL_BZIP2 is not set
> # CONFIG_KERNEL_LZMA is not set
> # CONFIG_KERNEL_XZ is not set
> # CONFIG_KERNEL_LZO is not set
> CONFIG_KERNEL_LZ4=y
> # CONFIG_KERNEL_ZSTD is not set
> CONFIG_DEFAULT_INIT=""
> CONFIG_DEFAULT_HOSTNAME="mtr.djwong.org"
> CONFIG_SYSVIPC=y
> CONFIG_SYSVIPC_SYSCTL=y
> CONFIG_SYSVIPC_COMPAT=y
> CONFIG_POSIX_MQUEUE=y
> CONFIG_POSIX_MQUEUE_SYSCTL=y
> # CONFIG_WATCH_QUEUE is not set
> CONFIG_CROSS_MEMORY_ATTACH=y
> # CONFIG_USELIB is not set
> # CONFIG_AUDIT is not set
> CONFIG_HAVE_ARCH_AUDITSYSCALL=y
> 
> #
> # IRQ subsystem
> #
> CONFIG_GENERIC_IRQ_PROBE=y
> CONFIG_GENERIC_IRQ_SHOW=y
> CONFIG_GENERIC_IRQ_EFFECTIVE_AFF_MASK=y
> CONFIG_GENERIC_PENDING_IRQ=y
> CONFIG_GENERIC_IRQ_MIGRATION=y
> CONFIG_HARDIRQS_SW_RESEND=y
> CONFIG_IRQ_DOMAIN=y
> CONFIG_IRQ_DOMAIN_HIERARCHY=y
> CONFIG_GENERIC_MSI_IRQ=y
> CONFIG_GENERIC_MSI_IRQ_DOMAIN=y
> CONFIG_GENERIC_IRQ_MATRIX_ALLOCATOR=y
> CONFIG_GENERIC_IRQ_RESERVATION_MODE=y
> CONFIG_IRQ_FORCED_THREADING=y
> CONFIG_SPARSE_IRQ=y
> # CONFIG_GENERIC_IRQ_DEBUGFS is not set
> # end of IRQ subsystem
> 
> CONFIG_CLOCKSOURCE_WATCHDOG=y
> CONFIG_ARCH_CLOCKSOURCE_INIT=y
> CONFIG_CLOCKSOURCE_VALIDATE_LAST_CYCLE=y
> CONFIG_GENERIC_TIME_VSYSCALL=y
> CONFIG_GENERIC_CLOCKEVENTS=y
> CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
> CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
> CONFIG_GENERIC_CMOS_UPDATE=y
> CONFIG_HAVE_POSIX_CPU_TIMERS_TASK_WORK=y
> CONFIG_POSIX_CPU_TIMERS_TASK_WORK=y
> CONFIG_CONTEXT_TRACKING=y
> CONFIG_CONTEXT_TRACKING_IDLE=y
> 
> #
> # Timers subsystem
> #
> CONFIG_TICK_ONESHOT=y
> CONFIG_NO_HZ_COMMON=y
> # CONFIG_HZ_PERIODIC is not set
> CONFIG_NO_HZ_IDLE=y
> # CONFIG_NO_HZ_FULL is not set
> CONFIG_NO_HZ=y
> CONFIG_HIGH_RES_TIMERS=y
> CONFIG_CLOCKSOURCE_WATCHDOG_MAX_SKEW_US=100
> # end of Timers subsystem
> 
> CONFIG_BPF=y
> CONFIG_HAVE_EBPF_JIT=y
> CONFIG_ARCH_WANT_DEFAULT_BPF_JIT=y
> 
> #
> # BPF subsystem
> #
> CONFIG_BPF_SYSCALL=y
> CONFIG_BPF_JIT=y
> CONFIG_BPF_JIT_ALWAYS_ON=y
> CONFIG_BPF_JIT_DEFAULT_ON=y
> CONFIG_BPF_UNPRIV_DEFAULT_OFF=y
> # CONFIG_BPF_PRELOAD is not set
> # end of BPF subsystem
> 
> CONFIG_PREEMPT_BUILD=y
> CONFIG_CPU_MITIGATIONS_OFF=y
> # CONFIG_CPU_MITIGATIONS_AUTO is not set
> # CONFIG_CPU_MITIGATIONS_AUTO_NOSMT is not set
> # CONFIG_PREEMPT_NONE is not set
> # CONFIG_PREEMPT_VOLUNTARY is not set
> CONFIG_PREEMPT=y
> CONFIG_PREEMPT_COUNT=y
> CONFIG_PREEMPTION=y
> CONFIG_PREEMPT_DYNAMIC=y
> CONFIG_SCHED_CORE=y
> 
> #
> # CPU/Task time and stats accounting
> #
> CONFIG_TICK_CPU_ACCOUNTING=y
> # CONFIG_VIRT_CPU_ACCOUNTING_GEN is not set
> CONFIG_IRQ_TIME_ACCOUNTING=y
> CONFIG_HAVE_SCHED_AVG_IRQ=y
> CONFIG_BSD_PROCESS_ACCT=y
> # CONFIG_BSD_PROCESS_ACCT_V3 is not set
> CONFIG_TASKSTATS=y
> CONFIG_TASK_DELAY_ACCT=y
> CONFIG_TASK_XACCT=y
> CONFIG_TASK_IO_ACCOUNTING=y
> CONFIG_PSI=y
> # CONFIG_PSI_DEFAULT_DISABLED is not set
> # end of CPU/Task time and stats accounting
> 
> # CONFIG_CPU_ISOLATION is not set
> 
> #
> # RCU Subsystem
> #
> CONFIG_TREE_RCU=y
> CONFIG_PREEMPT_RCU=y
> # CONFIG_RCU_EXPERT is not set
> CONFIG_SRCU=y
> CONFIG_TREE_SRCU=y
> CONFIG_TASKS_RCU_GENERIC=y
> CONFIG_TASKS_RCU=y
> CONFIG_TASKS_RUDE_RCU=y
> CONFIG_TASKS_TRACE_RCU=y
> CONFIG_RCU_STALL_COMMON=y
> CONFIG_RCU_NEED_SEGCBLIST=y
> # end of RCU Subsystem
> 
> # CONFIG_IKCONFIG is not set
> # CONFIG_IKHEADERS is not set
> CONFIG_LOG_BUF_SHIFT=17
> CONFIG_LOG_CPU_MAX_BUF_SHIFT=12
> CONFIG_PRINTK_SAFE_LOG_BUF_SHIFT=13
> # CONFIG_PRINTK_INDEX is not set
> CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
> 
> #
> # Scheduler features
> #
> # end of Scheduler features
> 
> CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y
> CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH=y
> CONFIG_CC_HAS_INT128=y
> CONFIG_CC_IMPLICIT_FALLTHROUGH="-Wimplicit-fallthrough=5"
> CONFIG_GCC12_NO_ARRAY_BOUNDS=y
> CONFIG_ARCH_SUPPORTS_INT128=y
> CONFIG_NUMA_BALANCING=y
> CONFIG_NUMA_BALANCING_DEFAULT_ENABLED=y
> CONFIG_CGROUPS=y
> CONFIG_PAGE_COUNTER=y
> # CONFIG_CGROUP_FAVOR_DYNMODS is not set
> CONFIG_MEMCG=y
> CONFIG_MEMCG_SWAP=y
> CONFIG_MEMCG_KMEM=y
> CONFIG_BLK_CGROUP=y
> CONFIG_CGROUP_WRITEBACK=y
> CONFIG_CGROUP_SCHED=y
> CONFIG_FAIR_GROUP_SCHED=y
> # CONFIG_CFS_BANDWIDTH is not set
> # CONFIG_RT_GROUP_SCHED is not set
> # CONFIG_CGROUP_PIDS is not set
> # CONFIG_CGROUP_RDMA is not set
> CONFIG_CGROUP_FREEZER=y
> # CONFIG_CGROUP_HUGETLB is not set
> CONFIG_CPUSETS=y
> # CONFIG_PROC_PID_CPUSET is not set
> # CONFIG_CGROUP_DEVICE is not set
> CONFIG_CGROUP_CPUACCT=y
> # CONFIG_CGROUP_PERF is not set
> # CONFIG_CGROUP_BPF is not set
> # CONFIG_CGROUP_MISC is not set
> # CONFIG_CGROUP_DEBUG is not set
> CONFIG_NAMESPACES=y
> CONFIG_UTS_NS=y
> CONFIG_TIME_NS=y
> CONFIG_IPC_NS=y
> CONFIG_USER_NS=y
> CONFIG_PID_NS=y
> CONFIG_NET_NS=y
> # CONFIG_CHECKPOINT_RESTORE is not set
> CONFIG_SCHED_AUTOGROUP=y
> # CONFIG_SYSFS_DEPRECATED is not set
> CONFIG_RELAY=y
> CONFIG_BLK_DEV_INITRD=y
> CONFIG_INITRAMFS_SOURCE=""
> CONFIG_RD_GZIP=y
> # CONFIG_RD_BZIP2 is not set
> # CONFIG_RD_LZMA is not set
> # CONFIG_RD_XZ is not set
> # CONFIG_RD_LZO is not set
> CONFIG_RD_LZ4=y
> # CONFIG_RD_ZSTD is not set
> CONFIG_BOOT_CONFIG=y
> # CONFIG_BOOT_CONFIG_EMBED is not set
> CONFIG_INITRAMFS_PRESERVE_MTIME=y
> CONFIG_CC_OPTIMIZE_FOR_PERFORMANCE=y
> # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
> CONFIG_LD_ORPHAN_WARN=y
> CONFIG_SYSCTL=y
> CONFIG_HAVE_UID16=y
> CONFIG_SYSCTL_EXCEPTION_TRACE=y
> CONFIG_HAVE_PCSPKR_PLATFORM=y
> CONFIG_EXPERT=y
> CONFIG_UID16=y
> CONFIG_MULTIUSER=y
> # CONFIG_SGETMASK_SYSCALL is not set
> # CONFIG_SYSFS_SYSCALL is not set
> CONFIG_FHANDLE=y
> CONFIG_POSIX_TIMERS=y
> CONFIG_PRINTK=y
> CONFIG_BUG=y
> CONFIG_ELF_CORE=y
> CONFIG_PCSPKR_PLATFORM=y
> CONFIG_BASE_FULL=y
> CONFIG_FUTEX=y
> CONFIG_FUTEX_PI=y
> CONFIG_EPOLL=y
> CONFIG_SIGNALFD=y
> CONFIG_TIMERFD=y
> CONFIG_EVENTFD=y
> CONFIG_SHMEM=y
> CONFIG_AIO=y
> CONFIG_IO_URING=y
> CONFIG_ADVISE_SYSCALLS=y
> CONFIG_MEMBARRIER=y
> CONFIG_KALLSYMS=y
> CONFIG_KALLSYMS_ALL=y
> CONFIG_KALLSYMS_ABSOLUTE_PERCPU=y
> CONFIG_KALLSYMS_BASE_RELATIVE=y
> CONFIG_ARCH_HAS_MEMBARRIER_SYNC_CORE=y
> # CONFIG_KCMP is not set
> # CONFIG_RSEQ is not set
> # CONFIG_EMBEDDED is not set
> CONFIG_HAVE_PERF_EVENTS=y
> # CONFIG_PC104 is not set
> 
> #
> # Kernel Performance Events And Counters
> #
> CONFIG_PERF_EVENTS=y
> # CONFIG_DEBUG_PERF_USE_VMALLOC is not set
> # end of Kernel Performance Events And Counters
> 
> # CONFIG_PROFILING is not set
> CONFIG_TRACEPOINTS=y
> # end of General setup
> 
> CONFIG_64BIT=y
> CONFIG_X86_64=y
> CONFIG_X86=y
> CONFIG_INSTRUCTION_DECODER=y
> CONFIG_OUTPUT_FORMAT="elf64-x86-64"
> CONFIG_LOCKDEP_SUPPORT=y
> CONFIG_STACKTRACE_SUPPORT=y
> CONFIG_MMU=y
> CONFIG_ARCH_MMAP_RND_BITS_MIN=28
> CONFIG_ARCH_MMAP_RND_BITS_MAX=32
> CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MIN=8
> CONFIG_ARCH_MMAP_RND_COMPAT_BITS_MAX=16
> CONFIG_GENERIC_BUG=y
> CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
> CONFIG_GENERIC_CALIBRATE_DELAY=y
> CONFIG_ARCH_HAS_CPU_RELAX=y
> CONFIG_ARCH_HIBERNATION_POSSIBLE=y
> CONFIG_ARCH_NR_GPIO=1024
> CONFIG_ARCH_SUSPEND_POSSIBLE=y
> CONFIG_AUDIT_ARCH=y
> CONFIG_X86_64_SMP=y
> CONFIG_ARCH_SUPPORTS_UPROBES=y
> CONFIG_FIX_EARLYCON_MEM=y
> CONFIG_PGTABLE_LEVELS=4
> CONFIG_CC_HAS_SANE_STACKPROTECTOR=y
> 
> #
> # Processor type and features
> #
> CONFIG_SMP=y
> CONFIG_X86_FEATURE_NAMES=y
> CONFIG_X86_X2APIC=y
> # CONFIG_X86_MPPARSE is not set
> # CONFIG_GOLDFISH is not set
> # CONFIG_X86_CPU_RESCTRL is not set
> # CONFIG_X86_EXTENDED_PLATFORM is not set
> # CONFIG_X86_INTEL_LPSS is not set
> # CONFIG_X86_AMD_PLATFORM_DEVICE is not set
> # CONFIG_IOSF_MBI is not set
> CONFIG_X86_SUPPORTS_MEMORY_FAILURE=y
> # CONFIG_SCHED_OMIT_FRAME_POINTER is not set
> CONFIG_HYPERVISOR_GUEST=y
> CONFIG_PARAVIRT=y
> # CONFIG_PARAVIRT_DEBUG is not set
> CONFIG_PARAVIRT_SPINLOCKS=y
> CONFIG_X86_HV_CALLBACK_VECTOR=y
> # CONFIG_XEN is not set
> CONFIG_KVM_GUEST=y
> CONFIG_ARCH_CPUIDLE_HALTPOLL=y
> CONFIG_PVH=y
> CONFIG_PARAVIRT_TIME_ACCOUNTING=y
> CONFIG_PARAVIRT_CLOCK=y
> # CONFIG_JAILHOUSE_GUEST is not set
> # CONFIG_ACRN_GUEST is not set
> # CONFIG_INTEL_TDX_GUEST is not set
> # CONFIG_MK8 is not set
> # CONFIG_MPSC is not set
> CONFIG_MCORE2=y
> # CONFIG_MATOM is not set
> # CONFIG_GENERIC_CPU is not set
> CONFIG_X86_INTERNODE_CACHE_SHIFT=6
> CONFIG_X86_L1_CACHE_SHIFT=6
> CONFIG_X86_INTEL_USERCOPY=y
> CONFIG_X86_USE_PPRO_CHECKSUM=y
> CONFIG_X86_P6_NOP=y
> CONFIG_X86_TSC=y
> CONFIG_X86_CMPXCHG64=y
> CONFIG_X86_CMOV=y
> CONFIG_X86_MINIMUM_CPU_FAMILY=64
> CONFIG_X86_DEBUGCTLMSR=y
> CONFIG_IA32_FEAT_CTL=y
> CONFIG_X86_VMX_FEATURE_NAMES=y
> CONFIG_PROCESSOR_SELECT=y
> CONFIG_CPU_SUP_INTEL=y
> CONFIG_CPU_SUP_AMD=y
> # CONFIG_CPU_SUP_HYGON is not set
> # CONFIG_CPU_SUP_CENTAUR is not set
> # CONFIG_CPU_SUP_ZHAOXIN is not set
> CONFIG_HPET_TIMER=y
> CONFIG_HPET_EMULATE_RTC=y
> CONFIG_DMI=y
> # CONFIG_GART_IOMMU is not set
> # CONFIG_MAXSMP is not set
> CONFIG_NR_CPUS_RANGE_BEGIN=2
> CONFIG_NR_CPUS_RANGE_END=512
> CONFIG_NR_CPUS_DEFAULT=64
> CONFIG_NR_CPUS=16
> CONFIG_SCHED_CLUSTER=y
> CONFIG_SCHED_SMT=y
> CONFIG_SCHED_MC=y
> # CONFIG_SCHED_MC_PRIO is not set
> CONFIG_X86_LOCAL_APIC=y
> CONFIG_X86_IO_APIC=y
> # CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
> CONFIG_X86_MCE=y
> # CONFIG_X86_MCELOG_LEGACY is not set
> # CONFIG_X86_MCE_INTEL is not set
> # CONFIG_X86_MCE_AMD is not set
> # CONFIG_X86_MCE_INJECT is not set
> 
> #
> # Performance monitoring
> #
> CONFIG_PERF_EVENTS_INTEL_UNCORE=y
> # CONFIG_PERF_EVENTS_INTEL_RAPL is not set
> # CONFIG_PERF_EVENTS_INTEL_CSTATE is not set
> # CONFIG_PERF_EVENTS_AMD_POWER is not set
> # CONFIG_PERF_EVENTS_AMD_UNCORE is not set
> # CONFIG_PERF_EVENTS_AMD_BRS is not set
> # end of Performance monitoring
> 
> CONFIG_X86_VSYSCALL_EMULATION=y
> CONFIG_X86_IOPL_IOPERM=y
> # CONFIG_MICROCODE is not set
> CONFIG_X86_MSR=y
> CONFIG_X86_CPUID=m
> # CONFIG_X86_5LEVEL is not set
> CONFIG_X86_DIRECT_GBPAGES=y
> # CONFIG_X86_CPA_STATISTICS is not set
> # CONFIG_AMD_MEM_ENCRYPT is not set
> CONFIG_NUMA=y
> # CONFIG_AMD_NUMA is not set
> CONFIG_X86_64_ACPI_NUMA=y
> CONFIG_NUMA_EMU=y
> CONFIG_NODES_SHIFT=6
> CONFIG_ARCH_SPARSEMEM_ENABLE=y
> CONFIG_ARCH_SPARSEMEM_DEFAULT=y
> # CONFIG_ARCH_MEMORY_PROBE is not set
> CONFIG_ARCH_PROC_KCORE_TEXT=y
> CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
> CONFIG_X86_PMEM_LEGACY_DEVICE=y
> CONFIG_X86_PMEM_LEGACY=y
> # CONFIG_X86_CHECK_BIOS_CORRUPTION is not set
> CONFIG_MTRR=y
> CONFIG_MTRR_SANITIZER=y
> CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=0
> CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
> CONFIG_X86_PAT=y
> CONFIG_ARCH_USES_PG_UNCACHED=y
> # CONFIG_X86_UMIP is not set
> CONFIG_CC_HAS_IBT=y
> # CONFIG_X86_KERNEL_IBT is not set
> # CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS is not set
> CONFIG_X86_INTEL_TSX_MODE_OFF=y
> # CONFIG_X86_INTEL_TSX_MODE_ON is not set
> # CONFIG_X86_INTEL_TSX_MODE_AUTO is not set
> # CONFIG_X86_SGX is not set
> # CONFIG_EFI is not set
> # CONFIG_HZ_100 is not set
> CONFIG_HZ_250=y
> # CONFIG_HZ_300 is not set
> # CONFIG_HZ_1000 is not set
> CONFIG_HZ=250
> CONFIG_SCHED_HRTICK=y
> CONFIG_KEXEC=y
> CONFIG_KEXEC_FILE=y
> CONFIG_ARCH_HAS_KEXEC_PURGATORY=y
> # CONFIG_KEXEC_SIG is not set
> CONFIG_CRASH_DUMP=y
> CONFIG_PHYSICAL_START=0x1000000
> CONFIG_RELOCATABLE=y
> # CONFIG_RANDOMIZE_BASE is not set
> CONFIG_PHYSICAL_ALIGN=0x1000000
> CONFIG_HOTPLUG_CPU=y
> # CONFIG_BOOTPARAM_HOTPLUG_CPU0 is not set
> # CONFIG_DEBUG_HOTPLUG_CPU0 is not set
> # CONFIG_COMPAT_VDSO is not set
> # CONFIG_LEGACY_VSYSCALL_XONLY is not set
> CONFIG_LEGACY_VSYSCALL_NONE=y
> CONFIG_CMDLINE_BOOL=y
> CONFIG_CMDLINE="systemd.unified_cgroup_hierarchy=1"
> # CONFIG_CMDLINE_OVERRIDE is not set
> # CONFIG_MODIFY_LDT_SYSCALL is not set
> # CONFIG_STRICT_SIGALTSTACK_SIZE is not set
> CONFIG_HAVE_LIVEPATCH=y
> # CONFIG_LIVEPATCH is not set
> # end of Processor type and features
> 
> CONFIG_CC_HAS_SLS=y
> CONFIG_CC_HAS_RETURN_THUNK=y
> # CONFIG_SPECULATION_MITIGATIONS is not set
> CONFIG_ARCH_HAS_ADD_PAGES=y
> CONFIG_ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE=y
> 
> #
> # Power management and ACPI options
> #
> CONFIG_SUSPEND=y
> CONFIG_SUSPEND_FREEZER=y
> # CONFIG_SUSPEND_SKIP_SYNC is not set
> # CONFIG_HIBERNATION is not set
> CONFIG_PM_SLEEP=y
> CONFIG_PM_SLEEP_SMP=y
> CONFIG_PM_AUTOSLEEP=y
> # CONFIG_PM_USERSPACE_AUTOSLEEP is not set
> CONFIG_PM_WAKELOCKS=y
> CONFIG_PM_WAKELOCKS_LIMIT=100
> CONFIG_PM_WAKELOCKS_GC=y
> CONFIG_PM=y
> # CONFIG_PM_DEBUG is not set
> CONFIG_PM_CLK=y
> # CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
> CONFIG_ARCH_SUPPORTS_ACPI=y
> CONFIG_ACPI=y
> CONFIG_ACPI_LEGACY_TABLES_LOOKUP=y
> CONFIG_ARCH_MIGHT_HAVE_ACPI_PDC=y
> CONFIG_ACPI_SYSTEM_POWER_STATES_SUPPORT=y
> # CONFIG_ACPI_DEBUGGER is not set
> # CONFIG_ACPI_SPCR_TABLE is not set
> # CONFIG_ACPI_FPDT is not set
> CONFIG_ACPI_LPIT=y
> CONFIG_ACPI_SLEEP=y
> CONFIG_ACPI_REV_OVERRIDE_POSSIBLE=y
> # CONFIG_ACPI_EC_DEBUGFS is not set
> # CONFIG_ACPI_AC is not set
> # CONFIG_ACPI_BATTERY is not set
> CONFIG_ACPI_BUTTON=y
> # CONFIG_ACPI_FAN is not set
> # CONFIG_ACPI_TAD is not set
> # CONFIG_ACPI_DOCK is not set
> CONFIG_ACPI_CPU_FREQ_PSS=y
> CONFIG_ACPI_PROCESSOR_CSTATE=y
> CONFIG_ACPI_PROCESSOR_IDLE=y
> CONFIG_ACPI_PROCESSOR=y
> CONFIG_ACPI_HOTPLUG_CPU=y
> # CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
> # CONFIG_ACPI_THERMAL is not set
> CONFIG_ACPI_CUSTOM_DSDT_FILE=""
> CONFIG_ARCH_HAS_ACPI_TABLE_UPGRADE=y
> CONFIG_ACPI_TABLE_UPGRADE=y
> # CONFIG_ACPI_DEBUG is not set
> CONFIG_ACPI_PCI_SLOT=y
> CONFIG_ACPI_CONTAINER=y
> CONFIG_ACPI_HOTPLUG_MEMORY=y
> CONFIG_ACPI_HOTPLUG_IOAPIC=y
> # CONFIG_ACPI_SBS is not set
> # CONFIG_ACPI_HED is not set
> # CONFIG_ACPI_CUSTOM_METHOD is not set
> # CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
> CONFIG_ACPI_NFIT=y
> # CONFIG_NFIT_SECURITY_DEBUG is not set
> CONFIG_ACPI_NUMA=y
> CONFIG_ACPI_HMAT=y
> CONFIG_HAVE_ACPI_APEI=y
> CONFIG_HAVE_ACPI_APEI_NMI=y
> # CONFIG_ACPI_APEI is not set
> # CONFIG_ACPI_DPTF is not set
> # CONFIG_ACPI_CONFIGFS is not set
> # CONFIG_ACPI_PFRUT is not set
> # CONFIG_PMIC_OPREGION is not set
> CONFIG_X86_PM_TIMER=y
> 
> #
> # CPU Frequency scaling
> #
> # CONFIG_CPU_FREQ is not set
> # end of CPU Frequency scaling
> 
> #
> # CPU Idle
> #
> CONFIG_CPU_IDLE=y
> CONFIG_CPU_IDLE_GOV_LADDER=y
> CONFIG_CPU_IDLE_GOV_MENU=y
> # CONFIG_CPU_IDLE_GOV_TEO is not set
> CONFIG_CPU_IDLE_GOV_HALTPOLL=y
> CONFIG_HALTPOLL_CPUIDLE=y
> # end of CPU Idle
> 
> # CONFIG_INTEL_IDLE is not set
> # end of Power management and ACPI options
> 
> #
> # Bus options (PCI etc.)
> #
> CONFIG_PCI_DIRECT=y
> CONFIG_PCI_MMCONFIG=y
> CONFIG_MMCONF_FAM10H=y
> # CONFIG_PCI_CNB20LE_QUIRK is not set
> # CONFIG_ISA_BUS is not set
> # CONFIG_ISA_DMA_API is not set
> CONFIG_AMD_NB=y
> # end of Bus options (PCI etc.)
> 
> #
> # Binary Emulations
> #
> CONFIG_IA32_EMULATION=y
> CONFIG_X86_X32_ABI=y
> CONFIG_COMPAT_32=y
> CONFIG_COMPAT=y
> CONFIG_COMPAT_FOR_U64_ALIGNMENT=y
> # end of Binary Emulations
> 
> CONFIG_HAVE_KVM=y
> # CONFIG_VIRTUALIZATION is not set
> CONFIG_AS_AVX512=y
> CONFIG_AS_SHA1_NI=y
> CONFIG_AS_SHA256_NI=y
> CONFIG_AS_TPAUSE=y
> 
> #
> # General architecture-dependent options
> #
> CONFIG_CRASH_CORE=y
> CONFIG_KEXEC_CORE=y
> CONFIG_HOTPLUG_SMT=y
> CONFIG_GENERIC_ENTRY=y
> CONFIG_KPROBES=y
> CONFIG_JUMP_LABEL=y
> # CONFIG_STATIC_KEYS_SELFTEST is not set
> # CONFIG_STATIC_CALL_SELFTEST is not set
> CONFIG_OPTPROBES=y
> CONFIG_KPROBES_ON_FTRACE=y
> CONFIG_UPROBES=y
> CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
> CONFIG_ARCH_USE_BUILTIN_BSWAP=y
> CONFIG_KRETPROBES=y
> CONFIG_KRETPROBE_ON_RETHOOK=y
> CONFIG_HAVE_IOREMAP_PROT=y
> CONFIG_HAVE_KPROBES=y
> CONFIG_HAVE_KRETPROBES=y
> CONFIG_HAVE_OPTPROBES=y
> CONFIG_HAVE_KPROBES_ON_FTRACE=y
> CONFIG_ARCH_CORRECT_STACKTRACE_ON_KRETPROBE=y
> CONFIG_HAVE_FUNCTION_ERROR_INJECTION=y
> CONFIG_HAVE_NMI=y
> CONFIG_TRACE_IRQFLAGS_SUPPORT=y
> CONFIG_TRACE_IRQFLAGS_NMI_SUPPORT=y
> CONFIG_HAVE_ARCH_TRACEHOOK=y
> CONFIG_HAVE_DMA_CONTIGUOUS=y
> CONFIG_GENERIC_SMP_IDLE_THREAD=y
> CONFIG_ARCH_HAS_FORTIFY_SOURCE=y
> CONFIG_ARCH_HAS_SET_MEMORY=y
> CONFIG_ARCH_HAS_SET_DIRECT_MAP=y
> CONFIG_HAVE_ARCH_THREAD_STRUCT_WHITELIST=y
> CONFIG_ARCH_WANTS_DYNAMIC_TASK_STRUCT=y
> CONFIG_ARCH_WANTS_NO_INSTR=y
> CONFIG_HAVE_ASM_MODVERSIONS=y
> CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
> CONFIG_HAVE_RSEQ=y
> CONFIG_HAVE_FUNCTION_ARG_ACCESS_API=y
> CONFIG_HAVE_HW_BREAKPOINT=y
> CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
> CONFIG_HAVE_USER_RETURN_NOTIFIER=y
> CONFIG_HAVE_PERF_EVENTS_NMI=y
> CONFIG_HAVE_HARDLOCKUP_DETECTOR_PERF=y
> CONFIG_HAVE_PERF_REGS=y
> CONFIG_HAVE_PERF_USER_STACK_DUMP=y
> CONFIG_HAVE_ARCH_JUMP_LABEL=y
> CONFIG_HAVE_ARCH_JUMP_LABEL_RELATIVE=y
> CONFIG_MMU_GATHER_TABLE_FREE=y
> CONFIG_MMU_GATHER_RCU_TABLE_FREE=y
> CONFIG_MMU_GATHER_MERGE_VMAS=y
> CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
> CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
> CONFIG_HAVE_CMPXCHG_LOCAL=y
> CONFIG_HAVE_CMPXCHG_DOUBLE=y
> CONFIG_ARCH_WANT_COMPAT_IPC_PARSE_VERSION=y
> CONFIG_ARCH_WANT_OLD_COMPAT_IPC=y
> CONFIG_HAVE_ARCH_SECCOMP=y
> CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
> CONFIG_SECCOMP=y
> CONFIG_SECCOMP_FILTER=y
> # CONFIG_SECCOMP_CACHE_DEBUG is not set
> CONFIG_HAVE_ARCH_STACKLEAK=y
> CONFIG_HAVE_STACKPROTECTOR=y
> CONFIG_STACKPROTECTOR=y
> CONFIG_STACKPROTECTOR_STRONG=y
> CONFIG_ARCH_SUPPORTS_LTO_CLANG=y
> CONFIG_ARCH_SUPPORTS_LTO_CLANG_THIN=y
> CONFIG_LTO_NONE=y
> CONFIG_HAVE_ARCH_WITHIN_STACK_FRAMES=y
> CONFIG_HAVE_CONTEXT_TRACKING_USER=y
> CONFIG_HAVE_CONTEXT_TRACKING_USER_OFFSTACK=y
> CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN=y
> CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
> CONFIG_HAVE_MOVE_PUD=y
> CONFIG_HAVE_MOVE_PMD=y
> CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
> CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD=y
> CONFIG_HAVE_ARCH_HUGE_VMAP=y
> CONFIG_HAVE_ARCH_HUGE_VMALLOC=y
> CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
> CONFIG_HAVE_ARCH_SOFT_DIRTY=y
> CONFIG_HAVE_MOD_ARCH_SPECIFIC=y
> CONFIG_MODULES_USE_ELF_RELA=y
> CONFIG_HAVE_IRQ_EXIT_ON_IRQ_STACK=y
> CONFIG_HAVE_SOFTIRQ_ON_OWN_STACK=y
> CONFIG_SOFTIRQ_ON_OWN_STACK=y
> CONFIG_ARCH_HAS_ELF_RANDOMIZE=y
> CONFIG_HAVE_ARCH_MMAP_RND_BITS=y
> CONFIG_HAVE_EXIT_THREAD=y
> CONFIG_ARCH_MMAP_RND_BITS=28
> CONFIG_HAVE_ARCH_MMAP_RND_COMPAT_BITS=y
> CONFIG_ARCH_MMAP_RND_COMPAT_BITS=8
> CONFIG_HAVE_ARCH_COMPAT_MMAP_BASES=y
> CONFIG_PAGE_SIZE_LESS_THAN_64KB=y
> CONFIG_PAGE_SIZE_LESS_THAN_256KB=y
> CONFIG_HAVE_OBJTOOL=y
> CONFIG_HAVE_JUMP_LABEL_HACK=y
> CONFIG_HAVE_NOINSTR_HACK=y
> CONFIG_HAVE_NOINSTR_VALIDATION=y
> CONFIG_HAVE_UACCESS_VALIDATION=y
> CONFIG_HAVE_STACK_VALIDATION=y
> CONFIG_HAVE_RELIABLE_STACKTRACE=y
> CONFIG_OLD_SIGSUSPEND3=y
> CONFIG_COMPAT_OLD_SIGACTION=y
> CONFIG_COMPAT_32BIT_TIME=y
> CONFIG_HAVE_ARCH_VMAP_STACK=y
> CONFIG_VMAP_STACK=y
> CONFIG_HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET=y
> # CONFIG_RANDOMIZE_KSTACK_OFFSET is not set
> CONFIG_ARCH_HAS_STRICT_KERNEL_RWX=y
> CONFIG_STRICT_KERNEL_RWX=y
> CONFIG_ARCH_HAS_STRICT_MODULE_RWX=y
> CONFIG_STRICT_MODULE_RWX=y
> CONFIG_HAVE_ARCH_PREL32_RELOCATIONS=y
> # CONFIG_LOCK_EVENT_COUNTS is not set
> CONFIG_ARCH_HAS_MEM_ENCRYPT=y
> CONFIG_HAVE_STATIC_CALL=y
> CONFIG_HAVE_STATIC_CALL_INLINE=y
> CONFIG_HAVE_PREEMPT_DYNAMIC=y
> CONFIG_HAVE_PREEMPT_DYNAMIC_CALL=y
> CONFIG_ARCH_WANT_LD_ORPHAN_WARN=y
> CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
> CONFIG_ARCH_SUPPORTS_PAGE_TABLE_CHECK=y
> CONFIG_ARCH_HAS_ELFCORE_COMPAT=y
> CONFIG_ARCH_HAS_PARANOID_L1D_FLUSH=y
> CONFIG_DYNAMIC_SIGFRAME=y
> 
> #
> # GCOV-based kernel profiling
> #
> # CONFIG_GCOV_KERNEL is not set
> CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
> # end of GCOV-based kernel profiling
> 
> CONFIG_HAVE_GCC_PLUGINS=y
> CONFIG_GCC_PLUGINS=y
> # CONFIG_GCC_PLUGIN_LATENT_ENTROPY is not set
> # end of General architecture-dependent options
> 
> CONFIG_RT_MUTEXES=y
> CONFIG_BASE_SMALL=0
> CONFIG_MODULES=y
> # CONFIG_MODULE_FORCE_LOAD is not set
> CONFIG_MODULE_UNLOAD=y
> # CONFIG_MODULE_FORCE_UNLOAD is not set
> # CONFIG_MODULE_UNLOAD_TAINT_TRACKING is not set
> # CONFIG_MODVERSIONS is not set
> CONFIG_MODULE_SRCVERSION_ALL=y
> # CONFIG_MODULE_SIG is not set
> CONFIG_MODULE_COMPRESS_NONE=y
> # CONFIG_MODULE_COMPRESS_GZIP is not set
> # CONFIG_MODULE_COMPRESS_XZ is not set
> # CONFIG_MODULE_COMPRESS_ZSTD is not set
> # CONFIG_MODULE_ALLOW_MISSING_NAMESPACE_IMPORTS is not set
> CONFIG_MODPROBE_PATH="/sbin/modprobe"
> # CONFIG_TRIM_UNUSED_KSYMS is not set
> CONFIG_MODULES_TREE_LOOKUP=y
> CONFIG_BLOCK=y
> CONFIG_BLOCK_LEGACY_AUTOLOAD=y
> CONFIG_BLK_RQ_ALLOC_TIME=y
> CONFIG_BLK_DEV_BSG_COMMON=y
> CONFIG_BLK_ICQ=y
> # CONFIG_BLK_DEV_BSGLIB is not set
> CONFIG_BLK_DEV_INTEGRITY=y
> CONFIG_BLK_DEV_INTEGRITY_T10=y
> # CONFIG_BLK_DEV_ZONED is not set
> # CONFIG_BLK_DEV_THROTTLING is not set
> # CONFIG_BLK_WBT is not set
> CONFIG_BLK_CGROUP_IOLATENCY=y
> CONFIG_BLK_CGROUP_IOCOST=y
> CONFIG_BLK_CGROUP_IOPRIO=y
> CONFIG_BLK_DEBUG_FS=y
> # CONFIG_BLK_SED_OPAL is not set
> # CONFIG_BLK_INLINE_ENCRYPTION is not set
> 
> #
> # Partition Types
> #
> CONFIG_PARTITION_ADVANCED=y
> # CONFIG_ACORN_PARTITION is not set
> # CONFIG_AIX_PARTITION is not set
> # CONFIG_OSF_PARTITION is not set
> # CONFIG_AMIGA_PARTITION is not set
> # CONFIG_ATARI_PARTITION is not set
> # CONFIG_MAC_PARTITION is not set
> CONFIG_MSDOS_PARTITION=y
> # CONFIG_BSD_DISKLABEL is not set
> # CONFIG_MINIX_SUBPARTITION is not set
> # CONFIG_SOLARIS_X86_PARTITION is not set
> # CONFIG_UNIXWARE_DISKLABEL is not set
> # CONFIG_LDM_PARTITION is not set
> # CONFIG_SGI_PARTITION is not set
> # CONFIG_ULTRIX_PARTITION is not set
> # CONFIG_SUN_PARTITION is not set
> # CONFIG_KARMA_PARTITION is not set
> CONFIG_EFI_PARTITION=y
> # CONFIG_SYSV68_PARTITION is not set
> # CONFIG_CMDLINE_PARTITION is not set
> # end of Partition Types
> 
> CONFIG_BLOCK_COMPAT=y
> CONFIG_BLK_MQ_PCI=y
> CONFIG_BLK_MQ_VIRTIO=y
> CONFIG_BLK_PM=y
> CONFIG_BLOCK_HOLDER_DEPRECATED=y
> CONFIG_BLK_MQ_STACKING=y
> 
> #
> # IO Schedulers
> #
> CONFIG_MQ_IOSCHED_DEADLINE=y
> CONFIG_MQ_IOSCHED_KYBER=m
> CONFIG_IOSCHED_BFQ=m
> # CONFIG_BFQ_GROUP_IOSCHED is not set
> # end of IO Schedulers
> 
> CONFIG_ASN1=m
> CONFIG_UNINLINE_SPIN_UNLOCK=y
> CONFIG_ARCH_SUPPORTS_ATOMIC_RMW=y
> CONFIG_MUTEX_SPIN_ON_OWNER=y
> CONFIG_RWSEM_SPIN_ON_OWNER=y
> CONFIG_LOCK_SPIN_ON_OWNER=y
> CONFIG_ARCH_USE_QUEUED_SPINLOCKS=y
> CONFIG_QUEUED_SPINLOCKS=y
> CONFIG_ARCH_USE_QUEUED_RWLOCKS=y
> CONFIG_QUEUED_RWLOCKS=y
> CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE=y
> CONFIG_ARCH_HAS_SYNC_CORE_BEFORE_USERMODE=y
> CONFIG_ARCH_HAS_SYSCALL_WRAPPER=y
> CONFIG_FREEZER=y
> 
> #
> # Executable file formats
> #
> CONFIG_BINFMT_ELF=y
> CONFIG_COMPAT_BINFMT_ELF=y
> CONFIG_ELFCORE=y
> # CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
> CONFIG_BINFMT_SCRIPT=y
> CONFIG_BINFMT_MISC=m
> CONFIG_COREDUMP=y
> # end of Executable file formats
> 
> #
> # Memory Management options
> #
> CONFIG_SWAP=y
> # CONFIG_ZSWAP is not set
> 
> #
> # SLAB allocator options
> #
> # CONFIG_SLAB is not set
> CONFIG_SLUB=y
> # CONFIG_SLOB is not set
> CONFIG_SLAB_MERGE_DEFAULT=y
> CONFIG_SLAB_FREELIST_RANDOM=y
> CONFIG_SLAB_FREELIST_HARDENED=y
> # CONFIG_SLUB_STATS is not set
> CONFIG_SLUB_CPU_PARTIAL=y
> # end of SLAB allocator options
> 
> CONFIG_SHUFFLE_PAGE_ALLOCATOR=y
> # CONFIG_COMPAT_BRK is not set
> CONFIG_SPARSEMEM=y
> CONFIG_SPARSEMEM_EXTREME=y
> CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
> CONFIG_SPARSEMEM_VMEMMAP=y
> CONFIG_HAVE_FAST_GUP=y
> CONFIG_NUMA_KEEP_MEMINFO=y
> CONFIG_MEMORY_ISOLATION=y
> CONFIG_EXCLUSIVE_SYSTEM_RAM=y
> CONFIG_HAVE_BOOTMEM_INFO_NODE=y
> CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
> CONFIG_ARCH_ENABLE_MEMORY_HOTREMOVE=y
> CONFIG_MEMORY_HOTPLUG=y
> CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE=y
> CONFIG_MEMORY_HOTREMOVE=y
> CONFIG_MHP_MEMMAP_ON_MEMORY=y
> CONFIG_SPLIT_PTLOCK_CPUS=4
> CONFIG_ARCH_ENABLE_SPLIT_PMD_PTLOCK=y
> CONFIG_MEMORY_BALLOON=y
> CONFIG_BALLOON_COMPACTION=y
> CONFIG_COMPACTION=y
> CONFIG_PAGE_REPORTING=y
> CONFIG_MIGRATION=y
> CONFIG_DEVICE_MIGRATION=y
> CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION=y
> CONFIG_ARCH_ENABLE_THP_MIGRATION=y
> CONFIG_CONTIG_ALLOC=y
> CONFIG_PHYS_ADDR_T_64BIT=y
> CONFIG_KSM=y
> CONFIG_DEFAULT_MMAP_MIN_ADDR=65536
> CONFIG_ARCH_SUPPORTS_MEMORY_FAILURE=y
> CONFIG_MEMORY_FAILURE=y
> CONFIG_HWPOISON_INJECT=m
> CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
> CONFIG_ARCH_WANTS_THP_SWAP=y
> CONFIG_TRANSPARENT_HUGEPAGE=y
> CONFIG_TRANSPARENT_HUGEPAGE_ALWAYS=y
> # CONFIG_TRANSPARENT_HUGEPAGE_MADVISE is not set
> CONFIG_THP_SWAP=y
> # CONFIG_READ_ONLY_THP_FOR_FS is not set
> CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
> CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
> CONFIG_USE_PERCPU_NUMA_NODE_ID=y
> CONFIG_HAVE_SETUP_PER_CPU_AREA=y
> # CONFIG_CMA is not set
> CONFIG_GENERIC_EARLY_IOREMAP=y
> # CONFIG_DEFERRED_STRUCT_PAGE_INIT is not set
> # CONFIG_IDLE_PAGE_TRACKING is not set
> CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
> CONFIG_ARCH_HAS_CURRENT_STACK_POINTER=y
> CONFIG_ARCH_HAS_PTE_DEVMAP=y
> CONFIG_ARCH_HAS_ZONE_DMA_SET=y
> CONFIG_ZONE_DMA=y
> CONFIG_ZONE_DMA32=y
> CONFIG_ZONE_DEVICE=y
> # CONFIG_DEVICE_PRIVATE is not set
> CONFIG_VM_EVENT_COUNTERS=y
> # CONFIG_PERCPU_STATS is not set
> # CONFIG_GUP_TEST is not set
> CONFIG_ARCH_HAS_PTE_SPECIAL=y
> CONFIG_SECRETMEM=y
> # CONFIG_ANON_VMA_NAME is not set
> CONFIG_USERFAULTFD=y
> CONFIG_HAVE_ARCH_USERFAULTFD_WP=y
> CONFIG_HAVE_ARCH_USERFAULTFD_MINOR=y
> CONFIG_PTE_MARKER=y
> CONFIG_PTE_MARKER_UFFD_WP=y
> 
> #
> # Data Access Monitoring
> #
> # CONFIG_DAMON is not set
> # end of Data Access Monitoring
> # end of Memory Management options
> 
> CONFIG_NET=y
> CONFIG_SKB_EXTENSIONS=y
> 
> #
> # Networking options
> #
> CONFIG_PACKET=m
> CONFIG_PACKET_DIAG=m
> CONFIG_UNIX=y
> CONFIG_UNIX_SCM=y
> CONFIG_AF_UNIX_OOB=y
> CONFIG_UNIX_DIAG=y
> # CONFIG_TLS is not set
> CONFIG_XFRM=y
> CONFIG_XFRM_ALGO=m
> CONFIG_XFRM_USER=m
> # CONFIG_XFRM_USER_COMPAT is not set
> # CONFIG_XFRM_INTERFACE is not set
> # CONFIG_XFRM_SUB_POLICY is not set
> # CONFIG_XFRM_MIGRATE is not set
> # CONFIG_XFRM_STATISTICS is not set
> CONFIG_NET_KEY=m
> # CONFIG_NET_KEY_MIGRATE is not set
> # CONFIG_XDP_SOCKETS is not set
> CONFIG_INET=y
> CONFIG_IP_MULTICAST=y
> # CONFIG_IP_ADVANCED_ROUTER is not set
> # CONFIG_IP_PNP is not set
> # CONFIG_NET_IPIP is not set
> # CONFIG_NET_IPGRE_DEMUX is not set
> # CONFIG_IP_MROUTE is not set
> CONFIG_SYN_COOKIES=y
> # CONFIG_NET_IPVTI is not set
> # CONFIG_NET_FOU is not set
> # CONFIG_INET_AH is not set
> # CONFIG_INET_ESP is not set
> # CONFIG_INET_IPCOMP is not set
> # CONFIG_INET_DIAG is not set
> # CONFIG_TCP_CONG_ADVANCED is not set
> CONFIG_TCP_CONG_CUBIC=y
> CONFIG_DEFAULT_TCP_CONG="cubic"
> CONFIG_TCP_MD5SIG=y
> CONFIG_IPV6=y
> CONFIG_IPV6_ROUTER_PREF=y
> # CONFIG_IPV6_ROUTE_INFO is not set
> # CONFIG_IPV6_OPTIMISTIC_DAD is not set
> # CONFIG_INET6_AH is not set
> # CONFIG_INET6_ESP is not set
> # CONFIG_INET6_IPCOMP is not set
> # CONFIG_IPV6_MIP6 is not set
> # CONFIG_IPV6_ILA is not set
> # CONFIG_IPV6_VTI is not set
> # CONFIG_IPV6_SIT is not set
> # CONFIG_IPV6_TUNNEL is not set
> # CONFIG_IPV6_MULTIPLE_TABLES is not set
> # CONFIG_IPV6_MROUTE is not set
> # CONFIG_IPV6_SEG6_LWTUNNEL is not set
> # CONFIG_IPV6_SEG6_HMAC is not set
> # CONFIG_IPV6_RPL_LWTUNNEL is not set
> # CONFIG_IPV6_IOAM6_LWTUNNEL is not set
> # CONFIG_MPTCP is not set
> CONFIG_NETWORK_SECMARK=y
> # CONFIG_NETWORK_PHY_TIMESTAMPING is not set
> CONFIG_NETFILTER=y
> CONFIG_NETFILTER_ADVANCED=y
> # CONFIG_BRIDGE_NETFILTER is not set
> 
> #
> # Core Netfilter Configuration
> #
> # CONFIG_NETFILTER_INGRESS is not set
> # CONFIG_NETFILTER_EGRESS is not set
> CONFIG_NETFILTER_NETLINK=m
> CONFIG_NETFILTER_FAMILY_BRIDGE=y
> # CONFIG_NETFILTER_NETLINK_HOOK is not set
> # CONFIG_NETFILTER_NETLINK_ACCT is not set
> # CONFIG_NETFILTER_NETLINK_QUEUE is not set
> # CONFIG_NETFILTER_NETLINK_LOG is not set
> CONFIG_NETFILTER_NETLINK_OSF=m
> CONFIG_NF_CONNTRACK=m
> # CONFIG_NF_LOG_SYSLOG is not set
> CONFIG_NETFILTER_CONNCOUNT=m
> # CONFIG_NF_CONNTRACK_MARK is not set
> # CONFIG_NF_CONNTRACK_SECMARK is not set
> # CONFIG_NF_CONNTRACK_ZONES is not set
> # CONFIG_NF_CONNTRACK_PROCFS is not set
> # CONFIG_NF_CONNTRACK_EVENTS is not set
> # CONFIG_NF_CONNTRACK_TIMEOUT is not set
> # CONFIG_NF_CONNTRACK_TIMESTAMP is not set
> # CONFIG_NF_CONNTRACK_LABELS is not set
> # CONFIG_NF_CT_PROTO_DCCP is not set
> # CONFIG_NF_CT_PROTO_SCTP is not set
> # CONFIG_NF_CT_PROTO_UDPLITE is not set
> # CONFIG_NF_CONNTRACK_AMANDA is not set
> # CONFIG_NF_CONNTRACK_FTP is not set
> # CONFIG_NF_CONNTRACK_H323 is not set
> # CONFIG_NF_CONNTRACK_IRC is not set
> # CONFIG_NF_CONNTRACK_NETBIOS_NS is not set
> # CONFIG_NF_CONNTRACK_SNMP is not set
> # CONFIG_NF_CONNTRACK_PPTP is not set
> # CONFIG_NF_CONNTRACK_SANE is not set
> # CONFIG_NF_CONNTRACK_SIP is not set
> # CONFIG_NF_CONNTRACK_TFTP is not set
> # CONFIG_NF_CT_NETLINK is not set
> CONFIG_NF_NAT=m
> CONFIG_NF_NAT_REDIRECT=y
> CONFIG_NF_NAT_MASQUERADE=y
> CONFIG_NETFILTER_SYNPROXY=m
> CONFIG_NF_TABLES=m
> CONFIG_NF_TABLES_INET=y
> CONFIG_NF_TABLES_NETDEV=y
> CONFIG_NFT_NUMGEN=m
> CONFIG_NFT_CT=m
> CONFIG_NFT_CONNLIMIT=m
> CONFIG_NFT_LOG=m
> CONFIG_NFT_LIMIT=m
> CONFIG_NFT_MASQ=m
> CONFIG_NFT_REDIR=m
> CONFIG_NFT_NAT=m
> CONFIG_NFT_TUNNEL=m
> CONFIG_NFT_OBJREF=m
> CONFIG_NFT_QUOTA=m
> CONFIG_NFT_REJECT=m
> CONFIG_NFT_REJECT_INET=m
> CONFIG_NFT_COMPAT=m
> CONFIG_NFT_HASH=m
> CONFIG_NFT_FIB=m
> # CONFIG_NFT_FIB_INET is not set
> CONFIG_NFT_XFRM=m
> CONFIG_NFT_SOCKET=m
> CONFIG_NFT_OSF=m
> CONFIG_NFT_TPROXY=m
> CONFIG_NFT_SYNPROXY=m
> CONFIG_NF_DUP_NETDEV=m
> CONFIG_NFT_DUP_NETDEV=m
> CONFIG_NFT_FWD_NETDEV=m
> # CONFIG_NFT_FIB_NETDEV is not set
> CONFIG_NFT_REJECT_NETDEV=m
> CONFIG_NETFILTER_XTABLES=m
> # CONFIG_NETFILTER_XTABLES_COMPAT is not set
> 
> #
> # Xtables combined modules
> #
> # CONFIG_NETFILTER_XT_MARK is not set
> # CONFIG_NETFILTER_XT_CONNMARK is not set
> CONFIG_NETFILTER_XT_SET=m
> 
> #
> # Xtables targets
> #
> # CONFIG_NETFILTER_XT_TARGET_CLASSIFY is not set
> # CONFIG_NETFILTER_XT_TARGET_CONNMARK is not set
> # CONFIG_NETFILTER_XT_TARGET_HMARK is not set
> # CONFIG_NETFILTER_XT_TARGET_IDLETIMER is not set
> # CONFIG_NETFILTER_XT_TARGET_LOG is not set
> # CONFIG_NETFILTER_XT_TARGET_MARK is not set
> CONFIG_NETFILTER_XT_NAT=m
> # CONFIG_NETFILTER_XT_TARGET_NETMAP is not set
> # CONFIG_NETFILTER_XT_TARGET_NFLOG is not set
> # CONFIG_NETFILTER_XT_TARGET_NFQUEUE is not set
> # CONFIG_NETFILTER_XT_TARGET_RATEEST is not set
> CONFIG_NETFILTER_XT_TARGET_REDIRECT=m
> # CONFIG_NETFILTER_XT_TARGET_MASQUERADE is not set
> # CONFIG_NETFILTER_XT_TARGET_TEE is not set
> # CONFIG_NETFILTER_XT_TARGET_SECMARK is not set
> # CONFIG_NETFILTER_XT_TARGET_TCPMSS is not set
> 
> #
> # Xtables matches
> #
> # CONFIG_NETFILTER_XT_MATCH_ADDRTYPE is not set
> # CONFIG_NETFILTER_XT_MATCH_BPF is not set
> # CONFIG_NETFILTER_XT_MATCH_CGROUP is not set
> # CONFIG_NETFILTER_XT_MATCH_CLUSTER is not set
> # CONFIG_NETFILTER_XT_MATCH_COMMENT is not set
> # CONFIG_NETFILTER_XT_MATCH_CONNBYTES is not set
> # CONFIG_NETFILTER_XT_MATCH_CONNLABEL is not set
> # CONFIG_NETFILTER_XT_MATCH_CONNLIMIT is not set
> # CONFIG_NETFILTER_XT_MATCH_CONNMARK is not set
> # CONFIG_NETFILTER_XT_MATCH_CONNTRACK is not set
> # CONFIG_NETFILTER_XT_MATCH_CPU is not set
> # CONFIG_NETFILTER_XT_MATCH_DCCP is not set
> # CONFIG_NETFILTER_XT_MATCH_DEVGROUP is not set
> # CONFIG_NETFILTER_XT_MATCH_DSCP is not set
> # CONFIG_NETFILTER_XT_MATCH_ECN is not set
> # CONFIG_NETFILTER_XT_MATCH_ESP is not set
> # CONFIG_NETFILTER_XT_MATCH_HASHLIMIT is not set
> # CONFIG_NETFILTER_XT_MATCH_HELPER is not set
> # CONFIG_NETFILTER_XT_MATCH_HL is not set
> # CONFIG_NETFILTER_XT_MATCH_IPCOMP is not set
> # CONFIG_NETFILTER_XT_MATCH_IPRANGE is not set
> # CONFIG_NETFILTER_XT_MATCH_L2TP is not set
> # CONFIG_NETFILTER_XT_MATCH_LENGTH is not set
> # CONFIG_NETFILTER_XT_MATCH_LIMIT is not set
> # CONFIG_NETFILTER_XT_MATCH_MAC is not set
> # CONFIG_NETFILTER_XT_MATCH_MARK is not set
> # CONFIG_NETFILTER_XT_MATCH_MULTIPORT is not set
> # CONFIG_NETFILTER_XT_MATCH_NFACCT is not set
> # CONFIG_NETFILTER_XT_MATCH_OSF is not set
> # CONFIG_NETFILTER_XT_MATCH_OWNER is not set
> # CONFIG_NETFILTER_XT_MATCH_POLICY is not set
> # CONFIG_NETFILTER_XT_MATCH_PKTTYPE is not set
> # CONFIG_NETFILTER_XT_MATCH_QUOTA is not set
> # CONFIG_NETFILTER_XT_MATCH_RATEEST is not set
> # CONFIG_NETFILTER_XT_MATCH_REALM is not set
> # CONFIG_NETFILTER_XT_MATCH_RECENT is not set
> # CONFIG_NETFILTER_XT_MATCH_SCTP is not set
> # CONFIG_NETFILTER_XT_MATCH_SOCKET is not set
> # CONFIG_NETFILTER_XT_MATCH_STATE is not set
> # CONFIG_NETFILTER_XT_MATCH_STATISTIC is not set
> # CONFIG_NETFILTER_XT_MATCH_STRING is not set
> # CONFIG_NETFILTER_XT_MATCH_TCPMSS is not set
> # CONFIG_NETFILTER_XT_MATCH_TIME is not set
> # CONFIG_NETFILTER_XT_MATCH_U32 is not set
> # end of Core Netfilter Configuration
> 
> CONFIG_IP_SET=m
> CONFIG_IP_SET_MAX=256
> # CONFIG_IP_SET_BITMAP_IP is not set
> # CONFIG_IP_SET_BITMAP_IPMAC is not set
> # CONFIG_IP_SET_BITMAP_PORT is not set
> CONFIG_IP_SET_HASH_IP=m
> # CONFIG_IP_SET_HASH_IPMARK is not set
> # CONFIG_IP_SET_HASH_IPPORT is not set
> # CONFIG_IP_SET_HASH_IPPORTIP is not set
> # CONFIG_IP_SET_HASH_IPPORTNET is not set
> # CONFIG_IP_SET_HASH_IPMAC is not set
> CONFIG_IP_SET_HASH_MAC=m
> # CONFIG_IP_SET_HASH_NETPORTNET is not set
> CONFIG_IP_SET_HASH_NET=m
> # CONFIG_IP_SET_HASH_NETNET is not set
> # CONFIG_IP_SET_HASH_NETPORT is not set
> # CONFIG_IP_SET_HASH_NETIFACE is not set
> # CONFIG_IP_SET_LIST_SET is not set
> # CONFIG_IP_VS is not set
> 
> #
> # IP: Netfilter Configuration
> #
> CONFIG_NF_DEFRAG_IPV4=m
> CONFIG_NF_SOCKET_IPV4=m
> CONFIG_NF_TPROXY_IPV4=m
> CONFIG_NF_TABLES_IPV4=y
> CONFIG_NFT_REJECT_IPV4=m
> CONFIG_NFT_DUP_IPV4=m
> CONFIG_NFT_FIB_IPV4=m
> # CONFIG_NF_TABLES_ARP is not set
> CONFIG_NF_DUP_IPV4=m
> # CONFIG_NF_LOG_ARP is not set
> # CONFIG_NF_LOG_IPV4 is not set
> CONFIG_NF_REJECT_IPV4=m
> CONFIG_IP_NF_IPTABLES=m
> # CONFIG_IP_NF_MATCH_AH is not set
> # CONFIG_IP_NF_MATCH_ECN is not set
> # CONFIG_IP_NF_MATCH_TTL is not set
> CONFIG_IP_NF_FILTER=m
> CONFIG_IP_NF_TARGET_REJECT=m
> # CONFIG_IP_NF_TARGET_SYNPROXY is not set
> CONFIG_IP_NF_NAT=m
> # CONFIG_IP_NF_TARGET_MASQUERADE is not set
> # CONFIG_IP_NF_TARGET_NETMAP is not set
> CONFIG_IP_NF_TARGET_REDIRECT=m
> # CONFIG_IP_NF_MANGLE is not set
> # CONFIG_IP_NF_RAW is not set
> # CONFIG_IP_NF_ARPTABLES is not set
> # end of IP: Netfilter Configuration
> 
> #
> # IPv6: Netfilter Configuration
> #
> CONFIG_NF_SOCKET_IPV6=m
> CONFIG_NF_TPROXY_IPV6=m
> CONFIG_NF_TABLES_IPV6=y
> CONFIG_NFT_REJECT_IPV6=m
> CONFIG_NFT_DUP_IPV6=m
> CONFIG_NFT_FIB_IPV6=m
> CONFIG_NF_DUP_IPV6=m
> CONFIG_NF_REJECT_IPV6=m
> # CONFIG_NF_LOG_IPV6 is not set
> CONFIG_IP6_NF_IPTABLES=m
> # CONFIG_IP6_NF_MATCH_AH is not set
> # CONFIG_IP6_NF_MATCH_EUI64 is not set
> # CONFIG_IP6_NF_MATCH_FRAG is not set
> # CONFIG_IP6_NF_MATCH_OPTS is not set
> # CONFIG_IP6_NF_MATCH_HL is not set
> # CONFIG_IP6_NF_MATCH_IPV6HEADER is not set
> # CONFIG_IP6_NF_MATCH_MH is not set
> # CONFIG_IP6_NF_MATCH_RT is not set
> # CONFIG_IP6_NF_MATCH_SRH is not set
> CONFIG_IP6_NF_FILTER=m
> CONFIG_IP6_NF_TARGET_REJECT=m
> # CONFIG_IP6_NF_TARGET_SYNPROXY is not set
> # CONFIG_IP6_NF_MANGLE is not set
> # CONFIG_IP6_NF_RAW is not set
> # CONFIG_IP6_NF_NAT is not set
> # end of IPv6: Netfilter Configuration
> 
> CONFIG_NF_DEFRAG_IPV6=m
> CONFIG_NF_TABLES_BRIDGE=m
> # CONFIG_NFT_BRIDGE_META is not set
> # CONFIG_NFT_BRIDGE_REJECT is not set
> # CONFIG_NF_CONNTRACK_BRIDGE is not set
> # CONFIG_BRIDGE_NF_EBTABLES is not set
> # CONFIG_BPFILTER is not set
> # CONFIG_IP_DCCP is not set
> # CONFIG_IP_SCTP is not set
> # CONFIG_RDS is not set
> # CONFIG_TIPC is not set
> # CONFIG_ATM is not set
> # CONFIG_L2TP is not set
> CONFIG_STP=m
> CONFIG_BRIDGE=m
> CONFIG_BRIDGE_IGMP_SNOOPING=y
> # CONFIG_BRIDGE_MRP is not set
> # CONFIG_BRIDGE_CFM is not set
> # CONFIG_NET_DSA is not set
> # CONFIG_VLAN_8021Q is not set
> # CONFIG_DECNET is not set
> CONFIG_LLC=m
> # CONFIG_LLC2 is not set
> # CONFIG_ATALK is not set
> # CONFIG_X25 is not set
> # CONFIG_LAPB is not set
> # CONFIG_PHONET is not set
> # CONFIG_6LOWPAN is not set
> # CONFIG_IEEE802154 is not set
> CONFIG_NET_SCHED=y
> 
> #
> # Queueing/Scheduling
> #
> # CONFIG_NET_SCH_CBQ is not set
> CONFIG_NET_SCH_HTB=m
> # CONFIG_NET_SCH_HFSC is not set
> # CONFIG_NET_SCH_PRIO is not set
> # CONFIG_NET_SCH_MULTIQ is not set
> # CONFIG_NET_SCH_RED is not set
> # CONFIG_NET_SCH_SFB is not set
> # CONFIG_NET_SCH_SFQ is not set
> # CONFIG_NET_SCH_TEQL is not set
> # CONFIG_NET_SCH_TBF is not set
> # CONFIG_NET_SCH_CBS is not set
> # CONFIG_NET_SCH_ETF is not set
> # CONFIG_NET_SCH_TAPRIO is not set
> # CONFIG_NET_SCH_GRED is not set
> # CONFIG_NET_SCH_DSMARK is not set
> # CONFIG_NET_SCH_NETEM is not set
> # CONFIG_NET_SCH_DRR is not set
> # CONFIG_NET_SCH_MQPRIO is not set
> # CONFIG_NET_SCH_SKBPRIO is not set
> # CONFIG_NET_SCH_CHOKE is not set
> # CONFIG_NET_SCH_QFQ is not set
> CONFIG_NET_SCH_CODEL=m
> CONFIG_NET_SCH_FQ_CODEL=m
> # CONFIG_NET_SCH_CAKE is not set
> CONFIG_NET_SCH_FQ=m
> # CONFIG_NET_SCH_HHF is not set
> # CONFIG_NET_SCH_PIE is not set
> # CONFIG_NET_SCH_PLUG is not set
> # CONFIG_NET_SCH_ETS is not set
> CONFIG_NET_SCH_DEFAULT=y
> # CONFIG_DEFAULT_FQ is not set
> # CONFIG_DEFAULT_CODEL is not set
> CONFIG_DEFAULT_FQ_CODEL=y
> # CONFIG_DEFAULT_PFIFO_FAST is not set
> CONFIG_DEFAULT_NET_SCH="fq_codel"
> 
> #
> # Classification
> #
> # CONFIG_NET_CLS_BASIC is not set
> # CONFIG_NET_CLS_TCINDEX is not set
> # CONFIG_NET_CLS_ROUTE4 is not set
> # CONFIG_NET_CLS_FW is not set
> # CONFIG_NET_CLS_U32 is not set
> # CONFIG_NET_CLS_RSVP is not set
> # CONFIG_NET_CLS_RSVP6 is not set
> # CONFIG_NET_CLS_FLOW is not set
> # CONFIG_NET_CLS_CGROUP is not set
> # CONFIG_NET_CLS_BPF is not set
> # CONFIG_NET_CLS_FLOWER is not set
> # CONFIG_NET_CLS_MATCHALL is not set
> # CONFIG_NET_EMATCH is not set
> # CONFIG_NET_CLS_ACT is not set
> CONFIG_NET_SCH_FIFO=y
> # CONFIG_DCB is not set
> CONFIG_DNS_RESOLVER=y
> # CONFIG_BATMAN_ADV is not set
> # CONFIG_OPENVSWITCH is not set
> # CONFIG_VSOCKETS is not set
> # CONFIG_NETLINK_DIAG is not set
> # CONFIG_MPLS is not set
> # CONFIG_NET_NSH is not set
> # CONFIG_HSR is not set
> # CONFIG_NET_SWITCHDEV is not set
> # CONFIG_NET_L3_MASTER_DEV is not set
> # CONFIG_QRTR is not set
> # CONFIG_NET_NCSI is not set
> CONFIG_PCPU_DEV_REFCNT=y
> CONFIG_RPS=y
> CONFIG_RFS_ACCEL=y
> CONFIG_SOCK_RX_QUEUE_MAPPING=y
> CONFIG_XPS=y
> # CONFIG_CGROUP_NET_PRIO is not set
> # CONFIG_CGROUP_NET_CLASSID is not set
> CONFIG_NET_RX_BUSY_POLL=y
> CONFIG_BQL=y
> CONFIG_NET_FLOW_LIMIT=y
> 
> #
> # Network testing
> #
> # CONFIG_NET_PKTGEN is not set
> # CONFIG_NET_DROP_MONITOR is not set
> # end of Network testing
> # end of Networking options
> 
> # CONFIG_HAMRADIO is not set
> # CONFIG_CAN is not set
> # CONFIG_BT is not set
> # CONFIG_AF_RXRPC is not set
> # CONFIG_AF_KCM is not set
> # CONFIG_MCTP is not set
> # CONFIG_WIRELESS is not set
> # CONFIG_RFKILL is not set
> # CONFIG_NET_9P is not set
> # CONFIG_CAIF is not set
> # CONFIG_CEPH_LIB is not set
> # CONFIG_NFC is not set
> # CONFIG_PSAMPLE is not set
> # CONFIG_NET_IFE is not set
> # CONFIG_LWTUNNEL is not set
> CONFIG_GRO_CELLS=y
> CONFIG_NET_SOCK_MSG=y
> CONFIG_PAGE_POOL=y
> # CONFIG_PAGE_POOL_STATS is not set
> CONFIG_FAILOVER=y
> # CONFIG_ETHTOOL_NETLINK is not set
> 
> #
> # Device Drivers
> #
> CONFIG_HAVE_EISA=y
> # CONFIG_EISA is not set
> CONFIG_HAVE_PCI=y
> CONFIG_PCI=y
> CONFIG_PCI_DOMAINS=y
> CONFIG_PCIEPORTBUS=y
> CONFIG_HOTPLUG_PCI_PCIE=y
> # CONFIG_PCIEAER is not set
> # CONFIG_PCIEASPM is not set
> CONFIG_PCIE_PME=y
> # CONFIG_PCIE_PTM is not set
> CONFIG_PCI_MSI=y
> CONFIG_PCI_MSI_IRQ_DOMAIN=y
> CONFIG_PCI_QUIRKS=y
> # CONFIG_PCI_DEBUG is not set
> # CONFIG_PCI_STUB is not set
> CONFIG_PCI_LOCKLESS_CONFIG=y
> # CONFIG_PCI_IOV is not set
> # CONFIG_PCI_PRI is not set
> # CONFIG_PCI_PASID is not set
> # CONFIG_PCI_P2PDMA is not set
> CONFIG_PCI_LABEL=y
> # CONFIG_PCIE_BUS_TUNE_OFF is not set
> CONFIG_PCIE_BUS_DEFAULT=y
> # CONFIG_PCIE_BUS_SAFE is not set
> # CONFIG_PCIE_BUS_PERFORMANCE is not set
> # CONFIG_PCIE_BUS_PEER2PEER is not set
> # CONFIG_VGA_ARB is not set
> CONFIG_HOTPLUG_PCI=y
> CONFIG_HOTPLUG_PCI_ACPI=y
> # CONFIG_HOTPLUG_PCI_ACPI_IBM is not set
> # CONFIG_HOTPLUG_PCI_CPCI is not set
> # CONFIG_HOTPLUG_PCI_SHPC is not set
> 
> #
> # PCI controller drivers
> #
> # CONFIG_VMD is not set
> 
> #
> # DesignWare PCI Core Support
> #
> # CONFIG_PCIE_DW_PLAT_HOST is not set
> # CONFIG_PCI_MESON is not set
> # end of DesignWare PCI Core Support
> 
> #
> # Mobiveil PCIe Core Support
> #
> # end of Mobiveil PCIe Core Support
> 
> #
> # Cadence PCIe controllers support
> #
> # end of Cadence PCIe controllers support
> # end of PCI controller drivers
> 
> #
> # PCI Endpoint
> #
> # CONFIG_PCI_ENDPOINT is not set
> # end of PCI Endpoint
> 
> #
> # PCI switch controller drivers
> #
> # CONFIG_PCI_SW_SWITCHTEC is not set
> # end of PCI switch controller drivers
> 
> # CONFIG_CXL_BUS is not set
> # CONFIG_PCCARD is not set
> # CONFIG_RAPIDIO is not set
> 
> #
> # Generic Driver Options
> #
> CONFIG_UEVENT_HELPER=y
> CONFIG_UEVENT_HELPER_PATH=""
> CONFIG_DEVTMPFS=y
> CONFIG_DEVTMPFS_MOUNT=y
> # CONFIG_DEVTMPFS_SAFE is not set
> # CONFIG_STANDALONE is not set
> CONFIG_PREVENT_FIRMWARE_BUILD=y
> 
> #
> # Firmware loader
> #
> CONFIG_FW_LOADER=y
> CONFIG_EXTRA_FIRMWARE=""
> # CONFIG_FW_LOADER_USER_HELPER is not set
> # CONFIG_FW_LOADER_COMPRESS is not set
> # CONFIG_FW_CACHE is not set
> # CONFIG_FW_UPLOAD is not set
> # end of Firmware loader
> 
> # CONFIG_ALLOW_DEV_COREDUMP is not set
> # CONFIG_DEBUG_DRIVER is not set
> # CONFIG_DEBUG_DEVRES is not set
> # CONFIG_DEBUG_TEST_DRIVER_REMOVE is not set
> CONFIG_HMEM_REPORTING=y
> # CONFIG_TEST_ASYNC_DRIVER_PROBE is not set
> CONFIG_GENERIC_CPU_AUTOPROBE=y
> CONFIG_GENERIC_CPU_VULNERABILITIES=y
> # end of Generic Driver Options
> 
> #
> # Bus devices
> #
> # CONFIG_MHI_BUS is not set
> # CONFIG_MHI_BUS_EP is not set
> # end of Bus devices
> 
> CONFIG_CONNECTOR=y
> CONFIG_PROC_EVENTS=y
> 
> #
> # Firmware Drivers
> #
> 
> #
> # ARM System Control and Management Interface Protocol
> #
> # end of ARM System Control and Management Interface Protocol
> 
> CONFIG_EDD=y
> CONFIG_EDD_OFF=y
> CONFIG_FIRMWARE_MEMMAP=y
> CONFIG_DMIID=y
> # CONFIG_DMI_SYSFS is not set
> CONFIG_DMI_SCAN_MACHINE_NON_EFI_FALLBACK=y
> # CONFIG_ISCSI_IBFT is not set
> CONFIG_FW_CFG_SYSFS=y
> # CONFIG_FW_CFG_SYSFS_CMDLINE is not set
> # CONFIG_SYSFB_SIMPLEFB is not set
> # CONFIG_GOOGLE_FIRMWARE is not set
> 
> #
> # Tegra firmware driver
> #
> # end of Tegra firmware driver
> # end of Firmware Drivers
> 
> # CONFIG_GNSS is not set
> # CONFIG_MTD is not set
> # CONFIG_OF is not set
> CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
> # CONFIG_PARPORT is not set
> CONFIG_PNP=y
> # CONFIG_PNP_DEBUG_MESSAGES is not set
> 
> #
> # Protocols
> #
> CONFIG_PNPACPI=y
> CONFIG_BLK_DEV=y
> CONFIG_BLK_DEV_NULL_BLK=m
> # CONFIG_BLK_DEV_NULL_BLK_FAULT_INJECTION is not set
> CONFIG_CDROM=y
> # CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
> # CONFIG_ZRAM is not set
> CONFIG_BLK_DEV_LOOP=y
> CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
> # CONFIG_BLK_DEV_DRBD is not set
> CONFIG_BLK_DEV_NBD=m
> # CONFIG_BLK_DEV_RAM is not set
> # CONFIG_CDROM_PKTCDVD is not set
> # CONFIG_ATA_OVER_ETH is not set
> CONFIG_VIRTIO_BLK=y
> # CONFIG_BLK_DEV_RBD is not set
> # CONFIG_BLK_DEV_UBLK is not set
> 
> #
> # NVME Support
> #
> CONFIG_NVME_CORE=m
> CONFIG_BLK_DEV_NVME=m
> # CONFIG_NVME_MULTIPATH is not set
> # CONFIG_NVME_VERBOSE_ERRORS is not set
> # CONFIG_NVME_FC is not set
> # CONFIG_NVME_TCP is not set
> # CONFIG_NVME_AUTH is not set
> # CONFIG_NVME_TARGET is not set
> # end of NVME Support
> 
> #
> # Misc devices
> #
> # CONFIG_DUMMY_IRQ is not set
> # CONFIG_IBM_ASM is not set
> # CONFIG_PHANTOM is not set
> # CONFIG_TIFM_CORE is not set
> # CONFIG_ENCLOSURE_SERVICES is not set
> # CONFIG_HP_ILO is not set
> # CONFIG_SRAM is not set
> # CONFIG_DW_XDATA_PCIE is not set
> # CONFIG_PCI_ENDPOINT_TEST is not set
> # CONFIG_XILINX_SDFEC is not set
> # CONFIG_C2PORT is not set
> 
> #
> # EEPROM support
> #
> # CONFIG_EEPROM_93CX6 is not set
> # end of EEPROM support
> 
> # CONFIG_CB710_CORE is not set
> 
> #
> # Texas Instruments shared transport line discipline
> #
> # end of Texas Instruments shared transport line discipline
> 
> #
> # Altera FPGA firmware download module (requires I2C)
> #
> # CONFIG_INTEL_MEI is not set
> # CONFIG_INTEL_MEI_ME is not set
> # CONFIG_INTEL_MEI_TXE is not set
> # CONFIG_VMWARE_VMCI is not set
> # CONFIG_GENWQE is not set
> # CONFIG_ECHO is not set
> # CONFIG_BCM_VK is not set
> # CONFIG_MISC_ALCOR_PCI is not set
> # CONFIG_MISC_RTSX_PCI is not set
> # CONFIG_HABANA_AI is not set
> CONFIG_PVPANIC=y
> CONFIG_PVPANIC_MMIO=m
> CONFIG_PVPANIC_PCI=m
> # end of Misc devices
> 
> #
> # SCSI device support
> #
> CONFIG_SCSI_MOD=y
> # CONFIG_RAID_ATTRS is not set
> CONFIG_SCSI_COMMON=y
> CONFIG_SCSI=y
> CONFIG_SCSI_DMA=y
> CONFIG_SCSI_PROC_FS=y
> 
> #
> # SCSI support type (disk, tape, CD-ROM)
> #
> CONFIG_BLK_DEV_SD=y
> # CONFIG_CHR_DEV_ST is not set
> CONFIG_BLK_DEV_SR=y
> CONFIG_CHR_DEV_SG=y
> CONFIG_BLK_DEV_BSG=y
> CONFIG_CHR_DEV_SCH=m
> CONFIG_SCSI_CONSTANTS=y
> # CONFIG_SCSI_LOGGING is not set
> CONFIG_SCSI_SCAN_ASYNC=y
> 
> #
> # SCSI Transports
> #
> # CONFIG_SCSI_SPI_ATTRS is not set
> # CONFIG_SCSI_FC_ATTRS is not set
> # CONFIG_SCSI_ISCSI_ATTRS is not set
> # CONFIG_SCSI_SAS_ATTRS is not set
> # CONFIG_SCSI_SAS_LIBSAS is not set
> # CONFIG_SCSI_SRP_ATTRS is not set
> # end of SCSI Transports
> 
> CONFIG_SCSI_LOWLEVEL=y
> # CONFIG_ISCSI_TCP is not set
> # CONFIG_ISCSI_BOOT_SYSFS is not set
> # CONFIG_SCSI_CXGB3_ISCSI is not set
> # CONFIG_SCSI_BNX2_ISCSI is not set
> # CONFIG_BE2ISCSI is not set
> # CONFIG_BLK_DEV_3W_XXXX_RAID is not set
> # CONFIG_SCSI_HPSA is not set
> # CONFIG_SCSI_3W_9XXX is not set
> # CONFIG_SCSI_3W_SAS is not set
> # CONFIG_SCSI_ACARD is not set
> # CONFIG_SCSI_AACRAID is not set
> # CONFIG_SCSI_AIC7XXX is not set
> # CONFIG_SCSI_AIC79XX is not set
> # CONFIG_SCSI_AIC94XX is not set
> # CONFIG_SCSI_MVSAS is not set
> # CONFIG_SCSI_MVUMI is not set
> # CONFIG_SCSI_ADVANSYS is not set
> # CONFIG_SCSI_ARCMSR is not set
> # CONFIG_SCSI_ESAS2R is not set
> # CONFIG_MEGARAID_NEWGEN is not set
> # CONFIG_MEGARAID_LEGACY is not set
> # CONFIG_MEGARAID_SAS is not set
> # CONFIG_SCSI_MPT3SAS is not set
> # CONFIG_SCSI_MPT2SAS is not set
> # CONFIG_SCSI_MPI3MR is not set
> # CONFIG_SCSI_SMARTPQI is not set
> # CONFIG_SCSI_HPTIOP is not set
> # CONFIG_SCSI_BUSLOGIC is not set
> # CONFIG_SCSI_MYRB is not set
> # CONFIG_SCSI_MYRS is not set
> # CONFIG_VMWARE_PVSCSI is not set
> # CONFIG_SCSI_SNIC is not set
> # CONFIG_SCSI_DMX3191D is not set
> # CONFIG_SCSI_FDOMAIN_PCI is not set
> # CONFIG_SCSI_ISCI is not set
> # CONFIG_SCSI_IPS is not set
> # CONFIG_SCSI_INITIO is not set
> # CONFIG_SCSI_INIA100 is not set
> # CONFIG_SCSI_STEX is not set
> # CONFIG_SCSI_SYM53C8XX_2 is not set
> # CONFIG_SCSI_QLOGIC_1280 is not set
> # CONFIG_SCSI_QLA_ISCSI is not set
> # CONFIG_SCSI_DC395x is not set
> # CONFIG_SCSI_AM53C974 is not set
> # CONFIG_SCSI_WD719X is not set
> CONFIG_SCSI_DEBUG=m
> # CONFIG_SCSI_PMCRAID is not set
> # CONFIG_SCSI_PM8001 is not set
> CONFIG_SCSI_VIRTIO=y
> # CONFIG_SCSI_DH is not set
> # end of SCSI device support
> 
> # CONFIG_ATA is not set
> CONFIG_MD=y
> CONFIG_BLK_DEV_MD=m
> # CONFIG_MD_LINEAR is not set
> # CONFIG_MD_RAID0 is not set
> CONFIG_MD_RAID1=m
> # CONFIG_MD_RAID10 is not set
> # CONFIG_MD_RAID456 is not set
> # CONFIG_MD_MULTIPATH is not set
> # CONFIG_MD_FAULTY is not set
> # CONFIG_BCACHE is not set
> CONFIG_BLK_DEV_DM_BUILTIN=y
> CONFIG_BLK_DEV_DM=y
> # CONFIG_DM_DEBUG is not set
> CONFIG_DM_BUFIO=m
> # CONFIG_DM_DEBUG_BLOCK_MANAGER_LOCKING is not set
> CONFIG_DM_BIO_PRISON=m
> CONFIG_DM_PERSISTENT_DATA=m
> # CONFIG_DM_UNSTRIPED is not set
> CONFIG_DM_CRYPT=m
> CONFIG_DM_SNAPSHOT=m
> CONFIG_DM_THIN_PROVISIONING=m
> CONFIG_DM_CACHE=m
> CONFIG_DM_CACHE_SMQ=m
> CONFIG_DM_WRITECACHE=m
> # CONFIG_DM_EBS is not set
> CONFIG_DM_ERA=m
> # CONFIG_DM_CLONE is not set
> CONFIG_DM_MIRROR=m
> CONFIG_DM_LOG_USERSPACE=m
> # CONFIG_DM_RAID is not set
> CONFIG_DM_ZERO=m
> # CONFIG_DM_MULTIPATH is not set
> CONFIG_DM_DELAY=m
> # CONFIG_DM_DUST is not set
> # CONFIG_DM_INIT is not set
> CONFIG_DM_UEVENT=y
> CONFIG_DM_FLAKEY=m
> # CONFIG_DM_VERITY is not set
> # CONFIG_DM_SWITCH is not set
> CONFIG_DM_LOG_WRITES=m
> CONFIG_DM_INTEGRITY=m
> # CONFIG_TARGET_CORE is not set
> # CONFIG_FUSION is not set
> 
> #
> # IEEE 1394 (FireWire) support
> #
> # CONFIG_FIREWIRE is not set
> # CONFIG_FIREWIRE_NOSY is not set
> # end of IEEE 1394 (FireWire) support
> 
> # CONFIG_MACINTOSH_DRIVERS is not set
> CONFIG_NETDEVICES=y
> CONFIG_NET_CORE=y
> # CONFIG_BONDING is not set
> # CONFIG_DUMMY is not set
> # CONFIG_WIREGUARD is not set
> # CONFIG_EQUALIZER is not set
> # CONFIG_NET_FC is not set
> # CONFIG_IFB is not set
> # CONFIG_NET_TEAM is not set
> # CONFIG_MACVLAN is not set
> # CONFIG_IPVLAN is not set
> # CONFIG_VXLAN is not set
> # CONFIG_GENEVE is not set
> # CONFIG_BAREUDP is not set
> # CONFIG_GTP is not set
> # CONFIG_AMT is not set
> # CONFIG_MACSEC is not set
> # CONFIG_NETCONSOLE is not set
> # CONFIG_TUN is not set
> # CONFIG_TUN_VNET_CROSS_LE is not set
> # CONFIG_VETH is not set
> CONFIG_VIRTIO_NET=y
> # CONFIG_NLMON is not set
> # CONFIG_ARCNET is not set
> # CONFIG_ETHERNET is not set
> # CONFIG_FDDI is not set
> # CONFIG_HIPPI is not set
> # CONFIG_NET_SB1000 is not set
> # CONFIG_PHYLIB is not set
> # CONFIG_MDIO_DEVICE is not set
> 
> #
> # PCS device drivers
> #
> # end of PCS device drivers
> 
> # CONFIG_PPP is not set
> # CONFIG_SLIP is not set
> 
> #
> # Host-side USB support is needed for USB Network Adapter support
> #
> # CONFIG_WLAN is not set
> # CONFIG_WAN is not set
> 
> #
> # Wireless WAN
> #
> # CONFIG_WWAN is not set
> # end of Wireless WAN
> 
> # CONFIG_VMXNET3 is not set
> # CONFIG_FUJITSU_ES is not set
> # CONFIG_NETDEVSIM is not set
> CONFIG_NET_FAILOVER=y
> # CONFIG_ISDN is not set
> 
> #
> # Input device support
> #
> CONFIG_INPUT=y
> # CONFIG_INPUT_FF_MEMLESS is not set
> # CONFIG_INPUT_SPARSEKMAP is not set
> # CONFIG_INPUT_MATRIXKMAP is not set
> 
> #
> # Userland interfaces
> #
> # CONFIG_INPUT_MOUSEDEV is not set
> # CONFIG_INPUT_JOYDEV is not set
> # CONFIG_INPUT_EVDEV is not set
> # CONFIG_INPUT_EVBUG is not set
> 
> #
> # Input Device Drivers
> #
> # CONFIG_INPUT_KEYBOARD is not set
> # CONFIG_INPUT_MOUSE is not set
> # CONFIG_INPUT_JOYSTICK is not set
> # CONFIG_INPUT_TABLET is not set
> # CONFIG_INPUT_TOUCHSCREEN is not set
> # CONFIG_INPUT_MISC is not set
> # CONFIG_RMI4_CORE is not set
> 
> #
> # Hardware I/O ports
> #
> # CONFIG_SERIO is not set
> CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
> # CONFIG_GAMEPORT is not set
> # end of Hardware I/O ports
> # end of Input device support
> 
> #
> # Character devices
> #
> CONFIG_TTY=y
> CONFIG_VT=y
> CONFIG_CONSOLE_TRANSLATIONS=y
> CONFIG_VT_CONSOLE=y
> CONFIG_VT_CONSOLE_SLEEP=y
> CONFIG_HW_CONSOLE=y
> CONFIG_VT_HW_CONSOLE_BINDING=y
> CONFIG_UNIX98_PTYS=y
> # CONFIG_LEGACY_PTYS is not set
> CONFIG_LDISC_AUTOLOAD=y
> 
> #
> # Serial drivers
> #
> CONFIG_SERIAL_EARLYCON=y
> CONFIG_SERIAL_8250=y
> # CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
> CONFIG_SERIAL_8250_PNP=y
> # CONFIG_SERIAL_8250_16550A_VARIANTS is not set
> # CONFIG_SERIAL_8250_FINTEK is not set
> CONFIG_SERIAL_8250_CONSOLE=y
> # CONFIG_SERIAL_8250_PCI is not set
> CONFIG_SERIAL_8250_NR_UARTS=48
> CONFIG_SERIAL_8250_RUNTIME_UARTS=4
> CONFIG_SERIAL_8250_EXTENDED=y
> CONFIG_SERIAL_8250_MANY_PORTS=y
> CONFIG_SERIAL_8250_SHARE_IRQ=y
> # CONFIG_SERIAL_8250_DETECT_IRQ is not set
> # CONFIG_SERIAL_8250_RSA is not set
> # CONFIG_SERIAL_8250_DW is not set
> # CONFIG_SERIAL_8250_RT288X is not set
> # CONFIG_SERIAL_8250_LPSS is not set
> # CONFIG_SERIAL_8250_MID is not set
> # CONFIG_SERIAL_8250_PERICOM is not set
> 
> #
> # Non-8250 serial port support
> #
> # CONFIG_SERIAL_UARTLITE is not set
> CONFIG_SERIAL_CORE=y
> CONFIG_SERIAL_CORE_CONSOLE=y
> # CONFIG_SERIAL_JSM is not set
> # CONFIG_SERIAL_LANTIQ is not set
> # CONFIG_SERIAL_SCCNXP is not set
> # CONFIG_SERIAL_ALTERA_JTAGUART is not set
> # CONFIG_SERIAL_ALTERA_UART is not set
> # CONFIG_SERIAL_ARC is not set
> # CONFIG_SERIAL_RP2 is not set
> # CONFIG_SERIAL_FSL_LPUART is not set
> # CONFIG_SERIAL_FSL_LINFLEXUART is not set
> # CONFIG_SERIAL_SPRD is not set
> # end of Serial drivers
> 
> # CONFIG_SERIAL_NONSTANDARD is not set
> # CONFIG_N_GSM is not set
> # CONFIG_NOZOMI is not set
> # CONFIG_NULL_TTY is not set
> CONFIG_HVC_DRIVER=y
> # CONFIG_SERIAL_DEV_BUS is not set
> CONFIG_TTY_PRINTK=y
> CONFIG_TTY_PRINTK_LEVEL=6
> CONFIG_VIRTIO_CONSOLE=y
> # CONFIG_IPMI_HANDLER is not set
> CONFIG_HW_RANDOM=y
> # CONFIG_HW_RANDOM_TIMERIOMEM is not set
> # CONFIG_HW_RANDOM_INTEL is not set
> # CONFIG_HW_RANDOM_AMD is not set
> # CONFIG_HW_RANDOM_BA431 is not set
> # CONFIG_HW_RANDOM_VIA is not set
> CONFIG_HW_RANDOM_VIRTIO=y
> # CONFIG_HW_RANDOM_XIPHERA is not set
> # CONFIG_APPLICOM is not set
> # CONFIG_MWAVE is not set
> CONFIG_DEVMEM=y
> CONFIG_NVRAM=m
> # CONFIG_DEVPORT is not set
> CONFIG_HPET=y
> CONFIG_HPET_MMAP=y
> CONFIG_HPET_MMAP_DEFAULT=y
> # CONFIG_HANGCHECK_TIMER is not set
> # CONFIG_TCG_TPM is not set
> # CONFIG_TELCLOCK is not set
> # CONFIG_XILLYBUS is not set
> # CONFIG_RANDOM_TRUST_CPU is not set
> # CONFIG_RANDOM_TRUST_BOOTLOADER is not set
> # end of Character devices
> 
> #
> # I2C support
> #
> # CONFIG_I2C is not set
> # end of I2C support
> 
> # CONFIG_I3C is not set
> # CONFIG_SPI is not set
> # CONFIG_SPMI is not set
> # CONFIG_HSI is not set
> # CONFIG_PPS is not set
> 
> #
> # PTP clock support
> #
> # CONFIG_PTP_1588_CLOCK is not set
> CONFIG_PTP_1588_CLOCK_OPTIONAL=y
> 
> #
> # Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
> #
> # end of PTP clock support
> 
> # CONFIG_PINCTRL is not set
> # CONFIG_GPIOLIB is not set
> # CONFIG_W1 is not set
> # CONFIG_POWER_RESET is not set
> # CONFIG_POWER_SUPPLY is not set
> # CONFIG_HWMON is not set
> CONFIG_THERMAL=y
> # CONFIG_THERMAL_NETLINK is not set
> # CONFIG_THERMAL_STATISTICS is not set
> CONFIG_THERMAL_EMERGENCY_POWEROFF_DELAY_MS=0
> # CONFIG_THERMAL_WRITABLE_TRIPS is not set
> CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE=y
> # CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE is not set
> # CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
> # CONFIG_THERMAL_GOV_FAIR_SHARE is not set
> CONFIG_THERMAL_GOV_STEP_WISE=y
> # CONFIG_THERMAL_GOV_BANG_BANG is not set
> # CONFIG_THERMAL_GOV_USER_SPACE is not set
> # CONFIG_THERMAL_EMULATION is not set
> 
> #
> # Intel thermal drivers
> #
> # CONFIG_INTEL_POWERCLAMP is not set
> CONFIG_X86_THERMAL_VECTOR=y
> # CONFIG_X86_PKG_TEMP_THERMAL is not set
> # CONFIG_INTEL_SOC_DTS_THERMAL is not set
> 
> #
> # ACPI INT340X thermal drivers
> #
> # CONFIG_INT340X_THERMAL is not set
> # end of ACPI INT340X thermal drivers
> 
> # CONFIG_INTEL_PCH_THERMAL is not set
> # CONFIG_INTEL_TCC_COOLING is not set
> # CONFIG_INTEL_HFI_THERMAL is not set
> # end of Intel thermal drivers
> 
> # CONFIG_WATCHDOG is not set
> CONFIG_SSB_POSSIBLE=y
> # CONFIG_SSB is not set
> CONFIG_BCMA_POSSIBLE=y
> # CONFIG_BCMA is not set
> 
> #
> # Multifunction device drivers
> #
> # CONFIG_MFD_MADERA is not set
> # CONFIG_HTC_PASIC3 is not set
> # CONFIG_MFD_INTEL_QUARK_I2C_GPIO is not set
> # CONFIG_LPC_ICH is not set
> # CONFIG_LPC_SCH is not set
> # CONFIG_MFD_INTEL_LPSS_ACPI is not set
> # CONFIG_MFD_INTEL_LPSS_PCI is not set
> # CONFIG_MFD_INTEL_PMC_BXT is not set
> # CONFIG_MFD_JANZ_CMODIO is not set
> # CONFIG_MFD_KEMPLD is not set
> # CONFIG_MFD_MT6397 is not set
> # CONFIG_MFD_RDC321X is not set
> # CONFIG_MFD_SM501 is not set
> # CONFIG_MFD_SYSCON is not set
> # CONFIG_MFD_TI_AM335X_TSCADC is not set
> # CONFIG_MFD_TQMX86 is not set
> # CONFIG_MFD_VX855 is not set
> # end of Multifunction device drivers
> 
> # CONFIG_REGULATOR is not set
> # CONFIG_RC_CORE is not set
> 
> #
> # CEC support
> #
> # CONFIG_MEDIA_CEC_SUPPORT is not set
> # end of CEC support
> 
> # CONFIG_MEDIA_SUPPORT is not set
> 
> #
> # Graphics support
> #
> # CONFIG_AGP is not set
> # CONFIG_VGA_SWITCHEROO is not set
> # CONFIG_DRM is not set
> # CONFIG_DRM_DEBUG_MODESET_LOCK is not set
> 
> #
> # ARM devices
> #
> # end of ARM devices
> 
> #
> # Frame buffer Devices
> #
> # CONFIG_FB is not set
> # end of Frame buffer Devices
> 
> #
> # Backlight & LCD device support
> #
> # CONFIG_LCD_CLASS_DEVICE is not set
> # CONFIG_BACKLIGHT_CLASS_DEVICE is not set
> # end of Backlight & LCD device support
> 
> #
> # Console display driver support
> #
> CONFIG_VGA_CONSOLE=y
> CONFIG_DUMMY_CONSOLE=y
> CONFIG_DUMMY_CONSOLE_COLUMNS=80
> CONFIG_DUMMY_CONSOLE_ROWS=25
> # end of Console display driver support
> # end of Graphics support
> 
> # CONFIG_SOUND is not set
> 
> #
> # HID support
> #
> CONFIG_HID=y
> # CONFIG_HID_BATTERY_STRENGTH is not set
> CONFIG_HIDRAW=y
> # CONFIG_UHID is not set
> CONFIG_HID_GENERIC=y
> 
> #
> # Special HID drivers
> #
> # CONFIG_HID_A4TECH is not set
> # CONFIG_HID_ACRUX is not set
> # CONFIG_HID_AUREAL is not set
> # CONFIG_HID_BELKIN is not set
> # CONFIG_HID_CHERRY is not set
> # CONFIG_HID_COUGAR is not set
> # CONFIG_HID_MACALLY is not set
> # CONFIG_HID_CMEDIA is not set
> # CONFIG_HID_CYPRESS is not set
> # CONFIG_HID_DRAGONRISE is not set
> # CONFIG_HID_EMS_FF is not set
> # CONFIG_HID_ELECOM is not set
> # CONFIG_HID_EZKEY is not set
> # CONFIG_HID_GEMBIRD is not set
> # CONFIG_HID_GFRM is not set
> # CONFIG_HID_GLORIOUS is not set
> # CONFIG_HID_VIVALDI is not set
> # CONFIG_HID_KEYTOUCH is not set
> # CONFIG_HID_KYE is not set
> # CONFIG_HID_WALTOP is not set
> # CONFIG_HID_VIEWSONIC is not set
> # CONFIG_HID_XIAOMI is not set
> # CONFIG_HID_GYRATION is not set
> # CONFIG_HID_ICADE is not set
> # CONFIG_HID_ITE is not set
> # CONFIG_HID_JABRA is not set
> # CONFIG_HID_TWINHAN is not set
> # CONFIG_HID_KENSINGTON is not set
> # CONFIG_HID_LCPOWER is not set
> # CONFIG_HID_LENOVO is not set
> # CONFIG_HID_MAGICMOUSE is not set
> # CONFIG_HID_MALTRON is not set
> # CONFIG_HID_MAYFLASH is not set
> # CONFIG_HID_REDRAGON is not set
> # CONFIG_HID_MICROSOFT is not set
> # CONFIG_HID_MONTEREY is not set
> # CONFIG_HID_MULTITOUCH is not set
> # CONFIG_HID_NTI is not set
> # CONFIG_HID_ORTEK is not set
> # CONFIG_HID_PANTHERLORD is not set
> # CONFIG_HID_PETALYNX is not set
> # CONFIG_HID_PICOLCD is not set
> # CONFIG_HID_PLANTRONICS is not set
> # CONFIG_HID_RAZER is not set
> # CONFIG_HID_PRIMAX is not set
> # CONFIG_HID_SAITEK is not set
> # CONFIG_HID_SEMITEK is not set
> # CONFIG_HID_SPEEDLINK is not set
> # CONFIG_HID_STEAM is not set
> # CONFIG_HID_STEELSERIES is not set
> # CONFIG_HID_SUNPLUS is not set
> # CONFIG_HID_RMI is not set
> # CONFIG_HID_GREENASIA is not set
> # CONFIG_HID_SMARTJOYPLUS is not set
> # CONFIG_HID_TIVO is not set
> # CONFIG_HID_TOPSEED is not set
> # CONFIG_HID_UDRAW_PS3 is not set
> # CONFIG_HID_XINMO is not set
> # CONFIG_HID_ZEROPLUS is not set
> # CONFIG_HID_ZYDACRON is not set
> # CONFIG_HID_SENSOR_HUB is not set
> # CONFIG_HID_ALPS is not set
> # end of Special HID drivers
> 
> #
> # Intel ISH HID support
> #
> # CONFIG_INTEL_ISH_HID is not set
> # end of Intel ISH HID support
> 
> #
> # AMD SFH HID Support
> #
> # CONFIG_AMD_SFH_HID is not set
> # end of AMD SFH HID Support
> # end of HID support
> 
> CONFIG_USB_OHCI_LITTLE_ENDIAN=y
> # CONFIG_USB_SUPPORT is not set
> # CONFIG_MMC is not set
> # CONFIG_SCSI_UFSHCD is not set
> # CONFIG_MEMSTICK is not set
> # CONFIG_NEW_LEDS is not set
> # CONFIG_ACCESSIBILITY is not set
> # CONFIG_INFINIBAND is not set
> CONFIG_EDAC_ATOMIC_SCRUB=y
> CONFIG_EDAC_SUPPORT=y
> # CONFIG_EDAC is not set
> CONFIG_RTC_LIB=y
> CONFIG_RTC_MC146818_LIB=y
> CONFIG_RTC_CLASS=y
> CONFIG_RTC_HCTOSYS=y
> CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
> CONFIG_RTC_SYSTOHC=y
> CONFIG_RTC_SYSTOHC_DEVICE="rtc0"
> # CONFIG_RTC_DEBUG is not set
> CONFIG_RTC_NVMEM=y
> 
> #
> # RTC interfaces
> #
> CONFIG_RTC_INTF_SYSFS=y
> CONFIG_RTC_INTF_PROC=y
> CONFIG_RTC_INTF_DEV=y
> CONFIG_RTC_INTF_DEV_UIE_EMUL=y
> # CONFIG_RTC_DRV_TEST is not set
> 
> #
> # I2C RTC drivers
> #
> 
> #
> # SPI RTC drivers
> #
> 
> #
> # SPI and I2C RTC drivers
> #
> 
> #
> # Platform RTC drivers
> #
> CONFIG_RTC_DRV_CMOS=y
> # CONFIG_RTC_DRV_DS1286 is not set
> # CONFIG_RTC_DRV_DS1511 is not set
> # CONFIG_RTC_DRV_DS1553 is not set
> # CONFIG_RTC_DRV_DS1685_FAMILY is not set
> # CONFIG_RTC_DRV_DS1742 is not set
> # CONFIG_RTC_DRV_DS2404 is not set
> # CONFIG_RTC_DRV_STK17TA8 is not set
> # CONFIG_RTC_DRV_M48T86 is not set
> # CONFIG_RTC_DRV_M48T35 is not set
> # CONFIG_RTC_DRV_M48T59 is not set
> # CONFIG_RTC_DRV_MSM6242 is not set
> # CONFIG_RTC_DRV_BQ4802 is not set
> # CONFIG_RTC_DRV_RP5C01 is not set
> # CONFIG_RTC_DRV_V3020 is not set
> 
> #
> # on-CPU RTC drivers
> #
> # CONFIG_RTC_DRV_FTRTC010 is not set
> 
> #
> # HID Sensor RTC drivers
> #
> # CONFIG_RTC_DRV_GOLDFISH is not set
> # CONFIG_DMADEVICES is not set
> 
> #
> # DMABUF options
> #
> # CONFIG_SYNC_FILE is not set
> # CONFIG_DMABUF_HEAPS is not set
> # end of DMABUF options
> 
> # CONFIG_AUXDISPLAY is not set
> # CONFIG_UIO is not set
> # CONFIG_VFIO is not set
> # CONFIG_VIRT_DRIVERS is not set
> CONFIG_VIRTIO_ANCHOR=y
> CONFIG_VIRTIO=y
> CONFIG_VIRTIO_PCI_LIB=y
> CONFIG_VIRTIO_PCI_LIB_LEGACY=y
> CONFIG_VIRTIO_MENU=y
> CONFIG_VIRTIO_PCI=y
> CONFIG_VIRTIO_PCI_LEGACY=y
> CONFIG_VIRTIO_PMEM=m
> CONFIG_VIRTIO_BALLOON=y
> # CONFIG_VIRTIO_MEM is not set
> CONFIG_VIRTIO_INPUT=y
> # CONFIG_VIRTIO_MMIO is not set
> # CONFIG_VDPA is not set
> CONFIG_VHOST_MENU=y
> # CONFIG_VHOST_NET is not set
> # CONFIG_VHOST_CROSS_ENDIAN_LEGACY is not set
> 
> #
> # Microsoft Hyper-V guest support
> #
> # CONFIG_HYPERV is not set
> # end of Microsoft Hyper-V guest support
> 
> # CONFIG_GREYBUS is not set
> # CONFIG_COMEDI is not set
> # CONFIG_STAGING is not set
> # CONFIG_CHROME_PLATFORMS is not set
> # CONFIG_MELLANOX_PLATFORM is not set
> CONFIG_SURFACE_PLATFORMS=y
> # CONFIG_SURFACE_GPE is not set
> # CONFIG_SURFACE_PRO3_BUTTON is not set
> CONFIG_X86_PLATFORM_DEVICES=y
> # CONFIG_ACPI_WMI is not set
> # CONFIG_ACERHDF is not set
> # CONFIG_ACER_WIRELESS is not set
> # CONFIG_AMD_PMC is not set
> # CONFIG_AMD_HSMP is not set
> # CONFIG_ADV_SWBUTTON is not set
> # CONFIG_ASUS_WIRELESS is not set
> # CONFIG_X86_PLATFORM_DRIVERS_DELL is not set
> # CONFIG_FUJITSU_TABLET is not set
> # CONFIG_GPD_POCKET_FAN is not set
> # CONFIG_WIRELESS_HOTKEY is not set
> # CONFIG_IBM_RTL is not set
> # CONFIG_SENSORS_HDAPS is not set
> # CONFIG_INTEL_SAR_INT1092 is not set
> # CONFIG_INTEL_PMC_CORE is not set
> 
> #
> # Intel Speed Select Technology interface support
> #
> # CONFIG_INTEL_SPEED_SELECT_INTERFACE is not set
> # end of Intel Speed Select Technology interface support
> 
> #
> # Intel Uncore Frequency Control
> #
> # CONFIG_INTEL_UNCORE_FREQ_CONTROL is not set
> # end of Intel Uncore Frequency Control
> 
> # CONFIG_INTEL_PUNIT_IPC is not set
> # CONFIG_INTEL_RST is not set
> # CONFIG_INTEL_SMARTCONNECT is not set
> # CONFIG_INTEL_VSEC is not set
> # CONFIG_SAMSUNG_Q10 is not set
> # CONFIG_TOSHIBA_BT_RFKILL is not set
> # CONFIG_TOSHIBA_HAPS is not set
> # CONFIG_ACPI_CMPC is not set
> # CONFIG_TOPSTAR_LAPTOP is not set
> # CONFIG_INTEL_IPS is not set
> # CONFIG_INTEL_SCU_PCI is not set
> # CONFIG_INTEL_SCU_PLATFORM is not set
> # CONFIG_SIEMENS_SIMATIC_IPC is not set
> # CONFIG_WINMATE_FM07_KEYS is not set
> # CONFIG_P2SB is not set
> CONFIG_HAVE_CLK=y
> CONFIG_HAVE_CLK_PREPARE=y
> CONFIG_COMMON_CLK=y
> # CONFIG_XILINX_VCU is not set
> # CONFIG_HWSPINLOCK is not set
> 
> #
> # Clock Source drivers
> #
> CONFIG_CLKEVT_I8253=y
> CONFIG_I8253_LOCK=y
> CONFIG_CLKBLD_I8253=y
> # end of Clock Source drivers
> 
> # CONFIG_MAILBOX is not set
> # CONFIG_IOMMU_SUPPORT is not set
> 
> #
> # Remoteproc drivers
> #
> # CONFIG_REMOTEPROC is not set
> # end of Remoteproc drivers
> 
> #
> # Rpmsg drivers
> #
> # CONFIG_RPMSG_VIRTIO is not set
> # end of Rpmsg drivers
> 
> # CONFIG_SOUNDWIRE is not set
> 
> #
> # SOC (System On Chip) specific Drivers
> #
> 
> #
> # Amlogic SoC drivers
> #
> # end of Amlogic SoC drivers
> 
> #
> # Broadcom SoC drivers
> #
> # end of Broadcom SoC drivers
> 
> #
> # NXP/Freescale QorIQ SoC drivers
> #
> # end of NXP/Freescale QorIQ SoC drivers
> 
> #
> # fujitsu SoC drivers
> #
> # end of fujitsu SoC drivers
> 
> #
> # i.MX SoC drivers
> #
> # end of i.MX SoC drivers
> 
> #
> # Enable LiteX SoC Builder specific drivers
> #
> # end of Enable LiteX SoC Builder specific drivers
> 
> #
> # Qualcomm SoC drivers
> #
> # end of Qualcomm SoC drivers
> 
> # CONFIG_SOC_TI is not set
> 
> #
> # Xilinx SoC drivers
> #
> # end of Xilinx SoC drivers
> # end of SOC (System On Chip) specific Drivers
> 
> # CONFIG_PM_DEVFREQ is not set
> # CONFIG_EXTCON is not set
> # CONFIG_MEMORY is not set
> # CONFIG_IIO is not set
> # CONFIG_NTB is not set
> # CONFIG_PWM is not set
> 
> #
> # IRQ chip support
> #
> # end of IRQ chip support
> 
> # CONFIG_IPACK_BUS is not set
> # CONFIG_RESET_CONTROLLER is not set
> 
> #
> # PHY Subsystem
> #
> # CONFIG_GENERIC_PHY is not set
> # CONFIG_PHY_CAN_TRANSCEIVER is not set
> 
> #
> # PHY drivers for Broadcom platforms
> #
> # CONFIG_BCM_KONA_USB2_PHY is not set
> # end of PHY drivers for Broadcom platforms
> 
> # CONFIG_PHY_PXA_28NM_HSIC is not set
> # CONFIG_PHY_PXA_28NM_USB2 is not set
> # CONFIG_PHY_INTEL_LGM_EMMC is not set
> # end of PHY Subsystem
> 
> # CONFIG_POWERCAP is not set
> # CONFIG_MCB is not set
> 
> #
> # Performance monitor support
> #
> # end of Performance monitor support
> 
> CONFIG_RAS=y
> # CONFIG_RAS_CEC is not set
> # CONFIG_USB4 is not set
> 
> #
> # Android
> #
> # CONFIG_ANDROID_BINDER_IPC is not set
> # end of Android
> 
> CONFIG_LIBNVDIMM=y
> CONFIG_BLK_DEV_PMEM=m
> CONFIG_ND_CLAIM=y
> CONFIG_ND_BTT=m
> CONFIG_BTT=y
> CONFIG_ND_PFN=m
> CONFIG_NVDIMM_PFN=y
> CONFIG_NVDIMM_DAX=y
> CONFIG_DAX=y
> CONFIG_DEV_DAX=m
> CONFIG_DEV_DAX_PMEM=m
> CONFIG_DEV_DAX_KMEM=m
> CONFIG_NVMEM=y
> CONFIG_NVMEM_SYSFS=y
> # CONFIG_NVMEM_RMEM is not set
> 
> #
> # HW tracing support
> #
> # CONFIG_STM is not set
> # CONFIG_INTEL_TH is not set
> # end of HW tracing support
> 
> # CONFIG_FPGA is not set
> # CONFIG_TEE is not set
> # CONFIG_SIOX is not set
> # CONFIG_SLIMBUS is not set
> # CONFIG_INTERCONNECT is not set
> # CONFIG_COUNTER is not set
> # CONFIG_MOST is not set
> # CONFIG_PECI is not set
> # CONFIG_HTE is not set
> # end of Device Drivers
> 
> #
> # File systems
> #
> CONFIG_DCACHE_WORD_ACCESS=y
> CONFIG_VALIDATE_FS_PARSER=y
> CONFIG_FS_IOMAP=y
> CONFIG_EXT2_FS=m
> CONFIG_EXT2_FS_XATTR=y
> CONFIG_EXT2_FS_POSIX_ACL=y
> CONFIG_EXT2_FS_SECURITY=y
> # CONFIG_EXT3_FS is not set
> CONFIG_EXT4_FS=m
> CONFIG_EXT4_FS_POSIX_ACL=y
> CONFIG_EXT4_FS_SECURITY=y
> CONFIG_EXT4_DEBUG=y
> CONFIG_JBD2=m
> # CONFIG_JBD2_DEBUG is not set
> CONFIG_FS_MBCACHE=m
> # CONFIG_REISERFS_FS is not set
> # CONFIG_JFS_FS is not set
> CONFIG_XFS_FS=m
> CONFIG_XFS_SUPPORT_V4=y
> CONFIG_XFS_QUOTA=y
> CONFIG_XFS_POSIX_ACL=y
> CONFIG_XFS_RT=y
> CONFIG_XFS_DRAIN_INTENTS=y
> CONFIG_XFS_LIVE_HOOKS=y
> CONFIG_XFS_IN_MEMORY_FILE=y
> CONFIG_XFS_IN_MEMORY_BTREE=y
> CONFIG_XFS_ONLINE_SCRUB=y
> # CONFIG_XFS_LIVE_HOOKS_SRCU is not set
> CONFIG_XFS_LIVE_HOOKS_BLOCKING=y
> CONFIG_XFS_ONLINE_REPAIR=y
> CONFIG_XFS_DEBUG=y
> # CONFIG_XFS_ASSERT_FATAL is not set
> CONFIG_XFS_LARGE_FOLIOS=y
> # CONFIG_GFS2_FS is not set
> CONFIG_OCFS2_FS=m
> CONFIG_OCFS2_FS_O2CB=m
> CONFIG_OCFS2_FS_STATS=y
> CONFIG_OCFS2_DEBUG_MASKLOG=y
> # CONFIG_OCFS2_DEBUG_FS is not set
> CONFIG_BTRFS_FS=m
> CONFIG_BTRFS_FS_POSIX_ACL=y
> # CONFIG_BTRFS_FS_CHECK_INTEGRITY is not set
> # CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
> # CONFIG_BTRFS_DEBUG is not set
> # CONFIG_BTRFS_ASSERT is not set
> # CONFIG_BTRFS_FS_REF_VERIFY is not set
> # CONFIG_NILFS2_FS is not set
> # CONFIG_F2FS_FS is not set
> CONFIG_FS_DAX=y
> CONFIG_FS_DAX_PMD=y
> CONFIG_FS_POSIX_ACL=y
> CONFIG_EXPORTFS=y
> CONFIG_EXPORTFS_BLOCK_OPS=y
> CONFIG_FILE_LOCKING=y
> # CONFIG_FS_ENCRYPTION is not set
> # CONFIG_FS_VERITY is not set
> CONFIG_FSNOTIFY=y
> CONFIG_DNOTIFY=y
> CONFIG_INOTIFY_USER=y
> CONFIG_FANOTIFY=y
> CONFIG_QUOTA=y
> CONFIG_QUOTA_NETLINK_INTERFACE=y
> # CONFIG_PRINT_QUOTA_WARNING is not set
> # CONFIG_QUOTA_DEBUG is not set
> CONFIG_QUOTA_TREE=m
> # CONFIG_QFMT_V1 is not set
> CONFIG_QFMT_V2=m
> CONFIG_QUOTACTL=y
> # CONFIG_AUTOFS4_FS is not set
> # CONFIG_AUTOFS_FS is not set
> CONFIG_FUSE_FS=m
> # CONFIG_CUSE is not set
> CONFIG_VIRTIO_FS=m
> CONFIG_FUSE_DAX=y
> CONFIG_OVERLAY_FS=m
> CONFIG_OVERLAY_FS_REDIRECT_DIR=y
> CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW=y
> CONFIG_OVERLAY_FS_INDEX=y
> CONFIG_OVERLAY_FS_XINO_AUTO=y
> CONFIG_OVERLAY_FS_METACOPY=y
> 
> #
> # Caches
> #
> # CONFIG_FSCACHE is not set
> # end of Caches
> 
> #
> # CD-ROM/DVD Filesystems
> #
> # CONFIG_ISO9660_FS is not set
> # CONFIG_UDF_FS is not set
> # end of CD-ROM/DVD Filesystems
> 
> #
> # DOS/FAT/EXFAT/NT Filesystems
> #
> CONFIG_FAT_FS=m
> # CONFIG_MSDOS_FS is not set
> CONFIG_VFAT_FS=m
> CONFIG_FAT_DEFAULT_CODEPAGE=437
> CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
> # CONFIG_FAT_DEFAULT_UTF8 is not set
> # CONFIG_EXFAT_FS is not set
> # CONFIG_NTFS_FS is not set
> # CONFIG_NTFS3_FS is not set
> # end of DOS/FAT/EXFAT/NT Filesystems
> 
> #
> # Pseudo filesystems
> #
> CONFIG_PROC_FS=y
> CONFIG_PROC_KCORE=y
> CONFIG_PROC_VMCORE=y
> # CONFIG_PROC_VMCORE_DEVICE_DUMP is not set
> CONFIG_PROC_SYSCTL=y
> CONFIG_PROC_PAGE_MONITOR=y
> CONFIG_PROC_CHILDREN=y
> CONFIG_PROC_PID_ARCH_STATUS=y
> CONFIG_KERNFS=y
> CONFIG_SYSFS=y
> CONFIG_TMPFS=y
> CONFIG_TMPFS_POSIX_ACL=y
> CONFIG_TMPFS_XATTR=y
> CONFIG_TMPFS_INODE64=y
> CONFIG_HUGETLBFS=y
> CONFIG_HUGETLB_PAGE=y
> CONFIG_ARCH_WANT_HUGETLB_PAGE_OPTIMIZE_VMEMMAP=y
> CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP=y
> # CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON is not set
> CONFIG_MEMFD_CREATE=y
> CONFIG_ARCH_HAS_GIGANTIC_PAGE=y
> CONFIG_CONFIGFS_FS=m
> # end of Pseudo filesystems
> 
> # CONFIG_MISC_FILESYSTEMS is not set
> CONFIG_NETWORK_FILESYSTEMS=y
> CONFIG_NFS_FS=y
> CONFIG_NFS_V2=m
> CONFIG_NFS_V3=y
> CONFIG_NFS_V3_ACL=y
> CONFIG_NFS_V4=m
> # CONFIG_NFS_SWAP is not set
> CONFIG_NFS_V4_1=y
> CONFIG_NFS_V4_2=y
> CONFIG_PNFS_FILE_LAYOUT=m
> CONFIG_PNFS_BLOCK=m
> CONFIG_PNFS_FLEXFILE_LAYOUT=m
> CONFIG_NFS_V4_1_IMPLEMENTATION_ID_DOMAIN="kernel.org"
> # CONFIG_NFS_V4_1_MIGRATION is not set
> CONFIG_NFS_USE_LEGACY_DNS=y
> CONFIG_NFS_DEBUG=y
> CONFIG_NFS_DISABLE_UDP_SUPPORT=y
> # CONFIG_NFS_V4_2_READ_PLUS is not set
> CONFIG_NFSD=m
> CONFIG_NFSD_V2_ACL=y
> CONFIG_NFSD_V3_ACL=y
> CONFIG_NFSD_V4=y
> CONFIG_NFSD_PNFS=y
> CONFIG_NFSD_BLOCKLAYOUT=y
> CONFIG_NFSD_SCSILAYOUT=y
> CONFIG_NFSD_FLEXFILELAYOUT=y
> # CONFIG_NFSD_V4_2_INTER_SSC is not set
> CONFIG_GRACE_PERIOD=y
> CONFIG_LOCKD=y
> CONFIG_LOCKD_V4=y
> CONFIG_NFS_ACL_SUPPORT=y
> CONFIG_NFS_COMMON=y
> CONFIG_NFS_V4_2_SSC_HELPER=y
> CONFIG_SUNRPC=y
> CONFIG_SUNRPC_GSS=m
> CONFIG_SUNRPC_BACKCHANNEL=y
> CONFIG_SUNRPC_DEBUG=y
> # CONFIG_CEPH_FS is not set
> CONFIG_CIFS=m
> # CONFIG_CIFS_STATS2 is not set
> # CONFIG_CIFS_ALLOW_INSECURE_LEGACY is not set
> # CONFIG_CIFS_UPCALL is not set
> # CONFIG_CIFS_XATTR is not set
> # CONFIG_CIFS_DEBUG is not set
> # CONFIG_CIFS_DFS_UPCALL is not set
> # CONFIG_CIFS_SWN_UPCALL is not set
> # CONFIG_SMB_SERVER is not set
> CONFIG_SMBFS_COMMON=m
> # CONFIG_CODA_FS is not set
> # CONFIG_AFS_FS is not set
> CONFIG_NLS=y
> CONFIG_NLS_DEFAULT="cp437"
> CONFIG_NLS_CODEPAGE_437=m
> # CONFIG_NLS_CODEPAGE_737 is not set
> # CONFIG_NLS_CODEPAGE_775 is not set
> # CONFIG_NLS_CODEPAGE_850 is not set
> # CONFIG_NLS_CODEPAGE_852 is not set
> # CONFIG_NLS_CODEPAGE_855 is not set
> # CONFIG_NLS_CODEPAGE_857 is not set
> # CONFIG_NLS_CODEPAGE_860 is not set
> # CONFIG_NLS_CODEPAGE_861 is not set
> # CONFIG_NLS_CODEPAGE_862 is not set
> # CONFIG_NLS_CODEPAGE_863 is not set
> # CONFIG_NLS_CODEPAGE_864 is not set
> # CONFIG_NLS_CODEPAGE_865 is not set
> # CONFIG_NLS_CODEPAGE_866 is not set
> # CONFIG_NLS_CODEPAGE_869 is not set
> # CONFIG_NLS_CODEPAGE_936 is not set
> # CONFIG_NLS_CODEPAGE_950 is not set
> # CONFIG_NLS_CODEPAGE_932 is not set
> # CONFIG_NLS_CODEPAGE_949 is not set
> # CONFIG_NLS_CODEPAGE_874 is not set
> # CONFIG_NLS_ISO8859_8 is not set
> # CONFIG_NLS_CODEPAGE_1250 is not set
> # CONFIG_NLS_CODEPAGE_1251 is not set
> CONFIG_NLS_ASCII=m
> CONFIG_NLS_ISO8859_1=m
> # CONFIG_NLS_ISO8859_2 is not set
> # CONFIG_NLS_ISO8859_3 is not set
> # CONFIG_NLS_ISO8859_4 is not set
> # CONFIG_NLS_ISO8859_5 is not set
> # CONFIG_NLS_ISO8859_6 is not set
> # CONFIG_NLS_ISO8859_7 is not set
> # CONFIG_NLS_ISO8859_9 is not set
> # CONFIG_NLS_ISO8859_13 is not set
> # CONFIG_NLS_ISO8859_14 is not set
> # CONFIG_NLS_ISO8859_15 is not set
> # CONFIG_NLS_KOI8_R is not set
> # CONFIG_NLS_KOI8_U is not set
> # CONFIG_NLS_MAC_ROMAN is not set
> # CONFIG_NLS_MAC_CELTIC is not set
> # CONFIG_NLS_MAC_CENTEURO is not set
> # CONFIG_NLS_MAC_CROATIAN is not set
> # CONFIG_NLS_MAC_CYRILLIC is not set
> # CONFIG_NLS_MAC_GAELIC is not set
> # CONFIG_NLS_MAC_GREEK is not set
> # CONFIG_NLS_MAC_ICELAND is not set
> # CONFIG_NLS_MAC_INUIT is not set
> # CONFIG_NLS_MAC_ROMANIAN is not set
> # CONFIG_NLS_MAC_TURKISH is not set
> CONFIG_NLS_UTF8=m
> # CONFIG_DLM is not set
> # CONFIG_UNICODE is not set
> CONFIG_IO_WQ=y
> # end of File systems
> 
> #
> # Security options
> #
> CONFIG_KEYS=y
> # CONFIG_KEYS_REQUEST_CACHE is not set
> # CONFIG_PERSISTENT_KEYRINGS is not set
> # CONFIG_TRUSTED_KEYS is not set
> # CONFIG_ENCRYPTED_KEYS is not set
> # CONFIG_KEY_DH_OPERATIONS is not set
> # CONFIG_SECURITY_DMESG_RESTRICT is not set
> # CONFIG_SECURITY is not set
> # CONFIG_SECURITYFS is not set
> CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR=y
> CONFIG_HARDENED_USERCOPY=y
> CONFIG_FORTIFY_SOURCE=y
> # CONFIG_STATIC_USERMODEHELPER is not set
> CONFIG_DEFAULT_SECURITY_DAC=y
> CONFIG_LSM="yama,loadpin,safesetid,integrity,selinux,smack,tomoyo,apparmor"
> 
> #
> # Kernel hardening options
> #
> 
> #
> # Memory initialization
> #
> CONFIG_INIT_STACK_NONE=y
> # CONFIG_GCC_PLUGIN_STRUCTLEAK_USER is not set
> # CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF is not set
> # CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL is not set
> # CONFIG_GCC_PLUGIN_STACKLEAK is not set
> # CONFIG_INIT_ON_ALLOC_DEFAULT_ON is not set
> # CONFIG_INIT_ON_FREE_DEFAULT_ON is not set
> CONFIG_CC_HAS_ZERO_CALL_USED_REGS=y
> # CONFIG_ZERO_CALL_USED_REGS is not set
> # end of Memory initialization
> 
> CONFIG_RANDSTRUCT_NONE=y
> # CONFIG_RANDSTRUCT_FULL is not set
> # CONFIG_RANDSTRUCT_PERFORMANCE is not set
> # end of Kernel hardening options
> # end of Security options
> 
> CONFIG_XOR_BLOCKS=m
> CONFIG_ASYNC_CORE=m
> CONFIG_ASYNC_XOR=m
> CONFIG_CRYPTO=y
> 
> #
> # Crypto core or helper
> #
> CONFIG_CRYPTO_ALGAPI=y
> CONFIG_CRYPTO_ALGAPI2=y
> CONFIG_CRYPTO_AEAD=m
> CONFIG_CRYPTO_AEAD2=y
> CONFIG_CRYPTO_SKCIPHER=y
> CONFIG_CRYPTO_SKCIPHER2=y
> CONFIG_CRYPTO_HASH=y
> CONFIG_CRYPTO_HASH2=y
> CONFIG_CRYPTO_RNG=m
> CONFIG_CRYPTO_RNG2=y
> CONFIG_CRYPTO_RNG_DEFAULT=m
> CONFIG_CRYPTO_AKCIPHER2=y
> CONFIG_CRYPTO_KPP2=y
> CONFIG_CRYPTO_ACOMP2=y
> CONFIG_CRYPTO_MANAGER=y
> CONFIG_CRYPTO_MANAGER2=y
> # CONFIG_CRYPTO_USER is not set
> CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
> CONFIG_CRYPTO_GF128MUL=m
> CONFIG_CRYPTO_NULL=m
> CONFIG_CRYPTO_NULL2=y
> # CONFIG_CRYPTO_PCRYPT is not set
> # CONFIG_CRYPTO_CRYPTD is not set
> CONFIG_CRYPTO_AUTHENC=m
> # CONFIG_CRYPTO_TEST is not set
> 
> #
> # Public-key cryptography
> #
> # CONFIG_CRYPTO_RSA is not set
> # CONFIG_CRYPTO_DH is not set
> # CONFIG_CRYPTO_ECDH is not set
> # CONFIG_CRYPTO_ECDSA is not set
> # CONFIG_CRYPTO_ECRDSA is not set
> # CONFIG_CRYPTO_SM2 is not set
> # CONFIG_CRYPTO_CURVE25519 is not set
> # CONFIG_CRYPTO_CURVE25519_X86 is not set
> 
> #
> # Authenticated Encryption with Associated Data
> #
> CONFIG_CRYPTO_CCM=m
> CONFIG_CRYPTO_GCM=m
> # CONFIG_CRYPTO_CHACHA20POLY1305 is not set
> # CONFIG_CRYPTO_AEGIS128 is not set
> # CONFIG_CRYPTO_AEGIS128_AESNI_SSE2 is not set
> CONFIG_CRYPTO_SEQIV=m
> # CONFIG_CRYPTO_ECHAINIV is not set
> 
> #
> # Block modes
> #
> CONFIG_CRYPTO_CBC=y
> # CONFIG_CRYPTO_CFB is not set
> CONFIG_CRYPTO_CTR=m
> # CONFIG_CRYPTO_CTS is not set
> CONFIG_CRYPTO_ECB=m
> # CONFIG_CRYPTO_LRW is not set
> # CONFIG_CRYPTO_OFB is not set
> # CONFIG_CRYPTO_PCBC is not set
> # CONFIG_CRYPTO_XTS is not set
> # CONFIG_CRYPTO_KEYWRAP is not set
> # CONFIG_CRYPTO_NHPOLY1305_SSE2 is not set
> # CONFIG_CRYPTO_NHPOLY1305_AVX2 is not set
> # CONFIG_CRYPTO_ADIANTUM is not set
> # CONFIG_CRYPTO_HCTR2 is not set
> CONFIG_CRYPTO_ESSIV=m
> 
> #
> # Hash modes
> #
> CONFIG_CRYPTO_CMAC=m
> CONFIG_CRYPTO_HMAC=m
> # CONFIG_CRYPTO_XCBC is not set
> # CONFIG_CRYPTO_VMAC is not set
> 
> #
> # Digest
> #
> CONFIG_CRYPTO_CRC32C=y
> CONFIG_CRYPTO_CRC32C_INTEL=y
> CONFIG_CRYPTO_CRC32=y
> CONFIG_CRYPTO_CRC32_PCLMUL=y
> CONFIG_CRYPTO_XXHASH=m
> CONFIG_CRYPTO_BLAKE2B=m
> # CONFIG_CRYPTO_BLAKE2S_X86 is not set
> CONFIG_CRYPTO_CRCT10DIF=y
> CONFIG_CRYPTO_CRCT10DIF_PCLMUL=y
> CONFIG_CRYPTO_CRC64_ROCKSOFT=y
> CONFIG_CRYPTO_GHASH=m
> # CONFIG_CRYPTO_POLYVAL_CLMUL_NI is not set
> # CONFIG_CRYPTO_POLY1305 is not set
> # CONFIG_CRYPTO_POLY1305_X86_64 is not set
> CONFIG_CRYPTO_MD4=m
> CONFIG_CRYPTO_MD5=y
> # CONFIG_CRYPTO_MICHAEL_MIC is not set
> # CONFIG_CRYPTO_RMD160 is not set
> # CONFIG_CRYPTO_SHA1 is not set
> # CONFIG_CRYPTO_SHA1_SSSE3 is not set
> # CONFIG_CRYPTO_SHA256_SSSE3 is not set
> # CONFIG_CRYPTO_SHA512_SSSE3 is not set
> CONFIG_CRYPTO_SHA256=y
> CONFIG_CRYPTO_SHA512=m
> # CONFIG_CRYPTO_SHA3 is not set
> # CONFIG_CRYPTO_SM3_GENERIC is not set
> # CONFIG_CRYPTO_SM3_AVX_X86_64 is not set
> # CONFIG_CRYPTO_STREEBOG is not set
> # CONFIG_CRYPTO_WP512 is not set
> # CONFIG_CRYPTO_GHASH_CLMUL_NI_INTEL is not set
> 
> #
> # Ciphers
> #
> CONFIG_CRYPTO_AES=y
> # CONFIG_CRYPTO_AES_TI is not set
> # CONFIG_CRYPTO_AES_NI_INTEL is not set
> # CONFIG_CRYPTO_BLOWFISH is not set
> # CONFIG_CRYPTO_BLOWFISH_X86_64 is not set
> # CONFIG_CRYPTO_CAMELLIA is not set
> # CONFIG_CRYPTO_CAMELLIA_X86_64 is not set
> # CONFIG_CRYPTO_CAMELLIA_AESNI_AVX_X86_64 is not set
> # CONFIG_CRYPTO_CAMELLIA_AESNI_AVX2_X86_64 is not set
> # CONFIG_CRYPTO_CAST5 is not set
> # CONFIG_CRYPTO_CAST5_AVX_X86_64 is not set
> # CONFIG_CRYPTO_CAST6 is not set
> # CONFIG_CRYPTO_CAST6_AVX_X86_64 is not set
> CONFIG_CRYPTO_DES=m
> # CONFIG_CRYPTO_DES3_EDE_X86_64 is not set
> # CONFIG_CRYPTO_FCRYPT is not set
> # CONFIG_CRYPTO_CHACHA20 is not set
> # CONFIG_CRYPTO_CHACHA20_X86_64 is not set
> # CONFIG_CRYPTO_ARIA is not set
> # CONFIG_CRYPTO_SERPENT is not set
> # CONFIG_CRYPTO_SERPENT_SSE2_X86_64 is not set
> # CONFIG_CRYPTO_SERPENT_AVX_X86_64 is not set
> # CONFIG_CRYPTO_SERPENT_AVX2_X86_64 is not set
> # CONFIG_CRYPTO_SM4_GENERIC is not set
> # CONFIG_CRYPTO_SM4_AESNI_AVX_X86_64 is not set
> # CONFIG_CRYPTO_SM4_AESNI_AVX2_X86_64 is not set
> # CONFIG_CRYPTO_TWOFISH is not set
> # CONFIG_CRYPTO_TWOFISH_X86_64 is not set
> # CONFIG_CRYPTO_TWOFISH_X86_64_3WAY is not set
> # CONFIG_CRYPTO_TWOFISH_AVX_X86_64 is not set
> 
> #
> # Compression
> #
> CONFIG_CRYPTO_DEFLATE=m
> # CONFIG_CRYPTO_LZO is not set
> # CONFIG_CRYPTO_842 is not set
> CONFIG_CRYPTO_LZ4=m
> # CONFIG_CRYPTO_LZ4HC is not set
> # CONFIG_CRYPTO_ZSTD is not set
> 
> #
> # Random Number Generation
> #
> CONFIG_CRYPTO_ANSI_CPRNG=m
> CONFIG_CRYPTO_DRBG_MENU=m
> CONFIG_CRYPTO_DRBG_HMAC=y
> # CONFIG_CRYPTO_DRBG_HASH is not set
> # CONFIG_CRYPTO_DRBG_CTR is not set
> CONFIG_CRYPTO_DRBG=m
> CONFIG_CRYPTO_JITTERENTROPY=m
> CONFIG_CRYPTO_USER_API=m
> CONFIG_CRYPTO_USER_API_HASH=m
> CONFIG_CRYPTO_USER_API_SKCIPHER=m
> CONFIG_CRYPTO_USER_API_RNG=m
> # CONFIG_CRYPTO_USER_API_RNG_CAVP is not set
> CONFIG_CRYPTO_USER_API_AEAD=m
> # CONFIG_CRYPTO_USER_API_ENABLE_OBSOLETE is not set
> # CONFIG_CRYPTO_HW is not set
> # CONFIG_ASYMMETRIC_KEY_TYPE is not set
> 
> #
> # Certificates for signature checking
> #
> # CONFIG_SYSTEM_BLACKLIST_KEYRING is not set
> # end of Certificates for signature checking
> 
> CONFIG_BINARY_PRINTF=y
> 
> #
> # Library routines
> #
> CONFIG_RAID6_PQ=m
> CONFIG_DISABLE_DMESG_POINTER_HASHING=y
> CONFIG_RAID6_PQ_BENCHMARK=y
> # CONFIG_PACKING is not set
> CONFIG_BITREVERSE=y
> CONFIG_GENERIC_STRNCPY_FROM_USER=y
> CONFIG_GENERIC_STRNLEN_USER=y
> CONFIG_GENERIC_NET_UTILS=y
> # CONFIG_CORDIC is not set
> # CONFIG_PRIME_NUMBERS is not set
> CONFIG_RATIONAL=y
> CONFIG_GENERIC_PCI_IOMAP=y
> CONFIG_GENERIC_IOMAP=y
> CONFIG_ARCH_USE_CMPXCHG_LOCKREF=y
> CONFIG_ARCH_HAS_FAST_MULTIPLIER=y
> CONFIG_ARCH_USE_SYM_ANNOTATIONS=y
> 
> #
> # Crypto library routines
> #
> CONFIG_CRYPTO_LIB_AES=y
> CONFIG_CRYPTO_LIB_BLAKE2S_GENERIC=y
> # CONFIG_CRYPTO_LIB_CHACHA is not set
> # CONFIG_CRYPTO_LIB_CURVE25519 is not set
> CONFIG_CRYPTO_LIB_DES=m
> CONFIG_CRYPTO_LIB_POLY1305_RSIZE=11
> # CONFIG_CRYPTO_LIB_POLY1305 is not set
> # CONFIG_CRYPTO_LIB_CHACHA20POLY1305 is not set
> CONFIG_CRYPTO_LIB_SHA1=y
> CONFIG_CRYPTO_LIB_SHA256=y
> # end of Crypto library routines
> 
> CONFIG_LIB_MEMNEQ=y
> # CONFIG_CRC_CCITT is not set
> CONFIG_CRC16=y
> CONFIG_CRC_T10DIF=y
> CONFIG_CRC64_ROCKSOFT=y
> # CONFIG_CRC_ITU_T is not set
> CONFIG_CRC32=y
> # CONFIG_CRC32_SELFTEST is not set
> CONFIG_CRC32_SLICEBY8=y
> # CONFIG_CRC32_SLICEBY4 is not set
> # CONFIG_CRC32_SARWATE is not set
> # CONFIG_CRC32_BIT is not set
> CONFIG_CRC64=y
> # CONFIG_CRC4 is not set
> # CONFIG_CRC7 is not set
> CONFIG_LIBCRC32C=m
> # CONFIG_CRC8 is not set
> CONFIG_XXHASH=y
> # CONFIG_RANDOM32_SELFTEST is not set
> CONFIG_ZLIB_INFLATE=y
> CONFIG_ZLIB_DEFLATE=m
> CONFIG_LZO_COMPRESS=m
> CONFIG_LZO_DECOMPRESS=m
> CONFIG_LZ4_COMPRESS=m
> CONFIG_LZ4_DECOMPRESS=y
> CONFIG_ZSTD_COMPRESS=m
> CONFIG_ZSTD_DECOMPRESS=m
> CONFIG_XZ_DEC=y
> CONFIG_XZ_DEC_X86=y
> # CONFIG_XZ_DEC_POWERPC is not set
> # CONFIG_XZ_DEC_IA64 is not set
> # CONFIG_XZ_DEC_ARM is not set
> # CONFIG_XZ_DEC_ARMTHUMB is not set
> # CONFIG_XZ_DEC_SPARC is not set
> # CONFIG_XZ_DEC_MICROLZMA is not set
> CONFIG_XZ_DEC_BCJ=y
> # CONFIG_XZ_DEC_TEST is not set
> CONFIG_DECOMPRESS_GZIP=y
> CONFIG_DECOMPRESS_LZ4=y
> CONFIG_GENERIC_ALLOCATOR=y
> CONFIG_INTERVAL_TREE=y
> CONFIG_XARRAY_MULTI=y
> CONFIG_ASSOCIATIVE_ARRAY=y
> CONFIG_HAS_IOMEM=y
> CONFIG_HAS_IOPORT_MAP=y
> CONFIG_HAS_DMA=y
> CONFIG_NEED_SG_DMA_LENGTH=y
> CONFIG_NEED_DMA_MAP_STATE=y
> CONFIG_ARCH_DMA_ADDR_T_64BIT=y
> CONFIG_SWIOTLB=y
> # CONFIG_DMA_API_DEBUG is not set
> # CONFIG_DMA_MAP_BENCHMARK is not set
> CONFIG_SGL_ALLOC=y
> CONFIG_CPU_RMAP=y
> CONFIG_DQL=y
> CONFIG_GLOB=y
> # CONFIG_GLOB_SELFTEST is not set
> CONFIG_NLATTR=y
> # CONFIG_IRQ_POLL is not set
> CONFIG_OID_REGISTRY=m
> CONFIG_HAVE_GENERIC_VDSO=y
> CONFIG_GENERIC_GETTIMEOFDAY=y
> CONFIG_GENERIC_VDSO_TIME_NS=y
> CONFIG_SG_POOL=y
> CONFIG_ARCH_HAS_PMEM_API=y
> CONFIG_MEMREGION=y
> CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE=y
> CONFIG_ARCH_HAS_COPY_MC=y
> CONFIG_ARCH_STACKWALK=y
> CONFIG_STACKDEPOT=y
> CONFIG_SBITMAP=y
> # end of Library routines
> 
> #
> # Kernel hacking
> #
> 
> #
> # printk and dmesg options
> #
> CONFIG_PRINTK_TIME=y
> # CONFIG_PRINTK_CALLER is not set
> CONFIG_STACKTRACE_BUILD_ID=y
> CONFIG_CONSOLE_LOGLEVEL_DEFAULT=7
> CONFIG_CONSOLE_LOGLEVEL_QUIET=4
> CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4
> # CONFIG_BOOT_PRINTK_DELAY is not set
> # CONFIG_DYNAMIC_DEBUG is not set
> # CONFIG_DYNAMIC_DEBUG_CORE is not set
> CONFIG_SYMBOLIC_ERRNAME=y
> CONFIG_DEBUG_BUGVERBOSE=y
> # end of printk and dmesg options
> 
> CONFIG_DEBUG_KERNEL=y
> # CONFIG_DEBUG_MISC is not set
> 
> #
> # Compile-time checks and compiler options
> #
> CONFIG_DEBUG_INFO=y
> # CONFIG_DEBUG_INFO_NONE is not set
> # CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT is not set
> # CONFIG_DEBUG_INFO_DWARF4 is not set
> CONFIG_DEBUG_INFO_DWARF5=y
> CONFIG_DEBUG_INFO_REDUCED=y
> # CONFIG_DEBUG_INFO_COMPRESSED is not set
> # CONFIG_DEBUG_INFO_SPLIT is not set
> CONFIG_PAHOLE_HAS_SPLIT_BTF=y
> # CONFIG_GDB_SCRIPTS is not set
> CONFIG_FRAME_WARN=1600
> CONFIG_STRIP_ASM_SYMS=y
> # CONFIG_READABLE_ASM is not set
> # CONFIG_HEADERS_INSTALL is not set
> # CONFIG_DEBUG_SECTION_MISMATCH is not set
> CONFIG_SECTION_MISMATCH_WARN_ONLY=y
> # CONFIG_DEBUG_FORCE_FUNCTION_ALIGN_64B is not set
> CONFIG_OBJTOOL=y
> # CONFIG_VMLINUX_MAP is not set
> # CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
> # end of Compile-time checks and compiler options
> 
> #
> # Generic Kernel Debugging Instruments
> #
> CONFIG_MAGIC_SYSRQ=y
> CONFIG_MAGIC_SYSRQ_DEFAULT_ENABLE=0x1
> CONFIG_MAGIC_SYSRQ_SERIAL=y
> CONFIG_MAGIC_SYSRQ_SERIAL_SEQUENCE=""
> CONFIG_DEBUG_FS=y
> CONFIG_DEBUG_FS_ALLOW_ALL=y
> # CONFIG_DEBUG_FS_DISALLOW_MOUNT is not set
> # CONFIG_DEBUG_FS_ALLOW_NONE is not set
> CONFIG_HAVE_ARCH_KGDB=y
> # CONFIG_KGDB is not set
> CONFIG_ARCH_HAS_UBSAN_SANITIZE_ALL=y
> CONFIG_UBSAN=y
> # CONFIG_UBSAN_TRAP is not set
> CONFIG_CC_HAS_UBSAN_BOUNDS=y
> CONFIG_UBSAN_BOUNDS=y
> CONFIG_UBSAN_ONLY_BOUNDS=y
> CONFIG_UBSAN_SHIFT=y
> CONFIG_UBSAN_DIV_ZERO=y
> CONFIG_UBSAN_BOOL=y
> CONFIG_UBSAN_ENUM=y
> # CONFIG_UBSAN_ALIGNMENT is not set
> # CONFIG_UBSAN_SANITIZE_ALL is not set
> # CONFIG_TEST_UBSAN is not set
> CONFIG_HAVE_ARCH_KCSAN=y
> CONFIG_HAVE_KCSAN_COMPILER=y
> # CONFIG_KCSAN is not set
> # end of Generic Kernel Debugging Instruments
> 
> #
> # Networking Debugging
> #
> # CONFIG_NET_DEV_REFCNT_TRACKER is not set
> # CONFIG_NET_NS_REFCNT_TRACKER is not set
> # CONFIG_DEBUG_NET is not set
> # end of Networking Debugging
> 
> #
> # Memory Debugging
> #
> # CONFIG_PAGE_EXTENSION is not set
> # CONFIG_DEBUG_PAGEALLOC is not set
> CONFIG_SLUB_DEBUG=y
> # CONFIG_SLUB_DEBUG_ON is not set
> # CONFIG_PAGE_OWNER is not set
> # CONFIG_PAGE_TABLE_CHECK is not set
> CONFIG_PAGE_POISONING=y
> # CONFIG_DEBUG_PAGE_REF is not set
> # CONFIG_DEBUG_RODATA_TEST is not set
> CONFIG_ARCH_HAS_DEBUG_WX=y
> CONFIG_DEBUG_WX=y
> CONFIG_GENERIC_PTDUMP=y
> CONFIG_PTDUMP_CORE=y
> # CONFIG_PTDUMP_DEBUGFS is not set
> # CONFIG_DEBUG_OBJECTS is not set
> CONFIG_SHRINKER_DEBUG=y
> CONFIG_HAVE_DEBUG_KMEMLEAK=y
> CONFIG_DEBUG_KMEMLEAK=y
> CONFIG_DEBUG_KMEMLEAK_MEM_POOL_SIZE=16000
> # CONFIG_DEBUG_KMEMLEAK_TEST is not set
> CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF=y
> CONFIG_DEBUG_KMEMLEAK_AUTO_SCAN=y
> CONFIG_DEBUG_STACK_USAGE=y
> CONFIG_SCHED_STACK_END_CHECK=y
> CONFIG_ARCH_HAS_DEBUG_VM_PGTABLE=y
> # CONFIG_DEBUG_VM is not set
> # CONFIG_DEBUG_VM_PGTABLE is not set
> CONFIG_ARCH_HAS_DEBUG_VIRTUAL=y
> # CONFIG_DEBUG_VIRTUAL is not set
> CONFIG_DEBUG_MEMORY_INIT=y
> # CONFIG_DEBUG_PER_CPU_MAPS is not set
> CONFIG_ARCH_SUPPORTS_KMAP_LOCAL_FORCE_MAP=y
> # CONFIG_DEBUG_KMAP_LOCAL_FORCE_MAP is not set
> CONFIG_HAVE_ARCH_KASAN=y
> CONFIG_HAVE_ARCH_KASAN_VMALLOC=y
> CONFIG_CC_HAS_KASAN_GENERIC=y
> CONFIG_CC_HAS_WORKING_NOSANITIZE_ADDRESS=y
> # CONFIG_KASAN is not set
> CONFIG_HAVE_ARCH_KFENCE=y
> # CONFIG_KFENCE is not set
> # end of Memory Debugging
> 
> # CONFIG_DEBUG_SHIRQ is not set
> 
> #
> # Debug Oops, Lockups and Hangs
> #
> # CONFIG_PANIC_ON_OOPS is not set
> CONFIG_PANIC_ON_OOPS_VALUE=0
> CONFIG_PANIC_TIMEOUT=0
> CONFIG_LOCKUP_DETECTOR=y
> CONFIG_SOFTLOCKUP_DETECTOR=y
> # CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
> CONFIG_HARDLOCKUP_DETECTOR_PERF=y
> CONFIG_HARDLOCKUP_CHECK_TIMESTAMP=y
> CONFIG_HARDLOCKUP_DETECTOR=y
> CONFIG_BOOTPARAM_HARDLOCKUP_PANIC=y
> CONFIG_DETECT_HUNG_TASK=y
> CONFIG_DEFAULT_HUNG_TASK_TIMEOUT=120
> # CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
> CONFIG_WQ_WATCHDOG=y
> # CONFIG_TEST_LOCKUP is not set
> # end of Debug Oops, Lockups and Hangs
> 
> #
> # Scheduler Debugging
> #
> CONFIG_SCHED_DEBUG=y
> CONFIG_SCHED_INFO=y
> CONFIG_SCHEDSTATS=y
> # end of Scheduler Debugging
> 
> # CONFIG_DEBUG_TIMEKEEPING is not set
> CONFIG_DEBUG_PREEMPT=y
> 
> #
> # Lock Debugging (spinlocks, mutexes, etc...)
> #
> CONFIG_LOCK_DEBUGGING_SUPPORT=y
> # CONFIG_PROVE_LOCKING is not set
> # CONFIG_LOCK_STAT is not set
> # CONFIG_DEBUG_RT_MUTEXES is not set
> CONFIG_DEBUG_SPINLOCK=y
> CONFIG_DEBUG_MUTEXES=y
> # CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
> CONFIG_DEBUG_RWSEMS=y
> # CONFIG_DEBUG_LOCK_ALLOC is not set
> CONFIG_DEBUG_ATOMIC_SLEEP=y
> # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
> # CONFIG_LOCK_TORTURE_TEST is not set
> # CONFIG_WW_MUTEX_SELFTEST is not set
> # CONFIG_SCF_TORTURE_TEST is not set
> # CONFIG_CSD_LOCK_WAIT_DEBUG is not set
> # end of Lock Debugging (spinlocks, mutexes, etc...)
> 
> # CONFIG_DEBUG_IRQFLAGS is not set
> CONFIG_STACKTRACE=y
> # CONFIG_WARN_ALL_UNSEEDED_RANDOM is not set
> # CONFIG_DEBUG_KOBJECT is not set
> 
> #
> # Debug kernel data structures
> #
> CONFIG_DEBUG_LIST=y
> # CONFIG_DEBUG_PLIST is not set
> # CONFIG_DEBUG_SG is not set
> # CONFIG_DEBUG_NOTIFIERS is not set
> CONFIG_BUG_ON_DATA_CORRUPTION=y
> # end of Debug kernel data structures
> 
> # CONFIG_DEBUG_CREDENTIALS is not set
> 
> #
> # RCU Debugging
> #
> # CONFIG_RCU_SCALE_TEST is not set
> # CONFIG_RCU_TORTURE_TEST is not set
> # CONFIG_RCU_REF_SCALE_TEST is not set
> CONFIG_RCU_CPU_STALL_TIMEOUT=60
> CONFIG_RCU_EXP_CPU_STALL_TIMEOUT=0
> # CONFIG_RCU_TRACE is not set
> # CONFIG_RCU_EQS_DEBUG is not set
> # end of RCU Debugging
> 
> # CONFIG_DEBUG_WQ_FORCE_RR_CPU is not set
> # CONFIG_CPU_HOTPLUG_STATE_CONTROL is not set
> CONFIG_LATENCYTOP=y
> CONFIG_USER_STACKTRACE_SUPPORT=y
> CONFIG_NOP_TRACER=y
> CONFIG_HAVE_RETHOOK=y
> CONFIG_RETHOOK=y
> CONFIG_HAVE_FUNCTION_TRACER=y
> CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
> CONFIG_HAVE_DYNAMIC_FTRACE=y
> CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
> CONFIG_HAVE_DYNAMIC_FTRACE_WITH_DIRECT_CALLS=y
> CONFIG_HAVE_DYNAMIC_FTRACE_WITH_ARGS=y
> CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
> CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
> CONFIG_HAVE_FENTRY=y
> CONFIG_HAVE_OBJTOOL_MCOUNT=y
> CONFIG_HAVE_C_RECORDMCOUNT=y
> CONFIG_HAVE_BUILDTIME_MCOUNT_SORT=y
> CONFIG_BUILDTIME_MCOUNT_SORT=y
> CONFIG_TRACE_CLOCK=y
> CONFIG_RING_BUFFER=y
> CONFIG_EVENT_TRACING=y
> CONFIG_CONTEXT_SWITCH_TRACER=y
> CONFIG_TRACING=y
> CONFIG_GENERIC_TRACER=y
> CONFIG_TRACING_SUPPORT=y
> CONFIG_FTRACE=y
> CONFIG_BOOTTIME_TRACING=y
> CONFIG_FUNCTION_TRACER=y
> CONFIG_FUNCTION_GRAPH_TRACER=y
> CONFIG_DYNAMIC_FTRACE=y
> CONFIG_DYNAMIC_FTRACE_WITH_REGS=y
> CONFIG_DYNAMIC_FTRACE_WITH_DIRECT_CALLS=y
> CONFIG_DYNAMIC_FTRACE_WITH_ARGS=y
> # CONFIG_FPROBE is not set
> # CONFIG_FUNCTION_PROFILER is not set
> # CONFIG_STACK_TRACER is not set
> # CONFIG_IRQSOFF_TRACER is not set
> # CONFIG_PREEMPT_TRACER is not set
> # CONFIG_SCHED_TRACER is not set
> # CONFIG_HWLAT_TRACER is not set
> # CONFIG_OSNOISE_TRACER is not set
> # CONFIG_TIMERLAT_TRACER is not set
> # CONFIG_MMIOTRACE is not set
> CONFIG_FTRACE_SYSCALLS=y
> # CONFIG_TRACER_SNAPSHOT is not set
> CONFIG_BRANCH_PROFILE_NONE=y
> # CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
> CONFIG_BLK_DEV_IO_TRACE=y
> CONFIG_KPROBE_EVENTS=y
> # CONFIG_KPROBE_EVENTS_ON_NOTRACE is not set
> CONFIG_UPROBE_EVENTS=y
> CONFIG_BPF_EVENTS=y
> CONFIG_DYNAMIC_EVENTS=y
> CONFIG_PROBE_EVENTS=y
> CONFIG_BPF_KPROBE_OVERRIDE=y
> CONFIG_FTRACE_MCOUNT_RECORD=y
> CONFIG_FTRACE_MCOUNT_USE_CC=y
> # CONFIG_SYNTH_EVENTS is not set
> # CONFIG_HIST_TRIGGERS is not set
> # CONFIG_TRACE_EVENT_INJECT is not set
> # CONFIG_TRACEPOINT_BENCHMARK is not set
> # CONFIG_RING_BUFFER_BENCHMARK is not set
> # CONFIG_TRACE_EVAL_MAP_FILE is not set
> # CONFIG_FTRACE_RECORD_RECURSION is not set
> # CONFIG_FTRACE_STARTUP_TEST is not set
> # CONFIG_FTRACE_SORT_STARTUP_TEST is not set
> # CONFIG_RING_BUFFER_STARTUP_TEST is not set
> # CONFIG_RING_BUFFER_VALIDATE_TIME_DELTAS is not set
> # CONFIG_PREEMPTIRQ_DELAY_TEST is not set
> # CONFIG_KPROBE_EVENT_GEN_TEST is not set
> # CONFIG_RV is not set
> # CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
> CONFIG_SAMPLES=y
> # CONFIG_SAMPLE_AUXDISPLAY is not set
> CONFIG_SAMPLE_TRACE_EVENTS=m
> # CONFIG_SAMPLE_TRACE_CUSTOM_EVENTS is not set
> CONFIG_SAMPLE_TRACE_PRINTK=m
> # CONFIG_SAMPLE_FTRACE_DIRECT is not set
> # CONFIG_SAMPLE_FTRACE_DIRECT_MULTI is not set
> # CONFIG_SAMPLE_TRACE_ARRAY is not set
> CONFIG_SAMPLE_KOBJECT=m
> CONFIG_SAMPLE_KPROBES=m
> CONFIG_SAMPLE_KRETPROBES=m
> # CONFIG_SAMPLE_HW_BREAKPOINT is not set
> # CONFIG_SAMPLE_KFIFO is not set
> # CONFIG_SAMPLE_CONFIGFS is not set
> # CONFIG_SAMPLE_WATCHDOG is not set
> CONFIG_HAVE_SAMPLE_FTRACE_DIRECT=y
> CONFIG_HAVE_SAMPLE_FTRACE_DIRECT_MULTI=y
> CONFIG_ARCH_HAS_DEVMEM_IS_ALLOWED=y
> CONFIG_STRICT_DEVMEM=y
> CONFIG_IO_STRICT_DEVMEM=y
> 
> #
> # x86 Debugging
> #
> # CONFIG_X86_VERBOSE_BOOTUP is not set
> CONFIG_EARLY_PRINTK=y
> # CONFIG_EARLY_PRINTK_DBGP is not set
> # CONFIG_EARLY_PRINTK_USB_XDBC is not set
> # CONFIG_DEBUG_TLBFLUSH is not set
> CONFIG_HAVE_MMIOTRACE_SUPPORT=y
> # CONFIG_X86_DECODER_SELFTEST is not set
> # CONFIG_IO_DELAY_0X80 is not set
> CONFIG_IO_DELAY_0XED=y
> # CONFIG_IO_DELAY_UDELAY is not set
> # CONFIG_IO_DELAY_NONE is not set
> # CONFIG_DEBUG_BOOT_PARAMS is not set
> # CONFIG_CPA_DEBUG is not set
> # CONFIG_DEBUG_ENTRY is not set
> # CONFIG_DEBUG_NMI_SELFTEST is not set
> # CONFIG_X86_DEBUG_FPU is not set
> # CONFIG_PUNIT_ATOM_DEBUG is not set
> CONFIG_UNWINDER_ORC=y
> # CONFIG_UNWINDER_FRAME_POINTER is not set
> # end of x86 Debugging
> 
> #
> # Kernel Testing and Coverage
> #
> # CONFIG_KUNIT is not set
> # CONFIG_NOTIFIER_ERROR_INJECTION is not set
> CONFIG_FUNCTION_ERROR_INJECTION=y
> CONFIG_FAULT_INJECTION=y
> # CONFIG_FAILSLAB is not set
> # CONFIG_FAIL_PAGE_ALLOC is not set
> # CONFIG_FAULT_INJECTION_USERCOPY is not set
> CONFIG_FAIL_MAKE_REQUEST=y
> # CONFIG_FAIL_IO_TIMEOUT is not set
> # CONFIG_FAIL_FUTEX is not set
> CONFIG_FAULT_INJECTION_DEBUG_FS=y
> # CONFIG_FAIL_FUNCTION is not set
> # CONFIG_FAIL_SUNRPC is not set
> CONFIG_ARCH_HAS_KCOV=y
> CONFIG_CC_HAS_SANCOV_TRACE_PC=y
> # CONFIG_KCOV is not set
> # CONFIG_RUNTIME_TESTING_MENU is not set
> CONFIG_ARCH_USE_MEMTEST=y
> # CONFIG_MEMTEST is not set
> # end of Kernel Testing and Coverage
> # end of Kernel hacking
