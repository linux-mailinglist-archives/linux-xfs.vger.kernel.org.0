Return-Path: <linux-xfs+bounces-18266-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CAD2BA10A20
	for <lists+linux-xfs@lfdr.de>; Tue, 14 Jan 2025 16:00:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2EC583A487F
	for <lists+linux-xfs@lfdr.de>; Tue, 14 Jan 2025 14:59:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62C1E14F9ED;
	Tue, 14 Jan 2025 14:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f8Tz4pGp"
X-Original-To: linux-xfs@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA131547FF
	for <linux-xfs@vger.kernel.org>; Tue, 14 Jan 2025 14:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736866781; cv=none; b=c6snmq9YPFlqI1N565eZJcqjNO7qbUafVlJgUPcGdhLW6zLX39SCNbv00AaiQzNNnF9sqUX+f7khHeH/okuLG80Rkqmbmk2FJxBGnzLKjuYV7i0W/8uyhV+uBrBj/zVoihQltlN0zZOTIZaDFenXVkOIC6kGjLRI2gOZFLDa3/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736866781; c=relaxed/simple;
	bh=D5xm3vL9ujW8inQ5mfURHfB5H5PTk4LOQ8S+EKftCv4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LSjGaXeQHMGIDO6gd4Af1P4BDQGGIhPVXmDYDnvUHyiouAtx1dBRWgduwXHHwh8h/L58t3supMvBrGjA5SerRw5s3rt/trSVUul2xCJdh77bYocAcCdpty28pwAUWF5sfyvwjT1lUnd7FWEfo+KHyo5Ew2F72oDrojzXoldpkx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f8Tz4pGp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736866777;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=YOOFa4tjOJHbzYzB4ngXxpUasXqbBcdKvOApLshzGmU=;
	b=f8Tz4pGpGRQF+jI/wRn64nQPvajyUqbYkSb3j7FWopfzugSNRT8IBrlmy548F2zN0Whc4H
	aNsWyjCrbF+4RYHCBRHUjo4j/ekU0+2j7FJVp8Q9UYHgcw2t2KPIwdlav9FQ952pKv/6vt
	i1lOCSQfBUbSIwLP+rr3D4lySsMzTbU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-262-WEuEKy4oMjOKmntg2y2ZNA-1; Tue, 14 Jan 2025 09:59:36 -0500
X-MC-Unique: WEuEKy4oMjOKmntg2y2ZNA-1
X-Mimecast-MFC-AGG-ID: WEuEKy4oMjOKmntg2y2ZNA
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4359eb032c9so42836805e9.2
        for <linux-xfs@vger.kernel.org>; Tue, 14 Jan 2025 06:59:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736866774; x=1737471574;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YOOFa4tjOJHbzYzB4ngXxpUasXqbBcdKvOApLshzGmU=;
        b=NOOQt0gfAOW2fQdxVscyJikflVlWpsO6fSzMycNwGaBLNaftsDtecDoXep+hsY4I2z
         bi4JfESCc/0x+Rxr0VT3ok/LzXHMvuOIDEmgdJc95Y5LXLt4AueLPQw2iP7jgX4ysKU0
         mjFzEHMZwCQw7WQXgoj6A9uwfpTel+aWFY2053d7yXToydPL3218wQpcdY+G7Av7l9pe
         iyUd6VImQQch8SION/D33JL10ohqae0saCnzRKso3UXclhBh9J4RCBhSjjw8iWWvuP+H
         qFGgagUrBA0joFb4bof8kuHmTB4MF12HN1Vk1Rby6EkEgxfkV7+/xf8MTkvSYfltlrfz
         CFTw==
X-Forwarded-Encrypted: i=1; AJvYcCXKcblGytMWDwmUvmLdbz1awbSg3zpKOG3duiQuqdxxSDcpNUkA+w901YYbJ9Ygw7ofP14iQ5B4kmw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJBgnDtBuz039rlEC8q5D5SWQz/7yYprB91iPp8is8kJ7auBXw
	pDZaJuHbXSbcrfvS5aYVqam2hBT3NtQEM1mj5wCaLeFMilxgt3DKEr4j/Vira2aVpn7SQ+VzmlH
	Oudh8HRb18qDVwxuTq69kU/5GRhgG6pJXyFUz6A20D/nyXeL3KgUnJfW1Lg==
