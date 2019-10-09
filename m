Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 667A7D05D4
	for <lists+linux-xfs@lfdr.de>; Wed,  9 Oct 2019 05:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730344AbfJIDVb (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 8 Oct 2019 23:21:31 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:57575 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730098AbfJIDVb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 8 Oct 2019 23:21:31 -0400
Received: from dread.disaster.area (pa49-181-226-196.pa.nsw.optusnet.com.au [49.181.226.196])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 404CD362D5A;
        Wed,  9 Oct 2019 14:21:28 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.2)
        (envelope-from <david@fromorbit.com>)
        id 1iI2XX-0006Bg-4w; Wed, 09 Oct 2019 14:21:27 +1100
Received: from dave by discord.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1iI2XX-00039Z-2i; Wed, 09 Oct 2019 14:21:27 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 14/26] mm: back off direct reclaim on excessive shrinker deferral
Date:   Wed,  9 Oct 2019 14:21:12 +1100
Message-Id: <20191009032124.10541-15-david@fromorbit.com>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20191009032124.10541-1-david@fromorbit.com>
References: <20191009032124.10541-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=dRuLqZ1tmBNts2YiI0zFQg==:117 a=dRuLqZ1tmBNts2YiI0zFQg==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=XobE76Q3jBoA:10 a=20KFwNOVAAAA:8
        a=c3jh6I83BcSAbW0NpfQA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

When the majority of possible shrinker reclaim work is deferred by
the shrinkers (e.g. due to GFP_NOFS context), and there is more work
defered than LRU pages were scanned, back off reclaim if there are
large amounts of IO in progress.

This tends to occur when there are inode cache heavy workloads that
have little page cache or application memory pressure on filesytems
like XFS. Inode cache heavy workloads involve lots of IO, so if we
are getting device congestion it is indicative of memory reclaim
running up against an IO throughput limitation. in this situation
we need to throttle direct reclaim as we nee dto wait for kswapd to
get some of the deferred work done.

However, if there is no device congestion, then the system is
keeping up with both the workload and memory reclaim and so there's
no need to throttle.

Hence we should only back off scanning for a bit if we see this
condition and there is block device congestion present.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/linux/swap.h |  2 ++
 mm/vmscan.c          | 30 +++++++++++++++++++++++++++++-
 2 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 72b855fe20b0..da0913e14bb9 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -131,6 +131,8 @@ union swap_header {
  */
 struct reclaim_state {
 	unsigned long	reclaimed_pages;	/* pages freed by shrinkers */
+	unsigned long	scanned_objects;	/* quantity of work done */ 
+	unsigned long	deferred_objects;	/* work that wasn't done */
 };
 
 /*
diff --git a/mm/vmscan.c b/mm/vmscan.c
index feea179bcb67..fe8e8508f98d 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -569,6 +569,8 @@ static unsigned long do_shrink_slab(struct shrink_control *shrinkctl,
 		deferred_count = min(deferred_count, freeable_objects * 2);
 
 	}
+	if (current->reclaim_state)
+		current->reclaim_state->scanned_objects += scanned_objects;
 
 	/*
 	 * Avoid risking looping forever due to too large nr value:
@@ -584,8 +586,11 @@ static unsigned long do_shrink_slab(struct shrink_control *shrinkctl,
 	 * If the shrinker can't run (e.g. due to gfp_mask constraints), then
 	 * defer the work to a context that can scan the cache.
 	 */
-	if (shrinkctl->defer_work)
+	if (shrinkctl->defer_work) {
+		if (current->reclaim_state)
+			current->reclaim_state->deferred_objects += scan_count;
 		goto done;
+	}
 
 	/*
 	 * Normally, we should not scan less than batch_size objects in one
@@ -2873,7 +2878,30 @@ static bool shrink_node(pg_data_t *pgdat, struct scan_control *sc)
 
 		if (reclaim_state) {
 			sc->nr_reclaimed += reclaim_state->reclaimed_pages;
+
+			/*
+			 * If we are deferring more work than we are actually
+			 * doing in the shrinkers, and we are scanning more
+			 * objects than we are pages, the we have a large amount
+			 * of slab caches we are deferring work to kswapd for.
+			 * We better back off here for a while, otherwise
+			 * we risk priority windup, swap storms and OOM kills
+			 * once we empty the page lists but still can't make
+			 * progress on the shrinker memory.
+			 *
+			 * kswapd won't ever defer work as it's run under a
+			 * GFP_KERNEL context and can always do work.
+			 */
+			if ((reclaim_state->deferred_objects >
+					sc->nr_scanned - nr_scanned) &&
+			    (reclaim_state->deferred_objects >
+					reclaim_state->scanned_objects)) {
+				wait_iff_congested(BLK_RW_ASYNC, HZ/50);
+			}
+
 			reclaim_state->reclaimed_pages = 0;
+			reclaim_state->deferred_objects = 0;
+			reclaim_state->scanned_objects = 0;
 		}
 
 		/* Record the subtree's reclaim efficiency */
-- 
2.23.0.rc1

