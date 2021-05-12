Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E129D37EF1A
	for <lists+linux-xfs@lfdr.de>; Thu, 13 May 2021 01:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbhELW6y (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 12 May 2021 18:58:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:38020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237507AbhELW4w (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 12 May 2021 18:56:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92D4761352;
        Wed, 12 May 2021 22:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620860143;
        bh=fn0TI4lZDOB9OVLMmRL88vJI096TeH/KoyRuyMfc/b0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=k4ulHQG7d3vNsb6vzd7IMBaIZG7ivw5U2xmtd/aO8uMSsWRoEQ9aeQU54oZXwg0wT
         uSF5igoQwg5O3+8Pmmlyaf6NFCSnpp22ivhGXFWOlm/J0YMD2edu8f+5hTIBEmdJhj
         5ZunB5wTICHsB5+rhYDAI20XZGNT36eMlpazPn0GHKnJug4X7a37X7HJokCGGdmfz4
         1XiCXnelNoG//uC1+Ib06zezFLTSyegPzclvJEa4VobudFocGak21XwvSYCJwx/o90
         Sykbanvcor7ZUHo1I6GV6Hgdxce7/4LkJV6cyumrFYKrnYZoSfT6SbC5L4sBDVLB38
         oOGkmnAHPLgdA==
Date:   Wed, 12 May 2021 15:55:42 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 17/22] xfs: simplify xfs_dialloc_select_ag() return values
Message-ID: <20210512225542.GL8582@magnolia>
References: <20210506072054.271157-1-david@fromorbit.com>
 <20210506072054.271157-18-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210506072054.271157-18-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 06, 2021 at 05:20:49PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The only caller of xfs_dialloc_select_ag() will always return
> -ENOSPC to it's caller if the agbp returned from
> xfs_dialloc_select_ag() is NULL. IOWs, failure to find a candidate
> AGI we can allocate inodes from is always an ENOSPC condition, so
> move this logic up into xfs_dialloc_select_ag() so we can simplify
> the return logic in this function.
> 
> xfs_dialloc_select_ag() now only ever returns 0 with a locked
> agbp, or an error with no agbp.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

Woo nice cleanup!
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/libxfs/xfs_ialloc.c | 23 ++++++++---------------
>  fs/xfs/xfs_inode.c         |  3 ---
>  2 files changed, 8 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> index 4540fbcd68a3..872591e8f5cb 100644
> --- a/fs/xfs/libxfs/xfs_ialloc.c
> +++ b/fs/xfs/libxfs/xfs_ialloc.c
> @@ -1717,7 +1717,7 @@ xfs_dialloc_roll(
>   * This function will ensure that the selected AG has free inodes available to
>   * allocate from. The selected AGI will be returned locked to the caller, and it
>   * will allocate more free inodes if required. If no free inodes are found or
> - * can be allocated, no AGI will be returned.
> + * can be allocated, -ENOSPC be returned.
>   */
>  int
>  xfs_dialloc_select_ag(
> @@ -1730,7 +1730,6 @@ xfs_dialloc_select_ag(
>  	struct xfs_buf		*agbp;
>  	xfs_agnumber_t		agno;
>  	int			error;
> -	bool			noroom = false;
>  	xfs_agnumber_t		start_agno;
>  	struct xfs_perag	*pag;
>  	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
> @@ -1744,7 +1743,7 @@ xfs_dialloc_select_ag(
>  	 */
>  	start_agno = xfs_ialloc_ag_select(*tpp, parent, mode);
>  	if (start_agno == NULLAGNUMBER)
> -		return 0;
> +		return -ENOSPC;
>  
>  	/*
>  	 * If we have already hit the ceiling of inode blocks then clear
> @@ -1757,7 +1756,6 @@ xfs_dialloc_select_ag(
>  	if (igeo->maxicount &&
>  	    percpu_counter_read_positive(&mp->m_icount) + igeo->ialloc_inos
>  							> igeo->maxicount) {
> -		noroom = true;
>  		okalloc = false;
>  	}
>  
> @@ -1794,10 +1792,8 @@ xfs_dialloc_select_ag(
>  		if (error)
>  			break;
>  
> -		if (pag->pagi_freecount) {
> -			xfs_perag_put(pag);
> +		if (pag->pagi_freecount)
>  			goto found_ag;
> -		}
>  
>  		if (!okalloc)
>  			goto nextag_relse_buffer;
> @@ -1805,9 +1801,6 @@ xfs_dialloc_select_ag(
>  		error = xfs_ialloc_ag_alloc(*tpp, agbp, pag);
>  		if (error < 0) {
>  			xfs_trans_brelse(*tpp, agbp);
> -
> -			if (error == -ENOSPC)
> -				error = 0;
>  			break;
>  		}
>  
> @@ -1818,12 +1811,11 @@ xfs_dialloc_select_ag(
>  			 * allocate one of the new inodes.
>  			 */
>  			ASSERT(pag->pagi_freecount > 0);
> -			xfs_perag_put(pag);
>  
>  			error = xfs_dialloc_roll(tpp, agbp);
>  			if (error) {
>  				xfs_buf_relse(agbp);
> -				return error;
> +				break;
>  			}
>  			goto found_ag;
>  		}
> @@ -1831,16 +1823,17 @@ xfs_dialloc_select_ag(
>  nextag_relse_buffer:
>  		xfs_trans_brelse(*tpp, agbp);
>  nextag:
> -		xfs_perag_put(pag);
>  		if (++agno == mp->m_sb.sb_agcount)
>  			agno = 0;
>  		if (agno == start_agno)
> -			return noroom ? -ENOSPC : 0;
> +			break;
> +		xfs_perag_put(pag);
>  	}
>  
>  	xfs_perag_put(pag);
> -	return error;
> +	return error ? error : -ENOSPC;
>  found_ag:
> +	xfs_perag_put(pag);
>  	*IO_agbp = agbp;
>  	return 0;
>  }
> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index 25910b145d70..3918c99fa95b 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -923,9 +923,6 @@ xfs_dir_ialloc(
>  	if (error)
>  		return error;
>  
> -	if (!agibp)
> -		return -ENOSPC;
> -
>  	/* Allocate an inode from the selected AG */
>  	error = xfs_dialloc_ag(*tpp, agibp, parent_ino, &ino);
>  	if (error)
> -- 
> 2.31.1
> 
