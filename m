Return-Path: <linux-xfs+bounces-14806-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 30A0C9B55CC
	for <lists+linux-xfs@lfdr.de>; Tue, 29 Oct 2024 23:30:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 684A6B22913
	for <lists+linux-xfs@lfdr.de>; Tue, 29 Oct 2024 22:30:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BA4120ADFF;
	Tue, 29 Oct 2024 22:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="nwFSP/lZ"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C142071F6
	for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2024 22:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730241000; cv=none; b=OLEEpfX0NbrePNrjxEj0qFcfERlBmTHgV4vLiBx4iP+6gBy34I7hCL/gResfZcD1L3wVXrundiSaJUSA8Fla8DcNPP7zOIrPY2sWvbvXXgsyfpDQvqCDFQ0eZDocOOQdwyBDoKpXdYSAjqueg6cvIih1exDMJdH+CHAg9sYXi8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730241000; c=relaxed/simple;
	bh=/raPG8JWFslih/M7A6y3VrwVMOCWAU8s9C2vDWm32+Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O+xxv/eTD8Q4ZMaDzWu28jyqixm3lCRrteTy+QPif8LLofZ7x7A9l7+fLwezARt4cgqwdxtgTHo6q/V43Zy8mjaNgKNKCA2nl0Ix13fyRp0QzWkLy946MEnm4XoIhf4rDWUg+gP6/5TvxJO0lIIVV1krarvTrS8cXmYklkNsz8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=nwFSP/lZ; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7205646f9ebso3752167b3a.0
        for <linux-xfs@vger.kernel.org>; Tue, 29 Oct 2024 15:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1730240996; x=1730845796; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oUVL3SAWt1umC95tyhCPn9FuARdi1+2feQgOINsa25o=;
        b=nwFSP/lZjzbuEKyERoh++ej51NkO8Zr9hGMLsJpZ/eSXrCczk3t/wqtYmn3tY3DqTV
         MR4qyinq1GnUEDLBmmGD1pi6HagvvWKNIiywpwFreqaj3x/Kf7LMaIX41nY6DJcTXL2Y
         3WFqUB1T89n83B2lJqTw/2Gm5ZmMNqeK5ZJ0O9sPNSLbwq7xCW4kdb8X8UfliahTA+oG
         Pxr5lKquACSk9pbFAGfi8T1+WW1ykmWtE4nZH4yYPPlDNsREnpxsvuXyUp/0aV4Fy6cv
         zDGvu5StuZqEHjj0FYoaLiEpsmn07hnXy9/ubYuSit4QSismbkd9ogZ7CKh9NzrYr+1y
         s7/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730240996; x=1730845796;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oUVL3SAWt1umC95tyhCPn9FuARdi1+2feQgOINsa25o=;
        b=FU974TExO0Xr0HF1Jy11+8vGGVkS3My0gEIe1SEJxZ9o9sJCqdukqtexQJAt40Gqks
         8GGwdfsrZCyG8HP2kpsAUdrPHLOMKAVtJtTT//qDg8B5S9FlEBhzd3eg0Utvj6RGOFUZ
         qOOJA4Acc1qZ49M2qXLHzB0Ub80Rlgk/aGf/eDnlF5SkFVWwBAbIXyNn2zbAlzfEV3Xt
         Q5JBWMRa1eTjjiXW9DUmH43LQmsaJhsr8HqHsSW53grRVceRFla9HFaCgt0fVyoEqODj
         /UBjeFBh6E1rgeTzL21hIKrnnp1ibeZfmfWxorZaJOHO6Bl3OfvvhaD5Y+a/6Hrs4gq9
         uRvQ==
X-Forwarded-Encrypted: i=1; AJvYcCUV7HcNRE4yIKsBPnUyEgqpvgQI2brbB6l1/00zbrrTDvLtaS+mPAHYAI3VbfcQyekGFotU8e9JC/0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwFey6X4oM4LsW7wVSzxY3jXE6wNJxO6xjxAPhtovp0/kmo4adR
	RPlB3RaL/4iJA4I2A+3vVLtQ2gq0Zvarr6SUe98jCmKmYu3bs2Co9nbq9C4R1Pc=
