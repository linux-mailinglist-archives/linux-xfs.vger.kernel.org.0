Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5C3B259566
	for <lists+linux-xfs@lfdr.de>; Tue,  1 Sep 2020 17:51:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728819AbgIAPux (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 1 Sep 2020 11:50:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727094AbgIAPuh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Sep 2020 11:50:37 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 790ACC061261
        for <linux-xfs@vger.kernel.org>; Tue,  1 Sep 2020 08:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=huI+qBuRC8KeWzsCnqYmZVpaH0u2JNmWYAjVb7gNnjI=; b=vX1UJ5r5iYjUz5s/SRl0QteBze
        TbhANQzM9qr78LrnEmEhScR2mvoAGp7KGAuQj6rKunsoQ5CD4iStgVCmUzhPhC1MZQ6f7Mq1YX3ZQ
        xKZAIrRoAJrO3M+HCldICCNnTv0Yr32CJo8Inyt/LzFu7UvaWnhm/MToril/am/qSJmbq2s9rBzzG
        p8jdxqlesyTUpqNmJua/msCmQVEHsd9EzUobois/HQe8fx0CB8DSroI0yCIrmFDx+7o34AmO/+y9a
        /6Av/2Oj7whvJsoKrZqwrzPjNn8nNzWS21cPlNfZFVmFtU5H4XcvE+P46PMzCAecb0C1P8bNpR4qM
        5sJGYF9w==;
Received: from [2001:4bb8:18c:45ba:2f95:e5:ca6b:9b4a] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kD8YK-0003mZ-RU; Tue, 01 Sep 2020 15:50:33 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 08/15] xfs: lift the XBF_IOEND_FAIL handling into xfs_buf_ioend_disposition
Date:   Tue,  1 Sep 2020 17:50:11 +0200
Message-Id: <20200901155018.2524-9-hch@lst.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901155018.2524-1-hch@lst.de>
References: <20200901155018.2524-1-hch@lst.de>
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

