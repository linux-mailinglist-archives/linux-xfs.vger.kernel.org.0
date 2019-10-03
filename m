Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85E90C9605
	for <lists+linux-xfs@lfdr.de>; Thu,  3 Oct 2019 02:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbfJCAxR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 2 Oct 2019 20:53:17 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:33922 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726002AbfJCAxR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Oct 2019 20:53:17 -0400
Received: from dread.disaster.area (pa49-181-226-196.pa.nsw.optusnet.com.au [49.181.226.196])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 51E9643EC66;
        Thu,  3 Oct 2019 10:53:12 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.2)
        (envelope-from <david@fromorbit.com>)
        id 1iFpMk-0000X3-Sd; Thu, 03 Oct 2019 10:53:10 +1000
Date:   Thu, 3 Oct 2019 10:53:10 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: Throttle commits on delayed background CIL push
Message-ID: <20191003005310.GV16973@dread.disaster.area>
References: <20190930060344.14561-1-david@fromorbit.com>
 <20190930060344.14561-3-david@fromorbit.com>
 <20190930170358.GD57295@bfoster>
 <20190930215336.GR16973@dread.disaster.area>
 <20191001131304.GA62428@bfoster>
 <20191001223107.GT16973@dread.disaster.area>
 <20191002124056.GA2403@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191002124056.GA2403@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=dRuLqZ1tmBNts2YiI0zFQg==:117 a=dRuLqZ1tmBNts2YiI0zFQg==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=XobE76Q3jBoA:10
        a=7-415B0cAAAA:8 a=eQDlhc7iGAFAyPrJEpcA:9 a=ezPR87Dl6ztoz3QW:21
        a=Kx1f2_VkTWtwFTPy:21 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 02, 2019 at 08:40:56AM -0400, Brian Foster wrote:
> On Wed, Oct 02, 2019 at 08:31:07AM +1000, Dave Chinner wrote:
> > On Tue, Oct 01, 2019 at 09:13:04AM -0400, Brian Foster wrote:
> > > On Tue, Oct 01, 2019 at 07:53:36AM +1000, Dave Chinner wrote:
> > > > On Mon, Sep 30, 2019 at 01:03:58PM -0400, Brian Foster wrote:
> > > > > Have you done similar testing for small/minimum sized logs?
> > > > 
> > > > Yes. I've had the tracepoint active during xfstests runs on test
> > > > filesystems using default log sizes on 5-15GB filesystems. The only
> > > > test in all of xfstests that has triggered it is generic/017, and it
> > > > only triggered once.
> > > > 
> > > 
> > > Ok, interesting. I guess it would be nice if we had a test that somehow
> > > or another more effectively exercised this codepath.
> > 
> > *nod*
> > 
> > But it's essentially difficult to predict in any way because
> > behaviour is not just a function of log size. :/
> > 
> > > > > Also, if this is so limited in occurrence, had you given any thought to
> > > > > something even more simple like flushing the CIL push workqueue when
> > > > > over the throttle threshold?
> > > > 
> > > > Yes, I've tried that - flush_workqueue() blocks /everything/ until
> > > > all the queued work is complete. That means it waits for the CIL to
> > > > flush to disk and write a commit record, and every modification in
> > > > the filesystem is stopped dead in it's tracks until the CIL push is
> > > > complete.
> > > > 
> > > > The problem is that flushing workqueues is a synchronous operation,
> > > > and it can't wait for partial work completion. We only need to wait
> > > > for the CIL context to be swapped out - this is done by the push
> > > > code before it starts all the expensive iclog formating and waiting
> > > > for iclog space...
> > > > 
> > > 
> > > I know it waits on the work to complete. I poked around a bit for an
> > > interface to "kick" a workqueue, so to speak (as opposed to flush), but
> > > I didn't see anything (not surprisingly, since it probably wouldn't be a
> > > broadly useful mechanism).
> > 
> > *nod*
> > 
> > > That aside, where would this wait on the CIL to flush to disk? AFAICT
> > > the only thing that might happen here is log buffer submission. That
> > > only happens when the log buffer is full (regardless of the current CIL
> > > push writing its commit record). In fact if we did wait on I/O anywhere
> > > in here, then that suggests potential problems with async log force.
> > 
> > There is no such thing as a "async log force". The log force always
> > waits on the CIL flush - XFS_LOG_SYNC only defines whether it waits
> > on all iclogbufs post CIL flush to hit the disk.
> > 
> 
> I'm just referring to the semantics/naming of the existing interface. I
> suppose I could have used "a log force that doesn't wait on all
> iclogbufs to hit the disk," but that doesn't quite roll off the tongue.
> ;)

*nod*

Just wanted to make sure we were both talking about the same thing
:)

