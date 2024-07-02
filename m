Return-Path: <linux-xfs+bounces-10188-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E3C4291EE5F
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Jul 2024 07:36:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 582D2B20A12
	for <lists+linux-xfs@lfdr.de>; Tue,  2 Jul 2024 05:36:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BED4B49621;
	Tue,  2 Jul 2024 05:36:32 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B00735280
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719898592; cv=none; b=FjjQlcYc26HX+XCvNa1vaVoJZu0eSJ1JBRTJjoKSdEDsudzRIKsImZJ/ekbWQH65yp8yU6swczYYirBDM7+mz7khm09bjeQyETviKZ1VSG+geQJv//JutgnZvCBlmBzqITr7KE/7pk7DocEoK+kb1TAYsPbnT94/PzuO0902x3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719898592; c=relaxed/simple;
	bh=VcKDJ0ZViOfvXSo+1eMbqlhEmS7CUcFPj+6n+0ddomQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hohpBzSoJZAxiwirrTuknX6AZa4qvFyv8Nzh96vzrZTqAdrM/9u37GxrDSFqqrtTKMntoeVgPSnCSUUC0mXUQUnOgztoIuA0diDvN7QsL4tC9gkBYXCpGfMrtUyAdXeo4koTCceSAJW+xTKI34NGcpiiz0C8CGec3RJOUdbQkO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 953A068B05; Tue,  2 Jul 2024 07:36:27 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:36:27 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 7/7] xfs_scrub: tune fstrim minlen parameter based on
 free space histograms
Message-ID: <20240702053627.GN22804@lst.de>
References: <171988118569.2007921.18066484659815583228.stgit@frogsfrogsfrogs> <171988118687.2007921.1260012940783338117.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988118687.2007921.1260012940783338117.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jul 01, 2024 at 06:04:41PM -0700, Darrick J. Wong wrote:
> Add a new -o fstrim_pct= option to xfs_scrub just in case there are
> users out there who want a different percentage.  For example, accepting
> a 95% trim would net us a speed increase of nearly two orders of
> magnitude, ignoring system call overhead.  Setting it to 100% will trim
> everything, just like fstrim(8).

It might also make sense to default the parameter to the
discard_granularity reported in sysfs.  While a lot of devices don't
report a useful value there, it avoids pointless work for those that
do.

Otherwise this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


