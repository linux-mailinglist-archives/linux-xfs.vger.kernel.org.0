Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA459B45F
	for <lists+linux-xfs@lfdr.de>; Fri, 23 Aug 2019 18:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436692AbfHWQSD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 23 Aug 2019 12:18:03 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40040 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436677AbfHWQSD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Aug 2019 12:18:03 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7NG8rgV015761;
        Fri, 23 Aug 2019 16:17:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=VtIqnQaSfS4Wj9f3GCUzZ+QisIS5SXT3NgixjTYPrcA=;
 b=me6IWyNwoZxEN/+K4ZnMeMY76ay+sHis7k0Uz8kqIl61XGBd9FV3tTjgJXnePMXPfNzk
 Y0DNw+uqs5r1XL4KntBn3eumfgeaNxVAncl4ASiyLnNxVtP4a/aDWqKo5O/HKsUU3o6e
 ucrQfwNkIo2XKgXQsizLGt9AdA+3hxv6OXx/XterqjgcWENUZQRyoJezPtXBC5wP1tVR
 qlOvVPY2i33zmOJ5etjf8Xwn0LsZfk7TQOSjdqeTXVPjAmgEx6FhjVIePvBjwCDtzPiY
 ah8zD9wxv+Smj3EsvQUX3xA47bpfs3XuvTrTOvZmB+SlsfmrFA3kzxdlxUQsox7hGDAc ng== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2ue9hq5nm3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Aug 2019 16:17:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7NG7xLF020930;
        Fri, 23 Aug 2019 16:17:51 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2ujca89h3e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Aug 2019 16:17:50 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7NGHo5j022061;
        Fri, 23 Aug 2019 16:17:50 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 23 Aug 2019 09:17:49 -0700
Date:   Fri, 23 Aug 2019 09:17:48 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: bmap scrub should only scrub records once
Message-ID: <20190823161748.GK1037350@magnolia>
References: <20190817020651.GH752159@magnolia>
 <20190823150221.GB54025@bfoster>
 <20190823152349.GJ1037350@magnolia>
 <20190823155347.GC54025@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190823155347.GC54025@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9358 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908230161
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9358 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908230161
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 23, 2019 at 11:53:47AM -0400, Brian Foster wrote:
> On Fri, Aug 23, 2019 at 08:23:49AM -0700, Darrick J. Wong wrote:
> > On Fri, Aug 23, 2019 at 11:02:21AM -0400, Brian Foster wrote:
> > > On Fri, Aug 16, 2019 at 07:06:51PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > The inode block mapping scrub function does more work for btree format
> > > > extent maps than is absolutely necessary -- first it will walk the bmbt
> > > > and check all the entries, and then it will load the incore tree and
> > > > check every entry in that tree.
> > > > 
> > > > Reduce the run time of the ondisk bmbt walk if the incore tree is loaded
> > > > by checking that the incore tree has an exact match for the bmbt extent.
> > > > Similarly, skip the incore tree walk if we have to load it from the
> > > > bmbt, since we just checked that.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> > > >  fs/xfs/scrub/bmap.c |   40 +++++++++++++++++++++++++++++++++++++---
> > > >  1 file changed, 37 insertions(+), 3 deletions(-)
> > > > 
> > > > diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
> > > > index 1bd29fdc2ab5..6170736fa94f 100644
> > > > --- a/fs/xfs/scrub/bmap.c
> > > > +++ b/fs/xfs/scrub/bmap.c
> > > > @@ -384,6 +384,7 @@ xchk_bmapbt_rec(
> > > >  	struct xfs_inode	*ip = bs->cur->bc_private.b.ip;
> > > >  	struct xfs_buf		*bp = NULL;
> > > >  	struct xfs_btree_block	*block;
> > > > +	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, info->whichfork);
> > > >  	uint64_t		owner;
> > > >  	int			i;
> > > >  
> > > > @@ -402,8 +403,30 @@ xchk_bmapbt_rec(
> > > >  		}
> > > >  	}
> > > >  
> > > > -	/* Set up the in-core record and scrub it. */
> > > > +	/*
> > > > +	 * If the incore bmap cache is already loaded, check that it contains
> > > > +	 * an extent that matches this one exactly.  We validate those cached
> > > > +	 * bmaps later, so we don't need to check here.
> > > > +	 *
> > > > +	 * If the cache is /not/ loaded, we need to validate the bmbt records
> > > > +	 * now.
> > > > +	 */
> > > >  	xfs_bmbt_disk_get_all(&rec->bmbt, &irec);
> > > > +        if (ifp->if_flags & XFS_IFEXTENTS) {
> > > 
> > > ^ looks like whitespace damage right here.
> > 
> > Oops.  Fixed.
> > 
> > > > +		struct xfs_bmbt_irec	iext_irec;
> > > > +		struct xfs_iext_cursor	icur;
> > > > +
> > > > +		if (!xfs_iext_lookup_extent(ip, ifp, irec.br_startoff, &icur,
> > > > +					&iext_irec) ||
> > > > +		    irec.br_startoff != iext_irec.br_startoff ||
> > > > +		    irec.br_startblock != iext_irec.br_startblock ||
> > > > +		    irec.br_blockcount != iext_irec.br_blockcount ||
> > > > +		    irec.br_state != iext_irec.br_state)
> > > > +			xchk_fblock_set_corrupt(bs->sc, info->whichfork,
> > > > +					irec.br_startoff);
> > > > +		return 0;
> > > > +	}
> > > > +
> > > 
> > > Ok, so right now the bmbt walk makes no consideration of in-core state.
> > > With this change, we correlate every on-disk record with an in-core
> > > counterpart (if cached) and skip the additional extent checks...
> > > 
> > > >  	return xchk_bmap_extent(ip, bs->cur, info, &irec);
> > > >  }
> > > >  
> > > > @@ -671,11 +694,22 @@ xchk_bmap(
> > > >  	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
> > > >  		goto out;
> > > >  
> > > > -	/* Now try to scrub the in-memory extent list. */
> > > > +	/*
> > > > +	 * If the incore bmap cache isn't loaded, then this inode has a bmap
> > > > +	 * btree and we already walked it to check all of the mappings.  Load
> > > > +	 * the cache now and skip ahead to rmap checking (which requires the
> > > > +	 * bmap cache to be loaded).  We don't need to check twice.
> > > > +	 *
> > > > +	 * If the cache /is/ loaded, then we haven't checked any mappings, so
> > > > +	 * iterate the incore cache and check the mappings now, because the
> > > > +	 * bmbt iteration code skipped the checks, assuming that we'd do them
> > > > +	 * here.
> > > > +	 */
> > > >          if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> > > >  		error = xfs_iread_extents(sc->tp, ip, whichfork);
> > > >  		if (!xchk_fblock_process_error(sc, whichfork, 0, &error))
> > > >  			goto out;
> > > > +		goto out_check_rmap;
> > > 
> > > ... because we end up doing that here. Otherwise, the bmbt walk did the
> > > extent checks, so we can skip it here.
> > 
> > Yep.  On the stress test case (which is bmapbtd checking of mdrestore'd
> > sparse images of large filesystems), only doing the extent walk + check
> > once can cut down the runtime by ~30%.
> > 
> > > I think I follow, but I'm a little confused by the need for such split
> > > logic when we follow up with an unconditional read of the extent tree
> > > anyways. Maybe I'm missing something, but couldn't we just read the
> > > extent tree a little earlier and always do the extent checks in one
> > > place?
> > 
> > The original goal was that if the extent cache isn't loaded, we want to
> > check the bmbt records before we even bother to call xfs_iread_extents,
> > so that someone could find out from the trace data exactly where in the
> > bmbt was the corruption found.
> > 
> 
> That certainly makes sense. There's also the line of thought that we
> probably shouldn't read the tree if we know the bmbt is corrupted
> on-disk (though I don't think anything prevents that from happening
> elsewhere).

Right.  AFAICT the iread_extents will at least catch obvious corruptions
in the btree blocks (which makes checking them during scrub a little
redundant) but I think the general pattern is that we try to read them
and if it fails then we just bounce the error out to userspace.

> From a broader scrub performance perspective, wouldn't the
> clean inode case dominate performance anyways since we may have to scan
> through however many clean inodes before we find corruption?

Yes.  Well, let's hope so anyway. :)

> > Granted, since we're reducing the scrub code to the bare minimum needed
> > to decide if something's good or bad due to the primary interface being
> > a bit field... I could unconditionally load the extent map earlier,
> > unconditionally check the iext records, and then the bmbt walk only
> > needs to check that the tree shape is ok and that each bmbt record
> > corresponds to an iext record.
> > 
> 
> Yeah, I think logically it sort of makes sense to 1.) check the bmbt is
> safe enough to read 2.) read the extent tree 3.) check the extents via
> the extent tree, but the btree scanning iteration mechanism and whatnot
> make what you describe above more practical. I think that's a reasonable
> approach and makes the current logic easier to read without having to
> rework anything major.

