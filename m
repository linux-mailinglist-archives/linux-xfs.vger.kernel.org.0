Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF45E54FC39
	for <lists+linux-xfs@lfdr.de>; Fri, 17 Jun 2022 19:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237383AbiFQRdV (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 17 Jun 2022 13:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbiFQRdT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Jun 2022 13:33:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1307F23BCB
        for <linux-xfs@vger.kernel.org>; Fri, 17 Jun 2022 10:33:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655487197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l9t8ci2pOVMm92hWEf9qj7OSOv7zoUPsj9UgV8OEIRA=;
        b=MH90flJXY+UUDmSid2k1nD5RzwUrvHpR+L/7qp8uw1djLYcERSMIcQYFoBc8kDr5GkTKip
        W1hYYScAWpK9uGUhQ+NHxRUiApWINHs3SykRdbaxmRRbHjXFvL0Z0WrRm8A3z+XBJqiJmj
        N5Dd6v27kxXzzPdoPE/3gEnzHXOkDcw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-416-HFsFYdvgMSCDVmoOg3-mtw-1; Fri, 17 Jun 2022 13:33:16 -0400
X-MC-Unique: HFsFYdvgMSCDVmoOg3-mtw-1
Received: by mail-wr1-f72.google.com with SMTP id z11-20020adfc00b000000b0021a3ab8ec82so928348wre.23
        for <linux-xfs@vger.kernel.org>; Fri, 17 Jun 2022 10:33:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=l9t8ci2pOVMm92hWEf9qj7OSOv7zoUPsj9UgV8OEIRA=;
        b=2hDN5+bRZXcYU5LPhiy0ZIKGR3BZSMDQ8dcs1pBYlqAmdVD5VQQaFyeo1+jb+r1lgt
         s3mveNvSK2LaPh67vxA4fAlr7a5ek3Ckr4GwjG8lbYMLp9+Rc1IP3fJIhrHX40qbix63
         SGXxObYyafbyDRuaXEHYHEGlZKLI2SRtPnVcPnLI648QtcBV6EP4mYLJYY3iY/6e1wMU
         YHWDKL2oPgT9hl7DpNoTxEFqFlH4M/v4M0iP6Le//sBEmZqntdeQj8By5p/1dJMx7C7o
         +75X2YowK9/JYaNaRAOVaA7LN0bJHvEsJORKnw7cf8CAS8hndqcFDww1wgM6DNlxbCcK
         5m1A==
X-Gm-Message-State: AJIora/0noNa9DkXwBcJp53EyGi+imaKUsNg3f/OQketgzH2FIKoQOWw
        YXQpIuetYJ+M1JXjEeUL+gmlzEPDg3g9m3h4oYTKdzSfIYKuO/JifiQywbDUK88npoa/WO3BSN6
        BOZH/VBSwvN0Px1Qgslj0
X-Received: by 2002:a5d:62ce:0:b0:21a:33d9:70eb with SMTP id o14-20020a5d62ce000000b0021a33d970ebmr8760935wrv.86.1655487194591;
        Fri, 17 Jun 2022 10:33:14 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1urFEzCzeOEUS5o/eRCkTO1px9MVS8RRmDRPHAiaj7roLYkwKxp344rt/xnUHDqok2Mu+dWjw==
X-Received: by 2002:a5d:62ce:0:b0:21a:33d9:70eb with SMTP id o14-20020a5d62ce000000b0021a33d970ebmr8760916wrv.86.1655487194277;
        Fri, 17 Jun 2022 10:33:14 -0700 (PDT)
Received: from ?IPV6:2003:cb:c70a:7e00:bb5b:b526:5b76:5824? (p200300cbc70a7e00bb5bb5265b765824.dip0.t-ipconnect.de. [2003:cb:c70a:7e00:bb5b:b526:5b76:5824])
        by smtp.gmail.com with ESMTPSA id h4-20020a5d6e04000000b0020d02262664sm5229194wrz.25.2022.06.17.10.33.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jun 2022 10:33:13 -0700 (PDT)
Message-ID: <7605beee-0a76-4ee9-e950-17419630f2cf@redhat.com>
Date:   Fri, 17 Jun 2022 19:33:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v5 01/13] mm: add zone device coherent type memory support
Content-Language: en-US
To:     "Sierra Guiza, Alejandro (Alex)" <alex.sierra@amd.com>,
        jgg@nvidia.com
