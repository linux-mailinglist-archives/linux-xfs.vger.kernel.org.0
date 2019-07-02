Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE715DA44
	for <lists+linux-xfs@lfdr.de>; Wed,  3 Jul 2019 03:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbfGCBHl (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 2 Jul 2019 21:07:41 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34530 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbfGCBHk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 Jul 2019 21:07:40 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x62ME4hl003399
        for <linux-xfs@vger.kernel.org>; Tue, 2 Jul 2019 22:15:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=WoQpXG9j+MMOmoM/r4g6AjZbQ6l/7XSkA3laPoaPzik=;
 b=KgNoqKxS5N9IFQENyVysHs4NOuk88moDdFZhceanDFVsn6JB31SYw5Q6ghzllroHd21T
 TBvXg6m+iduhdFVuYOXK1h/ZzBdxsmpJ3M7Vy9ul7SDJwXdJre7Zlu+I/HjZIR1sblz7
 vQYbF8F9uwNBH1trF4lswNdz3bmMYFvef3c50gXxZD7Na1Osn+DbSqVHRxRmUylnEChb
 37xxKGl4A2I0dAu2qhWy4IpR3Y60+0EQ0ptjdb/CqeB6oMrKBgbGtOsr4sy0Vl7r5lHs
 G0KD1usChdJcS2TbTbeqyealDbVminycv2jTaw9pD7eOdXF10Ab0d346dNK6bsubveHw Yw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2te61px5wb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 02 Jul 2019 22:15:16 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x62MCaGv165406
        for <linux-xfs@vger.kernel.org>; Tue, 2 Jul 2019 22:15:15 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2tebam19g3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 02 Jul 2019 22:15:15 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x62MFEu9001939
        for <linux-xfs@vger.kernel.org>; Tue, 2 Jul 2019 22:15:14 GMT
Received: from [192.168.1.226] (/70.176.225.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 02 Jul 2019 15:15:13 -0700
Subject: Re: [PATCH 1/1] xfsprogs: Fix uninitialized cfg->lsunit
To:     linux-xfs@vger.kernel.org
References: <20190701173538.29710-1-allison.henderson@oracle.com>
 <20190702082608.ju5gvqpo2twmm2eh@pegasus.maiolino.io>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <4616adb3-56d9-c037-e029-8ac5b10a922e@oracle.com>
Date:   Tue, 2 Jul 2019 15:15:12 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190702082608.ju5gvqpo2twmm2eh@pegasus.maiolino.io>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9306 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907020245
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9306 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907020245
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org


On 7/2/19 1:26 AM, Carlos Maiolino wrote:
> Hi,
> 
> On Mon, Jul 01, 2019 at 10:35:38AM -0700, Allison Collins wrote:
>> While investigating another mkfs bug, noticed that cfg->lsunit is sometimes
>> left uninitialized when it should not.  This is because calc_stripe_factors
>> in some cases needs cfg->loginternal to be set first.  This is done in
>> validate_logdev. So move calc_stripe_factors below validate_logdev while
>> parsing configs.
>>
> 
> I believe cfg->lsunit will be left 'uninitialized' every time if it is not
> explicitly set in mkfs command line.
> 
> I believe you are referring to this specific part of the code here:
> 
> ┆       if (lsunit) {
> ┆       ┆       /* convert from 512 byte blocks to fs blocks */
> ┆       ┆       cfg->lsunit = DTOBT(lsunit, cfg->blocklog);
> ┆       } else if (cfg->sb_feat.log_version == 2 &&
> ┆       ┆          cfg->loginternal && cfg->dsunit) {
> ┆       ┆       /* lsunit and dsunit now in fs blocks */
> ┆       ┆       cfg->lsunit = cfg->dsunit;
> ┆       }
> 
> Which, well, unless we set lsunit at command line, we will always fall into the
> else if and leave cfg->lsunit uninitialized, once we still don't have
> cfg->loginternal set.
> 
> This is 'okayish' because we initialize the cfg structure here in main:
> 
> struct mkfs_params┆     cfg = {};
> 
Yeah, it's worth mentioning too that I actually found this while trying 
to fix a corrupted log ticket that was reported to have popped up after 
upgrading xfsprogs.  A lot of trial and error later I found the 
corruption correlated with this bug, but I haven't found out exactly why 
it has that effect yet.  Something not right with how kernel space is 
handling the config I suspect, but I'm still looking at it.

> 
> By default (IIRC), GCC will initialize to 0 all members of the struct, so, we
> are 'safe' here in any case. But, at the same time, (also IIRC), structs should
> not be initialized by empty braces (according to ISO C).
> 
> So, while I agree with your patch, while you're still on it, could you please
> also (and if others agree), properly initialize the structs in main(){}?
> 
> Like:
> 
> @@ -3848,15 +3849,15 @@ main(
>                  .isdirect = LIBXFS_DIRECT,
>                  .isreadonly = LIBXFS_EXCLUSIVELY,
>          };
> -       struct xfs_mount        mbuf = {};
> +       struct xfs_mount        mbuf = {0};
>          struct xfs_mount        *mp = &mbuf;
>          struct xfs_sb           *sbp = &mp->m_sb;
> -       struct fs_topology      ft = {};
> +       struct fs_topology      ft = {0};
>          struct cli_params       cli = {
>                  .xi = &xi,
>                  .loginternal = 1,
>          };
> -       struct mkfs_params      cfg = {};
> +       struct mkfs_params      cfg = {0};
>   
> 
> 
> 
> Anyway, this is more a suggestion due ISO C 'formalities' (which I *think* GCC
> would complain if -Wpedantic was enabled), otherwise I can send a patch later
> changing that, if you decide to go with your patch as-is, you can add:
> 
Ok, that looks reasonable.  I can add that in a v2 and send it out.  Thanks!

Allison

> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
> 
> Cheers
> 
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>>
>> ---
>>   mkfs/xfs_mkfs.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
>> index ddb25ec..f4a5e4b 100644
>> --- a/mkfs/xfs_mkfs.c
>> +++ b/mkfs/xfs_mkfs.c
>> @@ -3995,7 +3995,6 @@ main(
>>   	cfg.rtblocks = calc_dev_size(cli.rtsize, &cfg, &ropts, R_SIZE, "rt");
>>   
>>   	validate_rtextsize(&cfg, &cli, &ft);
>> -	calc_stripe_factors(&cfg, &cli, &ft);
>>   
>>   	/*
>>   	 * Open and validate the device configurations
>> @@ -4005,6 +4004,7 @@ main(
>>   	validate_datadev(&cfg, &cli);
>>   	validate_logdev(&cfg, &cli, &logfile);
>>   	validate_rtdev(&cfg, &cli, &rtfile);
>> +	calc_stripe_factors(&cfg, &cli, &ft);
>>   
>>   	/*
>>   	 * At this point when know exactly what size all the devices are,
>> -- 
>> 2.7.4
>>
> 
