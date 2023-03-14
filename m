Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB886B8866
	for <lists+linux-xfs@lfdr.de>; Tue, 14 Mar 2023 03:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbjCNCVM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 13 Mar 2023 22:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjCNCVL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Mar 2023 22:21:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D30794F47
        for <linux-xfs@vger.kernel.org>; Mon, 13 Mar 2023 19:20:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 827ABB81642
        for <linux-xfs@vger.kernel.org>; Tue, 14 Mar 2023 02:20:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2496AC433D2;
        Tue, 14 Mar 2023 02:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678760436;
        bh=PESrnRqi0MYp1bi39Pq8lMO61Uz/0R8HJjUNg1pJl4M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e1MoK211DNIRO8zLnLeCyfDFbowhy6WifS9CEplRWgmxWZAsZzvWodC3za2UqZ0TB
         O8Q/3ynN3peCLEIPGwJCAClqZqXte1GF4TgzIp1SStIbnZx4JMop6uoKkkgWUHe7Yp
         F4dLinaDSOIN3f4XRkmLa+TpO2AHojV4qZ/TeazkTC5JcXAS01o8Z6o4MephoFY4ac
         YfoJO7ICkKx4iMvUpn7r5ZyWwkaAn+eNZx0Qfbte3/JFJG80re1JSN6kq/RiXGughV
         DdMSmVH6S87KVMuMrAAZROLyHhbaWpjBTKFDHU/DgK0vCyptbJrlOZgQi0J+jEAOv5
         2iD+GgVDi/FgQ==
Date:   Mon, 13 Mar 2023 19:20:35 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Allison Henderson <allison.henderson@oracle.com>
Cc:     "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Subject: Re: [RFC DELUGE v9r2d1] xfs: Parent Pointers
Message-ID: <20230314022035.GA11376@frogsfrogsfrogs>
References: <Y+6MxEgswrJMUNOI@magnolia>
 <8a65fba38b8a8f9167f27f2a2d6151c8d84bfa61.camel@oracle.com>
 <Y/gmTwva2hW0ydCb@magnolia>
 <839f853f7c7c6ac5b92ceca8afaf68589ac15d2c.camel@oracle.com>
 <Y/6pRWoZiXmf5OLV@magnolia>
 <02febe3626d49e2d9529d800263de4f6a19da73b.camel@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <02febe3626d49e2d9529d800263de4f6a19da73b.camel@oracle.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Mar 08, 2023 at 10:47:30PM +0000, Allison Henderson wrote:
