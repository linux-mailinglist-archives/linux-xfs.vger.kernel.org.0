Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57AE632672C
	for <lists+linux-xfs@lfdr.de>; Fri, 26 Feb 2021 20:02:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbhBZTCh (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 26 Feb 2021 14:02:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:37780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229571AbhBZTCb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 26 Feb 2021 14:02:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F31A64ED5;
        Fri, 26 Feb 2021 19:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614366110;
        bh=ZY27hmFQxY3qs2z1DEUUS58dWpn3B+78r9d6l2WiK4c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u6nDDSPusRmPAp/vrEHKAm4Dcx7HJNN6YhzkGkYJ9SU4g0+Tuvid+SbTeQEabBSbB
         VNZuvcv9OfZpyAwCGGVT2EtfiqMGqhSJtA/rEUneZgzNI4opg/RnIFMDPPQ2g3y8Fz
         LcJ2eI/YhWGq5X/ceFBiogNZE31huN4dG2t4ENmTvhdaAvjObo0NIR/jFtQRamJgQx
         pTFtnjC1pnVE9ejA78FQ2Gc7E/E5EiWc9TXXpksdaYAglt8vnn3EaTBcdwlK7pbrFj
         JqoBBqOnwszxGv2mvK42fHC2Eklr+4Tch4gEqX1aRcEevC+XpLuj2AYODiju3gqzvn
         cvgDERRCVQrLA==
Date:   Fri, 26 Feb 2021 11:01:49 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] xfs: set aside allocation btree blocks from block
 reservation
Message-ID: <20210226190149.GC7272@magnolia>
References: <20210222152108.896178-1-bfoster@redhat.com>
 <20210222183408.GB7272@magnolia>
 <20210223121017.GA946926@bfoster>
 <20210224181453.GP7272@magnolia>
 <YDfgsLyjXRwZI8JS@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YDfgsLyjXRwZI8JS@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 25, 2021 at 12:38:56PM -0500, Brian Foster wrote:
> On Wed, Feb 24, 2021 at 10:14:53AM -0800, Darrick J. Wong wrote:
> > On Tue, Feb 23, 2021 at 07:10:17AM -0500, Brian Foster wrote:
> > > On Mon, Feb 22, 2021 at 10:34:08AM -0800, Darrick J. Wong wrote:
> > > > On Mon, Feb 22, 2021 at 10:21:08AM -0500, Brian Foster wrote:
> > > > > The blocks used for allocation btrees (bnobt and countbt) are
> > > > > technically considered free space. This is because as free space is
> > > > > used, allocbt blocks are removed and naturally become available for
> > > > > traditional allocation. However, this means that a significant
> > > > > portion of free space may consist of in-use btree blocks if free
> > > > > space is severely fragmented.
> > > > > 
> > > > > On large filesystems with large perag reservations, this can lead to
> > > > > a rare but nasty condition where a significant amount of physical
> > > > > free space is available, but the majority of actual usable blocks
> > > > > consist of in-use allocbt blocks. We have a record of a (~12TB, 32
> > > > > AG) filesystem with multiple AGs in a state with ~2.5GB or so free
> > > > > blocks tracked across ~300 total allocbt blocks, but effectively at
> > > > > 100% full because the the free space is entirely consumed by
> > > > > refcountbt perag reservation.
> > 
> > Hmm.  I'm still a bit confused by what's going on here.  Free space is
> > heavily fragmented and the bnobt/cntbt are very large, but what actually
> > triggers the (bug? customer escalation?) report?  Did the fs go offline?
> > Did fsync() suddenly start emitting errors?
> > 
> 
> It's a very odd scenario.. The original bug report complains about a
> shutdown in the xfs_btree_insert() code because of a record insertion
> failure. This is a bmbt record insertion on COW I/O completion
> (xfs_reflink_end_cow()) where we are remapping from the COW fork to the
> data fork. I believe the user was beating this fs against -ENOSPC for

Heh, knowing some of my customers I bet I'll encounter this in 5..4...

> whatever reason and IIRC I was never able to reproduce that particular
> error. What I did observe is that on the same filesystem I could write
> delalloc (i.e., not reflink related) past effective -ENOSPC because
> xfs_mod_fdblocks() would not fail before the eventual physical
> allocations would actually fail. This variant manifests in the form of
> writeback errors and dirty page discards because xfs_map_blocks() fails
> to allocate real blocks for cached delalloc extents. IMO, that is the
> fundamental bug and what this patch attempts to fix.

