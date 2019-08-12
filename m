Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF3CF8A712
	for <lists+linux-xfs@lfdr.de>; Mon, 12 Aug 2019 21:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbfHLT3V (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 12 Aug 2019 15:29:21 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43530 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726681AbfHLT3V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 15:29:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CJE8lk113015
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 19:29:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=RECLVx+nH4vr1Y9CYBwjZLF8eYsk8s99fnKHCMwjQn8=;
 b=Mdyfb6z2HDEnL5njLw+hTtBava/GtJn7l63cE8C4+soZkcKLN524jzoPXkSG/s+rqR01
 HFoxzoZj/4xjLFNwtfwGvos8c6hckyqWkPWpQZE+dLgH/Og01fytvCjZFdEgpGGhjBzO
 VU1CN1gWcTUqDJgl67Czs82s5uyQC3MIeYNDHzuq+Ttw7sodmftAn34kniWXHoNoCKII
 3fa7fUEtPvXjXsdqgu8VDRUJb83fDJIjHIbtMYYwX0pxdhNLk48BlJ5ZlJIB8OWINbQg
 kyjZ2JQGkyjEOuU6Fj+Q+p3hpSebKZejgMM97uHbsLBef+aI7vAucE3G7VigsN6ZlKD1 Ow== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=RECLVx+nH4vr1Y9CYBwjZLF8eYsk8s99fnKHCMwjQn8=;
 b=y90LsPbc58O2B83VbyUOtevdOjMyswwNzsToCli4UR5T3X27o7BLGGxb7lb0/C78Odj0
 CygVJc2Tvveve/3ZgzR430X6anhuxONFt/tgLShCd5yzbHb0mB443FunLzoPFe+k+9IL
 FPzO90th0WtkMFFzCco1OBF0vrCsS9v3U2fUcr0x9A7ORws8IWCOeb4KnFaGM6EEJTd4
 tQRDatuGE3QQ8oPSbl//FJJF+1573vdRgf+Sk9ynttjyQOiyq9JmqGx13BOjblp0nM+g
 L7Uka6YbLfJHjvJVfeX8pCEFZwszoHStUWAErIYF5kfE7TSUyuf7b0d/cCUE0n3jrj8Q fw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2u9pjq9n5b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 19:29:19 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CJDEJS092612
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 19:29:19 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2u9m0agktq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 19:29:18 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7CJTHuS030111
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 19:29:18 GMT
Received: from [192.168.1.9] (/174.18.98.117)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 12 Aug 2019 12:29:17 -0700
From:   Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH v2 06/18] xfs: Factor out new helper functions
 xfs_attr_rmtval_set
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20190809213726.32336-1-allison.henderson@oracle.com>
 <20190809213726.32336-7-allison.henderson@oracle.com>
 <20190812160156.GU7138@magnolia>
Message-ID: <7959fdf2-f927-bb19-533f-fe9e98926959@oracle.com>
Date:   Mon, 12 Aug 2019 12:29:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190812160156.GU7138@magnolia>
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

On 8/12/19 9:01 AM, Darrick J. Wong wrote:
> On Fri, Aug 09, 2019 at 02:37:14PM -0700, Allison Collins wrote:
>> Break xfs_attr_rmtval_set into two helper functions
>> xfs_attr_rmt_find_hole and xfs_attr_rmtval_set_value.
>> xfs_attr_rmtval_set rolls the transaction between the
>> helpers, but delayed operations cannot.  We will use
>> the helpers later when constructing new delayed
>> attribute routines.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr_remote.c | 73 +++++++++++++++++++++++++++++++----------
>>   fs/xfs/libxfs/xfs_attr_remote.h |  4 ++-
>>   2 files changed, 58 insertions(+), 19 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
>> index 4eb30d3..c421412 100644
>> --- a/fs/xfs/libxfs/xfs_attr_remote.c
>> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
>> @@ -21,6 +21,7 @@
>>   #include "xfs_attr.h"
>>   #include "xfs_trace.h"
>>   #include "xfs_error.h"
>> +#include "xfs_attr_remote.h"
>>   
>>   #define ATTR_RMTVALUE_MAPSIZE	1	/* # of map entries at once */
>>   
>> @@ -430,34 +431,18 @@ xfs_attr_rmtval_set(
>>   	struct xfs_da_args	*args)
>>   {
>>   	struct xfs_inode	*dp = args->dp;
>> -	struct xfs_mount	*mp = dp->i_mount;
>>   	struct xfs_bmbt_irec	map;
>>   	xfs_dablk_t		lblkno;
>>   	xfs_fileoff_t		lfileoff = 0;
>> -	uint8_t			*src = args->value;
>>   	int			blkcnt;
>> -	int			valuelen;
>>   	int			nmap;
>>   	int			error;
>> -	int			offset = 0;
>>   
>> -	trace_xfs_attr_rmtval_set(args);
>> -
>> -	/*
>> -	 * Find a "hole" in the attribute address space large enough for
>> -	 * us to drop the new attribute's value into. Because CRC enable
>> -	 * attributes have headers, we can't just do a straight byte to FSB
>> -	 * conversion and have to take the header space into account.
>> -	 */
>> -	blkcnt = xfs_attr3_rmt_blocks(mp, args->rmtvaluelen);
>> -	error = xfs_bmap_first_unused(args->trans, args->dp, blkcnt, &lfileoff,
>> -						   XFS_ATTR_FORK);
>> +	error = xfs_attr_rmt_find_hole(args, &blkcnt, &lfileoff);
>>   	if (error)
>>   		return error;
>>   
>> -	args->rmtblkno = lblkno = (xfs_dablk_t)lfileoff;
>> -	args->rmtblkcnt = blkcnt;
>> -
>> +	lblkno = (xfs_dablk_t)lfileoff;
>>   	/*
>>   	 * Roll through the "value", allocating blocks on disk as required.
>>   	 */
>> @@ -498,6 +483,58 @@ xfs_attr_rmtval_set(
>>   			return error;
>>   	}
>>   
>> +	error = xfs_attr_rmtval_set_value(args);
>> +	return error;
>> +}
>> +
>> +
>> +
> 
> Only need one blank line between functions.
Ok, will trim out

