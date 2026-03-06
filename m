Return-Path: <linux-xfs+bounces-31978-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MMiVErX6qmmcZAEAu9opvQ
	(envelope-from <linux-xfs+bounces-31978-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Fri, 06 Mar 2026 17:03:01 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id BCE632247BC
	for <lists+linux-xfs@lfdr.de>; Fri, 06 Mar 2026 17:03:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AFCE030C25B7
	for <lists+linux-xfs@lfdr.de>; Fri,  6 Mar 2026 15:58:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4183D393DC0;
	Fri,  6 Mar 2026 15:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VI2soQCM"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CED137BE8A
	for <linux-xfs@vger.kernel.org>; Fri,  6 Mar 2026 15:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772812708; cv=none; b=YINOcGqIXwoFGfnnLvCKoph8I4pN2VIED5rk9i6rtriz8rBFalyOrplXMil015QxbVgM0j5uBPJelxpPh+Kw5AA0dXjibVW7ED2gFZvUv3AW9a16H3VjD8oSNYSkR2Do1v59tO8bY25J9G2Wll1AHnTn8pPhk+L4veaRMjIKkmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772812708; c=relaxed/simple;
	bh=RITY+AVjisUnSltvDgEzF2hwccvyYEM9ZjTKF9QUEM4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VbptoGxSj1FCHnYB+jfLkU78HPOSZocKXLHgvYoumD4EXD77MVd0vN9C2K9xOfhUKhH4r10gIcRlDjQ2QD6LxUyiLBXi0T+XLpqjy6pi5OJ4XmdWp1o/lqXaPi5y5gBfdvkhM8c60IMEm9hu8ZnsiqDDI2NaKdzkC5l/LJF+9dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VI2soQCM; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA30AC4CEF7;
	Fri,  6 Mar 2026 15:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772812708;
	bh=RITY+AVjisUnSltvDgEzF2hwccvyYEM9ZjTKF9QUEM4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VI2soQCMFy3TYzH0hLMFRtAZ5vg568nQjNamdzAyKie5c+9WSkNuFOF3tucPXS7a0
	 XepRGYjtE0VV5mak8rmFMmt8hFdxZbIoK4shl57HACaPXlF9BwCXq0HgowTSs1igBd
	 pzf8h+QNYu+txzStS+5Tj7TW/xrTWJEKeWe8biJP4CougPYVJcQzB+W6Fj6lKk9zDj
	 1xqxFjKhls02O439zRQrY4+HgxkQRs9VnzgySKn/q72KGTXFpbrD84U8FyVkAZSwDs
	 OJ1i+8iRFKffxUvYJCFP50hPrR+fyhgQgdFRV5Xr+4Xb5kfllbk+JusYpQws1h70qf
	 ANy0/z3ngYYYg==
Date: Fri, 6 Mar 2026 07:58:27 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 23/26] xfs_io: print systemd service names
Message-ID: <20260306155827.GD1487097@frogsfrogsfrogs>
References: <177249783165.482027.209169366483011357.stgit@frogsfrogsfrogs>
 <177249783711.482027.11261039889156364110.stgit@frogsfrogsfrogs>
 <aacE3gW9j6pKrspy@infradead.org>
 <20260303172916.GR57948@frogsfrogsfrogs>
 <aagt0pZTkqysyjQJ@infradead.org>
 <20260304163502.GV57948@frogsfrogsfrogs>
 <aamLP5UnWiPhvKqh@infradead.org>
 <20260305220051.GG57948@frogsfrogsfrogs>
 <aaripVrvxgo003ya@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aaripVrvxgo003ya@infradead.org>
X-Rspamd-Queue-Id: BCE632247BC
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-31978-lists,linux-xfs=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-0.949];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[djwong@kernel.org,linux-xfs@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	TAGGED_RCPT(0.00)[linux-xfs];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Fri, Mar 06, 2026 at 06:20:21AM -0800, Christoph Hellwig wrote:
> On Thu, Mar 05, 2026 at 02:00:51PM -0800, Darrick J. Wong wrote:
> > > Still seems totally out of place for something not touching the
> > > on-disk structures.  What's the problem with adding a new trivial
> > > binary for it?  Or even just publishing the name in a file in
> > > /usr/share?
> > 
> > Eh I'll just put it in xfs_{scrub,healer} as a --svcname argument.
> 
> I think I proposed something like this before, and I really like
> that!

Yes, you did propose it before, and I figured you'd like it :)

--D

