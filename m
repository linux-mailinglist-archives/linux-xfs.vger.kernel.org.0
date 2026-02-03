Return-Path: <linux-xfs+bounces-30600-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AE5GB/6EgWmcGwMAu9opvQ
	(envelope-from <linux-xfs+bounces-30600-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Tue, 03 Feb 2026 06:17:50 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D4349D498C
	for <lists+linux-xfs@lfdr.de>; Tue, 03 Feb 2026 06:17:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id F0F293006917
	for <lists+linux-xfs@lfdr.de>; Tue,  3 Feb 2026 05:17:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4E32365A1A;
	Tue,  3 Feb 2026 05:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mCKDnNuI"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E1835C1AD
	for <linux-xfs@vger.kernel.org>; Tue,  3 Feb 2026 05:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770095863; cv=none; b=fTOSUjGC3Fz2sllC14qVmdSDGFvr+aDaUvxGhImUmVNGBVBJLgq2F94yV/4g7KUAcyTyDn811FuhjCggi7f6WOZWnHdMc36PJqfGV7QdfXL6b6oAJ4GZ1ZlN5GQ+d0wXR4mRpNYnO3v+wPrz9MrI6+IbPl6F4CdgIvIVbcgAE+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770095863; c=relaxed/simple;
	bh=DyYrPDsD8L2OWl/cA3lK4PLa+B0eTiKtVjv3MFdkUv4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XM/QYCeX/75526Y6seCP9Ie7gdvfzattE8SWS6UQpzAG0xlw//yDppg1LS61CIh/XP/5p6/JLcZoHy8B5R3dcBX7jKf53R4bDpIlCBULKp1RS7WvCNE6yo4jykad/ifIombLunqAxsgUVz9vLzZi0wQASvDFEb9Yf0bgCd/lCik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mCKDnNuI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=pYFzqoC20lLFGw0vJqhKGVBPHluXrteT63y94PqfWwI=; b=mCKDnNuIDsGtl3guYvvKcsVNZR
	rQSxn//zOWhPQ0DxVowiHGzWrmHhAf9K0EQ6R/P+VmNgjlGdu5LCW4bwbcNOXCp2SnOh7svLUOGOH
	PyWuak7+KZLqMN6vxWtg7jJm1NLlPX0uhU/onD4Qk5yvBRjfM97AisTO+KyTfQvuLFl0T66/Olkek
	bTBCi6uC/PvjOLjF+yM446K7qLmHjYTjMQahCoxF0jZ/FiGXC9ulE6ROo6IubF/E40/TXl/yrKnQE
	LB1aWk3M4b5xZy/Wr07zO9DXgdBuRbnw4kyRgCngmkd6+hnn6Nvdd8AdV/RaR6+wAwP1kBIF7JRQn
	5a+YZ4gQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vn8n5-000000065Vm-115w;
	Tue, 03 Feb 2026 05:17:31 +0000
Date: Mon, 2 Feb 2026 21:17:31 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Lukas Herbolt <lukas@herbolt.com>,
	Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
	cem@kernel.org
Subject: Re: [PATCH] xfs: Use xarray to track SB UUIDs instead of plain array.
Message-ID: <aYGE65iSRZWmxyVI@infradead.org>
References: <20260130154206.1368034-2-lukas@herbolt.com>
 <20260130154206.1368034-4-lukas@herbolt.com>
 <20260130165534.GG7712@frogsfrogsfrogs>
 <aYBSzg3IhFffphuI@infradead.org>
 <698e4433ee0b01978deed124792c7e57@herbolt.com>
 <20260202185013.GH7712@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260202185013.GH7712@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-30600-lists,linux-xfs=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[infradead.org:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@infradead.org,linux-xfs@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[linux-xfs];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[infradead.org:mid,infradead.org:dkim,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D4349D498C
X-Rspamd-Action: no action

On Mon, Feb 02, 2026 at 10:50:13AM -0800, Darrick J. Wong wrote:
> > I do not have strong preference here.
> 
> <shrug> Since the original message said "krealloc prints out warning if
> allocation is bigger than 2x PAGE_SIZE", I figured that meant you were
> trying to mount more than (2 * 4096) / 16 == 512 different xfs
> filesystems on the same host.

I don't remember any such message.  But array or xarray iterations
should still scale well enough for a single mount time operation into
the 10.000nds of entries.

> I don't have a particular problem with the array search and large memory
> allocation since I never mount that many filesystems, but you would
> appear to be the first user to complain about a scaling limit there...

I was really just concerned about a single large allocation.  But yeah,
it's not that large...  That beind said I think the xarray version will
also look nicer than the original one.


