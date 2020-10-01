Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24659280535
	for <lists+linux-xfs@lfdr.de>; Thu,  1 Oct 2020 19:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732737AbgJARah (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 1 Oct 2020 13:30:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53161 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732609AbgJARah (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Oct 2020 13:30:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601573435;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=c+bzm6r8nIScoVsJ8XKw/qN94aVBaoKZysHSB3Tr6UA=;
        b=MY0wuNojhKUXTOnZYZPmUQi2zla1OfuSUolc41RSkgmRgzqYN9adRuYZtTCKeojXvZ1o72
        jAFYwMQCL0uS0Qwn+8XrVXu3ZalgyakeI6tGkuKIN16w3GDqmze1345akgqerplcKftgjK
        SeGlsupd6/Uq4jKal5g98oKiSUeb+7c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-16-4WMfU19xMzaM49fUL9i67Q-1; Thu, 01 Oct 2020 13:30:32 -0400
X-MC-Unique: 4WMfU19xMzaM49fUL9i67Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D2539427C6;
        Thu,  1 Oct 2020 17:30:30 +0000 (UTC)
Received: from bfoster (ovpn-116-218.rdu2.redhat.com [10.10.116.218])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EA0687369B;
        Thu,  1 Oct 2020 17:30:29 +0000 (UTC)
Date:   Thu, 1 Oct 2020 13:30:28 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Chinner <dchinner@redhat.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 1/5] xfs: remove xfs_defer_reset
Message-ID: <20201001173028.GC112884@bfoster>
References: <160140139198.830233.3093053332257853111.stgit@magnolia>
 <160140139874.830233.6882281372357115912.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160140139874.830233.6882281372357115912.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 29, 2020 at 10:43:18AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Remove this one-line helper since the assert is trivially true in one
> call site and the rest obscures a bitmask operation.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_defer.c |   24 +++++-------------------
>  1 file changed, 5 insertions(+), 19 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 29e9762f3b77..36c103c14bc9 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -312,22 +312,6 @@ xfs_defer_trans_roll(
>  	return error;
>  }
>  
> -/*
> - * Reset an already used dfops after finish.
> - */
> -static void
> -xfs_defer_reset(
> -	struct xfs_trans	*tp)
> -{
> -	ASSERT(list_empty(&tp->t_dfops));
> -
> -	/*
> -	 * Low mode state transfers across transaction rolls to mirror dfops
> -	 * lifetime. Clear it now that dfops is reset.
> -	 */
> -	tp->t_flags &= ~XFS_TRANS_LOWMODE;
> -}
> -
>  /*
>   * Free up any items left in the list.
>   */
> @@ -477,7 +461,10 @@ xfs_defer_finish(
>  			return error;
>  		}
>  	}
> -	xfs_defer_reset(*tp);
> +
> +	/* Reset LOWMODE now that we've finished all the dfops. */
> +	ASSERT(list_empty(&(*tp)->t_dfops));
> +	(*tp)->t_flags &= ~XFS_TRANS_LOWMODE;
>  	return 0;
>  }
>  
> @@ -551,8 +538,7 @@ xfs_defer_move(
>  	 * that behavior.
>  	 */
>  	dtp->t_flags |= (stp->t_flags & XFS_TRANS_LOWMODE);
> -
> -	xfs_defer_reset(stp);
> +	stp->t_flags &= ~XFS_TRANS_LOWMODE;
>  }
>  
>  /*
> 

