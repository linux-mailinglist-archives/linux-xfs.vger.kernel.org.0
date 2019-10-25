Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93E5AE416D
	for <lists+linux-xfs@lfdr.de>; Fri, 25 Oct 2019 04:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389827AbfJYCTA (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 24 Oct 2019 22:19:00 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:37814 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389816AbfJYCTA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Oct 2019 22:19:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=mIaLYT2mvE28e0IH3fXma4U0CHtheUcRd9g7a5tOVWQ=; b=QyGlUpD422isrXRQWNN3Yr6fP
        x/rrPetF6zPF4C8T6ZBRX9xWK1iIVVYVfr+ffaBEc8WWpd5SXPNm2RoeEW9lxt+ZdtBdeNNGmPnyB
        ruz/KmJiF3TAiz6nlCqoJSzUFKb3fNCmA7NdQU66hvHgHy8zqnIQbXVWb7qsL9lqnIDzWyl6gew/T
        V5yiuuOGgEmyODqXE1ab/goHbDb0wdncN2JCbbkmENiB+1dZDA7S1A5jII9Eyce/nNgRH/RbUHhuv
        zhEuOIkPL8021AALcrT7ug5Hivuwu36r7yTdj8m6XHGFVj1e2fnX5WwJRLwSDcM3vL4PzwL7dOl9N
        sR2l3JjDQ==;
Received: from p91006-ipngnfx01marunouchi.tokyo.ocn.ne.jp ([153.156.43.6] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iNpBr-0005Uy-FN
        for linux-xfs@vger.kernel.org; Fri, 25 Oct 2019 02:18:59 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/3] xfs: use xfs_inode_buftarg in xfs_file_dio_aio_write
Date:   Fri, 25 Oct 2019 11:18:51 +0900
Message-Id: <20191025021852.20172-3-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191025021852.20172-1-hch@lst.de>
References: <20191025021852.20172-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_file.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index ee4ebb7904f6..156238d5af19 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -487,8 +487,7 @@ xfs_file_dio_aio_write(
 	int			unaligned_io = 0;
 	int			iolock;
 	size_t			count = iov_iter_count(from);
-	struct xfs_buftarg      *target = XFS_IS_REALTIME_INODE(ip) ?
-					mp->m_rtdev_targp : mp->m_ddev_targp;
+	struct xfs_buftarg      *target = xfs_inode_buftarg(ip);
 
 	/* DIO must be aligned to device logical sector size */
 	if ((iocb->ki_pos | count) & target->bt_logical_sectormask)
-- 
2.20.1

