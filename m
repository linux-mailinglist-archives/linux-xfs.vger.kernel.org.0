Return-Path: <linux-xfs+bounces-18870-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DA42A27E18
	for <lists+linux-xfs@lfdr.de>; Tue,  4 Feb 2025 23:14:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B36A9166C27
	for <lists+linux-xfs@lfdr.de>; Tue,  4 Feb 2025 22:14:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A93721ADC4;
	Tue,  4 Feb 2025 22:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="LdJ/pvS7"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D1121A449
	for <linux-xfs@vger.kernel.org>; Tue,  4 Feb 2025 22:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738707245; cv=none; b=tpb8hxxPvzmny7qBN/lMKQPduYmhEX+ov4M6D4YHgCVp72VdZFBRKrgwcw3RnJsQ4tSbQneGGbdgvplgR49Kw9318s2xOXlSvdg9oSVFANNFSPlbsaoORPyvA1wDnWpiDKDhO6CB3zTU7TsncKqujxN09s6rFBkYO31KGk94t/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738707245; c=relaxed/simple;
	bh=7k7VEs6V4yvlIYtIgsJdw/4fFAfiL96U9mT+408AOFs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G8GXFkMgSq9FcOCClABiLO6Z7WC8+v8RyNQoX+fl4KTRm+32C0M3XVk8tS69cj4FatU/XQ2UgdLy9GfFTaT/1K/7FASfjKahtdJXuiugzZXSWCjEhQuoWbepUNgwXky6IwbcvPpxU8py/eaEGgUbVc+6xqySpCN8t4nsFsbzOFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=LdJ/pvS7; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2162c0f6a39so4409915ad.0
        for <linux-xfs@vger.kernel.org>; Tue, 04 Feb 2025 14:14:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1738707242; x=1739312042; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JayNHPls2+KCB/QM9GkK/iKI+liBYw5DSmO3rqCbMoM=;
        b=LdJ/pvS7EgMOVSPYVNsF3HkTEeOEbCnqfVhbOsfg5XO11+dSnWPMmiDQLpIKCVBu7N
         uD4KVd+wTNW+nmxBa18r4fBi+d0q3watk1VL75/ecCp1Po/XC6wqJYRYwcMQWVEsaUm3
         3SkfdV5syI+9+CUQO42TSXw/yRkYOQlHPAs2WPMLPjzj6kiPzJhCMl6o6npF4C8nfJmy
         Nb1MFDxyPgYVYzKE+C3ekyHfOHy99rYSYCPPwP+wdvcnmYr3KHUqjtMlQJvFV7CaH/tH
         yD5sZkOsOGqqYQxI3gIyRlHQs4iWbL/QtsHnPLrbDa2g24tWW2CkODfLCSO20t/rcX/M
         2LqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738707242; x=1739312042;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JayNHPls2+KCB/QM9GkK/iKI+liBYw5DSmO3rqCbMoM=;
        b=KiC0Mo14ZmtSMExMMjkaTj0TFUDn9JUvU75Kk3ycVaZnoxyZm1EdUXpSGwjNHNGFfa
         Q0yv/BbM/WKZ5B/4l1z1SKd+gQqq00J7WfpirOmrcyYSr6eRLQMbeCpPVhe7Yds49Y72
         jDO8EhDc7UAW5NzStQ2x7uvXtR46AyibSeBJx0lDOyHbl2FmSJDrP9Mdcd5QTgYXpFZF
         G2XBjjOyNsvYnA0J0xm8w6LLqVg1WnqMs0FCqtaZJTa5rpgxsU5NGJXPP5iVCx7xpHDr
         c5Y5IfZ1dI8PkKrZ7d+9IDUDaC0Bvpsl85H3kAoOaOpvheL+kGLKkal4JbJSww0CKJiy
         pjLg==
X-Forwarded-Encrypted: i=1; AJvYcCXaSp02wwHi/ZzWmhCloCrwihxlmfVEaan1SHJv76zOB86/iwvKRhM7ZlrByTH1KI/8CWCbEn8Dlvk=@vger.kernel.org
X-Gm-Message-State: AOJu0YynDXHGsIOL8qiN1fm/Wt5ctxiudVBy+w6ha3/T7Zt+mFAdlZjs
	65iE/6L0fj1zZ7+OTRxkN5URndeYi0uxAOs8viqv2Ij6NtnLQch27W/X1jZqk61o8/3fgMj2F08
	4
