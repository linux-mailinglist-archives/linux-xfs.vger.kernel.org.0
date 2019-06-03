Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D86C336AB
	for <lists+linux-xfs@lfdr.de>; Mon,  3 Jun 2019 19:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729927AbfFCRaC (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 3 Jun 2019 13:30:02 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53564 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727754AbfFCRaB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Jun 2019 13:30:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=LHZSHSkT4eSji6hYytW6umsq4iZZfwPTEgyt1bmwbuc=; b=B+ExI+sEuCUInD07P1TWx8zI2D
        F1Qk+gi80HIdn3Mh7KEhBmFvwRydoUvJrGZGKH5TPh0w8X8KQACy+zB3YWgZchjKkqUXpiUjsTyx0
        LyddX2/94vVnDQOg5B0ZqkBjCDlKlOcjjym4XIZL3tHE28liaTEu6PQWbKSfMkrF4T9uuBLxbE18u
        RAHaeZQaTMsaPj/ZUAGih+tdBsDJnq4Gb1b3SFRw/yBc9zTi6ETDn4uO81mksZXp+hTOkZWjtxQbs
        F3dK3xp5iRnA3DuZmsKyfKBx9rF14z9zbyYDuLdxRB9RsWSftPEtatFYRneyLbOpOo/2RaMQfdpGg
        MBYQL2xw==;
Received: from 089144193064.atnat0002.highway.a1.net ([89.144.193.64] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hXqmW-0002Ov-VZ; Mon, 03 Jun 2019 17:30:01 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 05/20] xfs: reformat xlog_get_lowest_lsn
Date:   Mon,  3 Jun 2019 19:29:30 +0200
Message-Id: <20190603172945.13819-6-hch@lst.de>
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

Reformat xlog_get_lowest_lsn to our usual style.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index a2048e46be4e..3b82ca8ac9c8 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2671,27 +2671,23 @@ xlog_state_clean_log(
 
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

