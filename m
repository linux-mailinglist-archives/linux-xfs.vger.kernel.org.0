Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0185FFFBD
	for <lists+linux-xfs@lfdr.de>; Sun, 16 Oct 2022 16:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbiJPOFh (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 16 Oct 2022 10:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiJPOFg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 16 Oct 2022 10:05:36 -0400
Received: from mail1.bemta34.messagelabs.com (mail1.bemta34.messagelabs.com [195.245.231.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E8822F643;
        Sun, 16 Oct 2022 07:05:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fujitsu.com;
        s=170520fj; t=1665929130; i=@fujitsu.com;
        bh=UF5pvAkURl7RmfocPLT7PSgtA8wwWq9yT0FQtMyfEQ4=;
        h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
         In-Reply-To:Content-Type:Content-Transfer-Encoding;
        b=Fb9mDSsJ6SASpKokx8XGftRyXT29bnvqp5oip/T/59FJyTgIOD5Y6CLM2KExpBEGF
         HnTMdBL9JkurLr6ReVcFah9j243rqG8kGEslJCJLOlIHCnfGszVAmKV1oNzLLpPtNp
         xjIwdcBlwjQ6A2BSwPNdffhCImJHUw5S9w7xfYVPo2dvqWDT9yGM+cnu0HugSUDNEL
         onevU9zWezHkS+tm53jhhRTLqw6hkOThrExOGM59kXtRfF3Smhu/IDrae3HBspCyZy
         vd/2GDCBFd3rrmDTtRjZjuTv6lJWqkvIKbaoRkshy29CwVKvMpRlU2pEFptNqYMZqJ
         AIDcKjRpUrghQ==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBKsWRWlGSWpSXmKPExsViZ8MxSXcFv0+
  ywcpr4hbTp15gtNhy7B6jxeUnfBZ79p5ksbi8aw6bxb01/1ktdv3ZwW6x8scfVgcOj1OLJDwW
  73nJ5LFpVSebx6ZPk9g9XmyeyejxeZNcAFsUa2ZeUn5FAmvGg9c7mQue11VsbJrB1MC4O72Lk
  YtDSGALo8SdSf9YIZzlTBI3111nhsssP7AcyOHk4BWwk2jovMAIYrMIqErcvNsBFReUODnzCQ
  uILSqQLPF16kUmEFtYwFHi1dQWsHoRAU2JI9+uMYEMZRa4xChx734z1IZHzBJPF61jA6liE9C
  RuLDgLyuIzSmgIbGooQGsm1nAQmLxm4PsELa8RPPW2WCbJQQUJK4fa4CyKyRmzWpjgrDVJK6e
  28Q8gVFoFpIDZyEZNQvJqAWMzKsYzYpTi8pSi3QNTfSSijLTM0pyEzNz9BKrdBP1Ukt1y1OLS
  3SN9BLLi/VSi4v1iitzk3NS9PJSSzYxAqMspVilfQfjp2V/9A4xSnIwKYnyZmzxTBbiS8pPqc
  xILM6ILyrNSS0+xCjDwaEkwXuQ2ydZSLAoNT21Ii0zBxjxMGkJDh4lEd697EBp3uKCxNzizHS
  I1ClGe461DQf2MnNseAAir165AiSnzv63n1mIJS8/L1VKnLebD6hNAKQtozQPbigsQV1ilJUS
  5mVkYGAQ4ilILcrNLEGVf8UozsGoJMyrxwk0hSczrwRu9yugs5iAzsrY7wVyVkkiQkqqgYmrJ
  9DyTWjaAeVLIlqc4ZnzVe8dEZyqEt5VxH2GsWxi12PLP63trKEr8sTOGSg9ey2zbsnuR291r0
  n5fWYJjOk4qBI2+2e7+sK+HSce3ebb9znVcVbsUYGKioOPv89z8dbKU/oteLX+g/+T1+17+L6
  y/eIq6fbbvL+DS9TTOTXm2bNs01tHYl5p2eQtW9N9rnnxeXtTsf8nrjVtymzJqOOvWBO3fRqr
  NmfN9QqvL/nHp12dsVf7xNT/ezNE7zTtnbp2ateH6GU103LUdarKxJR6Arl11X5Ou1piHhnNc
  WWZkdmRW3d/89qdmzSjva6Q9wRrir3f9avX2mpDbNq3TGbfGi5kf+fAQc1jz2QKLJRYijMSDb
  WYi4oTAf6d5mzLAwAA
X-Env-Sender: ruansy.fnst@fujitsu.com
X-Msg-Ref: server-10.tower-565.messagelabs.com!1665929128!140028!1
X-Originating-IP: [62.60.8.146]
X-SYMC-ESS-Client-Auth: outbound-route-from=pass
X-StarScan-Received: 
X-StarScan-Version: 9.87.3; banners=-,-,-
X-VirusChecked: Checked
Received: (qmail 3104 invoked from network); 16 Oct 2022 14:05:28 -0000
Received: from unknown (HELO n03ukasimr02.n03.fujitsu.local) (62.60.8.146)
  by server-10.tower-565.messagelabs.com with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP; 16 Oct 2022 14:05:28 -0000
Received: from n03ukasimr02.n03.fujitsu.local (localhost [127.0.0.1])
        by n03ukasimr02.n03.fujitsu.local (Postfix) with ESMTP id 0F2731000C1;
        Sun, 16 Oct 2022 15:05:28 +0100 (BST)
Received: from R01UKEXCASM126.r01.fujitsu.local (R01UKEXCASM126 [10.183.43.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by n03ukasimr02.n03.fujitsu.local (Postfix) with ESMTPS id 003A0100078;
        Sun, 16 Oct 2022 15:05:27 +0100 (BST)
Received: from [10.167.201.5] (10.167.201.5) by
 R01UKEXCASM126.r01.fujitsu.local (10.183.43.178) with Microsoft SMTP Server
 (TLS) id 15.0.1497.32; Sun, 16 Oct 2022 15:05:24 +0100
Message-ID: <dce214fe-c0f8-894c-c172-0c8372974d3e@fujitsu.com>
Date:   Sun, 16 Oct 2022 22:05:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [RFC PATCH] xfs: drop experimental warning for fsdax
To:     "Darrick J. Wong" <djwong@kernel.org>
CC:     Dave Chinner <david@fromorbit.com>, <linux-kernel@vger.kernel.org>,
        <linux-xfs@vger.kernel.org>, <nvdimm@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-fsdevel@vger.kernel.org>,
        <dan.j.williams@intel.com>
References: <1663234002-17-1-git-send-email-ruansy.fnst@fujitsu.com>
 <20220919045003.GJ3600936@dread.disaster.area>
 <20220919211533.GK3600936@dread.disaster.area>
 <f10de555-370b-f236-1107-e3089258ebbc@fujitsu.com>
 <YzMeqNg56v0/t/8x@magnolia> <20220927235129.GC3600936@dread.disaster.area>
 <2428b01d-afc7-7b33-1088-e34d68029e19@fujitsu.com>
 <YzXsavOWMSuwTBEC@magnolia> <Y0hZYCL3+no9qSSW@magnolia>
 <49f0cef6-d27e-2dee-dba6-4af17ca76d41@fujitsu.com>
 <Y0mFX1pAYhyPgv37@magnolia>
From:   Shiyang Ruan <ruansy.fnst@fujitsu.com>
In-Reply-To: <Y0mFX1pAYhyPgv37@magnolia>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.167.201.5]
X-ClientProxiedBy: G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) To
 R01UKEXCASM126.r01.fujitsu.local (10.183.43.178)
X-Virus-Scanned: ClamAV using ClamSMTP
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



在 2022/10/14 23:50, Darrick J. Wong 写道:
> On Fri, Oct 14, 2022 at 10:24:29AM +0800, Shiyang Ruan wrote:
>>
>>
>> 在 2022/10/14 2:30, Darrick J. Wong 写道:
>>> On Thu, Sep 29, 2022 at 12:05:14PM -0700, Darrick J. Wong wrote:
>>>> On Wed, Sep 28, 2022 at 10:46:17PM +0800, Shiyang Ruan wrote:
>>>>>
>> ...
>>>>>>
>>>>>>> FWIW I saw dmesg failures in xfs/517 and xfs/013 starting with 6.0-rc5,
>>>>>>> and I haven't even turned on reflink yet:
>>>>>>>
>>>>>>> run fstests xfs/517 at 2022-09-26 19:53:34
>>>>>>> XFS (pmem1): EXPERIMENTAL Large extent counts feature in use. Use at your own risk!
>>>>>>> XFS (pmem1): Mounting V5 Filesystem
>>>>>>> XFS (pmem1): Ending clean mount
>>>>>>> XFS (pmem1): Quotacheck needed: Please wait.
>>>>>>> XFS (pmem1): Quotacheck: Done.
>>>>>>> XFS (pmem1): Unmounting Filesystem
>>>>>>> XFS (pmem0): EXPERIMENTAL online scrub feature in use. Use at your own risk!
>>>>>>> XFS (pmem1): EXPERIMENTAL Large extent counts feature in use. Use at your own risk!
>>>>>>> XFS (pmem1): Mounting V5 Filesystem
>>>>>>> XFS (pmem1): Ending clean mount
>>>>>>> XFS (pmem1): Quotacheck needed: Please wait.
>>>>>>> XFS (pmem1): Quotacheck: Done.
>>>>>>> ------------[ cut here ]------------
>>>>>>> WARNING: CPU: 1 PID: 415317 at fs/dax.c:380 dax_insert_entry+0x22d/0x320
>>>
>>> Ping?
>>>
>>> This time around I replaced the WARN_ON with this:
>>>
>>> 	if (page->mapping)
>>> 		printk(KERN_ERR "%s:%d ino 0x%lx index 0x%lx page 0x%llx mapping 0x%llx <- 0x%llx\n", __func__, __LINE__, mapping->host->i_ino, index + i, (unsigned long long)page, (unsigned long long)page->mapping, (unsigned long long)mapping);
>>>
>>> and promptly started seeing scary things like this:
>>>
>>> [   37.576598] dax_associate_entry:381 ino 0x1807870 index 0x370 page 0xffffea00133f1480 mapping 0x1 <- 0xffff888042fbb528
>>> [   37.577570] dax_associate_entry:381 ino 0x1807870 index 0x371 page 0xffffea00133f1500 mapping 0x1 <- 0xffff888042fbb528
>>> [   37.698657] dax_associate_entry:381 ino 0x180044a index 0x5f8 page 0xffffea0013244900 mapping 0xffff888042eaf128 <- 0xffff888042dda128
>>> [   37.699349] dax_associate_entry:381 ino 0x800808 index 0x136 page 0xffffea0013245640 mapping 0xffff888042eaf128 <- 0xffff888042d3ce28
>>> [   37.699680] dax_associate_entry:381 ino 0x180044a index 0x5f9 page 0xffffea0013245680 mapping 0xffff888042eaf128 <- 0xffff888042dda128
>>> [   37.700684] dax_associate_entry:381 ino 0x800808 index 0x137 page 0xffffea00132456c0 mapping 0xffff888042eaf128 <- 0xffff888042d3ce28
>>> [   37.701611] dax_associate_entry:381 ino 0x180044a index 0x5fa page 0xffffea0013245700 mapping 0xffff888042eaf128 <- 0xffff888042dda128
>>> [   37.764126] dax_associate_entry:381 ino 0x103c52c index 0x28a page 0xffffea001345afc0 mapping 0x1 <- 0xffff888019c14928
>>> [   37.765078] dax_associate_entry:381 ino 0x103c52c index 0x28b page 0xffffea001345b000 mapping 0x1 <- 0xffff888019c14928
>>> [   39.193523] dax_associate_entry:381 ino 0x184657f index 0x124 page 0xffffea000e2a4440 mapping 0xffff8880120d7628 <- 0xffff888019ca3528
>>> [   39.194692] dax_associate_entry:381 ino 0x184657f index 0x125 page 0xffffea000e2a4480 mapping 0xffff8880120d7628 <- 0xffff888019ca3528
>>> [   39.195716] dax_associate_entry:381 ino 0x184657f index 0x126 page 0xffffea000e2a44c0 mapping 0xffff8880120d7628 <- 0xffff888019ca3528
>>> [   39.196736] dax_associate_entry:381 ino 0x184657f index 0x127 page 0xffffea000e2a4500 mapping 0xffff8880120d7628 <- 0xffff888019ca3528
>>> [   39.197906] dax_associate_entry:381 ino 0x184657f index 0x128 page 0xffffea000e2a5040 mapping 0xffff8880120d7628 <- 0xffff888019ca3528
>>> [   39.198924] dax_associate_entry:381 ino 0x184657f index 0x129 page 0xffffea000e2a5080 mapping 0xffff8880120d7628 <- 0xffff888019ca3528
>>> [   39.247053] dax_associate_entry:381 ino 0x5dd1e index 0x2d page 0xffffea0015a0e640 mapping 0x1 <- 0xffff88804af88828
>>> [   39.248006] dax_associate_entry:381 ino 0x5dd1e index 0x2e page 0xffffea0015a0e680 mapping 0x1 <- 0xffff88804af88828
>>> [   39.490880] dax_associate_entry:381 ino 0x1a9dc index 0x7d page 0xffffea000e7012c0 mapping 0xffff888042fd1728 <- 0xffff88804afaec28
>>> [   39.492038] dax_associate_entry:381 ino 0x1a9dc index 0x7e page 0xffffea000e701300 mapping 0xffff888042fd1728 <- 0xffff88804afaec28
>>> [   39.493099] dax_associate_entry:381 ino 0x1a9dc index 0x7f page 0xffffea000e701340 mapping 0xffff888042fd1728 <- 0xffff88804afaec28
>>> [   40.926247] dax_associate_entry:381 ino 0x182e265 index 0x54c page 0xffffea0015da0840 mapping 0x1 <- 0xffff888019c0dd28
>>> [   41.675459] dax_associate_entry:381 ino 0x15e5d index 0x29 page 0xffffea000e4350c0 mapping 0x1 <- 0xffff888019c05828
>>> [   41.676418] dax_associate_entry:381 ino 0x15e5d index 0x2a page 0xffffea000e435100 mapping 0x1 <- 0xffff888019c05828
>>> [   41.677352] dax_associate_entry:381 ino 0x15e5d index 0x2b page 0xffffea000e435180 mapping 0x1 <- 0xffff888019c05828
>>> [   41.678372] dax_associate_entry:381 ino 0x15e5d index 0x2c page 0xffffea000e4351c0 mapping 0x1 <- 0xffff888019c05828
>>> [   41.965026] dax_associate_entry:381 ino 0x185adb4 index 0x87 page 0xffffea000e616d00 mapping 0x1 <- 0xffff88801a83b528
>>> [   41.966065] dax_associate_entry:381 ino 0x185adb4 index 0x88 page 0xffffea000e616d40 mapping 0x1 <- 0xffff88801a83b528
>>> [   43.565384] dax_associate_entry:381 ino 0x804d9d index 0x229 page 0xffffea0013653fc0 mapping 0x1 <- 0xffff88804bd97128
>>> [   43.566399] dax_associate_entry:381 ino 0x804d9d index 0x22a page 0xffffea0013654000 mapping 0x1 <- 0xffff88804bd97128
>>> [   43.567343] dax_associate_entry:381 ino 0x804d9d index 0x22b page 0xffffea0013654040 mapping 0x1 <- 0xffff88804bd97128
>>> [   45.512017] dax_associate_entry:381 ino 0x18192bb index 0x1f page 0xffffea00133f1300 mapping 0x1 <- 0xffff88804bcdb528
>>> [   45.512974] dax_associate_entry:381 ino 0x18192bb index 0x20 page 0xffffea00133f1340 mapping 0x1 <- 0xffff88804bcdb528
>>> [   45.513942] dax_associate_entry:381 ino 0x18192bb index 0x21 page 0xffffea00133f1380 mapping 0x1 <- 0xffff88804bcdb528
>>> [   45.514857] dax_associate_entry:381 ino 0x18192bb index 0x22 page 0xffffea00133f13c0 mapping 0x1 <- 0xffff88804bcdb528
>>> [   45.515760] dax_associate_entry:381 ino 0x18192bb index 0x23 page 0xffffea00133f1400 mapping 0x1 <- 0xffff88804bcdb528
>>> [   45.516673] dax_associate_entry:381 ino 0x18192bb index 0x24 page 0xffffea00133f1440 mapping 0x1 <- 0xffff88804bcdb528
>>>
>>> I'm not sure what's going on here, but we're clearly turning COW daxpages
>>> back into single-mapping daxpages.  I'm not sure what's going on for the
>>> cases where we're replacing one mapping with another.  My dimwitted
>>> guess is that dax_fault_is_cow() is incorrectly returning false in some
>>> cases.
>>>
>>> Replacing the contents of that function with:
>>>
>>> 	if (iter->srcmap.type != IOMAP_HOLE)
>>> 		return true;
>>> 	if (iter->iomap.flags & IOMAP_F_SHARED)
>>> 		return true;
>>> 	return false;
>>>
>>> Doesn't make the errors go away.  Curiously, replacing the entire
>>> function body with "return true;" fixes /that/ problem though...
>>
>> I am looking into this error by adding debug message too.  I found that
>> testcases which execute fsstress will randomly occur this error.  I'm
>> guessing some concurrent operations caused the cow flag (returned by
>> dax_fault_is_cow()) to be incorrectly judged.  But still haven't catch the
>> exactly operation yet.
> 
> I have an offhand guess that the following sequence might reproduce it:
> 
> <write data to a fsdax file1>
> 
> <process 1 maps file1, which sets up the pagecache mapping to pmem, and
> goes to sleep>
> 
> cp --reflink=always file1 file2
> 
> <process 2 maps file2, which tries to map the same pmem "page" into
> file2's pagecache and trips over page->mapping already being set to
> file1's pagecache>
> 
> But I dunno, I haven't had much time for digging into this one.

I tried this sequence on v6.0 but it didn't reproduce the warning.

> 
>>> ...but generic/649 still fails with things like:
>>>
>>> [  571.224285] run fstests generic/649 at 2022-10-13 11:26:59
>>> [  571.796353] XFS (pmem0): Mounting V5 Filesystem
>>> [  571.799059] XFS (pmem0): Ending clean mount
>>> [  572.378624] ------------[ cut here ]------------
>>> [  572.379598] WARNING: CPU: 1 PID: 48538 at fs/dax.c:930 dax_writeback_mapping_range+0x2f1/0x600
>>>
>>> Which comes from this warning in dax_writeback_one:
>>>
>>> 	/*
>>> 	 * A page got tagged dirty in DAX mapping? Something is seriously
>>> 	 * wrong.
>>> 	 */
>>> 	if (WARN_ON(!xa_is_value(entry)))
>>> 		return -EIO;
>>>
>>> Help?
>>
>> Sorry, no time for this yet...
>>
>> BTW, are these errors still occur when reflink is turned off? (dax on,
>> reflink off)
> 
> Hmm I'll try that later today.

Forgot to tell you that I have tested dax_on&reflink_off with the Kernel 
Config which you sent to me: no failure case caused by the dmesg warning.


--
Thanks,
Ruan.

> 
> --D
> 
>>
>> --
>> Thanks,
>> Ruan.
>>
>>>
>>> --D
>>>
>>>>>>> Modules linked in: xfs nft_chain_nat xt_REDIRECT nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_tcpudp ip_set_hash_ip ip_set_hash_net xt_set nft_compat ip_set_hash_mac ip_set nf_tables libcrc32c bfq nfnetlink pvpanic_mmio pvpanic nd_pmem dax_pmem nd_btt sch_fq_codel fuse configfs ip_tables x_tables overlay nfsv4 af_packet [last unloaded: scsi_d
>>>>>>>
>>>>>>> CPU: 1 PID: 415317 Comm: fsstress Tainted: G        W          6.0.0-rc7-xfsx #rc7 727341edbd0773a36b78b09dab448fa1896eb3a5
>>>>>>> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1 04/01/2014
>>>>>>> RIP: 0010:dax_insert_entry+0x22d/0x320
>>>>>>> Code: e0 48 83 c4 20 5b 5d 41 5c 41 5d 41 5e 41 5f c3 48 8b 58 20 48 8d 53 01 e9 62 ff ff ff 48 8b 58 20 48 8d 53 01 e9 4d ff ff ff <0f> 0b e9 6d ff ff ff 31 f6 48 89 ef e8 72 74 12 00 eb a1 83 e0 02
>>>>>>> RSP: 0000:ffffc90004693b28 EFLAGS: 00010002
>>>>>>> RAX: ffffea0010a20480 RBX: 0000000000000001 RCX: 0000000000000001
>>>>>>> RDX: ffffea0000000000 RSI: 0000000000000033 RDI: ffffea0010a204c0
>>>>>>> RBP: ffffc90004693c08 R08: 0000000000000000 R09: 0000000000000000
>>>>>>> R10: ffff88800c226228 R11: 0000000000000001 R12: 0000000000000011
>>>>>>> R13: ffff88800c226228 R14: ffffc90004693e08 R15: 0000000000000000
>>>>>>> FS:  00007f3aad8db740(0000) GS:ffff88803ed00000(0000) knlGS:0000000000000000
>>>>>>> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>>>>> CR2: 00007f3aad8d1000 CR3: 0000000043104003 CR4: 00000000001706e0
>>>>>>> Call Trace:
>>>>>>>     <TASK>
>>>>>>>     dax_fault_iter+0x26e/0x670
>>>>>>>     dax_iomap_pte_fault+0x1ab/0x3e0
>>>>>>>     __xfs_filemap_fault+0x32f/0x5a0 [xfs c617487f99e14abfa5deb24e923415b927df3d4b]
>>>>>>>     __do_fault+0x30/0x1e0
>>>>>>>     do_fault+0x316/0x6d0
>>>>>>>     ? mmap_region+0x2a5/0x620
>>>>>>>     __handle_mm_fault+0x649/0x1250
>>>>>>>     handle_mm_fault+0xc1/0x220
>>>>>>>     do_user_addr_fault+0x1ac/0x610
>>>>>>>     ? _copy_to_user+0x63/0x80
>>>>>>>     exc_page_fault+0x63/0x130
>>>>>>>     asm_exc_page_fault+0x22/0x30
>>>>>>> RIP: 0033:0x7f3aada7f1ca
>>>>>>> Code: c5 fe 7f 07 c5 fe 7f 47 20 c5 fe 7f 47 40 c5 fe 7f 47 60 c5 f8 77 c3 66 0f 1f 84 00 00 00 00 00 40 0f b6 c6 48 89 d1 48 89 fa <f3> aa 48 89 d0 c5 f8 77 c3 66 66 2e 0f 1f 84 00 00 00 00 00 66 90
>>>>>>> RSP: 002b:00007ffe47afa688 EFLAGS: 00010206
>>>>>>> RAX: 000000000000002e RBX: 0000000000033000 RCX: 000000000000999c
>>>>>>> RDX: 00007f3aad8d1000 RSI: 000000000000002e RDI: 00007f3aad8d1000
>>>>>>> RBP: 0000558851e13240 R08: 0000000000000000 R09: 0000000000033000
>>>>>>> R10: 0000000000000008 R11: 0000000000000246 R12: 028f5c28f5c28f5c
>>>>>>> R13: 8f5c28f5c28f5c29 R14: 000000000000999c R15: 0000000000001c81
>>>>>>>     </TASK>
>>>>>>> ---[ end trace 0000000000000000 ]---
>>>>>>> XFS (pmem0): Unmounting Filesystem
>>>>>>> XFS (pmem1): EXPERIMENTAL online scrub feature in use. Use at your own risk!
>>>>>>> XFS (pmem1): *** REPAIR SUCCESS ino 0x80 type probe agno 0x0 inum 0x0 gen 0x0 flags 0x80000001 error 0
>>>>>>> XFS (pmem1): Unmounting Filesystem
>>>>>>> XFS (pmem1): EXPERIMENTAL Large extent counts feature in use. Use at your own risk!
>>>>>>> XFS (pmem1): Mounting V5 Filesystem
>>>>>>> XFS (pmem1): Ending clean mount
>>>>>>> XFS (pmem1): Unmounting Filesystem
>>>>>>
>>>>>> Yup, that's the same as what I'm seeing.
>>>>>
>>>>> Could you send me your kernel config (or other configs needed for the test)?
>>>>> I still cannot reproduce this warning when reflink is off, even without this
>>>>> drop patch.  Maybe something different in config file?
>>>>>
>>>>>
>>>>> PS: I specifically tried the two cases Darrick mentioned (on v6.0-rc6):
>>>>>
>>>>> [root@f33 xfstests-dev]# mkfs.xfs -m reflink=0,rmapbt=1 /dev/pmem0.1 -f
>>>>> meta-data=/dev/pmem0.1           isize=512    agcount=4, agsize=257920 blks
>>>>>            =                       sectsz=4096  attr=2, projid32bit=1
>>>>>            =                       crc=1        finobt=1, sparse=1, rmapbt=1
>>>>>            =                       reflink=0    bigtime=1 inobtcount=1
>>>>> nrext64=0
>>>>> data     =                       bsize=4096   blocks=1031680, imaxpct=25
>>>>>            =                       sunit=0      swidth=0 blks
>>>>> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
>>>>> log      =internal log           bsize=4096   blocks=16384, version=2
>>>>>            =                       sectsz=4096  sunit=1 blks, lazy-count=1
>>>>> realtime =none                   extsz=4096   blocks=0, rtextents=0
>>>>> [root@f33 xfstests-dev]# mkfs.xfs -m reflink=0,rmapbt=1 /dev/pmem0 -f
>>>>> meta-data=/dev/pmem0             isize=512    agcount=4, agsize=257920 blks
>>>>>            =                       sectsz=4096  attr=2, projid32bit=1
>>>>>            =                       crc=1        finobt=1, sparse=1, rmapbt=1
>>>>>            =                       reflink=0    bigtime=1 inobtcount=1
>>>>> nrext64=0
>>>>> data     =                       bsize=4096   blocks=1031680, imaxpct=25
>>>>>            =                       sunit=0      swidth=0 blks
>>>>> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
>>>>> log      =internal log           bsize=4096   blocks=16384, version=2
>>>>>            =                       sectsz=4096  sunit=1 blks, lazy-count=1
>>>>> realtime =none                   extsz=4096   blocks=0, rtextents=0
>>>>> [root@f33 xfstests-dev]# ./check xfs/013 xfs/517
>>>>> FSTYP         -- xfs (debug)
>>>>> PLATFORM      -- Linux/x86_64 f33 6.0.0-rc6 #84 SMP PREEMPT_DYNAMIC Wed Sep
>>>>> 28 18:27:33 CST 2022
>>>>> MKFS_OPTIONS  -- -f -m reflink=0,rmapbt=1 /dev/pmem0.1
>>>>> MOUNT_OPTIONS -- -o dax -o context=system_u:object_r:root_t:s0 /dev/pmem0.1
>>>>> /mnt/scratch
>>>>>
>>>>> xfs/013 127s ...  166s
>>>>> xfs/517 66s ...  66s
>>>>> Ran: xfs/013 xfs/517
>>>>> Passed all 2 tests
>>>>
>>>> I'm not sure what exactly is going weird here -- I tried it on my dev
>>>> machine just now and it passed, but the similarly configured testcloud
>>>> failed it last night.
>>>>
>>>> FSTYP         -- xfs (debug)
>>>> PLATFORM      -- Linux/x86_64 ca-nfsdev6-mtr03 6.0.0-rc7-xfsx #rc7 SMP
>>>> PREEMPT_DYNAMIC Wed Sep 28 15:35:58 PDT 2022
>>>> MKFS_OPTIONS  -- -f -m reflink=0, -d daxinherit=1, /dev/pmem1
>>>> MOUNT_OPTIONS -- -o usrquota,grpquota,prjquota, /dev/pmem1 /opt
>>>>
>>>> Note that I use libvirt to configure pmem in the VMs.  This is an
>>>> excerpt of the end of domain xml file:
>>>>
>>>>       <memory model='nvdimm' access='shared'>
>>>>         <source>
>>>>           <path>/run/mtrdisk/g.mem</path>
>>>>         </source>
>>>>         <target>
>>>>           <size unit='KiB'>21104640</size>
>>>>           <node>0</node>
>>>>         </target>
>>>>         <address type='dimm' slot='0'/>
>>>>       </memory>
>>>>       <memory model='nvdimm' access='shared'>
>>>>         <source>
>>>>           <path>/run/mtrdisk/h.mem</path>
>>>>         </source>
>>>>         <target>
>>>>           <size unit='KiB'>21104640</size>
>>>>           <node>1</node>
>>>>         </target>
>>>>         <address type='dimm' slot='1'/>
>>>>       </memory>
>>>>     </devices>
>>>> </domain>
>>>>
>>>> --D
>>>>