X-Gm-Gg: ASbGncu8RBL92QpMcA01Bp0wGVcxtjJJRPvk2IpavU3jvbeqwQZ+HmLDGZS0xeWhsVM
	sW6AHnvbDwEtrR0XzbourDE0s3tmQNoTGY867o7S0dOM+cXRw0J00UMwgnMkkmOY8g91D2HMPKA
	7iSt9THarBc0alPynLEKdy3hb/xDur4SW+cYaPvNTKTGt4BMmVudKur85duS+NF3n8s2v6ilrZX
	KuHrmUsB0S1nSzNMXu+MR9a+3bGoPTly3fsqbW47F3c1lwKFQpBJ5x+QyIPdhqexrfpwESHfRGl
	9g1AVZH4p7vpjtrhKvEfyCxITb1pIQ3FIPdIm7Ce7/BzHdA012hlF1A4
X-Google-Smtp-Source: AGHT+IHkvIHDhdySNOW6VZEb8eIoNXolZYs/YoDMCWGI63BQ4T3PlFG/RA89aby7eIz+5CNjxxSWHg==
X-Received: by 2002:a05:6a00:179c:b0:725:e386:3c5b with SMTP id d2e1a72fcca58-730271ffbd9mr9456022b3a.5.1738707242177;
        Tue, 04 Feb 2025 14:14:02 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72fe653ab20sm11110741b3a.76.2025.02.04.14.14.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 14:14:01 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tfRB9-0000000EgYl-0ZW2;
	Wed, 05 Feb 2025 09:13:59 +1100
Date: Wed, 5 Feb 2025 09:13:59 +1100
From: Dave Chinner <david@fromorbit.com>
To: Ritesh Harjani <ritesh.list@gmail.com>
Cc: Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	lsf-pc@lists.linux-foundation.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, djwong@kernel.org,
	dchinner@redhat.com, jack@suse.cz, tytso@mit.edu,
	linux-ext4@vger.kernel.org, nirjhar.roy.lists@gmail.com,
	zlang@kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] xfstests: Centralizing filesystem configs and
 device configs
Message-ID: <Z6KRJ3lcKZGJE9sX@dread.disaster.area>
References: <Z55RXUKB5O5l8QjM@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <Z6FFlxFEPfJT0h_P@dread.disaster.area>
 <87ed0erxl3.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ed0erxl3.fsf@gmail.com>

On Tue, Feb 04, 2025 at 12:44:00PM +0530, Ritesh Harjani wrote:
> Dave Chinner <david@fromorbit.com> writes:
> 
> > On Sat, Feb 01, 2025 at 10:23:29PM +0530, Ojaswin Mujoo wrote:
> >> Greetings,
> >> 
> >> This proposal is on behalf of Me, Nirjhar and Ritesh. We would like to submit
> >> a proposal on centralizing filesystem and device configurations within xfstests
> >> and maybe a further discussion on some of the open ideas listed by Ted here [3].
> >> More details are mentioned below.
> >> 
> >> ** Background ** 
> >> There was a discussion last year at LSFMM [1] about creating a central fs-config
> >> store, that can then be used by anyone for testing different FS
> >> features/configurations. This can also bring an awareness among other developers
> >> and testers on what is being actively maintained by FS maintainers. We recently
> >> posted an RFC [2] for centralizing filesystem configuration which is under
> >> review. The next step we are considering is to centralize device configurations
> >> within xfstests itself. In line with this, Ted also suggested a similar idea (in
> >> point A) [3], where he proposed specifying the device size for the TEST and
> >> SCRATCH devices to reduce costs (especially when using cloud infrastructure) and
> >> improve the overall runtime of xfstests.
> >> 
> >> Recently Dave introduced a feature [4] to run the xfs and generic tests in
> >> parallel. This patch creates the TEST and SCRATCH devices at runtime without
> >> requiring them to be specified in any config file. However, at this stage, the
> >> automatic device initialization appears to be somewhat limited. We believe that
> >> centralizing device configuration could help enhance this functionality as well.
> >
> > Right, the point of check-parallel is to take away the need to
> > specify devices completely.  I've already added support for the
> > LOGWRITES_DEV, and I'm in the process of adding LOGDEV and RTDEV
> > support for both test and scratch devices. At this point, the need
> > for actual actual device specification in the config files goes
> > away.
> >
> > What I am expecting to need is a set of fields that specify the
> > *size* of the devices so that the hard-coded image file sizes in
> > the check-parallel script go away.
> >
> > From there, I intend to have check-parallel iterate config file run
> > sections itself, rather than have it run them internally to check.
> > That way check is only ever invoked by check-parallel with all the
> > devices completely set up.
> 
> Yes, this sounds good. This is what we were anticipating too.
> Thanks for sharing.
> 
> >
> > Hence a typical host independent config file would look like:
> 
> The work being proposed by us here was to make this config file
> centralized within xfstests itself for both fsconfig and device-config.
> This saves us from defining each of this section within local.config file
> and can be used by passing cmdling arguments to invoke a given section
> directly. 
> 
> e.g.
> 
>     ./check -c configs/xfs/64k -g auto

