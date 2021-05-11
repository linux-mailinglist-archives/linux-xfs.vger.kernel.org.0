Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD41337B0D6
	for <lists+linux-xfs@lfdr.de>; Tue, 11 May 2021 23:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbhEKVeW (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 11 May 2021 17:34:22 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:55390 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229637AbhEKVeW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 May 2021 17:34:22 -0400
Received: from dread.disaster.area (pa49-179-143-157.pa.nsw.optusnet.com.au [49.179.143.157])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 14F775EBCDC;
        Wed, 12 May 2021 07:33:13 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lga08-00EPrf-IS; Wed, 12 May 2021 07:33:12 +1000
Date:   Wed, 12 May 2021 07:33:12 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/22] xfs: make for_each_perag... a first class citizen
Message-ID: <20210511213312.GT63242@dread.disaster.area>
References: <20210506072054.271157-1-david@fromorbit.com>
 <20210506072054.271157-5-david@fromorbit.com>
 <YJks5KC4l9N9/vIT@bfoster>
 <20210511073519.GS63242@dread.disaster.area>
 <YJp4sqtlkMRodcNx@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJp4sqtlkMRodcNx@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=I9rzhn+0hBG9LkCzAun3+g==:117 a=I9rzhn+0hBG9LkCzAun3+g==:17
        a=kj9zAlcOel0A:10 a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=ZluySElCvhP1ejyS-QEA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 11, 2021 at 08:29:38AM -0400, Brian Foster wrote:
> On Tue, May 11, 2021 at 05:35:19PM +1000, Dave Chinner wrote:
> > On Mon, May 10, 2021 at 08:53:56AM -0400, Brian Foster wrote:
> > > On Thu, May 06, 2021 at 05:20:36PM +1000, Dave Chinner wrote:
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > > 
> > > > for_each_perag_tag() is defined in xfs_icache.c for local use.
> > > > Promote this to xfs_ag.h and define equivalent iteration functions
> > > > so that we can use them to iterate AGs instead to replace open coded
> > > > perag walks and perag lookups.
> > > > 
> > > > We also convert as many of the straight forward open coded AG walks
> > > > to use these iterators as possible. Anything that is not a direct
> > > > conversion to an iterator is ignored and will be updated in future
> > > > commits.
> > > > 
> > > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > > ---
> > > >  fs/xfs/libxfs/xfs_ag.h    | 17 +++++++++++++++++
> > > >  fs/xfs/scrub/fscounters.c | 36 ++++++++++++++----------------------
> > > >  fs/xfs/xfs_extent_busy.c  |  7 ++-----
> > > >  fs/xfs/xfs_fsops.c        |  8 ++------
> > > >  fs/xfs/xfs_health.c       |  4 +---
> > > >  fs/xfs/xfs_icache.c       | 15 ++-------------
> > > >  6 files changed, 38 insertions(+), 49 deletions(-)
> > > > 
> > > ...
> > > > diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
> > > > index 453ae9adf94c..2dfdac566399 100644
> > > > --- a/fs/xfs/scrub/fscounters.c
> > > > +++ b/fs/xfs/scrub/fscounters.c
> > > ...
> > > > @@ -229,12 +224,9 @@ xchk_fscount_aggregate_agcounts(
> > > >  		fsc->fdblocks -= pag->pag_meta_resv.ar_reserved;
> > > >  		fsc->fdblocks -= pag->pag_rmapbt_resv.ar_orig_reserved;
> > > >  
> > > > -		xfs_perag_put(pag);
> > > > -
> > > > -		if (xchk_should_terminate(sc, &error))
> > > > -			break;
> > > >  	}
> > > > -
> > > > +	if (pag)
> > > > +		xfs_perag_put(pag);
> > > 
> > > It's not shown in the diff, but there is still an exit path out of the
> > > above loop that calls xfs_perag_put(). The rest of the patch LGTM.
> > 
> > Good spot. Fixed.
> > 
> > FWIW, I'm not entirely happy with the way the iterator can break and
> > require conditional cleanup. I'm thinking that I'll come back to
> > these and convert them to a iterator structure that will turn this
> > into the pattern:
> > 
> > 	perag_iter_init(&iter, start_agno, end_agno);
> > 	for_each_perag(pag, iter) {
> > 		....
> > 	}
> > 	perag_iter_done(&iter);
> > 
> > and so the code doesn't need to care about whether it exits the loop
> > via a break or running out of perags to iterate. I haven't fully
> > thought this through, though, so I'm leaving it alone for now...
> > 
> 
> I think something like that would be an improvement. It's
> straightforward enough to follow through these changes with the loop
> break quirk in mind, but I suspect that somebody modifying (and/or
> reviewing) related code farther in the future might very easily miss
> something like an external put being required if a loop is modified to
> break out early.

*nod*

I think I'll need to address this when I do the conversion of these
iterators to use active references to pin or skip perags that are
being torn down. The iterators becomes slightly more complex at this
point, so that's probably the best point to address this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
