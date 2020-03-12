Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5810183354
	for <lists+linux-xfs@lfdr.de>; Thu, 12 Mar 2020 15:40:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727467AbgCLOkF (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 12 Mar 2020 10:40:05 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:54944 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727359AbgCLOkF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Mar 2020 10:40:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=djUpOmWEtfW3uwunPAI3HAPM81WJYZGUUVAggh01B9Q=; b=f8YMNGMB+VXl4CnTvhKymkv/Zz
        y0bY7i2NQww97L8At1cJT15S2SA4v2bUObVDVmzSbgrIogA4aY/bgp/jBfgGSJXEItiPdv6I5cNM+
        OY145Q1PQvWYvJhGpL4km+o2gt+sCY1JUd6yjLVuYJ1Ry/Jsw5URG0QiwxdDj9Z7a0ATIWn2grHaY
        WSkrytHr1ncr8LgeWbM0Hc5mgTof91BTvujacxyOt9cLgrnQpY3Vbr5gIApNW9euUkXbxWQyonwKB
        hytW4BXMMiK6ijHcv+rz40MCCfzOQ/bSrpvQDOob1vjfZSGbZPlIdkHJIcZsO4nqZUrTOGr6GYaN8
        ejDiX0qg==;
Received: from [2001:4bb8:184:5cad:8026:d98c:a056:3e33] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jCP0G-0007Cd-Kd; Thu, 12 Mar 2020 14:40:05 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/5] xfs: mark XLOG_FORCED_SHUTDOWN as unlikely
Date:   Thu, 12 Mar 2020 15:39:55 +0100
Message-Id: <20200312143959.583781-2-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200312143959.583781-1-hch@lst.de>
References: <20200312143959.583781-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

A shutdown log is a slow failure path.  Add an unlikely annotation to
it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log_priv.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index b192c5a9f9fd..e400170ff4af 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -402,7 +402,8 @@ struct xlog {
 #define XLOG_BUF_CANCEL_BUCKET(log, blkno) \
 	((log)->l_buf_cancel_table + ((uint64_t)blkno % XLOG_BC_TABLE_SIZE))
 
-#define XLOG_FORCED_SHUTDOWN(log)	((log)->l_flags & XLOG_IO_ERROR)
+#define XLOG_FORCED_SHUTDOWN(log) \
+	(unlikely((log)->l_flags & XLOG_IO_ERROR))
 
 /* common routines */
 extern int
-- 
2.24.1

