Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1A4453695
	for <lists+linux-xfs@lfdr.de>; Tue, 16 Nov 2021 17:00:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238688AbhKPQCa (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 16 Nov 2021 11:02:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:32937 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238705AbhKPQCJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Nov 2021 11:02:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637078350;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rJKh/tDxbJLOM1jovsZTs7uOGsWHNg53u3z4dP3ZmSY=;
        b=QaJOs5qlbnrclYNX4+iA6aC7Qy3RG3IkxCDzX9Ihe3ar4PudVpRGM5lixk/USlc6d/spio
        cWcbzdbEM5BIiofxBdQ2OtQ3RFCoWvUDY+2vLmpeVQpguxK3Ha7VX2jwpZ1hB/ouLUtAKr
        Vb+eAWcRF4quJxSERA+TV6d6YyC4w+Y=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-21-eauVOVbAM1S6S9jPNi02tQ-1; Tue, 16 Nov 2021 10:59:09 -0500
X-MC-Unique: eauVOVbAM1S6S9jPNi02tQ-1
Received: by mail-qv1-f72.google.com with SMTP id kk1-20020a056214508100b003a9d1b987caso19575243qvb.4
        for <linux-xfs@vger.kernel.org>; Tue, 16 Nov 2021 07:59:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=rJKh/tDxbJLOM1jovsZTs7uOGsWHNg53u3z4dP3ZmSY=;
        b=kbf+YIxRx6GmF8nmXl3fSEcX3QDTD3UU5voOMFYWibFfCR25jL38jIIMrP95Gsa9Nz
         THMX2vgQTk2atHRMnfzagm0FCyyywwT4bCuqmpfMz3WxlJN8JkDCr3hvOfC1M3+sYSuc
         DX2BLHOkqyJLS28Dt5s38Adz7oT3/4+t23TfhZzCov0wFkaV4kjmFI+7Ypi7T1HEr715
         zUIn9+233xuHpg+QgnxaaxY/V3E7b/RYkz1LNSKwz8/UrRN4QpBMsmS0L/lfPZn2PMP0
         C7u2K0677oONgDFaGoyULf166yJHSvuohJwG60wcygrApXTuyDmVWNmdmFaOBUeOS3ol
         6G1Q==
X-Gm-Message-State: AOAM5314sik1H5u3VxdJi94CEUwLLfAv1XmprNDY+bgwWyxyQ9vdvf6p
        +VOY0czS8K+bK0gF8hK9APIljMVvF9LasQwYWLeTx4y9slMZFP0dRBnlyktO22qVLdRLgBz57MP
        DGelGVh25r/uBnHFjSUI4
X-Received: by 2002:ad4:5e87:: with SMTP id jl7mr46431007qvb.19.1637078348720;
        Tue, 16 Nov 2021 07:59:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxRfD9F8oUTPVVfk/IThpumP3GxsUzPnxyw+7w4Jb+3MfOWaFnro2Dh0MhQ3xrJipX2rYeNoQ==
X-Received: by 2002:ad4:5e87:: with SMTP id jl7mr46430981qvb.19.1637078348396;
        Tue, 16 Nov 2021 07:59:08 -0800 (PST)
Received: from bfoster (c-24-61-119-116.hsd1.ma.comcast.net. [24.61.119.116])
        by smtp.gmail.com with ESMTPSA id bl28sm9159619qkb.44.2021.11.16.07.59.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 07:59:07 -0800 (PST)
Date:   Tue, 16 Nov 2021 10:59:05 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Ian Kent <raven@themaw.net>, Miklos Szeredi <miklos@szeredi.hu>,
        xfs <linux-xfs@vger.kernel.org>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Howells <dhowells@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] xfs: make sure link path does not go away at access
Message-ID: <YZPVSTDIWroHNvFS@bfoster>
References: <163660195990.22525.6041281669106537689.stgit@mickey.themaw.net>
 <163660197073.22525.11235124150551283676.stgit@mickey.themaw.net>
 <20211112003249.GL449541@dread.disaster.area>
 <CAJfpegvHDM_Mtc8+ASAcmNLd6RiRM+KutjBOoycun_Oq2=+p=w@mail.gmail.com>
 <20211114231834.GM449541@dread.disaster.area>
 <CAJfpegu4BwJD1JKngsrzUs7h82cYDGpxv0R1om=WGhOOb6pZ2Q@mail.gmail.com>
 <20211115222417.GO449541@dread.disaster.area>
 <f8425d1270fe011897e7e14eaa6ba8a77c1ed077.camel@themaw.net>
 <20211116030120.GQ449541@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211116030120.GQ449541@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 16, 2021 at 02:01:20PM +1100, Dave Chinner wrote:
> On Tue, Nov 16, 2021 at 09:03:31AM +0800, Ian Kent wrote:
> > On Tue, 2021-11-16 at 09:24 +1100, Dave Chinner wrote:
> > > On Mon, Nov 15, 2021 at 10:21:03AM +0100, Miklos Szeredi wrote:
> > > > On Mon, 15 Nov 2021 at 00:18, Dave Chinner <david@fromorbit.com>
> > > > wrote:
> > > > > I just can't see how this race condition is XFS specific and why
> > > > > fixing it requires XFS to sepcifically handle it while we ignore
> > > > > similar theoretical issues in other filesystems...
> > > > 
> > > > It is XFS specific, because all other filesystems RCU free the in-
> > > > core
> > > > inode after eviction.
> > > > 
> > > > XFS is the only one that reuses the in-core inode object and that
> > > > is
> > > > very much different from anything the other filesystems do and what
> > > > the VFS expects.
> > > 
> > > Sure, but I was refering to the xfs_ifree issue that the patch
> > > addressed, not the re-use issue that the *first patch addressed*.
> > > 
> > > > I don't see how clearing the quick link buffer in
> > > > ext4_evict_inode()
> > > > could do anything bad.  The contents are irrelevant, the lookup
> > > > will
> > > > be restarted anyway, the important thing is that the buffer is not
> > > > freed and that it's null terminated, and both hold for the ext4,
> > > > AFAICS.
> > > 
> > > You miss the point (which, admittedly, probably wasn't clear).
> > > 
> > > I suggested just zeroing the buffer in xfs_ifree instead of zeroing
> > > it, which you seemed to suggest wouldn't work and we should move the
> > > XFS functionality to .free_inode. That's what I was refering to as
> > > "not being XFS specific" - if it is safe for ext4 to zero the link
> > > buffer in .evict while lockless lookups can still be accessing the
> > > link buffer, it is safe for XFS to do the same thing in .destroy
> > > context.
> > 
> > I'll need to think about that for a while.
> > 
> > Zeroing the buffer while it's being used seems like a problem to
> > me and was what this patch was trying to avoid.
> 
> *nod*
> 
> That was my reading of the situation when I saw what ext4 was doing.
> But Miklos says that this is fine, and I don't know the code well
> enough to say he's wrong. So if it's ok for ext4, it's OK for XFS.
> If it's not OK for XFS, then it isn't OK for ext4 either, and we
> have more bugs to fix than just in XFS.
> 
> > I thought all that would be needed for this to happen is for a
> > dentry drop to occur while the link walk was happening after
> > ->get_link() had returned the pointer.
> > 
> > What have I got wrong in that thinking?
> 
> Nothing that I can see, but see my previous statement above.
> 
> I *think* that just zeroing the buffer means the race condition
> means the link resolves as either wholly intact, partially zeroed
> with trailing zeros in the length, wholly zeroed or zero length.
> Nothing will crash, the link string is always null terminated even
> if the length is wrong, and so nothing bad should happen as a result
> of zeroing the symlink buffer when it gets evicted from the VFS
> inode cache after unlink.
> 
> > > If it isn't safe for ext4 to do that, then we have a general
> > > pathwalk problem, not an XFS issue. But, as you say, it is safe
> > > to do this zeroing, so the fix to xfs_ifree() is to zero the
> > > link buffer instead of freeing it, just like ext4 does.
> > > 
> > > As a side issue, we really don't want to move what XFS does in
> > > .destroy_inode to .free_inode because that then means we need to
> > > add synchronise_rcu() calls everywhere in XFS that might need to
> > > wait on inodes being inactivated and/or reclaimed. And because
> > > inode reclaim uses lockless rcu lookups, there's substantial
> > > danger of adding rcu callback related deadlocks to XFS here.
> > > That's just not a direction we should be moving in.
> > 
> > Another reason I decided to use the ECHILD return instead is that
> > I thought synchronise_rcu() might add an unexpected delay.
> 
> It depends where you put the synchronise_rcu() call. :)
> 
> > Since synchronise_rcu() will only wait for processes that
> > currently have the rcu read lock do you think that could actually
> > be a problem in this code path?
> 
> No, I don't think it will.  The inode recycle case in XFS inode
> lookup can trigger in two cases:
> 
> 1. VFS cache eviction followed by immediate lookup
> 2. Inode has been unlinked and evicted, then free and reallocated by
> the filesytsem.
> 
> In case #1, that's a cold cache lookup and hence delays are
> acceptible (e.g. a slightly longer delay might result in having to
> fetch the inode from disk again). Calling synchronise_rcu() in this
> case is not going to be any different from having to fetch the inode
> from disk...
> 
> In case #2, there's a *lot* of CPU work being done to modify
> metadata (inode btree updates, etc), and so the operations can block
> on journal space, metadata IO, etc. Delays are acceptible, and could
> be in the order of hundreds of milliseconds if the transaction
> subsystem is bottlenecked. waiting for an RCU grace period when we
> reallocate an indoe immediately after freeing it isn't a big deal.
> 
> IOWs, if synchronize_rcu() turns out to be a problem, we can
> optimise that separately - we need to correct the inode reuse
> behaviour w.r.t. VFS RCU expectations, then we can optimise the
> result if there are perf problems stemming from correct behaviour.
> 

