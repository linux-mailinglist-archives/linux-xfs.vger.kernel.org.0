Return-Path: <linux-xfs+bounces-13111-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 82926983A68
	for <lists+linux-xfs@lfdr.de>; Tue, 24 Sep 2024 01:21:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3A9DF1C2162E
	for <lists+linux-xfs@lfdr.de>; Mon, 23 Sep 2024 22:44:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AAED84E14;
	Mon, 23 Sep 2024 22:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="GnappkJ1"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588222907
	for <linux-xfs@vger.kernel.org>; Mon, 23 Sep 2024 22:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727131439; cv=none; b=LrJrNuHpLyXvcRJAgI9/GfwJzTORK0gr4OnvShnqdBW6iN1/MfFd99pgQEKOCLVDGgjrzGhAcEKF2IVQeXbD62Raiu3DqxnD3JbcDnIuvZNejmrWh1NeXFZ8MpmtYW0zZhxKk62k157d5sK5RVeqetk4V+zlSvy0uRnc5SGrpOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727131439; c=relaxed/simple;
	bh=cGaj8EG1PpbZNqB6qGvjD+ZVV7z0niQGXM8mQA5Pqo4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XvqRJfOsbsbc06kvv4Rf/OfQkMrQedrGbAEn3BCAMOx+VlNSCI8dY0FGres2+hlx/UM+LzTFgfmzWu5sk9QCLrTE2SDbUZuc09JsrGL0sPys6bhgKVKsP4w3i8mBvy02BhuX6fBeetykV+uFSbFDeAd/rNjZ4PGQGStVaPxrrSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=GnappkJ1; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-718e2855479so3713019b3a.1
        for <linux-xfs@vger.kernel.org>; Mon, 23 Sep 2024 15:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1727131436; x=1727736236; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fDmCoiTk9KAvbYfey+3zzo1/LmdJ9Czlmjqevs576Ns=;
        b=GnappkJ1EDvgRcs7LsKWxfetSP+JDaszWUlXWr9MgD772EkAnd2XE8sSrivRi4OvUJ
         2JGVaj2pBYVVX6eXJp83L72wyOQXyi+Y6ZqCV0qQ4Ut1LauiEwb1uVnkk5gOiUCrVDch
         r5Wigy+wDar5fI0GvdMB+N/2nEvcFsqPr8E7DEsKo0r3jZwXsXaZgcugrxw7EkEmM9oC
         jEiDRhptajOywGSz03k2aJPghZ8Su2o03Swxe7BC2y6Q+8Fy945a8GBo3D+GfIjGndYl
         6Q0tJfRFyBxbAXxHLqUIMFA/TJQUu5KLBUNIhD8mfNriY75IOTWZ14aO6dyJhlCgw6aa
         i2Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727131436; x=1727736236;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fDmCoiTk9KAvbYfey+3zzo1/LmdJ9Czlmjqevs576Ns=;
        b=B645jW9qTccW/1zEa2KLyGdT39n5BfoXJfNv1kP+x4QH+AtxHGc8HLT35o6lgQljes
         8pFWz/Rsvn/c/Pp1l8KhkGC/9LpEjaIczjrTrmRy6Hc0Y3P+6sOJ2D7Iew4cL9Ey8QEA
         mNlzV5G4arHjXO8kl9zzeW1CoOhJpAZhi3LEC4gV/qIRFaODL7G+kbHrVwBruXOOi2v4
         NkSGK7aLvcA/S9KuIiUlNfGTPAgzie3jTITnUU1FpIsBKw/EIwWbAA9ny1TAhxY6lnAM
         GPIzmDz88cS+Ai4KD6Bx3kKvXKwJFRkM99eARwOKRTuSVYfcXfKQJ/V1+Xvp7yHkJQgw
         1XYg==
X-Forwarded-Encrypted: i=1; AJvYcCVebKxvrZqX8mNdZElqM+dhFh/K28v+Ur9msRKF/yn7CfAhadKq7ZaFzmEhQd+KaJ63j3Oqx79TJYw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzshTHjti2ei8L+VIa3nGxP58rp7WEA3krniIMYzvabq7TJaMNe
	p1VMtfe3FaJel+emoKaoWuy6pC+M386mZdkIFH/X7YkvhpX2UyulvYNoFhNZ4xg=
X-Google-Smtp-Source: AGHT+IFJEyQ8w6L3S7EuKwSf8rE8YBanqXR04+qAr3XkIa+ydZE3RyTa8BB5jpHQcOVKM1vBHxmELg==
X-Received: by 2002:a05:6a20:c6cd:b0:1cf:215f:1055 with SMTP id adf61e73a8af0-1d30cb6f3cemr14045914637.48.1727131436610;
        Mon, 23 Sep 2024 15:43:56 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-78-197.pa.nsw.optusnet.com.au. [49.179.78.197])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71afc8341bdsm116585b3a.33.2024.09.23.15.43.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Sep 2024 15:43:56 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1ssrmb-009AkC-29;
	Tue, 24 Sep 2024 08:43:53 +1000