> On Tue, 2023-02-28 at 17:24 -0800, Darrick J. Wong wrote:
> > On Sat, Feb 25, 2023 at 07:34:14AM +0000, Allison Henderson wrote:
> > > On Thu, 2023-02-23 at 18:51 -0800, Darrick J. Wong wrote:
> > > > On Fri, Feb 17, 2023 at 08:02:29PM +0000, Allison Henderson
> > > > wrote:
> > > > > On Thu, 2023-02-16 at 12:06 -0800, Darrick J. Wong wrote:
> > > > > > Hi everyone,
> > > > > > 
> > > > > > This deluge contains all of the additions to the parent
> > > > > > pointers
> > > > > > patchset that I've been working on for the past month.� The
> > > > > > kernel
> > > > > > and
> > > > > > xfsprogs patchsets are based on Allison's v9r2 tag from last
> > > > > > week;
> > > > > > the fstests patches are merely a part of my development
> > > > > > tree.� To
> > > > > > recap
> > > > 
> > > > <snip>
> > > > 
> > > > > Ermergersh, thats a lot!� Thanks for all the hard work.� I feel
> > > > > like if
> > > > > we don't come up with a plan for review though, people may not
> > > > > know
> > > > > where to start for these deluges!� Lets see... if we had to
> > > > > break
> > > > > this
> > > > > down, I think would divide it up between the existing parent
> > > > > pointers
> > > > > and the new pptr propositions for ofsck.
> > > > 
> > > > That's a good place to cleave.
> > > > 
> > > > > Then further divide it among
> > > > > kernel space, user space and test case.� If I had to pick only
> > > > > one
> > > > > of
> > > > > these to focus attention on, probably it should be new ofsck
> > > > > changes in
> > > > > the kernel space, since the rest of the deluge is really
> > > > > contingent
> > > > > on
> > > > > it. 
> > > > 
> > > > Yup.� Though you ought to read through the offline fsck patches
> > > > too.
> > > > Those take a very different approach to resolving parent
> > > > pointers.�
> > > > So
> > > > much of repair is based on nuking directories that I don't know
> > > > there's
> > > > a good way to rebuild them from parent pointers.
> > > Ok, will take a look
> > > 
> > > > 
> > > > A thought I had was that when we decide to zap a directory due to
> > > > problems in the directory blocks themselves, we could them
> > > > initiate a
> > > > scan of the parent pointers to try to find all the dirents we
> > > > can.� I
> > > > ran into problems with that approach because libxfs_iget
> > > > allocates
> > > > fresh
> > > > xfs_inode objects (instead of caching and sharing them like the
> > > > kernel
> > > > does) and that made it really hard to scan things in a coherent
> > > > manner.
> > > > 
> > > > > So now we've narrowed this down to a few subsets:
> > > > > 
> > > > > [PATCHSET v9r2d1 0/3] xfs: bug fixes for parent pointers
> > > > > [PATCHSET v9r2d1 0/4] xfs: rework the GETPARENTS ioctl,
> > > > 
> > > > If you read through these two patchsets and think they're ok,
> > > > then
> > > > either fold the fixes into the main series or tack them on the
> > > > end,
> > > > whichever is easier.��
> > > ok, I'll take a look, I'll probably tack the first 2 fixes since
> > > they
> > > dont seat into an existing patch in the set.
> > 
> > Ok.
> > 
> > > > If you tack them on the end, please add your
> > > > own SOB tags.
> > > 
> > > Sure?� I SOB'd the last 2 patches of the set in v3, and then you
> > > said
> > > to make it an RVB
> > 
> > Er... SOB, RVB, whichever tag(s) get us to a patch that has a signoff
> > and a review. :)
> > 
> > > > 
> > > > > [PATCHSET v9r2d1 00/23] xfs: online fsck support patches
> > > > > [PATCHSET v9r2d1 0/7] xfs: online repair of directories
> > > > > [PATCHSET v9r2d1 0/2] xfs: online checking of parent pointers
> > > > > [PATCHSET v9r2d1 0/3] xfs: online checking of parent pointers
> > > > > [PATCHSET v9r2d1 0/2] xfs: online checking of directories
> > > > 
> > > > The fsck functionality exists to prove the point that directory
> > > > repair
> > > > is /very/ awkward if we have to update p_diroffset.� As such,
> > > > they
> > > > focused on getting the main parts right ... but with the obvious
> > > > problem of making pptrs dependent on online fsck part 1 getting
> > > > merged.
> > > > 
> > > > Speaking of which -- can we merge online fsck for 6.4?� Please?
> > > > :)
> > > I'm fine with it as long as everyone else is?� I'm not sure who
> > > this is
> > > directed to.
> > 
> > 10% dchinner, 90% anyone we don't know about who might swoop in at
> > the
> > last minute and NAK it. ;)
> > 
> > > I admittedly haven't been able to work through all of it,
> > > but I don't think anyone has.� I don't know that exhaustive
> > > reviewing
> > > as a whole is particularly effective though.� Back when the
> > > combined
> > > set of "attr refactoring" + "larp" + "parent pointers" was
> > > particularly
> > > large, I used to just send out subsets that I thought were more
> > > reasonable for people digest.� That way people can look at the
> > > giant
> > > mega-set if they really gotta see it, but it kept the reviews more
> > > focused on a sort of smaller next step.
> > 
> > TBH every time I went to look at all that, I pulled your github
> > branch
> > and looked at the whole thing.� I paid more attention to whatever was
> > being reviewed on-list, obviously.� That said, after about the fifth
> > round of looking at a patchset I start feeling like I'm only going to
> > increase my knowledge of the code by using it to write something.� At
> > that point it's easier to convince me to merge it, or at least to
> > fling
> > it at fstestscloud.
> > 
> > > 
> > > > 
> > > > > [PATCHSET v9r2d1 0/5] xfs: encode parent pointer name in xattr
> > > > > key
> > > > 
> > > > Resolving the questions presented by this series is critical to
> > > > nailing
> > > > down the ondisk format and merging the feature.� But we'll get to
> > > > that
> > > > below.
> > > > 
> > > > > [PATCHSET v9r2d1 0/3] xfs: use flex arrays for
> > > > > XFS_IOC_GETPARENTS,
> > > > 
> > > > I'd like to know what you think about converting the ioctl
> > > > definition
> > > > to
> > > > flex arrays instead of the fixed size structs.� I'm not sure
> > > > where to
> > > > put this series, though.� If you decide that you want 'em, then
> > > > ideally
> > > > they'd be in xfs_fs.h from the introduction of
> > > > XFS_IOC_GETPARENTS,
> > > > but
> > > > I don't see any point in backporting them around "xfs: rework the
> > > > GETPARENTS ioctl".
> > > > 
> > > > (I would be ok if you rolled all of it into patch 25 from the
> > > > original
> > > > v9 set.)
> > > I'll take a look at it, I didnt put a whole lot of focus on the
> > > ioctl
> > > initially because the only thing that was using it at the time was
> > > the
> > > test case, and I wanted to keep attention more on the
> > > infrastructure.
> > 
> > <nod> I only started looking at it because I started pounding on it
> > with
> > xfs_scrub and noticed problems. :D
> Just an fyi, I thought the flex arrays are fine, but it had some
> conflicts moving to the bottom of the set, so I just ended up re-doing
> it directly in the existing parent pointers ioctl patch.  If possible,
> next time put the renames and clean ups after the functional changes,
> and that should help them move around a bit easier. Thanks!

