Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74DBF71A069
	for <lists+linux-xfs@lfdr.de>; Thu,  1 Jun 2023 16:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232873AbjFAOjB (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 1 Jun 2023 10:39:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232754AbjFAOjB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Jun 2023 10:39:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02EC9E62
        for <linux-xfs@vger.kernel.org>; Thu,  1 Jun 2023 07:38:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E7A3645E1
        for <linux-xfs@vger.kernel.org>; Thu,  1 Jun 2023 14:38:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D34BCC4339B;
        Thu,  1 Jun 2023 14:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685630306;
        bh=NCHyolcMkVbi4wVfGKCy8OCCPK+2Qnv2nT4HYV0Qwl8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n+lKQNZl+JETzrCuHIzHg9j+9qA3PpOEOugO0dVkCUy1TdzrjDTxzWkisd69adwgz
         xuWXRPA3KwDnXQyM74z9CURYCl7S2q4d6A3HjzpV9pjojj7SpdReFajfCvqD2iKLu1
         ECOnjhPIznboV4/nvfh3aGpyNOksF1Ofz44PaUNhO2ttJI36pNr+Un9b1t1hb/x+HM
         IjpoHyYlymf/p0ktd3s4X4qPdzfE665hGxTZPpk46qG56NT1JPNAmCm3j7xHgdpgZ+
         Qb6iFXsJFF6ZkWM/aQjB7hviQvdj5aiQmivRPdYnCQoAf7D2qb0HBODmfZbAA83OTJ
         KN/q5eCH2JLvg==
Date:   Thu, 1 Jun 2023 07:38:26 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/4] xfs: fix AGF vs inode cluster buffer deadlock
Message-ID: <20230601143826.GA16865@frogsfrogsfrogs>
References: <20230517000449.3997582-1-david@fromorbit.com>
 <20230517000449.3997582-5-david@fromorbit.com>
 <20230517012629.GP858799@frogsfrogsfrogs>
 <ZHf5tYs4qeHa5edk@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHf5tYs4qeHa5edk@dread.disaster.area>
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jun 01, 2023 at 11:51:49AM +1000, Dave Chinner wrote:
> Friendly Ping.
> 
> Apart from the stray trace_printk()s I forgot to remove, are
> there any other problems with this patch I need to fix?

Nothing obvious that I could see.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D


