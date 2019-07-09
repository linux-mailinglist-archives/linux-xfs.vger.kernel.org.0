Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E47563893
	for <lists+linux-xfs@lfdr.de>; Tue,  9 Jul 2019 17:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbfGIPYD (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 9 Jul 2019 11:24:03 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:60794 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbfGIPYD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jul 2019 11:24:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=odWKYk1U6CJiUZ1AsnvP6OWuFpszJwMf5ubTpp9Kl1c=; b=DrwrlYbTkm+5/K3mWlCoCK0N2
        CL3Gt7tkOiYpK8f2Psz8gpr1hBC5cNWKtkCcFedkq8IJMerOdMHooee+Dkv/Xtx4nBonoG0X5wnJK
        zFyk5Upkv4wjIiZIEClq9iwCLv9qBLbjcWyBsTnNw0PFBh54CzFPXyuVqr9fzBIh/b/kSMcaalP4q
        JSVYBWJZXnJwXBkfqiDuXrULDBpHz7mI16E0JuyFD+ewVJykV9MriMjJZb0Vk0yqCMa6ZQciGK9ai
        O+HVolCi+WcCD8EuhsioRcaLFqT8Ft8VIyCgmPz1wpws2jzN/cKff1tGiX+cD+br0PbL3yXJTGK/g
        tlLwYIqTQ==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hkryM-0001Go-Oc; Tue, 09 Jul 2019 15:24:02 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: chain bios the right way around in xfs_rw_bdev
Date:   Tue,  9 Jul 2019 08:23:52 -0700
Message-Id: <20190709152352.27465-1-hch@lst.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We need to chain the earlier bios to the later ones, so that
submit_bio_wait waits on the bio that all the completions are
dispatched to.

Fixes: 6ad5b3255b9e ("xfs: use bios directly to read and write the log recovery buffers")
Reported-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_bio_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_bio_io.c b/fs/xfs/xfs_bio_io.c
index 757c1d9293eb..e2148f2d5d6b 100644
--- a/fs/xfs/xfs_bio_io.c
+++ b/fs/xfs/xfs_bio_io.c
@@ -43,7 +43,7 @@ xfs_rw_bdev(
 			bio_copy_dev(bio, prev);
 			bio->bi_iter.bi_sector = bio_end_sector(prev);
 			bio->bi_opf = prev->bi_opf;
-			bio_chain(bio, prev);
+			bio_chain(prev, bio);
 
 			submit_bio(prev);
 		}
-- 
2.20.1

