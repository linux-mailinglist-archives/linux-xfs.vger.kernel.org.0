Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 753BD336A25
	for <lists+linux-xfs@lfdr.de>; Thu, 11 Mar 2021 03:30:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229512AbhCKCaZ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 10 Mar 2021 21:30:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:41128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229593AbhCKCaZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Mar 2021 21:30:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5DDB64D96;
        Thu, 11 Mar 2021 02:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615429824;
        bh=wLKIxuPDt9eH7kXLyWrv1KyVdHveCvr649UQWRZ16Xs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=di97EKXlBKE+pcpnfXpYCU/ohws80KE7fBDtsNdUz63y78H5nGrknd1cGHoZNuX7/
         a0y1TqZHsKLSXX8xSEiwiOPjcA7QNvpeAEIhf8KnokWxiZg+LMHw62qsXZjih0NEKW
         TP6sbebC4nGcIMsfku0GqWVuZ0bRx2yaVPhKjWqfUvI7BQ+Ii/BVPVlQFOo+uKrJDV
         qbPCycUn74W0o18AW7/YW9IN8Q9qR4IKCWdpakL9OoUD6/LrZusBn3RBlyguSMOndz
         fL6/UtLt5gnYutVDLcozKvFAtuFyGsV1IvRY9GYa6Lzoi9zpDem8GvKY0l6WY/vLGU
         eSJOWU7P/3M+g==
Date:   Wed, 10 Mar 2021 18:30:20 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 45/45] xfs: expanding delayed logging design with
 background material
Message-ID: <20210311023020.GS3419940@magnolia>
References: <20210305051143.182133-1-david@fromorbit.com>
 <20210305051143.182133-46-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210305051143.182133-46-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Mar 05, 2021 at 04:11:43PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> I wrote up a description of how transactions, space reservations and
> relogging work together in response to a question for background
> material on the delayed logging design. Add this to the existing
> document for ease of future reference.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  .../xfs-delayed-logging-design.rst            | 362 ++++++++++++++++--
>  1 file changed, 323 insertions(+), 39 deletions(-)
> 
> diff --git a/Documentation/filesystems/xfs-delayed-logging-design.rst b/Documentation/filesystems/xfs-delayed-logging-design.rst
> index 464405d2801e..e02235911ff3 100644
> --- a/Documentation/filesystems/xfs-delayed-logging-design.rst
> +++ b/Documentation/filesystems/xfs-delayed-logging-design.rst
> @@ -1,29 +1,315 @@
>  .. SPDX-License-Identifier: GPL-2.0
>  
> -==========================
> -XFS Delayed Logging Design
> -==========================
> -
> -Introduction to Re-logging in XFS
> -=================================
> -
> -XFS logging is a combination of logical and physical logging. Some objects,
> -such as inodes and dquots, are logged in logical format where the details
> -logged are made up of the changes to in-core structures rather than on-disk
> -structures. Other objects - typically buffers - have their physical changes
> -logged. The reason for these differences is to reduce the amount of log space
> -required for objects that are frequently logged. Some parts of inodes are more
> -frequently logged than others, and inodes are typically more frequently logged
> -than any other object (except maybe the superblock buffer) so keeping the
> -amount of metadata logged low is of prime importance.
> -
> -The reason that this is such a concern is that XFS allows multiple separate
> -modifications to a single object to be carried in the log at any given time.
> -This allows the log to avoid needing to flush each change to disk before
> -recording a new change to the object. XFS does this via a method called
> -"re-logging". Conceptually, this is quite simple - all it requires is that any
> -new change to the object is recorded with a *new copy* of all the existing
> -changes in the new transaction that is written to the log.
> +==================
> +XFS Logging Design
> +==================
> +
> +Preamble
> +========
> +
> +This document describes the design and algorithms that the XFS journalling
> +subsystem is based on. While originally focussed on just the design of
> +the delayed logging extension introduced in 2010, it assumed the reader already
> +had a fair amount of in-depth knowledge about how XFS transactions are formed
> +and executed. It also largely omitted any details of how journal space
> +reservations are accounted for to ensure the operation of the logging subsystem
> +is guaranteed to be deadlock-free.
> +
> +Much of the original document is retained unmodified because it is still valid
> +and correct. It also allows the new background material to avoid long
> +descriptions for various algorithms because they are already well documented
> +in the original document (e.g. what "relogging" is and why it is needed).

