Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 665AD28037A
	for <lists+linux-xfs@lfdr.de>; Thu,  1 Oct 2020 18:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732823AbgJAQC1 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 1 Oct 2020 12:02:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:44947 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732763AbgJAQCM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Oct 2020 12:02:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601568130;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fg91b50AbgrhK5y8we/M4GxAFOMNQsmmAFfvbRRbrnM=;
        b=Wax23boR+39gtL6kILDBjSHxXEfINTSaEn9MOQCSnqYrkPIhHtEMQ6kem9wPvssXcPU1LM
        RjzAV9DF84wolbX6hRTjtVV2vfvez79xj67FJDpK6Ps078XdpoiF5sxhPticvYIe7/O9cj
        94MwfkPYf+9B08gYovkwca3Gnsqixhg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-546-W83XUlBjPj6wCSpNo3ve-A-1; Thu, 01 Oct 2020 12:02:06 -0400
X-MC-Unique: W83XUlBjPj6wCSpNo3ve-A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 79378108E1B1;
        Thu,  1 Oct 2020 16:02:05 +0000 (UTC)
Received: from bfoster (ovpn-116-218.rdu2.redhat.com [10.10.116.218])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CB8C176E16;
        Thu,  1 Oct 2020 16:02:04 +0000 (UTC)
Date:   Thu, 1 Oct 2020 12:02:02 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 2/4] xfs: periodically relog deferred intent items
Message-ID: <20201001160202.GA112884@bfoster>
References: <160140144925.831337.14031530940286104610.stgit@magnolia>
 <160140146229.831337.17465130965848184108.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160140146229.831337.17465130965848184108.stgit@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 29, 2020 at 10:44:22AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> There's a subtle design flaw in the deferred log item code that can lead
