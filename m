Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0A53AA710
	for <lists+linux-xfs@lfdr.de>; Thu, 17 Jun 2021 00:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbhFPW4S (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 16 Jun 2021 18:56:18 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:57633 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229483AbhFPW4S (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Jun 2021 18:56:18 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 6A0EB696A0;
        Thu, 17 Jun 2021 08:54:08 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lteQB-00DaZK-FA; Thu, 17 Jun 2021 08:54:07 +1000
Date:   Thu, 17 Jun 2021 08:54:07 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [BUG] generic/475 recovery failure(s)
Message-ID: <20210616225407.GA664593@dread.disaster.area>
References: <YMIsWJ0Cb2ot/UjG@bfoster>
 <YMOzT1goreWVgo8S@bfoster>
 <20210611223332.GS664593@dread.disaster.area>
 <20210616070542.GY664593@dread.disaster.area>
 <YMpgFmEzjpWnmZ66@bfoster>
 <20210616210500.GF158209@locust>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210616210500.GF158209@locust>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=kj9zAlcOel0A:10 a=r6YtysWOX24A:10 a=7-415B0cAAAA:8
        a=c38qygjJ3DZ5KMjuqXcA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jun 16, 2021 at 02:05:00PM -0700, Darrick J. Wong wrote:
> On Wed, Jun 16, 2021 at 04:33:26PM -0400, Brian Foster wrote:
> > On Wed, Jun 16, 2021 at 05:05:42PM +1000, Dave Chinner wrote:
> > > Ok, time to step back and think about this for a bit. The good news
> > > is that this can only happen with pipelined CIL commits, while means
> > > allowing more than one CIL push to be in progress at once. We can
> > > avoid this whole problem simply by setting the CIL workqueue back to
> > > running just a single ordered work at a time. Call that Plan B.
> > > 
> > > The bad news is that this is zero day bug, so all kernels out there
> > > will fail to recovery with out of order start records. Back before
> > > delayed logging, we could have mulitple transactions commit to the
> > > journal in just about any order and nesting, and they used exactly
> > > the same start/commit ordering in recovery that is causing us
> > > problems now. This wouldn't have been noticed, however, because
> > > transactions were tiny back then, not huge checkpoints like we run
> > > now. And if is was, it likely would have been blamed on broken
> > > storage because it's so ephemeral and there was little test
> > > infrastructure that exercised these paths... :/
> 
> It's a zero day bug, but at least nobody tripped over this until two
> months ago.  I've been dealing on and off with customer escalations
> involving a filesystem with large reflinked images that goes down, and
> then some time after the recovery (minutes to weeks) they hit a
> corruption goto and crash again.  I've been able to pin down the
> symptoms to ... the "corrupt" refcount btree block containing partial
> old contents, where the old contents are always aligned to 128 byte
> boundaries, and when Dave mentioned this last night I realized that he
> and I might have fallen into the same thing.

I have my suspicions that this has been causing issues for a long
time, but it's been so rare that it's been impossible to reproduce
and hence capture the information needed to debug it. This time,
however, the failure triggered an assert before recovery completed
and so left the filesystem in the state where I could repeat log
recovery and have it fail with the same ASSERT fail over and over
again.

<meme> A few hours later.... </meme>

> > > What this means is that we can't just make a fix to log recovery
> > > because taking a log from a current kernel and replaying it on an
> > > older kernel might still go very wrong, and do so silently. So I
> > > think we have to fix what we write to the log.
> > > 
> > > Hence I think the only way forward here is to recognise that the
> > > AIL, log forces and log recovery all require strictly ordered
> > > checkpoint start records (and hence LSNs) as well as commit records.
> > > We already strictly order the commit records (and this analysis
> > > proves it is working correctly), so we should be able to leverage
> > > the existing functionality to do this.
> > > 
> > 
> > Ok. I still need to poke at the code and think about this, but what you
> > describe here all makes sense. I wonder a bit if we have the option to
> > fix recovery via some kind of backwards incompatibility, but that
> > requires more thought (didn't we implement or at least consider
> > something like a transient feature bit state some time reasonably
> > recently? I thought we did but I can't quite put my finger on what it
> > was for or if it landed upstream.).
> 
> We did -- it was (is) a patchset to turn on log incompat feature bits in
> the superblock, and clear them later on when they're not in use and the
> log is being cleaned.  I proposed doing that for atomic file content
> swapping, and Allison's deferred xattrs patchset will want the same to
> protect xattr log intent items.
> 
> > That train of thought aside, ordering start records a la traditional
> > commit record ordering seems like a sane option. I am starting to think
> > that your plan B might actually be a wise plan A, though. I already
> > wished we weren't pushing so much log rewrite/rework through all in one
> > cycle. Now it sounds like we require even more significant (in
> > complexity, if not code churn, as I don't yet have a picture of what
> > "start record ordering" looks like) functional changes to make an
> > otherwise isolated change safe. Just my .02.
> 
> /me guesses that we should go with plan B for 5.14, and work on fixing
> whatever's wrong for 5.15.  But since it's never possible to tell how
> much time is left until the merge window opens, I'll keep an open
> mind...

The simple fix appears to have worked. That was just applying the
same write ordering code the commit records use to the start record
write.

The series of fixes I have now has run about a thousand cycles of
g/019 without a log hang or a log recovery failure, so I think I've
got viable fixes for the issues g/019 has exposed. I also suspect
that this start record ordering issue is what g/475 was tripping
over, too.

Given that we still have a couple of months before this will be
released to users, I'd much prefer that we move forwards with
testing the fixes because there is a suspicion and anecdotal
evidence that this problem has been affecting users for a long time
regardless of the recent changes that have brought it out into the
daylight.

I'm about to split up the fix into smaller chunks and then I'll post
the series for review.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
