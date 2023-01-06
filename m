Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8711265FA57
	for <lists+linux-xfs@lfdr.de>; Fri,  6 Jan 2023 04:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231702AbjAFDdS (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 5 Jan 2023 22:33:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231839AbjAFDdO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Jan 2023 22:33:14 -0500
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6036A0CA;
        Thu,  5 Jan 2023 19:33:13 -0800 (PST)
Received: by mail-vs1-xe2d.google.com with SMTP id k4so388149vsc.4;
        Thu, 05 Jan 2023 19:33:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PZ4t6exQ8ZmRl4sMNTpOmrreqBEpetWbWIflXGVD0cg=;
        b=jfuEDwSIfQtIFOAXGKU0pfWG9TyK/SrXwX4esX7NwyPz5JBVhCKlHBiWNNCcrzEKzZ
         ulm8sBuzYcZ4Y781Bt8ND0SZ6JWIBWWMphKepVQnp7J7tvQvgJQmYn9jpuEQ5eEXByf9
         /uZEaJ6N3YP78/Yrfpo78wzMa2JrPR9GoYLvTIsR70eTYKRCGBKOwbU1sivb9Sv5fbb5
         dsET819ultrlO6yl24thdpaTw3sgkwV4QI9Jfj64vEuNnMJugbMNQlEcww8w0+dx+0E9
         c1W5IV91LcP+BjFxRqlQUKoNT/cy/hYhQJuRFGbQtT9V27YGM15qPumvHGfdVluuUaFY
         u4Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PZ4t6exQ8ZmRl4sMNTpOmrreqBEpetWbWIflXGVD0cg=;
        b=2LD75vQW54KgOgZgTiSlwHlR6xeRnrJmdji59bMSzKAD83kBaautuXTBehoSXcvLqE
         6JfT4qmL6M/uxSzeyCm21IJ9ea5jlNRBi5UNizMOekbQkOdLo81xrx7G6YYmWHHFkee+
         +0A7XGofIXW0PIjHJ7BFlSN8ZXYl29pRXb2THJHQEWiyPLIYtekKFdvXKzJHeTL84YrO
         AyQYXpdnFWFMWOyUz1loqwmYmBDfBKtPX916miKBuvlanqlQpisHP8DLzIO++jRC3PDk
         2RqkIML0mhtHYBxqfUOyTTpP8soNUgMlzsdummupM4QvQmsi8i4Z/Muo7jCbvbf4ZpZ/
         2N1g==
X-Gm-Message-State: AFqh2krKtv7IuDR5rSWDbtPOY1u8UTz5CcnKf5J1M3UdvpKy/HjaHOmO
        KBDWp++1UOXx2lVp2dJ9u9RqDkRoTJbK4YCNa7TYN9VcuPE=
X-Google-Smtp-Source: AMrXdXvhIQj2XXzcrybAtSJzjKT0Mt9ji6N5+wVJGJp4iYuUFD6l0KGeujBzU7caqH+k35IHyyi16WTwr3mbCBSUx/Y=
X-Received: by 2002:a05:6102:32d6:b0:3b5:3bd5:2a78 with SMTP id
 o22-20020a05610232d600b003b53bd52a78mr6516994vss.3.1672975992021; Thu, 05 Jan
 2023 19:33:12 -0800 (PST)
MIME-Version: 1.0
References: <167243825144.682859.12802259329489258661.stgit@magnolia>
 <167243825245.682859.4827095718073568782.stgit@magnolia> <CAOQ4uxgqYCXi_c3PA8d0vVaaicGU=D9kvsR5fo9eb_89L0Y6PA@mail.gmail.com>
 <Y7cns4x+lJuAKIXj@magnolia>
In-Reply-To: <Y7cns4x+lJuAKIXj@magnolia>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 6 Jan 2023 05:33:00 +0200
Message-ID: <CAOQ4uxgEYuKqicCjf-3AijVyoCHsaCErXJghMg3=iDom=bshVA@mail.gmail.com>
Subject: Re: [PATCH 06/14] xfs: document how online fsck deals with eventual consistency
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, willy@infradead.org,
        chandan.babu@oracle.com, allison.henderson@oracle.com,
        linux-fsdevel@vger.kernel.org, hch@infradead.org,
        catherine.hoang@oracle.com, david@fromorbit.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jan 5, 2023 at 9:40 PM Darrick J. Wong <djwong@kernel.org> wrote:
>
> On Thu, Jan 05, 2023 at 11:08:51AM +0200, Amir Goldstein wrote:
> > On Sat, Dec 31, 2022 at 12:32 AM Darrick J. Wong <djwong@kernel.org> wrote:
> > >
> > > From: Darrick J. Wong <djwong@kernel.org>
> > >
> > > Writes to an XFS filesystem employ an eventual consistency update model
> > > to break up complex multistep metadata updates into small chained
> > > transactions.  This is generally good for performance and scalability
> > > because XFS doesn't need to prepare for enormous transactions, but it
> > > also means that online fsck must be careful not to attempt a fsck action
> > > unless it can be shown that there are no other threads processing a
> > > transaction chain.  This part of the design documentation covers the
> > > thinking behind the consistency model and how scrub deals with it.
> > >
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  .../filesystems/xfs-online-fsck-design.rst         |  303 ++++++++++++++++++++
> > >  1 file changed, 303 insertions(+)
> > >
> > >
> > > diff --git a/Documentation/filesystems/xfs-online-fsck-design.rst b/Documentation/filesystems/xfs-online-fsck-design.rst
> > > index f45bf97fa9c4..419eb54ee200 100644
> > > --- a/Documentation/filesystems/xfs-online-fsck-design.rst
> > > +++ b/Documentation/filesystems/xfs-online-fsck-design.rst
> > > @@ -1443,3 +1443,306 @@ This step is critical for enabling system administrator to monitor the status
> > >  of the filesystem and the progress of any repairs.
> > >  For developers, it is a useful means to judge the efficacy of error detection
> > >  and correction in the online and offline checking tools.
> > > +
> > > +Eventual Consistency vs. Online Fsck
> > > +------------------------------------
> > > +
> > > +Midway through the development of online scrubbing, the fsstress tests
> > > +uncovered a misinteraction between online fsck and compound transaction chains
> > > +created by other writer threads that resulted in false reports of metadata
> > > +inconsistency.
> > > +The root cause of these reports is the eventual consistency model introduced by
> > > +the expansion of deferred work items and compound transaction chains when
> > > +reverse mapping and reflink were introduced.
> > > +
> > > +Originally, transaction chains were added to XFS to avoid deadlocks when
> > > +unmapping space from files.
> > > +Deadlock avoidance rules require that AGs only be locked in increasing order,
> > > +which makes it impossible (say) to use a single transaction to free a space
> > > +extent in AG 7 and then try to free a now superfluous block mapping btree block
> > > +in AG 3.
> > > +To avoid these kinds of deadlocks, XFS creates Extent Freeing Intent (EFI) log
> > > +items to commit to freeing some space in one transaction while deferring the
> > > +actual metadata updates to a fresh transaction.
> > > +The transaction sequence looks like this:
> > > +
> > > +1. The first transaction contains a physical update to the file's block mapping
> > > +   structures to remove the mapping from the btree blocks.
> > > +   It then attaches to the in-memory transaction an action item to schedule
> > > +   deferred freeing of space.
> > > +   Concretely, each transaction maintains a list of ``struct
> > > +   xfs_defer_pending`` objects, each of which maintains a list of ``struct
> > > +   xfs_extent_free_item`` objects.
> > > +   Returning to the example above, the action item tracks the freeing of both
> > > +   the unmapped space from AG 7 and the block mapping btree (BMBT) block from
> > > +   AG 3.
> > > +   Deferred frees recorded in this manner are committed in the log by creating
> > > +   an EFI log item from the ``struct xfs_extent_free_item`` object and
> > > +   attaching the log item to the transaction.
> > > +   When the log is persisted to disk, the EFI item is written into the ondisk
> > > +   transaction record.
> > > +   EFIs can list up to 16 extents to free, all sorted in AG order.
> > > +
> > > +2. The second transaction contains a physical update to the free space btrees
> > > +   of AG 3 to release the former BMBT block and a second physical update to the
> > > +   free space btrees of AG 7 to release the unmapped file space.
> > > +   Observe that the the physical updates are resequenced in the correct order
> > > +   when possible.
> > > +   Attached to the transaction is a an extent free done (EFD) log item.
> > > +   The EFD contains a pointer to the EFI logged in transaction #1 so that log
> > > +   recovery can tell if the EFI needs to be replayed.
> > > +
> > > +If the system goes down after transaction #1 is written back to the filesystem
> > > +but before #2 is committed, a scan of the filesystem metadata would show
> > > +inconsistent filesystem metadata because there would not appear to be any owner
> > > +of the unmapped space.
> > > +Happily, log recovery corrects this inconsistency for us -- when recovery finds
> > > +an intent log item but does not find a corresponding intent done item, it will
> > > +reconstruct the incore state of the intent item and finish it.
> > > +In the example above, the log must replay both frees described in the recovered
> > > +EFI to complete the recovery phase.
> > > +
> > > +There are two subtleties to XFS' transaction chaining strategy to consider.
> > > +The first is that log items must be added to a transaction in the correct order
> > > +to prevent conflicts with principal objects that are not held by the
> > > +transaction.
> > > +In other words, all per-AG metadata updates for an unmapped block must be
> > > +completed before the last update to free the extent, and extents should not
> > > +be reallocated until that last update commits to the log.
> > > +The second subtlety comes from the fact that AG header buffers are (usually)
> > > +released between each transaction in a chain.
> > > +This means that other threads can observe an AG in an intermediate state,
> > > +but as long as the first subtlety is handled, this should not affect the
> > > +correctness of filesystem operations.
> > > +Unmounting the filesystem flushes all pending work to disk, which means that
> > > +offline fsck never sees the temporary inconsistencies caused by deferred work
> > > +item processing.
> > > +In this manner, XFS employs a form of eventual consistency to avoid deadlocks
> > > +and increase parallelism.
> > > +
> > > +During the design phase of the reverse mapping and reflink features, it was
> > > +decided that it was impractical to cram all the reverse mapping updates for a
> > > +single filesystem change into a single transaction because a single file
> > > +mapping operation can explode into many small updates:
> > > +
> > > +* The block mapping update itself
> > > +* A reverse mapping update for the block mapping update
> > > +* Fixing the freelist
> > > +* A reverse mapping update for the freelist fix
> > > +
> > > +* A shape change to the block mapping btree
> > > +* A reverse mapping update for the btree update
> > > +* Fixing the freelist (again)
> > > +* A reverse mapping update for the freelist fix
> > > +
> > > +* An update to the reference counting information
> > > +* A reverse mapping update for the refcount update
> > > +* Fixing the freelist (a third time)
> > > +* A reverse mapping update for the freelist fix
> > > +
> > > +* Freeing any space that was unmapped and not owned by any other file
> > > +* Fixing the freelist (a fourth time)
> > > +* A reverse mapping update for the freelist fix
> > > +
> > > +* Freeing the space used by the block mapping btree
> > > +* Fixing the freelist (a fifth time)
> > > +* A reverse mapping update for the freelist fix
> > > +
> > > +Free list fixups are not usually needed more than once per AG per transaction
> > > +chain, but it is theoretically possible if space is very tight.
> > > +For copy-on-write updates this is even worse, because this must be done once to
> > > +remove the space from a staging area and again to map it into the file!
> > > +
> > > +To deal with this explosion in a calm manner, XFS expands its use of deferred
> > > +work items to cover most reverse mapping updates and all refcount updates.
> > > +This reduces the worst case size of transaction reservations by breaking the
> > > +work into a long chain of small updates, which increases the degree of eventual
> > > +consistency in the system.
> > > +Again, this generally isn't a problem because XFS orders its deferred work
> > > +items carefully to avoid resource reuse conflicts between unsuspecting threads.
> > > +
> > > +However, online fsck changes the rules -- remember that although physical
> > > +updates to per-AG structures are coordinated by locking the buffers for AG
> > > +headers, buffer locks are dropped between transactions.
> > > +Once scrub acquires resources and takes locks for a data structure, it must do
> > > +all the validation work without releasing the lock.
> > > +If the main lock for a space btree is an AG header buffer lock, scrub may have
> > > +interrupted another thread that is midway through finishing a chain.
> > > +For example, if a thread performing a copy-on-write has completed a reverse
> > > +mapping update but not the corresponding refcount update, the two AG btrees
> > > +will appear inconsistent to scrub and an observation of corruption will be
> > > +recorded.  This observation will not be correct.
> > > +If a repair is attempted in this state, the results will be catastrophic!
> > > +
> > > +Several solutions to this problem were evaluated upon discovery of this flaw:
> > > +
> > > +1. Add a higher level lock to allocation groups and require writer threads to
> > > +   acquire the higher level lock in AG order before making any changes.
> > > +   This would be very difficult to implement in practice because it is
> > > +   difficult to determine which locks need to be obtained, and in what order,
> > > +   without simulating the entire operation.
> > > +   Performing a dry run of a file operation to discover necessary locks would
> > > +   make the filesystem very slow.
> > > +
> > > +2. Make the deferred work coordinator code aware of consecutive intent items
> > > +   targeting the same AG and have it hold the AG header buffers locked across
> > > +   the transaction roll between updates.
> > > +   This would introduce a lot of complexity into the coordinator since it is
> > > +   only loosely coupled with the actual deferred work items.
> > > +   It would also fail to solve the problem because deferred work items can
> > > +   generate new deferred subtasks, but all subtasks must be complete before
> > > +   work can start on a new sibling task.
> > > +
> > > +3. Teach online fsck to walk all transactions waiting for whichever lock(s)
> > > +   protect the data structure being scrubbed to look for pending operations.
> > > +   The checking and repair operations must factor these pending operations into
> > > +   the evaluations being performed.
> > > +   This solution is a nonstarter because it is *extremely* invasive to the main
> > > +   filesystem.
> > > +
> > > +4. Recognize that only online fsck has this requirement of total consistency
> > > +   of AG metadata, and that online fsck should be relatively rare as compared
> > > +   to filesystem change operations.
> > > +   For each AG, maintain a count of intent items targetting that AG.
> > > +   When online fsck wants to examine an AG, it should lock the AG header
> > > +   buffers to quiesce all transaction chains that want to modify that AG, and
> > > +   only proceed with the scrub if the count is zero.
> > > +   In other words, scrub only proceeds if it can lock the AG header buffers and
> > > +   there can't possibly be any intents in progress.
> > > +   This may lead to fairness and starvation issues, but regular filesystem
> > > +   updates take precedence over online fsck activity.
> > > +
> >
> > Is there any guarantee that some silly real life regular filesystem workload
> > won't starve online fsck forever?
> > IOW, is forward progress of online fsck guaranteed?
>
> Nope, forward progress isn't guaranteed.

That sounds like a problem.

> The kernel checks for fatal
> signals every time it backs off a scrub so at least we don't end up with
> unkillable processes.  At one point I added a timeout field to the ioctl
> interface so that the kernel could time out an operation if it took too
> long to acquire the necessary resources.  So far, the "race fsstress and
> xfs_scrub" tests have not shown scrub failing to make any forward
> progress.
>
> That said, I have /not/ yet had a chance to try it out any of these
> massive 1000-core systems with an according workload.
>

Don't know if fsstress is the best way to check the worst case scenario.

Can you think of a workload, say several threads creating and deleting
temp files, with deferred parent pointer items preventing the queue from
ever draining?

Considering that a "full journal" scenario is always going to be a possible
worst case incident, how bad would it be to block new transactions
instead of the possibility of starving scrub consistency checks forever?

Wouldn't the consistency checks be much faster than freeing journal
space would be in a "full journal" situation?

I don't know if there is a "mission statement" for online fsck, but
I think it would say "minimal user interference" not "no user interference".
It sounds like the interference we are trying to avoid is light years away
from the downtime of offline fsck, so online fsck would still be a huge win.
online fsck that never ends OTOH... maybe less so.

> > Good luck with landing online fsck before the 2024 NYE deluge ;)
>
> Thank *you* for reading this chapter of the design document!! :)
>

Oh I read them all at the summer submission, but it took me so long
that I forgot to follow up..

My other question was regarding memory usage control.
I have horrid memories from e2fsck unpredictable memory usage
and unpredictable runtime due to swapping.

xfs_repair -m was a huge improvement compared to e2fsck.
I don't remember reading about memory usage limits for online repair,
so I was concerned about unpredictable memory usage and swapping.
Can you say something to ease those concerns?

Thanks,
Amir.
