Return-Path: <linux-xfs+bounces-3252-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 724CC843662
	for <lists+linux-xfs@lfdr.de>; Wed, 31 Jan 2024 07:02:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 08F39B24DA0
	for <lists+linux-xfs@lfdr.de>; Wed, 31 Jan 2024 06:02:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06C2F3E477;
	Wed, 31 Jan 2024 06:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="yZ1L6ecC"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09083EA88
	for <linux-xfs@vger.kernel.org>; Wed, 31 Jan 2024 06:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706680951; cv=none; b=RTUzXtyVqhLGzMCgnknoQykCtUKLen6Vq4QKupjUvoQ6K0LbiAUChwiS0kh5m7NC6lmoe04PGFVlHqTRDdOtWKjAmVgfdJVxMeRUwua9HcvoJY6vlybxlo4+smPq1gMBCsGxLB6F/ZFchWiInSXK47aZa2wvHpHGbjmtMe7PzR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706680951; c=relaxed/simple;
	bh=S6iqY0O7bWkNnxXJ5MbqGTCSCZS6LNZcocjvfJVeznc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WV4+jM6g5c/Hc0ltABJy+/d5WtmImkNKz3NBpKSGCyoxVZC5z41/ZqRioSCmJYmTFeXSKgejvdE0y47U/Ko9+BKPpTFtVb9bOazFB49HXx+H+WEIfDf4TcqqLTXElTHS4o9Ey1cmaH27mo+OUjskp3yq4FC9bfbRhr9AWh5TzhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=yZ1L6ecC; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6dddc5e34e2so444258b3a.0
        for <linux-xfs@vger.kernel.org>; Tue, 30 Jan 2024 22:02:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1706680949; x=1707285749; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7nVt2N2T/88QwCj9vDpwCSukp2aFRSspOwEn5na4qf0=;
        b=yZ1L6ecCUUONG4bsc6gQvxkyWEIx86v9ub2Z5lEFvMNlYAm/TYsXR+v2xtprwKasht
         OwMj1laWfYKFRZWotbBiIGM87RAmQN/uoosw7sgX20Jp6aQJh3A0c8sYCtAJ/pV46MyG
         J9OHxV3o3C4aZurnOXtqPFSkyi73oh9fBkLhJCj0xwMg38KoCEUhkF4Or9cqVmf+OqAq
         8m09Ziy/kDVJ57O+bL9fyfidqAvrsEllyyqzn4O4P+7AtaeMx7xh+9axRlalBZZQpy8d
         5ItNfpbocRrHDu39iij8LGt50WSyzCjEtCZd26IHJAtoXk791nSI8c2+PK0GeQJSfiAK
         KJGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706680949; x=1707285749;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7nVt2N2T/88QwCj9vDpwCSukp2aFRSspOwEn5na4qf0=;
        b=tuy6SeEC44GfuhfGYxqoURqIihf/zfjndFwqFkYrn5zKyTP6CxasQt+iNUJEpUQkyc
         TBStz7D9x1HNC2z6nlY+dq2OZ8HZ76Zb60QzHq8DnO1gFxp5p4L0jB5jG/IT9rVHhT0O
         5pfIy7qDpvYJpece1rR304aDqUD6z4lgI7NAiplqLMjxpJkZb6thHZogqCpYv/uP3lkn
         N1XaG3+z/3mL7c7irRYoC+e6dVyZPrrgzyiEkmFngMvIdZSK1MkyRja+2iyiFwxrpNNB
         HsVwHJm0SIrieQ6VU9drNkr9/Okmsi4RUt2X6AmiiG5huJDxU7SLh2kIVshLwEQ1G7vE
         pZDg==
X-Gm-Message-State: AOJu0YxI9igeHv7pWY2XWVFg1TX+u9LnOve30hOVuR3Ze2YG8hVZdgF1
	hK/D8IfabCdU81bNKsoJyXZaXyXgZFCWyZK+o2PT29tKnNYH9voPvNX2yDBV6CQ=
X-Google-Smtp-Source: AGHT+IF83oLZBbfL/1pDsa5srWK3SXBJBiWlPPeb6q8CD6Rlv6AkRdfMv41fs5CW1HIELf7DGdNSpA==
X-Received: by 2002:a62:ce86:0:b0:6db:c583:1ac6 with SMTP id y128-20020a62ce86000000b006dbc5831ac6mr709518pfg.9.1706680948838;
        Tue, 30 Jan 2024 22:02:28 -0800 (PST)
