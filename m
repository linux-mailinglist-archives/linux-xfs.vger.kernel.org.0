Return-Path: <linux-xfs+bounces-19593-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 52858A350ED
	for <lists+linux-xfs@lfdr.de>; Thu, 13 Feb 2025 23:08:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DBB42188F838
	for <lists+linux-xfs@lfdr.de>; Thu, 13 Feb 2025 22:08:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11AFB20D50E;
	Thu, 13 Feb 2025 22:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y+At3/se"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45701714B7
	for <linux-xfs@vger.kernel.org>; Thu, 13 Feb 2025 22:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739484490; cv=none; b=tih/NwP9BPFjwqKpfaIJyNPLTbtxRvkAHF/seOMuJAXEr9uh0FPs9pSGOlwhSV7qvUUsvQaPrmnEMvjQ3nSHQq+yy4orkbo70I29qpOc4xN6PHHdbIssH8HET+5Ru8y5mqIYiV8C4yyetpTaCsoc6vvRssu92WLrx2eaEfGF4Ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739484490; c=relaxed/simple;
	bh=aLXO1ymjosr1ArxVj1FCe8OA1WnI+7mCwCTtFYBrWlM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YMFGiafmPW02w65pFAg369rAMeLbgKjTP9/mLxx3vmcnFsZNvBDV4TbCbb6Wv8VxpHC/duOU+X7d3M6Qen3p2Uk2fi2rxOXw1uoTRI4NWNgEajE/JJBHWS7lcECr/AGNgYrhz1m31+RYE5VWKWDnTvs/OE20tmvQDmA1JpzaAYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y+At3/se; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F90C4CED1;
	Thu, 13 Feb 2025 22:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739484490;
	bh=aLXO1ymjosr1ArxVj1FCe8OA1WnI+7mCwCTtFYBrWlM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y+At3/seOWZu/dBds2X5rILgw1O0Gp1OncI4DQbR7WPvFWsc0Sr7Ry1ac1Gy92qzJ
	 docrVofWAurHSitEq4D4TPNFcFkOKTvqO2yQshx9aEj0CWC9ZyFs0A9mQdyEzPZ02y
	 YXbYmUwyR/gvk8/rb4pm6FO674VOTmx35gxEqSOyGGX0s2htL4IVTJFAcGNNI9eQLq
	 fozkmaonvhj5FdhDpB6EUy0SLTPaYKvb66qMpYpLA4Qhw9TwSuOEn3kQ4MDNKrqSFz
	 vkIrefql08WpguSZFUwibF8dT2w5sNbuD7h23gglp3ZpH88Wy8LMpqaBZrbR0DHO7L
	 yreFZKuHZMC+A==
Date: Thu, 13 Feb 2025 14:08:09 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Hans Holmberg <hans.holmberg@wdc.com>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 22/43] xfs: add the zoned space allocator
Message-ID: <20250213220809.GT21808@frogsfrogsfrogs>
References: <20250206064511.2323878-1-hch@lst.de>
 <20250206064511.2323878-23-hch@lst.de>
 <20250207173942.GZ21808@frogsfrogsfrogs>
 <20250213051448.GC17582@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250213051448.GC17582@lst.de>

On Thu, Feb 13, 2025 at 06:14:48AM +0100, Christoph Hellwig wrote:
> On Fri, Feb 07, 2025 at 09:39:42AM -0800, Darrick J. Wong wrote:
> > > +	/* XXX: this is a little verbose, but let's keep it for now */
> > > +	xfs_info(mp, "using zone %u (%u)",
> > > +		 rtg_rgno(oz->oz_rtg), zi->zi_nr_open_zones);
> > 
> > Should this XXX become a tracepoint?
> > 
> > > +	trace_xfs_zone_activate(oz->oz_rtg);
> 
> The tracepoint is just below, but yes - this obviously was left as a
> canary in the coalmine to check if anyone actually reviews the code :)
> 
> > > +	if (xfs_is_shutdown(mp))
> > > +		goto out_error;
> > > +
> > > +	/*
> > > +	 * If we don't have a cached zone in this write context, see if the
> > > +	 * last extent before the one we are writing points of an active zone.
> > 
> > "...writing points *to the end* of an active zone" ?
> 
> We only really care about the same zone.  Even if that doesn't create a
> contiguous extent, it means the next GC cycle will make it contiguous.
> But even before that the locality is kinda useful at least on HDD.
> 
> There's still grammar issues, though which I've fixed up.
> 
> > 
> > > +	 * If so, just continue writing to it.
> > > +	 */
> > > +	if (!*oz && ioend->io_offset)
> > > +		*oz = xfs_last_used_zone(ioend);
> > 
> > Also, why not return oz instead of passing it out via double pointer?
> 
> I remember going back and forth a few times.  Let me give it a try to
> see how it works out this time.
> 
> > > +	mp->m_zone_info = xfs_alloc_zone_info(mp);
> > > +	if (!mp->m_zone_info)
> > > +		return -ENOMEM;
> > > +
> > > +	xfs_info(mp, "%u zones of %u blocks size (%u max open)",
> > > +		 mp->m_sb.sb_rgcount, mp->m_groups[XG_TYPE_RTG].blocks,
> > > +		 mp->m_max_open_zones);
> > 
> > Tracepoint?
> 
> I think this actually pretty usueful mount time information in the
> kernel log.  But if you mean a trace point on top of the message and
> not instead I can look into it.

Yeah, I like to just set up ftrace for 'xfs_zone*' and see what falls
out of a test run, instead of pulling in printk and then having to
filter out a bunch of other stuff. :)

--D

