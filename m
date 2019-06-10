Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9315B3B69B
	for <lists+linux-xfs@lfdr.de>; Mon, 10 Jun 2019 15:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390631AbfFJN64 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 10 Jun 2019 09:58:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44070 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390587AbfFJN6y (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 10 Jun 2019 09:58:54 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4F6CAC057F3B;
        Mon, 10 Jun 2019 13:58:54 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D80765D6A9;
        Mon, 10 Jun 2019 13:58:53 +0000 (UTC)
Date:   Mon, 10 Jun 2019 09:58:52 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 02/10] xfs: convert quotacheck to use the new iwalk
 functions
Message-ID: <20190610135848.GB6473@bfoster>
References: <155968496814.1657646.13743491598480818627.stgit@magnolia>
 <155968498085.1657646.3518168545540841602.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <155968498085.1657646.3518168545540841602.stgit@magnolia>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Mon, 10 Jun 2019 13:58:54 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 04, 2019 at 02:49:40PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Convert quotacheck to use the new iwalk iterator to dig through the
> inodes.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_qm.c |   62 ++++++++++++++++++-------------------------------------
>  1 file changed, 20 insertions(+), 42 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> index aa6b6db3db0e..a5b2260406a8 100644
> --- a/fs/xfs/xfs_qm.c
> +++ b/fs/xfs/xfs_qm.c
...
> @@ -1136,20 +1135,18 @@ xfs_qm_dqusage_adjust(
>  	 * rootino must have its resources accounted for, not so with the quota
>  	 * inodes.
>  	 */
> -	if (xfs_is_quota_inode(&mp->m_sb, ino)) {
> -		*res = BULKSTAT_RV_NOTHING;
> -		return -EINVAL;
> -	}
> +	if (xfs_is_quota_inode(&mp->m_sb, ino))
> +		return 0;
>  
>  	/*
>  	 * We don't _need_ to take the ilock EXCL here because quotacheck runs
>  	 * at mount time and therefore nobody will be racing chown/chproj.
>  	 */
> -	error = xfs_iget(mp, NULL, ino, XFS_IGET_DONTCACHE, 0, &ip);
> -	if (error) {
> -		*res = BULKSTAT_RV_NOTHING;
> +	error = xfs_iget(mp, tp, ino, XFS_IGET_DONTCACHE, 0, &ip);

I was wondering if we should start using IGET_UNTRUSTED here, but I
guess we're 1.) protected by quotacheck context and 2.) have the same
record validity semantics as the existing bulkstat walker. LGTM:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +	if (error == -EINVAL || error == -ENOENT)
> +		return 0;
> +	if (error)
>  		return error;
> -	}
>  
>  	ASSERT(ip->i_delayed_blks == 0);
>  
> @@ -1157,7 +1154,7 @@ xfs_qm_dqusage_adjust(
>  		struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
>  
>  		if (!(ifp->if_flags & XFS_IFEXTENTS)) {
> -			error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
> +			error = xfs_iread_extents(tp, ip, XFS_DATA_FORK);
>  			if (error)
>  				goto error0;
>  		}
> @@ -1200,13 +1197,8 @@ xfs_qm_dqusage_adjust(
>  			goto error0;
>  	}
>  
> -	xfs_irele(ip);
> -	*res = BULKSTAT_RV_DIDONE;
> -	return 0;
> -
>  error0:
>  	xfs_irele(ip);
> -	*res = BULKSTAT_RV_GIVEUP;
>  	return error;
>  }
>  
> @@ -1270,18 +1262,13 @@ STATIC int
>  xfs_qm_quotacheck(
>  	xfs_mount_t	*mp)
>  {
> -	int			done, count, error, error2;
> -	xfs_ino_t		lastino;
> -	size_t			structsz;
> +	int			error, error2;
>  	uint			flags;
>  	LIST_HEAD		(buffer_list);
>  	struct xfs_inode	*uip = mp->m_quotainfo->qi_uquotaip;
>  	struct xfs_inode	*gip = mp->m_quotainfo->qi_gquotaip;
>  	struct xfs_inode	*pip = mp->m_quotainfo->qi_pquotaip;
>  
> -	count = INT_MAX;
> -	structsz = 1;
> -	lastino = 0;
>  	flags = 0;
>  
>  	ASSERT(uip || gip || pip);
> @@ -1318,18 +1305,9 @@ xfs_qm_quotacheck(
>  		flags |= XFS_PQUOTA_CHKD;
>  	}
>  
> -	do {
> -		/*
> -		 * Iterate thru all the inodes in the file system,
> -		 * adjusting the corresponding dquot counters in core.
> -		 */
> -		error = xfs_bulkstat(mp, &lastino, &count,
> -				     xfs_qm_dqusage_adjust,
> -				     structsz, NULL, &done);
> -		if (error)
> -			break;
> -
> -	} while (!done);
> +	error = xfs_iwalk(mp, NULL, 0, xfs_qm_dqusage_adjust, 0, NULL);
> +	if (error)
> +		goto error_return;
>  
>  	/*
>  	 * We've made all the changes that we need to make incore.  Flush them
> 
