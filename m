Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF5E570DDC
	for <lists+linux-xfs@lfdr.de>; Tue, 23 Jul 2019 02:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387556AbfGWAGg (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 22 Jul 2019 20:06:36 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:54568 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727643AbfGWAGg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Jul 2019 20:06:36 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6MNwXJ9127979;
        Tue, 23 Jul 2019 00:06:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=eU3/fNgVeEP92Ut8eVfzJbCjOn1drf3ko/N2EAYO8uw=;
 b=Vl+7EhvkV+MpuGOYjm58NX5TjraBlXoZnAeHuhZYroypqLYv17mg54CJbRJrp+gbMX/6
 axFal//m2cRfNKc2K9rET61dbIh9vWnUCxb6qRJWeRBL9P/6gvS2ANMQkINQyLyMQgYg
 7gJ5yWBT7Pc+8AxnX0vpekUg3DSKHwelTUS2YNzoUpfEb3TSXYfpgpiXh4Jzm0azqrOl
 Q2eK0hk27R3xfbZrXwu049kjt6qBwoSSdsf2bSGR8YxJquAW2NBM7s2uM50v6R72c5Eb
 P9oiTfG/Dm2gk1SHJ4BadIFX/4Ffw2wRC0EKpMgosRAG7Xm8E2Zu01zKgJm0cyA/es9B 5A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2tutctaktv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Jul 2019 00:06:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6MNwEBP067004;
        Tue, 23 Jul 2019 00:06:32 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2tuts3bjh7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Jul 2019 00:06:31 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6N06UM5014247;
        Tue, 23 Jul 2019 00:06:30 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 22 Jul 2019 17:06:30 -0700
Date:   Mon, 22 Jul 2019 17:06:29 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: add kmem allocation trace points
Message-ID: <20190723000629.GG7093@magnolia>
References: <20190722233452.31183-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190722233452.31183-1-david@fromorbit.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9326 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907220252
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9326 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907220252
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

Hmm, what does moving this chunk enable?  I don't see the immediate
relevants to the added tracepoints...?  (insofar as "ZOMG MACROS OH MY EYES")

--D

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
