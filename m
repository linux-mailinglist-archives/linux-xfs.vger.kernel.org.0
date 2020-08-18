Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE2E0248DCF
	for <lists+linux-xfs@lfdr.de>; Tue, 18 Aug 2020 20:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbgHRSR5 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 18 Aug 2020 14:17:57 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:42120 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbgHRSRz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Aug 2020 14:17:55 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IIH8MH081310;
        Tue, 18 Aug 2020 18:17:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=GGhssC9fB437+KRsk4u6EfRZTv3iUezU+mX1m5uXN40=;
 b=fAJN82d6pkfGf99W9EGgX8WJtjYwTCt8Mf+/NCgV1zF8Bg/OT44YEEQ7jrmtoAp7nOdV
 tFCNoQofFiaLTjDZ7CzBDXKCoI0pK6PiZAj2rvfZPP7fKt4AwK47xODKaX9SIZuoBLsF
 V6vjTuBBHhP7T9dDS6KeYTYhI9EbA/c9nhxLOTdWS4AnXaAIG4+MpR9zhcE/Ns2i0s9t
 7ZT0oD5GqM30L0epNcrYyk2qi7m5BVvl3XOstXRlvgH0BnH1RydbO6JRzVyjgtt1VLTj
 ZH13SHFM58wmzCdXS4unl9UksL/RC4g0JUaT5LiiMCC78W4t/lJtKihDlj/shbe5JlAZ Aw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 32x8bn6d2g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 18 Aug 2020 18:17:48 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07IIHkkv162072;
        Tue, 18 Aug 2020 18:17:48 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 32xsm3fk3h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Aug 2020 18:17:47 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07IIHkXA030965;
        Tue, 18 Aug 2020 18:17:46 GMT
Received: from localhost (/10.159.135.24)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 18 Aug 2020 11:17:46 -0700
Date:   Tue, 18 Aug 2020 11:17:45 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>, hsiangkao@redhat.com
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 00/13] xfs: in memory inode unlink log items
Message-ID: <20200818181745.GL6107@magnolia>
References: <20200812092556.2567285-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200812092556.2567285-1-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008180126
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9717 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 lowpriorityscore=0
 impostorscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008180126
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 12, 2020 at 07:25:43PM +1000, Dave Chinner wrote:
> Hi folks,
> 
> This is a cleaned up version of the original RFC I posted here:
> 
> https://lore.kernel.org/linux-xfs/20200623095015.1934171-1-david@fromorbit.com/
> 
> The original description is preserved below for quick reference,
> I'll just walk though the changes in this version:
> 
> - rebased on current TOT and xfs/for-next
> - split up into many smaller patches
> - includes Xiang's single unlinked list bucket modification
> - uses a list_head for the in memory double unlinked inode list
>   rather than aginos and lockless inode lookups
> - much simpler as it doesn't need to look up inodes from agino
>   values
> - iunlink log item changed to take an xfs_inode pointer rather than
>   an imap and agino values
> - a handful of small cleanups that breaking up into small patches
>   allowed.

Two questions: How does this patchset intersect with the other one that
changes the iunlink series?  I guess the v4 of that series (when it
appears) is intended to be applied directly after this one?

The second is that I got this corruption warning on generic/043 with...

FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 ca-nfsdev6-mtr01 5.9.0-rc1-djw #rc1 SMP PREEMPT Mon Aug 17 20:13:04 PDT 2020
MKFS_OPTIONS  -- -f -m reflink=1,rmapbt=1 -i sparse=1, -b size=1024, /dev/sdd
MOUNT_OPTIONS -- -o usrquota,grpquota,prjquota, /dev/sdd /opt

