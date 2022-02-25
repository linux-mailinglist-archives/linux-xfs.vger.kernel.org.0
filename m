Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 072C94C5197
	for <lists+linux-xfs@lfdr.de>; Fri, 25 Feb 2022 23:35:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238268AbiBYWfi (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 25 Feb 2022 17:35:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236215AbiBYWfh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Feb 2022 17:35:37 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 18E131F6BDA
        for <linux-xfs@vger.kernel.org>; Fri, 25 Feb 2022 14:35:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645828504;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tdwFI8/HNO9zA57Faly0CQL2zwlJbm1DHl/wk+x1u2I=;
        b=bm0o4Y3ohGcIBG3bpeRXTqfCdeCZfndL/LmkQO5eBHAc6KyHuFRAbzWiysu0kjoFNELpYR
        q+HmZmKdpn1a78wndskHs4V6JmagSK5NsWKyjCTOgyl3Ho2qD+cliqbtlhvsesb1YMTsMj
        4IaxjlsreFG532pUZv2gXwrx1/4i7aU=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-186-B085Y3rkMxW4Erh5simP7w-1; Fri, 25 Feb 2022 17:35:03 -0500
X-MC-Unique: B085Y3rkMxW4Erh5simP7w-1
Received: by mail-il1-f200.google.com with SMTP id o10-20020a92d4ca000000b002c27571073fso4376681ilm.10
        for <linux-xfs@vger.kernel.org>; Fri, 25 Feb 2022 14:35:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=tdwFI8/HNO9zA57Faly0CQL2zwlJbm1DHl/wk+x1u2I=;
        b=6IwCThkdw+RR91+6nmm/EzEQVAiQKLdI1W+TSkDubsYduvL2yiaHtERL+aVeCngnmu
         xvVudhjCQe6HBB+GXfF0q27uZPxr0QKyzshD2593n/Z6JY1Oa0ahOb6EFkP+86gdVZM6
         0R5e/SXsEEyK40CLuGddgJlBEpgOJjij/bPDk3L8TbCWveDkucdsfKoicrIqvtUZvZ7A
         EqT4C2zn2eQD2gWSEYMJ9TpZ3tpTRS59S22s1V3mF1bAa06S6ALnsnUgX9lpb2jo9BqW
         30P8zGJRtjBXf3OUv4gsHahn6+3o/htbc0y+ir+wcvxJmdENul1cU8anhCTUdrQhop83
         iBwg==
X-Gm-Message-State: AOAM5331thYsNHsgdEgBgkBBQicRB7m7QsLJBL2rAfEIewsqOFP/E/7L
        HbKy5c2Fiq9fFzmpLo8ZY2i0vDNy5k3R8YSO73pOov0Z0GMt7p0pGg/Mfg0XLGax3He4jhnXiGb
        MVMw71Hnlpzgj+1t/9fzm
X-Received: by 2002:a02:cace:0:b0:315:2b2e:f63b with SMTP id f14-20020a02cace000000b003152b2ef63bmr7865438jap.320.1645828502254;
        Fri, 25 Feb 2022 14:35:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy6pKn3lRW4wQAS74HImFAYUoIDlFTUFrn7tRXG8OJKb731lVfLUH5ZV7BUFuMzODLGZ8zRFQ==
X-Received: by 2002:a02:cace:0:b0:315:2b2e:f63b with SMTP id f14-20020a02cace000000b003152b2ef63bmr7865421jap.320.1645828501997;
        Fri, 25 Feb 2022 14:35:01 -0800 (PST)
Received: from [10.0.0.147] (sandeen.net. [63.231.237.45])
        by smtp.gmail.com with ESMTPSA id d4-20020a5d9504000000b006409b9a3a22sm2116238iom.39.2022.02.25.14.35.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Feb 2022 14:35:01 -0800 (PST)
From:   Eric Sandeen <esandeen@redhat.com>
X-Google-Original-From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <a7e204d7-83eb-d2ef-7870-b28b3769e170@redhat.com>
Date:   Fri, 25 Feb 2022 16:35:00 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH v1.1 04/17] libfrog: always use the kernel GETFSMAP
 definitions
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        Dave Chinner <david@fromorbit.com>
References: <164263809453.863810.8908193461297738491.stgit@magnolia>
 <164263811682.863810.12064586264139896800.stgit@magnolia>
 <20220208164605.GC8313@magnolia>
In-Reply-To: <20220208164605.GC8313@magnolia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 2/8/22 10:46 AM, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The GETFSMAP ioctl has been a part of the kernel since 4.12.  We have no
> business shipping a stale copy of kernel header contents in the xfslibs
> package, so get rid of it.  This means that xfs_scrub now has a hard
> dependency on the build system having new kernel headers.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