Cc:     Felix.Kuehling@amd.com, linux-mm@kvack.org, rcampbell@nvidia.com,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        hch@lst.de, jglisse@redhat.com, apopple@nvidia.com,
        willy@infradead.org, akpm@linux-foundation.org
References: <20220531200041.24904-1-alex.sierra@amd.com>
 <20220531200041.24904-2-alex.sierra@amd.com>
 <3ac89358-2ce0-7d0d-8b9c-8b0e5cc48945@redhat.com>
 <02ed2cb7-3ad3-8ffc-6032-04ae1853e234@amd.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <02ed2cb7-3ad3-8ffc-6032-04ae1853e234@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 17.06.22 19:20, Sierra Guiza, Alejandro (Alex) wrote:
> 
> On 6/17/2022 4:40 AM, David Hildenbrand wrote:
>> On 31.05.22 22:00, Alex Sierra wrote:
>>> Device memory that is cache coherent from device and CPU point of view.
>>> This is used on platforms that have an advanced system bus (like CAPI
>>> or CXL). Any page of a process can be migrated to such memory. However,
>>> no one should be allowed to pin such memory so that it can always be
>>> evicted.
>>>
>>> Signed-off-by: Alex Sierra <alex.sierra@amd.com>
>>> Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
>>> Reviewed-by: Alistair Popple <apopple@nvidia.com>
>>> [hch: rebased ontop of the refcount changes,
>>>        removed is_dev_private_or_coherent_page]
>>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>>> ---
>>>   include/linux/memremap.h | 19 +++++++++++++++++++
>>>   mm/memcontrol.c          |  7 ++++---
>>>   mm/memory-failure.c      |  8 ++++++--
>>>   mm/memremap.c            | 10 ++++++++++
>>>   mm/migrate_device.c      | 16 +++++++---------
>>>   mm/rmap.c                |  5 +++--
>>>   6 files changed, 49 insertions(+), 16 deletions(-)
>>>
>>> diff --git a/include/linux/memremap.h b/include/linux/memremap.h
>>> index 8af304f6b504..9f752ebed613 100644
>>> --- a/include/linux/memremap.h
>>> +++ b/include/linux/memremap.h
>>> @@ -41,6 +41,13 @@ struct vmem_altmap {
>>>    * A more complete discussion of unaddressable memory may be found in
>>>    * include/linux/hmm.h and Documentation/vm/hmm.rst.
>>>    *
>>> + * MEMORY_DEVICE_COHERENT:
>>> + * Device memory that is cache coherent from device and CPU point of view. This
>>> + * is used on platforms that have an advanced system bus (like CAPI or CXL). A
>>> + * driver can hotplug the device memory using ZONE_DEVICE and with that memory
>>> + * type. Any page of a process can be migrated to such memory. However no one
>> Any page might not be right, I'm pretty sure. ... just thinking about special pages
>> like vdso, shared zeropage, ... pinned pages ...
> 

Well, you cannot migrate long term pages, that's what I meant :)

>>
>>> + * should be allowed to pin such memory so that it can always be evicted.
>>> + *
>>>    * MEMORY_DEVICE_FS_DAX:
>>>    * Host memory that has similar access semantics as System RAM i.e. DMA
>>>    * coherent and supports page pinning. In support of coordinating page
>>> @@ -61,6 +68,7 @@ struct vmem_altmap {
>>>   enum memory_type {
>>>   	/* 0 is reserved to catch uninitialized type fields */
>>>   	MEMORY_DEVICE_PRIVATE = 1,
>>> +	MEMORY_DEVICE_COHERENT,
>>>   	MEMORY_DEVICE_FS_DAX,
>>>   	MEMORY_DEVICE_GENERIC,
>>>   	MEMORY_DEVICE_PCI_P2PDMA,
>>> @@ -143,6 +151,17 @@ static inline bool folio_is_device_private(const struct folio *folio)
>> In general, this LGTM, and it should be correct with PageAnonExclusive I think.
>>
>>
>> However, where exactly is pinning forbidden?
> 
> Long-term pinning is forbidden since it would interfere with the device 
> memory manager owning the
> device-coherent pages (e.g. evictions in TTM). However, normal pinning 
> is allowed on this device type.

I don't see updates to folio_is_pinnable() in this patch.

So wouldn't try_grab_folio() simply pin these pages? What am I missing?

-- 
Thanks,

David / dhildenb

