Return-Path: <linux-xfs+bounces-31861-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YBNbHbL/p2nynAAAu9opvQ
	(envelope-from <linux-xfs+bounces-31861-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 04 Mar 2026 10:47:30 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 785E51FDDB0
	for <lists+linux-xfs@lfdr.de>; Wed, 04 Mar 2026 10:47:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 82B0B30080A9
	for <lists+linux-xfs@lfdr.de>; Wed,  4 Mar 2026 09:47:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8FA739D6FD;
	Wed,  4 Mar 2026 09:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lakz/Nf5"
X-Original-To: linux-xfs@vger.kernel.org
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B3BA39D6C0
	for <linux-xfs@vger.kernel.org>; Wed,  4 Mar 2026 09:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772617637; cv=none; b=LIt4RdVhp5FJo0ptw4deR+iLbWrHGdWdgrI5q8ocPT/4+6GYc0r5KPQSXXHDQoMMdBr5xOBNyW9OpCdQ6FWV2hPU2FLhPMKpovtcPDQNZFobec/4zXnfvUcxolUka0ivH9uswBqeSrl7Y3J2vUAM4ow7SvGqHpGOw7Sg/RSJLkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772617637; c=relaxed/simple;
	bh=xGg4VhPhu+JJgSYIQL9yzC/+49B9MHNtqmtxnhUueko=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Fagt8W2poZKd2qHYx41YsT5lJdrds4rlQdySQYd7DOhMX5ByInhQnVSzDrM0t28YTCKpc8cVkxapBam65Qxkii2gY2WdbLPkc8TG8Qs8usjZeIX5FQcxSgoCpXrhuZKv69DUu/CDzI+5narjkjHdVwU5zP773K+vW+vMeNDH6O4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lakz/Nf5; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <ecd24894-bd95-40d1-9f3f-579a6b666391@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772617633;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s6xT3UOHuwsU5P3nM8DCiTUqKBDD/rKddOevyZeZnlE=;
	b=lakz/Nf5iIxmZODvwpZC3TpZfxAn0aWHsAzpZHpLh7U8AbJr1DpIgaNnLbag8xu46OCzPj
	QlyTC8PvKx0H1OIya3h4TIJDLDpsSqTN6VQGmYRn4pUzlYuMZYVmuXQY/zVaZ5MCDNRAIl
	eiJDC11hwiIgK/+2KOip6KXlDJi6PtE=
Date: Wed, 4 Mar 2026 10:46:53 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [RFC 1/2] xfs: add flags field to xfs_alloc_file_space
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
 Pankaj Raghav <p.raghav@samsung.com>, linux-xfs@vger.kernel.org,
 bfoster@redhat.com, dchinner@redhat.com, "Darrick J . Wong"
 <djwong@kernel.org>, gost.dev@samsung.com, andres@anarazel.de,
 lukas@herbolt.com
References: <20260227140842.1437710-1-p.raghav@samsung.com>
 <20260227140842.1437710-2-p.raghav@samsung.com>
 <aab9Lgt-HUaNq-FL@infradead.org>
 <cz7xkvha3ka6cqilkeolypgbr7rttlxk24uiliqvaou527kjkr@6cx6q3kprtjt>
 <aaf6QgbmQQ56ZlhH@nidhogg.toxiclabs.cc>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Pankaj Raghav <pankaj.raghav@linux.dev>
In-Reply-To: <aaf6QgbmQQ56ZlhH@nidhogg.toxiclabs.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 785E51FDDB0
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-31861-lists,linux-xfs=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_TRACE(0.00)[linux.dev:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pankaj.raghav@linux.dev,linux-xfs@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[10];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,linux.dev:dkim,linux.dev:mid]
X-Rspamd-Action: no action


On 3/4/2026 10:31 AM, Carlos Maiolino wrote:
>>>> @@ -646,7 +646,8 @@ int
>>>>   xfs_alloc_file_space(
>>>>   	struct xfs_inode	*ip,
>>>>   	xfs_off_t		offset,
>>>> -	xfs_off_t		len)
>>>> +	xfs_off_t		len,
>>>> +	uint32_t flags)
>>>
>>> Messed up indentation.
>>>
>> Oops.
>>
>>> Given that we've been through this for a lot of iterations, what
>>> about you just take Lukas' existing patch and help improving it?
>>
>> I did review his patch[1]. The patches were broken when I tested it but I
>> did not get a reply from him after I reported them. That is why I decided
>> to send a new version.
>>
>> [1] https://lore.kernel.org/linux-xfs/wmxdwtvahubdga73cgzprqtj7fxyjgx5kxvr4cobtl6ski2i6y@ic2g3bfymkwi/
> 
> If I properly got the timeline, you barely gave him time to reply:
> 
> your reply to the original patch: Date: Thu, 26 Feb 2026 14:44:05 +0000
> your RFC time: Date: Fri, 27 Feb 2026 15:08:40 +0100
> 
> You are around enough time to know that people usually requires more
> than 24 hours to reply.
> 

I started working on this in parallel before I realized it was already being 
worked on. I could have waited a bit longer after responding to his patches. :) 
. Sorry for that.

> Please, work with him to get this done. It's not a nice thing to do IMHO
> to pass over somebody's else work if you are aware there is work being
> done.
> 
> FWIW you also didn't Cc'ed him in your RFC as you used the wrong email
> address... I'm fixing the headers so he gets aware of it.
>

Yes, I replied back to the thread with the correct ID [1].

> If by any means I got the timeline wrong above, forget everything I said
> other than the "work with him to get this done".
> 

His patches are not working properly. It is almost a week since I sent that 
message on his thread. I have messaged him again on how to proceed. I will wait 
and see what he replies :)

[1] 
https://lore.kernel.org/linux-xfs/20260227140842.1437710-1-p.raghav@samsung.com/T/#mb773dea20a7fc37772f811b26a5c5dd8941c3d2d

--
Pankaj

