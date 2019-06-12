Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 055BA41971
	for <lists+linux-xfs@lfdr.de>; Wed, 12 Jun 2019 02:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406427AbfFLAdD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 11 Jun 2019 20:33:03 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46442 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407268AbfFLAdD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jun 2019 20:33:03 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5C0U5c5172575;
        Wed, 12 Jun 2019 00:32:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=RD1nUJQ0FPh3HW9njy7z/cFGV8l/KZjl1JldcgMg07Q=;
 b=i3w2/aE7DVnTGR3Lnaxl/cSnQeFpsgTQz0luAh12MLKn0Cf7mDaYQPjP/zP5rxyP3g7c
 LoVNuDMEAYYEBThar5IBDIjD8oswRPuJQ8Jbzafz9rTV7/r7b0QkrqxVN56mSlQoruFg
 tMG+USzWVMkTr9RxHjXs21qO1SaPVarCIS/J2hWdWkAYcwXerYnrFii+vwMnf4J4p1+g
 vinhZin045Q5bwQP81LUgPtxUw4MTbZOKMWO+YLjlrurbCmO4Hhz45TPLq2jCkxyzevF
 4o+Kwo0Isg7MkwZJKDaPt8j9thU2DgxxyJvIdgZo4HXNuH8MXyHJUVzJPAITOSqjHMXW TA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2t04etraev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jun 2019 00:32:24 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5C0VJZN152983;
        Wed, 12 Jun 2019 00:32:23 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2t024upm7x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jun 2019 00:32:23 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5C0WLqN012207;
        Wed, 12 Jun 2019 00:32:22 GMT
Received: from localhost (/10.145.179.81)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 11 Jun 2019 17:32:21 -0700
Date:   Tue, 11 Jun 2019 17:32:19 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 02/10] xfs: convert quotacheck to use the new iwalk
 functions
Message-ID: <20190612003219.GV1871505@magnolia>
References: <155968496814.1657646.13743491598480818627.stgit@magnolia>
 <155968498085.1657646.3518168545540841602.stgit@magnolia>
 <20190610135848.GB6473@bfoster>
 <20190611232347.GE14363@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190611232347.GE14363@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9285 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906120000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9285 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906120001
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 12, 2019 at 09:23:47AM +1000, Dave Chinner wrote:
> On Mon, Jun 10, 2019 at 09:58:52AM -0400, Brian Foster wrote:
> > On Tue, Jun 04, 2019 at 02:49:40PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > 
> > > Convert quotacheck to use the new iwalk iterator to dig through the
> > > inodes.
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > Reviewed-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  fs/xfs/xfs_qm.c |   62 ++++++++++++++++++-------------------------------------
> > >  1 file changed, 20 insertions(+), 42 deletions(-)
> > > 
> > > 
> > > diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> > > index aa6b6db3db0e..a5b2260406a8 100644
> > > --- a/fs/xfs/xfs_qm.c
> > > +++ b/fs/xfs/xfs_qm.c
> > ...
> > > @@ -1136,20 +1135,18 @@ xfs_qm_dqusage_adjust(
> > >  	 * rootino must have its resources accounted for, not so with the quota
> > >  	 * inodes.
> > >  	 */
> > > -	if (xfs_is_quota_inode(&mp->m_sb, ino)) {
> > > -		*res = BULKSTAT_RV_NOTHING;
> > > -		return -EINVAL;
> > > -	}
> > > +	if (xfs_is_quota_inode(&mp->m_sb, ino))
> > > +		return 0;
> > >  
> > >  	/*
> > >  	 * We don't _need_ to take the ilock EXCL here because quotacheck runs
> > >  	 * at mount time and therefore nobody will be racing chown/chproj.
> > >  	 */
> > > -	error = xfs_iget(mp, NULL, ino, XFS_IGET_DONTCACHE, 0, &ip);
> > > -	if (error) {
> > > -		*res = BULKSTAT_RV_NOTHING;
> > > +	error = xfs_iget(mp, tp, ino, XFS_IGET_DONTCACHE, 0, &ip);
> > 
> > I was wondering if we should start using IGET_UNTRUSTED here, but I
> > guess we're 1.) protected by quotacheck context and 2.) have the same
> > record validity semantics as the existing bulkstat walker. LGTM:
> 
> FWIW, I'd be wanting to go the other way with bulkstat. i.e. finding
> ways of reducing IGET_UNTRUSTED in bulkstat because it adds
> substantial CPU overhead during inode lookup because it has to look
> up the inobt to validate the inode number. i.e. we are locking the
> AGI and doing an inobt lookup on every inode we bulkstat because
> there is some time between the initial inobt lookup and the
> xfs_iget() call and that's when the inode chunk can get removed.
> 
> IOWs, we only need to validate that the inode buffer still contains
> inodes before we start instantiating inodes from it, but because we
> don't hold any locks across individual inode processing in bulkstat
> we have to revalidate that buffer contains inodes for every
> allocated inode in that buffer. If we had a way of passing a locked
> cluster buffer into xfs_iget to avoid having to look it up and read
> it, we could do a single inode cluster read after validating the
> inobt record is still valid, we could cycle all the remaining inodes
> through xfs_iget() without having to use IGET_UNTRUSTED to validate
> the inode cluster still contains valid inodes on every inode....
> 
> We still need to cycle inodes through the cache (so bulkstat is
> coherent with other inode operations), but this would substantially
> reduce the per-inode bulkstat CPU overhead, I think....

I'll think about this as an addendum to the series, because I suspect
that remodelling the existing users is going to be an entire series on
its own.  (IOWs, my brain is too tired for today)

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
