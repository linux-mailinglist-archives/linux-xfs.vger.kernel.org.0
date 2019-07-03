Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4B45EC15
	for <lists+linux-xfs@lfdr.de>; Wed,  3 Jul 2019 21:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbfGCTBy (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 3 Jul 2019 15:01:54 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43574 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726473AbfGCTBx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Jul 2019 15:01:53 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x63IwdWl161151;
        Wed, 3 Jul 2019 19:01:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=ybsYCnb6fSq6zBLfqW1vWLFm+ix1QnHOUKbEAlCiQ/c=;
 b=2wWecRThAdHRLuKVBxj9fj8yL9o91jxt0hLMEQVCKbln2fVfcz513qJbP6pxBu5FRDsK
 RsiMbuMEiueHQVklsux8X0hwJwRFgJG7YJ6oEdN5AUgVJWr9wQeuYi6Hk1H8B6wmM7us
 5j9T4dM2EOruDitoSbrvHOFkqF+cfPTWi6nBRhIxfGqoxOEcrL5+100inWAfkWLVsiOG
 fmpakUGEIKeE/EhSxPzTw3SsmdDbqGAaeBDjq41fdkGiTNYPqT+0a5XoQ2fWw1d+Je5B
 rspIYMVxDMo1FkW7kqvymIhwNnLVguTPB8PLU1GD/uArLZ0nmFKujTwBE+xVq8SnNGdt /Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2te61eb5gj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Jul 2019 19:01:50 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x63IwTml141685;
        Wed, 3 Jul 2019 19:01:50 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 2tebqh9fdh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Jul 2019 19:01:50 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x63J1nMu017991;
        Wed, 3 Jul 2019 19:01:49 GMT
Received: from [192.168.1.226] (/70.176.225.12)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 03 Jul 2019 12:01:49 -0700
Subject: Re: [PATCH v2 1/1] xfsprogs: Fix uninitialized cfg->lsunit
To:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
References: <20190702232746.22516-1-allison.henderson@oracle.com>
 <6a2dd675-f392-dc72-4c8c-7061b9222b89@sandeen.net>
 <ecd99c92-af67-28b9-2cb4-d8c8f94436d4@sandeen.net>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <530852ba-96f5-8beb-304b-5b4836af3ec1@oracle.com>
Date:   Wed, 3 Jul 2019 12:01:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <ecd99c92-af67-28b9-2cb4-d8c8f94436d4@sandeen.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9307 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907030232
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9307 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907030232
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 7/3/19 11:14 AM, Eric Sandeen wrote:
> On 7/3/19 12:47 PM, Eric Sandeen wrote:
>> On 7/2/19 6:27 PM, Allison Collins wrote:
>>> From: Allison Henderson <allison.henderson@oracle.com>
>>>
>>> While investigating another mkfs bug, noticed that cfg->lsunit is sometimes
>>> left uninitialized when it should not.  This is because calc_stripe_factors
>>> in some cases needs cfg->loginternal to be set first.  This is done in
>>> validate_logdev. So move calc_stripe_factors below validate_logdev while
>>> parsing configs.
>>>
>>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>>> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
>>> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
>>
>> Ok, while I appreciate you taking Carlos's input, the patch now does
>> far more than the commit log says, with no explanation of why it's doing
>> so.  (and there's no indication of what actually changed in V2: - putting
>> that info below the "---" line is helpful)
>>
>> I'd prefer to take the original patch and if we really want to change
>> how we initialize empty structures, that should be a separate patch, and
>> should hit everywhere we do it, not just mkfs.
> 
> Ok so I was on track up to here
> 
>> But to Carlos's point, cfg->lsunit isn't exactly "uninitialized"
>> (to me, uninitialized means that it was never set, when in fact it was
>> initialized, to zero, right?)
> 
> and I guess this is just semantics...
> 
>> So it's not quite clear to me what's happening here; I guess this test:
>>
>>          /*
>>           * check that log sunit is modulo fsblksize or default it to dsunit.
>>           */
>>          if (lsunit) {
>>                  /* convert from 512 byte blocks to fs blocks */
>>                  cfg->lsunit = DTOBT(lsunit, cfg->blocklog);
>>          } else if (cfg->sb_feat.log_version == 2 &&
>>                     cfg->loginternal && cfg->dsunit) {
>>                  /* lsunit and dsunit now in fs blocks */
>>                  cfg->lsunit = cfg->dsunit;
>>          }
>>
>> is doing the wrong thing because cfg->loginternal hasn't actually been
>> evaluated yet?  Is there a mkfs command that demonstrates the problem
>> which could be included in the changelog?  Does it only happen with
>> external logs?  If you can provide a bit more information about when and
>> how this actually fails, that would improve the changelog for future
>> generations.
> 
> OK, TBH I had confused cfg-> with cli-> (derp) and I see that as you said,
> validate_logdev() sets up cfg->loginternal, sorry.  So I'm ok with V1 and
> its changelog as it stands, I think.
> 
> Sorry for my confusion and the noise,
> 
> -Eric

Alrighty then, I think I answered all your other questions in the IRC 
chat.  Thank you!!

Allison

> 
>> (also agreeing w/ darrick that these seem like little time bombs...)
>>
>> Thanks,
>> -Eric
>>
>>> ---
>>>   mkfs/xfs_mkfs.c | 8 ++++----
>>>   1 file changed, 4 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
>>> index 468b8fd..6e32403 100644
>>> --- a/mkfs/xfs_mkfs.c
>>> +++ b/mkfs/xfs_mkfs.c
>>> @@ -3861,15 +3861,15 @@ main(
>>>   		.isdirect = LIBXFS_DIRECT,
>>>   		.isreadonly = LIBXFS_EXCLUSIVELY,
>>>   	};
>>> -	struct xfs_mount	mbuf = {};
>>> +	struct xfs_mount	mbuf = {0};
>>>   	struct xfs_mount	*mp = &mbuf;
>>>   	struct xfs_sb		*sbp = &mp->m_sb;
>>> -	struct fs_topology	ft = {};
>>> +	struct fs_topology	ft = {0};
>>>   	struct cli_params	cli = {
>>>   		.xi = &xi,
>>>   		.loginternal = 1,
>>>   	};
>>> -	struct mkfs_params	cfg = {};
>>> +	struct mkfs_params	cfg = {0};
>>>   
>>>   	/* build time defaults */
>>>   	struct mkfs_default_params	dft = {
>>> @@ -4008,7 +4008,6 @@ main(
>>>   	cfg.rtblocks = calc_dev_size(cli.rtsize, &cfg, &ropts, R_SIZE, "rt");
>>>   
>>>   	validate_rtextsize(&cfg, &cli, &ft);
>>> -	calc_stripe_factors(&cfg, &cli, &ft);
>>>   
>>>   	/*
>>>   	 * Open and validate the device configurations
>>> @@ -4018,6 +4017,7 @@ main(
>>>   	validate_datadev(&cfg, &cli);
>>>   	validate_logdev(&cfg, &cli, &logfile);
>>>   	validate_rtdev(&cfg, &cli, &rtfile);
>>> +	calc_stripe_factors(&cfg, &cli, &ft);
>>>   
>>>   	/*
>>>   	 * At this point when know exactly what size all the devices are,
>>>
>>
