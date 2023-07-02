Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EBB6744E96
	for <lists+linux-xfs@lfdr.de>; Sun,  2 Jul 2023 18:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229737AbjGBQZ6 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 2 Jul 2023 12:25:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbjGBQZ6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Jul 2023 12:25:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01CEDE61
        for <linux-xfs@vger.kernel.org>; Sun,  2 Jul 2023 09:25:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5748D60C32
        for <linux-xfs@vger.kernel.org>; Sun,  2 Jul 2023 16:25:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B285BC433C8;
        Sun,  2 Jul 2023 16:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688315155;
        bh=lqACvG6PtePb07DV350MjXmAy2rTIU5a1He9+6gurAg=;
        h=Date:From:To:Cc:Subject:From;
        b=RLHUWyLwhk8/VcOCwtfoA0gBrmpFjkEo7G+wWkGw6ajseSiBqCXGCasXZCOup+4nd
         nnHWqm0tPWxrnWxP1NRyhtz9LOW8hZs6LCmGVl0VGa74cUymxl46Ghg6gvNUawtyWG
         YmmRpRA7fz/hTsGs7Yttk2nR78B1wdkvyP9mFM7hZAHO2XaCs2+CfaE155johBVoiT
         2Toyd+jorN5yJb4wWXqoGkKRR1V7NAB7SJsntFUKd1O5qqNt0aLFPR8nohFYePoTas
         ji1t4VqE03BXZkGIUsiTQk1hyh6erSvCVXECPUr2rHbIn84EvZAIQ+1SfOQ9Qaw0Bp
         51MD++pbF8mzQ==
Date:   Sun, 2 Jul 2023 09:25:55 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: AGI length should be bounds checked
Message-ID: <20230702162555.GL11441@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Similar to the recent patch strengthening the AGF agf_length
verification, the AGI verifier does not check that the AGI length field
is within known good bounds.  This isn't currently checked by runtime
kernel code, yet we assume in many places that it is correct and verify
other metadata against it.

Add length verification to the AGI verifier.  Just like the AGF length
checking, the length of the AGI must be equal to the size of the AG
specified in the superblock, unless it is the last AG in the filesystem.
In that case, it must be less than or equal to sb->sb_agblocks and
greater than XFS_MIN_AG_BLOCKS, which is the smallest AG a growfs
operation will allow to exist.

There's only one place in the filesystem that actually uses agi_length,
but let's not leave it vulnerable to the same weird nonsense that
generates syzbot bugs, eh?

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c  |   72 ++++++++++++++++++++++++++++----------------
 fs/xfs/libxfs/xfs_alloc.h  |    3 ++
 fs/xfs/libxfs/xfs_ialloc.c |   24 +++++++--------
 3 files changed, 60 insertions(+), 39 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index e2da7de9b37e..72501d4a9328 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2956,6 +2956,47 @@ xfs_alloc_put_freelist(
 	return 0;
 }
 
+/*
+ * Check that this AGF/AGI header's sequence number and length matches the AG
+ * number and size in fsblocks.
+ */
+xfs_failaddr_t
+xfs_validate_ag_length(
+	struct xfs_buf		*bp,
+	uint32_t		seqno,
+	uint32_t		length)
+{
+	struct xfs_mount	*mp = bp->b_mount;
+	/*
+	 * During growfs operations, the perag is not fully initialised,
+	 * so we can't use it for any useful checking. growfs ensures we can't
+	 * use it by using uncached buffers that don't have the perag attached
+	 * so we can detect and avoid this problem.
+	 */
+	if (bp->b_pag && seqno != bp->b_pag->pag_agno)
+		return __this_address;
+
+	/*
+	 * Only the last AG in the filesystem is allowed to be shorter
+	 * than the AG size recorded in the superblock.
+	 */
+	if (length != mp->m_sb.sb_agblocks) {
+		/*
+		 * During growfs, the new last AG can get here before we
+		 * have updated the superblock. Give it a pass on the seqno
+		 * check.
+		 */
+		if (bp->b_pag && seqno != mp->m_sb.sb_agcount - 1)
+			return __this_address;
+		if (length < XFS_MIN_AG_BLOCKS)
+			return __this_address;
+		if (length > mp->m_sb.sb_agblocks)
+			return __this_address;
+	}
+
+	return NULL;
+}
+
 /*
  * Verify the AGF is consistent.
  *
@@ -2975,6 +3016,8 @@ xfs_agf_verify(
 {
 	struct xfs_mount	*mp = bp->b_mount;
 	struct xfs_agf		*agf = bp->b_addr;
+	xfs_failaddr_t		fa;
+	uint32_t		agf_seqno = be32_to_cpu(agf->agf_seqno);
 	uint32_t		agf_length = be32_to_cpu(agf->agf_length);
 
 	if (xfs_has_crc(mp)) {
@@ -2993,33 +3036,10 @@ xfs_agf_verify(
 	/*
 	 * Both agf_seqno and agf_length need to validated before anything else
 	 * block number related in the AGF or AGFL can be checked.
-	 *
-	 * During growfs operations, the perag is not fully initialised,
-	 * so we can't use it for any useful checking. growfs ensures we can't
-	 * use it by using uncached buffers that don't have the perag attached
-	 * so we can detect and avoid this problem.
 	 */
