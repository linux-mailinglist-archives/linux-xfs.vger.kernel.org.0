Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF3D4549C9A
	for <lists+linux-xfs@lfdr.de>; Mon, 13 Jun 2022 21:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345237AbiFMTBH (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 13 Jun 2022 15:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245680AbiFMTAv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Jun 2022 15:00:51 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C533B95DED
        for <linux-xfs@vger.kernel.org>; Mon, 13 Jun 2022 09:23:16 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id e24so6114725pjt.0
        for <linux-xfs@vger.kernel.org>; Mon, 13 Jun 2022 09:23:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vSNccuYh4we1yOZG+w2VAnrJv46RwvtWv8Xi0I7VYb0=;
        b=hsvCkORtVgR41TYiOOf4gC1iZVI35VK2BvKJXKprg4/aAOmsmzGh7MmU1Yjzuh2Y0c
         XB9OsDGe3tsFn3sOPkYwpDi0nZOF+K6WXfk997VTmOoZnc+TD2dY/Dj3dThEl0ADESNy
         3WMyta6qO45pNCqVz5kPzq/jVNMIsZxMAvm/Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vSNccuYh4we1yOZG+w2VAnrJv46RwvtWv8Xi0I7VYb0=;
        b=FLFwNPam7sF/qdhSP80XfuZCt3HCyHYeJ0IUucxl+flWODUbmz64ELniRByLShqJWw
         p/j7dLBhOsp9Amik/qSI+PNZd0WguTnU6dA9Mf87owvV54aMLNX7QSVuHhAhVOobuY4T
         l5FDu85tEf1jr50K3TRZWbN/NaOBFp/4vWNZav5hP4zXyACFLisWJy8FL/NuIW4ZZfqZ
         XBKRfrIh05vBRkT7ctCOyQqlhbrJf7AUWy8E8bmfk2v9y4eGy/p2IfIWna3zskPdfTT7
         gHXaCOzmRMfKS6wtC7sFBW2BjRyiO+NPSKLDlbKZTGSwKnboCh58D3d+CyAjLTUSVE9d
         wgLA==
X-Gm-Message-State: AJIora+PvfIJCwhjy4CzZ88e2u99khIuCgHwIdNTAvRvLvBG8KAq0ocB
        hBNJrVRQDAUXz42yObF/j7hmAQ==
X-Google-Smtp-Source: AGRyM1spwIqiyw4Fe0nc/aqfToyDFsVpou2Aqr7S4QqIAWEyupmF0bz7MpA6EN2kR7R7y1cM2El+MQ==
X-Received: by 2002:a17:90b:615:b0:1e6:9c25:81ce with SMTP id gb21-20020a17090b061500b001e69c2581cemr601928pjb.148.1655137396268;
        Mon, 13 Jun 2022 09:23:16 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id x8-20020a637c08000000b003fe2062e49esm5677678pgc.73.2022.06.13.09.23.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 09:23:15 -0700 (PDT)
Date:   Mon, 13 Jun 2022 09:23:15 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     linux-mm@kvack.org, Uladzislau Rezki <urezki@gmail.com>,
        Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH 1/3] usercopy: Handle vm_map_ram() areas
Message-ID: <202206130922.A218C4E3E8@keescook>
References: <20220612213227.3881769-1-willy@infradead.org>
 <20220612213227.3881769-2-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220612213227.3881769-2-willy@infradead.org>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jun 12, 2022 at 10:32:25PM +0100, Matthew Wilcox (Oracle) wrote:
> vmalloc does not allocate a vm_struct for vm_map_ram() areas.  That causes
> us to deny usercopies from those areas.  This affects XFS which uses
> vm_map_ram() for its directories.
> 
> Fix this by calling find_vmap_area() instead of find_vm_area().

Thanks for the fixes!

> [...]
> +		/* XXX: We should also abort for free vmap_areas */

What's needed to detect this?

-- 
Kees Cook