Date: Tue, 24 Sep 2024 08:43:53 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>,
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 02/10] iomap: remove
 iomap_file_buffered_write_punch_delalloc
Message-ID: <ZvHvKWGJ0dNNOP5h@dread.disaster.area>
References: <20240923152904.1747117-1-hch@lst.de>
 <20240923152904.1747117-3-hch@lst.de>
 <20240923161825.GE21877@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240923161825.GE21877@frogsfrogsfrogs>

On Mon, Sep 23, 2024 at 09:18:25AM -0700, Darrick J. Wong wrote:
> On Mon, Sep 23, 2024 at 05:28:16PM +0200, Christoph Hellwig wrote:
> > Currently iomap_file_buffered_write_punch_delalloc can be called from
> > XFS either with the invalidate lock held or not.  To fix this while
> > keeping the locking in the file system and not the iomap library
> > code we'll need to life the locking up into the file system.
> > 
> > To prepare for that, open code iomap_file_buffered_write_punch_delalloc
> > in the only caller, and instead export iomap_write_delalloc_release.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  .../filesystems/iomap/operations.rst          |  2 +-
> >  fs/iomap/buffered-io.c                        | 85 ++++++-------------
> >  fs/xfs/xfs_iomap.c                            | 16 +++-
> >  include/linux/iomap.h                         |  6 +-
> >  4 files changed, 46 insertions(+), 63 deletions(-)
> > 
> > diff --git a/Documentation/filesystems/iomap/operations.rst b/Documentation/filesystems/iomap/operations.rst
> > index 8e6c721d233010..b93115ab8748ae 100644
> > --- a/Documentation/filesystems/iomap/operations.rst
> > +++ b/Documentation/filesystems/iomap/operations.rst
> > @@ -208,7 +208,7 @@ The filesystem must arrange to `cancel
> >  such `reservations
> >  <https://lore.kernel.org/linux-xfs/20220817093627.GZ3600936@dread.disaster.area/>`_
> >  because writeback will not consume the reservation.
> > -The ``iomap_file_buffered_write_punch_delalloc`` can be called from a
> > +The ``iomap_write_delalloc_release`` can be called from a
> >  ``->iomap_end`` function to find all the clean areas of the folios
> >  caching a fresh (``IOMAP_F_NEW``) delalloc mapping.
> >  It takes the ``invalidate_lock``.
> > diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> > index 884891ac7a226c..237aeb883166df 100644
> > --- a/fs/iomap/buffered-io.c
> > +++ b/fs/iomap/buffered-io.c
> > @@ -1149,6 +1149,32 @@ static void iomap_write_delalloc_scan(struct inode *inode,
> >   * have dirty data still pending in the page cache - those are going to be
> >   * written and so must still retain the delalloc backing for writeback.
> >   *
> > + * When a short write occurs, the filesystem may need to remove reserved space
> > + * that was allocated in ->iomap_begin from it's ->iomap_end method. For
> 
> "When a short write occurs, the filesystem may need to remove space
> reservations created in ->iomap_begin.
> 
> > + * filesystems that use delayed allocation, we need to punch out delalloc
> > + * extents from the range that are not dirty in the page cache. As the write can
> > + * race with page faults, there can be dirty pages over the delalloc extent
> > + * outside the range of a short write but still within the delalloc extent
> > + * allocated for this iomap.
> > + *
> > + * The punch() callback *must* only punch delalloc extents in the range passed
> > + * to it. It must skip over all other types of extents in the range and leave
> > + * them completely unchanged. It must do this punch atomically with respect to
> > + * other extent modifications.
> 
> Can a failing buffered write race with a write fault to the same file
> range?

Yes.

> write() thread:			page_mkwrite thread:
> ---------------			--------------------
> take i_rwsem
> ->iomap_begin
> create da reservation
> lock folio
> fail to write
> unlock folio
> 				take invalidation lock
> 				lock folio
> 				->iomap_begin
> 				sees da reservation
> 				mark folio dirty
> 				unlock folio
> 				drop invalidation lock
> ->iomap_end
> take invalidation lock
> iomap_write_delalloc_release
> drop invalidation lock
> 
> Can we end up in this situation, where the write fault thinks it has a
> dirty page backed by a delalloc reservation, yet the delalloc
> reservation gets removed by the delalloc punch logic? 

No.

> I think the
> answer to my question is that this sequence is impossible because the
> write fault dirties the folio so the iomap_write_delalloc_release does
> nothing, correct?

Yes.

The above situation is the race condition that the delalloc punching
code is taking into account when it checks for dirty data over the
range being punched. As the comment above
iomap_write_delalloc_release() says:

/*
 * Punch out all the delalloc blocks in the range given except for those that
 * have dirty data still pending in the page cache - those are going to be
 * written and so must still retain the delalloc backing for writeback.
 *
....

-Dave.
-- 
Dave Chinner
david@fromorbit.com

