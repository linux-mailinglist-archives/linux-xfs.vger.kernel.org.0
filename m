Return-Path: <linux-xfs+bounces-8676-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EA6E98CF6DC
	for <lists+linux-xfs@lfdr.de>; Mon, 27 May 2024 01:52:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6B9221F219A7
	for <lists+linux-xfs@lfdr.de>; Sun, 26 May 2024 23:52:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84D2822066;
	Sun, 26 May 2024 23:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="qcjEp7t9";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="pHDUIqFf"
X-Original-To: linux-xfs@vger.kernel.org
Received: from wfhigh1-smtp.messagingengine.com (wfhigh1-smtp.messagingengine.com [64.147.123.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0A92F46;
	Sun, 26 May 2024 23:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=64.147.123.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716767513; cv=none; b=lcaSQoD7Y0LyuW8amwz4d1kzplYdYvAWHadGLM02d6p+bmZGPTKJ+r0VSn+NndY3y/C1FwB3Ewg4zzYBevnWQxS2yzPncJwamcaOlXhlkGwujDRm2XS8cKN2TI2u+qU+T4TkfkJpa/x+drkyPnSVKm6gnnXpQu95QzJi4vdCzV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716767513; c=relaxed/simple;
	bh=y2YE2sACBvWRZ+y3y5PkgNP1II8JyQBD2vPJ5CDPp9k=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=vEMvxJOb6fkzYGCAP+yJpXJ8JYO7tadTGFNd0vWHPKPjN3LtcFmbDVMMS+dk8GPPjANNPzJ8LEjjU8t8FDEqU5abK5kLFwizQ2D4LH89dZNg6cUW74STGdprUDp2BWOJCvEaoS5tvI2d/d7D9SHCsP7h+diVbLS6xLuZg1fNwbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=themaw.net; spf=none smtp.mailfrom=themaw.net; dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b=qcjEp7t9; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=pHDUIqFf; arc=none smtp.client-ip=64.147.123.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=themaw.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=themaw.net
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
	by mailfhigh.west.internal (Postfix) with ESMTP id 2C6C918000C6;
	Sun, 26 May 2024 19:51:49 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 26 May 2024 19:51:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1716767508;
	 x=1716853908; bh=pnuxqKFArHc0hKC94sI3/4xCXe4WasF5RSe/E9GxAjg=; b=
	qcjEp7t94scPeY7fzf7EA5lR8vA9wunR1mfP1I4rja6yJFs7lZtcKyXw/MRk1YUn
	4ka1hdEu4Eexfqmxu3uKyioqEsmqVRfamYveddXa5HfA8MBddw/cEtOIJWrqZPt1
	UWBUbtKjwoDQE52Xt8FL2akrElq06Mvwitu7P5Z76YVHl00scgXu16YmSHufqP2Y
	x8U05MukWYwq9IN31MoFPv1FHg/tKBJQE2wXnTeMTltDMN5aP/7LyI+oSq+BdJ1e
	f1SJqZl9i4xpx12K/sJG+FDNRq7/5HAFrO6hWS9CSKCK+Nw4SJOC59hcY7O4AghJ
	9Z6CyZIeWQiXcZZWabppZg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1716767508; x=
	1716853908; bh=pnuxqKFArHc0hKC94sI3/4xCXe4WasF5RSe/E9GxAjg=; b=p
	HDUIqFfQ3DTxSDtBHXkJmo71iJaRe35RPccSSsaWM6pzJT0CFEJxx/psJ1tM5E05
	ch+ZGGJf/CkmXUGZy41vauNxB4iQ6ZHqEaYBeP/KGqynOPemnLMER8YObq0uYQRL
	EGZfhlit2APK0nK6W7p4Hqwv10hjoY1xgw9xTVEY13yP8fBat5Lx0hHkxrtk0ICx
	kcQaooLVQSu++610V9G/CqaXY9aVh0x3hNrN9cN7aNAbT8SbpUrniIihOnVSYXDO
	WuTDE6xw4mpVCnLxwYFvU3Yj8N9LH0DASUXU1wMc40v9gvEFuLXDw4Enw+Y76cK4
	smwen4I9OcCMB9mP058lQ==
X-ME-Sender: <xms:FMtTZjI4WwHaY1wVt2LI4zMr3QkDGeV2lE_5QmwNkVBC0qNDoHgkTQ>
    <xme:FMtTZnL1YfoE6B8dUGq8oMCLjtJajo1ba1gs67NCEtd-sp8IHep-3OZS0QHUUjGXH
    s-4Pxb39cbn>
X-ME-Received: <xmr:FMtTZrtFsrb_d-Ja23jg4PRZts3JQzXKovfL6Wa23m7Zz8L5ZZa0YbtVM7yBOzPgSMNO_BcUgpOMnGcYJuQ89JBJQ6aHIlMiSMxKT8lzwa3jDBTyOCMpeLJZ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvledrvdejfedgvdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepkfffgggfuffhvfevfhgjtgfgsehtkeertddtvdejnecuhfhrohhmpefkrghn
    ucfmvghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecuggftrfgrthhtvghrnh
    epgfdtheeftddukeehvdejtdejleeghffhgfeufeevjeetveeuvdfggfevgfdvudevnecu
    ffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpehrrghvvghnsehthhgvmhgrfidrnhgvth
X-ME-Proxy: <xmx:FMtTZsYe1atsz03i2DKCIRI_nCLvJ1p3w5S47s2UXoam72-U7T1fNg>
    <xmx:FMtTZqbCL_LziLq1jgi8VwMM1z71Wv7MIsF95c9aeNh5t8kgiofzWg>
    <xmx:FMtTZgChJe0g5aWltUoX3zSLJicgYNZQ5PZeDIqu1L43tjYBZqB15g>
    <xmx:FMtTZoYeSab8mNCrDbTfPR9kd8qRmty-i8VrXFbz1GQS9ay_V1Yz2g>
    <xmx:FMtTZi7A20CfJ3N1i4SSFxX0IhGST6F95yZ850_U9yUz3aaMmOTwMCNI>
Feedback-ID: i31e841b0:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 26 May 2024 19:51:44 -0400 (EDT)
Message-ID: <d2d010ce-51eb-4e99-b717-162e88f8d3fc@themaw.net>
Date: Mon, 27 May 2024 07:51:39 +0800
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: About the conflict between XFS inode recycle and VFS rcu-walk
From: Ian Kent <raven@themaw.net>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Jinliang Zheng <alexjlzheng@gmail.com>, alexjlzheng@tencent.com,
 bfoster@redhat.com, david@fromorbit.com, linux-fsdevel@vger.kernel.org,
 linux-xfs@vger.kernel.org, rcu@vger.kernel.org
References: <20240515155441.2788093-1-alexjlzheng@tencent.com>
 <20240516045655.40122-1-alexjlzheng@tencent.com>
 <7f744bf5-5f6d-4031-8a4f-91be2cd45147@themaw.net>
 <3545f78c-5e1c-4328-8ab0-19227005f4b7@themaw.net>
 <20240520173638.GB25518@frogsfrogsfrogs>
 <9a123c02-f88d-47dd-b8ef-dea136b01dc1@themaw.net>
 <dd7cdc06-9829-4519-9873-ea9d661a8c45@themaw.net>
Content-Language: en-US
Autocrypt: addr=raven@themaw.net;
 keydata= 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
In-Reply-To: <dd7cdc06-9829-4519-9873-ea9d661a8c45@themaw.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 21/5/24 10:13, Ian Kent wrote:
> On 21/5/24 09:35, Ian Kent wrote:
>> On 21/5/24 01:36, Darrick J. Wong wrote:
>>> On Thu, May 16, 2024 at 03:23:40PM +0800, Ian Kent wrote:
>>>> On 16/5/24 15:08, Ian Kent wrote:
>>>>> On 16/5/24 12:56, Jinliang Zheng wrote:
>>>>>> On Wed, 15 May 2024 at 23:54:41 +0800, Jinliang Zheng wrote:
>>>>>>> On Wed, 31 Jan 2024 at 11:30:18 -0800, djwong@kernel.org wrote:
>>>>>>>> On Wed, Jan 31, 2024 at 02:35:17PM +0800, Jinliang Zheng wrote:
>>>>>>>>> On Fri, 8 Dec 2023 11:14:32 +1100, david@fromorbit.com wrote:
>>>>>>>>>> On Tue, Dec 05, 2023 at 07:38:33PM +0800,
>>>>>>>>>> alexjlzheng@gmail.com wrote:
>>>>>>>>>>> Hi, all
>>>>>>>>>>>
>>>>>>>>>>> I would like to ask if the conflict between xfs
>>>>>>>>>>> inode recycle and vfs rcu-walk
>>>>>>>>>>> which can lead to null pointer references has been resolved?
>>>>>>>>>>>
>>>>>>>>>>> I browsed through emails about the following
>>>>>>>>>>> patches and their discussions:
>>>>>>>>>>> - 
>>>>>>>>>>> https://lore.kernel.org/linux-xfs/20220217172518.3842951-2-bfoster@redhat.com/
>>>>>>>>>>> - 
>>>>>>>>>>> https://lore.kernel.org/linux-xfs/20220121142454.1994916-1-bfoster@redhat.com/
>>>>>>>>>>> - 
>>>>>>>>>>> https://lore.kernel.org/linux-xfs/164180589176.86426.501271559065590169.stgit@mickey.themaw.net/
>>>>>>>>>>>
>>>>>>>>>>> And then came to the conclusion that this
>>>>>>>>>>> problem has not been solved, am I
>>>>>>>>>>> right? Did I miss some patch that could solve this problem?
>>>>>>>>>> We fixed the known problems this caused by turning off the VFS
>>>>>>>>>> functionality that the rcu pathwalks kept tripping over. See 
>>>>>>>>>> commit
>>>>>>>>>> 7b7820b83f23 ("xfs: don't expose internal symlink
>>>>>>>>>> metadata buffers to
>>>>>>>>>> the vfs").
>>>>>>>>> Sorry for the delay.
>>>>>>>>>
>>>>>>>>> The problem I encountered in the production environment
>>>>>>>>> was that during the
>>>>>>>>> rcu walk process the ->get_link() pointer was NULL,
>>>>>>>>> which caused a crash.
>>>>>>>>>
>>>>>>>>> As far as I know, commit 7b7820b83f23 ("xfs: don't
>>>>>>>>> expose internal symlink
>>>>>>>>> metadata buffers to the vfs") first appeared in:
>>>>>>>>> - 
>>>>>>>>> https://lore.kernel.org/linux-fsdevel/YZvvP9RFXi3%2FjX0q@bfoster/
>>>>>>>>>
>>>>>>>>> Does this commit solve the problem of NULL ->get_link()? And how?
>>>>>>>> I suggest reading the call stack from wherever the VFS enters 
>>>>>>>> the XFS
>>>>>>>> readlink code.  If you have a reliable reproducer, then
>>>>>>>> apply this patch
>>>>>>>> to your kernel (you haven't mentioned which one it is) and see 
>>>>>>>> if the
>>>>>>>> bad dereference goes away.
>>>>>>>>
>>>>>>>> --D
>>>>>>> Sorry for the delay.
>>>>>>>
>>>>>>> I encountered the following calltrace:
>>>>>>>
>>>>>>> [20213.578756] BUG: kernel NULL pointer dereference, address:
>>>>>>> 0000000000000000
>>>>>>> [20213.578785] #PF: supervisor instruction fetch in kernel mode
>>>>>>> [20213.578799] #PF: error_code(0x0010) - not-present page
>>>>>>> [20213.578812] PGD 3f01d64067 P4D 3f01d64067 PUD 3f01d65067 PMD 0
>>>>>>> [20213.578828] Oops: 0010 [#1] SMP NOPTI
>>>>>>> [20213.578839] CPU: 92 PID: 766 Comm: /usr/local/serv Kdump:
>>>>>>> loaded Not tainted 5.4.241-1-tlinux4-0017.3 #1
>>>>>>> [20213.578860] Hardware name: New H3C Technologies Co., Ltd.
>>>>>>> UniServer R4900 G3/RS33M2C9SA, BIOS 2.00.38P02 04/14/2020
>>>>>>> [20213.578884] RIP: 0010:0x0
>>>>>>> [20213.578894] Code: Bad RIP value.
>>>>>>> [20213.578903] RSP: 0018:ffffc90021ebfc38 EFLAGS: 00010246
>>>>>>> [20213.578916] RAX: ffffffff82081f40 RBX: ffffc90021ebfce0 RCX:
>>>>>>> 0000000000000000
>>>>>>> [20213.578932] RDX: ffffc90021ebfd48 RSI: ffff88bfad8d3890 RDI:
>>>>>>> 0000000000000000
>>>>>>> [20213.578948] RBP: ffffc90021ebfc70 R08: 0000000000000001 R09:
>>>>>>> ffff889b9eeae380
>>>>>>> [20213.578965] R10: 302d343200000067 R11: 0000000000000001 R12:
>>>>>>> 0000000000000000
>>>>>>> [20213.578981] R13: ffff88bfad8d3890 R14: ffff889b9eeae380 R15:
>>>>>>> ffffc90021ebfd48
>>>>>>> [20213.578998] FS:  00007f89c534e740(0000)
>>>>>>> GS:ffff88c07fd00000(0000) knlGS:0000000000000000
>>>>>>> [20213.579016] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>>>>>>> [20213.579030] CR2: ffffffffffffffd6 CR3: 0000003f01d90001 CR4:
>>>>>>> 00000000007706e0
>>>>>>> [20213.579046] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
>>>>>>> 0000000000000000
>>>>>>> [20213.579062] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
>>>>>>> 0000000000000400
>>>>>>> [20213.579079] PKRU: 55555554
>>>>>>> [20213.579087] Call Trace:
>>>>>>> [20213.579099]  trailing_symlink+0x1da/0x260
>>>>>>> [20213.579112]  path_lookupat.isra.53+0x79/0x220
>>>>>>> [20213.579125]  filename_lookup.part.69+0xa0/0x170
>>>>>>> [20213.579138]  ? kmem_cache_alloc+0x3f/0x3f0
>>>>>>> [20213.579151]  ? getname_flags+0x4f/0x1e0
>>>>>>> [20213.579161]  user_path_at_empty+0x3e/0x50
>>>>>>> [20213.579172]  vfs_statx+0x76/0xe0
>>>>>>> [20213.579182]  __do_sys_newstat+0x3d/0x70
>>>>>>> [20213.579194]  ? fput+0x13/0x20
>>>>>>> [20213.579203]  ? ksys_ioctl+0xb0/0x300
>>>>>>> [20213.579213]  ? generic_file_llseek+0x24/0x30
>>>>>>> [20213.579225]  ? fput+0x13/0x20
>>>>>>> [20213.579233]  ? ksys_lseek+0x8d/0xb0
>>>>>>> [20213.579243]  __x64_sys_newstat+0x16/0x20
>>>>>>> [20213.579256]  do_syscall_64+0x4d/0x140
>>>>>>> [20213.579268] entry_SYSCALL_64_after_hwframe+0x5c/0xc1
>>>>>>>
>>>>>>> <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 
>>>>>>>
>>>>>>>
>>>>>> Please note that the kernel version I use is the one maintained by
>>>>>> Tencent.Inc,
>>>>>> and the baseline is v5.4. But in fact, in the latest upstream source
>>>>>> tree,
>>>>>> although the trailing_symlink() function has been removed, its logic
>>>>>> has been
>>>>>> moved to pick_link(), so the problem still exists.
>>>>>>
>>>>>> Ian Kent pointed out that try_to_unlazy() was introduced in
>>>>>> pick_link() in the
>>>>>> latest upstream source tree, but I don't understand why this can
>>>>>> solve the NULL
>>>>>> ->get_link pointer dereference problem, because ->get_link pointer
>>>>>> will be
>>>>>> dereferenced before try_to_unlazy().
>>>>>>
>>>>>> (I don't understand why Ian Kent's email didn't appear on the
>>>>>> mailing list.)
>>>>> It was something about html mail and I think my mail client was at 
>>>>> fault.
>>>>>
>>>>> In any case what you say is indeed correct, so the comment isn't
>>>>> important.
>>>>>
>>>>>
>>>>> Fact is it is still a race between the lockless path walk and inode
>>>>> eviction
>>>>>
>>>>> and xfs recycling. I believe that the xfs recycling code is very 
>>>>> hard to
>>>>> fix.
>>>>>
>>>>>
>>>>> IIRC correctly putting a NULL check in pick_link() was not considered
>>>>> acceptable
>>>>>
>>>>> but there must be a way that is acceptable to check this and 
>>>>> restart the
>>>>> walk.
>>>>>
>>>>> Maybe there was a reluctance to suffer the overhead of restarting the
>>>>> walk when
>>>>>
>>>>> it shouldn't be needed.
>>>> Or perhaps the worry was that if it can become NULL it could also 
>>>> become a
>>>> pointer to a
>>>>
>>>> different (incorrect) link altogether which could have really 
>>>> odd/unpleasant
>>>> outcomes.
>>> Yuck.  I think that means that we can't reallocate freed inodes until
>>> the rcu grace period expires.  For inodes that haven't been evicted, I
>>> think that also means we cannot recycle cached inodes until after an 
>>> rcu
>>> grace period expires; or maybe that we cannot reset i_op/i_fop and must
>>> not leave the incore state in an inconsistent format?
>>
>> Yeah, not pretty!
>>
>> But shouldn't this case occur only occasionally?
>>
>>
>> So issuing a cache miss shouldn't impact performance too much that was,
>>
>> I believe, the concern with waiting for the rcu grace period.
>>
>>
>> Identifying it's happening should be possible, the vfs legitimize_*()
>>
>> has this job for various objects but maybe it's using vfs private info.
>>
>> (certainly it uses nameidata struct with a seq lock sequence number in
>>
>> it) but I assume it can be done somehow.
>
> Unfortunately, when you start trying to work out how to do this, it 
> isn't at all
>
> obvious how to do it ...

Indeed, that's what I found when I had a quick look.


Maybe a dentry (since that's part of the subject of the path walk and 
inode is readily

accessible) flag could be used since there's opportunity to set it in 
vfs callbacks that

are done as a matter of course.


Ian

>
>
>>
>>
>> My question then becomes is it viable/straight forward to not recycle 
>> such
>>
>> an inode and discard it instead so it gets re-created, I guess it's 
>> essentially
>>
>> a cache miss?
>>
>>
>> Ian
>>
>>>
>>> --D
>>>
>>>>>
>>>>> The alternative would be to find some way to identify when it's 
>>>>> unsafe
>>>>> to reuse
>>>>>
>>>>> an inode marked for re-cycle before dropping rcu read, perhaps 
>>>>> with the
>>>>> reference
>>>>>
>>>>> count plus the seqlock. Basically, to reuse inodes xfs will need to
>>>>> identify when
>>>>>
>>>>> the race occurs and let the inode go away under rcu and create a 
>>>>> new one
>>>>> if a race
>>>>>
>>>>> is detected. But possibly that isn't nearly as simple as it sounds?
>>>>>
>>>>>
>>>>>> Thanks,
>>>>>> Jinliang Zheng
>>>>>>
>>>>>>> And I analyzed the disassembly of trailing_symlink() and
>>>>>>> confirmed that a NULL
>>>>>>> ->get_link() happened here:
>>>>>>>
>>>>>>> 0xffffffff812e4850 <trailing_symlink>:    nopl 0x0(%rax,%rax,1)
>>>>>>> [FTRACE NOP]
>>>>>>> 0xffffffff812e4855 <trailing_symlink+0x5>: push %rbp
>>>>>>> 0xffffffff812e4856 <trailing_symlink+0x6>: mov %rsp,%rbp
>>>>>>> 0xffffffff812e4859 <trailing_symlink+0x9>: push %r15
>>>>>>> 0xffffffff812e485b <trailing_symlink+0xb>: push %r14
>>>>>>> 0xffffffff812e485d <trailing_symlink+0xd>: push %r13
>>>>>>> 0xffffffff812e485f <trailing_symlink+0xf>: push %r12
>>>>>>> 0xffffffff812e4861 <trailing_symlink+0x11>: push %rbx
>>>>>>> 0xffffffff812e4862 <trailing_symlink+0x12>: mov
>>>>>>> %rdi,%rbx        # rbx = &nameidate
>>>>>>> 0xffffffff812e4865 <trailing_symlink+0x15>: sub $0x8,%rsp
>>>>>>> 0xffffffff812e4869 <trailing_symlink+0x19>: mov
>>>>>>> 0x1765845(%rip),%edx     # 0xffffffff82a4a0b4
>>>>>>> <sysctl_protected_symlinks>
>>>>>>> 0xffffffff812e486f <trailing_symlink+0x1f>: mov 0x38(%rdi),%eax
>>>>>>> 0xffffffff812e4872 <trailing_symlink+0x22>: test %edx,%edx
>>>>>>> 0xffffffff812e4874 <trailing_symlink+0x24>: je
>>>>>>> 0xffffffff812e48ac <trailing_symlink+0x5c>
>>>>>>> 0xffffffff812e4876 <trailing_symlink+0x26>: mov %gs:0x1ad00,%rdx
>>>>>>> 0xffffffff812e487f <trailing_symlink+0x2f>: mov
>>>>>>> 0xc8(%rdi),%rcx        # rcx = nameidata->link_inode
>>>>>>> 0xffffffff812e4886 <trailing_symlink+0x36>: mov 0xc18(%rdx),%rdx
>>>>>>> 0xffffffff812e488d <trailing_symlink+0x3d>: mov
>>>>>>> 0x4(%rcx),%ecx        # ecx = link_inode->uid
>>>>>>> 0xffffffff812e4890 <trailing_symlink+0x40>: cmp %ecx,0x1c(%rdx)
>>>>>>> 0xffffffff812e4893 <trailing_symlink+0x43>: je
>>>>>>> 0xffffffff812e48ac <trailing_symlink+0x5c>
>>>>>>> 0xffffffff812e4895 <trailing_symlink+0x45>: mov 0x30(%rdi),%rsi
>>>>>>> 0xffffffff812e4899 <trailing_symlink+0x49>: movzwl (%rsi),%edx
>>>>>>> 0xffffffff812e489c <trailing_symlink+0x4c>: and $0x202,%dx
>>>>>>> 0xffffffff812e48a1 <trailing_symlink+0x51>: cmp $0x202,%dx
>>>>>>> 0xffffffff812e48a6 <trailing_symlink+0x56>: je
>>>>>>> 0xffffffff812e495f <trailing_symlink+0x10f>
>>>>>>> 0xffffffff812e48ac <trailing_symlink+0x5c>: or $0x10,%eax
>>>>>>> 0xffffffff812e48af <trailing_symlink+0x5f>: mov
>>>>>>> %eax,0x38(%rbx)        # nd->flags |= LOOKUP_PARENT
>>>>>>> 0xffffffff812e48b2 <trailing_symlink+0x62>: mov
>>>>>>> 0x50(%rbx),%rax        # rax = nd->stack
>>>>>>> 0xffffffff812e48b6 <trailing_symlink+0x66>: movq
>>>>>>> $0x0,0x20(%rax)        # stack[0].name = NULL
>>>>>>> 0xffffffff812e48be <trailing_symlink+0x6e>: mov
>>>>>>> 0x48(%rbx),%eax        # nd->depth
>>>>>>> 0xffffffff812e48c1 <trailing_symlink+0x71>: mov
>>>>>>> 0x50(%rbx),%rdx        # nd->stack
>>>>>>> 0xffffffff812e48c5 <trailing_symlink+0x75>: mov
>>>>>>> 0xc8(%rbx),%r13        # nd->link_inode
>>>>>>> 0xffffffff812e48cc <trailing_symlink+0x7c>: lea
>>>>>>> (%rax,%rax,2),%rax    # rax = depth * 3
>>>>>>> 0xffffffff812e48d0 <trailing_symlink+0x80>: shl
>>>>>>> $0x4,%rax        # rax = rax << 4, sizeof(saved):0x30
>>>>>>> 0xffffffff812e48d4 <trailing_symlink+0x84>: lea
>>>>>>> -0x30(%rdx,%rax,1),%r15    # r15 = last
>>>>>>> 0xffffffff812e48d9 <trailing_symlink+0x89>: mov
>>>>>>> 0x8(%r15),%r14        # r14 = last->link.dentry
>>>>>>> 0xffffffff812e48dd <trailing_symlink+0x8d>: testb $0x40,0x38(%rbx)
>>>>>>> 0xffffffff812e48e1 <trailing_symlink+0x91>: je
>>>>>>> 0xffffffff812e4950 <trailing_symlink+0x100>
>>>>>>> 0xffffffff812e48e3 <trailing_symlink+0x93>: mov %r13,%rsi
>>>>>>> 0xffffffff812e48e6 <trailing_symlink+0x96>: mov %r15,%rdi
>>>>>>> 0xffffffff812e48e9 <trailing_symlink+0x99>: callq
>>>>>>> 0xffffffff812f8a00 <atime_needs_update>
>>>>>>> 0xffffffff812e48ee <trailing_symlink+0x9e>: test %al,%al
>>>>>>> 0xffffffff812e48f0 <trailing_symlink+0xa0>: jne
>>>>>>> 0xffffffff812e4a56 <trailing_symlink+0x206>
>>>>>>> 0xffffffff812e48f6 <trailing_symlink+0xa6>: mov 0x38(%rbx),%edx
>>>>>>> 0xffffffff812e48f9 <trailing_symlink+0xa9>: mov %r13,%rsi
>>>>>>> 0xffffffff812e48fc <trailing_symlink+0xac>: mov %r14,%rdi
>>>>>>> 0xffffffff812e48ff <trailing_symlink+0xaf>: shr $0x6,%edx
>>>>>>> 0xffffffff812e4902 <trailing_symlink+0xb2>: and $0x1,%edx
>>>>>>> 0xffffffff812e4905 <trailing_symlink+0xb5>: callq
>>>>>>> 0xffffffff81424310 <security_inode_follow_link>
>>>>>>> 0xffffffff812e490a <trailing_symlink+0xba>: movslq %eax,%r12
>>>>>>> 0xffffffff812e490d <trailing_symlink+0xbd>: test %eax,%eax
>>>>>>> 0xffffffff812e490f <trailing_symlink+0xbf>: jne
>>>>>>> 0xffffffff812e4939 <trailing_symlink+0xe9>
>>>>>>> 0xffffffff812e4911 <trailing_symlink+0xc1>: movl $0x4,0x44(%rbx)
>>>>>>> 0xffffffff812e4918 <trailing_symlink+0xc8>: mov 0x248(%r13),%r12
>>>>>>> 0xffffffff812e491f <trailing_symlink+0xcf>: test %r12,%r12
>>>>>>> 0xffffffff812e4922 <trailing_symlink+0xd2>: je
>>>>>>> 0xffffffff812e49e5 <trailing_symlink+0x195>
>>>>>>> 0xffffffff812e4928 <trailing_symlink+0xd8>: movzbl (%r12),%eax
>>>>>>> 0xffffffff812e492d <trailing_symlink+0xdd>: cmp $0x2f,%al
>>>>>>> 0xffffffff812e492f <trailing_symlink+0xdf>: je
>>>>>>> 0xffffffff812e49b7 <trailing_symlink+0x167>
>>>>>>> 0xffffffff812e4935 <trailing_symlink+0xe5>: test %al,%al
>>>>>>> 0xffffffff812e4937 <trailing_symlink+0xe7>: je
>>>>>>> 0xffffffff812e49ae <trailing_symlink+0x15e>
>>>>>>> 0xffffffff812e4939 <trailing_symlink+0xe9>: test %r12,%r12
>>>>>>> 0xffffffff812e493c <trailing_symlink+0xec>: je
>>>>>>> 0xffffffff812e49ae <trailing_symlink+0x15e>
>>>>>>> 0xffffffff812e493e <trailing_symlink+0xee>: add $0x8,%rsp
>>>>>>> 0xffffffff812e4942 <trailing_symlink+0xf2>: mov %r12,%rax
>>>>>>> 0xffffffff812e4945 <trailing_symlink+0xf5>: pop %rbx
>>>>>>> 0xffffffff812e4946 <trailing_symlink+0xf6>: pop %r12
>>>>>>> 0xffffffff812e4948 <trailing_symlink+0xf8>: pop %r13
>>>>>>> 0xffffffff812e494a <trailing_symlink+0xfa>: pop %r14
>>>>>>> 0xffffffff812e494c <trailing_symlink+0xfc>: pop %r15
>>>>>>> 0xffffffff812e494e <trailing_symlink+0xfe>: pop %rbp
>>>>>>> 0xffffffff812e494f <trailing_symlink+0xff>: retq
>>>>>>> 0xffffffff812e4950 <trailing_symlink+0x100>: mov %r15,%rdi
>>>>>>> 0xffffffff812e4953 <trailing_symlink+0x103>: callq
>>>>>>> 0xffffffff812f8ae0 <touch_atime>
>>>>>>> 0xffffffff812e4958 <trailing_symlink+0x108>: callq
>>>>>>> 0xffffffff81a26410 <_cond_resched>
>>>>>>> 0xffffffff812e495d <trailing_symlink+0x10d>: jmp
>>>>>>> 0xffffffff812e48f6 <trailing_symlink+0xa6>
>>>>>>> 0xffffffff812e495f <trailing_symlink+0x10f>: mov 0x4(%rsi),%edx
>>>>>>> 0xffffffff812e4962 <trailing_symlink+0x112>: cmp $0xffffffff,%edx
>>>>>>> 0xffffffff812e4965 <trailing_symlink+0x115>: je
>>>>>>> 0xffffffff812e496f <trailing_symlink+0x11f>
>>>>>>> 0xffffffff812e4967 <trailing_symlink+0x117>: cmp %edx,%ecx
>>>>>>> 0xffffffff812e4969 <trailing_symlink+0x119>: je
>>>>>>> 0xffffffff812e48ac <trailing_symlink+0x5c>
>>>>>>> 0xffffffff812e496f <trailing_symlink+0x11f>: mov
>>>>>>> $0xfffffffffffffff6,%r12
>>>>>>> 0xffffffff812e4976 <trailing_symlink+0x126>: test $0x40,%al
>>>>>>> 0xffffffff812e4978 <trailing_symlink+0x128>: jne
>>>>>>> 0xffffffff812e493e <trailing_symlink+0xee>
>>>>>>> 0xffffffff812e497a <trailing_symlink+0x12a>: mov %gs:0x1ad00,%rax
>>>>>>> 0xffffffff812e4983 <trailing_symlink+0x133>: mov 0xce0(%rax),%rax
>>>>>>> 0xffffffff812e498a <trailing_symlink+0x13a>: test %rax,%rax
>>>>>>> 0xffffffff812e498d <trailing_symlink+0x13d>: je
>>>>>>> 0xffffffff812e4999 <trailing_symlink+0x149>
>>>>>>> 0xffffffff812e498f <trailing_symlink+0x13f>: mov (%rax),%eax
>>>>>>> 0xffffffff812e4991 <trailing_symlink+0x141>: test %eax,%eax
>>>>>>> 0xffffffff812e4993 <trailing_symlink+0x143>: je
>>>>>>> 0xffffffff812e4a6f <trailing_symlink+0x21f>
>>>>>>> 0xffffffff812e4999 <trailing_symlink+0x149>: mov
>>>>>>> $0xffffffff82319b4f,%rdi
>>>>>>> 0xffffffff812e49a0 <trailing_symlink+0x150>: mov
>>>>>>> $0xfffffffffffffff3,%r12
>>>>>>> 0xffffffff812e49a7 <trailing_symlink+0x157>: callq
>>>>>>> 0xffffffff81161310 <audit_log_link_denied>
>>>>>>> 0xffffffff812e49ac <trailing_symlink+0x15c>: jmp
>>>>>>> 0xffffffff812e493e <trailing_symlink+0xee>
>>>>>>> 0xffffffff812e49ae <trailing_symlink+0x15e>: mov
>>>>>>> $0xffffffff8230164d,%r12
>>>>>>> 0xffffffff812e49b5 <trailing_symlink+0x165>: jmp
>>>>>>> 0xffffffff812e493e <trailing_symlink+0xee>
>>>>>>> 0xffffffff812e49b7 <trailing_symlink+0x167>: cmpq $0x0,0x20(%rbx)
>>>>>>> 0xffffffff812e49bc <trailing_symlink+0x16c>: je
>>>>>>> 0xffffffff812e4a8a <trailing_symlink+0x23a>
>>>>>>> 0xffffffff812e49c2 <trailing_symlink+0x172>: mov %rbx,%rdi
>>>>>>> 0xffffffff812e49c5 <trailing_symlink+0x175>: callq
>>>>>>> 0xffffffff812e2da0 <nd_jump_root>
>>>>>>> 0xffffffff812e49ca <trailing_symlink+0x17a>: test %eax,%eax
>>>>>>> 0xffffffff812e49cc <trailing_symlink+0x17c>: jne
>>>>>>> 0xffffffff812e4a97 <trailing_symlink+0x247>
>>>>>>> 0xffffffff812e49d2 <trailing_symlink+0x182>: add $0x1,%r12
>>>>>>> 0xffffffff812e49d6 <trailing_symlink+0x186>: movzbl (%r12),%eax
>>>>>>> 0xffffffff812e49db <trailing_symlink+0x18b>: cmp $0x2f,%al
>>>>>>> 0xffffffff812e49dd <trailing_symlink+0x18d>: jne
>>>>>>> 0xffffffff812e4935 <trailing_symlink+0xe5>
>>>>>>> 0xffffffff812e49e3 <trailing_symlink+0x193>: jmp
>>>>>>> 0xffffffff812e49d2 <trailing_symlink+0x182>
>>>>>>> 0xffffffff812e49e5 <trailing_symlink+0x195>: mov
>>>>>>> 0x20(%r13),%rax        # inode->i_op
>>>>>>> 0xffffffff812e49e9 <trailing_symlink+0x199>: add $0x10,%r15
>>>>>>> 0xffffffff812e49ed <trailing_symlink+0x19d>: mov %r13,%rsi
>>>>>>> 0xffffffff812e49f0 <trailing_symlink+0x1a0>: mov %r15,%rdx
>>>>>>> 0xffffffff812e49f3 <trailing_symlink+0x1a3>: mov
>>>>>>> 0x8(%rax),%rcx        # inode_operations->get_link
>>>>>>> 0xffffffff812e49f7 <trailing_symlink+0x1a7>: testb $0x40,0x38(%rbx)
>>>>>>> 0xffffffff812e49fb <trailing_symlink+0x1ab>: jne
>>>>>>> 0xffffffff812e4a1f <trailing_symlink+0x1cf>
>>>>>>> 0xffffffff812e49fd <trailing_symlink+0x1ad>: mov
>>>>>>> %r14,%rdi        # nd->flags & LOOKUP_RCU == 0
>>>>>>> 0xffffffff812e4a00 <trailing_symlink+0x1b0>: callq
>>>>>>> 0xffffffff81e00f70 <__x86_indirect_thunk_rcx> # jmpq *%rcx
>>>>>>> 0xffffffff812e4a05 <trailing_symlink+0x1b5>: mov %rax,%r12
>>>>>>> 0xffffffff812e4a08 <trailing_symlink+0x1b8>: test %r12,%r12
>>>>>>> 0xffffffff812e4a0b <trailing_symlink+0x1bb>: je
>>>>>>> 0xffffffff812e49ae <trailing_symlink+0x15e>
>>>>>>> 0xffffffff812e4a0d <trailing_symlink+0x1bd>: cmp
>>>>>>> $0xfffffffffffff000,%r12
>>>>>>> 0xffffffff812e4a14 <trailing_symlink+0x1c4>: jbe
>>>>>>> 0xffffffff812e4928 <trailing_symlink+0xd8>
>>>>>>> 0xffffffff812e4a1a <trailing_symlink+0x1ca>: jmpq
>>>>>>> 0xffffffff812e493e <trailing_symlink+0xee>
>>>>>>> 0xffffffff812e4a1f <trailing_symlink+0x1cf>: xor
>>>>>>> %edi,%edi        # nd->flags & LOOKUP_RCU != 0
>>>>>>> 0xffffffff812e4a21 <trailing_symlink+0x1d1>: mov %rcx,-0x30(%rbp)
>>>>>>> 0xffffffff812e4a25 <trailing_symlink+0x1d5>: callq
>>>>>>> 0xffffffff81e00f70 <__x86_indirect_thunk_rcx> # jmpq *%rcx
>>>>>>> 0xffffffff812e4a2a <trailing_symlink+0x1da>: mov %rax,%r12
>>>>>>> 0xffffffff812e4a2d <trailing_symlink+0x1dd>: cmp
>>>>>>> $0xfffffffffffffff6,%rax
>>>>>>> 0xffffffff812e4a31 <trailing_symlink+0x1e1>: jne
>>>>>>> 0xffffffff812e4a08 <trailing_symlink+0x1b8>
>>>>>>> 0xffffffff812e4a33 <trailing_symlink+0x1e3>: mov %rbx,%rdi
>>>>>>> 0xffffffff812e4a36 <trailing_symlink+0x1e6>: callq
>>>>>>> 0xffffffff812e3840 <unlazy_walk>
>>>>>>> 0xffffffff812e4a3b <trailing_symlink+0x1eb>: test %eax,%eax
>>>>>>> 0xffffffff812e4a3d <trailing_symlink+0x1ed>: jne
>>>>>>> 0xffffffff812e4a97 <trailing_symlink+0x247>
>>>>>>> 0xffffffff812e4a3f <trailing_symlink+0x1ef>: mov %r15,%rdx
>>>>>>> 0xffffffff812e4a42 <trailing_symlink+0x1f2>: mov %r13,%rsi
>>>>>>> 0xffffffff812e4a45 <trailing_symlink+0x1f5>: mov %r14,%rdi
>>>>>>> 0xffffffff812e4a48 <trailing_symlink+0x1f8>: mov -0x30(%rbp),%rcx
>>>>>>> 0xffffffff812e4a4c <trailing_symlink+0x1fc>: callq
>>>>>>> 0xffffffff81e00f70 <__x86_indirect_thunk_rcx>
>>>>>>> 0xffffffff812e4a51 <trailing_symlink+0x201>: mov %rax,%r12
>>>>>>> 0xffffffff812e4a54 <trailing_symlink+0x204>: jmp
>>>>>>> 0xffffffff812e4a08 <trailing_symlink+0x1b8>
>>>>>>> 0xffffffff812e4a56 <trailing_symlink+0x206>: mov %rbx,%rdi
>>>>>>> 0xffffffff812e4a59 <trailing_symlink+0x209>: callq
>>>>>>> 0xffffffff812e3840 <unlazy_walk>
>>>>>>> 0xffffffff812e4a5e <trailing_symlink+0x20e>: test %eax,%eax
>>>>>>> 0xffffffff812e4a60 <trailing_symlink+0x210>: jne
>>>>>>> 0xffffffff812e4a97 <trailing_symlink+0x247>
>>>>>>> 0xffffffff812e4a62 <trailing_symlink+0x212>: mov %r15,%rdi
>>>>>>> 0xffffffff812e4a65 <trailing_symlink+0x215>: callq
>>>>>>> 0xffffffff812f8ae0 <touch_atime>
>>>>>>> 0xffffffff812e4a6a <trailing_symlink+0x21a>: jmpq
>>>>>>> 0xffffffff812e48f6 <trailing_symlink+0xa6>
>>>>>>> 0xffffffff812e4a6f <trailing_symlink+0x21f>: mov 0x50(%rbx),%rax
>>>>>>> 0xffffffff812e4a73 <trailing_symlink+0x223>: mov 0xb8(%rbx),%rdi
>>>>>>> 0xffffffff812e4a7a <trailing_symlink+0x22a>: xor %edx,%edx
>>>>>>> 0xffffffff812e4a7c <trailing_symlink+0x22c>: mov 0x8(%rax),%rsi
>>>>>>> 0xffffffff812e4a80 <trailing_symlink+0x230>: callq
>>>>>>> 0xffffffff811673f0 <__audit_inode>
>>>>>>> 0xffffffff812e4a85 <trailing_symlink+0x235>: jmpq
>>>>>>> 0xffffffff812e4999 <trailing_symlink+0x149>
>>>>>>> 0xffffffff812e4a8a <trailing_symlink+0x23a>: mov %rbx,%rdi
>>>>>>> 0xffffffff812e4a8d <trailing_symlink+0x23d>: callq
>>>>>>> 0xffffffff812e4790 <set_root>
>>>>>>> 0xffffffff812e4a92 <trailing_symlink+0x242>: jmpq
>>>>>>> 0xffffffff812e49c2 <trailing_symlink+0x172>
>>>>>>> 0xffffffff812e4a97 <trailing_symlink+0x247>: mov
>>>>>>> $0xfffffffffffffff6,%r12
>>>>>>> 0xffffffff812e4a9e <trailing_symlink+0x24e>: jmpq
>>>>>>> 0xffffffff812e493e <trailing_symlink+0xee>
>>>>>>>
>>>>>>> <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> According to my understanding, the problem solved by commit
>>>>>>> 7b7820b83f23 ("xfs:
>>>>>>> don't expose internal symlink metadata buffers to the vfs") is a
>>>>>>> data NULL
>>>>>>> pointer dereference, but the problem here is an instruction NULL
>>>>>>> pointer
>>>>>>> dereference.
>>>>>>>
>>>>>>> Further, I analyzed the possible triggering process as follows:
>>>>>>>
>>>>>>> rcu_walk            do_unlinkat ~~> prune_dcache_sb create
>>>>>>> rcu_read_lock
>>>>>>> read_seqcount_retry
>>>>>>> (the last check)      iput_final
>>>>>>>                           evict
>>>>>>>                             destroy_inode
>>>>>>>                               xfs_fs_destroy_inode
>>>>>>> xfs_inode_set_reclaim_tag xfs_ialloc
>>>>>>> spin_lock(ip->i_flags_lock)     xfs_dialloc
>>>>>>>                                   set(ip, XFS_IRECLAIMABLE)
>>>>>>> xfs_iget
>>>>>>> wakeup(xfs_reclaim_worker)        rcu_read_lock
>>>>>>> spin_unlock(ip->i_flags_lock) xfs_iget_cache_hit
>>>>>>> spin_lock(ip->i_flags_lock)
>>>>>>>                                                                      
>>>>>>> if (XFS_IRECLAIMABLE && !XFS_IRECLAIM)
>>>>>>> set(ip, XFS_IRECLAIM)
>>>>>>> spin_unlock(ip->i_flags_lock)
>>>>>>> rcu_read_unlock
>>>>>>> < ------------ >
>>>>>>>                                                                      
>>>>>>> // miss synchronize_rcu()
>>>>>>> xfs_reinit_inode
>>>>>>> ->get_link = NULL
>>>>>>> get_link() // NULL
>>>>>>>
>>>>>>> rcu_read_unlock
>>>>>>>
>>>>>>> <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< 
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> Therefore, I think that after commit 7b7820b83f23 ("xfs: don't
>>>>>>> expose internal
>>>>>>> symlink metadata buffers to the vfs"), we should start
>>>>>>> processing this NULL
>>>>>>> ->get_link pointer dereference.
>>>>>>>
>>>>>>> Or, am I thinking wrong somewhere?
>>>>>>>
>>>>>>> Thanks,
>>>>>>> Jinliang Zheng
>>>>>>>
>>>>>>>>>> Apart from that issue, I'm not aware of any other issues that 
>>>>>>>>>> the
>>>>>>>>>> XFS inode recycling directly exposes.
>>>>>>>>>>
>>>>>>>>>>> According to my understanding, the essence of
>>>>>>>>>>> this problem is that XFS reuses
>>>>>>>>>>> the inode evicted by VFS, but VFS rcu-walk
>>>>>>>>>>> assumes that this will not happen.
>>>>>>>>>> It assumes that the inode will not change identity during the 
>>>>>>>>>> RCU
>>>>>>>>>> grace period after the inode has been evicted from cache. We can
>>>>>>>>>> safely reinstantiate an evicted inode without waiting for an RCU
>>>>>>>>>> grace period as long as it is the same inode with the same 
>>>>>>>>>> content
>>>>>>>>>> and same state.
>>>>>>>>>>
>>>>>>>>>> Problems *may* arise when we unlink the inode, then evict it, 
>>>>>>>>>> then a
>>>>>>>>>> new file is created and the old slab cache memory address is 
>>>>>>>>>> used
>>>>>>>>>> for the new inode. I describe the issue here:
>>>>>>>>>>
>>>>>>>>>> https://lore.kernel.org/linux-xfs/20220118232547.GD59729@dread.disaster.area/ 
>>>>>>>>>>
>>>>>>>>>>
>>>>>>>>> And judging from the relevant emails, the main reason
>>>>>>>>> why ->get_link() is set
>>>>>>>>> to NULL should be the lack of synchronize_rcu() before
>>>>>>>>> xfs_reinit_inode() when
>>>>>>>>> the inode is chosen to be reused.
>>>>>>>>>
>>>>>>>>> However, perhaps due to performance reasons, this
>>>>>>>>> solution has not been merged
>>>>>>>>> for a long time. How is it now?
>>>>>>>>>
>>>>>>>>> Maybe I am missing something in the threads of mail?
>>>>>>>>>
>>>>>>>>> Thank you very much. :)
>>>>>>>>> Jinliang Zheng
>>>>>>>>>
>>>>>>>>>> That said, we have exactly zero evidence that this is actually a
>>>>>>>>>> problem in production systems. We did get systems tripping 
>>>>>>>>>> over the
>>>>>>>>>> symlink issue, but there's no evidence that the
>>>>>>>>>> unlink->close->open(O_CREAT) issues are manifesting in the 
>>>>>>>>>> wild and
>>>>>>>>>> hence there hasn't been any particular urgency to address it.
>>>>>>>>>>
>>>>>>>>>>> Are there any recommended workarounds until an
>>>>>>>>>>> elegant and efficient solution
>>>>>>>>>>> can be proposed? After all, causing a crash is
>>>>>>>>>>> extremely unacceptable in a
>>>>>>>>>>> production environment.
>>>>>>>>>> What crashes are you seeing in your production environment?
>>>>>>>>>>
>>>>>>>>>> -Dave.
>>>>>>>>>> -- 
>>>>>>>>>> Dave Chinner
>>>>>>>>>> david@fromorbit.com
>>
>

