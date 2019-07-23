Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D067718B0
	for <lists+linux-xfs@lfdr.de>; Tue, 23 Jul 2019 14:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390010AbfGWMwP (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 23 Jul 2019 08:52:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56272 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732432AbfGWMwP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Jul 2019 08:52:15 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D16418553A;
        Tue, 23 Jul 2019 12:52:14 +0000 (UTC)
Received: from bfoster (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7AB5319C58;
        Tue, 23 Jul 2019 12:52:14 +0000 (UTC)
Date:   Tue, 23 Jul 2019 08:52:12 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: add kmem allocation trace points
Message-ID: <20190723125212.GB59587@bfoster>
References: <20190722233452.31183-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190722233452.31183-1-david@fromorbit.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Tue, 23 Jul 2019 12:52:14 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jul 23, 2019 at 09:34:52AM +1000, Dave Chinner wrote:
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
> the type of allocation, the size and the iallocation constraints.
> The kmem code alos doesn't include much of the common XFS headers,
> so there are a few definitions that need to be added to the trace
> headers and a couple of types that need to be made common to avoid
> needing to include the whole world in the kmem code.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Seems fine:

Reviewed-by: Brian Foster <bfoster@redhat.com>

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
> @@ -3,10 +3,10 @@
>   * Copyright (c) 2000-2005 Silicon Graphics, Inc.
>   * All Rights Reserved.
>   */
> -#include <linux/sched/mm.h>
> +#include "xfs.h"
>  #include <linux/backing-dev.h>
> -#include "kmem.h"
>  #include "xfs_message.h"
> +#include "xfs_trace.h"
>  
>  void *
>  kmem_alloc(size_t size, xfs_km_flags_t flags)
> @@ -15,6 +15,8 @@ kmem_alloc(size_t size, xfs_km_flags_t flags)
>  	gfp_t	lflags = kmem_flags_convert(flags);
>  	void	*ptr;
>  
> +	trace_kmem_alloc(size, flags, _RET_IP_);
> +
>  	do {
>  		ptr = kmalloc(size, lflags);
>  		if (ptr || (flags & (KM_MAYFAIL|KM_NOSLEEP)))
> @@ -35,6 +37,8 @@ kmem_alloc_large(size_t size, xfs_km_flags_t flags)
>  	void	*ptr;
>  	gfp_t	lflags;
>  
> +	trace_kmem_alloc_large(size, flags, _RET_IP_);
> +
>  	ptr = kmem_alloc(size, flags | KM_MAYFAIL);
>  	if (ptr)
>  		return ptr;
> @@ -65,6 +69,8 @@ kmem_realloc(const void *old, size_t newsize, xfs_km_flags_t flags)
>  	gfp_t	lflags = kmem_flags_convert(flags);
>  	void	*ptr;
>  
> +	trace_kmem_realloc(newsize, flags, _RET_IP_);
> +
>  	do {
>  		ptr = krealloc(old, newsize, lflags);
>  		if (ptr || (flags & (KM_MAYFAIL|KM_NOSLEEP)))
> @@ -85,6 +91,7 @@ kmem_zone_alloc(kmem_zone_t *zone, xfs_km_flags_t flags)
>  	gfp_t	lflags = kmem_flags_convert(flags);
>  	void	*ptr;
>  
> +	trace_kmem_zone_alloc(0, flags, _RET_IP_);
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
> 2.22.0
> 
