Return-Path: <linux-xfs+bounces-12989-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D864A97B7FC
	for <lists+linux-xfs@lfdr.de>; Wed, 18 Sep 2024 08:37:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 548F41F23BBB
	for <lists+linux-xfs@lfdr.de>; Wed, 18 Sep 2024 06:37:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69C13158219;
	Wed, 18 Sep 2024 06:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="CRXEfWNE"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1790166F1A
	for <linux-xfs@vger.kernel.org>; Wed, 18 Sep 2024 06:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726641428; cv=none; b=mxNv4bnzXn4T6q3pY4mH7Fi7RsAJirkI5jhZFhuGJrJIgOxEqLnDn3QQDqeJH+VMOFlODCnY22UAs2FzRQ7aAjAwnK/fo0taINHLvZ6gR6J3jO5xxHOD2KSHeUY+tPFDFrL59DkS8glE7ANtuQMO3TmQzXdrV27p4GKz3ach8Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726641428; c=relaxed/simple;
	bh=04wFRTmhaMNLEIfkaR4jRwa5fJu4Gu8BgBWpgBSxiTA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s/jVskTtm1/dHPOltKEuSPmrniRkjmHLOEKCECrHBRATwwoEVz8hnjI3/oABPAqoyNwTCigbACypUdeJpZxmXC34EMpMRrmiKj2vr71HmuVx2ASQA+u4C8aWyeJ2BzC+D8PkX7oyz+LO8bPuTLwBIK1hZ/kFJOQx04ik48/6SKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=CRXEfWNE; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-42cde6b5094so52372185e9.3
        for <linux-xfs@vger.kernel.org>; Tue, 17 Sep 2024 23:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726641424; x=1727246224; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ONBa+excFFO7rQj3mSGSspHjsKaP6ICID9dssfbxrK8=;
        b=CRXEfWNEXvQs7ImCG6MHdU9GC0DDp184/WUnzRV1MipdN1FBmPZAANC0hm8YK2ncIH
         9vL06xcgUGOONXoVXBZl+h30C0FRCG/pJLTcTZ7CDHWRa9876tDusnRxetPNViK2hOna
         pbU6HzKsyP73jbXTVSZrgkx4mapUslY27UhejR36ZQKU28CbjEbg1Gbf3Z1v1JKXUohz
         hZvzQ2FDBGAyh1U9BQGT2OIODlGaNfqGMwhGqyDeFAnBLib9cjvMpoKFZV865Vpkijd8
         zDRaItIg909HW62F/80MRHou4+yHJwxorQvvTIHYiHqSTGW/kNMiub4LedgchFpCKWft
         fASg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726641424; x=1727246224;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ONBa+excFFO7rQj3mSGSspHjsKaP6ICID9dssfbxrK8=;
        b=vT8Jo5AkeWxE4/HuBK2ZirrwinYq8mAY/N8Y0iy/BfifN5zE2229xjoRmysQ0/xtVE
         gg5jThwGjwp5GHvMcKaHzVPgYOmJ/MbvAAGVFz21RwrICfhax05GfRxMwzEkQze4E0rr
         dUycCvsP3CXLwMxLSkBz92Wqu4UeUfH0DveRZeOc3f9XQRYlMWZo7p4y/bApXLP1Kp8a
         4rSkVZiQdEhpV3jli7dV+raNPXVBG3oz/djzMzL52m3MO0fxRj51uO5vMLyrCoLR7f+E
         WmjwnB3NHLTk22SEt1Gpbo9lILwEiPrBVPFkC65+zx0MPSHni22j8iS4pU1qMULJoRUe
         S98w==
X-Forwarded-Encrypted: i=1; AJvYcCXN5igMxDVkmWs6WwHdvV6PRjKIYob+GPRE2ZCG15cfYVH1WRILznPdL4kgm5pDcgMTZC0824iPZHQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7lPzlkdytQDKn87YPxvAe6V+rzrVjb3UbyjGiTjyR2mTvj7Mh
	dgPWnfxlg5dDdIlAab3j27Zqm75ifk2UD9lZpYWy7BeAv/wA3MQrKwBYv85Doag=
