Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFE6636465
	for <lists+linux-xfs@lfdr.de>; Wed,  5 Jun 2019 21:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbfFETPX (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 5 Jun 2019 15:15:23 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:59632 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbfFETPX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jun 2019 15:15:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=sr2qua3LAIyjQwUaq86aGWIzpiqEIE/8c2V7AOQ84os=; b=PRFIKyJNbOjXrV+A+YpdHW2Rdw
        xMiDtXUv925v9paB9o107DjySdBrK99zrs5YbR2/RMl04jRavKHIHehl8scqt3+1L2TIwxWKOnnD5
        6sbvc62ANFCPzUErJSNMX/BeCQNb7SNFEyItzRPbF9a4oe9HkBi7KByOobB3jOFi1wiMjyNYiDVC8
        BeefIKLn/9Z2Wd7j7jpYlL/D2iHoVnqN0uz4xboMXWin2+d3rIKMYaA7wiYdCtwzUlNNKZcfjh0Mq
        mNacB6uVcgLi1a5h8h+M0LVTgmNX5DOu9Voig/lB23XDulMUngFm9FIu/u4MtbfnXG/Ev8pPXrzj6
        GXRwbrrw==;
Received: from 089144193064.atnat0002.highway.a1.net ([89.144.193.64] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hYbNa-0002Ay-HT; Wed, 05 Jun 2019 19:15:22 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 03/24] xfs: renumber XBF_WRITE_FAIL
Date:   Wed,  5 Jun 2019 21:14:50 +0200
Message-Id: <20190605191511.32695-4-hch@lst.de>
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

Assining a numerical value that is not close to the flags
defined near by is just asking for conflicts later on.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
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

