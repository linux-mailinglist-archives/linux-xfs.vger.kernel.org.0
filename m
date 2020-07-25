Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5A5022D30E
	for <lists+linux-xfs@lfdr.de>; Sat, 25 Jul 2020 02:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgGYAIT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 24 Jul 2020 20:08:19 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52934 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726625AbgGYAIT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Jul 2020 20:08:19 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06ONpdAi136944
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 00:08:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=/PgMbUoXnZCIsPaAaSHl4ZnM10ReQYqRVAb4LHdNwxY=;
 b=VZkbWBjTX2poOWXSyBe1JTxPCtbJPa7cguZQhaqygRwOqsIcKgeVih15xJ7mArLXnoo7
 I/KHm4v/BiDkd7PYF7YsQdxy6HEx7rDjW54Hqac2r43r+oB1HE2OboNjcEsSmpU6jIWh
 cytUCG1ffCZ+Ij/7YLY132F4eCk36d3XijeGzd0ys31wmzWD/FhBCdTnQ8JqNpTWM5VX
 tCaM37Al5c1u5U8SMfHPR53oHgPCE2faZ4PLdET+sJvGerkFCFkaK9QH1JK7ljhCShmp
 P7S/xfs8DWVBGGu/ho+3FehgGI3N9ljfaeSmxqUkQ5p6SEuwri8Z1LgwOAkU+l2m1+C9 Sg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 32bs1n1mam-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 00:08:17 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06P02sPC187997
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 00:08:17 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 32g9uu05w7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 00:08:16 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06P08Gba019383
        for <linux-xfs@vger.kernel.org>; Sat, 25 Jul 2020 00:08:16 GMT
Received: from [192.168.1.226] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sat, 25 Jul 2020 00:08:15 +0000
Subject: Re: [PATCH v11 10/25] xfs: Refactor xfs_attr_rmtval_remove
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200721001606.10781-1-allison.henderson@oracle.com>
 <20200721001606.10781-11-allison.henderson@oracle.com>
 <20200721233118.GH3151642@magnolia> <20200722002446.GM3151642@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <a9c10934-c918-079e-69c0-1912ff6026ec@oracle.com>
Date:   Fri, 24 Jul 2020 17:08:13 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200722002446.GM3151642@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 adultscore=0 suspectscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007240164
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9692 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 malwarescore=0 clxscore=1015
 spamscore=0 mlxscore=0 impostorscore=0 phishscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007240164
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 7/21/20 5:24 PM, Darrick J. Wong wrote:
> On Tue, Jul 21, 2020 at 04:31:18PM -0700, Darrick J. Wong wrote:
>> On Mon, Jul 20, 2020 at 05:15:51PM -0700, Allison Collins wrote:
>>> Refactor xfs_attr_rmtval_remove to add helper function
>>> __xfs_attr_rmtval_remove. We will use this later when we introduce
>>> delayed attributes.  This function will eventually replace
>>> xfs_attr_rmtval_remove
>>>
>>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>>> Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
>>> Reviewed-by: Brian Foster <bfoster@redhat.com>
>>> ---
>>>   fs/xfs/libxfs/xfs_attr_remote.c | 46 ++++++++++++++++++++++++++++++++---------
>>>   fs/xfs/libxfs/xfs_attr_remote.h |  1 +
>>>   2 files changed, 37 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
>>> index 4d51969..9b4c173 100644
>>> --- a/fs/xfs/libxfs/xfs_attr_remote.c
>>> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
>>> @@ -681,7 +681,7 @@ xfs_attr_rmtval_remove(
>>>   	xfs_dablk_t		lblkno;
>>>   	int			blkcnt;
>>>   	int			error = 0;
>>> -	int			done = 0;
>>> +	int			retval = 0;
>>>   
>>>   	trace_xfs_attr_rmtval_remove(args);
>>>   
>>> @@ -693,14 +693,10 @@ xfs_attr_rmtval_remove(
>>>   	 */
>>>   	lblkno = args->rmtblkno;
>>>   	blkcnt = args->rmtblkcnt;
>>
>> Er... I think these local variables can go away here, right?
>>
>> --D
>>
>>> -	while (!done) {
>>> -		error = xfs_bunmapi(args->trans, args->dp, lblkno, blkcnt,
>>> -				    XFS_BMAPI_ATTRFORK, 1, &done);
>>> -		if (error)
>>> -			return error;
>>> -		error = xfs_defer_finish(&args->trans);
>>> -		if (error)
>>> -			return error;
>>> +	do {
>>> +		retval = __xfs_attr_rmtval_remove(args);
>>> +		if (retval && retval != EAGAIN)
> 
> Also this has to be -EAGAIN.  Amazingly, nothing in fstests blew up on
> this.
Ok, will fix! If you are running with the full set, it wouldnt trip over 
anything because this whole function is removed by the end of the series.

Allison

> 
> --D
> 
>>> +			return retval;
>>>   
>>>   		/*
>>>   		 * Close out trans and start the next one in the chain.
>>> @@ -708,6 +704,36 @@ xfs_attr_rmtval_remove(
>>>   		error = xfs_trans_roll_inode(&args->trans, args->dp);
>>>   		if (error)
>>>   			return error;
>>> -	}
>>> +	} while (retval == -EAGAIN);
>>> +
>>>   	return 0;
>>>   }
>>> +
>>> +/*
>>> + * Remove the value associated with an attribute by deleting the out-of-line
>>> + * buffer that it is stored on. Returns EAGAIN for the caller to refresh the
>>> + * transaction and re-call the function
>>> + */
>>> +int
>>> +__xfs_attr_rmtval_remove(
>>> +	struct xfs_da_args	*args)
>>> +{
>>> +	int			error, done;
>>> +
>>> +	/*
>>> +	 * Unmap value blocks for this attr.
>>> +	 */
>>> +	error = xfs_bunmapi(args->trans, args->dp, args->rmtblkno,
>>> +			    args->rmtblkcnt, XFS_BMAPI_ATTRFORK, 1, &done);
>>> +	if (error)
>>> +		return error;
>>> +
>>> +	error = xfs_defer_finish(&args->trans);
>>> +	if (error)
>>> +		return error;
>>> +
>>> +	if (!done)
>>> +		return -EAGAIN;
>>> +
>>> +	return error;
>>> +}
>>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
>>> index 3616e88..9eee615 100644
>>> --- a/fs/xfs/libxfs/xfs_attr_remote.h
>>> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
>>> @@ -14,4 +14,5 @@ int xfs_attr_rmtval_remove(struct xfs_da_args *args);
>>>   int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
>>>   		xfs_buf_flags_t incore_flags);
>>>   int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
>>> +int __xfs_attr_rmtval_remove(struct xfs_da_args *args);
>>>   #endif /* __XFS_ATTR_REMOTE_H__ */
>>> -- 
>>> 2.7.4
>>>
