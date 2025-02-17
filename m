Return-Path: <linux-xfs+bounces-19627-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A85CAA37E4B
	for <lists+linux-xfs@lfdr.de>; Mon, 17 Feb 2025 10:20:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7BAFC7A44FE
	for <lists+linux-xfs@lfdr.de>; Mon, 17 Feb 2025 09:19:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C172B201010;
	Mon, 17 Feb 2025 09:20:25 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 933051A5B86
	for <linux-xfs@vger.kernel.org>; Mon, 17 Feb 2025 09:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739784025; cv=none; b=OyAJnBvcUHIFKxA2iEIGYJqmxjLpmywV4eBFUE8wsuTXgx2K3vN/z0VvnqK9PuPSP9ei5KAKz9lDgzMNhdLxnm/e8XW6jA72OjHZ4rQxQArVvZFrgKSwkeyuEJr2BgPC8zoU5P4sqhfHVyYcVC59bmZuOPRvbtM/4ONFbFOZIFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739784025; c=relaxed/simple;
	bh=T0nIfq4mkfiYmtI39m3rAbHfIeWxsboTaDytU5+JJ1w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fsVs8TQQYrTa9CDUjNQfw1Old9mjvJ2GkT21kV2Wfd6cRmDB9YZpzH2vYO5wgwApHErfNAKgy1toYv9gIrFDZES1r0GUsIKIVqFucXJfGYAhacPQmisq0FV+K4912nbVEoLNDow6DUvLJBoq/qKV+7Wu8VSz3ncSb1+N2Zl53y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5D64268BEB; Mon, 17 Feb 2025 10:20:19 +0100 (CET)
Date: Mon, 17 Feb 2025 10:20:19 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 22/43] xfs: add the zoned space allocator
Message-ID: <20250217092019.GB29468@lst.de>
References: <20250206064511.2323878-1-hch@lst.de> <20250206064511.2323878-23-hch@lst.de> <20250207173942.GZ21808@frogsfrogsfrogs> <20250213051448.GC17582@lst.de> <20250213083540.GA26831@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250213083540.GA26831@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Feb 13, 2025 at 09:35:40AM +0100, Christoph Hellwig wrote:
> On Thu, Feb 13, 2025 at 06:14:48AM +0100, Christoph Hellwig wrote:
> > > > +	if (!*oz && ioend->io_offset)
> > > > +		*oz = xfs_last_used_zone(ioend);
> > > 
> > > Also, why not return oz instead of passing it out via double pointer?
> > 
> > I remember going back and forth a few times.  Let me give it a try to
> > see how it works out this time.
> 
> Looking into this, the callers treat the open_zone structure as a
> context, an passing in the address makes this much nicer.  If you don't
> like all the double pointer dereference operators we could add a new
> context structure that just has a pointer to the open zone as syntactic
> sugar.  And writing this down I think I like the idea, that makes it much
> more clear what is done here, even if it generates the same code.

That ended up being more messy than I though, so I'll stil to the
in/out pointer for now.


