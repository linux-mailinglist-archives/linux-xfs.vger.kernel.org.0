Return-Path: <linux-xfs+bounces-14152-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3328899D6BF
	for <lists+linux-xfs@lfdr.de>; Mon, 14 Oct 2024 20:49:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E7A45284B35
	for <lists+linux-xfs@lfdr.de>; Mon, 14 Oct 2024 18:49:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1296013C8F0;
	Mon, 14 Oct 2024 18:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Njh8200+"
X-Original-To: linux-xfs@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B4F84683
	for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2024 18:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728931765; cv=none; b=V6uQAgj36F7CitzksjwWhdw3jg1T8XcjEZQ1LxRqYzyRVRBh/5UJp3GelMoxNJ3Du8FadRppvOxTtxoYGUXD2yvfkT6tW+lKEr+njUd9jmva4x6FhSgdRNPjajDi+cdVZ2GoVG6jz7fTUylhM2OogcxmA3uzH5bfBBVw7IDo1YE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728931765; c=relaxed/simple;
	bh=BLzTNSoPDoPALmphY4rFclRYggnUlK2seKSOCBXDD10=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AfyDlS67DTYi2mh4S2iV0u/tjPRo9fLUz6T/gotS+q4vgG+R8vCRNS/eR9OX+EDyzs9xxCmSOioqEKvOlMnFibMVGdIXRt19IB3OeMVzNxEHrz1qAHoCHBurFl6UxCf2ePxzg8fYlxBvaLkmXfPx7vbxE7DhaueUmGpwUqeLxFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Njh8200+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728931762;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=m5uMXpBr+FK7XhDKWBmgQV3vN7mj7X8CdZfcIz47sfM=;
	b=Njh8200+xcH5gEfgEB6eIgjX/9BWQr7NaFDA5CVBJZpV2rU0YVd5hafPaT1pCD50GBWgJG
	jzGFO+e7nqPpchrM5nJdajiR8VwLSfunwbtIDqOs/dOC+hdfsvluUulaki9WCrKzjJ2gKM
	Pwzg42nbqU3J6QQOZ7FqDlxcBzLKYdY=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-664-FYWpI1CAPYW3nPhIpA_a_w-1; Mon,
 14 Oct 2024 14:49:19 -0400
X-MC-Unique: FYWpI1CAPYW3nPhIpA_a_w-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D3BA919560AE;
	Mon, 14 Oct 2024 18:49:17 +0000 (UTC)
Received: from bfoster (unknown [10.22.64.74])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C085819560AA;
	Mon, 14 Oct 2024 18:49:16 +0000 (UTC)
Date: Mon, 14 Oct 2024 14:50:37 -0400
From: Brian Foster <bfoster@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/7] xfs: don't update file system geometry through
 transaction deltas
Message-ID: <Zw1n_bkugSs6oEI6@bfoster>
References: <20240930164211.2357358-1-hch@lst.de>
 <20240930164211.2357358-7-hch@lst.de>
 <ZwffQQuVx_CyVgLc@bfoster>
 <20241011075709.GC2749@lst.de>
 <Zwkv6G1ZMIdE5vs2@bfoster>
 <20241011171303.GB21853@frogsfrogsfrogs>
 <ZwlxTVpgeVGRfuUb@bfoster>
 <20241011231241.GD21853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241011231241.GD21853@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Fri, Oct 11, 2024 at 04:12:41PM -0700, Darrick J. Wong wrote:
