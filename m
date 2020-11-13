Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44AC52B219E
	for <lists+linux-xfs@lfdr.de>; Fri, 13 Nov 2020 18:12:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726057AbgKMRMC (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 13 Nov 2020 12:12:02 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:40672 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726003AbgKMRMB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Nov 2020 12:12:01 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ADH3ZSb124469;
        Fri, 13 Nov 2020 17:12:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=kbCEjs1duXiaeBj9rhIxHKZm+HbmA0j4LwzyJY0Du04=;
 b=yB9UT1c5uJEU3g6lXFCuJMt2lBJwPErth5NlPN4QgYWPfQGB7YpnplVBSQ3tw/+BF801
 uUyWIQcJ7PjXUXPk51JC3zCL2wOvWdskn4g9Mll0Hu+aYVMUGofXrkM3AMkkWPmD+VYB
 ddxFT51Me0xCT8cJ5yapJ/fTxJmMLoazzAqbb5ZOUvP2tP8Wtaewvi6FZobyU4NckWle
 lwpcUdu0BGr0++FdvkYsOI+7IDl362kVKa/unhIXswzpIBPuFoO+l22+nm2jYTsNJe3+
 5w7zctatz9JY3qXEctyKLeJ3OJpEJEH0m+InLw1s74NXIdwUELvklapcGMqU10iy/Y/c OQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 34p72f1jnn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 13 Nov 2020 17:12:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0ADH5Eta150177;
        Fri, 13 Nov 2020 17:12:11 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 34rt587b3x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Nov 2020 17:12:11 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0ADHCAKK003779;
        Fri, 13 Nov 2020 17:12:10 GMT
Received: from [192.168.1.223] (/67.1.244.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 13 Nov 2020 09:12:10 -0800
Subject: Re: [PATCH v13 03/10] xfs: Add delay ready attr set routines
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
References: <20201023063435.7510-1-allison.henderson@oracle.com>
 <20201110215702.GH9695@magnolia>
 <f386c199-3bb8-f6b7-6ef7-1e08d2b35b8a@oracle.com>
 <20322189.3UhRF6KiVz@garuda>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <0d6bd8a6-e43e-6344-5e79-3cf348f447d6@oracle.com>
Date:   Fri, 13 Nov 2020 10:12:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20322189.3UhRF6KiVz@garuda>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9804 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011130111
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9804 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=0 lowpriorityscore=0 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011130111
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 11/13/20 2:16 AM, Chandan Babu R wrote:
> On Friday 13 November 2020 7:03:13 AM IST Allison Henderson wrote:
>>
>> On 11/10/20 2:57 PM, Darrick J. Wong wrote:
>>> On Tue, Oct 27, 2020 at 07:02:55PM +0530, Chandan Babu R wrote:
>>>> On Friday 23 October 2020 12:04:28 PM IST Allison Henderson wrote:
>>>>> This patch modifies the attr set routines to be delay ready. This means
>>>>> they no longer roll or commit transactions, but instead return -EAGAIN
>>>>> to have the calling routine roll and refresh the transaction.  In this
>>>>> series, xfs_attr_set_args has become xfs_attr_set_iter, which uses a
>>>>> state machine like switch to keep track of where it was when EAGAIN was
>>>>> returned. See xfs_attr.h for a more detailed diagram of the states.
>>>>>
>>>>> Two new helper functions have been added: xfs_attr_rmtval_set_init and
>>>>> xfs_attr_rmtval_set_blk.  They provide a subset of logic similar to
>>>>> xfs_attr_rmtval_set, but they store the current block in the delay attr
>>>>> context to allow the caller to roll the transaction between allocations.
>>>>> This helps to simplify and consolidate code used by
>>>>> xfs_attr_leaf_addname and xfs_attr_node_addname. xfs_attr_set_args has
>>>>> now become a simple loop to refresh the transaction until the operation
>>>>> is completed.  Lastly, xfs_attr_rmtval_remove is no longer used, and is
>>>>> removed.
>>>>
>>>> One nit. xfs_attr_rmtval_remove()'s prototype declaration needs to be removed
>>>> from xfs_attr_remote.h.
>> Alrighty, will pull out
>>
>>>>
>>>>>
>>>>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>>>>> ---
>>>>>    fs/xfs/libxfs/xfs_attr.c        | 370 ++++++++++++++++++++++++++--------------
>>>>>    fs/xfs/libxfs/xfs_attr.h        | 126 +++++++++++++-
>>>>>    fs/xfs/libxfs/xfs_attr_remote.c |  99 +++++++----
>>>>>    fs/xfs/libxfs/xfs_attr_remote.h |   4 +
>>>>>    fs/xfs/xfs_trace.h              |   1 -
>>>>>    5 files changed, 439 insertions(+), 161 deletions(-)
>>>>>
>>>>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>>>>> index 6ca94cb..95c98d7 100644
>>>>> --- a/fs/xfs/libxfs/xfs_attr.c
>>>>> +++ b/fs/xfs/libxfs/xfs_attr.c
>>>>> @@ -44,7 +44,7 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
>>>>>     * Internal routines when attribute list is one block.
>>>>>     */
>>>>>    STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
>>>>> -STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args);
>>>>> +STATIC int xfs_attr_leaf_addname(struct xfs_delattr_context *dac);
>>>>>    STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
>>>>>    STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
>>>>>    
>>>>> @@ -52,12 +52,15 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
>>>>>     * Internal routines when attribute list is more than one block.
>>>>>     */
>>>>>    STATIC int xfs_attr_node_get(xfs_da_args_t *args);
>>>>> -STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
>>>>> +STATIC int xfs_attr_node_addname(struct xfs_delattr_context *dac);
>>>>>    STATIC int xfs_attr_node_removename_iter(struct xfs_delattr_context *dac);
>>>>>    STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>>>>>    				 struct xfs_da_state **state);
>>>>>    STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>>>>>    STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
>>>>> +STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *args, struct xfs_buf *bp);
>>>>> +STATIC int xfs_attr_set_iter(struct xfs_delattr_context *dac,
>>>>> +			     struct xfs_buf **leaf_bp);
>>>>>    
>>>>>    int
>>>>>    xfs_inode_hasattr(
>>>>> @@ -218,8 +221,11 @@ xfs_attr_is_shortform(
>>>>>    
>>>>>    /*
>>>>>     * Attempts to set an attr in shortform, or converts short form to leaf form if
>>>>> - * there is not enough room.  If the attr is set, the transaction is committed
>>>>> - * and set to NULL.
>>>>> + * there is not enough room.  This function is meant to operate as a helper
>>>>> + * routine to the delayed attribute functions.  It returns -EAGAIN to indicate
>>>>> + * that the calling function should roll the transaction, and then proceed to
>>>>> + * add the attr in leaf form.  This subroutine does not expect to be recalled
>>>>> + * again like the other delayed attr routines do.
>>>>>     */
>>>>>    STATIC int
>>>>>    xfs_attr_set_shortform(
>>>>> @@ -227,16 +233,16 @@ xfs_attr_set_shortform(
>>>>>    	struct xfs_buf		**leaf_bp)
>>>>>    {
>>>>>    	struct xfs_inode	*dp = args->dp;
>>>>> -	int			error, error2 = 0;
>>>>> +	int			error = 0;
>>>>>    
>>>>>    	/*
>>>>>    	 * Try to add the attr to the attribute list in the inode.
>>>>>    	 */
>>>>>    	error = xfs_attr_try_sf_addname(dp, args);
>>>>> +
>>>>> +	/* Should only be 0, -EEXIST or ENOSPC */
>>>>>    	if (error != -ENOSPC) {
>>>>> -		error2 = xfs_trans_commit(args->trans);
>>>>> -		args->trans = NULL;
>>>>> -		return error ? error : error2;
>>>>> +		return error;
>>>>>    	}
>>>>>    	/*
>>>>>    	 * It won't fit in the shortform, transform to a leaf block.  GROT:
>>>>> @@ -249,18 +255,10 @@ xfs_attr_set_shortform(
>>>>>    	/*
>>>>>    	 * Prevent the leaf buffer from being unlocked so that a concurrent AIL
>>>>>    	 * push cannot grab the half-baked leaf buffer and run into problems
>>>>> -	 * with the write verifier. Once we're done rolling the transaction we
>>>>> -	 * can release the hold and add the attr to the leaf.
>>>>> +	 * with the write verifier.
>>>>>    	 */
>>>>>    	xfs_trans_bhold(args->trans, *leaf_bp);
>>>>> -	error = xfs_defer_finish(&args->trans);
>>>>> -	xfs_trans_bhold_release(args->trans, *leaf_bp);
>>>>> -	if (error) {
>>>>> -		xfs_trans_brelse(args->trans, *leaf_bp);
>>>>> -		return error;
>>>>> -	}
>>>>> -
>>>>> -	return 0;
>>>>> +	return -EAGAIN;
>>>>>    }
>>>>>    
>>>>>    /*
>>>>> @@ -268,7 +266,7 @@ xfs_attr_set_shortform(
>>>>>     * also checks for a defer finish.  Transaction is finished and rolled as
>>>>>     * needed, and returns true of false if the delayed operation should continue.
>>>>>     */
>>>>> -int
>>>>> +STATIC int
>>>>>    xfs_attr_trans_roll(
>>>>>    	struct xfs_delattr_context	*dac)
>>>>>    {
>>>>> @@ -297,61 +295,130 @@ int
>>>>>    xfs_attr_set_args(
>>>>>    	struct xfs_da_args	*args)
>>>>>    {
>>>>> -	struct xfs_inode	*dp = args->dp;
>>>>> -	struct xfs_buf          *leaf_bp = NULL;
>>>>> -	int			error = 0;
>>>>> +	struct xfs_buf			*leaf_bp = NULL;
>>>>> +	int				error = 0;
>>>>> +	struct xfs_delattr_context	dac = {
>>>>> +		.da_args	= args,
>>>>> +	};
>>>>> +
>>>>> +	do {
>>>>> +		error = xfs_attr_set_iter(&dac, &leaf_bp);
>>>>> +		if (error != -EAGAIN)
>>>>> +			break;
>>>>> +
>>>>> +		error = xfs_attr_trans_roll(&dac);
>>>>> +		if (error)
>>>>> +			return error;
>>>>> +
>>>>> +		if (leaf_bp) {
>>>>> +			xfs_trans_bjoin(args->trans, leaf_bp);
>>>>> +			xfs_trans_bhold(args->trans, leaf_bp);
>>>>> +		}
>>>>
>>>> When xfs_attr_set_iter() causes a "short form" attribute list to be converted
>>>> to "leaf form", leaf_bp would point to an xfs_buf which has been added to the
>>>> transaction and also XFS_BLI_HOLD flag is set on the buffer (last statement in
>>>> xfs_attr_set_shortform()). XFS_BLI_HOLD flag makes sure that the new
>>>> transaction allocated by xfs_attr_trans_roll() would continue to have leaf_bp
>>>> in the transaction's item list. Hence I think the above calls to
>>>> xfs_trans_bjoin() and xfs_trans_bhold() are not required.
>> Sorry, I just noticed Chandans commentary for this patch.  Apologies. I
>> think we can get away with out this now, but yes this routine disappears
>> at the end of the set now.  Will clean out anyway for bisecting reasons
>> though. :-)
> 
> No problem. As an aside, I stopped reviewing the patchset after I noticed
> Brian's review comments for "[PATCH v13 02/10] xfs: Add delay ready attr
> remove routines" suggesting some more code refactoring work.
> 
No worries, thats reasonable.  It's why I only send this out in subsets 
to try and keep people sort of focused on a smaller area because stuff 
at the end of the set changes more often as a result of things moving 
around at the bottom of the set.  It doesn't make sense to channel too 
much effort into something that's still moving around so much :-)

Allison
>>
>>>
>>> I /think/ the defer ops will rejoin the buffer each time it rolls, which
>>> means that xfs_attr_trans_roll returns with the buffer already joined to
>>> the transaction?  And I think you're right that the bhold isn't needed,
>>> because holding is dictated by the lower levels (i.e. _set_iter).
>>>
>>>> Please let me know if I am missing something obvious here.
>>>
>>> The entire function goes away by the end of the series. :)
>>>
>>> --D
>>>
>>>>
>>>>
>>>>
>>>>
>>
> 
> 
