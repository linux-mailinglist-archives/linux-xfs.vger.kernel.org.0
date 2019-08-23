Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 586009B3FA
	for <lists+linux-xfs@lfdr.de>; Fri, 23 Aug 2019 17:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436632AbfHWPxu (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 23 Aug 2019 11:53:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42950 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436629AbfHWPxu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 23 Aug 2019 11:53:50 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 581C030860A6;
        Fri, 23 Aug 2019 15:53:49 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0323E4142;
        Fri, 23 Aug 2019 15:53:48 +0000 (UTC)
Date:   Fri, 23 Aug 2019 11:53:47 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: bmap scrub should only scrub records once
Message-ID: <20190823155347.GC54025@bfoster>
References: <20190817020651.GH752159@magnolia>
 <20190823150221.GB54025@bfoster>
 <20190823152349.GJ1037350@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190823152349.GJ1037350@magnolia>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Fri, 23 Aug 2019 15:53:49 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 23, 2019 at 08:23:49AM -0700, Darrick J. Wong wrote:
> On Fri, Aug 23, 2019 at 11:02:21AM -0400, Brian Foster wrote:
> > On Fri, Aug 16, 2019 at 07:06:51PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > The inode block mapping scrub function does more work for btree format
> > > extent maps than is absolutely necessary -- first it will walk the bmbt
> > > and check all the entries, and then it will load the incore tree and
> > > check every entry in that tree.
> > > 
> > > Reduce the run time of the ondisk bmbt walk if the incore tree is loaded
> > > by checking that the incore tree has an exact match for the bmbt extent.
> > > Similarly, skip the incore tree walk if we have to load it from the
> > > bmbt, since we just checked that.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  fs/xfs/scrub/bmap.c |   40 +++++++++++++++++++++++++++++++++++++---
> > >  1 file changed, 37 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> > > index 1bd29fdc2ab5..6170736fa94f 100644
> > > --- a/fs/xfs/scrub/bmap.c
> > > +++ b/fs/xfs/scrub/bmap.c
> > > @@ -384,6 +384,7 @@ xchk_bmapbt_rec(
> > >  	struct xfs_inode	*ip = bs->cur->bc_private.b.ip;
> > >  	struct xfs_buf		*bp = NULL;
> > >  	struct xfs_btree_block	*block;
> > > +	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, info->whichfork);
> > >  	uint64_t		owner;
> > >  	int			i;
> > >  
> > > @@ -402,8 +403,30 @@ xchk_bmapbt_rec(
> > >  		}
> > >  	}
> > >  
> > > -	/* Set up the in-core record and scrub it. */
> > > +	/*
> > > +	 * If the incore bmap cache is already loaded, check that it contains
> > > +	 * an extent that matches this one exactly.  We validate those cached
> > > +	 * bmaps later, so we don't need to check here.
> > > +	 *
> > > +	 * If the cache is /not/ loaded, we need to validate the bmbt records
> > > +	 * now.
> > > +	 */
> > >  	xfs_bmbt_disk_get_all(&rec->bmbt, &irec);
> > > +        if (ifp->if_flags & XFS_IFEXTENTS) {
> > 
> > ^ looks like whitespace damage right here.
> 
> Oops.  Fixed.
> 
> > > +		struct xfs_bmbt_irec	iext_irec;
> > > +		struct xfs_iext_cursor	icur;
> > > +
> > > +		if (!xfs_iext_lookup_extent(ip, ifp, irec.br_startoff, &icur,
> > > +					&iext_irec) ||
> > > +		    irec.br_startoff != iext_irec.br_startoff ||
> > > +		    irec.br_startblock != iext_irec.br_startblock ||
> > > +		    irec.br_blockcount != iext_irec.br_blockcount ||
> > > +		    irec.br_state != iext_irec.br_state)
> > > +			xchk_fblock_set_corrupt(bs->sc, info->whichfork,
> > > +					irec.br_startoff);
> > > +		return 0;
> > > +	}
> > > +
> > 
> > Ok, so right now the bmbt walk makes no consideration of in-core state.
> > With this change, we correlate every on-disk record with an in-core
> > counterpart (if cached) and skip the additional extent checks...
> > 
> > >  	return xchk_bmap_extent(ip, bs->cur, info, &irec);
> > >  }
> > >  
> > > @@ -671,11 +694,22 @@ xchk_bmap(
> > >  	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
> > >  		goto out;
> > >  
> > > -	/* Now try to scrub the in-memory extent list. */
> > > +	/*
> > > +	 * If the incore bmap cache isn't loaded, then this inode has a bmap
> > > +	 * btree and we already walked it to check all of the mappings.  Load
> > > +	 * the cache now and skip ahead to rmap checking (which requires the
> > > +	 * bmap cache to be loaded).  We don't need to check twice.
> > > +	 *
> > > +	 * If the cache /is/ loaded, then we haven't checked any mappings, so
> > > +	 * iterate the incore cache and check the mappings now, because the
> > > +	 * bmbt iteration code skipped the checks, assuming that we'd do them
> > > +	 * here.
> > > +	 */
> > >          if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> > >  		error = xfs_iread_extents(sc->tp, ip, whichfork);
> > >  		if (!xchk_fblock_process_error(sc, whichfork, 0, &error))
> > >  			goto out;
> > > +		goto out_check_rmap;
> > 
> > ... because we end up doing that here. Otherwise, the bmbt walk did the
> > extent checks, so we can skip it here.
> 
> Yep.  On the stress test case (which is bmapbtd checking of mdrestore'd
> sparse images of large filesystems), only doing the extent walk + check
> once can cut down the runtime by ~30%.
> 
> > I think I follow, but I'm a little confused by the need for such split
> > logic when we follow up with an unconditional read of the extent tree
> > anyways. Maybe I'm missing something, but couldn't we just read the
> > extent tree a little earlier and always do the extent checks in one
> > place?
> 
> The original goal was that if the extent cache isn't loaded, we want to
> check the bmbt records before we even bother to call xfs_iread_extents,
> so that someone could find out from the trace data exactly where in the
> bmbt was the corruption found.
> 

That certainly makes sense. There's also the line of thought that we
probably shouldn't read the tree if we know the bmbt is corrupted
on-disk (though I don't think anything prevents that from happening
elsewhere). From a broader scrub performance perspective, wouldn't the
clean inode case dominate performance anyways since we may have to scan
through however many clean inodes before we find corruption?

> Granted, since we're reducing the scrub code to the bare minimum needed
> to decide if something's good or bad due to the primary interface being
> a bit field... I could unconditionally load the extent map earlier,
> unconditionally check the iext records, and then the bmbt walk only
> needs to check that the tree shape is ok and that each bmbt record
> corresponds to an iext record.
> 

Yeah, I think logically it sort of makes sense to 1.) check the bmbt is
safe enough to read 2.) read the extent tree 3.) check the extents via
the extent tree, but the btree scanning iteration mechanism and whatnot
make what you describe above more practical. I think that's a reasonable
approach and makes the current logic easier to read without having to
rework anything major.

