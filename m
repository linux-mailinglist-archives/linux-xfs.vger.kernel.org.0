Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C56133349D6
	for <lists+linux-xfs@lfdr.de>; Wed, 10 Mar 2021 22:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbhCJV2p (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 10 Mar 2021 16:28:45 -0500
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:40405 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231226AbhCJV2b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Mar 2021 16:28:31 -0500
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id B447E78C586;
        Thu, 11 Mar 2021 08:28:29 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lK6NY-0012bz-PY; Thu, 11 Mar 2021 08:28:28 +1100
Date:   Thu, 11 Mar 2021 08:28:28 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/45] xfs: journal IO cache flush reductions
Message-ID: <20210310212828.GG74031@dread.disaster.area>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-9-david@fromorbit.com>
 <YEYXtqb7L1zyAHyC@bfoster>
 <20210309011352.GD74031@dread.disaster.area>
 <YEkw2CDpeC58iIey@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YEkw2CDpeC58iIey@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_d
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=a-RJl1fv00Ts67t0PNQA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 10, 2021 at 03:49:28PM -0500, Brian Foster wrote:
> On Tue, Mar 09, 2021 at 12:13:52PM +1100, Dave Chinner wrote:
> > On Mon, Mar 08, 2021 at 07:25:26AM -0500, Brian Foster wrote:
> > > On Fri, Mar 05, 2021 at 04:11:06PM +1100, Dave Chinner wrote:
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > > 
> > > > Currently every journal IO is issued as REQ_PREFLUSH | REQ_FUA to
> > > > guarantee the ordering requirements the journal has w.r.t. metadata
> > > > writeback. THe two ordering constraints are:
> > ....
> > > > The rm -rf times are included because I ran them, but the
> > > > differences are largely noise. This workload is largely metadata
> > > > read IO latency bound and the changes to the journal cache flushing
> > > > doesn't really make any noticable difference to behaviour apart from
> > > > a reduction in noiclog events from background CIL pushing.
> > > > 
> > > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > > ---
> > > 
> > > Thoughts on my previous feedback to this patch, particularly the locking
> > > bits..? I thought I saw a subsequent patch somewhere that increased the
> > > parallelism of this code..
> > 
> > I seem to have missed that email, too.
> > 
> 
> Seems this occurs more frequently than it should. :/ Mailer problems?

vger has been causing all sorts of problems recently - fromorbit.com
is backed by gmail, and gmail has been one of the mail targets that
has caused vger the most problems. I've also noticed that gmail is
classifying and awful lot of mailing list traffic as spam in recent
months - I'm typically having to manulaly pull 50 "[PATCH ...]
emails a month out of the spam folders, including stuff from
Christoph, Darrick and @redhat.com addresses. There isn't anything I
can do about either of these things - email does not guarantee
delivery...

> > > > diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> > > > index c04d5d37a3a2..263c8d907221 100644
> > > > --- a/fs/xfs/xfs_log_cil.c
> > > > +++ b/fs/xfs/xfs_log_cil.c
> > > > @@ -896,11 +896,16 @@ xlog_cil_push_work(
> > > >  
> > > >  	/*
> > > >  	 * If the checkpoint spans multiple iclogs, wait for all previous
> > > > -	 * iclogs to complete before we submit the commit_iclog.
> > > > +	 * iclogs to complete before we submit the commit_iclog. If it is in the
> > > > +	 * same iclog as the start of the checkpoint, then we can skip the iclog
> > > > +	 * cache flush because there are no other iclogs we need to order
> > > > +	 * against.
> > > >  	 */
> > > >  	if (ctx->start_lsn != commit_lsn) {
> > > >  		spin_lock(&log->l_icloglock);
> > > >  		xlog_wait_on_iclog(commit_iclog->ic_prev);
> > > > +	} else {
> > > > +		commit_iclog->ic_flags &= ~XLOG_ICL_NEED_FLUSH;
> > > >  	}
> > 
> > .... that set/clear the flags on the iclog?  Yes, they probably
> > should be atomic.
> > 
> > On second thoughts, we can't just clear XLOG_ICL_NEED_FLUSH here
> > because there may be multiple commit records on this iclog and a
> > previous one might require the flush. I'll just remove this
> > optimisation from the patch right now, because it's more complex
> > than it initially seemed.
> > 
> 
> Ok.

On the gripping hand, the optimisation can stay once this:

> > And looking at the aggregated code that I have now (including the
> > stuff I haven't sent out), the need for xlog_write() to set the
> > flush flags on the iclog is gone. THis is because the unmount record
> > flushes the iclog directly itself so it can add flags there, and
> > the iclog that the commit record is written to is returned to the
> > caller.

is done.

That's because we are only setting new flags on each commit and so
not removing flags that previous commits to this iclog may have set.
Hence if a previous commit in this iclog set the flush flag, it will
remain set even if a new commit is added that is wholly within the
current iclog is run.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
