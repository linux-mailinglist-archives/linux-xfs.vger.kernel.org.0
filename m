Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBC21527AA5
	for <lists+linux-xfs@lfdr.de>; Mon, 16 May 2022 00:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234952AbiEOWUU (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 15 May 2022 18:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbiEOWUT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 15 May 2022 18:20:19 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2F13C35DE3
        for <linux-xfs@vger.kernel.org>; Sun, 15 May 2022 15:20:14 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id F0823534663;
        Mon, 16 May 2022 08:20:11 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nqMaw-00CQad-Fp; Mon, 16 May 2022 08:20:10 +1000
Date:   Mon, 16 May 2022 08:20:10 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [ANNOUNCE] xfs: for-next tree updated to
 efd409a4329f6927795be5ae080cd3ec8c014f49
Message-ID: <20220515222010.GM1098723@dread.disaster.area>
References: <20220512060302.GI2306852@dread.disaster.area>
 <Yn7hn9i0Y9Iv1Xjd@magnolia>
 <YoFXYS4SwG/Nze+B@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoFXYS4SwG/Nze+B@magnolia>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=62817c9c
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=kj9zAlcOel0A:10 a=oZkIemNP1mAA:10 a=VwQbUJbxAAAA:8 a=JfrnYn6hAAAA:8
        a=7-415B0cAAAA:8 a=Qm9Vf2B2xTzmW6a72NgA:9 a=CjuIK1q_8ugA:10
        a=AjGcO6oz07-iQ99wixmX:22 a=1CNFftbPRP8L7MoqJWF3:22
        a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, May 15, 2022 at 12:41:21PM -0700, Darrick J. Wong wrote:
> On Fri, May 13, 2022 at 03:54:23PM -0700, Darrick J. Wong wrote:
> > On Thu, May 12, 2022 at 04:03:02PM +1000, Dave Chinner wrote:
> > > Hi folks,
> > > 
> > > I've just pushed out a new for-next branch for XFS. You can find it
> > > here:
> > > 
> > > git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git for-next
> > > 
> > > This update contains the new Logged Attribute Replay functionality
> > > that Allison has been toiling over for a very long time. She has
> > > completely restructured how the attribute code works to lay the
> > > ground work for functionality that require attributes to be
> > > manipulated as part of complex atomic operations. This update
> > > includes that functionality as a new experimental feature which can
> > > be turned on via sysfs knob.
> > > 
> > > Great work, Allison, and thank you for all your hard work and help
> > > during this merge window so we could get to this point!
> > 
> > Yay!!
> > 
> > I ran this on the fstests cloud overnight, and I noticed complaints from
> > xfs/434 that we're leaking xfs_da_state objects.  I turned on kmemleak
> > checking, which pointed out that the removexattr code path seems to be
> > attaching a da state to the xfs_attr_item structure and never freeing
> > it. 

Yes, I suspected that there were issues here from combining the two
paths - the fill/refill state sidelining changes the way dastate
paths were used for the removexattr path, and the original set-iter
path used da_state structures fundamentally differently to the
remove_iter path. So I'm not surprised that there's a leak somewhere
in there - KASAN/kmemleak testing was somethign I planned for this
week, but you've beaten me to turning it on....

> > I don't know if the delayed attrs state machine actually needs that
> > state as it runs through the remove states, but my dumb solution is to
> > free xfs_attr_item.xattri_da_state (if it's still attached) right before
> > we free the xfs_attr_item.

Yeah, I think it used to be freed at the equivalent of XFS_DAS_DONE
before the integration, so this isn't unreasonable.
`
> > I also noticed that the attri recovery code doesn't reject unknown bits
> > in the alfi_op_flags and alfi_attr_flags fields, so I added a couple of
> > fixpatches to abort log recovery if either of those fields have bits set
> > that we don't recognize.

*nod*

> > While I was poking around in there, I also found a few things that
> > should probably get cleaned up, such as the alfi_op_flags shouldn't be
> > in the XFS_ATTR_* namespace since higher level xattr code already uses
> > it.

Oh, you mean the name needs changing, not that there's something
wrong with the code?

> > Question: the alfi_attr_flags are really just the attr_filter flags from
> > the da_state structure, right?  I renamed the field and gave the flags
> > their own XFS_XATTRI_FILTER_* namespace.

I don't think that's correct. The filter flags contain the on-disk
namespace for the attribute we are operating on (XFS_ATTR_ROOT,
XFS_ATTR_SECURE, XFS_ATTR_PARENT, etc). It also contains the LOCAL
and INCOMPLETE flags, too, which aren't namespace bits but indicate
on-disk state of the xattr.

IOWs, they are already well known on-disk flags, and I don't think
adding a separate namespace for it improves anything - it's
confusing enough trying to work out how the INCOMPLETE flag
interacts with XFS_ATTR_NSP_ONDISK_MASK and attr_filter without
adding a whole new set of names for the same on-disk namespace
flags...

> > Moving along, I noticed that we weren't creating a separate slab cache
> > for xfs_attr_item intent items, like we (now) do for the other deferred
> > work items, so I modified the runtime paths to use a slab cache (the
> > mega-item created by recovery gets left alone) and rearranged the struct
> > to reduce its size from 96 to 88 bytes.  Now we can cram 46 items into a
> > memory page instead of 32!

Nice cleanup!

> > Also, I moved the attri and attrd log item cache initialization to
> > xfs_super.c to go with all the other log intent item cache
> > initializations, and renamed xfs_attr_item to xfs_attr_intent because
> > all the other high level deferred work state structures have type names
> > that end in _intent.

Ok. I've got "clean up subsystem init" in my notes here, sounds like
you've already done that. :)

> > > The other functionality in the merge is the removal of all the quota
> > > warning infrastructure. The has never been used on Linux and really
> > > has no way of being used, so these changes clean up and remove the
> > > remaining pieces we never will use.
> > 
> > AFAICT the only tests changes that were needed are to silence the EINVAL
> > returns when we try to set the quota warning counters in xfs/050,
> > xfs/153, and xfs/299.  Does that square with everyone else's
> > experiences?

Yeah, I think those are the only three. I'll run those patches
today.

> > > At this point in the cycle (almost at -rc7) I'm not going to merge
> > > any more new functionality. I'm planning to spend the next week:
> > > 
> > > - more thoroughly testing a wider range of configurations
> > > - recoveryloop soak testing
> > > - fixing up all the tests that now fail due to changes merged during
> > >   the cycle
> > > - addressing any regressions and failures that I find
> > 
> > I finally diagnosed the regressions I was seeing in xfs/314 and xfs/313
> > on aarch64 all throughout 5.18.

Yay!

> > Sooo ... willy (I hope) is soon to become the pagecache maintainer and
> > clearly disagrees[1] with the current XFS behavior of invalidating and
> > clearing uptodate on a folio on write error.  I /think/ we can finally
> > let go of this quirk of ours and make XFS behave just like any other
> > Linux filesystem, since (AFAICT) there isn't any downside to leaving the
> > folio uptodate and !dirty.

Sure, seems like the right time to make things more consistent with
the rest of the filesystem writeback path behaviours....

> > 
> > [1] https://lore.kernel.org/linux-xfs/Yg04X73lr5YK5kwH@casper.infradead.org/
> > 
> > If the program notices the EIO and redirties the file we go through the
> > same write paths as we did before; and if the program doesn't care, the
> > cached contents will remain in RAM until the folio is evicted or someone
> > dirties it again.  It's true that if nobody redirties the page then the
> > contents will be lost at some point, but that's already true.
> > 
> > I'm testing a patch that removes the part of iomap that clears uptodate
> > and the part of xfs that invalidates the folio.  We'll see how that
> > goes.

What happens to the delalloc extent backing the file offset the
failed folio covers?

> > > - preparing for an early pull request during the merge window
> > > 
> > > I know of one failure that still needs to be analysed when LARP is
> > > enabled - the new recovery test fails on 1kB block size filesystems
> > > here. Otherwise, I did not see any unexpected failures during
> > > overnight testing on default configs, rmapbt=1, all quotas enabled,
> > > 1kB block size or V4 only testing.
> > 
> > Hmm.  I don't test recoveryloop on 1k block filesystems, I guess I
> > should... :P  Aside from the handful of issues I laid out in this reply,
> > everything *else* seems pretty solid.  I haven't tried larp mode or
> > nrext64=1 mode yet though.
> 
> I turned on LARP mode Friday night and found a second da state leak and
> a kernel crash when relogging an xattri log item.
> 
> The da state leak happens under a setxattr call to replace an attr.  I
> think what's going on is that _attr_set_iter finds the old name and
> removes it without freeing the da state structure.

Yeah, that'll probably be the same leak as the removexattr you've
already seen, as replace recovery starts with a remove...

> Once we roll to
> NODE_ADD state, we call xfs_attr_node_addname_find_attr to (re)compute
> the location of the new attr in the node-format structure without
> freeing the old da state structure, so that just leaks.

*nod*

> The crash seems to be happening when we have a long chain of xattr work
> racing with another thread making changes elsewhere and flushing the
> log.  At the start of the delayed attr work, we log an xattri log item,
> with the caller's name and value buffers attached.  When the CIL
> commits, we use those buffers to format the log item, and ->iop_commit
> sets the pointers to NULL.  At this point the other thread(s) manage to
> write to and flush the log enough times that we end up in a new
> checkpoint.  Seeing this, the deferred work manager makes the xattr
> writer relog the xattri log item.  The _relog method tries to memcpy the
> name and value into a new buffer, but crashes because we already nulled
> out the pointers, and kaboom.

I haven't see that one. As I went over the attr intent logging, I
thought that it needed to be rewritten to use a reference counted
name/value buffer so that we could elide all the extra CIL shadow
buffer allocation and copying that is done every time we roll the
xattr transaction and create a new intent. I was looking at this
more from an efficiency POV (reduced CPU/memory cost per large xattr
logged) than a correctness POV, but I suspected there might be
correctness issues there as well.

My tentative plan is that we allocate the buffer structure when the
attri does right now, but we modify the log iovec copy routinues to
be able to take a stable buffer by reference instead of copying it.
That way it can propagate into the CIL and it doesn't need to null
any pointers - when the CIL releases the intent item, it just drops
the reference on the name/val structure.

That way the same name/value structure is used repeatedly instead of
repeated alloc/copy/free, and it's life time is bound by the
first/last reference rather than a specific execution context as it
is now with the xattrip.

> I'm not sure how to fix that -- if nobody flushes the log, the attri
> items can stick around in memory until the CIL is being committed,
> right?  But that could be long after the original writer thread has
> returned to userspace, which means that (a) we can't just not drop the
> name/value buffer pointers from the xattr_log_item structure at commit
> time so that relog works, and (b) I think implies UAF bugs during log
> item formatting, perhaps?

Yeah, I think you might be right. I hadn't looked quite that deeply
into this code. I have notes that say "we need to reduce the
overhead of this" and I'm sure as soon as I started on that I'd
notice the issues that you've already uncovered.

That said, I don't think this is essential to fix for the upcoming
merge window because the experimental tag is intended to allow us
time to discover and fix these sorts of unexpected problems that
wider use and testing will uncover.

> <shrug> It's still the weekend here, so that's just my idul
> speculations.  I'm running the fixpatches through fstests one more time
> before I start sending them to the list.

Thanks!

-Dave.
-- 
Dave Chinner
david@fromorbit.com
