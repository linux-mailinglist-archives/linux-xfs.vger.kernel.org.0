Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62879543104
	for <lists+linux-xfs@lfdr.de>; Wed,  8 Jun 2022 15:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239959AbiFHNG2 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 8 Jun 2022 09:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239927AbiFHNG1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Jun 2022 09:06:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DA4BB1A40B1
        for <linux-xfs@vger.kernel.org>; Wed,  8 Jun 2022 06:06:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654693582;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=USUlEZ1UMdOAkVgNJKy6bNhyk03F1F+22jSwcfgVGi0=;
        b=UoJHHshZaUShraxSBVjI9WRQAg6Q8lBYAs+8JFhFch1f8CMfyCw5VlBsPzd0X33miW+LTV
        n+tFAzMZNP2w2mf/RoLa1qgjKmsiAzj7xWGHz0ugiGJ3JHWu1q5zh2oMRdIe+6x9O6Sb7q
        dIDTMPpWOFo8ML+JcvJ3jH62YcKv8sA=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-42-BTsCp2TPMCKlBSmplGysoQ-1; Wed, 08 Jun 2022 09:06:21 -0400
X-MC-Unique: BTsCp2TPMCKlBSmplGysoQ-1
Received: by mail-qt1-f200.google.com with SMTP id g14-20020ac87d0e000000b00304c6e43d12so16144038qtb.0
        for <linux-xfs@vger.kernel.org>; Wed, 08 Jun 2022 06:06:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=USUlEZ1UMdOAkVgNJKy6bNhyk03F1F+22jSwcfgVGi0=;
        b=ksMkufRWMUbtviccEWoB26Fx1j59QHdZsTkbQ5o+JQVVqbpZ6Njh8INGDHoiwZDRar
         Ctb9Wsy0ZEMYcRleix54K2UH9t1qoa7leHNNCoIRJbDRLaAG6rZytbhAUgxEvZjnS7o5
         C/k0+jV3/qVj4Sgcai53SdaKV6qiDz2gOL1UnabzGYdpBUb1Z0ieXtkyXrzvSKhKXciG
         2VhlYt96zIt1QNxF6mcFTqFKvNzSVRyShOsB9ntkSriyxMbt4Nlom+Q9abKHm4AGUCMJ
         K7tO9IgBWaVWAC9m8AVDkRPQnEN8+Qct/a8/3DQQZcOXfN0DrvANGtfeEXFgCAC1Cyyt
         PPoA==
X-Gm-Message-State: AOAM533/QBMo/uLk7M1+QcIsUT7VqBzfrRMT7uJgAUy8G3egDV5k3GLN
        JCqHjN3Mzw83Vub9Y4InZuc6tC7Tabr0QHIWhMJ9V6SPo482Tj1B6TwqJA8pHw327J+ktJ339RM
        Otz6uNBVj4CDc2r7ipEBT
X-Received: by 2002:a05:622a:1013:b0:305:3c:232e with SMTP id d19-20020a05622a101300b00305003c232emr2957092qte.180.1654693580925;
        Wed, 08 Jun 2022 06:06:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzmMXLqnBI6Og+4P0GHsdMp3mdyP17UTS82rMH1Kp6fTALPnxZvoiZs7I0UncTVXHO0B2TwhQ==
X-Received: by 2002:a05:622a:1013:b0:305:3c:232e with SMTP id d19-20020a05622a101300b00305003c232emr2957043qte.180.1654693580507;
        Wed, 08 Jun 2022 06:06:20 -0700 (PDT)
Received: from optiplex-fbsd (c-73-182-255-193.hsd1.nh.comcast.net. [73.182.255.193])
        by smtp.gmail.com with ESMTPSA id v10-20020a05620a440a00b0069fc13ce217sm4216712qkp.72.2022.06.08.06.06.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 06:06:20 -0700 (PDT)
Date:   Wed, 8 Jun 2022 09:06:17 -0400
From:   Rafael Aquini <aquini@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Matthew Wilcox <willy@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-aio@kvack.org,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
        linux-mm@kvack.org, linux-xfs@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net,
        ocfs2-devel@oss.oracle.com, linux-mtd@lists.infradead.org,
        virtualization@lists.linux-foundation.org,
        Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH 15/20] balloon: Convert to migrate_folio
Message-ID: <YqCeyZO77Oi1wvxt@optiplex-fbsd>
References: <20220606204050.2625949-1-willy@infradead.org>
 <20220606204050.2625949-16-willy@infradead.org>
 <e4d017a4-556d-bb5f-9830-a8843591bc8d@redhat.com>
 <Yp9fj/Si2qyb61Y3@casper.infradead.org>
 <Yp+lU55H4igaV3pB@casper.infradead.org>
 <36cc5e2b-b768-ce1c-fa30-72a932587289@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36cc5e2b-b768-ce1c-fa30-72a932587289@redhat.com>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 08, 2022 at 11:59:31AM +0200, David Hildenbrand wrote:
> On 07.06.22 21:21, Matthew Wilcox wrote:
> > On Tue, Jun 07, 2022 at 03:24:15PM +0100, Matthew Wilcox wrote:
> >> On Tue, Jun 07, 2022 at 09:36:21AM +0200, David Hildenbrand wrote:
> >>> On 06.06.22 22:40, Matthew Wilcox (Oracle) wrote:
> >>>>  const struct address_space_operations balloon_aops = {
> >>>> -	.migratepage = balloon_page_migrate,
> >>>> +	.migrate_folio = balloon_migrate_folio,
> >>>>  	.isolate_page = balloon_page_isolate,
> >>>>  	.putback_page = balloon_page_putback,
> >>>>  };
> >>>
> >>> I assume you're working on conversion of the other callbacks as well,
> >>> because otherwise, this ends up looking a bit inconsistent and confusing :)
> >>
> >> My intention was to finish converting aops for the next merge window.
> >>
> >> However, it seems to me that we goofed back in 2016 by merging
> >> commit bda807d44454.  isolate_page() and putback_page() should
> >> never have been part of address_space_operations.
> >>
> >> I'm about to embark on creating a new migrate_operations struct
> >> for drivers to use that contains only isolate/putback/migrate.
> >> No filesystem uses isolate/putback, so those can just be deleted.
> >> Both migrate_operations & address_space_operations will contain a
> >> migrate callback.
> 
> That makes sense to me. I wonder if there was a design
> decision/discussion behind that. CCing Rafael.
>

None that I recollect. If memory still serves me, I think the idea behind
bda807d44454 and friends was to provide a generic way to allow page
mobility for drivers without adding complexity to the page isolation / putback
paths, and since the migration callback was already part of the aops struct
those new callbacks just followed suit.


-- Rafael