I wonder how useful is this synopsis of this document's history?
When I'm reading a piece of documentation I really only care about
what's in the document I'm reading now, not what it looked like in 2010.
I think you could shorten the preamble by deleting everything between
the second sentence and the last paragraph:

"This document describes the design and algorithms that the XFS
journalling subsystem is based on.  Readers may wish to familiarize
themselves with the general concepts of how transaction processing
works.  We begin with an overview of transactions in XFS, followed by
the way transaction reservations..."

> +Hence we first start with an overview of transactions, followed by the way
> +transaction reservations are structured and accounted,
> +and then move into how we guarantee forwards progress for long running
> +transactions with finite initial reservations bounds. At this point we need
> +to explain how relogging works, and that is where the original document
> +started.
> +
> +Introduction
> +============
> +
> +XFS uses Write Ahead Logging for ensuring changes to the filesystem metadata
> +are atomic and recoverable. For reasons of space and time efficiency, the
> +logging mechanisms are varied and complex, combining intents, logical and
> +physical logging mechanisms to provide the necessary recovery guarantees the
> +filesystem requires.
> +
> +Some objects, such as inodes and dquots, are logged in logical format where the
> +details logged are made up of the changes to in-core structures rather than
> +on-disk structures. Other objects - typically buffers - have their physical
> +changes logged. And long running atomic modifications have individual changes

No need for the 'And' at the start of the sentence.

> +chained together by intents, ensuring that journal recovery can restart and
> +finish an operation that was only partially done when the system stopped
> +functioning.
> +
> +The reason for these differences is to keep the amount of log space and CPU time
> +required to process objects being modified as small as possible and hence the
> +logging overhead as low as possible. Some items are very frequently modified,
> +and some parts of objects are more frequently modified than others, so so

Double "so".

> +keeping the overhead of metadata logging low is of prime importance.
> +
> +The method used to log an item or chain modifications together isn't
> +particularly important in the scope of this document. It suffices to know that
> +the method used for logging a particular object or chaining modifications
> +together are different and are dependent on the object and/or modification being
> +performed. The logging subsystem only cares that certain specific rules are
> +followed to guarantee forwards progress and prevent deadlocks.

(Aww, maybe we /should/ document how we choose between intents, logical
updates, and physical updates.  But that can come in a later patch.)

> +
> +
> +Transactions in XFS
> +===================
> +
> +XFS has two types of high level transactions, defined by the type of log space
> +reservation they take. These are known as "one shot" and "permanent"

(Ugh, I wish we could call them 'compound' or 'rolling'
transactions....)

> +transactions.

It might be a good idea to introduce the idea that a permanent
transaction has the ability to reserve space across commit boundaries.

> +Permanent transaction reservations can be used for one-shot
> +transactions, but one-shot reservations cannot be used for permanent
> +transactions. Reservations must be matched to the modification taking place.

"The size and type of reservation must be matched..."

> +
> +In the code, a one-shot transaction pattern looks somewhat like this::
> +
> +        tp = xfs_trans_alloc(<reservation>)
> +	<lock items>
> +        <do modification>

Indenting is not consistent here.

> +        xfs_trans_commit(tp);
> +
> +As items are modified in the transaction, the dirty regions in those items are

...are what?  I think this sentence got truncated.

> +Once the transaction is committed, all resources joined to it are released,
> +along with the remaining unused reservation space that was taken at the
> +transaction allocation time.
> +
> +In contrast, a permanent transaction is made up of multiple linked individual
> +transactions, and the pattern looks like this::
> +
> +	tp = xfs_trans_alloc(<reservation>)
> +	xfs_ilock(ip, XFS_ILOCK_EXCL)
> +
> +	loop {
> +		xfs_trans_ijoin(tp, 0);
> +		<do modification>
> +		xfs_trans_log_inode(tp, ip);
> +		xfs_trans_roll(&tp);
> +	}
> +
> +	xfs_trans_commit(tp);
> +	xfs_iunlock(ip, XFS_ILOCK_EXCL);
> +
> +While this might look similar to a one-shot transaction, there is an important
> +difference: xfs_trans_roll() performs a specific operation that links two
> +transactions together::
> +
> +	ntp = xfs_trans_dup(tp);
> +	xfs_trans_commit(tp);
> +	xfs_log_reserve(ntp);
> +
> +This results in a series of "rolling transactions" where the inode is locked
> +across the entire chain of transactions.  Hence while this series of rolling
> +transactions is running, nothing else can read from or write to the inode and
> +this provides a mechanism for complex changes to appear atomic from an external
> +observer's point of view.
> +
> +It is important to note that a series of rolling transactions in a permanent
> +transaction does not form an atomic change in the journal. While each
> +individual modification is atomic, the chain is *not atomic*. If we crash half
> +way through, then recovery will only replay up to the last transactional
> +modification the loop made that was committed to the journal.

