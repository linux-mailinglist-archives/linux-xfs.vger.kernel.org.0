Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D764041A208
	for <lists+linux-xfs@lfdr.de>; Tue, 28 Sep 2021 00:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237773AbhI0WDi (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 27 Sep 2021 18:03:38 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:59390 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237645AbhI0WDX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Sep 2021 18:03:23 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 25D1E10534D4;
        Tue, 28 Sep 2021 08:01:44 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mUygq-00HSt9-7l; Tue, 28 Sep 2021 08:01:36 +1000
Date:   Tue, 28 Sep 2021 08:01:36 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     chandan.babu@oracle.com, chandanrlinux@gmail.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: use separate btree cursor slab for each btree
 type
Message-ID: <20210927220136.GJ1756565@dread.disaster.area>
References: <163244685787.2701674.13029851795897591378.stgit@magnolia>
 <163244687985.2701674.5510358661953545557.stgit@magnolia>
 <20210926004721.GD1756565@dread.disaster.area>
 <20210927182122.GT570615@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210927182122.GT570615@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=epq8cqlX c=1 sm=1 tr=0 ts=61523f48
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=kj9zAlcOel0A:10 a=7QKq2e-ADPsA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=4hQTuXZOUqmxXu6Hq6UA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 27, 2021 at 11:21:22AM -0700, Darrick J. Wong wrote:
> On Sun, Sep 26, 2021 at 10:47:21AM +1000, Dave Chinner wrote:
> > On Thu, Sep 23, 2021 at 06:27:59PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Now that we have the infrastructure to track the max possible height of
> > > each btree type, we can create a separate slab zone for cursors of each
> > > type of btree.  For smaller indices like the free space btrees, this
> > > means that we can pack more cursors into a slab page, improving slab
> > > utilization.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  fs/xfs/libxfs/xfs_btree.c |   12 ++++++------
> > >  fs/xfs/libxfs/xfs_btree.h |    9 +--------
> > >  fs/xfs/xfs_super.c        |   33 ++++++++++++++++++++++++---------
> > >  3 files changed, 31 insertions(+), 23 deletions(-)
> > > 
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
> > > index 120280c998f8..3131de9ae631 100644
> > > --- a/fs/xfs/libxfs/xfs_btree.c
> > > +++ b/fs/xfs/libxfs/xfs_btree.c
> > > @@ -26,7 +26,6 @@
> > >  /*
> > >   * Cursor allocation zone.
> > >   */
> > > -kmem_zone_t	*xfs_btree_cur_zone;
> > >  struct xfs_btree_cur_zone xfs_btree_cur_zones[XFS_BTNUM_MAX] = {
> > >  	[XFS_BTNUM_BNO]		= { .name = "xfs_alloc_btree_cur" },
> > >  	[XFS_BTNUM_INO]		= { .name = "xfs_ialloc_btree_cur" },
> > > @@ -364,6 +363,7 @@ xfs_btree_del_cursor(
> > >  	struct xfs_btree_cur	*cur,		/* btree cursor */
> > >  	int			error)		/* del because of error */
> > >  {
> > > +	struct xfs_btree_cur_zone *bczone = &xfs_btree_cur_zones[cur->bc_btnum];
> > >  	int			i;		/* btree level */
> > >  
> > >  	/*
> > > @@ -386,10 +386,10 @@ xfs_btree_del_cursor(
> > >  		kmem_free(cur->bc_ops);
> > >  	if (!(cur->bc_flags & XFS_BTREE_LONG_PTRS) && cur->bc_ag.pag)
> > >  		xfs_perag_put(cur->bc_ag.pag);
> > > -	if (cur->bc_maxlevels > XFS_BTREE_CUR_ZONE_MAXLEVELS)
> > > +	if (cur->bc_maxlevels > bczone->maxlevels)
> > >  		kmem_free(cur);
> > >  	else
> > > -		kmem_cache_free(xfs_btree_cur_zone, cur);
> > > +		kmem_cache_free(bczone->zone, cur);
> > >  }
> > >  
> > >  /*
> > > @@ -5021,12 +5021,12 @@ xfs_btree_alloc_cursor(
> > >  {
> > >  	struct xfs_btree_cur	*cur;
> > >  	unsigned int		maxlevels = xfs_btree_maxlevels(mp, btnum);
> > > +	struct xfs_btree_cur_zone *bczone = &xfs_btree_cur_zones[btnum];
> > >  
> > > -	if (maxlevels > XFS_BTREE_CUR_ZONE_MAXLEVELS)
> > > +	if (maxlevels > bczone->maxlevels)
> > >  		cur = kmem_zalloc(xfs_btree_cur_sizeof(maxlevels), KM_NOFS);
> > >  	else
> > > -		cur = kmem_cache_zalloc(xfs_btree_cur_zone,
> > > -				GFP_NOFS | __GFP_NOFAIL);
> > > +		cur = kmem_cache_zalloc(bczone->zone, GFP_NOFS | __GFP_NOFAIL);
> > 
> > When will maxlevels ever be greater than bczone->maxlevels? Isn't
> > the bczone->maxlevels case always supposed to be the tallest
> > possible height for that btree?
> 
> It should never happen, provided that the maxlevels computation and
> verification are all correct.  I thought it was important to leave the
> heap allocation in here as a fallback, since the consequence for getting
> the size calculations wrong is corrupt kernel memory.

I think that this is the wrong approach. Static debug-only testing
of btree size calculations at init time is needed here, not runtime
fallbacks that hide the fact that we got fundamental calculations
wrong. A mistake here should be loud and obvious, not hidden away in
a fallback path that might never, ever be hit in the real world.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
