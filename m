Return-Path: <linux-xfs+bounces-16050-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 274979E4F20
	for <lists+linux-xfs@lfdr.de>; Thu,  5 Dec 2024 09:02:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9E3871881E46
	for <lists+linux-xfs@lfdr.de>; Thu,  5 Dec 2024 08:02:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 222051CEADA;
	Thu,  5 Dec 2024 08:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GOTZlaJf"
X-Original-To: linux-xfs@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 411421CEAD8
	for <linux-xfs@vger.kernel.org>; Thu,  5 Dec 2024 08:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733385734; cv=none; b=IsG0mBRfwG/UZMtfa2UKKyCBFe0FRDXMDki7HYQzGWe79jSTY/bJNEs7ZkbRMifndbPWl6ctocmGYuI6funL3sBCJibPFsPhmaaLG+7oP3/Oe9dftEdkGsYZMQO9jzYatI6jvkHVo9u5wKGggUIZjXXPhGqVr0MjMudGLTMQuDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733385734; c=relaxed/simple;
	bh=hO00Dr1dme1t1unZazvpqhnvblTefko9CDhaW1ixDfw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dx2g8GduFUT5daHbxxonlQ2Z5PJVHr+OT9tj6wcfKtIyrH80INV6MaYz9r3xT6BtqFK1f8gwWNS5lRNZ/gtbfem39nIy5CtKnt67QsRfDKce6sBHGe88TQJg6zY+Mb0iT7B0VHukQiY9qCV5vTPp7y3D7XOSEtCiZWmvqL186M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GOTZlaJf; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733385732;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j3gOfxpC6UvqrylAsdrtGPVf0KluTNfjaNeutsqYjOI=;
	b=GOTZlaJfiZ2yyOFPemXIzd+92K4qTjwMpoMiQIw63F/yB387Y1kO3+TZTVhNe0dvhA/lhd
	KiONKeeu0e6fnxDUE1L0X4w7SE1xfewfBpRyNLmgyZncBSAYaxdUKs2MxDNpB6/unIRvzY
	H9goHeOZ2gOI1Keqz4KRKrkXSohq62I=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-692-L9svg-vfNI6FF0_Lbs7I7g-1; Thu,
 05 Dec 2024 03:02:06 -0500
X-MC-Unique: L9svg-vfNI6FF0_Lbs7I7g-1
X-Mimecast-MFC-AGG-ID: L9svg-vfNI6FF0_Lbs7I7g
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 677DE1956063;
	Thu,  5 Dec 2024 08:02:05 +0000 (UTC)
Received: from redhat.com (unknown [10.22.64.4])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6C2291956054;
	Thu,  5 Dec 2024 08:02:03 +0000 (UTC)
Date: Thu, 5 Dec 2024 02:02:00 -0600
From: Bill O'Donnell <bodonnel@redhat.com>
To: Bill O'Donnell <bodonnel@redhat.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@infradead.org>, cem@kernel.org,
	stable@vger.kernel.org, jlayton@kernel.org,
	linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCHSET v2] xfs: proposed bug fixes for 6.13
Message-ID: <Z1Fd-FVR84x3fLVd@redhat.com>
References: <173328106571.1145623.3212405760436181793.stgit@frogsfrogsfrogs>
 <Z1EBXqpMWGL306sh@redhat.com>
 <20241205064243.GD7837@frogsfrogsfrogs>
 <Z1FNqV27x5hjnqQ9@redhat.com>
 <Z1FPGXpTIJ1Fc2Xy@infradead.org>
 <Z1FQdYEXLR5BoOE-@redhat.com>
 <20241205073321.GH7837@frogsfrogsfrogs>
 <Z1Facuy97Xxj9mKO@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1Facuy97Xxj9mKO@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Thu, Dec 05, 2024 at 01:46:58AM -0600, Bill O'Donnell wrote:
> On Wed, Dec 04, 2024 at 11:33:21PM -0800, Darrick J. Wong wrote:
> > On Thu, Dec 05, 2024 at 01:04:21AM -0600, Bill O'Donnell wrote:
> > > On Wed, Dec 04, 2024 at 10:58:33PM -0800, Christoph Hellwig wrote:
> > > > On Thu, Dec 05, 2024 at 12:52:25AM -0600, Bill O'Donnell wrote:
> > > > > > 1) Our vaunted^Wshitty review process didn't catch various coding bugs,
> > > > > > and testing didn't trip over them until I started (ab)using precommit
> > > > > > hooks for spot checking of inode/dquot/buffer log items.
> > > > > 
> > > > > You give little time for the review process.
> > 
> > Seriously?!
> > 
> > Metadir has been out for review in some form or another since January
> > 2019[1].  If five years and eleven months is not sufficient for you to
> > review a patchset or even to make enough noise that I'm aware that
> > you're even reading my code, then I don't want you ever to touch any of
> > my patchsets ever again.
> > 
> > > > I don't really think that is true.  But if you feel you need more time
> > > > please clearly ask for it.  I've done that in the past and most of the
> > > > time the relevant people acted on it (not always).
> > > > 
> > > > > > 2) Most of the metadir/rtgroups fixes are for things that hch reworked
> > > > > > towards the end of the six years the patchset has been under
> > > > > > development, and that introduced bugs.  Did it make things easier for a
> > > > > > second person to understand?  Yes.
> > > > > 
> > > > > No.
> > > > 
> > > > So you speak for other people here?
> > > 
> > > No. I speak for myself. A lowly downstream developer.
> > > 
> > > > 
> > > > > I call bullshit. You guys are fast and loose with your patches. Giving
> > > > > little time for review and soaking.
> > > > 
> > > > I'm not sure who "you" is, but please say what is going wrong and what
> > > > you'd like to do better.
> > > 
> > > You and Darrick. Can I be much clearer?
> > > 
> > > > 
> > > > > > > becoming rather dodgy these days. Do things need to be this
> > > > > > > complicated?
> > > > > > 
> > > > > > Yeah, they do.  We left behind the kindly old world where people didn't
> > > > > > feed computers fuzzed datafiles and nobody got fired for a computer
> > > > > > crashing periodically.  Nowadays it seems that everything has to be
> > > > > > bulletproofed AND fast. :(
> > > > > 
> > > > > Cop-out answer.
> > > > 
> > > > What Darrick wrote feels a little snarky, but he has a very valid
> > > > point.  A lot of recent bug fixes come from better test coverage, where
> > > > better test coverage is mostly two new fuzzers hitting things, or
> > > > people using existing code for different things that weren't tested
> > > > much before.  And Darrick is single handedly responsible for a large
> > > > part of the better test coverage, both due to fuzzing and specific
> > > > xfstests.  As someone who's done a fair amount of new development
> > > > recently I'm extremely glad about all this extra coverage.
> > > > 
> > > I think you are killing xfs with your fast and loose patches.
> > 
> > Go work on the maintenance mode filesystems like JFS then.  Shaggy would
> > probably love it if someone took on some of that.
> 
> No idea who "Shaggy" is. Nor do I care.	   
> > 
> > > Downstreamers like me are having to clean up the mess you make of
> > > things.
> > 
> > What are you doing downstream these days, exactly?  You don't
> > participate in the LTS process at all, and your employer boasts about
> > ignoring that community process.  If your employer chooses to perform
> > independent forklift upgrades of the XFS codebase in its product every
> > three months and you don't like that, take it up with them, not
> > upstream.

Why are you such a nasty person? I try to get along with people, but you're
impossible. I've been an engineer for 40+ years, and I've never encountered such
an arrogant one as you.


> > 
> > --D
> > 
> > [1] https://lore.kernel.org/linux-xfs/154630934595.21716.17416691804044507782.stgit@magnolia/
> > 
> > 
> > > 
> > > > 
> > > 
> > > 
> > 
> 
> 


