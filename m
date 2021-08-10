Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12C333E053A
	for <lists+linux-xfs@lfdr.de>; Wed,  4 Aug 2021 18:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbhHDQGP (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 4 Aug 2021 12:06:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:60064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229721AbhHDQGO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 4 Aug 2021 12:06:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CBFB601FC;
        Wed,  4 Aug 2021 16:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628093161;
        bh=L0p+s0QxwB7QoF7xuabdM3JjwjDiUWMyVNGJaGLbINM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dQuDY5EgueR88vi/tElioALg9SLVCjyzKogmizxLlwBXYxEE91zbOQpxClBkCx1Dy
         CKA2jZANbgmnO0BtAVfgphYBvo2g5aZijCTcrjq0YmtrpJFaQoH/KTkUzaojldKG36
         zxgc7qZ3wKrCMxqnIHZhUVaVgdR6k4OGYpmCnMoA0PP94zLrZpuW9QSKGIUFmkiz3V
         +UZEvMOFaqcNDUlX/vYbtcUdwMIkn7BF6mhGHlPmMJaI2zJRDmg36YucDyBhzoxPNB
         HxPyC5WIrjQK3z72vvaj0YPrs7gaOWLhnDRyUMpvyDlLN0GFwErt9ir3NdY6G6D94+
         vkSiI9ENUJs8A==
Date:   Wed, 4 Aug 2021 09:06:01 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH, pre-03/20 #2] xfs: introduce all-mounts list for cpu
 hotplug notifications
Message-ID: <20210804160601.GO3601466@magnolia>
References: <162758423315.332903.16799817941903734904.stgit@magnolia>
 <162758425012.332903.3784529658243630550.stgit@magnolia>
 <20210803083403.GI2757197@dread.disaster.area>
 <20210804032030.GT3601443@magnolia>
 <20210804115051.GO2757197@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210804115051.GO2757197@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 04, 2021 at 09:50:51PM +1000, Dave Chinner wrote:
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> The inode inactivation and CIL tracking percpu structures are
> per-xfs_mount structures. That means when we get a CPU dead
> notification, we need to then iterate all the per-cpu structure
> instances to process them. Rather than keeping linked lists of
> per-cpu structures in each subsystem, add a list of all xfs_mounts
> that the generic xfs_cpu_dead() function will iterate and call into
> each subsystem appropriately.
> 
> This allows us to handle both per-mount and global XFS percpu state
> from xfs_cpu_dead(), and avoids the need to link subsystem
> structures that can be easily found from the xfs_mount into their
> own global lists.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_mount.h |  1 +
>  fs/xfs/xfs_super.c | 41 +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 42 insertions(+)
> 
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index c78b63fe779a..ed7064596f94 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -82,6 +82,7 @@ typedef struct xfs_mount {
>  	xfs_buftarg_t		*m_ddev_targp;	/* saves taking the address */
>  	xfs_buftarg_t		*m_logdev_targp;/* ptr to log device */
>  	xfs_buftarg_t		*m_rtdev_targp;	/* ptr to rt device */
> +	struct list_head	m_mount_list;	/* global mount list */
>  	/*
>  	 * Optional cache of rt summary level per bitmap block with the
>  	 * invariant that m_rsum_cache[bbno] <= the minimum i for which
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index ffe1ecd048db..c27df85212d4 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -49,6 +49,28 @@ static struct kset *xfs_kset;		/* top-level xfs sysfs dir */
>  static struct xfs_kobj xfs_dbg_kobj;	/* global debug sysfs attrs */
>  #endif
>  
> +#ifdef CONFIG_HOTPLUG_CPU
> +static LIST_HEAD(xfs_mount_list);
> +static DEFINE_SPINLOCK(xfs_mount_list_lock);
> +
> +static inline void xfs_mount_list_add(struct xfs_mount *mp)
> +{
> +	spin_lock(&xfs_mount_list_lock);
> +	list_add(&mp->m_mount_list, &xfs_mount_list);
> +	spin_unlock(&xfs_mount_list_lock);
> +}
> +
> +static inline void xfs_mount_list_del(struct xfs_mount *mp)
> +{
> +	spin_lock(&xfs_mount_list_lock);
> +	list_del(&mp->m_mount_list);
> +	spin_unlock(&xfs_mount_list_lock);
> +}
> +#else /* !CONFIG_HOTPLUG_CPU */
> +static inline void xfs_mount_list_add(struct xfs_mount *mp) {}
> +static inline void xfs_mount_list_del(struct xfs_mount *mp) {}
> +#endif
> +
>  enum xfs_dax_mode {
>  	XFS_DAX_INODE = 0,
>  	XFS_DAX_ALWAYS = 1,
> @@ -988,6 +1010,7 @@ xfs_fs_put_super(
>  
>  	xfs_freesb(mp);
>  	free_percpu(mp->m_stats.xs_stats);
> +	xfs_mount_list_del(mp);
>  	xfs_destroy_percpu_counters(mp);
>  	xfs_destroy_mount_workqueues(mp);
>  	xfs_close_devices(mp);
> @@ -1359,6 +1382,8 @@ xfs_fs_fill_super(
>  	if (error)
>  		goto out_destroy_workqueues;
>  
> +	xfs_mount_list_add(mp);
> +
>  	/* Allocate stats memory before we do operations that might use it */
>  	mp->m_stats.xs_stats = alloc_percpu(struct xfsstats);
>  	if (!mp->m_stats.xs_stats) {
> @@ -1567,6 +1592,7 @@ xfs_fs_fill_super(
>   out_free_stats:
>  	free_percpu(mp->m_stats.xs_stats);
>   out_destroy_counters:
> +	xfs_mount_list_del(mp);
>  	xfs_destroy_percpu_counters(mp);
>   out_destroy_workqueues:
>  	xfs_destroy_mount_workqueues(mp);
> @@ -2061,10 +2087,20 @@ xfs_destroy_workqueues(void)
>  	destroy_workqueue(xfs_alloc_wq);
>  }
>  
> +#ifdef CONFIG_HOTPLUG_CPU
>  static int
>  xfs_cpu_dead(
>  	unsigned int		cpu)
>  {
> +	struct xfs_mount	*mp, *n;
> +
> +	spin_lock(&xfs_mount_list_lock);
> +	list_for_each_entry_safe(mp, n, &xfs_mount_list, m_mount_list) {
> +		spin_unlock(&xfs_mount_list_lock);
> +		/* xfs_subsys_dead(mp, cpu); */
> +		spin_lock(&xfs_mount_list_lock);
> +	}
> +	spin_unlock(&xfs_mount_list_lock);
>  	return 0;
>  }
>  
> @@ -2090,6 +2126,11 @@ xfs_cpu_hotplug_destroy(void)
>  	cpuhp_remove_state_nocalls(CPUHP_XFS_DEAD);
>  }
>  
> +#else /* !CONFIG_HOTPLUG_CPU */
> +static inline int xfs_cpu_hotplug_init(struct xfs_cil *cil) { return 0; }
> +static inline void xfs_cpu_hotplug_destroy(struct xfs_cil *cil) {}

void arguments here, right?

> +#endif

Nit: I think this ifdef stuff belongs in the previous patch.  Will fix
it when I drag this into my tree.

--D

> +
>  STATIC int __init
>  init_xfs_fs(void)
>  {
