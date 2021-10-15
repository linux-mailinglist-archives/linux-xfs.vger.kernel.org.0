Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD82542E548
	for <lists+linux-xfs@lfdr.de>; Fri, 15 Oct 2021 02:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbhJOAjx (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 14 Oct 2021 20:39:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:50420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229656AbhJOAjx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 14 Oct 2021 20:39:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89F2660F9E;
        Fri, 15 Oct 2021 00:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634258267;
        bh=z4qd9fW/gMWQXW9snb8t+aopCZoeFeMusZWC1SUXjrQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DWvqMN4d1yG6eEqrc9i4PGduYdknxhp4/xclPCXQspMjTJzsNW9G3j8Y0C/UWl513
         byowFuLoxve959rh8yE+rfOoarNOFk10flG7P0CVSDNWxKwtyv6QYPOq/mNZF5lQS0
         pdGei/HU9gOzJQJMavTrSiFwefnUNkHxr+RWXAVdeAsTwNd8YQiATzbFtdNxH9sUw/
         KVxFP16dNXCsc6VbFB/s+utwnEpfW00dbByS9nqNAS5bG0SIXqW5urCWWHW5Sy/a3a
         0R3nnHPtWra3RF0yM6PFIybOP3NOgL9N9QRuwKUzdS2TiJJK1+dw7e0JrmsGCif5LR
         ith0PXhtokJxQ==
Date:   Thu, 14 Oct 2021 17:37:47 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, chandan.babu@oracle.com, hch@lst.de
Subject: Re: [PATCH 01/17] xfs: fix incorrect decoding in xchk_btree_cur_fsbno
Message-ID: <20211015003747.GN24307@magnolia>
References: <163424261462.756780.16294781570977242370.stgit@magnolia>
 <163424262046.756780.2366797746965376855.stgit@magnolia>
 <20211014224813.GN2361455@dread.disaster.area>
 <20211014230549.GM24307@magnolia>
 <20211014231702.GW2361455@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211014231702.GW2361455@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 15, 2021 at 10:17:02AM +1100, Dave Chinner wrote:
> On Thu, Oct 14, 2021 at 04:05:49PM -0700, Darrick J. Wong wrote:
> > On Fri, Oct 15, 2021 at 09:48:13AM +1100, Dave Chinner wrote:
> > > On Thu, Oct 14, 2021 at 01:17:00PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > During review of subsequent patches, Dave and I noticed that this
> > > > function doesn't work quite right -- accessing cur->bc_ino depends on
> > > > the ROOT_IN_INODE flag, not LONG_PTRS.  Fix that and the parentheses
> > > > isssue.  While we're at it, remove the piece that accesses cur->bc_ag,
> > > > because block 0 of an AG is never part of a btree.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > ---
> > > >  fs/xfs/scrub/trace.c |    7 ++++---
> > > >  1 file changed, 4 insertions(+), 3 deletions(-)
> > > > 
> > > > 
> > > > diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
> > > > index c0ef53fe6611..93c13763c15e 100644
> > > > --- a/fs/xfs/scrub/trace.c
> > > > +++ b/fs/xfs/scrub/trace.c
> > > > @@ -24,10 +24,11 @@ xchk_btree_cur_fsbno(
> > > >  	if (level < cur->bc_nlevels && cur->bc_bufs[level])
> > > >  		return XFS_DADDR_TO_FSB(cur->bc_mp,
> > > >  				xfs_buf_daddr(cur->bc_bufs[level]));
> > > > -	if (level == cur->bc_nlevels - 1 && cur->bc_flags & XFS_BTREE_LONG_PTRS)
> > > > +
> > > > +	if (level == cur->bc_nlevels - 1 &&
> > > > +	    (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE))
> > > >  		return XFS_INO_TO_FSB(cur->bc_mp, cur->bc_ino.ip->i_ino);
> > > 
> > > Ok.
> > > 
> > > > -	if (!(cur->bc_flags & XFS_BTREE_LONG_PTRS))
> > > > -		return XFS_AGB_TO_FSB(cur->bc_mp, cur->bc_ag.pag->pag_agno, 0);
> > > > +
> > > 
> > > But doesn't this break the tracing code on short pointers as the
> > > tracing code does:
> > > 
> > > 	TP_fast_assign(
> > > 		xfs_fsblock_t fsbno = xchk_btree_cur_fsbno(cur, level);
> > > 		...
> > > 		__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsbno);
> > > 
> > > 
> > > i.e. the tracing will no longer give the correct agno for per-ag
> > > cursors that don't have any buffers attached to them at the current
> > > level?
> > 
> > Hmmm.  By that logic, maybe we should get rid of the (level ==
> > cur->bc_nlevels - 1) check entirely so that any cursor without a buffer
> > attached at that level will always provide *some* kind of breadcrumb to
> > the tracepoints?
> 
> Perhaps so.
> 
> > I almost did that instead, except for the consideration that if you're
> > tracing the online fsck code, you should /probably/ have at least one of
> > xchk_stop/xrep_attempt/xchk_done included in the filter list so you can
> > be certain of what the kernel is checking.
> 
> It doesn't worry me how we resolve this - I just pointed it out
> because it's not mentioned in the commit message and I wanted to
> make sure it wasn't an oversight. If there are better ways to get
> this information from tracepoints and XFS_FSB_TO_AGNO() does
> something safe and obvious with NULLFSBLOCK (e.g. ends up as -1)
> then as long as there's mention of this change in the commit message
> I'm fine with it as it is.

Ok.  I'll add the following to the commit message:

"Note: This changes the btree scrubber tracepoints behavior -- if the
cursor has no buffer for a certain level, it will always report
NULLFSBLOCK.  It is assumed that anyone tracing the online fsck code
will also be tracing xchk_start/xchk_done or otherwise be aware of what
exactly is being scrubbed."

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