This strikes me as re-implementing config sections with a different
file format.

> There have been cases where testers and others have requested info to
> know about - 
> - What different FS config options to test,
> - What gets tested by the Maintainers,  
> - Is there a common place where I can find MKFS and MOUNT options which
>   I should be testing for my FS/feature testing. 

Those are questions that documentation should answer - they are not
a reason for changing config file formats.

> That is the reason, I think, centralizing fsconfig option can be
> helpful. I remember bringing this idea in our last LSFMM-2024, where you
> mentioned that - let's see the RFC [1] and maybe then we can discuss more :).
> Here is the RFC for the same. There are some additional improvements in
> that series, but it mainly adds fsconfig option.
> 
> [1]: https://lore.kernel.org/fstests/cover.1736496620.git.nirjhar.roy.lists@gmail.com/

Yeah, that's just making a tiny config file per config section, and
having to add a heap of parsing code to do that.

I find it much easier to manage a single config file where each
config is maybe only one or two lines than it is to have to find the
needle in a haystack of hundreds of tiny files that are almost all
alike.

> > TEST_DEV_SIZE=10g
> > TEST_RTDEV_size=10g
> > TEST_LOGDEV_SIZE=128m
> > SCRATCH_DEV_SIZE=20g
> > SCRATCH_RTDEV_size=20g
> > SCRATCH_LOGDEV_SIZE=512m
> > LOGWRITES_DEV_SIZE=2g
> >
> 
> For centralizing device-configs idea, I was hoping we could mention above
> in "configs/devices/loop" config file. This can be picked up by ./check
> too if local.config hasn't been provided with these options.

Great. How do you specify where the image files are going to be
hosted when no devices have been configured?

These sorts of zero-conf chicken/egg problems have already been
solved by check-parallel - I'm really not convinced that we need
to make check itself try to solve these. I designed check-parallel
the way I did because making check itself solve these problems is
.... convoluted and difficult.

If we need zero-conf, just use ./check-parallel....

> > [xfs]
> > FSTYP=xfs
> > MKFS_OPTIONS="-b size=4k"
> > TEST_FS_MOUNT_OPTIONS=
> > MOUNT_OPTIONS=
> > USE_EXTERNAL=
> >
> > [xfs-rmapbt]
> > MKFS_OPTIONS="-b size=4k -m rmapbt=1"
> >
> > [xfs-noreflink]
> > MKFS_OPTIONS="-b size=4k -m reflink=0"
> >
> > [xfs-n64k]
> > MKFS_OPTIONS="-b size=4k -n size=64k"
> >
> > [xfs-ext]
> > MKFS_OPTIONS="-b size=4k"
> > USE_EXTERNAL=yes
> >
> > [ext4]
> > FSTYP="ext4"
> > MKFS_OPTIONS=
> > USE_EXTERNAL=
> >
> > [btrfs]
> > FSTYP="btrfs"
> > .....
> 
> Above all fs configs could be added to configs/{ext4|xfs|btrfs}/... 
> Than this can be used in 2 ways.. 
> 
> 1. ./check -c configs/xfs/4k,configs/xfs/rmapbt,configs/ext4/4k ... 

Can't say I like using relative paths to specify the config we
should use. It's not an interface I'd choose over:

	./check -s xfs -g auto

Especially as the existing config section implementation does
exactly the same thing as the proposed config file farm....

