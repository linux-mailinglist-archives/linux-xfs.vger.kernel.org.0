Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4C77E56FA
	for <lists+linux-xfs@lfdr.de>; Sat, 26 Oct 2019 01:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbfJYXQh (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 25 Oct 2019 19:16:37 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:33533 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725897AbfJYXQh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Oct 2019 19:16:37 -0400
Received: from dread.disaster.area (pa49-181-161-154.pa.nsw.optusnet.com.au [49.181.161.154])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 6BC453A0270;
        Sat, 26 Oct 2019 10:16:30 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1iO8om-00071a-U1; Sat, 26 Oct 2019 10:16:28 +1100
Date:   Sat, 26 Oct 2019 10:16:28 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC] xfs: automatic log item relogging experiment
Message-ID: <20191025231628.GH4614@dread.disaster.area>
References: <20191024172850.7698-1-bfoster@redhat.com>
 <20191024224308.GD4614@dread.disaster.area>
 <20191025124117.GA10931@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191025124117.GA10931@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=G6BsK5s5 c=1 sm=1 tr=0
        a=l3vQdJ1SkhDHY1nke8Lmag==:117 a=l3vQdJ1SkhDHY1nke8Lmag==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=XobE76Q3jBoA:10
        a=20KFwNOVAAAA:8 a=eJfxgxciAAAA:8 a=7-415B0cAAAA:8 a=CmzxI4zJjvKU0sIpAKYA:9
        a=Gki6_EjlSPQMbvo9:21 a=F7j9pkht2gmid8L8:21 a=CjuIK1q_8ugA:10
        a=xM9caqqi1sUkTy8OJ5Uh:22 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 25, 2019 at 08:41:17AM -0400, Brian Foster wrote:
> On Fri, Oct 25, 2019 at 09:43:08AM +1100, Dave Chinner wrote:
> > On Thu, Oct 24, 2019 at 01:28:50PM -0400, Brian Foster wrote:
> > > An experimental mechanism to automatically relog specified log
> > > items.  This is useful for long running operations, like quotaoff,
> > > that otherwise risk deadlocking on log space usage.
> > > 
> > > Not-signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > > 
> > > Hi all,
> > > 
> > > This is an experiment that came out of a discussion with Darrick[1] on
> > > some design bits of the latest online btree repair work. Specifically,
> > > it logs free intents in the same transaction as block allocation to
> > > guard against inconsistency in the event of a crash during the repair
> > > sequence. These intents happen pin the log tail for an indeterminate
> > > amount of time. Darrick was looking for some form of auto relog
> > > mechanism to facilitate this general approach. It occurred to us that
> > > this is the same problem we've had with quotaoff for some time, so I
> > > figured it might be worth prototyping something against that to try and
> > > prove the concept.
> > 
> > Interesting idea. :)
> > 
> > > 
> > > Note that this is RFC because the code and interfaces are a complete
> > > mess and this is broken in certain ways. This occasionally triggers log
> > > reservation overrun shutdowns because transaction reservation checking
> > > has not yet been added, the cancellation path is overkill, etc. IOW, the
> > > purpose of this patch is purely to test a concept.
> > 
> > *nod*
> > 
> > > The concept is essentially to flag a log item for relogging on first
> > > transaction commit such that once it commits to the AIL, the next
> > > transaction that happens to commit with sufficient unused reservation
> > > opportunistically relogs the item to the current CIL context. For the
> > > log intent case, the transaction that commits the done item is required
> > > to cancel the relog state of the original intent to prevent further
> > > relogging.
> > 
> > Makes sense, but it seems like we removed the hook that would be
> > used by transactions to implement their own relogging on CIL commit
> > some time ago because nothign had used it for 15+ years....
> > 
> 
> Interesting, I'm not familiar with this...
> 
> > > In practice, this allows a log item to automatically roll through CIL
> > > checkpoints and not pin the tail of the log while something like a
> > > quotaoff is running for a potentially long period of time. This is
> > > applied to quotaoff and focused testing shows that it avoids the
> > > associated deadlock.
> > 
> > Hmmm. How do we deal with multiple identical intents being found in
> > checkpoints with different LSNs in log recovery?
> > 
> 
> Good question. I was kind of thinking they would be handled like
> normally relogged items, but I hadn't got to recovery testing yet. For
> quotaoff, no special handling is required because we simply turn off
> quota flags (i.e. no filesystem changes are required) when the intent is
> seen and don't do anything else with the log item. FWIW, we don't even
> seem to check for an associated quotaoff_end item.
> 
> For something more involved like an EFI, it looks like we'd create a
> duplicate log item for the intent and I suspect that would lead to a
> double processing attempt. So this would require some further changes to
> handle generic intent relogging properly.

