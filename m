Return-Path: <linux-xfs+bounces-11337-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB7A8949CC7
	for <lists+linux-xfs@lfdr.de>; Wed,  7 Aug 2024 02:26:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 607ED28634A
	for <lists+linux-xfs@lfdr.de>; Wed,  7 Aug 2024 00:26:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AF0B1DDEB;
	Wed,  7 Aug 2024 00:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="l7XpvUHo"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9922F3E
	for <linux-xfs@vger.kernel.org>; Wed,  7 Aug 2024 00:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722990405; cv=none; b=jpqh4LO83Zc1ptqX8WclLyYbwwatrGOT33nUhoyiX8qpb/F67X4EtR/X+n5ze3iJyqTEYJJIwQUAZOAPDyudPyGMhNpArSAfJurzN1n4XaDK9FytwaaQybymLTI7WB89O2YANie9YB0Es5TZGg1uFocm4OidNZI8cX+u5INYZUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722990405; c=relaxed/simple;
	bh=NB28XXPt6f6vAkrX1gx8U+5oCdbpfCq3hFiJuurRBHU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ud0YxR5D4kBGbK3aUD1/mC2LwUou0q8CiKucsLOvS0N9tUPotFVzxjQ7oV/fXjbGqtZ2FAeBLoTjedpb44Bp18KLDQ50OkdPptXsjSNSj+OMvlx539TiOeZ9a4RjZ2nXzMDwJhVipcaBJLAY24yCc/D3swGw+dg+eVwcv10lYf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=l7XpvUHo; arc=none smtp.client-ip=209.85.160.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-260f057aa9bso770105fac.2
        for <linux-xfs@vger.kernel.org>; Tue, 06 Aug 2024 17:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1722990401; x=1723595201; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ia2b2riLaw9KHmD+vv//YlOKCUSXJz+nA2ks+FBP5Bc=;
        b=l7XpvUHoHF+tWW+F+RflwMcsYRzQifRMGsaZXpifDfE0SJj2L105kRFLyEfH/lYy2a
         +IEpQZs2u0fAnwZ/j6RGnPxklZERB3vCgV5ouggZ84tgOwcHCmu4gH3Gp0imN1mF6IK9
         h4fYx5ukmm/pcm6t1Rf0q+3qraTVMGosm3LXbSTaF0URrjgNmPE/0AUEcB35LNqK3qeu
         oAtuswrs9wil24d4WUCvRtDNdSzEAPjJevAQjY3hUw8DTkbcvyNnfu0dHQdO6aI52iNQ
         jONvWx2WiIPZiviN/3JUQ8IOW+/rWm8zalyyFuaWq31N5vWK+JzQV5kHC8TD0T3VWZcq
         MAyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722990401; x=1723595201;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ia2b2riLaw9KHmD+vv//YlOKCUSXJz+nA2ks+FBP5Bc=;
        b=XMGQIyKL2wD6NlMnWHicVRqLcGlLgPABEJ6MrYEYtl/0x+1HTCq+OzkXlrvLKl4wxI
         nf0MRLi/5Zeq05gtdYcZ37QjSpTfDZKauOODplQuhHpJBTbS1Lm1nwQ7vZblhVxJBBxq
         1W6n/okKJL3i0PHTPGvyKrwgJ5JtlElqtiPEBl1aWaC23IaGooZQL7ydHqO7C1pDK2xR
         nd8OzhOSNSTh3l9c7ac9WiU71uuHtSC/UVwE5hagKX/vF1Kiz0kMrL6nJ8vezkd2ivml
         9T16ddBvydqBB3UEezN/jLzBPYSY3s3qEGQJg5jzAUc2PjZAY8IVvebe7Z5CSMt7XY7R
         l6hA==
X-Forwarded-Encrypted: i=1; AJvYcCW6JmC4LUHw/wlXOb13gBD/eWfDNI5IwMHrstLw75lumLS5Moqtiet1N4ev5DdelpBXGf/6Oor1FCJpCWryn7mgOUfx64ejWuT+
X-Gm-Message-State: AOJu0Ywcf/hv1fgDJ1/eMQ1IixuUt30VCHQstWPSsBYVNWQuViYahLFJ
	wFpl5rypzXaUrU7gujQxLU3xFAhgvUSOF5YZ4/gvWYBbSR+G4xGWxUNleMu85U4=
X-Google-Smtp-Source: AGHT+IGV6WNs4YYIr7yFxSPfcTvPPZ8LQkUPz4VtZAj9s6avntQdJy9VCYliAnmLBUVc1humn+nk6A==
X-Received: by 2002:a05:6870:519:b0:261:6c0:8a2a with SMTP id 586e51a60fabf-26891d4ba75mr20502868fac.20.1722990401568;
        Tue, 06 Aug 2024 17:26:41 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7106ece0911sm7466093b3a.132.2024.08.06.17.26.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Aug 2024 17:26:41 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sbUVi-007xHk-12;
	Wed, 07 Aug 2024 10:26:38 +1000
Date: Wed, 7 Aug 2024 10:26:38 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>, chandan.babu@oracle.com,
	dchinner@redhat.com, hch@lst.de, viro@zeniv.linux.org.uk,
	brauner@kernel.org, jack@suse.cz, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	catherine.hoang@oracle.com, martin.petersen@oracle.com
Subject: Re: [PATCH v3 01/14] xfs: only allow minlen allocations when near
 ENOSPC
Message-ID: <ZrK/Pq0KJKj0sLO9@dread.disaster.area>
References: <20240801163057.3981192-1-john.g.garry@oracle.com>
 <20240801163057.3981192-2-john.g.garry@oracle.com>
 <20240806185138.GF623936@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240806185138.GF623936@frogsfrogsfrogs>

On Tue, Aug 06, 2024 at 11:51:38AM -0700, Darrick J. Wong wrote:
> On Thu, Aug 01, 2024 at 04:30:44PM +0000, John Garry wrote:
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
> > index 59326f84f6a5..d559d992c6ef 100644
> > --- a/fs/xfs/libxfs/xfs_alloc.c
> > +++ b/fs/xfs/libxfs/xfs_alloc.c
> > @@ -2524,14 +2524,23 @@ xfs_alloc_space_available(
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
> > +	if (longest < alloc_len) {
> > +		args->maxlen = args->minlen;
> 
> Same question as the June 21st posting:
> 
> Is it possible to reduce maxlen the largest multiple of the alignment
> that is still less than @longest?

Perhaps.

The comment does say "we don't exaclty know what alignment/size
constraints have been placed on the allocation, so we can't
arbitrarily select some new max size."

Given this unknown I simply punted the issue and went straight to
selecting a size the caller has guaranteed will be valid for their
constraints.

-Dave.

-- 
Dave Chinner
david@fromorbit.com

