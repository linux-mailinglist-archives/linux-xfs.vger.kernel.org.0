Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12A6C3646E
	for <lists+linux-xfs@lfdr.de>; Wed,  5 Jun 2019 21:15:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbfFETPu (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 5 Jun 2019 15:15:50 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:59716 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbfFETPu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jun 2019 15:15:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=EOoLhueEOJjmjwPL7s12nVI7JLbfD4ZG+qd5ilXRmO0=; b=hIT9qQDlTigS7oTb3udu6ajtA0
        6OCarYcypE6ky5/6XK1zva+/b/v1qgOVV5/JfK/jYPkT450QRPgM74litdhY9t0DwSuA8nfRQOwRL
        lRXGC/dmjsGnTEnwUy9tlesEtl0PI8zuXMIb1PxHsP7OlLJwNCzWUVh5RH4E9ijvUKR8+jDdK6E3Z
        L3QXTJFeV/CWV/9Zqsi1sZizuhU7YricfxytA2UlVnWVaVcBWtdyemxapIm7K7UZAadQzVXtipusU
        sZG6Bo/qVIgI00/53HuhF89azg1iHPyPYIE5LhYy7BpT6q5XQ+RLkeyOC4hXj0dWRU1QcOI+a0QmO
        i7xBVb2w==;
Received: from 089144193064.atnat0002.highway.a1.net ([89.144.193.64] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hYbO1-0002Dv-RZ; Wed, 05 Jun 2019 19:15:50 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 12/24] xfs: factor out iclog size calculation from xlog_sync
Date:   Wed,  5 Jun 2019 21:14:59 +0200
Message-Id: <20190605191511.32695-13-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190605191511.32695-1-hch@lst.de>
References: <20190605191511.32695-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Split out another self-contained bit of code from xlog_sync.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c | 67 +++++++++++++++++++++++++++++-------------------
 1 file changed, 41 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 2138bc8cc6e8..b22f75affdc5 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1791,6 +1791,39 @@ xlog_split_iclog(
 	return split_offset;
 }
 
+static int
+xlog_calc_iclog_size(
+	struct xlog		*log,
+	struct xlog_in_core	*iclog,
+	uint32_t		*roundoff)
+{
+	uint32_t		count_init, count;
+	bool			use_lsunit;
+
+	use_lsunit = xfs_sb_version_haslogv2(&log->l_mp->m_sb) &&
+			log->l_mp->m_sb.sb_logsunit > 1;
+
+	/* Add for LR header */
+	count_init = log->l_iclog_hsize + iclog->ic_offset;
+
+	/* Round out the log write size */
+	if (use_lsunit) {
+		/* we have a v2 stripe unit to use */
+		count = XLOG_LSUNITTOB(log, XLOG_BTOLSUNIT(log, count_init));
+	} else {
+		count = BBTOB(BTOBB(count_init));
+	}
+
+	ASSERT(count >= count_init);
+	*roundoff = count - count_init;
+
+	if (use_lsunit)
+		ASSERT(*roundoff < log->l_mp->m_sb.sb_logsunit);
+	else
+		ASSERT(*roundoff < BBTOB(1));
+	return count;
+}
+
 /*
  * Flush out the in-core log (iclog) to the on-disk log in an asynchronous 
  * fashion.  Previously, we should have moved the current iclog
@@ -1819,35 +1852,17 @@ xlog_sync(
 	struct xlog		*log,
 	struct xlog_in_core	*iclog)
 {
-	uint		count;		/* byte count of bwrite */
-	uint		count_init;	/* initial count before roundup */
-	int		roundoff;       /* roundoff to BB or stripe */
-	int		v2 = xfs_sb_version_haslogv2(&log->l_mp->m_sb);
-	uint64_t	bno;
-	unsigned int	split = 0;
-	int		size;
-	bool		need_flush = true;
+	unsigned int		count;		/* byte count of bwrite */
+	unsigned int		roundoff;       /* roundoff to BB or stripe */
+	uint64_t		bno;
+	unsigned int		split = 0;
+	unsigned int		size;
+	bool			need_flush = true;
 
 	XFS_STATS_INC(log->l_mp, xs_log_writes);
 	ASSERT(atomic_read(&iclog->ic_refcnt) == 0);
 
-	/* Add for LR header */
-	count_init = log->l_iclog_hsize + iclog->ic_offset;
-
-	/* Round out the log write size */
-	if (v2 && log->l_mp->m_sb.sb_logsunit > 1) {
-		/* we have a v2 stripe unit to use */
-		count = XLOG_LSUNITTOB(log, XLOG_BTOLSUNIT(log, count_init));
-	} else {
-		count = BBTOB(BTOBB(count_init));
-	}
-	roundoff = count - count_init;
-	ASSERT(roundoff >= 0);
-	ASSERT((v2 && log->l_mp->m_sb.sb_logsunit > 1 && 
-                roundoff < log->l_mp->m_sb.sb_logsunit)
-		|| 
-		(log->l_mp->m_sb.sb_logsunit <= 1 && 
-		 roundoff < BBTOB(1)));
+	count = xlog_calc_iclog_size(log, iclog, &roundoff);
 
 	/* move grant heads by roundoff in sync */
 	xlog_grant_add_space(log, &log->l_reserve_head.grant, roundoff);
@@ -1858,7 +1873,7 @@ xlog_sync(
 
 	/* real byte length */
 	size = iclog->ic_offset;
-	if (v2)
+	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb))
 		size += roundoff;
 	iclog->ic_header.h_len = cpu_to_be32(size);
 
-- 
2.20.1

