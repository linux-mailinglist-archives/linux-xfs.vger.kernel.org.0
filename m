Return-Path: <linux-xfs+bounces-7265-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F06218AC227
	for <lists+linux-xfs@lfdr.de>; Mon, 22 Apr 2024 01:48:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4ACCB28118A
	for <lists+linux-xfs@lfdr.de>; Sun, 21 Apr 2024 23:48:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C13945C10;
	Sun, 21 Apr 2024 23:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="ii2p5E7X"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA30645BF1
	for <linux-xfs@vger.kernel.org>; Sun, 21 Apr 2024 23:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713743326; cv=none; b=YR52qknzIddnKZy7S4LNHC8+0IhqpceC640jCqBPrSbZql1RP1cgYdOFk1+YJmFsFbn28+0KiHx/GWjGxFoqtgs1CkccQmosw0j974uFaNonpKk8EnGk6Yfp61mIl3opAPBrVafMWiDGUrKpkUbMI1t0ytPK+XIPZefm0NMoBHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713743326; c=relaxed/simple;
	bh=y2G5uthsuVNhqW5pHUqGqg8U3yXFp7tl+IlqOZsE4FU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UwaD1LiTw8Ku/BwqbA0UMkBPHXU8MNsVbGwVEWgn1USWw+s+xKgvT2msxd+7zqIuta75nLcnjzJMvADDC/5xKaga30F/mhdG8qZN270F1HDe5/G+HzmIpam2TbeNmLII+8f8bAs3H6Z+ab50E5IpQFU/zCLMC+9UlgvEnEvHQTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=ii2p5E7X; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1e9320c2ef6so6937205ad.2
        for <linux-xfs@vger.kernel.org>; Sun, 21 Apr 2024 16:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1713743324; x=1714348124; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ODecTpiSDn8owcJVtYfhOYyFCmGqiEF5T0FOE0Q7pYU=;
        b=ii2p5E7XiDriPq/nPrtwiURkEPcBn4Ku0nhX8+AknwvC2epEmW1xrMC5B5XdhxYU4y
         o9MZgqT439mIpoGFwm7pboPLGnd0A3IYXrefI8Tu3qklIWNK+zWSkyg9HwlkbYkxIUJP
         W3AfIWqbiaamuxaQ6XnWb0alwUQCjUtJcfFfXftZN9UPerA/5jiEUIUUOV/6eo0QYSBT
         oDxHfEr8CGpTVcbpsaejFB0sXTbXIHyucGIQRF4+4ZI6c4dbi5TVjGECIdJ414674IS3
         +oLp2TxMG4kaxQMzJeKrtzwgOi2oiuSxeOnBwTofwuabqjTrd+bdu7ixY9hXeJBHQole
         DaLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713743324; x=1714348124;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ODecTpiSDn8owcJVtYfhOYyFCmGqiEF5T0FOE0Q7pYU=;
        b=kjNjOgIX8/DYdVXXh+2BlmfdT+aVnH3bOGFmAVwYIE1zYP77U5kfN8e7yzb+O2Yy7B
         Qo2K66/aU4++Xe/PgW+AO45/NhV3W6RoBfbyX5ivDuq/scRssooLaNaKc0lM0vagptM9
         DKmRca8/xyd/z/OolY8QeSP4A6ic5PnEt//RIs379kC/ZThzQUcioAG6FJKo7IGi2iEl
         WGDcF/0Q5KLNpFPSAtsrS9y9hnpdz2mRX5Yp8jMrh6MFokcfj9mYaIXAbLpDPlPNtSwY
         zLGAwqc1QxYIgIoaF4PCAIzLZCAXcaPUMlwc1Dyw2viNiEG34uEw3loAHnwSz+M66u7Z
         ZsxQ==
X-Forwarded-Encrypted: i=1; AJvYcCWKiwYdyNOoda/qVn7bSoxdT7OnYOIbSYQpYPZOaKVixOfqVyVZrViLqWQ8ve/K7Dhiy6DQn5tU0/tB06KxKg2dlDdfRkRSiEC0
X-Gm-Message-State: AOJu0YxljfIPf6g4VLbsha+E6P8SjvLvBb+POpFTCIFSvPab2IIm7fUA
	i2B14iyr3XqBK7lJ1gYJgcsZgT6j05XgAwayx738WJwhTDcT1NuF8+54G7AjE+CL/5VryONwqLZ
	/
