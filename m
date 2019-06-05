Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1339836470
	for <lists+linux-xfs@lfdr.de>; Wed,  5 Jun 2019 21:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbfFETQB (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 5 Jun 2019 15:16:01 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:59726 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbfFETQB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jun 2019 15:16:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=IV5PfolFz7twGgFosfWL0kEM8sPSDLv8bmRnlzhLqng=; b=f8s3uyGm3wyuu3R7rAj7kuCpBQ
        Wd/G6syRa/REEEG0MwoTU3ts8zGrzqfkZ6QF/Sikg6Q2q9UEjA/2kOb+H3DvVqhgokbWlHeS08xz+
        9d8T98RcWR1y+BqYQWjFdT87eOzeg8Z4AtVL52R4HwcWNR0ntbqHcuhUa6j4NvoBUqmJqC6lUHl0p
        nkRGeNH27B/U9k/cp2zTMeRSVXBVpeFIe1S8GMPTa3e54VVLRkk80+m4Hqyb0v+OmsdNc6y+ZXuTA
        se5ghTUK5NkxzjfPp1mzwCNe2lpv5EposwZGIcxxKxN1KPIvinjSOsamwoIifl8Lum6xUkMqSKzo4
        BjtqOfwg==;
Received: from 089144193064.atnat0002.highway.a1.net ([89.144.193.64] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hYbOC-0002EH-QD; Wed, 05 Jun 2019 19:16:01 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 14/24] xfs: remove the syncing argument from xlog_verify_iclog
Date:   Wed,  5 Jun 2019 21:15:01 +0200
Message-Id: <20190605191511.32695-15-hch@lst.de>
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

The only caller unconditionally passes true here.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 16f90a8fe49b..5f5b74c7ec2e 100644
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
 
@@ -1921,7 +1920,7 @@ xlog_sync(
 	iclog->ic_bp->b_io_length = BTOBB(split ? split : count);
 	iclog->ic_bwritecnt = split ? 2 : 1;
 
-	xlog_verify_iclog(log, iclog, count, true);
+	xlog_verify_iclog(log, iclog, count);
 	xlog_write_iclog(log, iclog, iclog->ic_bp, bno, need_flush);
 
 	if (split) {
@@ -3761,8 +3760,7 @@ STATIC void
 xlog_verify_iclog(
 	struct xlog		*log,
 	struct xlog_in_core	*iclog,
-	int			count,
-	bool                    syncing)
+	int			count)
 {
 	xlog_op_header_t	*ophead;
 	xlog_in_core_t		*icptr;
@@ -3806,7 +3804,7 @@ xlog_verify_iclog(
 		/* clientid is only 1 byte */
 		p = &ophead->oh_clientid;
 		field_offset = p - base_ptr;
-		if (!syncing || (field_offset & 0x1ff)) {
+		if (field_offset & 0x1ff) {
 			clientid = ophead->oh_clientid;
 		} else {
 			idx = BTOBBT((char *)&ophead->oh_clientid - iclog->ic_datap);
@@ -3829,7 +3827,7 @@ xlog_verify_iclog(
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

