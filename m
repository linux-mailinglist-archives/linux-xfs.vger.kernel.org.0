Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03D1EB6ACA
	for <lists+linux-xfs@lfdr.de>; Wed, 18 Sep 2019 20:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbfIRSq4 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 18 Sep 2019 14:46:56 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38728 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726527AbfIRSqz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Sep 2019 14:46:55 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8IIiScx155679;
        Wed, 18 Sep 2019 18:46:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=b+BJIVsmRY5W3CA+V9JAsKvrWq8hoUU029pTxqcaBT0=;
 b=VAZyectgbqPsOJDKLAjkm1W9Ox3AW7T/xBTaRIBPj4LQIivuDPw+X37Ld/h+zoFVkM1r
 jzmsAuWMMDrJL+dbg5OzsIm8ZA1URPuWnyP/c6uxT411gtDdRDZieMwi30xCUp74LEVC
 c1wEttjVvuKSfS+hzY3M7+00N+LK4WMMts/5qN3dzLsCXwYn5IqD/iym9LaqblLM79rr
 bmk2v4qshDUUFSReoczmaBwP3GgQpZWFanlXlID27XTa82OyhGM58/fXsIewhQXDL8on
 A9MnEnr0g1h7PCYNNLNAXoxqv+doGDo2+VBtlt8aPqhLfsrVveY8ZZv6e/wAyX9Xhp4s RA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2v385dwu7n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Sep 2019 18:46:41 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x8IIdEt4067771;
        Wed, 18 Sep 2019 18:46:40 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2v37ma46gx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Sep 2019 18:46:40 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x8IIkduG021762;
        Wed, 18 Sep 2019 18:46:39 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Sep 2019 11:46:39 -0700
