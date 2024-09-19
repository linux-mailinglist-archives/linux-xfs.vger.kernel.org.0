Return-Path: <linux-xfs+bounces-13025-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DB7C97C35D
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Sep 2024 06:42:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 799C01C2229D
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Sep 2024 04:42:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90DD218EAB;
	Thu, 19 Sep 2024 04:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="n2BP+4bh"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269691862A
	for <linux-xfs@vger.kernel.org>; Thu, 19 Sep 2024 04:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726720938; cv=none; b=LqGT5lMSzl0nwnDZqYIi+qhuPIQ3Iu83xmJ+k7UGDKVZSpGSr1LPKVHsyajXVCqtbGEl8+SUhO7SK8gn3SpS2tGqUGB48wPidHWv3ejcodF/yEd044C4yEf5mAiY3Kv/rCeXUPGBeckSh/occkJjQiM7Sryyj5Xd24/W+NPHp5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726720938; c=relaxed/simple;
	bh=I4emb0PPJdJq3XXtILxPZ4lkaDq6aRuqvd/+l5hpDA4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nk1jCaZV2pIbQAdDBJyHnfikVP/+8endY2tC8cbiLEEt7QXcyWfqFWOyBf1zGGLnQf32dVyuIXtVh6ApAs2kxGpKUO64IAIOVi+CJd6BhWb1G0ZJ+7IudZn/53MkYdP25tZZx0zVZ/yf505HA0HvmRgbStzycb3r4AiPOfjqNUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=n2BP+4bh; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-42bb7298bdeso4425295e9.1
        for <linux-xfs@vger.kernel.org>; Wed, 18 Sep 2024 21:42:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726720934; x=1727325734; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FEv0NNjcPwkYB/8A8F624McGvuZVJ9GKy7Zkfan8JEI=;
        b=n2BP+4bhySmWqQfoUaR5X2MpBbuVRf9b4TRm1Ybma4zWj8/2ZgyuYQq6DEuM3JdHfZ
         7CGc1N8i543uoJ9GIcem4w9H66KcKf9AUKGiOTELW+wtFzW4qGsInDhGpGMyMTBngsy2
         VDwHocFHYCeIGh02lEhs7ZonMbBasMRkenQn+wGKV59Y7htNPXizh7yzwsPl81YpB/xP
         B2TThF5CNOGBVPYwzL1LHtqZT/Q/dnky3PHsS/EyH/B5UlqiaAexl+LrOD43hcIQsjiY
         wPkkYQlnJSgoT+McNMW52g1kJ2FH/5xOCHdQQNNn7xQzdvfKaQE1G49NxGLlRvg1wH0E
         P3Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726720934; x=1727325734;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FEv0NNjcPwkYB/8A8F624McGvuZVJ9GKy7Zkfan8JEI=;
        b=hOd6HgiiJ0nuwiXMbQTf9KrRcsRsW24Y1ggSiA9LbbiBiv18i+nt5JyGxma1znCFX4
         zoy/1tbZ7AlQOBJc+cRt6YrMlLd3omQz1GGAPfdKvZMycahMH4r3vlw1PMEu4nMCgD9u
         EUuU+J6WD1mGbFtS0UOVEBW+OQ/CpVDB7vLx3DJEwLldpj2ovjZN46h78JkFR1ixCf7M
         vTFgXWVs4gGz9NcAaZDBvJIdR3dd+CSZqzm482SeJTD8RaGB7KJ2EyzvspPgmkIXHEit
         qJPIrdgRhayPb+AKSZKf/GoCS1IozHL6sdPRxWm0LtaGZmw3ojRRFsejpVnFUIi6vpVt
         2vSg==
X-Forwarded-Encrypted: i=1; AJvYcCWhsKSVHWEj6GZjGiifkHTKgihgE2Bnr07XPi/Ejt76ISBA9xEJBFX5FCvpArCE/nyS8wmN9oLsdW0=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywoioag/7wy4T7Yzy5qAYCFB+a+0CzJOK+dVoRPCmJ/sOO2iT5/
	7vWxRENm0uVK0Flt5vcakQCKtMRb0uGqCrDMDp0oY3bgN7OAIIUJwx2Q3vQybIM=
X-Google-Smtp-Source: AGHT+IEgYzZAXC3ZjqvsRJgwZCm8/AA1vRU0Hskc9IMNfMwPplLV5Fn3D/nQ2UuKkwP3xJKeZULYnw==
X-Received: by 2002:a05:600c:4e94:b0:42c:b8c9:16b6 with SMTP id 5b1f17b1804b1-42d9070a24cmr199328925e9.2.1726720933826;
        Wed, 18 Sep 2024 21:42:13 -0700 (PDT)
Received: from [192.168.0.216] ([185.44.53.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42e75b814bcsm9164595e9.21.2024.09.18.21.42.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Sep 2024 21:42:12 -0700 (PDT)
Message-ID: <4ef7647f-80d1-48e5-9cff-9ab612054ff8@kernel.dk>
Date: Wed, 18 Sep 2024 22:42:10 -0600
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Known and unfixed active data loss bug in MM + XFS with large
 folios since Dec 2021 (any kernel from 6.1 upwards)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, Matthew Wilcox <willy@infradead.org>,
 Chris Mason <clm@meta.com>, Christian Theune <ct@flyingcircus.io>,
 linux-mm@kvack.org, "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
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
 <8697e349-d22f-43a0-8469-beb857eb44a1@kernel.dk>
 <CAHk-=wjsf9eAsKf-s6Vcif8wHPFj3iycaJ89ei=K1hQPPAojEg@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHk-=wjsf9eAsKf-s6Vcif8wHPFj3iycaJ89ei=K1hQPPAojEg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/18/24 10:32 PM, Linus Torvalds wrote:
> On Thu, 19 Sept 2024 at 05:38, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> I kicked off a quick run with this on 6.9 with my debug patch as well,
>> and it still fails for me... I'll double check everything is sane. For
>> reference, below is the 6.9 filemap patch.

Confirmed with a few more runs, still hits, basically as quickly as it
did before. So no real change observed with the added xas_reset().

> Ok, that's interesting. So it's *not* just about "that code didn't do
> xas_reset() after xas_split_alloc()".
> 
> Now, another thing that commit 6758c1128ceb ("mm/filemap: optimize
> filemap folio adding") does is that it now *only* calls xa_get_order()
> under the xa lock, and then it verifies it against the
> xas_split_alloc() that it did earlier.
> 
> The old code did "xas_split_alloc()" with one order (all outside the
> lock), and then re-did the xas_get_order() lookup inside the lock. But
> if it changed in between, it ended up doing the "xas_split()" with the
> new order, even though "xas_split_alloc()" was done with the *old*
> order.
> 
> That seems dangerous, and maybe the lack of xas_reset() was never the
> *major* issue?
> 
> Willy? You know this code much better than I do. Maybe we should just
> back-port 6758c1128ceb in its entirety.
> 
> Regardless, I'd want to make sure that we really understand the root
> cause. Because it certainly looks like *just* the lack of xas_reset()
> wasn't it.

Just for sanity's sake, I backported 6758c1128ceb (and the associated
xarray xas_get_order() change) to 6.9 and kicked that off.

-- 
Jens Axboe

