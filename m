Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8D987D8C9B
	for <lists+linux-xfs@lfdr.de>; Fri, 27 Oct 2023 02:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbjJ0AnN (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 26 Oct 2023 20:43:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjJ0AnN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 26 Oct 2023 20:43:13 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C381C1B5
        for <linux-xfs@vger.kernel.org>; Thu, 26 Oct 2023 17:43:10 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E5F1C433C7;
        Fri, 27 Oct 2023 00:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698367390;
        bh=YHl6A6nYFt/HwJClw2voRRbSORwcF5afuZ372Ntv4U0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jn4HZWXXpyXOWmr/hIvBJH/yvCwFOvzwTkwOYhxdHaHvFfFqQWeKA/qpLNDfh8E0d
         eqa52uU1SlMY9D0UOQjJvxiKn8DAiFR8syWqeAn77COJjSkhKX2m09gb/s+MkG7fKY
         Zpu4I59kLOH3p//XPVnOxeKXq+s59m1PvUyQEThUMT5wBtLyz7nG8469x7fz3RstJs
         K8klTEhS+D7RLCuXIwuk/4xQkS69jfBf3xyuV6q4j4cbENYNB6fTB1Fz61esBAV3w8
         IFRdDeZLIpOJdPfwQpQdz0K0zqC0XFhh8nT76PvGmYQtDltCdjuQlr0GAeXV4nu9FD
         rsYKJ7tz8Lflg==
Date:   Thu, 26 Oct 2023 17:43:09 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christian Brauner <brauner@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Shirley Ma <shirley.ma@oracle.com>, hch@lst.de,
        jstancek@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [GIT PULL] iomap: bug fixes for 6.6-rc7
Message-ID: <20231027004309.GK3195650@frogsfrogsfrogs>
References: <169786962623.1265253.5321166241579915281.stg-ugh@frogsfrogsfrogs>
 <CAHk-=whNsCXwidLvx8u_JBH91=Z5EFw9FVj57HQ51P7uWs4yGQ@mail.gmail.com>
 <20231023223810.GW3195650@frogsfrogsfrogs>
 <20231024-flora-gerodet-8ec178f87fe9@brauner>
 <20231026031325.GH3195650@frogsfrogsfrogs>
 <20231026-gehofft-vorfreude-a5079bff7373@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231026-gehofft-vorfreude-a5079bff7373@brauner>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 26, 2023 at 01:54:29PM +0200, Christian Brauner wrote:
> On Wed, Oct 25, 2023 at 08:13:25PM -0700, Darrick J. Wong wrote:
> > On Tue, Oct 24, 2023 at 01:47:17PM +0200, Christian Brauner wrote:
> > > On Mon, Oct 23, 2023 at 03:38:10PM -0700, Darrick J. Wong wrote:
> > > > On Sat, Oct 21, 2023 at 09:46:35AM -0700, Linus Torvalds wrote:
> > > > > On Fri, 20 Oct 2023 at 23:27, Darrick J. Wong <djwong@kernel.org> wrote:
> > > > > >
> > > > > > Please pull this branch with changes for iomap for 6.6-rc7.
> > > > > >
> > > > > > As usual, I did a test-merge with the main upstream branch as of a few
> > > > > > minutes ago, and didn't see any conflicts.  Please let me know if you
> > > > > > encounter any problems.
> > > > > 
> > > > > .. and as usual, the branch you point to does not actually exist.
> > > > > 
> > > > > Because you *again* pointed to the wrong tree.
> > > > > 
> > > > > This time I remembered what the mistake was last time, and picked out
> > > > > the right tree by hand, but *please* just fix your completely broken
> > > > > scripts or workflow.
> > > > > 
> > > > > > https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git iomap-6.6-fixes-5
> > > > > 
> > > > > No.
> > > > > 
> > > > > It's pub/scm/fs/xfs/xfs-linux, once again.
> > > > 
> > > > Sorry about that.  After reviewing the output of git request-pull, I
> > > > have learned that if you provide a $url argument that does not point to
> > > > a repo containing $start, it will print a warning to stderr and emit a
> > > > garbage pull request to stdout anyway.  No --force required or anything.
> > > > Piping stdout to mutt without checking the return code is therefore a
> > > > bad idea.
> > > > 
> > > > I have now updated my wrapper script to buffer the entire pull request
> > > > contents and check the return value before proceeding.
> > > > 
> > > > It is a poor workman who blames his tools, so I declare publicly that
> > > > you have an idiot for a maintainer.
> > > > 
> > > > Christian: Do you have the bandwidth to take over fs/iomap/?
> > > 
> > > If this helps you I will take iomap over but only if you and Christoph
> > > stay around as main reviewers.
> > 
> > I can't speak for Christoph, but I am very much willing to continue
> > developing patches for fs/iomap, running the QA farm to make sure it's
> > working properly, and reviewing everyone else's patches.  Same as I do
> > now.
> > 
> > What I would like to concentrate on in the future are:
> > 
> > (a) improving documentation and cleanups that other fs maintainers have
> >     been asking for and I haven't had time to work on
> > 
> > (b) helping interested fs maintainers port their fs to iomap for better
> >     performance
> > 
> > (c) figuring out how to integrate smoothly with things like fsverity and
> >     fscrypt
> > 
> > (d) not stepping on *your* toes every time you want to change something
> >     in the vfs only to have it collide with iomap changes that you
> >     didn't see
> > 
> > Similar to what we just did with XFS, I propose breaking up the iomap
> > Maintainer role into pieces that are more manageable by a single person.
> 
> Sounds good.
> 
> > As RM, all you'd have to do is integrate reviewed patches and pull
> > requests into one of your work branches.  That gives you final say over
> > what goes in and how it goes in, instead of letting branches collide in
> > for-next without warning.
> > 
> > You can still forward on the review requests and bug reports to me.
> 
> Ok, cool.
> 
> > That part isn't changing.  I've enjoyed working with you and hope
> > that'll continue well into the future. :)
> 
> Thanks. That's good to hear and right back at you.

Thank you!  I enjoyed reading that! :)

> > 
> > > There's not much point in me pretending I
> > > can meaningfully review fs/iomap/ and I don't have the bandwith even if
> > > I could. So not without clear reviewers.
> > 
> > I hope the above assuades your concerns/fears!
> 
> Yes.
> 
> > 
> > > But, - and I'm sorry if I may overstep bounds a little bit - I think
> > > this self-castigation is really unwarranted. And we all very much know
> > > that you definitely aren't an idiot. And personally I think we shouldn't
> > > give the impression that we expect this sort of repentance when we make
> > > mistakes.
> > > 
> > > In other words, if the sole reason you're proposing this is an
> > > objectively false belief then I would suggest to reconsider.
> > 
> > Quite the opposite, these are changes that I've been wanting to make for
> > months. :)
> 
> In that case I would propose you send a patch to Linus for MAINTAINERS
> updating the tree and the entries for iomap. I believe it's customary
> for the current maintainer to do this.

Will do.  I'll change the M: entry to you, and add myself as an R:.

--D

> 
> Thanks!
> Christian
