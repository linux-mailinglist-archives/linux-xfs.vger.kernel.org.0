Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A616453FF8
	for <lists+linux-xfs@lfdr.de>; Wed, 17 Nov 2021 06:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbhKQFYv (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 17 Nov 2021 00:24:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:38458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232023AbhKQFYu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 17 Nov 2021 00:24:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5179563241;
        Wed, 17 Nov 2021 05:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637126512;
        bh=cXMcbWmVYE5ry8P6HAHth4ShhhY9ZCIfFWzA1a59m+0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R/1HU6jP0cGBgsnI+kOeDiJr6xASLHi7vWmS/2zA9cJMubtAfmqJlItWfVfevRpHc
         7FmNBsy2iQmOovqXJ5nkoVsbH5akkJ8wvc+SqNx1K0VA1DwSQpcjYVgeJ65WvP0BAh
         ni29JHyNSozgpLSHBSi0iFLxmfwWpnOKRDSNpEMYdKzsQ5kCyK0tCcH5HRspIToqcF
         kCoZYz+mMiWp70YTQFmAyxsFjYvL5R1lX+CsVSIsz9Nn20dse7RF3vDrjLWLGb/Zck
         UiAX6KiJzuovnY9MCrg4N8J4uUd47drp+8wxMBOxakQOQiL2e+Li93QqUlfBfpgk9O
         gjzn58V3z/fOA==
Date:   Tue, 16 Nov 2021 21:21:51 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 12/16] xfs:_introduce xlog_write_partial()
Message-ID: <20211117052151.GM24333@magnolia>
References: <20211109015055.1547604-1-david@fromorbit.com>
 <20211109015055.1547604-13-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211109015055.1547604-13-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> Subject: [PATCH 12/16] xfs:_introduce xlog_write_partial()

Nit: There's still an        ^ underscore in the subject.

