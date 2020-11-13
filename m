Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3EA2B13EA
	for <lists+linux-xfs@lfdr.de>; Fri, 13 Nov 2020 02:38:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725965AbgKMBic (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 12 Nov 2020 20:38:32 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:51498 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726015AbgKMBib (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Nov 2020 20:38:31 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AD1XwlN036745
        for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2020 01:38:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=IVNNutPRwtmBDTuIcPqCIDP2+J3ZMKM9JyNKpRhmH8U=;
 b=QcryqIyJMmQmWJ/7N6gksvkEzOFmGYTZCxvzJMQ28AMVYSZwgrsT7R4xgH1LtLHiD8hO
 zbYtSc0PKACrF2YHmC2ERk9BIaE7doTPrFsE2rpdTo3HbdEgt/7FPLOUpxwtxKCtniBW
 k85qKDmG8S1mBlJpw2yLCqHabTSisOgTMV0hdZ4eJ2vJTraKXEDLxDHn+gvP/m/YSREg
 8hEzIWCo+7VfCeRPegTf73abl/dRqJ9DwUDrDrewBDMM547S7np8eWTCn5JZqrz3OSMF
 MKxwuEE/P3sf3UOONc8CgvLHBJl640Bvj8Hiz/4SF7dIZ3QB9pvpBRJEpKaiBEO6CyU2 SA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 34nkhm8d5r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2020 01:38:30 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AD1UK8n041447
        for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2020 01:38:29 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 34rtksrg41-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2020 01:38:29 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AD1cSlQ016648
        for <linux-xfs@vger.kernel.org>; Fri, 13 Nov 2020 01:38:28 GMT
Received: from [192.168.1.223] (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 12 Nov 2020 17:38:28 -0800
Subject: Re: [PATCH v13 01/10] xfs: Add helper xfs_attr_node_remove_step
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20201023063435.7510-1-allison.henderson@oracle.com>
 <20201023063435.7510-2-allison.henderson@oracle.com>
 <20201110231230.GJ9695@magnolia>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <547121ec-7187-6d63-9f95-c96c158f8f4c@oracle.com>
Date:   Thu, 12 Nov 2020 18:38:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201110231230.GJ9695@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9803 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 suspectscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011130006
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9803 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 mlxscore=0 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 spamscore=0
 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011130006
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 11/10/20 4:12 PM, Darrick J. Wong wrote:
> On Thu, Oct 22, 2020 at 11:34:26PM -0700, Allison Henderson wrote:
>> From: Allison Collins <allison.henderson@oracle.com>
>>
>> This patch adds a new helper function xfs_attr_node_remove_step.  This
>> will help simplify and modularize the calling function
>> xfs_attr_node_remove.
>>
>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> 
> Looks fine to me, modulo Brian and Chandan's suggestions;
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Ok, thank you!

Allison
> 
> --D
> 
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 46 ++++++++++++++++++++++++++++++++++------------
>>   1 file changed, 34 insertions(+), 12 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index fd8e641..f4d39bf 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -1228,19 +1228,14 @@ xfs_attr_node_remove_rmt(
>>    * the root node (a special case of an intermediate node).
>>    */
>>   STATIC int
>> -xfs_attr_node_removename(
>> -	struct xfs_da_args	*args)
>> +xfs_attr_node_remove_step(
>> +	struct xfs_da_args	*args,
>> +	struct xfs_da_state	*state)
>>   {
>> -	struct xfs_da_state	*state;
>>   	struct xfs_da_state_blk	*blk;
>>   	int			retval, error;
>>   	struct xfs_inode	*dp = args->dp;
>>   
>> -	trace_xfs_attr_node_removename(args);
>> -
>> -	error = xfs_attr_node_removename_setup(args, &state);
>> -	if (error)
>> -		goto out;
>>   
>>   	/*
>>   	 * If there is an out-of-line value, de-allocate the blocks.
>> @@ -1250,7 +1245,7 @@ xfs_attr_node_removename(
>>   	if (args->rmtblkno > 0) {
>>   		error = xfs_attr_node_remove_rmt(args, state);
>>   		if (error)
>> -			goto out;
>> +			return error;
>>   	}
>>   
>>   	/*
>> @@ -1267,18 +1262,45 @@ xfs_attr_node_removename(
>>   	if (retval && (state->path.active > 1)) {
>>   		error = xfs_da3_join(state);
>>   		if (error)
>> -			goto out;
>> +			return error;
>>   		error = xfs_defer_finish(&args->trans);
>>   		if (error)
>> -			goto out;
>> +			return error;
>>   		/*
>>   		 * Commit the Btree join operation and start a new trans.
>>   		 */
>>   		error = xfs_trans_roll_inode(&args->trans, dp);
>>   		if (error)
>> -			goto out;
>> +			return error;
>>   	}
>>   
>> +	return error;
>> +}
>> +
>> +/*
>> + * Remove a name from a B-tree attribute list.
>> + *
>> + * This routine will find the blocks of the name to remove, remove them and
>> + * shirnk the tree if needed.
>> + */
>> +STATIC int
>> +xfs_attr_node_removename(
>> +	struct xfs_da_args	*args)
>> +{
>> +	struct xfs_da_state	*state;
>> +	int			error;
>> +	struct xfs_inode	*dp = args->dp;
>> +
>> +	trace_xfs_attr_node_removename(args);
>> +
>> +	error = xfs_attr_node_removename_setup(args, &state);
>> +	if (error)
>> +		goto out;
>> +
>> +	error = xfs_attr_node_remove_step(args, state);
>> +	if (error)
>> +		goto out;
>> +
>>   	/*
>>   	 * If the result is small enough, push it all into the inode.
>>   	 */
>> -- 
>> 2.7.4
>>
