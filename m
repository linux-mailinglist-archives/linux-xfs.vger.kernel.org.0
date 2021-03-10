Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 994F13332FF
	for <lists+linux-xfs@lfdr.de>; Wed, 10 Mar 2021 03:11:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231689AbhCJCLS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 9 Mar 2021 21:11:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59269 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231228AbhCJCKz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Mar 2021 21:10:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615342254;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PmSQRdKuTp5cPzpU2X7/Ag9DGVk/eGYjOzfVTtfQg8I=;
        b=MlSzF3SnBeBJNOLnBZywvgp9y+Ivxy2IwRTfKJi9yqM6uwsnARrP3qBNrSpdauUod4Cbre
        eQXwz5DZlRj8eT5DWPU1wtpMIbBQiP1fy3ZknppmUYQ/WpmXKp8jOr1mv3WLXOgh6QfbUH
        UFzpMVNS1gwD6jqJkuidKjfB7TtPt2o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-nUsYzvUBPq2QWDo17sRPJA-1; Tue, 09 Mar 2021 21:10:50 -0500
X-MC-Unique: nUsYzvUBPq2QWDo17sRPJA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C448B184214B;
        Wed, 10 Mar 2021 02:10:49 +0000 (UTC)
Received: from bfoster (ovpn-112-124.rdu2.redhat.com [10.10.112.124])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 43A376A8E5;
        Wed, 10 Mar 2021 02:10:49 +0000 (UTC)
Date:   Tue, 9 Mar 2021 21:10:47 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3 v2] xfs: AIL needs asynchronous CIL forcing\
Message-ID: <YEgqp87obzpezjwT@bfoster>
References: <20210224232600.GH4662@dread.disaster.area>
 <YD6xrJHgkkHi+7a3@bfoster>
 <20210303005752.GM4662@dread.disaster.area>
 <YD/IN66S3aM1lEQh@bfoster>
 <20210304015933.GO4662@dread.disaster.area>
 <YEDc42Z1GjHBXi6S@bfoster>
 <20210304224848.GR4662@dread.disaster.area>
 <YEJHEt/vt6yuHbak@bfoster>
 <20210309004410.GC74031@dread.disaster.area>
 <20210309043559.GT3419940@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210309043559.GT3419940@magnolia>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 08, 2021 at 08:35:59PM -0800, Darrick J. Wong wrote:
> On Tue, Mar 09, 2021 at 11:44:10AM +1100, Dave Chinner wrote:
> > On Fri, Mar 05, 2021 at 09:58:26AM -0500, Brian Foster wrote:
> > > On Fri, Mar 05, 2021 at 09:48:48AM +1100, Dave Chinner wrote:
> > > > > > > So not only does this patch expose subsystem internals to
> > > > > > > external layers and create more log forcing interfaces/behaviors to
> > > > > > 
> > > > > > Sorry, I don't follow. What "subsystem internals" are being exposed
> > > > > > and what external layer are they being exposed to?
> > > > > > 
> > > > > > > > Cleaning up the mess that is the xfs_log_* and xlog_* interfaces and
> > > > > > > > changing things like log force behaviour and implementation is for
> > > > > > > > a future series.
> > > > > > > > 
> > > > > > > 
> > > > > > > TBH I think this patch is kind of a mess on its own. I think the
> > > > > > > mechanism it wants to provide is sane, but I've not even got to the
> > > > > > > point of reviewing _that_ yet because of the seeming dismissal of higher
> > > > > > > level feedback. I'd rather not go around in circles on this so I'll just
> > > > > > > offer my summarized feedback to this patch...
> > > > > > 
> > > > > > I'm not dismissing review nor am I saying the API cannot or should
> > > > > > not be improved. I'm simply telling you that I think the additional
> > > > > > changes you are proposing are outside the scope of the problem I am
> > > > > > addressing here. I already plan to rework the log force API (and
> > > > > > others) but doing so it not something that this patchset needs to
> > > > > > address, or indeed should address.
> > > > > > 
> > > > > 
> > > > > I'm not proposing additional changes nor to rework the log force API.
> > > > > I'm pointing out that I find this implementation to be extremely and
> > > > > unnecessarily confusing.
> > > > 
> > > > And that's just fine - not everyone has to understand all of the
> > > > code all of the time. That's why we have a team....
> > > > 
> > > > > To improve it, I'm suggesting to either coopt
> > > > > the existing async log force API...
> > > > 
> > > > And I'm telling you that this is *future work*. As the person
> > > > actually doing the work, that's my decision and you need to accept
> > > > that. I understand your concerns and have a plan to address them -
> > > > you just have to accept that the plan to address them isn't going to
> > > > be exactly to your liking.
> > > > 
> > > 
> > > As a reviewer, I am pointing out that I object to how this patch is
> > > implemented and offered several fairly simple suggestions on how to
> > > address my concerns. Those suggestions have been rejected pretty much
> > > out of hand on the basis of the existence of some future plans.
> > 
> > We're allowed to disagree on the best approach. But to find a way
> > forward means that both the summitter and the reviewer need to
> > compromise. I've fixed up the obvious warts and bugs you've pointed
> > out, and agreed that it needs cleaning up and have committed to
> > cleaning it up in the near future.
> > 
> > > Future rework plans do not justify or change my view of this patch
> > > and the mess it adds (for other developers, for historical context
> > > and downstreams, etc.).  Therefore, if the only option you're
> > > willing to consider is "make this mess now and clean it up later
> > > in some broader rework," then I'd rather we just defer this patch
> > > until after that rework is available and avoid the mess that way.
> > 
> > So you won't review it until I have 100 outstanding patches in this
> > series and it's completely and utterly unreviewable?
> 
> Already unreviewable at 45, and I've only gotten through 2/3 of it.
> 
> > Then you'll ask me to split it up and re-order it into digestable
> > chunks, and so we'll go back to having to merge this because any of
> > the API rework that depends on the mechanism that this patch
> > introduces.
> 
> Here's something I haven't previously shared with all of you: Last cycle
> when we were going around and around on the ENOSPC/EDQUOT retry loop
> patches (which exploded from 13 to 41 patches) it was /very/ stressful
> to have to rework this and that part every day and a half for almost
> three weeks.
> 
> When I get a patchset ready for submission, I export the patches from my
> development branch into a topic branch based off the latest -rc.  Every
> time anyone makes a suggestion, I update the topic branch and send that
> to the fstests "cloud" to see if it broke anything.  If it succeeds, I
> push it to k.org and resubmit.
> 
> The part that's less obvious is the fact that rebasing is /not/ that
> simple.  Next I integrate the changes into my development tree and
> rebase everything that comes after /that/ to make sure it doesn't
> interfere with my longer term development goals.  Sometimes this is
> easy, sometimes this takes an entire day to work out the warts.
> Then I send that to the fstests "cloud".  This rebase is particularly
> painful because every change that everyone makes to inode
> initialization collides with a rework of inode initialization that I've
> been working on in preparation for metadata directory trees.
> 
> The part that's even /less/ obvious than that is that once the
> development tree tests ok, then I do the same to my xfsprogs dev tree to
> make sure that nothing broke.  Frequently there are ABI or cognitive
> mismatches between kernel and userspace such that the build breaks, and
> then I have to patch the two kernel trees and re-run everything.
> 
> So, that's really stressful for me because a minor tweak to an interface
> can result in an enormous amount of work.  And I reject the argument
> that I could just rebase less frequently -- Dave does that, which means
> that any time he hears that one of his topic branches is being asked
> about, he has to spend weeks rebasing the whole mess to the latest
> upstream.  Maybe that works for him, but for me, I would hate that even
> more than doing a daily rebase.
> 
> Add to that the fact that vger has been a total delivery sh*tshow all
> year.  Now in addition to feeling disconnected from my family and
> friends, I also feel disconnected from work people too.  This really did
> nearly push me over the edge three weeks ago.
> 
> Please remember, one of the big advantages of our open development
> processes is that we /do/ accept code with warty (but functional)
> interfaces now, and we can clean them up later.  This is (IMHO) a good
> stress-reduction tactic, because each of us (ideally) should concentrate
> on getting the core algorithms right, and not focusing on rebasing code
> and smoothing over the same d*** merge conflicts over and over.
> 
> Yes, it's true that people think that a maintainer's only real power is
> to say 'no' in the hopes of forcing developers to fix everything now
> because they can't trust that a dev will ever come back with the
> promised updates, but I reject that 110%.  I'm not going anywhere, and I
> /do/ trust that when the rest of you say that you'll be back with wart
> remover, you will.
> 
> > I'm not going to play that "now jump through this hoop" game.  We
> > add flags for on-off behaviours in internal functions -all the
> > time-. If this makes the interface so complex and confusing that you
> > don't understand it, then the interface was already too complex and
> > confusing. And fixing that is *not in the scope of this patchset*.
> > 
> > Demanding that code be made perfect before it can be merged is
> > really not very helpful. Especially when there are already plans to
> > rework the API but that rework is dependent on a bunch of other
> > changes than need to be done first.
> > 
> > iclogs are something that need to be moved behind the CIL, not sit
> > in front of CIL. The CIL abstracts the journal and writing to the
> > journal completely away from the transaction subsystem, yet the log
> > force code punches straight through that abstraction and walks
> > iclogs directly. The whole log force implementation needs to change,
> > and I plan for the API that wraps the log forces to get reworked at
> > that time.
> 
> So here's what I want to know: Do Dave's changes to the log force APIs
> introduce broken behavior?  If the interfaces are so confusing that
> /none/ of us understand it, can we introduce the appropriate wrappers
> and documentation so that the rest of us plugging away at the rest of
> the system can only call it the supported ways to achieve any of the
> supported outcomes?
> 

