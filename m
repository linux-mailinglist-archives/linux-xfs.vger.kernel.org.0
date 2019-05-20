Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4389E23CFC
	for <lists+linux-xfs@lfdr.de>; Mon, 20 May 2019 18:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390210AbfETQOq (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 May 2019 12:14:46 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:35640 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387964AbfETQOq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 12:14:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Zkla2PNxwnhw3gJDnCh1W2G8xf86NfHi0GmRTN6iPPE=; b=Zu3NPAu7asArkfx26pA90MjUC
        N6xGro4w6uo/BcKF5wsxM/zxMlpSuf+7jLSNzLQTnY4fPMeAvHAw/zn6DF47zLzNJh6oDG5VX6QPT
        TwPl0xPwAe4MAS/Pw9i84DPBKBinl/i8Nb8HBVJcIHA+CfVJ+8tRQK3GYgfxMNnIZX9j74Zyz7pv6
        ZUl9FWkz7XrIAbnG3yfBhRBun6oVVuytvtVDedsiwMSznxCkzor4Z8YoJG4BNnW/hh8mkISWLYkMU
        8LnpSE7kIjIucck2n8YEXpX4VZDOcUP2q+9SnYey0rNa5dApLVx22bYm5JtqMXnRx90jpqC17L80M
        tuGr0epyg==;
Received: from 089144206147.atnat0015.highway.bob.at ([89.144.206.147] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hSkvz-0005Ku-Jd
        for linux-xfs@vger.kernel.org; Mon, 20 May 2019 16:14:44 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 01/17] xfs: remove the no-op spinlock_destroy stub
Date:   Mon, 20 May 2019 18:13:31 +0200
Message-Id: <20190520161347.3044-2-hch@lst.de>
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_linux.h | 2 --
 fs/xfs/xfs_log.c   | 2 --
 2 files changed, 4 deletions(-)

diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index edbd5a210df2..b78287666309 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -110,8 +110,6 @@ typedef __u32			xfs_nlink_t;
 #define current_restore_flags_nested(sp, f)	\
 		(current->flags = ((current->flags & ~(f)) | (*(sp) & (f))))
 
-#define spinlock_destroy(lock)
-
 #define NBBY		8		/* number of bits per byte */
 
 /*
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 0d6fb374dbe8..242ab5e8aaea 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1551,7 +1551,6 @@ xlog_alloc_log(
 			xfs_buf_free(iclog->ic_bp);
 		kmem_free(iclog);
 	}
-	spinlock_destroy(&log->l_icloglock);
 	xfs_buf_free(log->l_xbuf);
 out_free_log:
 	kmem_free(log);
@@ -1998,7 +1997,6 @@ xlog_dealloc_log(
 		kmem_free(iclog);
 		iclog = next_iclog;
 	}
-	spinlock_destroy(&log->l_icloglock);
 
 	log->l_mp->m_log = NULL;
 	kmem_free(log);
-- 
2.20.1

