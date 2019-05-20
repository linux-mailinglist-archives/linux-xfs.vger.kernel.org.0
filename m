Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1297C23D01
	for <lists+linux-xfs@lfdr.de>; Mon, 20 May 2019 18:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391938AbfETQO4 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 May 2019 12:14:56 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:36898 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387964AbfETQO4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 12:14:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ItO2Umbfysc/uaTrPmztUhzzap8vbLF2PIKu/VG38x0=; b=eVH9hlGeFbDUDcZ8gKX5YANjw
        vMR2plxpo/GHmCDCSz2RZzNJELQRQVIkTmJSfAUGby4SuqpG5pWCVp5BWTYX+T/AhOd6ZPIGK8dpx
        tVjm+bPeyqpKomANb1kygBsC9FDwy2r7tvNQhvBCF8ZmnMDTlHgvnNV2E3k+z1XPn1A7we7NiWb2j
        UTGT+yHANRawTm798yz85rqE+YyE/DBgsI+5vNwxiQtUqiG4sZy3MgPegRTy89sF7b0V12Y6lxdrS
        47Lvwm7l4FAkOjtgJgm2KzDailKV9aR1Js4r7W0OIuyOPIcEVgDh1noNHAg/UJDPvT82hNOHsdsJl
        nAqv9JAAg==;
Received: from 089144206147.atnat0015.highway.bob.at ([89.144.206.147] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hSkwB-0005dQ-PU
        for linux-xfs@vger.kernel.org; Mon, 20 May 2019 16:14:56 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 05/17] xfs: don't use REQ_PREFLUSH for split log writes
Date:   Mon, 20 May 2019 18:13:35 +0200
Message-Id: <20190520161347.3044-6-hch@lst.de>
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

If we have to split a log write because it wraps the end of the log we
can't just use REQ_PREFLUSH to flush before the first log write,
as the writes might get reordered somewhere in the I/O stack.  Issue
a manual flush in that case so that the ordering of the two log I/Os
doesn't matter.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index e7c9e1a653a8..1374f5d6c372 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1912,7 +1912,7 @@ xlog_sync(
 	 * synchronously here; for an internal log we can simply use the block
 	 * layer state machine for preflushes.
 	 */
-	if (log->l_mp->m_logdev_targp != log->l_mp->m_ddev_targp)
+	if (log->l_mp->m_logdev_targp != log->l_mp->m_ddev_targp || split)
 		xfs_blkdev_issue_flush(log->l_mp->m_ddev_targp);
 	else
 		bp->b_flags |= XBF_FLUSH;
-- 
2.20.1

