Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69F1F536694
	for <lists+linux-xfs@lfdr.de>; Fri, 27 May 2022 19:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353221AbiE0RaK (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 27 May 2022 13:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354334AbiE0RaG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 May 2022 13:30:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 678CE5C362
        for <linux-xfs@vger.kernel.org>; Fri, 27 May 2022 10:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653672604;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cefitV8uX/6feCDJMEsFPG76wT6MNXuBQFQNrynOdh0=;
        b=B8VKkZamol0rMkxsAtoG6KQ9DYFjp5e1bvqXaTNY1mdtUHd0n/xJfA9IhUTi0WYQ/haFeE
        9WJcxylxlPL8B4LXt/9xlr8vMOnKuZyQAqQiEdZ5/BsctVrXGYqImZwqRND79cj13P3tmr
        cUBRwcjcpaI06eCRwjOg4OdYGQnbwgE=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-474-6X5FNzUCM22mbFsDJNkxwQ-1; Fri, 27 May 2022 13:30:03 -0400
X-MC-Unique: 6X5FNzUCM22mbFsDJNkxwQ-1
Received: by mail-lj1-f200.google.com with SMTP id k9-20020a2e9209000000b00253dffc9556so1439849ljg.2
        for <linux-xfs@vger.kernel.org>; Fri, 27 May 2022 10:30:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent:cc
         :subject:content-language:to:references:in-reply-to
         :content-transfer-encoding;
        bh=cefitV8uX/6feCDJMEsFPG76wT6MNXuBQFQNrynOdh0=;
        b=GpHPT7cvaVKQtcxeHM25gH9tYvV9PDBwFm2neZ3Av9wlZLfmLBRs4SHWxMLguzBiKa
         SyhHaxTKVcsSgvb8C4whI0hyba8VwtvIgja4BNGP8l/ZcbTTAmAEOqUBhP5LmcPJMuV6
         XJAz6eODKJc7EtOiJTsFaPYsZqLYG2yayvaIDYjCcTBudblZ7vvxxU8x3xmz371/U+Oq
         M9cvjTgjtndZhkRNx4Q06hy56kzSrH0i5Z2tm4Gumd0oWqjH0xrXgHG7TKtg+0H1MJKn
         ril2cyNZ9hof7FU9ULFXJmdNOrZcF9hul2qnhJEfZu/d2ui6w4W7jQmhCjv6Cvi9v/6l
         22Yg==
X-Gm-Message-State: AOAM532KHyMvNrQ3IEIXuUPD8LnoMvZzUREdkeB+OoPi2A1QWc7CdwKG
        cv/EGARM5+OxOWTBB5k06NUmoQy1ElXVKwj1Uuc9qw57YnRLv0BhHI2OepDu/a/IMSnOWN0CZi4
        nii2dWGqh3Ir43n1aQ+yY
X-Received: by 2002:a05:6512:1189:b0:478:8b81:d3b2 with SMTP id g9-20020a056512118900b004788b81d3b2mr13924877lfr.247.1653672601597;
        Fri, 27 May 2022 10:30:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzHy8Z11UyDeJF1PfQehPGRpRB2pdmd+NOjG8IQ3dm26jx4WasEfdOhzMuSV+x3EkYQK3j+tQ==
X-Received: by 2002:a05:6512:1189:b0:478:8b81:d3b2 with SMTP id g9-20020a056512118900b004788b81d3b2mr13924859lfr.247.1653672601309;
        Fri, 27 May 2022 10:30:01 -0700 (PDT)
Received: from [192.168.0.50] (87-59-106-155-cable.dk.customer.tdc.net. [87.59.106.155])
        by smtp.gmail.com with ESMTPSA id bj38-20020a2eaaa6000000b0025541ce7ef1sm134106ljb.11.2022.05.27.10.29.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 May 2022 10:30:00 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <16e1aba3-99af-9cc9-88d5-2cf0f1ed618b@redhat.com>
Date:   Fri, 27 May 2022 19:29:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Cc:     brouer@redhat.com, "Darrick J. Wong" <djwong@kernel.org>,
        Dave Chinner <dchinner@redhat.com>, Jan Kara <jack@suse.cz>,
        Vlastimil Babka <vbabka@suse.cz>,
        Chuck Lever <chuck.lever@oracle.com>,
        Linux-NFS <linux-nfs@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-XFS <linux-xfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/page_alloc: Always attempt to allocate at least one
 page during bulk allocation
Content-Language: en-US
To:     Mel Gorman <mgorman@techsingularity.net>,
        Andrew Morton <akpm@linux-foundation.org>
References: <20220526091210.GC3441@techsingularity.net>
In-Reply-To: <20220526091210.GC3441@techsingularity.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 26/05/2022 11.12, Mel Gorman wrote:
> Peter Pavlisko reported the following problem on kernel bugzilla 216007.
> 
> 	When I try to extract an uncompressed tar archive (2.6 milion
> 	files, 760.3 GiB in size) on newly created (empty) XFS file system,
> 	after first low tens of gigabytes extracted the process hangs in
> 	iowait indefinitely. One CPU core is 100% occupied with iowait,
> 	the other CPU core is idle (on 2-core Intel Celeron G1610T).
> 
> It was bisected to c9fa563072e1 ("xfs: use alloc_pages_bulk_array() for
> buffers") but XFS is only the messenger. The problem is that nothing
> is waking kswapd to reclaim some pages at a time the PCP lists cannot
> be refilled until some reclaim happens. The bulk allocator checks that
> there are some pages in the array and the original intent was that a bulk
> allocator did not necessarily need all the requested pages and it was
> best to return as quickly as possible. This was fine for the first user
> of the API but both NFS and XFS require the requested number of pages
> be available before making progress. Both could be adjusted to call the
> page allocator directly if a bulk allocation fails but it puts a burden on
> users of the API. Adjust the semantics to attempt at least one allocation
> via __alloc_pages() before returning so kswapd is woken if necessary.
> 
> It was reported via bugzilla that the patch addressed the problem and
> that the tar extraction completed successfully. This may also address
> bug 215975 but has yet to be confirmed.
> 
> BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=216007
> BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=215975
> Fixes: 387ba26fb1cb ("mm/page_alloc: add a bulk page allocator")
> Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
> Cc: <stable@vger.kernel.org> # v5.13+
> ---
>   mm/page_alloc.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)


Change looks good, and I checked page_pool will be fine with this change :-)

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>


> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 0e42038382c1..5ced6cb260ed 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5324,8 +5324,8 @@ unsigned long __alloc_pages_bulk(gfp_t gfp, int preferred_nid,
>   		page = __rmqueue_pcplist(zone, 0, ac.migratetype, alloc_flags,
>   								pcp, pcp_list);
>   		if (unlikely(!page)) {
> -			/* Try and get at least one page */
> -			if (!nr_populated)
> +			/* Try and allocate at least one page */
> +			if (!nr_account)
>   				goto failed_irq;
>   			break;
>   		}
> 

