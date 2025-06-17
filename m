Return-Path: <linux-xfs+bounces-23248-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3ECBBADC63A
	for <lists+linux-xfs@lfdr.de>; Tue, 17 Jun 2025 11:25:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 692663AC904
	for <lists+linux-xfs@lfdr.de>; Tue, 17 Jun 2025 09:25:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D92928C2C7;
	Tue, 17 Jun 2025 09:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G+/69HX5"
X-Original-To: linux-xfs@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A7A61C7017
	for <linux-xfs@vger.kernel.org>; Tue, 17 Jun 2025 09:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750152331; cv=none; b=jTxL0gwEFx44WdJJwqQrl7bojG6xWHCx+vgGfPUDMLZCaKbnP7jkc9UcAmBYW6HU+j9vDhBz1N00H7IbpHyvd7DI0KRsJCmpMlktcJMbj0EhNEbNAQNOBdXyglG5V5f2GM0xOq5MgrY9ze1HblSDoz6CGfMF6hAPpz9nQrIEE0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750152331; c=relaxed/simple;
	bh=wWhnXAyX2CPjsnfMuHGcrmqHfLEOeRFBGDWPGeExTLI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n4kJsVwKTlB9F9tKzRKItu6tRPKPOfRdZt5pA3BIsjME9mf3EXztx2EdKvmXpMkj5dsdvXy4ydykZnKEAxr3yopQ88OJhwVUOaACfhvf8A5NYboef+dN/uWMnuIbqWAcqKSN5KzhCJQfLNtGGxAAGCX8BQA9kvqYKI3ZrGn2Yck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=G+/69HX5; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750152328;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6zkQFw/Ch3T6ugLEDBuaz32yOTGmLuefrLkmwqJMJuQ=;
	b=G+/69HX5wzqpimVioWIuaCiZ64S6fBs2/IASn8ZhbbTVj1rYa78GnPpw9kyxoDhIx+5vck
	4ac9Z8sJzLJGxUOcwaJiSnMcUR0Ufw4fCDuJXsM75Wy5yo/XIPBQ2zxF8hLCrm8X2IY375
	90gRRpdtF53DcoKmiCJlDgCEgh0tBck=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-368-99TdPVIIMheW_LizMtLTRQ-1; Tue, 17 Jun 2025 05:25:18 -0400
X-MC-Unique: 99TdPVIIMheW_LizMtLTRQ-1
X-Mimecast-MFC-AGG-ID: 99TdPVIIMheW_LizMtLTRQ_1750152317
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45311704cdbso28297215e9.1
        for <linux-xfs@vger.kernel.org>; Tue, 17 Jun 2025 02:25:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750152317; x=1750757117;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6zkQFw/Ch3T6ugLEDBuaz32yOTGmLuefrLkmwqJMJuQ=;
        b=DZCFLtY7yZDK185MchXaavERk977GVea7QPie1l1PxKrahNss1pMpMUAhXvF2OFJyD
         wshUDyp7JhQyOhlfRpdUhGg3RoR2GBqOzMELb4N7l9tETqQoBBJJ79t15s7RIF4V1pov
         /QSI1RVgV1rfDGSqqwewPOgN4LgfnFDmnixD7a3uU7CmYUTWdCb0k5wv2T15XYrIW8a0
         0h41UctoK/gup/ArwbEJcaWxXx7/5kEUypI20AWyz3HenHV+rfRYTCO6T4E+SrqP+5GV
         VeQiK9ROeWOYF0P01MC5vt43pbpr5RNFEV7lv5XKtc1dJP2wE/JUV05vTIXJKJgV2tKX
         HaZg==
X-Forwarded-Encrypted: i=1; AJvYcCXD0lMles0dSFGmtN9uWF9cJJN3xrgIqkBMH4xjvmKKEx22qYjmnHRsOYKxZioF4ewNIBfJ+MMW7AY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJIGPzAmjDx6bChIHD6thZIAlJY1J6Hq1S7IgWKyqYbM8JBND3
	mO1/ra7HQiWVwwIAPCAoifms8gx9Qd7eJElJ5ybr5Z6czb9ZLcmy9k5ctsAeAFfZSTzxjtwFvzU
	240zFn6MhCTIyuBvaM28nrqX1eNpH3d/7LMY0rPw9p5r9j0sY20j1eT7v6iv9Cw==
X-Gm-Gg: ASbGncvk0nkzATEgdLkJfEN1CKXeHL+EECKRlyEg1P3MjZRCr5c72sCpJEcuZ+9MBvf
	jCadortLE3XmerrQUwi0j5ig1z+AmHzytFKTOSL9lOtdvHNYV05O2mp69WLlABsCTsAs7NnS0A/
	z1UljYPw7MF45w4RNSFKRKMlBFuZyjZgubTGf3k3E/EDPw47GYT6tlMSMFAe4GYdIXQtivH9vCC
	FoRy3vzmNbcBL/rT3nH0KonK7bbap4NZMbxxr8GIcAR8jkhwXluRn/yCCNY/k6r19p2BPc2u40I
	4qcnUocO/6J5muY4lIbTs1TJ4F13xV2Wa0EHhsaPV0U2qSp698QlHpWUrfZ+N3knvczSDfqogIS
	hwuu2yoyxKhNUh147WOk0Z+S9IdB5jN+Amh/00WQr9hikRZA=
X-Received: by 2002:a05:6000:1447:b0:3a5:2fad:17af with SMTP id ffacd0b85a97d-3a572e58cbemr8127094f8f.57.1750152316864;
        Tue, 17 Jun 2025 02:25:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHNVa+RJrykc/8Xieu2BbPmReEGJ3iCm4JfplZNxZv4/8Vep/Wlu6kppgIaFWfNuw/GXp3OKw==
