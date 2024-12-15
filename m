Return-Path: <linux-xfs+bounces-16897-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E40E69F1FAC
	for <lists+linux-xfs@lfdr.de>; Sat, 14 Dec 2024 16:23:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 22C721886380
	for <lists+linux-xfs@lfdr.de>; Sat, 14 Dec 2024 15:23:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B08519992C;
	Sat, 14 Dec 2024 15:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PVxNFLLI"
X-Original-To: linux-xfs@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33ABE194AEE
	for <linux-xfs@vger.kernel.org>; Sat, 14 Dec 2024 15:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734189790; cv=none; b=qNxSGVQwdfMySw9WEJJbE/p1XbTT0rgE6wFbO7Cc+1h6XJXIJPv0Q/D8jr1d0Ei5NbucEezd3A+S1vTkKcU8c7ZQUUbuamdZuEPKBKUN5eAMyssLtib5vZZwXFz70T47FppzejIHwRHMLo1O6xKacnTRIK8FIuhBMwYgy0wwK3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734189790; c=relaxed/simple;
	bh=jkdG9VVa/wTY2yy0geXHQ0O4Psz84VzAmqde2au0yKQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QcXB3JESreJ11rL5CuFMQSP2xouXONIKKKGyKwWrkF+Np1i5ECo+5rX+AbNYQYJBohO3NAxevhAcvPn4jC9W5JcD91qwpXB1KeQjlAku6aAQmXQk1lAdzNNh2xWiSVkOifvfvR3Pxb/UfDzHr2c82po0qsxDbsO7/IAdBfav56Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PVxNFLLI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734189787;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=WzJW0Dxa8i83uf13tdPe4mY1mNQ+O1FvKqm+giPK/c8=;
	b=PVxNFLLIZ8ckeORn0BbM0TPZLvWvhCSoFEHpsg2oeJCM0mnZp+S5qC20NvJq8FSAruPqW6
	/vny9JsamR3m0vJA07TTkks5E+LWM3GI9UuLrxwShP/FWK9DzJ4c2k/X5j+QJkzyFvrHQ2
	COAysVGHZz9FZ8FQzIWcsl0tSnNyQ50=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-507-TmFXr5VSOs6hw4cwRbsoWQ-1; Sat, 14 Dec 2024 10:23:04 -0500
X-MC-Unique: TmFXr5VSOs6hw4cwRbsoWQ-1
X-Mimecast-MFC-AGG-ID: TmFXr5VSOs6hw4cwRbsoWQ
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4362153dcd6so15415775e9.2
        for <linux-xfs@vger.kernel.org>; Sat, 14 Dec 2024 07:23:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734189783; x=1734794583;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=WzJW0Dxa8i83uf13tdPe4mY1mNQ+O1FvKqm+giPK/c8=;
        b=CBWpquKOH0/Enx2MzLlJ7vIysIfHibGz0xvjYgr30FVzkKTz98WDF9yMz+ZIp3wNT1
         mJUjy0RPcnGuiH0ru59ALkl71GQ3QmjpviSDF97IVLyS42LNiuTlTvbCnU16L3iZg5VO
         n8gLJqYkMVj4hxBIjmaIvc+XmicuAeGZpoC6HK5YX0PrDbn2Xa63C0jc/OyVyG1bC7Lm
         ah795NFjAd5uSo5/ZIjAPn2pPKVYs/gshezVoSSAkfW2mJC+vo4U0EC3iP0ynGiixSYx
         6JGazxoduCQaD9dFxi4L8dpxtmU2OVeqmS22+802wnXCDCzTwuC2W/9Cd9FYNSpxQZV9
         G1/g==
X-Forwarded-Encrypted: i=1; AJvYcCVqUUzi3xRfseX6/Fl32lxpmW1bghlK5FgyVqgtwnA4wEpHxBlkTXmDgM3riqFNl9+prW/sXgHaZYs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxzucwah680LNLtqWiktRJlvRH/4rT844vssH3XqEQP6htsZXre
	z8eHLoBTk4USpEpi5iLfhfWMLlKb8LU8b5gGa4xyqGQ978rG2MQ5LUuLR4JKSJhu+pVInbvZR6m
	imR5g2KW6AolIBUYoZHZetO5GSUjQJ9km8f6zHUfadge7f9B9FkNFAHHdSw==
X-Gm-Gg: ASbGncsKL8N+meDdwXoVbO0DLX0OqWcTXK8wmvvUKHVInkqmXCx2ILofQVvFTGAR2dM
	dvbqlAO4bBbw5bXq+7t+SNRTTYVYRdutfDnLToUikD55nTsx3GMQgCenxM5B6eh6XnVVmj7a0Cc
	TRwqqSyZ3+0FVMAogtgZR0Q7cuo/qMvD8gm+tmMR1IKPMTXfhEw8I1tMhm4l1VrluZv42jwUvi2
	QuMjUbmZDWoGFZqNiikoZVjS0A/6pVBCMFH3eysqH20T6NGIukmgM5g/NzGFSRtMlH1+ZRuufxA
	bedhhSSJLAQ/BTgaXRcMKoIPAIF+51lk13p1vwfZynZhe9UivHm1llsR0Tn2fR4PPT7HJ8a67fR
	56F5MzURA
