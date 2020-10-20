Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21BD82887BE
	for <lists+linux-xfs@lfdr.de>; Fri,  9 Oct 2020 13:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730740AbgJILSW (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 9 Oct 2020 07:18:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50432 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725908AbgJILSV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 9 Oct 2020 07:18:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602242300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OAvvXNDIqL6v1PpSBZyuRTS1KH+PfHaB5yhigCF+tVE=;
        b=bhIMkHbVUy1IpMvrW61AD8mn9ZzUvA4oklJfTjjtAfgUFibHa2PEqiRPtOlMEG84hSy+y5
        STRTd2Mektn/MFjo1uB8Z4Z62HRqRlfTY29D3mqzDfwEzIYmQuSkdN0M6YIkwSQDr9AZK3
        iiO+mKmY6dRmlOMGKLWfFGW+pYRC/qo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-585-M-16qnNfN2ejOJxrUzYT-A-1; Fri, 09 Oct 2020 07:18:18 -0400
X-MC-Unique: M-16qnNfN2ejOJxrUzYT-A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3E8F380401A;
        Fri,  9 Oct 2020 11:18:17 +0000 (UTC)
Received: from bfoster (ovpn-112-249.rdu2.redhat.com [10.10.112.249])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 31C4E7664E;
        Fri,  9 Oct 2020 11:18:14 +0000 (UTC)
Date:   Fri, 9 Oct 2020 07:18:12 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Eric Sandeen <sandeen@redhat.com>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH v2] xfs_scrub: don't use statvfs to collect filesystem
 summary counts
Message-ID: <20201009111812.GA769470@bfoster>
References: <20201005163737.GE49547@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201005163737.GE49547@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 05, 2020 at 09:37:37AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> The function scrub_scan_estimate_blocks naïvely uses the statvfs counts
> to estimate the size and free blocks on the data volume.  Unfortunately,
> it fails to account for the fact that statvfs can return the size and
> free counts for the realtime volume if the root directory has the
> rtinherit flag set, which leads to phase 7 reporting totally absurd
> quantities.
> 
> Eric pointed out a further problem with statvfs, which is that the file
> counts are clamped to the current user's project quota inode limits.
> Therefore, we must not use statvfs for querying the filesystem summary
> counts.
> 
> The XFS_IOC_FSCOUNTS ioctl returns all the data we need, so use that
> instead.
> 
> Fixes: 604dd3345f35 ("xfs_scrub: filesystem counter collection functions")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
> v2: drop statvfs entirely
> ---

This doesn't seem to apply to for-next..?

Brian

>  scrub/fscounters.c |   27 ++++-----------------------
>  1 file changed, 4 insertions(+), 23 deletions(-)
> 
> diff --git a/scrub/fscounters.c b/scrub/fscounters.c
> index f9d64f8c008f..e9901fcdf6df 100644
> --- a/scrub/fscounters.c
> +++ b/scrub/fscounters.c
> @@ -130,38 +130,19 @@ scrub_scan_estimate_blocks(
>  	unsigned long long		*f_free)
>  {
>  	struct xfs_fsop_counts		fc;
> -	struct xfs_fsop_resblks		rb;
> -	struct statvfs			sfs;
>  	int				error;
>  
> -	/* Grab the fstatvfs counters, since it has to report accurately. */
> -	error = fstatvfs(ctx->mnt.fd, &sfs);
> -	if (error)
> -		return errno;
> -
>  	/* Fetch the filesystem counters. */
>  	error = ioctl(ctx->mnt.fd, XFS_IOC_FSCOUNTS, &fc);
>  	if (error)
>  		return errno;
>  
> -	/*
> -	 * XFS reserves some blocks to prevent hard ENOSPC, so add those
> -	 * blocks back to the free data counts.
> -	 */
> -	error = ioctl(ctx->mnt.fd, XFS_IOC_GET_RESBLKS, &rb);
> -	if (error)
> -		return errno;
> -
> -	sfs.f_bfree += rb.resblks_avail;
> -
> -	*d_blocks = sfs.f_blocks;
> -	if (ctx->mnt.fsgeom.logstart > 0)
> -		*d_blocks += ctx->mnt.fsgeom.logblocks;
> -	*d_bfree = sfs.f_bfree;
> +	*d_blocks = ctx->mnt.fsgeom.datablocks;
> +	*d_bfree = fc.freedata;
>  	*r_blocks = ctx->mnt.fsgeom.rtblocks;
>  	*r_bfree = fc.freertx;
> -	*f_files = sfs.f_files;
> -	*f_free = sfs.f_ffree;
> +	*f_files = fc.allocino;
> +	*f_free = fc.freeino;
>  
>  	return 0;
>  }
> 

