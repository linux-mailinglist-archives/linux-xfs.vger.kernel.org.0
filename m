Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB9E16A6EF
	for <lists+linux-xfs@lfdr.de>; Mon, 24 Feb 2020 14:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727463AbgBXNIZ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 24 Feb 2020 08:08:25 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:54040 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727329AbgBXNIZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 08:08:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582549704;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tdHX9Ijap1Y/i8uK8LbFHnduNII7HYnql/xq/ZViYp4=;
        b=gizmG5mCZ1KuYNyn16nNRPWv2cp5xbxOiDj83/gibgj+N9RXF+Dl/Ho7Jd9SXRwt+34Q6k
        Dq6NLMc3MjbsrF6WDgXwLdWatc0E/puRwXy2plv5dHGfJ8BppoO3z3OzAJnxIJJAolNGy0
        EYqjAjLfX7sOUacyUVCsvSIrc+yvIVk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-Sco8nawNMaaI5WjsluK-Rg-1; Mon, 24 Feb 2020 08:08:22 -0500
X-MC-Unique: Sco8nawNMaaI5WjsluK-Rg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CA1B018C8C00;
        Mon, 24 Feb 2020 13:08:21 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6DF741CB;
        Mon, 24 Feb 2020 13:08:21 +0000 (UTC)
Date:   Mon, 24 Feb 2020 08:08:19 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v7 08/19] xfs: Refactor xfs_attr_try_sf_addname
Message-ID: <20200224130819.GD15761@bfoster>
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-9-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200223020611.1802-9-allison.henderson@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Feb 22, 2020 at 07:06:00PM -0700, Allison Collins wrote:
> To help pre-simplify xfs_attr_set_args, we need to hoist transacation handling up,
> while modularizing the adjacent code down into helpers. In this patch, hoist the
> commit in xfs_attr_try_sf_addname up into the calling function, and also pull the
> attr list creation down.
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_attr.c | 30 +++++++++++++++---------------
>  1 file changed, 15 insertions(+), 15 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index b2f0780..71298b9 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -227,8 +227,13 @@ xfs_attr_try_sf_addname(
>  	struct xfs_da_args	*args)
>  {
>  
> -	struct xfs_mount	*mp = dp->i_mount;
> -	int			error, error2;
> +	int			error;
> +
> +	/*
> +	 * Build initial attribute list (if required).
> +	 */
> +	if (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS)
> +		xfs_attr_shortform_create(args);
>  
>  	error = xfs_attr_shortform_addname(args);
>  	if (error == -ENOSPC)
> @@ -241,12 +246,10 @@ xfs_attr_try_sf_addname(
>  	if (!error && (args->name.type & ATTR_KERNOTIME) == 0)
>  		xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
>  
> -	if (mp->m_flags & XFS_MOUNT_WSYNC)
> +	if (dp->i_mount->m_flags & XFS_MOUNT_WSYNC)
>  		xfs_trans_set_sync(args->trans);
>  
> -	error2 = xfs_trans_commit(args->trans);
> -	args->trans = NULL;
> -	return error ? error : error2;
> +	return error;
>  }
>  
>  /*
> @@ -258,7 +261,7 @@ xfs_attr_set_args(
>  {
>  	struct xfs_inode	*dp = args->dp;
>  	struct xfs_buf          *leaf_bp = NULL;
> -	int			error;
> +	int			error, error2 = 0;
>  
>  	/*
>  	 * If the attribute list is non-existent or a shortform list,
> @@ -269,17 +272,14 @@ xfs_attr_set_args(
>  	     dp->i_d.di_anextents == 0)) {
>  
>  		/*
> -		 * Build initial attribute list (if required).
> -		 */
> -		if (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS)
> -			xfs_attr_shortform_create(args);
> -
> -		/*
>  		 * Try to add the attr to the attribute list in the inode.
>  		 */
>  		error = xfs_attr_try_sf_addname(dp, args);
> -		if (error != -ENOSPC)
> -			return error;
> +		if (error != -ENOSPC) {
> +			error2 = xfs_trans_commit(args->trans);
> +			args->trans = NULL;
> +			return error ? error : error2;
> +		}
>  
>  		/*
>  		 * It won't fit in the shortform, transform to a leaf block.
> -- 
> 2.7.4
> 

