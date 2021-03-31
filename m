Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7989346F2E
	for <lists+linux-xfs@lfdr.de>; Wed, 24 Mar 2021 03:05:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234721AbhCXCEb (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 23 Mar 2021 22:04:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:36570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231981AbhCXCEJ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Mar 2021 22:04:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99585619E9;
        Wed, 24 Mar 2021 02:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616551448;
        bh=MwAW+v7vtzcrSobKyVv2cZiy2w3dBpEYMZPOjuufDGo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rlvqG71amipOOYTv2Obv7C/63EA/DkCWslBFag2QlEGD2VegZ4XV+mZfT0gbK4Amm
         Kfxa+FbC4+xsdTd8qMguxmH/0/NqpJwU4yKImd7Ccc77/elpcY6jwR+/JhkHVveZng
         3aKdVubuTfIdFalM0/uGcF34ZuNfY7euWgFo1XwsRBJpbOyy7GOVXCDVtlC9t2vnjU
         op4zhgepde5lpDfVA8vowHkIvxp4JdXKWPvgizKCYz9+0YtzvbnfZfdodI+BEa4dAf
         T/eBgnn3ROA88UES52unVDOZ2k9NDEbfgb0YPTurui9BsBjbNXzbL+me2SC2bTqmPq
         WjI8mmVzS2CEw==
Date:   Tue, 23 Mar 2021 19:04:07 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/11] xfs: deferred inode inactivation
Message-ID: <20210324020407.GO22100@magnolia>
References: <161543194009.1947934.9910987247994410125.stgit@magnolia>
 <161543197372.1947934.1230576164438094965.stgit@magnolia>
 <20210323014417.GC63242@dread.disaster.area>
 <20210323040037.GI22100@magnolia>
 <20210323051907.GE63242@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210323051907.GE63242@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 23, 2021 at 04:19:07PM +1100, Dave Chinner wrote:
> On Mon, Mar 22, 2021 at 09:00:37PM -0700, Darrick J. Wong wrote:
> > On Tue, Mar 23, 2021 at 12:44:17PM +1100, Dave Chinner wrote:
> > > On Wed, Mar 10, 2021 at 07:06:13PM -0800, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > Instead of calling xfs_inactive directly from xfs_fs_destroy_inode,
> > > > defer the inactivation phase to a separate workqueue.  With this we
> > > > avoid blocking memory reclaim on filesystem metadata updates that are
> > > > necessary to free an in-core inode, such as post-eof block freeing, COW
> > > > staging extent freeing, and truncating and freeing unlinked inodes.  Now
> > > > that work is deferred to a workqueue where we can do the freeing in
> > > > batches.
> > > > 
> > > > We introduce two new inode flags -- NEEDS_INACTIVE and INACTIVATING.
> > > > The first flag helps our worker find inodes needing inactivation, and
> > > > the second flag marks inodes that are in the process of being
> > > > inactivated.  A concurrent xfs_iget on the inode can still resurrect the
> > > > inode by clearing NEEDS_INACTIVE (or bailing if INACTIVATING is set).
> > > > 
> > > > Unfortunately, deferring the inactivation has one huge downside --
> > > > eventual consistency.  Since all the freeing is deferred to a worker
> > > > thread, one can rm a file but the space doesn't come back immediately.
> > > > This can cause some odd side effects with quota accounting and statfs,
> > > > so we also force inactivation scans in order to maintain the existing
> > > > behaviors, at least outwardly.
> > > > 
> > > > For this patch we'll set the delay to zero to mimic the old timing as
> > > > much as possible; in the next patch we'll play with different delay
> > > > settings.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ....
> > > > diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
> > > > index a2a407039227..3a3baf56198b 100644
> > > > --- a/fs/xfs/xfs_fsops.c
> > > > +++ b/fs/xfs/xfs_fsops.c
> > > > @@ -19,6 +19,8 @@
> > > >  #include "xfs_log.h"
> > > >  #include "xfs_ag.h"
> > > >  #include "xfs_ag_resv.h"
> > > > +#include "xfs_inode.h"
> > > > +#include "xfs_icache.h"
> > > >  
> > > >  /*
> > > >   * growfs operations
> > > > @@ -290,6 +292,13 @@ xfs_fs_counts(
> > > >  	xfs_mount_t		*mp,
> > > >  	xfs_fsop_counts_t	*cnt)
> > > >  {
> > > > +	/*
> > > > +	 * Process all the queued file and speculative preallocation cleanup so
> > > > +	 * that the counter values we report here do not incorporate any
> > > > +	 * resources that were previously deleted.
> > > > +	 */
> > > > +	xfs_inodegc_force(mp);
> > > 
> > > xfs_fs_counts() is supposed to be a quick, non-blocking summary of
> > > the state - it can never supply userspace with accurate values
> > > because they are wrong even before the ioctl returns to userspace.
> > > Hence we do not attempt to make them correct, just use a fast, point
> > > in time sample of the current counter values.
> > > 
> > > So this seems like an unnecessarily heavyweight operation
> > > to add to this function....
> > 
> > I agree, xfs_inodegc_force is a heavyweight operation to add to statvfs
> > and (further down) the quota reporting ioctl.  I added these calls to
> > maintain the user-visible behavior that one can df a mount, rm -rf a
> > 30T directory tree, df again, and observe a 30T difference in available
> > space between the two df calls.
> >
> > There are a lot of fstests that require this kind of behavior to pass.
> > In my internal testing without this bit applied, I also got complaints
> > about breaking the user-behavior of XFS that people have gotten used to.
> 
> Yeah, that's messy, but I see a potential problem here with space
> monitoring apps that poll the filesystem frequently to check space
> usage. That's going to override whatever your background "do work"
> setting is going to be...
> 
> > Earlier revisions of this patchset tried to maintain counts of the
> > resources used by the inactivated inode so that we could adjust the
> > values reported by statvfs and the quota reporting ioctl.  This meant we
> > didn't have to delay either call at all, but it turns out that it's
> > not feasible to maintain an accurate count of inactive resources because
> > any resources that are shared at destroy_inode time cannot become part
> > of this liar counter and consulting the refcountbt to decide which
> > extents should be added just makes unlinking even slower.  Worse yet,
> > unsharing of shared blocks attached to queued inactive inodes implies
> > either that we have to update the liar counter or that we have to be ok
> > with the free block count fluctuating for a while after a deletion if
> > that deletion ends up freeing more space than the liar counter thinks
> > we can free by flushing inactivation.
> 
> So the main problem is block accounting. Non-reflink stuff is easy
> (the equivalent of delalloc accounting) but reflink is hard.
> 
> > Hmm, maybe this could maintain an approxiate liar counter and only flush
> > inactivation when the liar counter would cause us to be off by more than
> > some configurable amount?  The fstests that care about free space
> > accounting are not going to be happy since they are measured with very
> > tight tolerances.
> 
> I'd prefer something that doesn't require a magic heuristic. I don't
> have any better ideas right now, so let's just go with what you have
> and see what falls out...

