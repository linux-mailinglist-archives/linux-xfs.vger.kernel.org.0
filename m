Return-Path: <linux-xfs+bounces-13471-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 86CEE98D35F
	for <lists+linux-xfs@lfdr.de>; Wed,  2 Oct 2024 14:35:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 049121F21BE0
	for <lists+linux-xfs@lfdr.de>; Wed,  2 Oct 2024 12:35:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D3511CFEC2;
	Wed,  2 Oct 2024 12:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="AhZ2kDle"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462EC1CF2B6
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 12:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727872504; cv=none; b=u2/LDGsCkqBTpoKchs+Qkk3EUOzOfEjYhJvRv2HihWLP1aZJUCTNXayd4yliocUmgjoIfAD4yY6oFwcyc2nwgtjNh0VYBKK8UOSPAB9nz3TgZSNbhcdtruTJ+6ye6MrwieP7A5KvD4OYqmvs98u7U02ot87F5N979zMvSSWPXbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727872504; c=relaxed/simple;
	bh=iIykYlQAQBQN7DtszllePlXcuEVlfgXmcBsdIhggSW4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bbnrur6yVQIVVkYooyabFgx+ZRs/ctg1fogcLuDGi339wL+rzzP+mfInbaHW4KAMmH1H2SznzdYMilabvcOG9Iw6aaarHMhzMSNG8b/R/lOHVpNrvAHI85CVSXSY1fvkWOrcUJozyfHEZ3RaKQ5iWVJqo9wHqjDS+as8PHFrvrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=AhZ2kDle; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-20bb92346caso5481505ad.0
        for <linux-xfs@vger.kernel.org>; Wed, 02 Oct 2024 05:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1727872502; x=1728477302; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6E9XJDJSIE/rmejLoIrGrThAVKnoTdwPvPdz5g1SSNA=;
        b=AhZ2kDlecWSbMoIMf2t5ByyrggMIJMtUIcYKq3wcF1yN+sRNsvm7sRBvyszLHW9cSn
         bj4MfIsDwRlGaP3LLfQfqFJkfHssrwXnw3BEPBtiKR1YJh1a5iJHZ4dqfkM/QNr15BXM
         dXOqp4qiO7Q92dOj1+r9EERP1N2WRwyH8OwyfocrrfA/iaeH/ymJwC9UiYJCYarHJD0j
         0d+r8NlJnb9psuY2ZgJhrOvbRWEBZJyj2eUvtgq802CoKRVW1s+miedvAFOG6J1LBZpa
         274Zh1yax9tjiQJ4lNEge0IfOJ3O03ix7LOh7p4qnrsYzahUEMRUad0NVOgIRtotGAxV
         kBRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727872502; x=1728477302;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6E9XJDJSIE/rmejLoIrGrThAVKnoTdwPvPdz5g1SSNA=;
        b=mXCR/6ooElUIxlxeYa2eREL72YvMXtVja5S0q2UL+X5DdfuTMBYwVZRRyaA/CXHFrk
         QNwts+xJMdUPtqHzok685YabhwgvSKG4Rfd9qqj5YkwtPyXtaHAEJCVBAZCh/5CTeEVt
         pLZu5a2SoNuwQflbQyXA12Ak6yg61h5Bvl/FmZ5R/nvM96cNCKYFrQZ16QhSjk1P4yfM
         jFzg7yG6vP403YVvx9LhsJB39sco7/IyVRnSHZBft9gZARFP8iVD1gA8oyPX5PqOvc2I
         pVZESSu0ixbdqSY6kgFC8LAiGzC73tC+UpfJxf7cPm2VLE/1BhHHmNPWcwXOjVNsNKHv
         GJgw==
X-Forwarded-Encrypted: i=1; AJvYcCVQLhzvhFiHKJnKptVgFfQiVh1kvrLnPmilelNEiLsoDdB8PCfOTCurHQuk2Kzcxe5DrBeRPBOcINQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyVdrFlxR0XkRJK0WDpr232f7dIbVdqJkHP4sSZWYIDFo2Tb0pL
	lzTuCmxs63Ygb6hGwr3bGjt3SnivNsiycxb2Ebl6cH286H+zGlzogjNJ+0WD72k=
