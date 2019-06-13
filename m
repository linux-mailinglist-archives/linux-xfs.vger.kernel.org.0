Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1D844A24
	for <lists+linux-xfs@lfdr.de>; Thu, 13 Jun 2019 20:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbfFMSDG (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 13 Jun 2019 14:03:06 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:57402 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbfFMSDF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jun 2019 14:03:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=RjtsCwDO8xYhDrSUTmu8b9wGdlCg525TA8RJ3wccIsg=; b=pfRaqfsCI4ArHYC8CPfMi8tRkk
        aIVkSDKDFmdbUuKEjNhXcNoyD4H6HmfSIO1CUHVLedjONSBn1rZNwZyThYfWo6Viq/mhxbZAviYVt
        UtbeXVtNZpqFqiJnIoW6UOZ9JcgeHw54MiGKmoQCi1v9n9rZSEYcZ05QP7uQIk1n1M7QRiULMR7cN
        ecC0Vh+RfFOnaIQdO/Up07yiYCgshZM39PLCYC9kuOBB/tVS7NT/eUsaKAfK9AzsCgTdTAwYWnisM
        EgfsNIayC0OtxW/j8COta/XA/iQiW5bI/0PPuSvZ4mgcaelzm09IAOncNyA+jo6vgwWfG84/t1VyB
        MY+toAtA==;
Received: from [213.208.157.35] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hbU41-0002fO-AN; Thu, 13 Jun 2019 18:03:05 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Brian Foster <bfoster@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 01/20] xfs: fix a trivial comment typo in xfs_trans_committed_bulk
Date:   Thu, 13 Jun 2019 20:02:41 +0200
Message-Id: <20190613180300.30447-2-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190613180300.30447-1-hch@lst.de>
References: <20190613180300.30447-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
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