X-Gm-Gg: ASbGnctFPuhNMJGkXD1zo9Shcb0LLLRT7/uFq/82FsD91hW3auXRAaB4KO+yuDvANpX
	juyBQD9oDVTO3gXbJFjr6KwdiFE9ujLWIQyV38qLsJ2D+1rhi+5E+ZKNoCjdpNjVFPv5dTJ1RFG
	kWvruzvrLt/+5CE4l8zn8wiTT0/29AdYA3kAlnB1D6H3o2txSHOO8IO9zY4/NlKdHsbRl7qE7ob
	M50Jgrdqp4/hm0tZtJ3tJXhW4EucpFkIsp6TiZvOKi2qSGAkUmjrSn0IN1NL9mBuMrgQU2M5xVd
	OabkGY3ib4Wr1bDmUC9t9Z2juDObY0xuraRzuxq1UBxjjb87d+M1e65IhEeQJRJ5fxnausoDQJ6
	Jmo8S2p7C
X-Received: by 2002:a5d:64cc:0:b0:38a:86fe:52b3 with SMTP id ffacd0b85a97d-38a872e173emr22802715f8f.22.1736866774376;
        Tue, 14 Jan 2025 06:59:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHz2uZAV+J70P9YucwAztT9JSZ7+2iGUIBmkejGoMGYwNzGwovCPwKhDvjPwFBNmG0N05EWIg==
X-Received: by 2002:a5d:64cc:0:b0:38a:86fe:52b3 with SMTP id ffacd0b85a97d-38a872e173emr22802666f8f.22.1736866773899;
        Tue, 14 Jan 2025 06:59:33 -0800 (PST)
Received: from ?IPV6:2003:cb:c738:3100:8133:26cf:7877:94aa? (p200300cbc7383100813326cf787794aa.dip0.t-ipconnect.de. [2003:cb:c738:3100:8133:26cf:7877:94aa])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a8e38428bsm15089893f8f.37.2025.01.14.06.59.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jan 2025 06:59:33 -0800 (PST)
Message-ID: <927f9cef-3f97-4bef-b6d8-53e6ef1b78a8@redhat.com>
Date: Tue, 14 Jan 2025 15:59:31 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 11/26] mm: Allow compound zone device pages
To: Alistair Popple <apopple@nvidia.com>, akpm@linux-foundation.org,
 dan.j.williams@intel.com, linux-mm@kvack.org
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
 loongarch@lists.linux.dev, Jason Gunthorpe <jgg@nvidia.com>
