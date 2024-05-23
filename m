Return-Path: <linux-xfs+bounces-8652-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E4E0B8CCA4F
	for <lists+linux-xfs@lfdr.de>; Thu, 23 May 2024 03:14:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7F9291F2260A
	for <lists+linux-xfs@lfdr.de>; Thu, 23 May 2024 01:14:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BE563D69;
	Thu, 23 May 2024 01:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="AGc+tg3U"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C83D1878
	for <linux-xfs@vger.kernel.org>; Thu, 23 May 2024 01:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716426890; cv=none; b=RroBm31OzJs7E4rAwlZK70Y3H4HUWLpFpababysK74vaugeDi99ohN3ZYGf3/dlyg/xJbPikRT9A79j2mxrZeyrJe2hcKLsFGNJ6TuQOJG9d4zzrxC1hm/6oRka5EkHEdRC+QsRRyz5ENDvwl9P1y7tOdquLZqOf4Wy2GnSWMiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716426890; c=relaxed/simple;
	bh=F6aTYxhT26oFwWZ67Ld502s2Po3+Xcgbu+9VvbthueI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m94yH7+87/E1BW0amzRR4c80fHJGsLEQyV0DmzZcxczGQu2MbcndKh8GqZWquY5HjPEQfrTenbJ6k3RyxmcQ8BAuMRct5pAq0yjHU2gRqd4pA7APOROZUtuHwjZalI9DAwpcTMjNk5Qr+GPp+DLe/ZP/yrvyKe+8tgmmk4T+pTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=AGc+tg3U; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-602801ea164so1544941a12.0
        for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 18:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1716426888; x=1717031688; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ggg+vU4NzAtpKME671SbzqiVssDUIpzqRXRtZ78AP3g=;
        b=AGc+tg3UybDOW3aXsoS6q+WCEN4SAEaK82cy4MdraW193bOI8rCfEdGhcIUHhKVMkj
         UnMfbQMetndoJgNnacpamn53zETSm6/ADa6Z15VSLjLx0IZFh/yQE/92fdNYUN7GbRLN
         qj431krkIukCq7krtanCX6aysNuGJJ7IbktPhaDWn4VFhVFdQkzAX4XgcO4LxgY6s1OS
         m9lVQLcg5R2of4AGoRU0iss9GFD6kGlTxb/ug7plz0nMKyokTwCwoeMdqGpfpOP8G+4f
         KAA0xFIKV/t3dFAP0ThDbXnuYwnYhu/2f3ds3bd+JhezYRLXXK+FYp+gFvSNHug/kLMP
         VcLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716426888; x=1717031688;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ggg+vU4NzAtpKME671SbzqiVssDUIpzqRXRtZ78AP3g=;
        b=TTxiEd7uEKDKXx4D1jom+TzmlDAwfFClaz8dwKe6cQ760AdPjTwp9pw3zkQxLTZWHj
         vnVqIH6Lfh/u8d7TGD4U7gTQkX9S6zGr37koVX8f51+OlnRjNftUlXxQavqJPKhkrqf4
         bH1qer8GEtNhuHe08lCZtae+wKGJ7l4X21RVm0OEByI7YnyhijApuNIW+402VJ9DEf4M
         Mur+kW8t/Yb5p1MPYZoaNq5xK4RJXzTGbja92pI7Eh2UjLqHiueBrIlG8Zt17kOa245Z
         dVlIc8NBAmPtGz2SEaZVsiNIfxcFeKQK9Pd3gVF9o8shgrK9poD+BYNhOgkErxWpZNWv
         CRLQ==
X-Forwarded-Encrypted: i=1; AJvYcCVrwtCAC6lGCc5UDdx3bJRj7ebkXUQm57QumapRe7Z+dzHmtTV5ojxnUAnobBpgc7F5G08ZCPp2sma6q7Nak4lV8vbo0GyXqa8M
X-Gm-Message-State: AOJu0YxSNBuQ3EXxM2JNnaQLK1mqinaQ3OsWOOvEzP2DHOSiLww5O2fH
	jc8S8U0jDpIkuNvW6kqSAZ1UkAEItpMyxz/xvchAAHcKrzNujvAal/TQjzu/Zko=
X-Google-Smtp-Source: AGHT+IGrhJ7h989jjAjSMtYNfzU+Yi3+mZLiquC92tnMfDp+of2ZtyY0LfEoupYObDtgvUJLtg9k7A==
X-Received: by 2002:a17:90a:d706:b0:2ae:b8df:89e7 with SMTP id 98e67ed59e1d1-2bd9f5a2611mr3687386a91.38.1716426888226;
        Wed, 22 May 2024 18:14:48 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-32-121.pa.nsw.optusnet.com.au. [49.179.32.121])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2bdd9f0adfdsm413976a91.34.2024.05.22.18.14.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 May 2024 18:14:47 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1s9x2a-0077HZ-2j;
	Thu, 23 May 2024 11:14:44 +1000
Date: Thu, 23 May 2024 11:14:44 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Zhang Yi <yi.zhang@huaweicloud.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, hch@infradead.org, brauner@kernel.org,
	chandanbabu@kernel.org, jack@suse.cz, yi.zhang@huawei.com,
	chengzhihao1@huawei.com, yukuai3@huawei.com
Subject: Re: [PATCH v3 3/3] xfs: correct the zeroing truncate range
Message-ID: <Zk6YhF/DsbOy66EZ@dread.disaster.area>
References: <20240517111355.233085-1-yi.zhang@huaweicloud.com>
 <20240517111355.233085-4-yi.zhang@huaweicloud.com>
 <ZkwJJuFCV+WQLl40@dread.disaster.area>
 <20240522030020.GU25518@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240522030020.GU25518@frogsfrogsfrogs>

On Tue, May 21, 2024 at 08:00:20PM -0700, Darrick J. Wong wrote:
> On Tue, May 21, 2024 at 12:38:30PM +1000, Dave Chinner wrote:
> > [RFC] iomap: zeroing needs to be pagecache aware
> > 
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Unwritten extents can have page cache data over the range being
> > zeroed so we can't just skip them entirely. Fix this by checking for
> > an existing dirty folio over the unwritten range we are zeroing
> > and only performing zeroing if the folio is already dirty.
> > 
> > XXX: how do we detect a iomap containing a cow mapping over a hole
> > in iomap_zero_iter()? The XFS code implies this case also needs to
> > zero the page cache if there is data present, so trigger for page
> > cache lookup only in iomap_zero_iter() needs to handle this case as
> > well.
> 
> Hmm.  If memory serves, we probably need to adapt the
> xfs_buffered/direct_write_iomap_begin functions to return the hole in
> srcmap and the cow mapping in the iomap.  RN I think it just returns the
> hole.

Yes, that is what I was thinking we need to do -
xfs_buffered_write_iomap_begin() doesn't even check for COW mappings
if IOMAP_ZERO is set, so there's a bunch of refactoring work needed
to let iomap know that there is a COW mapping over the hole so it
can do the same page cache lookup stuff that I added for unwritten
extents....

-Dave.

-- 
Dave Chinner
david@fromorbit.com

