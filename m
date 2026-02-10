Return-Path: <linux-xfs+bounces-30739-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sMnKONkCi2npPAAAu9opvQ
	(envelope-from <linux-xfs+bounces-30739-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Tue, 10 Feb 2026 11:05:13 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 848241195FC
	for <lists+linux-xfs@lfdr.de>; Tue, 10 Feb 2026 11:05:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2CE9C3051D02
	for <lists+linux-xfs@lfdr.de>; Tue, 10 Feb 2026 10:01:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23A11343D76;
	Tue, 10 Feb 2026 10:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K71HRmME"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABA934320A
	for <linux-xfs@vger.kernel.org>; Tue, 10 Feb 2026 10:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770717704; cv=none; b=hP7J7YWFJSDaq/5YU3wXsKc033tJKLqTjYHQcp3ZybxkxbL9G///4yPuZhRBdkQukkZpNkxKoHTaHuT16zmtlMUFQ9JMKuJR1TO7w9FM8CruiGcSySb6c3Y78ogbaRzbt4u3V6gaP9mHu/vZ3EvT+MbZVG3heQlnibiMGcma/3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770717704; c=relaxed/simple;
	bh=xnoaRP9XqpR1GgnVaqTCINpnqF8mvoeenU8+ybf2ZpM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BApZq3665Yk3Dv04FKj4/o00nq2gknZqlPVB0OHFmLyhIz5I75RZv0YS7aWNI3vX39KxVWg3MmvDG5UqzJkgSZgA3WnkGd1uXzHXqUHVwOrAtIJn4ueJbv7oWx+lbMBQgq8Orn71etlJYMrKdNzwluUyhQGW5Ff904Hef+rA+bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K71HRmME; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-81ed3e6b8e3so1858849b3a.2
        for <linux-xfs@vger.kernel.org>; Tue, 10 Feb 2026 02:01:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770717702; x=1771322502; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7V0YYVHSZnhaEB1i1E+YCZJAXIpuuFg/eBBrcs6+9DE=;
        b=K71HRmMEiywsZ5645ws6ht9bhOzOG9/Mfc8CzUXjgMnbHVuO2C0ZgGK3LfWrCANxi4
         a78boxs5+jKmkN9DkF3003wBwbdS9YjAlpJkf+khx9l84Mf7dgKRiY4xs83/ItzHdH9o
         kBhIA58k3xZduM1l1O2FOlW9zhKux+IrnZrGTOVMAuBuRn2UgkJ+5Zc0xMZv9f6p6UwB
         JQbwc1DPybc3ORXkFcN1ox78RkGhpE7qsTNFRbLeur146wx/YDigWBof3OluBYgQHxOO
         sTh0h96+hIVPmJcLNT8PodcnDt7iIIOk5FxEYPT2SGbF1IAA2atK9JL/QhIlCvJMMncT
         MoHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770717702; x=1771322502;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7V0YYVHSZnhaEB1i1E+YCZJAXIpuuFg/eBBrcs6+9DE=;
        b=Md8JxdfkZwFRKB5nUcM6hKPLwXXsRDnV9i5c1FlzJC/3vA0JlenNfdNCY3ELLZ2D2k
         sH74Fgcu/+O8SsvsRbQ8NEdq3NfJzgIrD6/UJwf6tE7ye5o7Dg4yKu4uE+1iXo1GqKsi
         Piooa7GT/SuMQAv8Rlvef2LeFyMvpfmXYVJ6hlIqbFBqi6JumZeYNP6HTw+hc044JTeP
         k8KevOWDqTdNeSn0P8vG6BNz5dA5k3BPnyS9157fdWthq//WAqiff4oK//SWPgccryhe
         Xs0/i6z+lG7pOrAdsxKXZk/cfYbT4V44bex7Iu+JM5FL4NR0ZdGzQAwEfwXPH83nOFh3
         R2mw==
X-Forwarded-Encrypted: i=1; AJvYcCVweCkFLTqBHcMgF1naTmUrETiFBLUAz4qYlkaBmjl0CHV4QI6kAKh1CuqtpDDece76TUt6UBaooi8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwVgov/3+tqSmtZhqZZp5JCirUSZmFsJCeSyUovcA1zOGbCQCe7
	9UBFgOxBMAWxxz4YS0Hud1Dhb/YQziJ04iux16KAoia8IHHRQJPJBq0e
X-Gm-Gg: AZuq6aIBf37C4sb6/3fykjTYjKW8BIw65557WSzhfUMX2ZPXTmYMvKtuYhHlyMcRT1/
	XqifMuPwNPlYc09rSzr8/phPjDiBMseDASAH6G7E1PA5u0K9aEzynTMZQIv9SO6AmWhtgv7Ge3X
	XR9nOPVFud65Fz2GlXv1sn4ycF1VJhBZJpUXcV8/NESl1JcOUXLmaM2qRWOybEm4ISfRYPUvfTg
	XfGBMMjcfhzRPEc1JvJt1Gi7uyUJOYReFJxgtc+RBH48hzhiCKOurlze+4m5+p44ovDod7QIvp5
	hZHP65wU9gPCJC13mD8Uv8EbAkNtR6qGKoTc0icNlL9cLgoAT3U6AyH5ZfYG6/cEdY3r0TiZpnL
	RWPlzdrzpU7gHcHhax/PwQPcEigIDHBxUBV8UEV+WKuFtobWEEAjdh0IDDO9qiy4DqN3xcMfk0T
	4f698MZNbeBzZuhQQZDNovlPi6Ay3y
X-Received: by 2002:a05:6a21:62c3:b0:38b:ecae:670c with SMTP id adf61e73a8af0-393acff5fffmr14088202637.25.1770717701792;
        Tue, 10 Feb 2026 02:01:41 -0800 (PST)
Received: from [9.109.246.38] ([129.41.58.6])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c6dcb526676sm11280235a12.12.2026.02.10.02.01.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Feb 2026 02:01:41 -0800 (PST)
Message-ID: <24f83605-1bb2-4177-8f80-d3c97453a5cf@gmail.com>
Date: Tue, 10 Feb 2026 15:31:36 +0530
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [patch v1 0/2] Misc refactoring in XFS
To: Carlos Maiolino <cem@kernel.org>
Cc: djwong@kernel.org, hch@infradead.org, linux-xfs@vger.kernel.org,
 ritesh.list@gmail.com, ojaswin@linux.ibm.com
References: <cover.1770128479.git.nirjhar.roy.lists@gmail.com>
 <aYrztKTqOo6SL-Cm@nidhogg.toxiclabs.cc>
Content-Language: en-US
From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
In-Reply-To: <aYrztKTqOo6SL-Cm@nidhogg.toxiclabs.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-30739-lists,linux-xfs=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[kernel.org,infradead.org,vger.kernel.org,gmail.com,linux.ibm.com];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[nirjharroylists@gmail.com,linux-xfs@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 848241195FC
X-Rspamd-Action: no action


On 2/10/26 14:31, Carlos Maiolino wrote:
> On Fri, Feb 06, 2026 at 09:07:59PM +0530, Nirjhar Roy (IBM) wrote:
>> This patchset contains 2 refactorings. Details are in the patches.
>> Please note that the RB for patch 1 was given in [1].
>>
>> [1] https://lore.kernel.org/all/20250729202428.GE2672049@frogsfrogsfrogs/
>>
>> Nirjhar Roy (IBM) (2):
>>    xfs: Refactoring the nagcount and delta calculation
>>    xfs: Use rtg_group() wrapper in xfs_zone_gc.c
> I can only see a single patch in this series, same in lore.kernel. I'm
> assuming you made some mistake when sending it.

No, not a mistake really. After patch 0/2 and 1/2 was sent, gmail for 
some reason blocked patch 2/2 - since then I have tried multiple times 
to send it, but it is repeatedly getting blocked. I am still in the 
process of figuring this out. The 2 patches are independent, so if you 
want, you can look at patch 1/2 for now. I am checking as to why is the 
second patch getting blocked by gmail. Also, if you have any idea as to 
why some specific patch/patch-file can getting blocked, maybe can you 
please shed some light (I have verfied that I am able to send other 
patches/patch-files, only the patch 2/2 is getting blocked).

--NR

>
>>   fs/xfs/libxfs/xfs_ag.c | 28 ++++++++++++++++++++++++++++
>>   fs/xfs/libxfs/xfs_ag.h |  3 +++
>>   fs/xfs/xfs_fsops.c     | 17 ++---------------
>>   fs/xfs/xfs_zone_gc.c   |  4 ++--
>>   4 files changed, 35 insertions(+), 17 deletions(-)
>>
>> -- 
>> 2.43.5
>>
-- 
Nirjhar Roy
Linux Kernel Developer
IBM, Bangalore