References: <cover.11189864684e31260d1408779fac9db80122047b.1736488799.git-series.apopple@nvidia.com>
 <9210f90866fef17b54884130fb3e55ab410dd015.1736488799.git-series.apopple@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzSREYXZpZCBIaWxk
 ZW5icmFuZCA8ZGF2aWRAcmVkaGF0LmNvbT7CwZgEEwEIAEICGwMGCwkIBwMCBhUIAgkKCwQW
 AgMBAh4BAheAAhkBFiEEG9nKrXNcTDpGDfzKTd4Q9wD/g1oFAl8Ox4kFCRKpKXgACgkQTd4Q
 9wD/g1oHcA//a6Tj7SBNjFNM1iNhWUo1lxAja0lpSodSnB2g4FCZ4R61SBR4l/psBL73xktp
 rDHrx4aSpwkRP6Epu6mLvhlfjmkRG4OynJ5HG1gfv7RJJfnUdUM1z5kdS8JBrOhMJS2c/gPf
 wv1TGRq2XdMPnfY2o0CxRqpcLkx4vBODvJGl2mQyJF/gPepdDfcT8/PY9BJ7FL6Hrq1gnAo4
 3Iv9qV0JiT2wmZciNyYQhmA1V6dyTRiQ4YAc31zOo2IM+xisPzeSHgw3ONY/XhYvfZ9r7W1l
 pNQdc2G+o4Di9NPFHQQhDw3YTRR1opJaTlRDzxYxzU6ZnUUBghxt9cwUWTpfCktkMZiPSDGd
 KgQBjnweV2jw9UOTxjb4LXqDjmSNkjDdQUOU69jGMUXgihvo4zhYcMX8F5gWdRtMR7DzW/YE
 BgVcyxNkMIXoY1aYj6npHYiNQesQlqjU6azjbH70/SXKM5tNRplgW8TNprMDuntdvV9wNkFs
 9TyM02V5aWxFfI42+aivc4KEw69SE9KXwC7FSf5wXzuTot97N9Phj/Z3+jx443jo2NR34XgF
 89cct7wJMjOF7bBefo0fPPZQuIma0Zym71cP61OP/i11ahNye6HGKfxGCOcs5wW9kRQEk8P9
 M/k2wt3mt/fCQnuP/mWutNPt95w9wSsUyATLmtNrwccz63XOwU0EVcufkQEQAOfX3n0g0fZz
 Bgm/S2zF/kxQKCEKP8ID+Vz8sy2GpDvveBq4H2Y34XWsT1zLJdvqPI4af4ZSMxuerWjXbVWb
 T6d4odQIG0fKx4F8NccDqbgHeZRNajXeeJ3R7gAzvWvQNLz4piHrO/B4tf8svmRBL0ZB5P5A
 2uhdwLU3NZuK22zpNn4is87BPWF8HhY0L5fafgDMOqnf4guJVJPYNPhUFzXUbPqOKOkL8ojk
 CXxkOFHAbjstSK5Ca3fKquY3rdX3DNo+EL7FvAiw1mUtS+5GeYE+RMnDCsVFm/C7kY8c2d0G
 NWkB9pJM5+mnIoFNxy7YBcldYATVeOHoY4LyaUWNnAvFYWp08dHWfZo9WCiJMuTfgtH9tc75
 7QanMVdPt6fDK8UUXIBLQ2TWr/sQKE9xtFuEmoQGlE1l6bGaDnnMLcYu+Asp3kDT0w4zYGsx
 5r6XQVRH4+5N6eHZiaeYtFOujp5n+pjBaQK7wUUjDilPQ5QMzIuCL4YjVoylWiBNknvQWBXS
 lQCWmavOT9sttGQXdPCC5ynI+1ymZC1ORZKANLnRAb0NH/UCzcsstw2TAkFnMEbo9Zu9w7Kv
 AxBQXWeXhJI9XQssfrf4Gusdqx8nPEpfOqCtbbwJMATbHyqLt7/oz/5deGuwxgb65pWIzufa
 N7eop7uh+6bezi+rugUI+w6DABEBAAHCwXwEGAEIACYCGwwWIQQb2cqtc1xMOkYN/MpN3hD3
 AP+DWgUCXw7HsgUJEqkpoQAKCRBN3hD3AP+DWrrpD/4qS3dyVRxDcDHIlmguXjC1Q5tZTwNB
 boaBTPHSy/Nksu0eY7x6HfQJ3xajVH32Ms6t1trDQmPx2iP5+7iDsb7OKAb5eOS8h+BEBDeq
 3ecsQDv0fFJOA9ag5O3LLNk+3x3q7e0uo06XMaY7UHS341ozXUUI7wC7iKfoUTv03iO9El5f
 XpNMx/YrIMduZ2+nd9Di7o5+KIwlb2mAB9sTNHdMrXesX8eBL6T9b+MZJk+mZuPxKNVfEQMQ
 a5SxUEADIPQTPNvBewdeI80yeOCrN+Zzwy/Mrx9EPeu59Y5vSJOx/z6OUImD/GhX7Xvkt3kq
 Er5KTrJz3++B6SH9pum9PuoE/k+nntJkNMmQpR4MCBaV/J9gIOPGodDKnjdng+mXliF3Ptu6
 3oxc2RCyGzTlxyMwuc2U5Q7KtUNTdDe8T0uE+9b8BLMVQDDfJjqY0VVqSUwImzTDLX9S4g/8
 kC4HRcclk8hpyhY2jKGluZO0awwTIMgVEzmTyBphDg/Gx7dZU1Xf8HFuE+UZ5UDHDTnwgv7E
 th6RC9+WrhDNspZ9fJjKWRbveQgUFCpe1sa77LAw+XFrKmBHXp9ZVIe90RMe2tRL06BGiRZr
 jPrnvUsUUsjRoRNJjKKA/REq+sAnhkNPPZ/NNMjaZ5b8Tovi8C0tmxiCHaQYqj7G2rgnT0kt
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <9210f90866fef17b54884130fb3e55ab410dd015.1736488799.git-series.apopple@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10.01.25 07:00, Alistair Popple wrote:
> Zone device pages are used to represent various type of device memory
> managed by device drivers. Currently compound zone device pages are
> not supported. This is because MEMORY_DEVICE_FS_DAX pages are the only
> user of higher order zone device pages and have their own page
> reference counting.
> 
> A future change will unify FS DAX reference counting with normal page
> reference counting rules and remove the special FS DAX reference
> counting. Supporting that requires compound zone device pages.
> 
> Supporting compound zone device pages requires compound_head() to
> distinguish between head and tail pages whilst still preserving the
> special struct page fields that are specific to zone device pages.
> 
> A tail page is distinguished by having bit zero being set in
> page->compound_head, with the remaining bits pointing to the head
> page. For zone device pages page->compound_head is shared with
> page->pgmap.
> 
> The page->pgmap field is common to all pages within a memory section.
> Therefore pgmap is the same for both head and tail pages and can be
> moved into the folio and we can use the standard scheme to find
> compound_head from a tail page.

