Return-Path: <linux-xfs+bounces-9415-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A51F90C0B2
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Jun 2024 02:49:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2281328379C
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Jun 2024 00:49:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB6727489;
	Tue, 18 Jun 2024 00:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b="jZDb5Mfx"
X-Original-To: linux-xfs@vger.kernel.org
Received: from zebra.cherry.relay.mailchannels.net (zebra.cherry.relay.mailchannels.net [23.83.223.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 944817483
	for <linux-xfs@vger.kernel.org>; Tue, 18 Jun 2024 00:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.223.195
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718671742; cv=pass; b=DT1CC1Ol1FtLJ4VQHOdJTNfx+6hQbTFjWoo0tK94tYJng6Iq82y7Ni+QqCXmyN2B1mAJFe8E7bQ58WzZckXBORUSHpQPOy37U8AD7EOXYELttymQZL1xTGGrWo+YsapPVe3/Wz2xCK4J7xH+Oc/3Raox1v2Zn31HyGUgfP70iCI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718671742; c=relaxed/simple;
	bh=Thd6FDZURDPISy81LFnjhwP7nZrWmVK9yR1rrBWOvtU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ahHCnzY5ZBVUiVCLgy7N91/Nl4Vcodh6bDpE5ibWxQJWjighKSM9cwSmGofxxRDjTOPGFMO8+b6oUBT4p39Gs/Ut0iYCdfEYhXZ/sJB0eQ1c6lN4A43lwDve0V70k/y3iMSDHrkXS1MQoAPPKHVF8VfQHgFpwmoEE9xGC/bIbV0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com; spf=pass smtp.mailfrom=templeofstupid.com; dkim=pass (2048-bit key) header.d=templeofstupid.com header.i=@templeofstupid.com header.b=jZDb5Mfx; arc=pass smtp.client-ip=23.83.223.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=templeofstupid.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=templeofstupid.com
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 6C7647A40DB
	for <linux-xfs@vger.kernel.org>; Mon, 17 Jun 2024 22:25:53 +0000 (UTC)
Received: from pdx1-sub0-mail-a215.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id CFDE27A395D
	for <linux-xfs@vger.kernel.org>; Mon, 17 Jun 2024 22:25:52 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1718663152; a=rsa-sha256;
	cv=none;
	b=YvJG+I1W/GFSeLCi4rN8iUHMMsOYKTR6pmDh2IktHl3DYhYSXzGtpWrx4SK1F98pMkWgqN
	tKiKQy8QREh8a3f9Dr2v0s6ZHNbAei5B/xwvWNgBPCDB02unRsbjVhps/J8Ue0yrUcS1Wm
	7k2JkgWDOdHDzRk1ZfVuoaGgPF44TIp088v7dLUQlpg4SJ/ibLAFEDFf1avRaAbOKv6/0d
	gsjMpDWk0rKnBwsLVqaYdcfDpsRmsVYM/7zCEuNdsmqD6jCwO+ICWNhKCJx5PvigaurHvs
	amS2mGzuQ0JYwCDxKJO31vlyW3wyvyCC5DggiJbSIzHb625C4ppLLCsYDzMrEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1718663152;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7E1nFxCvR83LR0BmDx0IxQdh/SW12G1wVJarjGPZZyQ=;
	b=YQeztx6iBRFB3VqtsetWaL1/+t2zVgm3B9eiAB96vX3dH/TY+78mZJDmgNPqmsQ6GPHjx4
	2ciI2OhtD4EDcEYi+4XOUnQvmWu8PZcBmgepxQrDgVrQh3H0jyZSaSEEuQlFm/bqIH7xlw
	EqBontFE5HeHOjTrukSSBmKKLPznjFx4RvHBWA9aKtApww8vYCLvYtS3X9wVqC3Bp2G52b
	xzCH6ab6U6S0GKMYkF5OiWYLYzJCed418/cxv5UU2T6Ft55DXsYsbnVhQGAFs5Kcj3ab6/
	JPlaMg+iD5hznylkmaF7GfvoW7dG6YJppTMrv2YGDeS66ypLNn0X/txfULr6Og==
ARC-Authentication-Results: i=1;
	rspamd-7f76976655-6qrlm;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=kjlx@templeofstupid.com
X-Sender-Id: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|kjlx@templeofstupid.com
X-MailChannels-Auth-Id: dreamhost
X-Spill-Towering: 446b54987dafcaa2_1718663153075_4062491761
X-MC-Loop-Signature: 1718663153074:104733345
X-MC-Ingress-Time: 1718663153074
Received: from pdx1-sub0-mail-a215.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.113.46.135 (trex/6.9.2);
	Mon, 17 Jun 2024 22:25:53 +0000
Received: from kmjvbox.templeofstupid.com (c-73-70-109-47.hsd1.ca.comcast.net [73.70.109.47])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kjlx@templeofstupid.com)
	by pdx1-sub0-mail-a215.dreamhost.com (Postfix) with ESMTPSA id 4W34GS4XgPzHr
	for <linux-xfs@vger.kernel.org>; Mon, 17 Jun 2024 15:25:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=templeofstupid.com;
	s=dreamhost; t=1718663152;
	bh=7E1nFxCvR83LR0BmDx0IxQdh/SW12G1wVJarjGPZZyQ=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=jZDb5MfxG3Y2er7NF461FELmwXLi4RQz45mqeqHf001rTscFB9Bm4Tn0rctztyMdK
	 cuXbJ+EHaKQ4YN/jf0GmBEDAIXzh2+c75HsQxwLlJChffMwipNUnIacUxURYsXjvLY
	 BKNDpNfxO/JUt/UlSVC7HMRjROxnbtB8jfF3jiQpSjkPAJsL3j8M3XwCRpOd+QdjAd
	 GkOT1A+oEoQol/GRvIoF+T8vIqOryCjCihaBnoreCsdoM/LUE9y6y2DdpavmKeJ+Fi
	 QflsommLxIvPjXUUjaRpOdN33X2paqonzgvzEklTyVAn2wLve/X63JC7svSebhDHMM
	 reRwGzIhOEJ+w==
Received: from johansen (uid 1000)
	(envelope-from kjlx@templeofstupid.com)
	id e002c
	by kmjvbox.templeofstupid.com (DragonFly Mail Agent v0.12);
	Mon, 17 Jun 2024 15:25:27 -0700
Date: Mon, 17 Jun 2024 15:25:27 -0700
From: Krister Johansen <kjlx@templeofstupid.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>, Gao Xiang <xiang@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] bringing back the AGFL reserve
Message-ID: <20240617222527.GA2044@templeofstupid.com>
References: <cover.1718232004.git.kjlx@templeofstupid.com>
 <ZmuSsYn/ma9ejCoP@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZmuSsYn/ma9ejCoP@dread.disaster.area>

