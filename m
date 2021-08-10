Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 178EC3D7009
	for <lists+linux-xfs@lfdr.de>; Tue, 27 Jul 2021 09:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234803AbhG0HKY (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 27 Jul 2021 03:10:24 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:50457 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235653AbhG0HKV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Jul 2021 03:10:21 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id C77AA863A9C
        for <linux-xfs@vger.kernel.org>; Tue, 27 Jul 2021 17:10:17 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m8HEH-00BI44-13
        for linux-xfs@vger.kernel.org; Tue, 27 Jul 2021 17:10:17 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1m8HEG-00E5b7-PY
        for linux-xfs@vger.kernel.org; Tue, 27 Jul 2021 17:10:16 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 09/11] xfs: Enforce attr3 buffer recovery order
Date:   Tue, 27 Jul 2021 17:10:10 +1000
Message-Id: <20210727071012.3358033-10-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210727071012.3358033-1-david@fromorbit.com>
References: <20210727071012.3358033-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=e_q4qTt1xDgA:10 a=20KFwNOVAAAA:8 a=l0_hGK4vAAAA:8 a=VwQbUJbxAAAA:8
        a=GQI1gN7cFB_rTw0HXYgA:9 a=iXasW65n-xxAZI4iijma:22
        a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

From the department of "WTAF? How did we miss that!?"...

When we are recovering a buffer, the first thing we do is check the
buffer magic number and extract the LSN from the buffer. If the LSN
is older than the current LSN, we replay the modification to it. If
the metadata on disk is newer than the transaction in the log, we
skip it. This is a fundamental v5 filesystem metadata recovery
behaviour.

generic/482 failed with an attribute writeback failure during log
recovery. The write verifier caught the corruption before it got
written to disk, and the attr buffer dump looked like:

XFS (dm-3): Metadata corruption detected at xfs_attr3_leaf_verify+0x275/0x2e0, xfs_attr3_leaf block 0x19be8
XFS (dm-3): Unmount and run xfs_repair
XFS (dm-3): First 128 bytes of corrupted metadata buffer:
00000000: 00 00 00 00 00 00 00 00 3b ee 00 00 4d 2a 01 e1  ........;...M*..
00000010: 00 00 00 00 00 01 9b e8 00 00 00 01 00 00 05 38  ...............8
                                  ^^^^^^^^^^^^^^^^^^^^^^^
00000020: df 39 5e 51 58 ac 44 b6 8d c5 e7 10 44 09 bc 17  .9^QX.D.....D...
00000030: 00 00 00 00 00 02 00 83 00 03 00 cc 0f 24 01 00  .............$..
00000040: 00 68 0e bc 0f c8 00 10 00 00 00 00 00 00 00 00  .h..............
00000050: 00 00 3c 31 0f 24 01 00 00 00 3c 32 0f 88 01 00  ..<1.$....<2....
00000060: 00 00 3c 33 0f d8 01 00 00 00 00 00 00 00 00 00  ..<3............
00000070: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
.....

The highlighted bytes are the LSN that was replayed into the
buffer: 0x100000538. This is cycle 1, block 0x538. Prior to replay,
that block on disk looks like this:

$ sudo xfs_db -c "fsb 0x417d" -c "type attr3" -c p /dev/mapper/thin-vol
hdr.info.hdr.forw = 0
hdr.info.hdr.back = 0
hdr.info.hdr.magic = 0x3bee
hdr.info.crc = 0xb5af0bc6 (correct)
hdr.info.bno = 105448
hdr.info.lsn = 0x100000900
               ^^^^^^^^^^^
hdr.info.uuid = df395e51-58ac-44b6-8dc5-e7104409bc17
hdr.info.owner = 131203
hdr.count = 2
hdr.usedbytes = 120
hdr.firstused = 3796
hdr.holes = 1
hdr.freemap[0-2] = [base,size]

Note the LSN stamped into the buffer on disk: 1/0x900. The version
on disk is much newer than the log transaction that was being
replayed. That's a bug, and should -never- happen.

So I immediately went to look at xlog_recover_get_buf_lsn() to check
that we handled the LSN correctly. I was wondering if there was a
similar "two commits with the same start LSN skips the second
replay" problem with buffers. I didn't get that far, because I found
a much more basic, rudimentary bug: xlog_recover_get_buf_lsn()
doesn't recognise buffers with XFS_ATTR3_LEAF_MAGIC set in them!!!

IOWs, attr3 leaf buffers fall through the magic number checks
unrecognised, so trigger the "recover immediately" behaviour instead
of undergoing an LSN check. IOWs, we incorrectly replay ATTR3 leaf
buffers and that causes silent on disk corruption of inode attribute
forks and potentially other things....

Git history shows this is *another* zero day bug, this time
introduced in commit 50d5c8d8e938 ("xfs: check LSN ordering for v5
superblocks during recovery") which failed to handle the attr3 leaf
buffers in recovery. And we've failed to handle them ever since...

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_buf_item_recover.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index d44e8b4a3391..05fd816edf59 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -796,6 +796,7 @@ xlog_recover_get_buf_lsn(
 	switch (magicda) {
 	case XFS_DIR3_LEAF1_MAGIC:
 	case XFS_DIR3_LEAFN_MAGIC:
+	case XFS_ATTR3_LEAF_MAGIC:
 	case XFS_DA3_NODE_MAGIC:
 		lsn = be64_to_cpu(((struct xfs_da3_blkinfo *)blk)->lsn);
 		uuid = &((struct xfs_da3_blkinfo *)blk)->uuid;
-- 
2.31.1

