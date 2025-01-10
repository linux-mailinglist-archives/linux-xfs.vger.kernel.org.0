Return-Path: <linux-xfs+bounces-18133-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F22E8A097A8
	for <lists+linux-xfs@lfdr.de>; Fri, 10 Jan 2025 17:39:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C722716A994
	for <lists+linux-xfs@lfdr.de>; Fri, 10 Jan 2025 16:39:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F4BB212F9D;
	Fri, 10 Jan 2025 16:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="dZ7k25Mp"
X-Original-To: linux-xfs@vger.kernel.org
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C5DC212F84
	for <linux-xfs@vger.kernel.org>; Fri, 10 Jan 2025 16:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736527158; cv=none; b=C9z8UCGlOcjD5NifQIkU4FTS1K4B7W3Do8AvDLtYnegxTe8INLJ820dYjJW6lP8J+OqbO1VxUPtezVLy0RjGzNnBYlVvDuJwX5Maa2IekxDbx92/Gau4XRop9fOdyK20MDwBrRct8Nv1nTs5QMzM0VY/QGar5Xi62WSGwMmRSWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736527158; c=relaxed/simple;
	bh=TwZqzwu17hBRkWg5st+982oE0D5RXalZbub+dt2JLSs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OrIFchx9VVbbaDR95n0wO3wgYzK+PPg/gqyfvl+1iNpMwPp8zR8V5bv3McUlQeYUX0UHqpK7pmIWzBRnBCAMSNX9Z4LaMb0/IXeJ5w/4GJntv9a8fyJuJguPRilzXn8myd2qSxN7MyOXit46/YM6w2NrAo4uBkv3hNU7b4blghc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=dZ7k25Mp; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Received: from cwcc.thunk.org (pool-173-48-114-113.bstnma.fios.verizon.net [173.48.114.113])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 50AGcxj2009956
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 10 Jan 2025 11:39:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1736527141; bh=GBsvQRzNc4mpMIFiRQGhygjegaZHYY26FpHh0OrMdhs=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=dZ7k25MpwPto4bycwNqFwE6UE9o4Dp+1ttsdxlHB+/MtnI8u09SDtnbDs9Ct1SsNv
	 H6Ad2t2VkONlFXdE3V00CiqArqfAutoZ3CcvRDeIzdvqWryw/9sFfKnK7zMSEdR4YM
	 uQUZMOh/nonNyTmSlcVX/j/I1syse6BxNYyG6r70zVrUm/z9/cpdKkQAteGpL9t6re
	 OcC1t1oxArs+BTAKPf6crwOj9aP6uMcyhhX/i36sUc8bC/2E+DEeME0XBDtIaKKspu
	 8wUwKewb5vHV48iU/jVbnr52KiqdirfJHpD/FUorfO5/5Wel7R809vwOcYkaoDJ6uQ
	 Q0cxPWgF+ormQ==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
	id 481A915C0147; Fri, 10 Jan 2025 11:38:59 -0500 (EST)
Date: Fri, 10 Jan 2025 11:38:59 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, ritesh.list@gmail.com,
        ojaswin@linux.ibm.com, djwong@kernel.org, zlang@kernel.org
Subject: Re: [RFC 4/5] check,common/config: Add support for central fsconfig
Message-ID: <20250110163859.GB1514771@mit.edu>
References: <cover.1736496620.git.nirjhar.roy.lists@gmail.com>
 <9a6764237b900f40e563d8dee2853f1430245b74.1736496620.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a6764237b900f40e563d8dee2853f1430245b74.1736496620.git.nirjhar.roy.lists@gmail.com>

On Fri, Jan 10, 2025 at 09:10:28AM +0000, Nirjhar Roy (IBM) wrote:
> This adds support to pick and use any existing FS config from
> configs/<fstype>/<config>. e.g.
> 
> configs/xfs/1k
> configs/xfs/4k
> configs/ext4/4k
> configs/ext4/64k
> 
> This should help us maintain and test different fs test
> configurations from a central place. We also hope that
> this will be useful for both developers and testers to
> look into what is being actively maintained and tested
> by FS Maintainers.

