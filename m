Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C51A5711CA9
	for <lists+linux-xfs@lfdr.de>; Fri, 26 May 2023 03:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232288AbjEZBc3 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 May 2023 21:32:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235395AbjEZBc3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:32:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCD46189
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:32:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53F9964C30
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:32:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6EC8C433D2;
        Fri, 26 May 2023 01:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685064746;
        bh=F9esMWRjAqvAWpGDzVCb5FzUzCneVBx+q6Y9zjhXf28=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=fBIn64lSgBPBUQnzpkPoZy74qLsxYAyO5qYD+xlN20MUEQSBqwao5L1NlqEGws9SX
         Nqi7U4oq5y69gfx2ygE1Vhbx90fk451nlJaWA80o7Pgvmk40qP5z8Gxp/BBT9VxEkO
         eMC5JK8bjYVN2ET0ybGdUoy8Y1IKxjIvZ6RnDLfhkf6GjiLoutGocphh8Am2RJV+SA
         h22C4MpKNQCEvRUZvcBizO+7tFoDsNX/lV5xT52j5izxD3JyFlYDwfXQV5IG0pre2Q
         YaLc/MGKU2AhxloSnjZX+DkuhcPuc4bSWmCKfvTmpiNhbFmd8TCvkYpFsRmwBawbWR
         QZXTaedPwVWHQ==
Date:   Thu, 25 May 2023 18:32:26 -0700
Subject: [PATCH 8/9] xfs: validate explicit directory block buffer owners
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506066494.3735378.14364965040412265879.stgit@frogsfrogsfrogs>
In-Reply-To: <168506066363.3735378.3534676169269107254.stgit@frogsfrogsfrogs>
References: <168506066363.3735378.3534676169269107254.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Port the existing directory block header checking function to accept an
owner number instead of an xfs_inode, then update the callsites to use
xfs_da_args.owner when possible.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_dir2.h       |    1 +
 fs/xfs/libxfs/xfs_dir2_block.c |   22 ++++++++++++++--------
 fs/xfs/libxfs/xfs_dir2_priv.h  |    2 +-
 fs/xfs/libxfs/xfs_swapext.c    |    2 +-
 fs/xfs/scrub/dir.c             |    2 +-
 fs/xfs/scrub/readdir.c         |    2 +-
 fs/xfs/xfs_dir2_readdir.c      |    2 +-
 7 files changed, 20 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 537596b9de4a..f99788a1f3e6 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -100,6 +100,7 @@ extern int xfs_dir_ino_validate(struct xfs_mount *mp, xfs_ino_t ino);
 
 xfs_failaddr_t xfs_dir3_leaf_header_check(struct xfs_buf *bp, xfs_ino_t owner);
 xfs_failaddr_t xfs_dir3_data_header_check(struct xfs_buf *bp, xfs_ino_t owner);
+xfs_failaddr_t xfs_dir3_block_header_check(struct xfs_buf *bp, xfs_ino_t owner);
 
 extern const struct xfs_buf_ops xfs_dir3_block_buf_ops;
 extern const struct xfs_buf_ops xfs_dir3_leafn_buf_ops;
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 184341bb1f6a..30eef4d9d866 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -115,18 +115,23 @@ const struct xfs_buf_ops xfs_dir3_block_buf_ops = {
 	.verify_struct = xfs_dir3_block_verify,
 };
 
