Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA228ACA5
	for <lists+linux-xfs@lfdr.de>; Tue, 13 Aug 2019 04:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbfHMCVY (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 12 Aug 2019 22:21:24 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34672 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726500AbfHMCVY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 22:21:24 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7D2J1ah029250
        for <linux-xfs@vger.kernel.org>; Tue, 13 Aug 2019 02:21:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=Fswl9IuvptJ2VCkTZ8bD5NuWDckd2QWBUK4JA3jQsig=;
 b=QavW3S/WpOrlIDTxvWyo4j9WPT3cfGAnifu7ZK2mNkktT71/a2fnWBH+Jovt/lBh+cU8
 ROxlBPXjT+JVtc605xAMSC6QlHAjKlYc0jirT/P2IjDb9TkX0w3+vuNVu305WuJUKwPR
 uwdxcQ/D2FvZ3YSawTzgSZRXQIBBCa04bgwfjXw7DI7ieKjC0oJ+bGSCzRU7luzU+2Sn
 MhlTzKakj+Lg7atjLXRQ5gIpy6sgTzQ169vG7tMi4jaHyNQMYEmNoGFYSicfu/N7yIJ+
 dxieOx1Cbb7W30swhL6vhJ2qLd9lKVCH+bFZ8ZOugnXL7vX8c0BJidceZU+EEAw/A62k CQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=Fswl9IuvptJ2VCkTZ8bD5NuWDckd2QWBUK4JA3jQsig=;
 b=kNmEyY7rvoVFxUqj83wvx04Oikf2gFBWtoBIKacuTnLePA2H6mx4YPKKrJqZRF9YXOY9
 WcIeDYY9vr1K/6eh/W2anS5i+C0EKajNhdQqgUG3981FeQSN5Z5XB5dF1dCRnNK03SwH
 R6yslLsj+tWYmODEY6FsD4RA5Prc7NkEI9Y6Fx9ippH13E5b/12RVplGvz44KNDXjWX8
 ih5aATaaswMqRV6ljI8jX7qtHwi1IGI4sQH8iQs5FPXpM8bQnl3LCHxynpZc8Pkvq437
 EsX0tNb3Pt/pRR0y7Ohero8bXGeMHficRsqTmkkC6YaLKOI5mwFPRufivsY8xOASazbL Wg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2u9nbtb5nt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 13 Aug 2019 02:21:22 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7D2HeBd085502
        for <linux-xfs@vger.kernel.org>; Tue, 13 Aug 2019 02:19:22 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2u9nregjvc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 13 Aug 2019 02:19:21 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7D2JL6G029516
        for <linux-xfs@vger.kernel.org>; Tue, 13 Aug 2019 02:19:21 GMT
Received: from [192.168.1.9] (/174.18.98.117)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 12 Aug 2019 19:19:21 -0700
Subject: Re: [PATCH v2 15/18] xfs: Add delayed attribute routines
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
References: <20190809213726.32336-1-allison.henderson@oracle.com>
 <20190809213726.32336-16-allison.henderson@oracle.com>
 <20190812172933.GI7138@magnolia>
From:   Allison Collins <allison.henderson@oracle.com>
Message-ID: <238c7754-f75f-1afa-f361-20d981b2f0e7@oracle.com>
Date:   Mon, 12 Aug 2019 19:19:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190812172933.GI7138@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908130023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908130023
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/12/19 10:29 AM, Darrick J. Wong wrote:
> On Fri, Aug 09, 2019 at 02:37:23PM -0700, Allison Collins wrote:
>> This patch adds new delayed attribute routines:
>>
>> xfs_attr_da_set_args
>> xfs_attr_da_remove_args
>> xfs_attr_da_leaf_addname
>> xfs_attr_da_node_addname
>> xfs_attr_da_node_removename
> 
> I think the "_da_" thing is shorthand for "deferred attr", right?
> 
> If so, it's way too close to the other "_da_" (which is shorthand for
> "directory/attr") for my taste.
> 
> xfs_attr_set_later()
> xfs_attr_remove_later()
> xfs_leaf_addname_later()
> xfs_node_addname_later()
> xfs_node_remove_later() ?

Sure, I'm not very particular about the names, I think the later scheme 
is fine.

> 
>> These routines are similar to their existing counter parts,
>> but they do not roll or commit transactions.  They instead
>> return -EGAIN to allow the calling function to roll the
> 
> EAGAIN...
> 
>> transaction and recall the function.  This allows the
>> attribute operations to be logged in multiple smaller
>> transactions.
>>
>> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
>> ---
>>   fs/xfs/libxfs/xfs_attr.c | 720 +++++++++++++++++++++++++++++++++++++++++++++++
>>   fs/xfs/libxfs/xfs_attr.h |   2 +
>>   2 files changed, 722 insertions(+)
>>
>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>> index ca57202..9931e50 100644
>> --- a/fs/xfs/libxfs/xfs_attr.c
>> +++ b/fs/xfs/libxfs/xfs_attr.c
>> @@ -47,6 +47,7 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
>>    */
>>   STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
>>   STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args);
>> +STATIC int xfs_attr_da_leaf_addname(xfs_da_args_t *args);
>>   STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
>>   STATIC int xfs_leaf_has_attr(xfs_da_args_t *args, struct xfs_buf **bp);
>>   
>> @@ -55,12 +56,16 @@ STATIC int xfs_leaf_has_attr(xfs_da_args_t *args, struct xfs_buf **bp);
>>    */
>>   STATIC int xfs_attr_node_get(xfs_da_args_t *args);
>>   STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
>> +STATIC int xfs_attr_da_node_addname(xfs_da_args_t *args);
>>   STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
>> +STATIC int xfs_attr_da_node_removename(xfs_da_args_t *args);
>>   STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>>   				 struct xfs_da_state **state);
>>   STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>>   STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
>>   
>> +STATIC int
>> +xfs_attr_leaf_try_add(struct xfs_da_args *args, struct xfs_buf *bp);
> 
> STATIC int xfs_attr_leaf_try_add(...)
> 
> (no newline between the return type and the function name)
Ok, will clean out

