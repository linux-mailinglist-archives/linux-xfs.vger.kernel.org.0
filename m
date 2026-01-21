Return-Path: <linux-xfs+bounces-30078-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IMCdNvUocWniewAAu9opvQ
	(envelope-from <linux-xfs+bounces-30078-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 20:28:53 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 9254A5C2D4
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 20:28:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 839757EFA2D
	for <lists+linux-xfs@lfdr.de>; Wed, 21 Jan 2026 17:50:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B0613B95E1;
	Wed, 21 Jan 2026 17:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SaO/G9ej"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34EB938756B
	for <linux-xfs@vger.kernel.org>; Wed, 21 Jan 2026 17:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769017358; cv=none; b=ST7kIEtkOcjMQe061EK9fagduc6kJn+oxHZ8nj988XjJm1ApAx2pYkF1QPLim9j7JhmCQYzaDG8YApj/o20mLLavKKgoFAXJ5xWapGeMuRM0EuwtGzmL2IccjtSNK+gxYBWa0lLTH0PlnnxgwCYfVUE5tPUC9tDcVI+Qmuy9ORE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769017358; c=relaxed/simple;
	bh=6Yh8Jb/qLsftGcjXntNMbOM50FmyKKIpepjUlbq/bdo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ojBI2mMsj5yXnIXIRlCyhw/WJ9AzlaUUfI/na+qZtg9IvqxTvDjKW5rIhyZDrJLToD8qrTvGN/O+kF7vlUgH6vs4aIBLeO310MEMNVL7XVCVUa7AJP12b7jBseahY3NS3h3yfczDGtZTRzh28oYm5etFXDl78VvXuBbcmLM9bMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SaO/G9ej; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3B0DC4CEF1;
	Wed, 21 Jan 2026 17:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769017356;
	bh=6Yh8Jb/qLsftGcjXntNMbOM50FmyKKIpepjUlbq/bdo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SaO/G9ej1lx2xqvjaolLHSsTYDFIc0dDDmxtI4zi+VDMlo/YPAo3sxf50bK7WWajF
	 XA7cRfWmAy7OObniuWMA2UgtviW8b3RngJs7TyjuJsdwmYGTekPkyK0zrtuHOFe45b
	 pMCjQ0OXV7TsAetW01+VET87JH75aPavpdQXUhinm2dsXDJn0gf389pyoOI7d+2LQq
	 g2+YhjGifeahvSYNKG0FDZI3Z1bwXMU/VYRBWWqwzhW/up9MV6lUWDeCJglKDSfOGJ
	 Z/KA3tn/ll0Lq1wylkGQ28X4rRW5BNHka2jABHMRw8MBYmumBTWptZtM3FFa98K8iP
	 ePKCYNVz3jPKg==
Date: Wed, 21 Jan 2026 09:42:36 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: aalbersh@redhat.com, linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] libfrog: make xfrog_defragrange return a
 positive valued
Message-ID: <20260121174236.GD5945@frogsfrogsfrogs>
References: <20260119142724.284933-1-cem@kernel.org>
 <20260119142724.284933-2-cem@kernel.org>
 <NqW0yjXmDmicRQzL8BBvI3zJRK8Qmhm9mhV6AsYNCDn2zFHjCElMSAXi-jDCnnq8-zvHN_5Q8qsmw24M-wpFtg==@protonmail.internalid>
 <20260120172039.GO15551@frogsfrogsfrogs>
 <s3welc2n2qbdqdr4nuwgef4uwckjkq4lzzsnzp3vzxozpkoy6w@hym4evwdf63k>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s3welc2n2qbdqdr4nuwgef4uwckjkq4lzzsnzp3vzxozpkoy6w@hym4evwdf63k>
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-30078-lists,linux-xfs=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	DMARC_POLICY_ALLOW(0.00)[kernel.org,quarantine];
	DKIM_TRACE(0.00)[kernel.org:+];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djwong@kernel.org,linux-xfs@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[3];
	TAGGED_RCPT(0.00)[linux-xfs];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo]
X-Rspamd-Queue-Id: 9254A5C2D4
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, Jan 21, 2026 at 09:57:51AM +0100, Carlos Maiolino wrote:
> On Tue, Jan 20, 2026 at 09:20:39AM -0800, Darrick J. Wong wrote:
> > On Mon, Jan 19, 2026 at 03:26:50PM +0100, cem@kernel.org wrote:
> > > From: Carlos Maiolino <cem@kernel.org>
> > >
> > > Currently, the only user for xfrog_defragrange is xfs_fsr's packfile(),
> > > which expects error to be a positive value.
> > >
> > > Whenever xfrog_defragrange fails, the switch case always falls into the
> > > default clausule, making the error message pointless.
> > >
> > > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > > ---
> > >  libfrog/file_exchange.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/libfrog/file_exchange.c b/libfrog/file_exchange.c
> > > index e6c3f486b0ff..31bbc6da60c3 100644
> > > --- a/libfrog/file_exchange.c
> > > +++ b/libfrog/file_exchange.c
> > > @@ -232,7 +232,7 @@ xfrog_defragrange(
> > >  	if (ret) {
> > >  		if (errno == EOPNOTSUPP || errno != ENOTTY)
> > >  			goto legacy_fallback;
> > > -		return -errno;
> > > +		return errno;
> > 
> > Hrmm.  If you're going to change the polarity of the error numbers (e.g.
> > negative to positive) then please update the comments.
> 
> Sorry, I did it quickly and didn't even pay attention there were
> comments :)
> 
> > 
> > That said, I'd prefer to keep the errno polarity the same at least
> > within a .c file ... even though libfrog is a mess of different error
> > number return strategies.  What if the callsite changed to:
> > 
> > 	/* Swap the extents */
> > 	error = -xfrog_defragrange(...);
> 
> This looks to just add more confusion to it IMHO, it's not 'easy' for me
> at least to notice the minus sign in front of it.
> 
> What about just changing the switch case to catch for -ERROR instead of
> their positive counterparts? At least we stop playing the error sign
> change and just catch what we already have.

Sure, do whatever you think is best.  This whole part of C is an
unfixable mess as far as I'm concerned.

--D

> 
> > 
> > and
> > 
> > 	/* Snapshot file_fd before we start copying data... */
> > 	error = -xfrog_defragrange_prep(...);
> > 
> > (and I guess io/exchrange.c also needs a fix)
> > 
> > 	/* Snapshot the original file metadata in anticipation... */
> > 	ret = -xfrog_commitrange_prep(...);
> > 
> > Hrm?
> > 
> > --D
> > 
> > >  	}
> > >
> > >  	return 0;
> > > @@ -240,7 +240,7 @@ xfrog_defragrange(
> > >  legacy_fallback:
> > >  	ret = xfrog_ioc_swapext(file2_fd, xdf);
> > >  	if (ret)
> > > -		return -errno;
> > > +		return errno;
> > >
> > >  	return 0;
> > >  }
> > > --
> > > 2.52.0
> > >
> > >
> > 
> 

