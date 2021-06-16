Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFAD53A9E44
	for <lists+linux-xfs@lfdr.de>; Wed, 16 Jun 2021 16:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234214AbhFPO5X (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 16 Jun 2021 10:57:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40585 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233787AbhFPO5W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Jun 2021 10:57:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623855316;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/r8f6IIgo1K8FXqszkpngbmOAoo2wJk/wTPZ53xLmyM=;
        b=bLbpzRAtbT5sZBil5sjzU62AR35rO7HoKu/Idpx0dGAw5RcZG9xIYrJVSV20un1jwhXaO/
        hCAvc/gBcAeWAeX5dxndtU7ThvK7fQiFTC5EPNTZrlrXwbDtpgJePl2y2c66QxFI5HhsHt
        BpflT38ZWak5tsUk6QAPpJWW/nUsJ6Y=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-588-tfTTpSKjMSCpL4tCCRvsnA-1; Wed, 16 Jun 2021 10:55:15 -0400
X-MC-Unique: tfTTpSKjMSCpL4tCCRvsnA-1
Received: by mail-ot1-f72.google.com with SMTP id n4-20020a9d6f040000b029041298cb18cdso1720879otq.21
        for <linux-xfs@vger.kernel.org>; Wed, 16 Jun 2021 07:55:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/r8f6IIgo1K8FXqszkpngbmOAoo2wJk/wTPZ53xLmyM=;
        b=GJVH8lVhLrVDQYhq4BVNn+muI6gCBaxQSvmdJiGiW4fqxXe25Vn21sGy5bizC/brBb
         LQwtAAliotlZDVyqXfUmUiEiIGt4hGesaZAOyGtByKh5obGafNY2dhzF0fV7ilq7OY9I
         5FKH+iOc3w9cE+/CelLV4xaw1lXXg75myJzIS5FUwd4K2Rbrrl38zoNn720brIv9E48c
         bh/Km9qZMx+sgciTXmWfoZhgxuVf45fbBOXe/kme537LM+bcrZi+2KETyPgsDKxsGk1O
         ERxY0kG9r+FITNDOYnYB787wWejpNjWf0qoSQ5+5frFR0IExnLRbgF3d1XvZKmcDB4mW
         IiBg==
X-Gm-Message-State: AOAM533hsJ6ZL1Sgbs+iAY8MZeN+/T6CStIpNI1xwGXad2p73pU6ZxYe
        kStzSToudwjvTohX7d+47B1zrIKjr2TK8/zlAEzecXH2nwNGXfM6VCu8ho9iBv/wRIwBPIORpdI
        6LNVi88BUjU6dZZWoJhnp
X-Received: by 2002:aca:1112:: with SMTP id 18mr26035oir.34.1623855313984;
        Wed, 16 Jun 2021 07:55:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxcKP0Q42j7t8E9UEhau7g9sezKbK533aELBNIJnEemIXA4Ktk5lIawVeEepUljes3srFXHvQ==
X-Received: by 2002:aca:1112:: with SMTP id 18mr26024oir.34.1623855313656;
        Wed, 16 Jun 2021 07:55:13 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id m6sm562763ots.74.2021.06.16.07.55.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 07:55:13 -0700 (PDT)
Date:   Wed, 16 Jun 2021 10:55:10 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: add iclog state trace events
Message-ID: <YMoQzohrNSwlSk2O@bfoster>
References: <20210615064658.854029-1-david@fromorbit.com>
 <20210615064658.854029-2-david@fromorbit.com>
 <YMjJTQfDQ3muz2YQ@bfoster>
 <20210615224709.GX664593@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210615224709.GX664593@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 16, 2021 at 08:47:09AM +1000, Dave Chinner wrote:
> On Tue, Jun 15, 2021 at 11:37:49AM -0400, Brian Foster wrote:
> > On Tue, Jun 15, 2021 at 04:46:57PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > For the DEBUGS!
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  fs/xfs/xfs_log.c   | 18 ++++++++++++++++
> > >  fs/xfs/xfs_trace.h | 52 ++++++++++++++++++++++++++++++++++++++++++++++
> > >  2 files changed, 70 insertions(+)
> > > 
> > > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > > index e921b554b683..54fd6a695bb5 100644
> > > --- a/fs/xfs/xfs_log.c
> > > +++ b/fs/xfs/xfs_log.c
> > > @@ -524,6 +524,7 @@ __xlog_state_release_iclog(
> > >  		iclog->ic_header.h_tail_lsn = cpu_to_be64(tail_lsn);
> > >  		xlog_verify_tail_lsn(log, iclog, tail_lsn);
> > >  		/* cycle incremented when incrementing curr_block */
> > > +		trace_xlog_iclog_syncing(iclog, _RET_IP_);
> > >  		return true;
> > >  	}
> > >  
> > > @@ -543,6 +544,7 @@ xlog_state_release_iclog(
> > >  {
> > >  	lockdep_assert_held(&log->l_icloglock);
> > >  
> > > +	trace_xlog_iclog_release(iclog, _RET_IP_);
> > >  	if (iclog->ic_state == XLOG_STATE_IOERROR)
> > >  		return -EIO;
> > >  
> > > @@ -804,6 +806,7 @@ xlog_wait_on_iclog(
> > >  {
> > >  	struct xlog		*log = iclog->ic_log;
> > >  
> > > +	trace_xlog_iclog_wait_on(iclog, _RET_IP_);
> > 
> > Seems like this might be more informative if we actually wait.
> 
> This tells us the state at the time the call is made, so we know
> from that if we waited or not. Being able to see all calls to this
> function was instrumental in understanding the stiuation where we
> were waiting and when we weren't waiting. This is the iclog we got
> stuck waiting on:
> 
>  xlog_iclog_wait_on:   dev 259:0 state 0x3 refcnt 0 offset 32256 lsn 0x2300004be0 caller xlog_cil_push_work
> 
> The state is XLOG_STATE_DONE_SYNC, indicating IO had been completed,
> and the lsn tells me it is a future iclog we are waiting on, which
> tells us that it's waiting for a previous iclog to complete IO
> before it can move forward...
> 

Then this tracepoint would have still triggered, wouldn't it? What's the
great significance in seeing a tracepoint for a function call in cases
where that call is otherwise essentially a no-op?

My point is that from a general standpoint (i.e. once this particular
issue is addressed), I find it obscured to see a bunch of blah_wait*
tracepoints in a full trace dump because that explicitly suggests that
something actually waited, when in reality, it's just a byproduct of an
unfortunately named (i.e. based on the function name) function call
based tracepoint.

Thinking more about it, this is the exact type of thing I almost always
end up modifying or replacing with my own trace_printk() when debugging
anything that already requires reproduction to root cause, because
otherwise I have to sift through more context just to filter out
function call noise from the actual meaningful calls.

There's also subtle details like how this doesn't reflect shutdown state
(so technically this doesn't actually provide all the information
required to determine whether a block actually occurred), or that your
_syncing() tracepoint is in a very similar situation, yet in that case
you opted to bind the tracepoint with the relevant logic vs. to the
function call/name. All I'm asking for is to do a similar thing here by
moving this one down a few lines. What's the problem?

> > >  	if (!XLOG_FORCED_SHUTDOWN(log) &&
> > >  	    iclog->ic_state != XLOG_STATE_ACTIVE &&
> > >  	    iclog->ic_state != XLOG_STATE_DIRTY) {
> > > @@ -1804,6 +1807,7 @@ xlog_write_iclog(
> > >  	unsigned int		count)
> > >  {
> > >  	ASSERT(bno < log->l_logBBsize);
> > > +	trace_xlog_iclog_write(iclog, _RET_IP_);
> > >  
> > >  	/*
> > >  	 * We lock the iclogbufs here so that we can serialise against I/O
> > > @@ -1950,6 +1954,7 @@ xlog_sync(
> > >  	unsigned int		size;
> > >  
> > >  	ASSERT(atomic_read(&iclog->ic_refcnt) == 0);
> > > +	trace_xlog_iclog_sync(iclog, _RET_IP_);
> > >  
> > >  	count = xlog_calc_iclog_size(log, iclog, &roundoff);
> > >  
> > > @@ -2488,6 +2493,7 @@ xlog_state_activate_iclog(
> > >  	int			*iclogs_changed)
> > >  {
> > >  	ASSERT(list_empty_careful(&iclog->ic_callbacks));
> > > +	trace_xlog_iclog_activate(iclog, _RET_IP_);
> > >  
> > 
> > I wonder a bit whether these state change oriented tracepoints could be
> > served by a single trace_ixlog_iclog_state() or some such, since the
> > tracepoint already prints the state. That wouldn't show the before ->
> > state in each tracepoint, but that should reflect in the full log.
> 
> I disagree. We lose a -lot- of context by getting rid of the
> per-call site trace names, especially those that get called from
> multiple places. Not to mention tracing an ACTIVE, idle iclog can
> result in zero state information except for the tracepoint name...
> e.g:
> 
> 384.204393: xlog_iclog_write:     dev 259:0 state 0x2 refcnt 0 offset 32256 lsn 0x2300004b60 caller xlog_sync
> 384.204406: xlog_iclog_sync_done: dev 259:0 state 0x2 refcnt 0 offset 32256 lsn 0x2300004b60 caller xlog_ioend_work
> 384.204407: xlog_iclog_get_space: dev 259:0 state 0x0 refcnt 1 offset 0 lsn 0x0 caller xlog_write_get_more_iclog_space
> 384.204408: xlog_iclog_switch:    dev 259:0 state 0x0 refcnt 1 offset 0 lsn 0x2300004ba0 caller xlog_state_get_iclog_space
> 384.204418: xlog_iclog_release:   dev 259:0 state 0x1 refcnt 1 offset 32256 lsn 0x2300004ba0 caller xlog_write_get_more_iclog_space
> 384.204419: xlog_iclog_syncing:   dev 259:0 state 0x2 refcnt 0 offset 32256 lsn 0x2300004ba0 caller xlog_write_get_more_iclog_space
> 384.204419: xlog_iclog_sync:      dev 259:0 state 0x2 refcnt 0 offset 32256 lsn 0x2300004ba0 caller xlog_state_release_iclog
> 384.204422: xlog_iclog_write:     dev 259:0 state 0x2 refcnt 0 offset 32256 lsn 0x2300004ba0 caller xlog_sync
> 384.204435: xlog_iclog_sync_done: dev 259:0 state 0x2 refcnt 0 offset 32256 lsn 0x2300004ba0 caller xlog_ioend_work
> 
> See how the xlog_iclog_get_space trace has zero state/lsn? That
> indicates that it has actually found an idle, active iclog in the
> correct state for it to hand out. We can also see this progression
> is through xlog_write() filling mulitple iclogs. However, we can get
> different progressions from different contexts such as:
> 
> 384.193766: xlog_iclog_get_space: dev 259:0 state 0x0 refcnt 1 offset 0 lsn 0x0 caller xlog_write_get_more_iclog_space
> 384.193778: xlog_iclog_release:   dev 259:0 state 0x0 refcnt 1 offset 27352 lsn 0x23000042b0 caller xlog_write
> 384.193779: xlog_iclog_get_space: dev 259:0 state 0x0 refcnt 1 offset 27352 lsn 0x23000042b0 caller xlog_write
> 384.193780: xlog_iclog_wait_on:   dev 259:0 state 0x0 refcnt 0 offset 0 lsn 0x0 caller xlog_cil_push_work
> 384.193781: xlog_iclog_release:   dev 259:0 state 0x0 refcnt 1 offset 27364 lsn 0x23000042b0 caller xlog_cil_push_work
> 384.201268: xlog_iclog_get_space: dev 259:0 state 0x0 refcnt 1 offset 27364 lsn 0x23000042b0 caller xlog_write
> 
> .... the competion of a checkpoint where xlog_write() releases the
> iclog and it's not a full iclog. This is followed immediately by the
> commit record write which gets iclog space from a different caller
> location, passes it back to xlog_cil_push_work which then releases
> it. ANd then we try to wait on the previous iclog which is an idle
> ACTIVE buffer, so we skip the wait.  And because this isn't a
> "stable CIL push", we don't see a xlog_iclog_switch() trace, and the
> so iclog is not flushed to disk when it is release here.
> 

Side note: I like how you incorporated the lack of an _iclog_switch()
tracepoint in your analysis. It's almost like we'd be capable of similar
reasoning wrt that _wait_on() tracepoint. ;)

That aside, fair enough on the names. The reason I suggest it is I think
it would be nicer to be able to do something like 'trace-cmd start -e
xfs:xlog_iclog_state*' to see all the state transitions and nothing
else, but that's not a huge deal and secondary to providing useful
information. I do wonder a bit if we could accomplish something similar
with a new state setting inline and a custom, single tracepoint to
include the calling function name, but that's not something worth
digging into now.

> IOWs, if we don't have the individual trace names, we largely lose
> all this context and then have to infer it from caller and state
> changes that occur. That just makes things unnnecessarily difficult
> when looking for problems in hundreds of thousands trace events....
> 
> > > @@ -3138,6 +3153,8 @@ xfs_log_force(
> > >  	if (iclog->ic_state == XLOG_STATE_IOERROR)
> > >  		goto out_error;
> > >  
> > > +	trace_xlog_iclog_force(iclog, _RET_IP_);
> > > +
> > 
> > We have a log force tracepoint a few lines up. Do we need both?
> 
> Yes. The log force tracepoint tells us nothing about the iclog
> state we are about to operate on.
> 

Ok.

Brian

> > > +	TP_ARGS(iclog, caller_ip),
> > > +	TP_STRUCT__entry(
> > > +		__field(dev_t, dev)
> > > +		__field(uint32_t, state)
> > > +		__field(int32_t, refcount)
> > > +		__field(uint32_t, offset)
> > > +		__field(unsigned long long, lsn)
> > > +		__field(unsigned long, caller_ip)
> > > +	),
> > > +	TP_fast_assign(
> > > +		__entry->dev = iclog->ic_log->l_mp->m_super->s_dev;
> > > +		__entry->state = iclog->ic_state;
> > > +		__entry->refcount = atomic_read(&iclog->ic_refcnt);
> > > +		__entry->offset = iclog->ic_offset;
> > > +		__entry->lsn = be64_to_cpu(iclog->ic_header.h_lsn);
> > > +		__entry->caller_ip = caller_ip;
> > > +	),
> > > +	TP_printk("dev %d:%d state 0x%x refcnt %d offset %u lsn 0x%llx caller %pS",
> > > +		  MAJOR(__entry->dev), MINOR(__entry->dev),
> > > +		  __entry->state,
> > 
> > It might be nice to see a string representation of the state like we do
> > for other things like log item type, etc.
> 
> Yup, I thought about that after I sent when looking at other code.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