X-Google-Smtp-Source: AGHT+IHbzM9WTguvErwRH2CsBk5I52CDnC6s8ksQag1pw8ZVRDh4zwq68ajlLaHToMsn7cZSZRbijw==
X-Received: by 2002:a17:903:2308:b0:1e2:a61d:905 with SMTP id d8-20020a170903230800b001e2a61d0905mr11379072plh.63.1713743323840;
        Sun, 21 Apr 2024 16:48:43 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id w17-20020a1709027b9100b001e3e222072esm6809955pll.53.2024.04.21.16.48.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Apr 2024 16:48:43 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rygvI-006KH8-32;
	Mon, 22 Apr 2024 09:48:40 +1000
Date: Mon, 22 Apr 2024 09:48:40 +1000
From: Dave Chinner <david@fromorbit.com>
To: Marius Fleischer <fleischermarius@gmail.com>
Cc: Leah Rumancik <leah.rumancik@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, harrisonmichaelgreen@gmail.com,
	syzkaller@googlegroups.com
Subject: Re: KASAN: null-ptr-deref Write in xlog_cil_commit
Message-ID: <ZiWl2MG5f0wAp7mM@dread.disaster.area>
References: <CAJg=8jz0X=CKR1POvF41oEumrq1z=MVWPdF2ECbzV6-rhht8-g@mail.gmail.com>
 <ZiGYbJezGZg6tGgq@dread.disaster.area>
 <CAJg=8jycPX=fQskUb=48g=AS7-uUNAVKZyZ+tyAC5uGYwfpabg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJg=8jycPX=fQskUb=48g=AS7-uUNAVKZyZ+tyAC5uGYwfpabg@mail.gmail.com>

On Fri, Apr 19, 2024 at 10:28:41AM -0700, Marius Fleischer wrote:
> Hi Dave,
> 
> Thank you so much for your quick response to this!
> 
> 
> > kernel version: 5.15.156
> >
> > Really old kernel.
> >
> >
> I'm sorry, I was under the impression that 5.15.156 is an actively
> maintained kernel as
> it is one of the current LTS version. Is this not the case? I'd love your
> insight on this.

It might be maintained, but it's still a really old kernel. Lots of
meaningful stuff has changed since 5.15.0 was release by Linus...

> > > We took a very brief look at the code. Is it possible that there is a
> > check
> > > missing for the return value of kvmalloc at fs/xfs/xfs_log_cil.c:224?
> > >
> > > lv = kvmalloc(buf_size, GFP_KERNEL);
> > > memset(lv, 0, xlog_cil_iovec_space(niovecs));
> >
> > I've never seen that memory allocation fail there, and that code has
> > been using an unchecked, open coded kvmalloc() for well over a
> > decade. We replaced it with a direct call to kvmalloc() in 5.15,
> > but the failure semantics here never changed.
> >
> > But I guess it could fail if error injection is enabled,
> > and because we used to call __vmalloc() directly it may never have
> > had errors injected?
> >
> > But, regardless, that's completely irrelevant.
> >
> > We replaced the kvmalloc() call there with a guaranteed "no fail"
> > open coded loop in 5.17 for performance reasons, so this open coded
> > kvmalloc() call only existed in 5.15 and 5.16. See commit
> > 8dc9384b7d75 ("xfs: reduce kvmalloc overhead for CIL shadow
> > buffers").
> >
> >
> I am not sure I am completely following you. If I understand you correctly
> (and after
> checking out the commit you linked - thanks for that!), is it correct that
> it would be
> better to patch this by replacing it with the same open coded kvmalloc as
> in 5.17?

What I'm saying is that the code was changed soon afterwards for
different reasons, but hte newer code would also address the issue
you saw.

> Do you think it would make sense to backport that patch to 5.15.156 (the
> LTS kernel)?

That's up to the 5.15 LTS maintainers to decide. They also need to
weigh up the fact that xlog_cil_kvmalloc() doesn't exist anymore in
the upstream code base. i.e. we found other places that had the same
kvmalloc() performance problems, and so lifted that code up further
and used it in other places in XFS....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

