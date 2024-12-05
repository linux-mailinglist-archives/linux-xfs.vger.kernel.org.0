Return-Path: <linux-xfs+bounces-16051-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 518F59E4FED
	for <lists+linux-xfs@lfdr.de>; Thu,  5 Dec 2024 09:39:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C7F0B18809C4
	for <lists+linux-xfs@lfdr.de>; Thu,  5 Dec 2024 08:39:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C5781CB332;
	Thu,  5 Dec 2024 08:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gTGuJe8y"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57DC611187;
	Thu,  5 Dec 2024 08:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733387986; cv=none; b=sw8qfBki17LIq4+7GaoO/FmZnQnh2HnqQRLx9vwmN791EEqnM6dUDIWZgqDkKHJ2lw26MJUtaI3fPeOVyijWxdp6W/wAL41aAuvbh9BXj7YZDXXZd2tSyJR4GmIjEyArlzDQjOHqnQxk1Et87JGCGPai7WUxXM0/GYHqhBXIASs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733387986; c=relaxed/simple;
	bh=iZvFjVeHlkKNQ+JujndswwyY/NrXZ1FfdJV97S+pVCY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MJfWtkVW7StcNbFc8mAXEnxu3p05/Q+N8cm3kaHd206ouimmP1kJbVpBSXCqQLIK/8bV7GIelxoYZtf6WunyH5XdHXpAqQxSCRgTY7OcK5BiqC0VGP0rCcyRVoW6XcCFNovNkprLbMaqV5HFvyHRqqDm6itd4eKbQoH40YSQ89k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gTGuJe8y; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 319E6C4CED1;
	Thu,  5 Dec 2024 08:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733387985;
	bh=iZvFjVeHlkKNQ+JujndswwyY/NrXZ1FfdJV97S+pVCY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gTGuJe8yy3tiSKwGyHiQ1LKL8wZU5iUbAX0wJIStSU71jmNR6z7RkFHFaHTsY3Kpd
	 ckP/AzJyYlsEeS0XmRa+ZmnZmIJx6JOZtrE270m77kAeMeDIUyQMmoUFhLx4cWEwty
	 /tcL/D9dL5OzZxqAgdXxqQXi+XDqNM8+HD7c2Ce0=
Date: Thu, 5 Dec 2024 09:39:42 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Bill O'Donnell <bodonnel@redhat.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, cem@kernel.org,
	stable@vger.kernel.org, jlayton@kernel.org,
	linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCHSET v2] xfs: proposed bug fixes for 6.13
Message-ID: <2024120533-dirtiness-streak-c69d@gregkh>
References: <173328106571.1145623.3212405760436181793.stgit@frogsfrogsfrogs>
 <Z1EBXqpMWGL306sh@redhat.com>
 <20241205064243.GD7837@frogsfrogsfrogs>
 <Z1FNqV27x5hjnqQ9@redhat.com>
 <Z1FPGXpTIJ1Fc2Xy@infradead.org>
 <Z1FQdYEXLR5BoOE-@redhat.com>
 <20241205073321.GH7837@frogsfrogsfrogs>
 <Z1Facuy97Xxj9mKO@redhat.com>
 <Z1Fd-FVR84x3fLVd@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1Fd-FVR84x3fLVd@redhat.com>

