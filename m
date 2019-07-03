Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 096BA5E55E
	for <lists+linux-xfs@lfdr.de>; Wed,  3 Jul 2019 15:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726915AbfGCNYo (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 3 Jul 2019 09:24:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57838 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726621AbfGCNYo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Jul 2019 09:24:44 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B352530832C6;
        Wed,  3 Jul 2019 13:24:43 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 48D9917AB4;
        Wed,  3 Jul 2019 13:24:43 +0000 (UTC)
Date:   Wed, 3 Jul 2019 09:24:41 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com
Subject: Re: [PATCH 6/9] xfs: wire up the new v5 bulkstat_single ioctl
Message-ID: <20190703132441.GF26057@bfoster>
References: <156158193320.495715.6675123051075804739.stgit@magnolia>
 <156158197298.495715.10824532259700709632.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156158197298.495715.10824532259700709632.stgit@magnolia>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Wed, 03 Jul 2019 13:24:43 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 26, 2019 at 01:46:13PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Wire up the V5 BULKSTAT_SINGLE ioctl and rename the old one V1.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_fs.h |   16 ++++++++++
>  fs/xfs/xfs_ioctl.c     |   79 ++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_ioctl32.c   |    1 +
>  fs/xfs/xfs_ondisk.h    |    1 +
>  4 files changed, 97 insertions(+)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
> index 960f3542e207..95d0411dae9b 100644
> --- a/fs/xfs/libxfs/xfs_fs.h
> +++ b/fs/xfs/libxfs/xfs_fs.h
> @@ -468,6 +468,16 @@ struct xfs_bulk_ireq {
>  
>  #define XFS_BULK_IREQ_FLAGS_ALL	(0)
>  
> +/* Header for a single inode request. */
> +struct xfs_ireq {
> +	uint64_t	ino;		/* I/O: start with this inode	*/
> +	uint32_t	flags;		/* I/O: operation flags		*/
> +	uint32_t	reserved32;	/* must be zero			*/
> +	uint64_t	reserved[2];	/* must be zero			*/
> +};
> +
> +#define XFS_IREQ_FLAGS_ALL	(0)
> +
>  /*
>   * ioctl structures for v5 bulkstat and inumbers requests
>   */
> @@ -478,6 +488,11 @@ struct xfs_bulkstat_req {
>  #define XFS_BULKSTAT_REQ_SIZE(nr)	(sizeof(struct xfs_bulkstat_req) + \
>  					 (nr) * sizeof(struct xfs_bulkstat))
>  
> +struct xfs_bulkstat_single_req {
> +	struct xfs_ireq		hdr;
> +	struct xfs_bulkstat	bulkstat;
> +};
> +

What's the reasoning for separate data structures when the single
command is basically a subset of standard bulkstat (similar to the older
interface)?

Brian

>  /*
>   * Error injection.
>   */
> @@ -780,6 +795,7 @@ struct xfs_scrub_metadata {
>  #define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, uint32_t)
>  #define XFS_IOC_FSGEOMETRY	     _IOR ('X', 126, struct xfs_fsop_geom)
>  #define XFS_IOC_BULKSTAT	     _IOR ('X', 127, struct xfs_bulkstat_req)
> +#define XFS_IOC_BULKSTAT_SINGLE	     _IOR ('X', 128, struct xfs_bulkstat_single_req)
>  /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
>  
>  
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index cf6a38c2a3ed..2c821fa601a4 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -922,6 +922,83 @@ xfs_ioc_bulkstat(
>  	return 0;
>  }
>  
> +/*
> + * Check the incoming singleton request @hdr from userspace and initialize the
> + * internal @breq bulk request appropriately.  Returns 0 if the bulk request
> + * should proceed; or the usual negative error code.
> + */
> +static int
> +xfs_ireq_setup(
> +	struct xfs_mount	*mp,
> +	struct xfs_ireq		*hdr,
> +	struct xfs_ibulk	*breq,
> +	void __user		*ubuffer)
> +{
> +	if ((hdr->flags & ~XFS_IREQ_FLAGS_ALL) ||
> +	    hdr->reserved32 ||
> +	    memchr_inv(hdr->reserved, 0, sizeof(hdr->reserved)))
> +		return -EINVAL;
> +
> +	if (XFS_INO_TO_AGNO(mp, hdr->ino) >= mp->m_sb.sb_agcount)
> +		return -EINVAL;
> +
> +	breq->ubuffer = ubuffer;
> +	breq->icount = 1;
> +	breq->startino = hdr->ino;
> +	return 0;
> +}
> +
> +/*
> + * Update the userspace singleton request @hdr to reflect the end state of the
> + * internal bulk request @breq.  If @error is negative then we return just
> + * that; otherwise we copy the state so that userspace can discover what
> + * happened.
> + */
> +static void
> +xfs_ireq_teardown(
> +	struct xfs_ireq		*hdr,
> +	struct xfs_ibulk	*breq)
> +{
> +	hdr->ino = breq->startino;
> +}
> +
> +/* Handle the v5 bulkstat_single ioctl. */
> +STATIC int
> +xfs_ioc_bulkstat_single(
> +	struct xfs_mount	*mp,
> +	unsigned int		cmd,
> +	struct xfs_bulkstat_single_req __user *arg)
> +{
> +	struct xfs_ireq		hdr;
> +	struct xfs_ibulk	breq = {
> +		.mp		= mp,
> +	};
> +	int			error;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +
> +	if (XFS_FORCED_SHUTDOWN(mp))
> +		return -EIO;
> +
> +	if (copy_from_user(&hdr, &arg->hdr, sizeof(hdr)))
> +		return -EFAULT;
> +
> +	error = xfs_ireq_setup(mp, &hdr, &breq, &arg->bulkstat);
> +	if (error)
> +		return error;
> +
> +	error = xfs_bulkstat_one(&breq, xfs_bulkstat_fmt);
> +	if (error)
> +		return error;
> +
> +	xfs_ireq_teardown(&hdr, &breq);
> +	if (copy_to_user(&arg->hdr, &hdr, sizeof(hdr)))
> +		return -EFAULT;
> +
> +	return 0;
> +}
> +
>  STATIC int
>  xfs_ioc_fsgeometry(
>  	struct xfs_mount	*mp,
> @@ -2088,6 +2165,8 @@ xfs_file_ioctl(
>  
>  	case XFS_IOC_BULKSTAT:
>  		return xfs_ioc_bulkstat(mp, cmd, arg);
> +	case XFS_IOC_BULKSTAT_SINGLE:
> +		return xfs_ioc_bulkstat_single(mp, cmd, arg);
>  
>  	case XFS_IOC_FSGEOMETRY_V1:
>  		return xfs_ioc_fsgeometry(mp, arg, 3);
> diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
> index df107adbdbf3..6fa0f41dbae5 100644
> --- a/fs/xfs/xfs_ioctl32.c
> +++ b/fs/xfs/xfs_ioctl32.c
> @@ -581,6 +581,7 @@ xfs_file_compat_ioctl(
>  	case FS_IOC_GETFSMAP:
>  	case XFS_IOC_SCRUB_METADATA:
>  	case XFS_IOC_BULKSTAT:
> +	case XFS_IOC_BULKSTAT_SINGLE:
>  		return xfs_file_ioctl(filp, cmd, p);
>  #if !defined(BROKEN_X86_ALIGNMENT) || defined(CONFIG_X86_X32)
>  	/*
> diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
> index 954484c6eb96..fa1252657b08 100644
> --- a/fs/xfs/xfs_ondisk.h
> +++ b/fs/xfs/xfs_ondisk.h
> @@ -150,6 +150,7 @@ xfs_check_ondisk_structs(void)
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_bulkstat,		192);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_inumbers,		24);
>  	XFS_CHECK_STRUCT_SIZE(struct xfs_bulkstat_req,		64);
> +	XFS_CHECK_STRUCT_SIZE(struct xfs_bulkstat_single_req,	224);
>  }
>  
>  #endif /* __XFS_ONDISK_H */
> 
