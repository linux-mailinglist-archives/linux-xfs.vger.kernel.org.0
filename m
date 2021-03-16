Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1609533D62F
	for <lists+linux-xfs@lfdr.de>; Tue, 16 Mar 2021 15:53:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237522AbhCPOxV (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 16 Mar 2021 10:53:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50737 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229956AbhCPOxH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Mar 2021 10:53:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615906386;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SsDebXdXEoxHlEu/UYqfmeGno1g0j4im+6WBzvidJaA=;
        b=OOBgtiLyPPgyWWlk0ObTmUK5fu226PmR4keXzo2RwqqFw/T9v7eDH97gsOZ+WcrPZUNzyF
        FhCjc1TQpHERQnqMaUg20UIbQW2jOlHDEmX4YMh6ZoAdyfxIYrHT69fOPHe5beyCwxrwnC
        fspQjXDh2hgHre7TawWEamns6QnhoaU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-LPG_Y68UOn63mqn_wm-WbQ-1; Tue, 16 Mar 2021 10:53:05 -0400
X-MC-Unique: LPG_Y68UOn63mqn_wm-WbQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 089FF101F7C0;
        Tue, 16 Mar 2021 14:53:04 +0000 (UTC)
Received: from bfoster (ovpn-112-124.rdu2.redhat.com [10.10.112.124])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2EBA010023BE;
        Tue, 16 Mar 2021 14:53:02 +0000 (UTC)
Date:   Tue, 16 Mar 2021 10:53:01 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 25/45] xfs: reserve space and initialise xlog_op_header
 in item formatting
Message-ID: <YFDGTRSdC/PtkVLv@bfoster>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-26-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305051143.182133-26-david@fromorbit.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 05, 2021 at 04:11:23PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Current xlog_write() adds op headers to the log manually for every
> log item region that is in the vector passed to it. While
> xlog_write() needs to stamp the transaction ID into the ophdr, we
> already know it's length, flags, clientid, etc at CIL commit time.
> 
> This means the only time that xlog write really needs to format and
> reserve space for a new ophdr is when a region is split across two
> iclogs. Adding the opheader and accounting for it as part of the
> normal formatted item region means we simplify the accounting
> of space used by a transaction and we don't have to special case
> reserving of space in for the ophdrs in xlog_write(). It also means
> we can largely initialise the ophdr in transaction commit instead
> of xlog_write, making the xlog_write formatting inner loop much
> tighter.
> 
> xlog_prepare_iovec() is now too large to stay as an inline function,
> so we move it out of line and into xfs_log.c.
> 
> Object sizes:
> text	   data	    bss	    dec	    hex	filename
> 1125934	 305951	    484	1432369	 15db31 fs/xfs/built-in.a.before
> 1123360	 305951	    484	1429795	 15d123 fs/xfs/built-in.a.after
> 
> So the code is a roughly 2.5kB smaller with xlog_prepare_iovec() now
> out of line, even though it grew in size itself.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Looks mostly reasonable, a couple or so questions...