Can you add:

"Log intent items are used to track the progress of and to restart
metadata updates that span multiple transactions."

Or maybe just hoist the third paragraph of the next section into a
separate section introducing log intents?

> +
> +
> +Transactions are Asynchronous
> +=============================
> +
> +In XFS, all high level transactions are asynchronous by default. This means that
> +xfs_trans_commit() does not guarantee that the modification has been committed
> +to stable storage when it returns. Hence when a system crashes, not all the
> +completed transactions will be replayed during recovery.
> +
> +However, the logging subsystem does provide global ordering guarantees, such
> +that if a specific change is seen after recovery, all metadata modifications
> +that were committed prior to that change will also be seen.
> +
> +This affects long running permanent transactions in that it is not possible to
> +predict how much of a long running operation will actually be recovered because
> +there is no guarantee of how much of the operation reached stale storage. Hence
> +if a long running operation requires multiple transactions to fully complete,
> +the high level operation must use intents and defered operations to guarantee

"deferred"

> +recovery can complete the operation once the first modification reached the
> +journal.

"...once the first transaction is persisted in the on-disk journal."

> +
> +For single shot operations that need to reach stable storage immediately, or
> +ensuring that a long running permanent transaction is fully committed once it is
> +complete, we can explicitly tag a transaction as synchronous. This will trigger
> +a "log force" to flush the outstanding committed transactions to stable storage
> +in the journal and wait for that to complete.
> +
> +Synchronous transactions are rarely used, however, because they limit logging
> +throughput to the IO latency limitations of the underlying storage. Instead, we
> +tend to use log forces to ensure modifications are on stable storage only when
> +a user operation requires a synchronisation point to occur (e.g. fsync).
> +
> +
> +Transaction Reservations
> +========================
> +
> +It has been mentioned a number of times now that the logging subsystem needs to
> +provide a forwards progress guarantee so that no modification ever stalls
> +because it can't be written to the journal due to a lack of space in the
> +journal. This is acheived by the transaction reservations that are made when

"achieved"

> +a transaction is first allocated. For permanent transactions, these reservations
> +are maintained as part of the transaction rolling mechanism.
> +
> +A transaction reservation provides a guarantee that there is physical log space
> +available to write the modification into the journal before we start making
> +modifications to objects and items. As such, the reservation needs to be large
> +enough to take into account the amount of metadata that the change might need to
> +log in the worst case. This means that if we are modifying a btree in the
> +transaction, we have to reserve enough space to record a full leaf-to-root split
> +of the btree. As such, the reservations are quite complex because we have to
> +take into account all the hidden changes that might occur.
> +
> +For example, a user data extent allocation involves allocating an extent from
> +free space, which modifies the free space trees. That's two btrees. Then
> +inserting the extent into the inode extent map requires modify another btree,
> +which might require mor allocation that modifies the free space btrees again.

"Inserting the extent into the inode's extent map might require a split
of the extent map btree, which requires another allocation that can
modify the free space btrees again."

