Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 768DA181B1
	for <lists+linux-xfs@lfdr.de>; Wed,  8 May 2019 23:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbfEHVkh (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 8 May 2019 17:40:37 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:46875 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726875AbfEHVkh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 May 2019 17:40:37 -0400
Received: from dread.disaster.area (pa49-181-171-240.pa.nsw.optusnet.com.au [49.181.171.240])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id DA5DA439ACF;
        Thu,  9 May 2019 07:40:33 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hOUIj-0005D5-1v; Thu, 09 May 2019 07:40:33 +1000
Date:   Thu, 9 May 2019 07:40:33 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chris Mason <clm@fb.com>
Cc:     Rik van Riel <riel@surriel.com>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        David Chinner <dchinner@redhat.com>
Subject: Re: [PATCH] fs,xfs: fix missed wakeup on l_flush_wait
Message-ID: <20190508214033.GQ29573@dread.disaster.area>
References: <20190507130528.1d3d471b@imladris.surriel.com>
 <20190507212213.GO29573@dread.disaster.area>
 <605BF0CA-EB32-46A5-8045-2BAB7EB0BD66@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <605BF0CA-EB32-46A5-8045-2BAB7EB0BD66@fb.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0 cx=a_idp_d
        a=LhzQONXuMOhFZtk4TmSJIw==:117 a=LhzQONXuMOhFZtk4TmSJIw==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=E5NmQfObTbMA:10
        a=20KFwNOVAAAA:8 a=FOH2dFAWAAAA:8 a=7-415B0cAAAA:8 a=MvpEtWUUUWvuhsli_6IA:9
        a=CjuIK1q_8ugA:10 a=i3VuKzQdj-NEYjvDI-p3:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 08, 2019 at 04:39:41PM +0000, Chris Mason wrote:
> On 7 May 2019, at 17:22, Dave Chinner wrote:
> 
> > On Tue, May 07, 2019 at 01:05:28PM -0400, Rik van Riel wrote:
> >> The code in xlog_wait uses the spinlock to make adding the task to
> >> the wait queue, and setting the task state to UNINTERRUPTIBLE atomic
> >> with respect to the waker.
> >>
> >> Doing the wakeup after releasing the spinlock opens up the following
> >> race condition:
> >>
> >> - add task to wait queue
> >>
> >> -                                      wake up task
> >>
> >> - set task state to UNINTERRUPTIBLE
> >>
> >> Simply moving the spin_unlock to after the wake_up_all results
> >> in the waker not being able to see a task on the waitqueue before
> >> it has set its state to UNINTERRUPTIBLE.
> >
> > Yup, seems like an issue. Good find, Rik.
> >
> > So, what problem is this actually fixing? Was it noticed by
> > inspection, or is it actually manifesting on production machines?
> > If it is manifesting IRL, what are the symptoms (e.g. hang running
> > out of log space?) and do you have a test case or any way to
> > exercise it easily?
> 
> The steps to reproduce are semi-complicated, they create a bunch of 
> files, do stuff, and then delete all the files in a loop.  I think they 
> shotgunned it across 500 or so machines to trigger 5 times, and then 
> left the wreckage for us to poke at.
> 
> The symptoms were identical to the bug fixed here:
> 
> commit 696a562072e3c14bcd13ae5acc19cdf27679e865
> Author: Brian Foster <bfoster@redhat.com>
> Date:   Tue Mar 28 14:51:44 2017 -0700
> 
> xfs: use dedicated log worker wq to avoid deadlock with cil wq
> 
> But since our 4.16 kernel is new than that, I briefly hoped that 
> m_sync_workqueue needed to be flagged with WQ_MEM_RECLAIM.  I don't have 
> a great picture of how all of these workqueues interact, but I do think 
> it needs WQ_MEM_RECLAIM.  It can't be the cause of this deadlock, the 
> workqueue watchdog would have fired.

It shouldn't matter, because the m_sync_workqueue is largely
advisory - the only real function it has is to ensure that idle
filesystems have dirty metadata flushed and the journal emptied and
marked clean (that's what "covering the log" means) so if we crash
on an idle filesystem recovery is unnecessary....

i.e. if the filesystem is heavily busy it doesn't matter is the
m_sync_workqueue is run or not.

....

> That's a huge tangent around acking Rik's patch, but it's hard to be 
> sure if we've hit the lost wakeup in prod.  I could search through all 
> the related hung task timeouts, but they are probably all stuck in 
> blkmq.
> 
> Acked-but-I'm-still-blaming-Jens-by: Chris Mason <clm@fb.com>

No worries, quite the wild goose chase. :)

I just wanted some background on how it manifested so that we have
some idea of whether we have other unresolved bug reports that might
be a result of this problem.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