Date:   Wed, 18 Sep 2019 11:46:38 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v4 02/11] xfs: introduce allocation cursor data structure
Message-ID: <20190918184638.GQ2229799@magnolia>
References: <20190916121635.43148-1-bfoster@redhat.com>
 <20190916121635.43148-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190916121635.43148-3-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9384 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1909180163
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9384 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1909180164
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 16, 2019 at 08:16:26AM -0400, Brian Foster wrote:
> Introduce a new allocation cursor data structure to encapsulate the
> various states and structures used to perform an extent allocation.
> This structure will eventually be used to track overall allocation
> state across different search algorithms on both free space btrees.
> 
> To start, include the three btree cursors (one for the cntbt and two
> for the bnobt left/right search) used by the near mode allocation
> algorithm and refactor the cursor setup and teardown code into
> helpers. This slightly changes cursor memory allocation patterns,
> but otherwise makes no functional changes to the allocation
> algorithm.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks good to me; thanks for breaking this up a little more. :)

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_alloc.c | 318 +++++++++++++++++++-------------------
>  1 file changed, 163 insertions(+), 155 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 512a45888e06..d159377ed603 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -710,8 +710,71 @@ xfs_alloc_update_counters(
>  }
>  
>  /*
> - * Allocation group level functions.
> + * Block allocation algorithm and data structures.
>   */
> +struct xfs_alloc_cur {
> +	struct xfs_btree_cur		*cnt;	/* btree cursors */
> +	struct xfs_btree_cur		*bnolt;
> +	struct xfs_btree_cur		*bnogt;
> +};
> +
> +/*
> + * Set up cursors, etc. in the extent allocation cursor. This function can be
> + * called multiple times to reset an initialized structure without having to
> + * reallocate cursors.
> + */
> +static int
> +xfs_alloc_cur_setup(
> +	struct xfs_alloc_arg	*args,
> +	struct xfs_alloc_cur	*acur)
> +{
> +	int			error;
> +	int			i;
> +
> +	ASSERT(args->alignment == 1 || args->type != XFS_ALLOCTYPE_THIS_BNO);
> +
> +	/*
> +	 * Perform an initial cntbt lookup to check for availability of maxlen
> +	 * extents. If this fails, we'll return -ENOSPC to signal the caller to
> +	 * attempt a small allocation.
> +	 */
> +	if (!acur->cnt)
> +		acur->cnt = xfs_allocbt_init_cursor(args->mp, args->tp,
> +					args->agbp, args->agno, XFS_BTNUM_CNT);
> +	error = xfs_alloc_lookup_ge(acur->cnt, 0, args->maxlen, &i);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * Allocate the bnobt left and right search cursors.
> +	 */
> +	if (!acur->bnolt)
> +		acur->bnolt = xfs_allocbt_init_cursor(args->mp, args->tp,
> +					args->agbp, args->agno, XFS_BTNUM_BNO);
> +	if (!acur->bnogt)
> +		acur->bnogt = xfs_allocbt_init_cursor(args->mp, args->tp,
> +					args->agbp, args->agno, XFS_BTNUM_BNO);
> +	return i == 1 ? 0 : -ENOSPC;
> +}
> +
> +static void
> +xfs_alloc_cur_close(
> +	struct xfs_alloc_cur	*acur,
> +	bool			error)
> +{
> +	int			cur_error = XFS_BTREE_NOERROR;
> +
> +	if (error)
> +		cur_error = XFS_BTREE_ERROR;
> +
> +	if (acur->cnt)
> +		xfs_btree_del_cursor(acur->cnt, cur_error);
> +	if (acur->bnolt)
> +		xfs_btree_del_cursor(acur->bnolt, cur_error);
> +	if (acur->bnogt)
> +		xfs_btree_del_cursor(acur->bnogt, cur_error);
> +	acur->cnt = acur->bnolt = acur->bnogt = NULL;
> +}
>  
>  /*
>   * Deal with the case where only small freespaces remain. Either return the
> @@ -1008,8 +1071,8 @@ xfs_alloc_ag_vextent_exact(
>  STATIC int
>  xfs_alloc_find_best_extent(
>  	struct xfs_alloc_arg	*args,	/* allocation argument structure */
> -	struct xfs_btree_cur	**gcur,	/* good cursor */
> -	struct xfs_btree_cur	**scur,	/* searching cursor */
> +	struct xfs_btree_cur	*gcur,	/* good cursor */
> +	struct xfs_btree_cur	*scur,	/* searching cursor */
>  	xfs_agblock_t		gdiff,	/* difference for search comparison */
>  	xfs_agblock_t		*sbno,	/* extent found by search */
>  	xfs_extlen_t		*slen,	/* extent length */
> @@ -1031,7 +1094,7 @@ xfs_alloc_find_best_extent(
>  	 * Look until we find a better one, run out of space or run off the end.
>  	 */
>  	do {
> -		error = xfs_alloc_get_rec(*scur, sbno, slen, &i);
> +		error = xfs_alloc_get_rec(scur, sbno, slen, &i);
>  		if (error)
>  			goto error0;
>  		XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
> @@ -1074,21 +1137,19 @@ xfs_alloc_find_best_extent(
>  		}
>  
>  		if (!dir)
> -			error = xfs_btree_increment(*scur, 0, &i);
> +			error = xfs_btree_increment(scur, 0, &i);
>  		else
> -			error = xfs_btree_decrement(*scur, 0, &i);
> +			error = xfs_btree_decrement(scur, 0, &i);
>  		if (error)
>  			goto error0;
>  	} while (i);
>  
>  out_use_good:
> -	xfs_btree_del_cursor(*scur, XFS_BTREE_NOERROR);
> -	*scur = NULL;
> +	scur->bc_private.a.priv.abt.active = false;
>  	return 0;
>  
>  out_use_search:
> -	xfs_btree_del_cursor(*gcur, XFS_BTREE_NOERROR);
> -	*gcur = NULL;
> +	gcur->bc_private.a.priv.abt.active = false;
>  	return 0;
>  
>  error0:
> @@ -1102,13 +1163,12 @@ xfs_alloc_find_best_extent(
>   * and of the form k * prod + mod unless there's nothing that large.
>   * Return the starting a.g. block, or NULLAGBLOCK if we can't do it.
>   */
> -STATIC int				/* error */
> +STATIC int
>  xfs_alloc_ag_vextent_near(
> -	xfs_alloc_arg_t	*args)		/* allocation argument structure */
> +	struct xfs_alloc_arg	*args)
>  {
> -	xfs_btree_cur_t	*bno_cur_gt;	/* cursor for bno btree, right side */
> -	xfs_btree_cur_t	*bno_cur_lt;	/* cursor for bno btree, left side */
> -	xfs_btree_cur_t	*cnt_cur;	/* cursor for count btree */
> +	struct xfs_alloc_cur	acur = {0,};
> +	struct xfs_btree_cur	*bno_cur;
>  	xfs_agblock_t	gtbno;		/* start bno of right side entry */
>  	xfs_agblock_t	gtbnoa;		/* aligned ... */
>  	xfs_extlen_t	gtdiff;		/* difference to right side entry */
> @@ -1148,38 +1208,29 @@ xfs_alloc_ag_vextent_near(
>  		args->agbno = args->max_agbno;
>  
>  restart:
> -	bno_cur_lt = NULL;
> -	bno_cur_gt = NULL;
>  	ltlen = 0;
>  	gtlena = 0;
>  	ltlena = 0;
>  	busy = false;
>  
>  	/*
> -	 * Get a cursor for the by-size btree.
> +	 * Set up cursors and see if there are any free extents as big as
> +	 * maxlen. If not, pick the last entry in the tree unless the tree is
> +	 * empty.
>  	 */
> -	cnt_cur = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
> -		args->agno, XFS_BTNUM_CNT);
> -
> -	/*
> -	 * See if there are any free extents as big as maxlen.
> -	 */
> -	if ((error = xfs_alloc_lookup_ge(cnt_cur, 0, args->maxlen, &i)))
> -		goto error0;
> -	/*
> -	 * If none, then pick up the last entry in the tree unless the
> -	 * tree is empty.
> -	 */
> -	if (!i) {
> -		if ((error = xfs_alloc_ag_vextent_small(args, cnt_cur, &ltbno,
> -				&ltlen, &i)))
> -			goto error0;
> +	error = xfs_alloc_cur_setup(args, &acur);
> +	if (error == -ENOSPC) {
> +		error = xfs_alloc_ag_vextent_small(args, acur.cnt, &ltbno,
> +				&ltlen, &i);
> +		if (error)
> +			goto out;
>  		if (i == 0 || ltlen == 0) {
> -			xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
>  			trace_xfs_alloc_near_noentry(args);
> -			return 0;
> +			goto out;
>  		}
>  		ASSERT(i == 1);
> +	} else if (error) {
> +		goto out;
>  	}
>  	args->wasfromfl = 0;
>  
> @@ -1193,7 +1244,7 @@ xfs_alloc_ag_vextent_near(
>  	 * This is written as a while loop so we can break out of it,
>  	 * but we never loop back to the top.
>  	 */
> -	while (xfs_btree_islastblock(cnt_cur, 0)) {
> +	while (xfs_btree_islastblock(acur.cnt, 0)) {
>  		xfs_extlen_t	bdiff;
>  		int		besti=0;
>  		xfs_extlen_t	blen=0;
> @@ -1210,32 +1261,35 @@ xfs_alloc_ag_vextent_near(
>  		 * and skip all those smaller than minlen.
>  		 */
>  		if (ltlen || args->alignment > 1) {
> -			cnt_cur->bc_ptrs[0] = 1;
> +			acur.cnt->bc_ptrs[0] = 1;
>  			do {
> -				if ((error = xfs_alloc_get_rec(cnt_cur, &ltbno,
> -						&ltlen, &i)))
> -					goto error0;
> -				XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
> +				error = xfs_alloc_get_rec(acur.cnt, &ltbno,
> +						&ltlen, &i);
> +				if (error)
> +					goto out;
> +				XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, out);
>  				if (ltlen >= args->minlen)
>  					break;
> -				if ((error = xfs_btree_increment(cnt_cur, 0, &i)))
> -					goto error0;
> +				error = xfs_btree_increment(acur.cnt, 0, &i);
> +				if (error)
> +					goto out;
>  			} while (i);
>  			ASSERT(ltlen >= args->minlen);
>  			if (!i)
>  				break;
>  		}
> -		i = cnt_cur->bc_ptrs[0];
> +		i = acur.cnt->bc_ptrs[0];
>  		for (j = 1, blen = 0, bdiff = 0;
>  		     !error && j && (blen < args->maxlen || bdiff > 0);
> -		     error = xfs_btree_increment(cnt_cur, 0, &j)) {
> +		     error = xfs_btree_increment(acur.cnt, 0, &j)) {
>  			/*
>  			 * For each entry, decide if it's better than
>  			 * the previous best entry.
>  			 */
> -			if ((error = xfs_alloc_get_rec(cnt_cur, &ltbno, &ltlen, &i)))
> -				goto error0;
> -			XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
> +			error = xfs_alloc_get_rec(acur.cnt, &ltbno, &ltlen, &i);
> +			if (error)
> +				goto out;
> +			XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, out);
>  			busy = xfs_alloc_compute_aligned(args, ltbno, ltlen,
>  					&ltbnoa, &ltlena, &busy_gen);
>  			if (ltlena < args->minlen)
> @@ -1255,7 +1309,7 @@ xfs_alloc_ag_vextent_near(
>  				bdiff = ltdiff;
>  				bnew = ltnew;
>  				blen = args->len;
> -				besti = cnt_cur->bc_ptrs[0];
> +				besti = acur.cnt->bc_ptrs[0];
>  			}
>  		}
>  		/*
> @@ -1267,10 +1321,11 @@ xfs_alloc_ag_vextent_near(
>  		/*
>  		 * Point at the best entry, and retrieve it again.
>  		 */
> -		cnt_cur->bc_ptrs[0] = besti;
> -		if ((error = xfs_alloc_get_rec(cnt_cur, &ltbno, &ltlen, &i)))
> -			goto error0;
> -		XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
> +		acur.cnt->bc_ptrs[0] = besti;
> +		error = xfs_alloc_get_rec(acur.cnt, &ltbno, &ltlen, &i);
> +		if (error)
> +			goto out;
> +		XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, out);
>  		ASSERT(ltbno + ltlen <= be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length));
>  		args->len = blen;
>  
> @@ -1280,23 +1335,14 @@ xfs_alloc_ag_vextent_near(
>  		args->agbno = bnew;
>  		ASSERT(bnew >= ltbno);
>  		ASSERT(bnew + blen <= ltbno + ltlen);
> -		/*
> -		 * Set up a cursor for the by-bno tree.
> -		 */
> -		bno_cur_lt = xfs_allocbt_init_cursor(args->mp, args->tp,
> -			args->agbp, args->agno, XFS_BTNUM_BNO);
> -		/*
> -		 * Fix up the btree entries.
> -		 */
> -		if ((error = xfs_alloc_fixup_trees(cnt_cur, bno_cur_lt, ltbno,
> -				ltlen, bnew, blen, XFSA_FIXUP_CNT_OK)))
> -			goto error0;
> -		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
> -		xfs_btree_del_cursor(bno_cur_lt, XFS_BTREE_NOERROR);
> -
> +		error = xfs_alloc_fixup_trees(acur.cnt, acur.bnolt, ltbno,
> +					ltlen, bnew, blen, XFSA_FIXUP_CNT_OK);
> +		if (error)
> +			goto out;
>  		trace_xfs_alloc_near_first(args);
> -		return 0;
> +		goto out;
>  	}
> +
>  	/*
>  	 * Second algorithm.
>  	 * Search in the by-bno tree to the left and to the right
> @@ -1309,86 +1355,57 @@ xfs_alloc_ag_vextent_near(
>  	 * level algorithm that picks allocation groups for allocations
>  	 * is not supposed to do this.
>  	 */
> -	/*
> -	 * Allocate and initialize the cursor for the leftward search.
> -	 */
> -	bno_cur_lt = xfs_allocbt_init_cursor(args->mp, args->tp, args->agbp,
> -		args->agno, XFS_BTNUM_BNO);
> -	/*
> -	 * Lookup <= bno to find the leftward search's starting point.
> -	 */
> -	if ((error = xfs_alloc_lookup_le(bno_cur_lt, args->agbno, args->maxlen, &i)))
> -		goto error0;
> -	if (!i) {
> -		/*
> -		 * Didn't find anything; use this cursor for the rightward
> -		 * search.
> -		 */
> -		bno_cur_gt = bno_cur_lt;
> -		bno_cur_lt = NULL;
> -	}
> -	/*
> -	 * Found something.  Duplicate the cursor for the rightward search.
> -	 */
> -	else if ((error = xfs_btree_dup_cursor(bno_cur_lt, &bno_cur_gt)))
> -		goto error0;
> -	/*
> -	 * Increment the cursor, so we will point at the entry just right
> -	 * of the leftward entry if any, or to the leftmost entry.
> -	 */
> -	if ((error = xfs_btree_increment(bno_cur_gt, 0, &i)))
> -		goto error0;
> -	if (!i) {
> -		/*
> -		 * It failed, there are no rightward entries.
> -		 */
> -		xfs_btree_del_cursor(bno_cur_gt, XFS_BTREE_NOERROR);
> -		bno_cur_gt = NULL;
> -	}
> +	error = xfs_alloc_lookup_le(acur.bnolt, args->agbno, 0, &i);
> +	if (error)
> +		goto out;
> +	error = xfs_alloc_lookup_ge(acur.bnogt, args->agbno, 0, &i);
> +	if (error)
> +		goto out;
> +
>  	/*
>  	 * Loop going left with the leftward cursor, right with the
>  	 * rightward cursor, until either both directions give up or
>  	 * we find an entry at least as big as minlen.
>  	 */
>  	do {
> -		if (bno_cur_lt) {
> -			if ((error = xfs_alloc_get_rec(bno_cur_lt, &ltbno, &ltlen, &i)))
> -				goto error0;
> -			XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
> +		if (xfs_alloc_cur_active(acur.bnolt)) {
> +			error = xfs_alloc_get_rec(acur.bnolt, &ltbno, &ltlen, &i);
> +			if (error)
> +				goto out;
> +			XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, out);
>  			busy |= xfs_alloc_compute_aligned(args, ltbno, ltlen,
>  					&ltbnoa, &ltlena, &busy_gen);
>  			if (ltlena >= args->minlen && ltbnoa >= args->min_agbno)
>  				break;
> -			if ((error = xfs_btree_decrement(bno_cur_lt, 0, &i)))
> -				goto error0;
> -			if (!i || ltbnoa < args->min_agbno) {
> -				xfs_btree_del_cursor(bno_cur_lt,
> -						     XFS_BTREE_NOERROR);
> -				bno_cur_lt = NULL;
> -			}
> +			error = xfs_btree_decrement(acur.bnolt, 0, &i);
> +			if (error)
> +				goto out;
> +			if (!i || ltbnoa < args->min_agbno)
> +				acur.bnolt->bc_private.a.priv.abt.active = false;
>  		}
> -		if (bno_cur_gt) {
> -			if ((error = xfs_alloc_get_rec(bno_cur_gt, &gtbno, &gtlen, &i)))
> -				goto error0;
> -			XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
> +		if (xfs_alloc_cur_active(acur.bnogt)) {
> +			error = xfs_alloc_get_rec(acur.bnogt, &gtbno, &gtlen, &i);
> +			if (error)
> +				goto out;
> +			XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, out);
>  			busy |= xfs_alloc_compute_aligned(args, gtbno, gtlen,
>  					&gtbnoa, &gtlena, &busy_gen);
>  			if (gtlena >= args->minlen && gtbnoa <= args->max_agbno)
>  				break;
> -			if ((error = xfs_btree_increment(bno_cur_gt, 0, &i)))
> -				goto error0;
> -			if (!i || gtbnoa > args->max_agbno) {
> -				xfs_btree_del_cursor(bno_cur_gt,
> -						     XFS_BTREE_NOERROR);
> -				bno_cur_gt = NULL;
> -			}
> +			error = xfs_btree_increment(acur.bnogt, 0, &i);
> +			if (error)
> +				goto out;
> +			if (!i || gtbnoa > args->max_agbno)
> +				acur.bnogt->bc_private.a.priv.abt.active = false;
>  		}
> -	} while (bno_cur_lt || bno_cur_gt);
> +	} while (xfs_alloc_cur_active(acur.bnolt) ||
> +		 xfs_alloc_cur_active(acur.bnogt));
>  
>  	/*
>  	 * Got both cursors still active, need to find better entry.
>  	 */
> -	if (bno_cur_lt && bno_cur_gt) {
> +	if (xfs_alloc_cur_active(acur.bnolt) &&
> +	    xfs_alloc_cur_active(acur.bnogt)) {
>  		if (ltlena >= args->minlen) {
>  			/*
>  			 * Left side is good, look for a right side entry.
> @@ -1400,7 +1417,7 @@ xfs_alloc_ag_vextent_near(
>  				ltlena, &ltnew);
>  
>  			error = xfs_alloc_find_best_extent(args,
> -						&bno_cur_lt, &bno_cur_gt,
> +						acur.bnolt, acur.bnogt,
>  						ltdiff, &gtbno, &gtlen,
>  						&gtbnoa, &gtlena,
>  						0 /* search right */);
> @@ -1417,22 +1434,21 @@ xfs_alloc_ag_vextent_near(
>  				gtlena, &gtnew);
>  
>  			error = xfs_alloc_find_best_extent(args,
> -						&bno_cur_gt, &bno_cur_lt,
> +						acur.bnogt, acur.bnolt,
>  						gtdiff, &ltbno, &ltlen,
>  						&ltbnoa, &ltlena,
>  						1 /* search left */);
>  		}
>  
>  		if (error)
> -			goto error0;
> +			goto out;
>  	}
>  
>  	/*
>  	 * If we couldn't get anything, give up.
>  	 */
> -	if (bno_cur_lt == NULL && bno_cur_gt == NULL) {
> -		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
> -
> +	if (!xfs_alloc_cur_active(acur.bnolt) &&
> +	    !xfs_alloc_cur_active(acur.bnogt)) {
>  		if (busy) {
>  			trace_xfs_alloc_near_busy(args);
>  			xfs_extent_busy_flush(args->mp, args->pag, busy_gen);
> @@ -1440,7 +1456,7 @@ xfs_alloc_ag_vextent_near(
>  		}
>  		trace_xfs_alloc_size_neither(args);
>  		args->agbno = NULLAGBLOCK;
> -		return 0;
> +		goto out;
>  	}
>  
>  	/*
> @@ -1449,16 +1465,17 @@ xfs_alloc_ag_vextent_near(
>  	 * useful variables to the "left" set so we only have one
>  	 * copy of this code.
>  	 */
> -	if (bno_cur_gt) {
> -		bno_cur_lt = bno_cur_gt;
> -		bno_cur_gt = NULL;
> +	if (xfs_alloc_cur_active(acur.bnogt)) {
> +		bno_cur = acur.bnogt;
>  		ltbno = gtbno;
>  		ltbnoa = gtbnoa;
>  		ltlen = gtlen;
>  		ltlena = gtlena;
>  		j = 1;
> -	} else
> +	} else {
> +		bno_cur = acur.bnolt;
>  		j = 0;
> +	}
>  
>  	/*
>  	 * Fix up the length and compute the useful address.
> @@ -1474,27 +1491,18 @@ xfs_alloc_ag_vextent_near(
>  	ASSERT(ltnew >= args->min_agbno && ltnew <= args->max_agbno);
>  	args->agbno = ltnew;
>  
> -	if ((error = xfs_alloc_fixup_trees(cnt_cur, bno_cur_lt, ltbno, ltlen,
> -			ltnew, rlen, XFSA_FIXUP_BNO_OK)))
> -		goto error0;
> +	error = xfs_alloc_fixup_trees(acur.cnt, bno_cur, ltbno, ltlen, ltnew,
> +				      rlen, XFSA_FIXUP_BNO_OK);
> +	if (error)
> +		goto out;
>  
>  	if (j)
>  		trace_xfs_alloc_near_greater(args);
>  	else
>  		trace_xfs_alloc_near_lesser(args);
>  
> -	xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
> -	xfs_btree_del_cursor(bno_cur_lt, XFS_BTREE_NOERROR);
> -	return 0;
> -
> - error0:
> -	trace_xfs_alloc_near_error(args);
> -	if (cnt_cur != NULL)
> -		xfs_btree_del_cursor(cnt_cur, XFS_BTREE_ERROR);
> -	if (bno_cur_lt != NULL)
> -		xfs_btree_del_cursor(bno_cur_lt, XFS_BTREE_ERROR);
> -	if (bno_cur_gt != NULL)
> -		xfs_btree_del_cursor(bno_cur_gt, XFS_BTREE_ERROR);
> +out:
> +	xfs_alloc_cur_close(&acur, error);
>  	return error;
>  }
>  
> -- 
> 2.20.1
> 