Ok.  I'll leave a comment to this effect.

> > > > @@ -233,6 +242,94 @@ xfs_inode_clear_reclaim_tag(
> > > >  	xfs_perag_clear_reclaim_tag(pag);
> > > >  }
> > > >  
> > > > +/* Queue a new inode gc pass if there are inodes needing inactivation. */
> > > > +static void
> > > > +xfs_inodegc_queue(
> > > > +	struct xfs_mount        *mp)
> > > > +{
> > > > +	rcu_read_lock();
> > > > +	if (radix_tree_tagged(&mp->m_perag_tree, XFS_ICI_INACTIVE_TAG))
> > > > +		queue_delayed_work(mp->m_gc_workqueue, &mp->m_inodegc_work,
> > > > +				2 * HZ);
> > > > +	rcu_read_unlock();
> > > > +}
> > > 
> > > Why half a second and not something referenced against the inode
> > > reclaim/sync period?
> > 
> > It's actually 2 seconds, and the next patch adds a knob to tweak the
> > default value.
> 
> Ugh, 2 * HZ != 2Hz. Stupid bad generic timer code, always trips me
> over.
> 
> > The first version of this patchset from 2017 actually did just use
> > (6 * xfs_syncd_centisecs / 10) like reclaim does.  This turned out to be
> > pretty foolish because that meant that reclaim and inactivation would
> > start at the same time, and because inactivation is slow, most of them
> > would miss the reclaim window and sit around pointlessly until the
> > next one.
> > 
> > The next iteration from mid 2019 changed this to (xfs_syncd_centisecs/5)
> > which fixed that, but large deltree storms could lead to so many inodes
> > being inactivated that we'd still miss the reclaim window sometimes.
> > Around this time I got my djwong-dev tree hooked up to the ktest robot
> > and it started complaining about performance regressions and noticeably
> > higher slab usage for xfs inodes and log items.
> 
> Right, I was thinking more along the lines of "run inactivation
> twice for every background inode reclaim pass". It's clear that what
> you were struggling with was that the interaction between the two
> running at similar periods is not good, and hence no matter what the
> background reclaim period is, we should process inactivated inodes a
> at least a couple of times per reclaim period...
> 
> > The next time I got back to this was shortly after Dave cleaned up the
> > reclaim behavior (2020) to be driven by the AIL, which mostly fixed the
> > performance complaints, except for the one about AIM7.  I was intrigued
> > enough by this to instrument the patchset and fstests and the fstests
> > cloud hosts <cough> to see if I could derive a reasonable default value.
> > 
> > I've observed through experimentation that 2 seconds seems like a good
> > default value -- it's long enough to enable a lot of batching of
> > inactive inodes, but short enough that the background thread can
> > throttle the foreground threads by competing for the log grant heads.
> 
> Right, it ends up about 2x per reclaim period by default. :)
> 
> > I also noticed that the amount of overhead introduced by background
> > inactivation (as measured by fstests run times and other <cough>
> > performance tests) ranged from minimal at 0 seconds to about 20% at
> > (6*xfs_syncd_centisecs/10).
> 
> Which is about 20s period. yeah, that's way too long...
> 
> > Honestly, this could just be zero.  Assuming your distro has power
> > efficient workqueues enabled, the ~4-10ms delay introduced by that is
> > enough to realize some batching advantage with zero noticeable effect on
> > performance.
> 
> Yeah, the main benefit is moving it into the background so that the
> syscall completion isn't running the entire inode inactivation pass.
> That moves almost 50% of the unlink processing off to another thread
> which is what we want for rm -rf workloads. Keeping the batch size
> small is probably the best place to start with this - just enough
> inodes to keep a CPU busy for a scheduler tick?

