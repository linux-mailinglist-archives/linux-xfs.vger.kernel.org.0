Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE25B1E983
	for <lists+linux-xfs@lfdr.de>; Wed, 15 May 2019 09:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbfEOHy2 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 15 May 2019 03:54:28 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:51366 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726218AbfEOHy2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 May 2019 03:54:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=e5bnPg8OIFrtMbhi27jS0+YgvOcguldgvENEcbK9kME=; b=YCHd+XU9y2nLjOdF+DaVpiy3+
        iDRgm+6L3LTGIozAP1cvaHlAYHFV0UUlt2D3e53+RKBT3eE27uT6LeTskHiIDQz/pDhLwHwCAu2S9
        E31JlIGp235j5EXh2u7yMU7RwafmQrObN0ClW+AI4AYU2GPIm7KntJ6jACXN4jFGnUj5biFIerbYW
        Fdrz0GwyOY8cS7P3ZousR7RKNfDOS2Zt3N+28dmBCsAQrVPbo3oTVIuQ06G5QmYSwrJbN/AY4ObjA
        3Q3ARkKDixzRPY88VXdOE7hzt4ytJHA4YA/Qu87DAO/1GMVyuVca16awRI5CRAzl4fA1/1P5QQLTk
        5XiMI8GPg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hQok7-0006Ba-Pe; Wed, 15 May 2019 07:54:27 +0000
Date:   Wed, 15 May 2019 00:54:27 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: use locality optimized cntbt lookups for near
 mode allocations
Message-ID: <20190515075427.GI29211@infradead.org>
References: <20190509165839.44329-1-bfoster@redhat.com>
 <20190509165839.44329-4-bfoster@redhat.com>
 <20190510173110.GC18992@infradead.org>
 <20190513154544.GE61135@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190513154544.GE61135@bfoster>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 13, 2019 at 11:45:44AM -0400, Brian Foster wrote:
> Hmm, I had attempted some tighter integration with the xfs_btree_cur on
> a previous variant and ran into some roadblocks, the details of which I
> don't recall. That said, I may have tried to include more than just this
> active state, ran into header issues, and then never really stepped back
> from that to explore more incremental changes.
> 
> I think extending the priv union with something for the allocation code
> to use makes sense. Your suggestion has me wondering if down the road we
> could genericize this further to a bc_valid state or some such that
> quickly indicates whether a cursor points at a valid record or off into
> space. That's a matter for another series however..

Yep.

> You mean to create tree specific cursor structures of which
> xfs_btree_cur is a member, then the tree specific logic uses
> container_of() to pull out whatever it needs from cur..? I'd need to
> think more about that one, but indeed that is beyond the scope of this
> work.

Yes.