X-Received: by 2002:a05:600c:1c07:b0:434:a968:89a3 with SMTP id 5b1f17b1804b1-4362aa2e544mr63037775e9.9.1734189783514;
        Sat, 14 Dec 2024 07:23:03 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFroEMk6tFJ9Cy5+aMYXPulXjntj5yFN5KYCR5CVhsKcoZETtTRpp5EY+z8zXmRnRx7Xb1Kzg==
X-Received: by 2002:a05:600c:1c07:b0:434:a968:89a3 with SMTP id 5b1f17b1804b1-4362aa2e544mr63037545e9.9.1734189783051;
        Sat, 14 Dec 2024 07:23:03 -0800 (PST)
Received: from ?IPV6:2003:cb:c711:6400:d1b9:21c5:b517:5f4e? (p200300cbc7116400d1b921c5b5175f4e.dip0.t-ipconnect.de. [2003:cb:c711:6400:d1b9:21c5:b517:5f4e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43625550518sm82347835e9.5.2024.12.14.07.22.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Dec 2024 07:23:01 -0800 (PST)
Message-ID: <45555f72-e82a-4196-94af-22d05d6ac947@redhat.com>
Date: Sat, 14 Dec 2024 16:22:58 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/25] fs/dax: Fix ZONE_DEVICE page reference counts
To: Dan Williams <dan.j.williams@intel.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org
Cc: lina@asahilina.net, zhang.lyra@gmail.com, gerald.schaefer@linux.ibm.com,
 vishal.l.verma@intel.com, dave.jiang@intel.com, logang@deltatee.com,
 bhelgaas@google.com, jack@suse.cz, jgg@ziepe.ca, catalin.marinas@arm.com,
 will@kernel.org, mpe@ellerman.id.au, npiggin@gmail.com,
 dave.hansen@linux.intel.com, ira.weiny@intel.com, willy@infradead.org,
 djwong@kernel.org, tytso@mit.edu, linmiaohe@huawei.com, peterx@redhat.com,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-xfs@vger.kernel.org, jhubbard@nvidia.com, hch@lst.de,
 david@fromorbit.com, akpm@linux-foundation.org, sfr@canb.auug.org.au
References: <cover.e1ebdd6cab9bde0d232c1810deacf0bae25e6707.1732239628.git-series.apopple@nvidia.com>
 <675ce1e5a3d68_fad0294d0@dwillia2-xfh.jf.intel.com.notmuch>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <675ce1e5a3d68_fad0294d0@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 14.12.24 02:39, Dan Williams wrote:
> [ add akpm and sfr for next steps ]
> 
> Alistair Popple wrote:
>> Main updates since v2:
>>
>>   - Rename the DAX specific dax_insert_XXX functions to vmf_insert_XXX
>>     and have them pass the vmf struct.
>>
>>   - Seperate out the device DAX changes.
>>
>>   - Restore the page share mapping counting and associated warnings.
>>
>>   - Rework truncate to require file-systems to have previously called
>>     dax_break_layout() to remove the address space mapping for a
>>     page. This found several bugs which are fixed by the first half of
>>     the series. The motivation for this was initially to allow the FS
>>     DAX page-cache mappings to hold a reference on the page.
>>
>>     However that turned out to be a dead-end (see the comments on patch
>>     21), but it found several bugs and I think overall it is an
>>     improvement so I have left it here.
>>
>> Device and FS DAX pages have always maintained their own page
>> reference counts without following the normal rules for page reference
>> counting. In particular pages are considered free when the refcount
>> hits one rather than zero and refcounts are not added when mapping the
>> page.
>>
>> Tracking this requires special PTE bits (PTE_DEVMAP) and a secondary
>> mechanism for allowing GUP to hold references on the page (see
>> get_dev_pagemap). However there doesn't seem to be any reason why FS
>> DAX pages need their own reference counting scheme.
>>
>> By treating the refcounts on these pages the same way as normal pages
>> we can remove a lot of special checks. In particular pXd_trans_huge()
>> becomes the same as pXd_leaf(), although I haven't made that change
>> here. It also frees up a valuable SW define PTE bit on architectures
>> that have devmap PTE bits defined.
>>
>> It also almost certainly allows further clean-up of the devmap managed
>> functions, but I have left that as a future improvment. It also
>> enables support for compound ZONE_DEVICE pages which is one of my
>> primary motivators for doing this work.
> 
> So this is feeling ready for -next exposure, and ideally merged for v6.14. I
> see the comments from John and Bjorn and that you were going to respin for
> that, but if it's just those details things they can probably be handled
> incrementally.
> 
> Alistair, are you ready for this to hit -next?
> 
> As for which tree...
> 
> Andrew, we could take this through -mm, but my first instinct would be to try
> to take it through nvdimm.git mainly to offload any conflict wrangling work and
> small fixups which are likely to be an ongoing trickle.
> 
> However, I am not going to put up much of a fight if others prefer this go
> through -mm.
> 
> Thoughts?

I'm in the process of preparing v2 of [1] that will result in conflicts 
with this series in the rmap code (in particular [PATCH v3 14/25] 
huge_memory: Allow mappings of PUD sized pages).

I'll be away for 2 weeks over Christmas, but I assume I'll manage to 
post v2 shortly.

Which reminds me that I still have to take a closer look at some things 
in this series :) Especially also #14 regarding accounting.

I wonder if we could split out the rmap changes in #14, and have that 
patch simply in two trees? No idea.

[1] 
https://lore.kernel.org/all/20240829165627.2256514-1-david@redhat.com/T/#u

-- 
Cheers,

David / dhildenb


