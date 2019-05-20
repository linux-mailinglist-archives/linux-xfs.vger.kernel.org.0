Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B47523D06
	for <lists+linux-xfs@lfdr.de>; Mon, 20 May 2019 18:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389409AbfETQPI (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 May 2019 12:15:08 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37150 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389045AbfETQPI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 12:15:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=0s+ROkaHLZZx8bBicua8r2IpiR8W1SReRVHqJIosFko=; b=GEzUPpGQlTmyunsOR9J8Om0z6
        XkQy9Nj5VUq+lip0ABwzB8aoN7huDBKF2CLE5Yp2uLx6mbzZJJEX2mD9x7rMJHRxpJosZuJDKYm1h
        DtMm74k5Fq7+7FNovnLY20I+poCtKD2brjwCVjO7upzbhpi+oHRSy0i/tUpNHel5qy60pxtCc29si
        oWs68M1usZ/c0ZOnNoNZr8VL1oqVD+9CGcIUGnpO0J1WTBQ4ORkq3LYKh9/YJi0YCzZTbiixrtX9U
        Z1Ul7YJuJ849NRE1y+F4/Lwh9PNL3OtipMelRBkEKrLnYjpknhgsXN2AfFoE+/T/ZaQ+NPOcHMDLJ
        wt/ZjelXg==;
Received: from 089144206147.atnat0015.highway.bob.at ([89.144.206.147] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hSkwN-0006Gn-Lh
        for linux-xfs@vger.kernel.org; Mon, 20 May 2019 16:15:08 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 09/17] xfs: update both state counters together in xlog_sync
Date:   Mon, 20 May 2019 18:13:39 +0200
Message-Id: <20190520161347.3044-10-hch@lst.de>
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

Just a small bit of code tidying up.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 9950b1bb77a9..c5a78bc9f99b 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1866,7 +1866,6 @@ xlog_sync(
 	unsigned int		size;
 	bool			flush = true;
 
-	XFS_STATS_INC(log->l_mp, xs_log_writes);
 	ASSERT(atomic_read(&iclog->ic_refcnt) == 0);
 
 	count = xlog_calc_iclog_size(log, iclog, &roundoff);
@@ -1884,6 +1883,7 @@ xlog_sync(
 		size += roundoff;
 	iclog->ic_header.h_len = cpu_to_be32(size);
 
+	XFS_STATS_INC(log->l_mp, xs_log_writes);
 	XFS_STATS_ADD(log->l_mp, xs_log_blocks, BTOBB(count));
 
 	bno = BLOCK_LSN(be64_to_cpu(iclog->ic_header.h_lsn));
-- 
2.20.1

