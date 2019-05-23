Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F359328509
	for <lists+linux-xfs@lfdr.de>; Thu, 23 May 2019 19:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731093AbfEWRiG (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 23 May 2019 13:38:06 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:56036 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731037AbfEWRiG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 May 2019 13:38:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=mGty9SfKV3GiT5xqFeKuNGVQzC8R1e5u2XzT01nfbxY=; b=pnWwEGz129faxKdrFXsjH6+So
        2C+0htfh2bNXq8ERUCPTOvqszO0lUIAMpcFR1tF6bWWvTEpGRDhTY1QkIiB2zddLLU7dyHo06ds9r
        mlrIfONv/UCa3yrZM6E5nfkls8pKxgALncCeMN2Q1Q48Sqk7iOA1BCBrVqrxkD9LEVbgVtbHCDB8F
        ZIXXPOqFyj0d+00wo0xLQ/69pP79za76AmAxwfQl+PrvUJku3bvHONvjWxm12LDKCwVhBEGMQ+aeD
        zFLw16HTfnlTlZhL1FL4QUjvm4Q4xEP2Dj002JfzppmC/HWARkBW4bcJ1gixchpQWx0z7F+Jgc07l
        QZX6fXK0w==;
Received: from 213-225-10-46.nat.highway.a1.net ([213.225.10.46] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hTrfI-0000SG-AE
        for linux-xfs@vger.kernel.org; Thu, 23 May 2019 17:38:06 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 01/20] xfs: remove the no-op spinlock_destroy stub
Date:   Thu, 23 May 2019 19:37:23 +0200
Message-Id: <20190523173742.15551-2-hch@lst.de>
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