The more relevant thing is that the pgmap field must be common to all 
pages in a folio, even if a folio exceeds memory sections (e.g., 128 MiB 
on x86_64 where we have 1 GiB folios).

 > > Signed-off-by: Alistair Popple <apopple@nvidia.com>
> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> 
> ---
> 
> Changes for v4:
>   - Fix build breakages reported by kernel test robot
> 
> Changes since v2:
> 
>   - Indentation fix
>   - Rename page_dev_pagemap() to page_pgmap()
>   - Rename folio _unused field to _unused_pgmap_compound_head
>   - s/WARN_ON/VM_WARN_ON_ONCE_PAGE/
> 
> Changes since v1:
> 
>   - Move pgmap to the folio as suggested by Matthew Wilcox
> ---

[...]

>   static inline bool folio_is_device_coherent(const struct folio *folio)
> diff --git a/include/linux/migrate.h b/include/linux/migrate.h
> index 29919fa..61899ec 100644
> --- a/include/linux/migrate.h
> +++ b/include/linux/migrate.h
> @@ -205,8 +205,8 @@ struct migrate_vma {
>   	unsigned long		end;
>   
>   	/*
> -	 * Set to the owner value also stored in page->pgmap->owner for
> -	 * migrating out of device private memory. The flags also need to
> +	 * Set to the owner value also stored in page_pgmap(page)->owner
> +	 * for migrating out of device private memory. The flags also need to
>   	 * be set to MIGRATE_VMA_SELECT_DEVICE_PRIVATE.
>   	 * The caller should always set this field when using mmu notifier
>   	 * callbacks to avoid device MMU invalidations for device private
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index df8f515..54b59b8 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -129,8 +129,11 @@ struct page {
>   			unsigned long compound_head;	/* Bit zero is set */
>   		};
>   		struct {	/* ZONE_DEVICE pages */
> -			/** @pgmap: Points to the hosting device page map. */
> -			struct dev_pagemap *pgmap;
> +			/*
> +			 * The first word is used for compound_head or folio
> +			 * pgmap
> +			 */
> +			void *_unused_pgmap_compound_head;
>   			void *zone_device_data;
>   			/*
>   			 * ZONE_DEVICE private pages are counted as being
> @@ -299,6 +302,7 @@ typedef struct {
>    * @_refcount: Do not access this member directly.  Use folio_ref_count()
>    *    to find how many references there are to this folio.
>    * @memcg_data: Memory Control Group data.
> + * @pgmap: Metadata for ZONE_DEVICE mappings
>    * @virtual: Virtual address in the kernel direct map.
>    * @_last_cpupid: IDs of last CPU and last process that accessed the folio.
>    * @_entire_mapcount: Do not use directly, call folio_entire_mapcount().
> @@ -337,6 +341,7 @@ struct folio {
>   	/* private: */
>   				};
>   	/* public: */
> +				struct dev_pagemap *pgmap;

Agreed, that should work.

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers,

David / dhildenb


