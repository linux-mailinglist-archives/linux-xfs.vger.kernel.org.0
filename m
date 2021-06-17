Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1124D3AAEBD
	for <lists+linux-xfs@lfdr.de>; Thu, 17 Jun 2021 10:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbhFQI2c (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 17 Jun 2021 04:28:32 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:49109 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230238AbhFQI2b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jun 2021 04:28:31 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id A84271AFF41
        for <linux-xfs@vger.kernel.org>; Thu, 17 Jun 2021 18:26:22 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ltnLx-00DjwM-DK
        for linux-xfs@vger.kernel.org; Thu, 17 Jun 2021 18:26:21 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1ltnLx-0044v3-5S
        for linux-xfs@vger.kernel.org; Thu, 17 Jun 2021 18:26:21 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/8] xfs: add iclog state trace events
Date:   Thu, 17 Jun 2021 18:26:10 +1000
Message-Id: <20210617082617.971602-2-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210617082617.971602-1-david@fromorbit.com>
References: <20210617082617.971602-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=r6YtysWOX24A:10 a=20KFwNOVAAAA:8 a=kWWrJmqIgs_yr43_GoIA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

For the DEBUGS!

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c      | 18 +++++++++++++
 fs/xfs/xfs_log_priv.h | 10 ++++++++
 fs/xfs/xfs_trace.h    | 60 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 88 insertions(+)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index e921b554b683..54fd6a695bb5 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -524,6 +524,7 @@ __xlog_state_release_iclog(
 		iclog->ic_header.h_tail_lsn = cpu_to_be64(tail_lsn);
 		xlog_verify_tail_lsn(log, iclog, tail_lsn);
 		/* cycle incremented when incrementing curr_block */
+		trace_xlog_iclog_syncing(iclog, _RET_IP_);
 		return true;
 	}
 
