Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C6247E460
	for <lists+linux-xfs@lfdr.de>; Thu,  1 Aug 2019 22:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730391AbfHAUiB (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 1 Aug 2019 16:38:01 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45960 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725846AbfHAUiB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Aug 2019 16:38:01 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x71KYEl5138677;
        Thu, 1 Aug 2019 20:37:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=+p3XaWobmxG5rrjQ+BH4fQo5zmKBAeHpTjh5o0p8aak=;
 b=BnrDmOCaA/1plILAO0n30jbwEedsLnVtWjQHV5DkzJCkh++9Luey/+Zx8PxeDjbpTPDz
 1VwErt31lGJckhkweZaqsg1pRPXQLHkwafY3pi4B/apvgxBYss10PfVusawacI37GJu1
 0D7DojBAH2bGAYhj7Z76/ki//EMbnLWRmPbO5L6gN1J8aHfa5qopUE2fkyUcT2W1+RR5
 sDzhtBXf53bfmX4MHHpcFPEytMD07Z6vVDV8AXAG/6OT2LZHp9phrZxMIF0szrYC2WN4
 /VNRq3PvJhO0n0IWxmkSKA142rGRPSH+giFkIgNz6AdHH7OwKz9aCKA05hMfUn4iY7z6 zw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2u0ejpx5ne-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Aug 2019 20:37:58 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x71KbvDq099531;
        Thu, 1 Aug 2019 20:37:58 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2u349ebtw6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Aug 2019 20:37:58 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x71Kbv05013288;
        Thu, 1 Aug 2019 20:37:57 GMT
Received: from localhost (/10.145.178.162)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 01 Aug 2019 13:37:57 -0700
Date:   Thu, 1 Aug 2019 13:37:55 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: add kmem allocation trace points
Message-ID: <20190801203755.GB7138@magnolia>
References: <20190722233452.31183-1-david@fromorbit.com>
 <20190723000629.GG7093@magnolia>
 <20190723001608.GR7689@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190723001608.GR7689@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9336 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908010217
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9336 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908010216
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 23, 2019 at 10:16:09AM +1000, Dave Chinner wrote:
> On Mon, Jul 22, 2019 at 05:06:29PM -0700, Darrick J. Wong wrote:
> > On Tue, Jul 23, 2019 at 09:34:52AM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > When trying to correlate XFS kernel allocations to memory reclaim
> > > behaviour, it is useful to know what allocations XFS is actually
> > > attempting. This information is not directly available from
> > > tracepoints in the generic memory allocation and reclaim
> > > tracepoints, so these new trace points provide a high level
> > > indication of what the XFS memory demand actually is.
> > > 
> > > There is no per-filesystem context in this code, so we just trace
> > > the type of allocation, the size and the iallocation constraints.
> > > The kmem code alos doesn't include much of the common XFS headers,
> > > so there are a few definitions that need to be added to the trace
> > > headers and a couple of types that need to be made common to avoid
> > > needing to include the whole world in the kmem code.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  fs/xfs/kmem.c             | 11 +++++++++--
> > >  fs/xfs/libxfs/xfs_types.h |  8 ++++++++
> > >  fs/xfs/xfs_mount.h        |  7 -------
> > >  fs/xfs/xfs_trace.h        | 33 +++++++++++++++++++++++++++++++++
> > >  4 files changed, 50 insertions(+), 9 deletions(-)
> > > 
> > > diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
> > > index 16bb9a328678..edcf393c8fd9 100644
> > > --- a/fs/xfs/kmem.c
> > > +++ b/fs/xfs/kmem.c
> > > @@ -3,10 +3,10 @@
> > >   * Copyright (c) 2000-2005 Silicon Graphics, Inc.
> > >   * All Rights Reserved.
> > >   */
> > > -#include <linux/sched/mm.h>
> > > +#include "xfs.h"
> > >  #include <linux/backing-dev.h>
> > > -#include "kmem.h"
> > >  #include "xfs_message.h"
> > > +#include "xfs_trace.h"
> > >  
> > >  void *
> > >  kmem_alloc(size_t size, xfs_km_flags_t flags)
> > > @@ -15,6 +15,8 @@ kmem_alloc(size_t size, xfs_km_flags_t flags)
> > >  	gfp_t	lflags = kmem_flags_convert(flags);
> > >  	void	*ptr;
> > >  
> > > +	trace_kmem_alloc(size, flags, _RET_IP_);
> > > +
> > >  	do {
> > >  		ptr = kmalloc(size, lflags);
> > >  		if (ptr || (flags & (KM_MAYFAIL|KM_NOSLEEP)))
> > > @@ -35,6 +37,8 @@ kmem_alloc_large(size_t size, xfs_km_flags_t flags)
> > >  	void	*ptr;
> > >  	gfp_t	lflags;
> > >  
> > > +	trace_kmem_alloc_large(size, flags, _RET_IP_);
> > > +
> > >  	ptr = kmem_alloc(size, flags | KM_MAYFAIL);
> > >  	if (ptr)
> > >  		return ptr;
> > > @@ -65,6 +69,8 @@ kmem_realloc(const void *old, size_t newsize, xfs_km_flags_t flags)
> > >  	gfp_t	lflags = kmem_flags_convert(flags);
> > >  	void	*ptr;
> > >  
> > > +	trace_kmem_realloc(newsize, flags, _RET_IP_);
> > > +
> > >  	do {
> > >  		ptr = krealloc(old, newsize, lflags);
> > >  		if (ptr || (flags & (KM_MAYFAIL|KM_NOSLEEP)))
> > > @@ -85,6 +91,7 @@ kmem_zone_alloc(kmem_zone_t *zone, xfs_km_flags_t flags)
> > >  	gfp_t	lflags = kmem_flags_convert(flags);
> > >  	void	*ptr;
> > >  
> > > +	trace_kmem_zone_alloc(0, flags, _RET_IP_);
> > >  	do {
> > >  		ptr = kmem_cache_alloc(zone, lflags);
> > >  		if (ptr || (flags & (KM_MAYFAIL|KM_NOSLEEP)))
> > > diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> > > index 802b34cd10fe..300b3e91ca3a 100644
> > > --- a/fs/xfs/libxfs/xfs_types.h
> > > +++ b/fs/xfs/libxfs/xfs_types.h
> > > @@ -169,6 +169,14 @@ typedef struct xfs_bmbt_irec
> > >  	xfs_exntst_t	br_state;	/* extent state */
> > >  } xfs_bmbt_irec_t;
> > >  
> > > +/* per-AG block reservation types */
> > > +enum xfs_ag_resv_type {
> > > +	XFS_AG_RESV_NONE = 0,
> > > +	XFS_AG_RESV_AGFL,
> > > +	XFS_AG_RESV_METADATA,
> > > +	XFS_AG_RESV_RMAPBT,
> > > +};
> > > +
> > >  /*
> > >   * Type verifier functions
> > >   */
> > > diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> > > index 4adb6837439a..fdb60e09a9c5 100644
> > > --- a/fs/xfs/xfs_mount.h
> > > +++ b/fs/xfs/xfs_mount.h
> > > @@ -327,13 +327,6 @@ xfs_daddr_to_agbno(struct xfs_mount *mp, xfs_daddr_t d)
> > >  }
> > >  
> > >  /* per-AG block reservation data structures*/
> > > -enum xfs_ag_resv_type {
> > > -	XFS_AG_RESV_NONE = 0,
> > > -	XFS_AG_RESV_AGFL,
> > > -	XFS_AG_RESV_METADATA,
> > > -	XFS_AG_RESV_RMAPBT,
> > > -};
> > > -
> > 
> > Hmm, what does moving this chunk enable?  I don't see the immediate
> > relevants to the added tracepoints...?  (insofar as "ZOMG MACROS OH MY EYES")
> 
> The enum is used in a tracepoint class definition:
> 
> DECLARE_EVENT_CLASS(xfs_ag_resv_class,
> 	TP_PROTO(struct xfs_perag *pag, enum xfs_ag_resv_type resv,
> 		 xfs_extlen_t len),
> 	TP_ARGS(pag, resv, len),
> 
> And requiring an include of xfs_mount.h in kmem.c pulls in about
> 10 other irrelevent include file dependencies....
> 

Heh, ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
