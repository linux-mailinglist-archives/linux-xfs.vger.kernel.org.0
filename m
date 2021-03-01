Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF2BC32753E
	for <lists+linux-xfs@lfdr.de>; Mon,  1 Mar 2021 00:33:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230491AbhB1XdD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 28 Feb 2021 18:33:03 -0500
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:45113 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230419AbhB1XdC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 Feb 2021 18:33:02 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id 12B4E1057EC;
        Mon,  1 Mar 2021 10:32:19 +1100 (AEDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lGVXu-0093Vv-2c; Mon, 01 Mar 2021 10:32:18 +1100
Date:   Mon, 1 Mar 2021 10:32:18 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Cc:     linux-xfs@vger.kernel.org, djwong@kernel.org
Subject: Re: code questions about xfs log implementation
Message-ID: <20210228233218.GB4662@dread.disaster.area>
References: <a732a6ff-4d66-91e5-cd9a-43d156d83362@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a732a6ff-4d66-91e5-cd9a-43d156d83362@linux.alibaba.com>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=kj9zAlcOel0A:10 a=dESyimp9J3IA:10 a=7-415B0cAAAA:8
        a=WKyg_PURvCFiBR6fA1IA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Feb 28, 2021 at 03:46:56PM +0800, Xiaoguang Wang wrote:
> hi,
> 
> I'm studying xfs delayed logging codes, and currently have some questions about log
> reservation, can anyone help to answer below questions, thanks in advance!
> 
> 1, what's the difference between xlog's l_reserve_head and l_write_head?
> Seems that l_reserve_head already can been used to do log space reservation, from
> codes, I really don't get when to use l_reserve_head or l_write_head, so what different
> cases are they used for?

The reserve head tracks active transaction reservation space, the
write head tracks physical log space reservation. Mostly they track
the same, but there's an important difference when it comes to
rolling permanent transactions.

> 
> 2, what's the exact definition about permanent transaction reservation?
> In xfs_trans_resv_calc(), I see many kinds of transactions have XFS_TRANS_PERM_LOG_RES
> enabled, so non-permanent transaction does not need to do log reservation
> at the begin?

Non-permanent transactions are effectively one-shot transactions.
They consist of:

	tp = xfs_trans_alloc(<space>)
	<do modification>
	xfs_trans_commit(tp);

Once the transaction is committed, all resources attached to it are
released, along with all the unused reservation space (both reserve
and write space).

A "permanent" transaction is on that can be "rolled" repeatedly to
form a long running chain of individual transactions that appears
atomic to outside runtime observers. You'll see this pattern:

	tp = xfs_trans_alloc(<space>)
	xfs_ilock(ip, XFS_ILOCK_EXCL)

	loop {
		xfs_trans_ijoin(tp, 0);
		<do modification>
		xfs_trans_log_inode(tp, ip);
		xfs_trans_roll(&tp);
	}

	xfs_trans_commit(tp);
	xfs_iunlock(ip, XFS_ILOCK_EXCL);

This holds the inode locked over a series of rolling transactions,
and hence while this series of modifications is running, nothing
else can read from or write to the inode. i.e. the change is atomic
from an external observer's point of view. The key here is
xfs_trans_roll(), which does:

	ntp = xfs_trans_dup(tp);
	xfs_trans_commit(tp);
	xfs_log_reserve(ntp);

This duplicates the current transaction and it's internal state
(including reservations), commits the original transaction, then
reserves space for the new transaction if necessary. This can only
be done with transactions marked as permanent transactions.

The key here is that a permanent transaction reserves space for
multiple transactions up front. this is the tr_logcount in the
reservation. This number of unit reservations is made in the
original xfs_trans_alloc() call, and each time the transaction
"rolls" the unit count is decremented by one.

This is because each commit releases the unused part of the current
unit reservation back to the log and the new transaction (the dup'd
transaction) will start with an entire unit reservation that it
can consume.

So what happens when the log count reaches zero? Well, that's where
the differences between the reserve head and the write head come in.
When the log count reaches zero and the remaining unit reservations
have been freed, xfs_log_regrant() immediately takes
a new unit reservation on the reservation head. This
-overcommits- the reservation grant space, preventing new
reservations from occurring if the log is full until some ongoing
transactions commit and release unused reservation space.

xfs_log_regrant() does not, however, take any new space from the
write head because this tracks physical space in the log and must
not be overcommitted. If we overcommit write space, we can
physically overwrite the tail of the log with the current head, and
that corrupts the log. We can't wait for write head space in the
xfs_trans_commit code, because the commit we are about to write to
log might contain items that pin the tail of the log. Hence  new
write space won't get released for the current transaction because
that needs the commit to complete.

Hence we wait until we call xfs_log_reserve() after
xfs_trans_commit() completes to regrant write head space. At this
point, it is safe for us to sleep if the transaction we just
committed ensured that it relogged all the items in the transaction
that might pin the tail of the log (e.g. the inode). Because we
relogged those items, they'll get moved to the head of the log and
the tail will move forwards, guaranteeing that there will be write
space available for this permanent transaction. And we are
guaranteed that there will eventually be write space available
because we over-committed the reserve head and nobody can take new
reserve space via xfs_trans_alloc() while we are overcommitted.

So that's how permanent transactions and reservations work.

It is important to note that a series of rolling transactions in a
chain like this do not form an atomic change on disk.  While each
individual modification is atomic, the chain is *not atomic*. If we
crash half way through, then recovery will only replay up to the
last modification the loop made.

If you want an atomic modification that requires multiple individual
transactions to perform, then you need to learn about xfs_defer_ops,
intents, etc and how they are used within a permanent transaction
chain and recovery to form an atomic all-or-nothing modification to
the filesystem.

> 3, struct xfs_trans_res's tr_logcount(/* number of log operations per log ticket */)
> For exmaple, tr_write.tr_logcount is XFS_WRITE_LOG_COUNT_REFLINK(8), does that mean
> to complete a write operation, we'll need 8 log operations, such as file block mapping
> update intent will be counted one?

It means that we expect the vast majority of reflink modifications
to take less than 8 individual transactions chained together to
complete. THis effectively forms a fast path for common operations
where xfs_trans_roll() does not block having to wait for log space
to become available. IOWs, for the fast path when there is log space
available, we do an atomic, lockless transaction reservation for up
to 8 transaction rolls to complete the operation without need to
obtain more log space.

> 4, what's the exact definition about xfs rolling transactions?

"rolling transaction" == "permanent transaction"

Same thing, just one refers to the way the log sees the log space
accounting (a reservation that is permanent until the caller
releases it) and the other refers to the way the code running
transactions sees them (you roll from one transaction to the next in
the chain).

> 5, finally are there any documents that describe the initial xfs log design before
> current delayed logging design?
> Documentation/filesystems/xfs-delayed-logging-design.rst is a very good document, but
> seems that it assumes that readers has been familiar with initial xfs log design.

No. I wrote the delayed logging document with that in mind - the
first section ("Introduction to Re-logging in XFS") describes how
the original log design worked. That's essentially what I also wrote
above - none of what I describe above has anything to do with
delayed logging, nor does it even know (or care) that delayed
logging exists.

The above is all about locking, relogging and log space accounting,
and it's largely unchanged from the original design. While we've
added delayed logging and deferred transactions, they all still work
within the rules I outline above. It all really only works because
of the original design rules placed around the need to relog items
in permanent transactions...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
