Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA2EC46CA49
	for <lists+linux-xfs@lfdr.de>; Wed,  8 Dec 2021 02:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243186AbhLHByK (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 7 Dec 2021 20:54:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243209AbhLHByI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Dec 2021 20:54:08 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B017FC0617A1
        for <linux-xfs@vger.kernel.org>; Tue,  7 Dec 2021 17:50:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A2367CE1F7B
        for <linux-xfs@vger.kernel.org>; Wed,  8 Dec 2021 01:50:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE45C341C8;
        Wed,  8 Dec 2021 01:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638928232;
        bh=rXfrvb7f70YTQWbCMoSF6tDnpwNvju+2cA9fxdVBXWA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fn6bgg/M1kfFOMKxfqOCDaPaaioqzAdqzqn8j0hLX/J94Y8a8c3mqoh7rQP8Y4FW0
         ofETqdIDTCjq/Lx7yNpVOgg/GD8JRKbbF9bvanEfZTNR34kH7friPMnsXyO75eMiq1
         aLfMqKrhXuY9uPLu2om09mhbN+RTYIsHWYScNHvY/b1jbOfAFfxLs7eTMgfNrbuBbi
         tfvTDkTXE4JLQJK1G5tsPwOpVummoyCDyRXrJwf3DLMy6lbjRr6+prsFIo0lbZZ+vH
         vEIWxcYfctNR1PT52ZBZTsDCV4su9Gw/CC2cMhF1Xwj8zhIPmgfGib5tFmy3ePDE5D
         nlvrvJuR21E/w==
Date:   Tue, 7 Dec 2021 17:50:32 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, wen.gang.wang@oracle.com
Subject: Re: [PATCH 2/2] xfs: only run COW extent recovery when there are no
 live extents
Message-ID: <20211208015032.GS8467@magnolia>
References: <163890213974.3375879.451653865403812137.stgit@magnolia>
 <163890215109.3375879.3278003521122932642.stgit@magnolia>
 <20211207222109.GL449541@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211207222109.GL449541@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Dec 08, 2021 at 09:21:09AM +1100, Dave Chinner wrote:
> On Tue, Dec 07, 2021 at 10:35:51AM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > As part of multiple customer escalations due to file data corruption
> > after copy on write operations, I wrote some fstests that use fsstress
> > to hammer on COW to shake things loose.  Regrettably, I caught some
> > filesystem shutdowns due to incorrect rmap operations with the following
> > loop:
> > 
> > mount <filesystem>				# (0)
> > fsstress <run only readonly ops> &		# (1)
> > while true; do
> > 	fsstress <run all ops>
> > 	mount -o remount,ro			# (2)
> > 	fsstress <run only readonly ops>
> > 	mount -o remount,rw			# (3)
> > done
> > 
> > When (2) happens, notice that (1) is still running.  xfs_remount_ro will
> > call xfs_blockgc_stop to walk the inode cache to free all the COW
> > extents, but the blockgc mechanism races with (1)'s reader threads to
> > take IOLOCKs and loses, which means that it doesn't clean them all out.
> > Call such a file (A).
> > 
> > When (3) happens, xfs_remount_rw calls xfs_reflink_recover_cow, which
> > walks the ondisk refcount btree and frees any COW extent that it finds.
> > This function does not check the inode cache, which means that incore
> > COW forks of inode (A) is now inconsistent with the ondisk metadata.  If
> > one of those former COW extents are allocated and mapped into another
> > file (B) and someone triggers a COW to the stale reservation in (A), A's
> > dirty data will be written into (B) and once that's done, those blocks
> > will be transferred to (A)'s data fork without bumping the refcount.
> > 
> > The results are catastrophic -- file (B) and the refcount btree are now
> > corrupt.  In the first patch, we fixed the race condition in (2) so that
> > (A) will always flush the COW fork.  In this second patch, we move the
> > _recover_cow call to the initial mount call in (0) for safety.
> > 
> > As mentioned previously, xfs_reflink_recover_cow walks the refcount
> > btree looking for COW staging extents, and frees them.  This was
> > intended to be run at mount time (when we know there are no live inodes)
> > to clean up any leftover staging events that may have been left behind
> > during an unclean shutdown.  As a time "optimization" for readonly
> > mounts, we deferred this to the ro->rw transition, not realizing that
> > any failure to clean all COW forks during a rw->ro transition would
> > result in catastrophic corruption.
> > 
> > Therefore, remove this optimization and only run the recovery routine
> > when we're guaranteed not to have any COW staging extents anywhere,
> > which means we always run this at mount time.
> > 
> > Fixes: 174edb0e46e5 ("xfs: store in-progress CoW allocations in the refcount btree")
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> 
> The mechanism looks fine, comments below.
> 
> > ---
> >  fs/xfs/xfs_mount.c   |   37 ++++++++++++++++++++++++++++---------
> >  fs/xfs/xfs_reflink.c |    4 +++-
> >  fs/xfs/xfs_super.c   |    9 ---------
> >  3 files changed, 31 insertions(+), 19 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
> > index 359109b6f0d3..064ff89a4557 100644
> > --- a/fs/xfs/xfs_mount.c
> > +++ b/fs/xfs/xfs_mount.c
> > @@ -918,6 +918,34 @@ xfs_mountfs(
> >  		xfs_qm_mount_quotas(mp);
> >  	}
> >  
> > +	/*
> > +	 * Recover any CoW staging blocks that are still referenced by the
> > +	 * ondisk refcount metadata.  The ondisk metadata does not track which
> > +	 * inode created the staging extent, which means that we don't have an
> > +	 * easy means to figure out if a given staging extent is referenced by
> > +	 * a cached inode or is a leftover from a previous unclean shutdown,
> > +	 * short of scanning the entire inode cache to construct a bitmap of
> > +	 * actually stale extents.
> 
> This really isn't commentary that is need for recovery - it should
> be in the comment above xfs_reflink_recover_cow().

<nod>

> > +	 *
> > +	 * During mount, we know that zero files have been exposed to user
> > +	 * modifications, which means that there cannot possibly be any live
> > +	 * staging extents.  Therefore, it is safe to free them all right now,
> > +	 * even if we're performing a readonly mount.
> > +	 *
> > +	 * This cannot be deferred this to rw remount time if we're performing
> > +	 * a readonly mount (as XFS once did) until there's an interlock with
> > +	 * cached inodes.
> > +	 */
> 
> I'm not sure this last bit is necessary here - it's largely covered by
> the commit message and the comment added to xfs_reflink_end_cow().
> 
> It seems to me that the comment here can be reduced to:
> 
> 	/*
> 	 * Recover any CoW staging blocks that are still referenced by the
> 	 * ondisk refcount metadata.  During mount there cannot be any live
> 	 * staging extents as we have not run any user modifications.
> 	 * Therefore, it is safe to free them all right now, even on a
> 	 * read-only mount.
> 	 */
> 
> And the rest of the stuff about live staging extents vs on disk metadata state,
> ro->rw remounts, etc all goes into an more complete explanation of the
> limitations of xfs_reflink_recover_cow() in the comment above
> xfs_reflink_recover_cow()....

Changed, though I'll tweak the second sentence to end with "..as we have
not permitted any user modifications."

> > +	if (!xfs_has_norecovery(mp)) {
> > +		error = xfs_reflink_recover_cow(mp);
> > +		if (error) {
> > +			xfs_err(mp,
> > +	"Error %d recovering leftover CoW allocations.", error);
> > +			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> > +			goto out_quota;
> > +		}
> > +	}
> 
> This strikes me as something xfs_log_mount_finish() should do, as
> it's a post-replay recovery operation and should be done before
> we push the AIL and force the log at the end of log recovery....

Oof, yes.  The refcount btree /requires/ that there be a per-AG
reservation waiting for it, which means that it's current location
after xfs_reserve_blocks and before xfs_fs_reserve_ag_blocks is wrong.

> > +
> >  	/*
> >  	 * Now we are mounted, reserve a small amount of unused space for
> >  	 * privileged transactions. This is needed so that transaction
> > @@ -936,15 +964,6 @@ xfs_mountfs(
> >  			xfs_warn(mp,
> >  	"Unable to allocate reserve blocks. Continuing without reserve pool.");
> >  
> > -		/* Recover any CoW blocks that never got remapped. */
> > -		error = xfs_reflink_recover_cow(mp);
> > -		if (error) {
> > -			xfs_err(mp,
> > -	"Error %d recovering leftover CoW allocations.", error);
> > -			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> > -			goto out_quota;
> > -		}
> > -
> >  		/* Reserve AG blocks for future btree expansion. */
> >  		error = xfs_fs_reserve_ag_blocks(mp);
> >  		if (error && error != -ENOSPC)
> > diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> > index cb0edb1d68ef..a571489ef0bd 100644
> > --- a/fs/xfs/xfs_reflink.c
> > +++ b/fs/xfs/xfs_reflink.c
> > @@ -749,7 +749,9 @@ xfs_reflink_end_cow(
> >  }
> >  
> >  /*
> > - * Free leftover CoW reservations that didn't get cleaned out.
> > + * Free leftover CoW reservations that didn't get cleaned out.  This function
> > + * does not coordinate with cached inode COW forks, which means that callers
> > + * must ensure there are no COW staging extents attached to any cached inodes.
> >   */
> 
> Side note - I've noticed a lot of new comments are in the form of "X does Y,
> which means A needs to do B". Speaking for myself, I find it much easier to
> understand comments in the "rule before reason" form. i.e. "A needs to do B
> because X does Y".
> 
> The rule that we need to follow (A needs to do B) is the important thing
> readers need to understand and so it should be the primary object in the
> sentence/paragraph. They don't necessarily need to understand exactly
> why that rule needs to be followed, but they need to know about the rule.
> Putting the rule after a chunk of complex reasoning means the importance/clarity
> of the rule is lost/less obvious.
> 
> Rewritten in "rule before reason" form:
> 
> "Callers must ensure there are no COW staging extents attached to any cached
> inodes as this function does not co-ordinate with cached inode COW forks."
> 
> Now it's obvious that until there is an interlock between
> xfs_reflink_recover_cow() and cached inodes, this rule needs to be followed.
> There's also no need to add commentary to say "this rule needs to be followed
> until there's an interlock with cached inodes" because that's obvious from the
> rule and the reason for the rule...

<nod> I'll try to keep that in mind for subsequent patches, since these
suggestions significantly shortened the comments.  The comment now
reads:

/*
 * Free all CoW staging blocks that are still referenced by the ondisk
 * refcount metadata.  The ondisk metadata does not track which inode
 * created the staging extent, so callers must ensure that there are no
 * cached inodes with live CoW staging extents.
 */


--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
