Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D088144ABD
	for <lists+linux-xfs@lfdr.de>; Wed, 22 Jan 2020 05:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727141AbgAVERP (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 21 Jan 2020 23:17:15 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:37038 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbgAVERP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jan 2020 23:17:15 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00M4DKrZ032446
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2020 04:17:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=jNwOAw9/vdGbN33YHMniypOyPek4ZBdvJ3UIJPmRBEw=;
 b=hcrr5ly4mMFlZ9Jg/1FU4A8ZIyYP+TUddZgbDpzqXBavZRXdhcJjvtxHiane1skgVlui
 KgKrmH8RGjscRe4fqzMXndJLLWCWxedHXCt+tTeOSC7jKpopCn+y+QUj0SoCoHIB6Cov
 UDCxk9xSUbHnZZ2teZgQUp8FIEjs4kElemcRNSj2j0Zt6k0xH08l50OwNapGGmCOFDsW
 5/Ff1QNwKL1s1HwHlsdFELa7AjFsuPuREEL5LvCDZzGqSOM0Y2RQzhXphRU4kc3t8cEu
 R5yUjb6geVfyRksw2/7sM8VZ5zbrAVaXgjFUmwVTbeLtZ4lWuDNdYOkVTn2/B9LjYp9G cw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2xktnr91k1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2020 04:17:13 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00M4E86N057075
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2020 04:17:12 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2xnpfqcdxr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2020 04:17:12 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00M4HBYu019078
        for <linux-xfs@vger.kernel.org>; Wed, 22 Jan 2020 04:17:11 GMT
Received: from [192.168.1.223] (/67.1.3.112)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jan 2020 20:17:11 -0800
Subject: Re: [PATCH v6 07/16] xfs: Refactor xfs_attr_try_sf_addname
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200118225035.19503-1-allison.henderson@oracle.com>
 <20200118225035.19503-8-allison.henderson@oracle.com>
 <20200121230756.GJ8247@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <2d0a86a8-c1bb-d719-7ea9-c82d6be286a6@oracle.com>
Date:   Tue, 21 Jan 2020 21:17:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200121230756.GJ8247@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001220035
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9507 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001220035
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 1/21/20 4:07 PM, Darrick J. Wong wrote:
> On Sat, Jan 18, 2020 at 03:50:26PM -0700, Allison Collins wrote:
>> To help pre-simplify xfs_attr_set_args, we need to hoist transacation
>> handling up, while modularizing the adjacent code down into helpers. In
>> this patch, hoist the commit in xfs_attr_try_sf_addname up into the
>> calling function, and also pull the attr list creation down.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 30 +++++++++++++++---------------
>>   1 file changed, 15 insertions(+), 15 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index 9ed7e94..c15361a 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -227,8 +227,13 @@ xfs_attr_try_sf_addname(
>>   	struct xfs_da_args	*args)
>>   {
>>   
>> -	struct xfs_mount	*mp = dp->i_mount;
>> -	int			error, error2;
>> +	int			error;
>> +
>> +	/*
>> +	 * Build initial attribute list (if required).
>> +	 */
>> +	if (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS)
>> +		xfs_attr_shortform_create(args);
>>   
>>   	error = xfs_attr_shortform_addname(args);
>>   	if (error == -ENOSPC)
>> @@ -241,12 +246,10 @@ xfs_attr_try_sf_addname(
>>   	if (!error && (args->name.type & ATTR_KERNOTIME) == 0)
>>   		xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
>>   
>> -	if (mp->m_flags & XFS_MOUNT_WSYNC)
>> +	if (dp->i_mount->m_flags & XFS_MOUNT_WSYNC)
>>   		xfs_trans_set_sync(args->trans);
>>   
>> -	error2 = xfs_trans_commit(args->trans);
>> -	args->trans = NULL;
>> -	return error ? error : error2;
>> +	return error;
>>   }
>>   
>>   /*
>> @@ -258,7 +261,7 @@ xfs_attr_set_args(
>>   {
>>   	struct xfs_inode	*dp = args->dp;
>>   	struct xfs_buf          *leaf_bp = NULL;
>> -	int			error;
>> +	int			error, error2 = 0;
>>   
>>   	/*
>>   	 * If the attribute list is non-existent or a shortform list,
>> @@ -269,17 +272,14 @@ xfs_attr_set_args(
>>   	     dp->i_d.di_anextents == 0)) {
>>   
>>   		/*
>> -		 * Build initial attribute list (if required).
>> -		 */
>> -		if (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS)
>> -			xfs_attr_shortform_create(args);
>> -
>> -		/*
>>   		 * Try to add the attr to the attribute list in the inode.
>>   		 */
>>   		error = xfs_attr_try_sf_addname(dp, args);
>> -		if (error != -ENOSPC)
>> -			return error;
>> +		if (error != -ENOSPC) {
>> +			error2 = xfs_trans_commit(args->trans);
> 
> /me wonders if there's really a point in committing the transaction for
> things like EEXIST and ENOMEM, but I guess this is a straight
> conversion and the current code really does this...
> 
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> --D

Alrighty, thanks for the review!

Allison

> 
>> +			args->trans = NULL;
>> +			return error ? error : error2;
>> +		}
>>   
>>   		/*
>>   		 * It won't fit in the shortform, transform to a leaf block.
>> -- 
>> 2.7.4
>>
