Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA0D93999DB
	for <lists+linux-xfs@lfdr.de>; Thu,  3 Jun 2021 07:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbhFCFYx (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 3 Jun 2021 01:24:53 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:45122 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229640AbhFCFYw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Jun 2021 01:24:52 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id F2F0B68072
        for <linux-xfs@vger.kernel.org>; Thu,  3 Jun 2021 15:22:50 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lofog-008Mq2-DE
        for linux-xfs@vger.kernel.org; Thu, 03 Jun 2021 15:22:50 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lofog-000ilN-5S
        for linux-xfs@vger.kernel.org; Thu, 03 Jun 2021 15:22:50 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 04/39] xfs: async blkdev cache flush
Date:   Thu,  3 Jun 2021 15:22:05 +1000
Message-Id: <20210603052240.171998-5-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210603052240.171998-1-david@fromorbit.com>
References: <20210603052240.171998-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=r6YtysWOX24A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
        a=xC2MDfIwAKB5AMCYbWUA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

The new checkpoint cache flush mechanism requires us to issue an
unconditional cache flush before we start a new checkpoint. We don't
want to block for this if we can help it, and we have a fair chunk
of CPU work to do between starting the checkpoint and issuing the
first journal IO.

Hence it makes sense to amortise the latency cost of the cache flush
by issuing it asynchronously and then waiting for it only when we
need to issue the first IO in the transaction.

To do this, we need async cache flush primitives to submit the cache
flush bio and to wait on it. The block layer has no such primitives
for filesystems, so roll our own for the moment.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/xfs_bio_io.c | 35 +++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_linux.h  |  2 ++
 2 files changed, 37 insertions(+)

diff --git a/fs/xfs/xfs_bio_io.c b/fs/xfs/xfs_bio_io.c
index 17f36db2f792..667e297f59b1 100644
--- a/fs/xfs/xfs_bio_io.c
+++ b/fs/xfs/xfs_bio_io.c
@@ -9,6 +9,41 @@ static inline unsigned int bio_max_vecs(unsigned int count)
 	return bio_max_segs(howmany(count, PAGE_SIZE));
 }
 
+static void
+xfs_flush_bdev_async_endio(
+	struct bio	*bio)
+{
+	complete(bio->bi_private);
+}
+
+/*
+ * Submit a request for an async cache flush to run. If the request queue does
+ * not require flush operations, just skip it altogether. If the caller needs
+ * to wait for the flush completion at a later point in time, they must supply a
+ * valid completion. This will be signalled when the flush completes.  The
+ * caller never sees the bio that is issued here.
+ */
+void
+xfs_flush_bdev_async(
+	struct bio		*bio,
+	struct block_device	*bdev,
+	struct completion	*done)
+{
+	struct request_queue	*q = bdev->bd_disk->queue;
+
+	if (!test_bit(QUEUE_FLAG_WC, &q->queue_flags)) {
+		complete(done);
+		return;
+	}
+
+	bio_init(bio, NULL, 0);
+	bio_set_dev(bio, bdev);
+	bio->bi_opf = REQ_OP_WRITE | REQ_PREFLUSH | REQ_SYNC;
+	bio->bi_private = done;
+	bio->bi_end_io = xfs_flush_bdev_async_endio;
+
+	submit_bio(bio);
+}
 int
 xfs_rw_bdev(
 	struct block_device	*bdev,
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 7688663b9773..c174262a074e 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -196,6 +196,8 @@ static inline uint64_t howmany_64(uint64_t x, uint32_t y)
 
 int xfs_rw_bdev(struct block_device *bdev, sector_t sector, unsigned int count,
 		char *data, unsigned int op);
+void xfs_flush_bdev_async(struct bio *bio, struct block_device *bdev,
+		struct completion *done);
 
 #define ASSERT_ALWAYS(expr)	\
 	(likely(expr) ? (void)0 : assfail(NULL, #expr, __FILE__, __LINE__))
-- 
2.31.1

