Return-Path: <linux-xfs+bounces-9258-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0127B906655
	for <lists+linux-xfs@lfdr.de>; Thu, 13 Jun 2024 10:16:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9742DB25205
	for <lists+linux-xfs@lfdr.de>; Thu, 13 Jun 2024 08:16:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CD2113D292;
	Thu, 13 Jun 2024 08:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JkMitWJo"
X-Original-To: linux-xfs@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C63EE13D27C
	for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 08:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718266578; cv=none; b=LJjTL31ggroJGl0I5F+jtcG9aIaOnsR4lAvbh2eQKbP30jkMIZmeK78pZO1PYAq35z8HLiP3DbjXH0s1z4nHeUGp01QWSh0BexEyu02VLH/JuXOXYnInoNe2XH4WEuCDakLqSmTtl2e9jHuak2UdQKq5JA17FJXgUTGMHkAbG5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718266578; c=relaxed/simple;
	bh=P6zNzJkQBMx5DTOSRI1hmpjN0MortLz96yG/1i2J41M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fiq1Z2HdPyz36TS4gSDCkdpaqGEKSoQakezEaoEJOE5AzXoYMnJVF6Px9toJUhiHJ9WQvKx8erp9AtfxsuxdKdXYQi4W4SecE69Pc2ilcuG39Xnsie3CGzzDDz7lliniphnh7j7uJBGa6zOSvPC0Uka3LBv7NIzzXCY4iu3LWjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JkMitWJo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718266575;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+HvS5o00goPyqB2yAiG1GSSXSOvqSTXokODERQ3Empw=;
	b=JkMitWJo3ydsPAhEKdSnUwQScxU8xtctaBze0do9O0c+zmzVie+LM8J+neXHoPdqNL79EK
	DkDfFwmqG4vAYIc9AH2ntt211tA49Zi/XXjkxtO81V5Oab3iP7rcACkW/F0elZRapo2AWU
	CgiNEifqhNe9zPa65o1Tpl0+NB8VvNg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-638-o8YS1gjWPpmLFvzGapLFyA-1; Thu, 13 Jun 2024 04:16:14 -0400
X-MC-Unique: o8YS1gjWPpmLFvzGapLFyA-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-358f9dffbedso456797f8f.3
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2024 01:16:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718266573; x=1718871373;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+HvS5o00goPyqB2yAiG1GSSXSOvqSTXokODERQ3Empw=;
        b=ZcTzJsOY3YTKTP89BajnHLwdHW6R09vWq/6fnm6eYk3c1MA3JcYWjEH5zME0AP04+H
         9ENxHIV0AiWn9E/Bcok+a+rpdiWG/kUL67KA2/CaEhLsbPEwmltf6Q3A0gg6X8F0G86d
         4Eb1z/wU+b45g2tLObNDKNsf4ELxnYZ1lJEL5cZMHSTtUMj5GCSDPALbHekm2s5mrnNU
         /KJDhw/ccUdwYo0XdxB1RoSRsvC+L4ASnXPy9kSm9ybiu2GDcD3XzUMasS+l708GXPXA
         AYlO7X7k6e8Wo9aQReuVAD0g0rp2+b5yfQRlNUPhemoekQ6DGv9KnI8OPTQdepqBZk67
         VrYw==
X-Forwarded-Encrypted: i=1; AJvYcCWwTwm/oyz/ou0YbPusRFJq+AriyAmlSF478Bvvnbu5JaHZriRnz6XU13VdZx9JXMUktwDgF3PVW7Pp/JCOiYEvTVxWroHmSX/F
X-Gm-Message-State: AOJu0YyCaAi5XmUODMUxf1AUkjoRBXQfy2JrjoNoXkyakS88WbF3PEOj
	E3amOgL9tQUwq0JYEKMdYTrjXre40uANT75RaPTvd82RHxd20nXo+MRrCT11VyRD66Lx4OOQF91
	buRvY8gSNcalq463MtbFHEM4RwoNZe+UQWNlppSXZNDxYeI2OMl/T4eYvYQ==
X-Received: by 2002:adf:fe0a:0:b0:35f:fa0:cf82 with SMTP id ffacd0b85a97d-35fe891b400mr2828538f8f.68.1718266572857;
        Thu, 13 Jun 2024 01:16:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF7HepdPNeI8qmEZe10F4ZflLGI6ol2kzakdoPepdhR1E/su+t2ZMdOE1SBCwkbrt47wDdmrg==
X-Received: by 2002:adf:fe0a:0:b0:35f:fa0:cf82 with SMTP id ffacd0b85a97d-35fe891b400mr2828517f8f.68.1718266572443;
        Thu, 13 Jun 2024 01:16:12 -0700 (PDT)
