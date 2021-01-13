Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8490B2F54B2
	for <lists+linux-xfs@lfdr.de>; Wed, 13 Jan 2021 22:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbhAMVzt (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 13 Jan 2021 16:55:49 -0500
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:42426 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729229AbhAMVzK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Jan 2021 16:55:10 -0500
Received: from dread.disaster.area (pa49-179-167-107.pa.nsw.optusnet.com.au [49.179.167.107])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id A94981ACDFD;
        Thu, 14 Jan 2021 08:53:49 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1kzo5M-006AIU-SC; Thu, 14 Jan 2021 08:53:48 +1100
Date:   Thu, 14 Jan 2021 08:53:48 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Donald Buczek <buczek@molgen.mpg.de>, linux-xfs@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        it+linux-xfs@molgen.mpg.de
Subject: Re: [PATCH] xfs: Wake CIL push waiters more reliably
Message-ID: <20210113215348.GI331610@dread.disaster.area>
References: <1705b481-16db-391e-48a8-a932d1f137e7@molgen.mpg.de>
 <20201229235627.33289-1-buczek@molgen.mpg.de>
 <20201230221611.GC164134@dread.disaster.area>
 <20210104162353.GA254939@bfoster>
 <20210107215444.GG331610@dread.disaster.area>
 <20210108165657.GC893097@bfoster>
 <20210111163848.GC1091932@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111163848.GC1091932@bfoster>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=+wqVUQIkAh0lLYI+QRsciw==:117 a=+wqVUQIkAh0lLYI+QRsciw==:17
        a=kj9zAlcOel0A:10 a=EmqxpYm9HcoA:10 a=7-415B0cAAAA:8
        a=jeGTqxCbE2Z_5-kZt_IA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 11, 2021 at 11:38:48AM -0500, Brian Foster wrote:
> On Fri, Jan 08, 2021 at 11:56:57AM -0500, Brian Foster wrote:
> > On Fri, Jan 08, 2021 at 08:54:44AM +1100, Dave Chinner wrote:
> > > On Mon, Jan 04, 2021 at 11:23:53AM -0500, Brian Foster wrote:
> > > > On Thu, Dec 31, 2020 at 09:16:11AM +1100, Dave Chinner wrote:
> > > > > On Wed, Dec 30, 2020 at 12:56:27AM +0100, Donald Buczek wrote:
> > > > > > If the value goes below the limit while some threads are
> > > > > > already waiting but before the push worker gets to it, these threads are
> > > > > > not woken.
> > > > > > 
> > > > > > Always wake all CIL push waiters. Test with waitqueue_active() as an
> > > > > > optimization. This is possible, because we hold the xc_push_lock
> > > > > > spinlock, which prevents additions to the waitqueue.
> > > > > > 
> > > > > > Signed-off-by: Donald Buczek <buczek@molgen.mpg.de>
> > > > > > ---
> > > > > >  fs/xfs/xfs_log_cil.c | 2 +-
> > > > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > > > > 
> > > > > > diff --git a/fs/xfs/xfs_log_cil.c b/fs/xfs/xfs_log_cil.c
> > > > > > index b0ef071b3cb5..d620de8e217c 100644
> > > > > > --- a/fs/xfs/xfs_log_cil.c
> > > > > > +++ b/fs/xfs/xfs_log_cil.c
> > > > > > @@ -670,7 +670,7 @@ xlog_cil_push_work(
> > > > > >  	/*
> > > > > >  	 * Wake up any background push waiters now this context is being pushed.
> > > > > >  	 */
> > > > > > -	if (ctx->space_used >= XLOG_CIL_BLOCKING_SPACE_LIMIT(log))
> > > > > > +	if (waitqueue_active(&cil->xc_push_wait))
> > > > > >  		wake_up_all(&cil->xc_push_wait);
> > > > > 
> > > > > That just smells wrong to me. It *might* be correct, but this
> > > > > condition should pair with the sleep condition, as space used by a
> > > > > CIL context should never actually decrease....
> > > > > 
> > > > 
> > > > ... but I'm a little confused by this assertion. The shadow buffer
> > > > allocation code refers to the possibility of shadow buffers falling out
> > > > that are smaller than currently allocated buffers. Further, the
> > > > _insert_format_items() code appears to explicitly optimize for this
> > > > possibility by reusing the active buffer, subtracting the old size/count
> > > > values from the diff variables and then reformatting the latest
> > > > (presumably smaller) item to the lv.
> > > 
> > > Individual items might shrink, but the overall transaction should
> > > grow. Think of a extent to btree conversion of an inode fork. THe
> > > data in the inode fork decreases from a list of extents to a btree
> > > root block pointer, so the inode item shrinks. But then we add a new
> > > btree root block that contains all the extents + the btree block
> > > header, and it gets rounded up to ithe 128 byte buffer logging chunk
> > > size.
> > > 
> > > IOWs, while the inode item has decreased in size, the overall
> > > space consumed by the transaction has gone up and so the CIL ctx
> > > used_space should increase. Hence we can't just look at individual
> > > log items and whether they have decreased in size - we have to look
> > > at all the items in the transaction to understand how the space used
> > > in that transaction has changed. i.e. it's the aggregation of all
> > > items in the transaction that matter here, not so much the
> > > individual items.
> > > 
> > 
> > Ok, that makes more sense...
> > 
> > > > Of course this could just be implementation detail. I haven't dug into
> > > > the details in the remainder of this thread and I don't have specific
> > > > examples off the top of my head, but perhaps based on the ability of
> > > > various structures to change formats and the ability of log vectors to
> > > > shrink in size, shouldn't we expect the possibility of a CIL context to
> > > > shrink in size as well? Just from poking around the CIL it seems like
> > > > the surrounding code supports it (xlog_cil_insert_items() checks len > 0
> > > > for recalculating split res as well)...
> > > 
> > > Yes, there may be situations where it decreases. It may be this is
> > > fine, but the assumption *I've made* in lots of the CIL push code is
> > > that ctx->used_space rarely, if ever, will go backwards.
> > > 
> > 
> > ... and rarely seems a bit more pragmatic than never.
> > 
> 
> FWIW, a cursory look at the inode size/format code (motivated by
> Donald's recent log dump that appears to show inode log items changing
> size) suggested that a simple local format size change might be enough
> to cause this condition on an item. A subsequent test to create and
> immediately remove a file from an otherwise empty directory triggers a
> tracepoint I injected in xlog_cil_insert_items() to detect a negative
> transaction delta. As expected, the absolute value of the delta does
> seem to increase with a larger filename. This also produces a negative
> iovec delta, fwiw. E.g.:
> 
> # touch `for i in $(seq 0 63); do echo -n a; done`
> # rm -f `for i in $(seq 0 63); do echo -n a; done`
> #
> 
> rm-9265    [001] ....  4660.177806: xfs_log_commit_cil: 409: len -72 diff_iovecs 0
> rm-9265    [001] .N.1  4660.177913: xfs_log_commit_cil: 419: len -72 diff_iovecs 0
> rm-9265    [001] ....  4660.178313: xfs_log_commit_cil: 409: len -52 diff_iovecs -1
> rm-9265    [001] ...1  4660.178336: xfs_log_commit_cil: 419: len -64 diff_iovecs -1
> 
> ... and this only seems to occur when the unlink occurs before the CIL
> has been checkpointed and pushed out the inode (i.e. a freeze/unfreeze
> cycle prevents it).

Yeha, it's a shortform directory removal that triggers it easily
because the other items being modified in the transaction aren't
changing size on relogging (AGI unlink list pointer, unlinked inode
core for nlink change). Hence the reduction in size of the directory
inode reduces the overall CIL size...

> I've not dug into the transaction details and have no idea if this is
> the variant that Donald reproduces; it wouldn't surprise me a ton if
> there were various others. This is pretty straightforward, however, and
> shows the negative item delta carry through the transaction. IMO, that
> seems to justify a throttling fix...

I agree that a throttling fix is needed, but I'm trying to
understand the scope and breadth of the problem first instead of
jumping the gun and making the wrong fix for the wrong reasons that
just papers over the underlying problems that the throttling bug has
made us aware of...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