> +Then we might have to update reverse mappings, which modifies yet another btree
> +which might require more space. And so on.  Hence the amount of metadata that a
> +"simple" operation can modify can be quite large.
> +
> +This "worst case" calculation provides us with the static "unit reservation"
> +for the transaction that is calculated at mount time. We must guarantee that the
> +log has this much space available before the transaction is allowed to proceed
> +so that when we come to write the dirty metadata into the log we don't run out
> +of log space half way through the write.
> +
> +For one-shot transactions, a single unit space reservation is all that is
> +required for the transaction to proceed. For permanent transactions, however, we
> +also have a "log count" that affects the size of the reservation that is to be
> +made.
> +
> +While a permanent transaction can get by with a single unit of space
> +reservation, it is somewhat inefficient to do this as it requires the
> +transaction rolling mechanism to re-reserve space on every transaction roll. We
> +know from the implementation of the permanent transactions how many transaction
> +rolls are likely for the common modifications that need to be made.
> +
> +For example, and inode allocation is typically two transactions - one to
> +physically allocate a free inode chunk on disk, and another to allocate an inode
> +from an inode chunk that has free inodes in it.  Hence for an inode allocation
> +transaction, we might set the reservation log count to a value of 2 to indicate
> +that the common/fast path transaction will commit two linked transactions in a
> +chain. Each time a permanent transaction rolls, it consumes an entire unit
> +reservation.
> +
> +Hence when the permanent transaction is first allocated, the log space
> +reservation is increases from a single unit reservation to multiple unit
> +reservations. That multiple is defined by the reservation log count, and this
> +means we can roll the transaction multiple times before we have to re-reserve
> +log space when we roll the transaction. This ensures that the common
> +modifications we make only need to reserve log space once.
> +
> +If the log count for a permanent transation reaches zero, then it needs to

"transaction"

> +re-reserve physical space in the log. This is somewhat complex, and requires
> +an understanding of how the log accounts for space that has been reserved.
> +
> +
> +Log Space Accounting
> +====================
> +
> +The position in the log is typically referred to as a Log Sequence Number (LSN).
> +The log is circular, so the positions in the log are defined by the combination
> +of a cycle number - the number of times the log has been overwritten - and the
> +offset into the log.  A LSN carries the cycle in the upper 32 bits and the
> +offset in the lower 32 bits. The offset is in units of "basic blocks" (512
> +bytes). Hence we can do realtively simple LSN based math to keep track of
> +available space in the log.
> +
> +Log space accounting is done via a pair of constructs called "grant heads".  The
> +position of the grant heads is an absolute value, so the amount of space
> +available in the log is defined by the distance between the position of the
> +grant head and the current log tail. That is, how much space can be
> +reserved/consumed before the grant heads would fully wrap the log and overtake
> +the tail position.
> +
> +The first grant head is the "reserve" head. This tracks the byte count of the
> +reservations currently held by active transactions. It is a purely in-memory
> +accounting of the space reservation and, as such, actually tracks byte offsets
> +into the log rather than basic blocks. Hence it technically isn't using LSNs to
> +represent the log position, but it is still treated like a split {cycle,offset}
> +tuple for the purposes of tracking reservation space.

Lol, the grant head is delalloc for transactions.

> +
> +The reserve grant head is used to accurately account for exact transaction
> +reservations amounts and the exact byte count that modifications actually make
> +and need to write into the log. The reserve head is used to prevent new
> +transactions from taking new reservations when the head reaches the current
> +tail. It will block new reservations in a FIFO queue and as the log tail moves
> +forward it will wake them in order once sufficient space is available. This FIFO
> +mechanism ensures no transaction is starved of resources when log space
> +shortages occur.
> +
> +The other grant head is the "write" head. Unlike the reserve head, this grant
> +head contains an LSN and it tracks the physical space usage in the log. While
> +this might sound like it is accounting the same state as the reserve grant head
> +- and it mostly does track exactly the same location as the reserve grant head -
> +there are critical differences in behaviour between them that provides the
> +forwards progress guarantees that rolling permanent transactions require.
> +
> +These differences when a permanent transaction is rolled and the internal "log
> +count" reaches zero and the initial set of unit reservations have been
> +exhausted. At this point, we still require a log space reservation to continue
> +the next transaction in the sequeunce, but we have none remaining. We cannot
> +sleep during the transaction commit process waiting for new log space to become
> +available, as we may end up on the end of the FIFO queue and the items we have
> +locked while we sleep could end up pinning the tail of the log before there is
> +enough free space in the log to fulfil all of the pending reservations and
> +then wake up transaction commit in progress.
> +
> +To take a new reservation without sleeping requires us to be able to take a
> +reservation even if there is no reservation space currently available. That is,
> +we need to be able to *overcommit* the log reservation space. As has already
> +been detailed, we cannot overcommit physical log space. However, the reserve
> +grant head does not track physical space - it only accounts for the amount of
> +reservations we currently have outstanding. Hence if the reserve head passes
> +over the tail of the log all it means is that new reservations will be throttled
> +immediately and remain throttled until the log tail is moved forward far enough
> +to remove the overcommit and start taking new reservations. In other words, we
> +can overcommit the reserve head without violating the physical log head and tail
> +rules.