> On Fri, Oct 11, 2024 at 02:41:17PM -0400, Brian Foster wrote:
> > On Fri, Oct 11, 2024 at 10:13:03AM -0700, Darrick J. Wong wrote:
> > > On Fri, Oct 11, 2024 at 10:02:16AM -0400, Brian Foster wrote:
> > > > On Fri, Oct 11, 2024 at 09:57:09AM +0200, Christoph Hellwig wrote:
> > > > > On Thu, Oct 10, 2024 at 10:05:53AM -0400, Brian Foster wrote:
> > > > > > Ok, so we don't want geometry changes transactions in the same CIL
> > > > > > checkpoint as alloc related transactions that might depend on the
> > > > > > geometry changes. That seems reasonable and on a first pass I have an
> > > > > > idea of what this is doing, but the description is kind of vague.
> > > > > > Obviously this fixes an issue on the recovery side (since I've tested
> > > > > > it), but it's not quite clear to me from the description and/or logic
> > > > > > changes how that issue manifests.
> > > > > > 
> > > > > > Could you elaborate please? For example, is this some kind of race
> > > > > > situation between an allocation request and a growfs transaction, where
> > > > > > the former perhaps sees a newly added AG between the time the growfs
> > > > > > transaction commits (applying the sb deltas) and it actually commits to
> > > > > > the log due to being a sync transaction, thus allowing an alloc on a new
> > > > > > AG into the same checkpoint that adds the AG?
> > > > > 
> > > > > This is based on the feedback by Dave on the previous version:
> > > > > 
> > > > > https://lore.kernel.org/linux-xfs/Zut51Ftv%2F46Oj386@dread.disaster.area/
> > > > > 
> > > > 
> > > > Ah, Ok. That all seems reasonably sane to me on a first pass, but I'm
> > > > not sure I'd go straight to this change given the situation...
> > > > 
> > > > > Just doing the perag/in-core sb updates earlier fixes all the issues
> > > > > with my test case, so I'm not actually sure how to get more updates
> > > > > into the check checkpoint.  I'll try your exercisers if it could hit
> > > > > that.
> > > > > 
> > > > 
> > > > Ok, that explains things a bit. My observation is that the first 5
> > > > patches or so address the mount failure problem, but from there I'm not
> > > > reproducing much difference with or without the final patch.
> > > 
> > > Does this change to flush the log after committing the new sb fix the
> > > recovery problems on older kernels?  I /think/ that's the point of this
> > > patch.
> > > 
> > 
> > I don't follow.. growfs always forced the log via the sync transaction,
> > right? Or do you mean something else by "change to flush the log?"
> 
> I guess I was typing a bit too fast this morning -- "change to flush the
> log to disk before anyone else can get their hands on the superblock".
> You're right that xfs_log_sb and data-device growfs already do that.
> 
> That said, growfsrt **doesn't** call xfs_trans_set_sync, so that's a bug
> that this patch fixes, right?
> 

Ah, Ok.. that makes sense. Sounds like it could be..

> > I thought the main functional change of this patch was to hold the
> > superblock buffer locked across the force so nothing else can relog the
> > new geometry superblock buffer in the same cil checkpoint. Presumably,
> > the theory is that prevents recovery from seeing updates to different
> > buffers that depend on the geometry update before the actual sb geometry
> > update is recovered (because the latter might have been relogged).
> > 
> > Maybe we're saying the same thing..? Or maybe I just misunderstand.
> > Either way I think patch could use a more detailed commit log...
> 
> <nod> The commit message should point out that we're fixing a real bug
> here, which is that growfsrt doesn't force the log to disk when it
> commits the new rt geometry.
> 

Maybe even make it a separate patch to pull apart some of these cleanups
from fixes. I was also wondering if the whole locking change is the
moral equivalent of locking the sb across the growfs trans (i.e.
trans_getsb() + trans_bhold()), at which point maybe that would be a
reasonable incremental patch too.

> > > >                                                              Either way,
> > > > I see aborts and splats all over the place, which implies at minimum
> > > > this isn't the only issue here.
> > > 
> > > Ugh.  I've recently noticed the long soak logrecovery test vm have seen
> > > a slight tick up in failure rates -- random blocks that have clearly had
> > > garbage written to them such that recovery tries to read the block to
> > > recover a buffer log item and kaboom.  At this point it's unclear if
> > > that's a problem with xfs or somewhere else. :(
> > > 
> > > > So given that 1. growfs recovery seems pretty much broken, 2. this
> > > > particular patch has no straightforward way to test that it fixes
> > > > something and at the same time doesn't break anything else, and 3. we do
> > > 
> > > I'm curious, what might break?  Was that merely a general comment, or do
> > > you have something specific in mind?  (iows: do you see more string to
> > > pull? :))
> > > 
> > 
> > Just a general comment..
> > 
> > Something related that isn't totally clear to me is what about the
> > inverse shrink situation where dblocks is reduced. I.e., is there some
> > similar scenario where for example instead of the sb buffer being
> > relogged past some other buffer update that depends on it, some other
> > change is relogged past a sb update that invalidates/removes blocks
> > referenced by the relogged buffer..? If so, does that imply a shrink
> > should flush the log before the shrink transaction commits to ensure it
> > lands in a new checkpoint (as opposed to ensuring followon updates land
> > in a new checkpoint)..?
> 
> I think so.  Might we want to do that before and after to be careful?
> 

