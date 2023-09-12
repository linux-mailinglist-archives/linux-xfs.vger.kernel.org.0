Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4865779C181
	for <lists+linux-xfs@lfdr.de>; Tue, 12 Sep 2023 03:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233340AbjILBPR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 11 Sep 2023 21:15:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233384AbjILBPG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Sep 2023 21:15:06 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ACBC174145
        for <linux-xfs@vger.kernel.org>; Mon, 11 Sep 2023 18:02:01 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C53C36AEE;
        Tue, 12 Sep 2023 01:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694480444;
        bh=0ep3Nq8haqw9aPp6HFq0pE5W7iQIvVlYzBY5/aMWVC4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nb0+kNc6vKefDL4IVN4y7ctnjDN0Ml/S7J00P2PUFJ5XW50UbPuJGwvXLvQ2zUZCk
         g+4NFDD2fj+jKoBVAJoxdh9a8nZbIuwO9xzGOzwANGFArMqWrffzPTCNUDPKq/A4KW
         xpFW2D/dGyjVUhneRas90Ot1ZoVvWX+fPxPQXlYsSVQC/bzbXaDqT4pegCELzTSEeH
         2vtcLegjncjn4iMcQWyF/BpSIrg7NEaEvy+NKFD7sP9nixaM2NFHNb/Yyq4nrFddK7
         f+t5OdAAzF1Uk47dcJuj1VEFmaBLhLWcLKGLBp3QMfr0kfOYyNcIdx9hoDkVaodTO0
         fbe0lRV22kWWA==
Date:   Mon, 11 Sep 2023 18:00:42 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: correct calculation for agend and blockcount
Message-ID: <20230912010042.GA28186@frogsfrogsfrogs>
References: <20230828072450.1510248-1-ruansy.fnst@fujitsu.com>
 <20230911104641.331240-1-ruansy.fnst@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230911104641.331240-1-ruansy.fnst@fujitsu.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 11, 2023 at 06:46:41PM +0800, Shiyang Ruan wrote:
> The agend should be "start + length - 1", then, blockcount should be
> "end + 1 - start".  Correct 2 calculation mistakes.
> 
> Fixes: 5cf32f63b0f4 ("xfs: fix the calculation for "end" and "length"")
> Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>

/me notes that "agend" would be better named "range_agend" since it's
not the end of the AG per se; it's the end of the dead region *within*
an AG's agblock space.

With that changed,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_notify_failure.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/xfs/xfs_notify_failure.c b/fs/xfs/xfs_notify_failure.c
> index 4a9bbd3fe120..8b8ef776bdc3 100644
> --- a/fs/xfs/xfs_notify_failure.c
> +++ b/fs/xfs/xfs_notify_failure.c
> @@ -148,10 +148,10 @@ xfs_dax_notify_ddev_failure(
>  			ri_high.rm_startblock = XFS_FSB_TO_AGBNO(mp, end_fsbno);
>  
>  		agf = agf_bp->b_addr;
> -		agend = min(be32_to_cpu(agf->agf_length),
> +		agend = min(be32_to_cpu(agf->agf_length) - 1,
>  				ri_high.rm_startblock);
>  		notify.startblock = ri_low.rm_startblock;
> -		notify.blockcount = agend - ri_low.rm_startblock;
> +		notify.blockcount = agend + 1 - ri_low.rm_startblock;
>  
>  		error = xfs_rmap_query_range(cur, &ri_low, &ri_high,
>  				xfs_dax_failure_fn, &notify);
> -- 
> 2.42.0
> 
