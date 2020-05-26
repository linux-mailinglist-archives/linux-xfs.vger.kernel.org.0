Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0800B1DF1F0
	for <lists+linux-xfs@lfdr.de>; Sat, 23 May 2020 00:39:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731127AbgEVWj3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 22 May 2020 18:39:29 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57954 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731029AbgEVWj3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 22 May 2020 18:39:29 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04MMdQXV118409;
        Fri, 22 May 2020 22:39:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=rfKfjtkv5P9/FUh/sPES+33+8wOXunZ5uQQiY+0+yCM=;
 b=uvB/yzvksvfTy2Ww3TfMl0gANt5c2AuB40ubIUm5Gh5Ip4HbDAXb2ZFDPb4WlhHXh8kY
 it6RLaII7Zf1U7uT0inpCS1vZ1PPtNF81+IFUUzZg/lVHLk26q+CX8oA+9KLfthpqKLu
 1ZwhoF7Hh4SZh2FPUn4oOwhFpiutQz0hbLnL8qjCRwlHhaMEaqEimEWVYKLzwVYpWPve
 G0t+nMm4S/6eOgxYZ2B41ovZkDZmxyHKwkYn0oRZI5BBKRHfpmqctCyQMZdRzh+/MDUi
 XkaKfCb5+8rQtZIt90u6R5DT2s9PQzNmRq6B3xxJE3DrNAxIc6ZJaxzW0I6LXzAbSI3x cA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 31284mg08j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 May 2020 22:39:25 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04MMcaqB163182;
        Fri, 22 May 2020 22:39:25 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 314gmbwyvq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 May 2020 22:39:25 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04MMdOCJ031285;
        Fri, 22 May 2020 22:39:24 GMT
Received: from localhost (/10.159.153.228)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 May 2020 15:39:23 -0700
Date:   Fri, 22 May 2020 15:39:22 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/24] xfs: pin inode backing buffer to the inode log item
Message-ID: <20200522223922.GP8230@magnolia>
References: <20200522035029.3022405-1-david@fromorbit.com>
 <20200522035029.3022405-13-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522035029.3022405-13-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 adultscore=0 phishscore=0 mlxscore=0 spamscore=0 suspectscore=5
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2005220176
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=5 mlxscore=0
 cotscore=-2147483648 impostorscore=0 malwarescore=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 spamscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005220176
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 22, 2020 at 01:50:17PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When we dirty an inode, we are going to have to write it disk at
> some point in the near future. This requires the inode cluster
> backing buffer to be present in memory. Unfortunately, under severe
> memory pressure we can reclaim the inode backing buffer while the
> inode is dirty in memory, resulting in stalling the AIL pushing
> because it has to do a read-modify-write cycle on the cluster
> buffer.

RMW, boooo....

> When we have no memory available, the read of the cluster buffer
> blocks the AIL pushing process, and this causes all sorts of issues
> for memory reclaim as it requires inode writeback to make forwards
> progress. Allocating a cluster buffer causes more memory pressure,
> and results in more cluster buffers to be reclaimed, resulting in
> more RMW cycles to be done in the AIL context and everything then
> backs up on AIL progress. Only the synchronous inode cluster
> writeback in the the inode reclaim code provides some level of
> forwards progress guarantees that prevent OOM-killer rampages in
> this situation.
> 
> Fix this by pinning the inode backing buffer to the inode log item
> when the inode is first dirtied (i.e. in xfs_trans_log_inode()).

I'm guessing this is where the "dquots should be converted to use
a similar cluster flushing strategy" in the cover letter applies?

