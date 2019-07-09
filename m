Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30C03637DE
	for <lists+linux-xfs@lfdr.de>; Tue,  9 Jul 2019 16:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbfGIOZl (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 9 Jul 2019 10:25:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50960 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726055AbfGIOZl (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Jul 2019 10:25:41 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E901F7FDF6;
        Tue,  9 Jul 2019 14:25:40 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 91C7051C99;
        Tue,  9 Jul 2019 14:25:40 +0000 (UTC)
Date:   Tue, 9 Jul 2019 10:25:38 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: bump INUMBERS cursor correctly in xfs_inumbers_walk
Message-ID: <20190709142538.GA58362@bfoster>
References: <20190709135943.GF5167@magnolia>
 <20190709142226.GP1404256@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190709142226.GP1404256@magnolia>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Tue, 09 Jul 2019 14:25:40 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 09, 2019 at 07:22:26AM -0700, Darrick J. Wong wrote:
> On Tue, Jul 09, 2019 at 06:59:43AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > There's a subtle unit conversion error when we increment the INUMBERS
> > cursor at the end of xfs_inumbers_walk.  If there's an inode chunk at
> > the very end of the AG /and/ the AG size is a perfect power of two, that
> > means we can have inodes, that means that the startino of that last
> 
> "...is a perfect power of two, the startino of that last chunk..."
> 

Yeah, was going to point out this looked like some stale/spurious
text... :P

> --D
> 
> > chunk (which is in units of AG inodes) will be 63 less than (1 <<
> > agino_log).  If we add XFS_INODES_PER_CHUNK to the startino, we end up
> > with a startino that's larger than (1 << agino_log) and when we convert
> > that back to fs inode units we'll rip off that upper bit and wind up
> > back at the start of the AG.
> > 
> > Fix this by converting to units of fs inodes before adding
> > XFS_INODES_PER_CHUNK so that we'll harmlessly end up pointing to the
> > next AG.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---


Otherwise looks good:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> >  fs/xfs/xfs_itable.c |    5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
> > index cda8ae94480c..a8a06bb78ea8 100644
> > --- a/fs/xfs/xfs_itable.c
> > +++ b/fs/xfs/xfs_itable.c
> > @@ -338,15 +338,14 @@ xfs_inumbers_walk(
> >  		.xi_version	= XFS_INUMBERS_VERSION_V5,
> >  	};
> >  	struct xfs_inumbers_chunk *ic = data;
> > -	xfs_agino_t		agino;
> >  	int			error;
> >  
> >  	error = ic->formatter(ic->breq, &inogrp);
> >  	if (error && error != XFS_IBULK_ABORT)
> >  		return error;
> >  
> > -	agino = irec->ir_startino + XFS_INODES_PER_CHUNK;
> > -	ic->breq->startino = XFS_AGINO_TO_INO(mp, agno, agino);
> > +	ic->breq->startino = XFS_AGINO_TO_INO(mp, agno, irec->ir_startino) +
> > +			XFS_INODES_PER_CHUNK;
> >  	return error;
> >  }
> >  
