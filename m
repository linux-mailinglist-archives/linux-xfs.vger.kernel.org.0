Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39D0D2EB230
	for <lists+linux-xfs@lfdr.de>; Tue,  5 Jan 2021 19:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727786AbhAESLT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 5 Jan 2021 13:11:19 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:38750 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727840AbhAESLP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jan 2021 13:11:15 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 105I4jw8146300;
        Tue, 5 Jan 2021 18:10:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=PS4/kBf7JiqY2+AjZEBYRIC22iFNoWKpE4Zzz9cSmTg=;
 b=QQMuigw8YJAyGboUd1goaS1KOIPcS264RcSWQkdgTCRVsL9tMn2puRX8Bc+dCJ6lggrh
 OoE3a4ze+jKGkn+Bjvsd/remy3o1HndionYJh8b23YpUqIhMzvZye2/p1KzPyBMPJ5ID
 mUlxPhaVJOgjVs+UrlJlZuXnn67iYsy7ts/JYhRpTVQp6ozowmr2RmCDxH24UX+WYQgk
 GeVNlkD51JEzZjgRs2iKN9MyUkpGRhm520rJ76xqO6gQ5RZDHMTZO4kjmGwZWN3YE7W0
 LijVsXIbuChNhdvuL79qd/Ux8fsalZCuC+ABbYEOPZ6DI40C+n3XDj3OuXq1IpM7BarR ig== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 35tebat520-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 05 Jan 2021 18:10:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 105I4mjJ013549;
        Tue, 5 Jan 2021 18:10:29 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 35v1f8wapr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Jan 2021 18:10:28 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 105IASWm002524;
        Tue, 5 Jan 2021 18:10:28 GMT
Received: from [192.168.1.226] (/67.1.214.41)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 05 Jan 2021 10:10:28 -0800
Subject: Re: [PATCH v14 04/15] xfs: Add delay ready attr remove routines
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
References: <20201218072917.16805-1-allison.henderson@oracle.com>
 <20201218072917.16805-5-allison.henderson@oracle.com>
 <20201222171148.GC2808393@bfoster> <20201222172020.GD2808393@bfoster>
 <20201222184451.GE2808393@bfoster>
 <4d3a8199-4d8f-2691-6ad0-1f7d0aa9500c@oracle.com>
 <20201223141606.GA2911764@bfoster>
 <e697522d-fd26-d85f-7ed2-e496fe5a3976@oracle.com>
 <20210104175219.GC254939@bfoster>
From:   Allison Henderson <allison.henderson@oracle.com>
Message-ID: <160069a3-3ca7-9832-96cd-4edfbadab05c@oracle.com>
Date:   Tue, 5 Jan 2021 11:10:27 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210104175219.GC254939@bfoster>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 spamscore=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101050106
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9855 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 priorityscore=1501 spamscore=0 mlxscore=0 clxscore=1015 bulkscore=0
 lowpriorityscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101050106
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org



