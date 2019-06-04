Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC9D733CA6
	for <lists+linux-xfs@lfdr.de>; Tue,  4 Jun 2019 02:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbfFDA62 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 3 Jun 2019 20:58:28 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47126 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbfFDA62 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Jun 2019 20:58:28 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x540mptK049295;
        Tue, 4 Jun 2019 00:58:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=O0hPBnC90geIda7C58DBPTKUpfzkrI3ZrhZk5UtYpXg=;
 b=kdZcrs6bwW4zr6TIKerOgWS72+Zx4Iuu4Xh+bw7SSJnsb+WuS3FnurlGfDSit59+eMiG
 OcMu3NfBI7haw+X0gwzC2S6ZElc2AcZ7WqZ+31plWYcWjrJV9loAYo9sGtPShaq2QG7c
 X4eorP4mUAhELuBSk0UlSRcjT3KkcS70FWcjGhh+juf1rl5fHQe5tTUSJ09CEeFL9qp4
 bE/wom9I1/m8RYXoTud/oeyiZqqNk44fTZtkLXzJwF9Cn8RSNajRPWQAtIqj5CnKEXQH
 2Hn7hTCMASBkcYfn5NBFhro33kXuRrDm9PEFbq1vW4C9r53qcgvFZe4lN92ip7He+hJu sA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2suj0q9y0r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Jun 2019 00:58:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x540u5mb041140;
        Tue, 4 Jun 2019 00:56:25 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2supp7deyt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 04 Jun 2019 00:56:24 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x540uONo022574;
        Tue, 4 Jun 2019 00:56:24 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 03 Jun 2019 17:56:24 -0700
Date:   Mon, 3 Jun 2019 17:56:23 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: refactor inode geometry setup routines
Message-ID: <20190604005623.GA1200785@magnolia>
References: <155960225918.1194435.11314723160642989835.stgit@magnolia>
 <155960227220.1194435.7625646115020669657.stgit@magnolia>
 <20190604001743.GJ29573@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190604001743.GJ29573@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9277 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906040002
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9277 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906040002
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 04, 2019 at 10:17:43AM +1000, Dave Chinner wrote:
> On Mon, Jun 03, 2019 at 03:51:12PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Migrate all of the inode geometry setup code from xfs_mount.c into a
> > single libxfs function that we can share with xfsprogs.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_ialloc.c |   90 +++++++++++++++++++++++++++++++++++++-------
> >  fs/xfs/libxfs/xfs_ialloc.h |    8 ----
> >  fs/xfs/xfs_mount.c         |   83 -----------------------------------------
> >  3 files changed, 78 insertions(+), 103 deletions(-)
> 
> I probably would have moved it to libxfs/xfs_inode_buf.c and
> named it xfs_inode_setup_geometry(), but moving it here has some
> advantages so I'm happy to leave it here. :)

<nod>

> > 
> > - * Compute and fill in value of m_ino_geo.inobt_maxlevels.
> > - */
> > -void
> > -xfs_ialloc_compute_maxlevels(
> > -	xfs_mount_t	*mp)		/* file system mount structure */
> > -{
> > -	uint		inodes;
> > -
> > -	inodes = (1LL << XFS_INO_AGINO_BITS(mp)) >> XFS_INODES_PER_CHUNK_LOG;
> > -	M_IGEO(mp)->inobt_maxlevels = xfs_btree_compute_maxlevels(
> > -			M_IGEO(mp)->inobt_mnr, inodes);
> > -}
> > -
> >  /*
> >   * Log specified fields for the ag hdr (inode section). The growth of the agi
> >   * structure over time requires that we interpret the buffer as two logical
> > @@ -2773,3 +2759,79 @@ xfs_ialloc_count_inodes(
> >  	*freecount = ci.freecount;
> >  	return 0;
> >  }
> > +
> > +/*
> > + * Initialize inode-related geometry information.
> > + *
> > + * Compute the inode btree min and max levels and set maxicount.
> > + *
> > + * Set the inode cluster size.  This may still be overridden by the file
> > + * system block size if it is larger than the chosen cluster size.
> > + *
> > + * For v5 filesystems, scale the cluster size with the inode size to keep a
> > + * constant ratio of inode per cluster buffer, but only if mkfs has set the
> > + * inode alignment value appropriately for larger cluster sizes.
> > + *
> > + * Then compute the inode cluster alignment information.
> > + */
> > +void
> > +xfs_ialloc_setup_geometry(
> > +	struct xfs_mount	*mp)
> > +{
> > +	struct xfs_sb		*sbp = &mp->m_sb;
> > +	struct xfs_ino_geometry	*igeo = M_IGEO(mp);
> > +	uint64_t		icount;
> > +	uint			inodes;
> > +
> > +	/* Compute and fill in value of m_ino_geo.inobt_maxlevels. */
> > +	inodes = (1LL << XFS_INO_AGINO_BITS(mp)) >> XFS_INODES_PER_CHUNK_LOG;
> > +	igeo->inobt_maxlevels = xfs_btree_compute_maxlevels(igeo->inobt_mnr,
> > +			inodes);
> 
> Hmmm - any reason why you didn't move the inobt_mnr/mxr
> initalisation here as well?

Oops, I'll move that too.

> 
> > +
> > +	/* Set the maximum inode count for this filesystem. */
> > +	if (sbp->sb_imax_pct) {
> > +		/*
> > +		 * Make sure the maximum inode count is a multiple
> > +		 * of the units we allocate inodes in.
> > +		 */
> > +		icount = sbp->sb_dblocks * sbp->sb_imax_pct;
> > +		do_div(icount, 100);
> > +		do_div(icount, igeo->ialloc_blks);
> > +		igeo->maxicount = XFS_FSB_TO_INO(mp,
> > +				icount * igeo->ialloc_blks);
> > +	} else {
> > +		igeo->maxicount = 0;
> > +	}
> > +
> > +	igeo->inode_cluster_size = XFS_INODE_BIG_CLUSTER_SIZE;
> > +	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> > +		int	new_size = igeo->inode_cluster_size;
> > +
> > +		new_size *= mp->m_sb.sb_inodesize / XFS_DINODE_MIN_SIZE;
> > +		if (mp->m_sb.sb_inoalignmt >= XFS_B_TO_FSBT(mp, new_size))
> > +			igeo->inode_cluster_size = new_size;
> > +	}
> > +	igeo->blocks_per_cluster = xfs_icluster_size_fsb(mp);
> > +	igeo->inodes_per_cluster = XFS_FSB_TO_INO(mp,
> > +			igeo->blocks_per_cluster);
> > +	igeo->cluster_align = xfs_ialloc_cluster_alignment(mp);
> 
> I'll comment on xfs_icluster_size_fsb() and
> xfs_ialloc_cluster_alignment() here knowing that you make them
> private/static in the next patch: I'd actually remove them and open
> code them here. xfs_icluster_size_fsb() is only called from this
> function and xfs_ialloc_cluster_alignment(), and
> xfs_ialloc_cluster_alignment() is only called from here.
> 
> Given that they are both very short functions, I'd just open code
> them directly here and get rid of them completely like you have with
> xfs_ialloc_compute_maxlevels(). That way everyone is kinda forced to
> use the pre-calculated geometry rather than trying to do it
> themselves and maybe get it wrong...

Ok.

--D

> Otherwise than that, this looks good....
> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
