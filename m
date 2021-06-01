Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89C13393572
	for <lists+linux-xfs@lfdr.de>; Thu, 27 May 2021 20:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235179AbhE0SdR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 27 May 2021 14:33:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:35016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234155AbhE0SdQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 27 May 2021 14:33:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDDF9611AE;
        Thu, 27 May 2021 18:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622140303;
        bh=Y6ag5IuAfqzF3Bju7o8WLTqdRpW4li++GWk2Pstr+ZQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cPm8oYt+oZZD7B4Mq74WgiRuoj6DlP4Jq9JFo2Sb2RQNEkRybHBUroZisX+RDjBc4
         oBUCFcccRLCpnj2CF7g7OSVRXVEXkWWRHGJeutiPQ1SWmhjC5DPa0ussH3FKTmYkH6
         eG1CFwRsnuFY92mhMw8Qgdxw6ekkQ2gAg6VNSYkceUIUKpmGWykJZ4/97c9kZnQuDA
         wXhrZEpk77pIel6FrqAWCQvZsUJb/A98XIjz5dXHjTuoxwfWJRxaohvHoaloZ0/Zk9
         Bdm507SKj9xrcQO3zVJR3ldESXU6kPw3N+yBkNE4bwPz8GCX8Vd6kpJRvDyu6pF+W9
         CZzfH74zFkkQA==
Date:   Thu, 27 May 2021 11:31:42 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 29/39] xfs: introduce per-cpu CIL tracking structure
Message-ID: <20210527183142.GH2402049@locust>
References: <20210519121317.585244-1-david@fromorbit.com>
 <20210519121317.585244-30-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519121317.585244-30-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 19, 2021 at 10:13:07PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The CIL push lock is highly contended on larger machines, becoming a