On Fri, Jun 14, 2024 at 10:45:37AM +1000, Dave Chinner wrote:
> On Thu, Jun 13, 2024 at 01:27:09PM -0700, Krister Johansen wrote:
> > I managed to work out a reproducer for the problem.  Debugging that, the
> > steps Gao outlined turned out to be essentially what was necessary to
> > get the problem to happen repeatably.
> > 
> > 1. Allocate almost all of the space in an AG
> > 2. Free and reallocate that space to fragement it so the freespace
> > b-trees are just about to split.
> > 3. Allocate blocks in a file such that the next extent allocated for
> > that file will cause its bmbt to get converted from an inline extent to
> > a b-tree.
> > 4. Free space such that the free-space btrees have a contiguous extent
> > with a busy portion on either end
> > 5. Allocate the portion in the middle, splitting the extent and
> > triggering a b-tree split.
> 
> Do you have a script that sets up this precondition reliably?
> It sounds like it can be done from a known filesystem config. If you
> do have a script, can you share it? Or maybe even better, turn it
> into an fstest?

I do have a script that reproduces the problem.  At the moment it is in
a pretty embarrasing state.  I'm happy to clean it up a bit and share
it, or try to turn it into a fstest, or both.  The script currently
creates small loop devices to generate a filesystem layout that's a
little easier to work with.  Is it considered acceptable to have a
fstest create a filesystem with a particular geometry?  (And would you
consider taking a patch to let mkfs.xfs --unsupported take both size and
agsize arguments so the overall filesystem size and the per-ag size
could be set by a test?)

> > On older kernels this is all it takes.  After the AG-aware allocator
> > changes I also need to start the allocation in the highest numbered AG
> > available while inducing lock contention in the lower numbered AGs.
> 
> Ah, so you have to perform a DOS on the lower AGFs so that the
> attempts made by the xfs_alloc_vextent_start_ag() to trylock the
> lower AGFs once it finds it cannot allocate in the highest AG
> anymore also fail.
> 
> That was one of the changes made in the perag aware allocator
> rework; it added full-range AG iteration when XFS_ALLOC_FLAG_TRYLOCK
> is set because we can't deadlock on reverse order AGF locking when
> using trylocks.
> 
> However, if the trylock iteration fails, it then sets the restart AG
> to the minimum AG be can wait for without deadlocking, removes the
> trylock and restarts the iteration. Hence you've had to create AGF
> lock contention to force the allocator back to being restricted by
> the AGF locking orders.

The other thing that I really appreciated here is that the patchset
cleaned up a bunch of the different allocation functions and made
everything easier to read and follow.  Thanks for that as well.

> Is this new behaviour sufficient to mitigate the problem being seen
> with this database workload? Has it been tested with kernels that
> have those changes, and if so did it have any impact on the
> frequency of the issue occurring?

I don't have a good answer for this yet.  The team is planning to start
migrating later in the year and this will probably run through to next
year.  I'll have that information eventually and will share it when I
do, but don't know yet.  Aside from the script, other synethtic
load-tests have not been successful in reproducing the problemr.  That
may be the result of the databases that are spun up for load testing not
having filesystems that as full and fragmented as the production ones.

> > In order to ensure that AGs have enough space to complete transactions
> > with multiple allocations, I've taken a stab at implementing an AGFL
> > reserve pool.
> 
> OK. I'll comment directly on the code from here, hopefully I'll
> address your other questions in those comments.

Thanks, Dave.  I appreciate you spending the time to review and provide
feedback.

-K

