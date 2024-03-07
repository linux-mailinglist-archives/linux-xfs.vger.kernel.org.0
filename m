Return-Path: <linux-xfs+bounces-4709-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EAF5875A78
	for <lists+linux-xfs@lfdr.de>; Thu,  7 Mar 2024 23:55:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 978ED28546E
	for <lists+linux-xfs@lfdr.de>; Thu,  7 Mar 2024 22:55:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DE7E381B8;
	Thu,  7 Mar 2024 22:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="y0lgFRmN"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6509C3D0A4
	for <linux-xfs@vger.kernel.org>; Thu,  7 Mar 2024 22:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709852135; cv=none; b=sGcVwOC9xb+8fz4iU6kXU6oA38zkUW5SSK5opibc+Q6tGT1XOAwjdyA+lkMfvyCupUSIfcjrzj6Fvgw8Qhnwe/DHkB9cSZ5YOhjYlbjW6Vlot1rIrOJjOTxQgs1Rfl4Qi1rlXiRZH0a8CZo0Np607mjWEG6dyTl4CKpfu780koo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709852135; c=relaxed/simple;
	bh=mgEkYG6JDq+N5X9EAy4and47TeyQVlJo1Bziuom5wxM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qkvcMnYnD7B0HB7v/P2hbrYfysr/iO8zU7Z7DayeBggD5rrZh3uwKwBZPyJQnIrfBDnpedgLVsMOGKpiPZV5WBAeCftLMkjsAcqEH7FU14DD11wxAt2CtfAJWAsONbiBf/+Y1MArUsCFy8VT4XFkkniRjonbz2Q3st3685aCnLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=y0lgFRmN; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-6e09143c7bdso1221208b3a.3
        for <linux-xfs@vger.kernel.org>; Thu, 07 Mar 2024 14:55:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1709852132; x=1710456932; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LVJsO6fx+sT7Z8lY8puxf866746LEHhyhNnsriUumzk=;
        b=y0lgFRmN8S/x2x5qFppJ2YKJjNi67NzWN9a8RX3RUqrW5rKny0WNv5z+i67UyaMeZQ
         V6EhLuNJUvrPKIEDiICurxkF11pLZbacwRa2t7FpHQ/fsKDVe588/69inNV1pBC9LddJ
         VKf8u2DR09Y6DVNeqFc8kK5AvBJB6RNgfBi0t0Dwz/VBACxKh6XMzOxTIEhE236SnqCt
         Onz+Qdup+1mcAEM0NhDxf82XAuYs+hDeucTBORBdmoxMaySWiNh2/QCAyf+Ap+ZgLwn2
         WceL6unC+UmdG2wkRPsjF/MbwoaZ1PO1KRsGbkJJ5P/c5AlKHf1JnszB4QPp5ie85VuA
         kjGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709852132; x=1710456932;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LVJsO6fx+sT7Z8lY8puxf866746LEHhyhNnsriUumzk=;
        b=dEd0+EEdGAGYQKbMrlN1u/0CSgUMJleuz3l18S6PLVEipwzyaAP66NOThPNZasaFsg
         0foS14epqPfeDJfoDeEvL5UGhV9jYxBzoqscy5Bw2KduiFfemf49Yc1fSSYhXZB+GhhH
         fFgx/wGjUY2MCCun/J8BDfoV2mWQf88bxJCunDiyJ9nVZGnsEScyBvZIVl+B9GUxXHcS
         Bar2gKMaQQ3thWtKNIfI3A12ChxWkNX3B33HIHEXx/YYBzK5NojUarafGpQI6L6wgtXj
         x5p40pb/xAsnScYhU1M4D8bPv3dAP+gDTgr42c1FG+kDipzlM7KxLyt4fbP/bcSkv2b+
         bSlw==
X-Forwarded-Encrypted: i=1; AJvYcCWAl87DvupVneetUCK66fl/9EwoRe2gJEd2XNUmFJ/lIay/toCUZpNbb3C8rcdetVz5yqULLBYDZ1IOLuuRmfH9bMH8YELtIRkD
X-Gm-Message-State: AOJu0YzjdteIKHNCyaCsxN3FhVoQT1uFIJuHJr6Q3snMg7rk7EDqueHd
	g1y1Nc5WDFL/x+zPjMHd3dn14vJxNxGvq6redVQsA1IYjXHgC3Iaa1gwPS0L+a8=