> 2. Or we may still pass fsconfig via local.config file.. e.g. 
> 
> # both configs/xfs/4k or xfs/4k can be used here
> [xfs]
> FS_CONFIG_OPTION=configs/xfs/4k
> 
> [xfs-rmapbt]
> FS_CONFIG_OPTION=xfs/rmapbt
> 
> [xfs-noreflink]
> FS_CONFIG_OPTION=xfs/noreflink
> 
> [xfs-n64k]
> FS_CONFIG_OPTION=xfs/64k
> 
> [xfs-ext]
> FS_CONFIG_OPTION=xfs/4k
> USE_EXTERNAL=yes
> 
> [ext4]
> FS_CONFIG_OPTION=ext4/4k

How is that an improvement on the section setup we have right now?
Abstracting the config section options into a separate file is the
worst of both worlds - now I have to look up the section to find the
file and the section options, then lookup the file to see the
options that file contains.

It's like you've decided that the solution to centralised management
of configs must be "one config per file", and so every other way of
managing options needs to be reframed for that solution....

> > IOWs, all that is different from system to system is the device size
> > setup. The actual config sections under test (e.g. [xfs]) never need
> > to change from host to host, nor environment to environment. i.e.
> > "xfs-n64k" runs the same config filesystem test on every system,
> > everywhere...
> 
> Right. So it's also useful if those configs can stay in configs/<fs>/**
> as well.

Why is having hundreds of tiny single-config-only files
better than having all the configs in a single file that is
easily browsed and searched?

Honestly, I really don't see any advantage to re-implementing config
sections as a "file per config" object farm. Yes, you can store
information that way, but that doesn't make it an improvement over a
single file...

All that is needed is for the upstream repository to maintain a
config file with all the config sections defined that people need.
We don't need any new infrastructure to implement a "centralised
configs" feature - all we need is an agreement that upstream will
ship an update-to-date default config file instead of the ancient,
stale example.config/localhost.config files....

> > I don't really see a need for a new centralised config setup. With
> > the above, we can acheived a "zero-config" goal with the existing
> > config file formats and infrastructure. All that we need to do is
> > update the default config file in the repo to contain a section for
> > each of the "standard" test configs we want to define....
> 
> Could you please take look at the shared RFC [1] once? I believe it will
> be useful to have this central to xfstests for reasons I mentioned
> above. This also gets us to zero-config setup with almost no need to
> configure anything.

[1]: https://lore.kernel.org/fstests/cover.1736496620.git.nirjhar.roy.lists@gmail.com/

There's nothing in that which provides zero-config. It still
requires all the devices to be specified by the user...

> This helps other testers & subsystem maintainers to
> know what configs are being tested by maintainers, which they can use
> for their FS feature testing too.
> We can than directly issue -
> 
>            ./check -c <fs>/<config> -g quick

As I've already said: this functionality already exists - they are
called config sections!

> >> Additionally, we would like to thank Ted for listing several features he uses in
> >> his custom kvm-xfstests and gce-xfstests [3]. If there is an interest in further
> >> reducing the burden of maintaining custom test scripts and wrappers around
> >> xfstests, we can also discuss essential features that could be integrated
> >> directly into xfstests, whether from Ted's list or suggestions from others.
> >
> > On of my goals with check-parallel is to completely remove the need
> > for end users to configure fstests. i.e. all you need to do is point
> > it at a directory, tell it which filesystem to test, and it "just
> > runs" with all the defaults that come direct from the fstests
> > repository...
> >
> 
> Right. Centralizing fsconfigs & device configs is also doing the same.
> In fact once we have configs/devices/loop config file, then we don't
> need to even create local.config file (for most cases I believe).
> 
> ./check and ./check_parallel can be passed these config files and
> xfstests infra will create loop devices, run the tests and later do the
> cleanups.

Please, no.

check-parallel already provides the external zero-conf
infrastructure that check needs to run without config. It solves the
chicken/egg problems that check itself has (e.g. how do you specify
the location of the loop device image files it needs to create for
zero-conf), and it does it without needing check or it's internal
infrastructure to be modified in any way.

I've already outlined how we can use check-parallel to run check in
it's traditional serial form, so there is absolutely no need to try
to make check jump through hoops to do zero-conf internally.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

