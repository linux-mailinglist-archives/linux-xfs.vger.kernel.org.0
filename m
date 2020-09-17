Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 993E426E0ED
	for <lists+linux-xfs@lfdr.de>; Thu, 17 Sep 2020 18:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728546AbgIQQk4 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 17 Sep 2020 12:40:56 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50616 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728599AbgIQQio (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 12:38:44 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08HGaBhD019877;
        Thu, 17 Sep 2020 16:38:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=RPFaz4dOv+NqkVnFY0HMTCkIZuu2sfg6PPiCU2s9X1k=;
 b=CGukv4jGOFNplk18gwXu9KXtJe9Q6PyAcy3HAfMIOHmxQn2Pr2A2SkyTXCZpSLSW2O2g
 WWMD21Hgk0ED+yB9OO+97mQd5B6ujFj7ZgqxbfZb/p247zfuJSnQCd8uNgqpZ5sJmeo3
 WXezJQiZjt4OIksgexlkcX3mSt46zVH2yy6j6LFLcRrTARs8E/0ITDL5it6pL2vBBOre
 rg7Udx34LV9Ow9fxzh9J5cbLNzYVQnYpmP8K3b3EOa0W2nWZl6Uwc4ZQeRgraXZ836Oa
 XxHV7FrC1ak8riVZwJxKRRrDHol2itvf07pcRvKhp9lw1+CHgLx39OQbrvmut9DELQY1 Xg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 33gp9mjdwx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Sep 2020 16:38:38 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08HGYnge129580;
        Thu, 17 Sep 2020 16:38:37 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 33h8943njq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Sep 2020 16:38:37 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08HGcagp009743;
        Thu, 17 Sep 2020 16:38:36 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Sep 2020 16:38:36 +0000
Date:   Thu, 17 Sep 2020 09:38:35 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 1/3] xfs: change the order in which child and parent
 defer ops are finished
