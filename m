Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20AF83D2C60
	for <lists+linux-xfs@lfdr.de>; Thu, 22 Jul 2021 21:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbhGVS0a (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 22 Jul 2021 14:26:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:50660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229979AbhGVS02 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Jul 2021 14:26:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91D4160EB6;
        Thu, 22 Jul 2021 19:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626980823;
        bh=QyarhmzAOZ0mqM+owtpYHIuFxqDvJXRWldbz/9HYBAo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MmHbh1Azu2yjzBmJixc7DeAS0nq1IoLMQPtSaOUVJGG4YG6/LkJ25b1gK8ru+tdT4
         9SN8RnlH0urMQ/N5OGXebx+NF9XqlRT12IFXA4SyAUHOMIlImR+2kfuKAaKOey9nFF
         JORaRQgjzqYnoQ+Ucb1v8kQO90B0sDu1uF0eJF8YP/18lJ/+obSgvcW1LgmnmO0Ias
         mYftntsvBYC/iZKWC/KauBzsrbH6W0lYHu7jJrZHR/J/BoVulXvNN2CxBe+EhpcC0w
         iywTTuvBzebmT2LdQGkNZDtuGR/IOi/75xz9MtsmcwqmcsUVQ5rrI/zWqkvWjRX3G7
         zpf4hwEM6Mz2A==
Date:   Thu, 22 Jul 2021 12:07:03 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH 1/3] xfs: remove support for disabling quota accounting
 on a mounted file system
Message-ID: <20210722190703.GI559212@magnolia>
References: <20210722072610.975281-1-hch@lst.de>
 <20210722072610.975281-2-hch@lst.de>
 <20210722182254.GB559212@magnolia>
 <20210722190307.GA14569@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210722190307.GA14569@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 22, 2021 at 09:03:07PM +0200, Christoph Hellwig wrote:
> On Thu, Jul 22, 2021 at 11:22:54AM -0700, Darrick J. Wong wrote:
> > <snip> I think you could delete more...
> 
> > ...because I think xfs_dqrele_all_inodes has lost all of its callers.
> > Can you please remove it and XFS_ICWALK_DQRELE from xfs_icache.[ch]?
> 
> ---
> From e8d07e55103636ce3207788e430eeff12b9ef153 Mon Sep 17 00:00:00 2001
> From: Christoph Hellwig <hch@lst.de>
> Date: Thu, 22 Jul 2021 20:58:55 +0200
> Subject: xfs: remove xfs_dqrele_all_inodes
> 
> xfs_dqrele_all_inodes is unused now, remove it and all supporting code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

