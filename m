Return-Path: <linux-xfs+bounces-2745-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 42C8F82B5E3
	for <lists+linux-xfs@lfdr.de>; Thu, 11 Jan 2024 21:27:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C1E921F259D9
	for <lists+linux-xfs@lfdr.de>; Thu, 11 Jan 2024 20:27:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA71D57311;
	Thu, 11 Jan 2024 20:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="2lnjBzEr"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34CC95730F
	for <linux-xfs@vger.kernel.org>; Thu, 11 Jan 2024 20:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-6de95fd8767so748449a34.2
        for <linux-xfs@vger.kernel.org>; Thu, 11 Jan 2024 12:27:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1705004855; x=1705609655; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dOkQ9Rpa4osMiZgU5FKKMXtlaxFypnnHbi5Roc2d2Bw=;
        b=2lnjBzErTxwiF4tjatwnF6tuqzz8aInmiFj8dYsYdGfG9AxQC4XjoXKgon+Vx6ZBjJ
         XRndsSKenD6B/eUXrYLO/Y5j34ujSHsygkGbw5kcouxjQZBav4GL7dY7xMGhqgebwX3A
         /gRDi6QqeeBoo2ImoRxQM1kgfxn1cTTVIRGP12FfUH9J8pvXhEaaggpjD5TnNDMTnh9L
         0Wyg2MiGAc5xpFt6cVjIk4mkIXTh57QbnxZ90+d0FKHi64fN9xr7A3XV5tmFl8WXscnL
         p9SIF9TbnZqxPwlxO2Y3eZ2n3dFza9o1WShrLAVxjBVAbEeHK2ABeHjxbFyeTeZOspOR
         1F6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705004855; x=1705609655;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dOkQ9Rpa4osMiZgU5FKKMXtlaxFypnnHbi5Roc2d2Bw=;
        b=c2lm2U/apk6I5LHxyA3B28pGqTct1gqd6NEtXwD0xQbRj6jpKMaVEhy7YehXYdQ00q
         Dt8Pgzv7X4cN/ywUsEQy2Rqc0A6XvxccGvTvQIkof8I+uUtCWuAQF6ipAT1yS6w5VzG+
         Ms5MvnbRUSawxkCMDlDAZHG5TeKQLsC/7QQnDFrJOMb9ByOjsMobB/gIV9IQsWkhTlfa
         KPlWZcdLGhP0A5kbP7kktMoSaOqBF/b1Sr6PWhHGpW2dUdQbuMxm+lLMfpVwEU7mop87
         8SkmpJfUQ5IGo45fHApeGMhknEv0akEIT3yu7At55SWmK8K3Jc3Ub/OX7YX9qwe2zicL
         Pt5g==
X-Gm-Message-State: AOJu0YzqZjaIKWjdcko2tKSRMAN9OLUC3gFFwUR5mZXgm/v1hXf0yeAR
	lMT0IQKDqLvdnfwJUjr/IUGM9YsVTYZPEA==
X-Google-Smtp-Source: AGHT+IEadBPmiaBGj1c+EWB05y1hNWajbm2d20/1j8KZk8fOJAnFcvpQPMta5LP+DzvXU3baUAEJ7g==
X-Received: by 2002:a05:6871:e78f:b0:206:9e01:33af with SMTP id qb15-20020a056871e78f00b002069e0133afmr355605oac.43.1705004855190;
        Thu, 11 Jan 2024 12:27:35 -0800 (PST)
Received: from dread.disaster.area (pa49-180-249-6.pa.nsw.optusnet.com.au. [49.180.249.6])
        by smtp.gmail.com with ESMTPSA id z4-20020a636504000000b005ceb4a6d72bsm1565888pgb.65.2024.01.11.12.27.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jan 2024 12:27:34 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rO1eF-0095xN-1H;
	Fri, 12 Jan 2024 07:27:31 +1100
Date: Fri, 12 Jan 2024 07:27:31 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jian Wen <wenjianhn@gmail.com>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org, hch@lst.de,
	dchinner@redhat.com, Jian Wen <wenjian1@xiaomi.com>,
	Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: explicitly call cond_resched in
 xfs_itruncate_extents_flags
