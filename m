Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3CF2FC225
	for <lists+linux-xfs@lfdr.de>; Tue, 19 Jan 2021 22:23:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729445AbhASSrT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 19 Jan 2021 13:47:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:49908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730676AbhASS23 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 19 Jan 2021 13:28:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E130C238EA;
        Tue, 19 Jan 2021 17:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611078719;
        bh=7zFbjtkYU8nqYVGoeD3pZSlqNF4FbUJSbJ7IThcX/EM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RdBP6DR3hCirEe5R5H0fvUWjGmkak8auEyyJDc54QAkWA5PCPqnVa/ayg6tCZwuPE
         XYDa1Gnh95zerRLdQx+mMCK7+s5NEARmj/l9vH1eqJrwtXJYo9+WVWysQlgcqgM9BU
         DtogbQsdlGrSnYO9Rb5AR/4S9FZVyWxGN/VqAT6Zv7PQnPHlU2TfQ6Rtoh56ZrKsge
         3GpeKZtXblWX0XXn/Avf1vw4s+qDXv6S+29mKD5MbQUyV7RijDUsCrf1EkuqDi+FAe
         UHcDj5D0HkmM3hdIjdX6RgTLfB5TgWSB7KSIXJII6nUlqBQWnAtRtKmnK7QrWVev0E
         uAvo2dozD9Dqg==
Date:   Tue, 19 Jan 2021 09:51:54 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 4/9] xfs: cover the log during log quiesce
Message-ID: <20210119175154.GO3134581@magnolia>
References: <20210106174127.805660-1-bfoster@redhat.com>
 <20210106174127.805660-5-bfoster@redhat.com>
 <20210107190408.GD6918@magnolia>
 <20210107195336.GB845369@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107195336.GB845369@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 07, 2021 at 02:53:36PM -0500, Brian Foster wrote:
