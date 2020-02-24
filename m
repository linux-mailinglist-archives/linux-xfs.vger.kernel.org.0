Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32D2716A761
	for <lists+linux-xfs@lfdr.de>; Mon, 24 Feb 2020 14:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727448AbgBXNk3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 24 Feb 2020 08:40:29 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:43366 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727378AbgBXNk3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Feb 2020 08:40:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582551627;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pNfRi44Kdy9hpNJmF8z/qDrWgG8yr8NsuVzo8dEvjbQ=;
        b=WX0Eyrcq4czQP1hUIOAKJ2lBVe30ZVUNNCmQpt4OnrCJh+cRBdIU7rCBi45iAXs5ndE3Tw
        q5wgdbJBzg0WN3sqoLS+p3PQUngTweu6CNoaRtI+Y5Ik8cYnOhmSyLlutm/i3Kr6cz46GM
        IZtMR4J9MOFK7SXD/7HCgnFut7vNa8w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-244-EwyZqDdnNc-tXNXOpKQcag-1; Mon, 24 Feb 2020 08:40:25 -0500
X-MC-Unique: EwyZqDdnNc-tXNXOpKQcag-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8AD8C100550E;
        Mon, 24 Feb 2020 13:40:24 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 19F3D9009D;
        Mon, 24 Feb 2020 13:40:23 +0000 (UTC)
Date:   Mon, 24 Feb 2020 08:40:22 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v7 12/19] xfs: Add helper function xfs_attr_rmtval_unmap
Message-ID: <20200224134022.GF15761@bfoster>
References: <20200223020611.1802-1-allison.henderson@oracle.com>
 <20200223020611.1802-13-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200223020611.1802-13-allison.henderson@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Feb 22, 2020 at 07:06:04PM -0700, Allison Collins wrote:
> This function is similar to xfs_attr_rmtval_remove, but adapted to return EAGAIN for
> new transactions. We will use this later when we introduce delayed attributes
> 
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr_remote.c | 28 ++++++++++++++++++++++++++++
>  fs/xfs/libxfs/xfs_attr_remote.h |  1 +
>  2 files changed, 29 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_remote.c b/fs/xfs/libxfs/xfs_attr_remote.c
> index 3de2eec..da40f85 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.c
> +++ b/fs/xfs/libxfs/xfs_attr_remote.c
> @@ -711,3 +711,31 @@ xfs_attr_rmtval_remove(
>  	}
>  	return 0;
>  }
> +
> +/*
> + * Remove the value associated with an attribute by deleting the out-of-line
> + * buffer that it is stored on. Returns EAGAIN for the caller to refresh the
> + * transaction and recall the function
> + */
> +int
> +xfs_attr_rmtval_unmap(
> +	struct xfs_da_args	*args)
> +{
> +	int	error, done;
> +
> +	/*
> +	 * Unmap value blocks for this attr.  This is similar to
> +	 * xfs_attr_rmtval_remove, but open coded here to return EAGAIN
> +	 * for new transactions
> +	 */
> +	error = xfs_bunmapi(args->trans, args->dp,
> +		    args->rmtblkno, args->rmtblkcnt,
> +		    XFS_BMAPI_ATTRFORK, 1, &done);
> +	if (error)
> +		return error;
> +
> +	if (!done)
> +		return -EAGAIN;
> +
> +	return 0;
> +}

Hmm.. any reason this isn't a refactor of the existing remove function?
Just skipping to the end of the series, I see we leave the reference to
xfs_attr_rmtval_remove() (which no longer exists and so is not very
useful) in this comment as well as a stale function declaration in
xfs_attr_remote.h.

I haven't grokked how this is used yet, but it seems like it would be
more appropriate to lift out the transaction handling from the original
function as we have throughout the rest of the code. That could also
mean creating a temporary wrapper (i.e., rmtval_remove() calls
rmtval_unmap()) for the loop/transaction code that could be removed
later if it ends up unused. Either way is much easier to follow than
creating a (currently unused) replacement..

Brian

> diff --git a/fs/xfs/libxfs/xfs_attr_remote.h b/fs/xfs/libxfs/xfs_attr_remote.h
> index eff5f95..e06299a 100644
> --- a/fs/xfs/libxfs/xfs_attr_remote.h
> +++ b/fs/xfs/libxfs/xfs_attr_remote.h
> @@ -14,4 +14,5 @@ int xfs_attr_rmtval_remove(struct xfs_da_args *args);
>  int xfs_attr_rmtval_stale(struct xfs_inode *ip, struct xfs_bmbt_irec *map,
>  		xfs_buf_flags_t incore_flags);
>  int xfs_attr_rmtval_invalidate(struct xfs_da_args *args);
> +int xfs_attr_rmtval_unmap(struct xfs_da_args *args);
>  #endif /* __XFS_ATTR_REMOTE_H__ */
> -- 
> 2.7.4
> 

