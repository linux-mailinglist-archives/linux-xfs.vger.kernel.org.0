Return-Path: <linux-xfs+bounces-9778-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B942E912E3D
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Jun 2024 22:04:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 726132827A4
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Jun 2024 20:04:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00ACE16C87F;
	Fri, 21 Jun 2024 20:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OJ1sMRLZ"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD64416A927;
	Fri, 21 Jun 2024 20:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719000249; cv=none; b=WUk3xw7bJTZWb9IUy5cuTDnJAA9VfyZXUSZACtImzJKo6VKeb+eW9oGEj6FGfFlA/PWdN/EEyusMgX/zwyIRMUNlZ9ABP/BPNcJZH2UO0j0Zr/cakdSQ4OU7thGh0vw6sFqaY6p2OfWeN8RmQvSJOxOQ9LPUj4uRKgsog3BsgvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719000249; c=relaxed/simple;
	bh=g1gIkh1N7dpwladx/+giHa5C+3qDTtIwQQCFFklKWwo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=THH/rYaAAxFbWYiuiebmCBOKaqbuOAl778QH00wucvoWl1MOgBm88fZYs/xi88QwaJ5XJkE4hRKhkweDT/UeBEuIQD0ryY0DWDT6RRSNBm5+k0IB+6ZB8FwP3Nzp/wwyX2czIShs6pJSQmygIxS/TrVRTn/eOKbe33HT/d+O9xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OJ1sMRLZ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27B01C2BBFC;
	Fri, 21 Jun 2024 20:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719000249;
	bh=g1gIkh1N7dpwladx/+giHa5C+3qDTtIwQQCFFklKWwo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OJ1sMRLZ4WzWNLmbaZ3AcgUCaOKrV0yT4+JpzN9hMhj4m1eNv31fGmCGTzG7No0vo
	 ef8aa/lU2ERbrgaIMqv/gNmBsOfLkJ7jlSCaV1FW0r7peC/xGAYRICYEOgnBgatmgo
	 5QIc1Y5PYD+MVbW7Zw8Ag0WoNEVU1lJfcGabPwRJDwRo2JaAbsNTne5O2mSLgNHqYM
	 5Uh3tejy9VUI/o8ifogC1yI2srTWsRGbyX8tD3dR09m7/XzRxwt1xL1zL3F6n3Psz9
	 CO+BnNIo+lx7e6VDcoYO2dpewL/xRawV6lFjo7Oyz+VnshxPZvGVNUptMtjoM+PZX8
	 HiYeRhcPV4UCw==
Date: Fri, 21 Jun 2024 13:04:08 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: John Garry <john.g.garry@oracle.com>
Cc: chandan.babu@oracle.com, dchinner@redhat.com, hch@lst.de,
	viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, catherine.hoang@oracle.com,
	martin.petersen@oracle.com
Subject: Re: [PATCH 01/13] xfs: only allow minlen allocations when near ENOSPC
Message-ID: <20240621200408.GA103014@frogsfrogsfrogs>
References: <20240621100540.2976618-1-john.g.garry@oracle.com>
 <20240621100540.2976618-2-john.g.garry@oracle.com>
 <20240621194225.GR3058325@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240621194225.GR3058325@frogsfrogsfrogs>

On Fri, Jun 21, 2024 at 12:42:25PM -0700, Darrick J. Wong wrote:
> On Fri, Jun 21, 2024 at 10:05:28AM +0000, John Garry wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > When we are near ENOSPC and don't have enough free
> > space for an args->maxlen allocation, xfs_alloc_space_available()
> > will trim args->maxlen to equal the available space. However, this
> > function has only checked that there is enough contiguous free space
> > for an aligned args->minlen allocation to succeed. Hence there is no
> > guarantee that an args->maxlen allocation will succeed, nor that the
> > available space will allow for correct alignment of an args->maxlen
> > allocation.
> > 
> > Further, by trimming args->maxlen arbitrarily, it breaks an
> > assumption made in xfs_alloc_fix_len() that if the caller wants
> > aligned allocation, then args->maxlen will be set to an aligned
> > value. It then skips the tail alignment and so we end up with
> > extents that aren't aligned to extent size hint boundaries as we
> > approach ENOSPC.
> > 
> > To avoid this problem, don't reduce args->maxlen by some random,
> > arbitrary amount. If args->maxlen is too large for the available
> > space, reduce the allocation to a minlen allocation as we know we
> > have contiguous free space available for this to succeed and always
> > be correctly aligned.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > Signed-off-by: John Garry <john.g.garry@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_alloc.c | 19 ++++++++++++++-----
> >  1 file changed, 14 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> > index 6c55a6e88eba..5855a21d4864 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -2409,14 +2409,23 @@ xfs_alloc_space_available(
> >  	if (available < (int)max(args->total, alloc_len))
> >  		return false;
> >  
> > +	if (flags & XFS_ALLOC_FLAG_CHECK)
> > +		return true;
> > +
> >  	/*
> > -	 * Clamp maxlen to the amount of free space available for the actual
> > -	 * extent allocation.
> > +	 * If we can't do a maxlen allocation, then we must reduce the size of
> > +	 * the allocation to match the available free space. We know how big
> > +	 * the largest contiguous free space we can allocate is, so that's our
> > +	 * upper bound. However, we don't exaclty know what alignment/size
> > +	 * constraints have been placed on the allocation, so we can't
> > +	 * arbitrarily select some new max size. Hence make this a minlen
> > +	 * allocation as we know that will definitely succeed and match the
> > +	 * callers alignment constraints.
> >  	 */
> > -	if (available < (int)args->maxlen && !(flags & XFS_ALLOC_FLAG_CHECK)) {
> > -		args->maxlen = available;
> > +	alloc_len = args->maxlen + (args->alignment - 1) + args->minalignslop;
> 
> Didn't we already calculate alloc_len identically under "do we have
> enough contiguous free space for the allocation?"?  AFAICT we haven't
> alter anything in @args since then, right?

Oops, the first computation uses minlen, whereas this one uses maxlen.
Disregard this question, please.

--D

> > +	if (longest < alloc_len) {
> > +		args->maxlen = args->minlen;
> 
> Is it possible to reduce maxlen the largest multiple of the alignment
> that is still less than @longest?
> 
> --D
> 
> >  		ASSERT(args->maxlen > 0);
> > -		ASSERT(args->maxlen >= args->minlen);
> >  	}
> >  
> >  	return true;
> > -- 
> > 2.31.1
> > 
> > 
> 