X-Received: by 2002:a05:6000:1447:b0:3a5:2fad:17af with SMTP id ffacd0b85a97d-3a572e58cbemr8127063f8f.57.1750152316374;
        Tue, 17 Jun 2025 02:25:16 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f31:700:3851:c66a:b6b9:3490? (p200300d82f3107003851c66ab6b93490.dip0.t-ipconnect.de. [2003:d8:2f31:700:3851:c66a:b6b9:3490])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a568b087f8sm13629833f8f.53.2025.06.17.02.25.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jun 2025 02:25:15 -0700 (PDT)
Message-ID: <6afc2e67-3ecb-41a5-9c8f-00ecd64f035a@redhat.com>
Date: Tue, 17 Jun 2025 11:25:14 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 02/14] mm: Filter zone device pages returned from
 folio_walk_start()
To: Alistair Popple <apopple@nvidia.com>, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, gerald.schaefer@linux.ibm.com,
 dan.j.williams@intel.com, jgg@ziepe.ca, willy@infradead.org,
 linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-xfs@vger.kernel.org, jhubbard@nvidia.com, hch@lst.de,
 zhang.lyra@gmail.com, debug@rivosinc.com, bjorn@kernel.org,
 balbirs@nvidia.com, lorenzo.stoakes@oracle.com,
 linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-cxl@vger.kernel.org, dri-devel@lists.freedesktop.org, John@Groves.net,
 m.szyprowski@samsung.com
References: <cover.8d04615eb17b9e46fc0ae7402ca54b69e04b1043.1750075065.git-series.apopple@nvidia.com>
 <11dd5b70546ec67593a4bf79f087b113f15d6bb1.1750075065.git-series.apopple@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <11dd5b70546ec67593a4bf79f087b113f15d6bb1.1750075065.git-series.apopple@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 16.06.25 13:58, Alistair Popple wrote:
> Previously dax pages were skipped by the pagewalk code as pud_special() or
> vm_normal_page{_pmd}() would be false for DAX pages. Now that dax pages are
> refcounted normally that is no longer the case, so the pagewalk code will
> start returning them.
> 
> Most callers already explicitly filter for DAX or zone device pages so
> don't need updating. However some don't, so add checks to those callers.
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> 
> ---
> 
> Changes since v1:
> 
>   - Dropped "mm/pagewalk: Skip dax pages in pagewalk" and replaced it
>     with this new patch for v2
> 
>   - As suggested by David and Jason we can filter the folios in the
>     callers instead of doing it in folio_start_walk(). Most callers
>     already do this (see below).
> 
> I audited all callers of folio_walk_start() and found the following:
> 
> mm/ksm.c:
> 
> break_ksm() - doesn't need to filter zone_device pages because the can
> never be KSM pages.
> 
> get_mergeable_page() - already filters out zone_device pages.
> scan_get_next_rmap_iterm() - already filters out zone_device_pages.
> 
> mm/huge_memory.c:
> 
> split_huge_pages_pid() - already checks for DAX with
> vma_not_suitable_for_thp_split()
> 
> mm/rmap.c:
> 
> make_device_exclusive() - only works on anonymous pages, although
> there'd be no issue with finding a DAX page even if support was extended
> to file-backed pages.
> 
> mm/migrate.c:
> 
> add_folio_for_migration() - already checks the vma with vma_migratable()
> do_pages_stat_array() - explicitly checks for zone_device folios
> 
> kernel/event/uprobes.c:
> 
> uprobe_write_opcode() - only works on anonymous pages, not sure if
> zone_device could ever work so add an explicit check
> 
> arch/s390/mm/fault.c:
> 
> do_secure_storage_access() - not sure so be conservative and add a check
> 
> arch/s390/kernel/uv.c:
> 
> make_hva_secure() - not sure so be conservative and add a check
> ---
>   arch/s390/kernel/uv.c   | 2 +-
>   arch/s390/mm/fault.c    | 2 +-
>   kernel/events/uprobes.c | 2 +-
>   3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index b99478e..55aa280 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -424,7 +424,7 @@ int make_hva_secure(struct mm_struct *mm, unsigned long hva, struct uv_cb_header
>   		return -EFAULT;
>   	}
>   	folio = folio_walk_start(&fw, vma, hva, 0);
> -	if (!folio) {
> +	if (!folio || folio_is_zone_device(folio)) {
>   		mmap_read_unlock(mm);
>   		return -ENXIO;
>   	}
> diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
> index e1ad05b..df1a067 100644
> --- a/arch/s390/mm/fault.c
> +++ b/arch/s390/mm/fault.c
> @@ -449,7 +449,7 @@ void do_secure_storage_access(struct pt_regs *regs)
>   		if (!vma)
>   			return handle_fault_error(regs, SEGV_MAPERR);
>   		folio = folio_walk_start(&fw, vma, addr, 0);
> -		if (!folio) {
> +		if (!folio || folio_is_zone_device(folio)) {
>   			mmap_read_unlock(mm);
>   			return;
>   		}

Curious, does s390 even support ZONE_DEVICE and could trigger this?

> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index 8a601df..f774367 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -539,7 +539,7 @@ int uprobe_write_opcode(struct arch_uprobe *auprobe, struct vm_area_struct *vma,
>   	}
>   
>   	ret = 0;
> -	if (unlikely(!folio_test_anon(folio))) {
> +	if (unlikely(!folio_test_anon(folio) || folio_is_zone_device(folio))) {
>   		VM_WARN_ON_ONCE(is_register);
>   		folio_put(folio);
>   		goto out;

I wonder if __uprobe_write_opcode() would just work with anon device folios?

We only modify page content, and conditionally zap the page. Would there 
be a problem with anon device folios?

-- 
Cheers,

David / dhildenb


