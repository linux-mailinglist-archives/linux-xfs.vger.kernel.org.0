Return-Path: <linux-xfs+bounces-273-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A1F777FE81E
	for <lists+linux-xfs@lfdr.de>; Thu, 30 Nov 2023 05:05:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3E5D5B20C5F
	for <lists+linux-xfs@lfdr.de>; Thu, 30 Nov 2023 04:05:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7363156E7;
	Thu, 30 Nov 2023 04:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="HqEFLVg2"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D32E210EA
	for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2023 20:05:47 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-6c3363a2b93so492767b3a.3
        for <linux-xfs@vger.kernel.org>; Wed, 29 Nov 2023 20:05:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1701317147; x=1701921947; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1ONsjeizIjE5OlaayHFlorAVbCZUs0JfCPupP+En1ic=;
        b=HqEFLVg2G2Y+zfn9p4Z4gs6nj37fo+/kmf39nwa4Cj5TOS0q4Jp4rfQWrBudZzARYF
         tF3IRb9q+438mbMT69Jqo6Nt6w5pNCAhCBlJW+UDJeiMVjiXrnuSWNX++b/NHhMTRtYW
         58ruXgWALCWXaUd0bTW/1CJz73Gg2Xd+c6ZmiNy36g89zU5Q5Z8TwjcElR0FID4u6t8M
         6vXY62UOdlzPKVwFVMIruKS9RvlR3UR55V1rGxDSgowx0+FTg2e4U/ozmqLa9+8ipEr6
         SPDJteF3I2CbjFu3fh/e0wk+3nfz4KuSjk8z8FwMMgJyytFa1mRTCbfYJ4HRyzhH/xOP
         0Wyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701317147; x=1701921947;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1ONsjeizIjE5OlaayHFlorAVbCZUs0JfCPupP+En1ic=;
        b=o0s00MnrY2KXvhzhy3RvC7wqt5p6/CBDwTb+OJ2eOgqKWxasvDHN+pZJx2Jo5qp9K5
         jvjq6ArQD4Ar0J2DmH1vw2mPYFIr63X9E3Uiy3iGrQwVEJne8EDRbdReLy1Z+UrLP6Pv
         lwY9Z5wu9jNzvkNtgXU+Q4/jIqKiwgRYsdmXFprkODL/N1BPIn+HBWJOcJnO1b1tBrcs
         RGsosMUxz9G1LgKf1oaMThrJ+IaAnkEV0Ao1DGrHc7SVe4W+G+aVjKXYAWA5EqLkpEpP
         Dn415EP1nL6+VvVSlkcvBNdZEtiQmx1dEKGmxQrLmYwXX54fAt39sN+qQRPzZFqqSudC
         6QsA==
X-Gm-Message-State: AOJu0YzyBJBVi8wv/De8KbDCRop9t9RvAmEHuwdnJBf34lnmjYE1pBS1
	shTRIie5hXKC6cTR8+OZmlkdtA==
X-Google-Smtp-Source: AGHT+IGENlU2AnU0zafhpFrp1eBhMj0i2EcTlAUrNuqi2YPkll+KdKJHDo4eBv671KSFRb0Hw5Qu7Q==
X-Received: by 2002:a05:6a20:914b:b0:18c:548d:3d23 with SMTP id x11-20020a056a20914b00b0018c548d3d23mr19929964pzc.59.1701317147305;
        Wed, 29 Nov 2023 20:05:47 -0800 (PST)
Received: from localhost.localdomain ([61.213.176.7])
        by smtp.gmail.com with ESMTPSA id u6-20020a170903124600b001d01c970119sm174181plh.275.2023.11.29.20.05.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Nov 2023 20:05:46 -0800 (PST)
From: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: Dave Chinner <dchinner@redhat.com>,
	Allison Henderson <allison.henderson@oracle.com>,
	Zhang Tianci <zhangtianci.1997@bytedance.com>,
	Brian Foster <bfoster@redhat.com>,
	linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	xieyongji@bytedance.com,
	me@jcix.top,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v3 3/3] xfs: extract xfs_da_buf_copy() helper function