Yeah, I'll set it to a tick ... in the next patch, when we actually set
a real delay.

> 
> > > >  static void
> > > >  xfs_inew_wait(
> > > >  	struct xfs_inode	*ip)
> > > > @@ -298,6 +395,13 @@ xfs_iget_check_free_state(
> > > >  	struct xfs_inode	*ip,
> > > >  	int			flags)
> > > >  {
> > > > +	/*
> > > > +	 * Unlinked inodes awaiting inactivation must not be reused until we
> > > > +	 * have a chance to clear the on-disk metadata.
> > > > +	 */
> > > > +	if (VFS_I(ip)->i_nlink == 0 && (ip->i_flags & XFS_NEED_INACTIVE))
> > > > +		return -ENOENT;
> > > > +
> > > >  	if (flags & XFS_IGET_CREATE) {
> > > >  		/* should be a free inode */
> > > >  		if (VFS_I(ip)->i_mode != 0) {
> > > 
> > > How do we get here with an XFS_NEED_INACTIVE inode?
> > > xfs_iget_check_free_state() is only called from the cache miss path,
> > 
> > You added it to xfs_iget_cache_hit in 2018, commit afca6c5b2595f...
> 
> Oh, cscope fail:
> 
>   File             Function                  Line
> 0 xfs/xfs_icache.c xfs_iget_check_free_state 297 xfs_iget_check_free_state(
> 1 xfs/xfs_icache.c __releases                378 error = xfs_iget_check_free_state(ip, flags);
> 2 xfs/xfs_icache.c xfs_iget_cache_miss       530 error = xfs_iget_check_free_state(ip, flags);
> 
> "__releases" is a sparse annotation, so it didn't trigger that this
> was actually in xfs_iget_cache_hit()...
> 
> Never mind...
> 
> > > > @@ -713,6 +904,43 @@ xfs_icache_inode_is_allocated(
> > > >  	return 0;
> > > >  }
> > > >  
> > > > +/*
> > > > + * Grab the inode for inactivation exclusively.
> > > > + * Return true if we grabbed it.
> > > > + */
> > > > +static bool
> > > > +xfs_inactive_grab(
> > > > +	struct xfs_inode	*ip)
> > > > +{
> > > > +	ASSERT(rcu_read_lock_held());
> > > > +
> > > > +	/* quick check for stale RCU freed inode */
> > > > +	if (!ip->i_ino)
> > > > +		return false;
> > > > +
> > > > +	/*
> > > > +	 * The radix tree lock here protects a thread in xfs_iget from racing
> > > > +	 * with us starting reclaim on the inode.
> > > > +	 *
> > > > +	 * Due to RCU lookup, we may find inodes that have been freed and only
> > > > +	 * have XFS_IRECLAIM set.  Indeed, we may see reallocated inodes that
> > > > +	 * aren't candidates for reclaim at all, so we must check the
> > > > +	 * XFS_IRECLAIMABLE is set first before proceeding to reclaim.
> > > > +	 * Obviously if XFS_NEED_INACTIVE isn't set then we ignore this inode.
> > > > +	 */
> > > > +	spin_lock(&ip->i_flags_lock);
> > > > +	if (!(ip->i_flags & XFS_NEED_INACTIVE) ||
> > > > +	    (ip->i_flags & XFS_INACTIVATING)) {
> > > > +		/* not a inactivation candidate. */
> > > > +		spin_unlock(&ip->i_flags_lock);
> > > > +		return false;
> > > > +	}
> > > > +
> > > > +	ip->i_flags |= XFS_INACTIVATING;
> > > > +	spin_unlock(&ip->i_flags_lock);
> > > > +	return true;
> > > > +}
> > > > +
> > > >  /*
> > > >   * The inode lookup is done in batches to keep the amount of lock traffic and
> > > >   * radix tree lookups to a minimum. The batch size is a trade off between
> > > > @@ -736,6 +964,9 @@ xfs_inode_walk_ag_grab(
> > > >  
> > > >  	ASSERT(rcu_read_lock_held());
> > > >  
> > > > +	if (flags & XFS_INODE_WALK_INACTIVE)
> > > > +		return xfs_inactive_grab(ip);
> > > > +
> > > 
> > > Hmmm. This doesn't actually grab the inode. It's an unreferenced
> > > inode walk, in a function that assumes that the grab() call returns
> > > a referenced inode. Why isn't this using the inode reclaim walk
> > > which is intended to walk unreferenced inodes?
> > 
> > Because I thought that some day you might want to rebase the inode
> > reclaim cleanups from 2019 and didn't want to slow either of us down by
> > forcing a gigantic rebase.  So I left the duplicative inode walk
> > functions.
> > 
> > FWIW these are current separate functions with separate call sites in
> > xfs_inode_walk_ag since the "remove indirect calls from inode walk"
> > series made it more convenient to have a separate function for each tag.
> > 
> > As for the name ... reclaim also has a "grab" function even though it
> > walks unreferenced inodes.
> 
> Sure, but the reclaim code was always a special "unreferenced"
> lookup that just used the same code structure. It never mixed
> "igrab()" with unreferenced inode pinning...

Hmm well so long as I'm adding another patch to consolidate the reclaim
loop with xfs_inodes_walk, maybe I'll just rename it to
"selected_for_walk()" so then the code will read:

	if (done || !selected_for_walk(tag, ip))
		batch[i] = NULL;

> > > > +xfs_inactive_inode(
> > > > +	struct xfs_inode	*ip,
> > > > +	void			*args)
> > > > +{
> > > > +	struct xfs_eofblocks	*eofb = args;
> > > > +	struct xfs_perag	*pag;
> > > > +
> > > > +	ASSERT(ip->i_mount->m_super->s_writers.frozen < SB_FREEZE_FS);
> > > 
> > > What condition is this trying to catch? It's something to do with
> > > freeze, but you haven't documented what happens to inodes with
> > > pending inactivation when a freeze is started....
> > 
> > Inactivation creates transactions, which means that we should never be
> > running this at FREEZE_FS time.  IOWs, it's a check that we can never
> > stall a kernel thread indefinitely because the fs is frozen.
> 
> What's the problem with doing that to a dedicated worker thread?  We
> currently stall inactivation on a frozen filesystem if a transaction
> is required

It seems unnecessary to wedge a worker thread like that when I could
just cancel the work and reschedule it after the freeze...

> > We can continue to queue inodes for inactivation on a frozen filesystem,
> > and I was trying to avoid touching the umount lock in
> > xfs_perag_set_inactive_tag to find out if the fs is actually frozen and
> > therefore we shouldn't call xfs_inodegc_queue.
> 
> I think stopping background inactivation for frozen filesystems make
> more sense than this...

...oh hey, you seem to have reached the same conclusion. :)

> > > > +
> > > > +	/*
> > > > +	 * Not a match for our passed in scan filter?  Put it back on the shelf
> > > > +	 * and move on.
> > > > +	 */
> > > > +	spin_lock(&ip->i_flags_lock);
> > > > +	if (!xfs_inode_matches_eofb(ip, eofb)) {
> > > > +		ip->i_flags &= ~XFS_INACTIVATING;
> > > > +		spin_unlock(&ip->i_flags_lock);
> > > > +		return 0;
> > > > +	}
> > > > +	spin_unlock(&ip->i_flags_lock);
> > > 
> > > IDGI. What do EOF blocks have to do with running inode inactivation
> > > on this inode?
> > 
> > This enables foreground threads that hit EDQUOT to look for inodes to
> > inactivate in order to free up quota'd resources.
> 
> Not very obvious - better comment, please?

	/*
	 * Foreground threads that have hit ENOSPC or EDQUOT are allowed
	 * to pass in a eofb structure to look for inodes to inactivate
	 * immediately to free some resources.  If this inode isn't a
	 * match, put it back on the shelf and move on.
	 */

Better?

> > > I can't tell why this is necessary given what
> > > xfs_unmount_flush_inodes() does. Or, alternatively, why
> > > xfs_unmount_flush_inodes() can do what it does without caring about
> > > per-ag space reservations....
> > > 
> > > > diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> > > > index ca1b57d291dc..0f9a1450fe0e 100644
> > > > --- a/fs/xfs/xfs_qm_syscalls.c
> > > > +++ b/fs/xfs/xfs_qm_syscalls.c
> > > > @@ -104,6 +104,12 @@ xfs_qm_scall_quotaoff(
> > > >  	uint			inactivate_flags;
> > > >  	struct xfs_qoff_logitem	*qoffstart = NULL;
> > > >  
> > > > +	/*
> > > > +	 * Clean up the inactive list before we turn quota off, to reduce the
> > > > +	 * amount of quotaoff work we have to do with the mutex held.
> > > > +	 */
> > > > +	xfs_inodegc_force(mp);
> > > > +
> > > 
> > > Hmmm. why not just stop background inactivation altogether while
> > > quotaoff runs? i.e. just do normal, inline inactivation when
> > > quotaoff is running, and then we can get rid of the whole "drop
> > > dquot references" issue that background inactivation has...
> > 
> > I suppose that would have an advantage that quotaoff could switch to
> > foreground inactivation, flush the pending inactivation work to release
> > the dquot references, and then dqflush_all to dump the dquots
> > altogether.
> > 
> > How do we add the ability to switch behaviors, though?  The usual percpu
> > rwsem that protects a flag?
> 
> That's overkill.  Global synchronisation doesn't need complex
> structures, just a low cost reader path.
> 
> All we need is an atomic bit that we can test via test_bit().
> test_bit() is not a locked operation, but it is atomic. Hence most
> of the time it is a shared cacheline and hence has near zero cost to
> check as it can be shared across all CPUs.
> 
> Set the flag to turn off background inactivation, then all future
> inactivations will be foreground. Then flush and stop the inodegc
> work queue.  When we finish processing the last inactivated inode,
> the background work stops (i.e. it is not requeued).  No more
> pending background work.
> 
> Clear the flag to turn background inactivation back on. The first
> inode queued will restart that background work...
> 
> > > > @@ -1720,6 +1749,13 @@ xfs_remount_ro(
> > > >  		return error;
> > > >  	}
> > > >  
> > > > +	/*
> > > > +	 * Perform all on-disk metadata updates required to inactivate inodes.
> > > > +	 * Since this can involve finobt updates, do it now before we lose the
> > > > +	 * per-AG space reservations.
> > > > +	 */
> > > > +	xfs_inodegc_force(mp);
> > > 
> > > Should we stop background inactivation, because we can't make
> > > modifications anymore and hence background inactication makes little
> > > sense...
> > 
> > We don't actually stop background gc transactions or other internal
> > updates on readonly filesystems
> 
> Yes we do - that's what xfs_blockgc_stop() higher up in this
> function does. xfs_log_clean() further down in the function also
> stops the background log work (that covers the log when idle)
> because xfs_remount_ro() leaves the log clean.
> 
> THese all get restarted in xfs_remount_rw()....
> 
> > -- the ro part means only that we don't
> > let /userspace/ change anything directly.  If you open a file readonly,
> > unlink it, freeze the fs, and close the file, we'll still free it.
> 
> How do you unlink the file on a RO mount?

I got confused here.  If you open a file readonly on a rw mount, unlink
it, remount the fs readonly, and close the file, we'll still free it.

> And if it's a rw mount that is frozen, it will block on the first
> transaction in the inactivation process from close(), and block
> there until the filesystem is unfrozen.
> 
> It's pretty clear to me that we want frozen filesystems to
> turn off background inactivation so that we can block things like
> this in the syscall context and not have to deal with the complexity
> of freeze or read-only mounts in the background inactivation code at
> all..

Ok, will do.

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
