Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6F83158B8
	for <lists+linux-xfs@lfdr.de>; Tue,  9 Feb 2021 22:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233751AbhBIVgg (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 9 Feb 2021 16:36:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:42922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234076AbhBIUv5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Feb 2021 15:51:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8CC3264EB4;
        Tue,  9 Feb 2021 19:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612900761;
        bh=R8SxGH90Ft1xAEN0sl2YASsgw41T6quTJG9Z4jiQtts=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mCBd2HDOSx6F4iv4gtQtRKRP/2a/Ii+e1iuAXDJaPTaZ1XC/e9cA1kTQnRXbt+nbs
         lnPYVBBtb0xafOoJv84/zGS5z62CSB0ZFR5aGj1fheH+xcbY/Ae1lGxIduMVvjm8PC
         vKRu7jrOR5gedQriKsbct22kIZxc5YZeN8516wwM7mHM4lVWCnYkMVqz6+K1lqDuj/
         AWGujj08JiVf7q08NclhKfa0W4JT/8TRK3sMDU9QW5JMNW/8Ga3gjoAUYv6NFN0X9+
         a0Ar/l6imUz7z3X+o2sk5xSOdXXLiHd2UJuUh+k5sVLaszp1eZTTK8ue8DxhtwbGY6
         ixbOxMp7w3r7Q==
Date:   Tue, 9 Feb 2021 11:59:20 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Brian Foster <bfoster@redhat.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 09/10] xfs_repair: add a testing hook for NEEDSREPAIR
Message-ID: <20210209195920.GZ7193@magnolia>
References: <161284380403.3057868.11153586180065627226.stgit@magnolia>
 <161284385516.3057868.355176047687079022.stgit@magnolia>
 <20210209172131.GG14273@bfoster>
 <20210209181738.GU7193@magnolia>
 <20210209185939.GK14273@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210209185939.GK14273@bfoster>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 09, 2021 at 01:59:39PM -0500, Brian Foster wrote:
> On Tue, Feb 09, 2021 at 10:17:38AM -0800, Darrick J. Wong wrote:
> > On Tue, Feb 09, 2021 at 12:21:31PM -0500, Brian Foster wrote:
> > > On Mon, Feb 08, 2021 at 08:10:55PM -0800, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > Simulate a crash when anyone calls force_needsrepair.  This is a debug
> > > > knob so that we can test that the kernel won't mount after setting
> > > > needsrepair and that a re-run of xfs_repair will clear the flag.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > ---
> > > 
> > > Can't we just use db to manually set the bit on the superblock?
> > 
> > No, because the fstest uses this debug knob to simulate the following:
> > 
> > 1) sysadmin issues 'xfs_admin -O inobtcount /dev/sda1'
> > 2) xfs_repair flips on INOBTCOUNT and NEEDSREPAIR
> > 3) system goes down and repair never completes
> > 4) verify that we can't mount
> > 5) verify that repair clears NEEDSREPAIR and gives us a clean fs
> > 6) verify that mount works again
> > 
> 
> Ok, but that seems like circular reasoning.

I'm sorry, but I don't see how this is circular logic?

The test needs to show that NEEDSREPAIR is turned on during phase 1 (or
2) when we apply an upgrade, and it needs to induce some kind of early
exit so that the needsrepair clearing code after phase 7 does not run.

If we set NEEDSREPAIR with xfs_db before running repair then we have no
way to detect if the inobtcount upgrade doesn't set needsrepair.

If we don't have a debugging knob to stop repair before it reaches phase
7, we're not really testing a genuine early-repair-exit scenario.  Yes,
we can use xfs_db to manually set the flag after repair returns, but
that doesn't fill the testing gap above.

> It wouldn't be quite the
> same as a simulated repair failure, but ISTM that if we set the bit
> manually, we can still verify steps 4, 5 and 6 as is (with the caveat
> that the repair invocation performs a feature upgrade). I'm not sure how
> important it really is to verify that a feature upgrade sequence sets
> the bit if it happens to fail provided we have independent tests that 1.
> verify the needsrepair bit works as expected and 2. verify the feature
> upgrades work appropriately, since that is the primary functionality.
> 
> I wanted to think about that a little more before replying, but I also
> just realized something odd when digging into the debug code:
> 
> # ./repair/xfs_repair -c needsrepair=1 /dev/test/scratch 
> Phase 1 - find and verify superblock...
> Marking filesystem in need of repair.
> writing modified primary superblock
> Phase 2 - using internal log
>         - zero log...
> ERROR: The filesystem has valuable metadata changes in a log which needs to
> ...
> # mount /dev/test/scratch /mnt/
> mount: /mnt: wrong fs type, bad option, bad superblock on /dev/mapper/test-scratch, missing codepage or helper program, or other error.
> #
> 
> It looks like we can set a feature upgrade bit on the superblock before
> we've examined the log and potentially discovered that it's dirty (phase
> 2). If the log is recoverable, that puts the user in a bit of a bind..

Heh, funny that I was thinking that the upgrades shouldn't really be
happening in phase 1 anyway--

I've (separately) started working on a patch to make it so that you can
add reflink and finobt to a filesystem.  Those upgrades require somewhat
more intensive checks of the filesystem (such as checking free space in
each AG), so I ended up dumping them into phase 2, since the xfs_mount
and buffer cache aren't fully initialized until after phase 1.

So, yeah, the upgrade code should move to phase2() after log zeroing and
before the AG scan.

--D

