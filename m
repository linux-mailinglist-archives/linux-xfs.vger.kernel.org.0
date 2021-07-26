Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC1593D5306
	for <lists+linux-xfs@lfdr.de>; Mon, 26 Jul 2021 08:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbhGZF04 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 26 Jul 2021 01:26:56 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:56294 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231696AbhGZF0z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Jul 2021 01:26:55 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 13FC26406
        for <linux-xfs@vger.kernel.org>; Mon, 26 Jul 2021 16:07:19 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m7tlm-00AtQN-Qr
        for linux-xfs@vger.kernel.org; Mon, 26 Jul 2021 16:07:18 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1m7tlm-00DpCW-J2
        for linux-xfs@vger.kernel.org; Mon, 26 Jul 2021 16:07:18 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 08/10] xfs: logging the on disk inode LSN can make it go backwards
Date:   Mon, 26 Jul 2021 16:07:14 +1000
Message-Id: <20210726060716.3295008-9-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210726060716.3295008-1-david@fromorbit.com>
References: <20210726060716.3295008-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=e_q4qTt1xDgA:10 a=20KFwNOVAAAA:8 a=vXU75DgQ00rBU8kzyJMA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

When we log an inode, we format the "log inode" core and set an LSN
in that inode core. We do that via xfs_inode_item_format_core(),
which calls:

	xfs_inode_to_log_dinode(ip, dic, ip->i_itemp->ili_item.li_lsn);

to format the log inode. It writes the LSN from the inode item into
the log inode, and if recovery decides the inode item needs to be
replayed, it recovers the log inode LSN field and writes it into the
on disk inode LSN field.

Now this might seem like a reasonable thing to do, but it is wrong
on multiple levels. Firstly, if the item is not yet in the AIL,
item->li_lsn is zero. i.e. the first time the inode it is logged and
formatted, the LSN we write into the log inode will be zero. If we
only log it once, recovery will run and can write this zero LSN into
the inode.

This means that the next time the inode is logged and log recovery
runs, it will *always* replay changes to the inode regardless of
whether the inode is newer on disk than the version in the log and
that violates the entire purpose of recording the LSN in the inode
at writeback time (i.e. to stop it going backwards in time on disk
during recovery).

Secondly, if we commit the CIL to the journal so the inode item
moves to the AIL, and then relog the inode, the LSN that gets
stamped into the log inode will be the LSN of the inode's current
location in the AIL, not it's age on disk. And it's not the LSN that
will be associated with the current change. That means when log
recovery replays this inode item, the LSN that ends up on disk is
the LSN for the previous changes in the log, not the current
changes being replayed. IOWs, after recovery the LSN on disk is not
in sync with the LSN of the modifications that were replayed into
the inode. This, again, violates the recovery ordering semantics
that on-disk writeback LSNs provide.

Hence the inode LSN in the log dinode is -always- invalid.

Thirdly, recovery actually has the LSN of the log transaction it is
replaying right at hand - it uses it to determine if it should
replay the inode by comparing it to the on-disk inode's LSN. But it
doesn't use that LSN to stamp the LSN into the inode which will be
written back when the transaction is fully replayed. It uses the one
in the log dinode, which we know is always going to be incorrect.

Looking back at the change history, the inode logging was broken by
commit 93f958f9c41f ("xfs: cull unnecessary icdinode fields") way
back in 2016 by a stupid idiot who thought he knew how this code
worked. i.e. me. That commit replaced an in memory di_lsn field that
was updated only at inode writeback time from the inode item.li_lsn
value - and hence always contained the same LSN that appeared in the
on-disk inode - with a read of the inode item LSN at inode format
time. CLearly these are not the same thing.

Before 93f958f9c41f, the log recovery behaviour was irrelevant,
because the LSN in the log inode always matched the on-disk LSN at
the time the inode was logged, hence recovery of the transaction
would never make the on-disk LSN in the inode go backwards or get
out of sync.

A symptom of the problem is this, caught from a failure of
generic/482. Before log recovery, the inode has been allocated but
never used:

xfs_db> inode 393388
xfs_db> p
core.magic = 0x494e
core.mode = 0
....
v3.crc = 0x99126961 (correct)
v3.change_count = 0
v3.lsn = 0
v3.flags2 = 0
v3.cowextsize = 0
v3.crtime.sec = Thu Jan  1 10:00:00 1970
v3.crtime.nsec = 0

After log recovery:

xfs_db> p
core.magic = 0x494e
core.mode = 020444
....
v3.crc = 0x23e68f23 (correct)
v3.change_count = 2
v3.lsn = 0
v3.flags2 = 0
v3.cowextsize = 0
v3.crtime.sec = Thu Jul 22 17:03:03 2021
v3.crtime.nsec = 751000000
...

You can see that the LSN of the on-disk inode is 0, even though it
clearly has been written to disk. I point out this inode, because
the generic/482 failure occurred because several adjacent inodes in
this specific inode cluster were not replayed correctly and still
appeared to be zero on disk when all the other metadata (inobt,
finobt, directories, etc) indicated they should be allocated and
written back.

The fix for this is two-fold. The first is that we need to either
revert the LSN changes in 93f958f9c41f or stop logging the inode LSN
altogether. If we do the former, log recovery does not need to
change but we add 8 bytes of memory per inode to store what is
largely a write-only inode field. If we do the latter, log recovery
needs to stamp the on-disk inode in the same manner that inode
writeback does.

