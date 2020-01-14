Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A77513A316
	for <lists+linux-xfs@lfdr.de>; Tue, 14 Jan 2020 09:40:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728809AbgANIkM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 14 Jan 2020 03:40:12 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:56618 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727083AbgANIkL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jan 2020 03:40:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=VnChuydFgZloh2/+x4Zjiim6EtHsiLSomg0txKdC0sU=; b=lEpvwDz7dF4rqsuFNOArI/jRX
        +wGzWuaZsZtGmbVIK3+0vqGpAKN9SEwiIfLeGuD4z6/mtFhcecudjK7+Wwh34ZCr2EjKHJJPOtj/0
        EkyQodCypByLB+9O3GssbEFbpI3Pjd87zjhGkkWZfR7DLi/Qql4xEgaCUH+HYGOrHsYWVX3d9uaDR
        SfEzRRmMAsDlLH2ZRVP/oSiYDaXFoH5t0bHkj8lDdOIBoW34/iV9btHMidWPtoc3V5eGF4wCf1z2z
        33c0LzmTq4ht3sk4pIVP5VZdKti7UmeauuxfHwQZdNLX6Rx1uCdkY5RBKO1JOY2mjuoztnqvmLJmz
        TE1q2iMBQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1irHkB-0000DQ-6m; Tue, 14 Jan 2020 08:40:11 +0000
Date:   Tue, 14 Jan 2020 00:40:11 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 2/6] xfs: fix memory corruption during remote attr value
 buffer invalidation
Message-ID: <20200114084011.GB10888@infradead.org>
References: <157898348940.1566005.3231891474158666998.stgit@magnolia>
 <157898350371.1566005.2641685060877851666.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157898350371.1566005.2641685060877851666.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> Fortunately for us, remote attribute values are written to disk with
> xfs_bwrite(), which is to say that they are not logged.  Fix the problem
> by removing all places where we could end up creating a buffer log item
> for a remote attribute value and leave a note explaining why.

This is stil missing a comment that you are using a suitable helper
for marking the buffer stale, and why rmeoving the HOLEBLOCK check
is safe (which I now tink it is based on looking at the caller).

> -			error = xfs_trans_read_buf(mp, args->trans,
> +			error = xfs_trans_read_buf(mp, NULL,
>  						   mp->m_ddev_targp,
>  						   dblkno, dblkcnt, 0, &bp,
>  						   &xfs_attr3_rmt_buf_ops);
> @@ -411,7 +428,7 @@ xfs_attr_rmtval_get(
>  			error = xfs_attr_rmtval_copyout(mp, bp, args->dp->i_ino,
>  							&offset, &valuelen,
>  							&dst);
> -			xfs_trans_brelse(args->trans, bp);
> +			xfs_buf_relse(bp);

FYI, I don't think mixing xfs_trans_read_buf and xfs_buf_relse is a good
pattern.

> @@ -48,8 +45,8 @@ xfs_attr3_leaf_freextent(
>  	 * Roll through the "value", invalidating the attribute value's
>  	 * blocks.
>  	 */
> -	tblkno = blkno;
> -	tblkcnt = blkcnt;
> +	tblkno = lp->valueblk;
> +	tblkcnt = lp->valuelen;

Nit: these could be easily initialized on the declaration lines.  Or
even better if you keep the old calling conventions of passing the
blockno and count by value, in which case we don't need the extra local
variables at all.

> @@ -174,9 +155,7 @@ xfs_attr3_leaf_inactive(
>  	 */
>  	error = 0;
>  	for (lp = list, i = 0; i < count; i++, lp++) {
> -		tmp = xfs_attr3_leaf_freextent(trans, dp,
> -				lp->valueblk, lp->valuelen);
> -
> +		tmp = xfs_attr3_rmt_inactive(dp, lp);

So given that we don't touch the transaction I don't think we even
need the memory allocation to defer the marking stale of the buffer
until after the xfs_trans_brelse.  But that could be a separate
patch, especially if the block/count calling conventions are kept as-is.
