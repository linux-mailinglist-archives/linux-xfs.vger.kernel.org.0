Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6194F1B4
	for <lists+linux-xfs@lfdr.de>; Sat, 22 Jun 2019 01:58:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbfFUX6U (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 21 Jun 2019 19:58:20 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37862 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726134AbfFUX6U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Jun 2019 19:58:20 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5LNsLc6156287;
        Fri, 21 Jun 2019 23:58:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=GHsvC12FIvavO6HoWyTHTfU10gcR+FdCbBbrnIK8gdU=;
 b=Jk26imzb3E3UYAkmAAWmIzrmxwmCEoAUJ6yu9RLhyR0h73NrbauoYLeKnaV7tI9ChHaB
 In9mXfG5uF2x29w5oZpsflmCaGSuUUvoGtlI6RDzM0EQpGp6+/uarqT0KKv6sMOqDMN1
 EdSCQ5GqyefgRWRkzEGBjrLBOY7AUoZyU/mr0MtTxXV6s61sR4cbYSSkChpPBIeW+Grq
 t1uyW793iKBsmhel5kCAk2vHXw/GUi1xzBLbctFnVMf+Mf09cwGgwWDqC84sfBxgMDe7
 WGeGfAtOiLlGWCGbTW0P3pNS+aTtytCs60ijymMVZZzUEtX/Dg+itcXQPsAXb5ocO0/p SQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2t7809rq82-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jun 2019 23:58:09 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5LNvKXS171403;
        Fri, 21 Jun 2019 23:58:09 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2t7rdy069b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jun 2019 23:58:09 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x5LNw8Xe021017;
        Fri, 21 Jun 2019 23:58:08 GMT
Received: from localhost (/10.159.131.214)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 21 Jun 2019 16:58:07 -0700
Date:   Fri, 21 Jun 2019 16:58:06 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 02/11] xfs: move small allocation helper
Message-ID: <20190621235806.GA5387@magnolia>
References: <20190522180546.17063-1-bfoster@redhat.com>
 <20190522180546.17063-3-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522180546.17063-3-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9295 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906210182
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9295 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906210182
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 22, 2019 at 02:05:37PM -0400, Brian Foster wrote:
> Move the small allocation helper further up in the file to avoid the
> need for a function declaration. The remaining declarations will be
> removed by followup patches. No functional changes.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_alloc.c | 192 +++++++++++++++++++-------------------
>  1 file changed, 95 insertions(+), 97 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 9751531d3000..b345fe771c54 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -41,8 +41,6 @@ struct workqueue_struct *xfs_alloc_wq;
>  STATIC int xfs_alloc_ag_vextent_exact(xfs_alloc_arg_t *);
>  STATIC int xfs_alloc_ag_vextent_near(xfs_alloc_arg_t *);
>  STATIC int xfs_alloc_ag_vextent_size(xfs_alloc_arg_t *);
> -STATIC int xfs_alloc_ag_vextent_small(xfs_alloc_arg_t *,
> -		xfs_btree_cur_t *, xfs_agblock_t *, xfs_extlen_t *, int *);
>  
>  /*
>   * Size of the AGFL.  For CRC-enabled filesystes we steal a couple of slots in
> @@ -699,6 +697,101 @@ xfs_alloc_update_counters(
>   * Allocation group level functions.
>   */
>  
> +/*
> + * Deal with the case where only small freespaces remain. Either return the
> + * contents of the last freespace record, or allocate space from the freelist if
> + * there is nothing in the tree.
> + */
> +STATIC int			/* error */
> +xfs_alloc_ag_vextent_small(
> +	struct xfs_alloc_arg	*args,	/* allocation argument structure */
> +	struct xfs_btree_cur	*ccur,	/* optional by-size cursor */
> +	xfs_agblock_t		*fbnop,	/* result block number */
> +	xfs_extlen_t		*flenp,	/* result length */
> +	int			*stat)	/* status: 0-freelist, 1-normal/none */
> +{
> +	int			error = 0;
> +	xfs_agblock_t		fbno = NULLAGBLOCK;
> +	xfs_extlen_t		flen = 0;
> +	int			i;
> +
> +	error = xfs_btree_decrement(ccur, 0, &i);
> +	if (error)
> +		goto error;
> +	if (i) {
> +		error = xfs_alloc_get_rec(ccur, &fbno, &flen, &i);
> +		if (error)
> +			goto error;
> +		XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error);
> +		goto out;
> +	}
> +
> +	if (args->minlen != 1 || args->alignment != 1 ||
> +	    args->resv == XFS_AG_RESV_AGFL ||
> +	    (be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_flcount) <=
> +	     args->minleft))
> +		goto out;
> +
> +	error = xfs_alloc_get_freelist(args->tp, args->agbp, &fbno, 0);
> +	if (error)
> +		goto error;
> +	if (fbno == NULLAGBLOCK)
> +		goto out;
> +
> +	xfs_extent_busy_reuse(args->mp, args->agno, fbno, 1,
> +			      xfs_alloc_allow_busy_reuse(args->datatype));
> +
> +	if (xfs_alloc_is_userdata(args->datatype)) {
> +		struct xfs_buf	*bp;
> +
> +		bp = xfs_btree_get_bufs(args->mp, args->tp, args->agno, fbno,
> +					0);
> +		if (!bp) {
> +			error = -EFSCORRUPTED;
> +			goto error;
> +		}
> +		xfs_trans_binval(args->tp, bp);
> +	}
> +	args->len = 1;
> +	args->agbno = fbno;
> +	XFS_WANT_CORRUPTED_GOTO(args->mp,
> +		fbno < be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length),
> +		error);
> +	args->wasfromfl = 1;
> +	trace_xfs_alloc_small_freelist(args);
> +
> +	/*
> +	 * If we're feeding an AGFL block to something that doesn't live in the
> +	 * free space, we need to clear out the OWN_AG rmap.
> +	 */
> +	error = xfs_rmap_free(args->tp, args->agbp, args->agno, fbno, 1,
> +			      &XFS_RMAP_OINFO_AG);
> +	if (error)
> +		goto error;
> +
> +	*stat = 0;
> +	return 0;
> +
> +out:
> +	/*
> +	 * Can't do the allocation, give up.
> +	 */
> +	if (flen < args->minlen) {
> +		args->agbno = NULLAGBLOCK;
> +		trace_xfs_alloc_small_notenough(args);
> +		flen = 0;
> +	}
> +	*fbnop = fbno;
> +	*flenp = flen;
> +	*stat = 1;
> +	trace_xfs_alloc_small_done(args);
> +	return 0;
> +
> +error:
> +	trace_xfs_alloc_small_error(args);
> +	return error;
> +}
> +
>  /*
>   * Allocate a variable extent in the allocation group agno.
>   * Type and bno are used to determine where in the allocation group the
> @@ -1582,101 +1675,6 @@ xfs_alloc_ag_vextent_size(
>  	return 0;
>  }
>  
> -/*
> - * Deal with the case where only small freespaces remain. Either return the
> - * contents of the last freespace record, or allocate space from the freelist if
> - * there is nothing in the tree.
> - */
> -STATIC int			/* error */
> -xfs_alloc_ag_vextent_small(
> -	struct xfs_alloc_arg	*args,	/* allocation argument structure */
> -	struct xfs_btree_cur	*ccur,	/* optional by-size cursor */
> -	xfs_agblock_t		*fbnop,	/* result block number */
> -	xfs_extlen_t		*flenp,	/* result length */
> -	int			*stat)	/* status: 0-freelist, 1-normal/none */
> -{
> -	int			error = 0;
> -	xfs_agblock_t		fbno = NULLAGBLOCK;
> -	xfs_extlen_t		flen = 0;
> -	int			i;
> -
> -	error = xfs_btree_decrement(ccur, 0, &i);
> -	if (error)
> -		goto error;
> -	if (i) {
> -		error = xfs_alloc_get_rec(ccur, &fbno, &flen, &i);
> -		if (error)
> -			goto error;
> -		XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error);
> -		goto out;
> -	}
> -
> -	if (args->minlen != 1 || args->alignment != 1 ||
> -	    args->resv == XFS_AG_RESV_AGFL ||
> -	    (be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_flcount) <=
> -	     args->minleft))
> -		goto out;
> -
> -	error = xfs_alloc_get_freelist(args->tp, args->agbp, &fbno, 0);
> -	if (error)
> -		goto error;
> -	if (fbno == NULLAGBLOCK)
> -		goto out;
> -
> -	xfs_extent_busy_reuse(args->mp, args->agno, fbno, 1,
> -			      xfs_alloc_allow_busy_reuse(args->datatype));
> -
> -	if (xfs_alloc_is_userdata(args->datatype)) {
> -		struct xfs_buf	*bp;
> -
> -		bp = xfs_btree_get_bufs(args->mp, args->tp, args->agno, fbno,
> -					0);
> -		if (!bp) {
> -			error = -EFSCORRUPTED;
> -			goto error;
> -		}
> -		xfs_trans_binval(args->tp, bp);
> -	}
> -	args->len = 1;
> -	args->agbno = fbno;
> -	XFS_WANT_CORRUPTED_GOTO(args->mp,
> -		fbno < be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)->agf_length),
> -		error);
> -	args->wasfromfl = 1;
> -	trace_xfs_alloc_small_freelist(args);
> -
> -	/*
> -	 * If we're feeding an AGFL block to something that doesn't live in the
> -	 * free space, we need to clear out the OWN_AG rmap.
> -	 */
> -	error = xfs_rmap_free(args->tp, args->agbp, args->agno, fbno, 1,
> -			      &XFS_RMAP_OINFO_AG);
> -	if (error)
> -		goto error;
> -
> -	*stat = 0;
> -	return 0;
> -
> -out:
> -	/*
> -	 * Can't do the allocation, give up.
> -	 */
> -	if (flen < args->minlen) {
> -		args->agbno = NULLAGBLOCK;
> -		trace_xfs_alloc_small_notenough(args);
> -		flen = 0;
> -	}
> -	*fbnop = fbno;
> -	*flenp = flen;
> -	*stat = 1;
> -	trace_xfs_alloc_small_done(args);
> -	return 0;
> -
> -error:
> -	trace_xfs_alloc_small_error(args);
> -	return error;
> -}
> -
>  /*
>   * Free the extent starting at agno/bno for length.
>   */
> -- 
> 2.17.2
> 