Message-ID: <ZaBPM14r5vGrQ9mc@dread.disaster.area>
References: <20240110071347.3711925-1-wenjian1@xiaomi.com>
 <ZZ8OaNnp6b/PJzsb@dread.disaster.area>
 <CAMXzGWJU+a2s-tbpzdmPTCg9Et7UpDdpdBEjkiUUvAV5kxTjig@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMXzGWJU+a2s-tbpzdmPTCg9Et7UpDdpdBEjkiUUvAV5kxTjig@mail.gmail.com>

[cc Thomas, lkml]

On Thu, Jan 11, 2024 at 08:52:22PM +0800, Jian Wen wrote:
> On Thu, Jan 11, 2024 at 5:38 AM Dave Chinner <david@fromorbit.com> wrote:
> >
> > On Wed, Jan 10, 2024 at 03:13:47PM +0800, Jian Wen wrote:
> > > From: Jian Wen <wenjianhn@gmail.com>
> > >
> > > Deleting a file with lots of extents may cause a soft lockup if the
> > > preemption model is none(CONFIG_PREEMPT_NONE=y or preempt=none is set
> > > in the kernel cmdline). Alibaba cloud kernel and Oracle UEK container
> > > kernel are affected by the issue, since they select CONFIG_PREEMPT_NONE=y.
> >
> > Time for them to move to CONFIG_PREEMPT_DYNAMIC?
> I had asked one of them to support CONFIG_PREEMPT_DYNAMIC before
> sending the patch.

OK.

> > Also there has been recent action towards removing
> > CONFIG_PREEMPT_NONE/VOLUNTARY and cond_resched() altogether because
> > the lazy preemption model coming present in the RTPREEMPT patchset
> > solves the performance issues with full preemption that PREEMPT_NONE
> > works around...
> >
> > https://lwn.net/Articles/944686/
> > https://lwn.net/Articles/945422/
> >
> > Further, Thomas Gleixner has stated in those discussions that:
> >
> >         "Though definitely I'm putting a permanent NAK in place for
> >          any attempts to duct tape the preempt=NONE model any
> >          further by sprinkling more cond*() and whatever warts
> >          around."
> >
> > https://lwn.net/ml/linux-kernel/87jzshhexi.ffs@tglx/
> >
> > > Explicitly call cond_resched in xfs_itruncate_extents_flags avoid
> > > the below softlockup warning.
> >
> > IOWs, this is no longer considered an acceptible solution by core
> > kernel maintainers.
> Understood. I will only build a hotfix for our production kernel then.

Yeah, that may be your best short term fix. We'll need to clarify
what the current policy is on adding cond_resched points before we
go any further in this direction.

Thomas, any update on what is happening with cond_resched() - is
there an ETA on it going away/being unnecessary?

> > Regardless of these policy issues, the code change:
> >
> > > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > > index c0f1c89786c2..194381e10472 100644
> > > --- a/fs/xfs/xfs_inode.c
> > > +++ b/fs/xfs/xfs_inode.c
> > > @@ -4,6 +4,7 @@
> > >   * All Rights Reserved.
> > >   */
> > >  #include <linux/iversion.h>
> > > +#include <linux/sched.h>
> >
> > Global includes like this go in fs/xfs/xfs_linux.h, but I don't
> > think that's even necessary because we have cond_resched() calls
> > elsewhere in XFS with the same include list as xfs_inode.c...
> >
> > >  #include "xfs.h"
> > >  #include "xfs_fs.h"
> > > @@ -1383,6 +1384,8 @@ xfs_itruncate_extents_flags(
> > >               error = xfs_defer_finish(&tp);
> > >               if (error)
> > >                       goto out;
> > > +
> > > +             cond_resched();
> > >       }
> >
> > Shouldn't this go in xfs_defer_finish() so that we capture all the
> > cases where we loop indefinitely over a range continually rolling a
> > permanent transaction via xfs_defer_finish()?
> It seems xfs_collapse_file_space and xfs_insert_file_space also need
> to yield CPU.
> I don't have use cases for them yet.

Yup, they do, but they also call xfs_defer_finish(), so having the
cond_resched() in that function will capture them as well.

Also, the current upstream tree has moved this code from
xfs_itruncate_extents_flags() to xfs_bunmapi_range(), so the
cond_resched() has to be moved, anyway. We may as well put it in
xfs_defer_finish() if we end up doing this.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

