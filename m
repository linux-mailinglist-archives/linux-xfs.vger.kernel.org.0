Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71A7D352D1
	for <lists+linux-xfs@lfdr.de>; Wed,  5 Jun 2019 00:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbfFDWpu (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 4 Jun 2019 18:45:50 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:53947 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726179AbfFDWpu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jun 2019 18:45:50 -0400
Received: from dread.disaster.area (pa49-180-144-61.pa.nsw.optusnet.com.au [49.180.144.61])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 4F72C43ABB7;
        Wed,  5 Jun 2019 08:45:47 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hYIBc-0002fh-Tu; Wed, 05 Jun 2019 08:45:44 +1000
Date:   Wed, 5 Jun 2019 08:45:44 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 06/20] xfs: don't use REQ_PREFLUSH for split log writes
Message-ID: <20190604224544.GB29573@dread.disaster.area>
References: <20190603172945.13819-1-hch@lst.de>
 <20190603172945.13819-7-hch@lst.de>
 <20190604161240.GA44563@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190604161240.GA44563@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0 cx=a_idp_d
        a=8RU0RCro9O0HS2ezTvitPg==:117 a=8RU0RCro9O0HS2ezTvitPg==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=dq6fvYVFJ5YA:10
        a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8 a=HfHtIFm33E_ZmGJehCsA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Jun 04, 2019 at 12:12:40PM -0400, Brian Foster wrote:
> On Mon, Jun 03, 2019 at 07:29:31PM +0200, Christoph Hellwig wrote:
> > If we have to split a log write because it wraps the end of the log we
> > can't just use REQ_PREFLUSH to flush before the first log write,
> > as the writes might get reordered somewhere in the I/O stack.  Issue
> > a manual flush in that case so that the ordering of the two log I/Os
> > doesn't matter.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > Reviewed-by: Dave Chinner <dchinner@redhat.com>
> > ---
> >  fs/xfs/xfs_log.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index 3b82ca8ac9c8..646a190e5730 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -1941,7 +1941,7 @@ xlog_sync(
> >  	 * synchronously here; for an internal log we can simply use the block
> >  	 * layer state machine for preflushes.
> >  	 */
> > -	if (log->l_mp->m_logdev_targp != log->l_mp->m_ddev_targp)
> > +	if (log->l_mp->m_logdev_targp != log->l_mp->m_ddev_targp || split)
> >  		xfs_blkdev_issue_flush(log->l_mp->m_ddev_targp);
> 
> I'm curious if this is really necessary. The log record isn't
> recoverable until it's complete on disk (and thus the tail LSN stamped
> in the record header not relevant). As long as the cache flushes before
> the record is completely written, what difference does it make if it was
> made up of two out of order I/Os?

The problem is not whether the log write is recoverable, it's
whether what it overwrites is already on stable storage. i.e.  the
tail of the log can be overwritten by the split write to the start
of the log before the cache flush in the first iclog IO makes the
metadata it is overwriting stable. i.e:


	metadata write		-> volatile disk cache
	move log tail forwards	-> tail wraps back to start
<...>
	log write wrapping tail
	  iclog split
	   iclog write to end /w PREFLUSH + FUA
	   			-> queued in request queue
	   iclog write to start /w FUA
	   			-> queued in request queue
<....>
	request queue gets processed
	  dispatches write to start w/ FUA
				-> overwrites tail of log
<....>
	  dispatches write to end w/ PREFLUSH + FUA
	  			-> flushes metadata @ tail of log

If we have a power loss incident after the first FUA write to the
start of the log but before the second write issues/completes the
PREFLUSH, we have a situation on disk where the log tail has been
overwritten but the metadata that it overwrote had not yet been
committed to stable storage. That will result in either a corrupt
log (can't find tail) or a corrupt fielsystem because metadata in
some structure was not recovered.

> Granted log wrapping is not a frequent operation, but the explicit flush
> is a synchronous operation in the log force path whereas the flush flag
> isn't.

We have the options of:

	1) issuing a synchronous flush before both writes and then
	doing them w/ FUA only; or
	2) issuing both log writes with PREFLUSH+FUA.

In the first case, the fact the cache flush is done synchronously
really doesn't affect anything - it's done in the CIL push kworker
context, so blocking here doesn't really add any extra latency to
anything except synchronous log force waiters. Hence, typically,
there is nothing waiting on the log being flushed so it what extra
latency there is mostly won't matter.

In the second case, one of the cache flushes is superfluous and for
busy filesytems with small logs where we frequently hit the wrap
case this may add up to quite a bit of avoidable IO overhead....

Either way works, it's not clear to me that one is always superior
to the other, so we just have to chose one....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
