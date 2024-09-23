Return-Path: <linux-xfs+bounces-13022-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3819797C331
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Sep 2024 05:39:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A89A1C2172E
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Sep 2024 03:39:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84FEB18C3D;
	Thu, 19 Sep 2024 03:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="IHzOdL0z"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B07125A9
	for <linux-xfs@vger.kernel.org>; Thu, 19 Sep 2024 03:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726717131; cv=none; b=GvcY51nQx7qIG5iBoOQjn5p4LsdD29M9bAf2vLR8PWRRj9CY2xgruSvui4KBVrhwDlWjXZd/Z3zucJPLCULQo2fXt9XYmAOKZ61BGQ/G4yUvltfN5qBVAyOtyVd/k3kzK0ygv35QxyC3kVDT4FSfPvWOagZ3qKWqKQglI8lFg1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726717131; c=relaxed/simple;
	bh=LoMi13A4AfE43GdKZNtf5scV3hXW2dBvlxD8UDU1VWg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FMo6JmJUakbHcm8nHanY7ni830UzUUqoJga/FRSsmg9TVzwynT8FcFzTE7NKUYfmYS4NTh29lAYlsPbWhoWOJAPmmFpcant2wvCf6lvVvvanqGN0C61HEhAZ0Kf2yvhAlhXbz3biWrVGTwwHAgisPtUZTkiXbzbVLYDxpPGQCOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=IHzOdL0z; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a8a7596b7dfso64374766b.0
        for <linux-xfs@vger.kernel.org>; Wed, 18 Sep 2024 20:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726717126; x=1727321926; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0ip2Z9ZN8QnSQEWnaDGGUtbvLzJ9Kl1C8B/3QvjgaEU=;
        b=IHzOdL0ziPLBBqO2t+zRmtnE/yrtmkqD9LiWh0z93E+ZUW17YSGzOaMpm1ii+zzkfY
         dj1wMECQjOXkIm7nswPVJ55vS11ASWcAL0jzRGULO47JXgVSzbdUNVo6i9cdVxKLKAhI
         9DCJToJG0LbKVlDjId8sayrJ142cbV1YnwlI8kHgl2J8EPcSs2lM7IZMI6+zJYG9jfOr
         3UrR/EieI+O/3m0Hh+28ewlPaYKTomHdmUHHQlbdOEUUypBlzYXAz90IBlX99rnvzOtn
         dY8g4SXKmgNKkXhvuz7H/vg6W7WGoIFXIE0pPoeYHI6XsADDLLWYMjeBEbJ9nLUiPk7b
         wmaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726717126; x=1727321926;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0ip2Z9ZN8QnSQEWnaDGGUtbvLzJ9Kl1C8B/3QvjgaEU=;
        b=j3yj/VJTtLPoC/m32oMR4Fi7QhOa9g+3kOk3wIaWQGuNPMx/4FXNUGkJVxvlD0H4yT
         f42Pwg5N7MsKMcgt1czC5pEvz7RM8TrsnaVJq6pwY4NzUL7rieyogOG5hVVN6pB0Sov4
         1AIycDHc/WGDseISUs4ulnn/QrEj0jKpMJHsffbfgC7I88FQPSWUvANtaECGrlW8Tled
         h7aXNDiRdSovPPmQX54VAxeyY/TudYi66vCBZRkQ5YBbvdTdkNB1V8AKdni/8I1tFnjj
         Na1Ass2V29BozUd90XwDm/cXq3a0HTAp5EjYx3CqXjWhfoxuc8uhT3kSfC3qrs3v/H9e
         +/NQ==
X-Forwarded-Encrypted: i=1; AJvYcCVfc6kgJXULZdXVCh9/OVHvVLZ54zAlmtQ4q+Yxsj0cpJP/MjxUuBTvyrxMKoMWTE9hd90kpd47Jfw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyhF1jBU/wDJURDqV3kj3RJjEESGWXOyo8K9mSknePj1l4VylhE
	IxwAq1J9pB6WI/fgDWo4QRIqh+OvTR7JBqV/gm40zQhuSLjsRWi8PQ9ZN5DjJjg=
X-Google-Smtp-Source: AGHT+IEoH3Dhv73LGspYMYEfg6SjReNg6iDMuoDHAeKmrMPg6QH84CSbwClYlsxjJrTcrRMZ7RzAJg==
X-Received: by 2002:a17:907:3f88:b0:a8d:6372:2d38 with SMTP id a640c23a62f3a-a90c1cba61emr142785266b.18.1726717125742;
        Wed, 18 Sep 2024 20:38:45 -0700 (PDT)
