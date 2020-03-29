Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D82D71970DC
	for <lists+linux-xfs@lfdr.de>; Mon, 30 Mar 2020 00:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728938AbgC2WqG (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 29 Mar 2020 18:46:06 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:33338 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727591AbgC2WqF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 29 Mar 2020 18:46:05 -0400
Received: from dread.disaster.area (pa49-179-23-206.pa.nsw.optusnet.com.au [49.179.23.206])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id A82013A3029;
        Mon, 30 Mar 2020 09:46:03 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jIggs-0005Nh-5M; Mon, 30 Mar 2020 09:46:02 +1100
Date:   Mon, 30 Mar 2020 09:46:02 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: trylock underlying buffer on dquot flush
Message-ID: <20200329224602.GT10776@dread.disaster.area>
References: <20200326131703.23246-1-bfoster@redhat.com>
 <20200326131703.23246-2-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326131703.23246-2-bfoster@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=n/Z79dAqQwRlp4tcgfhWYA==:117 a=n/Z79dAqQwRlp4tcgfhWYA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=xuOJAi8C3-RupNdIJdcA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 26, 2020 at 09:17:02AM -0400, Brian Foster wrote:
> A dquot flush currently blocks on the buffer lock for the underlying
> dquot buffer. In turn, this causes xfsaild to block rather than
> continue processing other items in the meantime. Update
> xfs_qm_dqflush() to trylock the buffer, similar to how inode buffers
> are handled, and return -EAGAIN if the lock fails. Fix up any
> callers that don't currently handle the error properly.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_dquot.c      |  6 +++---
>  fs/xfs/xfs_dquot_item.c |  3 ++-
>  fs/xfs/xfs_qm.c         | 14 +++++++++-----
>  3 files changed, 14 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 711376ca269f..af2c8e5ceea0 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -1105,8 +1105,8 @@ xfs_qm_dqflush(
>  	 * Get the buffer containing the on-disk dquot
>  	 */
>  	error = xfs_trans_read_buf(mp, NULL, mp->m_ddev_targp, dqp->q_blkno,
> -				   mp->m_quotainfo->qi_dqchunklen, 0, &bp,
> -				   &xfs_dquot_buf_ops);
> +				   mp->m_quotainfo->qi_dqchunklen, XBF_TRYLOCK,
> +				   &bp, &xfs_dquot_buf_ops);
>  	if (error)
>  		goto out_unlock;
>  
> @@ -1177,7 +1177,7 @@ xfs_qm_dqflush(
>  
>  out_unlock:
>  	xfs_dqfunlock(dqp);
> -	return -EIO;
> +	return error;
>  }
>  
>  /*
> diff --git a/fs/xfs/xfs_dquot_item.c b/fs/xfs/xfs_dquot_item.c
> index cf65e2e43c6e..baad1748d0d1 100644
> --- a/fs/xfs/xfs_dquot_item.c
> +++ b/fs/xfs/xfs_dquot_item.c
> @@ -189,7 +189,8 @@ xfs_qm_dquot_logitem_push(
>  		if (!xfs_buf_delwri_queue(bp, buffer_list))
>  			rval = XFS_ITEM_FLUSHING;
>  		xfs_buf_relse(bp);
> -	}
> +	} else if (error == -EAGAIN)
> +		rval = XFS_ITEM_LOCKED;

Doesn't xfs_inode_item_push() also have this problem in that it
doesn't handle -EAGAIN properly?

Also, we can get -EIO, -EFSCORRUPTED, etc here. They probably
shouldn't return XFS_ITEM_SUCCESS, either....

Otherwise seems OK.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
