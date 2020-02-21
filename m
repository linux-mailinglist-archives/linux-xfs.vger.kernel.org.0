Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14E641680C2
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Feb 2020 15:51:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728611AbgBUOvC (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 21 Feb 2020 09:51:02 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:52760 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728436AbgBUOvC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 09:51:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=r0Vz8xnDJPiSGPpj8gMhCAb2FiF1T+vf1YqS28CSgsY=; b=mk89FnhF5PgWJ5emC1KQmg4sTW
        5k0/vORdUngoUWLhSTkcA+UzpImtcG44DONzlG92VVT6pAL1b9Q2V2ROAj1o6AcV1737wZr46jRHb
        zpTElbRfUx7jsfbjybur7aN5yxHTq6IqX3zptcnb/y5xLEy3d7n/RUgXNXp+dUOBySX9H56EY6iRz
        qaWSIr32qnhvOb4aB28JB/TklH+LH4kw4dbx0TJ2SvFfJHTcdXUSC5FKBFvmMYMYCAeLVn8Yw3D1B
        O5G8Le/4zJheTONNk0MJdjX5boMysjxYhA7CiYwLpNTSPkMX7cZTDNpVCftYpsLxBJsP9F8HRXXnx
        Hqpw7TAg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j59dt-0002o2-1l; Fri, 21 Feb 2020 14:51:01 +0000
Date:   Fri, 21 Feb 2020 06:51:01 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/18] libxfs: use uncached buffers for initial mkfs
 writes
Message-ID: <20200221145101.GJ15358@infradead.org>
References: <158216295405.602314.2094526611933874427.stgit@magnolia>
 <158216302984.602314.15196666031325406487.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158216302984.602314.15196666031325406487.stgit@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Feb 19, 2020 at 05:43:49PM -0800, Darrick J. Wong wrote:
> +/* Prepare an uncached buffer, ready to write something out. */
> +static inline struct xfs_buf *
> +get_write_buf(
> +	struct xfs_buftarg	*btp,
> +	xfs_daddr_t		daddr,
> +	int			bblen)
> +{
> +	struct xfs_buf		*bp;
> +
> +	bp = libxfs_buf_get_uncached(btp, bblen, 0);
> +	bp->b_bn = daddr;
> +	bp->b_maps[0].bm_bn = daddr;
> +	return bp;
> +}

I'd call this alloc_write_buf.

But the patch itself looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
