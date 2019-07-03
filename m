Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 576D05ED1B
	for <lists+linux-xfs@lfdr.de>; Wed,  3 Jul 2019 22:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbfGCUCA (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 3 Jul 2019 16:02:00 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:55640 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726739AbfGCUCA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Jul 2019 16:02:00 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x63JxDJn108966;
        Wed, 3 Jul 2019 20:01:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=stIIMCAg5MJnQ+ynksxMWv4mm3atyqkIYry8r1keeR4=;
 b=kE9nqv16trcUWVzFMcNm9VWBuNuAIyNwr62ISKMrTYLcI0zCjRVQfDAy0u4p1Zn0QA4p
 1n1ru0HJIQ4kg6L1eno6k+NFjF39VwB1ujL/HyWCVsX/dACOaWD1ySp4c0vnhMp0I9n8
 KoXQ+K9g3iT+wTr6OzbzXUBhAhLk/ligDY3YwAsZ+LejcTQn5euSX9JEEu4burbVkOIV
 mpERw4yRioBNOKGm6zu00n1qCaF/oKSvF6WIQl5PS/WGl0pUrPTO9LUlMMoZGwKc32rf
 H8x9cjzv/d9Ld/1XXrVa+e20Kl85epbZD7dVVuHL22WdRe+2k3SXJugKzjDJAF5Y22X2 GQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2te5tbucyd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Jul 2019 20:01:46 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x63JvZfw003706;
        Wed, 3 Jul 2019 20:01:46 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 2tebamjgsp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Jul 2019 20:01:45 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x63K1ibK028865;
        Wed, 3 Jul 2019 20:01:44 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 03 Jul 2019 13:01:44 -0700
Date:   Wed, 3 Jul 2019 13:01:43 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Subject: Re: [PATCH 6/9] xfs: wire up the new v5 bulkstat_single ioctl
Message-ID: <20190703200143.GY1404256@magnolia>
References: <156158193320.495715.6675123051075804739.stgit@magnolia>
 <156158197298.495715.10824532259700709632.stgit@magnolia>
 <20190703132441.GF26057@bfoster>
 <20190703145256.GU1404256@magnolia>
 <20190703161135.GL26057@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190703161135.GL26057@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9307 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907030244
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9307 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907030245
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 03, 2019 at 12:11:36PM -0400, Brian Foster wrote:
> On Wed, Jul 03, 2019 at 07:52:56AM -0700, Darrick J. Wong wrote:
> > On Wed, Jul 03, 2019 at 09:24:41AM -0400, Brian Foster wrote:
> > > On Wed, Jun 26, 2019 at 01:46:13PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > Wire up the V5 BULKSTAT_SINGLE ioctl and rename the old one V1.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> > > >  fs/xfs/libxfs/xfs_fs.h |   16 ++++++++++
> > > >  fs/xfs/xfs_ioctl.c     |   79 ++++++++++++++++++++++++++++++++++++++++++++++++
> > > >  fs/xfs/xfs_ioctl32.c   |    1 +
> > > >  fs/xfs/xfs_ondisk.h    |    1 +
> > > >  4 files changed, 97 insertions(+)
> > > > 
> > > > 
> > > > diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> > > > index 960f3542e207..95d0411dae9b 100644
> > > > --- a/fs/xfs/libxfs/xfs_fs.h
> > > > +++ b/fs/xfs/libxfs/xfs_fs.h
> > > > @@ -468,6 +468,16 @@ struct xfs_bulk_ireq {
> > > >  
> > > >  #define XFS_BULK_IREQ_FLAGS_ALL	(0)
> > > >  
> > > > +/* Header for a single inode request. */
> > > > +struct xfs_ireq {
> > > > +	uint64_t	ino;		/* I/O: start with this inode	*/
> > > > +	uint32_t	flags;		/* I/O: operation flags		*/
> > > > +	uint32_t	reserved32;	/* must be zero			*/
> > > > +	uint64_t	reserved[2];	/* must be zero			*/
> > > > +};
> > > > +
> > > > +#define XFS_IREQ_FLAGS_ALL	(0)
> > > > +
> > > >  /*
> > > >   * ioctl structures for v5 bulkstat and inumbers requests
> > > >   */
> > > > @@ -478,6 +488,11 @@ struct xfs_bulkstat_req {
> > > >  #define XFS_BULKSTAT_REQ_SIZE(nr)	(sizeof(struct xfs_bulkstat_req) + \
> > > >  					 (nr) * sizeof(struct xfs_bulkstat))
> > > >  
> > > > +struct xfs_bulkstat_single_req {
> > > > +	struct xfs_ireq		hdr;
> > > > +	struct xfs_bulkstat	bulkstat;
> > > > +};
> > > > +
> > > 
> > > What's the reasoning for separate data structures when the single
> > > command is basically a subset of standard bulkstat (similar to the older
> > > interface)?
> > 
> > I split them up to avoid having irrelevant bulk_req fields (specifically
> > icount and ocount) cluttering up the single_req header.  In patch 9 the
> > bulkstat single command grows the ability to request the root inode to
> > fix xfsdump's inability to correctly guess the root directory.
> > 
> 
> Ok, figured as much once I got to the magic inode flag patch. It's
> probably reasonable either way, the tradeoff to this approach is the
> extra boilerplate code associated with processing the separate data
> structure.

<nod>

> Thinking about it a bit more.. what was the purpose of the separate
> BULKSTAT_SINGLE command in the first place? AFAICT it just toggles the
> hacky ->lastip semantic. If we've addressed that with an entirely new
> data structure, do we need the separate ioctl at all anymore?

At the moment, somewhat simpler setup in userspace:

	struct xfs_bulkstat_single_req b = { 0 };
	int ret;

	b.hdr.ino = some_ino;
	ret = ioctl(fd, XFS_IOC_BULKSTAT_SINGLE, &b);
	if (ret)
		abort();

	printf("%d\n", b.bulkstat.bs_ino);

vs. a single-inode bulkstat:

	struct xfs_bulkstat_req *b;
	int ret;

	b = calloc(1, XFS_BULKSTAT_REQ_SIZE(1));
	if (!b)
		abort();

	b->hdr.ino = some_ino;
	ret = ioctl(fd, XFS_IOC_BULKSTAT, b);
	if (ret)
		abort();

	if (b->hdr.ocount)
		printf("%d\n", b->bulkstat[0].bs_ino);

	free(b);

AFAICT, the main advantages are (1) replacing the heap allocation with a
stack allocation and (2) not cluttering the regular bulkstat with the
"just grab this one symbolic inode" interface.  We could very well just
drop this one, particularly since I'm in the process of wrapping most of
the ioctl invocation complexity in libfrog wrapper functions anyway...

--D

> Brian
> 
> > --D
> > 
> > > Brian
> > > 
> > > >  /*
> > > >   * Error injection.
> > > >   */
> > > > @@ -780,6 +795,7 @@ struct xfs_scrub_metadata {
> > > >  #define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, uint32_t)
> > > >  #define XFS_IOC_FSGEOMETRY	     _IOR ('X', 126, struct xfs_fsop_geom)
> > > >  #define XFS_IOC_BULKSTAT	     _IOR ('X', 127, struct xfs_bulkstat_req)
> > > > +#define XFS_IOC_BULKSTAT_SINGLE	     _IOR ('X', 128, struct xfs_bulkstat_single_req)
> > > >  /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
> > > >  
> > > >  
> > > > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > > > index cf6a38c2a3ed..2c821fa601a4 100644
> > > > --- a/fs/xfs/xfs_ioctl.c
> > > > +++ b/fs/xfs/xfs_ioctl.c
> > > > @@ -922,6 +922,83 @@ xfs_ioc_bulkstat(
> > > >  	return 0;
> > > >  }
> > > >  
> > > > +/*
> > > > + * Check the incoming singleton request @hdr from userspace and initialize the
> > > > + * internal @breq bulk request appropriately.  Returns 0 if the bulk request
> > > > + * should proceed; or the usual negative error code.
> > > > + */
> > > > +static int
> > > > +xfs_ireq_setup(
> > > > +	struct xfs_mount	*mp,
> > > > +	struct xfs_ireq		*hdr,
> > > > +	struct xfs_ibulk	*breq,
> > > > +	void __user		*ubuffer)
> > > > +{
> > > > +	if ((hdr->flags & ~XFS_IREQ_FLAGS_ALL) ||
> > > > +	    hdr->reserved32 ||
> > > > +	    memchr_inv(hdr->reserved, 0, sizeof(hdr->reserved)))
> > > > +		return -EINVAL;
> > > > +
> > > > +	if (XFS_INO_TO_AGNO(mp, hdr->ino) >= mp->m_sb.sb_agcount)
> > > > +		return -EINVAL;
> > > > +
> > > > +	breq->ubuffer = ubuffer;
> > > > +	breq->icount = 1;
> > > > +	breq->startino = hdr->ino;
> > > > +	return 0;
> > > > +}
> > > > +
> > > > +/*
> > > > + * Update the userspace singleton request @hdr to reflect the end state of the
> > > > + * internal bulk request @breq.  If @error is negative then we return just
> > > > + * that; otherwise we copy the state so that userspace can discover what
> > > > + * happened.
> > > > + */
> > > > +static void
> > > > +xfs_ireq_teardown(
> > > > +	struct xfs_ireq		*hdr,
> > > > +	struct xfs_ibulk	*breq)
> > > > +{
> > > > +	hdr->ino = breq->startino;
> > > > +}
> > > > +
> > > > +/* Handle the v5 bulkstat_single ioctl. */
> > > > +STATIC int
> > > > +xfs_ioc_bulkstat_single(
> > > > +	struct xfs_mount	*mp,
> > > > +	unsigned int		cmd,
> > > > +	struct xfs_bulkstat_single_req __user *arg)
> > > > +{
> > > > +	struct xfs_ireq		hdr;
> > > > +	struct xfs_ibulk	breq = {
> > > > +		.mp		= mp,
> > > > +	};
> > > > +	int			error;
> > > > +
> > > > +	if (!capable(CAP_SYS_ADMIN))
> > > > +		return -EPERM;
> > > > +
> > > > +	if (XFS_FORCED_SHUTDOWN(mp))
> > > > +		return -EIO;
> > > > +
> > > > +	if (copy_from_user(&hdr, &arg->hdr, sizeof(hdr)))
> > > > +		return -EFAULT;
> > > > +
> > > > +	error = xfs_ireq_setup(mp, &hdr, &breq, &arg->bulkstat);
> > > > +	if (error)
> > > > +		return error;
> > > > +
> > > > +	error = xfs_bulkstat_one(&breq, xfs_bulkstat_fmt);
> > > > +	if (error)
> > > > +		return error;
> > > > +
> > > > +	xfs_ireq_teardown(&hdr, &breq);
> > > > +	if (copy_to_user(&arg->hdr, &hdr, sizeof(hdr)))
> > > > +		return -EFAULT;
> > > > +
> > > > +	return 0;
> > > > +}
> > > > +
> > > >  STATIC int
> > > >  xfs_ioc_fsgeometry(
> > > >  	struct xfs_mount	*mp,
> > > > @@ -2088,6 +2165,8 @@ xfs_file_ioctl(
> > > >  
> > > >  	case XFS_IOC_BULKSTAT:
> > > >  		return xfs_ioc_bulkstat(mp, cmd, arg);
> > > > +	case XFS_IOC_BULKSTAT_SINGLE:
> > > > +		return xfs_ioc_bulkstat_single(mp, cmd, arg);
> > > >  
> > > >  	case XFS_IOC_FSGEOMETRY_V1:
> > > >  		return xfs_ioc_fsgeometry(mp, arg, 3);
> > > > diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> > > > index df107adbdbf3..6fa0f41dbae5 100644
> > > > --- a/fs/xfs/xfs_ioctl32.c
> > > > +++ b/fs/xfs/xfs_ioctl32.c
> > > > @@ -581,6 +581,7 @@ xfs_file_compat_ioctl(
> > > >  	case FS_IOC_GETFSMAP:
> > > >  	case XFS_IOC_SCRUB_METADATA:
> > > >  	case XFS_IOC_BULKSTAT:
> > > > +	case XFS_IOC_BULKSTAT_SINGLE:
> > > >  		return xfs_file_ioctl(filp, cmd, p);
> > > >  #if !defined(BROKEN_X86_ALIGNMENT) || defined(CONFIG_X86_X32)
> > > >  	/*
> > > > diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> > > > index 954484c6eb96..fa1252657b08 100644
> > > > --- a/fs/xfs/xfs_ondisk.h
> > > > +++ b/fs/xfs/xfs_ondisk.h
> > > > @@ -150,6 +150,7 @@ xfs_check_ondisk_structs(void)
> > > >  	XFS_CHECK_STRUCT_SIZE(struct xfs_bulkstat,		192);
> > > >  	XFS_CHECK_STRUCT_SIZE(struct xfs_inumbers,		24);
> > > >  	XFS_CHECK_STRUCT_SIZE(struct xfs_bulkstat_req,		64);
> > > > +	XFS_CHECK_STRUCT_SIZE(struct xfs_bulkstat_single_req,	224);
> > > >  }
> > > >  
> > > >  #endif /* __XFS_ONDISK_H */
> > > > 
