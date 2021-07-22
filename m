Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 346E03D1B87
	for <lists+linux-xfs@lfdr.de>; Thu, 22 Jul 2021 03:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbhGVBNG (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 21 Jul 2021 21:13:06 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:35634 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230045AbhGVBNG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Jul 2021 21:13:06 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 76D9B1044DF1
        for <linux-xfs@vger.kernel.org>; Thu, 22 Jul 2021 11:53:39 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m6Nu6-009JQD-Ae
        for linux-xfs@vger.kernel.org; Thu, 22 Jul 2021 11:53:38 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1m6Nu6-00Cqua-2x
        for linux-xfs@vger.kernel.org; Thu, 22 Jul 2021 11:53:38 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/5] xfs: external logs need to flush data device
Date:   Thu, 22 Jul 2021 11:53:32 +1000
Message-Id: <20210722015335.3063274-3-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210722015335.3063274-1-david@fromorbit.com>
References: <20210722015335.3063274-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=e_q4qTt1xDgA:10 a=20KFwNOVAAAA:8 a=edIB7ZaJnL-MFb9X88MA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The recent journal flush/FUA changes replaced the flushing of the
data device on every iclog write with an up-front async data device
cache flush. Unfortunately, the assumption of which this was based
on has been proven incorrect by the flush vs log tail update
ordering issue. As the fix for that issue uses the
XLOG_ICL_NEED_FLUSH flag to indicate that data device needs a cache
flush, we now need to (once again) ensure that an iclog write to
external logs that need a cache flush to be issued actually issue a
cache flush to the data device as well as the log device.

Fixes: eef983ffeae7 ("xfs: journal IO cache flush reductions")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 96434cc4df6e..a3c4d48195d9 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -827,13 +827,6 @@ xlog_write_unmount_record(
 	/* account for space used by record data */
 	ticket->t_curr_res -= sizeof(ulf);
 
-	/*
-	 * For external log devices, we need to flush the data device cache
-	 * first to ensure all metadata writeback is on stable storage before we
-	 * stamp the tail LSN into the unmount record.
-	 */
-	if (log->l_targ != log->l_mp->m_ddev_targp)
-		blkdev_issue_flush(log->l_mp->m_ddev_targp->bt_bdev);
 	return xlog_write(log, &vec, ticket, NULL, NULL, XLOG_UNMOUNT_TRANS);
 }
 
@@ -1796,10 +1789,20 @@ xlog_write_iclog(
 	 * metadata writeback and causing priority inversions.
 	 */
 	iclog->ic_bio.bi_opf = REQ_OP_WRITE | REQ_META | REQ_SYNC | REQ_IDLE;
-	if (iclog->ic_flags & XLOG_ICL_NEED_FLUSH)
+	if (iclog->ic_flags & XLOG_ICL_NEED_FLUSH) {
 		iclog->ic_bio.bi_opf |= REQ_PREFLUSH;
+		/*
+		 * For external log devices, we also need to flush the data
+		 * device cache first to ensure all metadata writeback covered
+		 * by the LSN in this iclog is on stable storage. This is slow,
+		 * but it *must* complete before we issue the external log IO.
+		 */
+		if (log->l_targ != log->l_mp->m_ddev_targp)
+			blkdev_issue_flush(log->l_mp->m_ddev_targp->bt_bdev);
+	}
 	if (iclog->ic_flags & XLOG_ICL_NEED_FUA)
 		iclog->ic_bio.bi_opf |= REQ_FUA;
+
 	iclog->ic_flags &= ~(XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FUA);
 
 	if (xlog_map_iclog_data(&iclog->ic_bio, iclog->ic_data, count)) {
-- 
2.31.1

