Return-Path: <linux-xfs+bounces-31184-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yMQWG/CImGlKJgMAu9opvQ
	(envelope-from <linux-xfs+bounces-31184-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Fri, 20 Feb 2026 17:16:48 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C48921693B1
	for <lists+linux-xfs@lfdr.de>; Fri, 20 Feb 2026 17:16:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B8BE630897A1
	for <lists+linux-xfs@lfdr.de>; Fri, 20 Feb 2026 16:15:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 306523112C0;
	Fri, 20 Feb 2026 16:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a+TBIrBb"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB2E2D6407;
	Fri, 20 Feb 2026 16:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771604113; cv=none; b=nNwwLT0bpPDSGIKnH2dXBQGAfbQ0D+WOLJLYfmpi7bssheKZWyIQz5pFlHeo29omjN/jXnIaVSjDATsGCUjslZN06M7FLfs2zS+/oRQ0YUbaU99yR5evEI8Ik3bPcsc5A8EsdoYkNAm+jmLVqO/ytJTj3QOXjX71nxTsJa7grB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771604113; c=relaxed/simple;
	bh=fxyNNARTq68ILAo6lP6KWMpkcRBkwPqyBnggZNs1WSs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BChlpW+oVbK3aPv4uIs05s/qlNk1i7nU0sazFAg4PUTkHZqlpCqcjk0IsRZa1HmTKnkN26yG0we/oRiYYUP9mvVY4GmARPn4AL73MMurLBJLhSnHo0gmDcBZkpK++JtTPWBSX0zB+1YxBtLSxe5J8CzkJeKPbRwt+VlpkWX5cvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a+TBIrBb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 989FAC116C6;
	Fri, 20 Feb 2026 16:15:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771604112;
	bh=fxyNNARTq68ILAo6lP6KWMpkcRBkwPqyBnggZNs1WSs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a+TBIrBb56/XBnJATsMaQ1phXQrCQQ9SR0MXh9mRaQAO97AdId9MPZMiIperVpyWK
	 HjW74hcFHxm5Tb7knzjeVudmR1cJ2m2UBhwJzGdQVd8trjlDtpkRb2AJMc0dRcNGOQ
	 MN8D/mQpNPRPruwSwDEAGcsc92G+4UiKrnHIAzxlHI5Ipq7amBchGW+mVBb1LV2aNt
	 qjg3VqtoUm+Gkl8lKo3RCkb+KT4Y+duIWTpJ7vAV2L/S9rtVoDALLupyUSJIeXZnZy
	 Oqkfg5F8i/Bc4tjkpWPxLJAQvaKeCkdibT4JQS1BVb/YQtHQUTvSzqIZlTnWw6Hyyf
	 hYXsJKsHEScHg==
Date: Fri, 20 Feb 2026 08:15:12 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
Cc: Carlos Maiolino <cem@kernel.org>, hch@infradead.org,
	david@fromorbit.com, zlang@kernel.org, linux-xfs@vger.kernel.org,
	fstests@vger.kernel.org, ritesh.list@gmail.com,
	ojaswin@linux.ibm.com, hsiangkao@linux.alibaba.com
Subject: Re: [PATCH v1 0/7] Add multi rtgroup grow and shrink tests
Message-ID: <20260220161512.GW6490@frogsfrogsfrogs>
References: <20260219055737.769860-1-nirjhar@linux.ibm.com>
 <cover.1771425357.git.nirjhar.roy.lists@gmail.com>
 <aZcIEd9DY_bQGJ9L@nidhogg.toxiclabs.cc>
 <dd1b584b-987c-4dce-b84c-c9fe74687e95@gmail.com>
 <aZci9Fz8NgXhrUSa@nidhogg.toxiclabs.cc>
 <caf4de45aecea6ce7dda89b06c752ebfbd7e971b.camel@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <caf4de45aecea6ce7dda89b06c752ebfbd7e971b.camel@gmail.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-31184-lists,linux-xfs=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_CC(0.00)[kernel.org,infradead.org,fromorbit.com,vger.kernel.org,gmail.com,linux.ibm.com,linux.alibaba.com];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djwong@kernel.org,linux-xfs@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-xfs];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C48921693B1
X-Rspamd-Action: no action

