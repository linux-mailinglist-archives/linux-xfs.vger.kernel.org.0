Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E350123CFE
	for <lists+linux-xfs@lfdr.de>; Mon, 20 May 2019 18:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392518AbfETQOv (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 May 2019 12:14:51 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:36408 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387964AbfETQOv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 12:14:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=wW8Qzz+P66q0Q1xU9oWaqQNAFGLWH26GwRiSfs1m168=; b=rb1D3zmxI8E4I6iF+Cypvf0Dv
        zXXmNBNT0rAE9V0wKhVpRJj5oGXqVC7g1QTarZO6oJSfLVjzvpaGLIATWtAxV8/OrTr0WJcYpWBJz
        i8ovVg4KSA5bm88by0jYnRG3dY0mhsF38hTZZauD3/5m6SCAvkC68mqw9NaURt0a+PWBDvDR48MVy
        utQ2QRmCMVOLk0fRM9LwItuinc7N6NtHRdrDpyZXVjjFDLrpO8KfRVvPKsXmZPER7NJzXAaW6t23E
        iFbdpK3qeax9iR1CN/ZfaAcuepWRC9SFt006m3KfE+lCNwf7H94hvNRmSWXrVLygXJgexpt38b3kp
        woVG9m1og==;
Received: from 089144206147.atnat0015.highway.bob.at ([89.144.206.147] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hSkw5-0005UX-NO
        for linux-xfs@vger.kernel.org; Mon, 20 May 2019 16:14:50 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 03/17] xfs: renumber XBF_WRITE_FAIL
Date:   Mon, 20 May 2019 18:13:33 +0200
Message-Id: <20190520161347.3044-4-hch@lst.de>
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

Assining a numerical value that is not close to the flags
defined near by is just asking for conflicts later on.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index f67024c1deaa..61691d9a5bc9 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -28,7 +28,7 @@
 #define XBF_ASYNC	 (1 << 4) /* initiator will not wait for completion */
 #define XBF_DONE	 (1 << 5) /* all pages in the buffer uptodate */
 #define XBF_STALE	 (1 << 6) /* buffer has been staled, do not find it */
-#define XBF_WRITE_FAIL	 (1 << 24)/* async writes have failed on this buffer */
+#define XBF_WRITE_FAIL	 (1 << 7) /* async writes have failed on this buffer */
 
 /* I/O hints for the BIO layer */
 #define XBF_SYNCIO	 (1 << 10)/* treat this buffer as synchronous I/O */
-- 
2.20.1

