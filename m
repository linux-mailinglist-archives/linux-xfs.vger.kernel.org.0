Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2003336463
	for <lists+linux-xfs@lfdr.de>; Wed,  5 Jun 2019 21:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbfFETPR (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 5 Jun 2019 15:15:17 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:59546 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726280AbfFETPR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Jun 2019 15:15:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=riah3tn+nTOoZ8u1HZI9u2sKmvZ2NvAfDcRk116aCE0=; b=NWYVeDTtnF7mOOvbFyIKcJRRoq
        dYwIUEVKDj7wzUV7JFiOg+mRZruQXtLOxccRxNbA8SDBxnXXRundISYXRSyRC6LlKIWSiNNWbHEyY
        e53ZZhBy8Vu3GlAy+t6TRpvg1RqAOt7wG+X+JSOIXZ0coj1m/mkWXWeSBW3qbRIa+9GBpe+UEAlPx
        pzMbOHhNwEByOlYbmZt1OHy9kYq0QAsFGvaVgZ2BhRai2QCF0qzF5LlqF/DEPODN1mMir2pg/BxLf
        POaZwqc79oVLLtlNiha7RepZiKTos6OxE8Cq+q0ZcaZd1jUJAmfxr52qjMVrXVsxjpDsshvpO4z/b
        3RNnL6Pg==;
Received: from 089144193064.atnat0002.highway.a1.net ([89.144.193.64] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hYbNU-00029C-AX; Wed, 05 Jun 2019 19:15:17 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 01/24] xfs: remove the no-op spinlock_destroy stub
Date:   Wed,  5 Jun 2019 21:14:48 +0200
Message-Id: <20190605191511.32695-2-hch@lst.de>
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
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
index 457ced3ee3e1..a2048e46be4e 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1580,7 +1580,6 @@ xlog_alloc_log(
 			xfs_buf_free(iclog->ic_bp);
 		kmem_free(iclog);
 	}
-	spinlock_destroy(&log->l_icloglock);
 	xfs_buf_free(log->l_xbuf);
 out_free_log:
 	kmem_free(log);
@@ -2027,7 +2026,6 @@ xlog_dealloc_log(
 		kmem_free(iclog);
 		iclog = next_iclog;
 	}
-	spinlock_destroy(&log->l_icloglock);
 
 	log->l_mp->m_log = NULL;
 	kmem_free(log);
-- 
2.20.1

