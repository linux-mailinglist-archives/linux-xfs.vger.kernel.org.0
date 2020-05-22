Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 572471DDE54
	for <lists+linux-xfs@lfdr.de>; Fri, 22 May 2020 05:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728100AbgEVDuf (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 21 May 2020 23:50:35 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:51146 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727914AbgEVDuf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 May 2020 23:50:35 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id 895015AA2C0
        for <linux-xfs@vger.kernel.org>; Fri, 22 May 2020 13:50:32 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jbyha-0002Va-OE
        for linux-xfs@vger.kernel.org; Fri, 22 May 2020 13:50:30 +1000
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jbyha-00CgID-G4
        for linux-xfs@vger.kernel.org; Fri, 22 May 2020 13:50:30 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 13/24] xfs: make inode reclaim almost non-blocking
Date:   Fri, 22 May 2020 13:50:18 +1000
Message-Id: <20200522035029.3022405-14-david@fromorbit.com>
X-Mailer: git-send-email 2.26.2.761.g0e0b3e54be
In-Reply-To: <20200522035029.3022405-1-david@fromorbit.com>
References: <20200522035029.3022405-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=sTwFKg_x9MkA:10 a=20KFwNOVAAAA:8 a=A2ig2MbBs_zKB9zLTN4A:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Now that dirty inode writeback doesn't cause read-modify-write
cycles on the inode cluster buffer under memory pressure, the need
to throttle memory reclaim to the rate at which we can clean dirty
inodes goes away. That is due to the fact that we no longer thrash
inode cluster buffers under memory pressure to clean dirty inodes.

This means inode writeback no longer stalls on memory allocation
or read IO, and hence can be done asynchrnously without generating
memory pressure. As a result, blocking inode writeback in reclaim is
no longer necessary to prevent reclaim priority windup as cleaning
dirty inodes is no longer dependent on having memory reserves
available for the filesystem to make progress reclaiming inodes.

Hence we can convert inode reclaim to be non-blocking for shrinker
callouts, both for direct reclaim and kswapd.

On a vanilla kernel, running a 16-way fsmark create workload on a
4 node/16p/16GB RAM machine, I can reliably pin 14.75GB of RAM via
userspace mlock(). The OOM killer gets invoked at 15GB of
pinned RAM.

With this patch alone, pinning memory triggers premature OOM
killer invocation, sometimes with as much as 45% of RAM being free.
It's trivially easy to trigger the OOM killer when reclaim does not
block.

With pinning inode clusters in RAM adn then adding this patch, I can
reliably pin 14.5GB of RAM and still have the fsmark workload run to
completion. The OOM killer gets invoked 14.75GB of pinned RAM, which
is only a small amount of memory less than the vanilla kernel. It is
much more reliable than just with async reclaim alone.

simoops shows that allocation stalls go away when async reclaim is
used. Vanilla kernel:

Run time: 1924 seconds
Read latency (p50: 3,305,472) (p95: 3,723,264) (p99: 4,001,792)
Write latency (p50: 184,064) (p95: 553,984) (p99: 807,936)
Allocation latency (p50: 2,641,920) (p95: 3,911,680) (p99: 4,464,640)
work rate = 13.45/sec (avg 13.44/sec) (p50: 13.46) (p95: 13.58) (p99: 13.70)
alloc stall rate = 3.80/sec (avg: 2.59) (p50: 2.54) (p95: 2.96) (p99: 3.02)

With inode cluster pinning and async reclaim:

Run time: 1924 seconds
Read latency (p50: 3,305,472) (p95: 3,715,072) (p99: 3,977,216)
Write latency (p50: 187,648) (p95: 553,984) (p99: 789,504)
Allocation latency (p50: 2,748,416) (p95: 3,919,872) (p99: 4,448,256)
work rate = 13.28/sec (avg 13.32/sec) (p50: 13.26) (p95: 13.34) (p99: 13.34)
alloc stall rate = 0.02/sec (avg: 0.02) (p50: 0.01) (p95: 0.03) (p99: 0.03)

Latencies don't really change much, nor does the work rate. However,
allocation almost never stalls with these changes, whilst the
vanilla kernel is sometimes reporting 20 stalls/s over a 60s sample
period. This difference is due to inode reclaim being largely
non-blocking now.

IOWs, once we have pinned inode cluster buffers, we can make inode
reclaim non-blocking without a major risk of premature and/or
spurious OOM killer invocation, and without any changes to memory
reclaim infrastructure.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_icache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index d806d3bfa8936..0f0f8fcd61b03 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1420,7 +1420,7 @@ xfs_reclaim_inodes_nr(
 	xfs_reclaim_work_queue(mp);
 	xfs_ail_push_all(mp->m_ail);
 
-	return xfs_reclaim_inodes_ag(mp, SYNC_TRYLOCK | SYNC_WAIT, &nr_to_scan);
+	return xfs_reclaim_inodes_ag(mp, SYNC_TRYLOCK, &nr_to_scan);
 }
 
 /*
-- 
2.26.2.761.g0e0b3e54be

