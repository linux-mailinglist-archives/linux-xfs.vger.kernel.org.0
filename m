Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91D1F21455
	for <lists+linux-xfs@lfdr.de>; Fri, 17 May 2019 09:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728199AbfEQHcL (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 17 May 2019 03:32:11 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:44032 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727361AbfEQHcL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 May 2019 03:32:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=erRwG5BP/S2IFDPCbeHAUiL22NgF/SI0SYvEVCI6FlE=; b=IOlcGpAVV6RuJuWd/1wWrEHMX
        4jUAPHliHIQR0hctX7IxjZdhDWGUyIau5LwWKxzRFOh/eWWuRsI8Elki0EUOVAGiCLsvEqRb1KL1P
        NIk9az85lK/qhIPpZCy/a1Vagp3wZkKmxDmtnVewcB+s/vk3lQ2Bmf7U9kGa1QdwE214wKAqWyTAo
        pyE9QUsdJeaHeKktJJuiUfdBteJFcpDLmvQAo6HNTs852orQWoj9beAkMOq7Tg3LWlPi6VK2XRk7r
        RShTRcJWKDA+ku6/2Poar5dY59/CvT9kivEmw8eHIcSKZd8KRqa+bDVIKc6QF868J/O1PSxqNwwsU
        Hcjyd3rbw==;
Received: from 089144210233.atnat0019.highway.a1.net ([89.144.210.233] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hRXLe-0000iU-HY
        for linux-xfs@vger.kernel.org; Fri, 17 May 2019 07:32:10 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 01/20] xfs: fix a trivial comment typo in the xfs_trans_committed_bulk
Date:   Fri, 17 May 2019 09:31:00 +0200
Message-Id: <20190517073119.30178-2-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190517073119.30178-1-hch@lst.de>
References: <20190517073119.30178-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_trans.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 912b42f5fe4a..19f91312561a 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -815,7 +815,7 @@ xfs_log_item_batch_insert(
  *
  * If we are called with the aborted flag set, it is because a log write during
  * a CIL checkpoint commit has failed. In this case, all the items in the
- * checkpoint have already gone through iop_commited and iop_unlock, which
+ * checkpoint have already gone through iop_committed and iop_unlock, which
  * means that checkpoint commit abort handling is treated exactly the same
  * as an iclog write error even though we haven't started any IO yet. Hence in
  * this case all we need to do is iop_committed processing, followed by an
-- 
2.20.1

