Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 038BE7CFF5D
	for <lists+linux-xfs@lfdr.de>; Thu, 19 Oct 2023 18:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232123AbjJSQVu (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 19 Oct 2023 12:21:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231712AbjJSQVu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Oct 2023 12:21:50 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AB0B9B
        for <linux-xfs@vger.kernel.org>; Thu, 19 Oct 2023 09:21:48 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DE06C433C7;
        Thu, 19 Oct 2023 16:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697732508;
        bh=/UBilcauQoE50fEMN2cWUnr3IT+18T8yNg6+7Qa5C+o=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=uxXmT7f3mNfOJ3mcwVfcXvvlZAB6Rh8efOjXm7gvXpwZ1A6HkZe1Farf9ZGy+KIon
         JF5mXBc4xPFb5tKeOtwU35o5mwu8WAb844ybVC9p6GrD3ZiNqY2xo+LmYS2X9zxdcx
         nspnSOO5lBlf2JH+6wtMOx9XlSTIncUBz1r6QKkvruI7gDwhXibZDxry/a8pkdd1kH
         iW5YVptEi/SjPvNTX8BI0PkViqp72smHlW71WDDhj3FAIJGLwXmJn2JDCBiweZzxqm
         m46yWTWtg1eXRZtfa9EX4Xh/Mj4/l01DsLsPCRzxqUxIuaFFQm0p9mXVmzUrjMd4m2
         4RACVHEm9INXw==
Date:   Thu, 19 Oct 2023 09:21:47 -0700
Subject: [PATCH 2/4] xfs: hoist freeing of rt data fork extent mappings
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        osandov@fb.com, hch@lst.de
Message-ID: <169773209775.223190.13479316343116736994.stgit@frogsfrogsfrogs>
In-Reply-To: <169773209741.223190.10496728134720349846.stgit@frogsfrogsfrogs>
References: <169773209741.223190.10496728134720349846.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Currently, xfs_bmap_del_extent_real contains a bunch of code to convert
the physical extent of a data fork mapping for a realtime file into rt
extents and pass that to the rt extent freeing function.  Since the
details of this aren't needed when CONFIG_XFS_REALTIME=n, move it to
xfs_rtbitmap.c to reduce code size when realtime isn't enabled.

This will (one day) enable realtime EFIs to reuse the same
unit-converting call with less code duplication.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c     |   19 +++----------------
 fs/xfs/libxfs/xfs_rtbitmap.c |   33 +++++++++++++++++++++++++++++++++
 fs/xfs/xfs_rtalloc.h         |    5 +++++
 3 files changed, 41 insertions(+), 16 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 30c931b38853..26bfa34b4bbf 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5057,33 +5057,20 @@ xfs_bmap_del_extent_real(
 
 	flags = XFS_ILOG_CORE;
 	if (whichfork == XFS_DATA_FORK && XFS_IS_REALTIME_INODE(ip)) {
-		xfs_filblks_t	len;
-		xfs_extlen_t	mod;
-
-		len = div_u64_rem(del->br_blockcount, mp->m_sb.sb_rextsize,
-				  &mod);
-		ASSERT(mod == 0);
-
 		if (!(bflags & XFS_BMAPI_REMAP)) {
-			xfs_fsblock_t	bno;
-
-			bno = div_u64_rem(del->br_startblock,
-					mp->m_sb.sb_rextsize, &mod);
-			ASSERT(mod == 0);
-
-			error = xfs_rtfree_extent(tp, bno, (xfs_extlen_t)len);
+			error = xfs_rtfree_blocks(tp, del->br_startblock,
+					del->br_blockcount);
 			if (error)
 				goto done;
 		}
 
 		do_fx = 0;
-		nblks = len * mp->m_sb.sb_rextsize;
 		qfield = XFS_TRANS_DQ_RTBCOUNT;
 	} else {
 		do_fx = 1;
-		nblks = del->br_blockcount;
 		qfield = XFS_TRANS_DQ_BCOUNT;
 	}
+	nblks = del->br_blockcount;
 
 	del_endblock = del->br_startblock + del->br_blockcount;
 	if (cur) {
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index fa180ab66b73..655108a4cd05 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -1005,6 +1005,39 @@ xfs_rtfree_extent(
 	return 0;
 }
 
+/*
+ * Free some blocks in the realtime subvolume.  rtbno and rtlen are in units of
+ * rt blocks, not rt extents; must be aligned to the rt extent size; and rtlen
+ * cannot exceed XFS_MAX_BMBT_EXTLEN.
+ */
+int
+xfs_rtfree_blocks(
+	struct xfs_trans	*tp,
+	xfs_fsblock_t		rtbno,
+	xfs_filblks_t		rtlen)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	xfs_rtblock_t		bno;
+	xfs_filblks_t		len;
+	xfs_extlen_t		mod;
+
+	ASSERT(rtlen <= XFS_MAX_BMBT_EXTLEN);
+
+	len = div_u64_rem(rtlen, mp->m_sb.sb_rextsize, &mod);
+	if (mod) {
+		ASSERT(mod == 0);
+		return -EIO;
+	}
+
+	bno = div_u64_rem(rtbno, mp->m_sb.sb_rextsize, &mod);
+	if (mod) {
+		ASSERT(mod == 0);
+		return -EIO;
+	}
+
+	return xfs_rtfree_extent(tp, bno, len);
+}
+
 /* Find all the free records within a given range. */
 int
 xfs_rtalloc_query_range(
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index 62c7ad79cbb6..3b2f1b499a11 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -58,6 +58,10 @@ xfs_rtfree_extent(
 	xfs_rtblock_t		bno,	/* starting block number to free */
 	xfs_extlen_t		len);	/* length of extent freed */
 
+/* Same as above, but in units of rt blocks. */
+int xfs_rtfree_blocks(struct xfs_trans *tp, xfs_fsblock_t rtbno,
+		xfs_filblks_t rtlen);
+
 /*
  * Initialize realtime fields in the mount structure.
  */
@@ -139,6 +143,7 @@ int xfs_rtalloc_reinit_frextents(struct xfs_mount *mp);
 #else
 # define xfs_rtallocate_extent(t,b,min,max,l,f,p,rb)    (ENOSYS)
 # define xfs_rtfree_extent(t,b,l)                       (ENOSYS)
+# define xfs_rtfree_blocks(t,rb,rl)			(ENOSYS)
 # define xfs_rtpick_extent(m,t,l,rb)                    (ENOSYS)
 # define xfs_growfs_rt(mp,in)                           (ENOSYS)
 # define xfs_rtalloc_query_range(t,l,h,f,p)             (ENOSYS)

