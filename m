Return-Path: <linux-xfs+bounces-30339-lists+linux-xfs=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-xfs@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yG1oLzxLeGn2pAEAu9opvQ
	(envelope-from <linux-xfs+bounces-30339-lists+linux-xfs=lfdr.de@vger.kernel.org>)
	for <lists+linux-xfs@lfdr.de>; Tue, 27 Jan 2026 06:21:00 +0100
X-Original-To: lists+linux-xfs@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6400F90147
	for <lists+linux-xfs@lfdr.de>; Tue, 27 Jan 2026 06:21:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 6F73F300DF45
	for <lists+linux-xfs@lfdr.de>; Tue, 27 Jan 2026 05:20:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18BFC283FEA;
	Tue, 27 Jan 2026 05:20:55 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4D115B971
	for <linux-xfs@vger.kernel.org>; Tue, 27 Jan 2026 05:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769491255; cv=none; b=cdyCEXLEc1kFMRcldCxby7QzvSrmBeCqcbGdVb1Ehj+ST1juQ4XoKAcR1PHlkrCJGX6AEoaRRS6etMthOfEP6CscZHm/MyyZ6AbiEOZvQPwFLzdVLDeaEd+ud526iJnI8Bn6Nc5uTyrgcxcssM8UZaYkd7c6Pj6I9WIzaZ/fB88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769491255; c=relaxed/simple;
	bh=LMNNvakHN6uYUCwE6NDEm2Qxn4e2hSzppBHzT7UwqwQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RHJr6/T3MYAMZ5+lKyQ6OEJ4aRTLtyIQMvXCF4POFhzKq9uNqj+9gEIuWM66YzNncQOWNxDE7/FsKYYNVj+CHI1EpTb5kqocesykxMo4ADIATILcOgXYrvuy3qxS0jtsmdp17DhQCzMkTDbeRIJWi+x88fWyGDZecF4T+CHYwiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C5221227AAE; Tue, 27 Jan 2026 06:20:50 +0100 (CET)
Date: Tue, 27 Jan 2026 06:20:50 +0100
From: Christoph Hellwig <hch@lst.de>
To: Brian Foster <bfoster@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
	"Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH 1/3] xfs: don't keep a reference for buffers on the LRU
Message-ID: <20260127052050.GB24364@lst.de>
References: <20260126053825.1420158-1-hch@lst.de> <20260126053825.1420158-2-hch@lst.de> <aXe-EkVrEB-UhNy2@bfoster>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aXe-EkVrEB-UhNy2@bfoster>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	DMARC_POLICY_SOFTFAIL(0.10)[lst.de : SPF not aligned (relaxed), No valid DKIM,none];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_RCPT(0.00)[linux-xfs];
	NEURAL_HAM(-0.00)[-1.000];
	MID_RHS_MATCH_FROM(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	R_DKIM_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,lst.de:mid];
	RCVD_TLS_LAST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@lst.de,linux-xfs@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-30339-lists,linux-xfs=lfdr.de];
	RCPT_COUNT_FIVE(0.00)[6]
X-Rspamd-Queue-Id: 6400F90147
X-Rspamd-Action: no action

On Mon, Jan 26, 2026 at 02:18:42PM -0500, Brian Foster wrote:
> > +	/*
> > +	 * If the buffer is in use, remove it from the LRU for now as we can't
> > +	 * free it.  It will be added to the LRU again when the reference count
> > +	 * hits zero.
> > +	 */
> > +	if (bp->b_hold > 0) {
> > +		list_lru_isolate(lru, &bp->b_lru);
> > +		spin_unlock(&bp->b_lock);
> > +		return LRU_REMOVED;
> > +	}
> > +
> 
> Sorry I missed this on my first look at this, but I don't think I quite
> realized why this was here. This looks like a subtle change in behavior
> where a buffer that makes it onto the LRU and then is subsequently held
> can no longer be cycled off the LRU by background shrinker activity.
> Instead, we drop the buffer off the LRU entirely where it will no longer
> be visible from ongoing shrinker activity.

Yes.

> AFAICT the reason for this is we no longer support the ability for the
> shrinker to drop the LRU b_hold ref to indicate a buffer is fully cycled
> out and can go direct to freeing when the current b_hold lifecycle ends.
> Am I following that correctly?

Yes.

> If so, that doesn't necessarily seem like a showstopper as I'm not sure
> realistically a significant amount of memory would be caught up like
> this in practice, even under significant pressure. But regardless, why
> not do this preventative LRU removal only after the lru ref count is
> fully depleted? Wouldn't that more accurately preserve existing
> behavior, or am I missing something?

It would more closely resemble the current behavior, which seems wrong
and an artifact of the current reference counting.  A buffer that is
in use really should not be counted down on the LRU, which really is
for unused buffers.  So starting the countdown only once the buffer
is unused is the right thing to do.  I should have explained this
much better, though.


