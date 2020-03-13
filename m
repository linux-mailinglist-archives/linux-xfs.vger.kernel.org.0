Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BA54184008
	for <lists+linux-xfs@lfdr.de>; Fri, 13 Mar 2020 05:32:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbgCMEcs (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 13 Mar 2020 00:32:48 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:46533 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726236AbgCMEcr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Mar 2020 00:32:47 -0400
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id BFA057EC906;
        Fri, 13 Mar 2020 15:32:43 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jCc01-00075o-RB; Fri, 13 Mar 2020 15:32:41 +1100
Date:   Fri, 13 Mar 2020 15:32:41 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 6/7] xfs: make the btree cursor union members named
 structure
Message-ID: <20200313043241.GM10776@dread.disaster.area>
References: <158398468107.1307855.8287106235853942996.stgit@magnolia>
 <158398472029.1307855.3111787514328025615.stgit@magnolia>
 <20200312104929.GF60753@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200312104929.GF60753@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=SS2py6AdgQ4A:10
        a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8 a=7-415B0cAAAA:8 a=wzB7MDEo9Z2VQvkqHSMA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 12, 2020 at 06:49:29AM -0400, Brian Foster wrote:
> On Wed, Mar 11, 2020 at 08:45:20PM -0700, Darrick J. Wong wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > we need to name the btree cursor private structures to be able
> > to pull them out of the deeply nested structure definition they are
> > in now.
> > 
> > Based on code extracted from a patchset by Darrick Wong.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_btree.h |   36 +++++++++++++++++++++---------------
> >  1 file changed, 21 insertions(+), 15 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
> > index 12a2bc93371d..9884f543eb51 100644
> > --- a/fs/xfs/libxfs/xfs_btree.h
> > +++ b/fs/xfs/libxfs/xfs_btree.h
> > @@ -188,6 +188,24 @@ union xfs_btree_cur_private {
> >  	} abt;
> >  };
> >  
> > +/* Per-AG btree information. */
> > +struct xfs_btree_cur_ag {
> > +	struct xfs_buf			*agbp;
> > +	xfs_agnumber_t			agno;
> > +	union xfs_btree_cur_private	priv;
> > +};
> > +
> > +/* Btree-in-inode cursor information */
> > +struct xfs_btree_cur_ino {
> > +	struct xfs_inode	*ip;
> > +	int			allocated;
> > +	short			forksize;
> > +	char			whichfork;
> > +	char			flags;
> > +#define	XFS_BTCUR_BMBT_WASDEL	(1 << 0)
> > +#define	XFS_BTCUR_BMBT_INVALID_OWNER	(1 << 1)
> > +};
> > +
> 
> Are all of the per-field comments dropped intentionally? These are
> mostly self-explanatory, so either way:

Yeah, it was intentional, because the comments were redundant and
the meaning is clear from both the name and the use of the variable.
Comments don't always add value...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
