Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E25CB388DB2
	for <lists+linux-xfs@lfdr.de>; Wed, 19 May 2021 14:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345208AbhESMOr (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 19 May 2021 08:14:47 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:49202 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346316AbhESMOo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 May 2021 08:14:44 -0400
Received: from dread.disaster.area (pa49-195-118-180.pa.nsw.optusnet.com.au [49.195.118.180])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 802B9861550
        for <linux-xfs@vger.kernel.org>; Wed, 19 May 2021 22:13:20 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ljL4h-002m0N-GB
        for linux-xfs@vger.kernel.org; Wed, 19 May 2021 22:13:19 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1ljL4h-002SGU-82
        for linux-xfs@vger.kernel.org; Wed, 19 May 2021 22:13:19 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 01/39] xfs: log stripe roundoff is a property of the log
Date:   Wed, 19 May 2021 22:12:39 +1000
Message-Id: <20210519121317.585244-2-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519121317.585244-1-david@fromorbit.com>
References: <20210519121317.585244-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=xcwBwyABtj18PbVNKPPJDQ==:117 a=xcwBwyABtj18PbVNKPPJDQ==:17
        a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8
        a=D3aekpjFca_zLI-q5woA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

We don't need to look at the xfs_mount and superblock every time we
need to do an iclog roundoff calculation. The property is fixed for
the life of the log, so store the roundoff in the log at mount time
and use that everywhere.

On a debug build:

$ size fs/xfs/xfs_log.o.*
   text	   data	    bss	    dec	    hex	filename
  27360	    560	      8	  27928	   6d18	fs/xfs/xfs_log.o.orig
  27219	    560	      8	  27787	   6c8b	fs/xfs/xfs_log.o.patched

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_log_format.h |  3 --
 fs/xfs/xfs_log.c               | 59 ++++++++++++++--------------------
 fs/xfs/xfs_log_priv.h          |  2 ++
 3 files changed, 27 insertions(+), 37 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
index 3e15ea29fb8d..d548ea4b6aab 100644
--- a/fs/xfs/libxfs/xfs_log_format.h
+++ b/fs/xfs/libxfs/xfs_log_format.h
@@ -34,9 +34,6 @@ typedef uint32_t xlog_tid_t;
 #define XLOG_MIN_RECORD_BSHIFT	14		/* 16384 == 1 << 14 */
 #define XLOG_BIG_RECORD_BSHIFT	15		/* 32k == 1 << 15 */
 #define XLOG_MAX_RECORD_BSHIFT	18		/* 256k == 1 << 18 */
