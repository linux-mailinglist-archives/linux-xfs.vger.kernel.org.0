Return-Path: <linux-xfs+bounces-7806-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 546618B5FE9
	for <lists+linux-xfs@lfdr.de>; Mon, 29 Apr 2024 19:17:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0FB2228319C
	for <lists+linux-xfs@lfdr.de>; Mon, 29 Apr 2024 17:17:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D38485C41;
	Mon, 29 Apr 2024 17:17:37 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC88F2AE93
	for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 17:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714411057; cv=none; b=Uq3eA8B6Z4ufd97dw4RwArZEqOlvelbDoQmq87mbMUw6WWVw8HhDTbECbtaXWHL9jbJKrwtoAHzkFFAN4ICuLMq/5n8GQs8DuygwT/1AyCISrhYqTUVN3rm22w7mnMrFSGGX0PQLDd/80YRmYJ7i2at5L53vGgbsapAbKSoCA9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714411057; c=relaxed/simple;
	bh=xQ06eapT3golMFKpqGUevlwSwafBQTG3b2kQasxGC1A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EAGGqIQj9YMDq/J0EQtiUfR76WI12rGNYcn1elt2VwCSz8J8l6G6JslI/HxqVlJy1N4zP4dzhHq71JLDQmZdF7XCtFlwAl2PZilcYuAgjpfrj+fwyaZOrAl/FR7eXlqRHPEjVax0W//WiJnqqPMn/boLZY8ejdu8IrcOLXwcy64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id D1B5F227A87; Mon, 29 Apr 2024 19:17:32 +0200 (CEST)
Date: Mon, 29 Apr 2024 19:17:32 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/8] xfs: remove a racy if_bytes check in
 xfs_reflink_end_cow_extent
Message-ID: <20240429171732.GG31337@lst.de>
References: <20240429044917.1504566-1-hch@lst.de> <20240429044917.1504566-3-hch@lst.de> <20240429152743.GW360919@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240429152743.GW360919@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Apr 29, 2024 at 08:27:43AM -0700, Darrick J. Wong wrote:
> On Mon, Apr 29, 2024 at 06:49:11AM +0200, Christoph Hellwig wrote:
> > Accessing if_bytes without the ilock is racy.  Remove the initial
> > if_bytes == 0 check in xfs_reflink_end_cow_extent and let
> > ext_iext_lookup_extent fail for this case after we've taken the ilock.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> I wonder if this has any practical (mal)effects on the system?

No, just found by code audit.  I though I did hit it but that was another
bug, but in the process I did a somewhat paranoid audit.