On 1/4/21 10:52 AM, Brian Foster wrote:
> On Thu, Dec 24, 2020 at 01:23:24AM -0700, Allison Henderson wrote:
>>
>>
>> On 12/23/20 7:16 AM, Brian Foster wrote:
>>> On Tue, Dec 22, 2020 at 10:20:16PM -0700, Allison Henderson wrote:
>>>>
>>>>
>>>> On 12/22/20 11:44 AM, Brian Foster wrote:
>>>>> On Tue, Dec 22, 2020 at 12:20:20PM -0500, Brian Foster wrote:
>>>>>> On Tue, Dec 22, 2020 at 12:11:48PM -0500, Brian Foster wrote:
>>>>>>> On Fri, Dec 18, 2020 at 12:29:06AM -0700, Allison Henderson wrote:
>>>>>>>> This patch modifies the attr remove routines to be delay ready. This
>>>>>>>> means they no longer roll or commit transactions, but instead return
>>>>>>>> -EAGAIN to have the calling routine roll and refresh the transaction. In
>>>>>>>> this series, xfs_attr_remove_args has become xfs_attr_remove_iter, which
>>>>>>>> uses a sort of state machine like switch to keep track of where it was
>>>>>>>> when EAGAIN was returned. xfs_attr_node_removename has also been
>>>>>>>> modified to use the switch, and a new version of xfs_attr_remove_args
>>>>>>>> consists of a simple loop to refresh the transaction until the operation
>>>>>>>> is completed. A new XFS_DAC_DEFER_FINISH flag is used to finish the
>>>>>>>> transaction where ever the existing code used to.
>>>>>>>>
>>>>>>>> Calls to xfs_attr_rmtval_remove are replaced with the delay ready
>>>>>>>> version __xfs_attr_rmtval_remove. We will rename
>>>>>>>> __xfs_attr_rmtval_remove back to xfs_attr_rmtval_remove when we are
>>>>>>>> done.
>>>>>>>>
>>>>>>>> xfs_attr_rmtval_remove itself is still in use by the set routines (used
>>>>>>>> during a rename).  For reasons of preserving existing function, we
>>>>>>>> modify xfs_attr_rmtval_remove to call xfs_defer_finish when the flag is
>>>>>>>> set.  Similar to how xfs_attr_remove_args does here.  Once we transition
>>>>>>>> the set routines to be delay ready, xfs_attr_rmtval_remove is no longer
>>>>>>>> used and will be removed.
>>>>>>>>
>>>>>>>> This patch also adds a new struct xfs_delattr_context, which we will use
>>>>>>>> to keep track of the current state of an attribute operation. The new
>>>>>>>> xfs_delattr_state enum is used to track various operations that are in
>>>>>>>> progress so that we know not to repeat them, and resume where we left
>>>>>>>> off before EAGAIN was returned to cycle out the transaction. Other
>>>>>>>> members take the place of local variables that need to retain their
>>>>>>>> values across multiple function recalls.  See xfs_attr.h for a more
>>>>>>>> detailed diagram of the states.
>>>>>>>>
>>>>>>>> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
>>>>>>>> ---
>>>>>>>
>>>>>>> I started with a couple small comments on this patch but inevitably
>>>>>>> started thinking more about the factoring again and ended up with a
>>>>>>> couple patches on top. The first is more of some small tweaks and
>>>>>>> open-coding that IMO makes this patch a bit easier to follow. The
>>>>>>> second is more of an RFC so I'll follow up with that in a second email.
>>>>>>> I'm curious what folks' thoughts might be on either. Also note that I'm
>>>>>>> primarily focusing on code structure and whatnot here, so these are fast
>>>>>>> and loose, compile tested only and likely to be broken.
>>>>>>>
>>>>>>
>>>>>> ... and here's the second diff (applies on top of the first).
>>>>>>
>>>>>> This one popped up after staring at the previous changes for a bit and
>>>>>> wondering whether using "done flags" might make the whole thing easier
>>>>>> to follow than incremental state transitions. I think the attr remove
>>>>>> path is easy enough to follow with either method, but the attr set path
>>>>>> is a beast and so this is more with that in mind. Initial thoughts?
>>>>>>
>>>>>
>>>>> Eh, the more I stare at the attr set code I'm not sure this by itself is
>>>>> much of an improvement. It helps in some areas, but there are so many
>>>>> transaction rolls embedded throughout at different levels that a larger
>>>>> rework of the code is probably still necessary. Anyways, this was just a
>>>>> random thought for now..
>>>>>
>>>>> Brian
>>>>
>>>> No worries, I know the feeling :-)  The set works and all, but I do think
>>>> there is struggle around trying to find a particularly pleasent looking
>>>> presentation of it.  Especially when we get into the set path, it's a bit
>>>> more complex.  I may pick through the patches you habe here and pick up the
>>>> whitespace cleanups and other style adjustments if people prefer it that
>>>> way.  The good news is, a lot of the *_args routines are supposed to
>>>> disappear at the end of the set, so there's not really a need to invest too
>>>> much in them I suppose. It may help to jump to the "Set up infastructure"
>>>> patch too.  I've expanded the diagram to try and help illustrait the code
>>>> flow a bit, so that may help with following the code flow.
>>>>
>>>
>>> I'm sure.. :P Note that the first patch was more smaller tweaks and
>>> refactoring with the existing model in mind. For the set path, the
>>> challenge IMO is to make the code generally more readable. I think the
>>> remove path accomplishes this for the most part because the states and
>>> whatnot are fairly low overhead on top of the existing complexity. This
>>> changes considerably for the set path, not so much due to the mechanism
>>> but because the baseline code is so fragmented and complex from the
>>> start. I am slightly concerned that bolting state management onto the
>>> current code as such might make it harder to grok and clean up after the
>>> fact, but I could be wrong about that (my hope was certainly for the
>>> opposite).
>> tbh, everytime I do another spin of the set, I actually make all my
>> modifications on top of the extended set, with parent pointers and all, and
>> make sure all the test cases are still good.  I know pptrs are still pretty
>> far out from here, but they're actually the best testcase for this, because
>> it generates so much more activity.  If all thats still golden, then I'll
>> pull them back down into the lower subsets and work out all the conflicts on
>> the back way up.  If something went wrong, diffing the branch heads tracks
>> it down pretty fast.
>>
> 
> Indeed, that's a good thing. My comment was more around the readability
> of the code and subsequent ability to clean it up, reduce the number of
> required states, etc...
> 
>>>
>>> Regardless, that had me shifting focus a bit and playing around with the
>>> current upstream code as opposed to shifting around your code. ISTM that
>>> there is some commonality across the various set codepaths and perhaps
>>> there is potential to simplify things notably _before_ applying the
>>> state management scheme. I've appended a new diff below (based on
>>> for-next) that starts to demonstrate what I mean. Note again that this
>>> is similarly fast and loose as I've knowingly threw away some quirks of
>>> the code (i.e. leaf buffer bhold) for the purpose of quickly trying to
>>> explore/POC whether the factoring might be sane and plausible.
>>>
>>> In summary, this combines the "try addname" part of each xattr format to
>>> fall under a single transaction rolling loop such that I think the
>>> resulting function could become one high level state. I ran out of time
>>> for working through the rest, but from a read through it seems there's
>>> at least a chance we could continue with similar refactoring and
>>> reduction to a fewer number of generic states (vs. more format-specific
>>> states). For example, the remaining parts of the set operation all seem
>>> to have something along the lines of the following high level
>>> components:
>>>
>>> - remote value block allocation (and value set)
>>> - if rename == true, clear flag and done
>>> - if rename == false, flip flags
>>> 	- remove old xattr (i.e., similar to xattr remove)
>>>
>>> ... where much of that code looks remarkably similar across the
>>> different leaf/node code branches. So I'm curious what you and others
>>> following along might think about something like this as an intermediate
>>> step...
>>
>> Yes, I had noticed similarities when we first started, though I got the
>> impression that people mostly wanted to focus on just hoisting the
>> transactions upwards.  I did look at them at one point, but seem to recall
>> the similarities having just enough disimilarities such that trying to
>> consolodate them tends to introduce about as much plumbing with if/else's.
>> In any case, I do think the solution here with the format handling is
>> creative, and may reduce a state or two, but I'd really need to see it
>> through the test cases to know if it's going to work.  From what you've
>> hashed out here, I think I get the idea. It's hard for me to comment on
>> readability because I've been up and down the code so much.  I do think it's
>> a little loopy looking, but so is the statemachine.  Maybe a good spot for
>> others to chime in too.
>>
> 
> Can you elaborate on what you mean by loopy? :P I'm sure you noticed I
> borrowed the transaction rolling mechanism from your infra patch..
> 
Well, that loop that is borrowed is meant to disappear at the end of the 
set though.  This part with *_set_fmt we would have to keep.  I guess 
that really means the *_set_fmt call would probably get consolodated 
into the *_iter routine though.  Let me see if I can get something like 
this to work on top of the set so it's a bit more clear what it would 
look like.  I think this modification would actually look simpler if it 
came in after the statemachine.  Otherwise you're trying to introduce 
the tranaction loop early.  Really it's purpose is just to get the state 
machine working, and then we get rid of it later.

