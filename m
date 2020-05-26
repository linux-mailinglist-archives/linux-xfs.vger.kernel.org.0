Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9011C1A53
	for <lists+linux-xfs@lfdr.de>; Fri,  1 May 2020 18:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729278AbgEAQIS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 1 May 2020 12:08:18 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48376 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728495AbgEAQIR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 12:08:17 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 041G7ZTw034569;
        Fri, 1 May 2020 16:08:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=SOlPVJPhVf7EtQxCSDM/RGe2RpnwdzWdwyZmiblFwH0=;
 b=FGiLgUhA5taoFA4sHXbCEM5dPSVqESDBCEbMHS4M+nA3W3M6YaFapJU2grvuBLVbICjC
 DurtizIIIxz44cZUzBXk5gOIwPJ+tFgN9MyHZ5MciIpxrg8vWgmdAJW9AGcdS4LphEvf
 f/lCi09q6H6oFBKVKryfw5S/nKmikwVY8Bn/UbJ3XdSxnXR8O/lcKwyEq8hwDmKbRdl9
 G/tIEIgjizPjXWPapubATwOp1zHbrKJnYZ6rP8bwPQ7md/vUKMoHBz+nVfKUFNn75dF8
 +IAhZVUKLahcTGDKmGi24JXvZApIiFB3wYYcPfV9FYX4ZWgIgzoRfl5G1DxmFL7lKE3E kA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 30r7f5twvh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 May 2020 16:08:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 041G7SRT104160;
        Fri, 1 May 2020 16:08:11 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 30r7fh05aj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 01 May 2020 16:08:11 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 041G8ALl014613;
        Fri, 1 May 2020 16:08:10 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 01 May 2020 09:08:10 -0700
Date:   Fri, 1 May 2020 09:08:09 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/12] xfs: remove xfs_ifork_ops
Message-ID: <20200501160809.GT6742@magnolia>
References: <20200501081424.2598914-1-hch@lst.de>
 <20200501081424.2598914-9-hch@lst.de>
 <20200501155649.GO40250@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501155649.GO40250@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9608 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 mlxlogscore=999 phishscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005010126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9608 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 adultscore=0 mlxlogscore=999
 clxscore=1015 phishscore=0 impostorscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005010126
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 01, 2020 at 11:56:49AM -0400, Brian Foster wrote:
> On Fri, May 01, 2020 at 10:14:20AM +0200, Christoph Hellwig wrote:
> > xfs_ifork_ops add up to two indirect calls per inode read and flush,
> > despite just having a single instance in the kernel.  In xfsprogs
> > phase6 in xfs_repair overrides the verify_dir method to deal with inodes
> > that do not have a valid parent.  Instead of the costly indirection just
> > life the repair code into xfs_dir2_sf.c under a condition that ensures
> > it is compiled as part of a kernel build, but instantly eliminated as
> > it is unreachable.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/libxfs/xfs_dir2_sf.c    | 64 ++++++++++++++++++++++++++++++++--
> >  fs/xfs/libxfs/xfs_inode_fork.c | 19 +++-------
> >  fs/xfs/libxfs/xfs_inode_fork.h | 15 ++------
> >  fs/xfs/xfs_inode.c             |  4 +--
> >  4 files changed, 71 insertions(+), 31 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
> > index 7b7f6fb2ea3b2..1f6c30b68917c 100644
> > --- a/fs/xfs/libxfs/xfs_dir2_sf.c
> > +++ b/fs/xfs/libxfs/xfs_dir2_sf.c
> ...
> > @@ -804,6 +804,66 @@ xfs_dir2_sf_verify(
> >  	return NULL;
> >  }
> >  
> > +/*
> > + * When we're checking directory inodes, we're allowed to set a directory's
> > + * dotdot entry to zero to signal that the parent needs to be reconnected
> > + * during xfs_repair phase 6.  If we're handling a shortform directory the ifork
> > + * verifiers will fail, so temporarily patch out this canary so that we can
> > + * verify the rest of the fork and move on to fixing the dir.
> > + */
> > +static xfs_failaddr_t
> > +xfs_dir2_sf_verify_dir_check(
> > +	struct xfs_inode		*ip)
> > +{
> > +	struct xfs_mount		*mp = ip->i_mount;
> > +	struct xfs_ifork		*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
> > +	struct xfs_dir2_sf_hdr		*sfp =
> > +		(struct xfs_dir2_sf_hdr *)ifp->if_u1.if_data;
> > +	int				size = ifp->if_bytes;
> > +	bool				parent_bypass = false;
> > +	xfs_ino_t			old_parent;
> > +	xfs_failaddr_t			fa;
> > +
> > +	/*
> > +	 * If this is a shortform directory, phase4 in xfs_repair may have set
> > +	 * the parent inode to zero to indicate that it must be fixed.
> > +	 * Temporarily set a valid parent so that the directory verifier will
> > +	 * pass.
> > +	 */
> > +	if (size > offsetof(struct xfs_dir2_sf_hdr, parent) &&
> > +	    size >= xfs_dir2_sf_hdr_size(sfp->i8count)) {
> > +		old_parent = xfs_dir2_sf_get_parent_ino(sfp);
> > +		if (!old_parent) {
> > +			xfs_dir2_sf_put_parent_ino(sfp, mp->m_sb.sb_rootino);
> > +			parent_bypass = true;
> > +		}
> > +	}
> > +
> > +	fa = __xfs_dir2_sf_verify(ip);
> > +
> > +	/* Put it back. */
> > +	if (parent_bypass)
> > +		xfs_dir2_sf_put_parent_ino(sfp, old_parent);
> > +	return fa;
> > +}
> 
> I'm not sure the cleanup is worth the kludge of including repair code in
> the kernel like this. It might be better to reduce or replace ifork_ops
> to a single directory function pointer until there's a reason for this
> to become common. I dunno, maybe others have thoughts...

