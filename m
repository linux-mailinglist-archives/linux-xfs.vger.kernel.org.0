Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7F116F2FD
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Feb 2020 00:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729331AbgBYXKU (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Feb 2020 18:10:20 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:53292 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729258AbgBYXKT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 18:10:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=1I77KXvPrbUmdUlQUy/72HHIH8GfFwzYZvksLLwxw8s=; b=tjsanLJ0Icb96MqYW02wzrReUr
        CayoVct7qdqtdJkdB0VHKicYLcSQssdrUjlYvbjjivrOy2SX9m/p0ekXqsXoJcq+LahCRUKTW5VaL
        7KKx3DsbnIdFcctsssCylYvtsM9eRZ3PzaD2CmaO/uwqDBe3pfUV1OcpeYITG8t3tKZEaAet0izQm
        u4Hm6z8NtZj5dc1MvXWnR7BHhN6xe06iQmxLg60n81UQGj1B2Rj3sctn0WIUBumhNOVZ/sdmr3poV
        Gw1yiO62f5kM7CvcjmNJOxOXm8qKNeo+cfGhrKbSe1AShF0Q35E9ZCAftkVO6aShfUKg1ZgGMFYD0
        XAWBQogw==;
Received: from [4.28.11.157] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6jLH-00037c-I1; Tue, 25 Feb 2020 23:10:19 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 09/30] xfs: turn xfs_da_args.value into a void pointer
Date:   Tue, 25 Feb 2020 15:09:51 -0800
Message-Id: <20200225231012.735245-10-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200225231012.735245-1-hch@lst.de>
References: <20200225231012.735245-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The xattr values are blobs and should not be typed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_da_btree.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index 0f4fbb0889ff..0967d1bd3ceb 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -57,7 +57,7 @@ typedef struct xfs_da_args {
 	const uint8_t		*name;		/* string (maybe not NULL terminated) */
 	int		namelen;	/* length of string (maybe no NULL) */
 	uint8_t		filetype;	/* filetype of inode for directories */
-	uint8_t		*value;		/* set of bytes (maybe contain NULLs) */
+	void		*value;		/* set of bytes (maybe contain NULLs) */
 	int		valuelen;	/* length of value */
 	int		flags;		/* argument flags (eg: ATTR_NOCREATE) */
 	xfs_dahash_t	hashval;	/* hash value of name */
-- 
2.24.1

