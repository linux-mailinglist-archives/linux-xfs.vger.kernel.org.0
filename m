Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFEFF336B0
	for <lists+linux-xfs@lfdr.de>; Mon,  3 Jun 2019 19:30:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728031AbfFCRaO (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 3 Jun 2019 13:30:14 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53612 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727754AbfFCRaO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Jun 2019 13:30:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=OyeBrULzRSPro5QvtQPW6ckuz02LDeBTx+HxxsZ3W4Y=; b=OVhq+9GopGdtA/7hdv6ocvcuFS
        SyPLfZH7FSjxLAXzSytGW98q8N5++COK8/oFFQorv4QMzx3s9R/IkBQmbm4Am1C3vszTSyDyWdbLQ
        tHV9nljoGtMivbCUHmClLlyhfel7QVk6QgFwcIhoeN5KMp/wg+t9ciaB8fAtXGvGTWGT3sckmXelL
        hrlfOfbdIBogAR6asgaHFf0ebuOsJ4vy6Ej3XnvhaIloZmbO7Z1Hh4OPSueHa2VVAs2mNPfrl004b
        iRRcW4+guigbWPoXhm2msT+uiFx+Hh77ZKd49Qx9gG9pjDtDSTTUGygSAv/vAWslkvsoP/TOlP+wN
        7WfOEYvQ==;
Received: from 089144193064.atnat0002.highway.a1.net ([89.144.193.64] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hXqmj-0003go-Ji; Mon, 03 Jun 2019 17:30:13 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 10/20] xfs: update both stat counters together in xlog_sync
Date:   Mon,  3 Jun 2019 19:29:35 +0200
Message-Id: <20190603172945.13819-11-hch@lst.de>
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

Just a small bit of code tidying up.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 02e9ab3af5ee..fa0414b8b111 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1898,7 +1898,6 @@ xlog_sync(
 	unsigned int		size;
 	bool			need_flush = true;
 
-	XFS_STATS_INC(log->l_mp, xs_log_writes);
 	ASSERT(atomic_read(&iclog->ic_refcnt) == 0);
 
 	count = xlog_calc_iclog_size(log, iclog, &roundoff);
@@ -1916,6 +1915,7 @@ xlog_sync(
 		size += roundoff;
 	iclog->ic_header.h_len = cpu_to_be32(size);
 
+	XFS_STATS_INC(log->l_mp, xs_log_writes);
 	XFS_STATS_ADD(log->l_mp, xs_log_blocks, BTOBB(count));
 
 	bno = BLOCK_LSN(be64_to_cpu(iclog->ic_header.h_lsn));
-- 
2.20.1

