Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 258FF54C64
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Jun 2019 12:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbfFYKjS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Jun 2019 06:39:18 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:55886 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726756AbfFYKjS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jun 2019 06:39:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=JtIH7QdSScmE4BXIZTHehIrtIi6sUEd0KCMf0q1HyT0=; b=nOCsqemrV2aI5ZIBzS2pPy/JA
        t8oLLHrxL0KijQbpYQpGij89hKiUMXS51tdw9Ko4ER+48uOCTYU1st8TP8aRTFtN6wcKPJWcOyTvX
        wlsnW7S6B8TW7n12tAiAMbe4jpzwZcPvf8ImxxiZp832DJC2nvOF5P3Sw2mN7fTZyujV4Cc+tElC7
        VtMxJsZxitFCxU3uX0QcuDpR9KV4zE5fw0qr9N1vWePdZCbIydVWl1NEuYhlnRmxZVo2+5fjfCFtI
        UcwF5q7K2w5Jv2a8tEKZJXxiQl9mY2nuST+OxPlbEV6i4Xt5P98lQ1r6LsyYVX5l8vGhnpxrzSLq5
        NIBK+ilhg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hfir7-0001lK-8Z; Tue, 25 Jun 2019 10:39:17 +0000
Date:   Tue, 25 Jun 2019 03:39:17 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org,
        Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 2/6] xfs: account for log space when formatting new AGs
Message-ID: <20190625103917.GD30156@infradead.org>
References: <156114701371.1643538.316410894576032261.stgit@magnolia>
 <156114702648.1643538.14530619220062934565.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156114702648.1643538.14530619220062934565.stgit@magnolia>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 21, 2019 at 12:57:06PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> When we're writing out a fresh new AG, make sure that we don't list an
> internal log as free and that we create the rmap for the region.  growfs
> never does this, but we will need it when we hook up mkfs.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  libxfs/xfs_ag.c |   66 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 66 insertions(+)
> 
> 
> diff --git a/libxfs/xfs_ag.c b/libxfs/xfs_ag.c
> index fe79693e..237d6c53 100644
> --- a/libxfs/xfs_ag.c
> +++ b/libxfs/xfs_ag.c
> @@ -11,6 +11,7 @@
>  #include "xfs_shared.h"
>  #include "xfs_format.h"
>  #include "xfs_trans_resv.h"
> +#include "xfs_bit.h"
>  #include "xfs_sb.h"
>  #include "xfs_mount.h"
>  #include "xfs_btree.h"
> @@ -45,6 +46,12 @@ xfs_get_aghdr_buf(
>  	return bp;
>  }
>  
> +static inline bool is_log_ag(struct xfs_mount *mp, struct aghdr_init_data *id)
> +{
> +	return mp->m_sb.sb_logstart > 0 &&
> +	       id->agno == XFS_FSB_TO_AGNO(mp, mp->m_sb.sb_logstart);
> +}
> +
>  /*
>   * Generic btree root block init function
>   */
> @@ -65,11 +72,50 @@ xfs_freesp_init_recs(
>  	struct aghdr_init_data	*id)
>  {
>  	struct xfs_alloc_rec	*arec;
> +	struct xfs_btree_block	*block = XFS_BUF_TO_BLOCK(bp);
>  
>  	arec = XFS_ALLOC_REC_ADDR(mp, XFS_BUF_TO_BLOCK(bp), 1);
>  	arec->ar_startblock = cpu_to_be32(mp->m_ag_prealloc_blocks);
> +
> +	if (is_log_ag(mp, id)) {
> +		struct xfs_alloc_rec	*nrec;
> +		xfs_agblock_t		start = XFS_FSB_TO_AGBNO(mp,
> +							mp->m_sb.sb_logstart);

This new code is pretty self-contained, maybe it should move into
a separate helper?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
