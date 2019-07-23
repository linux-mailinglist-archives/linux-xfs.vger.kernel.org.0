Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D49271DDE
	for <lists+linux-xfs@lfdr.de>; Tue, 23 Jul 2019 19:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391166AbfGWRiL (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 23 Jul 2019 13:38:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:60550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388568AbfGWRiL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Jul 2019 13:38:11 -0400
Received: from tleilax.poochiereds.net (cpe-71-70-156-158.nc.res.rr.com [71.70.156.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 823B32083B;
        Tue, 23 Jul 2019 17:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563903490;
        bh=TstsnqIUeVfPZETZ6hgUM3bUawA1NPO1kFnMv264vcM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=1ZoUR2GmqpEAnktSJeA5vnQ52EbRrC7z0RRaLOFG/pOFItNP3/zZrubA4tZ+f2vpg
         5RgOyrkHzB6QdDV+NIbd2KS7c0rEfpj3lIrNkCpTblg9qNPnOdWXtmlCGB6nrHaopK
         jzbaiv3Aj7yKnczZ8argJY5NR3HUqI5x8/Px1S6c=
Message-ID: <70ea7252bc0cbfc99da7fde1ce58ddb92550885a.camel@kernel.org>
Subject: Re: [PATCH] xfs: Do not free xfs_extent_busy from inside a spinlock
From:   Jeff Layton <jlayton@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Date:   Tue, 23 Jul 2019 13:38:08 -0400
In-Reply-To: <20190723170843.GA1952@infradead.org>
References: <20190723150017.31891-1-cmaiolino@redhat.com>
         <20190723151102.GA1561054@magnolia>
         <20190723153133.wqt3p3dqaghxbkpr@orion.maiolino.org>
         <20190723155135.GA16481@infradead.org>
         <c2f3542bd06860ecf33f1785b9c146a09a155bf7.camel@kernel.org>
         <20190723170843.GA1952@infradead.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, 2019-07-23 at 10:08 -0700, Christoph Hellwig wrote:
> On Tue, Jul 23, 2019 at 01:07:00PM -0400, Jeff Layton wrote:
> > Note that those places are already broken. AIUI, the basic issue is that
> > vmalloc/vfree have to fix up page tables and that requires being able to
> > sleep. This patch just makes this situation more evident. If that patch
> > gets merged, I imagine we'll have a lot of places to clean up (not just
> > in xfs).
> > 
> > Anyway, in the case of being in an interrupt, we currently queue the
> > freeing to a workqueue. Al mentioned that we could create a new
> > kvfree_atomic that we could use from atomic contexts like this. That may
> > be another option (though Carlos' patch looked reasonable to me and
> > would probably be more efficient).
> 
> The point is for XFS we generally only use kmem_free for pure kmalloc
> allocations under spinlocks.  But yes, the interfac is a little
> suboptimal and a kmem_free_large would be nicer and then warnings like
> this that might be pretty useful could be added.

Ahh ok, I get it now. You're using it as a generic "free this, no matter
what it is" wrapper, and relying on the caller to ensure that it will
never try to free a vmalloc'ed addr from an atomic context.

I wonder how many other places are doing that? I count 858 call sites
for kvfree. If significant portion of those are doing this, then we may
have to re-think my patch. It seems like the right thing to do, but we
there may be more fallout than I expected.
-- 
Jeff Layton <jlayton@kernel.org>

