Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37AE23997F0
	for <lists+linux-xfs@lfdr.de>; Thu,  3 Jun 2021 04:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbhFCCPS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 2 Jun 2021 22:15:18 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:39320 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229541AbhFCCPR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Jun 2021 22:15:17 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 581611043517;
        Thu,  3 Jun 2021 12:13:31 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1locrS-008Jns-63; Thu, 03 Jun 2021 12:13:30 +1000
Date:   Thu, 3 Jun 2021 12:13:30 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 33/39] xfs: Add order IDs to log items in CIL
Message-ID: <20210603021330.GL664593@dread.disaster.area>
References: <20210519121317.585244-1-david@fromorbit.com>
 <20210519121317.585244-34-david@fromorbit.com>
 <20210527190023.GK2402049@locust>
 <20210603001622.GZ664593@dread.disaster.area>
 <20210603004914.GC26402@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210603004914.GC26402@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=7-415B0cAAAA:8 a=9BoE1E68RzcAytnihGwA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 02, 2021 at 05:49:14PM -0700, Darrick J. Wong wrote:
> On Thu, Jun 03, 2021 at 10:16:22AM +1000, Dave Chinner wrote:
> > On Thu, May 27, 2021 at 12:00:23PM -0700, Darrick J. Wong wrote:
> > > On Wed, May 19, 2021 at 10:13:11PM +1000, Dave Chinner wrote:
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > > 
> > > > Before we split the ordered CIL up into per cpu lists, we need a
> > > > mechanism to track the order of the items in the CIL. We need to do
> > > > this because there are rules around the order in which related items
> > > > must physically appear in the log even inside a single checkpoint
> > > > transaction.
> > > > 
> > > > An example of this is intents - an intent must appear in the log
> > > > before it's intent done record so taht log recovery can cancel the
> > > 
> > > s/taht/that/
> > > 
> > > > intent correctly. If we have these two records misordered in the
> > > > CIL, then they will not be recovered correctly by journal replay.
> > > > 
> > > > We also will not be able to move items to the tail of
> > > > the CIL list when they are relogged, hence the log items will need
> > > > some mechanism to allow the correct log item order to be recreated
> > > > before we write log items to the hournal.
> > > > 
> > > > Hence we need to have a mechanism for recording global order of
> > > > transactions in the log items  so that we can recover that order
> > > > from un-ordered per-cpu lists.
> > > > 
> > > > Do this with a simple monotonic increasing commit counter in the CIL
> > > > context. Each log item in the transaction gets stamped with the
> > > > current commit order ID before it is added to the CIL. If the item
> > > > is already in the CIL, leave it where it is instead of moving it to
> > > > the tail of the list and instead sort the list before we start the
> > > > push work.
> > > > 
> > > > XXX: list_sort() under the cil_ctx_lock held exclusive starts
> > > > hurting that >16 threads. Front end commits are waiting on the push
> > > > to switch contexts much longer. The item order id should likely be
> > > > moved into the logvecs when they are detacted from the items, then
> > > > the sort can be done on the logvec after the cil_ctx_lock has been
> > > > released. logvecs will need to use a list_head for this rather than
> > > > a single linked list like they do now....
> > > 
> > > ...which I guess happens in patch 35 now?
> > 
> > Right. I'll just remove this from the commit message.
> > 
> > > > @@ -780,6 +780,26 @@ xlog_cil_build_trans_hdr(
> > > >  	tic->t_curr_res -= lvhdr->lv_bytes;
> > > >  }
> > > >  
> > > > +/*
> > > > + * CIL item reordering compare function. We want to order in ascending ID order,
> > > > + * but we want to leave items with the same ID in the order they were added to
> > > 
> > > When do we have items with the same id?
> > 
> > All the items in a single transaction have the same id. The order id
> > increments before we tag all the items in the transaction and insert
> > them into the CIL.
> > 
> > > I guess that happens if we have multiple transactions adding items to
> > > the cil at the same time?  I guess that's not a big deal since each of
> > > those threads will hold a disjoint set of locks, so even if the order
> > > ids are the same for a bunch of items, they're never going to be
> > > touching the same AG/inode/metadata object, right?
> > >
> > > If that's correct, then:
> > > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> > 
> > 
> > While true, it's not the way this works so I won't immediately
> > accept your RVB. The reason for not changing the ordering within a
> > single transaction is actually intent logging.  i.e. this:
> > 
> > > > + * the list. This is important for operations like reflink where we log 4 order
> > > > + * dependent intents in a single transaction when we overwrite an existing
> > > > + * shared extent with a new shared extent. i.e. BUI(unmap), CUI(drop),
> > > > + * CUI (inc), BUI(remap)...
> > 
> > There's a specific order of operations that recovery must run these
> > intents in, and so if we re-order them here in the CIL they'll be
> > out of order in the log and recovery will replay the intents in the
> > wrong order. Replaying the intents in the wrong order results in
> > corruption warnings and assert failures during log recovery, hence
> > the constraint of not re-ordering items within the same transaction.
> 
> <ding> lightbulb comes on.  I think I understood this better the last
> time I read all these patches. :/
> 
> Basically, for each item that can be attached to a transaction, you're
> assigning it an "order id" that is a monotonically increasing counter
> that (roughly) records the last time the item was committed.  Certain
> items (like inodes) can be relogged and committed multiple times in
> rapid fire succession, in which case the order_id will get bumped
> forward.

Effectively, yes.

> In the /next/ patch you'll change the cil item list to be per-cpu and
> only splice the mess together at cil push time.  For that to work
> properly, you have to re-sort that resulting list in commit order (aka
> the order_id) to keep the items in order of commit.
> 
> For items *within* a transaction, you take advantage of the property
> of list_sort that it won't reorder items with cmp(a, b) == 0, which
> means that all the intents logged to a transaction will maintain the
> same order that the author of higher level code wrote into the software.

Correct.

> Question: xlog_cil_push_work zeroes the order_id of pushed log items.
> Is there any potential problem here when ctx->order_id wraps around to
> zero?  I think the answer is that we'll move on to a new cil context
> long before we hit 2^32-1 transactions?

Yes. At the moment, the max transaction rate is about 800k/s, which
means it'd take a couple of hours to run 4 billion transactions. So
we're in no danger of overruning the number of transactions in a CIL
commit any time soon. And if we ever get near that, we can just bump
the counter to a 64 bit value...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
