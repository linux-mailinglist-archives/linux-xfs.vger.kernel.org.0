Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F240320249
	for <lists+linux-xfs@lfdr.de>; Sat, 20 Feb 2021 01:48:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbhBTAsb (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 19 Feb 2021 19:48:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:60430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229722AbhBTAsb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 19 Feb 2021 19:48:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 09CD864EE2;
        Sat, 20 Feb 2021 00:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613782070;
        bh=P0ymx8DKb0n/au0eTZ3hHBMlc46QQMl9YxIpLyre0U4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PLEjjPRllGOW7L7o1SjAOS6MglMt2fk4c1lC0/bWoc1bmJgA+2AOuLmp4kCb6bXLg
         Btbu+WaC2bzmYBe71kFqcYoNMWqLKsMFM3bTkujEHVDOY0o40BhuiR6hehH0A86B5v
         mOjHu+LMPjzGbvJ3dfeFIWcRlMLLHTM1nzwea/IuEILf0v93mtY4k+6FdbX9AT8bWA
         VSH3zhKLMb+eoYzEAKbsksnVH54yAbx8i4VSptcMfKc3JU7BpAZaYztKs4e+Yc40/z
         zDJVGwtSQAZzGvRYEJ5X7IX/jc/0BPRCbR2xPE/28YUf3Q42h1dXlWJjj1KZq+AAE0
         XT9IU+5z48IQw==
Date:   Fri, 19 Feb 2021 16:47:48 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH 1/4] xfs_repair: set NEEDSREPAIR the first time we write
 to a filesystem
Message-ID: <20210220004748.GE7193@magnolia>
References: <161370467351.2389661.12577563230109429304.stgit@magnolia>
 <161370467918.2389661.3070940511114217130.stgit@magnolia>
 <fa46c3db-7598-3f16-f31d-c6adcc2b780a@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa46c3db-7598-3f16-f31d-c6adcc2b780a@sandeen.net>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 19, 2021 at 06:32:05PM -0600, Eric Sandeen wrote:
> On 2/18/21 9:17 PM, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Add a hook to the buffer cache so that xfs_repair can intercept the
> > first write to a V5 filesystem to set the NEEDSREPAIR flag.  In the
> > event that xfs_repair dirties the filesystem and goes down, this ensures
> > that the sysadmin will have to re-start repair before mounting.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  include/xfs_mount.h |    4 ++
> >  libxfs/rdwr.c       |    4 ++
> >  repair/xfs_repair.c |  102 +++++++++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 109 insertions(+), 1 deletion(-)
> > 
> > 
> > diff --git a/include/xfs_mount.h b/include/xfs_mount.h
> > index 75230ca5..f93a9f11 100644
> > --- a/include/xfs_mount.h
> > +++ b/include/xfs_mount.h
> > @@ -11,6 +11,8 @@ struct xfs_inode;
> >  struct xfs_buftarg;
> >  struct xfs_da_geometry;
> >  
> > +typedef void (*buf_writeback_fn)(struct xfs_buf *bp);
> > +
> >  /*
> >   * Define a user-level mount structure with all we need
> >   * in order to make use of the numerous XFS_* macros.
> > @@ -95,6 +97,8 @@ typedef struct xfs_mount {
> >  		int	qi_dqperchunk;
> >  	}			*m_quotainfo;
> >  
> > +	buf_writeback_fn	m_buf_writeback_fn;
> > +
> >  	/*
> >  	 * xlog is defined in libxlog and thus is not intialized by libxfs. This
> >  	 * allows an application to initialize and store a reference to the log
> > diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
> > index ac783ce3..ca272387 100644
> > --- a/libxfs/rdwr.c
> > +++ b/libxfs/rdwr.c
> > @@ -812,6 +812,10 @@ libxfs_bwrite(
> >  		return bp->b_error;
> >  	}
> >  
> > +	/* Trigger the writeback hook if there is one. */
> > +	if (bp->b_mount->m_buf_writeback_fn)
> > +		bp->b_mount->m_buf_writeback_fn(bp);
> > +
> >  	/*
> >  	 * clear any pre-existing error status on the buffer. This can occur if
> >  	 * the buffer is corrupt on disk and the repair process doesn't clear
> > diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> > index 90d1a95a..8eb7da53 100644
> > --- a/repair/xfs_repair.c
> > +++ b/repair/xfs_repair.c
> > @@ -725,7 +725,7 @@ clear_needsrepair(
> >  	 * that everything is ok with the ondisk filesystem.  Make sure any
> >  	 * dirty buffers are sent to disk and that the disks have persisted
> >  	 * writes to stable storage.  If that fails, leave NEEDSREPAIR in
> > -	 * place.  Don't purge the buffer cache here since we're not done yet.
> > +	 * place.
> 
> Just curious about this comment change...

Oh, I meant to delete this sentence entirely and deleted it from the
wrong patch.

> >  	 */
> >  	error = -libxfs_flush_mount(mp);
> >  	if (error) {
> > @@ -751,6 +751,102 @@ clear_needsrepair(
> >  		libxfs_buf_relse(bp);
> >  }
> >  
> > +static void
> > +update_sb_crc_only(
> > +	struct xfs_buf		*bp)
> > +{
> > +	xfs_buf_update_cksum(bp, XFS_SB_CRC_OFF);
> > +}
> > +
> > +/* Forcibly write the primary superblock with the NEEDSREPAIR flag set. */
> > +static void
> > +force_needsrepair(
> > +	struct xfs_mount	*mp)
> > +{
> > +	struct xfs_buf_ops	fake_ops;
> > +	struct xfs_buf		*bp;
> > +	int			error;
> > +
> > +	if (!xfs_sb_version_hascrc(&mp->m_sb) ||
> > +	    xfs_sb_version_needsrepair(&mp->m_sb))
> > +		return;
> > +
> > +	bp = libxfs_getsb(mp);
> > +	if (!bp || bp->b_error) {
> > +		do_log(
> > +	_("couldn't get superblock to set needsrepair, err=%d\n"),
> > +				bp ? bp->b_error : ENOMEM);
> > +	} else {
> > +		/*
> > +		 * It's possible that we need to set NEEDSREPAIR before we've
> > +		 * had a chance to fix the summary counters in the primary sb.
> > +		 * With the exception of those counters, phase 1 already
> > +		 * ensured that the geometry makes sense.
> > +		 *
> > +		 * Bad summary counters in the primary super can cause the
> > +		 * write verifier to fail, so substitute a dummy that only sets
> > +		 * the CRC.  In the event of a crash, NEEDSREPAIR will prevent
> > +		 * the kernel from mounting our potentially damaged filesystem
> > +		 * until repair is run again, so it's ok to bypass the usual
> > +		 * verification in this one case.
> > +		 */
> > +		fake_ops = xfs_sb_buf_ops; /* struct copy */
> > +		fake_ops.verify_write = update_sb_crc_only;
> > +
> > +		mp->m_sb.sb_features_incompat |=
> > +				XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
> > +		libxfs_sb_to_disk(bp->b_addr, &mp->m_sb);
> > +
> > +		/* Force the primary super to disk immediately. */
> > +		bp->b_ops = &fake_ops;
> > +		error = -libxfs_bwrite(bp);
> > +		bp->b_ops = &xfs_sb_buf_ops;
> > +		if (error)
> > +			do_log(_("couldn't force needsrepair, err=%d\n"), error);
> > +	}
> > +	if (bp)
> > +		libxfs_buf_relse(bp);
> > +}
> > +
> > +/*
> > + * Intercept the first non-super write to the filesystem so we can set
> > + * NEEDSREPAIR to protect the filesystem from mount in case of a crash.
> > + */
> > +static void
> > +repair_capture_writeback(
> > +	struct xfs_buf		*bp)
> > +{
> > +	struct xfs_mount	*mp = bp->b_mount;
> > +	static pthread_mutex_t	wb_mutex = PTHREAD_MUTEX_INITIALIZER;
> > +
> > +	/*
> > +	 * This write hook ignores any buffer that looks like a superblock to
> > +	 * avoid hook recursion when setting NEEDSREPAIR.  Higher level code
> > +	 * modifying an sb must control the flag manually.
> > +	 */
> 
> What does it mean to "control the flag manually?"

That means that if you want NEEDSREPAIR protection for your superblock
modification, you had better set it yourself.  This hook won't do it.

(It also means that anyone /clearing/ needsrepair also needs to know
what they're doing.)

> > +	if (bp->b_ops == &xfs_sb_buf_ops || bp->b_bn == XFS_SB_DADDR)
> > +		return;
> 
> humor me here... is it safe to be checking b_ops outside the mutex here, when
> it's going to be modified under the lock in force_needsrepair?

It should be, the bwrite caller in theory holds the buffer lock.

> I guess the b_bn check covers it, though... is there a reason to check the ops?

Paranoia, mostly.

> > +
> > +	pthread_mutex_lock(&wb_mutex);
> > +
> > +	/*
> > +	 * If someone else already dropped the hook, then needsrepair has
> > +	 * already been set on the filesystem and we can unlock.
> > +	 */
> > +	if (mp->m_buf_writeback_fn != repair_capture_writeback)
> > +		goto unlock;
> > +
> > +	/*
> > +	 * If we get here, the buffer being written is not a superblock, and
> > +	 * needsrepair needs to be set.  The hook is kept in place to plug all
> > +	 * other writes until the sb write finishes.
> > +	 */
> > +	force_needsrepair(mp);
> 
> 	/* we only do this once, so set the writeback_fn to NULL now */

Added.

--D

> > +	mp->m_buf_writeback_fn = NULL;
> > +unlock:
> > +	pthread_mutex_unlock(&wb_mutex);
> > +}
> > +
> >  int
> >  main(int argc, char **argv)
> >  {
> > @@ -847,6 +943,10 @@ main(int argc, char **argv)
> >  	if (verbose > 2)
> >  		mp->m_flags |= LIBXFS_MOUNT_WANT_CORRUPTED;
> >  
> > +	/* Capture the first writeback so that we can set needsrepair. */
> > +	if (xfs_sb_version_hascrc(&mp->m_sb))
> > +		mp->m_buf_writeback_fn = repair_capture_writeback;
> > +
> >  	/*
> >  	 * set XFS-independent status vars from the mount/sb structure
> >  	 */
> > 