Message-ID: <20200917163835.GF7955@magnolia>
References: <160031338724.3624707.1335084348340671147.stgit@magnolia>
 <160031339354.3624707.1985288778723932783.stgit@magnolia>
 <20200917152755.GA1874815@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917152755.GA1874815@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=1 mlxscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009170126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 spamscore=0 priorityscore=1501 suspectscore=1 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009170126
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 17, 2020 at 11:27:55AM -0400, Brian Foster wrote:
> On Wed, Sep 16, 2020 at 08:29:53PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > The defer ops code has been finishing items in the wrong order -- if a
> > top level defer op creates items A and B, and finishing item A creates
> > more defer ops A1 and A2, we'll put the new items on the end of the
> > chain and process them in the order A B A1 A2.  This is kind of weird,
> > since it's convenient for programmers to be able to think of A and B as
> > an ordered sequence where all the sub-tasks for A must finish before we
> > move on to B, e.g. A A1 A2 D.
> > 
> > Right now, our log intent items are not so complex that this matters,
> > but this will become important for the atomic extent swapping patchset.
> > In order to maintain correct reference counting of extents, we have to
> > unmap and remap extents in that order, and we want to complete that work
> > before moving on to the next range that the user wants to swap.  This
> > patch fixes defer ops to satsify that requirement.
> > 
> > The primary symptom of the incorrect order was noticed in an early
> > performance analysis of the atomic extent swap code.  An astonishingly
> > large number of deferred work items accumulated when userspace requested
> > an atomic update of two very fragmented files.  The cause of this was
> > traced to the same ordering bug in the inner loop of
> > xfs_defer_finish_noroll.
> > 
> > If the ->finish_item method of a deferred operation queues new deferred
> > operations, those new deferred ops are appended to the tail of the
> > pending work list.  To illustrate, say that a caller creates a
> > transaction t0 with four deferred operations D0-D3.  The first thing
> > defer ops does is roll the transaction to t1, leaving us with:
> > 
> > t1: D0(t0), D1(t0), D2(t0), D3(t0)
> > 
> > Let's say that finishing each of D0-D3 will create two new deferred ops.
> > After finish D0 and roll, we'll have the following chain:
> > 
> > t2: D1(t0), D2(t0), D3(t0), d4(t1), d5(t1)
> > 
> > d4 and d5 were logged to t1.  Notice that while we're about to start
> > work on D1, we haven't actually completed all the work implied by D0
> > being finished.  So far we've been careful (or lucky) to structure the
> > dfops callers such that D1 doesn't depend on d4 or d5 being finished,
> > but this is a potential logic bomb.
> > 
> > There's a second problem lurking.  Let's see what happens as we finish
> > D1-D3:
> > 
> > t3: D2(t0), D3(t0), d4(t1), d5(t1), d6(t2), d7(t2)
> > t4: D3(t0), d4(t1), d5(t1), d6(t2), d7(t2), d8(t3), d9(t3)
> > t5: d4(t1), d5(t1), d6(t2), d7(t2), d8(t3), d9(t3), d10(t4), d11(t4)
> > 
> > Let's say that d4-d11 are simple work items that don't queue any other
> > operations, which means that we can complete each d4 and roll to t6:
> > 
> > t6: d5(t1), d6(t2), d7(t2), d8(t3), d9(t3), d10(t4), d11(t4)
> > t7: d6(t2), d7(t2), d8(t3), d9(t3), d10(t4), d11(t4)
> > ...
> > t11: d10(t4), d11(t4)
> > t12: d11(t4)
> > <done>
> > 
> > When we try to roll to transaction #12, we're holding defer op d11,
> > which we logged way back in t4.  This means that the tail of the log is
> > pinned at t4.  If the log is very small or there are a lot of other
> > threads updating metadata, this means that we might have wrapped the log
> > and cannot get roll to t11 because there isn't enough space left before
> > we'd run into t4.
> > 
> > Let's shift back to the original failure.  I mentioned before that I
> > discovered this flaw while developing the atomic file update code.  In
> > that scenario, we have a defer op (D0) that finds a range of file blocks
> > to remap, creates a handful of new defer ops to do that, and then asks
> > to be continued with however much work remains.
> > 
> > So, D0 is the original swapext deferred op.  The first thing defer ops
> > does is rolls to t1:
> > 
> > t1: D0(t0)
> > 
> > We try to finish D0, logging d1 and d2 in the process, but can't get all
> > the work done.  We log a done item and a new intent item for the work
> > that D0 still has to do, and roll to t2:
> > 
> > t2: D0'(t1), d1(t1), d2(t1)
> > 
> > We roll and try to finish D0', but still can't get all the work done, so
> > we log a done item and a new intent item for it, requeue D0 a second
> > time, and roll to t3:
> > 
> > t3: D0''(t2), d1(t1), d2(t1), d3(t2), d4(t2)
> > 
> > If it takes 48 more rolls to complete D0, then we'll finally dispense
> > with D0 in t50:
> > 
> > t50: D<fifty primes>(t49), d1(t1), ..., d102(t50)
> > 
> > We then try to roll again to get a chain like this:
> > 
> > t51: d1(t1), d2(t1), ..., d101(t50), d102(t50)
> > ...
> > t152: d102(t50)
> > <done>
> > 
> > Notice that in rolling to transaction #51, we're holding on to a log
> > intent item for d1 that was logged in transaction #1.  This means that
> > the tail of the log is pinned at t1.  If the log is very small or there
> > are a lot of other threads updating metadata, this means that we might
> > have wrapped the log and cannot roll to t51 because there isn't enough
> > space left before we'd run into t1.  This is of course problem #2 again.
> > 
> > But notice the third problem with this scenario: we have 102 defer ops
> > tied to this transaction!  Each of these items are backed by pinned
> > kernel memory, which means that we risk OOM if the chains get too long.
> > 
> > Yikes.  Problem #1 is a subtle logic bomb that could hit someone in the
> > future; problem #2 applies (rarely) to the current upstream, and problem
> > #3 applies to work under development.
> > 
> > This is not how incremental deferred operations were supposed to work.
> > The dfops design of logging in the same transaction an intent-done item
> > and a new intent item for the work remaining was to make it so that we
> > only have to juggle enough deferred work items to finish that one small
> > piece of work.  Deferred log item recovery will find that first
> > unfinished work item and restart it, no matter how many other intent
> > items might follow it in the log.  Therefore, it's ok to put the new
> > intents at the start of the dfops chain.
> > 
> > For the first example, the chains look like this:
> > 
> > t2: d4(t1), d5(t1), D1(t0), D2(t0), D3(t0)
> > t3: d5(t1), D1(t0), D2(t0), D3(t0)
> > ...
> > t9: d9(t7), D3(t0)
> > t10: D3(t0)
> > t11: d10(t10), d11(t10)
> > t12: d11(t10)
> > 
> > For the second example, the chains look like this:
> > 
> > t1: D0(t0)
> > t2: d1(t1), d2(t1), D0'(t1)
> > t3: d2(t1), D0'(t1)
> > t4: D0'(t1)
> > t5: d1(t4), d2(t4), D0''(t4)
> > ...
> > t148: D0<50 primes>(t147)
> > t149: d101(t148), d102(t148)
> > t150: d102(t148)
> > <done>
> > 
> 
> Ok, this one looks funny at first glance, but I think it makes sense..
> If I use a simple example and assume D0(t0) is a large unmap intent and
> the subsequent child dfops (d1, d2) are extent frees, this essentially
> means that we'd unmap an (incomplete) range, defer the frees for the
> range we did unmap, process those frees, then get back around to the
> unmap and pick up the next chunk for D0' (and so on). That would be
> instead of the current behavior which presumably process the unmap (D0)
> continuously and queues up all of the frees (dN) until the former is
> 100% complete. Right?