FWIW, with a fairly crude test on a high cpu count system, it's not that
difficult to reproduce an observable degradation in inode allocation
rate with a synchronous grace period in the inode reuse path, caused
purely by a lookup heavy workload on a completely separate filesystem.
The following is a 5m snapshot of the iget stats from a filesystem doing
allocs/frees with an external/heavy lookup workload (which not included
in the stats), with and without a sync grace period wait in the reuse
path:

baseline:	ig 1337026 1331541 4 5485 0 5541 1337026
sync_rcu_test:	ig 2955 2588 0 367 0 383 2955

I think this is kind of the nature of RCU and why I'm not sure it's a
great idea to rely on update side synchronization in a codepath that
might want to scale/perform in certain workloads. I'm not totally sure
if this will be a problem for real users running real workloads or not,
or if this can be easily mitigated, whether it's all rcu or a cascading
effect, etc. This is just a quick test so that all probably requires
more test and analysis to discern.

> > > I'll also point out that this would require XFS inodes to pass
> > > through *two* rcu grace periods before the memory they hold could be
> > > freed because, as I mentioned, xfs inode reclaim uses rcu protected
> > > inode lookups and so relies on inodes to be freed by rcu callback...
> > > 
> > > > I tend to agree with Brian and Ian at this point: return -ECHILD
> > > > from
> > > > xfs_vn_get_link_inline() until xfs's inode resue vs. rcu walk
> > > > implications are fully dealt with.  No way to fix this from VFS
> > > > alone.
> > > 
> > > I disagree from a fundamental process POV - this is just sweeping
> > > the issue under the table and leaving it for someone else to solve
> > > because the root cause of the inode re-use issue has not been
> > > identified. But to the person who architected the lockless XFS inode
> > > cache 15 years ago, it's pretty obvious, so let's just solve it now.
> > 
> > Sorry, I don't understand what you mean by the root cause not
> > being identified?
> 
> The whole approach of "we don't know how to fix the inode reuse case
> so disable it" implies that nobody has understood where in the reuse
> case the problem lies. i.e. "inode reuse" by itself is not the root
> cause of the problem.
> 

I don't think anybody suggested to disable inode reuse. My suggestion
was to disable rcu walk mode on symlinks as an incremental step because
the change to enable it appeared to be an undocumented side effect of an
unrelated optimization. There was no real mention of it in the commit
log for the get_link_inline() variant, no analysis that explains if or
why it's safe to enable, and it was historical behavior since this
change in get_link() API to expose rcu walk was introduced. It seems
fairly reasonable to me to put that logic back in place first (while
also providing a predictable/stable fix) before we get into the weeds of
doing the right things with rcu to re-enable it (whether that be
synchronize_rcu() or something else)...

> The root cause is "allowing an inode to be reused without waiting
> for an RCU grace period to expire". This might seem pedantic, but
> "without waiting for an rcu grace period to expire" is the important
> part of the problem (i.e. the bug), not the "allowing an inode to be
> reused" bit.
> 
> Once the RCU part of the problem is pointed out, the solution
> becomes obvious. As nobody had seen the obvious (wait for an RCU
> grace period when recycling an inode) it stands to reason that
> nobody really understood what the root cause of the inode reuse
> problem.
> 

The synchronize_rcu() approach was one of the first options discussed in
the bug report once a reproducer was available. It had been tested as a
potential option for the broader problem (should the vfs change turn out
problematic) before these patches landed on the list. It's a reasonable
option and reasonable to prefer it over the most recent patch, but as
noted above I think there are other factors at play beyond having a pure
enough understanding of the root cause or not.

AIUI, this is not currently a reproducible problem even before patch 1,
which reduces the race window even further. Given that and the nak on
the current patch (the justification for which I don't really
understand), I'm starting to agree with Ian's earlier statement that
perhaps it is best to separate this one so we can (hopefully) move patch
1 along on its own merit..

Brian

> > > With the xfs_ifree() problem solved by zeroing rather than freeing,
> > > then the only other problem is inode reuse *within an rcu grace
> > > period*. Immediate inode reuse tends to be rare, (we can actually
> > > trace occurrences to validate this assertion), and implementation
> > > wise reuse is isolated to a single function: xfs_iget_recycle().
> > > 
> > > xfs_iget_recycle() drops the rcu_read_lock() inode lookup context
> > > that found the inode marks it as being reclaimed (preventing other
> > > lookups from finding it), then re-initialises the inode. This is
> > > what makes .get_link change in the middle of pathwalk - we're
> > > reinitialising the inode without waiting for the RCU grace period to
> > > expire.
> > 
> > Ok, good to know that, there's a lot of icache code to look
> > through, ;)
> 
> My point precisely. :)
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

