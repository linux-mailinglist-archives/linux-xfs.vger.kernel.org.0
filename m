Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A42770E01
	for <lists+linux-xfs@lfdr.de>; Tue, 23 Jul 2019 02:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731718AbfGWARV (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 22 Jul 2019 20:17:21 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:45859 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726283AbfGWARV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Jul 2019 20:17:21 -0400
Received: from dread.disaster.area (pa49-195-139-63.pa.nsw.optusnet.com.au [49.195.139.63])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 9C30C1AD49F;
        Tue, 23 Jul 2019 10:17:18 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hpiTR-0002BI-0u; Tue, 23 Jul 2019 10:16:09 +1000
Date:   Tue, 23 Jul 2019 10:16:09 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: add kmem allocation trace points
Message-ID: <20190723001608.GR7689@dread.disaster.area>
References: <20190722233452.31183-1-david@fromorbit.com>
 <20190723000629.GG7093@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190723000629.GG7093@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0 cx=a_idp_d
        a=fNT+DnnR6FjB+3sUuX8HHA==:117 a=fNT+DnnR6FjB+3sUuX8HHA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=0o9FgrsRnhwA:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=By2uiKbROOBojlMjYw4A:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jul 22, 2019 at 05:06:29PM -0700, Darrick J. Wong wrote:
> On Tue, Jul 23, 2019 at 09:34:52AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > When trying to correlate XFS kernel allocations to memory reclaim
> > behaviour, it is useful to know what allocations XFS is actually
> > attempting. This information is not directly available from
> > tracepoints in the generic memory allocation and reclaim
> > tracepoints, so these new trace points provide a high level
> > indication of what the XFS memory demand actually is.
> > 
> > There is no per-filesystem context in this code, so we just trace
> > the type of allocation, the size and the iallocation constraints.
> > The kmem code alos doesn't include much of the common XFS headers,
> > so there are a few definitions that need to be added to the trace
> > headers and a couple of types that need to be made common to avoid
> > needing to include the whole world in the kmem code.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/kmem.c             | 11 +++++++++--
> >  fs/xfs/libxfs/xfs_types.h |  8 ++++++++
> >  fs/xfs/xfs_mount.h        |  7 -------
> >  fs/xfs/xfs_trace.h        | 33 +++++++++++++++++++++++++++++++++
> >  4 files changed, 50 insertions(+), 9 deletions(-)
> > 
> > diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
> > index 16bb9a328678..edcf393c8fd9 100644
> > --- a/fs/xfs/kmem.c
> > +++ b/fs/xfs/kmem.c
> > @@ -3,10 +3,10 @@
> >   * Copyright (c) 2000-2005 Silicon Graphics, Inc.
> >   * All Rights Reserved.
> >   */
> > -#include <linux/sched/mm.h>
> > +#include "xfs.h"
> >  #include <linux/backing-dev.h>
> > -#include "kmem.h"
> >  #include "xfs_message.h"
> > +#include "xfs_trace.h"
> >  
> >  void *
> >  kmem_alloc(size_t size, xfs_km_flags_t flags)
> > @@ -15,6 +15,8 @@ kmem_alloc(size_t size, xfs_km_flags_t flags)
> >  	gfp_t	lflags = kmem_flags_convert(flags);
> >  	void	*ptr;
> >  
> > +	trace_kmem_alloc(size, flags, _RET_IP_);
> > +
> >  	do {
> >  		ptr = kmalloc(size, lflags);
> >  		if (ptr || (flags & (KM_MAYFAIL|KM_NOSLEEP)))
> > @@ -35,6 +37,8 @@ kmem_alloc_large(size_t size, xfs_km_flags_t flags)
> >  	void	*ptr;
> >  	gfp_t	lflags;
> >  
> > +	trace_kmem_alloc_large(size, flags, _RET_IP_);
> > +
> >  	ptr = kmem_alloc(size, flags | KM_MAYFAIL);
> >  	if (ptr)
> >  		return ptr;
> > @@ -65,6 +69,8 @@ kmem_realloc(const void *old, size_t newsize, xfs_km_flags_t flags)
> >  	gfp_t	lflags = kmem_flags_convert(flags);
> >  	void	*ptr;
> >  
> > +	trace_kmem_realloc(newsize, flags, _RET_IP_);
> > +
> >  	do {
> >  		ptr = krealloc(old, newsize, lflags);
> >  		if (ptr || (flags & (KM_MAYFAIL|KM_NOSLEEP)))
> > @@ -85,6 +91,7 @@ kmem_zone_alloc(kmem_zone_t *zone, xfs_km_flags_t flags)
> >  	gfp_t	lflags = kmem_flags_convert(flags);
> >  	void	*ptr;
> >  
> > +	trace_kmem_zone_alloc(0, flags, _RET_IP_);
> >  	do {
> >  		ptr = kmem_cache_alloc(zone, lflags);
> >  		if (ptr || (flags & (KM_MAYFAIL|KM_NOSLEEP)))
> > diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> > index 802b34cd10fe..300b3e91ca3a 100644
> > --- a/fs/xfs/libxfs/xfs_types.h
> > +++ b/fs/xfs/libxfs/xfs_types.h
> > @@ -169,6 +169,14 @@ typedef struct xfs_bmbt_irec
> >  	xfs_exntst_t	br_state;	/* extent state */
> >  } xfs_bmbt_irec_t;
> >  
> > +/* per-AG block reservation types */
> > +enum xfs_ag_resv_type {
> > +	XFS_AG_RESV_NONE = 0,
> > +	XFS_AG_RESV_AGFL,
> > +	XFS_AG_RESV_METADATA,
> > +	XFS_AG_RESV_RMAPBT,
> > +};
> > +
> >  /*
> >   * Type verifier functions
> >   */
> > diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> > index 4adb6837439a..fdb60e09a9c5 100644
> > --- a/fs/xfs/xfs_mount.h
> > +++ b/fs/xfs/xfs_mount.h
> > @@ -327,13 +327,6 @@ xfs_daddr_to_agbno(struct xfs_mount *mp, xfs_daddr_t d)
> >  }
> >  
> >  /* per-AG block reservation data structures*/
> > -enum xfs_ag_resv_type {
> > -	XFS_AG_RESV_NONE = 0,
> > -	XFS_AG_RESV_AGFL,
> > -	XFS_AG_RESV_METADATA,
> > -	XFS_AG_RESV_RMAPBT,
> > -};
> > -
> 
> Hmm, what does moving this chunk enable?  I don't see the immediate
> relevants to the added tracepoints...?  (insofar as "ZOMG MACROS OH MY EYES")

The enum is used in a tracepoint class definition:

DECLARE_EVENT_CLASS(xfs_ag_resv_class,
	TP_PROTO(struct xfs_perag *pag, enum xfs_ag_resv_type resv,
		 xfs_extlen_t len),
	TP_ARGS(pag, resv, len),

And requiring an include of xfs_mount.h in kmem.c pulls in about
10 other irrelevent include file dependencies....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
