Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50D7F15B35F
	for <lists+linux-xfs@lfdr.de>; Wed, 12 Feb 2020 23:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727692AbgBLWG7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 12 Feb 2020 17:06:59 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:45020 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727564AbgBLWG7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Feb 2020 17:06:59 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01CM0dk9087051;
        Wed, 12 Feb 2020 22:06:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=CQ4Ci2w+mSUNiLtu0sTa+DCDNZ2cYGrLZQrKBq9Z4Wc=;
 b=Ss03Mft94MT1KWM5ItYQA8KN+fkf+RBudKATRKkf3a9jKwTW8kejy0HcjybgBBw7w414
 Ny5v4srVFEKnyj4k8jTk3soh2QhMaSzpQLQ9MlEqWuRkrbRHNQFCxbgPtpf4CwvnHhAu
 wNasNiwz2Kup6oU122KooQNfEJKOADUHaE0bhCDVS6LVdgtoudTwXFzN0+LiA34oMoU/
 tqGq1uP1Aa65p+IqS10Rdya4gvp7OQcVBRfhGqtgE7YxOn2AoGaOyBiaFykm+fAgGPog
 FBYME8rpi0uNFp2YBTNv/IbGq3aOTzPv+S2dOH62miXL+352EOngX5LtoEBhhhJSNPmW xw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2y2jx6e5fe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 12 Feb 2020 22:06:07 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 01CLvJBE003682;
        Wed, 12 Feb 2020 22:06:06 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2y4k9ggt3k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Feb 2020 22:06:06 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 01CM64uO012425;
        Wed, 12 Feb 2020 22:06:04 GMT
Received: from localhost (/10.159.151.237)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 12 Feb 2020 14:06:03 -0800
Date:   Wed, 12 Feb 2020 14:06:00 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        Amir Goldstein <amir73il@gmail.com>,
        lsf-pc@lists.linux-foundation.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        xfs <linux-xfs@vger.kernel.org>, Eryu Guan <guaneryu@gmail.com>,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: [Lsf-pc] [LSF/MM/BPF TOPIC] FS Maintainers Don't Scale