Received: from dread.disaster.area (pa49-181-38-249.pa.nsw.optusnet.com.au. [49.181.38.249])
        by smtp.gmail.com with ESMTPSA id e17-20020a656491000000b005d67862799asm4574140pgv.44.2024.01.30.22.02.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jan 2024 22:02:28 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rV3g1-0002Xn-15;
	Wed, 31 Jan 2024 17:02:25 +1100
Date: Wed, 31 Jan 2024 17:02:25 +1100
From: Dave Chinner <david@fromorbit.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Theodore Ts'o <tytso@mit.edu>,
	syzbot <syzbot+cdee56dbcdf0096ef605@syzkaller.appspotmail.com>,
	adilger.kernel@dilger.ca, chandan.babu@oracle.com, jack@suse.com,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: Re: current->journal_info got nested! (was Re: [syzbot] [xfs?]
 [ext4?] general protection fault in jbd2__journal_start)
Message-ID: <Zbnicfk+JHIlG2WC@dread.disaster.area>
References: <000000000000e98460060fd59831@google.com>
 <000000000000d6e06d06102ae80b@google.com>
 <ZbmILkfdGks57J4a@dread.disaster.area>
 <20240131045822.GA2356784@mit.edu>
 <ZbnYitvLz7sWi727@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZbnYitvLz7sWi727@casper.infradead.org>

On Wed, Jan 31, 2024 at 05:20:10AM +0000, Matthew Wilcox wrote:
> On Tue, Jan 30, 2024 at 11:58:22PM -0500, Theodore Ts'o wrote:
> > Hmm, could XFS pre-fault target memory buffer for the bulkstat output
> > before starting its transaction?  Alternatively, ext4 could do a save
> > of current->journal_info before starting to process the page fault,
> > and restore it when it is done.  Both of these seem a bit hacky, and
> > the question is indeed, are there other avenues that might cause the
> > transaction context nesting, such that a more general solution is
> > called for?
> 
> I'd suggest that saving off current->journal_info is risky because
> it might cover a real problem where you've taken a pagefault inside
> a transaction (eg ext4 faulting while in the middle of a transaction on
> the same filesystem that contains the faulting file).

Depends. Look at it from the POV of XFS:

1. we can identify current->journal_info as belonging to XFS because
of the TRAN magic number in the first 32 bits of the structure.

2. the struct xfs_trans has a pointer to the xfs_mount which points
to the VFS superblock, which means we can identify exactly which
filesystem instance the transaction belongs to.

3. We can determine if the transaction has a journal reservation
from the log ticket the transaction holds.

From these three things, we can identify if we are about to recurse
into the same filesystem, and if so, determine if it is safe to run
new transactions from within that context.

> Seems to me that we shouldn't be writing to userspace while in the
> middle of a transaction.  We could even assert that in copy_to_user()?

On further thinking I don't think the problem is taking page faults
within a filesystem transaction context is the problem here. We're
using the transaction context for automated garbage collection so we
never have to care about leaking object references in the code, not
because we are running a modification and holding a journal
reservation. It's the journals reservations that cannot be allowed
to nest in XFS, not the transactions themselves.

IOWs, the real problem is that multiple filesystems use the same
task field for their own individual purposes, and that then leads
these sorts of recursion problems when a task jumps from one
filesystem context to another and the task field is then
mis-interpretted.

I've had a look at the XFS usage of current->journal_info, and I
think we can just remove it.

It's used for warning that we are running a writepages operations
from within transaction context (which should never happen from XFS
nor memory reclaim). it's also used in the ->destroy_inode path to
determine if we are running in a context where we cannot block on
filesystem locks or transaction reservations. 

The former we can remove with no loss, the latter we can simply
check PF_MEMALLOC_NOFS as that is set by transaction contexts.

IOWs, I think that, in general, page faults in user buffers are fine
in empty XFS transaction contexts as long as we aren't using some
structure that some other filesystem might then to process the
page fault....

This may not be true for other filesystems, but I don't think we
can really say "page faults in any filesystem transaction are unsafe
and should be banned"....

-Dave.
-- 
Dave Chinner
david@fromorbit.com