For this patch (which I guess is now patch 4?) and the original patch 1,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> ---
>  fs/xfs/xfs_icache.c | 107 +-------------------------------------------
>  fs/xfs/xfs_icache.h |   6 ---
>  2 files changed, 1 insertion(+), 112 deletions(-)
> 
> diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
> index 6007683482c625..086a88b8dfdb39 100644
> --- a/fs/xfs/xfs_icache.c
> +++ b/fs/xfs/xfs_icache.c
> @@ -38,9 +38,6 @@
>   * radix tree tags when convenient.  Avoid existing XFS_IWALK namespace.
>   */
>  enum xfs_icwalk_goal {
> -	/* Goals that are not related to tags; these must be < 0. */
> -	XFS_ICWALK_DQRELE	= -1,
> -
>  	/* Goals directly associated with tagged inodes. */
>  	XFS_ICWALK_BLOCKGC	= XFS_ICI_BLOCKGC_TAG,
>  	XFS_ICWALK_RECLAIM	= XFS_ICI_RECLAIM_TAG,
> @@ -64,9 +61,6 @@ static int xfs_icwalk_ag(struct xfs_perag *pag,
>   * Private inode cache walk flags for struct xfs_icwalk.  Must not
>   * coincide with XFS_ICWALK_FLAGS_VALID.
>   */
> -#define XFS_ICWALK_FLAG_DROP_UDQUOT	(1U << 31)
> -#define XFS_ICWALK_FLAG_DROP_GDQUOT	(1U << 30)
> -#define XFS_ICWALK_FLAG_DROP_PDQUOT	(1U << 29)
>  
>  /* Stop scanning after icw_scan_limit inodes. */
>  #define XFS_ICWALK_FLAG_SCAN_LIMIT	(1U << 28)
> @@ -74,10 +68,7 @@ static int xfs_icwalk_ag(struct xfs_perag *pag,
>  #define XFS_ICWALK_FLAG_RECLAIM_SICK	(1U << 27)
>  #define XFS_ICWALK_FLAG_UNION		(1U << 26) /* union filter algorithm */
>  
> -#define XFS_ICWALK_PRIVATE_FLAGS	(XFS_ICWALK_FLAG_DROP_UDQUOT | \
> -					 XFS_ICWALK_FLAG_DROP_GDQUOT | \
> -					 XFS_ICWALK_FLAG_DROP_PDQUOT | \
> -					 XFS_ICWALK_FLAG_SCAN_LIMIT | \
> +#define XFS_ICWALK_PRIVATE_FLAGS	(XFS_ICWALK_FLAG_SCAN_LIMIT | \
>  					 XFS_ICWALK_FLAG_RECLAIM_SICK | \
>  					 XFS_ICWALK_FLAG_UNION)
>  
> @@ -817,97 +808,6 @@ xfs_icache_inode_is_allocated(
>  	return 0;
>  }
>  
> -#ifdef CONFIG_XFS_QUOTA
> -/* Decide if we want to grab this inode to drop its dquots. */
> -static bool
> -xfs_dqrele_igrab(
> -	struct xfs_inode	*ip)
> -{
> -	bool			ret = false;
> -
> -	ASSERT(rcu_read_lock_held());
> -
> -	/* Check for stale RCU freed inode */
> -	spin_lock(&ip->i_flags_lock);
> -	if (!ip->i_ino)
> -		goto out_unlock;
> -
> -	/*
> -	 * Skip inodes that are anywhere in the reclaim machinery because we
> -	 * drop dquots before tagging an inode for reclamation.
> -	 */
> -	if (ip->i_flags & (XFS_IRECLAIM | XFS_IRECLAIMABLE))
> -		goto out_unlock;
> -
> -	/*
> -	 * The inode looks alive; try to grab a VFS reference so that it won't
> -	 * get destroyed.  If we got the reference, return true to say that
> -	 * we grabbed the inode.
> -	 *
> -	 * If we can't get the reference, then we know the inode had its VFS
> -	 * state torn down and hasn't yet entered the reclaim machinery.  Since
> -	 * we also know that dquots are detached from an inode before it enters
> -	 * reclaim, we can skip the inode.
> -	 */
> -	ret = igrab(VFS_I(ip)) != NULL;
> -
> -out_unlock:
> -	spin_unlock(&ip->i_flags_lock);
> -	return ret;
> -}
> -
> -/* Drop this inode's dquots. */
> -static void
> -xfs_dqrele_inode(
> -	struct xfs_inode	*ip,
> -	struct xfs_icwalk	*icw)
> -{
> -	if (xfs_iflags_test(ip, XFS_INEW))
> -		xfs_inew_wait(ip);
> -
> -	xfs_ilock(ip, XFS_ILOCK_EXCL);
> -	if (icw->icw_flags & XFS_ICWALK_FLAG_DROP_UDQUOT) {
> -		xfs_qm_dqrele(ip->i_udquot);
> -		ip->i_udquot = NULL;
> -	}
> -	if (icw->icw_flags & XFS_ICWALK_FLAG_DROP_GDQUOT) {
> -		xfs_qm_dqrele(ip->i_gdquot);
> -		ip->i_gdquot = NULL;
> -	}
> -	if (icw->icw_flags & XFS_ICWALK_FLAG_DROP_PDQUOT) {
> -		xfs_qm_dqrele(ip->i_pdquot);
> -		ip->i_pdquot = NULL;
> -	}
> -	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> -	xfs_irele(ip);
> -}
> -
> -/*
> - * Detach all dquots from incore inodes if we can.  The caller must already
> - * have dropped the relevant XFS_[UGP]QUOTA_ACTIVE flags so that dquots will
> - * not get reattached.
> - */
> -int
> -xfs_dqrele_all_inodes(
> -	struct xfs_mount	*mp,
> -	unsigned int		qflags)
> -{
> -	struct xfs_icwalk	icw = { .icw_flags = 0 };
> -
> -	if (qflags & XFS_UQUOTA_ACCT)
> -		icw.icw_flags |= XFS_ICWALK_FLAG_DROP_UDQUOT;
> -	if (qflags & XFS_GQUOTA_ACCT)
> -		icw.icw_flags |= XFS_ICWALK_FLAG_DROP_GDQUOT;
> -	if (qflags & XFS_PQUOTA_ACCT)
> -		icw.icw_flags |= XFS_ICWALK_FLAG_DROP_PDQUOT;
> -
> -	return xfs_icwalk(mp, XFS_ICWALK_DQRELE, &icw);
> -}
> -#else
> -# define xfs_dqrele_igrab(ip)		(false)
> -# define xfs_dqrele_inode(ip, priv)	((void)0)
> -#endif /* CONFIG_XFS_QUOTA */
> -
>  /*
>   * Grab the inode for reclaim exclusively.
>   *
> @@ -1647,8 +1547,6 @@ xfs_icwalk_igrab(
>  	struct xfs_icwalk	*icw)
>  {
>  	switch (goal) {
> -	case XFS_ICWALK_DQRELE:
> -		return xfs_dqrele_igrab(ip);
>  	case XFS_ICWALK_BLOCKGC:
>  		return xfs_blockgc_igrab(ip);
>  	case XFS_ICWALK_RECLAIM:
> @@ -1672,9 +1570,6 @@ xfs_icwalk_process_inode(
>  	int			error = 0;
>  
>  	switch (goal) {
> -	case XFS_ICWALK_DQRELE:
> -		xfs_dqrele_inode(ip, icw);
> -		break;
>  	case XFS_ICWALK_BLOCKGC:
>  		error = xfs_blockgc_scan_inode(ip, icw);
>  		break;
> diff --git a/fs/xfs/xfs_icache.h b/fs/xfs/xfs_icache.h
> index c751cc32dc4634..d0062ebb3f7ac8 100644
> --- a/fs/xfs/xfs_icache.h
> +++ b/fs/xfs/xfs_icache.h
> @@ -68,12 +68,6 @@ void xfs_inode_clear_cowblocks_tag(struct xfs_inode *ip);
>  
>  void xfs_blockgc_worker(struct work_struct *work);
>  
> -#ifdef CONFIG_XFS_QUOTA
> -int xfs_dqrele_all_inodes(struct xfs_mount *mp, unsigned int qflags);
> -#else
> -# define xfs_dqrele_all_inodes(mp, qflags)	(0)
> -#endif
> -
>  int xfs_icache_inode_is_allocated(struct xfs_mount *mp, struct xfs_trans *tp,
>  				  xfs_ino_t ino, bool *inuse);
>  
> -- 
> 2.30.2
> 
