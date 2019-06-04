Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 568EA33CAF
	for <lists+linux-xfs@lfdr.de>; Tue,  4 Jun 2019 03:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbfFDBIy (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 3 Jun 2019 21:08:54 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55128 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726136AbfFDBIy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Jun 2019 21:08:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5418pvd062118;
        Tue, 4 Jun 2019 01:08:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=Mvo8SdgmLG0qM8I0F3MtRzziK7eSsUhA/lSpV75r6yo=;
 b=Mhq6Kcbrk4mr5ccbnIK4WT6LsZgCF+bdmSa0Z0sgKEd2//xPcvM6hX3Np6OqTpuhh+uw
 b6p/DnQ0CANISZ0Sex64KLNLFuj6UtoqvAXnWgirrJpi0SkGOI+ODaXwPs4/BBhFuOoO
 nVJkinj6SivzM7AWnfSjMMPUhG9rzIAneM7d/PvEN0IQjz2rlkpq2pHFxN/yH4euIuW/
 Y5ueEKnq0z2JRSKvTaVE4CQNIOm4KSlKDWjJWDbowdGG6JToK3vuJOhxw73MxXnbSlSJ
 OEpcUUY3zXfUw67QcgPwi+2wQ8H8IOQR272FcMs8/NUHpH4hLN8mvzSmCq7EDWU9v2HU OA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2suj0q9ys9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Jun 2019 01:08:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x5418BAx065560;
        Tue, 4 Jun 2019 01:08:50 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2supp7dkdg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Jun 2019 01:08:50 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x5418oG0031231;
        Tue, 4 Jun 2019 01:08:50 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 03 Jun 2019 18:08:49 -0700
Date:   Mon, 3 Jun 2019 18:08:48 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] xfs: fix inode_cluster_size rounding mayhem
Message-ID: <20190604010848.GB1200785@magnolia>
References: <155960225918.1194435.11314723160642989835.stgit@magnolia>
 <155960228579.1194435.18215658650812508577.stgit@magnolia>
 <20190604002507.GK29573@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190604002507.GK29573@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9277 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906040004
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9277 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906040004
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 04, 2019 at 10:25:07AM +1000, Dave Chinner wrote:
> On Mon, Jun 03, 2019 at 03:51:25PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > inode_cluster_size is supposed to represent the size (in bytes) of an
> > inode cluster buffer.  We avoid having to handle multiple clusters per
> > filesystem block on filesystems with large blocks by openly rounding
> > this value up to 1 FSB when necessary.  However, we never reset
> > inode_cluster_size to reflect this new rounded value, which adds to the
> > potential for mistakes in calculating geometries.
> > 
> > Fix this by setting inode_cluster_size to reflect the rounded-up size if
> > needed, and special-case the few places in the sparse inodes code where
> > we actually need the smaller value to validate on-disk metadata.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Looks good - really helps simplify what some of the code does.
> 
> A few minor things below.
> 
> > ---
> >  fs/xfs/libxfs/xfs_format.h     |    8 ++++++--
> >  fs/xfs/libxfs/xfs_ialloc.c     |   19 +++++++++++++++++++
> >  fs/xfs/libxfs/xfs_trans_resv.c |    6 ++----
> >  fs/xfs/xfs_log_recover.c       |    3 +--
> >  fs/xfs/xfs_mount.c             |    4 ++--
> >  5 files changed, 30 insertions(+), 10 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> > index 0e831f04725c..1d3e1e66baf5 100644
> > --- a/fs/xfs/libxfs/xfs_format.h
> > +++ b/fs/xfs/libxfs/xfs_format.h
> > @@ -1698,11 +1698,15 @@ struct xfs_ino_geometry {
> >  	/* Maximum inode count in this filesystem. */
> >  	uint64_t	maxicount;
> >  
> > +	/* Actual inode cluster buffer size, in bytes. */
> > +	unsigned int	inode_cluster_size;
> > +
> >  	/*
> >  	 * Desired inode cluster buffer size, in bytes.  This value is not
> > -	 * rounded up to at least one filesystem block.
> > +	 * rounded up to at least one filesystem block, which is necessary for
> > +	 * validating sb_spino_align.
> >  	 */
> > -	unsigned int	inode_cluster_size;
> > +	unsigned int	inode_cluster_size_raw;
> 
> Can you mention in the comment that this should never be used
> outside of validating sb_spino_align and that inode_cluster_size is
> the value that should be used by all runtime code?

Ok.

> >  	/* Inode cluster sizes, adjusted to be at least 1 fsb. */
> >  	unsigned int	inodes_per_cluster;
> > diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
> > index cff202d0ee4a..976860673b6c 100644
> > --- a/fs/xfs/libxfs/xfs_ialloc.c
> > +++ b/fs/xfs/libxfs/xfs_ialloc.c
> > @@ -2810,6 +2810,16 @@ xfs_ialloc_setup_geometry(
> >  		igeo->maxicount = 0;
> >  	}
> >  
> > +	/*
> > +	 * Compute the desired size of an inode cluster buffer size, which
> > +	 * starts at 8K and (on v5 filesystems) scales up with larger inode
> > +	 * sizes.
> > +	 *
> > +	 * Preserve the desired inode cluster size because the sparse inodes
> > +	 * feature uses that desired size (not the actual size) to compute the
> > +	 * sparse inode alignment.  The mount code validates this value, so we
> > +	 * cannot change the behavior.
> > +	 */
> >  	igeo->inode_cluster_size = XFS_INODE_BIG_CLUSTER_SIZE;
> >  	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> >  		int	new_size = igeo->inode_cluster_size;
> > @@ -2818,12 +2828,21 @@ xfs_ialloc_setup_geometry(
> >  		if (mp->m_sb.sb_inoalignmt >= XFS_B_TO_FSBT(mp, new_size))
> >  			igeo->inode_cluster_size = new_size;
> >  	}
> > +	igeo->inode_cluster_size_raw = igeo->inode_cluster_size;
> 
> I think I'd prefer to see the calculation use
> igeo->inode_cluster_size_raw, and then that gets used to calculate
> igeo->blocks_per_cluster, then igeo->inode_cluster_size is
> calculated from blocks_per_cluster like you've done below. That way
> there is an obvious logic flow to the variable derivation. i.e.
> "this is how we calculate the raw cluster size and this is how we
> calculate the actual runtime cluster size"...

Makes sense.

> > +
> > +	/*
> > +	 * Compute the inode cluster buffer size ratios.  We avoid needing to
> > +	 * handle multiple clusters per filesystem block by rounding up
> > +	 * blocks_per_cluster to 1 if necessary.  Set the inode cluster size
> > +	 * to the actual value.
> > +	 */
> >  	igeo->blocks_per_cluster = xfs_icluster_size_fsb(mp);
> >  	igeo->inodes_per_cluster = XFS_FSB_TO_INO(mp,
> >  			igeo->blocks_per_cluster);
> >  	igeo->cluster_align = xfs_ialloc_cluster_alignment(mp);
> >  	igeo->cluster_align_inodes = XFS_FSB_TO_INO(mp,
> >  			igeo->cluster_align);
> > +	igeo->inode_cluster_size = XFS_FSB_TO_B(mp, igeo->blocks_per_cluster);
> 
> I'd put this immediately after we calculate blocks_per_cluster...

Ok.  Weirdly I just did this to fix up merge conflicts in the patch
stack before I even saw this comment....

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
