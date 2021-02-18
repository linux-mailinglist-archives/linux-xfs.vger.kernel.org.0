Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBC4831EEDB
	for <lists+linux-xfs@lfdr.de>; Thu, 18 Feb 2021 19:49:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233192AbhBRSs3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 18 Feb 2021 13:48:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:37620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232012AbhBRRIA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Feb 2021 12:08:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8110D64E15;
        Thu, 18 Feb 2021 17:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613668038;
        bh=i8XnE0Rr0X6SJSUe81NCfQZf7Nco2uoo8pbihsMXbBc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Pt/79RtU4ZDi6uKo4KXkHPLo7Mov99kmxC3bLkgCl/iJM/7OqmMKLYjhgXHbXaLdX
         f3xx+0cv0PS450cdcjAJdsQ4Q8witYDsvZZuk9ECgnjSf0EGsDpPP/23OwvBPjbszp
         StUpPzuR/sNsK2bJ0DhJ9u53IyI09Vtww770u5L0P9Ngk8ojd5fGGodcjbZZylvlLJ
         Npg+uLirWgI4zyIaq88pXtGlfyfOPsZj/3SxN2LI099XDXckblddivRXJ2Jjdj3vSY
         ePLzOV66o5weWSPZuD5MHZCwTgFEDVwZ8iHuv8OdGoWYzeeHpJNMDJSRytLY2+fUlZ
         lj+/N3CNcUfwQ==
Date:   Thu, 18 Feb 2021 09:07:17 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs_repair: set NEEDSREPAIR the first time we write
 to a filesystem
Message-ID: <20210218170717.GU7193@magnolia>
References: <161319520460.422860.10568013013578673175.stgit@magnolia>
 <161319521070.422860.2540813932323979688.stgit@magnolia>
 <20210216115534.GB534175@bfoster>
 <20210218044522.GR7193@magnolia>
 <20210218125927.GA685651@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210218125927.GA685651@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Feb 18, 2021 at 07:59:27AM -0500, Brian Foster wrote:
