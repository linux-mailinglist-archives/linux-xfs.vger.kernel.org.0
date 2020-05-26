Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE901DF36A
	for <lists+linux-xfs@lfdr.de>; Sat, 23 May 2020 02:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731183AbgEWANl (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 22 May 2020 20:13:41 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54582 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731169AbgEWANk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 May 2020 20:13:40 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04N0C2N3068080;
        Sat, 23 May 2020 00:13:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=odC09usxHeVanhvJbtryyCp6NUmoDCaCwwJ6Y9u4TSQ=;
 b=KNqkCrcAvo8GldktPEJXwNOTAcfPpIO+cMtVDb6gUrvYk9n5WS+NLYOu1XfuVK+gf6U8
 gbpKq/p1mgGWTmViNz9EHZZlfVlbo5g53ov6zu7qGGMfjhwWTOk/qHXAltE+K9Td0P69
 q5LuMsEVW0aqTV03OfAadzY9b9z5wFDOsHtQAg62FlcXiAm5OVh9Bbh6ULEn/uVcxuRb
 ypPL0Q/cHo9v5SxnNVpWxyvDTMICtlJcmANsBdRPz0lB/E0tAG98w76JvMtg/epUiZXc
 Cmz6i8DQsGlhPByAYpzvUhb/FYnzSR9nIVM9bf12R9k1fSLRB/oE0QlV1yZ4AuVKVUfW 6w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 31284mg5mj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 23 May 2020 00:13:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04N0DJDI057348;
        Sat, 23 May 2020 00:13:36 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 312t3g4f78-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 May 2020 00:13:36 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04N0DaMJ028783;
        Sat, 23 May 2020 00:13:36 GMT
Received: from localhost (/10.159.153.228)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 May 2020 17:13:35 -0700
Date:   Fri, 22 May 2020 17:13:34 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 22/24] xfs: rework xfs_iflush_cluster() dirty inode
 iteration