> But yeah, I'm partly to blame for the hoisting approach as well. I was
> thinking/hoping that seeing the various states would facilitate
> simplification of the code, but my first reaction when looking at the
> (much more complex) xattr set path is more confusion than clarity. I see
> the code drop into state management, using that to call into
> format-specific helpers, then fall into doing some other stuff that
> might call into some of the same format-specific add helpers, then
> realize I'll probably have to trace up and down through the whole path
> to make some sense of the execution flow. 

Yeah, I think this question is very prefrence oriented.  See, initially, 
I thought the pattern of pairing states to gotos sort of alleviated the 
anxiety of needing to trace up and down the code:


    /*
     * We're going away for a bit to cycle the tranaction,
     * but we're gonna come back ....
     */
    dela_state = XFS_DAS_UNIQUE_STATE;
    return -EAGAIN;

xfs_das_unique_state:
    /* ...and resume execution here */


Granted, sometimes we can use the state of the attr to get away from 
needing this, but now you have to re-read the code in the context of 
what ever form we're in to figure that we land back in the same place. I 
realize this is sort of a unique pattern, so I understand people wanting 
to explore the idea of simplifying it away.  At this point I feel like I 
can follow it either way, so it's really what folks are more comfortable 
with.

That is what has me wondering
> whether this would become more simple with fewer, generic and higher
> level states like SET_FORMAT (i.e. what I hacked up), SET_NAME,
> SET_VALUE (rmt block allocs), SET_FLAG (clear or flip), and then finally
> fall into the remove path in the rename case.
> 
> We'd ultimately implement the same type of state machine approach, it
> would just require more up front cleanup rework than the other way
> around, and hopefully land fairly simplified from the onset. Of course
> those states are just off the top of my head so might not be feasible,
> but I'm also curious if any others following along might have thoughts
> one way or the other. I'm sure we could implement things in either order
> when it comes down to it...
Yeah, let me see if it's feasable, and what it ends up looking like. 
I'm kindof of the opinion that if you to have have a certain degree of 
complexity (ie setting states, and resumeing with gotos), you may as 
well leverage it what it can do.  Once you abosorb that pattern, it's 
not so scary the next time you see it.  Simplfying is certainly a good 
thing, but if it breaks the pattern thats keeps a more complex concept 
organized, the simplification might not make as much sense to others.  I 
think it's likley a spot for others to chime in, I think after looking 
at the same code for a while, it's hard to put yourself in the POV of 
someone else still trying to work through it.  :-)

