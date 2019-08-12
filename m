Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A2B78A44F
	for <lists+linux-xfs@lfdr.de>; Mon, 12 Aug 2019 19:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726594AbfHLR3h (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 12 Aug 2019 13:29:37 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49286 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbfHLR3h (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 13:29:37 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CHNoVp003116
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 17:29:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=gGz1/hCplVoS/TMdW4Cy4FEzdWMYnCdHhX6fnr+LBGU=;
 b=rjl9bREv0eiyDI9QYooXQLcAHKxpns7NdaRQKd2Dq8c+4TaRS9TqW9fewlQDjgb75WmB
 ajiZXQMChTn4xgY1hYGBT5g3jtotclomjyci74JkkbK9mqFvBK1cWF01P6aja0ecqQEN
 4u9CdyBAo1SgB+mD4Zl410OqqmiKL3c22Evd5r38yNAeDbxlRwnX9mIMiwYHwYPKEtEk
 Ax4tYuYTu7Na/LKXVtBFIwSKGAxvazdolJCc7cfJ7aIMjmVNnx0n1h/dQHnK8HxM+yNY
 fiVXOSWBhs7VCQxNh0xeel6+dqu219U42vTElOv2QsOU+ZIoRjD1aGTFivQtpJIkIH6H zQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=gGz1/hCplVoS/TMdW4Cy4FEzdWMYnCdHhX6fnr+LBGU=;
 b=qHscYv4026v5/Ehm651aP5fhUB6n63a8T27G8DkFzcdCv3IbGgNa2ECcPxTtvfB8Xyb5
 oenkPc3uB0VuU8Dtk27apQxD/U72IkjBYOYkX7uqxvMMSGmnPsK2sqKOOsOs4FdH2xUc
 HhKhmJdZbZzJ7Nfm4Eyn4GsaQl5/uAerP3gRaRCmJC+A1ZfWPagBZy9sQoPjrCEAkIYk
 kYDv0s1tg7COEFcRHMLfonOqUEdtavjZH7CGwCpbqgVblh9DPgE2KcHgxwnKsMbls6Xm
 kQkXj6wgf1E1/B2/CgUS46+SoZSHWy8amJJYeMNtdfSsQNY3/lC1jiXLE5mxhM0ub0Ip JQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2u9nbt93x0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 17:29:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CHSACF041792
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 17:29:35 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2u9k1vf2uv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 17:29:35 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7CHTYcT027868
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 17:29:34 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 12 Aug 2019 10:29:33 -0700
Date:   Mon, 12 Aug 2019 10:29:33 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 15/18] xfs: Add delayed attribute routines
Message-ID: <20190812172933.GI7138@magnolia>
References: <20190809213726.32336-1-allison.henderson@oracle.com>
 <20190809213726.32336-16-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190809213726.32336-16-allison.henderson@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908120193
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908120193
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 09, 2019 at 02:37:23PM -0700, Allison Collins wrote:
> This patch adds new delayed attribute routines:
> 
> xfs_attr_da_set_args
> xfs_attr_da_remove_args
> xfs_attr_da_leaf_addname
> xfs_attr_da_node_addname
> xfs_attr_da_node_removename

I think the "_da_" thing is shorthand for "deferred attr", right?

If so, it's way too close to the other "_da_" (which is shorthand for
"directory/attr") for my taste.

xfs_attr_set_later()
xfs_attr_remove_later()
xfs_leaf_addname_later()
xfs_node_addname_later()
xfs_node_remove_later() ?

> These routines are similar to their existing counter parts,
> but they do not roll or commit transactions.  They instead
> return -EGAIN to allow the calling function to roll the

EAGAIN...

> transaction and recall the function.  This allows the
> attribute operations to be logged in multiple smaller
> transactions.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 720 +++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_attr.h |   2 +
>  2 files changed, 722 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index ca57202..9931e50 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -47,6 +47,7 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
>   */
>  STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
>  STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args);
> +STATIC int xfs_attr_da_leaf_addname(xfs_da_args_t *args);
>  STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args);
>  STATIC int xfs_leaf_has_attr(xfs_da_args_t *args, struct xfs_buf **bp);         
>  
> @@ -55,12 +56,16 @@ STATIC int xfs_leaf_has_attr(xfs_da_args_t *args, struct xfs_buf **bp);
>   */
>  STATIC int xfs_attr_node_get(xfs_da_args_t *args);
>  STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
> +STATIC int xfs_attr_da_node_addname(xfs_da_args_t *args);
>  STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
> +STATIC int xfs_attr_da_node_removename(xfs_da_args_t *args);
>  STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
>  				 struct xfs_da_state **state);
>  STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
>  STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
>  
> +STATIC int
> +xfs_attr_leaf_try_add(struct xfs_da_args *args, struct xfs_buf *bp);