Received: from ?IPV6:2003:cb:c703:fe00:10fe:298:6bf1:d163? (p200300cbc703fe0010fe02986bf1d163.dip0.t-ipconnect.de. [2003:cb:c703:fe00:10fe:298:6bf1:d163])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36075093547sm956156f8f.19.2024.06.13.01.16.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Jun 2024 01:16:12 -0700 (PDT)
Message-ID: <b3fef638-4f4a-4688-8a39-8dfa4ae88836@redhat.com>
Date: Thu, 13 Jun 2024 10:16:10 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 06/11] filemap: cap PTE range to be created to allowed
 zero fill in folio_map_range()
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>,
 yang@os.amperecomputing.com, linmiaohe@huawei.com, muchun.song@linux.dev,
 osalvador@suse.de, "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>,
 david@fromorbit.com, djwong@kernel.org, chandan.babu@oracle.com,
 brauner@kernel.org, akpm@linux-foundation.org, linux-mm@kvack.org,
 hare@suse.de, linux-kernel@vger.kernel.org, Zi Yan <zi.yan@sent.com>,
 linux-xfs@vger.kernel.org, p.raghav@samsung.com,
 linux-fsdevel@vger.kernel.org, hch@lst.de, gost.dev@samsung.com,
 cl@os.amperecomputing.com, john.g.garry@oracle.com
References: <20240607145902.1137853-1-kernel@pankajraghav.com>
 <20240607145902.1137853-7-kernel@pankajraghav.com>
 <ZmnyH_ozCxr_NN_Z@casper.infradead.org>
 <ZmqmWrzmL5Wx2DoF@bombadil.infradead.org>
 <818f69fa-9dc7-4ca0-b3ab-a667cd1fb16d@redhat.com>
 <ZmqqIrv4Fms-Vi6E@bombadil.infradead.org>
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
Autocrypt: addr=david@redhat.com; keydata=
 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
 WNyWQQ==
Organization: Red Hat
In-Reply-To: <ZmqqIrv4Fms-Vi6E@bombadil.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 13.06.24 10:13, Luis Chamberlain wrote:
> On Thu, Jun 13, 2024 at 10:07:15AM +0200, David Hildenbrand wrote:
>> On 13.06.24 09:57, Luis Chamberlain wrote:
>>> On Wed, Jun 12, 2024 at 08:08:15PM +0100, Matthew Wilcox wrote:
>>>> On Fri, Jun 07, 2024 at 02:58:57PM +0000, Pankaj Raghav (Samsung) wrote:
>>>>> From: Pankaj Raghav <p.raghav@samsung.com>
>>>>>
>>>>> Usually the page cache does not extend beyond the size of the inode,
>>>>> therefore, no PTEs are created for folios that extend beyond the size.
>>>>>
>>>>> But with LBS support, we might extend page cache beyond the size of the
>>>>> inode as we need to guarantee folios of minimum order. Cap the PTE range
>>>>> to be created for the page cache up to the max allowed zero-fill file
>>>>> end, which is aligned to the PAGE_SIZE.
>>>>
>>>> I think this is slightly misleading because we might well zero-fill
>>>> to the end of the folio.  The issue is that we're supposed to SIGBUS
>>>> if userspace accesses pages which lie entirely beyond the end of this
>>>> file.  Can you rephrase this?
>>>>
>>>> (from mmap(2))
>>>>          SIGBUS Attempted access to a page of the buffer that lies beyond the end
>>>>                 of the mapped file.  For an explanation of the treatment  of  the
>>>>                 bytes  in  the  page that corresponds to the end of a mapped file
>>>>                 that is not a multiple of the page size, see NOTES.
>>>>
>>>>
>>>> The code is good though.
>>>>
>>>> Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
>>>
>>> Since I've been curating the respective fstests test to test for this
>>> POSIX corner case [0] I wanted to enable the test for tmpfs instead of
>>> skipping it as I originally had it, and that meant also realizing mmap(2)
>>> specifically says this now:
>>>
>>> Huge page (Huge TLB) mappings
>>
>> Confusion alert: this likely talks about hugetlb (MAP_HUGETLB), not THP and
>> friends.
>>
>> So it might not be required for below changes.
> 
> Thanks, I had to ask as we're dusting off this little obscure corner of
> the universe. Reason I ask, is the test fails for tmpfs with huge pages,
> and this patch fixes it, but it got me wondering the above applies also
> to tmpfs with huge pages.

Is it tmpfs with THP/large folios or shmem with hugetlb? I assume the 
tmpfs with THP. There are not really mmap/munmap restrictions to THP and 
friends (because it's supposed to be "transparent" :) ).

-- 
Cheers,

David / dhildenb


