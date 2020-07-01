Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22C382106C7
	for <lists+linux-xfs@lfdr.de>; Wed,  1 Jul 2020 10:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728780AbgGAI4Y (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 1 Jul 2020 04:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbgGAI4X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Jul 2020 04:56:23 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53365C061755
        for <linux-xfs@vger.kernel.org>; Wed,  1 Jul 2020 01:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=kj1C/TlrKNBcpqoRBEwmf0Q8pO4M4eIprFNM7YUOikg=; b=Jj5GOeF7uxta8BmJoyem5NyQYw
        hvm06pvSub81hDIeev95WcR0oR6VM9i+I5R9ssQ9bczYEx5SERBfwx4cWficU+IZIqdrOt6nmPa06
        06IZPj9z6kNbz7OPRUEtsE1tVkx8I7RmYdZdf2IUYrEwmbV2jJ82DEsaq+QXoXo8gApK+uWL8V6KL
        k4awZQW7MBOCD8mvIQAr7ea+k1mYnfg1toK81bsmBJFRdLN62ItRJExnmvclQNfAPTGDptxxvII7S
        wsLxABUCHlHVbRa29wcF2TVsg1LedmjckCCqqRPOSrtkJJbAkbj0lelpaWTE7vh6YBYTeODn6NHH/
        M4Lch+LQ==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jqYXV-0007vf-Tm; Wed, 01 Jul 2020 08:56:22 +0000
Date:   Wed, 1 Jul 2020 09:56:21 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/18] xfs: refactor quota exceeded test
Message-ID: <20200701085621.GN25171@infradead.org>
References: <159353170983.2864738.16885438169173786208.stgit@magnolia>
 <159353180004.2864738.3571543752803090361.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159353180004.2864738.3571543752803090361.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 30, 2020 at 08:43:20AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor the open-coded test for whether or not we're over quota.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_dquot.c |   95 ++++++++++++++++------------------------------------
>  1 file changed, 30 insertions(+), 65 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> index 35a113d1b42b..ef34c82c28a0 100644
> --- a/fs/xfs/xfs_dquot.c
> +++ b/fs/xfs/xfs_dquot.c
> @@ -97,6 +97,33 @@ xfs_qm_adjust_dqlimits(
>  		xfs_dquot_set_prealloc_limits(dq);
>  }
>  
> +/*
> + * Determine if this quota counter is over either limit and set the quota
> + * timers as appropriate.
> + */
> +static inline void
> +xfs_qm_adjust_res_timer(
> +	struct xfs_dquot_res	*res,
> +	struct xfs_def_qres	*dres)
> +{
> +	bool			over;
> +
> +#ifdef DEBUG
> +	if (res->hardlimit)
> +		ASSERT(res->softlimit <= res->hardlimit);
> +#endif

Maybe:
	ASSERRT(!res->hardlimit || res->softlimit <= res->hardlimit);

> +
> +	over = (res->softlimit && res->count > res->softlimit) ||
> +	       (res->hardlimit && res->count > res->hardlimit);
> +
> +	if (over && res->timer == 0)
> +		res->timer = ktime_get_real_seconds() + dres->timelimit;
> +	else if (!over && res->timer != 0)
> +		res->timer = 0;
> +	else if (!over && res->timer == 0)
> +		res->warnings = 0;

What about:

	if ((res->softlimit && res->count > res->softlimit) ||
	    (res->hardlimit && res->count > res->hardlimit)) {
		if (res->timer == 0)	
			res->timer = ktime_get_real_seconds() + dres->timelimit;
	} else {
		if (res->timer)
			res->timer = 0;
		else
			res->warnings = 0;
	}
