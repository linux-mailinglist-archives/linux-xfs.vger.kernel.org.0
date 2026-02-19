Return-Path: <linux-xfs+bounces-31008-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UJqoNf6mlmmTiQIAu9opvQ
	(envelope-from <linux-xfs+bounces-31008-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 07:00:30 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DF9F15C42E
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 07:00:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 15F103020A46
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Feb 2026 06:00:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85FFA2DD5E2;
	Thu, 19 Feb 2026 06:00:28 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4608D299923;
	Thu, 19 Feb 2026 06:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771480828; cv=none; b=n+RdszSM1rDPtDQckPGze3Zn5tIYcvMgYhWo/sKmxHgRe0M9qGCuFtFiLLyWF6Q+N/o+GBAuKyQmeiIpxInjF+0JPVXuhaJF8Bi8dPE+d4gI53G4cLCRxFl5nEdz0X/x6CINfL9Zzf2YktwvexHM7tQPdcSZZjJrhVy4aWmO/Wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771480828; c=relaxed/simple;
	bh=lHwxlVVdiSiQsHLzUHIuDSlfIIypmm1ylC5H49bGhvM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iqbVhs2HsWxW9gDGocM4qnMuF3niSdbzW4EUh5NXldDQRQa2NgnB1JG4NVqxOz+k7QYeRgJtI3Q8Uk1i0hpvy9rQ5Q+2pTsvxSbvEHPWcDRRSP2cprHcJ9qZ8aqSJs0RL7yfuvteSVleNq89DMhE2lZde7sFjdmgT60+vquI0R4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4C57D68C7B; Thu, 19 Feb 2026 07:00:25 +0100 (CET)
Date: Thu, 19 Feb 2026 07:00:24 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org,
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	ebiggers@kernel.org, hch@lst.de
Subject: Re: [PATCH v3 07/35] iomap: introduce IOMAP_F_FSVERITY
Message-ID: <20260219060024.GB3739@lst.de>
References: <20260217231937.1183679-1-aalbersh@kernel.org> <20260217231937.1183679-8-aalbersh@kernel.org> <20260218230348.GF6467@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260218230348.GF6467@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[lst.de : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,lst.de:mid];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.966];
	TAGGED_RCPT(0.00)[linux-xfs];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_THREE(0.00)[4];
	R_DKIM_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@lst.de,linux-xfs@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-31008-lists,linux-xfs=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[]
X-Rspamd-Queue-Id: 5DF9F15C42E
X-Rspamd-Action: no action

On Wed, Feb 18, 2026 at 03:03:48PM -0800, Darrick J. Wong wrote:
> >  		old_size = iter->inode->i_size;
> > -		if (pos + written > old_size) {
> > +		if (pos + written > old_size &&
> > +		    !(iter->iomap.flags & IOMAP_F_FSVERITY)) {
> 
> I think this flag should be called IOMAP_F_POSTEOF since there's no
> "fsverity" logic dependent on this flag; it merely allows read/write
> access to folios beyond EOF without any of the usual clamping and
> zeroing...

There are fsverity-specific semantics attached because of the
magic hash handling for holes.