-#define XLOG_BTOLSUNIT(log, b)  (((b)+(log)->l_mp->m_sb.sb_logsunit-1) / \
-                                 (log)->l_mp->m_sb.sb_logsunit)
-#define XLOG_LSUNITTOB(log, su) ((su) * (log)->l_mp->m_sb.sb_logsunit)
 
 #define XLOG_HEADER_SIZE	512
 
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index c19a82adea1e..0e563ff8cd3b 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1401,6 +1401,11 @@ xlog_alloc_log(
 	xlog_assign_atomic_lsn(&log->l_last_sync_lsn, 1, 0);
 	log->l_curr_cycle  = 1;	    /* 0 is bad since this is initial value */
 
+	if (xfs_sb_version_haslogv2(&mp->m_sb) && mp->m_sb.sb_logsunit > 1)
+		log->l_iclog_roundoff = mp->m_sb.sb_logsunit;
+	else
+		log->l_iclog_roundoff = BBSIZE;
+
 	xlog_grant_head_init(&log->l_reserve_head);
 	xlog_grant_head_init(&log->l_write_head);
 
@@ -1854,29 +1859,15 @@ xlog_calc_iclog_size(
 	uint32_t		*roundoff)
 {
 	uint32_t		count_init, count;
-	bool			use_lsunit;
-
-	use_lsunit = xfs_sb_version_haslogv2(&log->l_mp->m_sb) &&
-			log->l_mp->m_sb.sb_logsunit > 1;
 
 	/* Add for LR header */
 	count_init = log->l_iclog_hsize + iclog->ic_offset;
+	count = roundup(count_init, log->l_iclog_roundoff);
 
-	/* Round out the log write size */
-	if (use_lsunit) {
-		/* we have a v2 stripe unit to use */
-		count = XLOG_LSUNITTOB(log, XLOG_BTOLSUNIT(log, count_init));
-	} else {
-		count = BBTOB(BTOBB(count_init));
-	}
-
-	ASSERT(count >= count_init);
 	*roundoff = count - count_init;
 
-	if (use_lsunit)
-		ASSERT(*roundoff < log->l_mp->m_sb.sb_logsunit);
-	else
-		ASSERT(*roundoff < BBTOB(1));
+	ASSERT(count >= count_init);
+	ASSERT(*roundoff < log->l_iclog_roundoff);
 	return count;
 }
 
@@ -3151,10 +3142,9 @@ xlog_state_switch_iclogs(
 	log->l_curr_block += BTOBB(eventual_size)+BTOBB(log->l_iclog_hsize);
 
 	/* Round up to next log-sunit */
-	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb) &&
-	    log->l_mp->m_sb.sb_logsunit > 1) {
-		uint32_t sunit_bb = BTOBB(log->l_mp->m_sb.sb_logsunit);
-		log->l_curr_block = roundup(log->l_curr_block, sunit_bb);
+	if (log->l_iclog_roundoff > BBSIZE) {
+		log->l_curr_block = roundup(log->l_curr_block,
+						BTOBB(log->l_iclog_roundoff));
 	}
 
 	if (log->l_curr_block >= log->l_logBBsize) {
@@ -3406,12 +3396,11 @@ xfs_log_ticket_get(
  * Figure out the total log space unit (in bytes) that would be
  * required for a log ticket.
  */
-int
-xfs_log_calc_unit_res(
-	struct xfs_mount	*mp,
+static int
+xlog_calc_unit_res(
+	struct xlog		*log,
 	int			unit_bytes)
 {
-	struct xlog		*log = mp->m_log;
 	int			iclog_space;
 	uint			num_headers;
 
@@ -3487,18 +3476,20 @@ xfs_log_calc_unit_res(
 	/* for commit-rec LR header - note: padding will subsume the ophdr */
 	unit_bytes += log->l_iclog_hsize;
 
-	/* for roundoff padding for transaction data and one for commit record */
-	if (xfs_sb_version_haslogv2(&mp->m_sb) && mp->m_sb.sb_logsunit > 1) {
-		/* log su roundoff */
-		unit_bytes += 2 * mp->m_sb.sb_logsunit;
-	} else {
-		/* BB roundoff */
-		unit_bytes += 2 * BBSIZE;
-        }
+	/* roundoff padding for transaction data and one for commit record */
+	unit_bytes += 2 * log->l_iclog_roundoff;
 
 	return unit_bytes;
 }
 
+int
+xfs_log_calc_unit_res(
+	struct xfs_mount	*mp,
+	int			unit_bytes)
+{
+	return xlog_calc_unit_res(mp->m_log, unit_bytes);
+}
+
 /*
  * Allocate and initialise a new log ticket.
  */
@@ -3515,7 +3506,7 @@ xlog_ticket_alloc(
 
 	tic = kmem_cache_zalloc(xfs_log_ticket_zone, GFP_NOFS | __GFP_NOFAIL);
 
-	unit_res = xfs_log_calc_unit_res(log->l_mp, unit_bytes);
+	unit_res = xlog_calc_unit_res(log, unit_bytes);
 
 	atomic_set(&tic->t_ref, 1);
 	tic->t_task		= current;
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 1c6fdbf3d506..037950cf1061 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -436,6 +436,8 @@ struct xlog {
 #endif
 	/* log recovery lsn tracking (for buffer submission */
 	xfs_lsn_t		l_recovery_lsn;
+
+	uint32_t		l_iclog_roundoff;/* padding roundoff */
 };
 
 #define XLOG_BUF_CANCEL_BUCKET(log, blkno) \
-- 
2.31.1

