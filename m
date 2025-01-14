Return-Path: <linux-xfs+bounces-18272-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B682A10C98
	for <lists+linux-xfs@lfdr.de>; Tue, 14 Jan 2025 17:46:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E13911651DE
	for <lists+linux-xfs@lfdr.de>; Tue, 14 Jan 2025 16:46:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AFE21CAA7C;
	Tue, 14 Jan 2025 16:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aRXVFrW4"
X-Original-To: linux-xfs@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ACE8159209
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jan 2025 16:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736873154; cv=none; b=LFJjc2CwE9J6bGcYG/J4f324+Zq09rw7t6YyCLd/4D1NnA0mU+IgCADE1F2foEUREE8EKbqI5KX5F+eH8pHtcbEv7ENOUgLOyvXFLEOOWzhhHuxQT4N0f4gkczUySg26MDcD+PE3PSqjvRaqFWIqTsQdvCyCPsP2bXnyniW1Xu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736873154; c=relaxed/simple;
	bh=rrRunl5fM4Cc4qWxOaFz446M0Mu44CqyepFmMGoS0S4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XuR4/1QfPOn8a70codmK2CO06uIGXaTXz6z0p4OFAsITs4bwKr3T2hyD2LuEvtEEGpaQxTgUX0SfPziplJiU246h1WNT83IrQdw3gGH2XiKV2HfH7uaM3ycO7PPdcFZXesAliys+0T8I04gxF/RvtO5YSKHF4ffHZpPp1ONj7Ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aRXVFrW4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736873151;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=iYdAwCr8qGYS0S8rKw89Mhn+3rwLqpam4TbyhY+NPyI=;
	b=aRXVFrW4NKSOV5nCiyMajEN7VFqmtV5lBkPuS+M54DPpiZ2mFMsgESMhpDImBV97mWgsj0
	gmrpL4hgBCqOr+XeNcBNZHgS0xD1BG3l5S9HRF+qXU7dKNM1/TgNeqdMewsCVPE8e2C4gK
	R3DWdLzhMca7o0U8lJVvTO/GKYuBD1s=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-310-Kzwon0DpMruYjTVse2uhOA-1; Tue, 14 Jan 2025 11:45:50 -0500
X-MC-Unique: Kzwon0DpMruYjTVse2uhOA-1
X-Mimecast-MFC-AGG-ID: Kzwon0DpMruYjTVse2uhOA
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4361f371908so39218245e9.0
        for <linux-xfs@vger.kernel.org>; Tue, 14 Jan 2025 08:45:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736873149; x=1737477949;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=iYdAwCr8qGYS0S8rKw89Mhn+3rwLqpam4TbyhY+NPyI=;
        b=fzFAdHczmxUMiBbA7ef3iPk89k9wFR72yNJRrlvyexG9OTQyCwhHi3KdUWDhIzSwvE
         eIulHnEyvRAp51PbvneLRkm0sjs1bSC5KqfGT+3VNb5LHc2zEkyo/TcEzrE6r3XemVzP
         BpYh7eTpqwhlK7FetP9Duk8L458kU+zUZxJU/CyrFoAfDmRcqeDydB53jAGERYqMXH/g
         hdjItX7F1GpVN2WQDhTL2g9JfESbeSkNxvVTWHpvuvTiKqjSSRiRBImdNU1ZlSmJVoLa
         gsADuoAli5x4LYmco7b9HGE3VG+I5wc345yAoEcAr7nraPZN4iMzfcNf8+x5UZ/5ww5S
         Jngw==
X-Forwarded-Encrypted: i=1; AJvYcCWx482x5abucZ/jDMaW5eqvdlry4TRgf21KUNtUjEbBBfNBafCRclAxnzxVdd8ohO9PxJcI1p+Q6+w=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3CcHu4ChCyl69gJubdRpTmlcB94uvYsGu/4ZI94jD1su///Sq
	GqOfDVDUCX0kMqV4hxFpItgPahQsNJlqAN2IWTIru9mFIBoi8cZfj2hSSdkhUasdnP9s+j/Q+Ds
	7AZKfK2tkweKOFCs4YCwlnW504mRuGI208rjfqBzP+BDVurjEVnaWDh9pgQ==
