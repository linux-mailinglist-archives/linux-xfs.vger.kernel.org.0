Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B40A7418D8
	for <lists+linux-xfs@lfdr.de>; Wed, 12 Jun 2019 01:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405796AbfFKXYs (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 11 Jun 2019 19:24:48 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:43079 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405384AbfFKXYr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jun 2019 19:24:47 -0400
Received: from dread.disaster.area (pa49-195-189-25.pa.nsw.optusnet.com.au [49.195.189.25])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id CF316105F03B;
        Wed, 12 Jun 2019 09:24:44 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1haq7H-00035u-3q; Wed, 12 Jun 2019 09:23:47 +1000
Date:   Wed, 12 Jun 2019 09:23:47 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 02/10] xfs: convert quotacheck to use the new iwalk
 functions
Message-ID: <20190611232347.GE14363@dread.disaster.area>
References: <155968496814.1657646.13743491598480818627.stgit@magnolia>
 <155968498085.1657646.3518168545540841602.stgit@magnolia>
 <20190610135848.GB6473@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190610135848.GB6473@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0 cx=a_idp_d
        a=K5LJ/TdJMXINHCwnwvH1bQ==:117 a=K5LJ/TdJMXINHCwnwvH1bQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=dq6fvYVFJ5YA:10
        a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=IQN3rknsCWRaDoeJ1yMA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 10, 2019 at 09:58:52AM -0400, Brian Foster wrote:
> On Tue, Jun 04, 2019 at 02:49:40PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Convert quotacheck to use the new iwalk iterator to dig through the
> > inodes.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > Reviewed-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_qm.c |   62 ++++++++++++++++++-------------------------------------
> >  1 file changed, 20 insertions(+), 42 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> > index aa6b6db3db0e..a5b2260406a8 100644
> > --- a/fs/xfs/xfs_qm.c
> > +++ b/fs/xfs/xfs_qm.c
> ...
> > @@ -1136,20 +1135,18 @@ xfs_qm_dqusage_adjust(
> >  	 * rootino must have its resources accounted for, not so with the quota
> >  	 * inodes.
> >  	 */
> > -	if (xfs_is_quota_inode(&mp->m_sb, ino)) {
> > -		*res = BULKSTAT_RV_NOTHING;
> > -		return -EINVAL;
> > -	}
> > +	if (xfs_is_quota_inode(&mp->m_sb, ino))
> > +		return 0;
> >  
> >  	/*
> >  	 * We don't _need_ to take the ilock EXCL here because quotacheck runs
> >  	 * at mount time and therefore nobody will be racing chown/chproj.
> >  	 */
> > -	error = xfs_iget(mp, NULL, ino, XFS_IGET_DONTCACHE, 0, &ip);
> > -	if (error) {
> > -		*res = BULKSTAT_RV_NOTHING;
> > +	error = xfs_iget(mp, tp, ino, XFS_IGET_DONTCACHE, 0, &ip);
> 
> I was wondering if we should start using IGET_UNTRUSTED here, but I
> guess we're 1.) protected by quotacheck context and 2.) have the same
> record validity semantics as the existing bulkstat walker. LGTM:

FWIW, I'd be wanting to go the other way with bulkstat. i.e. finding
ways of reducing IGET_UNTRUSTED in bulkstat because it adds
substantial CPU overhead during inode lookup because it has to look
up the inobt to validate the inode number. i.e. we are locking the
AGI and doing an inobt lookup on every inode we bulkstat because
there is some time between the initial inobt lookup and the
xfs_iget() call and that's when the inode chunk can get removed.

IOWs, we only need to validate that the inode buffer still contains
inodes before we start instantiating inodes from it, but because we
don't hold any locks across individual inode processing in bulkstat
we have to revalidate that buffer contains inodes for every
allocated inode in that buffer. If we had a way of passing a locked
cluster buffer into xfs_iget to avoid having to look it up and read
it, we could do a single inode cluster read after validating the
inobt record is still valid, we could cycle all the remaining inodes
through xfs_iget() without having to use IGET_UNTRUSTED to validate
the inode cluster still contains valid inodes on every inode....

We still need to cycle inodes through the cache (so bulkstat is
coherent with other inode operations), but this would substantially
reduce the per-inode bulkstat CPU overhead, I think....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
