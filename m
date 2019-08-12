Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A58688A32F
	for <lists+linux-xfs@lfdr.de>; Mon, 12 Aug 2019 18:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbfHLQWU (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 12 Aug 2019 12:22:20 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41930 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbfHLQWU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Aug 2019 12:22:20 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CGJTCh169051
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:22:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=frCNrfHFtfP6NrqUgeYpNC8PWzxSWPRlrUV2xw2T0Cc=;
 b=fmghnDd5rsY2f0B7ZjvSBcoFL5wY/dBPT4VJfladOYq2lJgN+VosMhpUH895FJNuShFx
 0Ox8vF3Bq938Njjda6n4qKGl+1thVZqV/sCtMEHV1jG9Pjkmye9KORFkU1mAV7kHotmV
 reH76rlAY+hoQVROd8/SHPJO61Ml+BUaGCCno/9OiB6BgQFSHEKoFXhMMi+Y0BILG4Nv
 gByyBqgRu2QgoVriXUdKqDKaAuIaEJBbBRF4fOSh6noGJeVMlDit1BVdUcmghRYNio80
 8wamYEmSpAmvFTQzZ3V9lKs6ksjfumKF8OhWFx0bVn55uDCZEvbJUpT2WcWmfSVtxYa9 iw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=frCNrfHFtfP6NrqUgeYpNC8PWzxSWPRlrUV2xw2T0Cc=;
 b=EQwHdTqEN7o9HM58dVY+rdGniVTxFZbOnoskT5Xb6Eq8WZBcbwno+hZUMbkG1XRUjX06
 yl7mmjkpqP32dWmkM4DbpdPWOQkZYGO7hRoLqdsPLE33LdCKkAHp9TcNf9P9eu2Q5zCU
 cg+C16j3dmY+73gO76lGvaXeaYN6uaoefBlzPHdwT+ICkFTMi/4k7ipFqrNdE4YiwVhe
 LD0MYAZT4xWHhmn7qXWoJK60u3PMbBsB9pDv2qNL09PjiOTAhsMEEL/BFanvcjUDdkYX
 FwUDnmfOiusf2g7DsxXpfSkQwWRPZ7IGzUrlkLmOf6piryjMxnM2UG/PgXdzreDco5Hu +A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2u9nvp0rn6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:22:19 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7CGIVWk046964
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:22:18 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2u9n9h21fc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:22:18 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7CGMHAp017332
        for <linux-xfs@vger.kernel.org>; Mon, 12 Aug 2019 16:22:17 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 12 Aug 2019 09:22:17 -0700
Date:   Mon, 12 Aug 2019 09:22:16 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 11/18] xfs: Add xfs_attr3_leaf helper functions
Message-ID: <20190812162216.GZ7138@magnolia>
References: <20190809213726.32336-1-allison.henderson@oracle.com>
 <20190809213726.32336-12-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190809213726.32336-12-allison.henderson@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908120182
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9347 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908120182
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 09, 2019 at 02:37:19PM -0700, Allison Collins wrote:
> And new helper functions xfs_attr3_leaf_flag_is_set and
> xfs_attr3_leaf_flagsflipped.  These routines check to see
> if xfs_attr3_leaf_setflag or xfs_attr3_leaf_flipflags have
> already been run.  We will need this later for delayed
> attributes since routines may be recalled several times
> when -EAGAIN is returned.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr_leaf.c | 78 +++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_attr_leaf.h |  2 ++
>  2 files changed, 80 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 4a22ced..b2d5f62 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -2729,6 +2729,34 @@ xfs_attr3_leaf_clearflag(
>  }
>  
>  /*
> + * Check if the INCOMPLETE flag on an entry in a leaf block is set.
> + */
> +int
> +xfs_attr3_leaf_flag_is_set(
> +	struct xfs_da_args		*args)

<urk> Please don't conflate error codes and a boolean predicate.  It
would be way too easy to do:

if (xfs_attr3_leaf_flag_is_set(&args)) {
	/* launch the nuculur missiles */
}

because there was a disk error and xfs_attr3_leaf_read fed us -EIO.
Either make the callers do the _read and pass the bp to this predicate,
or add a "bool *isset" outparam.