X-Gm-Gg: ASbGncvwCl+HaBIW0/1stjDfoNiHXb7kfkIMS2EC2xnWlsu9Ule605K89h/qSYCVDT8
	5ZJOyaG/lGU6JN7Vg8X5MRgs/XgZc2luW4pye1wLbITIgM0X3n40H1EebIxekeOA8EN30ZsT2VF
	L+5H58eiLSMZZxyxCyzqM5IT0GzIgA0BvbO/EOON2VKU/bP37Ikbb+qIyAlqX9psR1RmeITtykH
	4WxFBo/vzVsuj9KshlGFl6WuIfPBKk1G1Sa5MsK889LApbpDEov3tMqs86L9E1WCo2CqffjVC/3
	ur0qXae7JyGbBEOKVeAIoUL+Sg/4Oc7Yh0uSNpMjF8cpQKSS23Vx5UFjmaIIPj9QfKkTfrWrkrK
	+cSyyg0qV
X-Received: by 2002:a05:6000:4020:b0:385:e3c1:50d5 with SMTP id ffacd0b85a97d-38a87338fa8mr26780518f8f.48.1736873148979;
        Tue, 14 Jan 2025 08:45:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEz/61i1ZjhaPWPp1WC6/vgt/fDvbl6dYaUXZA+9G8OX1twYhKZREnloz3KEM1phDS6xL7CAQ==
X-Received: by 2002:a05:6000:4020:b0:385:e3c1:50d5 with SMTP id ffacd0b85a97d-38a87338fa8mr26780479f8f.48.1736873148535;
        Tue, 14 Jan 2025 08:45:48 -0800 (PST)
Received: from ?IPV6:2003:cb:c738:3100:8133:26cf:7877:94aa? (p200300cbc7383100813326cf787794aa.dip0.t-ipconnect.de. [2003:cb:c738:3100:8133:26cf:7877:94aa])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a8e320329sm15298458f8f.0.2025.01.14.08.45.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jan 2025 08:45:48 -0800 (PST)
Message-ID: <86efded9-c1d9-4efb-bf41-f67faa49bf69@redhat.com>
Date: Tue, 14 Jan 2025 17:45:46 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 19/26] proc/task_mmu: Mark devdax and fsdax pages as
 always unpinned
To: Dan Williams <dan.j.williams@intel.com>,
 Alistair Popple <apopple@nvidia.com>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: alison.schofield@intel.com, lina@asahilina.net, zhang.lyra@gmail.com,
 gerald.schaefer@linux.ibm.com, vishal.l.verma@intel.com,
 dave.jiang@intel.com, logang@deltatee.com, bhelgaas@google.com,
 jack@suse.cz, jgg@ziepe.ca, catalin.marinas@arm.com, will@kernel.org,
 mpe@ellerman.id.au, npiggin@gmail.com, dave.hansen@linux.intel.com,
 ira.weiny@intel.com, willy@infradead.org, djwong@kernel.org, tytso@mit.edu,
 linmiaohe@huawei.com, peterx@redhat.com, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linuxppc-dev@lists.ozlabs.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, jhubbard@nvidia.com,
 hch@lst.de, david@fromorbit.com, chenhuacai@kernel.org, kernel@xen0n.name,
 loongarch@lists.linux.dev
References: <cover.11189864684e31260d1408779fac9db80122047b.1736488799.git-series.apopple@nvidia.com>
 <d7a6c9822ddc945daaf4f9db34d3f2b1c0454447.1736488799.git-series.apopple@nvidia.com>
 <6785cbb7125bf_20fa29418@dwillia2-xfh.jf.intel.com.notmuch>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <6785cbb7125bf_20fa29418@dwillia2-xfh.jf.intel.com.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 14.01.25 03:28, Dan Williams wrote:
> Alistair Popple wrote:
>> The procfs mmu files such as smaps and pagemap currently ignore devdax and
>> fsdax pages because these pages are considered special. A future change
>> will start treating these as normal pages, meaning they can be exposed via
>> smaps and pagemap.
>>
>> The only difference is that devdax and fsdax pages can never be pinned for
>> DMA via FOLL_LONGTERM, so add an explicit check in pte_is_pinned() to
>> reflect that.
> 
> I don't understand this patch.


This whole pte_is_pinned() should likely be ripped out (and I have a 
patch here to do that for a long time).

But that's a different discussion.

> 
> pin_user_pages() is also used for Direct-I/O page pinning, so the
> comment about FOLL_LONGTERM is wrong, and I otherwise do not understand
> what goes wrong if the only pte_is_pinned() user correctly detects the
> pin state?

Yes, this patch should likely just be dropped.

Even if folio_maybe_dma_pinned() == true because of "false positives", 
it will behave just like other order-0 pages with false positives, and 
only affect soft-dirty tracking ... which nobody should be caring about 
here at all.

We would always detect the PTE as soft-dirty because we we never
	pte_wrprotect(old_pte)

Yes, nobody should care.

-- 
Cheers,

David / dhildenb


