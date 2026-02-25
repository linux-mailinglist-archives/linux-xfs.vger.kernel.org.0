Return-Path: <linux-xfs+bounces-31292-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MB6lG4YFn2mZYgQAu9opvQ
	(envelope-from <linux-xfs+bounces-31292-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 25 Feb 2026 15:21:58 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B9BB5198A24
	for <lists+linux-xfs@lfdr.de>; Wed, 25 Feb 2026 15:21:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6C6DD307C4A8
	for <lists+linux-xfs@lfdr.de>; Wed, 25 Feb 2026 14:21:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCC7D3AE70C;
	Wed, 25 Feb 2026 14:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qIS2MApO"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4922B72627
	for <linux-xfs@vger.kernel.org>; Wed, 25 Feb 2026 14:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772029315; cv=none; b=sdaNS8gm0bBMHU1J04ePAlA+y205nFzq6lEy62m/w4tjoUrR+3vHNo5fvB4N9qdJzkSdilCP/DJwSEo7UzKuYWnN1j/XVxD7ombjsVLzNm7IDXrY7QC1DlczZOgy+k8q/I6gZwTMMcny8yvUKmBS6mSZeYlGtz6u4NSll4wmrs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772029315; c=relaxed/simple;
	bh=Vvy5sBwKvxMcjRb7i6vZOSDyfGn4aUdmcqb4qoDryfU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ARDYd71oaqqajS1bk59xliqp9xuZ4sWPJXDZ5N9mlx62fRR6ajvfdGNP0AiovUmDKwUFSEitFmewp6xbJQYE3NByqxtL4he56zdwPbQugbSEVkknQWsU87b9a5LnbCE5HJCiqo4Z0JzTeL/M+m15//zJD+egDreVEhI7y5fOM7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qIS2MApO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ijig1yjytzgmswe7c4GNmL6LaZ1yAC11fO/fpCC1PGA=; b=qIS2MApO7UtyYA3jpLgyV99A+3
	tzpYHLnReQ/DcpyJ+PlrXTEOaUNiC0QdyFMhwsHbpGi6QzzGWryNhXJnUO/79bFb6bA6lwnemwkRA
	hHfdGHkMAn37klzZGriIk0HL82AwhEcCmlYKeszCDBt/7QGR67LsGCI/iKYHJ7qQAYRLBUInIpZYO
	4128xLMGq4taZOnIupb8yELOODOELgeVi1qj5Y6G1FfNoxZ0RJsOv02mOAn9fg0v2kA2os/G1IBoV
	R2zG3D+ClkvsedEDtF5cgwRKKDdpIWklrjKPj/988xKUSatMpCZMIv+Vy4nz9hZzWowX3HGiIN115
	9iZHpbLg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vvFlx-00000004Bb7-2aWP;
	Wed, 25 Feb 2026 14:21:53 +0000
Date: Wed, 25 Feb 2026 06:21:53 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	=?utf-8?B?0JzQsNGA0Log0JrQvtGA0LXQvdCx0LXRgNCz?= <socketpair@gmail.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [RFE] xfs_growfs: option to clamp growth to an AG boundary
Message-ID: <aZ8FgX6oF5MYEROL@infradead.org>
References: <CAEmTpZGcBvxsMP6Qg4zcUd-D4M9-jmzS=+9ZsY2RemRDTDQcQg@mail.gmail.com>
 <20260223162320.GB2390353@frogsfrogsfrogs>
 <CAEmTpZFcHCgt_T63zE4pQk4mmyULZ7TfTNqPXDXDfJBma8dj+g@mail.gmail.com>
 <20260223230840.GD2390353@frogsfrogsfrogs>
 <aZ29NxAM6CpGXVWl@infradead.org>
 <20260224194401.GB13843@frogsfrogsfrogs>
 <20260224222551.GA13853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260224222551.GA13853@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-31292-lists,linux-xfs=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[infradead.org,gmail.com,vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@infradead.org,linux-xfs@vger.kernel.org];
	DKIM_TRACE(0.00)[infradead.org:+];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[linux-xfs];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,infradead.org:mid,infradead.org:dkim]
X-Rspamd-Queue-Id: B9BB5198A24
X-Rspamd-Action: no action

On Tue, Feb 24, 2026 at 02:25:51PM -0800, Darrick J. Wong wrote:
> > Yeah, I'll give that a spin.
> 
> ...and that regresses generic/33[34] because they actually fill the
> filesystem up to full (or at least to the point where the fs won't let
> us write more) and test that reflink returns ENOSPC.
> 
> Seeing as the reporter would actually rather we didn't fall back to a
> slow pagecache copy(!) I'll drop this patch.

Not sure if the reported wanted it, but randomly failing reflink with
ENOSPC on a file system that is not out of space is really, really
weird behavior, and I think we should fix it.