@@ -543,6 +544,7 @@ xlog_state_release_iclog(
 {
 	lockdep_assert_held(&log->l_icloglock);
 
+	trace_xlog_iclog_release(iclog, _RET_IP_);
 	if (iclog->ic_state == XLOG_STATE_IOERROR)
 		return -EIO;
 
@@ -804,6 +806,7 @@ xlog_wait_on_iclog(
 {
 	struct xlog		*log = iclog->ic_log;
 
+	trace_xlog_iclog_wait_on(iclog, _RET_IP_);
 	if (!XLOG_FORCED_SHUTDOWN(log) &&
 	    iclog->ic_state != XLOG_STATE_ACTIVE &&
 	    iclog->ic_state != XLOG_STATE_DIRTY) {
@@ -1804,6 +1807,7 @@ xlog_write_iclog(
 	unsigned int		count)
 {
 	ASSERT(bno < log->l_logBBsize);
+	trace_xlog_iclog_write(iclog, _RET_IP_);
 
 	/*
 	 * We lock the iclogbufs here so that we can serialise against I/O
@@ -1950,6 +1954,7 @@ xlog_sync(
 	unsigned int		size;
 
 	ASSERT(atomic_read(&iclog->ic_refcnt) == 0);
+	trace_xlog_iclog_sync(iclog, _RET_IP_);
 
 	count = xlog_calc_iclog_size(log, iclog, &roundoff);
 
@@ -2488,6 +2493,7 @@ xlog_state_activate_iclog(
 	int			*iclogs_changed)
 {
 	ASSERT(list_empty_careful(&iclog->ic_callbacks));
+	trace_xlog_iclog_activate(iclog, _RET_IP_);
 
 	/*
 	 * If the number of ops in this iclog indicate it just contains the
@@ -2577,6 +2583,8 @@ xlog_state_clean_iclog(
 {
 	int			iclogs_changed = 0;
 
+	trace_xlog_iclog_clean(dirty_iclog, _RET_IP_);
+
 	dirty_iclog->ic_state = XLOG_STATE_DIRTY;
 
 	xlog_state_activate_iclogs(log, &iclogs_changed);
@@ -2636,6 +2644,7 @@ xlog_state_set_callback(
 	struct xlog_in_core	*iclog,
 	xfs_lsn_t		header_lsn)
 {
+	trace_xlog_iclog_callback(iclog, _RET_IP_);
 	iclog->ic_state = XLOG_STATE_CALLBACK;
 
 	ASSERT(XFS_LSN_CMP(atomic64_read(&log->l_last_sync_lsn),
@@ -2717,6 +2726,7 @@ xlog_state_do_iclog_callbacks(
 		__releases(&log->l_icloglock)
 		__acquires(&log->l_icloglock)
 {
+	trace_xlog_iclog_callbacks_start(iclog, _RET_IP_);
 	spin_unlock(&log->l_icloglock);
 	spin_lock(&iclog->ic_callback_lock);
 	while (!list_empty(&iclog->ic_callbacks)) {
@@ -2736,6 +2746,7 @@ xlog_state_do_iclog_callbacks(
 	 */
 	spin_lock(&log->l_icloglock);
 	spin_unlock(&iclog->ic_callback_lock);
+	trace_xlog_iclog_callbacks_done(iclog, _RET_IP_);
 }
 
 STATIC void
@@ -2827,6 +2838,7 @@ xlog_state_done_syncing(
 
 	spin_lock(&log->l_icloglock);
 	ASSERT(atomic_read(&iclog->ic_refcnt) == 0);
+	trace_xlog_iclog_sync_done(iclog, _RET_IP_);
 
 	/*
 	 * If we got an error, either on the first buffer, or in the case of
@@ -2899,6 +2911,8 @@ xlog_state_get_iclog_space(
 	atomic_inc(&iclog->ic_refcnt);	/* prevents sync */
 	log_offset = iclog->ic_offset;
 
+	trace_xlog_iclog_get_space(iclog, _RET_IP_);
+
 	/* On the 1st write to an iclog, figure out lsn.  This works
 	 * if iclogs marked XLOG_STATE_WANT_SYNC always write out what they are
 	 * committing to.  If the offset is set, that's how many blocks
@@ -3056,6 +3070,7 @@ xlog_state_switch_iclogs(
 {
 	ASSERT(iclog->ic_state == XLOG_STATE_ACTIVE);
 	assert_spin_locked(&log->l_icloglock);
+	trace_xlog_iclog_switch(iclog, _RET_IP_);
 
 	if (!eventual_size)
 		eventual_size = iclog->ic_offset;
@@ -3138,6 +3153,8 @@ xfs_log_force(
 	if (iclog->ic_state == XLOG_STATE_IOERROR)
 		goto out_error;
 
+	trace_xlog_iclog_force(iclog, _RET_IP_);
+
 	if (iclog->ic_state == XLOG_STATE_DIRTY ||
 	    (iclog->ic_state == XLOG_STATE_ACTIVE &&
 	     atomic_read(&iclog->ic_refcnt) == 0 && iclog->ic_offset == 0)) {
@@ -3225,6 +3242,7 @@ xlog_force_lsn(
 		goto out_error;
 
 	while (be64_to_cpu(iclog->ic_header.h_lsn) != lsn) {
+		trace_xlog_iclog_force_lsn(iclog, _RET_IP_);
 		iclog = iclog->ic_next;
 		if (iclog == log->l_iclog)
 			goto out_unlock;
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index e4e421a70335..330befd9f6be 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -50,6 +50,16 @@ enum xlog_iclog_state {
 	XLOG_STATE_IOERROR,	/* IO error happened in sync'ing log */
 };
 
+#define XLOG_STATE_STRINGS \
+	{ XLOG_STATE_ACTIVE,	"XLOG_STATE_ACTIVE" }, \
+	{ XLOG_STATE_WANT_SYNC,	"XLOG_STATE_WANT_SYNC" }, \
+	{ XLOG_STATE_SYNCING,	"XLOG_STATE_SYNCING" }, \
+	{ XLOG_STATE_DONE_SYNC,	"XLOG_STATE_DONE_SYNC" }, \
+	{ XLOG_STATE_CALLBACK,	"XLOG_STATE_CALLBACK" }, \
+	{ XLOG_STATE_DIRTY,	"XLOG_STATE_DIRTY" }, \
+	{ XLOG_STATE_IOERROR,	"XLOG_STATE_IOERROR" }
+
+
 /*
  * Log ticket flags
  */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 71dca776c110..28d570742000 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -24,6 +24,7 @@ struct xlog_ticket;
 struct xlog_recover;
 struct xlog_recover_item;
 struct xlog_rec_header;
+struct xlog_in_core;
 struct xfs_buf_log_format;
 struct xfs_inode_log_format;
 struct xfs_bmbt_irec;
@@ -3927,6 +3928,65 @@ DEFINE_EVENT(xfs_icwalk_class, name,	\
 DEFINE_ICWALK_EVENT(xfs_ioc_free_eofblocks);
 DEFINE_ICWALK_EVENT(xfs_blockgc_free_space);
 
+TRACE_DEFINE_ENUM(XLOG_STATE_ACTIVE);
+TRACE_DEFINE_ENUM(XLOG_STATE_WANT_SYNC);
+TRACE_DEFINE_ENUM(XLOG_STATE_SYNCING);
+TRACE_DEFINE_ENUM(XLOG_STATE_DONE_SYNC);
+TRACE_DEFINE_ENUM(XLOG_STATE_CALLBACK);
+TRACE_DEFINE_ENUM(XLOG_STATE_DIRTY);
+TRACE_DEFINE_ENUM(XLOG_STATE_IOERROR);
+
+DECLARE_EVENT_CLASS(xlog_iclog_class,
+	TP_PROTO(struct xlog_in_core *iclog, unsigned long caller_ip),
+	TP_ARGS(iclog, caller_ip),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(uint32_t, state)
+		__field(int32_t, refcount)
+		__field(uint32_t, offset)
+		__field(unsigned long long, lsn)
+		__field(unsigned long, caller_ip)
+	),
+	TP_fast_assign(
+		__entry->dev = iclog->ic_log->l_mp->m_super->s_dev;
+		__entry->state = iclog->ic_state;
+		__entry->refcount = atomic_read(&iclog->ic_refcnt);
+		__entry->offset = iclog->ic_offset;
+		__entry->lsn = be64_to_cpu(iclog->ic_header.h_lsn);
+		__entry->caller_ip = caller_ip;
+	),
+	TP_printk("dev %d:%d state %s refcnt %d offset %u lsn 0x%llx caller %pS",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __print_symbolic(__entry->state, XLOG_STATE_STRINGS),
+		  __entry->refcount,
+		  __entry->offset,
+		  __entry->lsn,
+		  (char *)__entry->caller_ip)
+
+);
+
+#define DEFINE_ICLOG_EVENT(name)	\
+DEFINE_EVENT(xlog_iclog_class, name,	\
+	TP_PROTO(struct xlog_in_core *iclog, unsigned long caller_ip), \
+	TP_ARGS(iclog, caller_ip))
+
+DEFINE_ICLOG_EVENT(xlog_iclog_activate);
+DEFINE_ICLOG_EVENT(xlog_iclog_clean);
+DEFINE_ICLOG_EVENT(xlog_iclog_callback);
+DEFINE_ICLOG_EVENT(xlog_iclog_callbacks_start);
+DEFINE_ICLOG_EVENT(xlog_iclog_callbacks_done);
+DEFINE_ICLOG_EVENT(xlog_iclog_force);
+DEFINE_ICLOG_EVENT(xlog_iclog_force_lsn);
+DEFINE_ICLOG_EVENT(xlog_iclog_get_space);
+DEFINE_ICLOG_EVENT(xlog_iclog_release);
+DEFINE_ICLOG_EVENT(xlog_iclog_switch);
+DEFINE_ICLOG_EVENT(xlog_iclog_sync);
+DEFINE_ICLOG_EVENT(xlog_iclog_syncing);
+DEFINE_ICLOG_EVENT(xlog_iclog_sync_done);
+DEFINE_ICLOG_EVENT(xlog_iclog_want_sync);
+DEFINE_ICLOG_EVENT(xlog_iclog_wait_on);
+DEFINE_ICLOG_EVENT(xlog_iclog_write);
+
 #endif /* _TRACE_XFS_H */
 
 #undef TRACE_INCLUDE_PATH
-- 
2.31.1

