Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5961A34DD
	for <lists+linux-xfs@lfdr.de>; Fri, 30 Aug 2019 12:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727417AbfH3KWb (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Aug 2019 06:22:31 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:60204 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727170AbfH3KWa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 06:22:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=zHgky+w/fhZ6xZZ95EZJ6DeN26pTgMkWDHq025jCYjQ=; b=r+EWr8ItVK/kg/AeDRDmG9Y1i
        XuCGnB6a1ffvDT/7JaIbsQcVl/d7x2J8c2aqjsSq//A7CHBNlu49JVwDR2yZcb9vUbBbiXkt9rEnp
        sigD0RKHclEuSdZ/VhhFZXYlWJ6VZZsdIGN4m1MBQerMLK5bHX+yYdj80IwJ1ywsOuNbvK+0mZiwd
        YJAyP0kd/Vh3gPtzLc43QPuKqjXzf2zpbo4GIY8nU4E6OYjJFWjINCRJ1V8FFp8s5Pyn5CPl6ufrw
        siaLmtr+OMTDnIT1jTjmNNNkLiEL1tQAnIR7epXvrYUlarDsLgpPUiGk19BCN/4E7BP0Dn3MymQSd
        o20DsU0Bg==;
Received: from [2001:4bb8:180:3f4c:863:2ead:e9d4:da9f] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1i3e33-0003Ih-Uh; Fri, 30 Aug 2019 10:22:30 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Murphy Zhou <jencce.kernel@gmail.com>
Subject: [PATCH] xfsprogs: provide a few compatibility typedefs
Date:   Fri, 30 Aug 2019 12:22:27 +0200
Message-Id: <20190830102227.20932-1-hch@lst.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Add back four typedefs that allow xfsdump to compile against the
headers from the latests xfsprogs.

Reported-by: Murphy Zhou <jencce.kernel@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/xfs.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/xfs.h b/include/xfs.h
index f2f675df..9ae067dc 100644
--- a/include/xfs.h
+++ b/include/xfs.h
@@ -37,4 +37,13 @@ extern int xfs_assert_largefile[sizeof(off_t)-8];
 #include <xfs/xfs_types.h>
 #include <xfs/xfs_fs.h>
 
+/*
+ * Backards compatibility for users of this header, now that the kernel
+ * removed these typedefs from xfs_fs.h.
+ */
+typedef struct xfs_bstat xfs_bstat_t;
+typedef struct xfs_fsop_bulkreq xfs_fsop_bulkreq_t;
+typedef struct xfs_fsop_geom_v1 xfs_fsop
+typedef struct xfs_inogrp xfs_inogrp_t;
+
 #endif	/* __XFS_H__ */
-- 
2.20.1