> to pinning the log tail.  Taking up the defer ops chain examples from
> the previous commit, we can get trapped in sequences like this:
> 
> Caller hands us a transaction t0 with D0-D3 attached.  The defer ops
> chain will look like the following if the transaction rolls succeed:
> 
> t1: D0(t0), D1(t0), D2(t0), D3(t0)
> t2: d4(t1), d5(t1), D1(t0), D2(t0), D3(t0)
> t3: d5(t1), D1(t0), D2(t0), D3(t0)
> ...
> t9: d9(t7), D3(t0)
> t10: D3(t0)
> t11: d10(t10), d11(t10)
> t12: d11(t10)
> 
> In transaction 9, we finish d9 and try to roll to t10 while holding onto
> an intent item for D3 that we logged in t0.
> 
> The previous commit changed the order in which we place new defer ops in
> the defer ops processing chain to reduce the maximum chain length.  Now
> make xfs_defer_finish_noroll capable of relogging the entire chain
> periodically so that we can always move the log tail forward.  Most
> chains will never get relogged, except for operations that generate very
> long chains (large extents containing many blocks with different sharing
> levels) or are on filesystems with small logs and a lot of ongoing
> metadata updates.
> 
> Callers are now required to ensure that the transaction reservation is
> large enough to handle logging done items and new intent items for the
> maximum possible chain length.  Most callers are careful to keep the
> chain lengths low, so the overhead should be minimal.
> 
> The decision to relog an intent item is made based on whether the intent
> was logged in a previous checkpoint, since there's no point in relogging
> an intent into the same checkpoint.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_defer.c  |   42 ++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_bmap_item.c     |   27 +++++++++++++++++++++++++++
>  fs/xfs/xfs_extfree_item.c  |   29 +++++++++++++++++++++++++++++
>  fs/xfs/xfs_refcount_item.c |   27 +++++++++++++++++++++++++++
>  fs/xfs/xfs_rmap_item.c     |   27 +++++++++++++++++++++++++++
>  fs/xfs/xfs_stats.c         |    4 ++++
>  fs/xfs/xfs_stats.h         |    1 +
>  fs/xfs/xfs_trace.h         |    1 +
>  fs/xfs/xfs_trans.h         |   10 ++++++++++
>  9 files changed, 168 insertions(+)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> index 81084c34138f..554777d1069c 100644
> --- a/fs/xfs/libxfs/xfs_defer.c
> +++ b/fs/xfs/libxfs/xfs_defer.c
> @@ -17,6 +17,7 @@
>  #include "xfs_inode_item.h"
>  #include "xfs_trace.h"
>  #include "xfs_icache.h"
> +#include "xfs_log.h"
>  
>  /*
>   * Deferred Operations in XFS
> @@ -345,6 +346,42 @@ xfs_defer_cancel_list(
>  	}
>  }
>  
> +/*
> + * Prevent a log intent item from pinning the tail of the log by logging a
> + * done item to release the intent item; and then log a new intent item.
> + * The caller should provide a fresh transaction and roll it after we're done.
> + */
> +static int
> +xfs_defer_relog(
> +	struct xfs_trans		**tpp,
> +	struct list_head		*dfops)
> +{
> +	struct xfs_defer_pending	*dfp;
> +
> +	ASSERT((*tpp)->t_flags & XFS_TRANS_PERM_LOG_RES);
> +
> +	list_for_each_entry(dfp, dfops, dfp_list) {
> +		/*
> +		 * If the log intent item for this deferred op is not a part of
> +		 * the current log checkpoint, relog the intent item to keep
> +		 * the log tail moving forward.  We're ok with this being racy
> +		 * because an incorrect decision means we'll be a little slower
> +		 * at pushing the tail.
> +		 */
> +		if (dfp->dfp_intent == NULL ||
> +		    xfs_log_item_in_current_chkpt(dfp->dfp_intent))
> +			continue;
> +

As discussed in the previous thread and on IRC, I'm a little concerned
that this could result in undesireable behavior in certain cases. For
example, if the chain grows too large for a transaction (since we don't
explicitly account intents in transaction reservation afaict), if we
have many of them hammering the log all at once, etc. That said, I don't
recall whether the previous versions included the transaction roll below
after relogging one or more intents or I just missed it, but that
mitigates one of my concerns because I was thinking we'd log the chain
in the same transaction used for the next dfop on the list.

In any event, I'm fine with it if this is preferred and has been
sufficiently stress tested:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +		trace_xfs_defer_relog_intent((*tpp)->t_mountp, dfp);
> +		XFS_STATS_INC((*tpp)->t_mountp, defer_relog);
> +		dfp->dfp_intent = xfs_trans_item_relog(dfp->dfp_intent, *tpp);
> +	}
> +
> +	if ((*tpp)->t_flags & XFS_TRANS_DIRTY)
> +		return xfs_defer_trans_roll(tpp);
> +	return 0;
> +}
> +
>  /*
>   * Log an intent-done item for the first pending intent, and finish the work
>   * items.
> @@ -431,6 +468,11 @@ xfs_defer_finish_noroll(
>  		if (error)
>  			goto out_shutdown;
>  
> +		/* Possibly relog intent items to keep the log moving. */
> +		error = xfs_defer_relog(tp, &dop_pending);
> +		if (error)
> +			goto out_shutdown;
> +
>  		dfp = list_first_entry(&dop_pending, struct xfs_defer_pending,
>  				       dfp_list);
>  		error = xfs_defer_finish_one(*tp, dfp);
> diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> index 0ffbc75bafe1..1cca93d3d743 100644
> --- a/fs/xfs/xfs_bmap_item.c
> +++ b/fs/xfs/xfs_bmap_item.c
> @@ -532,6 +532,32 @@ xfs_bui_item_match(
>  	return BUI_ITEM(lip)->bui_format.bui_id == intent_id;
>  }
>  
> +/* Relog an intent item to push the log tail forward. */
> +static struct xfs_log_item *
> +xfs_bui_item_relog(
> +	struct xfs_log_item		*intent,
> +	struct xfs_trans		*tp)
> +{
> +	struct xfs_bud_log_item		*budp;
> +	struct xfs_bui_log_item		*buip;
> +	struct xfs_map_extent		*extp;
> +	unsigned int			count;
> +
> +	count = BUI_ITEM(intent)->bui_format.bui_nextents;
> +	extp = BUI_ITEM(intent)->bui_format.bui_extents;
> +
> +	tp->t_flags |= XFS_TRANS_DIRTY;
> +	budp = xfs_trans_get_bud(tp, BUI_ITEM(intent));
> +	set_bit(XFS_LI_DIRTY, &budp->bud_item.li_flags);
> +
> +	buip = xfs_bui_init(tp->t_mountp);
> +	memcpy(buip->bui_format.bui_extents, extp, count * sizeof(*extp));
> +	atomic_set(&buip->bui_next_extent, count);
> +	xfs_trans_add_item(tp, &buip->bui_item);
> +	set_bit(XFS_LI_DIRTY, &buip->bui_item.li_flags);
> +	return &buip->bui_item;
> +}
> +
>  static const struct xfs_item_ops xfs_bui_item_ops = {
>  	.iop_size	= xfs_bui_item_size,
>  	.iop_format	= xfs_bui_item_format,
> @@ -539,6 +565,7 @@ static const struct xfs_item_ops xfs_bui_item_ops = {
>  	.iop_release	= xfs_bui_item_release,
>  	.iop_recover	= xfs_bui_item_recover,
>  	.iop_match	= xfs_bui_item_match,
> +	.iop_relog	= xfs_bui_item_relog,
>  };
>  
>  /*
> diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
> index 3920542f5736..6c11bfc3d452 100644
> --- a/fs/xfs/xfs_extfree_item.c
> +++ b/fs/xfs/xfs_extfree_item.c
> @@ -642,6 +642,34 @@ xfs_efi_item_match(
>  	return EFI_ITEM(lip)->efi_format.efi_id == intent_id;
>  }
>  
> +/* Relog an intent item to push the log tail forward. */
> +static struct xfs_log_item *
> +xfs_efi_item_relog(
> +	struct xfs_log_item		*intent,
> +	struct xfs_trans		*tp)
> +{
> +	struct xfs_efd_log_item		*efdp;
> +	struct xfs_efi_log_item		*efip;
> +	struct xfs_extent		*extp;
> +	unsigned int			count;
> +
> +	count = EFI_ITEM(intent)->efi_format.efi_nextents;
> +	extp = EFI_ITEM(intent)->efi_format.efi_extents;
> +
> +	tp->t_flags |= XFS_TRANS_DIRTY;
> +	efdp = xfs_trans_get_efd(tp, EFI_ITEM(intent), count);
> +	efdp->efd_next_extent = count;
> +	memcpy(efdp->efd_format.efd_extents, extp, count * sizeof(*extp));
> +	set_bit(XFS_LI_DIRTY, &efdp->efd_item.li_flags);
> +
> +	efip = xfs_efi_init(tp->t_mountp, count);
> +	memcpy(efip->efi_format.efi_extents, extp, count * sizeof(*extp));
> +	atomic_set(&efip->efi_next_extent, count);
> +	xfs_trans_add_item(tp, &efip->efi_item);
> +	set_bit(XFS_LI_DIRTY, &efip->efi_item.li_flags);
> +	return &efip->efi_item;
> +}
> +
>  static const struct xfs_item_ops xfs_efi_item_ops = {
>  	.iop_size	= xfs_efi_item_size,
>  	.iop_format	= xfs_efi_item_format,
> @@ -649,6 +677,7 @@ static const struct xfs_item_ops xfs_efi_item_ops = {
>  	.iop_release	= xfs_efi_item_release,
>  	.iop_recover	= xfs_efi_item_recover,
>  	.iop_match	= xfs_efi_item_match,
> +	.iop_relog	= xfs_efi_item_relog,
>  };
>  
>  /*
> diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
> index ad895b48f365..7529eb63ce94 100644
> --- a/fs/xfs/xfs_refcount_item.c
> +++ b/fs/xfs/xfs_refcount_item.c
> @@ -560,6 +560,32 @@ xfs_cui_item_match(
>  	return CUI_ITEM(lip)->cui_format.cui_id == intent_id;
>  }
>  
> +/* Relog an intent item to push the log tail forward. */
> +static struct xfs_log_item *
> +xfs_cui_item_relog(
> +	struct xfs_log_item		*intent,
> +	struct xfs_trans		*tp)
> +{
> +	struct xfs_cud_log_item		*cudp;
> +	struct xfs_cui_log_item		*cuip;
> +	struct xfs_phys_extent		*extp;
> +	unsigned int			count;
> +
> +	count = CUI_ITEM(intent)->cui_format.cui_nextents;
> +	extp = CUI_ITEM(intent)->cui_format.cui_extents;
> +
> +	tp->t_flags |= XFS_TRANS_DIRTY;
> +	cudp = xfs_trans_get_cud(tp, CUI_ITEM(intent));
> +	set_bit(XFS_LI_DIRTY, &cudp->cud_item.li_flags);
> +
> +	cuip = xfs_cui_init(tp->t_mountp, count);
> +	memcpy(cuip->cui_format.cui_extents, extp, count * sizeof(*extp));
> +	atomic_set(&cuip->cui_next_extent, count);
> +	xfs_trans_add_item(tp, &cuip->cui_item);
> +	set_bit(XFS_LI_DIRTY, &cuip->cui_item.li_flags);
> +	return &cuip->cui_item;
> +}
> +
>  static const struct xfs_item_ops xfs_cui_item_ops = {
>  	.iop_size	= xfs_cui_item_size,
>  	.iop_format	= xfs_cui_item_format,
> @@ -567,6 +593,7 @@ static const struct xfs_item_ops xfs_cui_item_ops = {
>  	.iop_release	= xfs_cui_item_release,
>  	.iop_recover	= xfs_cui_item_recover,
>  	.iop_match	= xfs_cui_item_match,
> +	.iop_relog	= xfs_cui_item_relog,
>  };
>  
>  /*
> diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
> index 1163f32c3e62..7adc996ca6e3 100644
> --- a/fs/xfs/xfs_rmap_item.c
> +++ b/fs/xfs/xfs_rmap_item.c
> @@ -583,6 +583,32 @@ xfs_rui_item_match(
>  	return RUI_ITEM(lip)->rui_format.rui_id == intent_id;
>  }
>  
> +/* Relog an intent item to push the log tail forward. */
> +static struct xfs_log_item *
> +xfs_rui_item_relog(
> +	struct xfs_log_item		*intent,
> +	struct xfs_trans		*tp)
> +{
> +	struct xfs_rud_log_item		*rudp;
> +	struct xfs_rui_log_item		*ruip;
> +	struct xfs_map_extent		*extp;
> +	unsigned int			count;
> +
> +	count = RUI_ITEM(intent)->rui_format.rui_nextents;
> +	extp = RUI_ITEM(intent)->rui_format.rui_extents;
> +
> +	tp->t_flags |= XFS_TRANS_DIRTY;
> +	rudp = xfs_trans_get_rud(tp, RUI_ITEM(intent));
> +	set_bit(XFS_LI_DIRTY, &rudp->rud_item.li_flags);
> +
> +	ruip = xfs_rui_init(tp->t_mountp, count);
> +	memcpy(ruip->rui_format.rui_extents, extp, count * sizeof(*extp));
> +	atomic_set(&ruip->rui_next_extent, count);
> +	xfs_trans_add_item(tp, &ruip->rui_item);
> +	set_bit(XFS_LI_DIRTY, &ruip->rui_item.li_flags);
> +	return &ruip->rui_item;
> +}
> +
>  static const struct xfs_item_ops xfs_rui_item_ops = {
>  	.iop_size	= xfs_rui_item_size,
>  	.iop_format	= xfs_rui_item_format,
> @@ -590,6 +616,7 @@ static const struct xfs_item_ops xfs_rui_item_ops = {
>  	.iop_release	= xfs_rui_item_release,
>  	.iop_recover	= xfs_rui_item_recover,
>  	.iop_match	= xfs_rui_item_match,
> +	.iop_relog	= xfs_rui_item_relog,
>  };
>  
>  /*
> diff --git a/fs/xfs/xfs_stats.c b/fs/xfs/xfs_stats.c
> index f70f1255220b..20e0534a772c 100644
> --- a/fs/xfs/xfs_stats.c
> +++ b/fs/xfs/xfs_stats.c
> @@ -23,6 +23,7 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
>  	uint64_t	xs_xstrat_bytes = 0;
>  	uint64_t	xs_write_bytes = 0;
>  	uint64_t	xs_read_bytes = 0;
> +	uint64_t	defer_relog = 0;
>  
>  	static const struct xstats_entry {
>  		char	*desc;
> @@ -70,10 +71,13 @@ int xfs_stats_format(struct xfsstats __percpu *stats, char *buf)
>  		xs_xstrat_bytes += per_cpu_ptr(stats, i)->s.xs_xstrat_bytes;
>  		xs_write_bytes += per_cpu_ptr(stats, i)->s.xs_write_bytes;
>  		xs_read_bytes += per_cpu_ptr(stats, i)->s.xs_read_bytes;
> +		defer_relog += per_cpu_ptr(stats, i)->s.defer_relog;
>  	}
>  
>  	len += scnprintf(buf + len, PATH_MAX-len, "xpc %Lu %Lu %Lu\n",
>  			xs_xstrat_bytes, xs_write_bytes, xs_read_bytes);
> +	len += scnprintf(buf + len, PATH_MAX-len, "defer_relog %llu\n",
> +			defer_relog);
>  	len += scnprintf(buf + len, PATH_MAX-len, "debug %u\n",
>  #if defined(DEBUG)
>  		1);
> diff --git a/fs/xfs/xfs_stats.h b/fs/xfs/xfs_stats.h
> index 34d704f703d2..43ffba74f045 100644
> --- a/fs/xfs/xfs_stats.h
> +++ b/fs/xfs/xfs_stats.h
> @@ -137,6 +137,7 @@ struct __xfsstats {
>  	uint64_t		xs_xstrat_bytes;
>  	uint64_t		xs_write_bytes;
>  	uint64_t		xs_read_bytes;
> +	uint64_t		defer_relog;
>  };
>  
>  #define	xfsstats_offset(f)	(offsetof(struct __xfsstats, f)/sizeof(uint32_t))
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index dcdcf99cfa5d..86951652d3ed 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -2533,6 +2533,7 @@ DEFINE_DEFER_PENDING_EVENT(xfs_defer_create_intent);
>  DEFINE_DEFER_PENDING_EVENT(xfs_defer_cancel_list);
>  DEFINE_DEFER_PENDING_EVENT(xfs_defer_pending_finish);
>  DEFINE_DEFER_PENDING_EVENT(xfs_defer_pending_abort);
> +DEFINE_DEFER_PENDING_EVENT(xfs_defer_relog_intent);
>  
>  #define DEFINE_BMAP_FREE_DEFERRED_EVENT DEFINE_PHYS_EXTENT_DEFERRED_EVENT
>  DEFINE_BMAP_FREE_DEFERRED_EVENT(xfs_bmap_free_defer);
> diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> index 186e77d08cc1..084658946cc8 100644
> --- a/fs/xfs/xfs_trans.h
> +++ b/fs/xfs/xfs_trans.h
> @@ -75,6 +75,8 @@ struct xfs_item_ops {
>  	int (*iop_recover)(struct xfs_log_item *lip,
>  			   struct list_head *capture_list);
>  	bool (*iop_match)(struct xfs_log_item *item, uint64_t id);
> +	struct xfs_log_item *(*iop_relog)(struct xfs_log_item *intent,
> +			struct xfs_trans *tp);
>  };
>  
>  /* Is this log item a deferred action intent? */
> @@ -258,4 +260,12 @@ void		xfs_trans_buf_copy_type(struct xfs_buf *dst_bp,
>  
>  extern kmem_zone_t	*xfs_trans_zone;
>  
> +static inline struct xfs_log_item *
> +xfs_trans_item_relog(
> +	struct xfs_log_item	*lip,
> +	struct xfs_trans	*tp)
> +{
> +	return lip->li_ops->iop_relog(lip, tp);
> +}
> +
>  #endif	/* __XFS_TRANS_H__ */
> 