> 
>>   
>>   int
>>   xfs_attr_args_init(
> 
> <snip>
> 
>> +STATIC int
>> +xfs_attr_da_leaf_addname(
>> +	struct xfs_da_args	*args)
>> +{
>> +	int			error, forkoff, nmap;
>> +	struct xfs_buf		*bp = NULL;
>> +	struct xfs_inode	*dp = args->dp;
>> +	struct xfs_bmbt_irec	*map = &args->dc.map;
> 
> <snip>
> 
>> +	/*
>> +	 * If this is an atomic rename operation, we must "flip" the
>> +	 * incomplete flags on the "new" and "old" attribute/value pairs
>> +	 * so that one disappears and one appears atomically.  Then we
>> +	 * must remove the "old" attribute/value pair.
>> +	 */
>> +	if (args->op_flags & XFS_DA_OP_RENAME) {
>> +		/*
>> +		 * In a separate transaction, set the incomplete flag on the
>> +		 * "old" attr and clear the incomplete flag on the "new" attr.
> 
> Echoing Christoph, can this new attr implementation set the attr value
> through the log so we can get rid of the INCOMPLETE flag switcheroo
> business?  I see a lot of nearly duplicated code and if we're going to
> have to support having two paths through the attr set/remove code, we
> could at least avoid the weird warts of the old path when designing the
> new one.

Hmm, Ok, I will see what I can do. I dont know that we could completely 
remove it since the old code path will still need it but maybe we can 
get away from it in the delayed code path here.

> 
> <snip more>
> 
>> +STATIC int
>> +xfs_attr_da_node_removename(
>> +	struct xfs_da_args	*args)
>> +{
>> +	struct xfs_da_state	*state = NULL;
>> +	struct xfs_da_state_blk	*blk;
>> +	struct xfs_buf		*bp;
>> +	int			error, forkoff, retval = 0;
>> +	struct xfs_inode	*dp = args->dp;
>> +	int			done = 0;
>> +
>> +	trace_xfs_attr_node_removename(args);
>> +
>> +	if (args->dc.state == NULL) {
>> +		error = xfs_attr_node_hasname(args, &args->dc.state);
>> +		if (error != -EEXIST)
>> +			goto out;
>> +		else
>> +			error = 0;
>> +
>> +		/*
>> +		 * If there is an out-of-line value, de-allocate the blocks.
>> +		 * This is done before we remove the attribute so that we don't
>> +		 * overflow the maximum size of a transaction and/or hit a
>> +		 * deadlock.
>> +		 */
>> +		state = args->dc.state;
>> +		args->dc.blk = &state->path.blk[state->path.active - 1];
>> +		ASSERT(args->dc.blk->bp != NULL);
>> +		ASSERT(args->dc.blk->magic == XFS_ATTR_LEAF_MAGIC);
>> +	}
>> +	state = args->dc.state;
>> +	blk = args->dc.blk;
>> +
>> +	if (args->rmtblkno > 0 && !(args->dc.flags & XFS_DC_RM_LEAF_BLKS)) {
>> +		if (!xfs_attr3_leaf_flag_is_set(args)) {
>> +			/*
>> +			 * Fill in disk block numbers in the state structure
>> +			 * so that we can get the buffers back after we commit
>> +			 * several transactions in the following calls.
>> +			 */
>> +			error = xfs_attr_fillstate(state);
>> +			if (error)
>> +				goto out;
>> +
>> +			/*
>> +			 * Mark the attribute as INCOMPLETE, then bunmapi() the
>> +			 * remote value.
>> +			 */
>> +			error = xfs_attr3_leaf_setflag(args);
>> +			if (error)
>> +				goto out;
>> +
>> +			return -EAGAIN;
>> +		}
>> +
>> +		if (!(args->dc.flags & XFS_DC_RM_NODE_BLKS)) {
>> +			error = xfs_attr_rmtval_remove_value(args);
>> +			if (error)
>> +				goto out;
>> +		}
>> +
>> +		args->dc.flags |= XFS_DC_RM_NODE_BLKS;
> 
> This ought to be set in the if clause above...
Ok, will tuck that in

> 
>> +		while (!done && !error) {
>> +			error = xfs_bunmapi(args->trans, args->dp,
>> +				    args->rmtblkno, args->rmtblkcnt,
>> +				    XFS_BMAPI_ATTRFORK, 1, &done);
>> +			if (error)
>> +				return error;
>> +
>> +			if (!done)
>> +				return -EAGAIN;
>> +		}
> 
> Probably worth a comment to make it a little clearer that this is the
> bottom part of xfs_attr_rmtval_remove but open-coded for this case.
> 
> I wish this new attr path could share more code with the old one,
> though I dunno, probably you've already done that analysis and decided
> that cutting this up into ~30 tiny functions isn't worth it...?

Ok, I will work in some comments.  Yes, at one point I finally decided 
that further modularizing every little bit was starting to make things 
more complicated than not.

> 
> (Yeah, snip all the way to the end because I need to go rest my eyes for
> a bit but didn't want to delay this reply further.)
> 
> --D
> 

Yes, it is convoluted to follow.  Truth be told, I do think the set is a 
bit complex, but also good illustration of what the -EAGAIN solution 
looks like in practice.  I'm not really sure if there are better 
approaches, but I'm certainly open to ideas or optimizations!  :-)

Thanks!
Allison
