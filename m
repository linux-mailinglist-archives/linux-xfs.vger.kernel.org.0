Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1E1A23CFF
	for <lists+linux-xfs@lfdr.de>; Mon, 20 May 2019 18:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392548AbfETQOx (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 May 2019 12:14:53 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:36696 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387964AbfETQOx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 12:14:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=TVjb/URPvSAtUoTpS2R4DSemJr61NYW/wI0XPMhXcvQ=; b=Be15SsB3DXhwJ0hNPhHX3CrKg
        gV/+3sbdwrXp9OP5X/GQLZ9Mhm7iMh+uZCy1Hhy3lNnH5ZZp66iKSj4cwEIuK7Q55aSQP0+4F4oIw
        PghdiB+koBHsT96691Rm75OduiT9yEvkN+CNU4ERByeYN4Hp3SqmPGQT/8MDShBwDJNQ19JjQHiem
        bLO8gLEXUxc8CK5QerWBYVJknT64TH35sRTzWVKsyn2xXlOopSdOf5CjpOFsBHz5ZgiftkprbPsAw
        jUArs3ozuUBQW9RCxCaDwjnAJTIx7BCxjDpGa3F+uowomAicVTPFgiv2cczTxe94yJJnPeBhqNd0U
        Bm6kiG8ZQ==;
Received: from 089144206147.atnat0015.highway.bob.at ([89.144.206.147] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hSkw8-0005Zy-Me
        for linux-xfs@vger.kernel.org; Mon, 20 May 2019 16:14:53 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 04/17] xfs: reformat xlog_get_lowest_lsn
Date:   Mon, 20 May 2019 18:13:34 +0200
Message-Id: <20190520161347.3044-5-hch@lst.de>
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

Reformat xlog_get_lowest_lsn to our usual style.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 242ab5e8aaea..e7c9e1a653a8 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2642,27 +2642,23 @@ xlog_state_clean_log(
 
 STATIC xfs_lsn_t
 xlog_get_lowest_lsn(
-	struct xlog	*log)
+	struct xlog		*log)
 {
-	xlog_in_core_t  *lsn_log;
-	xfs_lsn_t	lowest_lsn, lsn;
+	struct xlog_in_core	*iclog = log->l_iclog;
+	xfs_lsn_t		lowest_lsn = 0, lsn;
 
-	lsn_log = log->l_iclog;
-	lowest_lsn = 0;
 	do {
-	    if (!(lsn_log->ic_state & (XLOG_STATE_ACTIVE|XLOG_STATE_DIRTY))) {
-		lsn = be64_to_cpu(lsn_log->ic_header.h_lsn);
-		if ((lsn && !lowest_lsn) ||
-		    (XFS_LSN_CMP(lsn, lowest_lsn) < 0)) {
+		if (iclog->ic_state & (XLOG_STATE_ACTIVE | XLOG_STATE_DIRTY))
+			continue;
+
+		lsn = be64_to_cpu(iclog->ic_header.h_lsn);
+		if ((lsn && !lowest_lsn) || XFS_LSN_CMP(lsn, lowest_lsn) < 0)
 			lowest_lsn = lsn;
-		}
-	    }
-	    lsn_log = lsn_log->ic_next;
-	} while (lsn_log != log->l_iclog);
+	} while ((iclog = iclog->ic_next) != log->l_iclog);
+
 	return lowest_lsn;
 }
 
-
 STATIC void
 xlog_state_do_callback(
 	struct xlog		*log,
-- 
2.20.1

