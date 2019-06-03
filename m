Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5343A336AF
	for <lists+linux-xfs@lfdr.de>; Mon,  3 Jun 2019 19:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729434AbfFCRaM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 3 Jun 2019 13:30:12 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53604 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728164AbfFCRaL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Jun 2019 13:30:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=hGZlkal6T2SAYq7rJhbXZCCr5+Ph4u1kX+fDgJLkPh0=; b=jSqLWzHQNV35ecvEabdMF56oG
        ctsIMB8yT4inzinxaWujP3zTgWMbdDBOjFDJEYXOBvxxtPHcvYGjmtEhO1NJFAvjFGnjV+lDnvrNk
        BalQ9gk4w8/ylmQ04RWB+gOv3BbgvOxwQ4jtwLLxleDpUgk0Yl8oeOZVovi37qIxsMvyAUYBPgF6S
        4ON7UcV8EmvFJAN+UvbJzArh4kVqHExppg1RLeg+U/0SnhHPhEfexvDrt0BDz3hCjeZ3QxZQS1bSM
        v3R1v2eJoO4s3GfjYaJ2ou3/hjLV7fWjurzKuexup8AM5GxCyRuWLeg4YXTqTPWc0XC9lHJcgM1LI
        AtypcmFiQ==;
Received: from 089144193064.atnat0002.highway.a1.net ([89.144.193.64] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hXqmg-0003gV-SU
        for linux-xfs@vger.kernel.org; Mon, 03 Jun 2019 17:30:11 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 09/20] xfs: factor out iclog size calculation from xlog_sync
Date:   Mon,  3 Jun 2019 19:29:34 +0200
Message-Id: <20190603172945.13819-10-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190603172945.13819-1-hch@lst.de>
References: <20190603172945.13819-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Split out another self-contained bit of code from xlog_sync.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 67 +++++++++++++++++++++++++++++-------------------
 1 file changed, 41 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 0d8805c9570a..02e9ab3af5ee 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1830,6 +1830,39 @@ xlog_split_iclog(
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
@@ -1858,35 +1891,17 @@ xlog_sync(
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
@@ -1897,7 +1912,7 @@ xlog_sync(
 
 	/* real byte length */
 	size = iclog->ic_offset;
-	if (v2)
+	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb))
 		size += roundoff;
 	iclog->ic_header.h_len = cpu_to_be32(size);
 
-- 
2.20.1