Date: Thu, 30 Nov 2023 12:05:16 +0800
Message-Id: <20231130040516.35677-4-zhangjiachen.jaycee@bytedance.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20231130040516.35677-1-zhangjiachen.jaycee@bytedance.com>
References: <20231130040516.35677-1-zhangjiachen.jaycee@bytedance.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zhang Tianci <zhangtianci.1997@bytedance.com>

This patch does not modify logic.

xfs_da_buf_copy() will copy one block from src xfs_buf to
dst xfs_buf, and update the block metadata in dst directly.

Signed-off-by: Zhang Tianci <zhangtianci.1997@bytedance.com>
Suggested-by: Christoph Hellwig <hch@infradead.org>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 12 ++----
 fs/xfs/libxfs/xfs_da_btree.c  | 76 ++++++++++++++---------------------
 fs/xfs/libxfs/xfs_da_btree.h  |  2 +
 3 files changed, 37 insertions(+), 53 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 2580ae47209a..628dcd2d971e 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -1244,14 +1244,10 @@ xfs_attr3_leaf_to_node(
 	if (error)
 		goto out;
 
-	/* copy leaf to new buffer, update identifiers */
-	xfs_trans_buf_set_type(args->trans, bp2, XFS_BLFT_ATTR_LEAF_BUF);
-	bp2->b_ops = bp1->b_ops;
-	memcpy(bp2->b_addr, bp1->b_addr, args->geo->blksize);
-	if (xfs_has_crc(mp)) {
-		struct xfs_da3_blkinfo *hdr3 = bp2->b_addr;
-		hdr3->blkno = cpu_to_be64(xfs_buf_daddr(bp2));
-	}
+	/*
+	 * copy leaf to new buffer and log it.
+	 */
+	xfs_da_buf_copy(bp2, bp1, args->geo->blksize);
 	xfs_trans_log_buf(args->trans, bp2, 0, args->geo->blksize - 1);
 
 	/*
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index f3f987a65bc1..d39d6ad0f97b 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -690,12 +690,6 @@ xfs_da3_root_split(
 		btree = icnodehdr.btree;
 		size = (int)((char *)&btree[icnodehdr.count] - (char *)oldroot);
 		level = icnodehdr.level;
-
-		/*
-		 * we are about to copy oldroot to bp, so set up the type
-		 * of bp while we know exactly what it will be.
-		 */
-		xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DA_NODE_BUF);
 	} else {
 		struct xfs_dir3_icleaf_hdr leafhdr;
 
@@ -707,31 +701,17 @@ xfs_da3_root_split(
 		size = (int)((char *)&leafhdr.ents[leafhdr.count] -
 			(char *)leaf);
 		level = 0;
-
-		/*
-		 * we are about to copy oldroot to bp, so set up the type
-		 * of bp while we know exactly what it will be.
-		 */
-		xfs_trans_buf_set_type(tp, bp, XFS_BLFT_DIR_LEAFN_BUF);
 	}
 
 	/*
-	 * we can copy most of the information in the node from one block to
-	 * another, but for CRC enabled headers we have to make sure that the
-	 * block specific identifiers are kept intact. We update the buffer
-	 * directly for this.
+	 * Copy old root to new buffer and log it.
 	 */
-	memcpy(node, oldroot, size);
-	if (oldroot->hdr.info.magic == cpu_to_be16(XFS_DA3_NODE_MAGIC) ||
-	    oldroot->hdr.info.magic == cpu_to_be16(XFS_DIR3_LEAFN_MAGIC)) {
-		struct xfs_da3_intnode *node3 = (struct xfs_da3_intnode *)node;
-
-		node3->hdr.info.blkno = cpu_to_be64(xfs_buf_daddr(bp));
-	}
+	xfs_da_buf_copy(bp, blk1->bp, size);
 	xfs_trans_log_buf(tp, bp, 0, size - 1);
 
-	bp->b_ops = blk1->bp->b_ops;
-	xfs_trans_buf_copy_type(bp, blk1->bp);
+	/*
+	 * Update blk1 to point to new buffer.
+	 */
 	blk1->bp = bp;
 	blk1->blkno = blkno;
 
@@ -1220,21 +1200,14 @@ xfs_da3_root_join(
 	xfs_da_blkinfo_onlychild_validate(bp->b_addr, oldroothdr.level);
 
 	/*
-	 * This could be copying a leaf back into the root block in the case of
-	 * there only being a single leaf block left in the tree. Hence we have
-	 * to update the b_ops pointer as well to match the buffer type change
-	 * that could occur. For dir3 blocks we also need to update the block
-	 * number in the buffer header.
+	 * Copy child to root buffer and log it.
 	 */
-	memcpy(root_blk->bp->b_addr, bp->b_addr, args->geo->blksize);
-	root_blk->bp->b_ops = bp->b_ops;
-	xfs_trans_buf_copy_type(root_blk->bp, bp);
-	if (oldroothdr.magic == XFS_DA3_NODE_MAGIC) {
-		struct xfs_da3_blkinfo *da3 = root_blk->bp->b_addr;
-		da3->blkno = cpu_to_be64(xfs_buf_daddr(root_blk->bp));
-	}
+	xfs_da_buf_copy(root_blk->bp, bp, args->geo->blksize);
 	xfs_trans_log_buf(args->trans, root_blk->bp, 0,
 			  args->geo->blksize - 1);
+	/*
+	 * Now we could drop the child buffer.
+	 */
 	error = xfs_da_shrink_inode(args, child, bp);
 	return error;
 }
@@ -2252,6 +2225,26 @@ xfs_da_grow_inode(
 	return error;
 }
 
+/*
+ * Copy src directory/xattribute leaf/node buffer to the dst.
+ * If xfs enables crc(IOW, xfs' on-disk format is v5), we have to
+ * make sure that the block specific identifiers are kept intact.
+ */
+void
+xfs_da_buf_copy(
+	struct xfs_buf *dst,
+	struct xfs_buf *src,
+	size_t size)
+{
+	struct xfs_da3_blkinfo *da3 = dst->b_addr;
+
+	memcpy(dst->b_addr, src->b_addr, size);
+	dst->b_ops = src->b_ops;
+	xfs_trans_buf_copy_type(dst, src);
+	if (xfs_has_crc(dst->b_mount))
+		da3->blkno = cpu_to_be64(xfs_buf_daddr(dst));
+}
+
 /*
  * Ick.  We need to always be able to remove a btree block, even
  * if there's no space reservation because the filesystem is full.
@@ -2316,15 +2309,8 @@ xfs_da3_swap_lastblock(
 		return error;
 	/*
 	 * Copy the last block into the dead buffer and log it.
-	 * If xfs enable crc, the node/leaf block records its blkno, we
-	 * must update it.
 	 */
-	memcpy(dead_buf->b_addr, last_buf->b_addr, args->geo->blksize);
-	if (xfs_has_crc(mp)) {
-		struct xfs_da3_blkinfo *da3 = dead_buf->b_addr;
-
-		da3->blkno = cpu_to_be64(xfs_buf_daddr(dead_buf));
-	}
+	xfs_da_buf_copy(dead_buf, last_buf, args->geo->blksize);
 	xfs_trans_log_buf(tp, dead_buf, 0, args->geo->blksize - 1);
 	dead_info = dead_buf->b_addr;
 
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index ffa3df5b2893..706baf36e175 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -219,6 +219,8 @@ int	xfs_da_reada_buf(struct xfs_inode *dp, xfs_dablk_t bno,
 		const struct xfs_buf_ops *ops);
 int	xfs_da_shrink_inode(xfs_da_args_t *args, xfs_dablk_t dead_blkno,
 					  struct xfs_buf *dead_buf);
+void	xfs_da_buf_copy(struct xfs_buf *dst, struct xfs_buf *src,
+			size_t size);
 
 uint xfs_da_hashname(const uint8_t *name_string, int name_length);
 enum xfs_dacmp xfs_da_compname(struct xfs_da_args *args,
-- 
2.20.1


