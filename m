Return-Path: <linux-xfs+bounces-18519-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D0259A18C8A
	for <lists+linux-xfs@lfdr.de>; Wed, 22 Jan 2025 08:05:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B2EED3A3F58
	for <lists+linux-xfs@lfdr.de>; Wed, 22 Jan 2025 07:05:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D640619341F;
	Wed, 22 Jan 2025 07:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iQKTNtye"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90346170A30;
	Wed, 22 Jan 2025 07:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737529521; cv=none; b=U/FVr9wehOw5s9cvBkmoXsgSzX5EPWxEl6GvnPqMWmPOktski+X6C30BLTXLzPqsFnlpd4Adt3FRlaeheYncx0WZxn4mcuwSHgwcaJhxTMxFCnk65l/dY92RqYXBVRjDdS+xjWPVzravgd8AVfwZlJ6uaW1xM/Vk8dAw+5hQovg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737529521; c=relaxed/simple;
	bh=dmaN1PyI3doIGcfzfnWK+IjDV2PLESEQIR64XSz/+aw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DfNprEyI/FSzoUtVJpLqlGQW+fOm/EqY766jQxrE3fisAhg1ZGNJm4sIbsUg0TUKLq3iFqyxaP50hEbyYNfLqXsNYWAQ8D5/5Ec6+Z0AD8WUWpAknsICuGZVwhCGIps7QuotQ6IGIqB8rvFS/fDUGtPIKoSAdNDQ6qnEV9QS6R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iQKTNtye; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E926CC4CED6;
	Wed, 22 Jan 2025 07:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737529521;
	bh=dmaN1PyI3doIGcfzfnWK+IjDV2PLESEQIR64XSz/+aw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iQKTNtyexPHvUfP/xLJER2rb1TFx87NJGBt4/FSv2sT3YVyZCTppWU/am+40XH8t0
	 ifst/bMG682rBOmqLH3rJupw+NceWB5YxadRi/ikTVsYXuuC0Fp1zPF90griUQVp0P
	 U/5RqD0c7+0u68Nz/3Xfwu2alXtR15Pv1zbDyNRkwtGXn7BAzAX0lnlYpnwlpxeJpz
	 TzUfpxwCKMkFA7wb+bi0cut5vAj5R2B4Wow5WSnJMO+GYQdoxLtdm8aGneK+U4/N+g
	 zhJnDnFeBQ8X1QE84OmRIPyIQ/b1m2/6gPfGzFoFrbrgjsNMFv2dSe5qXnoMa5fFRu
	 /AUKWbWQDjM7w==
Date: Tue, 21 Jan 2025 23:05:20 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: zlang@redhat.com, hch@lst.de, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 08/23] common: fix pkill by running test program in a
 separate session
Message-ID: <20250122070520.GD1611770@frogsfrogsfrogs>
References: <173706974044.1927324.7824600141282028094.stgit@frogsfrogsfrogs>
 <173706974197.1927324.9208284704325894988.stgit@frogsfrogsfrogs>
 <Z48UWiVlRmaBe3cY@dread.disaster.area>
 <20250122042400.GX1611770@frogsfrogsfrogs>
 <Z5CLUbj4qbXCBGAD@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z5CLUbj4qbXCBGAD@dread.disaster.area>

On Wed, Jan 22, 2025 at 05:08:17PM +1100, Dave Chinner wrote:
> On Tue, Jan 21, 2025 at 08:24:00PM -0800, Darrick J. Wong wrote:
> > On Tue, Jan 21, 2025 at 02:28:26PM +1100, Dave Chinner wrote:
> > > On Thu, Jan 16, 2025 at 03:27:15PM -0800, Darrick J. Wong wrote:
> > > > c) Putting test subprocesses in a systemd sub-scope and telling systemd
> > > > to kill the sub-scope could work because ./check can already use it to
> > > > ensure that all child processes of a test are killed.  However, this is
> > > > an *optional* feature, which means that we'd have to require systemd.
> > > 
> > > ... requiring systemd was somewhat of a show-stopper for testing
> > > older distros.
> > 
> > Isn't RHEL7 the oldest one at this point?  And it does systemd.  At this
> > point the only reason I didn't go full systemd is out of consideration
> > for Devuan, since they probably need QA.
> 
> I have no idea what is out there in distro land vs what fstests
> "supports". All I know is that there are distros out there that
> don't use systemd.
> 
> It feels like poor form to prevent generic filesystem QA
> infrastructure from running on those distros by making an avoidable
> choice to tie the infrastructure exclusively to systemd-based
> functionality....

Agreed, though at some point after these bugfixes are merged I'll see if
I can build on the existing "if you have systemd then ___ else here's
your shabby opencoded version" logic in fstests to isolate the ./checks
from each other a little better.  It'd be kinda nice if we could
actually just put them in something resembling a modernish container,
albeit with the same underlying fs.

<shrug> Anyone else interested in that?

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 