Right, that's kinda what I was getting at, but most intents as
currently implemented are somewhat special from a "relogging"
perspective in that they don't track ongoing modifications that have
been made since the intent was originally logged.

> I don't think it's that
> difficult of a problem; we do already allow for relogs of other things
> obviously, we just don't currently do any tracking of already seen
> intents. That said, this could probably be considered an ABI change if
> older kernels don't know how to process the condition correctly, so we'd
> have to guard against that with a feature bit or some such when a
> filesystem isn't unmounted cleanly.

I don't think tracking duplicate intents is a difficult problem,
either. The problem I see is when the original intent drops a full
log cycle behind (i.e. out of the active recovery window) before
the log recovery terminates and fails to find the intent-done item,
hence we are left in a situation where -some- of the work has been
done, but we don't know exactly what...

Intents were designed to work within a permanent (rolling)
transaction sequence - the intent and the done intent are directly
related and the work that is done is done within the context of that
rolling transaction. Expanding an intent to span an unbound amount
of work should be ok if this work is done in the context of a single
rolling transaction and we can relog the intent safely. However,
Allowing intents to cover multiple independent transactions is a big
can of worms I really don't us want to open...

> More broadly, this implies that we don't ever currently relog intents so
> this is something that will come along with any implementation that
> intends to do so unless we adopt an alternative along the lines of what
> dfops processing does. Dfops completes the original intent and creates a
> new one on each internal transaction roll.

Right - chaining intents gives us atomic transactions from a
recovery perspective. This works because intents cover only a small
operation, so individual intents will never pin the tail of the log
over the scope of the larger modification being made. This avoids
the can of worms that open-ended, transaction indepedent intents
expose....

> My early thought was that
> would be overkill for relogs that are more intended to facilitate
> unrelated progress (i.e. not pin the log tail) as opposed to track
> progress in a particular operation (i.e. dfops freed 1 extent out of a 2
> extent EFI, roll, complete the original EFI and create a new EFI with 1
> extent left). The item never really changes in the first case where it
> does in the second.

The EFI is probably a bad example here - they were designed to relog
the EFD on partial completion, not the EFI. i.e. the EFI can log an
aribtrary number of extents to free, the EFD gets relogged on each
extent free completion until all extents in the EFI are freed. The
EFI itself was never intended to be relogged in the situation you
describe above.(*)

So, essentially, the EFD is the reloggable object that tracks
completion, and so to relog an EFI, we could just  we could just
relog the original EFI with the current EFD state indicating how
much of the EFI had been completed. We already have to roll the
inode in each of the EFD committing transactions to prevent it from
pinning the tail of the log, so the EFI/EFD pair could easily be
relogged like this, too. (**)

But for intent/intent done pairs that aren't designed for a rolling
completion like the EFD are more problematic, especially if we
aren't actually logging a completion state but just relogging the
intent. If the work being done is not in the same transaction
context as the intent (i.e. independent transactions rather than a
rolling context), then the intent cannot be sanely relogged without
modification as there is work that is in the journal between the two
intents that cannot be tracked by the intent relogging.

i.e. if the intent falls off the tail of the log, then we have the
situation of having a partial operation already on stable storage
but no way of tracking how much work has been done. Hence I think we
must confine relogging of intents to a single permanent transaction
context, and intents that can get relogged must have an intent done
logged with them to indicate progress that has been made. And, of
course, log recovery will need mods to handle this, too.

(*) That iterative partial EFD completion was never implemented in
the original design - I don't know the reason as it's not in the
commit history - but I can guess that it was because the EFI pinned
the tail of the log and caused deadlocks when the log was small.
Accounting for this in reservations made the reservation size blow
out and so defeated the purpose of rolling transactions to keep the
reservation size down.

(**) We only ever log single extent EFIs even with defer ops because
of XFS_BUI_MAX_FAST_EXTENTS = 1.