Ok, I'll try to keep things cleaner when I rebase against v10.  TBH I
had decided that the ioctl changes were something I could put off until
after I'd written repair, so that's why they landed where they did.
For future reference, if there's a patchset of mine that you want to
merge and want me to reorder it to make your life easier, I'm open to
doing that.

Last week I got bogged down in 6.3 problems, and then discovered that my
new name-value xattr lookup code didn't quite work right with log
recovery, so it's only today that I (think) I'm ready to call my own
work on parent pointers done.

(I'm definitely going to have to figure out how to grind out all the
sha512 stuff that was in the v9r2d1 deluge.)

--D

> Allison
> 
> > 
> > > > 
> > > > > Of those, I think "xfs: encode parent pointer name in xattr
> > > > > key" is
> > > > > the
> > > > > only one that might impact other features since it's changeing
> > > > > the
> > > > > ondisk format from when we first started the effort years ago.�
> > > > > So
> > > > > probably that might be the best place for people to start since
> > > > > if
> > > > > this
> > > > > needs to change it might impact some of the other subsets in
> > > > > the
> > > > > deluge, or even features they are working on if they've based
> > > > > anything
> > > > > on the existing pptr set.
> > > > 
> > > > Bingo!
> > > > 
> > > > The biggest question about the format change is (IMHO) whether
> > > > we're
> > > > ok
> > > > with using a hash function for parent pointer names that don't
> > > > fit in
> > > > the attr key space, and which hash?
> > > > 
> > > > The sha2 family was designed to be collision resistant, but I
> > > > don't
> > > > anticipate that will last forever.� The hash is computed from
> > > > (the
> > > > full
> > > > name and the child generation number) when the dirent name is
> > > > longer
> > > > than 243 bytes.� The first 179 bytes of the dirent name are still
> > > > written in the parent pointer attr name.� An attacker would have
> > > > to
> > > > find
> > > > a collision that only changes the last 76 bytes of the dirent
> > > > name,
> > > > and
> > > > they'd have to know the generation number at runtime.
> > > > 
> > > > (Note: dirent names shorter than 243 bytes are written directly
> > > > into
> > > > the
> > > > parent pointer xattr name, no hashing required.)
> > > > 
> > > > I /think/ that's good enough, but I'm no cryptanalyst.� The
> > > > alternative
> > > > would be to change the xattr format so that the namelen field in
> > > > the
> > > > leaf structure to encode *only* the name component of the parent
> > > > pointer.� This would lead to a lot of special cased xattr code
> > > > and
> > > > probably a lot of bugs and other stupid problems, which is why I
> > > > didn't
> > > > take that route.
> > > > 
> > > > Thoughts?
> > > 
> > > Hmm, well, it sounds like a risk to be weighed.� It wouldn't happen
> > > very often.� It seems like it would be extremely rare.� But when it
> > > does it will likely be quite unpleasant.� 
> > > 
> > > I think another question to ask would be how often does the parent
> > > pointer really need to be updated in a repair?� In most cases, an
> > > orphaned inode will likely be able to return to the dirofset from
> > > whence it came.� So an update may be unlikely.� Even more so would
> > > be
> > > the worst case of needing to update crazy amounts of parent
> > > pointers. 
> > > So� another option is to simply pick a cap and error out if the
> > > demand
> > > is too much.� Likely if this condition does arise, there's probably
> > > bigger issues going on.
> > > 
> > > While option A is substantially more rare than option B, you could
> > > probably pick either one and rarely encounter the error path.�
> > > While
> > > option A does have the advantage of being more memory conservative,
> > > it
> > > has the disadvantage of possibly being a really ugly sleeping bug. 
> > > While option B might error out when option A would have not, it
> > > would
> > > at least be clear as to why it did, and probably elude to the
> > > presence
> > > of bigger problems, such as an internal bug that we should probably
> > > go
> > > catch, or perhaps something external corrupting the fs image, which
> > > ofsck may not be able to solve anyway.� 
> > > 
> > > FWIW I seem to recall running across the idea of using hashes as
> > > keys
> > > in other projects I've been on, and most of the time the rarity of
> > > the
> > > collision was considered an acceptable risk, though it's really
> > > about
> > > which risk really bothers you more.
> > 
> > I want to study sha2 hash collisions and/or how the xattr code
> > stumbles
> > over attrs with the same dahash first.� Dealing with colliding xattr
> > names might not be as painful for the parent pointer code as I'm
> > currently thinking.
> > 
> > > > 
> > > > > I feel like a 5 patch subset is a very reasonable thing to ask
> > > > > people
> > > > > to give their attention to.� That way they dont get lost in
> > > > > things
> > > > > like
> > > > > nits for optimizations that might not even matter if something
> > > > > it
> > > > > depends on changes.
> > > > > 
> > > > > For the most part I am ok with changeing the format as long as
> > > > > everyone
> > > > > is aware and in agreement so that we dont get caught up re-
> > > > > coding
> > > > > efforts that seem to have stuggled with disagreements now on
> > > > > the
> > > > > scale
> > > > > of decades.� Some of these patches were already very old by the
> > > > > time I
> > > > > got them!
> > > > 
> > > > Hheehhe.� Same here -- rmap was pretty old by the time I started
> > > > pushing
> > > > that for reals. :)
> > > > 
> > > > > On a side note, there are some preliminary patches of kernel
> > > > > side
> > > > > parent pointers that are either larp fixes or refactoring not
> > > > > sensitive
> > > > > to the proposed ofsck changes.� These patches a have been
> > > > > floating
> > > > > around for a while now, so if no one has any gripes, I think
> > > > > just
> > > > > merging those would help cut down the amount of rebaseing, user
> > > > > space
> > > > > porting and patch reviewing that goes on for every version.�
> > > > > (maybe
> > > > > the
> > > > > first 1 though 7 of the 28 patch set, if folks are ok with
> > > > > that)
> > > > 
> > > > I thought about doing that for 6.3, but I found enough bugs in
> > > > the
> > > > locking stuff (recall the first bugfix series) that I held back.�
> > > > I'm
> > > > not sure about the two "Increase <blah>" patches -- they'll bloat
> > > > kernel
> > > > structures without a real user for them.
> > > 
> > > I don't think the first 7 are order sensitive, we should be able to
> > > do
> > > just 1, 4, 5, 6 and 7.
> > 
> > OH.
> > 
> > > > 
> > > > <shrug>
> > > > 
> > > > > I think the shear size of some of these sets tend to work
> > > > > against
> > > > > them,
> > > > > as people likely cannot afford the time block they present on
> > > > > the
> > > > > surface.
> > > > 
> > > > Agreed.� At this point, I've worked through enough of the parent
> > > > pointers code to understand what's going on that I'm ok with
> > > > merging
> > > > it
> > > > once we settle the above question.
> > > > 
> > > > FWIW the whole series (kernel+xfsprogs+fstests) has been passing
> > > > my
> > > > nightly QA farm for a couple of weeks now despite my constant
> > > > hammering
> > > > on it, so I think the implementation is ready.
> > > > 
> > > > > So I think we would do well to find a way to introduce them
> > > > > at a reasonable pace and keep attention focused on the
> > > > > subsections
> > > > > that
> > > > > should require more than others, and hopefully keep thing
> > > > > moving in
> > > > > a
> > > > > progressive direction.
> > > > 
> > > > I disagree -- I want to merge online fsck part 1 so I can get
> > > > that
> > > > out
> > > > of my dev trees.� Then I want to focus on getting this over the
> > > > finish
> > > > line and merged.� But then I'm not known for incrementalism. :P
> > > Well, I notice people respond better to subsets in smaller doses
> > > though.� And then it gives the preliminary patches time to
> > > stabilize if
> > > people do find an issue.
> > 
> > <nod> I'll keep that in mind.
> > 
> > --D
> > 
> > > > 
> > > > --D
> > > > 
> > > > > Thx!
> > > > > Allison
> > > > > 
> > > 
> 