X-Google-Smtp-Source: AGHT+IGO9MhIpSqfKeXy5vAvn1zbzDm9cPtiSF9r1+C1go1FuzVvg5kHpeIXGGr9/+Tq/5YIOUAnzw==
X-Received: by 2002:a05:6a00:2d8d:b0:71e:818a:97d9 with SMTP id d2e1a72fcca58-72062f8336amr19056400b3a.5.1730240995936;
        Tue, 29 Oct 2024 15:29:55 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-86-168.pa.vic.optusnet.com.au. [49.186.86.168])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7205794fd8dsm8332244b3a.96.2024.10.29.15.29.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2024 15:29:55 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1t5uik-007Y8D-2k;
	Wed, 30 Oct 2024 09:29:50 +1100
Date: Wed, 30 Oct 2024 09:29:50 +1100
From: Dave Chinner <david@fromorbit.com>
To: Ritesh Harjani <ritesh.list@gmail.com>
Cc: linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
	Jan Kara <jack@suse.cz>, "Darrick J . Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	John Garry <john.g.garry@oracle.com>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 4/6] ext4: Warn if we ever fallback to buffered-io for
 DIO atomic writes
Message-ID: <ZyFh3uCGqB20+2X2@dread.disaster.area>
References: <cover.1729825985.git.ritesh.list@gmail.com>
 <7c4779f1f0c8ead30f660a2cfbdf4d7cc08e405a.1729825985.git.ritesh.list@gmail.com>
 <Zx6+F4Cl1owSDspD@dread.disaster.area>
 <87iktdm3sf.fsf@gmail.com>
 <Zx8ga59h0JgU/YIC@dread.disaster.area>
 <87a5eom6xj.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a5eom6xj.fsf@gmail.com>

On Mon, Oct 28, 2024 at 11:44:00PM +0530, Ritesh Harjani wrote:
> 
> Hi Dave, 
> 
> Dave Chinner <david@fromorbit.com> writes:
> 
> > On Mon, Oct 28, 2024 at 06:39:36AM +0530, Ritesh Harjani wrote:
> >> 
> >> Hi Dave, 
> >> 
> >> Dave Chinner <david@fromorbit.com> writes:
> >> 
> >> > On Fri, Oct 25, 2024 at 09:15:53AM +0530, Ritesh Harjani (IBM) wrote:
> >> >> iomap will not return -ENOTBLK in case of dio atomic writes. But let's
> >> >> also add a WARN_ON_ONCE and return -EIO as a safety net.
> >> >> 
> >> >> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> >> >> ---
> >> >>  fs/ext4/file.c | 10 +++++++++-
> >> >>  1 file changed, 9 insertions(+), 1 deletion(-)
> >> >> 
> >> >> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> >> >> index f9516121a036..af6ebd0ac0d6 100644
> >> >> --- a/fs/ext4/file.c
> >> >> +++ b/fs/ext4/file.c
> >> >> @@ -576,8 +576,16 @@ static ssize_t ext4_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
> >> >>  		iomap_ops = &ext4_iomap_overwrite_ops;
> >> >>  	ret = iomap_dio_rw(iocb, from, iomap_ops, &ext4_dio_write_ops,
> >> >>  			   dio_flags, NULL, 0);
> >> >> -	if (ret == -ENOTBLK)
> >> >> +	if (ret == -ENOTBLK) {
> >> >>  		ret = 0;
> >> >> +		/*
> >> >> +		 * iomap will never return -ENOTBLK if write fails for atomic
> >> >> +		 * write. But let's just add a safety net.
> >> >> +		 */
> >> >> +		if (WARN_ON_ONCE(iocb->ki_flags & IOCB_ATOMIC))
> >> >> +			ret = -EIO;
> >> >> +	}
> >> >
> >> > Why can't the iomap code return EIO in this case for IOCB_ATOMIC?
> >> > That way we don't have to put this logic into every filesystem.
> >> 
> >> This was origially intended as a safety net hence the WARN_ON_ONCE.
> >> Later Darrick pointed out that we still might have an unconverted
> >> condition in iomap which can return ENOTBLK for DIO atomic writes (page
> >> cache invalidation).
> >
> > Yes. That's my point - iomap knows that it's an atomic write, it
> > knows that invalidation failed, and it knows that there is no such
> > thing as buffered atomic writes. So there is no possible fallback
> > here, and it should be returning EIO in the page cache invalidation
> > failure case and not ENOTBLK.
> >
> 
> So the iomap DIO can return following as return values which can make
> some filesystems fallback to buffered-io (if they implement fallback
> logic) - 
> (1) -ENOTBLK -> this is only returned for pagecache invalidation failure.
> (2) 0 or partial write size -> This can never happen for atomic writes
> (since we are only allowing for single fsblock as of now).

