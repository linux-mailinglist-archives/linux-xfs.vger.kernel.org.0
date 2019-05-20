Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABA0123D05
	for <lists+linux-xfs@lfdr.de>; Mon, 20 May 2019 18:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389396AbfETQPF (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 May 2019 12:15:05 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37128 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389045AbfETQPF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 12:15:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=o1p8sdBSXWXVIMgyUCz0pNaN1jtg5Omc5cEcXGrUffo=; b=MsywldrZCUlfU5V/8IybO8NpI
        +QwKPaNIi9R/nttn44v4WrwHQG/e5vxVyf0WN79KwqyZPqna6pn/fWV6KmJNvi2msY9Z09AZCKfQA
        gwPEO1wsZOn/jp56nH27bSMvgCQMz66txUc1KSrrqRubDGt/Vn3SPGtNE+YD5w3fdGPu6POphaORE
        dsOCZV971gvibqZM0x5m4svcro5bCM+/tfcsqVnDv7LhP346o+f2fcgwfv2EOoINYbIVwUw6u1B5x
        cqK2lh1e2RrIjKTimwK8jzqlfDYesAvWnWQTPZEK9xQElMsOwWEfG5Oqh446anNOAhHENSh5w3hYR
        l0TI5iLYA==;
Received: from 089144206147.atnat0015.highway.bob.at ([89.144.206.147] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hSkwK-0005nA-Fq
        for linux-xfs@vger.kernel.org; Mon, 20 May 2019 16:15:04 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 08/17] xfs: split iclog size calculation out of xlog_sync
Date:   Mon, 20 May 2019 18:13:38 +0200
Message-Id: <20190520161347.3044-9-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190520161347.3044-1-hch@lst.de>
References: <20190520161347.3044-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Split out another selfcountained bit of code from xlog_sync.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 64 ++++++++++++++++++++++++++++--------------------
 1 file changed, 38 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index acfa1b1a85c2..9950b1bb77a9 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1801,6 +1801,36 @@ xlog_split_iclog(
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
@@ -1829,35 +1859,17 @@ xlog_sync(
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
@@ -1868,7 +1880,7 @@ xlog_sync(
 
 	/* real byte length */
 	size = iclog->ic_offset;
-	if (v2)
+	if (xfs_sb_version_haslogv2(&log->l_mp->m_sb))
 		size += roundoff;
 	iclog->ic_header.h_len = cpu_to_be32(size);
 
-- 
2.20.1

