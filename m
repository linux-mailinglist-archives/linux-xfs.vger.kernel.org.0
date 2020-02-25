Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE2A16EF62
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Feb 2020 20:49:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728443AbgBYTtr (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Feb 2020 14:49:47 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:33642 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729238AbgBYTtr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 14:49:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=HAXvMDQU3TN68Ba15rDR3f31NuZKIhqeopocktkehpg=; b=SX5t9fjqqP8u8XbiwtL+Yl/a64
        58Z7LhYTU8GVZE9cJ5ZD6Lt0koyY6as22hc0ej5exaNneTq42JOMzwBRebzxj5hZB4GWk6txCfbCc
        /n+wDROh11uXuFlleNashytZugrjCKXmJr3F970qgWvJCCIJGAQhInAL3L5L5pd8+I8G0lOXnvmch
        HfsxMKim5L+BYwJAWLpm+eCtZnQd7vQpaPQaWeVCG/OsCY+fUGE1QAF80QzoVIXAXjngYDf7PaDmM
        1L296QttsoD2B1tHejCSqwBc+0beFmY5P5GP10o0ARGNhl171jmTL4qK2t+C4cJsfHHFB4agR+/T2
        McCVkTVQ==;
Received: from [4.28.11.157] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6gDD-00061k-86; Tue, 25 Feb 2020 19:49:47 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 02/30] xfs: remove the ATTR_INCOMPLETE flag
Date:   Tue, 25 Feb 2020 11:49:17 -0800
Message-Id: <20200225194945.720496-3-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200225194945.720496-1-hch@lst.de>
References: <20200225194945.720496-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Replace the ATTR_INCOMPLETE flag with a new boolean field in struct
xfs_attr_list_context.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.h | 5 ++---
 fs/xfs/scrub/attr.c      | 2 +-
 fs/xfs/xfs_attr_list.c   | 8 ++------
 3 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 4243b2272642..71bcf1298e4c 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -36,11 +36,10 @@ struct xfs_attr_list_context;
 #define ATTR_KERNOTIME	0x1000	/* [kernel] don't update inode timestamps */
 #define ATTR_KERNOVAL	0x2000	/* [kernel] get attr size only, not value */
 
-#define ATTR_INCOMPLETE	0x4000	/* [kernel] return INCOMPLETE attr keys */
 #define ATTR_ALLOC	0x8000	/* [kernel] allocate xattr buffer on demand */
 
 #define ATTR_KERNEL_FLAGS \
-	(ATTR_KERNOTIME | ATTR_KERNOVAL | ATTR_INCOMPLETE | ATTR_ALLOC)
+	(ATTR_KERNOTIME | ATTR_KERNOVAL | ATTR_ALLOC)
 
 #define XFS_ATTR_FLAGS \
 	{ ATTR_DONTFOLLOW, 	"DONTFOLLOW" }, \
@@ -51,7 +50,6 @@ struct xfs_attr_list_context;
 	{ ATTR_REPLACE,		"REPLACE" }, \
 	{ ATTR_KERNOTIME,	"KERNOTIME" }, \
 	{ ATTR_KERNOVAL,	"KERNOVAL" }, \
-	{ ATTR_INCOMPLETE,	"INCOMPLETE" }, \
 	{ ATTR_ALLOC,		"ALLOC" }
 
 /*
@@ -123,6 +121,7 @@ typedef struct xfs_attr_list_context {
 	 * error values to the xfs_attr_list caller.
 	 */
 	int				seen_enough;
+	bool				allow_incomplete;
 
 	ssize_t				count;		/* num used entries */
 	int				dupcnt;		/* count dup hashvals seen */
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index d9f0dd444b80..d804558cdbca 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -497,7 +497,7 @@ xchk_xattr(
 	sx.context.resynch = 1;
 	sx.context.put_listent = xchk_xattr_listent;
 	sx.context.tp = sc->tp;
-	sx.context.flags = ATTR_INCOMPLETE;
+	sx.context.allow_incomplete = true;
 	sx.sc = sc;
 
 	/*
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index d37743bdf274..f7c4f6b9749a 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -452,8 +452,8 @@ xfs_attr3_leaf_list_int(
 		}
 
 		if ((entry->flags & XFS_ATTR_INCOMPLETE) &&
-		    !(context->flags & ATTR_INCOMPLETE))
-			continue;		/* skip incomplete entries */
+		    !context->allow_incomplete)
+			continue;
 
 		if (entry->flags & XFS_ATTR_LOCAL) {
 			xfs_attr_leaf_name_local_t *name_loc;
@@ -632,10 +632,6 @@ xfs_attr_list(
 	    (cursor->hashval || cursor->blkno || cursor->offset))
 		return -EINVAL;
 
-	/* Only internal consumers can retrieve incomplete attrs. */
-	if (flags & ATTR_INCOMPLETE)
-		return -EINVAL;
-
 	/*
 	 * Check for a properly aligned buffer.
 	 */
-- 
2.24.1

