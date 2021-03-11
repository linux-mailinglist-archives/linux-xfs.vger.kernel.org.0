Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4EA4336BDA
	for <lists+linux-xfs@lfdr.de>; Thu, 11 Mar 2021 07:03:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbhCKGDT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 11 Mar 2021 01:03:19 -0500
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:45228 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229830AbhCKGDM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Mar 2021 01:03:12 -0500
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id 27A421AE104;
        Thu, 11 Mar 2021 17:03:11 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lKEPd-001Azm-ID; Thu, 11 Mar 2021 17:03:09 +1100
Date:   Thu, 11 Mar 2021 17:03:09 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 34/45] xfs: rework per-iclog header CIL reservation
Message-ID: <20210311060309.GR74031@dread.disaster.area>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-35-david@fromorbit.com>
 <20210311000338.GH3419940@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210311000338.GH3419940@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=ob1M9-DD6aG0HPZge8IA:9 a=j1l9Gt75X3hXmw7-:21 a=DdIdKtfir0DjxXO-:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 10, 2021 at 04:03:38PM -0800, Darrick J. Wong wrote:
> On Fri, Mar 05, 2021 at 04:11:32PM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > For every iclog that a CIL push will use up, we need to ensure we
> > have space reserved for the iclog header in each iclog. It is
> > extremely difficult to do this accurately with a per-cpu counter
> > without expensive summing of the counter in every commit. However,
> > we know what the maximum CIL size is going to be because of the
> > hard space limit we have, and hence we know exactly how many iclogs
> > we are going to need to write out the CIL.
> > 
> > We are constrained by the requirement that small transactions only
> > have reservation space for a single iclog header built into them.
> > At commit time we don't know how much of the current transaction
> > reservation is made up of iclog header reservations as calculated by
> > xfs_log_calc_unit_res() when the ticket was reserved. As larger
> > reservations have multiple header spaces reserved, we can steal
> > more than one iclog header reservation at a time, but we only steal
> > the exact number needed for the given log vector size delta.
> > 
> > As a result, we don't know exactly when we are going to steal iclog
> > header reservations, nor do we know exactly how many we are going to
> > need for a given CIL.
> > 
> > To make things simple, start by calculating the worst case number of
> > iclog headers a full CIL push will require. Record this into an
> > atomic variable in the CIL. Then add a byte counter to the log
> > ticket that records exactly how much iclog header space has been
> > reserved in this ticket by xfs_log_calc_unit_res(). This tells us
> > exactly how much space we can steal from the ticket at transaction
> > commit time.
> > 
> > Now, at transaction commit time, we can check if the CIL has a full
> > iclog header reservation and, if not, steal the entire reservation
> > the current ticket holds for iclog headers. This minimises the
> > number of times we need to do atomic operations in the fast path,
> > but still guarantees we get all the reservations we need.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/libxfs/xfs_log_rlimit.c |  2 +-
> >  fs/xfs/libxfs/xfs_shared.h     |  3 +-
> >  fs/xfs/xfs_log.c               | 12 +++++---
> >  fs/xfs/xfs_log_cil.c           | 55 ++++++++++++++++++++++++++--------
> >  fs/xfs/xfs_log_priv.h          | 20 +++++++------
> >  5 files changed, 64 insertions(+), 28 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_log_rlimit.c b/fs/xfs/libxfs/xfs_log_rlimit.c
> > index 7f55eb3f3653..75390134346d 100644
> > --- a/fs/xfs/libxfs/xfs_log_rlimit.c
> > +++ b/fs/xfs/libxfs/xfs_log_rlimit.c
> > @@ -88,7 +88,7 @@ xfs_log_calc_minimum_size(
> >  
> >  	xfs_log_get_max_trans_res(mp, &tres);
> >  
> > -	max_logres = xfs_log_calc_unit_res(mp, tres.tr_logres);
> > +	max_logres = xfs_log_calc_unit_res(mp, tres.tr_logres, NULL);
> 
> This is currently the only call site of xfs_log_calc_unit_res, so if a
> subsequent patch doesn't make use of that last argument it should go
> away.  (I don't know yet, I haven't looked...)

Can't remember, I'll have to check.

> > @@ -3418,7 +3422,7 @@ xlog_ticket_alloc(
> >  
> >  	tic = kmem_cache_zalloc(xfs_log_ticket_zone, GFP_NOFS | __GFP_NOFAIL);
> >  
> > -	unit_res = xlog_calc_unit_res(log, unit_bytes);
> > +	unit_res = xlog_calc_unit_res(log, unit_bytes, &tic->t_iclog_hdrs);
> 
> Ok, so each transaction ticket now gets to know the maximum number of
> iclog headers that the transaction can consume if we use every last byte
> of the reservation...

yes.

> > diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> > index 50101336a7f4..f8fb2f59e24c 100644
> > --- a/fs/xfs/xfs_log_cil.c
> > +++ b/fs/xfs/xfs_log_cil.c
> > @@ -44,9 +44,20 @@ xlog_cil_ticket_alloc(
> >  	 * transaction overhead reservation from the first transaction commit.
> >  	 */
> >  	tic->t_curr_res = 0;
> > +	tic->t_iclog_hdrs = 0;
> >  	return tic;
> >  }
> >  
> > +static inline void
> > +xlog_cil_set_iclog_hdr_count(struct xfs_cil *cil)
> > +{
> > +	struct xlog	*log = cil->xc_log;
> > +
> > +	atomic_set(&cil->xc_iclog_hdrs,
> > +		   (XLOG_CIL_BLOCKING_SPACE_LIMIT(log) /
> > +			(log->l_iclog_size - log->l_iclog_hsize)));
> > +}
> > +
> >  /*
> >   * Unavoidable forward declaration - xlog_cil_push_work() calls
> >   * xlog_cil_ctx_alloc() itself.
> > @@ -70,6 +81,7 @@ xlog_cil_ctx_switch(
> >  	struct xfs_cil		*cil,
> >  	struct xfs_cil_ctx	*ctx)
> >  {
> > +	xlog_cil_set_iclog_hdr_count(cil);
> 
> ...and I guess every time the CIL gets a fresh context, we also record
> the maximum number of iclog headers that we might be pushing to disk in
> one go?

Yes. that defines the maximum size of the iclog header reservation
the CIL checkpoint is going to need if it stays within the hard
limit.

> Which I guess happens if someone commits a lot of updates to a
> filesystem, a comitting thread hits the throttle threshold, and now the
> CIL has to switch contexts and write the old context's transactions to
> disk?

Right - it reserves enough space for delays in context switches to
use all the overrun without having to do anything ... slow.

> > @@ -442,19 +454,36 @@ xlog_cil_insert_items(
> >  	    test_and_clear_bit(XLOG_CIL_EMPTY, &cil->xc_flags))
> >  		ctx_res = ctx->ticket->t_unit_res;
> >  
> > -	spin_lock(&cil->xc_cil_lock);
> > -
> > -	/* do we need space for more log record headers? */
> > -	iclog_space = log->l_iclog_size - log->l_iclog_hsize;
> > -	if (len > 0 && (ctx->space_used / iclog_space !=
> > -				(ctx->space_used + len) / iclog_space)) {
> > -		split_res = (len + iclog_space - 1) / iclog_space;
> > -		/* need to take into account split region headers, too */
> > -		split_res *= log->l_iclog_hsize + sizeof(struct xlog_op_header);
> > -		ctx->ticket->t_unit_res += split_res;
> > +	/*
> > +	 * Check if we need to steal iclog headers. atomic_read() is not a
> > +	 * locked atomic operation, so we can check the value before we do any
> > +	 * real atomic ops in the fast path. If we've already taken the CIL unit
> > +	 * reservation from this commit, we've already got one iclog header
> > +	 * space reserved so we have to account for that otherwise we risk
> > +	 * overrunning the reservation on this ticket.
> > +	 *
> > +	 * If the CIL is already at the hard limit, we might need more header
> > +	 * space that originally reserved. So steal more header space from every
> > +	 * commit that occurs once we are over the hard limit to ensure the CIL
> > +	 * push won't run out of reservation space.
> > +	 *
> > +	 * This can steal more than we need, but that's OK.
> > +	 */
> > +	if (atomic_read(&cil->xc_iclog_hdrs) > 0 ||
> 
> If we haven't stolen enough iclog header space...
> 
> > +	    ctx->space_used + len >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log)) {
> 
> ...or we've hit a throttling threshold, in which case we know we're
> going to push, so we might as well take everything and (I guess?) not
> give back any reservation that would encourage more commits before we're
> ready?

Partially. This is also safety against the CIL bumping back
down below and above the space limit multiple times. It just ensures
that every transaction that commits over the hard limit is
guaranteed to have enough iclog headers reserved to write the CIL
when it goes over the hard limit.

> > +		int	split_res = log->l_iclog_hsize +
> > +					sizeof(struct xlog_op_header);
> > +		if (ctx_res)
> > +			ctx_res += split_res * (tp->t_ticket->t_iclog_hdrs - 1);
> > +		else
> > +			ctx_res = split_res * tp->t_ticket->t_iclog_hdrs;
> > +		atomic_sub(tp->t_ticket->t_iclog_hdrs, &cil->xc_iclog_hdrs);
> 
> What happens if xc_iclog_hdrs goes negative?  Does that merely mean that
> we stole more space from the transaction than we needed?  Or does it
> indicate that we're trying to cram too much into a single context?

Nothing. Yes. Indicates that we have commits throttling on the hard
limit.

> I suppose I worry about what might happen if each transaction's
> committed items actually somehow eats up every byte of reservation and
> that actually translates to t_iclog_hdrs iclogs being written out with a
> particular context, where sum(t_iclog_hdrs) is larger than what
> xlog_cil_set_iclog_hdr_count() precomputes?

If I understand what you are asking correctly, that should never
happen because the iclog header count should always span the maximum
number of iclogs that change requires to write into the log. And the
CIL context also reserves enough headers to write the entire set of
CIL data to the iclogs, so again we should not ever get into an
overrun situation because we have maximally dirty transactions being
committed. If these sorts of overruns ever occur, we've got a unit
reservation calculation issue, not a CIL iclog header space
reservation stealling issue...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
