Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2DB7E36BA
	for <lists+linux-xfs@lfdr.de>; Thu, 24 Oct 2019 17:32:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503289AbfJXPb7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 24 Oct 2019 11:31:59 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:32866 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503277AbfJXPb6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Oct 2019 11:31:58 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9OFCcIt021006;
        Thu, 24 Oct 2019 15:31:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=qZYD6/k+BtwrJq7lJrcn9CHQhka3BdLmigDbtboV/No=;
 b=Q0oZxRXc0HJX4izkBGg/A0l1/2nWT+yYNCm/MXjOOu2Lnp/QDmu96fvMcYPUfniwHvk+
 +c1wNwWcYcGfKhjhMNXjP+VX3KiepW370SfuDyFp/GQu6JAFRikRL+McC3HOOo0XLteJ
 AuwiCuEnaodcbtPHY2RUWhZJnAm2KlNVSGm23bVVBJeXjwbbHbr77udwcOYu+rOQUEos
 RrBOvZg+cl59Nkv0HSJbNdcEtZwoUieofpJOk4Qa9IVhysvT6N+yTQg/G6W05MZ/6Afp
 zSuyghdfIX29yWAFRfu5Xzk8gcOxR6YkgY3OmDEspa+R6APdRI0idI2pWEsqf3abgxlT pw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2vqu4r4903-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Oct 2019 15:31:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x9OF4cHt156843;
        Thu, 24 Oct 2019 15:31:28 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2vu0fpgvaa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 24 Oct 2019 15:31:28 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x9OFVQBW018295;
        Thu, 24 Oct 2019 15:31:26 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 24 Oct 2019 08:31:26 -0700
Date:   Thu, 24 Oct 2019 08:31:23 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Ian Kent <raven@themaw.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v7 09/17] xfs: add xfs_remount_rw() helper
Message-ID: <20191024153123.GS913374@magnolia>
References: <157190333868.27074.13987695222060552856.stgit@fedora-28>
 <157190348247.27074.12897905716268545882.stgit@fedora-28>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157190348247.27074.12897905716268545882.stgit@fedora-28>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9419 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910240139
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9419 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1910240139
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 24, 2019 at 03:51:22PM +0800, Ian Kent wrote:
> Factor the remount read write code into a helper to simplify the
> subsequent change from the super block method .remount_fs to the
> mount-api fs_context_operations method .reconfigure.
> 
> This helper is only used by the mount code, so locate it along with
> that code.
> 
> While we are at it change STATIC -> static for xfs_restore_resvblks().
> 
> Signed-off-by: Ian Kent <raven@themaw.net>
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_super.c |  119 +++++++++++++++++++++++++++++-----------------------
>  1 file changed, 67 insertions(+), 52 deletions(-)
> 
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index 297e6c98742e..c07e41489e75 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -47,6 +47,8 @@ static struct kset *xfs_kset;		/* top-level xfs sysfs dir */
>  static struct xfs_kobj xfs_dbg_kobj;	/* global debug sysfs attrs */
>  #endif
>  
> +static void xfs_restore_resvblks(struct xfs_mount *mp);

What's the reason for putting xfs_remount_rw above xfs_restore_resvblks?
I assume that's related to where you want to land later code chunks?

--D