> > commit d420e5c810bce5debce0238021b410d0ef99cf08
> > Author: Dave Chinner <dchinner@redhat.com>
> > Date:   Tue Oct 15 09:17:53 2013 +1100
> > 
> >     xfs: remove unused transaction callback variables
> >     
> >     We don't do callbacks at transaction commit time, no do we have any
> >     infrastructure to set up or run such callbacks, so remove the
> >     variables and typedefs for these operations. If we ever need to add
> >     callbacks, we can reintroduce the variables at that time.
> >     
> >     Signed-off-by: Dave Chinner <dchinner@redhat.com>
> >     Reviewed-by: Ben Myers <bpm@sgi.com>
> >     Signed-off-by: Ben Myers <bpm@sgi.com>
> > 
> > diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
> > index 09cf40b89e8c..71c835e9e810 100644
> > --- a/fs/xfs/xfs_trans.h
> > +++ b/fs/xfs/xfs_trans.h
> > @@ -85,18 +85,11 @@ struct xfs_item_ops {
> >  #define XFS_ITEM_LOCKED                2
> >  #define XFS_ITEM_FLUSHING      3
> >  
> > -/*
> > - * This is the type of function which can be given to xfs_trans_callback()
> > - * to be called upon the transaction's commit to disk.
> > - */
> > -typedef void (*xfs_trans_callback_t)(struct xfs_trans *, void *);
> > -
> >  /*
> >   * This is the structure maintained for every active transaction.
> >   */
> >  typedef struct xfs_trans {
> >         unsigned int            t_magic;        /* magic number */
> > -       xfs_log_callback_t      t_logcb;        /* log callback struct */
> >         unsigned int            t_type;         /* transaction type */
> >         unsigned int            t_log_res;      /* amt of log space resvd */
> >         unsigned int            t_log_count;    /* count for perm log res */
> > 
> > That's basically the functionality we want here - when the log item
> > hits the journal, we want a callback to tell us so we can relog it
> > ourselves if deemed necessary. i.e. it's time to reintroduce the
> > transaction/log commit callback infrastructure...
> > 
> 
> As noted earlier, this old mechanism is new to me.. This commit just
> appears to remove an unused hook and the surrounding commits don't look
> related. Was this previously used for something in particular?

This is how xfs_trans_committed() used to be attached to the
iclogbuf and called on completion. It was added back in 1994, and
only ever used to call xfs_trans_committed() in the XFS code. IIRC,
there was also an intent to use it in the CXFS metadata server to
co-ordinate internal server state with the on-disk filesystem state,
but I don't think it ever happened as cluster-wide state recovery
after a system/server crash was already huge problem for CXFS
without adding custom logging interactions to it...

The code, prior to it's removal as delayed logging didn't use it
anymore, was:

       /*
        * Tell the LM to call the transaction completion routine
        * when the log write with LSN commit_lsn completes (e.g.
        * when the transaction commit really hits the on-disk log).
        * After this call we cannot reference tp, because the call
        * can happen at any time and the call will free the transaction
        * structure pointed to by tp.  The only case where we call
        * the completion routine (xfs_trans_committed) directly is
        * if the log is turned off on a debug kernel or we're
        * running in simulation mode (the log is explicitly turned
        * off).
        */
       tp->t_logcb.cb_func = xfs_trans_committed;
       tp->t_logcb.cb_arg = tp;

       /*
        * We need to pass the iclog buffer which was used for the
        * transaction commit record into this function, and attach
        * the callback to it. The callback must be attached before
        * the items are unlocked to avoid racing with other threads
        * waiting for an item to unlock.
        */
       shutdown = xfs_log_notify(mp, commit_iclog, &(tp->t_logcb));

IOWs, we used to attach individual transactions directly to the
iclog to be called back from iclog completion and processed
directly. Essentially, it is a "commit is now stable" notification
mechanism.

> > This would get used in conjunction with a permanent transaction
> > reservation, allowing the owner of the object to keep it locked over
> > transaction commit (while whatever work is running between intent
> > and done), and the transaction commit turns into a trans_roll. Then
> > we reserve space for the next relogging commit, and go about our
> > business.
> > 
> 
> Hmm.. IIUC the original intent committer rolls instead of commits to
> reacquire relogging reservation, but what if the submitter needs to
> allocate and commit unrelated transactions before it gets to the point
> of completing the intent?

Not allowed. The intent + intent done must be committed as part of
the same rolling transaction sequence. Commiting an intent without a
reservation for the intent-done is a deadlock vector. i.e. intent
pins the tail of the log, can't reserve space for the intent-done to
remove it from the log.

Fundamentally, it is the responsibility of the running transaction
to ensure objects it logs do not pin the tail of the log and prevent
forwards progress of the transaction. The whole subsystem is
designed around this premise. Hence while I can see how automatic
relogging of intents like you've proposed is appealing, but it
doesn't follow the "forwards progress guarantee" rules that the
transactional model is built around.

Hence I think that if we have a long running intent that requires
relogging, it needs to be done under a single rolling transaction
context, not indepednent, unrelated transactions. We can roll
permanent transactions an unbound number of times (just think about
freeing several million extents in truncate) without penalty if they
follow the forwards progress rules, so the only thing we need to do
here is consider how to relog an intent pair for a specific
operation safely.

> I was originally thinking about "pre-reserving
> and donating" relogging reservation along these lines, but I thought
> reserving transactions like this (first for the intent+relog, then for
> whatever random transaction is next) was a potential deadlock vector.

This is what rolling transactions do. The reservation for any
specific transaction in a sequence is guaranteed to be enough to
for the next transaction in the sequence to run to completion.

> Perhaps it's not if the associated items have all been committed to the
> log subsystem. It also seemed unnecessary given our current design of
> worst case reservation sizes, but that's a separate topic and may only
> apply to intents (which are small compared to metadata associated with
> generic log items).
> 
> So are you suggesting ownership of the committed transaction transfers
> to the log subsystem somehow or another? For example, we internally roll
> and queue the _transaction_ (not the log item) for relogging while from
> the caller's perspective the transaction has committed? Or the
> additional reservation is pulled off and the transaction commits (i.e.
> frees)? Or something else?

Not internal. Subsystem adds a callback to the transaction it is
about to commit, that gets moved to the CIL context, when
the CIL commits and the iclog completion processing is done then
the CIL commit callbacks are run with whatever context the caller
attached to it.

> FWIW, I'm also wondering if this lends itself to some form of batching
> for if we get to the point of relogging a large number of small items.
> For example, consider a single dedicated/relogging transaction for many
> small (or related) intents vs. N independent transactions processing in
> the background. This is something that could came later once the
> fundamentals are worked out, however.

That's exactly the problem I see needing to be solved for the
"rebuild btrees in free space" type of long running operation that
repair will need to run.

i.e. an out-of-line btree rebuild that involves allocating space
that should be freed again if the rebuild fails or we crash during
the rebuild. Hence an EFI needs to be held for each allocation we
do until we get the tree rebuilt and do the atomic swap of the root
block. That atomic swap transaction also needs to commit all the
EFDs, as the space is now in use and we need to cancel the EFIs.(+)

Hence the rolling transaction will need to relog the primary "btree
rebuild in progress" intent/intent-done pair as well as all the all
the EFI/EFD pairs it holds for the extents it has allocated so far.
The subsystem will have to co-ordinate the intent commit callback
notification with it's ongoing transactional work that is done under
it's rolling transaction context.

IOWs, there's a whole lot more work needed than just updating a
single intent pair in "btree rebuild" situation like this. I also
don't really see how a "log internal" relogging mechanism based on
stealing reservations will be able to handle the complexity of
atomic multiple intent state updates. That requires
subsystem/application specific knowledge to understand the
relationship between all the intents that need to be relogged....

(+) The deferops and/or EFI code probably needs modification to
support non-freeing, delayed EFD processing like this - it needs to
log and track the intents it holds and relog them, but not free them
or run EFDs until a later point in time. i.e. it becomes 2-part
deferred op mechanism, with separate control of the intent-done
processing phase. I'd like to use this mechanism for DIO and
buffered writeback allocation (so we don't need to use unwritten
extents), but I haven't had time to dig into it yet...

> All in all this sounds interesting. I still need to grok the transaction
> reservation/ownership semantics you propose re: the questions above, but
> I do like the prospect of reusing existing mechanisms and thus being
> able to more easily handle generic log items. Thanks for the
> feedback...

Yeah, i'd much prefer to implement something that fits within the
existing model, too :)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