Even when we allow multi-FSB atomic writes, the definition of
atomic write is still "all or nothing". There is no scope for "short
writes" when IOCB_ATOMIC is set - any condition that means we can't
write the entire IO as a single bio, we need to abort and return
EINVAL.

Hence -ENOTBLK should never be returned by iomap for atomic DIO
writes - we need to say -EINVAL if the write could not be issued
atomically for whatever reason it may be so the application knows
that atomic IO submission was not possible for that IO.

> Now looking at XFS, it never fallsback to buffered-io ever except just 2
> cases - 
> 1. When pagecache invalidation fails in iomap (can never happen for
> atomic writes)

Why can't this happen for atomic DIO writes?  It's the same failure
cases as for normal DIO writes, isn't it? (i.e. race with mmap
writes)

My point is that if it's an atomic write, this failure should get
turned into -EINVAL by the iomap code. We do not want a fallback to
buffered IO when this situation happens for atomic IO.

> 2. On unaligned DIO writes to reflinked CoW (not possible for atomic writes)

This path doesn't ever go through iomap - XFS catches that case
before it calls into iomap, so it's not relevant to how iomap
behaves w.r.t atomic IO.

> So it anyways should never happen that XFS ever fallback to buffered-io
> for DIO atomic writes. Even today it does not fallback to buffered-io
> for non-atomic short DIO writes.
> 
> >> You pointed it right that it should be fixed in iomap. However do you
> >> think filesystems can still keep this as safety net (maybe no need of
> >> WARN_ON_ONCE).
> >
> > I don't see any point in adding "impossible to hit" checks into
> > filesystems just in case some core infrastructure has a bug
> > introduced....
> 
> Yes, that is true for XFS. EXT4 however can return -ENOTBLK for short
> writes, though it should not happen for current atomic write case where
> we are only allowing for 1 fsblock. 

Yes, but the -ENOTBLK error returned from ext4_iomap_end() if
nothing was written does not get returned to ext4 from
__iomap_dio_rw(). It is consumed by the iomap code:

	/* magic error code to fall back to buffered I/O */
        if (ret == -ENOTBLK) {
                wait_for_completion = true;
                ret = 0;
	}

This means that all the IO that was issued gets completed before
returning to the caller and that's how the short write comes about.

-ENOTBLK is *not returned to the caller* on a short write -
iomap_dio_rw will return 0 (success).  The caller then has to look
at the iov_iter state to determine if the write was fully completed.
This is exactly what the ext4 code currently does for all DIO
writes, not just those that return -ENOTBLK.

> I would still like to go with a WARN_ON_ONCE where we are calling ext4
> buffered-io handling for DIO fallback writes. This is to catch any bugs
> even in future when we move to multi-fsblock case (until we have atomic
> write support for buffered-io).

Your choice, but please realise that it is not going to catch short
atomic writes at all.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