Correct.

> > This actually sucks more for pinning the log tail (we try to roll to t10
> > while holding an intent item that was logged in t1) but we've solved
> > problem #1.  We've also reduced the maximum chain length from:
> > 
> >     sum(all the new items) + nr_original_items
> > 
> > to:
> > 
> >     max(new items that each original item creates) + nr_original_items
> > 
> > This solves problem #3 by sharply reducing the number of defer ops that
> > can be attached to a transaction at any given time.  The change makes
> > the problem of log tail pinning worse, but is improvement we need to
> > solve problem #2.  Actually solving #2, however, is left to the next
> > patch.
> > 
> > Note that a subsequent analysis of some hard-to-trigger reflink and COW
> > livelocks on extremely fragmented filesystems (or systems running a lot
> > of IO threads) showed the same symptoms -- uncomfortably large numbers
> > of incore deferred work items and occasional stalls in the transaction
> > grant code while waiting for log reservations.  I think this patch and
> > the next one will also solve these problems.
> > 
> > As originally written, the code used list_splice_tail_init instead of
> > list_splice_init, so change that, and leave a short comment explaining
> > our actions.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_defer.c |   11 ++++++++++-
> >  1 file changed, 10 insertions(+), 1 deletion(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> > index 97523b394932..84a70edd0da1 100644
> > --- a/fs/xfs/libxfs/xfs_defer.c
> > +++ b/fs/xfs/libxfs/xfs_defer.c
> > @@ -431,8 +431,17 @@ xfs_defer_finish_noroll(
> >  
> >  	/* Until we run out of pending work to finish... */
> >  	while (!list_empty(&dop_pending) || !list_empty(&(*tp)->t_dfops)) {
> > +		/*
> > +		 * Deferred items that are created in the process of finishing
> > +		 * other deferred work items should be queued at the head of
> > +		 * the pending list, which puts them ahead of the deferred work
> > +		 * that was created by the caller.  This keeps the number of
> > +		 * pending work items to a minimum, which decreases the amount
> > +		 * of time that any one intent item can stick around in memory,
> > +		 * pinning the log tail.
> > +		 */
> >  		xfs_defer_create_intents(*tp);
> > -		list_splice_tail_init(&(*tp)->t_dfops, &dop_pending);
> > +		list_splice_init(&(*tp)->t_dfops, &dop_pending);
> 
> This has me wondering whether we should consider explicit separation of
> chains through some kind of parent/child relationship to make the
> behavior and implementation more clear to reason about.

I thought about that; the difficulty is that we don't put any particular
limits on the amount of dfops children you can create.  Recalling the CS
textbooks of my childhood, the old code effectively flattened the
parent-child dfops tree into a breadth-first list for traversal, whereas
this new code flattens that "tree" into depth-first order.

(Except it's not a tree, and the requeueing ability makes the
tree-traversal analogy leak like Firefox running modern Faceook.)

> That's a bigger
> picture topic, though. Assuming I'm following things correctly above,
> this looks reasonable to me:

Yup, you're following things correctly.  Thanks for reviewing!

--D

> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> >  
> >  		error = xfs_defer_trans_roll(tp);
> >  		if (error)
> > 
> 
