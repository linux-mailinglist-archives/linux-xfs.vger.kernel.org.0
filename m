Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3882F25A4
	for <lists+linux-xfs@lfdr.de>; Tue, 12 Jan 2021 02:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727908AbhALBla (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 11 Jan 2021 20:41:30 -0500
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:51881 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732563AbhALBla (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Jan 2021 20:41:30 -0500
Received: from dread.disaster.area (pa49-179-167-107.pa.nsw.optusnet.com.au [49.179.167.107])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id F14AE827FB1;
        Tue, 12 Jan 2021 12:40:46 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kz8ft-005X6M-Te; Tue, 12 Jan 2021 12:40:45 +1100
Date:   Tue, 12 Jan 2021 12:40:45 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: flush speculative space allocations when we run
 out of quota
Message-ID: <20210112014045.GQ331610@dread.disaster.area>
References: <161040735389.1582114.15084485390769234805.stgit@magnolia>
 <161040738496.1582114.17998753962128996136.stgit@magnolia>
 <20210112012249.GP331610@dread.disaster.area>
 <20210112013126.GJ1164246@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210112013126.GJ1164246@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=+wqVUQIkAh0lLYI+QRsciw==:117 a=+wqVUQIkAh0lLYI+QRsciw==:17
        a=kj9zAlcOel0A:10 a=EmqxpYm9HcoA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=XU7w_1HB4ae65RuvB5AA:9 a=CjuIK1q_8ugA:10 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 11, 2021 at 05:31:26PM -0800, Darrick J. Wong wrote:
> On Tue, Jan 12, 2021 at 12:22:49PM +1100, Dave Chinner wrote:
> > On Mon, Jan 11, 2021 at 03:23:05PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > If a fs modification (creation, file write, reflink, etc.) is unable to
> > > reserve enough quota to handle the modification, try clearing whatever
> > > space the filesystem might have been hanging onto in the hopes of
> > > speeding up the filesystem.  The flushing behavior will become
> > > particularly important when we add deferred inode inactivation because
> > > that will increase the amount of space that isn't actively tied to user
> > > data.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  fs/xfs/xfs_bmap_util.c |   16 ++++++++++++++++
> > >  fs/xfs/xfs_file.c      |    2 +-
> > >  fs/xfs/xfs_icache.c    |    9 +++++++--
> > >  fs/xfs/xfs_icache.h    |    2 +-
> > >  fs/xfs/xfs_inode.c     |   17 +++++++++++++++++
> > >  fs/xfs/xfs_ioctl.c     |    2 ++
> > >  fs/xfs/xfs_iomap.c     |   20 +++++++++++++++++++-
> > >  fs/xfs/xfs_reflink.c   |   40 +++++++++++++++++++++++++++++++++++++---
> > >  fs/xfs/xfs_trace.c     |    1 +
> > >  fs/xfs/xfs_trace.h     |   40 ++++++++++++++++++++++++++++++++++++++++
> > >  10 files changed, 141 insertions(+), 8 deletions(-)
> > > 
> > > 
> > > diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
> > > index 7371a7f7c652..437fdc8a8fbd 100644
> > > --- a/fs/xfs/xfs_bmap_util.c
> > > +++ b/fs/xfs/xfs_bmap_util.c
> > > @@ -761,6 +761,7 @@ xfs_alloc_file_space(
> > >  	 */
> > >  	while (allocatesize_fsb && !error) {
> > >  		xfs_fileoff_t	s, e;
> > > +		bool		cleared_space = false;
> > >  
> > >  		/*
> > >  		 * Determine space reservations for data/realtime.
> > > @@ -803,6 +804,7 @@ xfs_alloc_file_space(
> > >  		/*
> > >  		 * Allocate and setup the transaction.
> > >  		 */
> > > +retry:
> > >  		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_write, resblks,
> > >  				resrtextents, 0, &tp);
> > >  
> > > @@ -819,6 +821,20 @@ xfs_alloc_file_space(
> > >  		xfs_ilock(ip, XFS_ILOCK_EXCL);
> > >  		error = xfs_trans_reserve_quota_nblks(tp, ip, qblocks,
> > >  						      0, quota_flag);
> > > +		/*
> > > +		 * We weren't able to reserve enough quota to handle fallocate.
> > > +		 * Flush any disk space that was being held in the hopes of
> > > +		 * speeding up the filesystem.  We hold the IOLOCK so we cannot
> > > +		 * do a synchronous scan.
> > > +		 */
> > > +		if ((error == -ENOSPC || error == -EDQUOT) && !cleared_space) {
> > > +			xfs_trans_cancel(tp);
> > > +			xfs_iunlock(ip, XFS_ILOCK_EXCL);
> > > +			cleared_space = xfs_inode_free_quota_blocks(ip, false);
> > > +			if (cleared_space)
> > > +				goto retry;
> > > +			return error;
> > 
> > Can't say I'm a fan of repeating this everywhere.  Can we move this
> > into xfs_trans_reserve_quota_nblks() with a "retry" flag such that
> > we do:
> > 
> > 	error = xfs_trans_reserve_quota_nblks(tp, ip, qblocks, 0,
> > 					quota_flag, &retry);
> > 	if (error) {
> > 		/* tp already cancelled, inode unlocked */
> > 		return error;
> > 	}
> > 	if (retry) {
> > 		/* tp already cancelled, inode unlocked */
> > 		goto retry;
> > 	}
> 
> Assuming you'd be interested in the same kind of change being applied to
> the next patch (kick the inode reclaim from xfs_trans_reserve on ENOSPC)
> then yes, that seems like a nice cleanup.

*nod*

It definitely seems to me to be cleaner to put all this GC stuff
into the transaction setup code that does the actual space
reservation, and then simply have the code that is setting up the
transactions handle failures appropriately.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
