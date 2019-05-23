Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 499182851D
	for <lists+linux-xfs@lfdr.de>; Thu, 23 May 2019 19:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731393AbfEWRkn (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 23 May 2019 13:40:43 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:56314 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731195AbfEWRkn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 May 2019 13:40:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=4NbyVGEL5vJ0p6m4Djaf4fdG8x05W0VvCDq3BHs0ePg=; b=OpsOJsnokKLtwEIvpPU7IkaOf
        Z4OGV9YK/RIinY4htPEGjsK+jUE0GAegKz+es7xYiRqjjULlh7KKIq447BYfQOlzhBd4H3wQ5xXlu
        ghCc2N6+nKwFumPPoimmNyBqrbND43XbqIMYIaR25iEeb8FWj+a5TZVTzmp7fYFmKTFS8N/51/VAg
        r6m+rdidGvTRYAZwnPCTfadxgWw6AQ2fd6Vpr1jyHfj7qHa8oNq1RkvVK2K0kpp8UvXzEKVGGSi+N
        gVB75eqoHovYIU+A7t0WXpCfwNeBzsAsr3KGhI/gWDvY3kdLO2BZUFQBzjqNsnuEMd9nL1UcpLF3f
        9198sAmnA==;
Received: from 213-225-10-46.nat.highway.a1.net ([213.225.10.46] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hTrhl-0002NH-Ju
        for linux-xfs@vger.kernel.org; Thu, 23 May 2019 17:40:42 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 11/20] xfs: remove the syncing argument from xlog_verify_iclog
Date:   Thu, 23 May 2019 19:37:33 +0200
Message-Id: <20190523173742.15551-12-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190523173742.15551-1-hch@lst.de>
References: <20190523173742.15551-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The only caller unconditionally passes true here.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 46a184d387ae..1974e47a96fb 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -103,8 +103,7 @@ STATIC void
 xlog_verify_iclog(
 	struct xlog		*log,
 	struct xlog_in_core	*iclog,
-	int			count,
-	bool                    syncing);
+	int			count);
 STATIC void
 xlog_verify_tail_lsn(
 	struct xlog		*log,
@@ -113,7 +112,7 @@ xlog_verify_tail_lsn(
 #else
 #define xlog_verify_dest_ptr(a,b)
 #define xlog_verify_grant_tail(a)
-#define xlog_verify_iclog(a,b,c,d)
+#define xlog_verify_iclog(a,b,c)
 #define xlog_verify_tail_lsn(a,b,c)
 #endif
 
@@ -1955,7 +1954,7 @@ xlog_sync(
 	iclog->ic_bp->b_io_length = BTOBB(split ? split : count);
 	iclog->ic_bwritecnt = split ? 2 : 1;
 
-	xlog_verify_iclog(log, iclog, count, true);
+	xlog_verify_iclog(log, iclog, count);
 	xlog_write_iclog(log, iclog, iclog->ic_bp, bno, flush);
 
 	if (split) {
@@ -3795,8 +3794,7 @@ STATIC void
 xlog_verify_iclog(
 	struct xlog		*log,
 	struct xlog_in_core	*iclog,
-	int			count,
-	bool                    syncing)
+	int			count)
 {
 	xlog_op_header_t	*ophead;
 	xlog_in_core_t		*icptr;
@@ -3840,7 +3838,7 @@ xlog_verify_iclog(
 		/* clientid is only 1 byte */
 		p = &ophead->oh_clientid;
 		field_offset = p - base_ptr;
-		if (!syncing || (field_offset & 0x1ff)) {
+		if (field_offset & 0x1ff) {
 			clientid = ophead->oh_clientid;
 		} else {
 			idx = BTOBBT((char *)&ophead->oh_clientid - iclog->ic_datap);
@@ -3863,7 +3861,7 @@ xlog_verify_iclog(
 		/* check length */
 		p = &ophead->oh_len;
 		field_offset = p - base_ptr;
-		if (!syncing || (field_offset & 0x1ff)) {
+		if (field_offset & 0x1ff) {
 			op_len = be32_to_cpu(ophead->oh_len);
 		} else {
 			idx = BTOBBT((uintptr_t)&ophead->oh_len -
-- 
2.20.1

