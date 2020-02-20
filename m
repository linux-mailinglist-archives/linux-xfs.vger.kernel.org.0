Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACB55165F6D
	for <lists+linux-xfs@lfdr.de>; Thu, 20 Feb 2020 15:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728054AbgBTOGV (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 20 Feb 2020 09:06:21 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59975 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727943AbgBTOGV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Feb 2020 09:06:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582207580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yGdXJjMh0krE1mEy2umUlFx3poy6bsxN4yaON/c9bfM=;
        b=Olki4ULDmGUrvOT2B6oqwrkVQV8N2rh2PJ2OyXu7cJTDOGSHC2EBiSCVNQ6NwVanDeSDB0
        YpJYie8Ke13LujIQtnYuKW/8AsIsgGCDr5uctLuVEUF8Y9K2CeAKudv8VcpCsQCmWnh5CG
        iEr1lVmhSBaUWhs4sZppHfHwqIAYuew=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-303-A1lpn3f8OfO2mp11C4sxQQ-1; Thu, 20 Feb 2020 09:06:15 -0500
X-MC-Unique: A1lpn3f8OfO2mp11C4sxQQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 95193800D5B;
        Thu, 20 Feb 2020 14:06:14 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F200A19E9C;
        Thu, 20 Feb 2020 14:06:13 +0000 (UTC)
Date:   Thu, 20 Feb 2020 09:06:12 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/8] libxfs: enable tools to check that metadata updates
 have been committed
Message-ID: <20200220140612.GB48977@bfoster>
References: <158216290180.601264.5491208016048898068.stgit@magnolia>
 <158216292664.601264.186457838279269618.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158216292664.601264.186457838279269618.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 19, 2020 at 05:42:06PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Add a new function that will ensure that everything we changed has