> This may mean the first modification of an inode that has been held
> in cache for a long time may block on a cluster buffer read, but
> we can do that in transaction context and block safely until the
> buffer has been allocated and read.
> 
> Once we have the cluster buffer, the inode log item takes a
> reference to it, pinning it in memory, and attaches it to the log
> item for future reference. This means we can always grab the cluster
> buffer from the inode log item when we need it.
> 
> When the inode is finally cleaned and removed from the AIL, we can
> drop the reference the inode log item holds on the cluster buffer.
> Once all inodes on the cluster buffer are clean, the cluster buffer
> will be unpinned and it will be available for memory reclaim to
> reclaim again.
> 
> This avoids the issues with needing to do RMW cycles in the AIL
> pushing context, and hence allows complete non-blocking inode
> flushing to be performed by the AIL pushing context.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_inode_buf.c   |  3 +-
>  fs/xfs/libxfs/xfs_trans_inode.c | 71 +++++++++++++++++++++++++--------
>  fs/xfs/xfs_inode_item.c         | 63 ++++++++++++++++++++++++-----
>  fs/xfs/xfs_trans_priv.h         | 12 +-----
>  4 files changed, 112 insertions(+), 37 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> index 6f84ea85fdd83..1af97235785c8 100644
> --- a/fs/xfs/libxfs/xfs_inode_buf.c
> +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> @@ -176,7 +176,8 @@ xfs_imap_to_bp(
>  	}
>  
>  	*bpp = bp;
> -	*dipp = xfs_buf_offset(bp, imap->im_boffset);
> +	if (dipp)
> +		*dipp = xfs_buf_offset(bp, imap->im_boffset);
>  	return 0;
>  }
>  
> diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
> index 510b996008221..e130eb2994156 100644
> --- a/fs/xfs/libxfs/xfs_trans_inode.c
> +++ b/fs/xfs/libxfs/xfs_trans_inode.c
> @@ -8,6 +8,8 @@
>  #include "xfs_shared.h"
>  #include "xfs_format.h"
>  #include "xfs_log_format.h"
> +#include "xfs_trans_resv.h"
> +#include "xfs_mount.h"
>  #include "xfs_inode.h"
>  #include "xfs_trans.h"
>  #include "xfs_trans_priv.h"
> @@ -71,13 +73,19 @@ xfs_trans_ichgtime(
>  }
>  
>  /*
> - * This is called to mark the fields indicated in fieldmask as needing
> - * to be logged when the transaction is committed.  The inode must
> - * already be associated with the given transaction.
> + * This is called to mark the fields indicated in fieldmask as needing to be
> + * logged when the transaction is committed.  The inode must already be
> + * associated with the given transaction.
>   *
> - * The values for fieldmask are defined in xfs_inode_item.h.  We always
> - * log all of the core inode if any of it has changed, and we always log
> - * all of the inline data/extents/b-tree root if any of them has changed.
> + * The values for fieldmask are defined in xfs_inode_item.h.  We always log all
> + * of the core inode if any of it has changed, and we always log all of the
> + * inline data/extents/b-tree root if any of them has changed.
> + *
> + * Grab and pin the cluster buffer associated with this inode to avoid RMW
> + * cycles at inode writeback time. Avoid the need to add error handling to every
> + * xfs_trans_log_inode() call by shutting down on read error.  This will cause
> + * transactions to fail and everything to error out, just like if we return a
> + * read error in a dirty transaction and cancel it.
>   */
>  void
>  xfs_trans_log_inode(
> @@ -122,21 +130,52 @@ xfs_trans_log_inode(
>  	}
>  
>  	/*
> -	 * Record the specific change for fdatasync optimisation. This
> -	 * allows fdatasync to skip log forces for inodes that are only
> -	 * timestamp dirty. We do this before the change count so that
> -	 * the core being logged in this case does not impact on fdatasync
> -	 * behaviour.
> +	 * Record the specific change for fdatasync optimisation. This allows
> +	 * fdatasync to skip log forces for inodes that are only timestamp
> +	 * dirty. We do this before the change count so that the core being
> +	 * logged in this case does not impact on fdatasync behaviour.
>  	 */
>  	spin_lock(&iip->ili_lock);
>  	iip->ili_fsync_fields |= flags;
>  
> +	if (!iip->ili_item.li_buf) {
> +		struct xfs_buf	*bp;
> +		int		error;
> +
> +		/*
> +		 * We hold the ILOCK here, so this inode is not going to be
> +		 * flushed while we are here. Further, because there is no
> +		 * buffer attached to the item, we know that there is no IO in
> +		 * progress, so nothing will clear the ili_fields while we read
> +		 * in the buffer. Hence we can safely drop the spin lock and
> +		 * read the buffer knowing that the state will not change from
> +		 * here.
> +		 */
> +		spin_unlock(&iip->ili_lock);
> +		error = xfs_imap_to_bp(ip->i_mount, tp, &ip->i_imap, NULL,
> +					&bp, 0);
> +		if (error) {
> +			xfs_force_shutdown(ip->i_mount, SHUTDOWN_META_IO_ERROR);
> +			return;
> +		}
> +
> +		/*
> +		 * We need an explicit buffer reference for the log item, We
> +		 * don't want the buffer attached to the transaction, so we have
> +		 * to release the transaction reference we just gained.

"We need an explicit buffer reference for the log item but don't want
the buffer to remain attached to the transaction.  Hold the buffer but
release the transaction reference." ?

> +		 */
> +		xfs_buf_hold(bp);
> +		xfs_trans_brelse(tp, bp);
> +
> +		spin_lock(&iip->ili_lock);
> +		iip->ili_item.li_buf = bp;
> +	}
> +
>  	/*
> -	 * Always OR in the bits from the ili_last_fields field.
> -	 * This is to coordinate with the xfs_iflush() and xfs_iflush_done()
> -	 * routines in the eventual clearing of the ili_fields bits.
> -	 * See the big comment in xfs_iflush() for an explanation of
> -	 * this coordination mechanism.
> +	 * Always OR in the bits from the ili_last_fields field.  This is to
> +	 * coordinate with the xfs_iflush() and xfs_iflush_done() routines in
> +	 * the eventual clearing of the ili_fields bits.  See the big comment in
> +	 * xfs_iflush() for an explanation of this coordination mechanism.
>  	 */
>  	flags |= iip->ili_last_fields | iversion_flags;
>  	iip->ili_fields |= flags;
> diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> index 7049f2ae8d186..86173a52526fe 100644
> --- a/fs/xfs/xfs_inode_item.c
> +++ b/fs/xfs/xfs_inode_item.c
> @@ -130,6 +130,8 @@ xfs_inode_item_size(
>  	xfs_inode_item_data_fork_size(iip, nvecs, nbytes);
>  	if (XFS_IFORK_Q(ip))
>  		xfs_inode_item_attr_fork_size(iip, nvecs, nbytes);
> +
> +	ASSERT(iip->ili_item.li_buf);
>  }
>  
>  STATIC void
> @@ -439,6 +441,7 @@ xfs_inode_item_pin(
>  	struct xfs_inode	*ip = INODE_ITEM(lip)->ili_inode;
>  
>  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> +	ASSERT(lip->li_buf);
>  
>  	trace_xfs_inode_pin(ip, _RET_IP_);
>  	atomic_inc(&ip->i_pincount);
> @@ -450,6 +453,12 @@ xfs_inode_item_pin(
>   * item which was previously pinned with a call to xfs_inode_item_pin().
>   *
>   * Also wake up anyone in xfs_iunpin_wait() if the count goes to 0.
> + *
> + * Note that unpin can race with inode cluster buffer freeing marking the buffer
> + * stale. In that case, flush completions are run from the buffer unpin call,
> + * which may happen before the inode is unpinned. If we lose the race, there
> + * will be no buffer attached to the log item, but the inode will be marked
> + * XFS_ISTALE.
>   */
>  STATIC void
>  xfs_inode_item_unpin(
> @@ -459,6 +468,7 @@ xfs_inode_item_unpin(
>  	struct xfs_inode	*ip = INODE_ITEM(lip)->ili_inode;
>  
>  	trace_xfs_inode_unpin(ip, _RET_IP_);
> +	ASSERT(lip->li_buf || xfs_iflags_test(ip, XFS_ISTALE));
>  	ASSERT(atomic_read(&ip->i_pincount) > 0);
>  	if (atomic_dec_and_test(&ip->i_pincount))
>  		wake_up_bit(&ip->i_flags, __XFS_IPINNED_BIT);
> @@ -647,10 +657,15 @@ xfs_inode_item_init(
>   */
>  void
>  xfs_inode_item_destroy(
> -	xfs_inode_t	*ip)
> +	struct xfs_inode	*ip)
>  {
> -	kmem_free(ip->i_itemp->ili_item.li_lv_shadow);
> -	kmem_cache_free(xfs_ili_zone, ip->i_itemp);
> +	struct xfs_inode_log_item *iip = ip->i_itemp;
> +
> +	ASSERT(iip->ili_item.li_buf == NULL);
> +
> +	ip->i_itemp = NULL;
> +	kmem_free(iip->ili_item.li_lv_shadow);
> +	kmem_cache_free(xfs_ili_zone, iip);
>  }
>  
>  
> @@ -665,6 +680,13 @@ xfs_inode_item_destroy(
>   * list for other inodes that will run this function. We remove them from the
>   * buffer list so we can process all the inode IO completions in one AIL lock
>   * traversal.
> + *
> + * Note: Now that we attach the log item to the buffer when we first log the
> + * inode in memory, we can have unflushed inodes on the buffer list here. These
> + * inodes will have a zero ili_last_fields, so skip over them here. We do
> + * this check -after- we've checked for stale inodes, because we're guaranteed
> + * to have XFS_ISTALE set in the case that dirty inodes are in the CIL and have
> + * not yet had their dirtying transactions committed to disk.
>   */
>  void
>  xfs_iflush_done(
> @@ -688,14 +710,16 @@ xfs_iflush_done(
>  			continue;
>  		}
>  
> +		if (!iip->ili_last_fields)
> +			continue;
> +
>  		list_move_tail(&lip->li_bio_list, &tmp);
>  
>  		/* Do an unlocked check for needing the AIL lock. */
> -		if (lip->li_lsn == iip->ili_flush_lsn ||
> +		if (iip->ili_flush_lsn == lip->li_lsn ||
>  		    test_bit(XFS_LI_FAILED, &lip->li_flags))
>  			need_ail++;
>  	}
> -	ASSERT(list_empty(&bp->b_li_list));
>  
>  	/*
>  	 * We only want to pull the item from the AIL if it is actually there
> @@ -708,7 +732,8 @@ xfs_iflush_done(
>  		/* this is an opencoded batch version of xfs_trans_ail_delete */
>  		spin_lock(&ailp->ail_lock);
>  		list_for_each_entry(lip, &tmp, li_bio_list) {
> -			if (lip->li_lsn == INODE_ITEM(lip)->ili_flush_lsn) {
> +			iip = INODE_ITEM(lip);
> +			if (iip->ili_flush_lsn == lip->li_lsn) {
>  				xfs_lsn_t lsn = xfs_ail_delete_one(ailp, lip);
>  				if (!tail_lsn && lsn)
>  					tail_lsn = lsn;
> @@ -725,14 +750,29 @@ xfs_iflush_done(
>  	 * them is safely on disk.
>  	 */
>  	list_for_each_entry_safe(lip, n, &tmp, li_bio_list) {
> +		bool	drop_buffer = false;
> +
>  		list_del_init(&lip->li_bio_list);
>  		iip = INODE_ITEM(lip);
>  
>  		spin_lock(&iip->ili_lock);
>  		iip->ili_last_fields = 0;
> -		spin_unlock(&iip->ili_lock);
> +		iip->ili_flush_lsn = 0;
>  
> +		/*
> +		 * Remove the reference to the cluster buffer if the inode is
> +		 * clean in memory. Drop the buffer reference once we've dropped
> +		 * the locks we hold.
> +		 */
> +		ASSERT(iip->ili_item.li_buf == bp);
> +		if (!iip->ili_fields) {
> +			iip->ili_item.li_buf = NULL;
> +			drop_buffer = true;
> +		}
> +		spin_unlock(&iip->ili_lock);
>  		xfs_ifunlock(iip->ili_inode);
> +		if (drop_buffer)
> +			xfs_buf_rele(bp);
>  	}
>  }
>  
> @@ -747,6 +787,7 @@ xfs_iflush_abort(
>  	struct xfs_inode		*ip)
>  {
>  	struct xfs_inode_log_item	*iip = ip->i_itemp;
> +	struct xfs_buf		*bp = NULL;

Indentation seems inconsistent here.

Other than those two things this looks pretty good to me.

--D

>  
>  	if (iip) {
>  		xfs_trans_ail_delete(&iip->ili_item, 0);
> @@ -758,12 +799,14 @@ xfs_iflush_abort(
>  		iip->ili_last_fields = 0;
>  		iip->ili_fields = 0;
>  		iip->ili_fsync_fields = 0;
> +		iip->ili_flush_lsn = 0;
> +		bp = iip->ili_item.li_buf;
> +		iip->ili_item.li_buf = NULL;
>  		spin_unlock(&iip->ili_lock);
>  	}
> -	/*
> -	 * Release the inode's flush lock since we're done with it.
> -	 */
>  	xfs_ifunlock(ip);
> +	if (bp)
> +		xfs_buf_rele(bp);
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_trans_priv.h b/fs/xfs/xfs_trans_priv.h
> index 3004aeac91102..21ffc6dfcd13e 100644
> --- a/fs/xfs/xfs_trans_priv.h
> +++ b/fs/xfs/xfs_trans_priv.h
> @@ -143,15 +143,10 @@ static inline void
>  xfs_clear_li_failed(
>  	struct xfs_log_item	*lip)
>  {
> -	struct xfs_buf	*bp = lip->li_buf;
> -
>  	ASSERT(test_bit(XFS_LI_IN_AIL, &lip->li_flags));
>  	lockdep_assert_held(&lip->li_ailp->ail_lock);
>  
> -	if (test_and_clear_bit(XFS_LI_FAILED, &lip->li_flags)) {
> -		lip->li_buf = NULL;
> -		xfs_buf_rele(bp);
> -	}
> +	clear_bit(XFS_LI_FAILED, &lip->li_flags);
>  }
>  
>  static inline void
> @@ -161,10 +156,7 @@ xfs_set_li_failed(
>  {
>  	lockdep_assert_held(&lip->li_ailp->ail_lock);
>  
> -	if (!test_and_set_bit(XFS_LI_FAILED, &lip->li_flags)) {
> -		xfs_buf_hold(bp);
> -		lip->li_buf = bp;
> -	}
> +	set_bit(XFS_LI_FAILED, &lip->li_flags);
>  }
>  
>  #endif	/* __XFS_TRANS_PRIV_H__ */
> -- 
> 2.26.2.761.g0e0b3e54be
> 