Yeah maybe. I'm not quite sure if even that's enough. I.e. assuming we
had a log preflush to flush out already committed changes before the
grow, I don't think anything really prevents another "problematic"
transaction from committing after that preflush.

I dunno.. on one hand it does seem like an unlikely thing due to the
nature of needing space to be free in order to shrink in the first
place, but OTOH if you have something like grow that is rare, not
performance sensitive, has a history of not being well tested, and has
these subtle ordering requirements that might change indirectly to other
transactions, ISTM it could be a wise engineering decision to simplify
to the degree possible and find the most basic model that enforces
predictable ordering.

So for a hacky thought/example, suppose we defined a transaction mode
that basically implemented an exclusive checkpoint requirement (i.e.
this transaction owns an entire checkpoint, nothing else is allowed in
the CIL concurrently). Presumably that would ensure everything before
the grow would flush out to disk in one checkpoint, everything
concurrent would block on synchronous commit of the grow trans (before
new geometry is exposed), and then after that point everything pending
would drain into another checkpoint.

It kind of sounds like overkill, but really if it could be implemented
simply enough then we wouldn't have to think too hard about auditing all
other relog scenarios. I'd probably want to see at least some reproducer
for this sort of problem to prove the theory though too, even if it
required debug instrumentation or something. Hm?

> > Anyways, my point is just that if it were me I wouldn't get too deep
> > into this until some of the reproducible growfs recovery issues are at
> > least characterized and testing is more sorted out.
> > 
> > The context for testing is here [1]. The TLDR is basically that
> > Christoph has a targeted test that reproduces the initial mount failure
> > and I hacked up a more general test that also reproduces it and
> > additional growfs recovery problems. This test does seem to confirm that
> > the previous patches address the mount failure issue, but this patch
> > doesn't seem to prevent any of the other problems produced by the
> > generic test. That might just mean the test doesn't reproduce what this
> > fixes, but it's kind of hard to at least regression test something like
> > this when basic growfs crash-recovery seems pretty much broken.
> 
> Hmm, if you make a variant of that test which formats with an rt device
> and -d rtinherit=1 and then runs xfs_growfs -R instead of -D, do you see
> similar blowups?  Let's see what happens if I do that...
> 

Heh, sounds like so from your followup. Fun times.

I guess that test should probably work its way upstream. I made some
tweaks locally since last posted to try and make it a little more
aggressive, but it didn't repro anything new so not sure how much
difference it makes really. Do we want a separate version like yours for
the rt case or would you expect to cover both cases in a single test?

Brian

> --D
> 
> > Brian
> > 
> > [1] https://lore.kernel.org/fstests/ZwVdtXUSwEXRpcuQ@bfoster/
> > 
> > > > have at least one fairly straightforward growfs/recovery test in the
> > > > works that reliably explodes, personally I'd suggest to split this work
> > > > off into separate series.
> > > > 
> > > > It seems reasonable enough to me to get patches 1-5 in asap once they're
> > > > fully cleaned up, and then leave the next two as part of a followon
> > > > series pending further investigation into these other issues. As part of
> > > > that I'd like to know whether the recovery test reproduces (or can be
> > > > made to reproduce) the issue this patch presumably fixes, but I'd also
> > > > settle for "the grow recovery test now passes reliably and this doesn't
> > > > regress it." But once again, just my .02.
> > > 
> > > Yeah, it's too bad there's no good way to test recovery with older
> > > kernels either. :(
> > > 
> > > --D
> > > 
> > > > Brian
> > > > 
> > > > 
> > > 
> > 
> > 
> 