I prefer the latter, because we shouldn't really be trying to log
and replay changes to the on disk LSN as the on-disk value is the
canonical source of the on-disk version of the inode. It also
matches the way we recover buffer items - we create a buf_log_item
that carries the current recovery transaction LSN that gets stamped
into the buffer by the write verifier when it gets written back
when the transaction is fully recovered.

However, this might break log recovery on older kernels even more,
so I'm going to simply ignore the logged value in recovery and stamp
the on-disk inode with the LSN of the transaction being recovered
that will trigger writeback on transaction recovery completion. This
will ensure that the on-disk inode LSN always reflects the LSN of
the last change that was written to disk, regardless of whether it
comes from log recovery or runtime writeback.

Fixes: 93f958f9c41f ("xfs: cull unnecessary icdinode fields")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_log_format.h  | 11 +++++++++-
 fs/xfs/xfs_inode_item_recover.c | 39 ++++++++++++++++++++++++---------
 2 files changed, 39 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index d548ea4b6aab..2c5bcbc19264 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -411,7 +411,16 @@ struct xfs_log_dinode {
 	/* start of the extended dinode, writable fields */
 	uint32_t	di_crc;		/* CRC of the inode */
 	uint64_t	di_changecount;	/* number of attribute changes */
-	xfs_lsn_t	di_lsn;		/* flush sequence */
+
+	/*
+	 * The LSN we write to this field during formatting is not a reflection
+	 * of the current on-disk LSN. It should never be used for recovery
+	 * sequencing, nor should it be recovered into the on-disk inode at all.
+	 * See xlog_recover_inode_commit_pass2() and xfs_log_dinode_to_disk()
+	 * for details.
+	 */
+	xfs_lsn_t	di_lsn;
+
 	uint64_t	di_flags2;	/* more random flags */
 	uint32_t	di_cowextsize;	/* basic cow extent size for file */
 	uint8_t		di_pad2[12];	/* more padding for future expansion */
diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
index 7b79518b6c20..e0072a6cd2d3 100644
--- a/fs/xfs/xfs_inode_item_recover.c
+++ b/fs/xfs/xfs_inode_item_recover.c
@@ -145,7 +145,8 @@ xfs_log_dinode_to_disk_ts(
 STATIC void
 xfs_log_dinode_to_disk(
 	struct xfs_log_dinode	*from,
-	struct xfs_dinode	*to)
+	struct xfs_dinode	*to,
+	xfs_lsn_t		lsn)
 {
 	to->di_magic = cpu_to_be16(from->di_magic);
 	to->di_mode = cpu_to_be16(from->di_mode);
@@ -182,7 +183,7 @@ xfs_log_dinode_to_disk(
 		to->di_flags2 = cpu_to_be64(from->di_flags2);
 		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
 		to->di_ino = cpu_to_be64(from->di_ino);
-		to->di_lsn = cpu_to_be64(from->di_lsn);
+		to->di_lsn = cpu_to_be64(lsn);
 		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
 		uuid_copy(&to->di_uuid, &from->di_uuid);
 		to->di_flushiter = 0;
@@ -261,16 +262,25 @@ xlog_recover_inode_commit_pass2(
 	}
 
 	/*
-	 * If the inode has an LSN in it, recover the inode only if it's less
-	 * than the lsn of the transaction we are replaying. Note: we still
-	 * need to replay an owner change even though the inode is more recent
-	 * than the transaction as there is no guarantee that all the btree
-	 * blocks are more recent than this transaction, too.
+	 * If the inode has an LSN in it, recover the inode only if the on-disk
+	 * inode's LSN is older than the lsn of the transaction we are
+	 * replaying. We can have multiple checkpoints with the same start LSN,
+	 * so the current LSN being equal to the on-disk LSN doesn't necessarily
+	 * mean that the on-disk inode is more recent than the change being
+	 * replayed.
+	 *
+	 * We must check the current_lsn against the on-disk inode
+	 * here because the we can't trust the log dinode to contain a valid LSN
+	 * (see comment below before replaying the log dinode for details).
+	 *
+	 * Note: we still need to replay an owner change even though the inode
+	 * is more recent than the transaction as there is no guarantee that all
+	 * the btree blocks are more recent than this transaction, too.
 	 */
 	if (dip->di_version >= 3) {
 		xfs_lsn_t	lsn = be64_to_cpu(dip->di_lsn);
 
-		if (lsn && lsn != -1 && XFS_LSN_CMP(lsn, current_lsn) >= 0) {
+		if (lsn && lsn != -1 && XFS_LSN_CMP(lsn, current_lsn) > 0) {
 			trace_xfs_log_recover_inode_skip(log, in_f);
 			error = 0;
 			goto out_owner_change;
@@ -368,8 +378,17 @@ xlog_recover_inode_commit_pass2(
 		goto out_release;
 	}
 
-	/* recover the log dinode inode into the on disk inode */
-	xfs_log_dinode_to_disk(ldip, dip);
+	/*
+	 * Recover the log dinode inode into the on disk inode.
+	 *
+	 * The LSN in the log dinode is garbage - it can be zero or reflect
+	 * stale in-memory runtime state that isn't coherent with the changes
+	 * logged in this transaction or the changes written to the on-disk
+	 * inode.  Hence we write the current lSN into the inode because that
+	 * matches what xfs_iflush() would write inode the inode when flushing
+	 * the changes in this transaction.
+	 */
+	xfs_log_dinode_to_disk(ldip, dip, current_lsn);
 
 	fields = in_f->ilf_fields;
 	if (fields & XFS_ILOG_DEV)
-- 
2.31.1