STATIC int xfs_attr_leaf_try_add(...)

(no newline between the return type and the function name)

>  
>  int
>  xfs_attr_args_init(

<snip>

> +STATIC int
> +xfs_attr_da_leaf_addname(
> +	struct xfs_da_args	*args)
> +{
> +	int			error, forkoff, nmap;
> +	struct xfs_buf		*bp = NULL;
> +	struct xfs_inode	*dp = args->dp;
> +	struct xfs_bmbt_irec	*map = &args->dc.map;

<snip>

> +	/*
> +	 * If this is an atomic rename operation, we must "flip" the
> +	 * incomplete flags on the "new" and "old" attribute/value pairs
> +	 * so that one disappears and one appears atomically.  Then we
> +	 * must remove the "old" attribute/value pair.
> +	 */
> +	if (args->op_flags & XFS_DA_OP_RENAME) {
> +		/*
> +		 * In a separate transaction, set the incomplete flag on the
> +		 * "old" attr and clear the incomplete flag on the "new" attr.

Echoing Christoph, can this new attr implementation set the attr value
through the log so we can get rid of the INCOMPLETE flag switcheroo
business?  I see a lot of nearly duplicated code and if we're going to
have to support having two paths through the attr set/remove code, we
could at least avoid the weird warts of the old path when designing the
new one.

<snip more>

> +STATIC int
> +xfs_attr_da_node_removename(
> +	struct xfs_da_args	*args)
> +{
> +	struct xfs_da_state	*state = NULL;
> +	struct xfs_da_state_blk	*blk;
> +	struct xfs_buf		*bp;
> +	int			error, forkoff, retval = 0;
> +	struct xfs_inode	*dp = args->dp;
> +	int			done = 0;
> +
> +	trace_xfs_attr_node_removename(args);
> +
> +	if (args->dc.state == NULL) {
> +		error = xfs_attr_node_hasname(args, &args->dc.state);
> +		if (error != -EEXIST)
> +			goto out;
> +		else
> +			error = 0;
> +
> +		/*
> +		 * If there is an out-of-line value, de-allocate the blocks.
> +		 * This is done before we remove the attribute so that we don't
> +		 * overflow the maximum size of a transaction and/or hit a
> +		 * deadlock.
> +		 */
> +		state = args->dc.state;
> +		args->dc.blk = &state->path.blk[state->path.active - 1];
> +		ASSERT(args->dc.blk->bp != NULL);
> +		ASSERT(args->dc.blk->magic == XFS_ATTR_LEAF_MAGIC);
> +	}
> +	state = args->dc.state;
> +	blk = args->dc.blk;
> +
> +	if (args->rmtblkno > 0 && !(args->dc.flags & XFS_DC_RM_LEAF_BLKS)) {
> +		if (!xfs_attr3_leaf_flag_is_set(args)) {
> +			/*
> +			 * Fill in disk block numbers in the state structure
> +			 * so that we can get the buffers back after we commit
> +			 * several transactions in the following calls.
> +			 */
> +			error = xfs_attr_fillstate(state);
> +			if (error)
> +				goto out;
> +
> +			/*
> +			 * Mark the attribute as INCOMPLETE, then bunmapi() the
> +			 * remote value.
> +			 */
> +			error = xfs_attr3_leaf_setflag(args);
> +			if (error)
> +				goto out;
> +
> +			return -EAGAIN;
> +		}
> +
> +		if (!(args->dc.flags & XFS_DC_RM_NODE_BLKS)) {
> +			error = xfs_attr_rmtval_remove_value(args);
> +			if (error)
> +				goto out;
> +		}
> +
> +		args->dc.flags |= XFS_DC_RM_NODE_BLKS;

This ought to be set in the if clause above...

> +		while (!done && !error) {
> +			error = xfs_bunmapi(args->trans, args->dp,
> +				    args->rmtblkno, args->rmtblkcnt,
> +				    XFS_BMAPI_ATTRFORK, 1, &done);
> +			if (error)
> +				return error;
> +
> +			if (!done)
> +				return -EAGAIN;
> +		}

Probably worth a comment to make it a little clearer that this is the
bottom part of xfs_attr_rmtval_remove but open-coded for this case.

I wish this new attr path could share more code with the old one,
though I dunno, probably you've already done that analysis and decided
that cutting this up into ~30 tiny functions isn't worth it...?

(Yeah, snip all the way to the end because I need to go rest my eyes for
a bit but didn't want to delay this reply further.)

--D