> The other way to go would be to convert xchk_bmap_check_rmaps to use a
> bmbt cursor if the iext isn't loaded, in which case we wouldn't need to
> load the iext cache at all.  That would reduce the kernel slab
> perturbations at a cost of extra code complexity.
> 

Hmm, so that means we wouldn't read in the extent tree, but we'd have to
look up each individual bmbt record from disk in xchk_bmap_check_rmap(),
right? If so, it's not clear to me that's an overall win over the
current implementation, particularly since some other random thing (i.e.
xfs_reflink_inode_has_shared_extents() called via a couple places in
scrub) might trigger reading an extent tree anyways. Perhaps this is
something better considered separately if there's suspected value to
it..

Brian

> Thoughts?
> 
> --D
> 
> > Brian
> > 
> > >  	}
> > >  
> > >  	/* Find the offset of the last extent in the mapping. */
> > > @@ -689,7 +723,7 @@ xchk_bmap(
> > >  	for_each_xfs_iext(ifp, &icur, &irec) {
> > >  		if (xchk_should_terminate(sc, &error) ||
> > >  		    (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
> > > -			break;
> > > +			goto out;
> > >  		if (isnullstartblock(irec.br_startblock))
> > >  			continue;
> > >  		if (irec.br_startoff >= endoff) {
