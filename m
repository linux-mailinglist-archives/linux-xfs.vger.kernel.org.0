Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 684C6386F2B
	for <lists+linux-xfs@lfdr.de>; Tue, 18 May 2021 03:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345747AbhERBbL (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 17 May 2021 21:31:11 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:53554 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238142AbhERBbL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 May 2021 21:31:11 -0400
Received: from dread.disaster.area (pa49-195-118-180.pa.nsw.optusnet.com.au [49.195.118.180])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id A70FF80AFB5;
        Tue, 18 May 2021 11:29:51 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lioYR-002E6I-42; Tue, 18 May 2021 11:29:51 +1000
Date:   Tue, 18 May 2021 11:29:51 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 18/22] xfs: collapse AG selection for inode allocation
Message-ID: <20210518012951.GH2893@dread.disaster.area>
References: <20210506072054.271157-1-david@fromorbit.com>
 <20210506072054.271157-19-david@fromorbit.com>
 <20210512231114.GM8582@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210512231114.GM8582@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=xcwBwyABtj18PbVNKPPJDQ==:117 a=xcwBwyABtj18PbVNKPPJDQ==:17
        a=kj9zAlcOel0A:10 a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=7-415B0cAAAA:8 a=HKCYgVcdAQFlvI52QQEA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 12, 2021 at 04:11:14PM -0700, Darrick J. Wong wrote:
> On Thu, May 06, 2021 at 05:20:50PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > xfs_dialloc_select_ag() does a lot of repetitive work. It first
> > calls xfs_ialloc_ag_select() to select the AG to start allocation
> > attempts in, which can do up to two entire loops across the perags
> > that inodes can be allocated in. This is simply checking if there is
> > spce available to allocate inodes in an AG, and it returns when it
> > finds the first candidate AG.
> > 
> > xfs_dialloc_select_ag() then does it's own iterative walk across
> > all the perags locking the AGIs and trying to allocate inodes from
> > the locked AG. It also doesn't limit the search to mp->m_maxagi,
> > so it will walk all AGs whether they can allocate inodes or not.
> > 
> > Hence if we are really low on inodes, we could do almost 3 entire
> > walks across the whole perag range before we find an allocation
> > group we can allocate inodes in or report ENOSPC.
> > 
> > Because xfs_ialloc_ag_select() returns on the first candidate AG it
> > finds, we can simply do these checks directly in
> > xfs_dialloc_select_ag() before we lock and try to allocate inodes.
> > This reduces the inode allocation pass down to 2 perag sweeps at
> > most - one for aligned inode cluster allocation and if we can't
> > allocate full, aligned inode clusters anywhere we'll do another pass
> > trying to do sparse inode cluster allocation.
> > 
> > This also removes a big chunk of duplicate code.
> 
> Soooooo... we did an AG walk to pick the optimal starting point of an AG
> walk?  Heh.

yup.

> > @@ -1734,16 +1616,23 @@ xfs_dialloc_select_ag(
> >  	struct xfs_perag	*pag;
> >  	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
> >  	bool			okalloc = true;
> > +	int			needspace;
> > +	int			flags;
> >  
> >  	*IO_agbp = NULL;
> >  
> >  	/*
> > -	 * We do not have an agbp, so select an initial allocation
> > -	 * group for inode allocation.
> > +	 * Files of these types need at least one block if length > 0
> > +	 * (and they won't fit in the inode, but that's hard to figure out).
> 
> Uh, what is length here?  Seeing as most directories and symlinks
> probably end up in local format, is this needspace computation really
> true?

Ah, that's the exact text from the comment in
xfs_ialloc_ag_select() above the needspace calculation - I didn't
actually change it at all. :/

> I guess it doesn't hurt to be cautious and assume that directories can
> expand and that people are aggressively symlinking.  But maybe this
> comment could be rephrased to something like:
> 
> 	/*
> 	 * Directories, symlinks, and regular files frequently allocate
> 	 * at least one block, so factor that potential expansion when
> 	 * we examine whether an AG has enough space for file creation.
> 	 */
> 	needspace = S_ISDIR(mode)...;
> 
> With that clarified,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Changed.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