> On Thu, Jan 07, 2021 at 11:04:08AM -0800, Darrick J. Wong wrote:
> > On Wed, Jan 06, 2021 at 12:41:22PM -0500, Brian Foster wrote:
> > > The log quiesce mechanism historically terminates by marking the log
> > > clean with an unmount record. The primary objective is to indicate
> > > that log recovery is no longer required after the quiesce has
> > > flushed all in-core changes and written back filesystem metadata.
> > > While this is perfectly fine, it is somewhat hacky as currently used
> > > in certain contexts. For example, filesystem freeze quiesces (i.e.
> > > cleans) the log and immediately redirties it with a dummy superblock
> > > transaction to ensure that log recovery runs in the event of a
> > > crash.
> > > 
> > > While this functions correctly, cleaning the log from freeze context
> > > is clearly superfluous given the current redirtying behavior.
> > > Instead, the desired behavior can be achieved by simply covering the
> > > log. This effectively retires all on-disk log items from the active
> > > range of the log by issuing two synchronous and sequential dummy
> > > superblock update transactions that serve to update the on-disk log
> > > head and tail. The subtle difference is that the log technically
> > > remains dirty due to the lack of an unmount record, though recovery
> > > is effectively a no-op due to the content of the checkpoints being
> > > clean (i.e. the unmodified on-disk superblock).
> > > 
> > > Log covering currently runs in the background and only triggers once
> > > the filesystem and log has idled. The purpose of the background
> > > mechanism is to prevent log recovery from replaying the most
> > > recently logged items long after those items may have been written
> > > back. In the quiesce path, the log has been deliberately idled by
> > > forcing the log and pushing the AIL until empty in a context where
> > > no further mutable filesystem operations are allowed. Therefore, we
> > > can cover the log as the final step in the log quiesce codepath to
> > > reflect that all previously active items have been successfully
> > > written back.
> > > 
> > > This facilitates selective log covering from certain contexts (i.e.
> > > freeze) that only seek to quiesce, but not necessarily clean the
> > > log. Note that as a side effect of this change, log covering now
> > > occurs when cleaning the log as well. This is harmless, facilitates
> > > subsequent cleanups, and is mostly temporary as various operations
> > > switch to use explicit log covering.
> > > 
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > >  fs/xfs/xfs_log.c | 49 +++++++++++++++++++++++++++++++++++++++++++++---
> > >  fs/xfs/xfs_log.h |  2 +-
> > >  2 files changed, 47 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > > index 1b3227a033ad..f7b23044723d 100644
> > > --- a/fs/xfs/xfs_log.c
> > > +++ b/fs/xfs/xfs_log.c
> > > @@ -91,6 +91,9 @@ STATIC int
> > >  xlog_iclogs_empty(
> > >  	struct xlog		*log);
> > >  
> > > +static int
> > > +xfs_log_cover(struct xfs_mount *);
> > > +
> > >  static void
> > >  xlog_grant_sub_space(
> > >  	struct xlog		*log,
> > > @@ -936,10 +939,9 @@ xfs_log_unmount_write(
> > >   * To do this, we first need to shut down the background log work so it is not
> > >   * trying to cover the log as we clean up. We then need to unpin all objects in
> > >   * the log so we can then flush them out. Once they have completed their IO and
> > > - * run the callbacks removing themselves from the AIL, we can write the unmount
> > > - * record.
> > > + * run the callbacks removing themselves from the AIL, we can cover the log.
> > >   */
> > > -void
> > > +int
> > >  xfs_log_quiesce(
> > >  	struct xfs_mount	*mp)
> > >  {
> > > @@ -957,6 +959,8 @@ xfs_log_quiesce(
> > >  	xfs_wait_buftarg(mp->m_ddev_targp);
> > >  	xfs_buf_lock(mp->m_sb_bp);
> > >  	xfs_buf_unlock(mp->m_sb_bp);
> > > +
> > > +	return xfs_log_cover(mp);
> > >  }
> > >  
> > >  void
> > > @@ -1092,6 +1096,45 @@ xfs_log_need_covered(
> > >  	return needed;
> > >  }
> > >  
> > > +/*
> > > + * Explicitly cover the log. This is similar to background log covering but
> > > + * intended for usage in quiesce codepaths. The caller is responsible to ensure
> > > + * the log is idle and suitable for covering. The CIL, iclog buffers and AIL
> > > + * must all be empty.
> > > + */
> > > +static int
> > > +xfs_log_cover(
> > > +	struct xfs_mount	*mp)
> > > +{
> > > +	struct xlog		*log = mp->m_log;
> > > +	int			error = 0;
> > > +
> > > +	ASSERT((xlog_cil_empty(log) && xlog_iclogs_empty(log) &&
> > > +	        !xfs_ail_min_lsn(log->l_ailp)) ||
> > > +	       XFS_FORCED_SHUTDOWN(mp));
> > > +
> > > +	if (!xfs_log_writable(mp))
> > > +		return 0;
> > > +
> > > +	/*
> > > +	 * To cover the log, commit the superblock twice (at most) in
> > > +	 * independent checkpoints. The first serves as a reference for the
> > > +	 * tail pointer. The sync transaction and AIL push empties the AIL and
> > > +	 * updates the in-core tail to the LSN of the first checkpoint. The
> > > +	 * second commit updates the on-disk tail with the in-core LSN,
> > > +	 * covering the log. Push the AIL one more time to leave it empty, as
> > > +	 * we found it.
> > > +	 */
> > 
> > Hm.  At first I looked at _need_covered and wondered how this could work
> > properly if we are in state DONE or DONE2, because this not-quite
> > predicate returns zero in that case.
> > 
> > I think it's the case that the only way the log can end up in DONE state
> > is if the background log worker had previously been in NEED, written the
> > first of the dummy transactions, moved the state to DONE, and waited for
> > xlog_covered_state to move the log from DONE to NEED2.  Similarly, the
> > log can only be in DONE2 state if the background worker wrote the second
> > dummy and is now waiting for xlog_covered_state to move the log from
> > DONE2 to IDLE.
> > 
> > Since xfs_log_quiesce cancelled the log worker and waited for it to
> > finish before calling xfs_log_cover, the covering state here can only be
> > IDLE, NEED, or NEED2, right?  And hence the while loop pushes the log to
> > IDLE no matter where it is now, right?
> > 
> 
> Yeah, we're in a quiescent context at this point where no other
> transactions are running, the in-core structures should be drained and
> the background log worker cancelled, etc. With regard to the background
> log worker, I don't think it should ever actually see the DONE or DONE2
> states as it sets those states and immediately issues the synchronous sb
> transaction. Therefore, the commit should have changed the state from
> DONE to NEED2 or NEED (if other items happened to land in the log)
> before it returns.
> 
> That said, I suppose it wouldn't be that surprising if some odd timing
> scenario or combination of external superblock commits could cause the
> background log worker to see a DONE state. I haven't fully audited for
> that, but regardless it would appropriately do nothing and that
> shouldn't be an issue from the quiesce context due to the runtime being
> pretty much shut down by this point.

<nod> I think that makes sense.  :)

--D

> > (I also wondered why this isn't a do-while loop but patch 6 addresses
> > that.)
> > 
> 
> Right, that changes due to the lazy sb counter logic..
> 
> Brian
> 
> > --D
> > 
> > > +	while (xfs_log_need_covered(mp)) {
> > > +		error = xfs_sync_sb(mp, true);
> > > +		if (error)
> > > +			break;
> > > +		xfs_ail_push_all_sync(mp->m_ail);
> > > +	}
> > > +
> > > +	return error;
> > > +}
> > > +
> > >  /*
> > >   * We may be holding the log iclog lock upon entering this routine.
> > >   */
> > > diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> > > index b0400589f824..044e02cb8921 100644
> > > --- a/fs/xfs/xfs_log.h
> > > +++ b/fs/xfs/xfs_log.h
> > > @@ -138,7 +138,7 @@ void	xlog_cil_process_committed(struct list_head *list);
> > >  bool	xfs_log_item_in_current_chkpt(struct xfs_log_item *lip);
> > >  
> > >  void	xfs_log_work_queue(struct xfs_mount *mp);
> > > -void	xfs_log_quiesce(struct xfs_mount *mp);
> > > +int	xfs_log_quiesce(struct xfs_mount *mp);
> > >  void	xfs_log_clean(struct xfs_mount *mp);
> > >  bool	xfs_log_check_lsn(struct xfs_mount *, xfs_lsn_t);
> > >  bool	xfs_log_in_recovery(struct xfs_mount *);
> > > -- 
> > > 2.26.2
> > > 
> > 
> 
