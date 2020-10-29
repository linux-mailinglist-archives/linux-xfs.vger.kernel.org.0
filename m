Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E81729F433
	for <lists+linux-xfs@lfdr.de>; Thu, 29 Oct 2020 19:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725783AbgJ2SkH (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 29 Oct 2020 14:40:07 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:59426 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgJ2SkH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 14:40:07 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TIUg8r058446;
        Thu, 29 Oct 2020 18:40:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=yi4CMoFBRLFiGL7A88lgSDMKod2kfXDzDb+xD2ig75E=;
 b=s1FXeNRMD0oXn4tyD8R+IcLIUUByoq8aoJhDZOqJxdOfHgFvv2nNo6glTeNeYMkokbl/
 g8GR2/WYrhnjve3DzGFhQOvZJHmx/oSvalmY/1Xcw1UiEnpDTai5+We6ufo3zOYEeg5y
 LHjAgr587WkJ7QFe6qBWXoQhCGGExVK5rkuoxedUrcu3YZ0PZuBg289XI16LsVJ2Nq8f
 4s3wdNg+U/hTTO1S8WYTM/VQMy5Hgk/JvsWw3zawcqNK+42dyUcnjasKyv2gpvFzlmCC
 FJqzZ0Qgkr1TFshbVOlAEF0KdbEisrswDoiPiSPyoO0x6MRtk1xmtxCnZIR8Q7tBHScf Pg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 34dgm4c1sc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 29 Oct 2020 18:40:05 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TIUXBK104338;
        Thu, 29 Oct 2020 18:38:04 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 34cwuq3se9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Oct 2020 18:38:04 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09TIc4lc016018;
        Thu, 29 Oct 2020 18:38:04 GMT
Received: from [192.168.1.226] (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Oct 2020 11:38:03 -0700
Subject: Re: [PATCH 2/5] xfs: remove unnecessary parameter from
 scrub_scan_estimate_blocks
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
References: <160375511371.879169.3659553317719857738.stgit@magnolia>
 <160375512596.879169.13683347692314634844.stgit@magnolia>
 <0b7fc968-8820-15c0-b84b-d430fddec3df@oracle.com>
 <20201027153350.GC853509@magnolia> <20201029183308.GW1061252@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <e587d982-d5e0-6122-c7e6-b54ff78c6f23@oracle.com>
Date:   Thu, 29 Oct 2020 11:38:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201029183308.GW1061252@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=2
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290128
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=2 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290128
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 10/29/20 11:33 AM, Darrick J. Wong wrote:
> On Tue, Oct 27, 2020 at 08:33:50AM -0700, Darrick J. Wong wrote:
>> On Mon, Oct 26, 2020 at 10:35:46PM -0700, Allison Henderson wrote:
>>>
>>>
>>> On 10/26/20 4:32 PM, Darrick J. Wong wrote:
>>>> From: Darrick J. Wong <darrick.wong@oracle.com>
>>>>
>>>> The only caller that cares about the file counts uses it to compute the
>>>> number of files used, so return that and save a parameter.
>>>>
>>>> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
>>>> ---
>>>>    scrub/fscounters.c |    8 +++-----
>>>>    scrub/fscounters.h |    2 +-
>>>>    scrub/phase6.c     |    7 +++----
>>>>    scrub/phase7.c     |    5 +----
>>>>    4 files changed, 8 insertions(+), 14 deletions(-)
>>>>
>>>>
>>>> diff --git a/scrub/fscounters.c b/scrub/fscounters.c
>>>> index e9901fcdf6df..9a240d49477b 100644
>>>> --- a/scrub/fscounters.c
>>>> +++ b/scrub/fscounters.c
>>>> @@ -116,7 +116,7 @@ scrub_count_all_inodes(
>>>>    }
>>>>    /*
>>>> - * Estimate the number of blocks and inodes in the filesystem.  Returns 0
>>>> + * Estimate the number of blocks and used inodes in the filesystem.  Returns 0
>>>>     * or a positive error number.
>>>>     */
>>>>    int
>>>> @@ -126,8 +126,7 @@ scrub_scan_estimate_blocks(
>>>>    	unsigned long long		*d_bfree,
>>>>    	unsigned long long		*r_blocks,
>>>>    	unsigned long long		*r_bfree,
>>>> -	unsigned long long		*f_files,
>>>> -	unsigned long long		*f_free)
>>>> +	unsigned long long		*f_files_used)
>>>>    {
>>>>    	struct xfs_fsop_counts		fc;
>>>>    	int				error;
>>>> @@ -141,8 +140,7 @@ scrub_scan_estimate_blocks(
>>>>    	*d_bfree = fc.freedata;
>>>>    	*r_blocks = ctx->mnt.fsgeom.rtblocks;
>>>>    	*r_bfree = fc.freertx;
>>>> -	*f_files = fc.allocino;
>>>> -	*f_free = fc.freeino;
>>>> +	*f_files_used = fc.allocino - fc.freeino;
>>> Just a nit, I think I might have put in:
>>> 	if(f_files_used)
>>> 		*f_files_used = fc.allocino - fc.freeino;
>>>
>>> That way calling functions that don't care can just pass NULL, instead of
>>> declaring a "dontcare" variable that has no other use.  Though I suppose
>>> none of the other variables do that.
>>
>> <shrug> There's only two callers, and they both pass a pointer, so I
>> didn't bother...
> 
> ...and one of those callers is to a dontcare variable; and that's what
> you were talking about.
> 
> Er... I don't mind changing it, but I'll leave that to Eric's
> discretion.
> 
> --D
No worries, it's not a huge detail, I just thought I'd throw the 
suggestion out is all :-)

Allison

> 
>> --D
>>
>>> Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
>>> Allison
>>>>    	return 0;
>>>>    }
>>>> diff --git a/scrub/fscounters.h b/scrub/fscounters.h
>>>> index 1fae58a6b287..13bd9967f004 100644
>>>> --- a/scrub/fscounters.h
>>>> +++ b/scrub/fscounters.h
>>>> @@ -9,7 +9,7 @@
>>>>    int scrub_scan_estimate_blocks(struct scrub_ctx *ctx,
>>>>    		unsigned long long *d_blocks, unsigned long long *d_bfree,
>>>>    		unsigned long long *r_blocks, unsigned long long *r_bfree,
>>>> -		unsigned long long *f_files, unsigned long long *f_free);
>>>> +		unsigned long long *f_files_used);
>>>>    int scrub_count_all_inodes(struct scrub_ctx *ctx, uint64_t *count);
>>>>    #endif /* XFS_SCRUB_FSCOUNTERS_H_ */
>>>> diff --git a/scrub/phase6.c b/scrub/phase6.c
>>>> index 8d976732d8e1..87828b60fbed 100644
>>>> --- a/scrub/phase6.c
>>>> +++ b/scrub/phase6.c
>>>> @@ -719,12 +719,11 @@ phase6_estimate(
>>>>    	unsigned long long	d_bfree;
>>>>    	unsigned long long	r_blocks;
>>>>    	unsigned long long	r_bfree;
>>>> -	unsigned long long	f_files;
>>>> -	unsigned long long	f_free;
>>>> +	unsigned long long	dontcare;
>>>>    	int			ret;
>>>> -	ret = scrub_scan_estimate_blocks(ctx, &d_blocks, &d_bfree,
>>>> -				&r_blocks, &r_bfree, &f_files, &f_free);
>>>> +	ret = scrub_scan_estimate_blocks(ctx, &d_blocks, &d_bfree, &r_blocks,
>>>> +			&r_bfree, &dontcare);
>>>>    	if (ret) {
>>>>    		str_liberror(ctx, ret, _("estimating verify work"));
>>>>    		return ret;
>>>> diff --git a/scrub/phase7.c b/scrub/phase7.c
>>>> index 96876f7c0596..bc652ab6f44a 100644
>>>> --- a/scrub/phase7.c
>>>> +++ b/scrub/phase7.c
>>>> @@ -111,8 +111,6 @@ phase7_func(
>>>>    	unsigned long long	d_bfree;
>>>>    	unsigned long long	r_blocks;
>>>>    	unsigned long long	r_bfree;
>>>> -	unsigned long long	f_files;
>>>> -	unsigned long long	f_free;
>>>>    	bool			complain;
>>>>    	int			ip;
>>>>    	int			error;
>>>> @@ -160,7 +158,7 @@ phase7_func(
>>>>    	}
>>>>    	error = scrub_scan_estimate_blocks(ctx, &d_blocks, &d_bfree, &r_blocks,
>>>> -			&r_bfree, &f_files, &f_free);
>>>> +			&r_bfree, &used_files);
>>>>    	if (error) {
>>>>    		str_liberror(ctx, error, _("estimating verify work"));
>>>>    		return error;
>>>> @@ -177,7 +175,6 @@ phase7_func(
>>>>    	/* Report on what we found. */
>>>>    	used_data = cvt_off_fsb_to_b(&ctx->mnt, d_blocks - d_bfree);
>>>>    	used_rt = cvt_off_fsb_to_b(&ctx->mnt, r_blocks - r_bfree);
>>>> -	used_files = f_files - f_free;
>>>>    	stat_data = totalcount.dbytes;
>>>>    	stat_rt = totalcount.rbytes;
>>>>