Message-ID: <20200523001334.GZ8230@magnolia>
References: <20200522035029.3022405-1-david@fromorbit.com>
 <20200522035029.3022405-23-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522035029.3022405-23-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=5 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005220186
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=5 mlxscore=0
 cotscore=-2147483648 impostorscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005220186
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 22, 2020 at 01:50:27PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Now that we have all the dirty inodes attached to the cluster
> buffer, we don't actually have to do radix tree lookups to find
> them. Sure, the radix tree is efficient, but walking a linked list
> of just the dirty inodes attached to the buffer is much better.
> 
> We are also no longer dependent on having a locked inode passed into
> the function to determine where to start the lookup. This means we
> can drop it from the function call and treat all inodes the same.
> 
> We also make xfs_iflush_cluster skip inodes marked with
> XFS_IRECLAIM. This we avoid races with inodes that reclaim is
> actively referencing or are being re-initialised by inode lookup. If
> they are actually dirty, they'll get written by a future cluster
> flush....
> 
> We also add a shutdown check after obtaining the flush lock so that
> we catch inodes that are dirty in memory and may have inconsistent
> state due to the shutdown in progress. We abort these inodes
> directly and so they remove themselves directly from the buffer list
> and the AIL rather than having to wait for the buffer to be failed
> and callbacks run to be processed correctly.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_inode.c      | 150 ++++++++++++++++------------------------
>  fs/xfs/xfs_inode.h      |   2 +-
>  fs/xfs/xfs_inode_item.c |  15 +++-
>  3 files changed, 74 insertions(+), 93 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index cbf8edf62d102..7db0f97e537e3 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -3428,7 +3428,7 @@ xfs_rename(
>  	return error;
>  }
>  
> -static int
> +int
>  xfs_iflush(

Not sure why this drops the static?

>  	struct xfs_inode	*ip,
>  	struct xfs_buf		*bp)
> @@ -3590,117 +3590,94 @@ xfs_iflush(
>   */
>  int
>  xfs_iflush_cluster(
> -	struct xfs_inode	*ip,
>  	struct xfs_buf		*bp)
>  {
> -	struct xfs_mount	*mp = ip->i_mount;
> -	struct xfs_perag	*pag;
> -	unsigned long		first_index, mask;
> -	int			cilist_size;
> -	struct xfs_inode	**cilist;
> -	struct xfs_inode	*cip;
> -	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
> -	int			error = 0;
> -	int			nr_found;
> +	struct xfs_mount	*mp = bp->b_mount;
> +	struct xfs_log_item	*lip, *n;
> +	struct xfs_inode	*ip;
> +	struct xfs_inode_log_item *iip;
>  	int			clcount = 0;
> -	int			i;
> -
> -	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
> -
> -	cilist_size = igeo->inodes_per_cluster * sizeof(struct xfs_inode *);
> -	cilist = kmem_alloc(cilist_size, KM_MAYFAIL|KM_NOFS);
> -	if (!cilist)
> -		goto out_put;
> -
> -	mask = ~(igeo->inodes_per_cluster - 1);
> -	first_index = XFS_INO_TO_AGINO(mp, ip->i_ino) & mask;
> -	rcu_read_lock();
> -	/* really need a gang lookup range call here */
> -	nr_found = radix_tree_gang_lookup(&pag->pag_ici_root, (void**)cilist,
> -					first_index, igeo->inodes_per_cluster);
> -	if (nr_found == 0)
> -		goto out_free;
> +	int			error = 0;
>  
> -	for (i = 0; i < nr_found; i++) {
> -		cip = cilist[i];
> +	/*
> +	 * We must use the safe variant here as on shutdown xfs_iflush_abort()
> +	 * can remove itself from the list.
> +	 */
> +	list_for_each_entry_safe(lip, n, &bp->b_li_list, li_bio_list) {
> +		iip = (struct xfs_inode_log_item *)lip;
> +		ip = iip->ili_inode;
>  
>  		/*
> -		 * because this is an RCU protected lookup, we could find a
> -		 * recently freed or even reallocated inode during the lookup.
> -		 * We need to check under the i_flags_lock for a valid inode
> -		 * here. Skip it if it is not valid or the wrong inode.
> +		 * Quick and dirty check to avoid locks if possible.
>  		 */
> -		spin_lock(&cip->i_flags_lock);
> -		if (!cip->i_ino ||
> -		    __xfs_iflags_test(cip, XFS_ISTALE)) {
> -			spin_unlock(&cip->i_flags_lock);
> +		if (__xfs_iflags_test(ip, XFS_IRECLAIM | XFS_IFLOCK))
> +			continue;
> +		if (xfs_ipincount(ip))
>  			continue;
> -		}
>  
>  		/*
> -		 * Once we fall off the end of the cluster, no point checking
> -		 * any more inodes in the list because they will also all be
> -		 * outside the cluster.
> +		 * The inode is still attached to the buffer, which means it is
> +		 * dirty but reclaim might try to grab it. Check carefully for
> +		 * that, and grab the ilock while still holding the i_flags_lock
> +		 * to guarantee reclaim will not be able to reclaim this inode
> +		 * once we drop the i_flags_lock.
>  		 */
> -		if ((XFS_INO_TO_AGINO(mp, cip->i_ino) & mask) != first_index) {
> -			spin_unlock(&cip->i_flags_lock);
> -			break;
> +		spin_lock(&ip->i_flags_lock);
> +		ASSERT(!__xfs_iflags_test(ip, XFS_ISTALE));
> +		if (__xfs_iflags_test(ip, XFS_IRECLAIM | XFS_IFLOCK)) {
> +			spin_unlock(&ip->i_flags_lock);
> +			continue;
>  		}
> -		spin_unlock(&cip->i_flags_lock);
>  
>  		/*
> -		 * Do an un-protected check to see if the inode is dirty and
> -		 * is a candidate for flushing.  These checks will be repeated
> -		 * later after the appropriate locks are acquired.
> +		 * ILOCK will pin the inode against reclaim and prevent
> +		 * concurrent transactions modifying the inode while we are
> +		 * flushing the inode.
>  		 */
> -		if (xfs_inode_clean(cip) && xfs_ipincount(cip) == 0)
> +		if (!xfs_ilock_nowait(ip, XFS_ILOCK_SHARED)) {
> +			spin_unlock(&ip->i_flags_lock);
>  			continue;
> +		}
> +		spin_unlock(&ip->i_flags_lock);
>  
>  		/*
> -		 * Try to get locks.  If any are unavailable or it is pinned,
> -		 * then this inode cannot be flushed and is skipped.
> +		 * Skip inodes that are already flush locked as they have
> +		 * already been written to the buffer.
>  		 */
> -
> -		if (!xfs_ilock_nowait(cip, XFS_ILOCK_SHARED))
> -			continue;
> -		if (!xfs_iflock_nowait(cip)) {
> -			xfs_iunlock(cip, XFS_ILOCK_SHARED);
> +		if (!xfs_iflock_nowait(ip)) {
> +			xfs_iunlock(ip, XFS_ILOCK_SHARED);
>  			continue;
>  		}
> -		if (xfs_ipincount(cip)) {
> -			xfs_ifunlock(cip);
> -			xfs_iunlock(cip, XFS_ILOCK_SHARED);
> -			continue;
> -		}
> -
>  
>  		/*
> -		 * Check the inode number again, just to be certain we are not
> -		 * racing with freeing in xfs_reclaim_inode(). See the comments
> -		 * in that function for more information as to why the initial
> -		 * check is not sufficient.
> +		 * If we are shut down, unpin and abort the inode now as there
> +		 * is no point in flushing it to the buffer just to get an IO
> +		 * completion to abort the buffer and remove it from the AIL.
>  		 */
> -		if (!cip->i_ino) {
> -			xfs_ifunlock(cip);
> -			xfs_iunlock(cip, XFS_ILOCK_SHARED);
> +		if (XFS_FORCED_SHUTDOWN(mp)) {
> +			xfs_iunpin_wait(ip);
> +			/* xfs_iflush_abort() drops the flush lock */
> +			xfs_iflush_abort(ip);
> +			xfs_iunlock(ip, XFS_ILOCK_SHARED);
> +			error = EIO;

error = -EIO?

>  			continue;
>  		}
>  
> -		/*
> -		 * arriving here means that this inode can be flushed.  First
> -		 * re-check that it's dirty before flushing.
> -		 */
> -		if (!xfs_inode_clean(cip)) {
> -			error = xfs_iflush(cip, bp);
> -			if (error) {
> -				xfs_iunlock(cip, XFS_ILOCK_SHARED);
> -				goto out_free;
> -			}
> -			clcount++;
> -		} else {
> -			xfs_ifunlock(cip);
> +		/* don't block waiting on a log force to unpin dirty inodes */
> +		if (xfs_ipincount(ip)) {
> +			xfs_ifunlock(ip);
> +			xfs_iunlock(ip, XFS_ILOCK_SHARED);
> +			continue;
>  		}
> -		xfs_iunlock(cip, XFS_ILOCK_SHARED);
> +
> +		if (!xfs_inode_clean(ip))
> +			error = xfs_iflush(ip, bp);
> +		else
> +			xfs_ifunlock(ip);
> +		xfs_iunlock(ip, XFS_ILOCK_SHARED);
> +		if (error)
> +			break;
> +		clcount++;
>  	}
>  
>  	if (clcount) {
> @@ -3708,11 +3685,6 @@ xfs_iflush_cluster(
>  		XFS_STATS_ADD(mp, xs_icluster_flushinode, clcount);
>  	}
>  
> -out_free:
> -	rcu_read_unlock();
> -	kmem_free(cilist);
> -out_put:
> -	xfs_perag_put(pag);
>  	if (error) {
>  		bp->b_flags |= XBF_ASYNC;
>  		xfs_buf_ioend_fail(bp);
> diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> index d1109eb13ba2e..b93cf9076df8a 100644
> --- a/fs/xfs/xfs_inode.h
> +++ b/fs/xfs/xfs_inode.h
> @@ -427,7 +427,7 @@ int		xfs_log_force_inode(struct xfs_inode *ip);
>  void		xfs_iunpin_wait(xfs_inode_t *);
>  #define xfs_ipincount(ip)	((unsigned int) atomic_read(&ip->i_pincount))
>  
> -int		xfs_iflush_cluster(struct xfs_inode *, struct xfs_buf *);
> +int		xfs_iflush_cluster(struct xfs_buf *);
>  void		xfs_lock_two_inodes(struct xfs_inode *ip0, uint ip0_mode,
>  				struct xfs_inode *ip1, uint ip1_mode);
>  
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 42b4b5fe1e2a9..af4764f97a339 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -523,11 +523,20 @@ xfs_inode_item_push(
>  	}
>  	spin_unlock(&lip->li_ailp->ail_lock);
>  
> -	error = xfs_iflush_cluster(ip, bp);
> +	/*
> +	 * We need to hold a reference for flushing the cluster buffer as it may
> +	 * fail the buffer without IO submission. In which case, we better have
> +	 * a reference for that completion as otherwise we don't get a reference
> +	 * for IO until we queue it for delwri submission.

<confused>

What completion are we talking about?  Does this refer to the fact that
xfs_iflush_cluster handles a flush failure by simulating an async write
failure which could result in us giving away the inode log item's
reference to the buffer?

--D

> +	 */
> +	xfs_buf_hold(bp);
> +	error = xfs_iflush_cluster(bp);
>  	if (!error) {
> -		if (!xfs_buf_delwri_queue(bp, buffer_list))
> +		if (!xfs_buf_delwri_queue(bp, buffer_list)) {
> +			ASSERT(0);
>  			rval = XFS_ITEM_FLUSHING;
> -		xfs_buf_unlock(bp);
> +		}
> +		xfs_buf_relse(bp);
>  	} else {
>  		rval = XFS_ITEM_LOCKED;
>  	}
> -- 
> 2.26.2.761.g0e0b3e54be
> 
