Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCA1F305813
	for <lists+linux-xfs@lfdr.de>; Wed, 27 Jan 2021 11:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S313715AbhAZXD4 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 26 Jan 2021 18:03:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:49290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394758AbhAZSfe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 26 Jan 2021 13:35:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DD0A22228;
        Tue, 26 Jan 2021 18:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611686093;
        bh=X6xjOAXwUM08ZXoO1uhz+/DG4QdNNJZebr56TPt0qUE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=drZ2FNqCsJzMEnu24QPfFP49VXAK3NiZ4KTJI1xbx1rBSvyDgyyztjrRJ2Yb1q+8t
         7gzEGsvVaPcwcw33V0lLsniZiXhLqcf1C0RwPv7ffivi5K0iKtqXeSoDrgFFoLm2Gd
         Lptuimt2yElKv5EgUSbGfASm0nQIL2wS3ayYM3yhXPffrPd3hRX8QA4x7GoVcWeIV3
         0hrvBDc5pLtzaGhY1SPbatzCnC9kZsSd6XdP3hGNElNfOn16cNG2sMogtz05zBGQ1q
         w6V6L0NnpqQbEXBhv2S0fuFjPTPfpRkcQM9tt8YVA3LdfSqLN2BSxtenKmTorgElV5
         cQBXbfnY80xtw==
Date:   Tue, 26 Jan 2021 10:34:52 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH 02/11] xfs: don't stall cowblocks scan if we can't take
 locks
Message-ID: <20210126183452.GZ7698@magnolia>
References: <161142791950.2171939.3320927557987463636.stgit@magnolia>
 <161142793080.2171939.11486862758521454210.stgit@magnolia>
 <20210125181406.GH2047559@bfoster>
 <20210125195446.GD7698@magnolia>
 <20210126131451.GA2158252@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210126131451.GA2158252@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jan 26, 2021 at 08:14:51AM -0500, Brian Foster wrote:
> On Mon, Jan 25, 2021 at 11:54:46AM -0800, Darrick J. Wong wrote:
> > On Mon, Jan 25, 2021 at 01:14:06PM -0500, Brian Foster wrote:
> > > On Sat, Jan 23, 2021 at 10:52:10AM -0800, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > Don't stall the cowblocks scan on a locked inode if we possibly can.
> > > > We'd much rather the background scanner keep moving.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > > ---
> > > >  fs/xfs/xfs_icache.c |   21 ++++++++++++++++++---
> > > >  1 file changed, 18 insertions(+), 3 deletions(-)
> > > > 
> > > > 
> > > > diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> > > > index c71eb15e3835..89f9e692fde7 100644
> > > > --- a/fs/xfs/xfs_icache.c
> > > > +++ b/fs/xfs/xfs_icache.c
> > > > @@ -1605,17 +1605,31 @@ xfs_inode_free_cowblocks(
> > > >  	void			*args)
> > > >  {
> > > >  	struct xfs_eofblocks	*eofb = args;
> > > > +	bool			wait;
> > > >  	int			ret = 0;
> > > >  
> > > > +	wait = eofb && (eofb->eof_flags & XFS_EOF_FLAGS_SYNC);
> > > > +
> > > >  	if (!xfs_prep_free_cowblocks(ip))
> > > >  		return 0;
> > > >  
> > > >  	if (!xfs_inode_matches_eofb(ip, eofb))
> > > >  		return 0;
> > > >  
> > > > -	/* Free the CoW blocks */
> > > > -	xfs_ilock(ip, XFS_IOLOCK_EXCL);
> > > > -	xfs_ilock(ip, XFS_MMAPLOCK_EXCL);
> > > > +	/*
> > > > +	 * If the caller is waiting, return -EAGAIN to keep the background
> > > > +	 * scanner moving and revisit the inode in a subsequent pass.
> > > > +	 */
> > > > +	if (!xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
> > > > +		if (wait)
> > > > +			return -EAGAIN;
> > > > +		return 0;
> > > > +	}
> > > > +	if (!xfs_ilock_nowait(ip, XFS_MMAPLOCK_EXCL)) {
> > > > +		if (wait)
> > > > +			ret = -EAGAIN;
> > > > +		goto out_iolock;
> > > > +	}
> > > 
> > > Hmm.. I'd be a little concerned over this allowing a scan to repeat
> > > indefinitely with a competing workload because a restart doesn't carry
> > > over any state from the previous scan. I suppose the
> > > xfs_prep_free_cowblocks() checks make that slightly less likely on a
> > > given file, but I more wonder about a scenario with a large set of
> > > inodes in a particular AG with a sufficient amount of concurrent
> > > activity. All it takes is one trylock failure per scan to have to start
> > > the whole thing over again... hm?
> > 
> > I'm not quite sure what to do here -- xfs_inode_free_eofblocks already
> > has the ability to return EAGAIN, which (I think) means that it's
> > already possible for the low-quota scan to stall indefinitely if the
> > scan can't lock the inode.
> > 
> 
> Indeed, that is true.
> 
> > I think we already had a stall limiting factor here in that all the
> > other threads in the system that hit EDQUOT will drop their IOLOCKs to
> > scan the fs, which means that while they loop around the scanner they
> > can only be releasing quota and driving us towards having fewer inodes
> > with the same dquots and either blockgc tag set.
> > 
> 
> Yeah, that makes sense for the current use case. There's a broader
> sequence involved there that provides some throttling and serialization,
> along with the fact that the workload is imminently driving into
> -ENOSPC.
> 
> I think what had me a little concerned upon seeing this is whether the
> scanning mechanism is currently suitable for the broader usage
> introduced in this series. We've had related issues in the past with
> concurrent sync eofblocks scans and iolock (see [1], for example).
> Having made it through the rest of the series however, it looks like all
> of the new scan invocations are async, so perhaps this is not really an
> immediate problem.
> 
> I think it would be nice if we could somehow assert that the task that
> invokes a sync scan doesn't hold an iolock, but I'm not sure there's a
> clean way to do that. We'd probably have to define the interface to
> require an inode just for that purpose. It may not be worth that
> weirdness, and I suppose if code is tested it should be pretty obvious
> that such a scan will never complete..

Well... in theory it would be possible to deal with stalls (A->A
livelock or otherwise) if we had that IWALK_NORETRY flag I was talking
about that would cause xfs_iwalk to exit with EAGAIN instead of
restarting the scan at inode 0.  The caller could detect that a
synchronous scan didn't complete, and then decide if it wants to call
back to try again.

But, that might be a lot of extra code to deal with a requirement that
xfs_blockgc_free_* callers cannot hold an iolock or an mmaplock.  Maybe
that's the simpler course of action?

--D

> Brian
> 
> [1] c3155097ad89 ("xfs: sync eofblocks scans under iolock are livelock prone")
> 
> > --D
> > 
> > > Brian
> > > 
> > > >  
> > > >  	/*
> > > >  	 * Check again, nobody else should be able to dirty blocks or change
> > > > @@ -1625,6 +1639,7 @@ xfs_inode_free_cowblocks(
> > > >  		ret = xfs_reflink_cancel_cow_range(ip, 0, NULLFILEOFF, false);
> > > >  
> > > >  	xfs_iunlock(ip, XFS_MMAPLOCK_EXCL);
> > > > +out_iolock:
> > > >  	xfs_iunlock(ip, XFS_IOLOCK_EXCL);
> > > >  
> > > >  	return ret;
> > > > 
> > > 
> > 
> 
