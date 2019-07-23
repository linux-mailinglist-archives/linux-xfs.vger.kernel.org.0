Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 353DD71D5B
	for <lists+linux-xfs@lfdr.de>; Tue, 23 Jul 2019 19:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388225AbfGWRHD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 23 Jul 2019 13:07:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:48844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726513AbfGWRHD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Jul 2019 13:07:03 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8143E223A0;
        Tue, 23 Jul 2019 17:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563901622;
        bh=u8YL5bInTHWYF/BiHJtQ0OVgCjd1G2NeKGffevCXEbg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fakiajwsYPlGtcwJDHpNlrtId25nhNGc3GcWF0v+mj3xTLriecbmUq2i3z5nifoAe
         D39g7kzW1G0xCr+aPSIDAUalDSkeDfqrGLmRfJ8l6H0nlnflmzaW7/BCvAdzu8u076
         IiRTnsncsvXpfomuYLbf7+cyS8xG3Fcp8kCZ5V9E=
Message-ID: <c2f3542bd06860ecf33f1785b9c146a09a155bf7.camel@kernel.org>
Subject: Re: [PATCH] xfs: Do not free xfs_extent_busy from inside a spinlock
From:   Jeff Layton <jlayton@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org
Cc:     Al Viro <viro@zeniv.linux.org.uk>
Date:   Tue, 23 Jul 2019 13:07:00 -0400
In-Reply-To: <20190723155135.GA16481@infradead.org>
References: <20190723150017.31891-1-cmaiolino@redhat.com>
         <20190723151102.GA1561054@magnolia>
         <20190723153133.wqt3p3dqaghxbkpr@orion.maiolino.org>
         <20190723155135.GA16481@infradead.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2019-07-23 at 08:51 -0700, Christoph Hellwig wrote:
> On Tue, Jul 23, 2019 at 05:31:33PM +0200, Carlos Maiolino wrote:
> > CC'ing Jeff so he can maybe chime in too.
> > 
> > 
> > > Er, what problem does this solve?  Does holding on to the pag spinlock
> > > too long while memory freeing causes everything else to stall?  When is
> > > memory freeing slow enough to cause a noticeable impact?
> > 
> > Jeff detected it when using this patch:
> > 
> > https://marc.info/?l=linux-mm&m=156388753722881&w=2
> > 
> > At first I don't see any specific problem, but I don't think we are supposed to
> > use kmem_free() inside interrupt context anyway. So, even though there is no
> > visible side effect, it should be fixed IMHO. With the patch above, the side
> > effect is a bunch of warnings :P
> 
> This is going to break lots of places in xfs.  While we have separate
> allocation side wrappers for plain kmalloc vs using a vmalloc fallback we
> always use the same free side wrapper.  We could fix this by adding a
> kmem_free_large and switch all places that allocated using
> kmem_alloc_large to that, but it will require a bit of work.

(cc'ing Al)

Note that those places are already broken. AIUI, the basic issue is that
vmalloc/vfree have to fix up page tables and that requires being able to
sleep. This patch just makes this situation more evident. If that patch
gets merged, I imagine we'll have a lot of places to clean up (not just
in xfs).

Anyway, in the case of being in an interrupt, we currently queue the
freeing to a workqueue. Al mentioned that we could create a new
kvfree_atomic that we could use from atomic contexts like this. That may
be another option (though Carlos' patch looked reasonable to me and
would probably be more efficient).
-- 
Jeff Layton <jlayton@kernel.org>

