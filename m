Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08A883646F
	for <lists+linux-xfs@lfdr.de>; Wed,  5 Jun 2019 21:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbfFETP6 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 5 Jun 2019 15:15:58 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:59722 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726670AbfFETP6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jun 2019 15:15:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=+kTXYhnGfsaaI7TXns3oSJMPKOZHcx2ne+W5RNine74=; b=A+MYuM+0KixThswOVpfFmx5OA/
        OkrPJw3rIPHOUVtt7C1YX3qq6ar+b91bSHEJPcyoRrvH6s7hi2koVFi3DX6JQBDg8ibTVlAkIsNKA
        iw8xivI6AaqdUeWouNYHxt7MIj+Vl52QchhiwQyg6IhKxeVjL4OCbfW4ARRYeZjVUGLXugfvZe9/m
        6fl0fhwySKIb+WRVxIGhe4EAJQDKoKUQu3MNbtTo7AZBTWnCGH2Bj56MEAPzD009PUPrPDoeYbRRp
        3PkEYUaxqkU+bs2sFn28SmhmmM4PJMjpszh86MDpKtqHY6wIEvOgQW7zzcQZYy3pixV34m2u46mku
        woCYODDQ==;
Received: from 089144193064.atnat0002.highway.a1.net ([89.144.193.64] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hYbO9-0002E9-NP; Wed, 05 Jun 2019 19:15:58 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 13/24] xfs: update both stat counters together in xlog_sync
Date:   Wed,  5 Jun 2019 21:15:00 +0200
Message-Id: <20190605191511.32695-14-hch@lst.de>
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

Just a small bit of code tidying up.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index b22f75affdc5..16f90a8fe49b 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1859,7 +1859,6 @@ xlog_sync(
 	unsigned int		size;
 	bool			need_flush = true;
 
-	XFS_STATS_INC(log->l_mp, xs_log_writes);
 	ASSERT(atomic_read(&iclog->ic_refcnt) == 0);
 
 	count = xlog_calc_iclog_size(log, iclog, &roundoff);
@@ -1877,6 +1876,7 @@ xlog_sync(
 		size += roundoff;
 	iclog->ic_header.h_len = cpu_to_be32(size);
 
+	XFS_STATS_INC(log->l_mp, xs_log_writes);
 	XFS_STATS_ADD(log->l_mp, xs_log_blocks, BTOBB(count));
 
 	bno = BLOCK_LSN(be64_to_cpu(iclog->ic_header.h_lsn));
-- 
2.20.1

