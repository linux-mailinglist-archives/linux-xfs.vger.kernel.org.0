Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85FF6307336
	for <lists+linux-xfs@lfdr.de>; Thu, 28 Jan 2021 10:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbhA1Jyf (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 28 Jan 2021 04:54:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231758AbhA1Jy3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Jan 2021 04:54:29 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A76C061573
        for <linux-xfs@vger.kernel.org>; Thu, 28 Jan 2021 01:53:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=gNV4s2Tjex28cY0Ym+HVicA7bg1pZjBWPzFVx++yMMs=; b=M4FbQ3GkvpTWHNujiSlfdLNyWp
        rrSGjl8G6q4VwxhnJyQsbkFqbv0AZtE9crAfq7ZCWeLpvwprUQV4FTVPjWGtYi+ZNLm/XYggT3qEX
        0jKBmZ+E8HIXgAP5SPc92P3030fI8vjxT+88MJbBPQ84+B3TApT0FoNy4X1TJ7TtaHA2GME5JotOy
        51JcY9VHbM1Fs4JgGlbQpB3t/+/7++T2SziA6AI1xJjZdVGByZpFsQAyYlYp5FKjhf18PdWhHv9ij
        W0MvUhkKukV89DNx47srivKcZBKPnoD/GtOFSFDxTu8NYmQPRoH0ib/4UFq0IQ+wt35AyN4YrqTHt
        BHQwU6ag==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l53zl-008HyE-GY; Thu, 28 Jan 2021 09:53:45 +0000
Date:   Thu, 28 Jan 2021 09:53:45 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Subject: Re: [PATCH 09/13] xfs: refactor reflink functions to use
 xfs_trans_alloc_inode
Message-ID: <20210128095345.GE1973802@infradead.org>
References: <161181366379.1523592.9213241916555622577.stgit@magnolia>
 <161181371557.1523592.14364313318301403930.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161181371557.1523592.14364313318301403930.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 27, 2021 at 10:01:55PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The two remaining callers of xfs_trans_reserve_quota_nblks are in the
> reflink code.  These conversions aren't as uniform as the previous
> conversions, so call that out in a separate patch.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/xfs_reflink.c |   58 +++++++++++++++++++++-----------------------------
>  1 file changed, 24 insertions(+), 34 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 0778b5810c26..ded86cc4764c 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -376,16 +376,15 @@ xfs_reflink_allocate_cow(
>  	resblks = XFS_DIOSTRAT_SPACE_RES(mp, resaligned);
>  
>  	xfs_iunlock(ip, *lockmode);
>  
> +	error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write, resblks, 0,
> +			false, &tp);
> +	if (error) {
> +		/* This function must return with ILOCK_EXCL held. */
> +		*lockmode = XFS_ILOCK_EXCL;
> +		xfs_ilock(ip, *lockmode);
>  		return error;
> +	}

The only thing that the only caller of xfs_reflink_allocate_cow does
on error is to immediately release the lock.  So I think we are better
off changing the calling convention instead of relocking here.