X-Google-Smtp-Source: AGHT+IGvAKTIKpdXHilR8JjRJDZQqBcdKvQUhJRqeoc1DZ0G4W6lMxeZ5gViaMxOem0ULRgSkX7SfA==
X-Received: by 2002:a05:6a00:ad1:b0:6e6:276a:8ea4 with SMTP id c17-20020a056a000ad100b006e6276a8ea4mr15203940pfl.33.1709852132449;
        Thu, 07 Mar 2024 14:55:32 -0800 (PST)
Received: from dread.disaster.area (pa49-179-47-118.pa.nsw.optusnet.com.au. [49.179.47.118])
        by smtp.gmail.com with ESMTPSA id z19-20020aa785d3000000b006e583a649b4sm13038175pfn.210.2024.03.07.14.55.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Mar 2024 14:55:31 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1riMe9-00GS6j-0o;
	Fri, 08 Mar 2024 09:55:29 +1100
Date: Fri, 8 Mar 2024 09:55:29 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>,
	Andrey Albershteyn <aalbersh@redhat.com>, fsverity@lists.linux.dev,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	chandan.babu@oracle.com
Subject: Re: [PATCH v5 08/24] fsverity: add per-sb workqueue for post read
 processing
Message-ID: <ZepF4aeI+uskr3zu@dread.disaster.area>
References: <20240304191046.157464-2-aalbersh@redhat.com>
 <20240304191046.157464-10-aalbersh@redhat.com>
 <20240305010805.GF17145@sol.localdomain>
 <20240307215857.GS1927156@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240307215857.GS1927156@frogsfrogsfrogs>

On Thu, Mar 07, 2024 at 01:58:57PM -0800, Darrick J. Wong wrote:
> On Mon, Mar 04, 2024 at 05:08:05PM -0800, Eric Biggers wrote:
> > On Mon, Mar 04, 2024 at 08:10:31PM +0100, Andrey Albershteyn wrote:
> > > For XFS, fsverity's global workqueue is not really suitable due to:
> > > 
> > > 1. High priority workqueues are used within XFS to ensure that data
> > >    IO completion cannot stall processing of journal IO completions.
> > >    Hence using a WQ_HIGHPRI workqueue directly in the user data IO
> > >    path is a potential filesystem livelock/deadlock vector.
> > > 
> > > 2. The fsverity workqueue is global - it creates a cross-filesystem
> > >    contention point.
> > > 
> > > This patch adds per-filesystem, per-cpu workqueue for fsverity
> > > work. This allows iomap to add verification work in the read path on
> > > BIO completion.
> > > 
> > > Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>
> > 
> > Should ext4 and f2fs switch over to this by converting
> > fsverity_enqueue_verify_work() to use it?  I'd prefer not to have to maintain
> > two separate workqueue strategies as part of the fs/verity/ infrastructure.
> 
> (Agreed.)
> 
> > > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > > index 1fbc72c5f112..5863519ffd51 100644
> > > --- a/include/linux/fs.h
> > > +++ b/include/linux/fs.h
> > > @@ -1223,6 +1223,8 @@ struct super_block {
> > >  #endif
> > >  #ifdef CONFIG_FS_VERITY
> > >  	const struct fsverity_operations *s_vop;
> > > +	/* Completion queue for post read verification */
> > > +	struct workqueue_struct *s_read_done_wq;
> > >  #endif
> > 
> > Maybe s_verity_wq?  Or do you anticipate this being used for other purposes too,
> > such as fscrypt?  Note that it's behind CONFIG_FS_VERITY and is allocated by an
> > fsverity_* function, so at least at the moment it doesn't feel very generic.
> 
> Doesn't fscrypt already create its own workqueues?

Yes, but iomap really needs it to be a generic sb workqueue like the
sb->s_dio_done_wq.

i.e. the completion processing in task context is not isolated to
fsverity - it will likely also be needed for fscrypt completion and
decompression on read completion, when they get supported by the
generic iomap IO infrastruture. i.e. Any read IO that needs a task
context for completion side data processing will need this.

The reality is that the major filesytsems are already using either
generic or internal per-fs workqueues for DIO completion and
buffered write completions. Some already use buried workqueues on
read IO completion, too, so moving this to being supported by the
generic IO infrastructure rather than reimplmenting it just a little
bit differently in every filesystem makes a lot of sense.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