X-Google-Smtp-Source: AGHT+IGRepjT6EONm519qNvFVatwdjtoHygVk65CVuxZwoZSUutpYOsWKPjw/omJyTOMx8u7eYBS2w==
X-Received: by 2002:a17:903:184:b0:205:5d71:561e with SMTP id d9443c01a7336-20bc5bf1574mr44093105ad.26.1727872502452;
        Wed, 02 Oct 2024 05:35:02 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-78-197.pa.nsw.optusnet.com.au. [49.179.78.197])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20b37e61b00sm83299965ad.275.2024.10.02.05.35.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2024 05:35:01 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1svyZG-00CwWg-2I;
	Wed, 02 Oct 2024 22:34:58 +1000
Date: Wed, 2 Oct 2024 22:34:58 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-bcachefs@vger.kernel.org, kent.overstreet@linux.dev,
	torvalds@linux-foundation.org
Subject: Re: [RFC PATCH 0/7] vfs: improving inode cache iteration scalability
Message-ID: <Zv098heGHOtGfw1R@dread.disaster.area>
References: <20241002014017.3801899-1-david@fromorbit.com>
 <20241002-lethargisch-hypnose-fd06ae7a0977@brauner>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241002-lethargisch-hypnose-fd06ae7a0977@brauner>

On Wed, Oct 02, 2024 at 12:00:01PM +0200, Christian Brauner wrote:
> On Wed, Oct 02, 2024 at 11:33:17AM GMT, Dave Chinner wrote:
> > What do people think of moving towards per-sb inode caching and
> > traversal mechanisms like this?
> 
> Patches 1-4 are great cleanups that I would like us to merge even
> independent of the rest.

Yes, they make it much easier to manage the iteration code.

> I don't have big conceptual issues with the series otherwise. The only
> thing that makes me a bit uneasy is that we are now providing an api
> that may encourage filesystems to do their own inode caching even if
> they don't really have a need for it just because it's there.  So really
> a way that would've solved this issue generically would have been my
> preference.

Well, that's the problem, isn't it? :/

There really isn't a good generic solution for global list access
and management.  The dlist stuff kinda works, but it still has
significant overhead and doesn't get rid of spinlock contention
completely because of the lack of locality between list add and
remove operations.

i.e. dlist is optimised for low contention add operations (i.e.
local to the CPU). However, removal is not a local operation - it
almsot always happens on a different CPU to the add operation.
Hence removal always pulls the list and lock away from the CPU that
"owns" them, and hence there is still contention when inodes are
streaming through memory. This causes enough overhead that dlist
operations are still very visible in CPU profiles during scalability
testing...

XFS (and now bcachefs) have their own per-sb inode cache
implementations, and hence for them the sb->s_inodes list is pure
overhead.  If we restructure the generic inode cache infrastructure
to also be per-sb (this suggestion from Linus was what lead me to
this patch set), then they will also likely not need the
sb->s_inodes list, too.

That's the longer term "generic solution" to the sb->s_inodes list
scalability problem (i.e. get rid of it!), but it's a much larger
and longer term undertaking. Once we know what that new generic
inode cache infrastructure looks like, we'll probably only want to
be converting one filesystem at a time to the new infrastucture.

We'll need infrastructure to allow alternative per-sb iteration
mechanisms for such a conversion take place - the converted
filesystems will likely call a generic ->iter_vfs_inodes()
implementation based on the per-sb inode cache infrastructure rather
than iterating sb->s_inodes. Eventually, we'll end up with that
generic method replacing the sb->s_inodes iteration, we'll end up
with only a couple of filesystems using the callout again.

> But the reality is that xfs has been doing that private inode cache for
> a long time and reading through 5/7 and 6/7 it clearly provides value
> for xfs. So I find it hard to object to adding ->iter_vfs_inodes()
> (Though I would like to s/iter_vfs_inodes/iter_inodes/g).

I named it that way because, from my filesystem centric point of
view, there is a very distinct separation between VFS and filesystem
inodes. The VFS inode (struct inode) is a subset of the filesystem
inode structure and, in XFS's case, a subset of the filesystem inode
life cycle, too.

i.e. this method should not iterate cached filesystem inodes that
exist outside the VFS inode lifecycle or VFS visibility even though
they may be present in the filesystem's internal inode cache.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

