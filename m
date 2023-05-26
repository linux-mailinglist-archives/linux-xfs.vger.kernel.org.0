Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7DA9711C9D
	for <lists+linux-xfs@lfdr.de>; Fri, 26 May 2023 03:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbjEZB3z (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 May 2023 21:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235395AbjEZB3x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:29:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C20DF199
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:29:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B2C764C30
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:29:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F889C433D2;
        Fri, 26 May 2023 01:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685064590;
        bh=6iUxockQva2NSv6Rhln7noFjZ0S8GbmkM/TftTQOk00=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=rY2fmu4+pSM4D0OkdNDfM7PmPBl/qjfqu9Yb2YZe8vW60hRwux/VuTowORA/1q+Nf
         46Tx0uFtNZfIl3L0fffd47pRcfVo6GoLl+cE8BtDuSt+fdIk1dStl81t/P1hJFIg/3
         w7YLTAoXpNPeXL1MHsK7bblW3EBJO6Y3YndIQCS6xMa/LNjUSh0KghMOiL4jmSAjbj
         r4A2aG8BfkxioYqsCUD31ZaSRNTpOFCiaX7R+pIJXL1KRz4emVrnC+2GaiDoM6RSkV
         8Y3h/rtLsABLc52lP7Q4cIbj+4hwx8xUyVXZd5fpHeZ9Te/B3BVo2sLkkg5vronaxc
         e8O9mJHrqwNrA==
Date:   Thu, 25 May 2023 18:29:50 -0700
Subject: [PATCH 1/3] xfs: support preallocating and copying content into
 temporary files
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506066025.3735250.12282984469411759541.stgit@frogsfrogsfrogs>
In-Reply-To: <168506066008.3735250.5566316565558388079.stgit@frogsfrogsfrogs>
References: <168506066008.3735250.5566316565558388079.stgit@frogsfrogsfrogs>
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

Create the routines we need to preallocate space in a temporary ondisk
file and then copy the contents of an xfile into the tempfile.  The
upcoming rtsummary repair feature will construct the contents of a
realtime summary file in memory, after which it will want to copy all
that into the ondisk temporary file before atomically committing the new
rtsummary contents.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/tempfile.c |  195 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/tempfile.h |   15 ++++
 fs/xfs/scrub/trace.h    |   39 +++++++++
 3 files changed, 249 insertions(+)


diff --git a/fs/xfs/scrub/tempfile.c b/fs/xfs/scrub/tempfile.c
index e7179243f56f..ef8e3f175786 100644
--- a/fs/xfs/scrub/tempfile.c
+++ b/fs/xfs/scrub/tempfile.c
@@ -14,14 +14,18 @@
 #include "xfs_inode.h"
 #include "xfs_ialloc.h"
 #include "xfs_quota.h"
+#include "xfs_bmap.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_trans_space.h"
 #include "xfs_dir2.h"
 #include "xfs_xchgrange.h"
+#include "xfs_defer.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
+#include "scrub/repair.h"
 #include "scrub/trace.h"
 #include "scrub/tempfile.h"
+#include "scrub/xfile.h"
 
 /*
  * Create a temporary file for reconstructing metadata, with the intention of
@@ -249,3 +253,194 @@ xrep_tempfile_rele(
 	xchk_irele(sc, sc->tempip);
 	sc->tempip = NULL;
 }
+
+/*
+ * Make sure that the given range of the data fork of the temporary file is
+ * mapped to written blocks.  The caller must ensure that both inodes are
+ * joined to the transaction.
+ */
+int
+xrep_tempfile_prealloc(
+	struct xfs_scrub	*sc,
+	xfs_fileoff_t		off,
+	xfs_filblks_t		len)
+{
+	struct xfs_bmbt_irec	map;
+	xfs_fileoff_t		end = off + len;
+	int			error;
+
+	ASSERT(sc->tempip != NULL);
+	ASSERT(!XFS_NOT_DQATTACHED(sc->mp, sc->tempip));
+
+	for (; off < end; off = map.br_startoff + map.br_blockcount) {
+		int		nmaps = 1;
+
+		/*
+		 * If we have a real extent mapping this block then we're
+		 * in ok shape.
+		 */
+		error = xfs_bmapi_read(sc->tempip, off, end - off, &map, &nmaps,
+				XFS_DATA_FORK);
+		if (error)
+			return error;
+		if (nmaps == 0) {
+			ASSERT(nmaps != 0);
+			return -EFSCORRUPTED;
+		}
+
+		if (xfs_bmap_is_written_extent(&map))
+			continue;
+
+		/*
+		 * If we find a delalloc reservation then something is very
+		 * very wrong.  Bail out.
+		 */
+		if (map.br_startblock == DELAYSTARTBLOCK)
+			return -EFSCORRUPTED;
+
+		/*
+		 * Make sure this block has a real zeroed extent allocated to
+		 * it.
+		 */
+		nmaps = 1;
+		error = xfs_bmapi_write(sc->tp, sc->tempip, off, end - off,
+				XFS_BMAPI_CONVERT | XFS_BMAPI_ZERO, 0, &map,
+				&nmaps);
+		if (error)
+			return error;
+
+		trace_xrep_tempfile_prealloc(sc, XFS_DATA_FORK, &map);
+
+		/* Commit new extent and all deferred work. */
+		error = xfs_defer_finish(&sc->tp);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
+
+/*
+ * Write data to each block of a file.  The given range of the tempfile's data
+ * fork must already be populated with written extents.
+ */
+int
+xrep_tempfile_copyin(
+	struct xfs_scrub	*sc,
+	xfs_fileoff_t		off,
+	xfs_filblks_t		len,
+	xrep_tempfile_copyin_fn	prep_fn,
+	void			*data)
+{
+	LIST_HEAD(buffers_list);
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_buf		*bp;
+	xfs_fileoff_t		flush_mask;
+	xfs_fileoff_t		end = off + len;
+	loff_t			pos = XFS_FSB_TO_B(mp, off);
+	int			error = 0;
+
+	ASSERT(S_ISREG(VFS_I(sc->tempip)->i_mode));
+
+	/* Flush buffers to disk every 512K */
+	flush_mask = XFS_B_TO_FSBT(mp, (1U << 19)) - 1;
+
+	for (; off < end; off++, pos += mp->m_sb.sb_blocksize) {
+		struct xfs_bmbt_irec	map;
+		int			nmaps = 1;
+
+		/* Read block mapping for this file block. */
+		error = xfs_bmapi_read(sc->tempip, off, 1, &map, &nmaps, 0);
+		if (error)
+			goto out_err;
+		if (nmaps == 0 || !xfs_bmap_is_written_extent(&map)) {
+			error = -EFSCORRUPTED;
+			goto out_err;
+		}
+
+		/* Get the metadata buffer for this offset in the file. */
+		error = xfs_trans_get_buf(sc->tp, mp->m_ddev_targp,
+				XFS_FSB_TO_DADDR(mp, map.br_startblock),
+				mp->m_bsize, 0, &bp);
+		if (error)
+			goto out_err;
+
+		trace_xrep_tempfile_copyin(sc, XFS_DATA_FORK, &map);
+
+		/* Read in a block's worth of data from the xfile. */
+		error = prep_fn(sc, bp, data);
+		if (error) {
+			xfs_trans_brelse(sc->tp, bp);
+			goto out_err;
+		}
+
+		/* Queue buffer, and flush if we have too much dirty data. */
+		xfs_buf_delwri_queue_here(bp, &buffers_list);
+		xfs_trans_brelse(sc->tp, bp);
+
+		if (!(off & flush_mask)) {
+			error = xfs_buf_delwri_submit(&buffers_list);
+			if (error)
+				goto out_err;
+		}
+	}
+
+	/*
+	 * Write the new blocks to disk.  If the ordered list isn't empty after
+	 * that, then something went wrong and we have to fail.  This should
+	 * never happen, but we'll check anyway.
+	 */
+	error = xfs_buf_delwri_submit(&buffers_list);
+	if (error)
+		goto out_err;
+
+	if (!list_empty(&buffers_list)) {
+		ASSERT(list_empty(&buffers_list));
+		error = -EIO;
+		goto out_err;
+	}
+
+	return 0;
+
+out_err:
+	xfs_buf_delwri_cancel(&buffers_list);
+	return error;
+}
+
+/*
+ * Set the temporary file's size.  Caller must join the tempfile to the scrub
+ * transaction and is responsible for adjusting block mappings as needed.
+ */
+int
+xrep_tempfile_set_isize(
+	struct xfs_scrub	*sc,
+	unsigned long long	isize)
+{
+	if (sc->tempip->i_disk_size == isize)
+		return 0;
+
+	sc->tempip->i_disk_size = isize;
+	i_size_write(VFS_I(sc->tempip), isize);
+	return xrep_tempfile_roll_trans(sc);
+}
+
+/*
+ * Roll a repair transaction involving the temporary file.  Caller must join
+ * both the temporary file and the file being scrubbed to the transaction.
+ * This function return with both inodes joined to a new scrub transaction,
+ * or the usual negative errno.
+ */
+int
+xrep_tempfile_roll_trans(
+	struct xfs_scrub	*sc)
+{
+	int			error;
+
+	xfs_trans_log_inode(sc->tp, sc->tempip, XFS_ILOG_CORE);
+	error = xrep_roll_trans(sc);
+	if (error)
+		return error;
+
+	xfs_trans_ijoin(sc->tp, sc->tempip, 0);
+	return 0;
+}
diff --git a/fs/xfs/scrub/tempfile.h b/fs/xfs/scrub/tempfile.h
index c85e56148e47..e7be1d5f1f54 100644
--- a/fs/xfs/scrub/tempfile.h
+++ b/fs/xfs/scrub/tempfile.h
@@ -17,6 +17,21 @@ void xrep_tempfile_iounlock(struct xfs_scrub *sc);
 void xrep_tempfile_ilock(struct xfs_scrub *sc);
 bool xrep_tempfile_ilock_nowait(struct xfs_scrub *sc);
 void xrep_tempfile_iunlock(struct xfs_scrub *sc);
+
+int xrep_tempfile_prealloc(struct xfs_scrub *sc, xfs_fileoff_t off,
+		xfs_filblks_t len);
+
+enum xfs_blft;
+
+typedef int (*xrep_tempfile_copyin_fn)(struct xfs_scrub *sc,
+		struct xfs_buf *bp, void *data);
+
+int xrep_tempfile_copyin(struct xfs_scrub *sc, xfs_fileoff_t off,
+		xfs_filblks_t len, xrep_tempfile_copyin_fn fn, void *data);
+
+int xrep_tempfile_set_isize(struct xfs_scrub *sc, unsigned long long isize);
+
+int xrep_tempfile_roll_trans(struct xfs_scrub *sc);
 #else
 static inline void xrep_tempfile_iolock_both(struct xfs_scrub *sc)
 {
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 13a0a07e933f..5e3240910487 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2244,6 +2244,45 @@ TRACE_EVENT(xrep_tempfile_create,
 		  __entry->temp_inum)
 );
 
+DECLARE_EVENT_CLASS(xrep_tempfile_class,
+	TP_PROTO(struct xfs_scrub *sc, int whichfork,
+		 struct xfs_bmbt_irec *irec),
+	TP_ARGS(sc, whichfork, irec),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(int, whichfork)
+		__field(xfs_fileoff_t, lblk)
+		__field(xfs_filblks_t, len)
+		__field(xfs_fsblock_t, pblk)
+		__field(int, state)
+	),
+	TP_fast_assign(
+		__entry->dev = sc->mp->m_super->s_dev;
+		__entry->ino = sc->tempip->i_ino;
+		__entry->whichfork = whichfork;
+		__entry->lblk = irec->br_startoff;
+		__entry->len = irec->br_blockcount;
+		__entry->pblk = irec->br_startblock;
+		__entry->state = irec->br_state;
+	),
+	TP_printk("dev %d:%d ino 0x%llx whichfork %s fileoff 0x%llx fsbcount 0x%llx startblock 0x%llx state %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __print_symbolic(__entry->whichfork, XFS_WHICHFORK_STRINGS),
+		  __entry->lblk,
+		  __entry->len,
+		  __entry->pblk,
+		  __entry->state)
+);
+#define DEFINE_XREP_TEMPFILE_EVENT(name) \
+DEFINE_EVENT(xrep_tempfile_class, name, \
+	TP_PROTO(struct xfs_scrub *sc, int whichfork, \
+		 struct xfs_bmbt_irec *irec), \
+	TP_ARGS(sc, whichfork, irec))
+DEFINE_XREP_TEMPFILE_EVENT(xrep_tempfile_prealloc);
+DEFINE_XREP_TEMPFILE_EVENT(xrep_tempfile_copyin);
+
 TRACE_EVENT(xreap_ifork_extent,
 	TP_PROTO(struct xfs_scrub *sc, struct xfs_inode *ip, int whichfork,
 		 const struct xfs_bmbt_irec *irec),