Message-ID: <20200212220600.GS6870@magnolia>
References: <20200131052520.GC6869@magnolia>
 <CAOQ4uxh=4DrH_dL3TULcFa+pGk0YhS=TobuGk_+Z0oRWvw63rg@mail.gmail.com>
 <8983ceaa-1fda-f9cc-73c9-8764d010d3e2@oracle.com>
 <20200202214620.GA20628@dread.disaster.area>
 <fc430471-54d2-bb44-d084-a37e7ff9ef50@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc430471-54d2-bb44-d084-a37e7ff9ef50@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9529 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0 spamscore=0
 adultscore=0 bulkscore=0 phishscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002120151
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9529 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 priorityscore=1501 adultscore=0 phishscore=0 impostorscore=0 spamscore=0
 bulkscore=0 lowpriorityscore=0 mlxscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2002120151
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Feb 09, 2020 at 10:12:03AM -0700, Allison Collins wrote:
> 
> 
> On 2/2/20 2:46 PM, Dave Chinner wrote:
> > On Fri, Jan 31, 2020 at 08:20:37PM -0700, Allison Collins wrote:
> > > 
> > > 
> > > On 1/31/20 12:30 AM, Amir Goldstein wrote:
> > > > On Fri, Jan 31, 2020 at 7:25 AM Darrick J. Wong <darrick.wong@oracle.com> wrote:
> > > > > 
> > > > > Hi everyone,
> > > > > 
> > > > > I would like to discuss how to improve the process of shepherding code
> > > > > into the kernel to make it more enjoyable for maintainers, reviewers,
> > > > > and code authors.  Here is a brief summary of how we got here:
> > > > > 
> > > > > Years ago, XFS had one maintainer tending to all four key git repos
> > > > > (kernel, userspace, documentation, testing).  Like most subsystems, the
> > > > > maintainer did a lot of review and porting code between the kernel and
> > > > > userspace, though with help from others.
> > > > > 
> > > > > It turns out that this didn't scale very well, so we split the
> > > > > responsibilities into three maintainers.  Like most subsystems, the
> > > > > maintainers still did a lot of review and porting work, though with help
> > > > > from others.
> > > > > 
> > > > > It turns out that this system doesn't scale very well either.  Even with
> > > > > three maintainers sharing access to the git trees and working together
> > > > > to get reviews done, mailing list traffic has been trending upwards for
> > > > > years, and we still can't keep up.  I fear that many maintainers are
> > > > > burning out.  For XFS, the biggest pain point (AFAICT) is not assembly and
> > > > > testing of the git trees, but keeping up with the mail and the reviews.
> > > > > 
> > > > > So what do we do about this?  I think we (the XFS project, anyway)
> > > > > should increase the amount of organizing in our review process.  For
> > > > > large patchsets, I would like to improve informal communication about
> > > > > who the author might like to have conduct a review, who might be
> > > > > interested in conducting a review, estimates of how much time a reviewer
> > > > > has to spend on a patchset, and of course, feedback about how it went.
> > > > > This of course is to lay the groundwork for making a case to our bosses
> > > > > for growing our community, allocating time for reviews and for growing
> > > > > our skills as reviewers.
> > > > > 
> > > > 
> > > > Interesting.
> > > > 
> > > > Eryu usually posts a weekly status of xfstests review queue, often with
> > > > a call for reviewers, sometimes with specific patch series mentioned.
> > > > That helps me as a developer to monitor the status of my own work
> > > > and it helps me as a reviewer to put the efforts where the maintainer
> > > > needs me the most.
> > > > 
> > > > For xfs kernel patches, I can represent the voice of "new blood".
> > > > Getting new people to join the review effort is quite a hard barrier.
> > > > I have taken a few stabs at doing review for xfs patch series over the
> > > > year, but it mostly ends up feeling like it helped me (get to know xfs code
> > > > better) more than it helped the maintainer, because the chances of a
> > > > new reviewer to catch meaningful bugs are very low and if another reviewer
> > > > is going to go over the same patch series, the chances of new reviewer to
> > > > catch bugs that novice reviewer will not catch are extremely low.
> > > That sounds like a familiar experience.  Lots of times I'll start a review,
> > > but then someone else will finish it before I do, and catch more things
> > > along the way.  So I sort of feel like if it's not something I can get
> > > through quickly, then it's not a very good distribution of work effort and I
> > > should shift to something else. Most of the time, I'll study it until I feel
> > > like I understand what the person is trying to do, and I might catch stuff
> > > that appears like it may not align with that pursuit, but I don't
> > > necessarily feel I can deem it void of all unforeseen bugs.
> > 
> > I think you are both underselling yourselves. Imposter syndrome and
> > all that jazz.
> > 
> > The reality is that we don't need more people doing the sorts of
> > "how does this work with the rest of XFS" reviews that people like
> > Darricki or Christoph do. What we really need is more people looking
> > at whether loops are correctly terminated, the right variable types
> > are used, we don't have signed vs unsigned issues, 32 bit overflows,
> > use the right 32/64 bit division functions, the error handling logic
> > is correct, etc.
> > 
> > It's those sorts of little details that lead to most bugs, and
> > that's precisely the sort of thing that is typically missed by an
> > experienced developer doing a "is this the best possible
> > implemenation of this functionality" review.
> > 
> > A recent personal example: look at the review of Matthew Wilcox's
> > ->readahead() series that I recently did. I noticed problems in the
> > core change and the erofs and btfrs implementations not because I
> > knew anything about those filesystems, but because I was checking
> > whether the new loops iterated the pages in the page cache
> > correctly. i.e. all I was really looking at was variable counting
> > and loop initialisation and termination conditions. Experience tells
> > me this stuff is notoriously difficult to get right, so that's what
> > I looked at....
> > 
> > IOWs, you don't need to know anything about the subsystem to
> > perform such a useful review, and a lot of the time you won't find a
> > problem. But it's still a very useful review to perform, and in
> > doing so you've validated, to the best of your ability, that the
> > change is sound. Put simply:
> > 
> > 	"I've checked <all these things> and it looks good to me.
> > 
> > 	Reviewed-by: Joe Bloggs <joe@blogg.com>"
> > 
> > This is a very useful, valid review, regardless of whether you find
> > anything. It's also a method of review that you can use when you
> > have limited time - rather than trying to check everything and
> > spending hours on a pathset, pick one thing and get the entire
> > review done in 15 minutes. Then do the same thing for the next patch
> > set. You'll be surprised how many things you notice that aren't what
> > you are looking for when you do this.
> > 
> > Hence the fact that other people find (different) issues is
> > irrelevant - they'll be looking at different things to you, and
> > there may not even be any overlap in the focus/scope of the reviews
> > that have been performed. You may find the same things, but that is
> > also not a bad thing - I intentionally don't read other reviews
> > before I review a patch series, so that I don't taint my view of the
> > code before I look at it (e.g., darrick found a bug in this code, so
> > I don't need to look at it...).
> > 
> > IOWs, if you are starting from the premise that "I don't know this
> > code well enough to perform a useful review" then you are setting
> > yourself up for failure right at the start. Read the series
> > description, think about the change being made, use your experience
> > to answer the question "what's a mistake I could make performing
> > this change". Then go looking for that mistake through the
> > patch(es). In the process of performing this review, more than
> > likely, you'll notice bugs other than what you are actually looking
> > for...
> > 
> > This does not require any deep subsystem specific knowledge, but in
> > doing this sort of review you're going to notice things and learn
> > about the code and slowly build your knowledge and experience about
> > that subsystem.
> > 
> > > > However, there are quite a few cleanup and refactoring patch series,
> > > > especially on the xfs list, where a review from an "outsider" could still
> > > > be of value to the xfs community. OTOH, for xfs maintainer, those are
> > > > the easy patches to review, so is there a gain in offloading those reviews?
> > > > 
> > > > Bottom line - a report of the subsystem review queue status, call for
> > > > reviewers and highlighting specific areas in need of review is a good idea.
> > > > Developers responding to that report publicly with availability for review,
> > > > intention and expected time frame for taking on a review would be helpful
> > > > for both maintainers and potential reviewers.
> > > I definitely think that would help delegate review efforts a little more.
> > > That way it's clear what people are working on, and what still needs
> > > attention.
> > 
> > It is not the maintainer's repsonsibility to gather reviewers. That
> > is entirely the responsibility of the patch submitter. That is, if
> > the code has gone unreviewed, it is up to the submitter to find
> > people to review the code, not the maintainer. If you, as a
> > developer, are unable to find people willing to review your code
> > then it's a sign you haven't been reviewing enough code yourself.
> > 
> > Good reviewers are a valuable resource - as a developer I rely on
> > reviewers to get my code merged, so if I don't review code and
> > everyone else behaves the same way, how can I possibly get my code
> > merged? IOWs, review is something every developer should be spending
> > a significant chunk of their time on. IMO, if you are not spending
> > *at least* a whole day a week reviewing code, you're not actually
> > doing enough code review to allow other developers to be as
> > productive as you are.
> > 
> > The more you review other people's code, the more you learn about
> > the code and the more likely other people will be to review your
> > code because they know you'll review their code in turn.  It's a
> > positive reinforcement cycle that benefits both the individual
> > developers personally and the wider community.
> > 
> > But this positive reinforcemnt cycle just doesn't happen if people
> > avoid reviewing code because they think "I don't know anything so my
> > review is not going to be worth anything".  Constructive review, not
> > matter whether it's performed at a simple or complex level, is
> > always valuable.
> > 
> > Cheers,
> > 
> > Dave.
> > 
> Well, I can see the response is meant to be encouraging, and you are right
> that everyone needs to give to receive :-)
> 
> I have thought a lot about this, and I do have some opinions about it how
> the process is described to work vs how it ends up working though. There has
> quite been a few times I get conflicting reviews from multiple reviewers. I
> suspect either because reviewers are not seeing each others reviews, or
> because it is difficult for people to recall or even find discussions on
> prior revisions.  And so at times, I find myself puzzling a bit trying to
> extrapolate what the community as a whole really wants.

