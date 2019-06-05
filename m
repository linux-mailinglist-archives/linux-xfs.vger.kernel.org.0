Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD89136468
	for <lists+linux-xfs@lfdr.de>; Wed,  5 Jun 2019 21:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbfFETPc (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 5 Jun 2019 15:15:32 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:59674 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbfFETPc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jun 2019 15:15:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=WoGO+ipjDp5qA/1T/1lrubpaJSXRekoTcaiKnZsiRmQ=; b=eJEal4/y3bdKHi+CU8F/ehQ7Q
        hgqoYpJdj/kBbUMeb23aweETQ3ESVvaPLRTO3gDJxNDWOa9EcrosWUlkP5Yb6NBg4jQd2fK78BUqk
        1Kblyk/68nmqhSHMZasxZeg6htUc30XIfIw9E6V2FgigdbarrHX0F6cO6FLY+9eJATjCOXXy8ZeeA
        CiPUNuUFmQhrI+DJcO7qpHw+iWprjuxuMzvHeUZv0jiauj0lC4sp2Ip5Wu87U4RFBgoaQaSi5EzMB
        rDYlnaAukvDLbnPo1HG4Abc2G02Z3m6iAK05R3+5sJX4P3IjcRL9VT3YFgogU73+1kjd06b0v6PZ8
        RjbmUxXAg==;
Received: from 089144193064.atnat0002.highway.a1.net ([89.144.193.64] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hYbNj-0002CC-HH
        for linux-xfs@vger.kernel.org; Wed, 05 Jun 2019 19:15:32 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 06/24] xfs: cleanup xlog_get_iclog_buffer_size
Date:   Wed,  5 Jun 2019 21:14:53 +0200
Message-Id: <20190605191511.32695-7-hch@lst.de>
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

We don't really need all the messy branches in the function, as it
really does three things, out of which 2 are common for all branches:

 1) set up mount point log buffer size and count values if not already
    done from mount options
 2) calculate the number of log headers
 3) set up all the values in struct xlog based on the above

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 52 ++++++++++--------------------------------------
 1 file changed, 11 insertions(+), 41 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 8033b64092bb..3e7b046e04b5 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1301,56 +1301,26 @@ xlog_iodone(xfs_buf_t *bp)
  * If the filesystem blocksize is too large, we may need to choose a
  * larger size since the directory code currently logs entire blocks.
  */
-
 STATIC void
 xlog_get_iclog_buffer_size(
 	struct xfs_mount	*mp,
 	struct xlog		*log)
 {
-	int xhdrs;
-
 	if (mp->m_logbufs <= 0)
-		log->l_iclog_bufs = XLOG_MAX_ICLOGS;
-	else
-		log->l_iclog_bufs = mp->m_logbufs;
+		mp->m_logbufs = XLOG_MAX_ICLOGS;
+	if (mp->m_logbsize <= 0)
+		mp->m_logbsize = XLOG_BIG_RECORD_BSIZE;
+
+	log->l_iclog_bufs = mp->m_logbufs;
+	log->l_iclog_size = mp->m_logbsize;
 
 	/*
-	 * Buffer size passed in from mount system call.
+	 * # headers = size / 32k - one header holds cycles from 32k of data.
 	 */
-	if (mp->m_logbsize > 0) {
-		if (xfs_sb_version_haslogv2(&mp->m_sb)) {
-			/* # headers = size / 32k
-			 * one header holds cycles from 32k of data
-			 */
-
-			xhdrs = mp->m_logbsize / XLOG_HEADER_CYCLE_SIZE;
-			if (mp->m_logbsize % XLOG_HEADER_CYCLE_SIZE)
-				xhdrs++;
-			log->l_iclog_hsize = xhdrs << BBSHIFT;
-			log->l_iclog_heads = xhdrs;
-		} else {
-			ASSERT(mp->m_logbsize <= XLOG_BIG_RECORD_BSIZE);
-			log->l_iclog_hsize = BBSIZE;
-			log->l_iclog_heads = 1;
-		}
-		goto done;
-	}
-
-	/* All machines use 32kB buffers by default. */
-	log->l_iclog_size = XLOG_BIG_RECORD_BSIZE;
-
-	/* the default log size is 16k or 32k which is one header sector */
-	log->l_iclog_hsize = BBSIZE;
-	log->l_iclog_heads = 1;
-
-done:
-	/* are we being asked to make the sizes selected above visible? */
-	if (mp->m_logbufs == 0)
-		mp->m_logbufs = log->l_iclog_bufs;
-	if (mp->m_logbsize == 0)
-		mp->m_logbsize = log->l_iclog_size;
-}	/* xlog_get_iclog_buffer_size */
-
+	log->l_iclog_heads =
+		DIV_ROUND_UP(mp->m_logbsize, XLOG_HEADER_CYCLE_SIZE);
+	log->l_iclog_hsize = log->l_iclog_heads << BBSHIFT;
+}
 
 void
 xfs_log_work_queue(
-- 
2.20.1