Allison

> 
> Brian
> 
>> I actually find it easier to work on it from the top of the set rather than
>> the bottom.  Just so that the end goal of what it will end up looking like
>> is a little more clear.  Once the goal is clear, then I worry about layering
>> it in what ever patch it goes in.  Otherwise it's harder to see exactly how
>> the conflicts shake out.
>>
>> Allison
>>>
>>> Brian
>>>
>>> --- 8< ---
>>>
>>> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
>>> index fd8e6418a0d3..eff8833d5303 100644
>>> --- a/fs/xfs/libxfs/xfs_attr.c
>>> +++ b/fs/xfs/libxfs/xfs_attr.c
>>> @@ -58,6 +58,8 @@ STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>>>    				 struct xfs_da_state **state);
>>>    STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>>>    STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
>>> +STATIC int xfs_attr_leaf_try_add(struct xfs_da_args *, struct xfs_buf *);
>>> +STATIC int xfs_attr_node_addname_work(struct xfs_da_args *);
>>>    int
>>>    xfs_inode_hasattr(
>>> @@ -216,116 +218,93 @@ xfs_attr_is_shortform(
>>>    		ip->i_afp->if_nextents == 0);
>>>    }
>>> -/*
>>> - * Attempts to set an attr in shortform, or converts short form to leaf form if
>>> - * there is not enough room.  If the attr is set, the transaction is committed
>>> - * and set to NULL.
>>> - */
>>> -STATIC int
>>> -xfs_attr_set_shortform(
>>> +int
>>> +xfs_attr_set_fmt(
>>>    	struct xfs_da_args	*args,
>>> -	struct xfs_buf		**leaf_bp)
>>> +	bool			*done)
>>>    {
>>>    	struct xfs_inode	*dp = args->dp;
>>> -	int			error, error2 = 0;
>>> +	struct xfs_buf		*leaf_bp = NULL;
>>> +	int			error = 0;
>>> -	/*
>>> -	 * Try to add the attr to the attribute list in the inode.
>>> -	 */
>>> -	error = xfs_attr_try_sf_addname(dp, args);
>>> -	if (error != -ENOSPC) {
>>> -		error2 = xfs_trans_commit(args->trans);
>>> -		args->trans = NULL;
>>> -		return error ? error : error2;
>>> +	if (xfs_attr_is_shortform(dp)) {
>>> +		error = xfs_attr_try_sf_addname(dp, args);
>>> +		if (!error)
>>> +			*done = true;
>>> +		if (error != -ENOSPC)
>>> +			return error;
>>> +
>>> +		error = xfs_attr_shortform_to_leaf(args, &leaf_bp);
>>> +		if (error)
>>> +			return error;
>>> +		return -EAGAIN;
>>>    	}
>>> -	/*
>>> -	 * It won't fit in the shortform, transform to a leaf block.  GROT:
>>> -	 * another possible req'mt for a double-split btree op.
>>> -	 */
>>> -	error = xfs_attr_shortform_to_leaf(args, leaf_bp);
>>> -	if (error)
>>> -		return error;
>>> -	/*
>>> -	 * Prevent the leaf buffer from being unlocked so that a concurrent AIL
>>> -	 * push cannot grab the half-baked leaf buffer and run into problems
>>> -	 * with the write verifier. Once we're done rolling the transaction we
>>> -	 * can release the hold and add the attr to the leaf.
>>> -	 */
>>> -	xfs_trans_bhold(args->trans, *leaf_bp);
>>> -	error = xfs_defer_finish(&args->trans);
>>> -	xfs_trans_bhold_release(args->trans, *leaf_bp);
>>> -	if (error) {
>>> -		xfs_trans_brelse(args->trans, *leaf_bp);
>>> -		return error;
>>> +	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>>> +		struct xfs_buf	*bp = NULL;
>>> +
>>> +		error = xfs_attr_leaf_try_add(args, bp);
>>> +		if (error != -ENOSPC)
>>> +			return error;
>>> +
>>> +		error = xfs_attr3_leaf_to_node(args);
>>> +		if (error)
>>> +			return error;
>>> +		return -EAGAIN;
>>>    	}
>>> -	return 0;
>>> +	return xfs_attr_node_addname(args);
>>>    }
>>>    /*
>>>     * Set the attribute specified in @args.
>>>     */
>>>    int
>>> -xfs_attr_set_args(
>>> +__xfs_attr_set_args(
>>>    	struct xfs_da_args	*args)
>>>    {
>>>    	struct xfs_inode	*dp = args->dp;
>>> -	struct xfs_buf          *leaf_bp = NULL;
>>>    	int			error = 0;
>>> -	/*
>>> -	 * If the attribute list is already in leaf format, jump straight to
>>> -	 * leaf handling.  Otherwise, try to add the attribute to the shortform
>>> -	 * list; if there's no room then convert the list to leaf format and try
>>> -	 * again.
>>> -	 */
>>> -	if (xfs_attr_is_shortform(dp)) {
>>> -
>>> -		/*
>>> -		 * If the attr was successfully set in shortform, the
>>> -		 * transaction is committed and set to NULL.  Otherwise, is it
>>> -		 * converted from shortform to leaf, and the transaction is
>>> -		 * retained.
>>> -		 */
>>> -		error = xfs_attr_set_shortform(args, &leaf_bp);
>>> -		if (error || !args->trans)
>>> -			return error;
>>> -	}
>>> -
>>>    	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>>>    		error = xfs_attr_leaf_addname(args);
>>> -		if (error != -ENOSPC)
>>> -			return error;
>>> -
>>> -		/*
>>> -		 * Promote the attribute list to the Btree format.
>>> -		 */
>>> -		error = xfs_attr3_leaf_to_node(args);
>>>    		if (error)
>>>    			return error;
>>> +	}
>>> +
>>> +	error = xfs_attr_node_addname_work(args);
>>> +	return error;
>>> +}
>>> +
>>> +int
>>> +xfs_attr_set_args(
>>> +	struct xfs_da_args	*args)
>>> +
>>> +{
>>> +	int			error;
>>> +	bool			done = false;
>>> +
>>> +	do {
>>> +		error = xfs_attr_set_fmt(args, &done);
>>> +		if (error != -EAGAIN)
>>> +			break;
>>> -		/*
>>> -		 * Finish any deferred work items and roll the transaction once
>>> -		 * more.  The goal here is to call node_addname with the inode
>>> -		 * and transaction in the same state (inode locked and joined,
>>> -		 * transaction clean) no matter how we got to this step.
>>> -		 */
>>>    		error = xfs_defer_finish(&args->trans);
>>>    		if (error)
>>> -			return error;
>>> +			break;
>>> +		error = xfs_trans_roll_inode(&args->trans, args->dp);
>>> +	} while (!error);
>>> -		/*
>>> -		 * Commit the current trans (including the inode) and
>>> -		 * start a new one.
>>> -		 */
>>> -		error = xfs_trans_roll_inode(&args->trans, dp);
>>> -		if (error)
>>> -			return error;
>>> -	}
>>> +	if (error || done)
>>> +		return error;
>>> -	error = xfs_attr_node_addname(args);
>>> -	return error;
>>> +	error = xfs_defer_finish(&args->trans);
>>> +	if (!error)
>>> +		error = xfs_trans_roll_inode(&args->trans, args->dp);
>>> +	if (error)
>>> +		return error;
>>> +
>>> +	return __xfs_attr_set_args(args);
>>>    }
>>>    /*
>>> @@ -676,18 +655,6 @@ xfs_attr_leaf_addname(
>>>    	trace_xfs_attr_leaf_addname(args);
>>> -	error = xfs_attr_leaf_try_add(args, bp);
>>> -	if (error)
>>> -		return error;
>>> -
>>> -	/*
>>> -	 * Commit the transaction that added the attr name so that
>>> -	 * later routines can manage their own transactions.
>>> -	 */
>>> -	error = xfs_trans_roll_inode(&args->trans, dp);
>>> -	if (error)
>>> -		return error;
>>> -
>>>    	/*
>>>    	 * If there was an out-of-line value, allocate the blocks we
>>>    	 * identified for its storage and copy the value.  This is done
>>> @@ -923,7 +890,7 @@ xfs_attr_node_addname(
>>>    	 * Fill in bucket of arguments/results/context to carry around.
>>>    	 */
>>>    	dp = args->dp;
>>> -restart:
>>> +
>>>    	/*
>>>    	 * Search to see if name already exists, and get back a pointer
>>>    	 * to where it should go.
>>> @@ -967,21 +934,10 @@ xfs_attr_node_addname(
>>>    			xfs_da_state_free(state);
>>>    			state = NULL;
>>>    			error = xfs_attr3_leaf_to_node(args);
>>> -			if (error)
>>> -				goto out;
>>> -			error = xfs_defer_finish(&args->trans);
>>>    			if (error)
>>>    				goto out;
>>> -			/*
>>> -			 * Commit the node conversion and start the next
>>> -			 * trans in the chain.
>>> -			 */
>>> -			error = xfs_trans_roll_inode(&args->trans, dp);
>>> -			if (error)
>>> -				goto out;
>>> -
>>> -			goto restart;
>>> +			return -EAGAIN;
>>>    		}
>>>    		/*
>>> @@ -993,9 +949,6 @@ xfs_attr_node_addname(
>>>    		error = xfs_da3_split(state);
>>>    		if (error)
>>>    			goto out;
>>> -		error = xfs_defer_finish(&args->trans);
>>> -		if (error)
>>> -			goto out;
>>>    	} else {
>>>    		/*
>>>    		 * Addition succeeded, update Btree hashvals.
>>> @@ -1010,13 +963,23 @@ xfs_attr_node_addname(
>>>    	xfs_da_state_free(state);
>>>    	state = NULL;
>>> -	/*
>>> -	 * Commit the leaf addition or btree split and start the next
>>> -	 * trans in the chain.
>>> -	 */
>>> -	error = xfs_trans_roll_inode(&args->trans, dp);
>>> +	return 0;
>>> +
>>> +out:
>>> +	if (state)
>>> +		xfs_da_state_free(state);
>>>    	if (error)
>>> -		goto out;
>>> +		return error;
>>> +	return retval;
>>> +}
>>> +
>>> +STATIC int
>>> +xfs_attr_node_addname_work(
>>> +	struct xfs_da_args	*args)
>>> +{
>>> +	struct xfs_da_state	*state;
>>> +	struct xfs_da_state_blk	*blk;
>>> +	int			retval, error;
>>>    	/*
>>>    	 * If there was an out-of-line value, allocate the blocks we
>>>
>>
> 
