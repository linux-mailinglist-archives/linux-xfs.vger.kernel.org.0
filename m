Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78BE8578FCB
	for <lists+linux-xfs@lfdr.de>; Tue, 19 Jul 2022 03:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbiGSBWh (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 18 Jul 2022 21:22:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbiGSBWh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Jul 2022 21:22:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C55A1401C
        for <linux-xfs@vger.kernel.org>; Mon, 18 Jul 2022 18:22:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 133C56171D
        for <linux-xfs@vger.kernel.org>; Tue, 19 Jul 2022 01:22:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ED66C341C0;
        Tue, 19 Jul 2022 01:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658193755;
        bh=4ci+jKQi3RxCkLx+4WQMxPNf3e2ZPaMKzzgKwCXnl8E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KYwrhPnSGe3JhECRqeG4eyfw41jccX8H78SYp7mzcOMKHTYRJpNKYe1Eq75XdjAA1
         Zfa9bUZoWDUcpY+HNKb4gP2obcJIip0efiu3EbQDhNuRWCrS3abWtNDFXBGsmDnIM4
         j0AVM3MbTVVYjBtqvljYK6prrnoXdz/U6zILpUe6CGn/ascZpmoSZqp1K/2RvHWSmS
         FbzW6Zbjtt9ZBeHO10Qo4G4lOENL6idska7p2OGD8AVtQx+2ddZCDtucVS7Lo1TeZ8
         oc/OcGJQ7qj/HOa5xFbebd9rpvYGWcbE165qjIb1hR99fiSskDYCca1yyqCMtOw7G1
         VhYXKdz5eT9Lw==
Date:   Mon, 18 Jul 2022 18:22:34 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: xfs_buf cache destroy isn't RCU safe
Message-ID: <YtYHWhonQ2D2Ff1f@magnolia>
References: <20220718235851.1940837-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220718235851.1940837-1-david@fromorbit.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 19, 2022 at 09:58:51AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Darrick and Sachin Sant reported that xfs/435 and xfs/436 would
> report an non-empty xfs_buf slab on module remove. This isn't easily
> to reproduce, but is clearly a side effect of converting the buffer
> caceh to RUC freeing and lockless lookups. Sachin bisected and
> Darrick hit it when testing the patchset directly.
> 
> Turns out that the xfs_buf slab is not destroyed when all the other
> XFS slab caches are destroyed. Instead, it's got it's own little
> wrapper function that gets called separately, and so it doesn't have
> an rcu_barrier() call in it that is needed to drain all the rcu
> callbacks before the slab is destroyed.
> 
> Fix it by removing the xfs_buf_init/terminate wrappers that just
> allocate and destroy the xfs_buf slab, and move them to the same
> place that all the other slab caches are set up and destroyed.
> 
> Reported-and-tested-by: Sachin Sant <sachinp@linux.ibm.com>
> Fixes: 298f34224506 ("xfs: lockless buffer lookup")
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Makes sense to put the slab teardown in the same place as all the other
slab teardowns,

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_buf.c   | 25 +------------------------
>  fs/xfs/xfs_buf.h   |  6 ++----
>  fs/xfs/xfs_super.c | 22 +++++++++++++---------
>  3 files changed, 16 insertions(+), 37 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index ccc09dc27e46..8878b0069854 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -21,7 +21,7 @@
>  #include "xfs_error.h"
>  #include "xfs_ag.h"
>  
> -static struct kmem_cache *xfs_buf_cache;
> +struct kmem_cache *xfs_buf_cache;
>  
>  /*
>   * Locking orders
> @@ -2302,29 +2302,6 @@ xfs_buf_delwri_pushbuf(
>  	return error;
>  }
>  
> -int __init
> -xfs_buf_init(void)
> -{
> -	xfs_buf_cache = kmem_cache_create("xfs_buf", sizeof(struct xfs_buf), 0,
> -					 SLAB_HWCACHE_ALIGN |
> -					 SLAB_RECLAIM_ACCOUNT |
> -					 SLAB_MEM_SPREAD,
> -					 NULL);
> -	if (!xfs_buf_cache)
> -		goto out;
> -
> -	return 0;
> -
> - out:
> -	return -ENOMEM;
> -}
> -
> -void
> -xfs_buf_terminate(void)
> -{
> -	kmem_cache_destroy(xfs_buf_cache);
> -}
> -
>  void xfs_buf_set_ref(struct xfs_buf *bp, int lru_ref)
>  {
>  	/*
> diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
> index d5a9c5ce763d..a561f6ee4c1d 100644
> --- a/fs/xfs/xfs_buf.h
> +++ b/fs/xfs/xfs_buf.h
> @@ -15,6 +15,8 @@
>  #include <linux/uio.h>
>  #include <linux/list_lru.h>
>  
> +extern struct kmem_cache *xfs_buf_cache;
> +
>  /*
>   *	Base types
>   */
> @@ -306,10 +308,6 @@ extern int xfs_buf_delwri_submit(struct list_head *);
>  extern int xfs_buf_delwri_submit_nowait(struct list_head *);
>  extern int xfs_buf_delwri_pushbuf(struct xfs_buf *, struct list_head *);
>  
> -/* Buffer Daemon Setup Routines */
> -extern int xfs_buf_init(void);
> -extern void xfs_buf_terminate(void);
> -
>  static inline xfs_daddr_t xfs_buf_daddr(struct xfs_buf *bp)
>  {
>  	return bp->b_maps[0].bm_bn;
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 4edee1d3784a..3d27ba1295c9 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -1967,11 +1967,19 @@ xfs_init_caches(void)
>  {
>  	int		error;
>  
> +	xfs_buf_cache = kmem_cache_create("xfs_buf", sizeof(struct xfs_buf), 0,
> +					 SLAB_HWCACHE_ALIGN |
> +					 SLAB_RECLAIM_ACCOUNT |
> +					 SLAB_MEM_SPREAD,
> +					 NULL);
> +	if (!xfs_buf_cache)
> +		goto out;
> +
>  	xfs_log_ticket_cache = kmem_cache_create("xfs_log_ticket",
>  						sizeof(struct xlog_ticket),
>  						0, 0, NULL);
>  	if (!xfs_log_ticket_cache)
> -		goto out;
> +		goto out_destroy_buf_cache;
>  
>  	error = xfs_btree_init_cur_caches();
>  	if (error)
> @@ -2145,6 +2153,8 @@ xfs_init_caches(void)
>  	xfs_btree_destroy_cur_caches();
>   out_destroy_log_ticket_cache:
>  	kmem_cache_destroy(xfs_log_ticket_cache);
> + out_destroy_buf_cache:
> +	kmem_cache_destroy(xfs_buf_cache);
>   out:
>  	return -ENOMEM;
>  }
> @@ -2178,6 +2188,7 @@ xfs_destroy_caches(void)
>  	xfs_defer_destroy_item_caches();
>  	xfs_btree_destroy_cur_caches();
>  	kmem_cache_destroy(xfs_log_ticket_cache);
> +	kmem_cache_destroy(xfs_buf_cache);
>  }
>  
>  STATIC int __init
> @@ -2283,13 +2294,9 @@ init_xfs_fs(void)
>  	if (error)
>  		goto out_destroy_wq;
>  
> -	error = xfs_buf_init();
> -	if (error)
> -		goto out_mru_cache_uninit;
> -
>  	error = xfs_init_procfs();
>  	if (error)
> -		goto out_buf_terminate;
> +		goto out_mru_cache_uninit;
>  
>  	error = xfs_sysctl_register();
>  	if (error)
> @@ -2346,8 +2353,6 @@ init_xfs_fs(void)
>  	xfs_sysctl_unregister();
>   out_cleanup_procfs:
>  	xfs_cleanup_procfs();
> - out_buf_terminate:
> -	xfs_buf_terminate();
>   out_mru_cache_uninit:
>  	xfs_mru_cache_uninit();
>   out_destroy_wq:
> @@ -2373,7 +2378,6 @@ exit_xfs_fs(void)
>  	kset_unregister(xfs_kset);
>  	xfs_sysctl_unregister();
>  	xfs_cleanup_procfs();
> -	xfs_buf_terminate();
>  	xfs_mru_cache_uninit();
>  	xfs_destroy_workqueues();
>  	xfs_destroy_caches();
> -- 
> 2.36.1
> 
