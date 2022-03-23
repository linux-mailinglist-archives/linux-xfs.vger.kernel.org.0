Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CD934E5A79
	for <lists+linux-xfs@lfdr.de>; Wed, 23 Mar 2022 22:11:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240870AbiCWVNU (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 23 Mar 2022 17:13:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240625AbiCWVNT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Mar 2022 17:13:19 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 62A5138797
        for <linux-xfs@vger.kernel.org>; Wed, 23 Mar 2022 14:11:49 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-150-27.pa.vic.optusnet.com.au [49.186.150.27])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 24A4210E5083;
        Thu, 24 Mar 2022 08:11:48 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nX8Gh-0093R3-15; Thu, 24 Mar 2022 08:11:47 +1100
Date:   Thu, 24 Mar 2022 08:11:47 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/6] xfs: fix infinite loop when reserving free block pool
Message-ID: <20220323211147.GX1544202@dread.disaster.area>
References: <164779460699.550479.5112721232994728564.stgit@magnolia>
 <164779462946.550479.3987400627869935198.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164779462946.550479.3987400627869935198.stgit@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=623b8d14
        a=sPqof0Mm7fxWrhYUF33ZaQ==:117 a=sPqof0Mm7fxWrhYUF33ZaQ==:17
        a=kj9zAlcOel0A:10 a=o8Y5sQTvuykA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=pEW31Y1e3stFNrKW6rsA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Mar 20, 2022 at 09:43:49AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Don't spin in an infinite loop trying to reserve blocks -- if we can't
> do it after 30 tries, we're racing with a nearly full filesystem, so
> just give up.
> 
> Cc: Brian Foster <bfoster@redhat.com>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> ---
>  fs/xfs/xfs_fsops.c |   12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> index 710e857bb825..615334e4f689 100644
> --- a/fs/xfs/xfs_fsops.c
> +++ b/fs/xfs/xfs_fsops.c
> @@ -379,6 +379,7 @@ xfs_reserve_blocks(
>  	int64_t			fdblks_delta = 0;
>  	uint64_t		request;
>  	int64_t			free;
> +	unsigned int		tries;
>  	int			error = 0;
>  
>  	/* If inval is null, report current values and return */
> @@ -430,9 +431,16 @@ xfs_reserve_blocks(
>  	 * If the request is larger than the current reservation, reserve the
>  	 * blocks before we update the reserve counters. Sample m_fdblocks and
>  	 * perform a partial reservation if the request exceeds free space.
> +	 *
> +	 * The loop body estimates how many blocks it can request from fdblocks
> +	 * to stash in the reserve pool.  This is a classic TOCTOU race since
> +	 * fdblocks updates are not always coordinated via m_sb_lock.  We also
> +	 * cannot tell if @free remaining unchanged between iterations is due
> +	 * to an idle system or freed blocks being consumed immediately, so
> +	 * we'll try a finite number of times to satisfy the request.
>  	 */
>  	error = -ENOSPC;
> -	do {
> +	for (tries = 0; tries < 30 && error == -ENOSPC; tries++) {
>  		free = percpu_counter_sum(&mp->m_fdblocks) -
>  						xfs_fdblocks_unavailable(mp);
>  		if (free <= 0)
> @@ -459,7 +467,7 @@ xfs_reserve_blocks(
>  		spin_unlock(&mp->m_sb_lock);
>  		error = xfs_mod_fdblocks(mp, -fdblks_delta, 0);
>  		spin_lock(&mp->m_sb_lock);
> -	} while (error == -ENOSPC);
> +	}

So the problem here is that if we don't get all of the reservation,
we get none of it, so we try again. This seems like we should simply
punch the error back out to userspace and let it retry rather than
try a few times and then fail anyway. Either way, userspace has to
handle failure to reserve enough blocks.

The other alternative here is that we just change the reserve block
limit when ENOSPC occurs and allow the xfs_mod_fdblocks() refill
code just fill up the pool as space is freed. That would greatly
simplify the code - we do a single attempt to reserve the new space,
and if it fails we don't care because the reserve space gets
refilled before free space is made available again.  I think that's
preferable to having an arbitrary number of retries like this that's
going to end up failing anyway.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
