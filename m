Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26EDAEA2F1
	for <lists+linux-xfs@lfdr.de>; Wed, 30 Oct 2019 19:04:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727749AbfJ3SEs (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 30 Oct 2019 14:04:48 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:38382 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727715AbfJ3SEs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Oct 2019 14:04:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=FohHpKpqyfXLH3FJL0PWqHmxjHd4ZLD21AlgpJ8k98c=; b=km3xVQurXiFTeH6wEsl5INYHw
        GT2rx4oedl0sGQB+gU5ftoAjzmYBuciHtG49zV4BMOxKL+2luAT4RdQXNQSgQBYZpJGcRwVCNAOU8
        z+jLvEsvZ4GJdkqqCAOmDEKnbtDSjoxynRgZHjcUEky0dD3/IxWfW0YPfJOVExfPVZs3SVm9MjvBn
        ZJsvYFnCpQQ5Kjs4n8EAZIhNUn+frMstCIRt/xjUBE7fsiQCMknmtxRyaHKsIx9+uIsQmmb5BvKLB
        QkT9d+wjcaKxWBclMNUKKokR8t6WXphmGgSJ/LhHvq9cFXS6UhRPTd8/Jbf9KpmH/btvkyDgFSpOK
        mxTz61YWQ==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iPsKu-0005fF-Es
        for linux-xfs@vger.kernel.org; Wed, 30 Oct 2019 18:04:48 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/9] xfs: slightly tweak an assert in xfs_fs_map_blocks
Date:   Wed, 30 Oct 2019 11:04:14 -0700
Message-Id: <20191030180419.13045-5-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030180419.13045-1-hch@lst.de>
References: <20191030180419.13045-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We should never see delalloc blocks for a pNFS layout, write or not.
Adjust the assert to check for that.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_pnfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index c637f0192976..3634ffff3b07 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -148,11 +148,11 @@ xfs_fs_map_blocks(
 	if (error)
 		goto out_unlock;
 
+	ASSERT(!nimaps || imap.br_startblock != DELAYSTARTBLOCK);
+
 	if (write) {
 		enum xfs_prealloc_flags	flags = 0;
 
-		ASSERT(imap.br_startblock != DELAYSTARTBLOCK);
-
 		if (!nimaps || imap.br_startblock == HOLESTARTBLOCK) {
 			/*
 			 * xfs_iomap_write_direct() expects to take ownership of
-- 
2.20.1

