Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55B2BA2CAD
	for <lists+linux-xfs@lfdr.de>; Fri, 30 Aug 2019 04:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbfH3CNk (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 29 Aug 2019 22:13:40 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:45763 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727066AbfH3CNk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Aug 2019 22:13:40 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id EB0B043E96A;
        Fri, 30 Aug 2019 12:13:31 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i3WPp-0002YW-LG; Fri, 30 Aug 2019 12:13:29 +1000
Date:   Fri, 30 Aug 2019 12:13:29 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chandan Rajendra <chandan@linux.ibm.com>
Cc:     Brian Foster <bfoster@redhat.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        hch@infradead.org
Subject: Re: [RFC] xfs: Flush iclog containing XLOG_COMMIT_TRANS before
 waiting for log space
Message-ID: <20190830021329.GB1119@dread.disaster.area>
References: <20190821110448.30161-1-chandanrlinux@gmail.com>
 <3457989.EyS6152c1k@localhost.localdomain>
 <20190826003253.GK1119@dread.disaster.area>
 <783535067.D5oYYkGoWf@localhost.localdomain>
 <20190829230817.GW1119@dread.disaster.area>
 <20190830003441.GY1119@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190830003441.GY1119@dread.disaster.area>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10
        a=7-415B0cAAAA:8 a=20KFwNOVAAAA:8 a=7Q2-SO56R8pWWUt_uDsA:9
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 30, 2019 at 10:34:41AM +1000, Dave Chinner wrote:
> On Fri, Aug 30, 2019 at 09:08:17AM +1000, Dave Chinner wrote:
> > On Thu, Aug 29, 2019 at 10:51:59AM +0530, Chandan Rajendra wrote:
> > > 	 786576: kworker/4:1H-kb  1825 [004]   217.041079:                       xfs:xfs_log_assign_tail_lsn: dev 7:1 new tail lsn 2/19333, old lsn 2/19330, last sync 3/18501
> > 
> > 200ms later the tail has moved, and last_sync_lsn is now 3/18501.
> > i.e. the iclog writes have made it to disk, and the items have been
> > moved into the AIL. I don't know where that came from, but I'm
> > assuming it's an IO completion based on it being run from a
> > kworker context that doesn't have an "xfs-" name prefix(*).
> > 
> > As the tail has moved, this should have woken the anything sleeping
> > on the log tail in xlog_grant_head_wait() via a call to
> > xfs_log_space_wake(). The first waiter should wake, see that there
> > still isn't room in the log (only 3 sectors were freed in the log,
> > we need at least 60). That woken process should then run
> > xlog_grant_push_ail() again and go back to sleep.
> 
> Actually, it doesn't get woken because xlog_grant_head_wake() checks
> how much space is available before waking waiters, and there clearly
> isn't enough here. So that's one likely vector. Can you try this
> patch?

And this one on top to address the situation the previous patch
doesn't....

-Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: push the grant head when the log head moves forward

From: Dave Chinner <dchinner@redhat.com>

When the log fills up, we can get into the state where the
outstanding items in the CIL being committed and aggregated are
larger than the range that the reservation grant head tail pushing
will attempt to clean. This can result in the tail pushing range
being trimmed back to the the log head (l_last_sync_lsn) and so
may not actually move the push target at all.

When the iclogs associated with the CIL commit finally land, the
log head moves forward, and this removes the restriction on the AIL
push target. However, if we already have transactions sleeping on
the grant head, and there's nothing in the AIL still to flush from
the current push target, then nothing will move the tail of the log
and trigger a log reservation wakeup.

Hence the there is nothing that will trigger xlog_grant_push_ail()
to recalculate the AIL push target and start pushing on the AIL
again to write back the metadata objects that pin the tail of the
log and hence free up space and allow the transaction reservations
to be woken and make progress.

Hence we need to push on the grant head when we move the log head
forward, as this may be the only trigger we have that can move the
AIL push target forwards in this situation.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c | 65 ++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 40 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 941f10ff99d9..ce46bb244442 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2612,6 +2612,45 @@ xlog_get_lowest_lsn(
 	return lowest_lsn;
 }
 
+
+/*
+ * Completion of a iclog IO does not imply that a transaction has completed, as
+ * transactions can be large enough to span many iclogs. We cannot change the
+ * tail of the log half way through a transaction as this may be the only
+ * transaction in the log and moving the tail to point to the middle of it
+ * will prevent recovery from finding the start of the transaction. Hence we
+ * should only update the last_sync_lsn if this iclog contains transaction
+ * completion callbacks on it.
+ *
+ * We have to do this before we drop the icloglock to ensure we are the only one
+ * that can update it.
+ *
+ * If we are moving the last_sync_lsn forwards, we also need to ensure we kick
+ * the reservation grant head pushing. This is due to the fact that the push
+ * target is bound by the current last_sync_lsn value. Hence if we have a large
+ * amount of log space bound up in this committing transaction then the
+ * last_sync_lsn value may be the limiting factor preventing tail pushing from
+ * freeing space in the log. Hence once we've updated the last_sync_lsn we
+ * should push the AIL to ensure the push target (and hence the grant head) is
+ * no longer bound by the old log head location and can move forwards and make
+ * progress again.
+ */
+static void
+xlog_iclog_iodone(
+	struct xlog		*log,
+	struct xlog_in_core	*iclog)
+{
+	ASSERT(XFS_LSN_CMP(atomic64_read(&log->l_last_sync_lsn),
+		be64_to_cpu(iclog->ic_header.h_lsn)) <= 0);
+
+	if (list_empty_careful(&iclog->ic_callbacks))
+		return;
+
+	atomic64_set(&log->l_last_sync_lsn, be64_to_cpu(iclog->ic_header.h_lsn));
+	xlog_grant_push_ail(log, 0);
+
+}
+
 STATIC void
 xlog_state_do_callback(
 	struct xlog		*log,
@@ -2710,31 +2749,7 @@ xlog_state_do_callback(
 				}
 
 				iclog->ic_state = XLOG_STATE_CALLBACK;
-
-
-				/*
-				 * Completion of a iclog IO does not imply that
-				 * a transaction has completed, as transactions
-				 * can be large enough to span many iclogs. We
-				 * cannot change the tail of the log half way
-				 * through a transaction as this may be the only
-				 * transaction in the log and moving th etail to
-				 * point to the middle of it will prevent
-				 * recovery from finding the start of the
-				 * transaction. Hence we should only update the
-				 * last_sync_lsn if this iclog contains
-				 * transaction completion callbacks on it.
-				 *
-				 * We have to do this before we drop the
-				 * icloglock to ensure we are the only one that
-				 * can update it.
-				 */
-				ASSERT(XFS_LSN_CMP(atomic64_read(&log->l_last_sync_lsn),
-					be64_to_cpu(iclog->ic_header.h_lsn)) <= 0);
-				if (!list_empty_careful(&iclog->ic_callbacks))
-					atomic64_set(&log->l_last_sync_lsn,
-						be64_to_cpu(iclog->ic_header.h_lsn));
-
+				xlog_iclog_iodone(log, iclog);
 			} else
 				ioerrors++;
 
