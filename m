Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7BBE3646D
	for <lists+linux-xfs@lfdr.de>; Wed,  5 Jun 2019 21:15:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbfFETPs (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 5 Jun 2019 15:15:48 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:59712 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbfFETPs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jun 2019 15:15:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=pLA6j3NR+5/JfCU4w+zLJdTKYxoJ+OlAwKKZr/W+/yw=; b=EnxpdWXmGdqx3mTvX0v5IwXhgE
        FLc4KRtW4jd1Rb+aKl5oQLLqd+3ODcCfsQ9Hd4SWZPn6A+inhZo2shRpTWYvNJjG3wuIB4WCA4wnw
        ZhVyL+qokTi7vmbwEErpuAyL+WaWOvzkhbTjrzsJVvS96myS0Nn40Ur/oMcp8il98ZVvWJEqlve0o
        uf0r12FL1X4Pr/2kwgi/v4s3BaQQ+o5Nfynl2TDnnTx7FElX+w53vpe2Cld7DzNBks+HFbnAXJWG9
        lJ9X9Da0W+SGG/LwEIwNMDeLPZz1HDOIolQKdqgMj+IuQ+uO4IOxzNSH/qha+Gbya/qUeYpcZL8i/
        Zz5YqG/A==;
Received: from 089144193064.atnat0002.highway.a1.net ([89.144.193.64] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hYbNz-0002Dk-9R; Wed, 05 Jun 2019 19:15:47 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 11/24] xfs: factor out splitting of an iclog from xlog_sync
Date:   Wed,  5 Jun 2019 21:14:58 +0200
Message-Id: <20190605191511.32695-12-hch@lst.de>
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

Split out a self-contained chunk of code from xlog_sync that calculates
the split offset for an iclog that wraps the log end and bumps the
cycles for the second half.

Use the chance to bring some sanity to the variables used to track the
split in xlog_sync by not changing the count variable, and instead use
split as the offset for the split and use those to calculate the
sizes and offsets for the two write buffers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c | 63 +++++++++++++++++++++++++-----------------------
 1 file changed, 33 insertions(+), 30 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 7b4a11c1ff08..2138bc8cc6e8 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1765,6 +1765,32 @@ xlog_write_iclog(
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
@@ -1793,13 +1819,12 @@ xlog_sync(
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
 
@@ -1842,32 +1867,8 @@ xlog_sync(
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
@@ -1902,14 +1903,16 @@ xlog_sync(
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

