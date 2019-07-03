Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADC755EB5A
	for <lists+linux-xfs@lfdr.de>; Wed,  3 Jul 2019 20:14:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbfGCSOy (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 3 Jul 2019 14:14:54 -0400
Received: from sandeen.net ([63.231.237.45]:45458 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726550AbfGCSOy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Jul 2019 14:14:54 -0400
Received: from Liberator-6.local (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id BB397D5E;
        Wed,  3 Jul 2019 13:14:30 -0500 (CDT)
Subject: Re: [PATCH v2 1/1] xfsprogs: Fix uninitialized cfg->lsunit
From:   Eric Sandeen <sandeen@sandeen.net>
To:     Allison Collins <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org
References: <20190702232746.22516-1-allison.henderson@oracle.com>
 <6a2dd675-f392-dc72-4c8c-7061b9222b89@sandeen.net>
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <ecd99c92-af67-28b9-2cb4-d8c8f94436d4@sandeen.net>
Date:   Wed, 3 Jul 2019 13:14:52 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <6a2dd675-f392-dc72-4c8c-7061b9222b89@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 7/3/19 12:47 PM, Eric Sandeen wrote:
> On 7/2/19 6:27 PM, Allison Collins wrote:
>> From: Allison Henderson <allison.henderson@oracle.com>
>>
>> While investigating another mkfs bug, noticed that cfg->lsunit is sometimes
>> left uninitialized when it should not.  This is because calc_stripe_factors
>> in some cases needs cfg->loginternal to be set first.  This is done in
>> validate_logdev. So move calc_stripe_factors below validate_logdev while
>> parsing configs.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> 
> Ok, while I appreciate you taking Carlos's input, the patch now does
> far more than the commit log says, with no explanation of why it's doing
> so.  (and there's no indication of what actually changed in V2: - putting
> that info below the "---" line is helpful)
> 
> I'd prefer to take the original patch and if we really want to change
> how we initialize empty structures, that should be a separate patch, and
> should hit everywhere we do it, not just mkfs.

Ok so I was on track up to here

> But to Carlos's point, cfg->lsunit isn't exactly "uninitialized"
> (to me, uninitialized means that it was never set, when in fact it was
> initialized, to zero, right?)

and I guess this is just semantics...

> So it's not quite clear to me what's happening here; I guess this test:
> 
>         /*
>          * check that log sunit is modulo fsblksize or default it to dsunit.
>          */
>         if (lsunit) {
>                 /* convert from 512 byte blocks to fs blocks */
>                 cfg->lsunit = DTOBT(lsunit, cfg->blocklog);
>         } else if (cfg->sb_feat.log_version == 2 &&
>                    cfg->loginternal && cfg->dsunit) {
>                 /* lsunit and dsunit now in fs blocks */
>                 cfg->lsunit = cfg->dsunit;
>         }
> 
> is doing the wrong thing because cfg->loginternal hasn't actually been
> evaluated yet?  Is there a mkfs command that demonstrates the problem
> which could be included in the changelog?  Does it only happen with
> external logs?  If you can provide a bit more information about when and
> how this actually fails, that would improve the changelog for future
> generations.

OK, TBH I had confused cfg-> with cli-> (derp) and I see that as you said,
validate_logdev() sets up cfg->loginternal, sorry.  So I'm ok with V1 and
its changelog as it stands, I think.

Sorry for my confusion and the noise,

-Eric

> (also agreeing w/ darrick that these seem like little time bombs...)
> 
> Thanks,
> -Eric
> 
>> ---
>>  mkfs/xfs_mkfs.c | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
>> index 468b8fd..6e32403 100644
>> --- a/mkfs/xfs_mkfs.c
>> +++ b/mkfs/xfs_mkfs.c
>> @@ -3861,15 +3861,15 @@ main(
>>  		.isdirect = LIBXFS_DIRECT,
>>  		.isreadonly = LIBXFS_EXCLUSIVELY,
>>  	};
>> -	struct xfs_mount	mbuf = {};
>> +	struct xfs_mount	mbuf = {0};
>>  	struct xfs_mount	*mp = &mbuf;
>>  	struct xfs_sb		*sbp = &mp->m_sb;
>> -	struct fs_topology	ft = {};
>> +	struct fs_topology	ft = {0};
>>  	struct cli_params	cli = {
>>  		.xi = &xi,
>>  		.loginternal = 1,
>>  	};
>> -	struct mkfs_params	cfg = {};
>> +	struct mkfs_params	cfg = {0};
>>  
>>  	/* build time defaults */
>>  	struct mkfs_default_params	dft = {
>> @@ -4008,7 +4008,6 @@ main(
>>  	cfg.rtblocks = calc_dev_size(cli.rtsize, &cfg, &ropts, R_SIZE, "rt");
>>  
>>  	validate_rtextsize(&cfg, &cli, &ft);
>> -	calc_stripe_factors(&cfg, &cli, &ft);
>>  
>>  	/*
>>  	 * Open and validate the device configurations
>> @@ -4018,6 +4017,7 @@ main(
>>  	validate_datadev(&cfg, &cli);
>>  	validate_logdev(&cfg, &cli, &logfile);
>>  	validate_rtdev(&cfg, &cli, &rtfile);
>> +	calc_stripe_factors(&cfg, &cli, &ft);
>>  
>>  	/*
>>  	 * At this point when know exactly what size all the devices are,
>>
> 
