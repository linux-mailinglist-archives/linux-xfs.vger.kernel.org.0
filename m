Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4F601C8A8A
	for <lists+linux-xfs@lfdr.de>; Thu,  7 May 2020 14:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbgEGMUs (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 7 May 2020 08:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725900AbgEGMUs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 08:20:48 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00AF3C05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 05:20:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=MmEOI2S5weh5FiI4+xwEFTrqHcNbCHv9ms7g1tRDyac=; b=sjEC62rR2xsZ2z2JW38w9QnKjb
        jE8B8Uk4i7efTitu+YoyjfaqQfW+SDZgT7hrkQ+NH4C55FASEMEHo0DBSGMGIJ4q8NZjhxnCDQAvO
        A7oimQ48HIehXMFQI4xKsc9x0RZw1uTYsH5+6+tFmqM3TkOvr/UGP1NFJkI5X5B+/bcnPtFbR8V1B
        74SLRSQY3114K8cIa9GptFvvIbeMxt/9l6aWuxH3ObgDuxV3Mt+7IMXnFiQAEjWkP4nSdq0pZ+idQ
        fAaL76Xwt462wO6fkk5megBs28xPvoJYCJmGdG6JMMvHz78HZk92OowBMAtqRgIIJTxVwunabeVIA
        FoNLaSzg==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWfWA-0007m3-4B; Thu, 07 May 2020 12:20:46 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH 46/58] xfs: xfs_dabuf_map should return ENOMEM when map allocation fails
Date:   Thu,  7 May 2020 14:18:39 +0200
Message-Id: <20200507121851.304002-47-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200507121851.304002-1-hch@lst.de>
References: <20200507121851.304002-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

Source kernel commit: faf8ee8476c19b30fd16079ad616b2b0f56eaff4

If the xfs_buf_map array allocation in xfs_dabuf_map fails for whatever
reason, we bail out with error code zero.  This will confuse callers, so
make sure that we return ENOMEM.  Allocation failure should never happen
with the small size of the array, but code defensively anyway.

Fixes: 45feef8f50b94d ("xfs: refactor xfs_dabuf_map")
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_da_btree.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index d785312f..4e909caa 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -2518,8 +2518,10 @@ xfs_dabuf_map(
 	 */
 	if (nirecs > 1) {
 		map = kmem_zalloc(nirecs * sizeof(struct xfs_buf_map), KM_NOFS);
-		if (!map)
+		if (!map) {
+			error = -ENOMEM;
 			goto out_free_irecs;
+		}
 		*mapp = map;
 	}
 
-- 
2.26.2

