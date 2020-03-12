Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB19C1832A8
	for <lists+linux-xfs@lfdr.de>; Thu, 12 Mar 2020 15:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727439AbgCLORW (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 12 Mar 2020 10:17:22 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:44520 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727123AbgCLORW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Mar 2020 10:17:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=4m9FLaCArzISyi2qBpyZ7VpxlqiV93ufgBI05+NM4es=; b=NkowLNsnp8TuT3L9znAoQEvdDx
        DLNk7KDoJKoRlv6bO0PROkxoNySTVBhviTDO29c5QDiWA54kkfEvmOpk3gV5g1g9kAKAipQkcI9gz
        3ce7Q4o7r6yLk1C2CJZQUNFiP/HpwNjijclEVNBkOMLl9yvmcRHjJDp8Kdz/pzTK0dU85aOsZq3hZ
        qWkJSSk81wXnY2id7EOsCf3VoLR898PoshTLClvu1RLzBAjc55JFT5MdChyLKgHODvA4ppK6n0IBt
        gK14kh6xO5KuXPwylpkVhUKe6ifOB8bav9rOcFzjULb9cS+QadPwY6yXln8zgPJ5dDrgOpCCcIkHS
        QSPoQE3g==;
Received: from [2001:4bb8:184:5cad:8026:d98c:a056:3e33] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jCOeH-0001v7-QQ
        for linux-xfs@vger.kernel.org; Thu, 12 Mar 2020 14:17:22 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/4] libxfs: turn the xfs_buf_incore stub into an inline function
Date:   Thu, 12 Mar 2020 15:17:12 +0100
Message-Id: <20200312141715.550387-2-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200312141715.550387-1-hch@lst.de>
References: <20200312141715.550387-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Replace the macro with an inline function to avoid compiler warnings with new
backports of kernel code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/libxfs_priv.h | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 5d6dd063..17a0104b 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -369,14 +369,12 @@ roundup_64(uint64_t x, uint32_t y)
 #define XFS_BUF_UNDELAYWRITE(bp)	((bp)->b_flags &= ~LIBXFS_B_DIRTY)
 #define XFS_BUF_SET_BDSTRAT_FUNC(a,b)	((void) 0)
 
-/* avoid gcc warning */
-#define xfs_buf_incore(bt,blkno,len,lockit) ({		\
-	typeof(blkno) __foo = (blkno);			\
-	typeof(len) __bar = (len);			\
-	(blkno) = __foo;				\
-	(len) = __bar; /* no set-but-unused warning */	\
-	NULL;						\
-})
+static inline struct xfs_buf *xfs_buf_incore(struct xfs_buftarg *target,
+		xfs_daddr_t blkno, size_t numblks, xfs_buf_flags_t flags)
+{
+	return NULL;
+}
+
 #define xfs_buf_oneshot(bp)		((void) 0)
 
 #define XBRW_READ			LIBXFS_BREAD
-- 
2.24.1

