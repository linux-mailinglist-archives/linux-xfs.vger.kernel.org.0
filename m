Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF643336AC
	for <lists+linux-xfs@lfdr.de>; Mon,  3 Jun 2019 19:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728110AbfFCRaE (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 3 Jun 2019 13:30:04 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53578 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727754AbfFCRaE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Jun 2019 13:30:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=/wsOG4/m7YgkHZbsaEo4Vyqyd5TkCJMzJskLZlnfwO0=; b=hBoquFqJwcCqWFpTotXTLRepE/
        0+64idLazO2gMsZXe+908UkWAJtoqZuWtvz+jx683UlXVFcOszGRAGD1vqZpPI0y91M4/YjBnGtF3
        LqlWTHcGEu6yBFvDxiIUbQ7luKE58Eebx0WXBfwnYG16PjHOISw1DlEPYyWtfxeahu4hmGp9jKuiJ
        S9NZDM9LeiCB4avOh/eqxV/MG4AgWJfFBK6CkLMrYuPs8JiN1GYsU2ncrzqzX204cnxLeeloWweI+
        VIOy/VQqVhyPbrssOe8w1KJVoV65KBIqjuoPH1GGtxl7Rg3jtMQAGUkB0At9TVF27KgvAwwZ5E2/w
        t8DzV0/Q==;
Received: from 089144193064.atnat0002.highway.a1.net ([89.144.193.64] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hXqmZ-0002Uo-Iw; Mon, 03 Jun 2019 17:30:03 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>
Subject: [PATCH 06/20] xfs: don't use REQ_PREFLUSH for split log writes
Date:   Mon,  3 Jun 2019 19:29:31 +0200
Message-Id: <20190603172945.13819-7-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190603172945.13819-1-hch@lst.de>
References: <20190603172945.13819-1-hch@lst.de>
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
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 3b82ca8ac9c8..646a190e5730 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1941,7 +1941,7 @@ xlog_sync(
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

