Return-Path: <linux-xfs+bounces-8088-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BAE228B9315
	for <lists+linux-xfs@lfdr.de>; Thu,  2 May 2024 03:26:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2E1D31F20FFB
	for <lists+linux-xfs@lfdr.de>; Thu,  2 May 2024 01:26:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBC7512B95;
	Thu,  2 May 2024 01:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="o0BMVTW3"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AEF112B8B
	for <linux-xfs@vger.kernel.org>; Thu,  2 May 2024 01:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714613212; cv=none; b=paxaYPxNF9Z3luxwzyhjVcyFac+/2oHq/3y5r8aGVlrUw3CvgqppXRPGDT23VCdF8PJZP1WLr+qXjgFO6rSn1uec5/53UgX8cx75/j3drFkS3sIU8loPEShTpvh3IeJ/b/yrVAeVoXmqXr89QLFqSG2nUjdcKpWjm6QiZ5wQi/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714613212; c=relaxed/simple;
	bh=aiQLgMnrBrWvk7K6foZtmxAJr384q7kBAbb7yTl4V5s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gJf+CLwIdHSVyUV2Ip43e1QmDB+89ppRMqMeX9GoTzAytopwPn5g5T671HTxD3zMym6jk66OIQRuT2Z+FcnF5/2OlPYigwz+PZpkwMY6XyXveh8pqPoRkhfeky/boRk83eQOJk40VOVGgFHrCWSEf9ltN0Hp/IRp8uCSDJqvuaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=o0BMVTW3; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-6f42e9221bbso574516b3a.2
        for <linux-xfs@vger.kernel.org>; Wed, 01 May 2024 18:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1714613211; x=1715218011; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BoNtHTJ8szqDZXGrqdiequs/rQM0aLZwOdY/YpVYtUQ=;
        b=o0BMVTW3O9/N6bVJ1TKjQiTqcuWG+xPLGKDhdcrjGRSiJobke3aijfF9lEyrBswMLo
         bEXTVuMGMFv+bmv2z57rQNQjRq7YyfMJmnq3Fw1PlmouxXvCS5Xrl4ISJD1vIujqx4en
         5BY6v5Czswsz32zKTP9+YJ2kFnkMHOLxjcUu6uDM9h0oGGRlixEx76GsSuGusd+llGkK
         Klp88BwIYOPVBqT8KzYJ+GOAFHGFIuJKgXd7UurhvW+0LzVIexBntt2T9LRB3izJLKxW
         4oN/3pWUx/TDKzaoSQPNM4UxDAN7EUbHDxDx+OwYwmqRYhOgX+o59tbD8S3RuPm4PuFi
         EvGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714613211; x=1715218011;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BoNtHTJ8szqDZXGrqdiequs/rQM0aLZwOdY/YpVYtUQ=;
        b=BxkkewxyFp4nfemcVKxJJTUQF6/SlqoNyBMPw1NI1L9ifqW6/U9bjZUdOUkMB2+Ny9
         E5OjvhGMUsI6tOmVfzypq5nxf1drDO+3keIHud8Cx9V5jCEVr5KIQBLU1sPijE0gFyq3
         h9+QnMlrSmHrvdxeADRr/n1QJ0e89wXu9SHMVrtmVKVZqSL+6yST8YfSoMvaahfXuBKX
         HHWTXG1LdfEljQxqcaGzlJAL4TKkwwa4z2j2dWjaBQWg8kVA7Fu2iAhhYtv2GDmH3Ep3
         W/IQux8u3r8JOCrafTsxfT9IFwAr5dS9L3lFx342cq9lhs39S1pjiGIo507iZjOz35uQ
         035g==
X-Forwarded-Encrypted: i=1; AJvYcCXyRTiIm65/XhIcCz3QYyIqoE9/jUiGC/V6xgDZC2AzLaKYqRKM3U8HnoFEPOOExdvQ8Gi/qfAw17baJalkNrfCFguKqAB+O3Kf
X-Gm-Message-State: AOJu0Ywlb7hGzHtLTOq/mQjO9I67ngQq1xOITcdNLhISLCKH40dFXsTm
	QGI9rVeitPwgZqS2ht/XKsRI52Gc3P7ZSfe1L6x/Rwe/PngHrndv5bHgTO4cDok=
X-Google-Smtp-Source: AGHT+IHnNHve2YtRJXBin4iPljutTTUfrx/RxhWwRiJVuk82SYT4Ex3LTe2WrKa6Z73pMoij2m2nGw==
X-Received: by 2002:a05:6a00:23d5:b0:6f3:f30a:19b with SMTP id g21-20020a056a0023d500b006f3f30a019bmr4277299pfc.18.1714613210547;
        Wed, 01 May 2024 18:26:50 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id n16-20020a63ee50000000b005f3d54c0a57sm7292pgk.49.2024.05.01.18.26.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 May 2024 18:26:50 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1s2LDj-000Nxl-18;
	Thu, 02 May 2024 11:26:47 +1000
