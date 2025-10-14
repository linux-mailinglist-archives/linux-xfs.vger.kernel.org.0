Return-Path: <linux-xfs+bounces-26416-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B7B2BD75E6
	for <lists+linux-xfs@lfdr.de>; Tue, 14 Oct 2025 07:11:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 12A404E781C
	for <lists+linux-xfs@lfdr.de>; Tue, 14 Oct 2025 05:11:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93C5626E708;
	Tue, 14 Oct 2025 05:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Af4EhvM2"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3F42367D9
	for <linux-xfs@vger.kernel.org>; Tue, 14 Oct 2025 05:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760418654; cv=none; b=mUNUhxxz+ozAmGBRE+yFG42S9WXZorEiMAWv5Osykm+uTOuGMHeUtreEexcdIeN4lGnK8TXF7BJzhb2tHIIDYWSJUjOx/UijHs6gIS1R7VAn5KKUbD50w0lSsPQTjp9aP+aKVh0UdkvSo8HJiX4U5tSRVb9XX6FkffhSLIdMwqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760418654; c=relaxed/simple;
	bh=056xWVMlQB6yM5hEPTfg/Iz6mp86SxqH9G9Bx8zA0b0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qtcEoLLMblARuIaqQom+uFzRHPU0ijC6Nx0LqpD9vDP89lqHFcyUHDvnPsm13J2XUzquaDAmEueKSJ9MKxpKkOoyorroJFKFfOFK2KteCs0xKw0QPKQRcAC9rRojrSRIeThfgiYW4We6J3+kQXeoGkeTYBnrgvz5b7racOSDLO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Af4EhvM2; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3ee64bc6b85so5360647f8f.3
        for <linux-xfs@vger.kernel.org>; Mon, 13 Oct 2025 22:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1760418650; x=1761023450; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=w0MZBFptNWdkfouEcVHOtRQWTPFO4rz9x5djAVC9lXs=;
        b=Af4EhvM2JZbmPSW2wt/rtorq6g0gqb6WvGJJKiG4moYI14mgUeQvfdXoDxfiqhjnUc
         ackYd13Z5UfdCRTOZ4PZ8fSrC4fkfnkpmcoPZXhkSs55TtuaNw/I23SU55ZqbaIb8/ow
         KyLiT2FGlIucaAJKO7JV3yqiqqcOK6hEMVZYHiACrfxBGzVZ0TB7fRuqMb4K0hqqN6Gy
         qmXGifzXy+bRz02dYsOBd0ns/n6ZT5BLsuqW29/YuzAS57fIRMXDaMf7r/XcuEXN8ZU0
         M9XX04euH/+7dTGxxl/609f7d3rgvDgI3vU99IEpP+wT70YRe15sUPYcF+byA7KPsyXS
         q4Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760418650; x=1761023450;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w0MZBFptNWdkfouEcVHOtRQWTPFO4rz9x5djAVC9lXs=;
        b=k6ZB0/vTbPYjs2hNpblWsmIptn+b2qT3q6ivFNMaSfOMIxb8Q+Z6mjqFucTy549i89
         8BYNIqVbSrnXsYpvW8DVYB5n0VUPCVrgnJ1E4H/xUMeirgj5JknBBg2wujieZ0Q3jaV/
         oUSCfP5uPR17NgmmP6FM7nNePTBobA1b5A04NGTW271r6Sfk7Sd3O4ZRTUl38aye300O
         VAo/dN/VaZLsE3F4fec2f7RSYnFvaOtd5eNuYWJHLZUHwpgZcF+KHV5IreYAW8K5Dh+F
         vIC/Hpm/bIBIvVMv0/sUkdJydoOoUPAdLrCNebkCeK081D26Sw2Hg7C7OMmHu2xAqpOo
         RvXA==
X-Forwarded-Encrypted: i=1; AJvYcCVgyQ2AHeBw79Opyg/MaFYDKdqQO5L046tHGgbTu3OioRdtnzl55uWVBc9fkQtc9OzozMb1LtPCVSY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzkfS+5UlM0uptxeZWLoquk1BUyWtsxEcu1o+OMGrzMRW+RrON6
	QnpPIGOV+B3J6NmWgSak4ZoaMGbtRqk73HQPbR8Dn2AUuEFXXDN74qPF4WfOfCwE3to=
X-Gm-Gg: ASbGnct9J7M4f5VWxAY91qx2dw0IBQnE3J9MEFp8RJhUnqGOTDolbaZoPAX8ukU5dhj
	sB3CVcM8mQzSzip+zwKnUhDOOkeDICycPm/VW6u7qFaKLQutPKUBeNZgI45Xvmj6GcgLi1kphY9
	kcZtFOitM7GZoiqt6GBB/p1cj9l5rgq2Jkhs8XsCzENkU3HI3TB3+xTXBHdsgaHXx/A3XnNFcXn
	5Ls0X0KqTMUD/GzvJCtSjf/YuyFpAadhTcHHU5Ms6Lvj8qy6JzWQQffAbU/no5L88CKm20FfDMV
	8zlScdeYRrlmeiqBT6Qv+/6Jftyp3bzlBl5RZBXzuLJdygUj/g8w/BaxusqEVBjxUN5ojhb6d/3
	MMrgIeTJYkyb+G4ZEwE6g6QC+mplV1HSyZycxq/ISFqp2CNLGiq+LlsrXbfnXPBOqekGaV25G9A
	aKwOp/
