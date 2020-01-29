Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 755DF14CF11
	for <lists+linux-xfs@lfdr.de>; Wed, 29 Jan 2020 18:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727020AbgA2RDf (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 29 Jan 2020 12:03:35 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:46616 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726847AbgA2RDf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jan 2020 12:03:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=1rGIouOWfJ0k2OvrMCdPkMucPRPBUfqTIZwYXAa+xAo=; b=GKog/2+6iaGH51FIYq8Zbbdvvq
        KcxTWQOzy6abLz6dJ6k70If5X2NCQW4OXibe7gzSGNwYiV77N7431yZQJboXcm6ph7YGMklY0lMvF
        2u9F0ZzFYsTKz7f9eePLB3Vjcp8xgamlPKNybJoB5tw2pXZHpnEEAIklbp2ErPcZL8EsAtN9krLco
        wKQVGwU1Q4tcMEQtKmRBIhiVDMNbceX6NFgytCHOX4hS8Gf+Ffd3Qn0iS8dhmu9a6PgbRJe5VBONy
        bX9mbrKx/hbxfuR3d+CG0zqUSRK35nXWO58qTFxvdtZqITzCxMYub/PQJQabtASQHQcbMiy61thcf
        amDwlZMQ==;
Received: from [2001:4bb8:18c:3335:c19:50e8:dbcf:dcc6] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iwqkY-0006tI-AS; Wed, 29 Jan 2020 17:03:34 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 09/30] xfs: move struct xfs_da_args to xfs_types.h
Date:   Wed, 29 Jan 2020 18:02:48 +0100
Message-Id: <20200129170310.51370-10-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200129170310.51370-1-hch@lst.de>
References: <20200129170310.51370-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

To allow passing a struct xfs_da_args to the high-level attr helpers
it needs to be easily includable by files like xfs_xattr.c.  Move the
struct definition to xfs_types.h to allow for that.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_da_btree.h | 64 ------------------------------------
 fs/xfs/libxfs/xfs_types.h    | 60 +++++++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+), 64 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index 0f4fbb0889ff..dd2f48b8ee07 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -36,70 +36,6 @@ struct xfs_da_geometry {
 	size_t		data_entry_offset;
 };
 
