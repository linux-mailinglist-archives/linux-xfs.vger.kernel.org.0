Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBCD584AB
	for <lists+linux-xfs@lfdr.de>; Thu, 27 Jun 2019 16:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbfF0Ojx (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 27 Jun 2019 10:39:53 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:46288 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726431AbfF0Ojx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jun 2019 10:39:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=qPeMy5f5txM1yAe30PZH0SPRKG4ohg67v2A9SaBslCA=; b=H6YjyWY5gG+jJm8JOvVTsXyMu
        5aGThhZb1d4c3QrkrZEB38oljBxgc++DqCuP0VzuxlhfOn94IX8RdNSo/q6oGIqXJvZpcWIlEf65J
        i4YjMMnQtVO+yv0V7spIc8JJbdPn/F/FVRslKk94oQN8/mBOVS31kWiECLX8zShxShu3nbFF1uZFF
        vpy+kWDEVEQ5dFedgB6WfIc1uNGjVT6G8+2gIQeIGYK4mleiuFZU9TDJe+0sjOw55ANlnXSYEkaId
        Gt4hCdqGC1ZoAsKCNIHC81BXfzaRNoLzr2YO7yN1JFfKld/JI1umGFCgVkc33xSrxjhsffGkupWym
        sS0X+jU0A==;
Received: from 089144214055.atnat0023.highway.a1.net ([89.144.214.55] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hgVZ2-0007ZU-OJ; Thu, 27 Jun 2019 14:39:53 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     syzbot+b75afdbe271a0d7ac4f6@syzkaller.appspotmail.com
Subject: [PATCH] xfs: fix iclog allocation size
Date:   Thu, 27 Jun 2019 16:39:50 +0200
Message-Id: <20190627143950.19558-1-hch@lst.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Properly allocate the space for the bio_vecs instead of just one byte
per bio_vec.

Fixes: 991fc1d2e65e ("xfs: use bios directly to write log buffers")
Reported-by: syzbot+b75afdbe271a0d7ac4f6@syzkaller.appspotmail.com
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 0f849b4095d6..e230f3c18ceb 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1415,7 +1415,8 @@ xlog_alloc_log(
 	 */
 	ASSERT(log->l_iclog_size >= 4096);
 	for (i = 0; i < log->l_iclog_bufs; i++) {
-		size_t bvec_size = howmany(log->l_iclog_size, PAGE_SIZE);
+		size_t bvec_size = howmany(log->l_iclog_size, PAGE_SIZE) *
+				sizeof(struct bio_vec);
 
 		iclog = kmem_zalloc(sizeof(*iclog) + bvec_size, KM_MAYFAIL);
 		if (!iclog)
-- 
2.20.1