I hadn't fully realized this.  Good information. :)

> +As a result, permanent transactions only "regrant" reservation space during
> +xfs_trans_commit() calls, while the physical log space reservation - tracked by
> +the write head - is then reserved separately by a call to xfs_log_reserve()
> +after the commit completes. Once the commit completes, we can sleep waiting for
> +physical log space to be reserved from the write grant head, but only if one
> +critical rule has been observed::
> +
> +	Code using permanent reservations must always log the items they hold
> +	locked across each transaction they roll in the chain.
> +
> +"Re-logging" the locked items on every transaction roll ensures that the items
> +the transaction chain is rolling are always relocated to the physical head of
> +the log and so do not pin the tail of the log. If a locked item pins the tail of
> +the log when we sleep on the write reservation, then we will deadlock the log as
> +we cannot take the locks needed to write back that item and move the tail of the
> +log forwards to free up write grant space. Re-logging the locked items avoids
> +this deadlock and guarantees that the log reservation we are making cannot
> +self-deadlock.
> +
> +If all rolling transactions obey this rule, then they can all make forwards
> +progress independently because nothing will block the progress of the log
> +tail moving forwards and hence ensuring that write grant space is always
> +(eventually) made available to permanent transactions no matter how many times
> +they roll.
> +
> +
> +Re-logging Explained
> +====================
> +
> +XFS allows multiple separate modifications to a single object to be carried in
> +the log at any given time.  This allows the log to avoid needing to flush each
> +change to disk before recording a new change to the object. XFS does this via a
> +method called "re-logging". Conceptually, this is quite simple - all it requires
> +is that any new change to the object is recorded with a *new copy* of all the
> +existing changes in the new transaction that is written to the log.
>  
>  That is, if we have a sequence of changes A through to F, and the object was
>  written to disk after change D, we would see in the log the following series
> @@ -42,16 +328,13 @@ transaction::
>  In other words, each time an object is relogged, the new transaction contains
>  the aggregation of all the previous changes currently held only in the log.
>  
> -This relogging technique also allows objects to be moved forward in the log so
> -that an object being relogged does not prevent the tail of the log from ever
> -moving forward.  This can be seen in the table above by the changing
> -(increasing) LSN of each subsequent transaction - the LSN is effectively a
> -direct encoding of the location in the log of the transaction.
> +This relogging technique allows objects to be moved forward in the log so that
> +an object being relogged does not prevent the tail of the log from ever moving
> +forward.  This can be seen in the table above by the changing (increasing) LSN
> +of each subsequent transaction, and it's the technique that allows us to
> +implement long-running, multiple-commit permanent transactions. 
>  
> -This relogging is also used to implement long-running, multiple-commit
> -transactions.  These transaction are known as rolling transactions, and require
> -a special log reservation known as a permanent transaction reservation. A
> -typical example of a rolling transaction is the removal of extents from an
> +A typical example of a rolling transaction is the removal of extents from an
>  inode which can only be done at a rate of two extents per transaction because
>  of reservation size limitations. Hence a rolling extent removal transaction
>  keeps relogging the inode and btree buffers as they get modified in each
> @@ -67,12 +350,13 @@ the log over and over again. Worse is the fact that objects tend to get
>  dirtier as they get relogged, so each subsequent transaction is writing more
>  metadata into the log.
>  
> -Another feature of the XFS transaction subsystem is that most transactions are
> -asynchronous. That is, they don't commit to disk until either a log buffer is
> -filled (a log buffer can hold multiple transactions) or a synchronous operation
> -forces the log buffers holding the transactions to disk. This means that XFS is
> -doing aggregation of transactions in memory - batching them, if you like - to
> -minimise the impact of the log IO on transaction throughput.
> +It should now also be obvious how relogging and asynchronous transactions go
> +hand in hand. That is, transactions don't get written to the physical journal
> +until either a log buffer is filled (a log buffer can hold multiple
> +transactions) or a synchronous operation forces the log buffers holding the
> +transactions to disk. This means that XFS is doing aggregation of transactions
> +in memory - batching them, if you like - to minimise the impact of the log IO on
> +transaction throughput.

...microtransaction fusion, yippee!

--D

>  
>  The limitation on asynchronous transaction throughput is the number and size of
>  log buffers made available by the log manager. By default there are 8 log
> -- 
> 2.28.0
> 
