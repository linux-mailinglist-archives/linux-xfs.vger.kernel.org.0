Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9298167FD4
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Feb 2020 15:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728732AbgBUOL5 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 21 Feb 2020 09:11:57 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:59312 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728655AbgBUOL5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 09:11:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=m8HeFaAXizYl31b/ksq1WmZhZLaXYGVVk74nK6Ib3UY=; b=NMFg0MaLFDwaisJUlJb3ppreoh
        BpDrbaYA0ng9v3l8/uVv6VMNKvzxFJM33TJJ9/UaWGu+fFUVJuYz8YQvdpHAbc8znDuxnD7cukWf6
        7rI2DBqDJwJdP4bur4gFvT5KtZmFdsU7cLm7h1v8Hm7DgYADYCB6bJ0XAHbCw1G5hkIUtrQCviz4v
        Rzf9OIaop2eoLD4+tU5DHSPII5fvSGzt1mhZy0sbHCTTSIPrdk2YYZ4ayscCJKxREB6s5qDiuFALg
        MrQpz+c/myqK0bli6OTcj1+KOn/Ery0BVAQd/RWWjkKWjJSlaYFqT9VX1eoufJBlXxreWCWaDpLir
        lTXl8HsQ==;
Received: from [38.126.112.138] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j5925-0000H4-4j; Fri, 21 Feb 2020 14:11:57 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 10/31] xfs: turn xfs_da_args.value into a void pointer
Date:   Fri, 21 Feb 2020 06:11:33 -0800
Message-Id: <20200221141154.476496-11-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200221141154.476496-1-hch@lst.de>
References: <20200221141154.476496-1-hch@lst.de>
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
 fs/xfs/libxfs/xfs_types.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index e2711d119665..634814dd1d10 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -192,7 +192,7 @@ typedef struct xfs_da_args {
 	const uint8_t	*name;		/* string (maybe not NULL terminated) */
 	int		namelen;	/* length of string (maybe no NULL) */
 	uint8_t		filetype;	/* filetype of inode for directories */
-	uint8_t		*value;		/* set of bytes (maybe contain NULLs) */
+	void		*value;		/* set of bytes (maybe contain NULLs) */
 	int		valuelen;	/* length of value */
 	int		flags;		/* argument flags (eg: ATTR_NOCREATE) */
 	xfs_dahash_t	hashval;	/* hash value of name */
-- 
2.24.1