> hard bottleneck that about 700,000 transaction commits/s on >16p
> machines. To address this, start moving the CIL tracking
> infrastructure to utilise per-CPU structures.
> 
> We need to track the space used, the amount of log reservation space
> reserved to write the CIL, the log items in the CIL and the busy
> extents that need to be completed by the CIL commit.  This requires
> a couple of per-cpu counters, an unordered per-cpu list and a
> globally ordered per-cpu list.
> 
> Create a per-cpu structure to hold these and all the management
> interfaces needed, as well as the hooks to handle hotplug CPUs.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log_cil.c       | 106 +++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_log_priv.h      |  15 ++++++
>  include/linux/cpuhotplug.h |   1 +
>  3 files changed, 122 insertions(+)
> 
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 87d4eb321fdc..ba1c6979a4c7 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -1370,6 +1370,105 @@ xfs_log_item_in_current_chkpt(
>  	return lip->li_seq == cil->xc_ctx->sequence;
>  }
>  
> +#ifdef CONFIG_HOTPLUG_CPU
> +static LIST_HEAD(xlog_cil_pcp_list);
> +static DEFINE_SPINLOCK(xlog_cil_pcp_lock);
> +static bool xlog_cil_pcp_init;
> +
> +/*
> + * Move dead percpu state to the relevant CIL context structures.
> + *
> + * We have to lock the CIL context here to ensure that nothing is modifying
> + * the percpu state, either addition or removal. Both of these are done under
> + * the CIL context lock, so grabbing that exclusively here will ensure we can
> + * safely drain the cilpcp for the CPU that is dying.
> + */
> +static int
> +xlog_cil_pcp_dead(
> +	unsigned int		cpu)
> +{
> +	struct xfs_cil		*cil, *n;
> +
> +	spin_lock(&xlog_cil_pcp_lock);
> +	list_for_each_entry_safe(cil, n, &xlog_cil_pcp_list, xc_pcp_list) {
> +		spin_unlock(&xlog_cil_pcp_lock);
> +		down_write(&cil->xc_ctx_lock);
> +		/* move stuff on dead CPU to context */
> +		up_write(&cil->xc_ctx_lock);
> +		spin_lock(&xlog_cil_pcp_lock);
> +	}
> +	spin_unlock(&xlog_cil_pcp_lock);
> +	return 0;
> +}
> +
> +static int
> +xlog_cil_pcp_hpadd(
> +	struct xfs_cil		*cil)
> +{
> +	if (!xlog_cil_pcp_init) {
> +		int	ret;
> +		ret = cpuhp_setup_state_nocalls(CPUHP_XFS_CIL_DEAD,

Nit: blank line between variable declarations and code.

> +						"xfs/cil_pcp:dead", NULL,
> +						xlog_cil_pcp_dead);
> +		if (ret < 0) {
> +			xfs_warn(cil->xc_log->l_mp,
> +	"Failed to initialise CIL hotplug, error %d. XFS is non-functional.",
> +				ret);
> +			ASSERT(0);
> +			return -ENOMEM;
> +		}
> +		xlog_cil_pcp_init = true;
> +	}
> +
> +	INIT_LIST_HEAD(&cil->xc_pcp_list);
> +	spin_lock(&xlog_cil_pcp_lock);
> +	list_add(&cil->xc_pcp_list, &xlog_cil_pcp_list);
> +	spin_unlock(&xlog_cil_pcp_lock);
> +	return 0;
> +}
> +
> +static void
> +xlog_cil_pcp_hpremove(
> +	struct xfs_cil		*cil)
> +{
> +	spin_lock(&xlog_cil_pcp_lock);
> +	list_del(&cil->xc_pcp_list);
> +	spin_unlock(&xlog_cil_pcp_lock);
> +}
> +
> +#else /* !CONFIG_HOTPLUG_CPU */
> +static inline void xlog_cil_pcp_hpadd(struct xfs_cil *cil) {}
> +static inline void xlog_cil_pcp_hpremove(struct xfs_cil *cil) {}
> +#endif
> +
> +static void __percpu *
> +xlog_cil_pcp_alloc(
> +	struct xfs_cil		*cil)
> +{
> +	void __percpu		*pcp;
> +
> +	pcp = alloc_percpu(struct xlog_cil_pcp);
> +	if (!pcp)
> +		return NULL;
> +
> +	if (xlog_cil_pcp_hpadd(cil) < 0) {
> +		free_percpu(pcp);
> +		return NULL;
> +	}
> +	return pcp;
> +}
> +
> +static void
> +xlog_cil_pcp_free(
> +	struct xfs_cil		*cil,
> +	void __percpu		*pcp)
> +{
> +	if (!pcp)
> +		return;
> +	xlog_cil_pcp_hpremove(cil);
> +	free_percpu(pcp);
> +}
> +
>  /*
>   * Perform initial CIL structure initialisation.
>   */
> @@ -1384,6 +1483,12 @@ xlog_cil_init(
>  	if (!cil)
>  		return -ENOMEM;
>  
> +	cil->xc_pcp = xlog_cil_pcp_alloc(cil);
> +	if (!cil->xc_pcp) {
> +		kmem_free(cil);
> +		return -ENOMEM;
> +	}
> +
>  	INIT_LIST_HEAD(&cil->xc_cil);
>  	INIT_LIST_HEAD(&cil->xc_committing);
>  	spin_lock_init(&cil->xc_cil_lock);
> @@ -1414,6 +1519,7 @@ xlog_cil_destroy(
>  
>  	ASSERT(list_empty(&cil->xc_cil));
>  	ASSERT(test_bit(XLOG_CIL_EMPTY, &cil->xc_flags));
> +	xlog_cil_pcp_free(cil, cil->xc_pcp);
>  	kmem_free(cil);
>  }
>  
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 85a85ab569fe..aaa1e7f7fb66 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -227,6 +227,16 @@ struct xfs_cil_ctx {
>  	struct work_struct	push_work;
>  };
>  
> +/*
> + * Per-cpu CIL tracking items
> + */
> +struct xlog_cil_pcp {
> +	uint32_t		space_used;
> +	uint32_t		curr_res;

I don't think these fields need to be in this patch.

Especially since you rename one of them in patch 31.

I think this looks like the skeleton of adding per-cpu structures to the
log, though I'll read the next few patches to see if the comments make
more sense once you actually starting using the pcpu data.

--D

> +	struct list_head	busy_extents;
> +	struct list_head	log_items;
> +};
> +
>  /*
>   * Committed Item List structure
>   *
> @@ -260,6 +270,11 @@ struct xfs_cil {
>  	wait_queue_head_t	xc_commit_wait;
>  	xfs_csn_t		xc_current_sequence;
>  	wait_queue_head_t	xc_push_wait;	/* background push throttle */
> +
> +	void __percpu		*xc_pcp;	/* percpu CIL structures */
> +#ifdef CONFIG_HOTPLUG_CPU
> +	struct list_head	xc_pcp_list;
> +#endif
>  } ____cacheline_aligned_in_smp;
>  
>  /* xc_flags bit values */
> diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
> index 4a62b3980642..3d3ccde9e9c8 100644
> --- a/include/linux/cpuhotplug.h
> +++ b/include/linux/cpuhotplug.h
> @@ -52,6 +52,7 @@ enum cpuhp_state {
>  	CPUHP_FS_BUFF_DEAD,
>  	CPUHP_PRINTK_DEAD,
>  	CPUHP_MM_MEMCQ_DEAD,
> +	CPUHP_XFS_CIL_DEAD,
>  	CPUHP_PERCPU_CNT_DEAD,
>  	CPUHP_RADIX_DEAD,
>  	CPUHP_PAGE_ALLOC_DEAD,
> -- 
> 2.31.1
> 
