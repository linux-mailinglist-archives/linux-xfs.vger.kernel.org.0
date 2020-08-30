Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3AD3256BF0
	for <lists+linux-xfs@lfdr.de>; Sun, 30 Aug 2020 08:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbgH3GP0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 30 Aug 2020 02:15:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbgH3GPZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Aug 2020 02:15:25 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C21C061573
        for <linux-xfs@vger.kernel.org>; Sat, 29 Aug 2020 23:15:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=huI+qBuRC8KeWzsCnqYmZVpaH0u2JNmWYAjVb7gNnjI=; b=QGHpqnF4KImMueN3rNTAeyJX8T
        TBN/gGDqLGlaVfY4WDPZdEWPBR+PqYF3++T3IoEsy4f8pa35C/kFnD70wbxlDAeMmuL6hbH3r0iky
        CCgxyoxHMrCLk6OAmZniQMR+pMUU3DrRO+K+zcAXvaBGhUgRh1l6Fs3qRlmdnuqpWBUBN3o2HVd9S
        UjDdZb8e4vdJNO+HiCTP9KaHfjKyFKnJY7C3yaPnlH1yzKvumEk9FJ4fLT0fRblgea3VDTAV0FExU
        zu4o8VAwvJonJApgg7XC7FRXaLahFgtxVV7LCPEFs6TxozPdfn5Hfqmnuqz5NVAzF6f1knMyx15ob
        2a5tYK9w==;
Received: from [2001:4bb8:18c:45ba:9892:9e86:5202:32f0] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kCGcd-0001yU-R4; Sun, 30 Aug 2020 06:15:23 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 08/13] xfs: lift the XBF_IOEND_FAIL handling into xfs_buf_ioend_disposition
Date:   Sun, 30 Aug 2020 08:15:07 +0200
Message-Id: <20200830061512.1148591-9-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200830061512.1148591-1-hch@lst.de>
References: <20200830061512.1148591-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Keep all the error handling code together.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_buf.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 0d4eb06826f5e7..951d9c35b3170c 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1283,6 +1283,14 @@ xfs_buf_ioend_disposition(
 	}
 
 	/* Still considered a transient error. Caller will schedule retries. */
+	if (bp->b_flags & _XBF_INODES)
+		xfs_buf_inode_io_fail(bp);
+	else if (bp->b_flags & _XBF_DQUOTS)
+		xfs_buf_dquot_io_fail(bp);
+	else
+		ASSERT(list_empty(&bp->b_li_list));
+	xfs_buf_ioerror(bp, 0);
+	xfs_buf_relse(bp);
 	return XBF_IOEND_FAIL;
 
 resubmit:
@@ -1336,14 +1344,6 @@ xfs_buf_ioend(
 		case XBF_IOEND_DONE:
 			return;
 		case XBF_IOEND_FAIL:
-			if (bp->b_flags & _XBF_INODES)
-				xfs_buf_inode_io_fail(bp);
-			else if (bp->b_flags & _XBF_DQUOTS)
-				xfs_buf_dquot_io_fail(bp);
-			else
-				ASSERT(list_empty(&bp->b_li_list));
-			xfs_buf_ioerror(bp, 0);
-			xfs_buf_relse(bp);
 			return;
 		default:
 			break;
-- 
2.28.0