> +
>  /*
>   * Table driven mount option parser.
>   */
> @@ -455,6 +457,68 @@ xfs_mount_free(
>  	kmem_free(mp);
>  }
>  
> +static int
> +xfs_remount_rw(
> +	struct xfs_mount	*mp)
> +{
> +	struct xfs_sb		*sbp = &mp->m_sb;
> +	int			error;
> +
> +	if (mp->m_flags & XFS_MOUNT_NORECOVERY) {
> +		xfs_warn(mp,
> +			"ro->rw transition prohibited on norecovery mount");
> +		return -EINVAL;
> +	}
> +
> +	if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
> +	    xfs_sb_has_ro_compat_feature(sbp, XFS_SB_FEAT_RO_COMPAT_UNKNOWN)) {
> +		xfs_warn(mp,
> +	"ro->rw transition prohibited on unknown (0x%x) ro-compat filesystem",
> +			(sbp->sb_features_ro_compat &
> +				XFS_SB_FEAT_RO_COMPAT_UNKNOWN));
> +		return -EINVAL;
> +	}
> +
> +	mp->m_flags &= ~XFS_MOUNT_RDONLY;
> +
> +	/*
> +	 * If this is the first remount to writeable state we might have some
> +	 * superblock changes to update.
> +	 */
> +	if (mp->m_update_sb) {
> +		error = xfs_sync_sb(mp, false);
> +		if (error) {
> +			xfs_warn(mp, "failed to write sb changes");
> +			return error;
> +		}
> +		mp->m_update_sb = false;
> +	}
> +
> +	/*
> +	 * Fill out the reserve pool if it is empty. Use the stashed value if
> +	 * it is non-zero, otherwise go with the default.
> +	 */
> +	xfs_restore_resvblks(mp);
> +	xfs_log_work_queue(mp);
> +
> +	/* Recover any CoW blocks that never got remapped. */
> +	error = xfs_reflink_recover_cow(mp);
> +	if (error) {
> +		xfs_err(mp,
> +			"Error %d recovering leftover CoW allocations.", error);
> +			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> +		return error;
> +	}
> +	xfs_start_block_reaping(mp);
> +
> +	/* Create the per-AG metadata reservation pool .*/
> +	error = xfs_fs_reserve_ag_blocks(mp);
> +	if (error && error != -ENOSPC)
> +		return error;
> +
> +	return 0;
> +}
> +
>  struct proc_xfs_info {
>  	uint64_t	flag;
>  	char		*str;
> @@ -1169,7 +1233,7 @@ xfs_save_resvblks(struct xfs_mount *mp)
>  	xfs_reserve_blocks(mp, &resblks, NULL);
>  }
>  
> -STATIC void
> +static void
>  xfs_restore_resvblks(struct xfs_mount *mp)
>  {
>  	uint64_t resblks;
> @@ -1307,57 +1371,8 @@ xfs_fs_remount(
>  
>  	/* ro -> rw */
>  	if ((mp->m_flags & XFS_MOUNT_RDONLY) && !(*flags & SB_RDONLY)) {
> -		if (mp->m_flags & XFS_MOUNT_NORECOVERY) {
> -			xfs_warn(mp,
> -		"ro->rw transition prohibited on norecovery mount");
> -			return -EINVAL;
> -		}
> -
> -		if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
> -		    xfs_sb_has_ro_compat_feature(sbp,
> -					XFS_SB_FEAT_RO_COMPAT_UNKNOWN)) {
> -			xfs_warn(mp,
> -"ro->rw transition prohibited on unknown (0x%x) ro-compat filesystem",
> -				(sbp->sb_features_ro_compat &
> -					XFS_SB_FEAT_RO_COMPAT_UNKNOWN));
> -			return -EINVAL;
> -		}
> -
> -		mp->m_flags &= ~XFS_MOUNT_RDONLY;
> -
> -		/*
> -		 * If this is the first remount to writeable state we
> -		 * might have some superblock changes to update.
> -		 */
> -		if (mp->m_update_sb) {
> -			error = xfs_sync_sb(mp, false);
> -			if (error) {
> -				xfs_warn(mp, "failed to write sb changes");
> -				return error;
> -			}
> -			mp->m_update_sb = false;
> -		}
> -
> -		/*
> -		 * Fill out the reserve pool if it is empty. Use the stashed
> -		 * value if it is non-zero, otherwise go with the default.
> -		 */
> -		xfs_restore_resvblks(mp);
> -		xfs_log_work_queue(mp);
> -
> -		/* Recover any CoW blocks that never got remapped. */
> -		error = xfs_reflink_recover_cow(mp);
> -		if (error) {
> -			xfs_err(mp,
> -	"Error %d recovering leftover CoW allocations.", error);
> -			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> -			return error;
> -		}
> -		xfs_start_block_reaping(mp);
> -
> -		/* Create the per-AG metadata reservation pool .*/
> -		error = xfs_fs_reserve_ag_blocks(mp);
> -		if (error && error != -ENOSPC)
> +		error = xfs_remount_rw(mp);
> +		if (error)
>  			return error;
>  	}
>  
> 
