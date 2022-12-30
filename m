Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE8A2659EA6
	for <lists+linux-xfs@lfdr.de>; Sat, 31 Dec 2022 00:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235771AbiL3Xpl (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 18:45:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235752AbiL3Xpe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:45:34 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E82D1E3C3
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:45:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EC52ACE19D8
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:45:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30222C433D2;
        Fri, 30 Dec 2022 23:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672443929;
        bh=TEv/HwV9yENpdoR3doLLTYk6oZHc1SdcXiHkS9YNaaY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=c/HxvN1ntFRmAVg77f3QZ6aFC71QOdUThG5/c/pnM8Osd5W5mGgbY5Dj4n36B8Qz+
         NObuRjG2luRPCs1mU06qfRdlP9YP98QqjQfo5z5t67LwbNuRRQHWxwi9NScCy5crrt
         X4lSedLyRwUyCfTXFlZw9V69QrxUkas6zI0ovf/e71myRP1EhcJm7KR7aE8Hec8COX
         +P4rnGrdO3Q8R7SB8xrTpfHH9gEG/md9OGz7QlUYhQO4Ruwt2KyOYW2gNl7qJfQ4jP
         vHdO1CZZn7PjDXWBzrsa/0DRLKcBMN+F+4k9NRXF+ChSATor2fZSaUMwYQ2GnS6zy2
         nDtaLXAhONCKA==
Subject: [PATCH 6/9] xfs: btree convert xfs_btree_init_block to
 xfs_btree_init_buf calls
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:34 -0800
Message-ID: <167243841455.696890.3969433307761723239.stgit@magnolia>
In-Reply-To: <167243841359.696890.6518296492918665756.stgit@magnolia>
References: <167243841359.696890.6518296492918665756.stgit@magnolia>
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

Convert any place we call xfs_btree_init_block with a buffer to use the
_init_buf function.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c  |    3 +--
 fs/xfs/libxfs/xfs_btree.c |    3 +--
 fs/xfs/scrub/xfbtree.c    |    3 +--
 3 files changed, 3 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 3ff3202e6e91..ac20971a8c18 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -696,8 +696,7 @@ xfs_bmap_extents_to_btree(
 	 */
 	abp->b_ops = &xfs_bmbt_buf_ops;
 	ablock = XFS_BUF_TO_BLOCK(abp);
-	xfs_btree_init_block(mp, ablock, &xfs_bmbt_ops, xfs_buf_daddr(abp),
-			0, 0, ip->i_ino);
+	xfs_btree_init_buf(mp, abp, &xfs_bmbt_ops, 0, 0, ip->i_ino);
 
 	for_each_xfs_iext(ifp, &icur, &rec) {
 		if (isnullstartblock(rec.br_startblock))
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index fe2f21fa7b21..b3f9b7324c93 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -1289,8 +1289,7 @@ xfs_btree_init_block_cur(
 	else
 		owner = cur->bc_ag.pag->pag_agno;
 
-	xfs_btree_init_block(cur->bc_mp, XFS_BUF_TO_BLOCK(bp), cur->bc_ops,
-			xfs_buf_daddr(bp), level, numrecs, owner);
+	xfs_btree_init_buf(cur->bc_mp, bp, cur->bc_ops, level, numrecs, owner);
 }
 
 /*
diff --git a/fs/xfs/scrub/xfbtree.c b/fs/xfs/scrub/xfbtree.c
index 95cbdd6738ec..d42d1bc8e36b 100644
--- a/fs/xfs/scrub/xfbtree.c
+++ b/fs/xfs/scrub/xfbtree.c
@@ -416,8 +416,7 @@ xfbtree_init_leaf_block(
 	trace_xfbtree_create_root_buf(xfbt, bp);
 
 	bp->b_ops = cfg->btree_ops->buf_ops;
-	xfs_btree_init_block(mp, bp->b_addr, cfg->btree_ops, daddr, 0, 0,
-			cfg->owner);
+	xfs_btree_init_buf(mp, bp, cfg->btree_ops, 0, 0, cfg->owner);
 	error = xfs_bwrite(bp);
 	xfs_buf_relse(bp);
 	if (error)

