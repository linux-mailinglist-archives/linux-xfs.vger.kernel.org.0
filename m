Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 307F536469
	for <lists+linux-xfs@lfdr.de>; Wed,  5 Jun 2019 21:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726645AbfFETPf (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 5 Jun 2019 15:15:35 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:59676 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbfFETPf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jun 2019 15:15:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=UvRPXvvkOBl4UU91Imc62z2pIqpdkIAE1sdSXyHLa28=; b=qxeh1s4bCC/wkzzEqXN2zDHLyo
        M9kW6astxqSxiCghRg6CwLx0xky/pCs0lhGjJWiVMbQKH1Jq6vfR+A6MDhGauKd3rdw0N4mLjhBe+
        PsjQQMbGGYR7nfAq+V74QMAPOaY6M3+13Jjc9+NF3wBYnkKFOonB+rzCRpU4PsXPWj/JZ2OWrc44l
        VqFJibpN0NBJv4GhtVRp/DM4JcsPX+ZWIydWTHHaLhLM7xZJjyHaKpRYoM3SuGt6yOrolmfC3HRah
        ARc7cSbcOHHJeu80eGOBbg46p5WsNN42YlptNCgIGHUOAXoo4nYc9BhgOoUSltbgvIevZYIs57ggV
        CbNXZt5A==;
Received: from 089144193064.atnat0002.highway.a1.net ([89.144.193.64] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hYbNm-0002CL-QJ; Wed, 05 Jun 2019 19:15:35 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 07/24] xfs: reformat xlog_get_lowest_lsn
Date:   Wed,  5 Jun 2019 21:14:54 +0200
Message-Id: <20190605191511.32695-8-hch@lst.de>
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

Reformat xlog_get_lowest_lsn to our usual style.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 3e7b046e04b5..eececb847f8d 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2632,27 +2632,23 @@ xlog_state_clean_log(
 
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

