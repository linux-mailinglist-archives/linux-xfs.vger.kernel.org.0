Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB3F255C00
	for <lists+linux-xfs@lfdr.de>; Fri, 28 Aug 2020 16:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbgH1OKw (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 28 Aug 2020 10:10:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58352 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726400AbgH1OK2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Aug 2020 10:10:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598623825;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UOLSKM1Afz5sba1ii8QSYbsgXnyKpBlvVY6vaUCJ/JI=;
        b=SF8umoO/7o9aGu9xU9G1edwvMYEiRvXgcWhaGdoYuHomPdiBTqLR5hRUpbphOyg6cSROF2
        /pHi7rQ1lHbf9dvlA0J7sd0n1DrJDrxL7JWQwHKmPwYxJ/AoJ6y9iGVqNVsavjsjznvcIm
        i4ytgNnIpummox+WkXhr9a6miEkaEJI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-0E4aSOrWNGO0fmKlXhr79w-1; Fri, 28 Aug 2020 10:10:21 -0400
X-MC-Unique: 0E4aSOrWNGO0fmKlXhr79w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0E38080733A;
        Fri, 28 Aug 2020 14:10:20 +0000 (UTC)
Received: from bfoster (ovpn-112-11.rdu2.redhat.com [10.10.112.11])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 664CF5C221;
        Fri, 28 Aug 2020 14:10:19 +0000 (UTC)
Date:   Fri, 28 Aug 2020 10:10:17 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Josef Bacik <josef@toxicpanda.com>, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] generic: require discard zero behavior for
 dmlogwrites on XFS
Message-ID: <20200828141017.GA514051@bfoster>
References: <20200826143815.360002-1-bfoster@redhat.com>
 <20200826143815.360002-2-bfoster@redhat.com>
 <CAOQ4uxjYf2Hb4+Zid7KeWUcu3sOgqR30de_0KwwjVbwNw1HfJg@mail.gmail.com>
 <20200827070237.GA22194@infradead.org>
 <CAOQ4uxhhN6Gj9AZBvEHUDLjTRKWi7=rOhitmbDLWFA=dCZQxXw@mail.gmail.com>
 <20200827141131.GA428538@bfoster>
 <CAOQ4uxj6RKX01kKKc_SGZJegWEKaF+D8ZNJGALvh4o0c5bBcBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxj6RKX01kKKc_SGZJegWEKaF+D8ZNJGALvh4o0c5bBcBg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Re-add lists to CC.

On Fri, Aug 28, 2020 at 06:47:06AM +0300, Amir Goldstein wrote:
> On Thu, Aug 27, 2020, 5:11 PM Brian Foster <bfoster@redhat.com> wrote:
> 
> > On Thu, Aug 27, 2020 at 10:29:05AM +0300, Amir Goldstein wrote:
> > > On Thu, Aug 27, 2020 at 10:02 AM Christoph Hellwig <hch@infradead.org>
> > wrote:
> > > >
> > > > On Thu, Aug 27, 2020 at 09:58:09AM +0300, Amir Goldstein wrote:
> > > > > I imagine that ext4 could also be burned by this.
> > > > > Do we have a reason to limit this requirement to xfs?
> > > > > I prefer to make it generic.
> > > >
> > > > The whole idea that discard zeroes data is just completely broken.
> > > > Discard is a hint that is explicitly allowed to do nothing.
> > >
> > > I figured you'd say something like that :)
> > > but since we are talking about dm-thin as a solution for predictable
> > > behavior at the moment and this sanity check helps avoiding adding
> > > new tests that can fail to some extent, is the proposed bandaid good
> > enough
> > > to keep those tests alive until a better solution is proposed?
> > >
> > > Another concern that I have is that perhaps adding dm-thin to the fsx
> > tests
> > > would change timing of io in a subtle way and hide the original bugs
> > that they
> > > caught:
> > >
> > > 47c7d0b19502 ("xfs: fix incorrect log_flushed on fsync")
> > > 3af423b03435 ("xfs: evict CoW fork extents when performing
> > finsert/fcollapse")
> > > 51e3ae81ec58 ("ext4: fix interaction between i_size, fallocate, and
> > > delalloc after a crash")
> > >
> > > Because at the time I (re)wrote Josef's fsx tests, they flushed out the
> > bugs
> > > on spinning rust much more frequently than on SSD.
> > >
> > > So Brian, if you could verify that the fsx tests still catch the
> > original bugs
> > > by reverting the fixes or running with an old kernel and probably running
> > > on a slow disk that would be great.
> > >
> >
> > I made these particular changes because it's how we previously addressed
> > generic/482 and they were a pretty clear and quick way to address the
> > problem. I'm pretty sure I've seen these tests reproduce legitimate
> > issues with or without thin, but that's from memory so I can't confirm
> > that with certainty or suggest that applies for every regression these
> > have discovered in the past.
> >
> > If we want to go down that path, I'd say lets just assume those no
> > longer reproduce. That doesn't make these tests any less broken on XFS
> > (v5, at least) today, so I guess I'd drop the thin changes (note again
> > that generic/482 is already using dmthinp) and just disable these tests
> > on XFS until we can come up with an acceptable solution to make them
> > more reliable. That's slightly unfortunate because I think the tests are
> > quite effective, but we're continuing to see spurious failures that are
> > not trivial to diagnose.
> 
> 
> 
> > IIRC, I did at one point experiment with removing the (128M?) physical
> > zeroing limit from the associated logwrites tool, but that somewhat
> > predictably caused the test to take an extremely long time. I'm not sure
> > I even allowed it to finish, tbh. Anyways, perhaps some options are to
> > allow a larger physical zeroing limit and remove the tests from the auto
> > group, use smaller target devices to reduce the amount of zeroing
> > required, require the user to have a thinp or some such volume as a
> > scratch dev already or otherwise find some other more efficient zeroing
> > mechanism.
> >
> > > I know it is not a simple request, but I just don't know how else to
> > trust
> > > these changes. I guess a quick way for you to avoid the hassle is to add
> > > _require_discard_zeroes (patch #1) and drop the rest.
> > >
> >
> > That was going to be my fallback suggestion if the changes to the tests
> > were problematic for whatever reason. Christoph points out that the
> > discard zeroing logic is not predictable in general as it might be on
> > dm-thinp, so I think for now we should probably just notrun these on
> > XFS. I'll send something like that as a v2 of patch 1.
> >
> 
> Maybe there is a better way to stay safe and not sorry.
> 
> Can we use dm thinp only for replay but not for fsx?
> I suppose reliable zeroing is only needed in replay?
> 

I think that would work, but might clutter or complicate the tests by
using multiple devices for I/O vs. replay. That kind of strikes me as
overkill given that two of these run multiple instances of fsx (which
has a fixed size file) and the other looks like it runs a simple xfs_io
command with a fixed amount of I/O. Ironically, generic/482 seems like
the test with the most I/O overhead (via fsstress), but it's been using
dm-thin for a while now.

I think if we're really that concerned with dm-thin allocation overhead,
we should either configure the cluster size to amortize the cost of it
or just look into using smaller block devices so replay-log falls back
to manual zeroing when discard doesn't work. A quick test of the latter
doesn't show a huge increase in test runtime for 455/457, but I'd also
have to confirm that this works as expected and eliminates the spurious
corruption issue. Of course, a tradeoff could be that if discard does
work but doesn't provide zeroing (which Christoph already explained is
unpredictable), then I think we're still susceptible to the original
problem. Perhaps we could create a mode that simply forces manual
zeroing over discards if there isn't one already...

Brian

> Thanks,
> Amir.