One of the online repair gaps I haven't figured out how to close yet is
what to do when there's a short format directory that fails validation
(such that iget fails).  The inode repairer gets stuck with the job of
fixing the sf dir, but the (future) directory repair code will have all
the expertise in fixing directories.  Regrettably, it also requires a
working xfs_inode.

So I could just set the sf parent to some obviously garbage value (like
repair does) to make the verifiers pass and then trip the directory
repair, and then this hunk would be useful to have in the kernel.  OTOH
that means more special case flags and other junk, just to end up with
this kludge that sucks even for xfs_repair.

OTOH I have spent quite a bit of time trying to figure out how to kill
that stupid kludge of repair's, and come up emptyhanded, so <shrug>?

--D

> Brian
> 
> > +
> > +/*
> > + * Allow xfs_repair to enable the parent bypass mode.  For now this is entirely
> > + * unused in the kernel, but might come in useful for online repair eventually.
> > + */
> > +#ifndef xfs_inode_parent_bypass
> > +#define xfs_inode_parent_bypass(ip)	0
> > +#endif
> > +
> > +xfs_failaddr_t
> > +xfs_dir2_sf_verify(
> > +	struct xfs_inode		*ip)
> > +{
> > +	if (xfs_inode_parent_bypass(ip))
> > +		return xfs_dir2_sf_verify_dir_check(ip);
> > +	return __xfs_dir2_sf_verify(ip);
> > +}
> > +
> >  /*
> >   * Create a new (shortform) directory.
> >   */
> > diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> > index f30d43364aa92..f6dcee919f59e 100644
> > --- a/fs/xfs/libxfs/xfs_inode_fork.c
> > +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> > @@ -673,18 +673,10 @@ xfs_ifork_init_cow(
> >  	ip->i_cnextents = 0;
> >  }
> >  
> > -/* Default fork content verifiers. */
> > -struct xfs_ifork_ops xfs_default_ifork_ops = {
> > -	.verify_attr	= xfs_attr_shortform_verify,
> > -	.verify_dir	= xfs_dir2_sf_verify,
> > -	.verify_symlink	= xfs_symlink_shortform_verify,
> > -};
> > -
> >  /* Verify the inline contents of the data fork of an inode. */
> >  xfs_failaddr_t
> >  xfs_ifork_verify_data(
> > -	struct xfs_inode	*ip,
> > -	struct xfs_ifork_ops	*ops)
> > +	struct xfs_inode	*ip)
> >  {
> >  	/* Non-local data fork, we're done. */
> >  	if (ip->i_d.di_format != XFS_DINODE_FMT_LOCAL)
> > @@ -693,9 +685,9 @@ xfs_ifork_verify_data(
> >  	/* Check the inline data fork if there is one. */
> >  	switch (VFS_I(ip)->i_mode & S_IFMT) {
> >  	case S_IFDIR:
> > -		return ops->verify_dir(ip);
> > +		return xfs_dir2_sf_verify(ip);
> >  	case S_IFLNK:
> > -		return ops->verify_symlink(ip);
> > +		return xfs_symlink_shortform_verify(ip);
> >  	default:
> >  		return NULL;
> >  	}
> > @@ -704,13 +696,12 @@ xfs_ifork_verify_data(
> >  /* Verify the inline contents of the attr fork of an inode. */
> >  xfs_failaddr_t
> >  xfs_ifork_verify_attr(
> > -	struct xfs_inode	*ip,
> > -	struct xfs_ifork_ops	*ops)
> > +	struct xfs_inode	*ip)
> >  {
> >  	/* There has to be an attr fork allocated if aformat is local. */
> >  	if (ip->i_d.di_aformat != XFS_DINODE_FMT_LOCAL)
> >  		return NULL;
> >  	if (!XFS_IFORK_PTR(ip, XFS_ATTR_FORK))
> >  		return __this_address;
> > -	return ops->verify_attr(ip);
> > +	return xfs_attr_shortform_verify(ip);
> >  }
> > diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
> > index 8487b0c88a75e..3f84d33abd3b7 100644
> > --- a/fs/xfs/libxfs/xfs_inode_fork.h
> > +++ b/fs/xfs/libxfs/xfs_inode_fork.h
> > @@ -176,18 +176,7 @@ extern struct kmem_zone	*xfs_ifork_zone;
> >  
> >  extern void xfs_ifork_init_cow(struct xfs_inode *ip);
> >  
> > -typedef xfs_failaddr_t (*xfs_ifork_verifier_t)(struct xfs_inode *);
> > -
> > -struct xfs_ifork_ops {
> > -	xfs_ifork_verifier_t	verify_symlink;
> > -	xfs_ifork_verifier_t	verify_dir;
> > -	xfs_ifork_verifier_t	verify_attr;
> > -};
> > -extern struct xfs_ifork_ops	xfs_default_ifork_ops;
> > -
> > -xfs_failaddr_t xfs_ifork_verify_data(struct xfs_inode *ip,
> > -		struct xfs_ifork_ops *ops);
> > -xfs_failaddr_t xfs_ifork_verify_attr(struct xfs_inode *ip,
> > -		struct xfs_ifork_ops *ops);
> > +xfs_failaddr_t xfs_ifork_verify_data(struct xfs_inode *ip);
> > +xfs_failaddr_t xfs_ifork_verify_attr(struct xfs_inode *ip);
> >  
> >  #endif	/* __XFS_INODE_FORK_H__ */
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index d1772786af29d..93967278355de 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -3769,7 +3769,7 @@ xfs_inode_verify_forks(
> >  	struct xfs_ifork	*ifp;
> >  	xfs_failaddr_t		fa;
> >  
> > -	fa = xfs_ifork_verify_data(ip, &xfs_default_ifork_ops);
> > +	fa = xfs_ifork_verify_data(ip);
> >  	if (fa) {
> >  		ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
> >  		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "data fork",
> > @@ -3777,7 +3777,7 @@ xfs_inode_verify_forks(
> >  		return false;
> >  	}
> >  
> > -	fa = xfs_ifork_verify_attr(ip, &xfs_default_ifork_ops);
> > +	fa = xfs_ifork_verify_attr(ip);
> >  	if (fa) {
> >  		ifp = XFS_IFORK_PTR(ip, XFS_ATTR_FORK);
> >  		xfs_inode_verifier_error(ip, -EFSCORRUPTED, "attr fork",
> > -- 
> > 2.26.2
> > 
> 
