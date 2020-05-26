Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA601C4A07
	for <lists+linux-xfs@lfdr.de>; Tue,  5 May 2020 01:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728080AbgEDXGY (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 4 May 2020 19:06:24 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:55388 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728059AbgEDXGY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 19:06:24 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044N3daa164508
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 23:06:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Fuw8rCQCEt4ep8CPFX95UBCGX1FUwsdeHqZL4yaEKdA=;
 b=pOyq6v6/wfT8X/1Ksa/oJ0iw9tU3fvTWBHl96OfqblzdbQtd9y5hhkBqffzL4+vXkaiL
 x/x3f1QbAZMS3lJZzucPQydQfkxLY14q1Qo/41H7DNYymJHMsw/Yh0ImYNFgBQ0Fxp4f
 XUdc8DwXmXKkfw8cJwQ2Kj8yUc/GlOIasz3R8Dcl8LLnkoOscjS9MnymDHrXLIrSfyPh
 50cIyTHA7C2Vs596x2AMhboAfrHTeQfCcVp60H3HVYiyUQ/caW22Hd0obCZ4tFPtlzE/
 Irv19IUNiW5ZCZTARyraCJ2jHwSr2aUSv0W3XOt6lnN63AdVt1cQFv4ugOdWmISrao0n Eg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 30s09r1tf6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 May 2020 23:06:23 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044N5VlB185864
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 23:06:22 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 30sjncaa5r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 04 May 2020 23:06:22 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 044N6L33002591
        for <linux-xfs@vger.kernel.org>; Mon, 4 May 2020 23:06:21 GMT
Received: from [192.168.1.223] (/67.1.142.158)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 16:06:21 -0700
Subject: Re: [PATCH v9 19/24] xfs: Simplify xfs_attr_leaf_addname
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20200430225016.4287-1-allison.henderson@oracle.com>
 <20200430225016.4287-20-allison.henderson@oracle.com>
 <20200504190320.GF5703@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <a168a1a1-2770-a5bd-b373-1e39c67670e0@oracle.com>
Date:   Mon, 4 May 2020 16:06:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20200504190320.GF5703@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005040179
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 clxscore=1015 suspectscore=0
 priorityscore=1501 malwarescore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005040179
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 5/4/20 12:03 PM, Darrick J. Wong wrote:
> On Thu, Apr 30, 2020 at 03:50:11PM -0700, Allison Collins wrote:
>> Quick patch to unnest the rename logic in the leaf code path.  This will
>> help simplify delayed attr logic later.
> 
> This isn't really an unnesting, is it?  We're inverting the if logic and
> flipping the subordinate blocks.
> 
> "Invert the rename logic in xfs_attr_leaf_addname to simplify the
> delayed attr logic later."
Alrighty, will fix

> 
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 108 +++++++++++++++++++++++------------------------
>>   1 file changed, 53 insertions(+), 55 deletions(-)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index ab1c9fa..1810f90 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -694,73 +694,71 @@ xfs_attr_leaf_addname(
>>   			return error;
>>   	}
>>   
>> -	/*
>> -	 * If this is an atomic rename operation, we must "flip" the
>> -	 * incomplete flags on the "new" and "old" attribute/value pairs
>> -	 * so that one disappears and one appears atomically.  Then we
>> -	 * must remove the "old" attribute/value pair.
>> -	 */
>> -	if (args->op_flags & XFS_DA_OP_RENAME) {
>> +	if ((args->op_flags & XFS_DA_OP_RENAME) == 0) {
> 
> 	if (!(args->op_flags & XFS_DA_OP_RENAME)) {
Sure, will flip.  Thanks!

Allison
> 
> --D
> 
>>   		/*
>> -		 * In a separate transaction, set the incomplete flag on the
>> -		 * "old" attr and clear the incomplete flag on the "new" attr.
>> -		 */
>> -		error = xfs_attr3_leaf_flipflags(args);
>> -		if (error)
>> -			return error;
>> -		/*
>> -		 * Commit the flag value change and start the next trans in
>> -		 * series.
>> +		 * Added a "remote" value, just clear the incomplete flag.
>>   		 */
>> -		error = xfs_trans_roll_inode(&args->trans, args->dp);
>> -		if (error)
>> -			return error;
>> +		if (args->rmtblkno > 0)
>> +			error = xfs_attr3_leaf_clearflag(args);
>>   
>> -		/*
>> -		 * Dismantle the "old" attribute/value pair by removing
>> -		 * a "remote" value (if it exists).
>> -		 */
>> -		xfs_attr_restore_rmt_blk(args);
>> +		return error;
>> +	}
>>   
>> -		if (args->rmtblkno) {
>> -			error = xfs_attr_rmtval_invalidate(args);
>> -			if (error)
>> -				return error;
>> +	/*
>> +	 * If this is an atomic rename operation, we must "flip" the incomplete
>> +	 * flags on the "new" and "old" attribute/value pairs so that one
>> +	 * disappears and one appears atomically.  Then we must remove the "old"
>> +	 * attribute/value pair.
>> +	 *
>> +	 * In a separate transaction, set the incomplete flag on the "old" attr
>> +	 * and clear the incomplete flag on the "new" attr.
>> +	 */
>>   
>> -			error = xfs_attr_rmtval_remove(args);
>> -			if (error)
>> -				return error;
>> -		}
>> +	error = xfs_attr3_leaf_flipflags(args);
>> +	if (error)
>> +		return error;
>> +	/*
>> +	 * Commit the flag value change and start the next trans in series.
>> +	 */
>> +	error = xfs_trans_roll_inode(&args->trans, args->dp);
>> +	if (error)
>> +		return error;
>>   
>> -		/*
>> -		 * Read in the block containing the "old" attr, then
>> -		 * remove the "old" attr from that block (neat, huh!)
>> -		 */
>> -		error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
>> -					   &bp);
>> +	/*
>> +	 * Dismantle the "old" attribute/value pair by removing a "remote" value
>> +	 * (if it exists).
>> +	 */
>> +	xfs_attr_restore_rmt_blk(args);
>> +
>> +	if (args->rmtblkno) {
>> +		error = xfs_attr_rmtval_invalidate(args);
>>   		if (error)
>>   			return error;
>>   
>> -		xfs_attr3_leaf_remove(bp, args);
>> -
>> -		/*
>> -		 * If the result is small enough, shrink it all into the inode.
>> -		 */
>> -		if ((forkoff = xfs_attr_shortform_allfit(bp, dp))) {
>> -			error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
>> -			/* bp is gone due to xfs_da_shrink_inode */
>> -			if (error)
>> -				return error;
>> -		}
>> -
>> -	} else if (args->rmtblkno > 0) {
>> -		/*
>> -		 * Added a "remote" value, just clear the incomplete flag.
>> -		 */
>> -		error = xfs_attr3_leaf_clearflag(args);
>> +		error = xfs_attr_rmtval_remove(args);
>>   		if (error)
>>   			return error;
>>   	}
>> +
>> +	/*
>> +	 * Read in the block containing the "old" attr, then remove the "old"
>> +	 * attr from that block (neat, huh!)
>> +	 */
>> +	error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno,
>> +				   &bp);
>> +	if (error)
>> +		return error;
>> +
>> +	xfs_attr3_leaf_remove(bp, args);
>> +
>> +	/*
>> +	 * If the result is small enough, shrink it all into the inode.
>> +	 */
>> +	forkoff = xfs_attr_shortform_allfit(bp, dp);
>> +	if (forkoff)
>> +		error = xfs_attr3_leaf_to_shortform(bp, args, forkoff);
>> +		/* bp is gone due to xfs_da_shrink_inode */
>> +
>>   	return error;
>>   }
>>   
>> -- 
>> 2.7.4
>>