Hm.  But if we load the iext cache earlier then we ought to split the
functionality in xchk_bmapbt_rec, since it's called both from the bmbt
walk and from the iext walk.  The bmbt check function would /only/
verify that the bmbt record has a corresponding iext record; whereas the
iext check function would do all the sanity checking and cross
referencing that xchk_bmapbt_rec does now.

> > The other way to go would be to convert xchk_bmap_check_rmaps to use a
> > bmbt cursor if the iext isn't loaded, in which case we wouldn't need to
> > load the iext cache at all.  That would reduce the kernel slab
> > perturbations at a cost of extra code complexity.
> > 
> 
> Hmm, so that means we wouldn't read in the extent tree, but we'd have to
> look up each individual bmbt record from disk in xchk_bmap_check_rmap(),
> right? If so, it's not clear to me that's an overall win over the
> current implementation, particularly since some other random thing (i.e.
> xfs_reflink_inode_has_shared_extents() called via a couple places in
> scrub) might trigger reading an extent tree anyways. Perhaps this is
> something better considered separately if there's suspected value to
> it..

It would be the usual tradeoff between performance vs. memory usage.
Meh, I'll just keep loading the iext cache since in theory memory
reclaim will just kill off the stuff we've scanned and let go. <cough>

--D

> Brian
> 
> > Thoughts?
> > 
> > --D
> > 
> > > Brian
> > > 
> > > >  	}
> > > >  
> > > >  	/* Find the offset of the last extent in the mapping. */
> > > > @@ -689,7 +723,7 @@ xchk_bmap(
> > > >  	for_each_xfs_iext(ifp, &icur, &irec) {
> > > >  		if (xchk_should_terminate(sc, &error) ||
> > > >  		    (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
> > > > -			break;
> > > > +			goto out;
> > > >  		if (isnullstartblock(irec.br_startblock))
> > > >  			continue;
> > > >  		if (irec.br_startoff >= endoff) {