> On Wed, Feb 17, 2021 at 08:45:22PM -0800, Darrick J. Wong wrote:
> > On Tue, Feb 16, 2021 at 06:55:34AM -0500, Brian Foster wrote:
> > > On Fri, Feb 12, 2021 at 09:46:50PM -0800, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > Add a hook to the buffer cache so that xfs_repair can intercept the
> > > > first write to a V5 filesystem to set the NEEDSREPAIR flag.  In the
> > > > event that xfs_repair dirties the filesystem and goes down, this ensures
> > > > that the sysadmin will have to re-start repair before mounting.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > ---
> > > >  include/xfs_mount.h |    4 ++
> > > >  libxfs/rdwr.c       |    4 ++
> > > >  repair/xfs_repair.c |   95 +++++++++++++++++++++++++++++++++++++++++++++++++++
> > > >  3 files changed, 103 insertions(+)
> > > > 
> > > > 
> > > ...
> > > > diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> > > > index 90d1a95a..12e319ae 100644
> > > > --- a/repair/xfs_repair.c
> > > > +++ b/repair/xfs_repair.c
> ...
> > > > @@ -751,6 +753,95 @@ clear_needsrepair(
> > > >  		libxfs_buf_relse(bp);
> > > >  }
> > > >  
> > > > +static void
> > > > +update_sb_crc_only(
> > > > +	struct xfs_buf		*bp)
> > > > +{
> > > > +	xfs_buf_update_cksum(bp, XFS_SB_CRC_OFF);
> > > > +}
> > > > +
> > > > +/* Forcibly write the primary superblock with the NEEDSREPAIR flag set. */
> > > > +static void
> > > > +force_needsrepair(
> > > > +	struct xfs_mount	*mp)
> > > > +{
> > > > +	struct xfs_buf_ops	fake_ops;
> > > > +	struct xfs_buf		*bp;
> > > > +	int			error;
> > > > +
> > > > +	if (!xfs_sb_version_hascrc(&mp->m_sb) ||
> > > > +	    xfs_sb_version_needsrepair(&mp->m_sb))
> > > > +		return;
> > > > +
> > > > +	bp = libxfs_getsb(mp);
> > > > +	if (!bp || bp->b_error) {
> > > > +		do_log(
> > > > +	_("couldn't get superblock to set needsrepair, err=%d\n"),
> > > > +				bp ? bp->b_error : ENOMEM);
> > > > +		return;
> > > > +	} else {
> > > > +		/*
> > > > +		 * It's possible that we need to set NEEDSREPAIR before we've
> > > > +		 * had a chance to fix the summary counters in the primary sb.
> > > > +		 * With the exception of those counters, phase 1 already
> > > > +		 * ensured that the geometry makes sense.
> > > > +		 *
> > > > +		 * Bad summary counters in the primary super can cause the
> > > > +		 * write verifier to fail, so substitute a dummy that only sets
> > > > +		 * the CRC.  In the event of a crash, NEEDSREPAIR will prevent
> > > > +		 * the kernel from mounting our potentially damaged filesystem
> > > > +		 * until repair is run again, so it's ok to bypass the usual
> > > > +		 * verification in this one case.
> > > > +		 */
> > > > +		fake_ops = xfs_sb_buf_ops; /* struct copy */
> > > > +		fake_ops.verify_write = update_sb_crc_only;
> > > > +
> > > > +		mp->m_sb.sb_features_incompat |=
> > > > +				XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
> > > > +		libxfs_sb_to_disk(bp->b_addr, &mp->m_sb);
> > > > +
> > > > +		/* Force the primary super to disk immediately. */
> > > > +		bp->b_ops = &fake_ops;
> > > > +		error = -libxfs_bwrite(bp);
> > > 
> > > This looks like it calls back into the writeback hook before it's been
> > > cleared.
> > 
> > Yes, it does...
> > 
> > > I'm guessing the xfs_sb_version_needsrepair() check above cuts
> > > off any recursion issues,
> > 
> > ...but as soon as we end up in the writeback hook, the b_ops and
> > XFS_SB_DADDR checks cause the hook to return without doing anything.
> > 
> > > but it might be cleaner to clear the callback pointer first.
> > 
> > We need to block all other writers until /after/ we've written the
> > primary super, which means that we can't clear the callback until some
> > time after the bwrite.
> > 
> 
> Ok, care to document how this is intended to work with a comment?

Will do, though I'll put the comments about the hook in the actual hook
function:

	/*
	 * This write hook ignores any buffer that looks like a
	 * superblock to avoid hook recursion when setting NEEDSREPAIR.
	 * Higher level code modifying an sb must control the flag
	 * manually.
	 */

	if (bp->b_ops == &xfs_sb_buf_ops || bp->b_bn == XFS_SB_DADDR)
		return;

	pthread_mutex_lock(&wb_mutex);

	/*
	 * If someone else already dropped the hook, then needsrepair
	 * has already been set on the filesystem and we can unlock.
	 */
	if (mp->m_buf_writeback_fn != repair_capture_writeback)
		goto unlock;

	/*
	 * If we get here, the buffer being written is not a superblock,
	 * and needsrepair needs to be set.  The hook is kept in place
	 * to plug all other writes until the sb write finishes.
	 */
	force_needsrepair(mp);
	mp->m_buf_writeback_fn = NULL;

--D

> Brian
> 
> > > 
> > > > +		bp->b_ops = &xfs_sb_buf_ops;
> > > > +		if (error)
> > > > +			do_log(_("couldn't force needsrepair, err=%d\n"), error);
> > > > +	}
> > > > +	if (bp)
> > > > +		libxfs_buf_relse(bp);
> > > 
> > > Doesn't appear we can get here with bp == NULL. Otherwise the rest looks
> > > reasonable to me.
> > 
> > Yep, will fix.
> > 
> > --D
> > 
> > > Brian
> > > 
> > > > +}
> > > > +
> > > > +/* Intercept the first write to the filesystem so we can set NEEDSREPAIR. */
> > > > +static void
> > > > +repair_capture_writeback(
> > > > +	struct xfs_buf		*bp)
> > > > +{
> > > > +	struct xfs_mount	*mp = bp->b_mount;
> > > > +	static pthread_mutex_t	wb_mutex = PTHREAD_MUTEX_INITIALIZER;
> > > > +
> > > > +	/* Higher level code modifying a superblock must set NEEDSREPAIR. */
> > > > +	if (bp->b_ops == &xfs_sb_buf_ops || bp->b_bn == XFS_SB_DADDR)
> > > > +		return;
> > > > +
> > > > +	pthread_mutex_lock(&wb_mutex);
> > > > +
> > > > +	/*
> > > > +	 * If someone else already dropped the hook, then needsrepair has
> > > > +	 * already been set on the filesystem and we can unlock.
> > > > +	 */
> > > > +	if (mp->m_buf_writeback_fn != repair_capture_writeback)
> > > > +		goto unlock;
> > > > +
> > > > +	/*
> > > > +	 * If we get here, the buffer being written is not a superblock, and
> > > > +	 * needsrepair needs to be set.
> > > > +	 */
> > > > +	force_needsrepair(mp);
> > > > +	mp->m_buf_writeback_fn = NULL;
> > > > +unlock:
> > > > +	pthread_mutex_unlock(&wb_mutex);
> > > > +}
> > > > +
> > > >  int
> > > >  main(int argc, char **argv)
> > > >  {
> > > > @@ -847,6 +938,10 @@ main(int argc, char **argv)
> > > >  	if (verbose > 2)
> > > >  		mp->m_flags |= LIBXFS_MOUNT_WANT_CORRUPTED;
> > > >  
> > > > +	/* Capture the first writeback so that we can set needsrepair. */
> > > > +	if (xfs_sb_version_hascrc(&mp->m_sb))
> > > > +		mp->m_buf_writeback_fn = repair_capture_writeback;
> > > > +
> > > >  	/*
> > > >  	 * set XFS-independent status vars from the mount/sb structure
> > > >  	 */
> > > > 
> > > 
> > 
> 
