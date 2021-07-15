Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90F723C94C2
	for <lists+linux-xfs@lfdr.de>; Thu, 15 Jul 2021 02:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbhGOAI7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 14 Jul 2021 20:08:59 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:35146 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229535AbhGOAI7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Jul 2021 20:08:59 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 7E1AE5D48;
        Thu, 15 Jul 2021 10:06:05 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m3otA-006cvv-Qg; Thu, 15 Jul 2021 10:06:04 +1000
Date:   Thu, 15 Jul 2021 10:06:04 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: detect misaligned rtinherit directory extent size
 hints
Message-ID: <20210715000604.GG664593@dread.disaster.area>
References: <20210714213542.GK22402@magnolia>
 <20210714235049.GF664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714235049.GF664593@dread.disaster.area>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=kj9zAlcOel0A:10 a=e_q4qTt1xDgA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=7-415B0cAAAA:8 a=3ZCFyrmBj5rzNp096TEA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 15, 2021 at 09:50:49AM +1000, Dave Chinner wrote:
> On Wed, Jul 14, 2021 at 02:35:42PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > If we encounter a directory that has been configured to pass on an
> > extent size hint to a new realtime file and the hint isn't an integer
> > multiple of the rt extent size, we should flag the hint for
> > administrative review because that is a misconfiguration (that other
> > parts of the kernel will fix automatically).
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/scrub/inode.c |   18 ++++++++++++++++--
> >  1 file changed, 16 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
> > index 61f90b2c9430..76fbc7ca4cec 100644
> > --- a/fs/xfs/scrub/inode.c
> > +++ b/fs/xfs/scrub/inode.c
> > @@ -73,11 +73,25 @@ xchk_inode_extsize(
> >  	uint16_t		flags)
> >  {
> >  	xfs_failaddr_t		fa;
> > +	uint32_t		value = be32_to_cpu(dip->di_extsize);
> >  
> > -	fa = xfs_inode_validate_extsize(sc->mp, be32_to_cpu(dip->di_extsize),
> > -			mode, flags);
> > +	fa = xfs_inode_validate_extsize(sc->mp, value, mode, flags);
> >  	if (fa)
> >  		xchk_ino_set_corrupt(sc, ino);
> > +
> > +	/*
> > +	 * XFS allows a sysadmin to change the rt extent size when adding a rt
> > +	 * section to a filesystem after formatting.  If there are any
> > +	 * directories with extszinherit and rtinherit set, the hint could
> > +	 * become misaligned with the new rextsize.  The verifier doesn't check
> > +	 * this, because we allow rtinherit directories even without an rt
> > +	 * device.  Flag this as an administrative warning since we will clean
> > +	 * this up eventually.
> > +	 */
> > +	if ((flags & XFS_DIFLAG_RTINHERIT) &&
> > +	    (flags & XFS_DIFLAG_EXTSZINHERIT) &&
> > +	    value % sc->mp->m_sb.sb_rextsize > 0)
> > +		xchk_ino_set_warning(sc, ino);
> >  }
> >  
> >  /*
> 
> Looks good. A warning seems appropriate for scrub in this corner
> case...

so...

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com
