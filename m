Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B66DF28515
	for <lists+linux-xfs@lfdr.de>; Thu, 23 May 2019 19:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731216AbfEWRkF (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 23 May 2019 13:40:05 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:56256 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731195AbfEWRkF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 May 2019 13:40:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=RNXO5g8KEKsOi3tnb43R4XYPSTxRRpBcKo2ZASsG1kA=; b=FO6m7R44FdAYyVPgnQPZLM5gQ
        YKz7l7GoXY8PR3ffGI/H59SkM6eYk5Tw3wVrhRb+P+u3028yoCJzY2kAdAcywBRN3VahFL70vA45S
        L+zFrhnknf6tp2U+P7xQ1baGVU/WNCyaGG3SR//D8829BvgwUQbfwaIJCjRnZVSkPsEmfdN5wIjyc
        dqLwoFnVjXeYz857QUT999U80K5M7soBTVm32pCkBq0W6jjYGUbUFXOyiTck9FLmiXFidGvy5OI5h
        iTRe9p4eTOTBNUqnjSQ9qBrDYOaQJI7UsHKCd0uv6C/qcUpPMLBCdX3G1OND3RqmwBurPOV3SlvDX
        KnApmqwmA==;
Received: from 213-225-10-46.nat.highway.a1.net ([213.225.10.46] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hTrhB-00015L-Gg
        for linux-xfs@vger.kernel.org; Thu, 23 May 2019 17:40:04 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 09/20] xfs: factor out iclog size calculation from xlog_sync
Date:   Thu, 23 May 2019 19:37:31 +0200
Message-Id: <20190523173742.15551-10-hch@lst.de>
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

Split out another self-contained bit of code from xlog_sync.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 64 ++++++++++++++++++++++++++++--------------------
 1 file changed, 38 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 885470f08554..e2c9f74f86f3 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1830,6 +1830,36 @@ xlog_split_iclog(
 	return split_offset;
 }
 
+static int
+xlog_calc_iclog_size(
+	struct xlog		*log,
+	struct xlog_in_core	*iclog,
+	uint32_t		*roundoff)
+{
+	bool			v2 = xfs_sb_version_haslogv2(&log->l_mp->m_sb);
+	uint32_t		count_init, count;
+
+	/* Add for LR header */
+	count_init = log->l_iclog_hsize + iclog->ic_offset;
+
+	/* Round out the log write size */
+	if (v2 && log->l_mp->m_sb.sb_logsunit > 1) {
+		/* we have a v2 stripe unit to use */
+		count = XLOG_LSUNITTOB(log, XLOG_BTOLSUNIT(log, count_init));
+	} else {
+		count = BBTOB(BTOBB(count_init));
+	}
+
+	ASSERT(count >= count_init);
+	*roundoff = count - count_init;
+
+	if (v2 && log->l_mp->m_sb.sb_logsunit > 1)
+		ASSERT(*roundoff < log->l_mp->m_sb.sb_logsunit);
+	else
+		ASSERT(*roundoff < BBTOB(1));
+	return count;
+}
+
 /*
  * Flush out the in-core log (iclog) to the on-disk log in an asynchronous 
  * fashion.  Previously, we should have moved the current iclog
@@ -1858,35 +1888,17 @@ xlog_sync(
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
-	bool		flush = true;
+	unsigned int		count;		/* byte count of bwrite */
+	unsigned int		roundoff;       /* roundoff to BB or stripe */
+	uint64_t		bno;
+	unsigned int		split = 0;
+	unsigned int		size;
+	bool			flush = true;
 
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
@@ -1897,7 +1909,7 @@ xlog_sync(
 
 	/* real byte length */
 	size = iclog->ic_offset;
-	if (v2)
+	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb))
 		size += roundoff;
 	iclog->ic_header.h_len = cpu_to_be32(size);
 
-- 
2.20.1

