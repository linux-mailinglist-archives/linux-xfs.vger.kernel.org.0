Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 248652850F
	for <lists+linux-xfs@lfdr.de>; Thu, 23 May 2019 19:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731216AbfEWRjW (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 23 May 2019 13:39:22 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:56086 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731037AbfEWRjW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 May 2019 13:39:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=cfbZbzx/keeoB/JhYAmCK1gsDW1Xme3XefPW0ZL/sTM=; b=j5s9+ylTAutn0teYurS3jCUOm
        1NjNI6XY+TNqLPDnRhaq84Df17Qlj3GCWAb0xCvBXbUi38cP+l9Es0XyIpioD8cylTdisf4BHVyQg
        IMEEGHklktlBX0coE+hR/U4WpVcLmMW6A4Jw0Y/bM9LjEe9Vb1U8St2v98P34B4QRxxKipR+jYS4i
        W7iHGH7wcz6daNK+2NKX/0l2gtURyVLdkPPIKWa3WZxGN3aG3OCd1jL11ur8gBvjePuzRnQgcVPm2
        hJQkHl+wzNE6H/Ht3ux44vqyaM86HLKeAOUobjnK8M1brwNM3DTh+oeqCtvnJ+TNhXFx9+cRm+9N8
        dlHw95tlg==;
Received: from 213-225-10-46.nat.highway.a1.net ([213.225.10.46] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hTrgT-00012e-MA
        for linux-xfs@vger.kernel.org; Thu, 23 May 2019 17:39:22 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 07/20] xfs: factor out log buffer writing from xlog_sync
Date:   Thu, 23 May 2019 19:37:29 +0200
Message-Id: <20190523173742.15551-8-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190523173742.15551-1-hch@lst.de>
References: <20190523173742.15551-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Replace the not very useful xlog_bdstrat wrapper with a new version that
that takes care of all the common logic for writing log buffers.  Use
the opportunity to avoid overloading the buffer address with the log
relative address, and to shed the unused return value.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 125 +++++++++++++++++------------------------------
 1 file changed, 45 insertions(+), 80 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 646a190e5730..9a81d2d32ad9 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -45,10 +45,6 @@ STATIC int
 xlog_space_left(
 	struct xlog		*log,
 	atomic64_t		*head);
-STATIC int
-xlog_sync(
-	struct xlog		*log,
-	struct xlog_in_core	*iclog);
 STATIC void
 xlog_dealloc_log(
 	struct xlog		*log);
@@ -1765,28 +1761,34 @@ xlog_cksum(
 	return xfs_end_cksum(crc);
 }
 
-/*
- * The bdstrat callback function for log bufs. This gives us a central
- * place to trap bufs in case we get hit by a log I/O error and need to
- * shutdown. Actually, in practice, even when we didn't get a log error,
- * we transition the iclogs to IOERROR state *after* flushing all existing
- * iclogs to disk. This is because we don't want anymore new transactions to be
- * started or completed afterwards.
- *
- * We lock the iclogbufs here so that we can serialise against IO completion
- * during unmount. We might be processing a shutdown triggered during unmount,
- * and that can occur asynchronously to the unmount thread, and hence we need to
- * ensure that completes before tearing down the iclogbufs. Hence we need to
- * hold the buffer lock across the log IO to acheive that.
- */
-STATIC int
-xlog_bdstrat(
-	struct xfs_buf		*bp)
+STATIC void
+xlog_write_iclog(
+	struct xlog		*log,
+	struct xlog_in_core	*iclog,
+	struct xfs_buf		*bp,
+	uint64_t		bno,
+	bool			flush)
 {
-	struct xlog_in_core	*iclog = bp->b_log_item;
+	ASSERT(bno < log->l_logBBsize);
+	ASSERT(bno + bp->b_io_length <= log->l_logBBsize);
 
+	bp->b_maps[0].bm_bn = log->l_logBBstart + bno;
+	bp->b_log_item = iclog;
+	bp->b_flags &= ~XBF_FLUSH;
+	bp->b_flags |= (XBF_ASYNC | XBF_SYNCIO | XBF_WRITE | XBF_FUA);
+	if (flush)
+		bp->b_flags |= XBF_FLUSH;
+
+	/*
+	 * We lock the iclogbufs here so that we can serialise against I/O
+	 * completion during unmount.  We might be processing a shutdown
+	 * triggered during unmount, and that can occur asynchronously to the
+	 * unmount thread, and hence we need to ensure that completes before
+	 * tearing down the iclogbufs.  Hence we need to hold the buffer lock
+	 * across the log IO to archive that.
+	 */
 	xfs_buf_lock(bp);
-	if (iclog->ic_state & XLOG_STATE_IOERROR) {
+	if (unlikely(iclog->ic_state & XLOG_STATE_IOERROR)) {
 		xfs_buf_ioerror(bp, -EIO);
 		xfs_buf_stale(bp);
 		xfs_buf_ioend(bp);
@@ -1796,11 +1798,10 @@ xlog_bdstrat(
 		 * doing it here. Similarly, IO completion will unlock the
 		 * buffer, so we don't do it here.
 		 */
-		return 0;
+		return;
 	}
 
 	xfs_buf_submit(bp);
-	return 0;
 }
 
 /*
@@ -1823,25 +1824,23 @@ xlog_bdstrat(
  * log will require grabbing the lock though.
  *
  * The entire log manager uses a logical block numbering scheme.  Only
- * log_sync (and then only bwrite()) know about the fact that the log may
- * not start with block zero on a given device.  The log block start offset
- * is added immediately before calling bwrite().
+ * xlog_write_iclog knows about the fact that the log may not start with
+ * block zero on a given device.
  */
-
-STATIC int
+STATIC void
 xlog_sync(
 	struct xlog		*log,
 	struct xlog_in_core	*iclog)
 {
-	xfs_buf_t	*bp;
 	int		i;
 	uint		count;		/* byte count of bwrite */
 	uint		count_init;	/* initial count before roundup */
 	int		roundoff;       /* roundoff to BB or stripe */
 	int		split = 0;	/* split write into two regions */
-	int		error;
 	int		v2 = xfs_sb_version_haslogv2(&log->l_mp->m_sb);
+	uint64_t	bno;
 	int		size;
+	bool		flush = true;
 
 	XFS_STATS_INC(log->l_mp, xs_log_writes);
 	ASSERT(atomic_read(&iclog->ic_refcnt) == 0);
@@ -1877,17 +1876,16 @@ xlog_sync(
 		size += roundoff;
 	iclog->ic_header.h_len = cpu_to_be32(size);
 
-	bp = iclog->ic_bp;
-	XFS_BUF_SET_ADDR(bp, BLOCK_LSN(be64_to_cpu(iclog->ic_header.h_lsn)));
-
 	XFS_STATS_ADD(log->l_mp, xs_log_blocks, BTOBB(count));
 
+	bno = BLOCK_LSN(be64_to_cpu(iclog->ic_header.h_lsn));
+
 	/* Do we need to split this write into 2 parts? */
-	if (XFS_BUF_ADDR(bp) + BTOBB(count) > log->l_logBBsize) {
+	if (bno + BTOBB(count) > log->l_logBBsize) {
 		char		*dptr;
 
-		split = count - (BBTOB(log->l_logBBsize - XFS_BUF_ADDR(bp)));
-		count = BBTOB(log->l_logBBsize - XFS_BUF_ADDR(bp));
+		split = count - (BBTOB(log->l_logBBsize - bno));
+		count = BBTOB(log->l_logBBsize - bno);
 		iclog->ic_bwritecnt = 2;
 
 		/*
@@ -1928,11 +1926,6 @@ xlog_sync(
 			 be64_to_cpu(iclog->ic_header.h_lsn));
 	}
 
-	bp->b_io_length = BTOBB(count);
-	bp->b_log_item = iclog;
-	bp->b_flags &= ~XBF_FLUSH;
-	bp->b_flags |= (XBF_ASYNC | XBF_SYNCIO | XBF_WRITE | XBF_FUA);
-
 	/*
 	 * Flush the data device before flushing the log to make sure all meta
 	 * data written back from the AIL actually made it to disk before
@@ -1941,50 +1934,22 @@ xlog_sync(
 	 * synchronously here; for an internal log we can simply use the block
 	 * layer state machine for preflushes.
 	 */
-	if (log->l_mp->m_logdev_targp != log->l_mp->m_ddev_targp || split)
+	if (log->l_mp->m_logdev_targp != log->l_mp->m_ddev_targp || split) {
 		xfs_blkdev_issue_flush(log->l_mp->m_ddev_targp);
-	else
-		bp->b_flags |= XBF_FLUSH;
+		flush = false;
+	}
 
-	ASSERT(XFS_BUF_ADDR(bp) <= log->l_logBBsize-1);
-	ASSERT(XFS_BUF_ADDR(bp) + BTOBB(count) <= log->l_logBBsize);
+	iclog->ic_bp->b_io_length = BTOBB(count);
 
 	xlog_verify_iclog(log, iclog, count, true);
+	xlog_write_iclog(log, iclog, iclog->ic_bp, bno, flush);
 
-	/* account for log which doesn't start at block #0 */
-	XFS_BUF_SET_ADDR(bp, XFS_BUF_ADDR(bp) + log->l_logBBstart);
-
-	/*
-	 * Don't call xfs_bwrite here. We do log-syncs even when the filesystem
-	 * is shutting down.
-	 */
-	error = xlog_bdstrat(bp);
-	if (error) {
-		xfs_buf_ioerror_alert(bp, "xlog_sync");
-		return error;
-	}
 	if (split) {
-		bp = iclog->ic_log->l_xbuf;
-		XFS_BUF_SET_ADDR(bp, 0);	     /* logical 0 */
-		xfs_buf_associate_memory(bp,
+		xfs_buf_associate_memory(iclog->ic_log->l_xbuf,
 				(char *)&iclog->ic_header + count, split);
-		bp->b_log_item = iclog;
-		bp->b_flags &= ~XBF_FLUSH;
-		bp->b_flags |= (XBF_ASYNC | XBF_SYNCIO | XBF_WRITE | XBF_FUA);
-
-		ASSERT(XFS_BUF_ADDR(bp) <= log->l_logBBsize-1);
-		ASSERT(XFS_BUF_ADDR(bp) + BTOBB(count) <= log->l_logBBsize);
-
-		/* account for internal log which doesn't start at block #0 */
-		XFS_BUF_SET_ADDR(bp, XFS_BUF_ADDR(bp) + log->l_logBBstart);
-		error = xlog_bdstrat(bp);
-		if (error) {
-			xfs_buf_ioerror_alert(bp, "xlog_sync (split)");
-			return error;
-		}
+		xlog_write_iclog(log, iclog, iclog->ic_log->l_xbuf, 0, false);
 	}
-	return 0;
-}	/* xlog_sync */
+}
 
 /*
  * Deallocate a log structure
@@ -3224,7 +3189,7 @@ xlog_state_release_iclog(
 	 * flags after this point.
 	 */
 	if (sync)
-		return xlog_sync(log, iclog);
+		xlog_sync(log, iclog);
 	return 0;
 }	/* xlog_state_release_iclog */
 
-- 
2.20.1