[16533.664277] run fstests generic/043 at 2020-08-18 00:50:48
[16534.875994] XFS (sde): Mounting V5 Filesystem
[16534.889508] XFS (sde): Ending clean mount
[16534.893661] xfs filesystem being mounted at /mnt supports timestamps until 2038 (0x7fffffff)
[16535.403285] XFS (sdd): Mounting V5 Filesystem
[16535.412082] XFS (sdd): Ending clean mount
[16535.414126] XFS (sdd): Quotacheck needed: Please wait.
[16535.450551] XFS (sdd): Quotacheck: Done.
[16535.453583] xfs filesystem being mounted at /opt supports timestamps until 2038 (0x7fffffff)
[16535.468595] XFS (sdd): User initiated shutdown received. Shutting down filesystem
[16535.477876] XFS (sdd): Unmounting Filesystem
[16535.787559] XFS (sdd): Mounting V5 Filesystem
[16535.797105] XFS (sdd): Ending clean mount
[16535.801363] XFS (sdd): Quotacheck needed: Please wait.
[16535.838561] XFS (sdd): Quotacheck: Done.
[16535.841371] xfs filesystem being mounted at /opt supports timestamps until 2038 (0x7fffffff)
[16556.765496] XFS (sdd): User initiated shutdown received. Shutting down filesystem
[16556.898239] XFS (sdd): Unmounting Filesystem
[16556.903292] list_del corruption. next->prev should be ffff88802dbb0fc8, but was ffff888008d46050
[16556.905487] ------------[ cut here ]------------
[16556.906424] kernel BUG at lib/list_debug.c:54!
[16556.907314] invalid opcode: 0000 [#1] PREEMPT SMP
[16556.908216] CPU: 0 PID: 2975390 Comm: xfsaild/sdd Tainted: G        W         5.9.0-rc1-djw #rc1
[16556.909816] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.13.0-1ubuntu1 04/01/2014
[16556.911406] RIP: 0010:__list_del_entry_valid.cold+0x1d/0x51
[16556.912453] Code: c7 c7 e0 a2 e4 81 e8 55 1e cf ff 0f 0b 48 89 fe 48 c7 c7 70 a3 e4 81 e8 44 1e cf ff 0f 0b 48 c7 c7 20 a4 e4 81 e8 36 1e cf ff <0f> 0b 48 89 f2 48 89 fe 48 c7 c7 e0 a3 e4 81 e8 22 1e cf ff 0f 0b
[16556.915781] RSP: 0018:ffffc900018abd58 EFLAGS: 00010246
[16556.916782] RAX: 0000000000000054 RBX: ffff88802dbb0f78 RCX: 0000000000000000
[16556.918081] RDX: 0000000000000000 RSI: ffffffff81e2b51a RDI: 00000000ffffffff
[16556.919385] RBP: ffff88804e615a00 R08: 0000000000000001 R09: 0000000000000001
[16556.920691] R10: 0000000000000001 R11: 0000000000000001 R12: ffff88804e615be0
[16556.921995] R13: ffff88802dbb0fc8 R14: ffff88806a6dd340 R15: ffff88802dbb1018
[16556.923304] FS:  0000000000000000(0000) GS:ffff88803ea00000(0000) knlGS:0000000000000000
[16556.924860] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[16556.925939] CR2: 00005593e4e4dd5c CR3: 000000003d5f0002 CR4: 00000000001706b0
[16556.927280] Call Trace:
[16556.927894]  xfs_iflush_abort+0x80/0x110 [xfs]
[16556.928828]  xfs_iflush_cluster+0x4fb/0x920 [xfs]
[16556.929734]  ? rcu_read_lock_sched_held+0x56/0x80
[16556.930721]  xfs_inode_item_push+0xac/0x150 [xfs]
[16556.931707]  xfsaild+0x61b/0x13b0 [xfs]
[16556.932452]  ? kvm_clock_read+0x14/0x30
[16556.933197]  ? sched_clock+0x9/0x10
[16556.933886]  ? trace_hardirqs_on+0x20/0xf0
[16556.934760]  ? xfs_trans_ail_cursor_first+0x80/0x80 [xfs]
[16556.935755]  kthread+0x13c/0x180
[16556.936343]  ? kthread_park+0x90/0x90
[16556.937027]  ret_from_fork+0x1f/0x30

--D

> The patchset passes fstests for v5 filesystems - v4 filesytsems
> testing is currently running, though I don't expect any new problems
> there.
> 
> Code can be found here:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git xfs-iunlink-item-2
> 
> Comments, thoughts, testing, etc all welcome.
> 
> -Dave.
> 
> ============
> 
> [Original RFC text]
> 
> Inode cluster buffer pinning by dirty inodes allows us to improve
> dirty inode tracking efficiency in the log by logging the inode
> cluster buffer as an ordered transaction. However, this brings with
> it some new issues, namely the order in which we lock inode cluster
> buffers.
> 
> That is, transactions that dirty and commit multiple inodes in a
> transaction will now need to locking multiple inode cluster buffers
> in each transaction (e.g. create, rename, etc). This introduces new 
> lock ordering constraints in these operations. It also introduces
> lock ordering constraints between the AGI and inode cluster buffers
> as a result of allocation/freeing being serialised by the AGI
> buffer lock. And then there is unlinked inode list logging, which
> currently has no fixed order of inode cluster buffer locking.
> 
> It's a bit messy.
> 
> Locking pure inode modifications in order is relatively easy. We
> don't actually need to attach and log the buffer to the transaction
> until the last moment. We have all the inodes locked, so nothing
> other than unlinked inode list modification can race with the
> transaction modifying inodes. Hence we can safely move the
> attachment of the inodes to the cluster buffer from when we first
> dirty them in xfs_trans_log_inode to just before we commit the
> transaction.
> 
> At this point, all the inodes that have been dirtied in the
> transaction have already been locked, modified, logged and attached
> to the transaction. Hence if we add a hook into xfs_trans_commit()
> to run a "precommit" operation on these log items, we can use this
> operation to attach the inodes to the cluster buffer at commit time
> instead of in xfs_trans_log_inode().
> 
> This, by itself, doesn't solve the lock ordering problem. What it
> does do, however, is give us a place where we can -order- all the
> dirty items in the transaction list. Hence before we call the
> precommit operation on each log item, we sort them. This allows us
> to sort all the inode items so that the pre-commit functions that
> locks and logs the cluster buffers are run in a deterministic order.
> This solves the lock order problem for pure inode modifications.
> 
> The unlinked inode list buffer locking is more complex. The unlinked
> list is unordered - we add to the tail, remove from where-ever the
> inode is in the list. Hence we might need to lock two inode buffers
> here (previous inode in list and the one being removed). While we
> can order the locking of these buffers correctly within the confines
> of the unlinked list, there may be other inodes that need buffer
> locking in the same transaction. e.g. O_TMPFILE being linked into a
> directory also modifies the directory inode.
> 
> Hence we need a mechanism for defering unlinked inode list updates
> to the pre-commit operation where it can be sorted into the correct
> order. We can do this by first observing that we serialise unlinked
> list modifications by holding the AGI buffer lock. IOWs, the AGI is
> going to be locked until the transaction commits any time we modify
> the unlinked list. Hence it doesn't matter when in the transaction
> we actually load, lock and modify the inode cluster buffer.
> 
> IOWs, what we need is an unlinked inode log item to defer the inode
> cluster buffer update to transaction commit time where it can be
> ordered with all the other inode cluster operations. Essentially all
> we need to do is record the inodes that need to have their unlinked
> list pointer updated in a new log item that we attached to the
> transaction.
> 
> This log item exists purely for the purpose of delaying the update
> of the unlinked list pointer until the inode cluster buffer can be
> locked in the correct order around the other inode cluster buffers.
> It plays no part in the actual commit, and there's no change to
> anything that is written to the log. i.e. the inode cluster buffers
> still have to be fully logged here (not just ordered) as log
> recovery depedends on this to replay mods to the unlinked inode
> list.
> 
> To make this unlinked inode list processing simpler and easier to
> implement as a log item, we need to change the way we track the
> unlinked list in memory. Starting from the observation that an inode
> on the unlinked list is pinned in memory by the VFS, we can use the
> xfs_inode itself to track the unlinked list. To do this efficiently,
> we want the unlinked list to be a double linked list. The current
> implementation takes the approach of minimising the memory footprint
> of this list in case we don't want to burn 16 bytes of memory per
> inode for a largely unused list head. [*]
> 
> We can get this down to 8 bytes per inode because the unlinked list
> is per-ag, and hence we only need to store the agino portion of the
> inode number as list pointers. We can then use these for lockless
> inode cache lookups to retreive the inode. The aginos in the inode
> are modified only under the AGI lock, just like the cluster buffer
> pointers, so we don't need any extra locking here.  The
> i_next_unlinked field tracks the on-disk value of the unlinked list,
> and the i_prev_unlinked is a purely in-memory pointer that enables
> us to efficiently remove inodes from the middle of the list.
> 
> IOWs, we burn a bit more CPU to resolve the unlinked list pointers
> to save 8 bytes of memory per inode. If we decide that 8 bytes of
> memory isn't a big code, we can convert this to a list_head and just
> link the inodes directly to a unlinked list head in the perag.[**]
> 
> This gets rid of the entire unlinked list reference hash table that
> is used to track this back pointer relationship, greatly simplifying
> the unlinked list modification code.
> 
> Comments, flames, thoughts all welcome.
> 
> -Dave.
> 
> [*] An in-memory double linked list removes the need for keeping
> lists short to minimise previous inode lookup overhead when removing
> from the list. The current backref hash has this function, but it's
> not obvious that it can do this and it's a kinda complex way of
> implementing a double linked list.
> 
> Once we've removed the need for keeping the lists short, we no
> longer need the on-disk hash for unlinked lists, so we can put all
> the inodes in a single list....
> 
> [**] A single unlinked list in the per-ag then leads to a mutex in
> the per-ag to protect the list, removing the AGI lock from needing
> to be held to modify the unlinked list unless the head of the list
> is being modified. We can then add to the tail of the list instead
> of the head, hence largely removing the AGI from the unlinked list
> processing entirely when there is more than one inode on the
> unlinked list.[***]
> 
> This is another advantage of moving to single unlinked list - we are
> much more likely to have multiple inodes on a single unlinked list
> than when they are spread across 64 lists. Hence we are more likely
> to be able to elide AGI locking for the unlinked list modifications
> the more pressure we put on the unlinked list...
> 
> [***] Taking the AGI out of the unlinked list processing means the
> only thing it "protects" is the contents of the AGI itself. This is
> basically updating accounting and tracking btree root pointers. We
> could add another in-memory log item for AGI updates such that the
> AGI only needs to be locked, updated and logged in the precommit
> function, greatly reducing the time it spends locked for inode
> unlink processing [*^4. This will improve performance of inode
> alloc/freeing on AG constrained filessytems as we spend less time
> serialising on the AGI lock.....
> 
> [*^4] This is how superblock updates work, except it's not by a
> generic in-memory SB log item - the changes to accounting are stored
> directly in the struct xfs_trans as deltas and then applied in
> xfs_trans_commit() via xfs_trans_apply_sb_deltas() which locks,
> applies and logs the superblock buffer. This could be converted to a
> precommit operation, too. [*^5]
> 
> Note that this superblock locking is elided for the freespace and
> inode accounting when lazy superblock updates are enabled. This
> prevents the superblock buffer lock for transactional accounting
> update from being a major global contention point.
> 
> [*^5] dquots also use a delta accounting structure hard coded into
> the struct xfs_trans - the xfs_dquot_acct structure. This gets
> allocated when dquot modifications are reserved, and then updated
> with each quota modification that is made in the transaction.
> 
> Then, in xfs_trans_commit(), it calls xfs_trans_apply_dquot_deltas()
> which then orders the locking of the dquots correct, reads, loads
> and locks the dquots, modifies the in-memory on-disk dquots and logs
> them. This could also be converted to pre-commit operations. [*^6]
> 
> [*^6] It should be obvious by now that the pattern of "pre-commit
> processing" for "delayed object modification" is not a new idea.
> It's been in the code for 25-odd years and copy-pasta'd through the
> ages as needed. It's never been turned into a useful, formalised
> infrastructure mechanism - that's what this patchset starts us down
> the path of. It kinda reminds me of the btree infrastructure
> abstraction I did years ago to get rid fo the the 15,000 lines of
> copy-pastad btree code and set us on the path to the (relatively)
> easy addition of more btrees....
> 
> 
> 
> Dave Chinner (12):
>   xfs: xfs_iflock is no longer a completion
>   xfs: add log item precommit operation
>   xfs: factor the xfs_iunlink functions
>   xfs: add unlink list pointers to xfs_inode
>   xfs: replace iunlink backref lookups with list lookups
>   xfs: mapping unlinked inodes is now redundant
>   xfs: updating i_next_unlinked doesn't need to return old value
>   xfs: validate the unlinked list pointer on update
>   xfs: re-order AGI updates in unlink list updates
>   xfs: combine iunlink inode update functions
>   xfs: add in-memory iunlink log item
>   xfs: reorder iunlink remove operation in xfs_ifree
> 
> Gao Xiang (1):
>   xfs: arrange all unlinked inodes into one list
> 
>  fs/xfs/Makefile           |   1 +
>  fs/xfs/xfs_error.c        |   2 -
>  fs/xfs/xfs_icache.c       |  19 +-
>  fs/xfs/xfs_inode.c        | 688 ++++++++------------------------------
>  fs/xfs/xfs_inode.h        |  37 +-
>  fs/xfs/xfs_inode_item.c   |  15 +-
>  fs/xfs/xfs_inode_item.h   |   4 +-
>  fs/xfs/xfs_iunlink_item.c | 168 ++++++++++
>  fs/xfs/xfs_iunlink_item.h |  25 ++
>  fs/xfs/xfs_log_recover.c  | 179 ++++++----
>  fs/xfs/xfs_mount.c        |  17 +-
>  fs/xfs/xfs_mount.h        |   1 +
>  fs/xfs/xfs_super.c        |  20 +-
>  fs/xfs/xfs_trace.h        |   1 -
>  fs/xfs/xfs_trans.c        |  91 +++++
>  fs/xfs/xfs_trans.h        |   6 +-
>  16 files changed, 587 insertions(+), 687 deletions(-)
>  create mode 100644 fs/xfs/xfs_iunlink_item.c
>  create mode 100644 fs/xfs/xfs_iunlink_item.h
> 
> -- 
> 2.26.2.761.g0e0b3e54be
> 
