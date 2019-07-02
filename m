Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A73D55CC00
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Jul 2019 10:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbfGBI0N (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 2 Jul 2019 04:26:13 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41547 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727040AbfGBI0M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jul 2019 04:26:12 -0400
Received: by mail-wr1-f65.google.com with SMTP id c2so16701760wrm.8
        for <linux-xfs@vger.kernel.org>; Tue, 02 Jul 2019 01:26:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=3xWAY0HH3S3kWIXCgsfioRZMKXzbwe3z9wCJISvmWx4=;
        b=WqSSPeW56GsMKsb+iaYxknvzlWJoGRquUNr+1Ax60vOKn89/Zf+PErMUSAZ0Z/bRHt
         XdIlA9NlDJ6lo/ocxym30KuycfSo5I9vhNa5vko0YoEuaoNO8yoqpEf8O5SBiRUIwJ/H
         TYK4/Eo3dPMFWA7viulB2KVmmmj/nqooekUN/6Q8m7v3B55C+t+0jCW/BwTrH5MmZEOL
         Wucw3pTomMhn9n9GjnH6mWjUUjNHuvSUW5rzQhk0BoJ8Gih78BgNBvCSWuSykak+hrxV
         jW8oXmzxdxk82cBbGTxAPcGxslAgJ8FjJ09QOAdj8OtyzZERUDAgWHLcLISYmISbN9KX
         byqA==
X-Gm-Message-State: APjAAAUB5tvYD+PSpxY7ahAoqRAsiMm1KVvIAzq7WtL7G8ubdNjOiOOm
        zWDnqWtrpuodAmBQ1ddiziUqdA==
X-Google-Smtp-Source: APXvYqyMjwQtrcX7acKMuemRIScqB8/CimVX1kuBDKrum9MzEdJhUSHynYzRnkYBsnLi/q/Du4g3yQ==
X-Received: by 2002:adf:ecd2:: with SMTP id s18mr2086002wro.339.1562055970482;
        Tue, 02 Jul 2019 01:26:10 -0700 (PDT)
Received: from pegasus.maiolino.io (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id t6sm2224206wmb.29.2019.07.02.01.26.09
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 01:26:09 -0700 (PDT)
Date:   Tue, 2 Jul 2019 10:26:08 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfsprogs: Fix uninitialized cfg->lsunit
Message-ID: <20190702082608.ju5gvqpo2twmm2eh@pegasus.maiolino.io>
Mail-Followup-To: Allison Collins <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org
References: <20190701173538.29710-1-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190701173538.29710-1-allison.henderson@oracle.com>
User-Agent: NeoMutt/20180716
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

On Mon, Jul 01, 2019 at 10:35:38AM -0700, Allison Collins wrote:
> While investigating another mkfs bug, noticed that cfg->lsunit is sometimes
> left uninitialized when it should not.  This is because calc_stripe_factors
> in some cases needs cfg->loginternal to be set first.  This is done in
> validate_logdev. So move calc_stripe_factors below validate_logdev while
> parsing configs.
> 

I believe cfg->lsunit will be left 'uninitialized' every time if it is not
explicitly set in mkfs command line.

I believe you are referring to this specific part of the code here:

┆       if (lsunit) {
┆       ┆       /* convert from 512 byte blocks to fs blocks */
┆       ┆       cfg->lsunit = DTOBT(lsunit, cfg->blocklog);
┆       } else if (cfg->sb_feat.log_version == 2 && 
┆       ┆          cfg->loginternal && cfg->dsunit) {
┆       ┆       /* lsunit and dsunit now in fs blocks */
┆       ┆       cfg->lsunit = cfg->dsunit;
┆       }

Which, well, unless we set lsunit at command line, we will always fall into the
else if and leave cfg->lsunit uninitialized, once we still don't have
cfg->loginternal set.

This is 'okayish' because we initialize the cfg structure here in main:

struct mkfs_params┆     cfg = {};


By default (IIRC), GCC will initialize to 0 all members of the struct, so, we
are 'safe' here in any case. But, at the same time, (also IIRC), structs should
not be initialized by empty braces (according to ISO C).

So, while I agree with your patch, while you're still on it, could you please
also (and if others agree), properly initialize the structs in main(){}?

Like:

@@ -3848,15 +3849,15 @@ main(
                .isdirect = LIBXFS_DIRECT,
                .isreadonly = LIBXFS_EXCLUSIVELY,
        };
-       struct xfs_mount        mbuf = {};
+       struct xfs_mount        mbuf = {0};
        struct xfs_mount        *mp = &mbuf;
        struct xfs_sb           *sbp = &mp->m_sb;
-       struct fs_topology      ft = {};
+       struct fs_topology      ft = {0};
        struct cli_params       cli = {
                .xi = &xi,
                .loginternal = 1,
        };
-       struct mkfs_params      cfg = {};
+       struct mkfs_params      cfg = {0};
 



Anyway, this is more a suggestion due ISO C 'formalities' (which I *think* GCC
would complain if -Wpedantic was enabled), otherwise I can send a patch later
changing that, if you decide to go with your patch as-is, you can add:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

Cheers

> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> ---
>  mkfs/xfs_mkfs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> index ddb25ec..f4a5e4b 100644
> --- a/mkfs/xfs_mkfs.c
> +++ b/mkfs/xfs_mkfs.c
> @@ -3995,7 +3995,6 @@ main(
>  	cfg.rtblocks = calc_dev_size(cli.rtsize, &cfg, &ropts, R_SIZE, "rt");
>  
>  	validate_rtextsize(&cfg, &cli, &ft);
> -	calc_stripe_factors(&cfg, &cli, &ft);
>  
>  	/*
>  	 * Open and validate the device configurations
> @@ -4005,6 +4004,7 @@ main(
>  	validate_datadev(&cfg, &cli);
>  	validate_logdev(&cfg, &cli, &logfile);
>  	validate_rtdev(&cfg, &cli, &rtfile);
> +	calc_stripe_factors(&cfg, &cli, &ft);
>  
>  	/*
>  	 * At this point when know exactly what size all the devices are,
> -- 
> 2.7.4
> 

-- 
Carlos