> Brian
> 
> > and the other scenario is:
> > 
> > 1) fuzz a directory entry in such a way that repair will decide to
> >    blow out the dirent and rebuild the directory later
> > 2) sysadmin issues 'xfs_repair /dev/sda1'
> > 2) xfs_repair flips on NEEDSREPAIR at the same time it corrupts the
> >    dirent to trigger the rebuild later
> > 3) system goes down and repair never completes
> > 4) verify that we can't mount
> > 5) verify that repair clears NEEDSREPAIR and gives us a clean fs
> > 6) verify that mount works again
> > 
> > Both cases reflect what I think are the most likely failure scenarios,
> > hence the knob needs to be in xfs_repair to prevent it from running to
> > completion.
> > 
> > (And yes, I've been recently very bad at sending fstests out for review
> > the past few months; I will get that done by this afternoon.)
> > 
> > --D
> > 
> > > Brian
> > > 
> > > >  repair/globals.c    |    1 +
> > > >  repair/globals.h    |    2 ++
> > > >  repair/phase1.c     |    5 +++++
> > > >  repair/xfs_repair.c |    7 +++++++
> > > >  4 files changed, 15 insertions(+)
> > > > 
> > > > 
> > > > diff --git a/repair/globals.c b/repair/globals.c
> > > > index 699a96ee..b0e23864 100644
> > > > --- a/repair/globals.c
> > > > +++ b/repair/globals.c
> > > > @@ -40,6 +40,7 @@ int	dangerously;		/* live dangerously ... fix ro mount */
> > > >  int	isa_file;
> > > >  int	zap_log;
> > > >  int	dumpcore;		/* abort, not exit on fatal errs */
> > > > +bool	abort_after_force_needsrepair;
> > > >  int	force_geo;		/* can set geo on low confidence info */
> > > >  int	assume_xfs;		/* assume we have an xfs fs */
> > > >  char	*log_name;		/* Name of log device */
> > > > diff --git a/repair/globals.h b/repair/globals.h
> > > > index 043b3e8e..9fa73b2c 100644
> > > > --- a/repair/globals.h
> > > > +++ b/repair/globals.h
> > > > @@ -82,6 +82,8 @@ extern int	isa_file;
> > > >  extern int	zap_log;
> > > >  extern int	dumpcore;		/* abort, not exit on fatal errs */
> > > >  extern int	force_geo;		/* can set geo on low confidence info */
> > > > +/* Abort after forcing NEEDSREPAIR to test its functionality */
> > > > +extern bool	abort_after_force_needsrepair;
> > > >  extern int	assume_xfs;		/* assume we have an xfs fs */
> > > >  extern char	*log_name;		/* Name of log device */
> > > >  extern int	log_spec;		/* Log dev specified as option */
> > > > diff --git a/repair/phase1.c b/repair/phase1.c
> > > > index b26d25f8..57f72cd0 100644
> > > > --- a/repair/phase1.c
> > > > +++ b/repair/phase1.c
> > > > @@ -170,5 +170,10 @@ _("Cannot disable lazy-counters on V5 fs\n"));
> > > >  	 */
> > > >  	sb_ifree = sb_icount = sb_fdblocks = sb_frextents = 0;
> > > >  
> > > > +	/* Simulate a crash after setting needsrepair. */
> > > > +	if (primary_sb_modified && add_needsrepair &&
> > > > +	    abort_after_force_needsrepair)
> > > > +		exit(55);
> > > > +
> > > >  	free(sb);
> > > >  }
> > > > diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
> > > > index ee377e8a..ae7106a6 100644
> > > > --- a/repair/xfs_repair.c
> > > > +++ b/repair/xfs_repair.c
> > > > @@ -44,6 +44,7 @@ enum o_opt_nums {
> > > >  	BLOAD_LEAF_SLACK,
> > > >  	BLOAD_NODE_SLACK,
> > > >  	NOQUOTA,
> > > > +	FORCE_NEEDSREPAIR_ABORT,
> > > >  	O_MAX_OPTS,
> > > >  };
> > > >  
> > > > @@ -57,6 +58,7 @@ static char *o_opts[] = {
> > > >  	[BLOAD_LEAF_SLACK]	= "debug_bload_leaf_slack",
> > > >  	[BLOAD_NODE_SLACK]	= "debug_bload_node_slack",
> > > >  	[NOQUOTA]		= "noquota",
> > > > +	[FORCE_NEEDSREPAIR_ABORT] = "debug_force_needsrepair_abort",
> > > >  	[O_MAX_OPTS]		= NULL,
> > > >  };
> > > >  
> > > > @@ -282,6 +284,9 @@ process_args(int argc, char **argv)
> > > >  		_("-o debug_bload_node_slack requires a parameter\n"));
> > > >  					bload_node_slack = (int)strtol(val, NULL, 0);
> > > >  					break;
> > > > +				case FORCE_NEEDSREPAIR_ABORT:
> > > > +					abort_after_force_needsrepair = true;
> > > > +					break;
> > > >  				case NOQUOTA:
> > > >  					quotacheck_skip();
> > > >  					break;
> > > > @@ -795,6 +800,8 @@ force_needsrepair(
> > > >  		error = -libxfs_bwrite(bp);
> > > >  		if (error)
> > > >  			do_log(_("couldn't force needsrepair, err=%d\n"), error);
> > > > +		if (abort_after_force_needsrepair)
> > > > +			exit(55);
> > > >  	}
> > > >  	if (bp)
> > > >  		libxfs_buf_relse(bp);
> > > > 
> > > 
> > 
> 
