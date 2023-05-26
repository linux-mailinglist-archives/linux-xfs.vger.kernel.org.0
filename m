Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB74D711BBC
	for <lists+linux-xfs@lfdr.de>; Fri, 26 May 2023 02:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236413AbjEZAxo (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 May 2023 20:53:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236055AbjEZAxn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:53:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FB9C12E
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:53:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CFEE5614A2
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:53:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4095AC433D2;
        Fri, 26 May 2023 00:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685062420;
        bh=cZVXwbdJWdkhG97lZRcbMVfJ8WF5GFbcgPRmiInYaNI=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=k6b2pRk9r/WbdfeL3BVo173t5T7OgYLGRsmyW77CWN3OMGvuE0Gr/UVenE0VyDDTz
         sPbNxM7OjH4s6A7P9jzZZOgyUEVR6B+fB3MIdXRMMffL7Dx/+OzV0pOqTHTgw88kRv
         GywrPm1s1VDPnmRAb4y4IkHeojTzv90qPXZjoyfMgdUFhhJDv7yzQTEG2V8Chx0pH/
         PitYSV9Kc5FO25JGd+TDGnXdvS+Enb4ED4DSm/2ypTyow3qWmrz3ga3UeiJwig3CMk
         6B0RnJ2dtaGhkyKOZGwDCNKIjJ8B023RVO0Vq/MXjzA+rU7OucouuJKNazWCpVyq0q
         wnZDzjKfP4RTQ==
Date:   Thu, 25 May 2023 17:53:39 -0700
Subject: [PATCH 6/6] xfs: repair obviously broken inode modes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506058397.3730405.15745668137639852004.stgit@frogsfrogsfrogs>
In-Reply-To: <168506058301.3730405.12262241466147528228.stgit@frogsfrogsfrogs>
References: <168506058301.3730405.12262241466147528228.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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

Building off the rmap scanner that we added in the previous patch, we
can now find block 0 and try to use the information contained inside of
it to guess the mode of an inode if it's totally improper.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/inode_repair.c |  170 ++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/trace.h        |   11 ++-
 2 files changed, 172 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
index fbe4eeff82f0..42ec3b38c826 100644
--- a/fs/xfs/scrub/inode_repair.c
+++ b/fs/xfs/scrub/inode_repair.c
@@ -74,6 +74,9 @@ struct xrep_inode {
 	/* Blocks in use by the attr fork. */
 	xfs_rfsblock_t		attr_blocks;
 
+	/* Physical block containing data block 0. */
+	xfs_fsblock_t		block0;
+
 	/* Number of data device extents for the data fork. */
 	xfs_extnum_t		data_extents;
 
@@ -113,6 +116,7 @@ xrep_setup_inode(
 	ri = sc->buf;
 	memcpy(&ri->imap, imap, sizeof(struct xfs_imap));
 	ri->sc = sc;
+	ri->block0 = NULLFSBLOCK;
 	return 0;
 }
 
@@ -188,12 +192,159 @@ xrep_dinode_header(
 	dip->di_gen = cpu_to_be32(sc->sm->sm_gen);
 }
 
+/* Parse enough of the directory block header to guess if this is a dir. */
+static inline bool
+xrep_dinode_is_dir(
+	xfs_ino_t			ino,
+	xfs_daddr_t			daddr,
+	struct xfs_buf			*bp)
+{
+	struct xfs_dir3_blk_hdr		*hdr3 = bp->b_addr;
+	struct xfs_dir2_data_free	*bf;
+	struct xfs_mount		*mp = bp->b_mount;
+	xfs_lsn_t			lsn = be64_to_cpu(hdr3->lsn);
+
+	/* Does the dir3 header match the filesystem? */
+	if (hdr3->magic != cpu_to_be32(XFS_DIR3_BLOCK_MAGIC) &&
+	    hdr3->magic != cpu_to_be32(XFS_DIR3_DATA_MAGIC))
+		return false;
+
+	if (be64_to_cpu(hdr3->owner) != ino)
+		return false;
+
+	if (!uuid_equal(&hdr3->uuid, &mp->m_sb.sb_meta_uuid))
+		return false;
+
+	if (be64_to_cpu(hdr3->blkno) != daddr)
+		return false;
+
+	/* Directory blocks are always logged and must have a valid LSN. */
+	if (lsn == NULLCOMMITLSN)
+		return false;
+	if (!xlog_valid_lsn(mp->m_log, lsn))
+		return false;
+
+	/*
+	 * bestfree information lives immediately after the end of the header,
+	 * so we won't run off the end of the buffer.
+	 */
+	bf = xfs_dir2_data_bestfree_p(mp, bp->b_addr);
+	if (!bf[0].length && bf[0].offset)
+		return false;
+	if (!bf[1].length && bf[1].offset)
+		return false;
+	if (!bf[2].length && bf[2].offset)
+		return false;
+
+	if (be16_to_cpu(bf[0].length) < be16_to_cpu(bf[1].length))
+		return false;
+	if (be16_to_cpu(bf[1].length) < be16_to_cpu(bf[2].length))
+		return false;
+
+	return true;
+}
+
+/* Guess the mode of this file from the contents. */
+STATIC uint16_t
+xrep_dinode_guess_mode(
+	struct xrep_inode	*ri,
+	struct xfs_dinode	*dip)
+{
+	struct xfs_buf		*bp;
+	struct xfs_mount	*mp = ri->sc->mp;
+	xfs_daddr_t		daddr;
+	uint64_t		fsize = be64_to_cpu(dip->di_size);
+	unsigned int		dfork_sz = XFS_DFORK_DSIZE(dip, mp);
+	uint16_t		mode = S_IFREG;
+	int			error;
+
+	switch (dip->di_format) {
+	case XFS_DINODE_FMT_LOCAL:
+		/*
+		 * If the data fork is local format, the size of the data area
+		 * is reasonable and is big enough to contain the entire file,
+		 * we can guess the file type from the local data.
+		 *
+		 * If there are no nulls, guess this is a symbolic link.
+		 * Otherwise, this is probably a shortform directory.
+		 */
+		if (dfork_sz <= XFS_LITINO(mp) && dfork_sz >= fsize) {
+			if (!memchr(XFS_DFORK_DPTR(dip), 0, fsize))
+				return S_IFLNK;
+			return S_IFDIR;
+		}
+
+		/* By default, we guess regular file. */
+		return S_IFREG;
+	case XFS_DINODE_FMT_DEV:
+		/*
+		 * If the data fork is dev format, the size of the data area is
+		 * reasonable and large enough to store a dev_t, and the file
+		 * size is zero, this could be a blockdev, a chardev, a fifo,
+		 * or a socket.  There is no solid way to distinguish between
+		 * those choices, so we guess blockdev if the device number is
+		 * nonzero and chardev if it's zero (aka whiteout).
+		 */
+		if (dfork_sz <= XFS_LITINO(mp) &&
+		    dfork_sz >= sizeof(__be32) && fsize == 0) {
+			xfs_dev_t	dev = xfs_dinode_get_rdev(dip);
+
+			return dev != 0 ? S_IFBLK : S_IFCHR;
+		}
+
+		/* By default, we guess regular file. */
+		return S_IFREG;
+	case XFS_DINODE_FMT_EXTENTS:
+	case XFS_DINODE_FMT_BTREE:
+		/* There are data blocks to examine below. */
+		break;
+	default:
+		/* Everything else is considered a regular file. */
+		return S_IFREG;
+	}
+
+	/* There are no zero-length directories. */
+	if (fsize == 0)
+		return S_IFREG;
+
+	/*
+	 * If we didn't find a written mapping for file block zero, we'll guess
+	 * that it's a sparse regular file.
+	 */
+	if (ri->block0 == NULLFSBLOCK)
+		return S_IFREG;
+
+	/* Directories can't have rt extents. */
+	if (ri->rt_extents > 0)
+		return S_IFREG;
+
+	/*
+	 * Read the first block of the file.  Since we have no idea what kind
+	 * of file geometry (e.g. dirblock size) we might be reading into, use
+	 * an uncached buffer so that we don't pollute the buffer cache.  We
+	 * can't do uncached mapped buffers, so the best we can do is guess
+	 * from the directory header.
+	 */
+	daddr = XFS_FSB_TO_DADDR(mp, ri->block0);
+	error = xfs_buf_read_uncached(mp->m_ddev_targp, daddr,
+			XFS_FSS_TO_BB(mp, 1), 0, &bp, NULL);
+	if (error)
+		return S_IFREG;
+
+	if (xrep_dinode_is_dir(ri->sc->sm->sm_ino, daddr, bp))
+		mode = S_IFDIR;
+
+	xfs_buf_relse(bp);
+	return mode;
+}
+
 /* Turn di_mode into /something/ recognizable. */
 STATIC void
 xrep_dinode_mode(
-	struct xfs_scrub	*sc,
+	struct xrep_inode	*ri,
 	struct xfs_dinode	*dip)
 {
+	struct xfs_scrub	*sc = ri->sc;
 	uint16_t		mode;
 
 	trace_xrep_dinode_mode(sc, dip);
@@ -203,7 +354,7 @@ xrep_dinode_mode(
 		return;
 
 	/* bad mode, so we set it to a file that only root can read */
-	mode = S_IFREG;
+	mode = xrep_dinode_guess_mode(ri, dip);
 	dip->di_mode = cpu_to_be16(mode);
 	dip->di_uid = 0;
 	dip->di_gid = 0;
@@ -412,9 +563,17 @@ xrep_dinode_walk_rmap(
 	}
 
 	ri->data_blocks += rec->rm_blockcount;
-	if (!(rec->rm_flags & XFS_RMAP_BMBT_BLOCK))
+	if (!(rec->rm_flags & XFS_RMAP_BMBT_BLOCK)) {
 		ri->data_extents++;
 
+		if (rec->rm_offset == 0 &&
+		    !(rec->rm_flags & XFS_RMAP_UNWRITTEN)) {
+			if (ri->block0 != NULLFSBLOCK)
+				return -EFSCORRUPTED;
+			ri->block0 = rec->rm_startblock;
+		}
+	}
+
 	return 0;
 }
 
@@ -465,7 +624,8 @@ xrep_dinode_count_rmaps(
 
 	trace_xrep_dinode_count_rmaps(ri->sc,
 			ri->data_blocks, ri->rt_blocks, ri->attr_blocks,
-			ri->data_extents, ri->rt_extents, ri->attr_extents);
+			ri->data_extents, ri->rt_extents, ri->attr_extents,
+			ri->block0);
 	return 0;
 }
 
@@ -1072,7 +1232,7 @@ xrep_dinode_core(
 	/* Fix everything the verifier will complain about. */
 	dip = xfs_buf_offset(bp, ri->imap.im_boffset);
 	xrep_dinode_header(sc, dip);
-	xrep_dinode_mode(sc, dip);
+	xrep_dinode_mode(ri, dip);
 	xrep_dinode_flags(sc, dip, ri->rt_extents > 0);
 	xrep_dinode_size(sc, dip);
 	xrep_dinode_extsize_hints(sc, dip);
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index cc939bf726e3..b288b3db9e4b 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1483,9 +1483,9 @@ TRACE_EVENT(xrep_dinode_count_rmaps,
 	TP_PROTO(struct xfs_scrub *sc, xfs_rfsblock_t data_blocks,
 		xfs_rfsblock_t rt_blocks, xfs_rfsblock_t attr_blocks,
 		xfs_extnum_t data_extents, xfs_extnum_t rt_extents,
-		xfs_aextnum_t attr_extents),
+		xfs_aextnum_t attr_extents, xfs_fsblock_t block0),
 	TP_ARGS(sc, data_blocks, rt_blocks, attr_blocks, data_extents,
-		rt_extents, attr_extents),
+		rt_extents, attr_extents, block0),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_ino_t, ino)
@@ -1495,6 +1495,7 @@ TRACE_EVENT(xrep_dinode_count_rmaps,
 		__field(xfs_extnum_t, data_extents)
 		__field(xfs_extnum_t, rt_extents)
 		__field(xfs_aextnum_t, attr_extents)
+		__field(xfs_fsblock_t, block0)
 	),
 	TP_fast_assign(
 		__entry->dev = sc->mp->m_super->s_dev;
@@ -1505,8 +1506,9 @@ TRACE_EVENT(xrep_dinode_count_rmaps,
 		__entry->data_extents = data_extents;
 		__entry->rt_extents = rt_extents;
 		__entry->attr_extents = attr_extents;
+		__entry->block0 = block0;
 	),
-	TP_printk("dev %d:%d ino 0x%llx dblocks 0x%llx rtblocks 0x%llx ablocks 0x%llx dextents %llu rtextents %llu aextents %u",
+	TP_printk("dev %d:%d ino 0x%llx dblocks 0x%llx rtblocks 0x%llx ablocks 0x%llx dextents %llu rtextents %llu aextents %u startblock0 0x%llx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->data_blocks,
@@ -1514,7 +1516,8 @@ TRACE_EVENT(xrep_dinode_count_rmaps,
 		  __entry->attr_blocks,
 		  __entry->data_extents,
 		  __entry->rt_extents,
-		  __entry->attr_extents)
+		  __entry->attr_extents,
+		  __entry->block0)
 );
 
 #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */

