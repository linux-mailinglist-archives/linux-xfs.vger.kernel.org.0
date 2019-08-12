Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D2688A750
	for <lists+linux-xfs@lfdr.de>; Mon, 12 Aug 2019 21:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbfHLThW (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 12 Aug 2019 15:37:22 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:40112 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726808AbfHLThW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 15:37:22 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CJEQ8K100050
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 19:37:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=95ARRxMKkhJEZyxQqdXW4gjwQBWwRZkjcUTMYgMCZek=;
 b=QxAxw3IzMNfYjerYhNaaFLHHO3SS1vxmZinU3rAAmAOy6QLhHwW3Ry3gLb/8qgtkgea1
 5u10ViUwlqVhOpvsnCQNnWZt8EtpUWlK17oHqaCe68J47wYDo9Kc+48du6d2Yl0sNXQl
 8m1Di5kPy8+2BepEemanjerk2Y+1VQ28oNdU4OlECzQ4bSH3z60muZZrlInZpYpb8TQU
 KWjBMnRBNNIN3MrsRfeiCj4TXRpcFTrj5VpDlayg4L16CSYoIavw5qWCjVG2n0g9qVm7
 CVlU9FlEMGiI+Yl7ma1iMrRok3wK2UKxXOmP3lJ3AvxEuTTZTTIDSdyixeB3jcjPL4L9 QQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=95ARRxMKkhJEZyxQqdXW4gjwQBWwRZkjcUTMYgMCZek=;
 b=jHKgVaLtUu0/TVjR2BdKlVLmRTeGLj0sM1lyczGZwnSvowd+/74+I9y4876/s9+iaiHH
 V9iw8hlsFNRbZzRHDfdSaSJTntv5D8eSmAYuu36WzNOH+Tv/IvJ7cGpTiVsCk5kIEL0k
 u/rYquiUafJdOksspmDqAsM3FWY6PFoO+KM+au0YY9ULTjeL7o+TzzB8ctVi8TuMZi6w
 TgBEKwJFwk3ecEr/5szXJe0zpyaT5NQLRs2ztTFGnFmS01H3HTTpI3gyymt9GRRR5JdK
 cibLmOEjmRtxPZnT08JqTZSzk2ZSLj/5mRzQbcXZNBBFCGa5vpJ8I3jIZg8x8m8fZGM0 8A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2u9nbt9sqh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 19:37:20 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CJDFue092658
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 19:37:20 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2u9m0agu3u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 19:37:20 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7CJbIJH002535
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 19:37:19 GMT
Received: from [192.168.1.9] (/174.18.98.117)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 12 Aug 2019 12:37:18 -0700
Subject: Re: [PATCH v2 08/18] xfs: Factor out xfs_attr_leaf_addname helper
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20190809213726.32336-1-allison.henderson@oracle.com>
 <20190809213726.32336-9-allison.henderson@oracle.com>
 <20190812160655.GW7138@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <30244f2e-e05d-cefe-c41b-34b61ff4914b@oracle.com>
Date:   Mon, 12 Aug 2019 12:37:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190812160655.GW7138@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908120198
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908120198
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/12/19 9:06 AM, Darrick J. Wong wrote:
> On Fri, Aug 09, 2019 at 02:37:16PM -0700, Allison Collins wrote:
>> Factor out new helper function xfs_attr_leaf_try_add.
>> Because new delayed attribute routines cannot roll
>> transactions, we carve off the parts of
>> xfs_attr_leaf_addname that we can use.  This will help
>> to reduce repetitive code later when we introduce
>> delayed attributes.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 43 +++++++++++++++++++++++++++++--------------
>>   1 file changed, 29 insertions(+), 14 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index f36c792..f9d5e28 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -635,19 +635,12 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
>>    * External routines when attribute list is one block
>>    *========================================================================*/
>>   
>> -/*
>> - * Add a name to the leaf attribute list structure
>> - *
>> - * This leaf block cannot have a "remote" value, we only call this routine
>> - * if bmap_one_block() says there is only one block (ie: no remote blks).
>> - */
>>   STATIC int
>> -xfs_attr_leaf_addname(
>> -	struct xfs_da_args	*args)
>> +xfs_attr_leaf_try_add(
>> +	struct xfs_da_args	*args,
>> +	struct xfs_buf		*bp)
>>   {
>> -	struct xfs_buf		*bp;
>> -	int			retval, error, forkoff;
>> -	struct xfs_inode	*dp = args->dp;
>> +	int			retval, error;
>>   
>>   	trace_xfs_attr_leaf_addname(args);
>>   
>> @@ -692,13 +685,35 @@ xfs_attr_leaf_addname(
>>   	retval = xfs_attr3_leaf_add(bp, args);
>>   	if (retval == -ENOSPC) {
>>   		/*
>> -		 * Promote the attribute list to the Btree format, then
>> -		 * Commit that transaction so that the node_addname() call
>> -		 * can manage its own transactions.
>> +		 * Promote the attribute list to the Btree format,
> 
> Why does the sentence end with a comma?
I think there came a point when they all started looking the same!  Lol, 
will clean up.  :-)

> 
>>   		 */
>>   		error = xfs_attr3_leaf_to_node(args);
>>   		if (error)
>>   			return error;
>> +	}
>> +	return retval;
>> +}
>> +
>> +
>> +/*
>> + * Add a name to the leaf attribute list structure
>> + *
>> + * This leaf block cannot have a "remote" value, we only call this routine
>> + * if bmap_one_block() says there is only one block (ie: no remote blks).
>> + */
>> +STATIC int
>> +xfs_attr_leaf_addname(struct xfs_da_args	*args)
>> +{
>> +	int retval, error, forkoff;
> 
> Indentation problem here.
Alrighty, will catch.  Thanks!

Allison

> 
> --D
> 
>> +	struct xfs_buf		*bp = NULL;
>> +	struct xfs_inode	*dp = args->dp;
>> +
>> +	retval = xfs_attr_leaf_try_add(args, bp);
>> +	if (retval == -ENOSPC) {
>> +		/*
>> +		 * Commit that transaction so that the node_addname() call
>> +		 * can manage its own transactions.
>> +		 */
>>   		error = xfs_defer_finish(&args->trans);
>>   		if (error)
>>   			return error;
>> -- 
>> 2.7.4
>>