I haven't been using the current in-place configs in kvm-xfstests and
gce-xfstests because there are number of things that my setup can
support that xfstests native config doesn't support (and becuase my
system predates the FS config setup).  I don't mind just using my own
custom setup, but if we can keep feature parity, perhaps someday I can
switch over to xfstests's system.  This might also make it easier for
people to more easily test using the same setup as the FS maintainers,
regardless of which test running infrastructure they are using.

A) A way of specifying the minimum device size needed for the TEST and
      SCRATCH device.  Using a smaller file system size reduces test
      run time, and if you are paying for cloud test infrastructure,
      the size of the Google Persistent Disk or Amazon Elastic Block
      Storage has a direct impact on the cost per test, which in turn
      impacts how many tests we can afford to run.  But for certain
      test configurations, such as using a larger block size, or using
      bigalloc, a larger test device size might be needed in order for
      tests to be able to run correctly.

B) A way of specifying test exclusions, both at a global level, or on
	a per-fs, or on a per-configuration basis.  It should also be
	possible to specify the kernel version being tested, and so
	that certain test exclusions might only be done when testing
	LTS kernels (for example):

#if LINUX_VERSION_CODE < KERNEL_VERSION(6,6,30)
// This test failure is fixed by commit 631426ba1d45q ("mm/madvise:
// make MADV_POPULATE_(READ|WRITE) handle VM_FAULT_RETRY properly"),
// which first landed in v6.9, and was backported to 6.6.30 as commit
// 631426ba1d45.  Unfortunately, it's too involved to backport it and its
// dependencies to the 6.1 or earlier LTS kernels
generic/743
#endif

C) A way to run shell functions to do setups for testing things like
	overlayfs, or nfs (where I may be starting separate VM's for
	the NFS server, or needing to find the IP address for the NFS
	server running the appropriate kernel under test, which either
	been the same as the kernel under test, or which might be some
	standard server version, such as a RHEL or SLES kernel), as
	part of the setup and teardown of a particular test
	configuration.

D) I also have a really nice scheme for specifying a mkfs
	configuration for testing LTS kernels, since I use the same
	test appliance for testing upstream and LTS/product kernels,
	and the latest mkfs.xfs will produce a file system image that
	isn't supported by a 5.15 LTS kernel.  Product teams might
	also want to run tests using the mkfs configuration for that
	era kernel, even if a 6.1 kernel can support a file system
	created using the latest version of xfsprogs or e2fsprogs.

	Doing this is a bit non-trivial due to a misfeature of how
	mkfs.xfs works, but I have a workaround that some might find
	useful here:

   https://github.com/tytso/xfstests-bld/commit/f62433b74146e6ecacdeace306828c6c7510c4a6

	Note that this might also be useful for xfstests, where
	specific xfstests scripts have to handle cases where mkfs.xfs
	might unexpectedly fail due to an unfortunate combination
	between the test-specific _scratch_mkfs options, and the
	global MKFS_OPTIONS.  This never happens with ext4, due to how
	mkfs.ext4 handles conflicting command-line options, but it
	*is* a problem with mkfs.xfs.  If you think merging an 150
	line shell script library is easier than trying to get
	consensus from within the xfs community, here's a technical
	workaround to what might be charitably described as a
	disagreement between the xfs architects and the needs of the
	testing community.  :-)

If we're going to have critical mass, maybe this is something that's
worth discussing at the upcoming LSF/MM?  As I said, I'm happy having
this be an exclusive feature in gce-xfstests and kvm-xfstests, but
perhaps it would make sense to uplevel some of this feature into
xfstests so that more people can take advantage of it, and to make it
easier for us to share test configs across test teams and upstream
developers?

Cheers,

						- Ted

