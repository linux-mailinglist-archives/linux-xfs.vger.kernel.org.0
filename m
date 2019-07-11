Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D436666136
	for <lists+linux-xfs@lfdr.de>; Thu, 11 Jul 2019 23:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729074AbfGKVb2 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 11 Jul 2019 17:31:28 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38219 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729067AbfGKVb2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Jul 2019 17:31:28 -0400
Received: by mail-pf1-f194.google.com with SMTP id y15so3344697pfn.5
        for <linux-xfs@vger.kernel.org>; Thu, 11 Jul 2019 14:31:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h0li3xhz4+acWFDo/bMhBX18vS9tPI8VpxMt5WWQyBk=;
        b=OCVICqNm8W4H6dNZrm4LsZBNnhLhAuV/wYUx2hDMtcrQp/IkL1pgwhhuY/wyqdENvi
         bfWUObDrfwUe9pz9E2kfEAulHs0gVv950eOVE466Vj9tHtMSe5ay++FGL1Szy/21c1IF
         3sqicaUTZHYSa1tNItHvOV+YRQW4JVn6Ow9D8aHHb/tVhVEz+wkOVBl/lktBNAptngS5
         R5J69YBC4FUKgugJkznIDL3t3orZD/QtFD562NBHzLfUFTB60XUdPbVWB9EH+rIzgqHz
         ZeG65Dk5X5i4zPw0++vu1aygFUHa1SILmNCk8Ddk8loqHKdQo8pZOwq2wr0Q9PWJQlx2
         1jeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h0li3xhz4+acWFDo/bMhBX18vS9tPI8VpxMt5WWQyBk=;
        b=GD0lz71MZWCdazYklhc3MX6VOVurej7ENHEXC/xJYdr1aVo5KHwa9s3McU/QijVJr/
         PND8OdqrTVCmnIzwbBmwot/y0LrvwuBMOQ4j6ILaJ7SBUo8Kn5enhOxCkrZXTfCkPdIr
         CwxsPN4P0GIzerCuXgJtYo+/qpp1W2Sp+cIQt06CU0ZY91Sw0H5GCjI/0NqJZa5Vb3lj
         0eJUl0x4P+mnRIUOoIWVLWb562PL4Y675+3n+YMrL7oGAfIPqme7g7j59NXzg1NnVF4j
         PZ2fdKefhg0XrbVxDrwwCaMBTpvx9r1yTAvBwnHNGj5/2AX5cahytuGgIt14u+r+lUfB
         ivoQ==
X-Gm-Message-State: APjAAAUIbbt/08PJLwKKXpQudwkpFV8P3L9M8fWrSGGRtlRwcw5UTnfk
        PwK9bklGNiOm2sDSSq0bVvk8+VqXcVaxWfXU014vfQ==
X-Google-Smtp-Source: APXvYqzfOsEAMRtBI+nHwZ9rZwKzA3V96eeiRwhIJCYj+RBGPbja6faXox7EbAjZQhXE55uENS8c06Vt+Q/F6xaW8Fo=
X-Received: by 2002:a63:b919:: with SMTP id z25mr6534778pge.201.1562880686976;
 Thu, 11 Jul 2019 14:31:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190624055253.31183-1-hch@lst.de> <20190624055253.31183-12-hch@lst.de>
 <20190624234304.GD7777@dread.disaster.area> <20190625101020.GI1462@lst.de>
 <20190628004542.GJ7777@dread.disaster.area> <20190628222756.GM19023@42.do-not-panic.com>
In-Reply-To: <20190628222756.GM19023@42.do-not-panic.com>
From:   Brendan Higgins <brendanhiggins@google.com>
Date:   Thu, 11 Jul 2019 14:31:15 -0700
Message-ID: <CAFd5g46kRfQYkobqXta8GJibkEnUDv2oWXp+JZurRtydotbsuA@mail.gmail.com>
Subject: Re: [PATCH 11/12] iomap: move the xfs writeback code to iomap.c
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 28, 2019 at 3:28 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
>
> On Fri, Jun 28, 2019 at 10:45:42AM +1000, Dave Chinner wrote:
> > On Tue, Jun 25, 2019 at 12:10:20PM +0200, Christoph Hellwig wrote:
> > > On Tue, Jun 25, 2019 at 09:43:04AM +1000, Dave Chinner wrote:
> > > > I'm a little concerned this is going to limit what we can do
> > > > with the XFS IO path because now we can't change this code without
> > > > considering the direct impact on other filesystems. The QA burden of
> > > > changing the XFS writeback code goes through the roof with this
> > > > change (i.e. we can break multiple filesystems, not just XFS).
> > >
> > > Going through the roof is a little exaggerated.
> >
> > You've already mentioned two new users you want to add. I don't even
> > have zone capable hardware here to test one of the users you are
> > indicating will use this code, and I suspect that very few people
> > do.  That's a non-trivial increase in testing requirements for
> > filesystem developers and distro QA departments who will want to
> > change and/or validate this code path.
>
> A side topic here:
>
> Looking towards the future of prosects here with regards to helping QA
> and developers with more confidence in API changes (kunit is one
> prospect we're evaluating)...
>
> If... we could somehow... codify what XFS *requires* from the API
> precisely...  would that help alleviate concerns or bring confidence in
> the prospect of sharing code?
>
> Or is it simply an *impossibility* to address these concerns in question by
> codifying tests for the promised API?
>
> Ie, are the concerns something which could be addressed with strict
> testing on adherence to an API, or are the concerns *unknown* side
> dependencies which could not possibly be codified?

Thanks for pointing this out, Luis. This is a really important
distinction. In the former case, I think as has become apparent in
your example below; KUnit has a strong potential to be able to
formally specify API behavior and guarantee compliance.

However, as you point out there are many *unknown* dependencies which
always have a way of sneaking into API informal specifications. I have
some colleagues working on this problem for unknown server API
dependencies; nevertheless, to my knowledge this is an unsolved
problem.

One partial solution I have seen is to put a system in place to record
live traffic so that it can be later replayed in a test environment.

Another partial solution is a modified form of fuzz testing similar to
what Haskell's QuickCheck[1] does, which basically attempts to allow
users to specify the kinds of data they expect to handle in such a way
that QuickCheck is able to generate random data, pass it into the API,
and verify the results satisfy the contract. I actually wrote a
prototype of this for KUnit, but haven't publicly shared it yet since
I thought it was kind of an out there idea (plus KUnit was pretty far
away from being merged at the time).

Still, a QuickCheck style test will always have the problem that the
contract will likely underspecify things, and if not, the test may
still never run long enough to cover all interesting cases. I have
heard of attempts to solve this problem by combining the two prior
approaches in novel ways (like using a QuckCheck style specification
to mutate real recorded data).

Anyway, sorry for the tangent, but I would be really interested to
know whether you think the problem is more of the just testing the
formally specified contract or the problem lies in unknown
dependencies that Luis mentioned, and in either case whether you would
find any of these ideas useful.

> As an example of the extent possible to codify API promise (although
> I beleive it was unintentional at first), see:
>
> http://lkml.kernel.org/r/20190626021744.GU19023@42.do-not-panic.com

[1] http://www.cse.chalmers.se/~rjmh/QuickCheck/manual.html

Cheers!