<and now jumping back in from the reply I sent to Neil Brown earlier...>

> For example: a reviewer may propose a minor change, perhaps a style change,
> and as long as it's not terrible I assume this is just how people are used
> to seeing things implemented.  So I amend it, and in the next revision
> someone expresses that they dislike it and makes a different proposition.
> Generally I'll mention that this change was requested, but if anyone feels
> particularly strongly about it, to please chime in.  Most of the time I
> don't hear anything, I suspect because either the first reviewer isn't
> around, or they don't have time to revisit it?

Definitely guilty of that here. :(

I've noticed that my own reviews decline in quality and coherency of
pickiness as the version count increases.  It's not easy to tell what's
the real difference between v2 and v3 of a series without git-am'ing
both series, building branches, and then git diffing the branches, and
that is /very/ time consuming.

I've really really wanted to be able to tell people to just send a pull
request for large series and skip all the email patch review stuff, but
I'm well aware that will start a popular revolt.  But maybe we can do
both?  Is it legit to ask that if you're sending more than a simple
quickfix, to please push a branch somewhere so that I can just yank it
down and have a look?  I try to do that with every series that I send, I
think Allison has been doing that, Christoph does it sometimes, etc.

> Maybe they weren't strongly
> opinionated about it to begin with?  It could have been they were feeling
> pressure to generate reviews, or maybe an employer is measuring their
> engagement?  In any case, if it goes around a third time, I'll usually start
> including links to prior reviews to try and get people on the same page, but
> most of the time I've found the result is that it just falls silent.

(And that's where we end up at this annoying thing of "Well the
reviewers don't agree, the maintainer notices the awkward silence, and
eventually gives in and 'resolves' the conflict by reading the whole
series...)

> At this point though it feels unclear to me if everyone is happy?  Did we
> have a constructive review?  Maybe it's not a very big deal and I should
> just move on.

Only you can't, unless the maintainer either pulls the patches or sends
back a forever-nak.  The whole process of shepherding code into the
kernel grinds to a halt because we can't agree on things like "two
function with similar argument lists or one function with flags?".

> And in many scenarios like the one above, the exact outcome
> appears to be of little concern to people in the greater scheme of things.
> But this pattern does not always scale well in all cases.  Complex issues
> that persist over time generally do so because no one yet has a clear idea
> of what a correct solution even looks like, or perhaps cannot agree on one.
> In my experience, getting people to come together on a common goal requires
> a sort of exploratory coding effort.

Ok, so there's this yearslong D** mess where we can't quite agree on how
the user interface should work.

TBH, I've wondered if we could reduce the amount of resistance to new
code and ABIs by making /every/ new ioctl and syscall announce itself as
EXPERIMENTAL for the first 6-9mo to give people time to prototype how
these things will work for real, and while we won't change the behavior
capriciously during that time, if we have to break things to prevent a
greater harm, we can do so without having to rev the whole interface.

I've also wished we had a better way to prototype new things in XFS
while not affecting the stable codebase, but various people have warned
me not to repeat the mistake of ext4dev. :/

> Like a prototype that people can look
> at, learn from, share ideas, and then adapt the model from there.  But for
> that to work, they need to have been engaged with the history of it.  They
> need the common experience of seeing what has worked and what hasn't.  It
> helps people to let go of theories that have not performed well in practice,
> and shift to alternate approaches that have.  In a way, reviewers that have
> been historically more involved with a particular effort start to become a
> little integral to it as its reviewers.  Which I *think* is what Darrick may
> be eluding to in his initial proposition.

Yes.

> People request for certain
> reviewers, or perhaps the reviewers can volunteer to be sort of assigned to
> it in an effort to provide more constructive reviews.  In this way,
> reviewers allocate their efforts where they are most effective, and in doing
> so better distribute the work load as well.  Did I get that about right?
> Thoughts?

And yes.  We of course have zero ability to coerce anyone to do things,
but at the same time, we're all collaborating to build something better,
and hoping that people organically decide to do things really doesn't
scale any more, given that we're burning out a second generation of
maintainers. :/

--D

> Allison