On Fri, Feb 20, 2026 at 04:50:15PM +0530, Nirjhar Roy (IBM) wrote:
> On Thu, 2026-02-19 at 15:55 +0100, Carlos Maiolino wrote:
> > On Thu, Feb 19, 2026 at 08:10:50PM +0530, Nirjhar Roy (IBM) wrote:
> > > On 2/19/26 18:25, Carlos Maiolino wrote:
> > > > On Thu, Feb 19, 2026 at 06:10:48AM +0000, Nirjhar Roy (IBM) wrote:
> > > > > From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>
> > > > > 
> > > > > This series adds several tests to validate the XFS realtime fs growth and
> > > > > shrink functionality.
> > > > > It begins with the introduction of some preconditions and helper
> > > > > functions, then some tests that validate realtime group growth, followed
> > > > > by realtime group shrink/removal tests and ends with a test that
> > > > > validates both growth and shrink functionality together.
> > > > > Individual patches have the details.
> > > > Please don't send new versions in reply to the old one, it just make
> > > > hard to pull patches from the list. b4 usually doesn't handle it
> > > > gracefully.
> > > 
> > > This entire series is new i.e, the kernel changes, fstests and the xfsprogs
> > > changes. Can you please explain as to what do you mean by the old version?
> > > Which old are version are you referring to?
> > 
> > Sure, I said 'old version' but the same applies to sending them in reply
> > to other series/patches.
> > 
> > This series was sent:
> > 
> > In-Reply-To: <20260219055737.769860-1-nirjhar@linux.ibm.com>
> > 
> > which is:
> > 
> > Subject: xfs: Add support for multi rtgroup shrink+removal
> > 
> > 
> > In better wording, please don't nest series under other series/patches,
> > or things like that. It works in some point cases, but in general it
> > just makes my life difficult to pull them from the list.
> 
> Okay sure. Actually I have seen some patchbombs follow a similar style
> i.e, have a top level root email/cover, and under that have multiple
> patchsets with each patchset having multiple patches/commits - so
> overall a 3 level nesting. Since this work has patches in 3 different
> projects, I thought of having all of them under one roof. If that is
> inconvenient for you, I will send individual patchsets separately from
> the next revision.

Yeah, I do this too (combined kernel/xfsprogs/fstests patchsets under
one giant cover letter) because a manager wanted a one-keystroke way to
mark the entire megathread as read.

--D

>  --NR
> > 
> > 
> > > --NR
> > > 
> > > > > Nirjhar Roy (IBM) (7):
> > > > >    xfs: Introduce _require_realtime_xfs_{shrink,grow} pre-condition
> > > > >    xfs: Introduce helpers to count the number of bitmap and summary
> > > > >      inodes
> > > > >    xfs: Add realtime group grow tests
> > > > >    xfs: Add multi rt group grow + shutdown + recovery tests
> > > > >    xfs: Add realtime group shrink tests
> > > > >    xfs: Add multi rt group shrink + shutdown + recovery tests
> > > > >    xfs: Add parallel back to back grow/shrink tests
> > > > > 
> > > > >   common/xfs        |  65 +++++++++++++++-
> > > > >   tests/xfs/333     |  95 +++++++++++++++++++++++
> > > > >   tests/xfs/333.out |   5 ++
> > > > >   tests/xfs/539     | 190 ++++++++++++++++++++++++++++++++++++++++++++++
> > > > >   tests/xfs/539.out |  19 +++++
> > > > >   tests/xfs/611     |  97 +++++++++++++++++++++++
> > > > >   tests/xfs/611.out |   5 ++
> > > > >   tests/xfs/654     |  90 ++++++++++++++++++++++
> > > > >   tests/xfs/654.out |   5 ++
> > > > >   tests/xfs/655     | 151 ++++++++++++++++++++++++++++++++++++
> > > > >   tests/xfs/655.out |  13 ++++
> > > > >   11 files changed, 734 insertions(+), 1 deletion(-)
> > > > >   create mode 100755 tests/xfs/333
> > > > >   create mode 100644 tests/xfs/333.out
> > > > >   create mode 100755 tests/xfs/539
> > > > >   create mode 100644 tests/xfs/539.out
> > > > >   create mode 100755 tests/xfs/611
> > > > >   create mode 100644 tests/xfs/611.out
> > > > >   create mode 100755 tests/xfs/654
> > > > >   create mode 100644 tests/xfs/654.out
> > > > >   create mode 100755 tests/xfs/655
> > > > >   create mode 100644 tests/xfs/655.out
> > > > > 
> > > > > -- 
> > > > > 2.34.1
> > > > > 
> > > > > 
> > > -- 
> > > Nirjhar Roy
> > > Linux Kernel Developer
> > > IBM, Bangalore
> > > 
> 
> 

