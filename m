Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EFFF27EFBC
	for <lists+linux-xfs@lfdr.de>; Wed, 30 Sep 2020 18:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728729AbgI3Qxw (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 30 Sep 2020 12:53:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:36531 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725355AbgI3Qxw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Sep 2020 12:53:52 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601484829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7wWTjIAE9DXRHAysoLju9URw2prtcdWDzqUGMG7k3Xo=;
        b=P7r489XoXwA+67Gl5efrF5JlxjAAidNrJt9ohQFQquCbIATU6XPVROPLndjaz2mi5tpSfj
        cs9FKRXpjw8BGaJ+f47uOVfTmwntyJg4mmOxNnScPtxQ5mQMd7BgXjWuL31DWvkVS5Anhb
        rf+yiupPuJEHZLr0gIi9GJocjG++MHw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-590-lMweyylsN-6D1cTrAP7uAA-1; Wed, 30 Sep 2020 12:53:45 -0400
X-MC-Unique: lMweyylsN-6D1cTrAP7uAA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AFC088015B0;
        Wed, 30 Sep 2020 16:53:44 +0000 (UTC)
Received: from bfoster (ovpn-116-218.rdu2.redhat.com [10.10.116.218])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 356125578A;
        Wed, 30 Sep 2020 16:53:44 +0000 (UTC)
Date:   Wed, 30 Sep 2020 12:53:42 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH RFC 3/3] xfs: rework quotaoff logging to avoid log
 deadlock on active fs
Message-ID: <20200930165342.GB3882@bfoster>
References: <20200929141228.108688-1-bfoster@redhat.com>
 <20200929141228.108688-4-bfoster@redhat.com>
 <20200929204808.GI14422@dread.disaster.area>
 <20200930133030.GA2649@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200930133030.GA2649@bfoster>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 30, 2020 at 09:30:30AM -0400, Brian Foster wrote:
> On Wed, Sep 30, 2020 at 06:48:08AM +1000, Dave Chinner wrote:
> > On Tue, Sep 29, 2020 at 10:12:28AM -0400, Brian Foster wrote:
> > > The quotaoff operation logs two log items. The start item is
> > > committed first, followed by the bulk of the in-core quotaoff
> > > processing, and then the quotaoff end item is committed to release
> > > the start item from the log. The problem with this mechanism is that
> > > quite a bit of processing can be required to release dquots from all
> > > in-core inodes and subsequently flush/purge all dquots in the
> > > system. This processing work doesn't generally generate much log
> > > traffic itself, but the start item pins the tail of the log. If an
> > > external workload consumes the remaining log space before the
> > > transaction for the end item is allocated, a log deadlock can occur.
> > > 
> > > The purpose of the separate start and end log items is primarily to
> > > ensure that log recovery does not incorrectly recover dquot data
> > > after an fs crash where a quotaoff was in progress. If we only
> > > logged a single quotaoff item, for example, it could fall behind the
> > > tail of the log before the last dquot modification was made and
> > > incorrectly replay dquot changes that might have occurred after the
> > > start item committed but before quotaoff deactivated the quota.
> > > 
> > > With that context, we can make some small changes to the quotaoff
> > > algorithm to provide the same general log ordering guarantee without
> > > such a large window to create a log deadlock vector. Rather than
> > > place a start item in the log for the duration of quotaoff
> > > processing, we can quiesce the transaction subsystem up front to
> > > guarantee that no further dquots are logged from that point forward.
> > > IOW, we freeze the transaction subsystem, commit the start item in a
> > > synchronous transaction that forces the log, deactivate the
> > > associated quota such that subsequent transactions no longer modify
> > > associated dquots, unfreeze the transaction subsystem and finally
> > > commit the quotaoff end item. The transaction freeze is somewhat of
> > > a heavy weight operation, but quotaoff is already a rare, slow and
> > > performance disruptive operation.
> > > 
> > > Altogether, this means that the dquot rele/purge sequence occurs
> > > after the quotaoff end item has committed and thus can technically
> > > fall off the active range of the log. This is safe because the
> > > remaining processing is all in-core work that doesn't involve
> > > logging dquots and we've guaranteed that no further dquots can be
> > > modified by external transactions. This allows quotaoff to complete
> > > without risking log deadlock regardless of how much dquot processing
> > > is required.
> > > 
> > > Suggested-by: Dave Chinner <david@fromorbit.com>
> > > Signed-off-by: Brian Foster <bfoster@redhat.com>
> > > ---
> > >  fs/xfs/xfs_qm_syscalls.c | 36 ++++++++++++++++--------------------
> > >  fs/xfs/xfs_trans_dquot.c |  2 ++
> > >  2 files changed, 18 insertions(+), 20 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
> > > index ca1b57d291dc..97844f33f70f 100644
> > > --- a/fs/xfs/xfs_qm_syscalls.c
> > > +++ b/fs/xfs/xfs_qm_syscalls.c
> > > @@ -29,7 +29,8 @@ xfs_qm_log_quotaoff(
> > >  	int			error;
> > >  	struct xfs_qoff_logitem	*qoffi;
> > >  
> > > -	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_quotaoff, 0, 0, 0, &tp);
> > > +	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_qm_quotaoff, 0, 0,
> > > +				XFS_TRANS_NO_WRITECOUNT, &tp);
> > >  	if (error)
> > >  		goto out;
> > >  
> > > @@ -169,14 +170,18 @@ xfs_qm_scall_quotaoff(
> > >  	if ((mp->m_qflags & flags) == 0)
> > >  		goto out_unlock;
> > >  
> > > +	xfs_trans_freeze(mp);
> > > +
> > >  	/*
> > >  	 * Write the LI_QUOTAOFF log record, and do SB changes atomically,
> > >  	 * and synchronously. If we fail to write, we should abort the
> > >  	 * operation as it cannot be recovered safely if we crash.
> > >  	 */
> > >  	error = xfs_qm_log_quotaoff(mp, &qoffstart, flags);
> > > -	if (error)
> > > +	if (error) {
> > > +		xfs_trans_unfreeze(mp);
> > >  		goto out_unlock;
> > > +	}
> > >  
> > >  	/*
> > >  	 * Next we clear the XFS_MOUNT_*DQ_ACTIVE bit(s) in the mount struct
> > > @@ -191,6 +196,15 @@ xfs_qm_scall_quotaoff(
> > >  	 */
> > >  	mp->m_qflags &= ~inactivate_flags;
> > >  
> > > +	xfs_trans_unfreeze(mp);
> > > +
> > > +	error = xfs_qm_log_quotaoff_end(mp, &qoffstart, flags);
> > > +	if (error) {
> > > +		/* We're screwed now. Shutdown is the only option. */
> > > +		xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
> > > +		goto out_unlock;
> > > +	}
> > > +
> > 
> > The m_qflags update is racy. There's no memory barriers or locks
> > here to order the mp->m_qflags update with other CPUs, so there's no
> > guarantee that an incoming transaction will see the m_qflags change
> > that disables quotas.
> > 
> 
> The transaction freeze is based on a percpu rwsem (I've replaced the
> abuse of the freeze lock with our own lock in patch 2). That documents a
> memory barrier on the read side, but that appears to be down in
> __percpu_down_read_trylock() (or percpu_rwsem_wait()). What isn't clear
> to me is whether the higher level RCU fast path has similar semantics,
> particularly in the case where a racing transaction allocates just after
> the transaction unfreeze...
> 
> Hmm... it seems not, but the rcu sync state managed by the lock appears
> to be reentrant. I'm wondering if we could do something like grab the
> write lock in the quotaoff path, re-enter the rcu sync state explicitly,
> do the quotaoff bits, unlock, then hold the extra rcu sync entry until
> the dqrele scan completes. That means transactions would temporarily hit
> the memory barrier via the read lock until we can fall back to the
> current ilock ordering scheme. OTOH, I don't see any precedent for
> something like that elsewhere in the kernel, though cgroups does
> something very similar by forcing the slow path unconditionally via
> rcu_sync_enter_start(). This would presumably just do that
> dynamically/temporarily. Thoughts?
> 

After digging further into it, this doesn't appear to be a viable option
because the associated rcu_sync_*() symbols aren't exported..

Brian

> For reference, the current quotaoff implementation appears to rely on
> the order of the flag update before the dqrele scan as it assumes racing
> transactions check quota active state under the ilock:
> 
>         /*
>          * Next we clear the XFS_MOUNT_*DQ_ACTIVE bit(s) in the mount struct
>          * to take care of the race between dqget and quotaoff. We don't take
>          * any special locks to reset these bits. All processes need to check
>          * these bits *after* taking inode lock(s) to see if the particular
>          * quota type is in the process of being turned off. If *ACTIVE, it is
>          * guaranteed that all dquot structures and all quotainode ptrs will all
>          * stay valid as long as that inode is kept locked.
>          *
>          * There is no turning back after this.
>          */
>         mp->m_qflags &= ~inactivate_flags;
> 
> IOW, since quotaoff scans and cycles every ilock, the dqrele scan
> essentially serves as the barrier for racing transactions checking quota
> active state (under ilock).
> 
> > Also, we can now race with other transaction reservations to log the
> > quota off end item, which means that if there are enough pending
> > transactions reservations queued before the quotaoff_end transaction
> > is started, the quotaoff item can pin the tail of the log and we
> > deadlock.
> > 
> 
> That thought crossed my mind, but I didn't think it was possible in
> practice. It's easy enough to commit the end transaction with
> transactions paused as well so I'll make that change.
> 
> > That was the reason why I logged both quota off items in the same
> > transaction in the prototype code I send out - we have to log both
> > quota-off items while the transaction subsystem is quiesced
> > otherwise we don't fix the original problem (that the quotaoff
> > item can pin the tail of the log and deadlock).....
> > 
> 
> The prototype code logged both transactions within the quota transaction
> quiesce window, not both items in the same transaction. IIRC, we
> discussed eventually doing that along with some other potential
> cleanups, but I'm not looking to do any of that before the fundamental
> algorithm rework settles...
> 
> Brian
> 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> > 
> 

