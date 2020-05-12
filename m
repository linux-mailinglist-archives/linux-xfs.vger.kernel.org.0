Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A83F1CF933
	for <lists+linux-xfs@lfdr.de>; Tue, 12 May 2020 17:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbgELPby (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 12 May 2020 11:31:54 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:33944 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726492AbgELPby (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 May 2020 11:31:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589297512;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2DSBsIXd5qFYB/MeTnZBlOyzq/6V8crP7+jirrwYBfc=;
        b=cEnIaOCOjs3+K4unWMzXKF/eO93B/wq5bqYBg9nDQIO4B8vYLQm0MrRljwN8NLsMO/yz2w
        E401D5d+lcyB4KJKDCE5Hi/LqaArZ60MARK+ByuXLi+IUvvvV22TM/TlL1rC3sLB7NsqB/
        xExoFXFBoW2B/dwPBpJ+NefSn/2wGu0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-K9iGlYGbPZ6Sxm4nD5wJlQ-1; Tue, 12 May 2020 11:31:51 -0400
X-MC-Unique: K9iGlYGbPZ6Sxm4nD5wJlQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EF2E6107BA6C;
        Tue, 12 May 2020 15:31:49 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 821BD60BF1;
        Tue, 12 May 2020 15:31:49 +0000 (UTC)
Date:   Tue, 12 May 2020 11:31:47 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: remove xfs_ifree_local_data
Message-ID: <20200512153147.GG37029@bfoster>
References: <20200510072404.986627-1-hch@lst.de>
 <20200510072404.986627-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200510072404.986627-4-hch@lst.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, May 10, 2020 at 09:24:01AM +0200, Christoph Hellwig wrote:
> xfs_ifree only need to free inline data in the data fork, as we've
> already taken care of the attr fork before (and in fact freed the
> fork structure).  Just open code the freeing of the inline data.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_inode.c | 30 ++++++++++--------------------
>  1 file changed, 10 insertions(+), 20 deletions(-)
> 
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 549ff468b7b60..7d3144dc99b72 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -2711,24 +2711,6 @@ xfs_ifree_cluster(
>  	return 0;
>  }
>  
> -/*
> - * Free any local-format buffers sitting around before we reset to
> - * extents format.
> - */
> -static inline void
> -xfs_ifree_local_data(
> -	struct xfs_inode	*ip,
> -	int			whichfork)
> -{
> -	struct xfs_ifork	*ifp;
> -
> -	if (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_LOCAL)
> -		return;
> -
> -	ifp = XFS_IFORK_PTR(ip, whichfork);
> -	xfs_idata_realloc(ip, -ifp->if_bytes, whichfork);
> -}
> -
>  /*
>   * This is called to return an inode to the inode free list.
>   * The inode should already be truncated to 0 length and have
> @@ -2765,8 +2747,16 @@ xfs_ifree(
>  	if (error)
>  		return error;
>  
> -	xfs_ifree_local_data(ip, XFS_DATA_FORK);
> -	xfs_ifree_local_data(ip, XFS_ATTR_FORK);
> +	/*
> +	 * Free any local-format data sitting around before we reset the
> +	 * data fork to extents format.  Note that the attr fork data has
> +	 * already been freed by xfs_attr_inactive.
> +	 */
> +	if (ip->i_d.di_format == XFS_DINODE_FMT_LOCAL) {
> +		kmem_free(ip->i_df.if_u1.if_data);
> +		ip->i_df.if_u1.if_data = NULL;
> +		ip->i_df.if_bytes = 0;
> +	}
>  
>  	VFS_I(ip)->i_mode = 0;		/* mark incore inode as free */
>  	ip->i_d.di_flags = 0;
> -- 
> 2.26.2
> 

