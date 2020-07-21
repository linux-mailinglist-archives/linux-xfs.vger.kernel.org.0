Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AFD1228CA6
	for <lists+linux-xfs@lfdr.de>; Wed, 22 Jul 2020 01:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728007AbgGUXVs (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 21 Jul 2020 19:21:48 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40326 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726555AbgGUXVs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 21 Jul 2020 19:21:48 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06LN1Gtj133796
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 23:21:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=4XagdVeg39OJxLCCQcX++ZEjK83YKsXO/Z3QH2Bj2ZE=;
 b=UdnOfrw4Ye9DIWhwl+efFwxoOJjKNND+N6K++Uv85cM/MukIvZ/TyzDaPnM4S6xmrVEn
 0nBjHJvzCt2glghUqgpDY3lcXNIVutfRM9zu3VnJj2vS9Jr9GsvySUA/c7i+aCELNRvf
 5GwJJIMwMxvfusI7GF4gfolBkA1GBUopXUBL3iwzhooUYGfLMRKTTXL0Bm7IgCVc3kKl
 8wHoSSzPKca4dDoaA737o+fM4rsi4rxMIovcFPSAnAO4MX/QwQMOBNc09zUO1hquLuXB
 528UgCQMDEhnGvsWQNzPZVaCgK+0+LEJRB7Pik88gB95RmRTwZ5wYMDPi1UKL1hKuJaG 0Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 32d6ksmc4c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 23:21:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06LNIA0r037030
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 23:19:46 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 32e9dp2k3y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 23:19:46 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 06LNJjkI009386
        for <linux-xfs@vger.kernel.org>; Tue, 21 Jul 2020 23:19:45 GMT
Received: from localhost (/10.159.147.229)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 21 Jul 2020 16:19:45 -0700
Date:   Tue, 21 Jul 2020 16:19:44 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v11 05/25] xfs: Split apart xfs_attr_leaf_addname
Message-ID: <20200721231944.GG3151642@magnolia>
References: <20200721001606.10781-1-allison.henderson@oracle.com>
 <20200721001606.10781-6-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200721001606.10781-6-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9689 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxlogscore=999
 malwarescore=0 mlxscore=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007210145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9689 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=1
 bulkscore=0 mlxscore=0 mlxlogscore=999 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 spamscore=0 adultscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007210144
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 20, 2020 at 05:15:46PM -0700, Allison Collins wrote:
> Split out new helper function xfs_attr_leaf_try_add from
> xfs_attr_leaf_addname. Because new delayed attribute routines cannot
> roll transactions, we split off the parts of xfs_attr_leaf_addname that
> we can use, and move the commit into the calling function.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_attr.c | 95 +++++++++++++++++++++++++++++++-----------------
>  1 file changed, 61 insertions(+), 34 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index 28a9f8e..6fc6dc6 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -256,10 +256,31 @@ xfs_attr_set_args(
>  		}
>  	}
>  
> -	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
> +	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
>  		error = xfs_attr_leaf_addname(args);
> -	else
> -		error = xfs_attr_node_addname(args);
> +		if (error != -ENOSPC)
> +			return error;
> +
> +		/*
> +		 * Finish any deferred work items and roll the transaction once
> +		 * more.  The goal here is to call node_addname with the inode
> +		 * and transaction in the same state (inode locked and joined,
> +		 * transaction clean) no matter how we got to this step.
> +		 */
> +		error = xfs_defer_finish(&args->trans);
> +		if (error)
> +			return error;
> +
> +		/*
> +		 * Commit the current trans (including the inode) and
> +		 * start a new one.
> +		 */
> +		error = xfs_trans_roll_inode(&args->trans, dp);
> +		if (error)
> +			return error;
> +	}
> +
> +	error = xfs_attr_node_addname(args);
>  	return error;
>  }
>  
> @@ -507,20 +528,21 @@ xfs_attr_shortform_addname(xfs_da_args_t *args)
>   *========================================================================*/
>  
>  /*
> - * Add a name to the leaf attribute list structure
> + * Tries to add an attribute to an inode in leaf form
>   *
> - * This leaf block cannot have a "remote" value, we only call this routine
> - * if bmap_one_block() says there is only one block (ie: no remote blks).
> + * This function is meant to execute as part of a delayed operation and leaves
> + * the transaction handling to the caller.  On success the attribute is added
> + * and the inode and transaction are left dirty.  If there is not enough space,
> + * the attr data is converted to node format and -ENOSPC is returned. Caller is
> + * responsible for handling the dirty inode and transaction or adding the attr
> + * in node format.
>   */
>  STATIC int
> -xfs_attr_leaf_addname(
> -	struct xfs_da_args	*args)
> +xfs_attr_leaf_try_add(
> +	struct xfs_da_args	*args,
> +	struct xfs_buf		*bp)
>  {
> -	struct xfs_buf		*bp;
> -	int			retval, error, forkoff;
> -	struct xfs_inode	*dp = args->dp;
> -
> -	trace_xfs_attr_leaf_addname(args);
> +	int			retval, error;
>  
>  	/*
>  	 * Look up the given attribute in the leaf block.  Figure out if
> @@ -562,31 +584,39 @@ xfs_attr_leaf_addname(
>  	retval = xfs_attr3_leaf_add(bp, args);
>  	if (retval == -ENOSPC) {
>  		/*
> -		 * Promote the attribute list to the Btree format, then
> -		 * Commit that transaction so that the node_addname() call
> -		 * can manage its own transactions.
> +		 * Promote the attribute list to the Btree format. Unless an
> +		 * error occurs, retain the -ENOSPC retval
>  		 */
>  		error = xfs_attr3_leaf_to_node(args);
>  		if (error)
>  			return error;
> -		error = xfs_defer_finish(&args->trans);
> -		if (error)
> -			return error;
> +	}
> +	return retval;
> +out_brelse:
> +	xfs_trans_brelse(args->trans, bp);
> +	return retval;
> +}
>  
> -		/*
> -		 * Commit the current trans (including the inode) and start
> -		 * a new one.
> -		 */
> -		error = xfs_trans_roll_inode(&args->trans, dp);
> -		if (error)
> -			return error;
>  
> -		/*
> -		 * Fob the whole rest of the problem off on the Btree code.
> -		 */
> -		error = xfs_attr_node_addname(args);
> +/*
> + * Add a name to the leaf attribute list structure
> + *
> + * This leaf block cannot have a "remote" value, we only call this routine
> + * if bmap_one_block() says there is only one block (ie: no remote blks).
> + */
> +STATIC int
> +xfs_attr_leaf_addname(
> +	struct xfs_da_args	*args)
> +{
> +	int			error, forkoff;
> +	struct xfs_buf		*bp = NULL;
> +	struct xfs_inode	*dp = args->dp;
> +
> +	trace_xfs_attr_leaf_addname(args);
> +
> +	error = xfs_attr_leaf_try_add(args, bp);
> +	if (error)
>  		return error;
> -	}
>  
>  	/*
>  	 * Commit the transaction that added the attr name so that
> @@ -681,9 +711,6 @@ xfs_attr_leaf_addname(
>  		error = xfs_attr3_leaf_clearflag(args);
>  	}
>  	return error;
> -out_brelse:
> -	xfs_trans_brelse(args->trans, bp);
> -	return retval;
>  }
>  
>  /*
> -- 
> 2.7.4
> 
