Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89AFD3D071
	for <lists+linux-xfs@lfdr.de>; Tue, 11 Jun 2019 17:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404461AbfFKPK0 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 11 Jun 2019 11:10:26 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:44706 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404429AbfFKPK0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jun 2019 11:10:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=CivRGk2IJQ+CG/Ap3jP7tA22KCO2fUTPLtqqWiWXwyk=; b=ONSzOX9UY77SC0oZwpB8hSjQVG
        GNFJGpNEgFkPRtmHHPEkOYSkMLgZIYlr6zbUwgdjKyrFwGLddrH/IEpVvogXZzKZOocnXQRnsQVpU
        UhuL550U4dylS4E10knInUKpHHlGUPs9hLtq4R2IXV7j8q2NxjnUdmgLv/SY8qCS+b9LBcATbzJeC
        2JRFVqNDlPi4S1O86GoqOAvXUXFj0qaNVZlBmcN8JofKXoJy3S2+H1GVGasutfp7tK3FxWXuUtX6K
        o5rrBORlT0cRVfnRG0QvMsEjLz6oEqp8cPc7GIgCBdkuLs/BVKySFcgsjeawlFZtQpHiMiUT60eum
        5pac5R2g==;
Received: from mpp-cp1-natpool-1-037.ethz.ch ([82.130.71.37] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1haiPi-0000nC-Kt; Tue, 11 Jun 2019 15:10:20 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>
Cc:     David Gibson <david@gibson.dropbear.id.au>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-block@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH 1/5] block: fix gap checking in __bio_add_pc_page
Date:   Tue, 11 Jun 2019 17:10:03 +0200
Message-Id: <20190611151007.13625-2-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190611151007.13625-1-hch@lst.de>
References: <20190611151007.13625-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

If we can add more data into an existing segment we do not create a gap
per definition, so move the check for a gap after the attempt to merge
into the segment.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 683cbb40f051..6db39699aab9 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -722,18 +722,18 @@ static int __bio_add_pc_page(struct request_queue *q, struct bio *bio,
 			goto done;
 		}
 
+		if (page_is_mergeable(bvec, page, len, offset, false) &&
+		    can_add_page_to_seg(q, bvec, page, len, offset)) {
+			bvec->bv_len += len;
+			goto done;
+		}
+
 		/*
 		 * If the queue doesn't support SG gaps and adding this
 		 * offset would create a gap, disallow it.
 		 */
 		if (bvec_gap_to_prev(q, bvec, offset))
 			return 0;
-
-		if (page_is_mergeable(bvec, page, len, offset, false) &&
-		    can_add_page_to_seg(q, bvec, page, len, offset)) {
-			bvec->bv_len += len;
-			goto done;
-		}
 	}
 
 	if (bio_full(bio))
-- 
2.20.1