-static xfs_failaddr_t
+xfs_failaddr_t
 xfs_dir3_block_header_check(
-	struct xfs_inode	*dp,
-	struct xfs_buf		*bp)
+	struct xfs_buf		*bp,
+	xfs_ino_t		owner)
 {
-	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_mount	*mp = bp->b_mount;
 
 	if (xfs_has_crc(mp)) {
 		struct xfs_dir3_blk_hdr *hdr3 = bp->b_addr;
 
-		if (be64_to_cpu(hdr3->owner) != dp->i_ino)
+		ASSERT(hdr3->magic == cpu_to_be32(XFS_DIR3_BLOCK_MAGIC));
+
+		if (be64_to_cpu(hdr3->owner) != owner) {
+			xfs_err(NULL, "dir block owner 0x%llx doesnt match block 0x%llx", owner, be64_to_cpu(hdr3->owner));
+			dump_stack();
 			return __this_address;
+		}
 	}
 
 	return NULL;
@@ -136,6 +141,7 @@ int
 xfs_dir3_block_read(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
+	xfs_ino_t		owner,
 	struct xfs_buf		**bpp)
 {
 	struct xfs_mount	*mp = dp->i_mount;
@@ -148,7 +154,7 @@ xfs_dir3_block_read(
 		return err;
 
 	/* Check things that we can't do in the verifier. */
-	fa = xfs_dir3_block_header_check(dp, *bpp);
+	fa = xfs_dir3_block_header_check(*bpp, owner);
 	if (fa) {
 		__xfs_buf_mark_corrupt(*bpp, fa);
 		xfs_trans_brelse(tp, *bpp);
@@ -383,7 +389,7 @@ xfs_dir2_block_addname(
 	tp = args->trans;
 
 	/* Read the (one and only) directory block into bp. */
-	error = xfs_dir3_block_read(tp, dp, &bp);
+	error = xfs_dir3_block_read(tp, dp, args->owner, &bp);
 	if (error)
 		return error;
 
@@ -698,7 +704,7 @@ xfs_dir2_block_lookup_int(
 	dp = args->dp;
 	tp = args->trans;
 
-	error = xfs_dir3_block_read(tp, dp, &bp);
+	error = xfs_dir3_block_read(tp, dp, args->owner, &bp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index 22267a6e651a..b1dfe3e27357 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -51,7 +51,7 @@ extern int xfs_dir_cilookup_result(struct xfs_da_args *args,
 
 /* xfs_dir2_block.c */
 extern int xfs_dir3_block_read(struct xfs_trans *tp, struct xfs_inode *dp,
-			       struct xfs_buf **bpp);
+			       xfs_ino_t owner, struct xfs_buf **bpp);
 extern int xfs_dir2_block_addname(struct xfs_da_args *args);
 extern int xfs_dir2_block_lookup(struct xfs_da_args *args);
 extern int xfs_dir2_block_removename(struct xfs_da_args *args);
diff --git a/fs/xfs/libxfs/xfs_swapext.c b/fs/xfs/libxfs/xfs_swapext.c
index 86f683c10d40..b00d021b7d93 100644
--- a/fs/xfs/libxfs/xfs_swapext.c
+++ b/fs/xfs/libxfs/xfs_swapext.c
@@ -586,7 +586,7 @@ xfs_swapext_dir_to_sf(
 	if (!isblock)
 		return 0;
 
-	error = xfs_dir3_block_read(tp, sxi->sxi_ip2, &bp);
+	error = xfs_dir3_block_read(tp, sxi->sxi_ip2, sxi->sxi_ip2->i_ino, &bp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 6c8044cfb0eb..0e5f62295f29 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -313,7 +313,7 @@ xchk_directory_data_bestfree(
 		/* dir block format */
 		if (lblk != XFS_B_TO_FSBT(mp, XFS_DIR2_DATA_OFFSET))
 			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
-		error = xfs_dir3_block_read(sc->tp, sc->ip, &bp);
+		error = xfs_dir3_block_read(sc->tp, sc->ip, sc->ip->i_ino, &bp);
 	} else {
 		/* dir data format */
 		error = xfs_dir3_data_read(sc->tp, sc->ip, sc->ip->i_ino, lblk,
diff --git a/fs/xfs/scrub/readdir.c b/fs/xfs/scrub/readdir.c
index 33035b98d25c..d58a15c63a2d 100644
--- a/fs/xfs/scrub/readdir.c
+++ b/fs/xfs/scrub/readdir.c
@@ -101,7 +101,7 @@ xchk_dir_walk_block(
 	unsigned int		off, next_off, end;
 	int			error;
 
-	error = xfs_dir3_block_read(sc->tp, dp, &bp);
+	error = xfs_dir3_block_read(sc->tp, dp, dp->i_ino, &bp);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 37a521f47f20..771769f9e404 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -159,7 +159,7 @@ xfs_dir2_block_getdents(
 	if (xfs_dir2_dataptr_to_db(geo, ctx->pos) > geo->datablk)
 		return 0;
 
-	error = xfs_dir3_block_read(args->trans, dp, &bp);
+	error = xfs_dir3_block_read(args->trans, dp, args->owner, &bp);
 	if (error)
 		return error;
 

