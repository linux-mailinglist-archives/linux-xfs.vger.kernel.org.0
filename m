Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68995544C69
	for <lists+linux-xfs@lfdr.de>; Thu,  9 Jun 2022 14:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240129AbiFIMqT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 9 Jun 2022 08:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233314AbiFIMqS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Jun 2022 08:46:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 32D87215A6B
        for <linux-xfs@vger.kernel.org>; Thu,  9 Jun 2022 05:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654778776;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zufIRXqzWNkS/vBQ6LnlofDt3t0aO0GgELLgxZEV3qM=;
        b=bfaVa0reba5JNx1JCCi449akB/iE7w7HJkh+iPewcoKUtXRVntBOZRj18BsRFXEJQD7Xt3
        GObsr5AzbK9k5Qx9iLnaJWAyVgOUUAb6wweVt7qXGOICRsO1ol959im5WFYdFixia0rC7b
        ZHeTquzJ+C6aZV+E1vVG8wDxl9vLE1g=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-163-9DgwF8eTOqi-FGFb1d15qg-1; Thu, 09 Jun 2022 08:46:14 -0400
X-MC-Unique: 9DgwF8eTOqi-FGFb1d15qg-1
Received: by mail-wm1-f70.google.com with SMTP id p42-20020a05600c1daa00b0039c62488f7eso2641632wms.7
        for <linux-xfs@vger.kernel.org>; Thu, 09 Jun 2022 05:46:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=zufIRXqzWNkS/vBQ6LnlofDt3t0aO0GgELLgxZEV3qM=;
        b=kY2G2UxD8bdjIOX5dF6jpoEDAoGFzbvaoIfCxwm4zkJ0kAiXHbf1yiBKfzg/yGHreE
         37okKrMWQOPSVRxSWCw6G2zNY6a4A+MU3HL2Qdn4QeHb0wNROQUNV2eXkfVWp4zMZKkW
         yX+OQfzVZy1p1ZV3JSb4jQyoIFzF3kXH/LV9v17pXnNsY4nra9MkOQqEHN3qGjWY9gkG
         y0YRDhC2bOLFo7sPnF1Ajuj5RRmTA7P2zL3IHpPR8JKJ0p1AMNSOOv2OwyrK3S7Sr46x
         46fWeSUTYUJ/yIfTXTm5DXPuY1d6yGYz00LLX9FXL5+PbeuG8qsm+u+gJx8sGd9UJCxh
         +VFg==
X-Gm-Message-State: AOAM531o3FPDf4AkEwsMDDfwFiLfo0KrRhL+96ZrFP/StwjeUgmGRqJw
        /ODSWVOPa05DBby8iTNwE/NdTWsrhiEff1rSv+LyFOsMFdMciuf5NGDnom54h8WLxgJTCdxrLc/
        LIs+lQI8kPojTMqc3JU/X
X-Received: by 2002:a05:6000:168b:b0:218:54da:90ba with SMTP id y11-20020a056000168b00b0021854da90bamr12022158wrd.283.1654778773734;
        Thu, 09 Jun 2022 05:46:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxFg5i2EPJ88Gv87gtw7EHVrLhSwsyQAltgpPZk1DxRKIUlDObIOhdmhH9jKki5ThpOI9Vqng==
X-Received: by 2002:a05:6000:168b:b0:218:54da:90ba with SMTP id y11-20020a056000168b00b0021854da90bamr12022117wrd.283.1654778773451;
        Thu, 09 Jun 2022 05:46:13 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:20af:34be:985b:b6c8? ([2a09:80c0:192:0:20af:34be:985b:b6c8])
        by smtp.gmail.com with ESMTPSA id a7-20020a05600c224700b0039c693a54ecsm3854607wmm.23.2022.06.09.05.46.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jun 2022 05:46:12 -0700 (PDT)
Message-ID: <c204c627-ec6b-cd8c-412d-57c8f55c61fa@redhat.com>
Date:   Thu, 9 Jun 2022 14:46:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v2 01/19] secretmem: Remove isolate_page
Content-Language: en-US
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-fsdevel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-aio@kvack.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        cluster-devel@redhat.com, linux-mm@kvack.org,
        linux-xfs@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-ntfs-dev@lists.sourceforge.net, ocfs2-devel@oss.oracle.com,
        linux-mtd@lists.infradead.org,
        virtualization@lists.linux-foundation.org
References: <20220608150249.3033815-1-willy@infradead.org>
 <20220608150249.3033815-2-willy@infradead.org>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20220608150249.3033815-2-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 08.06.22 17:02, Matthew Wilcox (Oracle) wrote:
> The isolate_page operation is never called for filesystems, only
> for device drivers which call SetPageMovable.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  mm/secretmem.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/mm/secretmem.c b/mm/secretmem.c
> index 206ed6b40c1d..1c7f1775b56e 100644
> --- a/mm/secretmem.c
> +++ b/mm/secretmem.c
> @@ -133,11 +133,6 @@ static const struct file_operations secretmem_fops = {
>  	.mmap		= secretmem_mmap,
>  };
>  
> -static bool secretmem_isolate_page(struct page *page, isolate_mode_t mode)
> -{
> -	return false;
> -}
> -
>  static int secretmem_migratepage(struct address_space *mapping,
>  				 struct page *newpage, struct page *page,
>  				 enum migrate_mode mode)
> @@ -155,7 +150,6 @@ const struct address_space_operations secretmem_aops = {
>  	.dirty_folio	= noop_dirty_folio,
>  	.free_folio	= secretmem_free_folio,
>  	.migratepage	= secretmem_migratepage,
> -	.isolate_page	= secretmem_isolate_page,
>  };
>  
>  static int secretmem_setattr(struct user_namespace *mnt_userns,

Reviewed-by: David Hildenbrand <david@redhat.com>

-- 
Thanks,

David / dhildenb

