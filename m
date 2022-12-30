Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05EE7659F17
	for <lists+linux-xfs@lfdr.de>; Sat, 31 Dec 2022 01:01:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbiLaABG (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 19:01:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235668AbiLaABG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:01:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7883B2ACD
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:01:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2538EB81DE0
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:01:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB5BBC433D2;
        Sat, 31 Dec 2022 00:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672444862;
        bh=p3WMiim6+8X5s3iqTEletmdUmwXb57Sqna3ScCqQgP8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=H6hac/Bv+5XcvwIu4re/NHzxsLja7gUubh+xMPuLSyVYX0WR6ry3Dt+WunHBi7Ab4
         m4uFYMmwCkzzC/jdqLNQlaWQLyx+9HnXWbgN0ymilkgP1ks/KHo7AYQl9Pw0HK+k9F
         jID81NUt7ojO5yZeou7uRQyrEmCBpeE3aHxSwquJffG5jhyrYuRDQw3bbY9ZrzRXeF
         hVKLm1Fte9BLIpSzT7ZHO0+zWPkJkpq79qphCM9YsiFAVQRsJ72n4jepCFa6JcM6I4
         l3hXAUowe0XRZhOV7tXrVyCdf3gVZl3qD/PWLDKC3wndzK5rROOtpcUjFtS6Rr/gdK
         iQe8HPAYH7y1A==
Subject: [PATCH 5/5] xfs: flag empty xattr leaf blocks for optimization
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:14:13 -0800
Message-ID: <167243845343.700496.10955255986696331196.stgit@magnolia>
In-Reply-To: <167243845264.700496.9115810454468711427.stgit@magnolia>
References: <167243845264.700496.9115810454468711427.stgit@magnolia>
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

Empty xattr leaf blocks at offset zero are a waste of space but
otherwise harmless.  If we encounter one, flag it as an opportunity for
optimization.

If we encounter empty attr leaf blocks anywhere else in the attr fork,
that's corruption.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/attr.c    |   11 +++++++++++
 fs/xfs/scrub/dabtree.h |    2 ++
 2 files changed, 13 insertions(+)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 0fb9344c671b..a1585862c625 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -412,6 +412,17 @@ xchk_xattr_block(
 	xfs_attr3_leaf_hdr_from_disk(mp->m_attr_geo, &leafhdr, leaf);
 	hdrsize = xfs_attr3_leaf_hdr_size(leaf);
 
+	/*
+	 * Empty xattr leaf blocks mapped at block 0 are probably a byproduct
+	 * of a race between setxattr and a log shutdown.  Anywhere else in the
+	 * attr fork is a corruption.
+	 */
+	if (leafhdr.count == 0) {
+		if (blk->blkno == 0)
+			xchk_da_set_preen(ds, level);
+		else
+			xchk_da_set_corrupt(ds, level);
+	}
 	if (leafhdr.usedbytes > mp->m_attr_geo->blksize)
 		xchk_da_set_corrupt(ds, level);
 	if (leafhdr.firstused > mp->m_attr_geo->blksize)
diff --git a/fs/xfs/scrub/dabtree.h b/fs/xfs/scrub/dabtree.h
index 8066fa00dc1b..a24a4cbc4125 100644
--- a/fs/xfs/scrub/dabtree.h
+++ b/fs/xfs/scrub/dabtree.h
@@ -37,6 +37,8 @@ bool xchk_da_process_error(struct xchk_da_btree *ds, int level, int *error);
 void xchk_da_set_corrupt(struct xchk_da_btree *ds, int level);
 void xchk_da_set_preen(struct xchk_da_btree *ds, int level);
 
+void xchk_da_set_preen(struct xchk_da_btree *ds, int level);
+
 int xchk_da_btree_hash(struct xchk_da_btree *ds, int level, __be32 *hashp);
 int xchk_da_btree(struct xfs_scrub *sc, int whichfork,
 		xchk_da_btree_rec_fn scrub_fn, void *private);

