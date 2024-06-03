Return-Path: <linux-xfs+bounces-8953-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D84218D89BB
	for <lists+linux-xfs@lfdr.de>; Mon,  3 Jun 2024 21:16:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3D169B26A3C
	for <lists+linux-xfs@lfdr.de>; Mon,  3 Jun 2024 19:16:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC54613C8E3;
	Mon,  3 Jun 2024 19:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jDz/Juv+"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E63135A46
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717442006; cv=none; b=Fzi8Eu8ec7KsietMKqoFzKby6HZwjX1eIL8Ed90z8L2y3J56RAZSxGFc4ZieGUHJFyP4jJKBmUgv8KyUaLMlBSGE21lIK+0+JsfcIu/7cgL1LGXHOXDdPXdMCnIC45UHvJs7AhunT6SqY9MZStRu5HQVi+yDTV+JuK+RSwXRdsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717442006; c=relaxed/simple;
	bh=h4ABS1sKue61G63JkenEBGySsPVx7c1P7iwaKI5GosQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Axp8AiezRzP+XNuwVrfk37VVWRSDxP+zjoWelx7B7OAFwHemvCbF9jOPahFKzx02Y7lyloXTkO4rdFDS4tACB1H3jw68iC+F4SUSlaDz+J9HStKcUof5JKuG9j7GzBFepT6OYh0P6FRAyc+eiYaD7KJkD/Vzs153WE2/AS/AkMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jDz/Juv+; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29372C2BD10;
	Mon,  3 Jun 2024 19:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717442006;
	bh=h4ABS1sKue61G63JkenEBGySsPVx7c1P7iwaKI5GosQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jDz/Juv+hMgRSaQiSLt06kUQOxohA3Ko1voKe0A+0eFXGxgvuGspVrXCYSxWoi2Wr
	 pUa2B+qi0PqgEatxzyNSrIeY4AYqv9RMCSQ9mcyFsjW+HXRBjDsW2jlrXop+2elcQ9
	 OqnOpzqbpK/PWrRdoQWilN2jc9z9hsPNjbS2Gv1Tn8IVn98ji6B2rBMor6FV+wsO8G
	 0RjaltI2tCml8xBhfp0hM1dKwrvAfcAn17PLWOunrbG1gkjYFhKjbMnbZBTjd6Krji
	 Hr9tLLhDqf9oIBrZkqTZwtKMNvZicLx50I4zxOvHaoT/ByaqGHV2kcZX+ojQu8a5C8
	 4f95b9x1tKp6A==
Date: Mon, 03 Jun 2024 12:13:25 -0700
Subject: [PATCH 082/111] xfs: consolidate btree block verification
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cmaiolino@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171744040602.1443973.5407520525597991487.stgit@frogsfrogsfrogs>
In-Reply-To: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
References: <171744039240.1443973.5959953049110025783.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 4ce0c711d9ab3a435bc605cd2f36a3f6b4e12c05

Add a __xfs_btree_check_block helper that can be called by the scrub code
to validate a btree block of any form, and move the duplicate error
handling code from xfs_btree_check_sblock and xfs_btree_check_lblock into
xfs_btree_check_block and thus remove these two helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 libxfs/xfs_btree.c |   72 ++++++++++++++++++++++------------------------------
 libxfs/xfs_btree.h |    9 +------
 2 files changed, 31 insertions(+), 50 deletions(-)


diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 2f5848b9d..fae121ace 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -95,7 +95,7 @@ xfs_btree_check_sblock_siblings(
  * Check a long btree block header.  Return the address of the failing check,
  * or NULL if everything is ok.
  */
-xfs_failaddr_t
+static xfs_failaddr_t
 __xfs_btree_check_lblock(
 	struct xfs_btree_cur	*cur,
 	struct xfs_btree_block	*block,
@@ -144,33 +144,11 @@ __xfs_btree_check_lblock(
 	return fa;
 }
 
-/* Check a long btree block header. */
-static int
-xfs_btree_check_lblock(
-	struct xfs_btree_cur	*cur,
-	struct xfs_btree_block	*block,
-	int			level,
-	struct xfs_buf		*bp)
-{
-	struct xfs_mount	*mp = cur->bc_mp;
-	xfs_failaddr_t		fa;
-
-	fa = __xfs_btree_check_lblock(cur, block, level, bp);
-	if (XFS_IS_CORRUPT(mp, fa != NULL) ||
-	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BTREE_CHECK_LBLOCK)) {
-		if (bp)
-			trace_xfs_btree_corrupt(bp, _RET_IP_);
-		xfs_btree_mark_sick(cur);
-		return -EFSCORRUPTED;
-	}
-	return 0;
-}
-
 /*
  * Check a short btree block header.  Return the address of the failing check,
  * or NULL if everything is ok.
  */
-xfs_failaddr_t
+static xfs_failaddr_t
 __xfs_btree_check_sblock(
 	struct xfs_btree_cur	*cur,
 	struct xfs_btree_block	*block,
@@ -206,26 +184,28 @@ __xfs_btree_check_sblock(
 	return fa;
 }
 
-/* Check a short btree block header. */
-STATIC int
-xfs_btree_check_sblock(
+/*
+ * Internal btree block check.
+ *
+ * Return NULL if the block is ok or the address of the failed check otherwise.
+ */
+xfs_failaddr_t
+__xfs_btree_check_block(
 	struct xfs_btree_cur	*cur,
 	struct xfs_btree_block	*block,
 	int			level,
 	struct xfs_buf		*bp)
 {
-	struct xfs_mount	*mp = cur->bc_mp;
-	xfs_failaddr_t		fa;
+	if (cur->bc_ops->ptr_len == XFS_BTREE_SHORT_PTR_LEN)
+		return __xfs_btree_check_sblock(cur, block, level, bp);
+	return __xfs_btree_check_lblock(cur, block, level, bp);
+}
 
-	fa = __xfs_btree_check_sblock(cur, block, level, bp);
-	if (XFS_IS_CORRUPT(mp, fa != NULL) ||
-	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BTREE_CHECK_SBLOCK)) {
-		if (bp)
-			trace_xfs_btree_corrupt(bp, _RET_IP_);
-		xfs_btree_mark_sick(cur);
-		return -EFSCORRUPTED;
-	}
-	return 0;
+static inline unsigned int xfs_btree_block_errtag(struct xfs_btree_cur *cur)
+{
+	if (cur->bc_ops->ptr_len == XFS_BTREE_SHORT_PTR_LEN)
+		return XFS_ERRTAG_BTREE_CHECK_SBLOCK;
+	return XFS_ERRTAG_BTREE_CHECK_LBLOCK;
 }
 
 /*
@@ -238,10 +218,18 @@ xfs_btree_check_block(
 	int			level,	/* level of the btree block */
 	struct xfs_buf		*bp)	/* buffer containing block, if any */
 {
-	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN)
-		return xfs_btree_check_lblock(cur, block, level, bp);
-	else
-		return xfs_btree_check_sblock(cur, block, level, bp);
+	struct xfs_mount	*mp = cur->bc_mp;
+	xfs_failaddr_t		fa;
+
+	fa = __xfs_btree_check_block(cur, block, level, bp);
+	if (XFS_IS_CORRUPT(mp, fa != NULL) ||
+	    XFS_TEST_ERROR(false, mp, xfs_btree_block_errtag(cur))) {
+		if (bp)
+			trace_xfs_btree_corrupt(bp, _RET_IP_);
+		xfs_btree_mark_sick(cur);
+		return -EFSCORRUPTED;
+	}
+	return 0;
 }
 
 int
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index ca4a305eb..d3afa6209 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -334,15 +334,8 @@ xfs_btree_cur_sizeof(unsigned int nlevels)
  */
 #define	XFS_BUF_TO_BLOCK(bp)	((struct xfs_btree_block *)((bp)->b_addr))
 
-/*
- * Internal long and short btree block checks.  They return NULL if the
- * block is ok or the address of the failed check otherwise.
- */
-xfs_failaddr_t __xfs_btree_check_lblock(struct xfs_btree_cur *cur,
+xfs_failaddr_t __xfs_btree_check_block(struct xfs_btree_cur *cur,
 		struct xfs_btree_block *block, int level, struct xfs_buf *bp);
-xfs_failaddr_t __xfs_btree_check_sblock(struct xfs_btree_cur *cur,
-		struct xfs_btree_block *block, int level, struct xfs_buf *bp);
-
 int __xfs_btree_check_ptr(struct xfs_btree_cur *cur,
 		const union xfs_btree_ptr *ptr, int index, int level);
 