On Tue, Nov 09, 2021 at 12:50:51PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Re-implement writing of a log vector that does not fit into the current
> iclog. The iclog will already be in XLOG_STATE_WANT_SYNC because
> xlog_get_iclog_space() will have reserved all the remaining iclog
> space for us, hence we can simply iterate over the iovecs in
> the log vector getting more iclog space until the entire log vector
> is written.
> 
> handling this partial write case separately means we do need to pass
> unnecessary state around for the common, fast path case when the log
> vector fits entirely within the current iclog. It isolates the
> complexity and allows us to modify and improve the partial
> write case without impacting the simple fast path.
> 
> This change includes several improvements incorporated from patches
> written by Christoph Hellwig.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_log.c      | 424 +++++++++++++++++++-----------------------
>  fs/xfs/xfs_log_priv.h |   8 -
>  2 files changed, 196 insertions(+), 236 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 44134f8e699c..02db5a712e76 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -2260,7 +2260,8 @@ xlog_write_full(
>  {
>  	int			index;
>  
> -	ASSERT(*log_offset + *len <= iclog->ic_size);
> +	ASSERT(*log_offset + *len <= iclog->ic_size ||
> +		iclog->ic_state == XLOG_STATE_WANT_SYNC);
>  
>  	/*
>  	 * Ordered log vectors have no regions to write so this
> @@ -2278,111 +2279,177 @@ xlog_write_full(
>  	}
>  }
>  
> -static xlog_op_header_t *
> -xlog_write_setup_ophdr(
> -	struct xlog_op_header	*ophdr,
> -	struct xlog_ticket	*ticket)
> +static int
> +xlog_write_get_more_iclog_space(
> +	struct xlog_ticket	*ticket,
> +	struct xlog_in_core	**iclogp,
> +	uint32_t		*log_offset,
> +	uint32_t		len,
> +	uint32_t		*record_cnt,
> +	uint32_t		*data_cnt,
> +	int			*contwr)
>  {
> -	ophdr->oh_clientid = XFS_TRANSACTION;
> -	ophdr->oh_res2 = 0;
> -	ophdr->oh_flags = 0;
> -	return ophdr;
> +	struct xlog_in_core	*iclog = *iclogp;
> +	struct xlog		*log = iclog->ic_log;
> +	int			error;
> +
> +	spin_lock(&log->l_icloglock);
> +	ASSERT(iclog->ic_state == XLOG_STATE_WANT_SYNC);
> +	xlog_state_finish_copy(log, iclog, *record_cnt, *data_cnt);
> +	error = xlog_state_release_iclog(log, iclog, 0);
> +	spin_unlock(&log->l_icloglock);
> +	if (error)
> +		return error;
> +
> +	error = xlog_state_get_iclog_space(log, len, &iclog,
> +				ticket, contwr, log_offset);
> +	if (error)
> +		return error;
> +	*record_cnt = 0;
> +	*data_cnt = 0;
> +	*iclogp = iclog;
> +	return 0;
>  }
>  
>  /*
> - * Set up the parameters of the region copy into the log. This has
> - * to handle region write split across multiple log buffers - this
> - * state is kept external to this function so that this code can
> - * be written in an obvious, self documenting manner.
> + * Write log vectors into a single iclog which is smaller than the current chain
> + * length. We write until we cannot fit a full record into the remaining space
> + * and then stop. We return the log vector that is to be written that cannot
> + * wholly fit in the iclog.
>   */
>  static int
> -xlog_write_setup_copy(
> +xlog_write_partial(
> +	struct xfs_log_vec	*lv,
>  	struct xlog_ticket	*ticket,
> -	struct xlog_op_header	*ophdr,
> -	int			space_available,
> -	int			space_required,
> -	int			*copy_off,
> -	int			*copy_len,
> -	int			*last_was_partial_copy,
> -	int			*bytes_consumed)
> -{
> -	int			still_to_copy;
> -
> -	still_to_copy = space_required - *bytes_consumed;
> -	*copy_off = *bytes_consumed;
> -
> -	if (still_to_copy <= space_available) {
> -		/* write of region completes here */
> -		*copy_len = still_to_copy;
> -		ophdr->oh_len = cpu_to_be32(*copy_len);
> -		if (*last_was_partial_copy)
> -			ophdr->oh_flags |= (XLOG_END_TRANS|XLOG_WAS_CONT_TRANS);
> -		*last_was_partial_copy = 0;
> -		*bytes_consumed = 0;
> -		return 0;
> -	}
> +	struct xlog_in_core	**iclogp,
> +	uint32_t		*log_offset,
> +	uint32_t		*len,
> +	uint32_t		*record_cnt,
> +	uint32_t		*data_cnt,
> +	int			*contwr)
> +{
> +	struct xlog_in_core	*iclog = *iclogp;
> +	struct xlog		*log = iclog->ic_log;
> +	struct xlog_op_header	*ophdr;
> +	int			index = 0;
> +	uint32_t		rlen;
> +	int			error;
>  
> -	/* partial write of region, needs extra log op header reservation */
> -	*copy_len = space_available;
> -	ophdr->oh_len = cpu_to_be32(*copy_len);
> -	ophdr->oh_flags |= XLOG_CONTINUE_TRANS;
> -	if (*last_was_partial_copy)
> -		ophdr->oh_flags |= XLOG_WAS_CONT_TRANS;
> -	*bytes_consumed += *copy_len;
> -	(*last_was_partial_copy)++;
> +	/* walk the logvec, copying until we run out of space in the iclog */
> +	for (index = 0; index < lv->lv_niovecs; index++) {
> +		struct xfs_log_iovec	*reg = &lv->lv_iovecp[index];
> +		uint32_t		reg_offset = 0;
>  
> -	/* account for new log op header */
> -	ticket->t_curr_res -= sizeof(struct xlog_op_header);
> +		/*
> +		 * The first region of a continuation must have a non-zero
> +		 * length otherwise log recovery will just skip over it and
> +		 * start recovering from the next opheader it finds. Because we
> +		 * mark the next opheader as a continuation, recovery will then
> +		 * incorrectly add the continuation to the previous region and
> +		 * that breaks stuff.
> +		 *
> +		 * Hence if there isn't space for region data after the
> +		 * opheader, then we need to start afresh with a new iclog.
> +		 */
> +		if (iclog->ic_size - *log_offset <=
> +					sizeof(struct xlog_op_header)) {
> +			error = xlog_write_get_more_iclog_space(ticket,
> +					&iclog, log_offset, *len, record_cnt,
> +					data_cnt, contwr);
> +			if (error)
> +				return error;
> +		}
>  
> -	return sizeof(struct xlog_op_header);
> -}
> +		ophdr = reg->i_addr;
> +		rlen = min_t(uint32_t, reg->i_len, iclog->ic_size - *log_offset);
>  
> -static int
> -xlog_write_copy_finish(
> -	struct xlog		*log,
> -	struct xlog_in_core	*iclog,
> -	uint			flags,
> -	int			*record_cnt,
> -	int			*data_cnt,
> -	int			*partial_copy,
> -	int			*partial_copy_len,
> -	int			log_offset)
> -{
> -	int			error;
> +		ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
> +		ophdr->oh_len = cpu_to_be32(rlen - sizeof(struct xlog_op_header));
> +		if (rlen != reg->i_len)
> +			ophdr->oh_flags |= XLOG_CONTINUE_TRANS;
> +
> +		xlog_verify_dest_ptr(log, iclog->ic_datap + *log_offset);
> +		xlog_write_iovec(iclog, log_offset, reg->i_addr,
> +				rlen, len, record_cnt, data_cnt);
> +
> +		/* If we wrote the whole region, move to the next. */
> +		if (rlen == reg->i_len)
> +			continue;
>  
> -	if (*partial_copy) {
>  		/*
> -		 * This iclog has already been marked WANT_SYNC by
> -		 * xlog_state_get_iclog_space.
> +		 * We now have a partially written iovec, but it can span
> +		 * multiple iclogs so we loop here. First we release the iclog
> +		 * we currently have, then we get a new iclog and add a new
> +		 * opheader. Then we continue copying from where we were until
> +		 * we either complete the iovec or fill the iclog. If we
> +		 * complete the iovec, then we increment the index and go right
> +		 * back to the top of the outer loop. if we fill the iclog, we
> +		 * run the inner loop again.
> +		 *
> +		 * This is complicated by the tail of a region using all the
> +		 * space in an iclog and hence requiring us to release the iclog
> +		 * and get a new one before returning to the outer loop. We must
> +		 * always guarantee that we exit this inner loop with at least
> +		 * space for log transaction opheaders left in the current
> +		 * iclog, hence we cannot just terminate the loop at the end
> +		 * of the of the continuation. So we loop while there is no
> +		 * space left in the current iclog, and check for the end of the
> +		 * continuation after getting a new iclog.
>  		 */
> -		spin_lock(&log->l_icloglock);
> -		xlog_state_finish_copy(log, iclog, *record_cnt, *data_cnt);
> -		*record_cnt = 0;
> -		*data_cnt = 0;
> -		goto release_iclog;
> -	}
> +		do {
> +			/*
> +			 * Ensure we include the continuation opheader in the
> +			 * space we need in the new iclog by adding that size
> +			 * to the length we require. This continuation opheader
> +			 * needs to be accounted to the ticket as the space it
> +			 * consumes hasn't been accounted to the lv we are
> +			 * writing.
> +			 */
> +			error = xlog_write_get_more_iclog_space(ticket,
> +					&iclog, log_offset,
> +					*len + sizeof(struct xlog_op_header),

Hm.  The last time I saw this patch, it incremented *len by the sizeof
expression, but now we merely pass (*len + sizeof(...)) into
xlog_write_get_more_iclog_space.  Why is that?

The rest of this looks more or less like a slightly reorganized version
that I looked at the from June, so that was the only question I had.

--D

> +					record_cnt, data_cnt, contwr);
> +			if (error)
> +				return error;
> +
> +			ophdr = iclog->ic_datap + *log_offset;
> +			ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
> +			ophdr->oh_clientid = XFS_TRANSACTION;
> +			ophdr->oh_res2 = 0;
> +			ophdr->oh_flags = XLOG_WAS_CONT_TRANS;
>  
> -	*partial_copy = 0;
> -	*partial_copy_len = 0;
> +			ticket->t_curr_res -= sizeof(struct xlog_op_header);
> +			*log_offset += sizeof(struct xlog_op_header);
> +			*data_cnt += sizeof(struct xlog_op_header);
>  
> -	if (iclog->ic_size - log_offset > sizeof(xlog_op_header_t))
> -		return 0;
> +			/*
> +			 * If rlen fits in the iclog, then end the region
> +			 * continuation. Otherwise we're going around again.
> +			 */
> +			reg_offset += rlen;
> +			rlen = reg->i_len - reg_offset;
> +			if (rlen <= iclog->ic_size - *log_offset)
> +				ophdr->oh_flags |= XLOG_END_TRANS;
> +			else
> +				ophdr->oh_flags |= XLOG_CONTINUE_TRANS;
>  
> -	/* no more space in this iclog - push it. */
> -	spin_lock(&log->l_icloglock);
> -	xlog_state_finish_copy(log, iclog, *record_cnt, *data_cnt);
> -	*record_cnt = 0;
> -	*data_cnt = 0;
> +			rlen = min_t(uint32_t, rlen, iclog->ic_size - *log_offset);
> +			ophdr->oh_len = cpu_to_be32(rlen);
>  
> -	if (iclog->ic_state == XLOG_STATE_ACTIVE)
> -		xlog_state_switch_iclogs(log, iclog, 0);
> -	else
> -		ASSERT(iclog->ic_state == XLOG_STATE_WANT_SYNC ||
> -			xlog_is_shutdown(log));
> -release_iclog:
> -	error = xlog_state_release_iclog(log, iclog, 0);
> -	spin_unlock(&log->l_icloglock);
> -	return error;
> +			xlog_verify_dest_ptr(log, iclog->ic_datap + *log_offset);
> +			xlog_write_iovec(iclog, log_offset,
> +					reg->i_addr + reg_offset,
> +					rlen, len, record_cnt, data_cnt);
> +
> +		} while (ophdr->oh_flags & XLOG_CONTINUE_TRANS);
> +	}
> +
> +	/*
> +	 * No more iovecs remain in this logvec so return the next log vec to
> +	 * the caller so it can go back to fast path copying.
> +	 */
> +	*iclogp = iclog;
> +	return 0;
>  }
>  
>  /*
> @@ -2437,14 +2504,11 @@ xlog_write(
>  {
>  	struct xlog_in_core	*iclog = NULL;
>  	struct xfs_log_vec	*lv = log_vector;
> -	struct xfs_log_iovec	*vecp = lv->lv_iovecp;
> -	int			index = 0;
> -	int			partial_copy = 0;
> -	int			partial_copy_len = 0;
>  	int			contwr = 0;
>  	uint32_t		record_cnt = 0;
>  	uint32_t		data_cnt = 0;
>  	int			error = 0;
> +	int			log_offset;
>  
>  	if (ticket->t_curr_res < 0) {
>  		xfs_alert_tag(log->l_mp, XFS_PTAG_LOGRES,
> @@ -2453,151 +2517,54 @@ xlog_write(
>  		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
>  	}
>  
> -	while (lv && (!lv->lv_niovecs || index < lv->lv_niovecs)) {
> -		void		*ptr;
> -		int		log_offset;
> -
> -		error = xlog_state_get_iclog_space(log, len, &iclog, ticket,
> -						   &contwr, &log_offset);
> -		if (error)
> -			return error;
> +	error = xlog_state_get_iclog_space(log, len, &iclog, ticket,
> +					   &contwr, &log_offset);
> +	if (error)
> +		return error;
>  
> -		ASSERT(log_offset <= iclog->ic_size - 1);
> +	ASSERT(log_offset <= iclog->ic_size - 1);
>  
> -		/*
> -		 * If we have a context pointer, pass it the first iclog we are
> -		 * writing to so it can record state needed for iclog write
> -		 * ordering.
> -		 */
> -		if (ctx) {
> -			xlog_cil_set_ctx_write_state(ctx, iclog);
> -			ctx = NULL;
> -		}
> -
> -		/* If this is a single iclog write, go fast... */
> -		if (!contwr && lv == log_vector) {
> -			while (lv) {
> -				xlog_write_full(lv, ticket, iclog, &log_offset,
> -						 &len, &record_cnt, &data_cnt);
> -				lv = lv->lv_next;
> -			}
> -			data_cnt = 0;
> -			break;
> -		}
> +	/*
> +	 * If we have a context pointer, pass it the first iclog we are
> +	 * writing to so it can record state needed for iclog write
> +	 * ordering.
> +	 */
> +	if (ctx)
> +		xlog_cil_set_ctx_write_state(ctx, iclog);
>  
> +	while (lv) {
>  		/*
> -		 * This loop writes out as many regions as can fit in the amount
> -		 * of space which was allocated by xlog_state_get_iclog_space().
> +		 * If the entire log vec does not fit in the iclog, punt it to
> +		 * the partial copy loop which can handle this case.
>  		 */
> -		ptr = iclog->ic_datap + log_offset;
> -		while (lv && (!lv->lv_niovecs || index < lv->lv_niovecs)) {
> -			struct xfs_log_iovec	*reg;
> -			struct xlog_op_header	*ophdr;
> -			int			copy_len;
> -			int			copy_off;
> -			bool			ordered = false;
> -			bool			added_ophdr = false;
> -
> -			/* ordered log vectors have no regions to write */
> -			if (lv->lv_buf_len == XFS_LOG_VEC_ORDERED) {
> -				ASSERT(lv->lv_niovecs == 0);
> -				ordered = true;
> -				goto next_lv;
> -			}
> -
> -			reg = &vecp[index];
> -			ASSERT(reg->i_len % sizeof(int32_t) == 0);
> -			ASSERT((unsigned long)ptr % sizeof(int32_t) == 0);
> -
> -			/*
> -			 * Regions always have their ophdr at the start of the
> -			 * region, except for:
> -			 * - a transaction start which has a start record ophdr
> -			 *   before the first region ophdr; and
> -			 * - the previous region didn't fully fit into an iclog
> -			 *   so needs a continuation ophdr to prepend the region
> -			 *   in this new iclog.
> -			 */
> -			ophdr = reg->i_addr;
> -			if (optype && index) {
> -				optype &= ~XLOG_START_TRANS;
> -			} else if (partial_copy) {
> -                                ophdr = xlog_write_setup_ophdr(ptr, ticket);
> -				xlog_write_adv_cnt(&ptr, &len, &log_offset,
> -					   sizeof(struct xlog_op_header));
> -				added_ophdr = true;
> -			}
> -			ophdr->oh_tid = cpu_to_be32(ticket->t_tid);
> -
> -			len += xlog_write_setup_copy(ticket, ophdr,
> -						     iclog->ic_size-log_offset,
> -						     reg->i_len,
> -						     &copy_off, &copy_len,
> -						     &partial_copy,
> -						     &partial_copy_len);
> -			xlog_verify_dest_ptr(log, ptr);
> -
> -
> -			/*
> -			 * Wart: need to update length in embedded ophdr not
> -			 * to include it's own length.
> -			 */
> -			if (!added_ophdr) {
> -				ophdr->oh_len = cpu_to_be32(copy_len -
> -						sizeof(struct xlog_op_header));
> -			}
> -
> -			ASSERT(copy_len > 0);
> -			memcpy(ptr, reg->i_addr + copy_off, copy_len);
> -			xlog_write_adv_cnt(&ptr, &len, &log_offset, copy_len);
> -
> -			if (added_ophdr)
> -				copy_len += sizeof(struct xlog_op_header);
> -			record_cnt++;
> -			data_cnt += contwr ? copy_len : 0;
> -
> -			error = xlog_write_copy_finish(log, iclog, optype,
> -						       &record_cnt, &data_cnt,
> -						       &partial_copy,
> -						       &partial_copy_len,
> -						       log_offset);
> -			if (error)
> +		if (lv->lv_niovecs &&
> +		    lv->lv_bytes > iclog->ic_size - log_offset) {
> +			error = xlog_write_partial(lv, ticket, &iclog,
> +					&log_offset, &len, &record_cnt,
> +					&data_cnt, &contwr);
> +			if (error) {
> +				/*
> +				 * We have no iclog to release, so just return
> +				 * the error immediately.
> +				 */
>  				return error;
> -
> -			/*
> -			 * if we had a partial copy, we need to get more iclog
> -			 * space but we don't want to increment the region
> -			 * index because there is still more is this region to
> -			 * write.
> -			 *
> -			 * If we completed writing this region, and we flushed
> -			 * the iclog (indicated by resetting of the record
> -			 * count), then we also need to get more log space. If
> -			 * this was the last record, though, we are done and
> -			 * can just return.
> -			 */
> -			if (partial_copy)
> -				break;
> -
> -			if (++index == lv->lv_niovecs) {
> -next_lv:
> -				lv = lv->lv_next;
> -				index = 0;
> -				if (lv)
> -					vecp = lv->lv_iovecp;
> -			}
> -			if (record_cnt == 0 && !ordered) {
> -				if (!lv)
> -					return 0;
> -				break;
>  			}
> +		} else {
> +			xlog_write_full(lv, ticket, iclog, &log_offset,
> +					 &len, &record_cnt, &data_cnt);
>  		}
> +		lv = lv->lv_next;
>  	}
> -
>  	ASSERT(len == 0);
>  
> +	/*
> +	 * We've already been guaranteed that the last writes will fit inside
> +	 * the current iclog, and hence it will already have the space used by
> +	 * those writes accounted to it. Hence we do not need to update the
> +	 * iclog with the number of bytes written here.
> +	 */
>  	spin_lock(&log->l_icloglock);
> -	xlog_state_finish_copy(log, iclog, record_cnt, data_cnt);
> +	xlog_state_finish_copy(log, iclog, record_cnt, 0);
>  	error = xlog_state_release_iclog(log, iclog, 0);
>  	spin_unlock(&log->l_icloglock);
>  
> @@ -3754,11 +3721,12 @@ xlog_verify_iclog(
>  					iclog->ic_header.h_cycle_data[idx]);
>  			}
>  		}
> -		if (clientid != XFS_TRANSACTION && clientid != XFS_LOG)
> +		if (clientid != XFS_TRANSACTION && clientid != XFS_LOG) {
>  			xfs_warn(log->l_mp,
> -				"%s: invalid clientid %d op "PTR_FMT" offset 0x%lx",
> -				__func__, clientid, ophead,
> +				"%s: op %d invalid clientid %d op "PTR_FMT" offset 0x%lx",
> +				__func__, i, clientid, ophead,
>  				(unsigned long)field_offset);
> +		}
>  
>  		/* check length */
>  		p = &ophead->oh_len;
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 51254d7f38d6..6e9c7d924363 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -480,14 +480,6 @@ extern struct kmem_cache *xfs_log_ticket_cache;
>  struct xlog_ticket *xlog_ticket_alloc(struct xlog *log, int unit_bytes,
>  		int count, bool permanent);
>  
> -static inline void
> -xlog_write_adv_cnt(void **ptr, int *len, int *off, size_t bytes)
> -{
> -	*ptr += bytes;
> -	*len -= bytes;
> -	*off += bytes;
> -}
> -
>  void	xlog_print_tic_res(struct xfs_mount *mp, struct xlog_ticket *ticket);
>  void	xlog_print_trans(struct xfs_trans *);
>  int	xlog_write(struct xlog *log, struct xfs_cil_ctx *ctx,
> -- 
> 2.33.0
> 