X-Google-Smtp-Source: AGHT+IFDfukt8ElU2uUIMPKSUQbK6e6P/Qpt3+OqqL2RpgrQD9ez41vaEOfsSOzU9xtbmExE5sgPWw==
X-Received: by 2002:a05:6000:3106:b0:3ee:12a8:6f1c with SMTP id ffacd0b85a97d-4266e8de388mr15701619f8f.46.1760418650412;
        Mon, 13 Oct 2025 22:10:50 -0700 (PDT)
Received: from ?IPV6:2403:580d:fda1::299? (2403-580d-fda1--299.ip6.aussiebb.net. [2403:580d:fda1::299])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7992b63a03dsm13500800b3a.19.2025.10.13.22.10.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Oct 2025 22:10:49 -0700 (PDT)
Message-ID: <8267e2ae-de17-40e2-9100-6eeb2b3680e6@suse.com>
Date: Tue, 14 Oct 2025 15:40:45 +1030
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] iomap: add IOMAP_DIO_FSBLOCK_ALIGNED flag
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-btrfs@vger.kernel.org, brauner@kernel.org, djwong@kernel.org,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <c78d08f4e709158f30e1e88e62ab98db45dd7883.1760345826.git.wqu@suse.com>
 <aO3TYhXo1LDxsd5_@infradead.org>
 <5a9e8670-c892-4b94-84a3-099096810678@suse.com>
 <aO3YcT9s8ezmIkzv@infradead.org>
Content-Language: en-US
From: Qu Wenruo <wqu@suse.com>
Autocrypt: addr=wqu@suse.com; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNGFF1IFdlbnJ1byA8d3F1QHN1c2UuY29tPsLAlAQTAQgAPgIbAwULCQgHAgYVCAkKCwIE
 FgIDAQIeAQIXgBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXVgBQkQ/lqxAAoJEMI9kfOh
 Jf6o+jIH/2KhFmyOw4XWAYbnnijuYqb/obGae8HhcJO2KIGcxbsinK+KQFTSZnkFxnbsQ+VY
 fvtWBHGt8WfHcNmfjdejmy9si2jyy8smQV2jiB60a8iqQXGmsrkuR+AM2V360oEbMF3gVvim
 2VSX2IiW9KERuhifjseNV1HLk0SHw5NnXiWh1THTqtvFFY+CwnLN2GqiMaSLF6gATW05/sEd
 V17MdI1z4+WSk7D57FlLjp50F3ow2WJtXwG8yG8d6S40dytZpH9iFuk12Sbg7lrtQxPPOIEU
 rpmZLfCNJJoZj603613w/M8EiZw6MohzikTWcFc55RLYJPBWQ+9puZtx1DopW2jOwE0EWdWB
 rwEIAKpT62HgSzL9zwGe+WIUCMB+nOEjXAfvoUPUwk+YCEDcOdfkkM5FyBoJs8TCEuPXGXBO
 Cl5P5B8OYYnkHkGWutAVlUTV8KESOIm/KJIA7jJA+Ss9VhMjtePfgWexw+P8itFRSRrrwyUf
 E+0WcAevblUi45LjWWZgpg3A80tHP0iToOZ5MbdYk7YFBE29cDSleskfV80ZKxFv6koQocq0
 vXzTfHvXNDELAuH7Ms/WJcdUzmPyBf3Oq6mKBBH8J6XZc9LjjNZwNbyvsHSrV5bgmu/THX2n
 g/3be+iqf6OggCiy3I1NSMJ5KtR0q2H2Nx2Vqb1fYPOID8McMV9Ll6rh8S8AEQEAAcLAfAQY
 AQgAJgIbDBYhBC3fcuWlpVuonapC4cI9kfOhJf6oBQJnEXWBBQkQ/lrSAAoJEMI9kfOhJf6o
 cakH+QHwDszsoYvmrNq36MFGgvAHRjdlrHRBa4A1V1kzd4kOUokongcrOOgHY9yfglcvZqlJ
 qfa4l+1oxs1BvCi29psteQTtw+memmcGruKi+YHD7793zNCMtAtYidDmQ2pWaLfqSaryjlzR
 /3tBWMyvIeWZKURnZbBzWRREB7iWxEbZ014B3gICqZPDRwwitHpH8Om3eZr7ygZck6bBa4MU
 o1XgbZcspyCGqu1xF/bMAY2iCDcq6ULKQceuKkbeQ8qxvt9hVxJC2W3lHq8dlK1pkHPDg9wO
 JoAXek8MF37R8gpLoGWl41FIUb3hFiu3zhDDvslYM4BmzI18QgQTQnotJH8=
In-Reply-To: <aO3YcT9s8ezmIkzv@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



在 2025/10/14 15:28, Christoph Hellwig 写道:
> On Tue, Oct 14, 2025 at 03:25:31PM +1030, Qu Wenruo wrote:
>> Unfortunately that may not be that easy. Either we merge it early, meaning
>> just this change + using the new flag in btrfs.
>> But that means it makes no real change at all, as bs > ps direct IO is still
>> disabled.
>>
>> Or we wait for the btrfs sub-block checksum handling patchset merged, then
>> with the full bs > ps direct IO enablement.
>> But that also means we're waiting for some other btrfs patches.
>> There are already too many btrfs bs > ps patches pending now.
> 
> What's your plan for merging this?  I was going to look into doing a
> patch like this to improve the zoned XFS direct I/O handling soon,
> so if you aim for 6.19 we need to figure out a way to get it into
> the iomap tree and merge that into the xfs and btrfs trees.  If you're
> not aiming for 6.19 we could merge the iomap and xfs work through
> either the iomap or xfs trees.
> 

I'm not sure if I can get this patch through btrfs tree in v6.19.
There are too many pending btrfs patches.

So please go ahead through iomap/xfs tree instead.

Thanks,
Qu