> -Dave.
> 
> On Tue, May 16, 2023 at 06:26:29PM -0700, Darrick J. Wong wrote:
> > On Wed, May 17, 2023 at 10:04:49AM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Lock order in XFS is AGI -> AGF, hence for operations involving
> > > inode unlinked list operations we always lock the AGI first. Inode
> > > unlinked list operations operate on the inode cluster buffer,
> > > so the lock order there is AGI -> inode cluster buffer.
> > > 
> > > For O_TMPFILE operations, this now means the lock order set down in
> > > xfs_rename and xfs_link is AGI -> inode cluster buffer -> AGF as the
> > > unlinked ops are done before the directory modifications that may
> > > allocate space and lock the AGF.
> > > 
> > > Unfortunately, we also now lock the inode cluster buffer when
> > > logging an inode so that we can attach the inode to the cluster
> > > buffer and pin it in memory. This creates a lock order of AGF ->
> > > inode cluster buffer in directory operations as we have to log the
> > > inode after we've allocated new space for it.
> > > 
> > > This creates a lock inversion between the AGF and the inode cluster
> > > buffer. Because the inode cluster buffer is shared across multiple
> > > inodes, the inversion is not specific to individual inodes but can
> > > occur when inodes in the same cluster buffer are accessed in
> > > different orders.
> > > 
> > > To fix this we need move all the inode log item cluster buffer
> > > interactions to the end of the current transaction. Unfortunately,
> > > xfs_trans_log_inode() calls are littered throughout the transactions
> > > with no thought to ordering against other items or locking. This
> > > makes it difficult to do anything that involves changing the call
> > > sites of xfs_trans_log_inode() to change locking orders.
> > > 
> > > However, we do now have a mechanism that allows is to postpone dirty
> > > item processing to just before we commit the transaction: the
> > > ->iop_precommit method. This will be called after all the
> > > modifications are done and high level objects like AGI and AGF
> > > buffers have been locked and modified, thereby providing a mechanism
> > > that guarantees we don't lock the inode cluster buffer before those
> > > high level objects are locked.
> > > 
> > > This change is largely moving the guts of xfs_trans_log_inode() to
> > > xfs_inode_item_precommit() and providing an extra flag context in
> > > the inode log item to track the dirty state of the inode in the
> > > current transaction. This also means we do a lot less repeated work
> > > in xfs_trans_log_inode() by only doing it once per transaction when
> > > all the work is done.
> > 
> > Aha, and that's why you moved all the "opportunistically tweak inode
> > metadata while we're already logging it" bits to the precommit hook.
> > 
> > > Fixes: 298f7bec503f ("xfs: pin inode backing buffer to the inode log item")
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  fs/xfs/libxfs/xfs_log_format.h  |   9 +-
> > >  fs/xfs/libxfs/xfs_trans_inode.c | 115 +++---------------------
> > >  fs/xfs/xfs_inode_item.c         | 152 ++++++++++++++++++++++++++++++++
> > >  fs/xfs/xfs_inode_item.h         |   1 +
> > >  4 files changed, 171 insertions(+), 106 deletions(-)
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> > > index f13e0809dc63..269573c82808 100644
> > > --- a/fs/xfs/libxfs/xfs_log_format.h
> > > +++ b/fs/xfs/libxfs/xfs_log_format.h
> > > @@ -324,7 +324,6 @@ struct xfs_inode_log_format_32 {
> > >  #define XFS_ILOG_DOWNER	0x200	/* change the data fork owner on replay */
> > >  #define XFS_ILOG_AOWNER	0x400	/* change the attr fork owner on replay */
> > >  
> > > -
> > >  /*
> > >   * The timestamps are dirty, but not necessarily anything else in the inode
> > >   * core.  Unlike the other fields above this one must never make it to disk
> > > @@ -333,6 +332,14 @@ struct xfs_inode_log_format_32 {
> > >   */
> > >  #define XFS_ILOG_TIMESTAMP	0x4000
> > >  
> > > +/*
> > > + * The version field has been changed, but not necessarily anything else of
> > > + * interest. This must never make it to disk - it is used purely to ensure that
> > > + * the inode item ->precommit operation can update the fsync flag triggers
> > > + * in the inode item correctly.
> > > + */
> > > +#define XFS_ILOG_IVERSION	0x8000
> > > +
> > >  #define	XFS_ILOG_NONCORE	(XFS_ILOG_DDATA | XFS_ILOG_DEXT | \
> > >  				 XFS_ILOG_DBROOT | XFS_ILOG_DEV | \
> > >  				 XFS_ILOG_ADATA | XFS_ILOG_AEXT | \
> > > diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
> > > index 8b5547073379..2d164d0588b1 100644
> > > --- a/fs/xfs/libxfs/xfs_trans_inode.c
> > > +++ b/fs/xfs/libxfs/xfs_trans_inode.c
> > > @@ -40,9 +40,8 @@ xfs_trans_ijoin(
> > >  	iip->ili_lock_flags = lock_flags;
> > >  	ASSERT(!xfs_iflags_test(ip, XFS_ISTALE));
> > >  
> > > -	/*
> > > -	 * Get a log_item_desc to point at the new item.
> > > -	 */
> > > +	/* Reset the per-tx dirty context and add the item to the tx. */
> > > +	iip->ili_dirty_flags = 0;
> > >  	xfs_trans_add_item(tp, &iip->ili_item);
> > >  }
> > >  
> > > @@ -76,17 +75,10 @@ xfs_trans_ichgtime(
> > >  /*
> > >   * This is called to mark the fields indicated in fieldmask as needing to be
> > >   * logged when the transaction is committed.  The inode must already be
> > > - * associated with the given transaction.
> > > - *
> > > - * The values for fieldmask are defined in xfs_inode_item.h.  We always log all
> > > - * of the core inode if any of it has changed, and we always log all of the
> > > - * inline data/extents/b-tree root if any of them has changed.
> > > - *
> > > - * Grab and pin the cluster buffer associated with this inode to avoid RMW
> > > - * cycles at inode writeback time. Avoid the need to add error handling to every
> > > - * xfs_trans_log_inode() call by shutting down on read error.  This will cause
> > > - * transactions to fail and everything to error out, just like if we return a
> > > - * read error in a dirty transaction and cancel it.
> > > + * associated with the given transaction. All we do here is record where the
> > > + * inode was dirtied and mark the transaction and inode log item dirty;
> > > + * everything else is done in the ->precommit log item operation after the
> > > + * changes in the transaction have been completed.
> > >   */
> > >  void
> > >  xfs_trans_log_inode(
> > > @@ -96,7 +88,6 @@ xfs_trans_log_inode(
> > >  {
> > >  	struct xfs_inode_log_item *iip = ip->i_itemp;
> > >  	struct inode		*inode = VFS_I(ip);
> > > -	uint			iversion_flags = 0;
> > >  
> > >  	ASSERT(iip);
> > >  	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
> > > @@ -104,18 +95,6 @@ xfs_trans_log_inode(
> > >  
> > >  	tp->t_flags |= XFS_TRANS_DIRTY;
> > >  
> > > -	/*
> > > -	 * Don't bother with i_lock for the I_DIRTY_TIME check here, as races
> > > -	 * don't matter - we either will need an extra transaction in 24 hours
> > > -	 * to log the timestamps, or will clear already cleared fields in the
> > > -	 * worst case.
> > > -	 */
> > > -	if (inode->i_state & I_DIRTY_TIME) {
> > > -		spin_lock(&inode->i_lock);
> > > -		inode->i_state &= ~I_DIRTY_TIME;
> > > -		spin_unlock(&inode->i_lock);
> > > -	}
> > > -
> > >  	/*
> > >  	 * First time we log the inode in a transaction, bump the inode change
> > >  	 * counter if it is configured for this to occur. While we have the
> > > @@ -128,86 +107,12 @@ xfs_trans_log_inode(
> > >  	if (!test_and_set_bit(XFS_LI_DIRTY, &iip->ili_item.li_flags)) {
> > >  		if (IS_I_VERSION(inode) &&
> > >  		    inode_maybe_inc_iversion(inode, flags & XFS_ILOG_CORE))
> > > -			iversion_flags = XFS_ILOG_CORE;
> > > +			flags |= XFS_ILOG_IVERSION;
> > >  	}
> > >  
> > > -	/*
> > > -	 * If we're updating the inode core or the timestamps and it's possible
> > > -	 * to upgrade this inode to bigtime format, do so now.
> > > -	 */
> > > -	if ((flags & (XFS_ILOG_CORE | XFS_ILOG_TIMESTAMP)) &&
> > > -	    xfs_has_bigtime(ip->i_mount) &&
> > > -	    !xfs_inode_has_bigtime(ip)) {
> > > -		ip->i_diflags2 |= XFS_DIFLAG2_BIGTIME;
> > > -		flags |= XFS_ILOG_CORE;
> > > -	}
> > > -
> > > -	/*
> > > -	 * Inode verifiers do not check that the extent size hint is an integer
> > > -	 * multiple of the rt extent size on a directory with both rtinherit
> > > -	 * and extszinherit flags set.  If we're logging a directory that is
> > > -	 * misconfigured in this way, clear the hint.
> > > -	 */
> > > -	if ((ip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
> > > -	    (ip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) &&
> > > -	    (ip->i_extsize % ip->i_mount->m_sb.sb_rextsize) > 0) {
> > > -		ip->i_diflags &= ~(XFS_DIFLAG_EXTSIZE |
> > > -				   XFS_DIFLAG_EXTSZINHERIT);
> > > -		ip->i_extsize = 0;
> > > -		flags |= XFS_ILOG_CORE;
> > > -	}
> > > -
> > > -	/*
> > > -	 * Record the specific change for fdatasync optimisation. This allows
> > > -	 * fdatasync to skip log forces for inodes that are only timestamp
> > > -	 * dirty.
> > > -	 */
> > > -	spin_lock(&iip->ili_lock);
> > > -	iip->ili_fsync_fields |= flags;
> > > -
> > > -	if (!iip->ili_item.li_buf) {
> > > -		struct xfs_buf	*bp;
> > > -		int		error;
> > > -
> > > -		/*
> > > -		 * We hold the ILOCK here, so this inode is not going to be
> > > -		 * flushed while we are here. Further, because there is no
> > > -		 * buffer attached to the item, we know that there is no IO in
> > > -		 * progress, so nothing will clear the ili_fields while we read
> > > -		 * in the buffer. Hence we can safely drop the spin lock and
> > > -		 * read the buffer knowing that the state will not change from
> > > -		 * here.
> > > -		 */
> > > -		spin_unlock(&iip->ili_lock);
> > > -		error = xfs_imap_to_bp(ip->i_mount, tp, &ip->i_imap, &bp);
> > > -		if (error) {
> > > -			xfs_force_shutdown(ip->i_mount, SHUTDOWN_META_IO_ERROR);
> > > -			return;
> > > -		}
> > > -
> > > -		/*
> > > -		 * We need an explicit buffer reference for the log item but
> > > -		 * don't want the buffer to remain attached to the transaction.
> > > -		 * Hold the buffer but release the transaction reference once
> > > -		 * we've attached the inode log item to the buffer log item
> > > -		 * list.
> > > -		 */
> > > -		xfs_buf_hold(bp);
> > > -		spin_lock(&iip->ili_lock);
> > > -		iip->ili_item.li_buf = bp;
> > > -		bp->b_flags |= _XBF_INODES;
> > > -		list_add_tail(&iip->ili_item.li_bio_list, &bp->b_li_list);
> > > -		xfs_trans_brelse(tp, bp);
> > > -	}
> > > -
> > > -	/*
> > > -	 * Always OR in the bits from the ili_last_fields field.  This is to
> > > -	 * coordinate with the xfs_iflush() and xfs_buf_inode_iodone() routines
> > > -	 * in the eventual clearing of the ili_fields bits.  See the big comment
> > > -	 * in xfs_iflush() for an explanation of this coordination mechanism.
> > > -	 */
> > > -	iip->ili_fields |= (flags | iip->ili_last_fields | iversion_flags);
> > > -	spin_unlock(&iip->ili_lock);
> > > +	iip->ili_dirty_flags |= flags;
> > > +	trace_printk("ino 0x%llx, flags 0x%x, dflags 0x%x",
> > > +		ip->i_ino, flags, iip->ili_dirty_flags);
> > 
> > Urk, leftover debugging info?
> > 
> > --D
> > >  }
> > >  
> > >  int
> > > diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> > > index ca2941ab6cbc..586af11b7cd1 100644
> > > --- a/fs/xfs/xfs_inode_item.c
> > > +++ b/fs/xfs/xfs_inode_item.c
> > > @@ -29,6 +29,156 @@ static inline struct xfs_inode_log_item *INODE_ITEM(struct xfs_log_item *lip)
> > >  	return container_of(lip, struct xfs_inode_log_item, ili_item);
> > >  }
> > >  
> > > +static uint64_t
> > > +xfs_inode_item_sort(
> > > +	struct xfs_log_item	*lip)
> > > +{
> > > +	return INODE_ITEM(lip)->ili_inode->i_ino;
> > > +}
> > > +
> > > +/*
> > > + * Prior to finally logging the inode, we have to ensure that all the
> > > + * per-modification inode state changes are applied. This includes VFS inode
> > > + * state updates, format conversions, verifier state synchronisation and
> > > + * ensuring the inode buffer remains in memory whilst the inode is dirty.
> > > + *
> > > + * We have to be careful when we grab the inode cluster buffer due to lock
> > > + * ordering constraints. The unlinked inode modifications (xfs_iunlink_item)
> > > + * require AGI -> inode cluster buffer lock order. The inode cluster buffer is
> > > + * not locked until ->precommit, so it happens after everything else has been
> > > + * modified.
> > > + *
> > > + * Further, we have AGI -> AGF lock ordering, and with O_TMPFILE handling we
> > > + * have AGI -> AGF -> iunlink item -> inode cluster buffer lock order. Hence we
> > > + * cannot safely lock the inode cluster buffer in xfs_trans_log_inode() because
> > > + * it can be called on a inode (e.g. via bumplink/droplink) before we take the
> > > + * AGF lock modifying directory blocks.
> > > + *
> > > + * Rather than force a complete rework of all the transactions to call
> > > + * xfs_trans_log_inode() once and once only at the end of every transaction, we
> > > + * move the pinning of the inode cluster buffer to a ->precommit operation. This
> > > + * matches how the xfs_iunlink_item locks the inode cluster buffer, and it
> > > + * ensures that the inode cluster buffer locking is always done last in a
> > > + * transaction. i.e. we ensure the lock order is always AGI -> AGF -> inode
> > > + * cluster buffer.
> > > + *
> > > + * If we return the inode number as the precommit sort key then we'll also
> > > + * guarantee that the order all inode cluster buffer locking is the same all the
> > > + * inodes and unlink items in the transaction.
> > > + */
> > > +static int
> > > +xfs_inode_item_precommit(
> > > +	struct xfs_trans	*tp,
> > > +	struct xfs_log_item	*lip)
> > > +{
> > > +	struct xfs_inode_log_item *iip = INODE_ITEM(lip);
> > > +	struct xfs_inode	*ip = iip->ili_inode;
> > > +	struct inode		*inode = VFS_I(ip);
> > > +	unsigned int		flags = iip->ili_dirty_flags;
> > > +
> > > +	trace_printk("ino 0x%llx, dflags 0x%x, fields 0x%x lastf 0x%x",
> > > +		ip->i_ino, flags, iip->ili_fields, iip->ili_last_fields);
> > > +	/*
> > > +	 * Don't bother with i_lock for the I_DIRTY_TIME check here, as races
> > > +	 * don't matter - we either will need an extra transaction in 24 hours
> > > +	 * to log the timestamps, or will clear already cleared fields in the
> > > +	 * worst case.
> > > +	 */
> > > +	if (inode->i_state & I_DIRTY_TIME) {
> > > +		spin_lock(&inode->i_lock);
> > > +		inode->i_state &= ~I_DIRTY_TIME;
> > > +		spin_unlock(&inode->i_lock);
> > > +	}
> > > +
> > > +
> > > +	/*
> > > +	 * If we're updating the inode core or the timestamps and it's possible
> > > +	 * to upgrade this inode to bigtime format, do so now.
> > > +	 */
> > > +	if ((flags & (XFS_ILOG_CORE | XFS_ILOG_TIMESTAMP)) &&
> > > +	    xfs_has_bigtime(ip->i_mount) &&
> > > +	    !xfs_inode_has_bigtime(ip)) {
> > > +		ip->i_diflags2 |= XFS_DIFLAG2_BIGTIME;
> > > +		flags |= XFS_ILOG_CORE;
> > > +	}
> > > +
> > > +	/*
> > > +	 * Inode verifiers do not check that the extent size hint is an integer
> > > +	 * multiple of the rt extent size on a directory with both rtinherit
> > > +	 * and extszinherit flags set.  If we're logging a directory that is
> > > +	 * misconfigured in this way, clear the hint.
> > > +	 */
> > > +	if ((ip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
> > > +	    (ip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) &&
> > > +	    (ip->i_extsize % ip->i_mount->m_sb.sb_rextsize) > 0) {
> > > +		ip->i_diflags &= ~(XFS_DIFLAG_EXTSIZE |
> > > +				   XFS_DIFLAG_EXTSZINHERIT);
> > > +		ip->i_extsize = 0;
> > > +		flags |= XFS_ILOG_CORE;
> > > +	}
> > > +
> > > +	/*
> > > +	 * Record the specific change for fdatasync optimisation. This allows
> > > +	 * fdatasync to skip log forces for inodes that are only timestamp
> > > +	 * dirty. Once we've processed the XFS_ILOG_IVERSION flag, convert it
> > > +	 * to XFS_ILOG_CORE so that the actual on-disk dirty tracking
> > > +	 * (ili_fields) correctly tracks that the version has changed.
> > > +	 */
> > > +	spin_lock(&iip->ili_lock);
> > > +	iip->ili_fsync_fields |= (flags & ~XFS_ILOG_IVERSION);
> > > +	if (flags & XFS_ILOG_IVERSION)
> > > +		flags = ((flags & ~XFS_ILOG_IVERSION) | XFS_ILOG_CORE);
> > > +
> > > +	if (!iip->ili_item.li_buf) {
> > > +		struct xfs_buf	*bp;
> > > +		int		error;
> > > +
> > > +		/*
> > > +		 * We hold the ILOCK here, so this inode is not going to be
> > > +		 * flushed while we are here. Further, because there is no
> > > +		 * buffer attached to the item, we know that there is no IO in
> > > +		 * progress, so nothing will clear the ili_fields while we read
> > > +		 * in the buffer. Hence we can safely drop the spin lock and
> > > +		 * read the buffer knowing that the state will not change from
> > > +		 * here.
> > > +		 */
> > > +		spin_unlock(&iip->ili_lock);
> > > +		error = xfs_imap_to_bp(ip->i_mount, tp, &ip->i_imap, &bp);
> > > +		if (error)
> > > +			return error;
> > > +
> > > +		/*
> > > +		 * We need an explicit buffer reference for the log item but
> > > +		 * don't want the buffer to remain attached to the transaction.
> > > +		 * Hold the buffer but release the transaction reference once
> > > +		 * we've attached the inode log item to the buffer log item
> > > +		 * list.
> > > +		 */
> > > +		xfs_buf_hold(bp);
> > > +		spin_lock(&iip->ili_lock);
> > > +		iip->ili_item.li_buf = bp;
> > > +		bp->b_flags |= _XBF_INODES;
> > > +		list_add_tail(&iip->ili_item.li_bio_list, &bp->b_li_list);
> > > +		xfs_trans_brelse(tp, bp);
> > > +	}
> > > +
> > > +	/*
> > > +	 * Always OR in the bits from the ili_last_fields field.  This is to
> > > +	 * coordinate with the xfs_iflush() and xfs_buf_inode_iodone() routines
> > > +	 * in the eventual clearing of the ili_fields bits.  See the big comment
> > > +	 * in xfs_iflush() for an explanation of this coordination mechanism.
> > > +	 */
> > > +	iip->ili_fields |= (flags | iip->ili_last_fields);
> > > +	spin_unlock(&iip->ili_lock);
> > > +
> > > +	/*
> > > +	 * We are done with the log item transaction dirty state, so clear it so
> > > +	 * that it doesn't pollute future transactions.
> > > +	 */
> > > +	iip->ili_dirty_flags = 0;
> > > +	return 0;
> > > +}
> > > +
> > >  /*
> > >   * The logged size of an inode fork is always the current size of the inode
> > >   * fork. This means that when an inode fork is relogged, the size of the logged
> > > @@ -662,6 +812,8 @@ xfs_inode_item_committing(
> > >  }
> > >  
> > >  static const struct xfs_item_ops xfs_inode_item_ops = {
> > > +	.iop_sort	= xfs_inode_item_sort,
> > > +	.iop_precommit	= xfs_inode_item_precommit,
> > >  	.iop_size	= xfs_inode_item_size,
> > >  	.iop_format	= xfs_inode_item_format,
> > >  	.iop_pin	= xfs_inode_item_pin,
> > > diff --git a/fs/xfs/xfs_inode_item.h b/fs/xfs/xfs_inode_item.h
> > > index bbd836a44ff0..377e06007804 100644
> > > --- a/fs/xfs/xfs_inode_item.h
> > > +++ b/fs/xfs/xfs_inode_item.h
> > > @@ -17,6 +17,7 @@ struct xfs_inode_log_item {
> > >  	struct xfs_log_item	ili_item;	   /* common portion */
> > >  	struct xfs_inode	*ili_inode;	   /* inode ptr */
> > >  	unsigned short		ili_lock_flags;	   /* inode lock flags */
> > > +	unsigned int		ili_dirty_flags;   /* dirty in current tx */
> > >  	/*
> > >  	 * The ili_lock protects the interactions between the dirty state and
> > >  	 * the flush state of the inode log item. This allows us to do atomic
> > > -- 
> > > 2.40.1
> > > 
> > 
> 
> -- 
> Dave Chinner
> david@fromorbit.com
