Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE9963499BB
	for <lists+linux-xfs@lfdr.de>; Thu, 25 Mar 2021 19:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbhCYSx3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 Mar 2021 14:53:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:37412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229614AbhCYSxE (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Mar 2021 14:53:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 97CE461A10;
        Thu, 25 Mar 2021 18:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616698383;
        bh=0fENPNKAuigUiDVYWv0p78EnqHlgpWYVBC6ztSSqL0U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TBG9zTsDWp91Syd7EljV2YqoXbRFuoj+FcztekU00W3cKqSfc8JLoGwDEjcqaPK/g
         PMjGvIdILA4VgbuohUIuHFmvTK5MIWXhEwVr+7NYKaXUTl+YY/XpCcNt2wh9/Sx+EW
         li+3J7a8536WnWzBNGH/4m5IwYVopv1OCeMcqiH8aJRhEAs+ilQuvOD1W3292L251R
         fGBcFcKmDhbUxafFbOhvADwUJkagvKwv3wdJSfBCQeDxPsjSWufIhgfW7bzjG7KPQx
         yGZ007T4nj7VnfJCaGmQO1l1QoIF90rSkimnmmznfrWyJ7S6q7d/xRiMJu8UmdQ50P
         2Aiwynz/5R7ew==
Date:   Thu, 25 Mar 2021 11:53:02 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: Fix dax inode extent calculation when direct
 write is performed on an unwritten extent
Message-ID: <20210325185302.GL4090233@magnolia>
References: <20210325140339.6603-1-chandanrlinux@gmail.com>
 <20210325140339.6603-2-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210325140339.6603-2-chandanrlinux@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 25, 2021 at 07:33:39PM +0530, Chandan Babu R wrote:
> With dax enabled filesystems, a direct write operation into an existing
> unwritten extent results in xfs_iomap_write_direct() zero-ing and converting
> the extent into a normal extent before the actual data is copied from the
> userspace buffer.
> 
> The inode extent count can increase by 2 if the extent range being written to
> maps to the middle of the existing unwritten extent range. Hence this commit
> uses XFS_IEXT_WRITE_UNWRITTEN_CNT as the extent count delta when such a write
> operation is being performed.
> 
> Fixes: 727e1acd297c ("xfs: Check for extent overflow when trivally adding a new extent")
> Reported-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>

Pretty much what I was expecting,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_iomap.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
> index e17ab7f42928..8b27c10a3d08 100644
> --- a/fs/xfs/xfs_iomap.c
> +++ b/fs/xfs/xfs_iomap.c
> @@ -198,6 +198,7 @@ xfs_iomap_write_direct(
>  	bool			force = false;
>  	int			error;
>  	int			bmapi_flags = XFS_BMAPI_PREALLOC;
> +	int			nr_exts = XFS_IEXT_ADD_NOSPLIT_CNT;
>  
>  	ASSERT(count_fsb > 0);
>  
> @@ -232,6 +233,7 @@ xfs_iomap_write_direct(
>  		bmapi_flags = XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO;
>  		if (imap->br_state == XFS_EXT_UNWRITTEN) {
>  			force = true;
> +			nr_exts = XFS_IEXT_WRITE_UNWRITTEN_CNT;
>  			dblocks = XFS_DIOSTRAT_SPACE_RES(mp, 0) << 1;
>  		}
>  	}
> @@ -241,8 +243,7 @@ xfs_iomap_write_direct(
>  	if (error)
>  		return error;
>  
> -	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
> -			XFS_IEXT_ADD_NOSPLIT_CNT);
> +	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK, nr_exts);
>  	if (error)
>  		goto out_trans_cancel;
>  
> -- 
> 2.29.2
> 
