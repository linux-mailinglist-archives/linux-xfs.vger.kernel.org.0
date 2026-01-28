Return-Path: <linux-xfs+bounces-30477-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EIL3ORw+emlB4wEAu9opvQ
	(envelope-from <linux-xfs+bounces-30477-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Jan 2026 17:49:32 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 09D15A62AF
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Jan 2026 17:49:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id E2F9A30192AF
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Jan 2026 16:14:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DC7E2D29B7;
	Wed, 28 Jan 2026 16:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pNFO4xzl"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B7632505AA
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 16:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769616888; cv=none; b=C1uQSOEJ6m3FRxs7mxaODPiT7ZDhjkFnvItEtErjW3jwiDKc5iMzVkJTHO+inWc2zO3Dt7530IRPILQlr7OfZOJ8EeUWhKc5pc23r8Cu5h/S8pDJpj/RJA8Ih+mOJszoTIw8IYz6yKGV+QfMavMXAYHYkTigG1+bc3awkL8ELU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769616888; c=relaxed/simple;
	bh=uEnAsUsFeeFm1FfLlwmUBwPH/hEqLJoJCSjv8V+gsUU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jDfDG6olcdgFAevZAQU9uO3iJK6YjDJVSjVeIFipfD+Qk3bkUyCsJvlMTBSVAqTh9L8+fD3f0jETqr2edehYiqHkdrx7fPFP1dUqoqczHyYs9+K5QVEEkD4yjZz4R8ZkC25JB/MWJijfdOpvFViIXrZ1WI7jf+DouDjBrkeALC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pNFO4xzl; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 017BFC4CEF1;
	Wed, 28 Jan 2026 16:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769616888;
	bh=uEnAsUsFeeFm1FfLlwmUBwPH/hEqLJoJCSjv8V+gsUU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pNFO4xzlccHaNbmQiOMaHDy33glWyxPTyaJLndmYSsqkw130vs1Dg1lYSXGP/Oz+5
	 8i1cSfp7tqGjXfYrg4Buda9sfVVKxeUcEzOu/vXBirhE3VxIQFFKvTmoE5FatBiK93
	 19dn+5zKrCkbPU/4fqi1z+Sg5TtdWxiKcltFL2UBtL9bL6i/dMpAlkodacVtnKp3DI
	 WDXuDNqB41q9KMvbMRSROiWZgdRxi18UWEyakhoxRjYz6TulyJLerGUEoIXGSN6grA
	 e2CVBrYY9AxZybKDAKLyIX3O/5wGkjnOZPYKTwrpIjv0S4cWBs8df0Dq032hqj0EcX
	 1OFAbmMrF+S+A==
Date: Wed, 28 Jan 2026 08:14:47 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Alan Huang <mmpgouride@gmail.com>
Cc: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>,
	linux-xfs@vger.kernel.org, ritesh.list@gmail.com,
	ojaswin@linux.ibm.com, hch@infradead.org
Subject: Re: [PATCH v1 1/2] xfs: Move ASSERTion location in
 xfs_rtcopy_summary()
Message-ID: <20260128161447.GV5945@frogsfrogsfrogs>
References: <cover.1769613182.git.nirjhar.roy.lists@gmail.com>
 <a904c5bcb5b4fc2c7c2429646251a7f429a67d5a.1769613182.git.nirjhar.roy.lists@gmail.com>
 <AFEDD069-01DE-4DDF-B499-9B2C2C3F8778@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AFEDD069-01DE-4DDF-B499-9B2C2C3F8778@gmail.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-30477-lists,linux-xfs=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_TO(0.00)[gmail.com];
	RCVD_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	RCPT_COUNT_FIVE(0.00)[6];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djwong@kernel.org,linux-xfs@vger.kernel.org];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,linux.ibm.com,infradead.org];
	TAGGED_RCPT(0.00)[linux-xfs];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 09D15A62AF
X-Rspamd-Action: no action

On Wed, Jan 28, 2026 at 11:25:17PM +0800, Alan Huang wrote:
> On Jan 28, 2026, at 23:14, Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com> wrote:
> > 
> > We should ASSERT on a variable before using it, so that we
> > don't end up using an illegal value.
> > 
> > Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
> > ---
> > fs/xfs/xfs_rtalloc.c | 6 +++++-
> > 1 file changed, 5 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
> > index a12ffed12391..9fb975171bf8 100644
> > --- a/fs/xfs/xfs_rtalloc.c
> > +++ b/fs/xfs/xfs_rtalloc.c
> > @@ -112,6 +112,11 @@ xfs_rtcopy_summary(
> > error = xfs_rtget_summary(oargs, log, bbno, &sum);
> > if (error)
> > goto out;
> > + if (sum < 0) {
> > + ASSERT(sum >= 0);
> 
> 
> Does the ASSERT make sense under the if condition ?

Yes, it's logging that the function failed due to some sort of loop
control problem, rather than the current behavior where it logs the
assert failure and .... keeps going.

--D

> 
> > + error = -EFSCORRUPTED;
> > + goto out;
> > + }
> > if (sum == 0)
> > continue;
> > error = xfs_rtmodify_summary(oargs, log, bbno, -sum);
> > @@ -120,7 +125,6 @@ xfs_rtcopy_summary(
> > error = xfs_rtmodify_summary(nargs, log, bbno, sum);
> > if (error)
> > goto out;
> > - ASSERT(sum > 0);
> > }
> > }
> > error = 0;
> > -- 
> > 2.43.5
> > 
> > 
> 
> 