Second potential failure case:

error = xfs_attr3_leaf_flag_is_set(&args);
if (error) {
	/* bury all the whatever */
}

Wherein everything was actually fine, but instead someone incorrectly
freaked out and that's why my neighbors were running chainsaws at 11pm
last night.

> +{
> +	struct xfs_attr_leafblock	*leaf;
> +	struct xfs_attr_leaf_entry	*entry;
> +	struct xfs_buf			*bp;
> +	struct xfs_inode		*dp = args->dp;
> +	int				error = 0;
> +
> +	trace_xfs_attr_leaf_setflag(args);
> +
> +	/*
> +	 * Set up the operation.
> +	 */
> +	error = xfs_attr3_leaf_read(args->trans, dp, args->blkno, -1, &bp);
> +	if (error)
> +		return error;
> +
> +	leaf = bp->b_addr;
> +	entry = &xfs_attr3_leaf_entryp(leaf)[args->index];
> +
> +	return ((entry->flags & XFS_ATTR_INCOMPLETE) != 0);
> +}
> +
> +/*
>   * Set the INCOMPLETE flag on an entry in a leaf block.
>   */
>  int
> @@ -2890,3 +2918,53 @@ xfs_attr3_leaf_flipflags(
>  
>  	return error;
>  }
> +
> +/*
> + * On a leaf entry, check to see if the INCOMPLETE flag is cleared
> + * in args->blkno/index and set in args->blkno2/index2.
> + *
> + * Note that they could be in different blocks, or in the same block.
> + */
> +int
> +xfs_attr3_leaf_flagsflipped(
> +	struct xfs_da_args		*args)
> +{
> +	struct xfs_attr_leafblock	*leaf1;
> +	struct xfs_attr_leafblock	*leaf2;
> +	struct xfs_attr_leaf_entry	*entry1;
> +	struct xfs_attr_leaf_entry	*entry2;
> +	struct xfs_buf			*bp1;
> +	struct xfs_buf			*bp2;
> +	struct xfs_inode		*dp = args->dp;
> +	int				error = 0;
> +
> +	trace_xfs_attr_leaf_flipflags(args);
> +
> +	/*
> +	 * Read the block containing the "old" attr
> +	 */
> +	error = xfs_attr3_leaf_read(args->trans, dp, args->blkno, -1, &bp1);
> +	if (error)
> +		return error;
> +
> +	/*
> +	 * Read the block containing the "new" attr, if it is different
> +	 */
> +	if (args->blkno2 != args->blkno) {
> +		error = xfs_attr3_leaf_read(args->trans, args->dp, args->blkno2,
> +					   -1, &bp2);
> +		if (error)
> +			return error;
> +	} else {
> +		bp2 = bp1;
> +	}
> +
> +	leaf1 = bp1->b_addr;
> +	entry1 = &xfs_attr3_leaf_entryp(leaf1)[args->index];
> +
> +	leaf2 = bp2->b_addr;
> +	entry2 = &xfs_attr3_leaf_entryp(leaf2)[args->index2];
> +
> +	return (((entry1->flags & XFS_ATTR_INCOMPLETE) == 0) &&
> +		 (entry2->flags & XFS_ATTR_INCOMPLETE));

Same complaint here.

--D

> +}
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
> index be1f636..d6afe23 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.h
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.h
> @@ -54,7 +54,9 @@ int	xfs_attr3_leaf_to_shortform(struct xfs_buf *bp,
>  				   struct xfs_da_args *args, int forkoff);
>  int	xfs_attr3_leaf_clearflag(struct xfs_da_args *args);
>  int	xfs_attr3_leaf_setflag(struct xfs_da_args *args);
> +int	xfs_attr3_leaf_flag_is_set(struct xfs_da_args *args);
>  int	xfs_attr3_leaf_flipflags(struct xfs_da_args *args);
> +int	xfs_attr3_leaf_flagsflipped(struct xfs_da_args *args);
>  
>  /*
>   * Routines used for growing the Btree.
> -- 
> 2.7.4
> 