X-Google-Smtp-Source: AGHT+IFuyOiC/XvUY4Wd1OtS/NrMuj2AqikvELaUO76m0bhp4vCBZtJUmcPgp8JUIdbzh/H1w+GxiA==
X-Received: by 2002:a05:600c:1e0f:b0:42c:bc04:58a5 with SMTP id 5b1f17b1804b1-42cdb58e4b1mr140112675e9.33.1726641423740;
        Tue, 17 Sep 2024 23:37:03 -0700 (PDT)
Received: from [192.168.0.216] ([185.44.53.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42e7054c580sm7966815e9.45.2024.09.17.23.37.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Sep 2024 23:37:02 -0700 (PDT)
Message-ID: <5bee194c-9cd3-47e7-919b-9f352441f855@kernel.dk>
Date: Wed, 18 Sep 2024 00:37:02 -0600
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Known and unfixed active data loss bug in MM + XFS with large
 folios since Dec 2021 (any kernel from 6.1 upwards)
To: Matthew Wilcox <willy@infradead.org>, Chris Mason <clm@meta.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
 Dave Chinner <david@fromorbit.com>, Christian Theune <ct@flyingcircus.io>,
 linux-mm@kvack.org, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 Daniel Dao <dqminh@cloudflare.com>, regressions@lists.linux.dev,
 regressions@leemhuis.info
References: <A5A976CB-DB57-4513-A700-656580488AB6@flyingcircus.io>
 <ZuNjNNmrDPVsVK03@casper.infradead.org>
 <0fc8c3e7-e5d2-40db-8661-8c7199f84e43@kernel.dk>
 <CAHk-=wh5LRp6Tb2oLKv1LrJWuXKOvxcucMfRMmYcT-npbo0=_A@mail.gmail.com>
 <Zud1EhTnoWIRFPa/@dread.disaster.area>
 <CAHk-=wgY-PVaVRBHem2qGnzpAQJheDOWKpqsteQxbRop6ey+fQ@mail.gmail.com>
 <74cceb67-2e71-455f-a4d4-6c5185ef775b@meta.com>
 <ZulMlPFKiiRe3iFd@casper.infradead.org>
 <52d45d22-e108-400e-a63f-f50ef1a0ae1a@meta.com>
 <ZumDPU7RDg5wV0Re@casper.infradead.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZumDPU7RDg5wV0Re@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/17/24 7:25 AM, Matthew Wilcox wrote:
> On Tue, Sep 17, 2024 at 01:13:05PM +0200, Chris Mason wrote:
>> On 9/17/24 5:32 AM, Matthew Wilcox wrote:
>>> On Mon, Sep 16, 2024 at 10:47:10AM +0200, Chris Mason wrote:
>>>> I've got a bunch of assertions around incorrect folio->mapping and I'm
>>>> trying to bash on the ENOMEM for readahead case.  There's a GFP_NOWARN
>>>> on those, and our systems do run pretty short on ram, so it feels right
>>>> at least.  We'll see.
>>>
>>> I've been running with some variant of this patch the whole way across
>>> the Atlantic, and not hit any problems.  But maybe with the right
>>> workload ...?
>>>
>>> There are two things being tested here.  One is whether we have a
>>> cross-linked node (ie a node that's in two trees at the same time).
>>> The other is whether the slab allocator is giving us a node that already
>>> contains non-NULL entries.
>>>
>>> If you could throw this on top of your kernel, we might stand a chance
>>> of catching the problem sooner.  If it is one of these problems and not
>>> something weirder.
>>>
>>
>> This fires in roughly 10 seconds for me on top of v6.11.  Since array seems
>> to always be 1, I'm not sure if the assertion is right, but hopefully you
>> can trigger yourself.
> 
> Whoops.
> 
> $ git grep XA_RCU_FREE
> lib/xarray.c:#define XA_RCU_FREE        ((struct xarray *)1)
> lib/xarray.c:   node->array = XA_RCU_FREE;
> 
> so you walked into a node which is currently being freed by RCU.  Which
> isn't a problem, of course.  I don't know why I do that; it doesn't seem
> like anyone tests it.  The jetlag is seriously kicking in right now,
> so I'm going to refrain from saying anything more because it probably
> won't be coherent.

Based on a modified reproducer from Chris (N threads reading from a
file, M threads dropping pages), I can pretty quickly reproduce the
xas_descend() spin on 6.9 in a vm with 128 cpus. Here's some debugging
output with a modified version of your patch too, that ignores
XA_RCU_FREE:

node ffff8e838a01f788 max 59 parent 0000000000000000 shift 0 count 0 values 0 array ffff8e839dfa86a0 list ffff8e838a01f7a0 ffff8e838a01f7a0 marks 0 0 0
WARNING: CPU: 106 PID: 1554 at lib/xarray.c:405 xas_alloc.cold+0x26/0x4b

which is:

XA_NODE_BUG_ON(node, memchr_inv(&node->slots, 0, sizeof(void *) * XA_CHUN  K_SIZE));

and:

node ffff8e838a01f788 offset 59 parent ffff8e838b0419c8 shift 0 count 252 values 0 array ffff8e839dfa86a0 list ffff8e838a01f7a0 ffff8e838a01f7a0 marks 0 0 0

which is:

XA_NODE_BUG_ON(node, node->count > XA_CHUNK_SIZE);

and for this particular run, 2 threads spinning:

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	Tasks blocked on level-1 rcu_node (CPUs 16-31): P1555
rcu: 	Tasks blocked on level-1 rcu_node (CPUs 64-79): P1556
rcu: 	(detected by 97, t=2102 jiffies, g=7821, q=293800 ncpus=128)
task:reader          state:R  running task     stack:0     pid:1555  tgid:1551  ppid:1      flags:0x00004006
Call Trace:
 <TASK>
 ? __schedule+0x37f/0xaa0
 ? sysvec_apic_timer_interrupt+0x96/0xb0
 ? asm_sysvec_apic_timer_interrupt+0x16/0x20
 ? xas_load+0x74/0xe0
 ? xas_load+0x10/0xe0
 ? xas_find+0x162/0x1b0
 ? find_lock_entries+0x1ac/0x360
 ? find_lock_entries+0x76/0x360
 ? mapping_try_invalidate+0x5d/0x130
 ? generic_fadvise+0x110/0x240
 ? xfd_validate_state+0x1e/0x70
 ? ksys_fadvise64_64+0x50/0x90
 ? __x64_sys_fadvise64+0x18/0x20
 ? do_syscall_64+0x5d/0x180
 ? entry_SYSCALL_64_after_hwframe+0x4b/0x53
 </TASK>
task:reader          state:R  running task     stack:0     pid:1556  tgid:1551  ppid:1      flags:0x00004006

The reproducer takes ~30 seconds, and will lead to anywhere from 1..N
threads spinning here.

Now for the kicker - this doesn't reproduce in 6.10 and onwards. There
are only a few changes here that are relevant, seemingly, and the prime
candidates are:

commit a4864671ca0bf51c8e78242951741df52c06766f
Author: Kairui Song <kasong@tencent.com>
Date:   Tue Apr 16 01:18:55 2024 +0800

    lib/xarray: introduce a new helper xas_get_order

and the followup filemap change:

commit 6758c1128ceb45d1a35298912b974eb4895b7dd9
Author: Kairui Song <kasong@tencent.com>
Date:   Tue Apr 16 01:18:56 2024 +0800

    mm/filemap: optimize filemap folio adding

and reverting those two on 6.10 hits it again almost immediately. Didn't
look into these commit, but looks like they inadvertently also fixed
this corruption issue.

-- 
Jens Axboe

