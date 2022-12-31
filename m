Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EFB665A06B
	for <lists+linux-xfs@lfdr.de>; Sat, 31 Dec 2022 02:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235936AbiLaBRK (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 20:17:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236047AbiLaBRH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:17:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E62B1AD9A
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:17:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C19761D79
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:17:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 999AAC433D2;
        Sat, 31 Dec 2022 01:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672449425;
        bh=HzwpWgwfQ9Mfz1R9AkHcvK2nPsJlDP2WhxCRh45i+ZI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MZpNCkfUfzaBxga5cRHYQrvILFosRQ/3staDVQ4Lon/ybi2q8hFldUM2qUY7cRJpy
         h0XBOzb0vg9Z7zSryd5ZmNmrfHJncDpqlcpt/gR4fbPfa7m4lg5cccVz2cbyELgMBd
         AOctx6t7qtALzwrFcfB6CsxK7h+ehjPuVSNfbbPcCcCV+IcJCCiBnh7YWmlBbc5YOL
         yW4pkkFJXX+kvDgGVhj7yZDDwJ42w7KF2WB9au98Bxw7b/QXxpKIT2jtEN9OiSuCg0
         gCjBH0qE1VdYz/8SK5UGdMdOS8P9YGhZpxbJEFjJzyNEia+lCO7YnwueyTztg3qq4f
         roOQuWvgeXL3g==
Subject: [PATCH 03/14] xfs: refactor creation of bmap btree roots
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:31 -0800
Message-ID: <167243865150.708933.20488103124286076.stgit@magnolia>
In-Reply-To: <167243865089.708933.5645420573863731083.stgit@magnolia>
References: <167243865089.708933.5645420573863731083.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Now that we've created inode fork helpers to allocate and free btree
roots, create a new bmap btree helper to create a new bmbt root, and
refactor the extents <-> btree conversion functions to use our new
helpers.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c       |   17 ++++-------------
 fs/xfs/libxfs/xfs_bmap_btree.c |   16 ++++++++++++++++
 fs/xfs/libxfs/xfs_bmap_btree.h |    2 ++
 3 files changed, 22 insertions(+), 13 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index cbcb24df1a1e..98bd32da142d 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -591,7 +591,7 @@ xfs_bmap_btree_to_extents(
 	xfs_trans_binval(tp, cbp);
 	if (cur->bc_levels[0].bp == cbp)
 		cur->bc_levels[0].bp = NULL;
-	xfs_iroot_realloc(ip, -1, whichfork);
+	xfs_iroot_free(ip, whichfork);
 	ASSERT(ifp->if_broot == NULL);
 	ifp->if_format = XFS_DINODE_FMT_EXTENTS;
 	*logflagsp |= XFS_ILOG_CORE | xfs_ilog_fext(whichfork);
@@ -631,20 +631,10 @@ xfs_bmap_extents_to_btree(
 	ifp = xfs_ifork_ptr(ip, whichfork);
 	ASSERT(ifp->if_format == XFS_DINODE_FMT_EXTENTS);
 
-	/*
-	 * Make space in the inode incore. This needs to be undone if we fail
-	 * to expand the root.
-	 */
-	xfs_iroot_realloc(ip, 1, whichfork);
-
-	/*
-	 * Fill in the root.
-	 */
-	block = ifp->if_broot;
-	xfs_btree_init_block(mp, block, &xfs_bmbt_ops, 1, 1, ip->i_ino);
 	/*
 	 * Need a cursor.  Can't allocate until bb_level is filled in.
 	 */
+	xfs_bmbt_iroot_alloc(ip, whichfork);
 	cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
 	cur->bc_ino.flags = wasdel ? XFS_BTCUR_BMBT_WASDEL : 0;
 	/*
@@ -711,6 +701,7 @@ xfs_bmap_extents_to_btree(
 	/*
 	 * Fill in the root key and pointer.
 	 */
+	block = ifp->if_broot;
 	kp = xfs_bmbt_key_addr(mp, block, 1);
 	arp = xfs_bmbt_rec_addr(mp, ablock, 1);
 	kp->br_startoff = cpu_to_be64(xfs_bmbt_disk_get_startoff(arp));
@@ -732,7 +723,7 @@ xfs_bmap_extents_to_btree(
 out_unreserve_dquot:
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
 out_root_realloc:
-	xfs_iroot_realloc(ip, -1, whichfork);
+	xfs_iroot_free(ip, whichfork);
 	ifp->if_format = XFS_DINODE_FMT_EXTENTS;
 	ASSERT(ifp->if_broot == NULL);
 	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 82f46837f79f..973fa6cc7aa6 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -796,3 +796,19 @@ xfs_bmbt_destroy_cur_cache(void)
 	kmem_cache_destroy(xfs_bmbt_cur_cache);
 	xfs_bmbt_cur_cache = NULL;
 }
+
+/* Create an incore bmbt btree root block. */
+void
+xfs_bmbt_iroot_alloc(
+	struct xfs_inode	*ip,
+	int			whichfork)
+{
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
+
+	xfs_iroot_alloc(ip, whichfork,
+			xfs_bmap_broot_space_calc(ip->i_mount, 1));
+
+	/* Fill in the root. */
+	xfs_btree_init_block(ip->i_mount, ifp->if_broot, &xfs_bmbt_ops, 1, 1,
+			ip->i_ino);
+}
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.h b/fs/xfs/libxfs/xfs_bmap_btree.h
index 62fbc4f7c2c4..3fe9c4f7f1a0 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.h
+++ b/fs/xfs/libxfs/xfs_bmap_btree.h
@@ -196,4 +196,6 @@ xfs_bmap_bmdr_space(struct xfs_btree_block *bb)
 	return xfs_bmdr_space_calc(be16_to_cpu(bb->bb_numrecs));
 }
 
+void xfs_bmbt_iroot_alloc(struct xfs_inode *ip, int whichfork);
+
 #endif	/* __XFS_BMAP_BTREE_H__ */

