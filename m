Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C52A1DF35E
	for <lists+linux-xfs@lfdr.de>; Sat, 23 May 2020 01:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731183AbgEVX5q (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 22 May 2020 19:57:46 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:45852 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731169AbgEVX5p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 May 2020 19:57:45 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04MNppP5072652;
        Fri, 22 May 2020 23:57:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=pnUVgv6igmiTUJSDuACKactnB6ZW8eQRjSpqTyJ5nmc=;
 b=b4os6zpQlJrTcwYwGBIVmKDs8d/FtZd9itX2NlaH81OI3uXeVXjEqVwC33+KsoxRSItc
 TWLRuIdmW4zkVI3/X5338c9GSOjpsogHpNT+ZcjnwqLPqigquF2ALm20CH5LxrY1UZO+
 S2p6afTJRIrywsJEi1ixI2FVme82Kz59U9oxJpm0n1KP9F3GFkQTcKCZvuJPnMV45uAz
 XA+jPvbdZELk53nHGn52nfGu++OxU/56iryadqF/ZzUwYyMbFYcPlXFfwtkrkmMx1Eab
 uJblhf910qYnHI9WBcS4Y/vLDcCwy3nC9fb3Ezy83mG+KoqoOizwhZLL/qcDKtyWWgH6 HA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 3127krr60x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 May 2020 23:57:41 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04MNqb3N162386;
        Fri, 22 May 2020 23:57:40 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 314gmc0xh6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 May 2020 23:57:40 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04MNveO2003362;
        Fri, 22 May 2020 23:57:40 GMT
Received: from localhost (/10.159.153.228)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 May 2020 16:57:39 -0700
Date:   Fri, 22 May 2020 16:57:38 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 21/24] xfs: rename xfs_iflush_int()
Message-ID: <20200522235738.GY8230@magnolia>
References: <20200522035029.3022405-1-david@fromorbit.com>
 <20200522035029.3022405-22-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522035029.3022405-22-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 phishscore=0 mlxscore=0 spamscore=0 suspectscore=5
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005220183
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 mlxscore=0 impostorscore=0
 suspectscore=5 mlxlogscore=999 malwarescore=0 cotscore=-2147483648
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005220183
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 22, 2020 at 01:50:26PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> with xfs_iflush() gone, we can rename xfs_iflush_int() back to
> xfs_iflush(). Also move it up above xfs_iflush_cluster() so we don't
> need the forward definition any more.

So of course git moves xfs_iflush_cluster instead.  Why move 114 lines
when you could move 146? :P

> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Eh, whatever,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_inode.c | 293 ++++++++++++++++++++++-----------------------
>  1 file changed, 146 insertions(+), 147 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index a94528d26328b..cbf8edf62d102 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -44,7 +44,6 @@ kmem_zone_t *xfs_inode_zone;
>   */
>  #define	XFS_ITRUNC_MAX_EXTENTS	2
>  
> -STATIC int xfs_iflush_int(struct xfs_inode *, struct xfs_buf *);
>  STATIC int xfs_iunlink(struct xfs_trans *, struct xfs_inode *);
>  STATIC int xfs_iunlink_remove(struct xfs_trans *, struct xfs_inode *);
>  
> @@ -3429,152 +3428,8 @@ xfs_rename(
>  	return error;
>  }
>  
> -/*
> - * Non-blocking flush of dirty inode metadata into the backing buffer.
> - *
> - * The caller must have a reference to the inode and hold the cluster buffer
> - * locked. The function will walk across all the inodes on the cluster buffer it
> - * can find and lock without blocking, and flush them to the cluster buffer.
> - *
> - * On success, the caller must write out the buffer returned in *bp and
> - * release it. On failure, the filesystem will be shut down, the buffer will
> - * have been unlocked and released, and EFSCORRUPTED will be returned.
> - */
> -int
> -xfs_iflush_cluster(
> -	struct xfs_inode	*ip,
> -	struct xfs_buf		*bp)
> -{
> -	struct xfs_mount	*mp = ip->i_mount;
> -	struct xfs_perag	*pag;
> -	unsigned long		first_index, mask;
> -	int			cilist_size;
> -	struct xfs_inode	**cilist;
> -	struct xfs_inode	*cip;
> -	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
> -	int			error = 0;
> -	int			nr_found;
> -	int			clcount = 0;
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
> -
> -	for (i = 0; i < nr_found; i++) {
> -		cip = cilist[i];
> -
> -		/*
> -		 * because this is an RCU protected lookup, we could find a
> -		 * recently freed or even reallocated inode during the lookup.
> -		 * We need to check under the i_flags_lock for a valid inode
> -		 * here. Skip it if it is not valid or the wrong inode.
> -		 */
> -		spin_lock(&cip->i_flags_lock);
> -		if (!cip->i_ino ||
> -		    __xfs_iflags_test(cip, XFS_ISTALE)) {
> -			spin_unlock(&cip->i_flags_lock);
> -			continue;
> -		}
> -
> -		/*
> -		 * Once we fall off the end of the cluster, no point checking
> -		 * any more inodes in the list because they will also all be
> -		 * outside the cluster.
> -		 */
> -		if ((XFS_INO_TO_AGINO(mp, cip->i_ino) & mask) != first_index) {
> -			spin_unlock(&cip->i_flags_lock);
> -			break;
> -		}
> -		spin_unlock(&cip->i_flags_lock);
> -
> -		/*
> -		 * Do an un-protected check to see if the inode is dirty and
> -		 * is a candidate for flushing.  These checks will be repeated
> -		 * later after the appropriate locks are acquired.
> -		 */
> -		if (xfs_inode_clean(cip) && xfs_ipincount(cip) == 0)
> -			continue;
> -
> -		/*
> -		 * Try to get locks.  If any are unavailable or it is pinned,
> -		 * then this inode cannot be flushed and is skipped.
> -		 */
> -
> -		if (!xfs_ilock_nowait(cip, XFS_ILOCK_SHARED))
> -			continue;
> -		if (!xfs_iflock_nowait(cip)) {
> -			xfs_iunlock(cip, XFS_ILOCK_SHARED);
> -			continue;
> -		}
> -		if (xfs_ipincount(cip)) {
> -			xfs_ifunlock(cip);
> -			xfs_iunlock(cip, XFS_ILOCK_SHARED);
> -			continue;
> -		}
> -
> -
> -		/*
> -		 * Check the inode number again, just to be certain we are not
> -		 * racing with freeing in xfs_reclaim_inode(). See the comments
> -		 * in that function for more information as to why the initial
> -		 * check is not sufficient.
> -		 */
> -		if (!cip->i_ino) {
> -			xfs_ifunlock(cip);
> -			xfs_iunlock(cip, XFS_ILOCK_SHARED);
> -			continue;
> -		}
> -
> -		/*
> -		 * arriving here means that this inode can be flushed.  First
> -		 * re-check that it's dirty before flushing.
> -		 */
> -		if (!xfs_inode_clean(cip)) {
> -			error = xfs_iflush_int(cip, bp);
> -			if (error) {
> -				xfs_iunlock(cip, XFS_ILOCK_SHARED);
> -				goto out_free;
> -			}
> -			clcount++;
> -		} else {
> -			xfs_ifunlock(cip);
> -		}
> -		xfs_iunlock(cip, XFS_ILOCK_SHARED);
> -	}
> -
> -	if (clcount) {
> -		XFS_STATS_INC(mp, xs_icluster_flushcnt);
> -		XFS_STATS_ADD(mp, xs_icluster_flushinode, clcount);
> -	}
> -
> -out_free:
> -	rcu_read_unlock();
> -	kmem_free(cilist);
> -out_put:
> -	xfs_perag_put(pag);
> -	if (error) {
> -		bp->b_flags |= XBF_ASYNC;
> -		xfs_buf_ioend_fail(bp);
> -		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> -	}
> -	return error;
> -}
> -
> -STATIC int
> -xfs_iflush_int(
> +static int
> +xfs_iflush(
>  	struct xfs_inode	*ip,
>  	struct xfs_buf		*bp)
>  {
> @@ -3722,6 +3577,150 @@ xfs_iflush_int(
>  	return error;
>  }
>  
> +/*
> + * Non-blocking flush of dirty inode metadata into the backing buffer.
> + *
> + * The caller must have a reference to the inode and hold the cluster buffer
> + * locked. The function will walk across all the inodes on the cluster buffer it
> + * can find and lock without blocking, and flush them to the cluster buffer.
> + *
> + * On success, the caller must write out the buffer returned in *bp and
> + * release it. On failure, the filesystem will be shut down, the buffer will
> + * have been unlocked and released, and EFSCORRUPTED will be returned.
> + */
> +int
> +xfs_iflush_cluster(
> +	struct xfs_inode	*ip,
> +	struct xfs_buf		*bp)
> +{
> +	struct xfs_mount	*mp = ip->i_mount;
> +	struct xfs_perag	*pag;
> +	unsigned long		first_index, mask;
> +	int			cilist_size;
> +	struct xfs_inode	**cilist;
> +	struct xfs_inode	*cip;
> +	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
> +	int			error = 0;
> +	int			nr_found;
> +	int			clcount = 0;
> +	int			i;
> +
> +	pag = xfs_perag_get(mp, XFS_INO_TO_AGNO(mp, ip->i_ino));
> +
> +	cilist_size = igeo->inodes_per_cluster * sizeof(struct xfs_inode *);
> +	cilist = kmem_alloc(cilist_size, KM_MAYFAIL|KM_NOFS);
> +	if (!cilist)
> +		goto out_put;
> +
> +	mask = ~(igeo->inodes_per_cluster - 1);
> +	first_index = XFS_INO_TO_AGINO(mp, ip->i_ino) & mask;
> +	rcu_read_lock();
> +	/* really need a gang lookup range call here */
> +	nr_found = radix_tree_gang_lookup(&pag->pag_ici_root, (void**)cilist,
> +					first_index, igeo->inodes_per_cluster);
> +	if (nr_found == 0)
> +		goto out_free;
> +
> +	for (i = 0; i < nr_found; i++) {
> +		cip = cilist[i];
> +
> +		/*
> +		 * because this is an RCU protected lookup, we could find a
> +		 * recently freed or even reallocated inode during the lookup.
> +		 * We need to check under the i_flags_lock for a valid inode
> +		 * here. Skip it if it is not valid or the wrong inode.
> +		 */
> +		spin_lock(&cip->i_flags_lock);
> +		if (!cip->i_ino ||
> +		    __xfs_iflags_test(cip, XFS_ISTALE)) {
> +			spin_unlock(&cip->i_flags_lock);
> +			continue;
> +		}
> +
> +		/*
> +		 * Once we fall off the end of the cluster, no point checking
> +		 * any more inodes in the list because they will also all be
> +		 * outside the cluster.
> +		 */
> +		if ((XFS_INO_TO_AGINO(mp, cip->i_ino) & mask) != first_index) {
> +			spin_unlock(&cip->i_flags_lock);
> +			break;
> +		}
> +		spin_unlock(&cip->i_flags_lock);
> +
> +		/*
> +		 * Do an un-protected check to see if the inode is dirty and
> +		 * is a candidate for flushing.  These checks will be repeated
> +		 * later after the appropriate locks are acquired.
> +		 */
> +		if (xfs_inode_clean(cip) && xfs_ipincount(cip) == 0)
> +			continue;
> +
> +		/*
> +		 * Try to get locks.  If any are unavailable or it is pinned,
> +		 * then this inode cannot be flushed and is skipped.
> +		 */
> +
> +		if (!xfs_ilock_nowait(cip, XFS_ILOCK_SHARED))
> +			continue;
> +		if (!xfs_iflock_nowait(cip)) {
> +			xfs_iunlock(cip, XFS_ILOCK_SHARED);
> +			continue;
> +		}
> +		if (xfs_ipincount(cip)) {
> +			xfs_ifunlock(cip);
> +			xfs_iunlock(cip, XFS_ILOCK_SHARED);
> +			continue;
> +		}
> +
> +
> +		/*
> +		 * Check the inode number again, just to be certain we are not
> +		 * racing with freeing in xfs_reclaim_inode(). See the comments
> +		 * in that function for more information as to why the initial
> +		 * check is not sufficient.
> +		 */
> +		if (!cip->i_ino) {
> +			xfs_ifunlock(cip);
> +			xfs_iunlock(cip, XFS_ILOCK_SHARED);
> +			continue;
> +		}
> +
> +		/*
> +		 * arriving here means that this inode can be flushed.  First
> +		 * re-check that it's dirty before flushing.
> +		 */
> +		if (!xfs_inode_clean(cip)) {
> +			error = xfs_iflush(cip, bp);
> +			if (error) {
> +				xfs_iunlock(cip, XFS_ILOCK_SHARED);
> +				goto out_free;
> +			}
> +			clcount++;
> +		} else {
> +			xfs_ifunlock(cip);
> +		}
> +		xfs_iunlock(cip, XFS_ILOCK_SHARED);
> +	}
> +
> +	if (clcount) {
> +		XFS_STATS_INC(mp, xs_icluster_flushcnt);
> +		XFS_STATS_ADD(mp, xs_icluster_flushinode, clcount);
> +	}
> +
> +out_free:
> +	rcu_read_unlock();
> +	kmem_free(cilist);
> +out_put:
> +	xfs_perag_put(pag);
> +	if (error) {
> +		bp->b_flags |= XBF_ASYNC;
> +		xfs_buf_ioend_fail(bp);
> +		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> +	}
> +	return error;
> +}
> +
>  /* Release an inode. */
>  void
>  xfs_irele(
> -- 
> 2.26.2.761.g0e0b3e54be
> 
