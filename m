Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8C251F6A
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Jun 2019 02:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729081AbfFYAAc (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 24 Jun 2019 20:00:32 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:53261 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728694AbfFYAAc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 20:00:32 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id B66F6221D8;
        Mon, 24 Jun 2019 20:00:30 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 24 Jun 2019 20:00:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm3; bh=
        POhFJQtzLZestIksBn6sLe+xkkO1BqJT4aCoxSS+6aE=; b=lUxbQZmoR5WQihOs
        dXSU78gqOr6dmJ0tqzpBWSm1AXV59ZmRt1p5+wvMlZeC+BQTjhzqRlErWZ9RZDbs
        0dHoXv/PsjZHONyvL4LfIAMSWky70XTts/ck3GGd3TzZLY2iYryyYLQCvzlgY66L
        HEi0ARVad9yvjwnPZu6Hmmzx9pK7fEbLIgKIkBBkmowa79d+ERILAS+0XYWYzi5l
        /TSeP2P1KVwcGfllwzigL0p39mBSGpT4Vo66TlhcXHQkOSBmK7YxIzyUARKHRx2O
        kq+GAeKPx8IcEexXBoeQshC36fLsnxkLxRTxZVEIju+L2mfuCTobz0gkqCG++zrK
        td1dtg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=POhFJQtzLZestIksBn6sLe+xkkO1BqJT4aCoxSS+6
        aE=; b=Icbl73h1zXil6lLbVhuCmynF+D9xFREphywZH3JrLebM5vUF6YfU/z8az
        lDa757+N6tqx+dbtAGKpCc3LfASKaEm2jir6SBWkJSoYjG/gCUAD9Fg3ugMGHNoi
        L0SrDmK4aBVhNi8qfKg3P7oCJHHdLPTkuYOir8Yd5AWW9PVt5GdePxZMKUyHDBdE
        4rURLkq71vUSOXJJJXuwknhwsFVS3IxqFU0b2XcsWM40wcDDMzBKK57OiuIdrdKG
        ie0+ZP8MWkXwBVeqYvBIg2DnaP60/DVWxj5K5rEMDeay2p9DoeazFNqKRMu9YA6c
        JlVzc135yaG9qCz10LaG1wM0M5kWw==
X-ME-Sender: <xms:HWQRXRbC9WTke3tfnsQgv9RTwQJa7KnRLl_yhGVeT0SsRmIG9S-XVA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudefgdefudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpefkrghnucfm
    vghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecukfhppeduudekrddvtdekrd
    dujeefrdehfeenucfrrghrrghmpehmrghilhhfrhhomheprhgrvhgvnhesthhhvghmrgif
    rdhnvghtnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:HmQRXQRy9uPOTgk5J8Os9kVLVoUIsjoi0HQAHoqlIxViBUJwJxRDbQ>
    <xmx:HmQRXTWDwcED5ohIwR8BE1g7nM8G92ia2vXprJkPj-0DpGlXC7G-Ug>
    <xmx:HmQRXXYDdFp5z-ltPIqGCF0f25nduJ6vmtO6LZouq8I3pSzk1ttMiQ>
    <xmx:HmQRXaTlKXLOo86tPhBe21YLlCe62l_MLvt1vgpOYBPOE8M--Uumiw>
Received: from pluto.themaw.net (unknown [118.208.173.53])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8868F380088;
        Mon, 24 Jun 2019 20:00:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by pluto.themaw.net (Postfix) with ESMTP id 3C7EC1C0114;
        Tue, 25 Jun 2019 08:00:26 +0800 (AWST)
Message-ID: <1bae22f3b34059dcd24caf1f12fc121ca1a906d3.camel@themaw.net>
Subject: Re: [PATCH 06/10] xfs: mount api - add xfs_reconfigure()
From:   Ian Kent <raven@themaw.net>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Tue, 25 Jun 2019 08:00:26 +0800
In-Reply-To: <20190624175541.GX5387@magnolia>
References: <156134510205.2519.16185588460828778620.stgit@fedora-28>
         <156134513640.2519.16288235480703050854.stgit@fedora-28>
         <20190624175541.GX5387@magnolia>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, 2019-06-24 at 10:55 -0700, Darrick J. Wong wrote:
> On Mon, Jun 24, 2019 at 10:58:56AM +0800, Ian Kent wrote:
> > Add the fs_context_operations method .reconfigure that performs
> > remount validation as previously done by the super_operations
> > .remount_fs method.
> > 
> > An attempt has also been made to update the comment about options
> > handling problems with mount(8) to reflect the current situation.
> > 
> > Signed-off-by: Ian Kent <raven@themaw.net>
> > ---
> >  fs/xfs/xfs_super.c |  171
> > ++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 171 insertions(+)
> > 
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index 0ec0142b94e1..7326b21b32d1 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -1721,6 +1721,176 @@ xfs_validate_params(
> >  	return 0;
> >  }
> >  
> > +STATIC int
> > +xfs_reconfigure(
> > +	struct fs_context *fc)
> > +{
> > +	struct xfs_fs_context	*ctx = fc->fs_private;
> > +	struct xfs_mount	*mp = XFS_M(fc->root->d_sb);
> > +	struct xfs_mount        *new_mp = fc->s_fs_info;
> > +	xfs_sb_t		*sbp = &mp->m_sb;
> > +	int			flags = fc->sb_flags;
> > +	int			error;
> > +
> > +	error = xfs_validate_params(new_mp, ctx, fc->purpose);
> > +	if (error)
> > +		return error;
> > +
> > +	/*
> > +	 * There have been problems in the past with options
> > +	 * passed from mount(8).
> > +	 *
> > +	 * The problem being that options passed by mount(8) in
> > +	 * the case where only the the mount point path is given
> > +	 * would consist of the existing fstab options with the
> > +	 * options from mtab for the current mount merged in and
> > +	 * the options given on the command line last. But the
> > +	 * result couldn't be relied upon to accurately reflect the
> > +	 * current mount options so that rejecting options that
> > +	 * can't be changed on reconfigure could erronously cause
> > +	 * mount failure.
> > +	 *
> > +	 * The mount-api uses a legacy mount options handler
> > +	 * in the VFS to accomodate mount(8) so these options
> > +	 * will continue to be passed. Even if mount(8) is
> > +	 * updated to use fsopen()/fsconfig()/fsmount() it's
> > +	 * likely to continue to set the existing options so
> > +	 * options problems with reconfigure could continue.
> > +	 *
> > +	 * For the longest time mtab locking was a problem and
> > +	 * this could have been one possible cause. It's also
> > +	 * possible there could have been options order problems.
> > +	 *
> > +	 * That has changed now as mtab is a link to the proc
> > +	 * file system mount table so mtab options should be
> > +	 * always accurate.
> > +	 *
> > +	 * Consulting the util-linux maintainer (Karel Zak) he
> > +	 * is confident that, in this case, the options passed
> > +	 * by mount(8) will be those of the current mount and
> > +	 * the options order should be a correct merge of fstab
> > +	 * and mtab options, and new options given on the command
> > +	 * line.
> 
> I don't know if it's too late to do this, but could we mandate this
> behavior for the new mount api that dhowells has been working on, and
> then pass a flag to all the fs parsers so that they know when it's safe
> to complain about attempts to remount with changes to options that can't
> be changed?

Sounds like a good idea but I'm not sure if it can be done.
David?

> 
> > +	 *
> > +	 * So, in theory, it should be possible to compare incoming
> > +	 * options and return an error for options that differ from
> > +	 * the current mount and can't be changed on reconfigure to
> > +	 * prevent users from believing they might have changed mount
> > +	 * options using remount which can't be changed.
> > +	 *
> > +	 * But for now continue to return success for every reconfigure
> > +	 * request, and silently ignore all options that can't actually
> > +	 * be changed.
> 
> The comment lines could be longer (i.e. wrapped at column 80 instead of
> 72 or wherever they are now) and moved to be part of the comment for the
> function instead of inside the body.

Ok, will do.

TBH I wish it was less verbose but this is what I ended up with
after trying to understand what the original comment meant.

> 
> > +	 */
> > +
> > +	/* inode32 -> inode64 */
> > +	if ((mp->m_flags & XFS_MOUNT_SMALL_INUMS) &&
> > +	    !(new_mp->m_flags & XFS_MOUNT_SMALL_INUMS)) {
> > +		mp->m_flags &= ~XFS_MOUNT_SMALL_INUMS;
> > +		mp->m_maxagi = xfs_set_inode_alloc(mp, sbp->sb_agcount);
> > +	}
> > +
> > +	/* inode64 -> inode32 */
> > +	if (!(mp->m_flags & XFS_MOUNT_SMALL_INUMS) &&
> > +	    (new_mp->m_flags & XFS_MOUNT_SMALL_INUMS)) {
> > +		mp->m_flags |= XFS_MOUNT_SMALL_INUMS;
> > +		mp->m_maxagi = xfs_set_inode_alloc(mp, sbp->sb_agcount);
> > +	}
> > +
> > +	/* ro -> rw */
> > +	if ((mp->m_flags & XFS_MOUNT_RDONLY) && !(flags & SB_RDONLY)) {
> > +		if (mp->m_flags & XFS_MOUNT_NORECOVERY) {
> > +			xfs_warn(mp,
> > +		"ro->rw transition prohibited on norecovery mount");
> > +			return -EINVAL;
> > +		}
> > +
> > +		if (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
> > +		    xfs_sb_has_ro_compat_feature(sbp,
> > +					XFS_SB_FEAT_RO_COMPAT_UNKNOWN)) {
> > +			xfs_warn(mp,
> > +"ro->rw transition prohibited on unknown (0x%x) ro-compat filesystem",
> > +				(sbp->sb_features_ro_compat &
> > +					XFS_SB_FEAT_RO_COMPAT_UNKNOWN));
> > +			return -EINVAL;
> > +		}
> > +
> > +		mp->m_flags &= ~XFS_MOUNT_RDONLY;
> > +
> > +		/*
> > +		 * If this is the first remount to writeable state we
> > +		 * might have some superblock changes to update.
> > +		 */
> > +		if (mp->m_update_sb) {
> > +			error = xfs_sync_sb(mp, false);
> > +			if (error) {
> > +				xfs_warn(mp, "failed to write sb changes");
> > +				return error;
> > +			}
> > +			mp->m_update_sb = false;
> > +		}
> > +
> > +		/*
> > +		 * Fill out the reserve pool if it is empty. Use the stashed
> > +		 * value if it is non-zero, otherwise go with the default.
> > +		 */
> > +		xfs_restore_resvblks(mp);
> > +		xfs_log_work_queue(mp);
> > +
> > +		/* Recover any CoW blocks that never got remapped. */
> > +		error = xfs_reflink_recover_cow(mp);
> > +		if (error) {
> > +			xfs_err(mp,
> > +	"Error %d recovering leftover CoW allocations.", error);
> > +			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> > +			return error;
> > +		}
> > +		xfs_start_block_reaping(mp);
> > +
> > +		/* Create the per-AG metadata reservation pool .*/
> > +		error = xfs_fs_reserve_ag_blocks(mp);
> > +		if (error && error != -ENOSPC)
> > +			return error;
> 
> Ugh, could you please refactor everything from the "ro -> rw" case in
> xfs_fs_remount into a separate function and then call it from here?

Yes, I admit I thought about doing that myself pretty much immediately
after posting the series, ;)

> Then both functions can shrink to:
> 
> 	if ((mp->m_flags & XFS_MOUNT_RDONLY) && !(flags & SB_RDONLY)) {
> 		error = xfs_remount_rw(mp);
> 		if (error)
> 			return error;
> 	} else if (!(mp->m_flags & XFS_MOUNT_RDONLY) && (flags & SB_RDONLY)) {
> 		error = xfs_remount_ro(mp);
> 		if (error)
> 			return error;
> 	}
> 
> > +	}
> > +
> > +	/* rw -> ro */
> > +	if (!(mp->m_flags & XFS_MOUNT_RDONLY) && (flags & SB_RDONLY)) {
> > +		/*
> > +		 * Cancel background eofb scanning so it cannot race with the
> > +		 * final log force+buftarg wait and deadlock the remount.
> > +		 */
> > +		xfs_stop_block_reaping(mp);
> > +
> > +		/* Get rid of any leftover CoW reservations... */
> > +		error = xfs_icache_free_cowblocks(mp, NULL);
> > +		if (error) {
> > +			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> > +			return error;
> > +		}
> > +
> > +		/* Free the per-AG metadata reservation pool. */
> > +		error = xfs_fs_unreserve_ag_blocks(mp);
> > +		if (error) {
> > +			xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> > +			return error;
> > +		}
> > +
> > +		/*
> > +		 * Before we sync the metadata, we need to free up the reserve
> > +		 * block pool so that the used block count in the superblock on
> > +		 * disk is correct at the end of the remount. Stash the current
> > +		 * reserve pool size so that if we get remounted rw, we can
> > +		 * return it to the same size.
> > +		 */
> > +		xfs_save_resvblks(mp);
> > +
> > +		xfs_quiesce_attr(mp);
> > +		mp->m_flags |= XFS_MOUNT_RDONLY;
> 
> ...and here?
> 
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> >  /*
> >   * Second stage of a freeze. The data is already frozen so we only
> >   * need to take care of the metadata. Once that's done sync the superblock
> > @@ -2246,6 +2416,7 @@ static const struct super_operations
> > xfs_super_operations = {
> >  static const struct fs_context_operations xfs_context_ops = {
> >  	.parse_param = xfs_parse_param,
> >  	.get_tree    = xfs_get_tree,
> > +	.reconfigure = xfs_reconfigure,
> >  };
> >  
> >  static struct file_system_type xfs_fs_type = {
> > 