Date: Thu, 2 May 2024 11:26:47 +1000
From: Dave Chinner <david@fromorbit.com>
To: John Garry <john.g.garry@oracle.com>
Cc: djwong@kernel.org, hch@lst.de, viro@zeniv.linux.org.uk,
	brauner@kernel.org, jack@suse.cz, chandan.babu@oracle.com,
	willy@infradead.org, axboe@kernel.dk, martin.petersen@oracle.com,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	tytso@mit.edu, jbongio@google.com, ojaswin@linux.ibm.com,
	ritesh.list@gmail.com, mcgrof@kernel.org, p.raghav@samsung.com,
	linux-xfs@vger.kernel.org, catherine.hoang@oracle.com
Subject: Re: [PATCH v3 15/21] fs: xfs: iomap: Sub-extent zeroing
Message-ID: <ZjLr12LjiSrY4cdh@dread.disaster.area>
References: <20240429174746.2132161-1-john.g.garry@oracle.com>
 <20240429174746.2132161-16-john.g.garry@oracle.com>
 <ZjGbkAuGj0MhXAZ/@dread.disaster.area>
 <0eb8b5b6-1a59-445c-8ac1-1de2a1c0ce4a@oracle.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0eb8b5b6-1a59-445c-8ac1-1de2a1c0ce4a@oracle.com>

On Wed, May 01, 2024 at 12:36:02PM +0100, John Garry wrote:
> On 01/05/2024 02:32, Dave Chinner wrote:
> > On Mon, Apr 29, 2024 at 05:47:40PM +0000, John Garry wrote:
> > > Set iomap->extent_size when sub-extent zeroing is required.
> > > 
> > > We treat a sub-extent write same as an unaligned write, so we can leverage
> > > the existing sub-FSblock unaligned write support, i.e. try a shared lock
> > > with IOMAP_DIO_OVERWRITE_ONLY flag, if this fails then try the exclusive
> > > lock.
> > > 
> > > In xfs_iomap_write_unwritten(), FSB calcs are now based on the extsize.
> > 
> > If forcedalign is set, should we just reject unaligned DIOs?
> 
> Why would we? That's very restrictive. Indeed, we got to the point of adding
> the sub-extent zeroing just for supporting that.
> > > @@ -646,9 +647,9 @@ xfs_file_dio_write_unaligned(
> > >   	ssize_t			ret;
> > >   	/*
> > > -	 * Extending writes need exclusivity because of the sub-block zeroing
> > > -	 * that the DIO code always does for partial tail blocks beyond EOF, so
> > > -	 * don't even bother trying the fast path in this case.
> > > +	 * Extending writes need exclusivity because of the sub-block/extent
> > > +	 * zeroing that the DIO code always does for partial tail blocks
> > > +	 * beyond EOF, so don't even bother trying the fast path in this case.
> > >   	 */
> > >   	if (iocb->ki_pos > isize || iocb->ki_pos + count >= isize) {
> > >   		if (iocb->ki_flags & IOCB_NOWAIT)
> > > @@ -714,11 +715,19 @@ xfs_file_dio_write(
> > >   	struct xfs_inode	*ip = XFS_I(file_inode(iocb->ki_filp));
> > >   	struct xfs_buftarg      *target = xfs_inode_buftarg(ip);
> > >   	size_t			count = iov_iter_count(from);
> > > +	struct xfs_mount	*mp = ip->i_mount;
> > > +	unsigned int		blockmask;
> > >   	/* direct I/O must be aligned to device logical sector size */
> > >   	if ((iocb->ki_pos | count) & target->bt_logical_sectormask)
> > >   		return -EINVAL;
> > > -	if ((iocb->ki_pos | count) & ip->i_mount->m_blockmask)
> > > +
> > > +	if (xfs_inode_has_forcealign(ip) && ip->i_extsize > 1)
> > > +		blockmask = XFS_FSB_TO_B(mp, ip->i_extsize) - 1;
> > > +	else
> > > +		blockmask = mp->m_blockmask;
> > 
> > 	alignmask = XFS_FSB_TO_B(mp, xfs_inode_alignment(ip)) - 1;
> 
> Do you mean xfs_extent_alignment() instead of xfs_inode_alignment()?

Yes, I was.

I probably should have named it xfs_inode_extent_alignment() because
clearly I kept thinking of it as "inode alignment"... :)

-Dave.
-- 
Dave Chinner
david@fromorbit.com

