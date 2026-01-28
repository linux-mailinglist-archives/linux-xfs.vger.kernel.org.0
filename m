Return-Path: <linux-xfs+bounces-30412-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cGPUILyGeWnjxQEAu9opvQ
	(envelope-from <linux-xfs+bounces-30412-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Jan 2026 04:47:08 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 159429CD7B
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Jan 2026 04:47:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0D884300A4E1
	for <lists+linux-xfs@lfdr.de>; Wed, 28 Jan 2026 03:47:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 553182DC32A;
	Wed, 28 Jan 2026 03:47:05 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09BF92DB7B4
	for <linux-xfs@vger.kernel.org>; Wed, 28 Jan 2026 03:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769572025; cv=none; b=Xqd8eZ5X67NRRd2sGoJrucNkP2LiNmeRExshSdKHRoDmKrGRneF0Q26qWPYJGTiHqavT99HVuEfvCRGYADWthE1kWGO+jjDS9fOyc+C9X3IbSDBeUH4tul8qRygxcLWNDr3hC9zMiGs7HVN2VQNArWZRg64qsox6He/USVhxXoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769572025; c=relaxed/simple;
	bh=KgHifRE21TAx7FWYqkQw6MdVjlhWTBRwQJWmOk4rs6E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G8IruYM54TzcKKLBEs2p1R1uLOq6dxUIyPyiVuQgGtdMsr2tThKCsS1JpEWuA/o+NFU0YNyuoHfNMX7lb6Fqea6flqfJAX7zBa50WkW8b/gKk17NNMTEOnmNCtQTrKvTWKc5nGYukP3AzR5F+jvLF/9MXRmTteYHd8vuCrBz5QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0BD35227A8E; Wed, 28 Jan 2026 04:47:02 +0100 (CET)
Date: Wed, 28 Jan 2026 04:47:01 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 07/10] xfs: don't mark all discard issued by zoned GC
 as sync
Message-ID: <20260128034701.GD30989@lst.de>
References: <20260127160619.330250-1-hch@lst.de> <20260127160619.330250-8-hch@lst.de> <20260128013818.GG5945@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128013818.GG5945@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[lst.de : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_RCPT(0.00)[linux-xfs];
	NEURAL_HAM(-0.00)[-1.000];
	MID_RHS_MATCH_FROM(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	R_DKIM_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[lst.de:mid,lst.de:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	RCVD_TLS_LAST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@lst.de,linux-xfs@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-30412-lists,linux-xfs=lfdr.de];
	RCPT_COUNT_FIVE(0.00)[5]
X-Rspamd-Queue-Id: 159429CD7B
X-Rspamd-Action: no action

On Tue, Jan 27, 2026 at 05:38:18PM -0800, Darrick J. Wong wrote:
> On Tue, Jan 27, 2026 at 05:05:47PM +0100, Christoph Hellwig wrote:
> > Discard are not usually sync when issued from zoned garbage collection,
> > so drop the REQ_SYNC flag.
> 
> Cc: <stable@vger.kernel.org> # v6.15
> 
> > Fixes: 080d01c41d44 ("xfs: implement zoned garbage collection")
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> What does REQ_SYNC even mean for a discard, anyway?

It expedites a few things in the block submission path basically.
And deep magic in the I/O schedulers, but I'm not sure if that
even applies to discard.


