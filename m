Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E03838045
	for <lists+linux-xfs@lfdr.de>; Fri,  7 Jun 2019 00:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728990AbfFFWHA (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 6 Jun 2019 18:07:00 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:57466 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728066AbfFFWHA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Jun 2019 18:07:00 -0400
Received: from dread.disaster.area (pa49-195-189-25.pa.nsw.optusnet.com.au [49.195.189.25])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id AEC767E9AFC;
        Fri,  7 Jun 2019 08:06:56 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1hZ0WF-0000VR-0z; Fri, 07 Jun 2019 08:05:59 +1000
Date:   Fri, 7 Jun 2019 08:05:59 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 00/11] xfs: rework extent allocation
Message-ID: <20190606220558.GB14308@dread.disaster.area>
References: <20190522180546.17063-1-bfoster@redhat.com>
 <20190523015659.GL29573@dread.disaster.area>
 <20190523125535.GA20099@bfoster>
 <20190523221552.GM29573@dread.disaster.area>
 <20190524120015.GA32730@bfoster>
 <20190525224317.GZ29573@dread.disaster.area>
 <20190531171136.GA26315@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190531171136.GA26315@bfoster>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0 cx=a_idp_d
        a=K5LJ/TdJMXINHCwnwvH1bQ==:117 a=K5LJ/TdJMXINHCwnwvH1bQ==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=dq6fvYVFJ5YA:10
        a=7-415B0cAAAA:8 a=ZQUQBZYBC2Cbu7dTj44A:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, May 31, 2019 at 01:11:36PM -0400, Brian Foster wrote:
> On Sun, May 26, 2019 at 08:43:17AM +1000, Dave Chinner wrote:
> > Most of the cases I've seen have had the same symptom - "skip to
> > next AG, allocate at same high-up-in AGBNO target as the previous AG
> > wanted, then allocate backwards in the same AG until freespace
> > extent is exhausted. It then skips to some other freespace extent,
> > and depending on whether it's a forwards or backwards skip the
> > problem either goes away or continues. This is not a new behaviour,
> > I first saw it some 15 years ago, but I've never been able to
> > provoke it reliably enough with test code to get to the root
> > cause...
> > 
> 
> I guess the biggest question to me is whether we're more looking for a
> backwards searching pattern or a pattern where we split up a larger free
> extent into smaller chunks (in reverse), or both. I can definitely see
> some isolated areas where a backwards search could lead to this
> behavior. E.g., my previous experiment to replace near mode allocs with
> size mode allocs always allocates in reverse when free space is
> sufficiently fragmented. To see this in practice would require repeated
> size mode allocations, however, which I think is unlikely because once
> we jump AGs and do a size mode alloc, the subsequent allocs should be
> near mode within the new AG (unless we jump again and again, which I
> don't think is consistent with what you're describing).
> 
> Hmm, the next opportunity for this kind of behavior in the near mode
> allocator is probably the bnobt left/right span. This would require the
> right circumstances to hit. We'd have to bypass the first (cntbt)
> algorithm then find a closer extent in the left mode search vs. the
> right mode search, and then probably repeat that across however many
> allocations it takes to work out of this state.
> 
> If instead we're badly breaking up an extent in the wrong order, it
> looks like we do have the capability to allocate the right portion of an
> extent (in xfs_alloc_compute_diff()) but that is only enabled for non
> data allocations. xfs_alloc_compute_aligned() can cause a similar effect
> if alignment is set, but I'm not sure that would break up an extent into
> more than one usable chunk.

This is pretty much matches what I've been able to infer about the
cause, but lacking a way to actually trigger it and be able to
monitor the behviour in real time is where I've got stuck on this.
I see the result in aged, fragmented filesystems and can infer how
it may have occurred, but can't cause it to occur on demand...

> In any event, maybe I'll hack some temporary code in the xfs_db locality
> stuff to quickly flag whether I happen to get lucky enough to reproduce
> any instances of this during the associated test workloads (and if so,
> try and collect more data).

*nod*

Best we can do, I think, and hope we stumble across an easily
reproducable trigger...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