It looks to me that the changes to xlog_cil_force_seq() could
essentially be replaced with something like:

/*
 * Behold the magical async CIL force
 * ... <explain what this does> ...
 */
static inline void
xfs_cil_force_async(
	struct xlog	*log)
{
	struct xfs_cil	*cil = log->l_cilp;

	/* true for magic async CIL force */
	xlog_cil_push_now(log, cil->xc_current_sequence, true);
}

If so, we wouldn't have to hack up xlog_cil_force_seq() with a flags
parameter that provides inconsistent async semantics (and thus show
mercy on the log force call stack above it) and otherwise only serves to
bypass 95% of that function anyways. I also think that inverting the cil
push bool param (and calling it async_push or some such) is a bit more
clear because it separates it from XFS_LOG_SYNC (or !XFS_LOG_SYNC)
semantics and simultaneously maps directly to the underlying
->xc_push_async control.

Brian

> I'm willing to accept a bunch of documentation and "trivial" wrappers
> for the rest of us as a shoofly to enable the rest of the xfs developers
> to keep moving around a messy slow-moving log restructuring without
> falling into a work pit.
> 
> However, it's been difficult for me to check that without being able to
> reference a branch to see that at least the end result looks sane.  That
> was immensely helpful for reviewing Allison's deferred xattrs series.
> 
> (TLDR: git branch plz)
> 
> The other way to ease my fears, of course, would be to submit a ton of
> fstests to examine the log behavior for correctness, but that's
> difficult to pull off when the control surface is the userspace ABI.
> 
> > For example, if we want to direct map storage for log writes, then
> > iclog-based log force synchronisation needs to go away because we
> > don't need iclogs for buffering journal writes. Hence the log foce
> > code should interface only with the CIL, and only the CIL should
> > manage whatever mechanism it is using to write to stable storage.
> > The code is currently the way it is because the CIL, when first
> > implemented, had to co-exist with the old way of writing to the log.
> > We haven't used that old way for a decade now and we have very
> > different storage performance characteristics these days, so it's
> > about time we got rid of the mechanism designed to be optimal for
> > spinning disks and actually integrated the CIL and the log
> > efficiently.
> > 
> > There are a *lot* of steps to do this, and reworking the log force
> > implementation and API is part of that. But reworking that API is
> > premature because we haven't done all the necessary pre-work in
> > place to make such a change yet. This patch is actually part of that
> > pre-work to get the mechanisms that the log force rework will rely
> > on.
> > 
> > I have very good reasons for pushing back against your suggestions,
> > Brian. Your suggestions have merit but this patch is not the time to
> > be making the changes you suggest. Code does not need to be perfect
> > to be merged, nor does the entire larger change they will be part of
> > need to be complete and 100% tested and reviewed before preparation
> > and infrastructure patches can be merged. This is how we've done big
> > changes in the past - they've been staged across multiple kernel
> > cycles - and not everything needs to be done in the first
> > patchset of a larger body of work....
> 
> You mean there's even more beyond the 45 already on the list? /groan/
> 
> --D
> 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
> 

