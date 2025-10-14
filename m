Return-Path: <linux-xfs+bounces-26388-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 84E76BD69D6
	for <lists+linux-xfs@lfdr.de>; Tue, 14 Oct 2025 00:32:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 431213B8B0B
	for <lists+linux-xfs@lfdr.de>; Mon, 13 Oct 2025 22:32:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 231B72FF176;
	Mon, 13 Oct 2025 22:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K+Am9tZ9"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C442FF148
	for <linux-xfs@vger.kernel.org>; Mon, 13 Oct 2025 22:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760394717; cv=none; b=QwpHW223/mtrH7kZkDAXHTaE2BHc77kQRph0lUbxo7fmwb0saTr2eOS5kxy6zJq9RZyVMDYm0XxSldhLCkBElAYAVFNH3MV22rmhX6En13ezRsp3fXa6UffRNWmBWuJoZLh66Z1X2M6gYNREd5nXwFgVa474sc7T//Ms8Z/eTis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760394717; c=relaxed/simple;
	bh=UesNOrdgrlOzi9/g5vqkVodH+nLDBuRuk2DDptHwvfg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CsroBpyhK3nwk7B6wXB+/CYonruNamW2D5yJdFnYsBXolZUo11BQ2tRLDrxXfZySyFOsJ3jUgInqU1t/J+4FAuWJnOtoGTZgCMj2+m9GU5qTBbhbpv7pBQ3Ehb3J8m49K+yB+PaTzYqiZchv194dlQulKFCUfnCiv7etDloiP9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K+Am9tZ9; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A31CC4CEFE;
	Mon, 13 Oct 2025 22:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760394717;
	bh=UesNOrdgrlOzi9/g5vqkVodH+nLDBuRuk2DDptHwvfg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K+Am9tZ9IfeXAQXdH/IJhAzPeRaM9YSw3wHZ5gAX99JtBl9hdjZoT6zIB48S1qBmV
	 GcVZB9fY3YOdFXuLH7Mtr82qJCOxmKAvIac+/LQgSf5Qi4IkakD5lat3KVVer/lal+
	 DgiGwNVbimOGMUQ5m+5+m2+mLJM6SE0USCNVPOBymwT+gd+jIenxWI91gjwsPSRM3W
	 rKN4YDQIk5ajlEmTY/Z1R8xjBiHRZGmeC9a1Oueir3WqXTWmEEs1ci58zrDgPMDwfw
	 GCi28FdVJehhk/B4pzeNBfckbWZI22ZJ74FQ3ek98+9xR4+wQHtVjnSqcrnm805CDl
	 ndmM7vK/wrL6w==
Date: Mon, 13 Oct 2025 15:31:56 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Iustin Pop <iustin@debian.org>, 1116595@bugs.debian.org
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: Re: Packaging issue: xfs_scrub_all_fail.service NoNewPrivileges
 breaks emailing reports
Message-ID: <20251013223156.GF6215@frogsfrogsfrogs>
References: <aNmt9M4e9Q6wqwxH%40teal.hq.k1024.org>
 <20251013174106.GN6188@frogsfrogsfrogs>
 <aO1calELgCjY8C7o@teal.hq.k1024.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aO1calELgCjY8C7o@teal.hq.k1024.org>

[directly cc the xfs list now because dealing with the debian bug
tracker is just too hard]

On Mon, Oct 13, 2025 at 10:09:14PM +0200, Iustin Pop wrote:
> On 2025-10-13 10:41:06, Darrick J. Wong wrote:
> > [yay, debian bugs aren't cc'ing linux-xfs consistently]
> 
> They try to, but fail because the (new) bug source address is not
> subscribed to linux-xfs, and thus there is a bounce. I haven't had time
> to report this, sorry.
> 
> > > I've struggled with this for a while because all my logs were spammed by
> > > hundreds of lines of:
> > > 
> > > postfix/postdrop[37291]: warning: mail_queue_enter: create file maildrop/480926.37291: Permission denied
> > > 
> > > And it took me a long while to dig this down to xfs_scrub reporting.
> > > Problem setup:
> > > 
> > > - mailer is postfix, which uses a setgid /usr/sbin/postdrop binary to
> > >   write to /var/lib/postfix/maildrop (mode 0730, group postdrop)
> > > - the systemd unit for the xfs_scrub reporting,
> > >   /usr/lib/systemd/system/xfs_scrub_all_fail.service, contains:
> > >   
> > >   # xfs_scrub needs these privileges to run, and no others
> > >   CapabilityBoundingSet=
> > >   NoNewPrivileges=true
> > > 
> > > Together, this means that the script
> > > (/usr/libexec/xfsprogs/xfs_scrub_fail) composes the email, and pipes it
> > > to "/usr/sbin/sendmail -t -i", which in turn invokes the postdrop
> > > binary, but which can't get the sgid bit. But since it calls sendmail
> > 
> > IOWs, postfix is installed and postdrop needs to be able to run as
> > setgid, right?
> 
> Correct.
> 
> > Do you only need us to change the xfs_scrub_fail@.service file to have
> > "NoNewPrivileges=false", or do you also need it to have
> > "CapabilityBoundingSet=CAP_SETGID" ?
> > 
> > The systemd documentation implies that you only need
> > NoNewPrivileges=false to run setgid programs, but I don't know for sure.
> > I'll try to test this and report back, but it sounds like you're in a
> > better position to say for sure that postfix works.  (I use msmtp)
> 
> I don't know either, but sometimes in the next weeks I hope to get time
> to test it. I suspect CapabilityBoundingSet=CAP_SETGID is an improvement
> on NoNewPrivileges=False, but not required.

No, both configuration directives fail to fix the problem.  I even tried
to selectively disable directives in the service configuration file, but
for whatever reason it still fails even with seemingly unrelated things
like RestrictRealtime=yes turned back on.

The one thing that /does/ work consistently is to add
SupplementalGroups=postdrop, but that makes the whole service fail if
you don't happen to have postfix installed.

Evidently postfix is *really* dependent upon postdrop being a setgid
program and thereby being able to write to /var/spool/postfix/maildrop.
There are some horrifying workarounds like this:

https://github.com/cyberitsolutions/prisonpc-systemd-lockdown/blob/main/systemd/system/0-EXAMPLES/30-allow-mail-postfix-via-msmtp.conf

That advocate for installing msmtp, bindmounting msmtp over sendmail,
and injecting a config file that just relays mail to the localhost MTA.
I guess that works, but YUCK.

I'll play around with this a little more, but maybe email reporting just
isn't worth the trouble.

--D

> > > repeatedly, I get for a few days, every hour, hundreds of flagged log
> > > entries by logcheck.
> > 
> > Yikes.
> > 
> > > Now, the Trixie kernel seems to not support scrubbing anyway, so I can
> > > simply disable this, but it would be better to fix this and do an update
> > > (in trixe), otherwise the log spamming is really annoying.
> > 
> > Indeed.  Forky (assuming it gets 6.18/6.24) should have online fsck
> > turned on since upstream changed the kconfig default.  Not that I have
> > any idea how one gets kconfig options changed in Debian...
> 
> Me neither, but I assume a new setting would just get the default. Once
> sid kernels get to 6.18, I can test in a VM.
> 
> thanks!

