Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90946399620
	for <lists+linux-xfs@lfdr.de>; Thu,  3 Jun 2021 01:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbhFBXCf (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 2 Jun 2021 19:02:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:46738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229626AbhFBXCf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 2 Jun 2021 19:02:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CDE1613E6;
        Wed,  2 Jun 2021 23:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622674851;
        bh=KC6qdW1O0gAW43urJ80ddt5Q8BSzwyd3uDjFdWlYVB8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hVAIosILRpzr0q+10RmnTw6881NmpOC8t6s/wQrFvjBkcrJ8xN5cJ95rzEvUbIYZp
         5p3Rj3aL0PB1k/vtXJ/4jDEfOdQoprLbZwSdZzdZBpsheFsWTHOJy3dT9nPS76cu5z
         I+DazZaCiSJXzC3+WcFQVsGfH7B6fg1WDn254LaWohoWx2d4OmdCP/qbKNy3tWtyN2
         J07GRNDmF71hE1Fr9wBeRpjD1ip14Z1PT6n0puhF2nas5BytnRRyocgn4jeTV/O+T5
         8CdRLBOzS0fuPNbtATqqhca16z/N/Hlx3b4XfWw6f9eHT3byLE33kdxK8N/TkaE3Gd
         GhyLoGphJzztw==
Date:   Wed, 2 Jun 2021 16:00:51 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: don't take a spinlock unconditionally in the DIO
 fastpath
Message-ID: <20210602230051.GO26380@locust>
References: <20210602215802.24753-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210602215802.24753-1-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 03, 2021 at 07:58:02AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Because this happens at high thread counts on high IOPS devices
> doing mixed read/write AIO-DIO to a single file at about a million
> iops:
> 
>    64.09%     0.21%  [kernel]            [k] io_submit_one
>    - 63.87% io_submit_one
>       - 44.33% aio_write
>          - 42.70% xfs_file_write_iter
>             - 41.32% xfs_file_dio_write_aligned
>                - 25.51% xfs_file_write_checks
>                   - 21.60% _raw_spin_lock
>                      - 21.59% do_raw_spin_lock
>                         - 19.70% __pv_queued_spin_lock_slowpath
> 
> This also happens of the IO completion IO path:
> 
>    22.89%     0.69%  [kernel]            [k] xfs_dio_write_end_io
>    - 22.49% xfs_dio_write_end_io
>       - 21.79% _raw_spin_lock
>          - 20.97% do_raw_spin_lock
>             - 20.10% __pv_queued_spin_lock_slowpath
> 
> IOWs, fio is burning ~14 whole CPUs on this spin lock.
> 
> So, do an unlocked check against inode size first, then if we are
> at/beyond EOF, take the spinlock and recheck. This makes the
> spinlock disappear from the overwrite fastpath.
> 
> I'd like to report that fixing this makes things go faster. It
> doesn't - it just exposes the the XFS_ILOCK as the next severe
> contention point doing extent mapping lookups, and that now burns
> all the 14 CPUs this spinlock was burning.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

Looks good,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_file.c | 42 +++++++++++++++++++++++++++++++-----------
>  1 file changed, 31 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
> index 396ef36dcd0a..c068dcd414f4 100644
> --- a/fs/xfs/xfs_file.c
> +++ b/fs/xfs/xfs_file.c
> @@ -384,21 +384,30 @@ xfs_file_write_checks(
>  		}
>  		goto restart;
>  	}
> +
>  	/*
>  	 * If the offset is beyond the size of the file, we need to zero any
>  	 * blocks that fall between the existing EOF and the start of this
> -	 * write.  If zeroing is needed and we are currently holding the
> -	 * iolock shared, we need to update it to exclusive which implies
> -	 * having to redo all checks before.
> +	 * write.  If zeroing is needed and we are currently holding the iolock
> +	 * shared, we need to update it to exclusive which implies having to
> +	 * redo all checks before.
> +	 *
> +	 * We need to serialise against EOF updates that occur in IO completions
> +	 * here. We want to make sure that nobody is changing the size while we
> +	 * do this check until we have placed an IO barrier (i.e.  hold the
> +	 * XFS_IOLOCK_EXCL) that prevents new IO from being dispatched.  The
> +	 * spinlock effectively forms a memory barrier once we have the
> +	 * XFS_IOLOCK_EXCL so we are guaranteed to see the latest EOF value and
> +	 * hence be able to correctly determine if we need to run zeroing.
>  	 *
> -	 * We need to serialise against EOF updates that occur in IO
> -	 * completions here. We want to make sure that nobody is changing the
> -	 * size while we do this check until we have placed an IO barrier (i.e.
> -	 * hold the XFS_IOLOCK_EXCL) that prevents new IO from being dispatched.
> -	 * The spinlock effectively forms a memory barrier once we have the
> -	 * XFS_IOLOCK_EXCL so we are guaranteed to see the latest EOF value
> -	 * and hence be able to correctly determine if we need to run zeroing.
> +	 * We can do an unlocked check here safely as IO completion can only
> +	 * extend EOF. Truncate is locked out at this point, so the EOF can
> +	 * not move backwards, only forwards. Hence we only need to take the
> +	 * slow path and spin locks when we are at or beyond the current EOF.
>  	 */
> +	if (iocb->ki_pos <= i_size_read(inode))
> +		goto out;
> +
>  	spin_lock(&ip->i_flags_lock);
>  	isize = i_size_read(inode);
>  	if (iocb->ki_pos > isize) {
> @@ -426,7 +435,7 @@ xfs_file_write_checks(
>  			drained_dio = true;
>  			goto restart;
>  		}
> -	
> +
>  		trace_xfs_zero_eof(ip, isize, iocb->ki_pos - isize);
>  		error = iomap_zero_range(inode, isize, iocb->ki_pos - isize,
>  				NULL, &xfs_buffered_write_iomap_ops);
> @@ -435,6 +444,7 @@ xfs_file_write_checks(
>  	} else
>  		spin_unlock(&ip->i_flags_lock);
>  
> +out:
>  	return file_modified(file);
>  }
>  
> @@ -500,7 +510,17 @@ xfs_dio_write_end_io(
>  	 * other IO completions here to update the EOF. Failing to serialise
>  	 * here can result in EOF moving backwards and Bad Things Happen when
>  	 * that occurs.
> +	 *
> +	 * As IO completion only ever extends EOF, we can do an unlocked check
> +	 * here to avoid taking the spinlock. If we land within the current EOF,
> +	 * then we do not need to do an extending update at all, and we don't
> +	 * need to take the lock to check this. If we race with an update moving
> +	 * EOF, then we'll either still be beyond EOF and need to take the lock,
> +	 * or we'll be within EOF and we don't need to take it at all.
>  	 */
> +	if (offset + size <= i_size_read(inode))
> +		goto out;
> +
>  	spin_lock(&ip->i_flags_lock);
>  	if (offset + size > i_size_read(inode)) {
>  		i_size_write(inode, offset + size);
> -- 
> 2.31.1
> 
