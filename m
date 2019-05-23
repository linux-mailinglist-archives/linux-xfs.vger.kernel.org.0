Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3B4D2850B
	for <lists+linux-xfs@lfdr.de>; Thu, 23 May 2019 19:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731237AbfEWRiR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 23 May 2019 13:38:17 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:56048 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731037AbfEWRiR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 May 2019 13:38:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=W+Khy+nwB9Kns80R5fkPOH8OvLE9Yo+686UqTb1kb5w=; b=uTK7mWOgqxmgAOjQCGxSEQ7s2
        mjhikB4pvFCeuWRvGoQdpySAqWX8MvSXtYWmu/f33to+fBmo3fwo0i9hnyFWFMYPBV+nyE1ZrGN0S
        9WxAQWQENGArvZ7U7AI4+9omYkUPoaoHk7XMhD86tddES5r5UrICPRB6J38YXhwWhvaS+U0dr3av/
        Yp8WYahIRbcCtAHPvseUQkWu8/AAxccaH9Z3O+z1ltQdzkMe7l7SnV9gmRwPmgdyVwTqqj3Xwiv4g
        Iuf3biImlWfXFUYtYVEnVzd90td5Ksmzcb3odrenBPfOE4gWkNVj9Tnu9VmlYAaRn2hjGmsMN7kmD
        PARM580kA==;
Received: from 213-225-10-46.nat.highway.a1.net ([213.225.10.46] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hTrfT-0000UV-SE
        for linux-xfs@vger.kernel.org; Thu, 23 May 2019 17:38:16 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 03/20] xfs: renumber XBF_WRITE_FAIL
Date:   Thu, 23 May 2019 19:37:25 +0200
Message-Id: <20190523173742.15551-4-hch@lst.de>
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

Assining a numerical value that is not close to the flags
defined near by is just asking for conflicts later on.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 4f2c2bc43003..15f6ce3974ac 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -34,7 +34,7 @@ typedef enum {
 #define XBF_ASYNC	 (1 << 4) /* initiator will not wait for completion */
 #define XBF_DONE	 (1 << 5) /* all pages in the buffer uptodate */
 #define XBF_STALE	 (1 << 6) /* buffer has been staled, do not find it */
-#define XBF_WRITE_FAIL	 (1 << 24)/* async writes have failed on this buffer */
+#define XBF_WRITE_FAIL	 (1 << 7) /* async writes have failed on this buffer */
 
 /* I/O hints for the BIO layer */
 #define XBF_SYNCIO	 (1 << 10)/* treat this buffer as synchronous I/O */
-- 
2.20.1

