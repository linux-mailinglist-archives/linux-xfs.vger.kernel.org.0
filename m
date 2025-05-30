Return-Path: <linux-xfs+bounces-22755-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 284DEAC8B3A
	for <lists+linux-xfs@lfdr.de>; Fri, 30 May 2025 11:43:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 67F003BBFEA
	for <lists+linux-xfs@lfdr.de>; Fri, 30 May 2025 09:42:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3753822D7A3;
	Fri, 30 May 2025 09:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F3eRGqSf"
X-Original-To: linux-xfs@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7615221D9C
	for <linux-xfs@vger.kernel.org>; Fri, 30 May 2025 09:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748597850; cv=none; b=m5VYdTf569hH17kgaN+Df9H66iuz2CFDewdr77aIFUg3NagrBx85rjftDpKZhE/FDlSz9n9w0yqLwRgSPUoJfVmhrnUUmUQlaVK8l6IZhux2jDn7hC8gtc4kmVy1UHeqJXiEZfo94Nlp45kPQfAyIyxweAuv85MvafLcTI0QYz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748597850; c=relaxed/simple;
	bh=Vo15I+t4ldDz+udo0/J6K2wEPwd7uOm20jAwOh5675U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FIXjLdBZ2VdfnnkxRFjo6SQ/Xl0HSwMmGrY0uAO2prcakFren3JGCBywCt0WceS4OBMLc0/xZnyL5ROlFMqqyhDD6MOY3zz/zUYv0HYAd5LZTihzfZUikA1li0dSRH3+aTfwJ70FhtcA4gpGUUVFd20FxCXSi/DnUMObQYbKXfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F3eRGqSf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1748597847;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=yhyTHW9/iNSmJ3o1/+Kc2KlH+vX1ja7mHJ+mDxpkv9E=;
	b=F3eRGqSf/naq58IBMHrYtrb93TuXz2tHgKs5FOHBLNuv8r89hCK1Km5ApOAl0yWYRGmMKz
	JVQClIFiiHtw1veKrCx/07QzVPbyblJiLbS3KEbubfRtG1nRnjkOe7keuNTfgwZqYpycNU
	RXsk0x37kJcCr856Vm21+g1AtfR9I3o=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-581-JBKn09wOMg2Hcoa7KqAAqg-1; Fri, 30 May 2025 05:37:25 -0400
X-MC-Unique: JBKn09wOMg2Hcoa7KqAAqg-1
X-Mimecast-MFC-AGG-ID: JBKn09wOMg2Hcoa7KqAAqg_1748597844
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-441c96c1977so12781185e9.0
        for <linux-xfs@vger.kernel.org>; Fri, 30 May 2025 02:37:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748597844; x=1749202644;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=yhyTHW9/iNSmJ3o1/+Kc2KlH+vX1ja7mHJ+mDxpkv9E=;
        b=qnz/rdOdcAF0bwOW9y5/Vb/sODFAk8hW/7/WVoLZeh29hAUjpodFE+VWk6SDeyp2Za
         x6Ff90/Aq5tp4JCiL4boVegfnpeMHbha4l6JErMf1eBYPxq8Ns1dibs4O1YvEGGPD4VU
         1YW5n2zfbRgNRG0PLamFILa45tWftDDqDKZU9r4rN/n3KQhmMI5mcS7DnrM2/i6nrNet
         S1L7Jjklk4J3Mhpm/dyweABjFY1sOxWqeG6rylLdIsAQZDP+E+shJGKJhOw0/IrDbb55
         d122yx0nW0vIZIQGOLiosgyOtDauNw40c/Xwd3lNzF7jWcYjZQtquoU++lNH7/H8+/a0
         7l0A==
X-Forwarded-Encrypted: i=1; AJvYcCUqCqHgGtCDfQ22XAH5N0kgu0+tQ1+o3SlK82PWNf9WaQ0jhyc1ZbAhDUKoa/xrG258i1zJJy2iiIE=@vger.kernel.org
X-Gm-Message-State: AOJu0YylCXLhCiiQFYwE69FM3HqprfsND9cZT9TfLfl+9Wpwp0Uz62W+
	SLm2HPXiyCfHyZGJ/mEEvsvI0wRmw4S1zA/oxpXF2nZBPl3ZBmfx41mvYzte1EdDNLCEy8QXKl7
	ZrGMh3MKXQfHg8VDX1ACkSYJ/JcYzZ2nmWGjRhy+tKfHW3T7ewOGKd6kvOPt1ZA==
X-Gm-Gg: ASbGncux99VjYUB/Hh8Xb8rP2W0Z1Hr65nO2Fl2is1Ie0I3+N6kLD7yEPTthvCQl59C
	3wgTH+j6hozbg3x/8zvoMfziR20teTQ+wKGhMzmHeCZ10RXlj2CixpkJxUORi6qG4Cslrzj0jQH
	mWMvNQdm3ACkLZlORpwOcKytqJNItv2A8idQsvr0S35nkF3bQ3hW3/YQ+fgcqdn4QVuZn6rrVft
	zC7ddWtX+VtV4CZ+EXgKZ/loy6VmaDFo12KeNRkDpBdxFOiztcRTaOTdl/U85yfHDb5OQfMuVyB
	ZxOpqGh51etmXrtURn4u21ChuNZkdVa93U/LL5Fr+spJ8koFv9kxjifg9xzk04uUR0q3fgIse3S
	4wZ4PGNh3DAos85NgPGadsVAJoo0sXrl1xPBR02k=
