Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 555C871C35
	for <lists+linux-xfs@lfdr.de>; Tue, 23 Jul 2019 17:51:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732237AbfGWPvg (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 23 Jul 2019 11:51:36 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53170 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730008AbfGWPvg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Jul 2019 11:51:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:To:From:Date:Sender:Reply-To:Cc:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=AYN6jdsZ8Y/8rQLCiW3oj2CXlK5D5BjRzZuUcmuM1Cg=; b=pwqYAZ3f9rzO2kRZnzfslg0hD
        vnaMaf69/SJwS0JnmZw7+PywvysnaY07GufyRymTL5KVNGEZgtguM/fk9ghcuvsYDMmGqH+qBlSHr
        YGK1B5bj/2yp+hvsVSYt0jcRAk9zOVMINgn7a/9IHxnb4zdlPB3nr5+qEn43Pn1e+zNQeYpQmyX4R
        YVN9BwNhhdHe9z8c9EtBZ9Up9CSJ0dfz06LJhWdaiUFr6Yn7IhDFTWRvQQcxpRtMiP0Mz1BCEbLEk
        +0qyH/GD+MeRPT8h8Z/Ir+T+eeZYOUzdscmmql8ARhl2uMOpmVjOZrFb5Y1SlhRWCjQvak1OFMB7v
        ap82w1DBA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hpx4h-0007xn-P5; Tue, 23 Jul 2019 15:51:35 +0000
Date:   Tue, 23 Jul 2019 08:51:35 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, jlayton@kernel.org
Subject: Re: [PATCH] xfs: Do not free xfs_extent_busy from inside a spinlock
Message-ID: <20190723155135.GA16481@infradead.org>
References: <20190723150017.31891-1-cmaiolino@redhat.com>
 <20190723151102.GA1561054@magnolia>
 <20190723153133.wqt3p3dqaghxbkpr@orion.maiolino.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190723153133.wqt3p3dqaghxbkpr@orion.maiolino.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 23, 2019 at 05:31:33PM +0200, Carlos Maiolino wrote:
> CC'ing Jeff so he can maybe chime in too.
> 
> 
> > Er, what problem does this solve?  Does holding on to the pag spinlock
> > too long while memory freeing causes everything else to stall?  When is
> > memory freeing slow enough to cause a noticeable impact?
> 
> Jeff detected it when using this patch:
> 
> https://marc.info/?l=linux-mm&m=156388753722881&w=2
> 
> At first I don't see any specific problem, but I don't think we are supposed to
> use kmem_free() inside interrupt context anyway. So, even though there is no
> visible side effect, it should be fixed IMHO. With the patch above, the side
> effect is a bunch of warnings :P

This is going to break lots of places in xfs.  While we have separate
allocation side wrappers for plain kmalloc vs using a vmalloc fallback we
always use the same free side wrapper.  We could fix this by adding a
kmem_free_large and switch all places that allocated using
kmem_alloc_large to that, but it will require a bit of work.