-	if (bp->b_pag && be32_to_cpu(agf->agf_seqno) != bp->b_pag->pag_agno)
-		return __this_address;
-
-	/*
-	 * Only the last AGF in the filesytsem is allowed to be shorter
-	 * than the AG size recorded in the superblock.
-	 */
-	if (agf_length != mp->m_sb.sb_agblocks) {
-		/*
-		 * During growfs, the new last AGF can get here before we
-		 * have updated the superblock. Give it a pass on the seqno
-		 * check.
-		 */
-		if (bp->b_pag &&
-		    be32_to_cpu(agf->agf_seqno) != mp->m_sb.sb_agcount - 1)
-			return __this_address;
-		if (agf_length < XFS_MIN_AG_BLOCKS)
-			return __this_address;
-		if (agf_length > mp->m_sb.sb_agblocks)
-			return __this_address;
-	}
+	fa = xfs_validate_ag_length(bp, agf_seqno, agf_length);
+	if (fa)
+		return fa;
 
 	if (be32_to_cpu(agf->agf_flfirst) >= xfs_agfl_size(mp))
 		return __this_address;
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index e544ee43fba6..6bb8d295c321 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -273,4 +273,7 @@ extern struct kmem_cache	*xfs_extfree_item_cache;
 int __init xfs_extfree_intent_init_cache(void);
 void xfs_extfree_intent_destroy_cache(void);
 
+xfs_failaddr_t xfs_validate_ag_length(struct xfs_buf *bp, uint32_t seqno,
+		uint32_t length);
+
 #endif	/* __XFS_ALLOC_H__ */
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 1e5fafbc0cdb..b83e54c70906 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -2486,11 +2486,14 @@ xfs_ialloc_log_agi(
 
 static xfs_failaddr_t
 xfs_agi_verify(
-	struct xfs_buf	*bp)
+	struct xfs_buf		*bp)
 {
-	struct xfs_mount *mp = bp->b_mount;
-	struct xfs_agi	*agi = bp->b_addr;
-	int		i;
+	struct xfs_mount	*mp = bp->b_mount;
+	struct xfs_agi		*agi = bp->b_addr;
+	xfs_failaddr_t		fa;
+	uint32_t		agi_seqno = be32_to_cpu(agi->agi_seqno);
+	uint32_t		agi_length = be32_to_cpu(agi->agi_length);
+	int			i;
 
 	if (xfs_has_crc(mp)) {
 		if (!uuid_equal(&agi->agi_uuid, &mp->m_sb.sb_meta_uuid))
@@ -2507,6 +2510,10 @@ xfs_agi_verify(
 	if (!XFS_AGI_GOOD_VERSION(be32_to_cpu(agi->agi_versionnum)))
 		return __this_address;
 
+	fa = xfs_validate_ag_length(bp, agi_seqno, agi_length);
+	if (fa)
+		return fa;
+
 	if (be32_to_cpu(agi->agi_level) < 1 ||
 	    be32_to_cpu(agi->agi_level) > M_IGEO(mp)->inobt_maxlevels)
 		return __this_address;
@@ -2516,15 +2523,6 @@ xfs_agi_verify(
 	     be32_to_cpu(agi->agi_free_level) > M_IGEO(mp)->inobt_maxlevels))
 		return __this_address;
 
-	/*
-	 * during growfs operations, the perag is not fully initialised,
-	 * so we can't use it for any useful checking. growfs ensures we can't
-	 * use it by using uncached buffers that don't have the perag attached
-	 * so we can detect and avoid this problem.
-	 */
-	if (bp->b_pag && be32_to_cpu(agi->agi_seqno) != bp->b_pag->pag_agno)
-		return __this_address;
-
 	for (i = 0; i < XFS_AGI_UNLINKED_BUCKETS; i++) {
 		if (agi->agi_unlinked[i] == cpu_to_be32(NULLAGINO))
 			continue;