On Thu, Dec 05, 2024 at 02:02:00AM -0600, Bill O'Donnell wrote:
> On Thu, Dec 05, 2024 at 01:46:58AM -0600, Bill O'Donnell wrote:
> > On Wed, Dec 04, 2024 at 11:33:21PM -0800, Darrick J. Wong wrote:
> > > On Thu, Dec 05, 2024 at 01:04:21AM -0600, Bill O'Donnell wrote:
> > > > On Wed, Dec 04, 2024 at 10:58:33PM -0800, Christoph Hellwig wrote:
> > > > > On Thu, Dec 05, 2024 at 12:52:25AM -0600, Bill O'Donnell wrote:
> > > > > > > 1) Our vaunted^Wshitty review process didn't catch various coding bugs,
> > > > > > > and testing didn't trip over them until I started (ab)using precommit
> > > > > > > hooks for spot checking of inode/dquot/buffer log items.
> > > > > > 
> > > > > > You give little time for the review process.
> > > 
> > > Seriously?!
> > > 
> > > Metadir has been out for review in some form or another since January
> > > 2019[1].  If five years and eleven months is not sufficient for you to
> > > review a patchset or even to make enough noise that I'm aware that
> > > you're even reading my code, then I don't want you ever to touch any of
> > > my patchsets ever again.
> > > 
> > > > > I don't really think that is true.  But if you feel you need more time
> > > > > please clearly ask for it.  I've done that in the past and most of the
> > > > > time the relevant people acted on it (not always).
> > > > > 
> > > > > > > 2) Most of the metadir/rtgroups fixes are for things that hch reworked
> > > > > > > towards the end of the six years the patchset has been under
> > > > > > > development, and that introduced bugs.  Did it make things easier for a
> > > > > > > second person to understand?  Yes.
> > > > > > 
> > > > > > No.
> > > > > 
> > > > > So you speak for other people here?
> > > > 
> > > > No. I speak for myself. A lowly downstream developer.
> > > > 
> > > > > 
> > > > > > I call bullshit. You guys are fast and loose with your patches. Giving
> > > > > > little time for review and soaking.
> > > > > 
> > > > > I'm not sure who "you" is, but please say what is going wrong and what
> > > > > you'd like to do better.
> > > > 
> > > > You and Darrick. Can I be much clearer?
> > > > 
> > > > > 
> > > > > > > > becoming rather dodgy these days. Do things need to be this
> > > > > > > > complicated?
> > > > > > > 
> > > > > > > Yeah, they do.  We left behind the kindly old world where people didn't
> > > > > > > feed computers fuzzed datafiles and nobody got fired for a computer
> > > > > > > crashing periodically.  Nowadays it seems that everything has to be
> > > > > > > bulletproofed AND fast. :(
> > > > > > 
> > > > > > Cop-out answer.
> > > > > 
> > > > > What Darrick wrote feels a little snarky, but he has a very valid
> > > > > point.  A lot of recent bug fixes come from better test coverage, where
> > > > > better test coverage is mostly two new fuzzers hitting things, or
> > > > > people using existing code for different things that weren't tested
> > > > > much before.  And Darrick is single handedly responsible for a large
> > > > > part of the better test coverage, both due to fuzzing and specific
> > > > > xfstests.  As someone who's done a fair amount of new development
> > > > > recently I'm extremely glad about all this extra coverage.
> > > > > 
> > > > I think you are killing xfs with your fast and loose patches.
> > > 
> > > Go work on the maintenance mode filesystems like JFS then.  Shaggy would
> > > probably love it if someone took on some of that.
> > 
> > No idea who "Shaggy" is. Nor do I care.	   
> > > 
> > > > Downstreamers like me are having to clean up the mess you make of
> > > > things.
> > > 
> > > What are you doing downstream these days, exactly?  You don't
> > > participate in the LTS process at all, and your employer boasts about
> > > ignoring that community process.  If your employer chooses to perform
> > > independent forklift upgrades of the XFS codebase in its product every
> > > three months and you don't like that, take it up with them, not
> > > upstream.
> 
> Why are you such a nasty person? I try to get along with people, but you're
> impossible. I've been an engineer for 40+ years, and I've never encountered such
> an arrogant one as you.

I have to step in here, sorry.

Please take a beat and relax and maybe get some sleep before you respond
again.  Darrick is not being "nasty" here at all, but reiterating the
fact that your company does do huge fork-lifts of code into their kernel
tree.  If that development model doesn't work for you, please work with
your company to change it.

And if you wish to help out here, please do so by reviewing and even
better yet, testing, the proposed changes.  If you can't just suck down
a patch series and put it into your test framework with a few
keystrokes, perhaps that needs to be worked on to make it simpler to do
from your side (i.e. that's what most of us do here with our development
systems.)

By critisizing the mere posting of bugfixes, you aren't helping anything
out at all, sorry.  Bugfixes are good, I don't know why you don't want
even more, that means that people are testing and finding issues to fix!
Surely you don't want the people finding the issues to be your users,
right?

thanks,

greg k-h