> 
> > Further, when the CIL flushes, it's normally flushing more metadata that we
> > can hold in 8x iclogbufs. The default is 32kB iclogbufs, so if we've
> > got more than 256kB of checkpoint data to be written, then we end up
> > waiting on iclogbuf completion to write more then 256kB.
> > 
> > Typically I see a sustainted ratio of roughly 4 iclog writes to 1
> > noiclogbufs in the metric graphs on small logs - just measured 700
> > log writes/s, 250 noiclogs/s for a 64MB log and 256kB logbuf size.
> > IOWs, CIL flushes are regularly waiting in xlog_get_iclog_space() on
> > iclog IO completion to occur...
> > 
> 
> Ok, that's not quite what I was concerned about when you mentioned
> waiting on the CIL to flush to disk. No matter, the important bit here
> is the performance cost of including the extra blocking on log I/O (to
> cycle iclogs back to active for reuse) in the throttle.
> 
> I'm curious about how noticeable this extra blocking would be because
> it's one likely cause of the CIL pressure buildup in the first place. My
> original tests reproduced huge CIL checkpoints purely based on one CIL
> push being blocked behind the processing of another, the latter taking
> relatively more time due to log I/O.

It's very noticable. I dropped that as a throttle mechanism because
even on a SSD at 200us per write, a 32MB CIL flush takes for
20-30ms. And it stops everything dead for that time because it
stalls all async transaction commits while the log flushes.

When several CIL flushes a second occur (pushing 100-150MB/s to the
log), I start seeing a substantial amount of additional time
(15-20% of total CPU time) being spent idle just waiting for CIL
flush completion. And it only gets worse as the storage gets
slower...

The throttle that these patches implement are typically only
stalling incoming transactions for a couple of hundred microseconds.
The timestamps from the groups of log events show the blocking of
all threads are very close together in time, and the push work to
switch over to the new context to allow them to unblock and continue
happens within another 200-300 microseconds. And the worst case I've
seen, this is happening once or twice a second. IOWs, the blocking
time of the throttle is very short and largely unnoticable, and the
difference to performance it causes is far, far less than the noise
threshold of the benchmarks.

> This is not to say there aren't other causes of excessively sized
> checkpoints. Rather, if we're at a point where we've blocked
> transactions on this new threshold, that means we've doubled the
> background threshold in the time we've first triggered a background CIL
> push and the push actually started. From that, it seems fairly likely
> that we could replenish the CIL to the background threshold once
> threads are unblocked but before the previous push completes.

That's just fine. The CIL is actually designed to allow that sort of
overlap between multiple committing background contexts and the
current aggregating context. As long as each individual CIL commit
size doesn't go over half the log and there's always a complete
commit in the log (which there should be via head/tail limits),
the only limit on the number of concurrent committing CIL contexts
on the fly at once is the amount of log space we have available....

> The question is: can we get all the way to the blocking threshold before
> that happens? That doesn't seem unrealistic to me, but it's hard to
> reason about without having tested it. If so, I think it means we end up
> blocking on completion of the first push to some degree anyways.

Yes, we can fill and push the current sequence before the previous
sequence has finished committing.

> > > > xlog_cil_push_now() uses flush_work() to push any pending work
> > > > before it queues up the CIL flush that the caller is about to wait
> > > > for.  i.e. the callers of xlog_cil_push_now() must ensure that all
> > > > CIL contexts are flushed for the purposes of a log force as they are
> > > > going to wait for all pending CIL flushes to complete. If we've
> > > > already pushed the CIL to the sequence that we are asking to push
> > > > to, we still have to wait for that previous push to be
> > > > done. This is what the flush_work() call in xlog_cil_push_now()
> > > > acheives.
> > > > 
> > > 
> > > Yes, I'm just exploring potential to reuse this code..
> > 
> > Yeah, I have a few prototype patches for revamping this, including
> > an actual async CIL flush. I do some work here, but it didn't solve
> > any of the problems I needed to fix so it put it aside. See below.
> > 
> 
> That sounds more involved than what I was thinking. My thought is that
> this throttle is already not predictable or deterministic (i.e. we're
> essentially waiting on a scheduler event) and so might not require the
> extra complexity of a new waitqueue. It certainly could be the case that
> blocking on the entire push is just too long in practice, but since this

I've made that sort of change here and measured the regression.
Then I discarded it as an unworkable option and looked for other
solutions.

> is already based on empirical evidence and subject to unpredictability,
> ISTM that testing is the only way to know for sure. For reference, I
> hacked up something to reuse xlog_cil_push_now() for background pushing
> and throttling that ends up removing 20 or so lines of code by the time
> it's in place, but I haven't given it any testing.
>
> That said, this is just an observation and an idea. I'm fine with the
> proposed implementation with the other nits and whatnot fixed up.

No worries. It's still worth exploring all the alternatives. :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