-/*========================================================================
- * Btree searching and modification structure definitions.
- *========================================================================*/
-
-/*
- * Search comparison results
- */
-enum xfs_dacmp {
-	XFS_CMP_DIFFERENT,	/* names are completely different */
-	XFS_CMP_EXACT,		/* names are exactly the same */
-	XFS_CMP_CASE		/* names are same but differ in case */
-};
-
-/*
- * Structure to ease passing around component names.
- */
-typedef struct xfs_da_args {
-	struct xfs_da_geometry *geo;	/* da block geometry */
-	const uint8_t		*name;		/* string (maybe not NULL terminated) */
-	int		namelen;	/* length of string (maybe no NULL) */
-	uint8_t		filetype;	/* filetype of inode for directories */
-	uint8_t		*value;		/* set of bytes (maybe contain NULLs) */
-	int		valuelen;	/* length of value */
-	int		flags;		/* argument flags (eg: ATTR_NOCREATE) */
-	xfs_dahash_t	hashval;	/* hash value of name */
-	xfs_ino_t	inumber;	/* input/output inode number */
-	struct xfs_inode *dp;		/* directory inode to manipulate */
-	struct xfs_trans *trans;	/* current trans (changes over time) */
-	xfs_extlen_t	total;		/* total blocks needed, for 1st bmap */
-	int		whichfork;	/* data or attribute fork */
-	xfs_dablk_t	blkno;		/* blkno of attr leaf of interest */
-	int		index;		/* index of attr of interest in blk */
-	xfs_dablk_t	rmtblkno;	/* remote attr value starting blkno */
-	int		rmtblkcnt;	/* remote attr value block count */
-	int		rmtvaluelen;	/* remote attr value length in bytes */
-	xfs_dablk_t	blkno2;		/* blkno of 2nd attr leaf of interest */
-	int		index2;		/* index of 2nd attr in blk */
-	xfs_dablk_t	rmtblkno2;	/* remote attr value starting blkno */
-	int		rmtblkcnt2;	/* remote attr value block count */
-	int		rmtvaluelen2;	/* remote attr value length in bytes */
-	int		op_flags;	/* operation flags */
-	enum xfs_dacmp	cmpresult;	/* name compare result for lookups */
-} xfs_da_args_t;
-
-/*
- * Operation flags:
- */
-#define XFS_DA_OP_JUSTCHECK	0x0001	/* check for ok with no space */
-#define XFS_DA_OP_RENAME	0x0002	/* this is an atomic rename op */
-#define XFS_DA_OP_ADDNAME	0x0004	/* this is an add operation */
-#define XFS_DA_OP_OKNOENT	0x0008	/* lookup/add op, ENOENT ok, else die */
-#define XFS_DA_OP_CILOOKUP	0x0010	/* lookup to return CI name if found */
-#define XFS_DA_OP_ALLOCVAL	0x0020	/* lookup to alloc buffer if found  */
-#define XFS_DA_OP_INCOMPLETE	0x0040	/* lookup INCOMPLETE attr keys */
-
-#define XFS_DA_OP_FLAGS \
-	{ XFS_DA_OP_JUSTCHECK,	"JUSTCHECK" }, \
-	{ XFS_DA_OP_RENAME,	"RENAME" }, \
-	{ XFS_DA_OP_ADDNAME,	"ADDNAME" }, \
-	{ XFS_DA_OP_OKNOENT,	"OKNOENT" }, \
-	{ XFS_DA_OP_CILOOKUP,	"CILOOKUP" }, \
-	{ XFS_DA_OP_ALLOCVAL,	"ALLOCVAL" }, \
-	{ XFS_DA_OP_INCOMPLETE,	"INCOMPLETE" }
-
 /*
  * Storage for holding state during Btree searches and split/join ops.
  *
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 397d94775440..e2711d119665 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -175,6 +175,66 @@ enum xfs_ag_resv_type {
 	XFS_AG_RESV_RMAPBT,
 };
 
+/*
+ * Dir/attr btree search comparison results.
+ */
+enum xfs_dacmp {
+	XFS_CMP_DIFFERENT,	/* names are completely different */
+	XFS_CMP_EXACT,		/* names are exactly the same */
+	XFS_CMP_CASE		/* names are same but differ in case */
+};
+
+/*
+ * Structure to ease passing around dir/attr component names.
+ */
+typedef struct xfs_da_args {
+	struct xfs_da_geometry *geo;	/* da block geometry */
+	const uint8_t	*name;		/* string (maybe not NULL terminated) */
+	int		namelen;	/* length of string (maybe no NULL) */
+	uint8_t		filetype;	/* filetype of inode for directories */
+	uint8_t		*value;		/* set of bytes (maybe contain NULLs) */
+	int		valuelen;	/* length of value */
+	int		flags;		/* argument flags (eg: ATTR_NOCREATE) */
+	xfs_dahash_t	hashval;	/* hash value of name */
+	xfs_ino_t	inumber;	/* input/output inode number */
+	struct xfs_inode *dp;		/* directory inode to manipulate */
+	struct xfs_trans *trans;	/* current trans (changes over time) */
+	xfs_extlen_t	total;		/* total blocks needed, for 1st bmap */
+	int		whichfork;	/* data or attribute fork */
+	xfs_dablk_t	blkno;		/* blkno of attr leaf of interest */
+	int		index;		/* index of attr of interest in blk */
+	xfs_dablk_t	rmtblkno;	/* remote attr value starting blkno */
+	int		rmtblkcnt;	/* remote attr value block count */
+	int		rmtvaluelen;	/* remote attr value length in bytes */
+	xfs_dablk_t	blkno2;		/* blkno of 2nd attr leaf of interest */
+	int		index2;		/* index of 2nd attr in blk */
+	xfs_dablk_t	rmtblkno2;	/* remote attr value starting blkno */
+	int		rmtblkcnt2;	/* remote attr value block count */
+	int		rmtvaluelen2;	/* remote attr value length in bytes */
+	int		op_flags;	/* operation flags */
+	enum xfs_dacmp	cmpresult;	/* name compare result for lookups */
+} xfs_da_args_t;
+
+/*
+ * Operation flags:
+ */
+#define XFS_DA_OP_JUSTCHECK	0x0001	/* check for ok with no space */
+#define XFS_DA_OP_RENAME	0x0002	/* this is an atomic rename op */
+#define XFS_DA_OP_ADDNAME	0x0004	/* this is an add operation */
+#define XFS_DA_OP_OKNOENT	0x0008	/* lookup/add op, ENOENT ok, else die */
+#define XFS_DA_OP_CILOOKUP	0x0010	/* lookup to return CI name if found */
+#define XFS_DA_OP_ALLOCVAL	0x0020	/* lookup to alloc buffer if found  */
+#define XFS_DA_OP_INCOMPLETE	0x0040	/* lookup INCOMPLETE attr keys */
+
+#define XFS_DA_OP_FLAGS \
+	{ XFS_DA_OP_JUSTCHECK,	"JUSTCHECK" }, \
+	{ XFS_DA_OP_RENAME,	"RENAME" }, \
+	{ XFS_DA_OP_ADDNAME,	"ADDNAME" }, \
+	{ XFS_DA_OP_OKNOENT,	"OKNOENT" }, \
+	{ XFS_DA_OP_CILOOKUP,	"CILOOKUP" }, \
+	{ XFS_DA_OP_ALLOCVAL,	"ALLOCVAL" }, \
+	{ XFS_DA_OP_INCOMPLETE,	"INCOMPLETE" }
+
 /*
  * Type verifier functions
  */
-- 
2.24.1

