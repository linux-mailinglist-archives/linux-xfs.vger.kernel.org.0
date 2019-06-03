Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA9DD336AE
	for <lists+linux-xfs@lfdr.de>; Mon,  3 Jun 2019 19:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729929AbfFCRaJ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 3 Jun 2019 13:30:09 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53594 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727754AbfFCRaJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Jun 2019 13:30:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=k785f4qrogbNAiecNyJQWbWrwBaOUWyBVcLb/O1dMAI=; b=XLaTHq17GhHFiOXcxYgt4Td0u
        dyDGnAFaTb8PMnTEYweYqNBA7fOLGLWcHNq2K7mcjNPA23987AjqH7Jd7VZduVQjgPJFoW9PB5Uue
        5WFew2MSC202lsvxMzhXvOJFbUwokY+pICKi/iJkdZI3a//BEDT+XOECc2wZvnGMAeLa+CpUzoMfu
        nBG/dCnyA1to+3nU2aPDajQlYFQx8k6F+fjHFA0P5hCCxVJLTsZIv+xwbKJ7hX70Op8RtcSbWcIiC
        nh+xXZAqsCXPW8oEBVD0PFlO9MYj/SeEdl+/00W9eBcCgSKmrB7GF79Bew8R+lh0tnw+NuoDFZmNu
        mm2m8tnMQ==;
Received: from 089144193064.atnat0002.highway.a1.net ([89.144.193.64] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hXqme-0003Ub-FR
        for linux-xfs@vger.kernel.org; Mon, 03 Jun 2019 17:30:08 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 08/20] xfs: factor out splitting of an iclog from xlog_sync
Date:   Mon,  3 Jun 2019 19:29:33 +0200
Message-Id: <20190603172945.13819-9-hch@lst.de>
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

Split out a self-contained chunk of code from xlog_sync that calculates
the split offset for an iclog that wraps the log end and bumps the
cycles for the second half.

Use the chance to bring some sanity to the variables used to track the
split in xlog_sync by not changing the count variable, and instead use
split as the offset for the split and use those to calculate the
sizes and offsets for the two write buffers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 63 +++++++++++++++++++++++++-----------------------
 1 file changed, 33 insertions(+), 30 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 217941c4105d..0d8805c9570a 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1804,6 +1804,32 @@ xlog_write_iclog(
 	xfs_buf_submit(bp);
 }
 
+/*
+ * We need to bump cycle number for the part of the iclog that is
+ * written to the start of the log. Watch out for the header magic
+ * number case, though.
+ */
+static unsigned int
+xlog_split_iclog(
+	struct xlog		*log,
+	void			*data,
+	uint64_t		bno,
+	unsigned int		count)
+{
+	unsigned int		split_offset = BBTOB(log->l_logBBsize - bno);
+	unsigned int		i;
+
+	for (i = split_offset; i < count; i += BBSIZE) {
+		uint32_t cycle = get_unaligned_be32(data + i);
+
+		if (++cycle == XLOG_HEADER_MAGIC_NUM)
+			cycle++;
+		put_unaligned_be32(cycle, data + i);
+	}
+
+	return split_offset;
+}
+
 /*
  * Flush out the in-core log (iclog) to the on-disk log in an asynchronous 
  * fashion.  Previously, we should have moved the current iclog
@@ -1832,13 +1858,12 @@ xlog_sync(
 	struct xlog		*log,
 	struct xlog_in_core	*iclog)
 {
-	int		i;
 	uint		count;		/* byte count of bwrite */
 	uint		count_init;	/* initial count before roundup */
 	int		roundoff;       /* roundoff to BB or stripe */
-	int		split = 0;	/* split write into two regions */
 	int		v2 = xfs_sb_version_haslogv2(&log->l_mp->m_sb);
 	uint64_t	bno;
+	unsigned int	split = 0;
 	int		size;
 	bool		need_flush = true;
 
@@ -1881,32 +1906,8 @@ xlog_sync(
 	bno = BLOCK_LSN(be64_to_cpu(iclog->ic_header.h_lsn));
 
 	/* Do we need to split this write into 2 parts? */
-	if (bno + BTOBB(count) > log->l_logBBsize) {
-		char		*dptr;
-
-		split = count - (BBTOB(log->l_logBBsize - bno));
-		count = BBTOB(log->l_logBBsize - bno);
-		iclog->ic_bwritecnt = 2;
-
-		/*
-		 * Bump the cycle numbers at the start of each block in the
-		 * part of the iclog that ends up in the buffer that gets
-		 * written to the start of the log.
-		 *
-		 * Watch out for the header magic number case, though.
-		 */
-		dptr = (char *)&iclog->ic_header + count;
-		for (i = 0; i < split; i += BBSIZE) {
-			uint32_t cycle = be32_to_cpu(*(__be32 *)dptr);
-			if (++cycle == XLOG_HEADER_MAGIC_NUM)
-				cycle++;
-			*(__be32 *)dptr = cpu_to_be32(cycle);
-
-			dptr += BBSIZE;
-		}
-	} else {
-		iclog->ic_bwritecnt = 1;
-	}
+	if (bno + BTOBB(count) > log->l_logBBsize)
+		split = xlog_split_iclog(log, &iclog->ic_header, bno, count);
 
 	/* calculcate the checksum */
 	iclog->ic_header.h_crc = xlog_cksum(log, &iclog->ic_header,
@@ -1939,14 +1940,16 @@ xlog_sync(
 		need_flush = false;
 	}
 
-	iclog->ic_bp->b_io_length = BTOBB(count);
+	iclog->ic_bp->b_io_length = BTOBB(split ? split : count);
+	iclog->ic_bwritecnt = split ? 2 : 1;
 
 	xlog_verify_iclog(log, iclog, count, true);
 	xlog_write_iclog(log, iclog, iclog->ic_bp, bno, need_flush);
 
 	if (split) {
 		xfs_buf_associate_memory(iclog->ic_log->l_xbuf,
-				(char *)&iclog->ic_header + count, split);
+				(char *)&iclog->ic_header + split,
+				count - split);
 		xlog_write_iclog(log, iclog, iclog->ic_log->l_xbuf, 0, false);
 	}
 }
-- 
2.20.1