> landed on stable media, and report the results.  Subsequent commits will
> teach the individual programs to report when things go wrong.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  include/xfs_mount.h |    3 +++
>  libxfs/init.c       |   43 +++++++++++++++++++++++++++++++++++++++++++
>  libxfs/libxfs_io.h  |    2 ++
>  libxfs/rdwr.c       |   27 +++++++++++++++++++++++++--
>  4 files changed, 73 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/include/xfs_mount.h b/include/xfs_mount.h
> index 29b3cc1b..c80aaf69 100644
> --- a/include/xfs_mount.h
> +++ b/include/xfs_mount.h
> @@ -187,4 +187,7 @@ extern xfs_mount_t	*libxfs_mount (xfs_mount_t *, xfs_sb_t *,
>  extern void	libxfs_umount (xfs_mount_t *);
>  extern void	libxfs_rtmount_destroy (xfs_mount_t *);
>  
> +void libxfs_flush_devices(struct xfs_mount *mp, int *datadev, int *logdev,
> +		int *rtdev);
> +
>  #endif	/* __XFS_MOUNT_H__ */
> diff --git a/libxfs/init.c b/libxfs/init.c
> index a0d4b7f4..d1d3f4df 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c
> @@ -569,6 +569,8 @@ libxfs_buftarg_alloc(
>  	}
>  	btp->bt_mount = mp;
>  	btp->dev = dev;
> +	btp->lost_writes = false;
> +
>  	return btp;
>  }
>  
> @@ -791,6 +793,47 @@ libxfs_rtmount_destroy(xfs_mount_t *mp)
>  	mp->m_rsumip = mp->m_rbmip = NULL;
>  }
>  
> +static inline int
> +libxfs_flush_buftarg(
> +	struct xfs_buftarg	*btp)
> +{
> +	if (btp->lost_writes)
> +		return -ENOTRECOVERABLE;

I'm curious why we'd want to skip the flush just because some writes
happened to fail..? I suppose the fs might be borked, but it seems a
little strange to at least not try the flush, particularly since we
might still flush any of the other two possible devices.

> +
> +	return libxfs_blkdev_issue_flush(btp);
> +}
> +
> +/*
> + * Purge the buffer cache to write all dirty buffers to disk and free all
> + * incore buffers.  Buffers that cannot be written will cause the lost_writes
> + * flag to be set in the buftarg.  If there were no lost writes, flush the
> + * device to make sure the writes made it to stable storage.
> + *
> + * For each device, the return code will be set to -ENOTRECOVERABLE if we
> + * couldn't write something to disk; or the results of the block device flush
> + * operation.

Why not -EIO?

Brian

> + */
> +void
> +libxfs_flush_devices(
> +	struct xfs_mount	*mp,
> +	int			*datadev,
> +	int			*logdev,
> +	int			*rtdev)
> +{
> +	*datadev = *logdev = *rtdev = 0;
> +
> +	libxfs_bcache_purge();
> +
> +	if (mp->m_ddev_targp)
> +		*datadev = libxfs_flush_buftarg(mp->m_ddev_targp);
> +
> +	if (mp->m_logdev_targp && mp->m_logdev_targp != mp->m_ddev_targp)
> +		*logdev = libxfs_flush_buftarg(mp->m_logdev_targp);
> +
> +	if (mp->m_rtdev_targp)
> +		*rtdev = libxfs_flush_buftarg(mp->m_rtdev_targp);
> +}
> +
>  /*
>   * Release any resource obtained during a mount.
>   */
> diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
> index 579df52b..fc0fd060 100644
> --- a/libxfs/libxfs_io.h
> +++ b/libxfs/libxfs_io.h
> @@ -23,10 +23,12 @@ struct xfs_perag;
>  struct xfs_buftarg {
>  	struct xfs_mount	*bt_mount;
>  	dev_t			dev;
> +	bool			lost_writes;
>  };
>  
>  extern void	libxfs_buftarg_init(struct xfs_mount *mp, dev_t ddev,
>  				    dev_t logdev, dev_t rtdev);
> +int libxfs_blkdev_issue_flush(struct xfs_buftarg *btp);
>  
>  #define LIBXFS_BBTOOFF64(bbs)	(((xfs_off_t)(bbs)) << BBSHIFT)
>  
> diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> index 8b47d438..92e497f9 100644
> --- a/libxfs/rdwr.c
> +++ b/libxfs/rdwr.c
> @@ -17,6 +17,7 @@
>  #include "xfs_inode_fork.h"
>  #include "xfs_inode.h"
>  #include "xfs_trans.h"
> +#include "libfrog/platform.h"
>  
>  #include "libxfs.h"		/* for LIBXFS_EXIT_ON_FAILURE */
>  
> @@ -1227,9 +1228,11 @@ libxfs_brelse(
>  
>  	if (!bp)
>  		return;
> -	if (bp->b_flags & LIBXFS_B_DIRTY)
> +	if (bp->b_flags & LIBXFS_B_DIRTY) {
>  		fprintf(stderr,
>  			"releasing dirty buffer to free list!\n");
> +		bp->b_target->lost_writes = true;
> +	}
>  
>  	pthread_mutex_lock(&xfs_buf_freelist.cm_mutex);
>  	list_add(&bp->b_node.cn_mru, &xfs_buf_freelist.cm_list);
> @@ -1248,9 +1251,11 @@ libxfs_bulkrelse(
>  		return 0 ;
>  
>  	list_for_each_entry(bp, list, b_node.cn_mru) {
> -		if (bp->b_flags & LIBXFS_B_DIRTY)
> +		if (bp->b_flags & LIBXFS_B_DIRTY) {
>  			fprintf(stderr,
>  				"releasing dirty buffer (bulk) to free list!\n");
> +			bp->b_target->lost_writes = true;
> +		}
>  		count++;
>  	}
>  
> @@ -1479,6 +1484,24 @@ libxfs_irele(
>  	kmem_cache_free(xfs_inode_zone, ip);
>  }
>  
> +/*
> + * Flush everything dirty in the kernel and disk write caches to stable media.
> + * Returns 0 for success or a negative error code.
> + */
> +int
> +libxfs_blkdev_issue_flush(
> +	struct xfs_buftarg	*btp)
> +{
> +	int			fd, ret;
> +
> +	if (btp->dev == 0)
> +		return 0;
> +
> +	fd = libxfs_device_to_fd(btp->dev);
> +	ret = platform_flush_device(fd, btp->dev);
> +	return ret ? -errno : 0;
> +}
> +
>  /*
>   * Write out a buffer list synchronously.
>   *
> 

