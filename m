Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11F9F39005D
	for <lists+linux-xfs@lfdr.de>; Tue, 25 May 2021 13:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbhEYLzO (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 May 2021 07:55:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24416 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231434AbhEYLzO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 May 2021 07:55:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621943624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5oxC4rpch011NjytZYdmMD7f6tsaVcwH/Xu6XegBpJY=;
        b=UakdKz8GQZR7qtDl4I7wbT0TqxpEknBb1RA1HD2ysOyErX/4nmA9jRrzr/vQFtSw4bWCaM
        Ep0PIDZBPgm8rSt98AViysE39JFHcSlasyUpS/o+S3RrChxf5+NMf6+L9HkjWsGffbPodj
        YlVGYkY/VD4NnuiQPdkHnPXURPEWOzw=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-Tujjn2f2Nzy_OebEaB5XpQ-1; Tue, 25 May 2021 07:53:42 -0400
X-MC-Unique: Tujjn2f2Nzy_OebEaB5XpQ-1
Received: by mail-qt1-f198.google.com with SMTP id s11-20020ac8758b0000b029020e731296abso15521171qtq.22
        for <linux-xfs@vger.kernel.org>; Tue, 25 May 2021 04:53:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5oxC4rpch011NjytZYdmMD7f6tsaVcwH/Xu6XegBpJY=;
        b=EDyo2D82Mi+O1kcizCpO4qUXslkF7T53VQXy5KriZJGVSnJo/jOm6VGN7IknWIYCXE
         o5LGsu11OT1fqSdvumIO+GZV0QeMXFUvkcBedq3Tk7fAMs1GPLtNgf4as5oaJYQAIEJj
         EcCnO2a0Rs8riW2/1oM1ukOvTlYWbkZQxmAIqKmrZFKgJn55MH12/i0qFDnl4UUDsghX
         uBi1OJjSEG/Q+z6tsIc9PBjojtZ2f2K5RQhbq1OHihI2v3tPffG0rR/HgukxdgBcKyqw
         H0aQS1nsEew1W9H3GdlkuXVMTDYX1CGYJL2cs8stQj6y8WJzupWam0ra7EhDPuVJ9Rr+
         z9aQ==
X-Gm-Message-State: AOAM530y2cYgDg8MbZ0w3aDLCHqkslmuAL8/JQg2o15ovvMnrMrJP4Oc
        KGm4re45KMNm2kKMBZ9ctegYK22Xe++hAcC1wSI58+0jZ8cBIm/8J9QM7XrEGPYTqwbTlLEG93S
        +CqFM41cYh2kNUtgJZQ60
X-Received: by 2002:a05:6214:88a:: with SMTP id cz10mr36227738qvb.52.1621943622150;
        Tue, 25 May 2021 04:53:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzf6bzVawBY+7DmvfNoOo5WSBXF5bkNoQoUa3OHPOR2jfi7Iad3+IBND1Phrg/J7TVdCg/prw==
X-Received: by 2002:a05:6214:88a:: with SMTP id cz10mr36227702qvb.52.1621943621806;
        Tue, 25 May 2021 04:53:41 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id r5sm11982975qtp.75.2021.05.25.04.53.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 04:53:41 -0700 (PDT)
Date:   Tue, 25 May 2021 07:53:39 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org
Subject: Re: [PATCH 2/2] xfs: validate extsz hints against rt extent size
 when rtinherit is set
Message-ID: <YKzlQ3HPkc9rZb1t@bfoster>
References: <162181807472.202929.18194381144862527586.stgit@locust>
 <162181808584.202929.10474310046605173335.stgit@locust>
 <YKuDFNdxIqLKfIbg@bfoster>
 <20210524172328.GA202121@locust>
 <YKvum6AFV03hwxrR@bfoster>
 <20210524212607.GC202121@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210524212607.GC202121@locust>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 24, 2021 at 02:26:07PM -0700, Darrick J. Wong wrote:
> On Mon, May 24, 2021 at 02:21:15PM -0400, Brian Foster wrote:
> > On Mon, May 24, 2021 at 10:23:28AM -0700, Darrick J. Wong wrote:
> > > On Mon, May 24, 2021 at 06:42:28AM -0400, Brian Foster wrote:
> > > > On Sun, May 23, 2021 at 06:01:25PM -0700, Darrick J. Wong wrote:
> > > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > > 
> > > > > The RTINHERIT bit can be set on a directory so that newly created
> > > > > regular files will have the REALTIME bit set to store their data on the
> > > > > realtime volume.  If an extent size hint (and EXTSZINHERIT) are set on
> > > > > the directory, the hint will also be copied into the new file.
> > > > > 
> > > > > As pointed out in previous patches, for realtime files we require the
> > > > > extent size hint be an integer multiple of the realtime extent, but we
> > > > > don't perform the same validation on a directory with both RTINHERIT and
> > > > > EXTSZINHERIT set, even though the only use-case of that combination is
> > > > > to propagate extent size hints into new realtime files.  This leads to
> > > > > inode corruption errors when the bad values are propagated.
> > > > > 
> > > > > Because there may be existing filesystems with such a configuration, we
> > > > > cannot simply amend the inode verifier to trip on these directories and
> > > > > call it a day because that will cause previously "working" filesystems
> > > > > to start throwing errors abruptly.  Note that it's valid to have
> > > > > directories with rtinherit set even if there is no realtime volume, in
> > > > > which case the problem does not manifest because rtinherit is ignored if
> > > > > there's no realtime device; and it's possible that someone set the flag,
> > > > > crashed, repaired the filesystem (which clears the hint on the realtime
> > > > > file) and continued.
> > > > > 
> > > > > Therefore, mitigate this issue in several ways: First, if we try to
> > > > > write out an inode with both rtinherit/extszinherit set and an unaligned
> > > > > extent size hint, we'll simply turn off the hint to correct the error.
> > > > > Second, if someone tries to misconfigure a file via the fssetxattr
> > > > > ioctl, we'll fail the ioctl.  Third, we reverify both extent size hint
> > > > > values when we propagate heritable inode attributes from parent to
> > > > > child, so that we prevent misconfigurations from spreading.
> > > > > 
> > > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > > ---
> > > > >  fs/xfs/libxfs/xfs_inode_buf.c   |   13 +++++++++++++
> > > > >  fs/xfs/libxfs/xfs_trans_inode.c |   15 +++++++++++++++
> > > > >  fs/xfs/xfs_inode.c              |   29 +++++++++++++++++++++++++++++
> > > > >  fs/xfs/xfs_ioctl.c              |   15 +++++++++++++++
> > > > >  4 files changed, 72 insertions(+)
> > > > > 
> > > > > 
> > > > > diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> > > > > index 045118c7bf78..23c19e632c2d 100644
> > > > > --- a/fs/xfs/libxfs/xfs_inode_buf.c
> > > > > +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> > > > > @@ -589,6 +589,19 @@ xfs_inode_validate_extsize(
> > > > >  	inherit_flag = (flags & XFS_DIFLAG_EXTSZINHERIT);
> > > > >  	extsize_bytes = XFS_FSB_TO_B(mp, extsize);
> > > > >  
> > > > > +	/*
> > > > > +	 * This comment describes a historic gap in this verifier function.
> > > > > +	 * On older kernels, XFS doesnt't check that the extent size hint is
> > > > > +	 * an integer multiple of the rt extent size on a directory with both
> > > > > +	 * RTINHERIT and EXTSZINHERIT flags set.  This results in corruption
> > > > > +	 * shutdowns when the misaligned hint propagates into new realtime
> > > > > +	 * files, since they do check the rextsize alignment of the hint for
> > > > > +	 * files with the REALTIME flag set.  There could be filesystems with
> > > > > +	 * misconfigured directories in the wild, so we cannot add it to the
> > > > > +	 * verifier now because that would cause new corruption shutdowns on
> > > > > +	 * the directories.
> > > > > +	 */
> > > > > +
> > > > 
> > > > One of the things that confused me about the previous version is whether
> > > > the verifier changes would have triggered corruption on read of a
> > > > misconfigured inode.
> > > 
> > > Yes, it would have, so I switched strategies...
> > > 
> > > > If so, that seems to conflict with propagation
> > > > mitigation if we can't read such a pre-existing inode in the first
> > > > place. Is that not still a factor here too?
> > > 
> > > ...completely away from making any code changes to the verifier.
> > > So to answer your question, it should not be a factor any more.
> > > 
> > 
> > Right.. what I mean to ask is whether it's worth mentioning in the
> > comment we're adding here. ISTM it is, because the flag mitigation
> > strategy depends on being able to actually read the historically broken
> > inodes. At the very least, that tells somebody who might be cleverly
> > trying to get around the caveat in the comment that they might need to
> > consider the external code when making changes to the verifier.
> 
> <nod> This whole thing 
> 
> > 
> > > > >  	if (rt_flag)
> > > > >  		blocksize_bytes = mp->m_sb.sb_rextsize << mp->m_sb.sb_blocklog;
> > > > >  	else
> > > > > diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
> > > > > index 78324e043e25..325f2dceec13 100644
> > > > > --- a/fs/xfs/libxfs/xfs_trans_inode.c
> > > > > +++ b/fs/xfs/libxfs/xfs_trans_inode.c
> > > > > @@ -142,6 +142,21 @@ xfs_trans_log_inode(
> > > > >  		flags |= XFS_ILOG_CORE;
> > > > >  	}
> > > > >  
> > > > > +	/*
> > > > > +	 * Inode verifiers on older kernels don't check that the extent size
> > > > > +	 * hint is an integer multiple of the rt extent size on a directory
> > > > > +	 * with both rtinherit and extszinherit flags set.  If we're logging a
> > > > > +	 * directory that is misconfigured in this way, clear the hint.
> > > > > +	 */
> > > > > +	if ((ip->i_diflags & XFS_DIFLAG_RTINHERIT) &&
> > > > > +	    (ip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) &&
> > > > > +	    (ip->i_extsize % ip->i_mount->m_sb.sb_rextsize) > 0) {
> > > > > +		ip->i_diflags &= ~(XFS_DIFLAG_EXTSIZE |
> > > > > +				   XFS_DIFLAG_EXTSZINHERIT);
> > > > > +		ip->i_extsize = 0;
> > > > > +		flags |= XFS_ILOG_CORE;
> > > > > +	}
> > > > > +
> > > > 
> > > > Hmm.. if we're going to also clear the state from preexisting
> > > > directories (vs. just mitigate propagation), it kind of makes me wonder
> > > > why we wouldn't just clear the bad settings from in-core inodes on read.
> > > 
> > > Making corrections at iget time is complicated -- of the callers that
> > > pass in a transaction, I'd would have to check every call site carefully
> > > to ensure that we don't cancel what would otherwise be a clean
> > > transaction, since that would lead to a shutdown.  The non-transaction
> > > iget callsites would each have to grow a call to get a transaction,
> > > update the inode, and commit it.  We'd have to be careful to make sure
> > > that all new iget callsites do this properly, forever.  We could make
> > > the change nontransactionally and wait for someone to log the icore to
> > > persist the changes, but that's always frowned upon.
> > > 
> > 
> > The latter is more what I had in mind.. just filter out the bad state
> > in-core (perhaps with a one-shot warning to let the user know this fs
> > has the oddity) and let further modifications commit the change or not.
> > I agree that it's probably overkill to introduce a transaction to
> > persist a fix at read time where one does not already exist. But if
> > we're going to silently modify what's on-disk anyways, I'm not sure I
> > see a major problem with clearing it on read if it otherwise results in
> > the same behavior. I believe we used to convert old (v1) inodes to v2 in
> > a similar manner when read off disk into the in-core structure.
> > 
> > FWIW, the reason I ask in this case is just to see if we can achieve the
> > same desired behavior with less code. This seems like quite a rare case,
> > so I think it would be a slightly unfortunate to have code spread in
> > various places, including a non-trivial comment in the verifier, for
> > something that could potentially be isolated to a single bit of
> > filtering logic at or near the read verifier. Of course if I'm mistaken
> > about the potential simplification, then I don't have any major issue
> > with what the patch is currently doing..
> 
> Agreed that all of this would be a lot less complex if I modified
> xfs_iget to detect and zero out the hint (without bothering to schedule
> a transaction to commit it), but I tried setting DIFLAG2_BIGTIME in one
> of the earlier y2038+ patchset revisions and caught criticism for
> making the incore state inconsistent with the ondisk state.  I think
> that's why all the inode upgrades and whatnot end up in
> xfs_trans_log_inode, because they're effectively free there.
> 

Ok. Just for reference, I think there is some precedent for doing an
in-core only conversion in that xfs_inode_from_disk() (or previously,
xfs_iread()) has converted old v1 inodes for quite some time without any
apparent problem. I can absolutely see this type of strategy not being
something we want to adopt generically, for frequent conversions or
things that might be associated with new features, etc. At the same time
I think insistence that this suddenly needs to be avoided at all costs
is a bit unreasonable and slightly inconsistent with reality. As you've
already pointed out, this particular scenario is a very rare historical
corner case that already likely involved corruption errors. I think it's
reasonable to strip the misconfiguration at read time and provide a
oneshot warning to at least give users who might prefer to repair/modify
the filesystem the opportunity to do so before we decide to fix it for
them piecemeal.

That's all just my .02 though. I think my preference would still be to
fix the verifier and consider something more involved if somebody
actually complains. It's just a hint at the end of the day so I'm fine
with this approach if that's still what you prefer amongst the various
options..

Brian

> > 
> > > That's why I decided to go with making updates in xfs_trans_log_inode,
> > > since (a) it's not going to burn a bunch of human time, (b) it's where
> > > we perform other silent inode upgrades, and (c) it doesn't generate any
> > > new log traffic.
> > > 
> > > However, I just had a thought--
> > > 
> > > This patch doesn't do anything to fix the case of existing realtime
> > > regular files with an invalid hint.  The only time the invalid hint
> > > actually bites us is in xfs_bmap_rtalloc.  To fix that case, all I need
> > > to do is amend xfs_trans_log_inode to fix realtime files too, and then
> > > update xfs_bmap_rtalloc:
> > > 
> > > 	align = xfs_get_extsz_hint(ap->ip);
> > > 
> > > to check for bad hints:
> > > 
> > > 	align = xfs_get_extsz_hint(ap->ip);
> > > 	if (align > mp->m_sb.sb_rextsize &&
> > > 	    align % mp->m_sb.sb_rextsize)
> > > 		align = mp->m_sb.sb_rextsize;
> > > 
> > > If the allocation succeeds, then the rt file's inode (which is already
> > > ijoined) gets logged, at which point we'll correct the inode.
> > > 
> > 
> > Hmm.. that sounds reasonable in principle, but it's not clear to me if
> > you mean to combine that with the explicit propagation prevention or use
> > it in place of it. As above, I'm still curious if the implementation for
> > this behavior needs to be more involved than 1. prevent new bad
> > configurations in the ioctl path and 2. filter out the pre-existing bad
> > settings at read time and let them persist naturally.
> > 
> > Also if this is already more than likely a fatal error, I don't think
> > I'd object to just letting the verifier fail and fixing the problem via
> > repair (or filtering the verifier failure to the case where failure was
> > otherwise imminent; the historical situation is a little unclear to me
> > tbh).
> 
> AFAICT from spelunking the source code, the extent size verification
> code has enforced (extsize % rextsize)==0 for realtime files since the
> beginning of git, but has never enforced that for propagation from a
> directory.
> 
> So while it's /really/ tempting to classify this an edge case (realtime)
> of an edge case (rextsize > 1) of an edge case (rtinherit and
> extszinherit both set) and break the old filesystems, I'm not
> comfortable with breaking existing users.  I'll certainly post an
> xfs_repair patch to flag and clear these directories, however.
> 
> --D
> 
> > 
> > Brian
> > 
> > > > Wouldn't that also prevent the state from propagating and/or clear it
> > > > from directories on next modification?
> > > 
> > > Yes, but with the reviewer costs mentioned above.
> > > 
> > > --D
> > > 
> > > > 
> > > > Brian
> > > > 
> > > > >  	/*
> > > > >  	 * Record the specific change for fdatasync optimisation. This allows
> > > > >  	 * fdatasync to skip log forces for inodes that are only timestamp
> > > > > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > > > > index 0369eb22c1bb..e4c2da4566f1 100644
> > > > > --- a/fs/xfs/xfs_inode.c
> > > > > +++ b/fs/xfs/xfs_inode.c
> > > > > @@ -690,6 +690,7 @@ xfs_inode_inherit_flags(
> > > > >  	const struct xfs_inode	*pip)
> > > > >  {
> > > > >  	unsigned int		di_flags = 0;
> > > > > +	xfs_failaddr_t		failaddr;
> > > > >  	umode_t			mode = VFS_I(ip)->i_mode;
> > > > >  
> > > > >  	if (S_ISDIR(mode)) {
> > > > > @@ -729,6 +730,24 @@ xfs_inode_inherit_flags(
> > > > >  		di_flags |= XFS_DIFLAG_FILESTREAM;
> > > > >  
> > > > >  	ip->i_diflags |= di_flags;
> > > > > +
> > > > > +	/*
> > > > > +	 * Inode verifiers on older kernels only check that the extent size
> > > > > +	 * hint is an integer multiple of the rt extent size on realtime files.
> > > > > +	 * They did not check the hint alignment on a directory with both
> > > > > +	 * rtinherit and extszinherit flags set.  If the misaligned hint is
> > > > > +	 * propagated from a directory into a new realtime file, new file
> > > > > +	 * allocations will fail due to math errors in the rt allocator and/or
> > > > > +	 * trip the verifiers.  Validate the hint settings in the new file so
> > > > > +	 * that we don't let broken hints propagate.
> > > > > +	 */
> > > > > +	failaddr = xfs_inode_validate_extsize(ip->i_mount, ip->i_extsize,
> > > > > +			VFS_I(ip)->i_mode, ip->i_diflags);
> > > > > +	if (failaddr) {
> > > > > +		ip->i_diflags &= ~(XFS_DIFLAG_EXTSIZE |
> > > > > +				   XFS_DIFLAG_EXTSZINHERIT);
> > > > > +		ip->i_extsize = 0;
> > > > > +	}
> > > > >  }
> > > > >  
> > > > >  /* Propagate di_flags2 from a parent inode to a child inode. */
> > > > > @@ -737,12 +756,22 @@ xfs_inode_inherit_flags2(
> > > > >  	struct xfs_inode	*ip,
> > > > >  	const struct xfs_inode	*pip)
> > > > >  {
> > > > > +	xfs_failaddr_t		failaddr;
> > > > > +
> > > > >  	if (pip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE) {
> > > > >  		ip->i_diflags2 |= XFS_DIFLAG2_COWEXTSIZE;
> > > > >  		ip->i_cowextsize = pip->i_cowextsize;
> > > > >  	}
> > > > >  	if (pip->i_diflags2 & XFS_DIFLAG2_DAX)
> > > > >  		ip->i_diflags2 |= XFS_DIFLAG2_DAX;
> > > > > +
> > > > > +	/* Don't let invalid cowextsize hints propagate. */
> > > > > +	failaddr = xfs_inode_validate_cowextsize(ip->i_mount, ip->i_cowextsize,
> > > > > +			VFS_I(ip)->i_mode, ip->i_diflags, ip->i_diflags2);
> > > > > +	if (failaddr) {
> > > > > +		ip->i_diflags2 &= ~XFS_DIFLAG2_COWEXTSIZE;
> > > > > +		ip->i_cowextsize = 0;
> > > > > +	}
> > > > >  }
> > > > >  
> > > > >  /*
> > > > > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > > > > index 6407921aca96..1fe4c1fc0aea 100644
> > > > > --- a/fs/xfs/xfs_ioctl.c
> > > > > +++ b/fs/xfs/xfs_ioctl.c
> > > > > @@ -1291,6 +1291,21 @@ xfs_ioctl_setattr_check_extsize(
> > > > >  
> > > > >  	new_diflags = xfs_flags2diflags(ip, fa->fsx_xflags);
> > > > >  
> > > > > +	/*
> > > > > +	 * Inode verifiers on older kernels don't check that the extent size
> > > > > +	 * hint is an integer multiple of the rt extent size on a directory
> > > > > +	 * with both rtinherit and extszinherit flags set.  Don't let sysadmins
> > > > > +	 * misconfigure directories.
> > > > > +	 */
> > > > > +	if ((new_diflags & XFS_DIFLAG_RTINHERIT) &&
> > > > > +	    (new_diflags & XFS_DIFLAG_EXTSZINHERIT)) {
> > > > > +		unsigned int	rtextsize_bytes;
> > > > > +
> > > > > +		rtextsize_bytes = XFS_FSB_TO_B(mp, mp->m_sb.sb_rextsize);
> > > > > +		if (fa->fsx_extsize % rtextsize_bytes)
> > > > > +			return -EINVAL;
> > > > > +	}
> > > > > +
> > > > >  	failaddr = xfs_inode_validate_extsize(ip->i_mount,
> > > > >  			XFS_B_TO_FSB(mp, fa->fsx_extsize),
> > > > >  			VFS_I(ip)->i_mode, new_diflags);
> > > > > 
> > > > 
> > > 
> > 
> 