X-Received: by 2002:a05:600c:6207:b0:43c:ea36:9840 with SMTP id 5b1f17b1804b1-450d885e38amr12675485e9.22.1748597844512;
        Fri, 30 May 2025 02:37:24 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGccFKRFTCgkkT3ae/QFUuhHOQzucrbv9tCboH5VNdb/K0MlBO6YnvTUAz5zFzNoWT7UAvZNw==
X-Received: by 2002:a05:600c:6207:b0:43c:ea36:9840 with SMTP id 5b1f17b1804b1-450d885e38amr12675135e9.22.1748597844047;
        Fri, 30 May 2025 02:37:24 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f03:5b00:f549:a879:b2d3:73ee? (p200300d82f035b00f549a879b2d373ee.dip0.t-ipconnect.de. [2003:d8:2f03:5b00:f549:a879:b2d3:73ee])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-450d800671csm12953125e9.30.2025.05.30.02.37.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 May 2025 02:37:22 -0700 (PDT)
Message-ID: <371b8fdd-129d-4fe3-bbc7-f0a1bc433b30@redhat.com>
Date: Fri, 30 May 2025 11:37:21 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/12] mm: Convert pXd_devmap checks to vma_is_dax
To: Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org
Cc: gerald.schaefer@linux.ibm.com, dan.j.williams@intel.com, jgg@ziepe.ca,
 willy@infradead.org, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-xfs@vger.kernel.org, jhubbard@nvidia.com, hch@lst.de,
 zhang.lyra@gmail.com, debug@rivosinc.com, bjorn@kernel.org,
 balbirs@nvidia.com, lorenzo.stoakes@oracle.com,
 linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org,
 linux-cxl@vger.kernel.org, dri-devel@lists.freedesktop.org, John@Groves.net
References: <cover.541c2702181b7461b84f1a6967a3f0e823023fcc.1748500293.git-series.apopple@nvidia.com>
 <224f0265027a9578534586fa1f6ed80270aa24d5.1748500293.git-series.apopple@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <224f0265027a9578534586fa1f6ed80270aa24d5.1748500293.git-series.apopple@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 29.05.25 08:32, Alistair Popple wrote:
> Currently dax is the only user of pmd and pud mapped ZONE_DEVICE
> pages. Therefore page walkers that want to exclude DAX pages can check
> pmd_devmap or pud_devmap. However soon dax will no longer set PFN_DEV,
> meaning dax pages are mapped as normal pages.
> 
> Ensure page walkers that currently use pXd_devmap to skip DAX pages
> continue to do so by adding explicit checks of the VMA instead.
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> ---
>   fs/userfaultfd.c | 2 +-
>   mm/hmm.c         | 2 +-
>   mm/userfaultfd.c | 2 +-
>   3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
> index 22f4bf9..de671d3 100644
> --- a/fs/userfaultfd.c
> +++ b/fs/userfaultfd.c
> @@ -304,7 +304,7 @@ static inline bool userfaultfd_must_wait(struct userfaultfd_ctx *ctx,
>   		goto out;
>   
>   	ret = false;
> -	if (!pmd_present(_pmd) || pmd_devmap(_pmd))
> +	if (!pmd_present(_pmd) || vma_is_dax(vmf->vma))
>   		goto out;
>   
>   	if (pmd_trans_huge(_pmd)) {
> diff --git a/mm/hmm.c b/mm/hmm.c
> index 082f7b7..db12c0a 100644
> --- a/mm/hmm.c
> +++ b/mm/hmm.c
> @@ -429,7 +429,7 @@ static int hmm_vma_walk_pud(pud_t *pudp, unsigned long start, unsigned long end,
>   		return hmm_vma_walk_hole(start, end, -1, walk);
>   	}
>   
> -	if (pud_leaf(pud) && pud_devmap(pud)) {
> +	if (pud_leaf(pud) && vma_is_dax(walk->vma)) {
>   		unsigned long i, npages, pfn;
>   		unsigned int required_fault;
>   		unsigned long *hmm_pfns;
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index e0db855..133f750 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -1791,7 +1791,7 @@ ssize_t move_pages(struct userfaultfd_ctx *ctx, unsigned long dst_start,
>   
>   		ptl = pmd_trans_huge_lock(src_pmd, src_vma);
>   		if (ptl) {
> -			if (pmd_devmap(*src_pmd)) {
> +			if (vma_is_dax(src_vma)) {
>   				spin_unlock(ptl);
>   				err = -ENOENT;
>   				break;

I assume we could also just refuse dax folios, right?

If we decide to check VMAs, we should probably check earlier.

But I wonder, what about anonymous non-dax pages in COW mappings? Is it 
possible? Not supported?

If supported, checking the actual folio would be the right thing to do.

-- 
Cheers,

David / dhildenb