>  fs/xfs/xfs_log.c     | 115 +++++++++++++++++++++++++++++--------------
>  fs/xfs/xfs_log.h     |  42 +++-------------
>  fs/xfs/xfs_log_cil.c |  25 +++++-----
>  3 files changed, 99 insertions(+), 83 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 429cb1e7cc67..98de45be80c0 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -89,6 +89,62 @@ xlog_iclogs_empty(
>  static int
>  xfs_log_cover(struct xfs_mount *);
>  
> +/*
> + * We need to make sure the buffer pointer returned is naturally aligned for the
> + * biggest basic data type we put into it. We have already accounted for this
> + * padding when sizing the buffer.
> + *
> + * However, this padding does not get written into the log, and hence we have to
> + * track the space used by the log vectors separately to prevent log space hangs
> + * due to inaccurate accounting (i.e. a leak) of the used log space through the
> + * CIL context ticket.
> + *
> + * We also add space for the xlog_op_header that describes this region in the
> + * log. This prepends the data region we return to the caller to copy their data
> + * into, so do all the static initialisation of the ophdr now. Because the ophdr
> + * is not 8 byte aligned, we have to be careful to ensure that we align the
> + * start of the buffer such that the region we return to the call is 8 byte
> + * aligned and packed against the tail of the ophdr.
> + */
> +void *
> +xlog_prepare_iovec(
> +	struct xfs_log_vec	*lv,
> +	struct xfs_log_iovec	**vecp,
> +	uint			type)
> +{
> +	struct xfs_log_iovec	*vec = *vecp;
> +	struct xlog_op_header	*oph;
> +	uint32_t		len;
> +	void			*buf;
> +
> +	if (vec) {
> +		ASSERT(vec - lv->lv_iovecp < lv->lv_niovecs);
> +		vec++;
> +	} else {
> +		vec = &lv->lv_iovecp[0];
> +	}
> +
> +	len = lv->lv_buf_len + sizeof(struct xlog_op_header);
> +	if (!IS_ALIGNED(len, sizeof(uint64_t))) {
> +		lv->lv_buf_len = round_up(len, sizeof(uint64_t)) -
> +					sizeof(struct xlog_op_header);
> +	}
> +
> +	vec->i_type = type;
> +	vec->i_addr = lv->lv_buf + lv->lv_buf_len;
> +
> +	oph = vec->i_addr;
> +	oph->oh_clientid = XFS_TRANSACTION;
> +	oph->oh_res2 = 0;
> +	oph->oh_flags = 0;
> +
> +	buf = vec->i_addr + sizeof(struct xlog_op_header);
> +	ASSERT(IS_ALIGNED((unsigned long)buf, sizeof(uint64_t)));

Why is it the buffer portion needs to be 8 byte aligned but not ->i_addr
itself?

> +
> +	*vecp = vec;
> +	return buf;
> +}
> +

Not worth changing now, but it's helpful to reduce the size of the patch
by separating out mechanical changes like moving functions around.

>  static void
>  xlog_grant_sub_space(
>  	struct xlog		*log,
...
> @@ -2149,18 +2205,7 @@ xlog_write_calc_vec_length(
>  			xlog_tic_add_region(ticket, vecp->i_len, vecp->i_type);
>  		}
>  	}
> -
> -	/* Don't account for regions with embedded ophdrs */
> -	if (optype && headers > 0) {
> -		headers--;
> -		if (optype & XLOG_START_TRANS) {
> -			ASSERT(headers >= 1);
> -			headers--;
> -		}
> -	}
> -
>  	ticket->t_res_num_ophdrs += headers;
> -	len += headers * sizeof(struct xlog_op_header);

Hm, this seems to suggest something was off wrt to ->t_res_num_ophdrs
prior to this change.  Granted this looks like it's just a debug field,
but the previous logic filtered out embedded op headers unconditionally
whereas now it looks like we go back to accounting them. Am I missing
something?

>  
>  	return len;
>  }
...
> @@ -2404,21 +2448,25 @@ xlog_write(
>  			ASSERT((unsigned long)ptr % sizeof(int32_t) == 0);
>  
>  			/*
> -			 * The XLOG_START_TRANS has embedded ophdrs for the
> -			 * start record and transaction header. They will always
> -			 * be the first two regions in the lv chain. Commit and
> -			 * unmount records also have embedded ophdrs.
> +			 * Regions always have their ophdr at the start of the
> +			 * region, except for:
> +			 * - a transaction start which has a start record ophdr
> +			 *   before the first region ophdr; and
> +			 * - the previous region didn't fully fit into an iclog
> +			 *   so needs a continuation ophdr to prepend the region
> +			 *   in this new iclog.
>  			 */
> -			if (optype) {
> -				ophdr = reg->i_addr;
> -				if (index)
> -					optype &= ~XLOG_START_TRANS;
> -			} else {
> +			ophdr = reg->i_addr;
> +			if (optype && index) {
> +				optype &= ~XLOG_START_TRANS;
> +			} else if (partial_copy) {
>                                  ophdr = xlog_write_setup_ophdr(ptr, ticket);
>  				xlog_write_adv_cnt(&ptr, &len, &log_offset,
>  					   sizeof(struct xlog_op_header));
>  				added_ophdr = true;
>  			}

So in the partial_copy continuation case we're still stamping an ophdr
directly into the iclog. Otherwise we're processing/modifying flags and
whatnot on the ophdr already stamped at commit time in the log vector.
However, this is Ok because a relog would reformat the op header.

> +			ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
> +
>  			len += xlog_write_setup_copy(ticket, ophdr,
>  						     iclog->ic_size-log_offset,
>  						     reg->i_len,
> @@ -2436,20 +2484,11 @@ xlog_write(
>  				ophdr->oh_len = cpu_to_be32(copy_len -
>  						sizeof(struct xlog_op_header));
>  			}
> -			/*
> -			 * Copy region.
> -			 *
> -			 * Commit records just log an opheader, so
> -			 * we can have empty payloads with no data region to
> -			 * copy.  Hence we only copy the payload if the vector
> -			 * says it has data to copy.
> -			 */
> -			ASSERT(copy_len >= 0);
> -			if (copy_len > 0) {
> -				memcpy(ptr, reg->i_addr + copy_off, copy_len);
> -				xlog_write_adv_cnt(&ptr, &len, &log_offset,
> -						   copy_len);
> -			}
> +
> +			ASSERT(copy_len > 0);
> +			memcpy(ptr, reg->i_addr + copy_off, copy_len);
> +			xlog_write_adv_cnt(&ptr, &len, &log_offset, copy_len);
> +

I assume the checks in xlog_write_copy_finish() to require a minimum of
one op header worth of space in the iclog prevent doing a partial write
across an embedded op header boundary, but it would be nice to have an
assert or something that ensures that. For example, assert for something
like if a partial_copy occurs, partial_copy_len was at least the length
of an op header into the region.

>  			if (added_ophdr)
>  				copy_len += sizeof(struct xlog_op_header);
>  			record_cnt++;
...
> diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> index 0c81c13e2cf6..7a5e6bdb7876 100644
> --- a/fs/xfs/xfs_log_cil.c
> +++ b/fs/xfs/xfs_log_cil.c
> @@ -181,13 +181,20 @@ xlog_cil_alloc_shadow_bufs(
>  		}
>  
>  		/*
> -		 * We 64-bit align the length of each iovec so that the start
> -		 * of the next one is naturally aligned.  We'll need to
> -		 * account for that slack space here. Then round nbytes up
> -		 * to 64-bit alignment so that the initial buffer alignment is
> -		 * easy to calculate and verify.
> +		 * We 64-bit align the length of each iovec so that the start of
> +		 * the next one is naturally aligned.  We'll need to account for
> +		 * that slack space here.
> +		 *

Related to my question above, I'm a little confused by the (preexisting)
comment. If the start of the next iovec is now the ophdr, doesn't that
mean the "start of the next one (iovec)" is technically no longer
naturally aligned?

Brian

> +		 * We also add the xlog_op_header to each region when
> +		 * formatting, but that's not accounted to the size of the item
> +		 * at this point. Hence we'll need an addition number of bytes
> +		 * for each vector to hold an opheader.
> +		 *
> +		 * Then round nbytes up to 64-bit alignment so that the initial
> +		 * buffer alignment is easy to calculate and verify.
>  		 */
> -		nbytes += niovecs * sizeof(uint64_t);
> +		nbytes += niovecs *
> +			(sizeof(uint64_t) + sizeof(struct xlog_op_header));
>  		nbytes = round_up(nbytes, sizeof(uint64_t));
>  
>  		/*
> @@ -433,11 +440,6 @@ xlog_cil_insert_items(
>  
>  	spin_lock(&cil->xc_cil_lock);
>  
> -	/* account for space used by new iovec headers  */
> -	iovhdr_res = diff_iovecs * sizeof(xlog_op_header_t);
> -	len += iovhdr_res;
> -	ctx->nvecs += diff_iovecs;
> -
>  	/* attach the transaction to the CIL if it has any busy extents */
>  	if (!list_empty(&tp->t_busy))
>  		list_splice_init(&tp->t_busy, &ctx->busy_extents);
> @@ -469,6 +471,7 @@ xlog_cil_insert_items(
>  	}
>  	tp->t_ticket->t_curr_res -= len;
>  	ctx->space_used += len;
> +	ctx->nvecs += diff_iovecs;
>  
>  	/*
>  	 * If we've overrun the reservation, dump the tx details before we move
> -- 
> 2.28.0
> 

