Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA06538773
	for <lists+linux-xfs@lfdr.de>; Mon, 30 May 2022 20:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238219AbiE3SjU (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 30 May 2022 14:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242733AbiE3SjT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 May 2022 14:39:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D64A09345C
        for <linux-xfs@vger.kernel.org>; Mon, 30 May 2022 11:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653935957;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oREYfii8268D+SJ71twg9YvDIowl5zBevuAhXKYzK4M=;
        b=eTlYWu29EdWuT4T0WMdohZEVyOkM46KaV7azjs+A8HwuRt/WC7p3vIdb+5jMOYO0eNX0xh
        KlUEDh0cjb5FRme/1ETtaOvDFo8+L/rbcIDet91PvcZ/xzRyTbPM9EvYpcqYaSNeNZbB3N
        6TjXGWmtR2QT32x5BuGzq5uogT7df7s=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-225-lUt7grmPPySP4wEs2ufM6g-1; Mon, 30 May 2022 14:39:15 -0400
X-MC-Unique: lUt7grmPPySP4wEs2ufM6g-1
Received: by mail-qt1-f200.google.com with SMTP id s36-20020a05622a1aa400b00304b8f28352so254151qtc.23
        for <linux-xfs@vger.kernel.org>; Mon, 30 May 2022 11:39:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oREYfii8268D+SJ71twg9YvDIowl5zBevuAhXKYzK4M=;
        b=bMIBdZAk3YjxOhv2mYxTTZPD57zS+VzjfyRMcxjtdH1FF/2Foz34QEIepYx3ZQKiJv
         fx4NSY4C7nFmGSLHyyTjACFABZg7QoClLNIxoNSXsoKkCLXh00Y8JQRlWEJddpUMtFNT
         0YhZ+vw3NZB6Hn3C1azq2Dl68H3sUXA24ZYkbYi0ZibQ9Qz9nIS9N3I+nwXEVs1e2V8+
         eE4c13IDoDYgY7l0DF4BbSLQdR47BUyH8d6xGS52qxQWpOlvh6Tz1reWUDBZTvDF/Ike
         /EBaHFWIXvlrZWu46zNAlPRJO/pPx4GseorK87jt2nblpb7rrpKFXSowo/eKajJGsJyb
         BL4A==
X-Gm-Message-State: AOAM531lshZNqJcvT+lMr/5AXbDtukT1uKEKFK7vMsIVoo35sfRggd+x
        0cCS4EItyGeEG1BFcbFmfkzblLQY3W15W8ZG6CWem9seNGPod58bXV+Dm4b5zYuStw0U34dGEd2
        ZAMkrHcYJhB+7Bwqx9hMd
X-Received: by 2002:a05:620a:1a14:b0:69e:9090:a7ba with SMTP id bk20-20020a05620a1a1400b0069e9090a7bamr38266504qkb.582.1653935955374;
        Mon, 30 May 2022 11:39:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzCToRradBLOq6t7wYOeb4G8/QmYmXQANMYcAUrzfr+44PNLUgltY7kruU/ecnwjtQHIwmoTw==
X-Received: by 2002:a05:620a:1a14:b0:69e:9090:a7ba with SMTP id bk20-20020a05620a1a1400b0069e9090a7bamr38266494qkb.582.1653935955102;
        Mon, 30 May 2022 11:39:15 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y16-20020a376410000000b006a371ba1fa5sm8055751qkb.32.2022.05.30.11.39.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 May 2022 11:39:14 -0700 (PDT)
Date:   Tue, 31 May 2022 02:39:08 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     linux-mm@kvack.org
Cc:     linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        nvdimm@lists.linux.dev
Subject: Re: Potential regression on kernel 5.19-rc0: kernel BUG at
 mm/page_table_check.c:51!
Message-ID: <20220530183908.vi7u37a6irji4gnf@zlang-mailbox>
References: <20220530080616.6h77ppymilyvjqus@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220530080616.6h77ppymilyvjqus@zlang-mailbox>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 30, 2022 at 04:06:16PM +0800, Zorro Lang wrote:
> Hi mm folks:
> 
> I reported a regression bug on latest upstream linux:
> https://bugzilla.kernel.org/show_bug.cgi?id=216047
> 
> It's about xfs/ext4 + DAX, panic at mm/page_table_check.c:51!
> 
>   static struct page_table_check *get_page_table_check(struct page_ext *page_ext)
>   {
> ==>     BUG_ON(!page_ext);
>         return (void *)(page_ext) + page_table_check_ops.offset;
>   }
> 
> It's 100% reproducible for me, by running fstests generic/623:
>   https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git/tree/tests/generic/623
> on xfs or ext4 with DAX enabled.
> 
> It doesn't look like a xfs or ext4 issue, so send to linux-mm to get more
> reviewing. More details please refer to above bug link. I changed its Pruduct
> to mm, but the Assignee isn't changed by default.

It's not a regression *recently* at least, I still can reproduce this bug on
linux v5.16.

But I found it's related with someone kernel configuration (sorry I haven't
figured out which one config is). I've upload two kernel config files, one[1]
can build a kernel which reproduce this bug, the other[2] can't. Hope that
helps.

Thanks,
Zorro

[1]
https://bugzilla.kernel.org/attachment.cgi?id=301076

[2]
https://bugzilla.kernel.org/attachment.cgi?id=301077

> 
> Thanks,
> Zorro

