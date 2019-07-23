Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A72471B27
	for <lists+linux-xfs@lfdr.de>; Tue, 23 Jul 2019 17:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733015AbfGWPNX (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 23 Jul 2019 11:13:23 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38927 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731731AbfGWPNX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Jul 2019 11:13:23 -0400
Received: by mail-wr1-f68.google.com with SMTP id x4so43561180wrt.6
        for <linux-xfs@vger.kernel.org>; Tue, 23 Jul 2019 08:13:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=4iDqQnOesGHobNYuAPanMINYEtogMNCaHrRbuxMsvE0=;
        b=VM6qVMt21OFjKBRBQ1wUSiESwde1oNOyBJ0qZUxfuPPNW87mEk0nrc7vQ/tgl86hb5
         cvjL69CD6672OtyzoRBZVYWAnAZHJbTWKYjgEX+8O6H2mhj/oa7GdqGRZuQIwaa6kFiF
         Rs+AnTx0HKN6TZCmsnujWfBevapx4k+VzUGqGLvNaXjzCf0Eq2hNvsS1GHpyfhUriyQf
         8qzu24A9f1r+SwwICbcVH1rxwcEndYcIJCaWxaF1CPtA5Wpc3+pdPsO+eTkB8dfD5jt7
         7RbLML1oTpxQgQaR+Y60zSNzwjgeG9MV+9Jaq7dMLAaZTHY0oxe2R2rSqwBzHG+Jy1Qi
         Aj7g==
X-Gm-Message-State: APjAAAX1xLHS8NLrJXoWHqSz5zTijX6HmK8/m+4P7ozFeNaojYcMaFg6
        Vw1rvj/bBgfLE4brTYzEepwb5HleYjQ=
X-Google-Smtp-Source: APXvYqyg3HhSye7i4X5p9x444qWmAuYfufPDnEm74P2z8cee+9tJO2VeOqfGltTDbAF4xsXrzgV6hw==
X-Received: by 2002:adf:eac4:: with SMTP id o4mr79697614wrn.290.1563894801589;
        Tue, 23 Jul 2019 08:13:21 -0700 (PDT)
Received: from orion.maiolino.org (ip-89-103-126-188.net.upcbroadband.cz. [89.103.126.188])
        by smtp.gmail.com with ESMTPSA id h8sm43570078wmf.12.2019.07.23.08.13.20
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 23 Jul 2019 08:13:21 -0700 (PDT)
Date:   Tue, 23 Jul 2019 17:13:19 +0200
From:   Carlos Maiolino <cmaiolino@redhat.com>
To:     linux-xfs@vger.kernel.org
Cc:     jlayton@kernel.org
Subject: Re: [PATCH] xfs: Do not free xfs_extent_busy from inside a spinlock
Message-ID: <20190723151319.j7ynrn2zt4uztby6@orion.maiolino.org>
Mail-Followup-To: linux-xfs@vger.kernel.org, jlayton@kernel.org
References: <20190723150017.31891-1-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190723150017.31891-1-cmaiolino@redhat.com>
User-Agent: NeoMutt/20180716
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I forgot to Cc Jeff on the patch.

Sorry Jeff, cc'ing now.

On Tue, Jul 23, 2019 at 05:00:17PM +0200, Carlos Maiolino wrote:
> xfs_extent_busy_clear_one() calls kmem_free() with the pag spinlock
> locked.
> 
> Fix this by adding a new temporary list, and, make
> xfs_extent_busy_clear_one() to move the extent_busy items to this new
> list, instead of freeing them.
> 
> Free the objects in the temporary list after we drop the pagb_lock
> 
> Reported-by: Jeff Layton <jlayton@kernel.org>
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> ---
>  fs/xfs/xfs_extent_busy.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/xfs/xfs_extent_busy.c b/fs/xfs/xfs_extent_busy.c
> index 0ed68379e551..0a7dcf03340b 100644
> --- a/fs/xfs/xfs_extent_busy.c
> +++ b/fs/xfs/xfs_extent_busy.c
> @@ -523,7 +523,8 @@ STATIC void
>  xfs_extent_busy_clear_one(
>  	struct xfs_mount	*mp,
>  	struct xfs_perag	*pag,
> -	struct xfs_extent_busy	*busyp)
> +	struct xfs_extent_busy	*busyp,
> +	struct list_head	*list)
>  {
>  	if (busyp->length) {
>  		trace_xfs_extent_busy_clear(mp, busyp->agno, busyp->bno,
> @@ -531,8 +532,7 @@ xfs_extent_busy_clear_one(
>  		rb_erase(&busyp->rb_node, &pag->pagb_tree);
>  	}
>  
> -	list_del_init(&busyp->list);
> -	kmem_free(busyp);
> +	list_move(&busyp->list, list);
>  }
>  
>  static void
> @@ -565,6 +565,7 @@ xfs_extent_busy_clear(
>  	struct xfs_perag	*pag = NULL;
>  	xfs_agnumber_t		agno = NULLAGNUMBER;
>  	bool			wakeup = false;
> +	LIST_HEAD(busy_list);
>  
>  	list_for_each_entry_safe(busyp, n, list, list) {
>  		if (busyp->agno != agno) {
> @@ -580,13 +581,18 @@ xfs_extent_busy_clear(
>  		    !(busyp->flags & XFS_EXTENT_BUSY_SKIP_DISCARD)) {
>  			busyp->flags = XFS_EXTENT_BUSY_DISCARDED;
>  		} else {
> -			xfs_extent_busy_clear_one(mp, pag, busyp);
> +			xfs_extent_busy_clear_one(mp, pag, busyp, &busy_list);
>  			wakeup = true;
>  		}
>  	}
>  
>  	if (pag)
>  		xfs_extent_busy_put_pag(pag, wakeup);
> +
> +	list_for_each_entry_safe(busyp, n, &busy_list, list) {
> +		list_del_init(&busyp->list);
> +		kmem_free(busyp);
> +	}
>  }
>  
>  /*
> -- 
> 2.20.1
> 

-- 
Carlos
