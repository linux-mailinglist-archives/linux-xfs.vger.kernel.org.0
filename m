Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D9B242C6CB
	for <lists+linux-xfs@lfdr.de>; Wed, 13 Oct 2021 18:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbhJMQy0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 13 Oct 2021 12:54:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:50764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237782AbhJMQyW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 13 Oct 2021 12:54:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F059861027;
        Wed, 13 Oct 2021 16:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634143939;
        bh=mKrv7wi0GwHUjPlrzRObPsBMtjqp74EFrBMzHW/FTss=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E/Nxv5kffVEvCElhAMiIywDJM8bAr1uhpqGiGaLfI+K6bNriCKOY43gBDfnWOYOnr
         6iiM8+T4sVYOKc+s43+C7kXFJXdVvetjREitMk9xEb8Tg1WRvm3bczKx6GrARqz6PB
         x7IBfG1Hldu1aCuyP+vW6msp75SgXXPCNUI2ygLWvtAV6oNZQ0/gl6X0JlHSGZLsGm
         X4fYlzvLKodgqRNeFWCFSMPSEZiUTEmqLMBt61I3khJjFqXsu4i2rUT8kjm1JSV6z4
         MxU8B4by67cR5oh94ARTqOU9d7E1vfP7/LQS2VRWG8ko8W4yADM9528Rm9HOtS/683
         8066xHXdbQVoQ==
Date:   Wed, 13 Oct 2021 09:52:18 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/15] xfs: support dynamic btree cursor heights
Message-ID: <20211013165218.GV24307@magnolia>
References: <163408155346.4151249.8364703447365270670.stgit@magnolia>
 <163408158126.4151249.1899753599807152513.stgit@magnolia>
 <20211013053122.GX2361455@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211013053122.GX2361455@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 13, 2021 at 04:31:22PM +1100, Dave Chinner wrote:
> On Tue, Oct 12, 2021 at 04:33:01PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Split out the btree level information into a separate struct and put it
> > at the end of the cursor structure as a VLA.  The realtime rmap btree
> > (which is rooted in an inode) will require the ability to support many
> > more levels than a per-AG btree cursor, which means that we're going to
> > create two btree cursor caches to conserve memory for the more common
> > case.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Reviewed-by: Chandan Babu R <chandan.babu@oracle.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/libxfs/xfs_alloc.c |    6 +-
> >  fs/xfs/libxfs/xfs_bmap.c  |   10 +--
> >  fs/xfs/libxfs/xfs_btree.c |  168 +++++++++++++++++++++++----------------------
> >  fs/xfs/libxfs/xfs_btree.h |   28 ++++++--
> >  fs/xfs/scrub/bitmap.c     |   22 +++---
> >  fs/xfs/scrub/bmap.c       |    2 -
> >  fs/xfs/scrub/btree.c      |   47 +++++++------
> >  fs/xfs/scrub/trace.c      |    7 +-
> >  fs/xfs/scrub/trace.h      |   10 +--
> >  fs/xfs/xfs_super.c        |    2 -
> >  fs/xfs/xfs_trace.h        |    2 -
> >  11 files changed, 164 insertions(+), 140 deletions(-)
> 
> Hmmm - subject of the patch doesn't really match the changes being
> made - there's nothing here that makes the btree cursor heights
> dynamic. It's just a structure layout change...

"xfs: prepare xfs_btree_cur for dynamic cursor heights" ?