> 
>> +int
>> +xfs_attr_rmt_find_hole(
>> +	struct xfs_da_args	*args,
>> +	int			*blkcnt,
>> +	xfs_fileoff_t		*lfileoff)
>> +{
>> +	struct xfs_inode        *dp = args->dp;
>> +	struct xfs_mount	*mp = dp->i_mount;
>> +	int			error;
>> +
>> +	trace_xfs_attr_rmtval_set(args);
> 
> Shouldn't this be in the xfs_attr_rmtval_set_value function?
> We're not actually setting anything here, we're just looking for holes.
Yes, that would probably make more sense there.  :-)

> 
>> +
>> +	/*
>> +	 * Find a "hole" in the attribute address space large enough for
>> +	 * us to drop the new attribute's value into. Because CRC enable
> 
> This first sentence would make a lovely comment above this function
> telling us what it does.
Ok, that sounds good, I will move that up

> 
>> +	 * attributes have headers, we can't just do a straight byte to FSB
>> +	 * conversion and have to take the header space into account.
>> +	 */
>> +	*blkcnt = xfs_attr3_rmt_blocks(mp, args->rmtvaluelen);
> 
> Can the callers be refactored to use args->rmtblkcnt to eliminate the
> @blkcnt parameter?

Sure, I think that would be ok.  I'll see if I can clean that out.
Thanks!

Allison

> 
> --D
> 
>> +	error = xfs_bmap_first_unused(args->trans, args->dp, *blkcnt, lfileoff,
>> +						   XFS_ATTR_FORK);
>> +	if (error)
>> +		return error;
>> +
>> +	args->rmtblkno = (xfs_dablk_t)*lfileoff;
>> +	args->rmtblkcnt = *blkcnt;
>> +
>> +	return 0;
>> +}
>> +
>> +int
>> +xfs_attr_rmtval_set_value(
>> +	struct xfs_da_args	*args)
>> +{
>> +	struct xfs_inode	*dp = args->dp;
>> +	struct xfs_mount	*mp = dp->i_mount;
>> +	struct xfs_bmbt_irec	map;
>> +	xfs_dablk_t		lblkno;
>> +	uint8_t			*src = args->value;
>> +	int			blkcnt;
>> +	int			valuelen;
>> +	int			nmap;
>> +	int			error;
>> +	int			offset = 0;
>> +
>> +
>>   	/*
>>   	 * Roll through the "value", copying the attribute value to the
>>   	 * already-allocated blocks.  Blocks are written synchronously
>> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
>> index 9d20b66..2a73cd9 100644
>> --- a/fs/xfs/libxfs/xfs_attr_remote.h
>> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
>> @@ -11,5 +11,7 @@ int xfs_attr3_rmt_blocks(struct xfs_mount *mp, int attrlen);
>>   int xfs_attr_rmtval_get(struct xfs_da_args *args);
>>   int xfs_attr_rmtval_set(struct xfs_da_args *args);
>>   int xfs_attr_rmtval_remove(struct xfs_da_args *args);
>> -
>> +int xfs_attr_rmtval_set_value(struct xfs_da_args *args);
>> +int xfs_attr_rmt_find_hole(struct xfs_da_args *args, int *blkcnt,
>> +			   xfs_fileoff_t *lfileoff);
>>   #endif /* __XFS_ATTR_REMOTE_H__ */
>> -- 
>> 2.7.4
>>