Received: from [192.168.0.216] ([185.44.53.103])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a90610f4375sm666457166b.73.2024.09.18.20.38.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Sep 2024 20:38:43 -0700 (PDT)
Message-ID: <8697e349-d22f-43a0-8469-beb857eb44a1@kernel.dk>
Date: Wed, 18 Sep 2024 21:38:41 -0600
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Known and unfixed active data loss bug in MM + XFS with large
 folios since Dec 2021 (any kernel from 6.1 upwards)
To: Linus Torvalds <torvalds@linux-foundation.org>,
 Dave Chinner <david@fromorbit.com>
Cc: Matthew Wilcox <willy@infradead.org>, Chris Mason <clm@meta.com>,
 Christian Theune <ct@flyingcircus.io>, linux-mm@kvack.org,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 Daniel Dao <dqminh@cloudflare.com>, regressions@lists.linux.dev,
 regressions@leemhuis.info
References: <CAHk-=wh5LRp6Tb2oLKv1LrJWuXKOvxcucMfRMmYcT-npbo0=_A@mail.gmail.com>
 <Zud1EhTnoWIRFPa/@dread.disaster.area>
 <CAHk-=wgY-PVaVRBHem2qGnzpAQJheDOWKpqsteQxbRop6ey+fQ@mail.gmail.com>
 <74cceb67-2e71-455f-a4d4-6c5185ef775b@meta.com>
 <ZulMlPFKiiRe3iFd@casper.infradead.org>
 <52d45d22-e108-400e-a63f-f50ef1a0ae1a@meta.com>
 <ZumDPU7RDg5wV0Re@casper.infradead.org>
 <5bee194c-9cd3-47e7-919b-9f352441f855@kernel.dk>
 <459beb1c-defd-4836-952c-589203b7005c@meta.com>
 <ZurXAco1BKqf8I2E@casper.infradead.org>
 <ZuuBs762OrOk58zQ@dread.disaster.area>
 <CAHk-=wjsrwuU9uALfif4WhSg=kpwXqP2h1ZB+zmH_ORDsrLCnQ@mail.gmail.com>
 <CAHk-=wgQ_OeAaNMA7A=icuf66r7Atz1-NNs9Qk8O=2gEjd=qTw@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHk-=wgQ_OeAaNMA7A=icuf66r7Atz1-NNs9Qk8O=2gEjd=qTw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/18/24 9:12 PM, Linus Torvalds wrote:
> On Thu, 19 Sept 2024 at 05:03, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> I think we should just do the simple one-liner of adding a
>> "xas_reset()" to after doing xas_split_alloc() (or do it inside the
>> xas_split_alloc()).
> 
> .. and obviously that should be actually *verified* to fix the issue
> not just with the test-case that Chris and Jens have been using, but
> on Christian's real PostgreSQL load.
> 
> Christian?
> 
> Note that the xas_reset() needs to be done after the check for errors
> - or like Willy suggested, xas_split_alloc() needs to be re-organized.
> 
> So the simplest fix is probably to just add a
> 
>                         if (xas_error(&xas))
>                                 goto error;
>                 }
> +               xas_reset(&xas);
>                 xas_lock_irq(&xas);
>                 xas_for_each_conflict(&xas, entry) {
>                         old = entry;
> 
> in __filemap_add_folio() in mm/filemap.c
> 
> (The above is obviously a whitespace-damaged pseudo-patch for the
> pre-6758c1128ceb state. I don't actually carry a stable tree around on
> my laptop, but I hope it's clear enough what I'm rambling about)

I kicked off a quick run with this on 6.9 with my debug patch as well,
and it still fails for me... I'll double check everything is sane. For
reference, below is the 6.9 filemap patch.

diff --git a/mm/filemap.c b/mm/filemap.c
index 30de18c4fd28..88093e2b7256 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -883,6 +883,7 @@ noinline int __filemap_add_folio(struct address_space *mapping,
 		if (order > folio_order(folio))
 			xas_split_alloc(&xas, xa_load(xas.xa, xas.xa_index),
 					order, gfp);
+		xas_reset(&xas);
 		xas_lock_irq(&xas);
 		xas_for_each_conflict(&xas, entry) {
 			old = entry;

-- 
Jens Axboe