> 
> > @@ -415,9 +415,9 @@ xfs_btree_dup_cursor(
> >  	 * For each level current, re-get the buffer and copy the ptr value.
> >  	 */
> >  	for (i = 0; i < new->bc_nlevels; i++) {
> > -		new->bc_ptrs[i] = cur->bc_ptrs[i];
> > -		new->bc_ra[i] = cur->bc_ra[i];
> > -		bp = cur->bc_bufs[i];
> > +		new->bc_levels[i].ptr = cur->bc_levels[i].ptr;
> > +		new->bc_levels[i].ra = cur->bc_levels[i].ra;
> > +		bp = cur->bc_levels[i].bp;
> >  		if (bp) {
> >  			error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
> >  						   xfs_buf_daddr(bp), mp->m_bsize,
> > @@ -429,7 +429,7 @@ xfs_btree_dup_cursor(
> >  				return error;
> >  			}
> >  		}
> > -		new->bc_bufs[i] = bp;
> > +		new->bc_levels[i].bp = bp;
> >  	}
> >  	*ncur = new;
> >  	return 0;
> 
> ObHuh: that dup_cursor code seems like a really obtuse way of doing:
> 
> 	bip = cur->bc_levels[i].bp->b_log_item;
> 	bip->bli_recur++;
> 	new->bc_levels[i] = cur->bc_levels[i];
> 
> But that's not a problem this patch needs to solve. Just something
> that made me go hmmmm...

Yeah, I noticed that too while I was checking the results of my sed
script.

> > @@ -922,11 +922,11 @@ xfs_btree_readahead(
> >  	    (lev == cur->bc_nlevels - 1))
> >  		return 0;
> >  
> > -	if ((cur->bc_ra[lev] | lr) == cur->bc_ra[lev])
> > +	if ((cur->bc_levels[lev].ra | lr) == cur->bc_levels[lev].ra)
> >  		return 0;
> 
> That's whacky logic. Surely that's just:
> 
> 	if (cur->bc_levels[lev].ra & lr)
> 		return 0;

This is an early-exit test, which means the careful check is necessary.

If (some day) someone calls this function with (LEFTRA|RIGHTRA) to
readahead both siblings on a btree level where one sibling has been ra'd
but not the other, we must avoid taking the branch.

> > diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> > index 1018bcc43d66..f31f057bec9d 100644
> > --- a/fs/xfs/libxfs/xfs_btree.h
> > +++ b/fs/xfs/libxfs/xfs_btree.h
> > @@ -212,6 +212,19 @@ struct xfs_btree_cur_ino {
> >  #define	XFS_BTCUR_BMBT_INVALID_OWNER	(1 << 1)
> >  };
> >  
> > +struct xfs_btree_level {
> > +	/* buffer pointer */
> > +	struct xfs_buf		*bp;
> > +
> > +	/* key/record number */
> > +	uint16_t		ptr;
> > +
> > +	/* readahead info */
> > +#define XFS_BTCUR_LEFTRA	1	/* left sibling has been read-ahead */
> > +#define XFS_BTCUR_RIGHTRA	2	/* right sibling has been read-ahead */
> > +	uint16_t		ra;
> > +};
> 
> The ra variable is a bit field. Can we define the values obviously
> as bit fields with (1 << 0) and (1 << 1) instead of 1 and 2?

Done.

> > @@ -242,8 +250,17 @@ struct xfs_btree_cur
> >  		struct xfs_btree_cur_ag	bc_ag;
> >  		struct xfs_btree_cur_ino bc_ino;
> >  	};
> > +
> > +	/* Must be at the end of the struct! */
> > +	struct xfs_btree_level	bc_levels[];
> >  };
> >  
> > +static inline size_t
> > +xfs_btree_cur_sizeof(unsigned int nlevels)
> > +{
> > +	return struct_size((struct xfs_btree_cur *)NULL, bc_levels, nlevels);
> > +}
> 
> Ooooh, yeah, we really need comments explaining how many btree
> levels these VLAs are tracking, because this one doesn't have a "-
> 1" in it like the previous one I commented on....

/*
 * Compute the size of a btree cursor that can handle a btree of a given
 * height.  The bc_levels array handles node and leaf blocks, so its
 * size is exactly nlevels.
 */


> > diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
> > index c0ef53fe6611..816dfc8e5a80 100644
> > --- a/fs/xfs/scrub/trace.c
> > +++ b/fs/xfs/scrub/trace.c
> > @@ -21,10 +21,11 @@ xchk_btree_cur_fsbno(
> >  	struct xfs_btree_cur	*cur,
> >  	int			level)
> >  {
> > -	if (level < cur->bc_nlevels && cur->bc_bufs[level])
> > +	if (level < cur->bc_nlevels && cur->bc_levels[level].bp)
> >  		return XFS_DADDR_TO_FSB(cur->bc_mp,
> > -				xfs_buf_daddr(cur->bc_bufs[level]));
> > -	if (level == cur->bc_nlevels - 1 && cur->bc_flags & XFS_BTREE_LONG_PTRS)
> > +				xfs_buf_daddr(cur->bc_levels[level].bp));
> > +	else if (level == cur->bc_nlevels - 1 &&
> > +		 cur->bc_flags & XFS_BTREE_LONG_PTRS)
> 
> No need for an else there as the first if () clause returns.
> Also, needs more () around that "a & b" second line.

TBH I think we check the wrong flag, and that last bit should be:

	if (level == cur->bc_nlevels - 1 &&
	    (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE))
		return XFS_INO_TO_FSB(cur->bc_mp, cur->bc_ino.ip->i_ino);

	return NULLFSBLOCK;

But for now I'll stick to the straight replacement and tack on another
patch to fix that.

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
