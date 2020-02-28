Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E09C172CCD
	for <lists+linux-xfs@lfdr.de>; Fri, 28 Feb 2020 01:10:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730009AbgB1AKF (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 27 Feb 2020 19:10:05 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:46159 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729984AbgB1AKF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Feb 2020 19:10:05 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id CD1FD7EA88D;
        Fri, 28 Feb 2020 11:10:01 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j7TE8-0005AH-6t; Fri, 28 Feb 2020 11:10:00 +1100
Date:   Fri, 28 Feb 2020 11:10:00 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [RFC v5 PATCH 1/9] xfs: set t_task at wait time instead of alloc
 time
Message-ID: <20200228001000.GC10776@dread.disaster.area>
References: <20200227134321.7238-1-bfoster@redhat.com>
 <20200227134321.7238-2-bfoster@redhat.com>
 <20200227232853.GP8045@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200227232853.GP8045@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=l697ptgUJYAA:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=s_m6zCt6FSDr8vMcL6AA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 27, 2020 at 03:28:53PM -0800, Darrick J. Wong wrote:
> On Thu, Feb 27, 2020 at 08:43:13AM -0500, Brian Foster wrote:
> > The xlog_ticket structure contains a task reference to support
> > blocking for available log reservation. This reference is assigned
> > at ticket allocation time, which assumes that the transaction
> > allocator will acquire reservation in the same context. This is
> > normally true, but will not always be the case with automatic
> > relogging.
> > 
> > There is otherwise no fundamental reason log space cannot be
> > reserved for a ticket from a context different from the allocating
> > context. Move the task assignment to the log reservation blocking
> > code where it is used.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > ---
> >  fs/xfs/xfs_log.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index f6006d94a581..df60942a9804 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -262,6 +262,7 @@ xlog_grant_head_wait(
> >  	int			need_bytes) __releases(&head->lock)
> >  					    __acquires(&head->lock)
> >  {
> > +	tic->t_task = current;
> >  	list_add_tail(&tic->t_queue, &head->waiters);
> >  
> >  	do {
> > @@ -3601,7 +3602,6 @@ xlog_ticket_alloc(
> >  	unit_res = xfs_log_calc_unit_res(log->l_mp, unit_bytes);
> >  
> >  	atomic_set(&tic->t_ref, 1);
> > -	tic->t_task		= current;
> 
> Hm.  So this leaves t_task set to NULL in the ticket constructor in
> favor of setting it in xlog_grant_head_wait.  I guess this implies that
> some future piece will be able to transfer a ticket to another process
> as part of a regrant or something?
> 
> I've been wondering lately if you could transfer a dirty permanent
> transaction to a different task so that the front end could return to
> userspace as soon as the first transaction (with the intent items)
> commits, and then you could reduce the latency of front-end system
> calls.  That's probably a huge fantasy since you'd also have to transfer
> a whole ton of state to that worker and whatever you locked to do the
> operation remains locked...

Yup, that's basically the idea I've raised in the past for "async
XFS" where the front end is completely detached from the back end
that does the internal work. i.e deferred ops are the basis for
turning XFS into a huge async processing machine.

This isn't a new idea - tux3 was based around this "async back end"
concept, too.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