<nod>

> > (Sorry, I'm going to go wandering stream-of-consciousness now...)
> > 
> > > > Do the finobt/rmapbt per-ag reservations present similar challenges?
> > 
> > The refcountbt per-ag reservation code computes the difference between
> > the max btree size and the actual btree size, and subtracts that from
> > fdblocks.  The rmapbt reservation subtracts the entire reservation from
> > fdblocks because the rmapbt also lives in "free" space.  The finobt
> > reservation follows the rmapbt formula, so none of the three btrees
> > should be directly causing whatever's going on.
> > 
> > So I think the answer to my question is a tentative "no, because those
> > btrees already subtracted themselves from fdblocks" while I continue to
> > try to work out what's going on here...
> > 
> 
> Right, it's not a direct problem with any of the associated feature
> trees. The problem is indirect in that they simply have a large
> outstanding perag reservation, which basically means an AG can be
> effectively full (i.e. for data allocs) while it still tracks a good
> number of free (but reserved) blocks. If that free space happens to be
> fragmented, then we could have an elevated ->agf_btreeblks, which have
> not been removed from fdblocks.

<nod> Or put another way, I forgot to consider the indirect space
reservation needed to maintain the btree space reservations. :(

> > [narrator: No, he's wrong, let's watch him figure out why.]
> > 
> > > I think any large perag reservation can contribute to an elevated
> > > btreeblks count if free space is fragmented enough. That said, it's not
> > > clear to me that an elevated btreeblks count is enough to cause this
> > > problem. So far I've not been able to reproduce, but have only been able
> > > to play around with a filesystem that was already put into this state by
> > > a workload that seemingly made heavy/fragmented use of COW and
> > > persistently beat against -ENOSPC over time. For that reason I suspect
> > > COW remaps dipping into the reserve block pool may also be a
> > > contributing factor, but it's hard to say for sure. Given the
> > > circumstances, I opted to keep this isolated to reflink at least for the
> > > time being.
> > > 
> > > We could certainly enable the enforcement for any filesystem that
> > > requires perag reservation if we preferred to do that out of caution.
> > > The accounting logic is trivial and already unconditional. The one
> > > caveat to be aware of is that the enforcement is not effective until
> > > m_btree_blks is fully populated, which doesn't occur until each AGF has
> > > been read for the first time. This is not a problem for reflink and
> > > rmapbt because both of those features read the AGF at mount time to
> > > calculate the perag res.
> > > 
> > > The finobt perag res calculation only reads the AGIs atm, so we'd either
> > > want to also read the AGFs there as well (which is perhaps not such a
> > > big deal if we're already reading the AGIs), or perhaps just leave
> > > things as is, enforce by default, and hope (and document) that the
> > > counter is initialized in the cases where it's most important. I don't
> > > have a strong opinion on any of those particular options. Thoughts?
> > > 
> > > Brian
> > > 
> > > > --D
> > > > 
> > > > > Such a large perag reservation is by design on large filesystems.
> > > > > The problem is that because the free space is so fragmented, this AG
> > > > > contributes the 300 or so allocbt blocks to the global counters as
> > > > > free space.
> > 
> > How big is the refcount btree?
> > 
> > As an example scenario (with exaggerated/made up numbers), pretend our
> > filesystem has a single AG with 100 blocks.  The refcount btree consumes
> > 5 blocks, and the refcountbt reservation is 11 blocks.  Say there are 15
> > free blocks in the AG -- 6 individual blocks pointed to by the free
> > space btrees, 4 blocks used by the free space btrees, and 5 blocks in
> > the AGFL.  (Pretend that we actually need 2 blocks per tree to store 6
> > records.)
> > 
> > The 5 blocks actually in use by the refcount btree were subtracted from
> > fdblocks ages ago when we expanded the btree shape.
> > 
> 
> Right, those blocks are allocated and accounted for.
> 
> > The (11-5)==6 blocks remaining in the per-ag reservation were subtracted
> > from fdblocks at mount time, so this AG contributes (15-6)==9 blocks to
> > the incore fdblocks counter.
> > 
> 
> Ok.
> 
> > Unfortunately, those 9 "free" blocks aren't all free -- we're using four
> > freesp btree blocks to hold in reserve the 6 blocks for the refcount
> > btree.  Until we rearrange the free space btree or grow the refcount
> > btree to consume the rest of its reservation, we're never going to get
> > those four blocks back...
> > 
> 
> Right.
> 
> > > > > If this pattern repeats across enough AGs, the
> > > > > filesystem lands in a state where global block reservation can
> > > > > outrun physical block availability. For example, a streaming
> > > > > buffered write on the affected filesystem continues to allow delayed
> > > > > allocation beyond the point where writeback starts to fail due to
> > > > > physical block allocation failures. The expected behavior is for the
> > > > > delalloc block reservation to fail gracefully with -ENOSPC before
> > > > > physical block allocation failure is a possibility.
> > 
> > ...and then (continuing the scenario) a 9-block delalloc write comes
> > along and sees 9 free blocks, so it creates a reservation for 9 blocks.
> > When writeback kicks off it'll try to allocate those 9 blocks, but only
> > receives the 5 blocks that are on the AGFL.  Next it... runs around in
> > circles wondering where the other four blocks went?  Or maybe it just
> > ENOSPCs, but that's bad because delalloc was supposed to prevent ENOSPC
> > on writeback.  Either way it's bad news.
> > 
> 
> The writeback path basically assumes delalloc conversion should succeed
> one way or another. It can't guarantee delalloc extents map 1:1 to
> contiguous real allocations, but it expects the blocks to be available
> somehow or another. If not, we end up in xfs_discard_page() and throw
> away the data..
> 
> > > > > To address this problem, introduce a counter to track the sum of the
> > > > > allocbt block counters already tracked in the AGF. Use the new
> > 
> > Ahh, ok.  I think I grok what this patch does now.  XFS (prior to per-ag
> > space reservations) counts all the space used by the free space btrees
> > as free space, which means that a delalloc reservation expects to be
> > able to consume both the free space in the tree as well as the tree
> > itself.
> > 
> > Now we use the free space btrees to hold space for future metadata
> > expansions, so the expectation above no longer holds.  Hence subtracting
> > agf_btreeblks from fdblocks at mount time.
> > 
> > With that in mind, the finobt and rmapbt reservations are no different
> > from the refcountbt reservation -- the unused-but-reserved space for all
> > three reservations are held in the free space btrees, so they all need
> > this now.  The answer to my question is "yes, they need it too".
> > 
> 
> Ok, that sounds reasonable.
> 
> > With that in mind, should xfs_ag_resv_init be responsible for
> > subtracting agf_btreeblocks from fdblocks if there are any reservations?
> > 
> 
> I'd have to think it through as the perag res code tends to confuse me,
> but at a glance that sounds like a potential option. That said, what's
> the advantage? Would that imply that subsequent runtime allocbt
> allocations need also pass through xfs_mod_fdblocks()? I admit I'm a
> little weary of fundamentally changing how blocks for core structures
> like the allocbt are tracked, particularly for such an unlikely corner
> case. For that reason, I do like the simplicity of the track and set
> aside model...

I was thinking of something simpler than creating a new XFS_AG_RESV
type, if that's what you were thinking.

Now that we know that we have to subtract the free space btree blocks
from fdblocks for any AG that has a reservation, I think it makes the
most sense to wrap the m_btree_blks accounting code in xfs_ag_resv.c.

bool xfs_ag_has_resv(struct xfs_perag *pag)
{
	return  pag->pag_meta_resv.ar_asked > 0 ||
		pag->pag_rmapbt_resv.ar_asked > 0;
}

void xfs_ag_resv_allocbt_delta(struct xfs_perag *pag, s64 delta)
{
	if (xfs_ag_has_resv(pag))
		atomic64_add(delta, &mp->m_btree_blks);
}

And call that from xfs_allocbt_{alloc,free}_block.

Then move the initialization of m_btree_blks from the pagf_init code
into xfs_ag_resv_init, because that function already knows whether or
not we made reservations, and therefore how much to add to m_btree_blks.

	/* Create the metadata reservation. */
	if (pag->pag_meta_resv.ar_asked == 0) {...}

	/* Create the RMAPBT metadata reservation */
	if (pag->pag_rmapbt_resv.ar_asked == 0) {...}

	/*
	 * Blocks reserved for metadata btree reservations are held in
	 * the free space btree, which effectively means that the free
	 * space btrees themselves become part of the reservation.  Add
	 * the size of /only/ the free space btrees to what we withhold
	 * from the fdblocks count that we present to userspace.  (We
	 * already reserved the space that the rmapbt wants.)
	 */
	if (xfs_ag_has_resv(pag)) {
		xfs_alloc_pagf_init(...);

		allocbt_resv =  pag->pagf_btreeblks -
				pag->pag_rmapbt_resv.ar_asked;

		atomic64_add(allocbt_resv, &mp->m_btree_blks);
	}

> > > > > counter to set these blocks aside at reservation time and thus
> > > > > ensure they cannot be allocated until truly available. Since this is
> > > > > only necessary when large reflink perag reservations are in place
> > > > > and the counter requires a read of each AGF to fully populate, only
> > > > > enforce on reflink enabled filesystems. This allows initialization
> > > > > of the counter at ->pagf_init time because the refcountbt perag
> > > > > reservation init code reads each AGF at mount time.

By the way, should we be subtracting m_btree_blks from b_avail in
statvfs?

> > > > > 
> > > > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > > > ---
> > > > > 
> > > > > v2:
> > > > > - Use an atomic counter instead of a percpu counter.
> > > > > v1: https://lore.kernel.org/linux-xfs/20210217132339.651020-1-bfoster@redhat.com/
> > > > > 
> > > > >  fs/xfs/libxfs/xfs_alloc.c |  3 +++
> > > > >  fs/xfs/xfs_mount.c        | 15 ++++++++++++++-
> > > > >  fs/xfs/xfs_mount.h        |  6 ++++++
> > > > >  3 files changed, 23 insertions(+), 1 deletion(-)
> > > > > 
> > > > > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > > > > index 0c623d3c1036..fb3d36cad173 100644
> > > > > --- a/fs/xfs/libxfs/xfs_alloc.c
> > > > > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > > > > @@ -2746,6 +2746,7 @@ xfs_alloc_get_freelist(
> > > > >  	if (btreeblk) {
> > > > >  		be32_add_cpu(&agf->agf_btreeblks, 1);
> > > > >  		pag->pagf_btreeblks++;
> > > > > +		atomic64_inc(&mp->m_btree_blks);
> > > > >  		logflags |= XFS_AGF_BTREEBLKS;
> > > > >  	}
> > > > >  
> > > > > @@ -2853,6 +2854,7 @@ xfs_alloc_put_freelist(
> > > > >  	if (btreeblk) {
> > > > >  		be32_add_cpu(&agf->agf_btreeblks, -1);
> > > > >  		pag->pagf_btreeblks--;
> > > > > +		atomic64_dec(&mp->m_btree_blks);
> > > > >  		logflags |= XFS_AGF_BTREEBLKS;
> > > > >  	}
> > > > >  
> > > > > @@ -3055,6 +3057,7 @@ xfs_alloc_read_agf(
> > > > >  	if (!pag->pagf_init) {
> > > > >  		pag->pagf_freeblks = be32_to_cpu(agf->agf_freeblks);
> > > > >  		pag->pagf_btreeblks = be32_to_cpu(agf->agf_btreeblks);
> > > > > +		atomic64_add(pag->pagf_btreeblks, &mp->m_btree_blks);
> > 
> > Come to think of it, this isn't quite correct -- rmapbt blocks are
> > counted in agf_btreeblks and separately in agf_rmap_blocks.  At mount
> > time, the rmapbt per-ag reservation subtracts the entire rmapbt
> > reservation from fdblocks (not just agf_rmap_blocks), so this
> > effectively double-charges fdblocks for the rmap btree.
> > 
> 
> Not sure I follow.. this counter just tracks the sum of of
> ->agf_btreeblks. I see what you mean that __xfs_ag_resv_init() doesn't
> subtract the used value for XFS_AG_RESV_RMAPBT. So are you saying that
> some portion of this total btree block counter includes
> ->agf_rmap_blocks, those blocks have been already reserved, and
> therefore should not be part of set_aside in xfs_mod_fdblocks()?

Yes.

> If so, I _think_ I follow, and I suspect that would require a separate
> global counter to remove the rmap blocks from the set_aside bit. That
> said, I am a little confused by the rmapbt reservation in this regard.
> It sounds like it already double accounts at mount time by reserving
> already used blocks.

It doesn't double count, because the blocks used by the rmapbt are (for
better or worse) accounted on disk in exactly the same way as the free
space btree blocks.  IOWs, the blocks used by the rmap btree are not
subtracted from fdblocks.

> If that is because those blocks are always shown as free (thus used
> blocks are not actually double accounted), does that mean we could
> drop the used portion of the mount time reservation by including the
> used blocks in the set_aside value instead?

Er... I thought the set_aside value is static?

--D

> Brian
> 
> > --D
> > 
> > > > >  		pag->pagf_flcount = be32_to_cpu(agf->agf_flcount);
> > > > >  		pag->pagf_longest = be32_to_cpu(agf->agf_longest);
> > > > >  		pag->pagf_levels[XFS_BTNUM_BNOi] =
> > > > > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > > > > index 52370d0a3f43..16482e02da01 100644
> > > > > --- a/fs/xfs/xfs_mount.c
> > > > > +++ b/fs/xfs/xfs_mount.c
> > > > > @@ -1178,6 +1178,7 @@ xfs_mod_fdblocks(
> > > > >  	int64_t			lcounter;
> > > > >  	long long		res_used;
> > > > >  	s32			batch;
> > > > > +	uint64_t		set_aside = mp->m_alloc_set_aside;
> > > > >  
> > > > >  	if (delta > 0) {
> > > > >  		/*
> > > > > @@ -1217,8 +1218,20 @@ xfs_mod_fdblocks(
> > > > >  	else
> > > > >  		batch = XFS_FDBLOCKS_BATCH;
> > > > >  
> > > > > +	/*
> > > > > +	 * Set aside allocbt blocks on reflink filesystems because COW remaps
> > > > > +	 * can dip into the reserved block pool. This is problematic if free
> > > > > +	 * space is fragmented and m_fdblocks tracks a significant number of
> > > > > +	 * allocbt blocks. Note this also ensures the counter is accurate before
> > > > > +	 * the filesystem is active because perag reservation reads all AGFs at
> > > > > +	 * mount time. The only call prior to that is to populate the reserve
> > > > > +	 * pool itself.
> > > > > +	 */
> > > > > +	if (xfs_sb_version_hasreflink(&mp->m_sb))
> > > > > +		set_aside += atomic64_read(&mp->m_btree_blks);
> > > > > +
> > > > >  	percpu_counter_add_batch(&mp->m_fdblocks, delta, batch);
> > > > > -	if (__percpu_counter_compare(&mp->m_fdblocks, mp->m_alloc_set_aside,
> > > > > +	if (__percpu_counter_compare(&mp->m_fdblocks, set_aside,
> > > > >  				     XFS_FDBLOCKS_BATCH) >= 0) {
> > > > >  		/* we had space! */
> > > > >  		return 0;
> > > > > diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> > > > > index 659ad95fe3e0..70e1dd6b538a 100644
> > > > > --- a/fs/xfs/xfs_mount.h
> > > > > +++ b/fs/xfs/xfs_mount.h
> > > > > @@ -170,6 +170,12 @@ typedef struct xfs_mount {
> > > > >  	 * extents or anything related to the rt device.
> > > > >  	 */
> > > > >  	struct percpu_counter	m_delalloc_blks;
> > > > > +	/*
> > > > > +	 * Optional count of btree blocks in use across all AGs. Only used when
> > > > > +	 * reflink is enabled. Helps prevent block reservation from attempting
> > > > > +	 * to reserve allocation btree blocks.
> > > > > +	 */
> > > > > +	atomic64_t		m_btree_blks;
> > > > >  
> > > > >  	struct radix_tree_root	m_perag_tree;	/* per-ag accounting info */
> > > > >  	spinlock_t		m_perag_lock;	/* lock for m_perag_tree */
> > > > > -- 
> > > > > 2.26.2
> > > > > 
> > > > 
> > > 
> > 
> 
