Return-Path: <linux-xfs+bounces-22969-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 414C4AD2C9E
	for <lists+linux-xfs@lfdr.de>; Tue, 10 Jun 2025 06:27:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7FD663B188E
	for <lists+linux-xfs@lfdr.de>; Tue, 10 Jun 2025 04:26:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EFFA25DCE5;
	Tue, 10 Jun 2025 04:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="u/mwn7YO"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E561A727D;
	Tue, 10 Jun 2025 04:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749529630; cv=none; b=HV6Uw6TdZF44fdLFv32dN/P6LMC1P/oL/N79XjEG6kjcg9GdeqGznJvOAPhumkKU1TBftk9RAjKxAIKhB98mNGX4mrGGqow4WPJw1LQOe90EXeqUYzgiSQLb2nMzU0Xcyn7hZIVJvyOqgWBqvK8ZKCPkQzxA70qzlfxFMtfmHDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749529630; c=relaxed/simple;
	bh=dov7b1LWN2Ocyb8Mkg0J3jO+vnCe3FVBWiGItjaHKIk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WpGMC+f51cK7jYncKEDpvrhlOeN3yrs0/BoeB4WJUQoJMTh4jhNyHY3f/PHjLTL7iLYISah3HEVErkQOiCWH6Xfz0klyHXhxucIkwVaapCThPfgRtNHD+EQwbkovhAJmZUn9wC9KsOpRkBTnkLSZt2HgJMZKIACzW7E3VpBSgS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=u/mwn7YO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6j9kCIFFmi6qxhj67+KXg+0HPqhBU06rEgEjBWJ3HqY=; b=u/mwn7YOMEFjX+xq+kFfFBFwXw
	QBb25ackLhAVhjk6i/cfU8kwHwCMkfTXerelYZtQnz9keqs41poQAs2fxKGjQbSaT+I/U9dBzM8Xj
	6jw+exqZEFs4lw7a1ozkCjVxBCtm6fMJZr43IWvy9SNqpgH9xA73ZVHaq3zoRJf+b8ruWm2P1Yrqq
	YXxCEQE3P07vLT34ANas/7pNrkfpCTn+nQEcuee1aR4z1+919nm7jnJnRIJEEDpbfPb8DoWDJgdQo
	/V1Ci0yg3/2wDh8inkTf2WGDsKQwAL47MmL8tLSxSvVYWcIej6+mA9S3bLWW3GR/VvAPL6JH9MtX8
	0upB0wNw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uOqZn-00000005kRj-41k2;
	Tue, 10 Jun 2025 04:27:07 +0000
Date: Mon, 9 Jun 2025 21:27:07 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Brian Foster <bfoster@redhat.com>, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/7] iomap: optional zero range dirty folio processing
Message-ID: <aEe0G8a8qL2CjgOg@infradead.org>
References: <20250605173357.579720-1-bfoster@redhat.com>
 <20250605173357.579720-4-bfoster@redhat.com>
 <20250609160420.GC6156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250609160420.GC6156@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Mon, Jun 09, 2025 at 09:04:20AM -0700, Darrick J. Wong wrote:
> > +	if (iter->fbatch) {
> > +		struct folio *folio = folio_batch_next(iter->fbatch);
> > +
> > +		if (folio) {
> > +			folio_get(folio);
> > +			folio_lock(folio);
> 
> Hrm.  So each folio that is added to the batch isn't locked, nor does
> the batch (or iomap) hold a refcount on the folio until we get here.

find_get_entry references a folio, and filemap_get_folios_dirty
preserves that reference.  It will be released in folio_batch_release.
So this just add an extra reference for local operation so that the
rest of iomap doesn't need to know about that magic.

> Do
> we have to re-check that folio->{mapping,index} match what iomap is
> trying to process?  Or can we assume that nobody has removed the folio
> from the mapping?

That's a good point, though  as without having the folio locked it
could get truncated, so I think we'll have to redo the truncate
check here.


