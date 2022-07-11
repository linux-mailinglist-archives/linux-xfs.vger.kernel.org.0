Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E10AE567A9A
	for <lists+linux-xfs@lfdr.de>; Wed,  6 Jul 2022 01:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbiGEXSU (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 5 Jul 2022 19:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiGEXST (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jul 2022 19:18:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD35BE1A
        for <linux-xfs@vger.kernel.org>; Tue,  5 Jul 2022 16:18:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F7FCB81A38
        for <linux-xfs@vger.kernel.org>; Tue,  5 Jul 2022 23:18:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 163C2C341C7;
        Tue,  5 Jul 2022 23:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657063095;
        bh=kXc1DF9UHyvuoWDHrFAIJ+xpzvyknfiRmmyLzN68w28=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=BMdKGHsqUwzxKINGu79NrDmfqVdoNcx6r9D/C+2Daqa3nKM1/Zmcsfb5g2MfWORbJ
         urP/PBVEQ50gJK3iL0CeVe6F+dhym7Wk20W8ykb8NbiI50+kKb/gSF/ZvFfUttU/ZL
         MZFjW9PDn87sRoo/NI+fz1ODVJvlw5pINW05fYjJ27CWwAt9pxDZ8DZC0q9IiHio9k
         getI3OSVVMzI29W5Jr7d8SBmA4K1A7hixXXMByAQNrSmYy9YYog6mGcoz/bRVbNvj8
         GoHbeJjCUDb5E1tLv7FhNh3bMBPySRGCSqqFrFMpl/n/Eyt055Gji9DHNfOC0muYYU
         tgHSYuCzOasBQ==
Date:   Tue, 5 Jul 2022 16:18:14 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Subject: [PATCH 4/3] xfs: replace XFS_IFORK_Q with a proper predicate function
Message-ID: <YsTGtvcWszfGuyle@magnolia>
References: <165705897408.2826746.14673631830829415034.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165705897408.2826746.14673631830829415034.stgit@magnolia>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Replace this shouty macro with a real C function that has a more
descriptive name.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c       |    4 ++--
 fs/xfs/libxfs/xfs_attr.h       |    2 +-
 fs/xfs/libxfs/xfs_bmap.c       |    4 ++--
 fs/xfs/libxfs/xfs_inode_fork.c |    2 +-
 fs/xfs/libxfs/xfs_inode_fork.h |    5 ++---
 fs/xfs/scrub/btree.c           |    2 +-
 fs/xfs/xfs_attr_inactive.c     |    4 ++--
 fs/xfs/xfs_bmap_util.c         |   10 +++++-----
 fs/xfs/xfs_inode.c             |   10 +++++-----
 fs/xfs/xfs_inode.h             |    7 ++++++-
 fs/xfs/xfs_inode_item.c        |    4 ++--
 fs/xfs/xfs_iomap.c             |    2 +-
 fs/xfs/xfs_iops.c              |    2 +-
 13 files changed, 31 insertions(+), 27 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 002d7dea2190..58715c7ec672 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -67,7 +67,7 @@ int
 xfs_inode_hasattr(
 	struct xfs_inode	*ip)
 {
-	if (!XFS_IFORK_Q(ip))
+	if (!xfs_inode_has_attr_fork(ip))
 		return 0;
 	if (ip->i_af.if_format == XFS_DINODE_FMT_EXTENTS &&
 	    ip->i_af.if_nextents == 0)
@@ -999,7 +999,7 @@ xfs_attr_set(
 		 * If the inode doesn't have an attribute fork, add one.
 		 * (inode must not be locked when we call this routine)
 		 */
-		if (XFS_IFORK_Q(dp) == 0) {
+		if (xfs_inode_has_attr_fork(dp) == 0) {
 			int sf_size = sizeof(struct xfs_attr_sf_hdr) +
 				xfs_attr_sf_entsize_byname(args->namelen,
 						args->valuelen);
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 36371c3b9069..81be9b3e4004 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -576,7 +576,7 @@ xfs_attr_init_add_state(struct xfs_da_args *args)
 	 * context, i_af is guaranteed to exist. Hence if the attr fork is
 	 * null, we were called from a pure remove operation and so we are done.
 	 */
-	if (!XFS_IFORK_Q(args->dp))
+	if (!xfs_inode_has_attr_fork(args->dp))
 		return XFS_DAS_DONE;
 
 	args->op_flags |= XFS_DA_OP_ADDNAME;
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 1ef72443025a..e5108df54f5a 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1023,7 +1023,7 @@ xfs_bmap_add_attrfork(
 	int			logflags;	/* logging flags */
 	int			error;		/* error return value */
 
-	ASSERT(XFS_IFORK_Q(ip) == 0);
+	ASSERT(xfs_inode_has_attr_fork(ip) == 0);
 
 	mp = ip->i_mount;
 	ASSERT(!XFS_NOT_DQATTACHED(mp, ip));
@@ -1034,7 +1034,7 @@ xfs_bmap_add_attrfork(
 			rsvd, &tp);
 	if (error)
 		return error;
-	if (XFS_IFORK_Q(ip))
+	if (xfs_inode_has_attr_fork(ip))
 		goto trans_cancel;
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index b0370b837166..b3ba97242e71 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -717,7 +717,7 @@ xfs_ifork_verify_local_attr(
 	struct xfs_ifork	*ifp = &ip->i_af;
 	xfs_failaddr_t		fa;
 
-	if (!XFS_IFORK_Q(ip))
+	if (!xfs_inode_has_attr_fork(ip))
 		fa = __this_address;
 	else
 		fa = xfs_attr_shortform_verify(ip);
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 0b912bbe4f4b..efee11956540 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -78,13 +78,12 @@ struct xfs_ifork {
  * Fork handling.
  */
 
-#define XFS_IFORK_Q(ip)			((ip)->i_forkoff != 0)
 #define XFS_IFORK_BOFF(ip)		((int)((ip)->i_forkoff << 3))
 
 #define XFS_IFORK_DSIZE(ip) \
-	(XFS_IFORK_Q(ip) ? XFS_IFORK_BOFF(ip) : XFS_LITINO((ip)->i_mount))
+	(xfs_inode_has_attr_fork(ip) ? XFS_IFORK_BOFF(ip) : XFS_LITINO((ip)->i_mount))
 #define XFS_IFORK_ASIZE(ip) \
-	(XFS_IFORK_Q(ip) ? XFS_LITINO((ip)->i_mount) - XFS_IFORK_BOFF(ip) : 0)
+	(xfs_inode_has_attr_fork(ip) ? XFS_LITINO((ip)->i_mount) - XFS_IFORK_BOFF(ip) : 0)
 #define XFS_IFORK_SIZE(ip,w) \
 	((w) == XFS_DATA_FORK ? \
 		XFS_IFORK_DSIZE(ip) : \
diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index 39dd46f038fe..2f4519590dc1 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -462,7 +462,7 @@ xchk_btree_check_iroot_minrecs(
 	 */
 	if (bs->cur->bc_btnum == XFS_BTNUM_BMAP &&
 	    bs->cur->bc_ino.whichfork == XFS_DATA_FORK &&
-	    XFS_IFORK_Q(bs->sc->ip))
+	    xfs_inode_has_attr_fork(bs->sc->ip))
 		return false;
 
 	return true;
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index ec20ad7a9001..0e83cab9cdde 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -338,7 +338,7 @@ xfs_attr_inactive(
 	ASSERT(! XFS_NOT_DQATTACHED(mp, dp));
 
 	xfs_ilock(dp, lock_mode);
-	if (!XFS_IFORK_Q(dp))
+	if (!xfs_inode_has_attr_fork(dp))
 		goto out_destroy_fork;
 	xfs_iunlock(dp, lock_mode);
 
@@ -351,7 +351,7 @@ xfs_attr_inactive(
 	lock_mode = XFS_ILOCK_EXCL;
 	xfs_ilock(dp, lock_mode);
 
-	if (!XFS_IFORK_Q(dp))
+	if (!xfs_inode_has_attr_fork(dp))
 		goto out_cancel;
 
 	/*
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index f317586d2f63..8111319cbb46 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -444,7 +444,7 @@ xfs_getbmap(
 	xfs_ilock(ip, XFS_IOLOCK_SHARED);
 	switch (whichfork) {
 	case XFS_ATTR_FORK:
-		if (!XFS_IFORK_Q(ip))
+		if (!xfs_inode_has_attr_fork(ip))
 			goto out_unlock_iolock;
 
 		max_len = 1LL << 32;
@@ -1320,7 +1320,7 @@ xfs_swap_extents_check_format(
 	 * extent format...
 	 */
 	if (tifp->if_format == XFS_DINODE_FMT_BTREE) {
-		if (XFS_IFORK_Q(ip) &&
+		if (xfs_inode_has_attr_fork(ip) &&
 		    XFS_BMAP_BMDR_SPACE(tifp->if_broot) > XFS_IFORK_BOFF(ip))
 			return -EINVAL;
 		if (tifp->if_nextents <= XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK))
@@ -1329,7 +1329,7 @@ xfs_swap_extents_check_format(
 
 	/* Reciprocal target->temp btree format checks */
 	if (ifp->if_format == XFS_DINODE_FMT_BTREE) {
-		if (XFS_IFORK_Q(tip) &&
+		if (xfs_inode_has_attr_fork(tip) &&
 		    XFS_BMAP_BMDR_SPACE(ip->i_df.if_broot) > XFS_IFORK_BOFF(tip))
 			return -EINVAL;
 		if (ifp->if_nextents <= XFS_IFORK_MAXEXT(tip, XFS_DATA_FORK))
@@ -1506,14 +1506,14 @@ xfs_swap_extent_forks(
 	/*
 	 * Count the number of extended attribute blocks
 	 */
-	if (XFS_IFORK_Q(ip) && ip->i_af.if_nextents > 0 &&
+	if (xfs_inode_has_attr_fork(ip) && ip->i_af.if_nextents > 0 &&
 	    ip->i_af.if_format != XFS_DINODE_FMT_LOCAL) {
 		error = xfs_bmap_count_blocks(tp, ip, XFS_ATTR_FORK, &junk,
 				&aforkblks);
 		if (error)
 			return error;
 	}
-	if (XFS_IFORK_Q(tip) && tip->i_af.if_nextents > 0 &&
+	if (xfs_inode_has_attr_fork(tip) && tip->i_af.if_nextents > 0 &&
 	    tip->i_af.if_format != XFS_DINODE_FMT_LOCAL) {
 		error = xfs_bmap_count_blocks(tp, tip, XFS_ATTR_FORK, &junk,
 				&taforkblks);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 699c44f57707..33cf0b82a0c0 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -125,7 +125,7 @@ xfs_ilock_attr_map_shared(
 {
 	uint			lock_mode = XFS_ILOCK_SHARED;
 
-	if (XFS_IFORK_Q(ip) && xfs_need_iread_extents(&ip->i_af))
+	if (xfs_inode_has_attr_fork(ip) && xfs_need_iread_extents(&ip->i_af))
 		lock_mode = XFS_ILOCK_EXCL;
 	xfs_ilock(ip, lock_mode);
 	return lock_mode;
@@ -635,7 +635,7 @@ xfs_ip2xflags(
 			flags |= FS_XFLAG_COWEXTSIZE;
 	}
 
-	if (XFS_IFORK_Q(ip))
+	if (xfs_inode_has_attr_fork(ip))
 		flags |= FS_XFLAG_HASATTR;
 	return flags;
 }
@@ -1762,7 +1762,7 @@ xfs_inactive(
 	 * now.  The code calls a routine that recursively deconstructs the
 	 * attribute fork. If also blows away the in-core attribute fork.
 	 */
-	if (XFS_IFORK_Q(ip)) {
+	if (xfs_inode_has_attr_fork(ip)) {
 		error = xfs_attr_inactive(ip);
 		if (error)
 			goto out;
@@ -3501,7 +3501,7 @@ xfs_iflush(
 	if (ip->i_df.if_format == XFS_DINODE_FMT_LOCAL &&
 	    xfs_ifork_verify_local_data(ip))
 		goto flush_out;
-	if (XFS_IFORK_Q(ip) &&
+	if (xfs_inode_has_attr_fork(ip) &&
 	    ip->i_af.if_format == XFS_DINODE_FMT_LOCAL &&
 	    xfs_ifork_verify_local_attr(ip))
 		goto flush_out;
@@ -3520,7 +3520,7 @@ xfs_iflush(
 	}
 
 	xfs_iflush_fork(ip, dip, iip, XFS_DATA_FORK);
-	if (XFS_IFORK_Q(ip))
+	if (xfs_inode_has_attr_fork(ip))
 		xfs_iflush_fork(ip, dip, iip, XFS_ATTR_FORK);
 
 	/*
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 9bda01311c2f..2badbf9bb80d 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -77,6 +77,11 @@ typedef struct xfs_inode {
 	struct list_head	i_ioend_list;
 } xfs_inode_t;
 
+static inline bool xfs_inode_has_attr_fork(struct xfs_inode *ip)
+{
+	return ip->i_forkoff > 0;
+}
+
 static inline struct xfs_ifork *
 xfs_ifork_ptr(
 	struct xfs_inode	*ip,
@@ -86,7 +91,7 @@ xfs_ifork_ptr(
 	case XFS_DATA_FORK:
 		return &ip->i_df;
 	case XFS_ATTR_FORK:
-		if (!XFS_IFORK_Q(ip))
+		if (!xfs_inode_has_attr_fork(ip))
 			return NULL;
 		return &ip->i_af;
 	case XFS_COW_FORK:
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 77519e6f0b34..a78a0b9dd1d0 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -143,7 +143,7 @@ xfs_inode_item_size(
 		   xfs_log_dinode_size(ip->i_mount);
 
 	xfs_inode_item_data_fork_size(iip, nvecs, nbytes);
-	if (XFS_IFORK_Q(ip))
+	if (xfs_inode_has_attr_fork(ip))
 		xfs_inode_item_attr_fork_size(iip, nvecs, nbytes);
 }
 
@@ -480,7 +480,7 @@ xfs_inode_item_format(
 
 	xfs_inode_item_format_core(ip, lv, &vecp);
 	xfs_inode_item_format_data_fork(iip, ilf, lv, &vecp);
-	if (XFS_IFORK_Q(ip)) {
+	if (xfs_inode_has_attr_fork(ip)) {
 		xfs_inode_item_format_attr_fork(iip, ilf, lv, &vecp);
 	} else {
 		iip->ili_fields &=
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index eb54fd259d15..edbfd6abcc15 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1307,7 +1307,7 @@ xfs_xattr_iomap_begin(
 	lockmode = xfs_ilock_attr_map_shared(ip);
 
 	/* if there are no attribute fork or extents, return ENOENT */
-	if (!XFS_IFORK_Q(ip) || !ip->i_af.if_nextents) {
+	if (!xfs_inode_has_attr_fork(ip) || !ip->i_af.if_nextents) {
 		error = -ENOENT;
 		goto out_unlock;
 	}
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 6720b60f88cf..14efa0fc1c19 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1279,7 +1279,7 @@ xfs_setup_inode(
 	 * If there is no attribute fork no ACL can exist on this inode,
 	 * and it can't have any file capabilities attached to it either.
 	 */
-	if (!XFS_IFORK_Q(ip)) {
+	if (!xfs_inode_has_attr_fork(ip)) {
 		inode_has_no_xattr(inode);
 		cache_no_acl(inode);
 	}
