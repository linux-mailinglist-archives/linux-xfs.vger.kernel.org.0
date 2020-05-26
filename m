Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A39001D414E
	for <lists+linux-xfs@lfdr.de>; Fri, 15 May 2020 00:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728861AbgENWqn (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 14 May 2020 18:46:43 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:60540 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728229AbgENWqm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 May 2020 18:46:42 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 92BFA7EAAB8;
        Fri, 15 May 2020 08:46:39 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jZMcg-0000hT-Am; Fri, 15 May 2020 08:46:38 +1000
Date:   Fri, 15 May 2020 08:46:38 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/5] [RFC] xfs: per-cpu CIL lists
Message-ID: <20200514224638.GM2040@dread.disaster.area>
References: <20200512092811.1846252-1-david@fromorbit.com>
 <20200512092811.1846252-5-david@fromorbit.com>
 <20200513170237.GB45326@bfoster>
 <20200513233358.GH2040@dread.disaster.area>
 <20200514134446.GC50441@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514134446.GC50441@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=pQvZ14r-Mhnp-0U9hdMA:9 a=TSgRATn2hkBgsKh5:21 a=e13LH2IYHvbndQVm:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 14, 2020 at 09:44:46AM -0400, Brian Foster wrote:
> On Thu, May 14, 2020 at 09:33:58AM +1000, Dave Chinner wrote:
> > On Wed, May 13, 2020 at 01:02:37PM -0400, Brian Foster wrote:
> > > On Tue, May 12, 2020 at 07:28:10PM +1000, Dave Chinner wrote:
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > > 
> > > > Next on the list to getting rid of the xc_cil_lock is making the CIL
> > > > itself per-cpu.
> > > > 
> > > > This requires a trade-off: we no longer move items forward in the
> > > > CIL; once they are on the CIL they remain there as we treat the
> > > > percpu lists as lockless.
> > > > 
> > > > XXX: preempt_disable() around the list operations to ensure they
> > > > stay local to the CPU.
> > > > 
> > > > XXX: this needs CPU hotplug notifiers to clean up when cpus go
> > > > offline.
> > > > 
> > > > Performance now increases substantially - the transaction rate goes
> > > > from 750,000/s to 1.05M/sec, and the unlink rate is over 500,000/s
> > > > for the first time.
> > > > 
> > > > Using a 32-way concurrent create/unlink on a 32p/16GB virtual
> > > > machine:
> > > > 
> > > > 	    create time     rate            unlink time
> > > > unpatched	1m56s      533k/s+/-28k/s      2m34s
> > > > patched		1m49s	   523k/s+/-14k/s      2m00s
> > > > 
> > > > Notably, the system time for the create went up, while variance went
> > > > down. This indicates we're starting to hit some other contention
> > > > limit as we reduce the amount of time we spend contending on the
> > > > xc_cil_lock.
> > > > 
> > > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > > ---
> > > >  fs/xfs/xfs_log_cil.c  | 66 ++++++++++++++++++++++++++++---------------
> > > >  fs/xfs/xfs_log_priv.h |  2 +-
> > > >  2 files changed, 45 insertions(+), 23 deletions(-)
> > > > 
> > > > diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> > > > index 746c841757ed1..af444bc69a7cd 100644
> > > > --- a/fs/xfs/xfs_log_cil.c
> > > > +++ b/fs/xfs/xfs_log_cil.c
> > > ...
> > > > @@ -687,7 +689,7 @@ xlog_cil_push_work(
> > > >  	 * move on to a new sequence number and so we have to be able to push
> > > >  	 * this sequence again later.
> > > >  	 */
> > > > -	if (list_empty(&cil->xc_cil)) {
> > > > +	if (percpu_counter_read(&cil->xc_curr_res) == 0) {
> > > 
> > > It seems reasonable, but I need to think a bit more about the whole
> > > percpu list thing. In the meantime, one thing that comes to mind is the
> > > more of these list_empty() -> percpu_counter_read() translations I see
> > > the less I like it because we're leaking this inherent raciness to
> > > different contexts. Whether it's ultimately safe or not, it's subject to
> > > change and far too subtle and indirect for my taste. 
> > 
> > Well, all the critical list_empty(&cil->xc_cil) checks are done
> > under the xc_push_lock, so I'd suggest that if we zero the counters
> > under the push lock when switching contexts, and put the initial
> > zero->non-zero counter transition to under the same lock we'll get
> > exact checks without requiring a spinlock/atomic in the fast
> > path and have all the right memory barriers in place such that races
> > can't happen...
> > 
> 
> That might work. We'd just have to audit the external checks and provide
> clear comments on the purpose of the lock in those cases.

It does work. And there's only one external check and that's an
ASSERT that falls into the case of "we just added to the CIL, so the
counter must be non-zero because we haven't dropped the xc_ctx_lock
yet" so we don't need to hold the push lock here.

> > > Could we replace all of the direct ->xc_cil list checks with an atomic
> > > bitop (i.e. XLOG_CIL_EMPTY) or something similar in the xfs_cil? AFAICT,
> > > that could be done in a separate patch and we could ultimately reuse it
> > > to close the race with the initial ctx reservation (via
> > > test_and_set_bit()) because it's otherwise set in the same function. Hm?
> > 
> > test_and_set_bit() still locks the memory bus and so requires
> > exclusive access to the cacheline. Avoiding locked bus ops
> > (atomics, spinlocks, etc) in the fast path is the problem
> > I'm trying to solve with this patchset. IOWs, this isn't a viable
> > solution to a scalability problem caused by many CPUs all trying to
> > access the same cacheline exclusively.
> > 
> 
> Of course I'd expect some hit from the added serialization, but it's not
> clear to me it would be as noticeable as an explicit lock in practice.

It's an atomic. They have less overhead than a spin lock, but that
means it just requires a few more CPUs banging on it before it goes
into exponential breakdown like a spinlock does. And contention on
atomics is a lot harder to see in profiles.

> For example, if we had an XLOG_CIL_EMPTY bit that was set at push time
> and had a test_and_clear_bit() in the commit/insert path, would we take
> that hit every time through the commit path or only until the cpu clears
> it or sees that it's been cleared?

Every time it goes through the commit path. The x86 implementation:

static __always_inline bool
arch_test_and_set_bit(long nr, volatile unsigned long *addr)
{
        return GEN_BINARY_RMWcc(LOCK_PREFIX __ASM_SIZE(bts), *addr, c, "Ir", nr);
}

It is a single instruction that always locks the bus to perform the
operation atomically.

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
