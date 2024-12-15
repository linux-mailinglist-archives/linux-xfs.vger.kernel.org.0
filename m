Return-Path: <linux-xfs+bounces-16913-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C91D09F226A
	for <lists+linux-xfs@lfdr.de>; Sun, 15 Dec 2024 07:21:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E5AA0166133
	for <lists+linux-xfs@lfdr.de>; Sun, 15 Dec 2024 06:21:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D9542F30;
	Sun, 15 Dec 2024 06:21:21 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2161CABF
	for <linux-xfs@vger.kernel.org>; Sun, 15 Dec 2024 06:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734243681; cv=none; b=Sfty/85xv4lw8gidV6VKdOml2wum/QwE0EjLD4G6BFLvvCjQQoDxvhCxSEW2q4jOqUNIaTGLbmdaq7BKZU43pD9f8BWiC90MEur+albQ9/EM2S/b7H4ayqCRk57RutD++S2kP2VDNBNgJU8qKVp7P+mThcmEWJWxgnQH2I1ORBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734243681; c=relaxed/simple;
	bh=hPu3SMmgowJMQjyMM9iij7WtanYaq4Aq4t+3TRGTyQI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eBHmd+H6K1Q/9c1gxwZsS4kldiOAwpjTNQuqIspF1/D2VLYP0JzHEMX4GaoySyfhY/+rIZt7+nVbjXxk8Vkl+e9BS+2qEPDIDbTMABUfSR7tFFjHtPYnDvseq0BoEUhxRUIgRF5M21sY0mtC7qP3zSSkB68HSADF7bfBlwZmiMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6E68668C7B; Sun, 15 Dec 2024 07:21:15 +0100 (CET)
Date: Sun, 15 Dec 2024 07:21:15 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 37/43] xfs: disable rt quotas for zoned file systems
Message-ID: <20241215062115.GF10855@lst.de>
References: <20241211085636.1380516-1-hch@lst.de> <20241211085636.1380516-38-hch@lst.de> <20241213230503.GE6678@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241213230503.GE6678@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Dec 13, 2024 at 03:05:03PM -0800, Darrick J. Wong wrote:
> On Wed, Dec 11, 2024 at 09:55:02AM +0100, Christoph Hellwig wrote:
> > They'll need a little more work.
> 
> I guess we'll have to get back to this... :/

Yes.  I've always been wanting to implement it, but not with the
very highest priority.  The fact that you pulled up the RT quota series
to earlier in your patch stack threw a little monkey wrench here :)


