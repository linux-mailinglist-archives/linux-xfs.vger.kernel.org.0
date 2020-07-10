Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0C421BA55
	for <lists+linux-xfs@lfdr.de>; Fri, 10 Jul 2020 18:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbgGJQIH (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 10 Jul 2020 12:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgGJQIG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 Jul 2020 12:08:06 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 827F2C08C5CE
        for <linux-xfs@vger.kernel.org>; Fri, 10 Jul 2020 09:08:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=OjQNd9UDNwL8TjR2ocKuDbi2pZjqGGlDtjvWuQrfynE=; b=VOjZGv2bXFYIBAQns1ECFakd5z
        BIijbWgkh975JA6R/7WEQ0t1t5fzPRfIL9WkETUuy95veEdryk6rcc7ttOxhzYSPpgicpx6FQ4qWU
        AaHhokRUb+pWmFJ1ILvW6Re8NnERx0mtL06L28wVIR9Xqdj0OpMe6ClzShEay9SDnlSe2OiwrVgL3
        u5U58jChiqesOmqZLIm2aWpTQ7x5Qb8QhMLxO5dExdg5pjF3XWGcTXlnzF1e8zMyY1Jskn1u7igN9
        gaN1R6Q3Z2Dlp8nYvWFJEhofnJhGNnqik+zLOmqS7RfLfqs8huQZjIntCyv0wGvQ0ohs5I7d9iNeN
        tvnLcoPg==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jtvZE-000304-Hc; Fri, 10 Jul 2020 16:08:04 +0000
Date:   Fri, 10 Jul 2020 17:08:04 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Carlos Maiolino <cmaiolino@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2 1/5] xfs: Remove kmem_zone_alloc() usage
Message-ID: <20200710160804.GA10364@infradead.org>
References: <20200710091536.95828-1-cmaiolino@redhat.com>
 <20200710091536.95828-2-cmaiolino@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200710091536.95828-2-cmaiolino@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 5daef654956cb..8c3fe7ef56e27 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -35,15 +35,20 @@ xfs_inode_alloc(
>  	xfs_ino_t		ino)
>  {
>  	struct xfs_inode	*ip;
> +	gfp_t			gfp_mask = GFP_KERNEL;
>  
>  	/*
> -	 * if this didn't occur in transactions, we could use
> -	 * KM_MAYFAIL and return NULL here on ENOMEM. Set the
> -	 * code up to do this anyway.
> +	 * If this is inside a transaction, we can not fail here,
> +	 * otherwise we can return NULL on ENOMEM.
>  	 */
> -	ip = kmem_zone_alloc(xfs_inode_zone, 0);
> +
> +	if (current->flags & PF_MEMALLOC_NOFS)
> +		gfp_mask |= __GFP_NOFAIL;

I'm a little worried about this change in beavior here.  Can we
just keep the unconditional __GFP_NOFAIL and if we really care do the
change separately after the series?  At that point it should probably
use the re-added PF_FSTRANS flag as well.
