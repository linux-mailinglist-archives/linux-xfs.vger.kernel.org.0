Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01B601A247
	for <lists+linux-xfs@lfdr.de>; Fri, 10 May 2019 19:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727653AbfEJRbL (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 10 May 2019 13:31:11 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:59458 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727453AbfEJRbK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 10 May 2019 13:31:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=4yb1AXRGfrTy9pxeatVbm1k5xF2Ns7lrmZMer+Gp774=; b=Fc7K/pyDAFsrk0lkmGPhQ8Zm2
        V4v7D4TfgXwBN4wV9DcYwBwVMCBu+O4isFgMD634FFqfU9YfmVd3IK3TNk47RGFLc0IyH5UcyDeYK
        5rVfprrceRdaYII8E5Nz6cGlW7Ng4q+diGKWUM3uHpuAMHyqqX+gFQvmQSNdnoFHImBpnWg8HIYtX
        t0kus82GVtFgh1f7c8hAisPPfLgybHHMRCGg1XxDBOqVubGmq+k0mj2/OEwhmXeitTMOPq+eu+v0d
        5gTqcw5qaK+O4Xr2bj49bQCggF405wVcpRacvbUtUvx/S0ElKAPtr9rbssffsB3KIck6X1ZLvZKUs
        mtY1UaThQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hP9MU-0008AL-I1; Fri, 10 May 2019 17:31:10 +0000
Date:   Fri, 10 May 2019 10:31:10 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: use locality optimized cntbt lookups for near
 mode allocations
Message-ID: <20190510173110.GC18992@infradead.org>
References: <20190509165839.44329-1-bfoster@redhat.com>
 <20190509165839.44329-4-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190509165839.44329-4-bfoster@redhat.com>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Still digesting the algorithmic changes, but a few nitpicks below:

>  /*
> + * BLock allocation algorithm and data structures.

I think the upper case L is a typo.

> +struct xfs_alloc_btree_cur {
> +	struct xfs_btree_cur	*cur;		/* cursor */
> +	bool			active;		/* cursor active flag */
> +};

Can't we move the active flag inside the btree_cur, more specically
into enum xfs_btree_cur_private?

Or maybe we should byte the bullet and make xfs_btree_cur a structure
embedded into the type specific structures and use container_of.
But I certainly don't want to burden that on you and this series..
