Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCC3C4B29E9
	for <lists+linux-xfs@lfdr.de>; Fri, 11 Feb 2022 17:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350520AbiBKQPc (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 11 Feb 2022 11:15:32 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238817AbiBKQPc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Feb 2022 11:15:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 09D85B88
        for <linux-xfs@vger.kernel.org>; Fri, 11 Feb 2022 08:15:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644596130;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bCRcaleTGgKZtCPcAf/F4rdGaJxNLIOVjEVDZ1rkuA8=;
        b=ZMOaPJX0suHtoX5wZ/XZylqdA1qglUQW62fMDpIidgOdUFTs14G1bspDCy5HLrc7k10/oi
        kKY4OFyJ6oR5tIh29a/VDEN6ZMvT+WOwnkLvlf+Ai+/yR67c/55rWBxNEniiDlY1twrmjM
        rnDNxxHY6hvvBUxyDm4UDFgD7NeuOEI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-8dq-Ts5hP1OhwUZQESE7zg-1; Fri, 11 Feb 2022 11:15:29 -0500
X-MC-Unique: 8dq-Ts5hP1OhwUZQESE7zg-1
Received: by mail-wm1-f71.google.com with SMTP id a8-20020a7bc1c8000000b0037bc4c62e97so2733926wmj.0
        for <linux-xfs@vger.kernel.org>; Fri, 11 Feb 2022 08:15:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:organization:subject
         :in-reply-to:content-transfer-encoding;
        bh=bCRcaleTGgKZtCPcAf/F4rdGaJxNLIOVjEVDZ1rkuA8=;
        b=o3euUd+Z+Kn1Hen71ifAazV646BrpMFR7Tq85st/z60OXSraxBa2Z7bhRTK+CDwcs0
         kvZkI2ST7LnwrGqolIU6hRpUKRBo0FCnJNAc5qau71bXaI7B6vP+OpiQwvBtr3mHIMiZ
         TwMc8FBOPJFLnlVcka3f+x/lR7lv5CkXPMQq63f28oKfB0P0DVAFY5v2C+ANtlhwHIJQ
         ytvMj2AgatYedT7fiuu81XMK0K/hhg6MpfTdmmuzIas8VI47RWnkYOJeT0BX3mAso0X0
         7hYJnTLR0eQrT0Xoqu1m1+qzZTAIWggmwFk7esTIrIPwsrvoAMMfgulBV6Gckgnx9rrc
         1msw==
X-Gm-Message-State: AOAM53129HKMxQlEEoYA67oHRL/vXc1xw27Peic8/k/A7/4ppp9u+XT1
        H6JUypuVsa+R3Mf1L+ROpsiI2If4T/2q3XMXpdBx++tSF2+laamjtHQRulj4I/SgTSnMe0PYc2s
        IFLyO4/7gAsFSYwXdVIY/
X-Received: by 2002:adf:f904:: with SMTP id b4mr1897407wrr.183.1644596127726;
        Fri, 11 Feb 2022 08:15:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxxWjE7RoWsgISgQBtP4hRDQ/YRVeK6b5oKT74teyBVgT9eGeQ23Quvk5zgwZNMOVVwPpSm9A==
X-Received: by 2002:adf:f904:: with SMTP id b4mr1897388wrr.183.1644596127444;
        Fri, 11 Feb 2022 08:15:27 -0800 (PST)
Received: from ?IPV6:2003:cb:c70c:aa00:4cc6:d24a:90ae:8c1f? (p200300cbc70caa004cc6d24a90ae8c1f.dip0.t-ipconnect.de. [2003:cb:c70c:aa00:4cc6:d24a:90ae:8c1f])
        by smtp.gmail.com with ESMTPSA id l21sm4770865wms.0.2022.02.11.08.15.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Feb 2022 08:15:26 -0800 (PST)
Message-ID: <beb38138-2266-1ff8-cc82-8fe914bed862@redhat.com>
Date:   Fri, 11 Feb 2022 17:15:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Content-Language: en-US
To:     Alex Sierra <alex.sierra@amd.com>, akpm@linux-foundation.org,
        Felix.Kuehling@amd.com, linux-mm@kvack.org, rcampbell@nvidia.com,
        linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        hch@lst.de, jgg@nvidia.com, jglisse@redhat.com, apopple@nvidia.com,
        willy@infradead.org
References: <20220201154901.7921-1-alex.sierra@amd.com>
 <20220201154901.7921-2-alex.sierra@amd.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [PATCH v6 01/10] mm: add zone device coherent type memory support
In-Reply-To: <20220201154901.7921-2-alex.sierra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 01.02.22 16:48, Alex Sierra wrote:
> Device memory that is cache coherent from device and CPU point of view.
> This is used on platforms that have an advanced system bus (like CAPI
> or CXL). Any page of a process can be migrated to such memory. However,
> no one should be allowed to pin such memory so that it can always be
> evicted.
> 
> Signed-off-by: Alex Sierra <alex.sierra@amd.com>
> Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
> Reviewed-by: Alistair Popple <apopple@nvidia.com>

So, I'm currently messing with PageAnon() pages and CoW semantics ...
all these PageAnon() ZONE_DEVICE variants don't necessarily make my life
easier but I'm not sure yet if they make my life harder. I hope you can
help me understand some of that stuff.

1) What are expected CoW semantics for DEVICE_COHERENT?

I assume we'll share them just like other PageAnon() pages during fork()
readable, and the first sharer writing to them receives an "ordinary"
!ZONE_DEVICE copy.

So this would be just like DEVICE_EXCLUSIVE CoW handling I assume, just
that we don't have to go through the loop of restoring a device
exclusive entry?

2) How are these pages freed to clear/invalidate PageAnon() ?

I assume for PageAnon() ZONE_DEVICE pages we'll always for via
free_devmap_managed_page(), correct?


3) FOLL_PIN

While you write "no one should be allowed to pin such memory", patch #2
only blocks FOLL_LONGTERM. So I assume we allow ordinary FOLL_PIN and
you might want to be a bit more precise?


... I'm pretty sure we cannot FOLL_PIN DEVICE_PRIVATE pages, but can we
FILL_PIN DEVICE_EXCLUSIVE pages? I strongly assume so?


Thanks for any information.

-- 
Thanks,

David / dhildenb

