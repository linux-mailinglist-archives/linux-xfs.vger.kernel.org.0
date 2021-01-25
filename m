Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78A45302C27
	for <lists+linux-xfs@lfdr.de>; Mon, 25 Jan 2021 21:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731745AbhAYUDF (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 25 Jan 2021 15:03:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:36464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726573AbhAYUC6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 25 Jan 2021 15:02:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BE0D224F9;
        Mon, 25 Jan 2021 20:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611604937;
        bh=i52u3YbdnDP+ktgFox9DJTuLW9KZskyQqKKsPQmXjY4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nwGLNHWpeZRBbO7oUuoYzHzTSwX24Jj/TwKfClgin68yuGNqRC2Cd8+XXbAm4T2UL
         48qIEHYomRRZTbuc/rhnWJF65yTVh9EzJ+p4GXq+2Mcvty8UscoFIpThREnvQ9g7Ee
         YSXP2zpDGQwhhjVSmJYf7/YtL9+OKOKf58FyiCFkKETuzSabpYFOtZmAvnOHNJJHbc
         2ENfLqVOWN5r2DdUgcjYbLOBFQPQpDyeUod2kmnMZdSDTEKKMerPikahsGZvLYBArG
         vfPtFdj02eE0chKJfCnd947Mrx4VQPRERq7/2F1ISC3m33MR2THEbqvvEsB3O4WH8S
         2lVcBkr34oL5g==
Date:   Mon, 25 Jan 2021 12:02:16 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 11/11] xfs: flush speculative space allocations when we
 run out of space
Message-ID: <20210125200216.GE7698@magnolia>
References: <161142791950.2171939.3320927557987463636.stgit@magnolia>
 <161142798066.2171939.9311024588681972086.stgit@magnolia>
 <20210124094816.GE670331@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210124094816.GE670331@infradead.org>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jan 24, 2021 at 09:48:16AM +0000, Christoph Hellwig wrote:
> > +retry:
> >  	/*
> >  	 * Allocate the handle before we do our freeze accounting and setting up
> >  	 * GFP_NOFS allocation context so that we avoid lockdep false positives
> > @@ -285,6 +289,22 @@ xfs_trans_alloc(
> >  	tp->t_firstblock = NULLFSBLOCK;
> >  
> >  	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
> > +	if (error == -ENOSPC && tries > 0) {
> > +		xfs_trans_cancel(tp);
> > +
> > +		/*
> > +		 * We weren't able to reserve enough space for the transaction.
> > +		 * Flush the other speculative space allocations to free space.
> > +		 * Do not perform a synchronous scan because callers can hold
> > +		 * other locks.
> > +		 */
> > +		error = xfs_blockgc_free_space(mp, NULL);
> > +		if (error)
> > +			return error;
> > +
> > +		tries--;
> > +		goto retry;
> > +	}
> >  	if (error) {
> >  		xfs_trans_cancel(tp);
> >  		return error;
> 
> Why do we need to restart the whole function?  A failing
> xfs_trans_reserve should restore tp to its initial state, and keeping
> the SB_FREEZE_FS counter increased also doesn't look harmful as far as
> I can tell.  So why not:
> 
> 	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
> 	if (error == -ENOSPC) {
> 		/*
> 		 * We weren't able to reserve enough space for the transaction.
> 		 * Flush the other speculative space allocations to free space.
> 		 * Do not perform a synchronous scan because callers can hold
> 		 * other locks.
> 		 */
> 		error = xfs_blockgc_free_space(mp, NULL);

xfs_blockgc_free_space runs the blockgc scan directly, which means that
it creates transactions to free blocks.  Since we can't have nested
transactions, we have to drop tp here.

--D

> 		if (error)
> 			return error;
> 		error = xfs_trans_reserve(tp, resp, blocks, rtextents);
> 	}
>  	if (error) {
>   		xfs_trans_cancel(tp);
>   		return error;
> 
> ?
