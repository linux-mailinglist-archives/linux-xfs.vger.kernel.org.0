Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8DB597AF3
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Aug 2019 15:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbfHUNeg (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 21 Aug 2019 09:34:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55854 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726371AbfHUNeg (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 21 Aug 2019 09:34:36 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 753541801580;
        Wed, 21 Aug 2019 13:34:35 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1D25057B6;
        Wed, 21 Aug 2019 13:34:35 +0000 (UTC)
Date:   Wed, 21 Aug 2019 09:34:33 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: add kmem allocation trace points
Message-ID: <20190821133433.GA19646@bfoster>
References: <20190821083820.11725-1-david@fromorbit.com>
 <20190821083820.11725-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190821083820.11725-2-david@fromorbit.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.63]); Wed, 21 Aug 2019 13:34:35 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 21, 2019 at 06:38:18PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> When trying to correlate XFS kernel allocations to memory reclaim
> behaviour, it is useful to know what allocations XFS is actually
> attempting. This information is not directly available from
> tracepoints in the generic memory allocation and reclaim
> tracepoints, so these new trace points provide a high level
> indication of what the XFS memory demand actually is.
> 
> There is no per-filesystem context in this code, so we just trace
> the type of allocation, the size and the allocation constraints.
> The kmem code also doesn't include much of the common XFS headers,
> so there are a few definitions that need to be added to the trace
> headers and a couple of types that need to be made common to avoid
> needing to include the whole world in the kmem code.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/kmem.c             | 11 +++++++++--
>  fs/xfs/libxfs/xfs_types.h |  8 ++++++++
>  fs/xfs/xfs_mount.h        |  7 -------
>  fs/xfs/xfs_trace.h        | 33 +++++++++++++++++++++++++++++++++
>  4 files changed, 50 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
> index 16bb9a328678..edcf393c8fd9 100644
> --- a/fs/xfs/kmem.c
> +++ b/fs/xfs/kmem.c
...
> @@ -85,6 +91,7 @@ kmem_zone_alloc(kmem_zone_t *zone, xfs_km_flags_t flags)
>  	gfp_t	lflags = kmem_flags_convert(flags);
>  	void	*ptr;
>  
> +	trace_kmem_zone_alloc(0, flags, _RET_IP_);

You can use kmem_cache_size() to determine object size here. With that
fixed:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  	do {
>  		ptr = kmem_cache_alloc(zone, lflags);
>  		if (ptr || (flags & (KM_MAYFAIL|KM_NOSLEEP)))
> diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> index 802b34cd10fe..300b3e91ca3a 100644
> --- a/fs/xfs/libxfs/xfs_types.h
> +++ b/fs/xfs/libxfs/xfs_types.h
> @@ -169,6 +169,14 @@ typedef struct xfs_bmbt_irec
>  	xfs_exntst_t	br_state;	/* extent state */
>  } xfs_bmbt_irec_t;
>  
> +/* per-AG block reservation types */
> +enum xfs_ag_resv_type {
> +	XFS_AG_RESV_NONE = 0,
> +	XFS_AG_RESV_AGFL,
> +	XFS_AG_RESV_METADATA,
> +	XFS_AG_RESV_RMAPBT,
> +};
> +
>  /*
>   * Type verifier functions
>   */
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 4adb6837439a..fdb60e09a9c5 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -327,13 +327,6 @@ xfs_daddr_to_agbno(struct xfs_mount *mp, xfs_daddr_t d)
>  }
>  
>  /* per-AG block reservation data structures*/
> -enum xfs_ag_resv_type {
> -	XFS_AG_RESV_NONE = 0,
> -	XFS_AG_RESV_AGFL,
> -	XFS_AG_RESV_METADATA,
> -	XFS_AG_RESV_RMAPBT,
> -};
> -
>  struct xfs_ag_resv {
>  	/* number of blocks originally reserved here */
>  	xfs_extlen_t			ar_orig_reserved;
> diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
> index 8094b1920eef..8bb8b4704a00 100644
> --- a/fs/xfs/xfs_trace.h
> +++ b/fs/xfs/xfs_trace.h
> @@ -23,6 +23,7 @@ struct xlog;
>  struct xlog_ticket;
>  struct xlog_recover;
>  struct xlog_recover_item;
> +struct xlog_rec_header;
>  struct xfs_buf_log_format;
>  struct xfs_inode_log_format;
>  struct xfs_bmbt_irec;
> @@ -30,6 +31,10 @@ struct xfs_btree_cur;
>  struct xfs_refcount_irec;
>  struct xfs_fsmap;
>  struct xfs_rmap_irec;
> +struct xfs_icreate_log;
> +struct xfs_owner_info;
> +struct xfs_trans_res;
> +struct xfs_inobt_rec_incore;
>  
>  DECLARE_EVENT_CLASS(xfs_attr_list_class,
>  	TP_PROTO(struct xfs_attr_list_context *ctx),
> @@ -3575,6 +3580,34 @@ TRACE_EVENT(xfs_pwork_init,
>  		  __entry->nr_threads, __entry->pid)
>  )
>  
> +DECLARE_EVENT_CLASS(xfs_kmem_class,
> +	TP_PROTO(ssize_t size, int flags, unsigned long caller_ip),
> +	TP_ARGS(size, flags, caller_ip),
> +	TP_STRUCT__entry(
> +		__field(ssize_t, size)
> +		__field(int, flags)
> +		__field(unsigned long, caller_ip)
> +	),
> +	TP_fast_assign(
> +		__entry->size = size;
> +		__entry->flags = flags;
> +		__entry->caller_ip = caller_ip;
> +	),
> +	TP_printk("size %zd flags 0x%x caller %pS",
> +		  __entry->size,
> +		  __entry->flags,
> +		  (char *)__entry->caller_ip)
> +)
> +
> +#define DEFINE_KMEM_EVENT(name) \
> +DEFINE_EVENT(xfs_kmem_class, name, \
> +	TP_PROTO(ssize_t size, int flags, unsigned long caller_ip), \
> +	TP_ARGS(size, flags, caller_ip))
> +DEFINE_KMEM_EVENT(kmem_alloc);
> +DEFINE_KMEM_EVENT(kmem_alloc_large);
> +DEFINE_KMEM_EVENT(kmem_realloc);
> +DEFINE_KMEM_EVENT(kmem_zone_alloc);
> +
>  #endif /* _TRACE_XFS_H */
>  
>  #undef TRACE_INCLUDE_PATH
> -- 
> 2.23.0.rc1
> 
