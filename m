Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AFC6DD92C
	for <lists+linux-xfs@lfdr.de>; Sat, 19 Oct 2019 16:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbfJSOpT (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sat, 19 Oct 2019 10:45:19 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:43154 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbfJSOpT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 19 Oct 2019 10:45:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=uU8DwMOWf+Mr7ERk4c+5ecoPI49p3r8VqPiRezZurCI=; b=Bc6t2YNcNqBxQ1w89DqQCrLbdN
        hvIkHfeLUSfGC2LxG2gg+FIuEchH4PBmQleH3bp472bEifaOPIvWTu0akR6/pqnHZ8tZN8DcNSKzD
        tMIXy7Y7Jd4YyWyJuzZqVUqrgLSqkXnWK6nwmnWHPcv7eiRhOrJJYPwnyrCSrYW94XORll+awdspp
        ikYRbAcB3YhUa7sk5w/F5j0kcLdmREwnpd4QmQwJwNkQJjBdf9KzIdsKs1D+DlLfnB1zcXWuhr/Ej
        jYbaqiPMGpa7cr7amgSj4t+7BmI6H48VLND7L2p3DZsk+/0NQms7L6MLOhC3+cG1eSvbgrPIVhW17
        7PoW+Hgg==;
Received: from [2001:4bb8:18c:d7b:c70:4a89:bc61:3] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iLpyo-0003A9-HZ; Sat, 19 Oct 2019 14:45:19 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Goldwyn Rodrigues <rgoldwyn@suse.com>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 08/12] xfs: move xfs_file_iomap_begin_delay around
Date:   Sat, 19 Oct 2019 16:44:44 +0200
Message-Id: <20191019144448.21483-9-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191019144448.21483-1-hch@lst.de>
References: <20191019144448.21483-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Move xfs_file_iomap_begin_delay near the end of the file next to the
other iomap functions to prepare for additional refactoring.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_iomap.c | 434 +++++++++++++++++++++++----------------------
 1 file changed, 221 insertions(+), 213 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 3bd1f7d62f4c..bbe0ca4ff10d 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -530,219 +530,6 @@ xfs_iomap_prealloc_size(
 	return alloc_blocks;
 }
 
-static int
-xfs_file_iomap_begin_delay(
-	struct inode		*inode,
-	loff_t			offset,
-	loff_t			count,
-	unsigned		flags,
-	struct iomap		*iomap,
-	struct iomap		*srcmap)
-{
-	struct xfs_inode	*ip = XFS_I(inode);
-	struct xfs_mount	*mp = ip->i_mount;
-	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
-	xfs_fileoff_t		end_fsb = xfs_iomap_end_fsb(mp, offset, count);
-	struct xfs_bmbt_irec	imap, cmap;
-	struct xfs_iext_cursor	icur, ccur;
-	xfs_fsblock_t		prealloc_blocks = 0;
-	bool			eof = false, cow_eof = false, shared = false;
-	int			whichfork = XFS_DATA_FORK;
-	int			error = 0;
-
-	ASSERT(!XFS_IS_REALTIME_INODE(ip));
-	ASSERT(!xfs_get_extsz_hint(ip));
-
-	xfs_ilock(ip, XFS_ILOCK_EXCL);
-
-	if (unlikely(XFS_TEST_ERROR(
-	    (XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) != XFS_DINODE_FMT_EXTENTS &&
-	     XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) != XFS_DINODE_FMT_BTREE),
-	     mp, XFS_ERRTAG_BMAPIFORMAT))) {
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
-		error = -EFSCORRUPTED;
-		goto out_unlock;
-	}
-
-	XFS_STATS_INC(mp, xs_blk_mapw);
-
-	if (!(ip->i_df.if_flags & XFS_IFEXTENTS)) {
-		error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
-		if (error)
-			goto out_unlock;
-	}
-
-	/*
-	 * Search the data fork fork first to look up our source mapping.  We
-	 * always need the data fork map, as we have to return it to the
-	 * iomap code so that the higher level write code can read data in to
-	 * perform read-modify-write cycles for unaligned writes.
-	 */
-	eof = !xfs_iext_lookup_extent(ip, &ip->i_df, offset_fsb, &icur, &imap);
-	if (eof)
-		imap.br_startoff = end_fsb; /* fake hole until the end */
-
-	/* We never need to allocate blocks for zeroing a hole. */
-	if ((flags & IOMAP_ZERO) && imap.br_startoff > offset_fsb) {
-		xfs_hole_to_iomap(ip, iomap, offset_fsb, imap.br_startoff);
-		goto out_unlock;
-	}
-
-	/*
-	 * Search the COW fork extent list even if we did not find a data fork
-	 * extent.  This serves two purposes: first this implements the
-	 * speculative preallocation using cowextsize, so that we also unshare
-	 * block adjacent to shared blocks instead of just the shared blocks
-	 * themselves.  Second the lookup in the extent list is generally faster
-	 * than going out to the shared extent tree.
-	 */
-	if (xfs_is_cow_inode(ip)) {
-		if (!ip->i_cowfp) {
-			ASSERT(!xfs_is_reflink_inode(ip));
-			xfs_ifork_init_cow(ip);
-		}
-		cow_eof = !xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb,
-				&ccur, &cmap);
-		if (!cow_eof && cmap.br_startoff <= offset_fsb) {
-			trace_xfs_reflink_cow_found(ip, &cmap);
-			goto found_cow;
-		}
-	}
-
-	if (imap.br_startoff <= offset_fsb) {
-		/*
-		 * For reflink files we may need a delalloc reservation when
-		 * overwriting shared extents.   This includes zeroing of
-		 * existing extents that contain data.
-		 */
-		if (!xfs_is_cow_inode(ip) ||
-		    ((flags & IOMAP_ZERO) && imap.br_state != XFS_EXT_NORM)) {
-			trace_xfs_iomap_found(ip, offset, count, XFS_DATA_FORK,
-					&imap);
-			goto found_imap;
-		}
-
-		xfs_trim_extent(&imap, offset_fsb, end_fsb - offset_fsb);
-
-		/* Trim the mapping to the nearest shared extent boundary. */
-		error = xfs_inode_need_cow(ip, &imap, &shared);
-		if (error)
-			goto out_unlock;
-
-		/* Not shared?  Just report the (potentially capped) extent. */
-		if (!shared) {
-			trace_xfs_iomap_found(ip, offset, count, XFS_DATA_FORK,
-					&imap);
-			goto found_imap;
-		}
-
-		/*
-		 * Fork all the shared blocks from our write offset until the
-		 * end of the extent.
-		 */
-		whichfork = XFS_COW_FORK;
-		end_fsb = imap.br_startoff + imap.br_blockcount;
-	} else {
-		/*
-		 * We cap the maximum length we map here to MAX_WRITEBACK_PAGES
-		 * pages to keep the chunks of work done where somewhat
-		 * symmetric with the work writeback does.  This is a completely
-		 * arbitrary number pulled out of thin air.
-		 *
-		 * Note that the values needs to be less than 32-bits wide until
-		 * the lower level functions are updated.
-		 */
-		count = min_t(loff_t, count, 1024 * PAGE_SIZE);
-		end_fsb = xfs_iomap_end_fsb(mp, offset, count);
-
-		if (xfs_is_always_cow_inode(ip))
-			whichfork = XFS_COW_FORK;
-	}
-
-	error = xfs_qm_dqattach_locked(ip, false);
-	if (error)
-		goto out_unlock;
-
-	if (eof) {
-		prealloc_blocks = xfs_iomap_prealloc_size(ip, whichfork, offset,
-				count, &icur);
-		if (prealloc_blocks) {
-			xfs_extlen_t	align;
-			xfs_off_t	end_offset;
-			xfs_fileoff_t	p_end_fsb;
-
-			end_offset = XFS_WRITEIO_ALIGN(mp, offset + count - 1);
-			p_end_fsb = XFS_B_TO_FSBT(mp, end_offset) +
-					prealloc_blocks;
-
-			align = xfs_eof_alignment(ip, 0);
-			if (align)
-				p_end_fsb = roundup_64(p_end_fsb, align);
-
-			p_end_fsb = min(p_end_fsb,
-				XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes));
-			ASSERT(p_end_fsb > offset_fsb);
-			prealloc_blocks = p_end_fsb - end_fsb;
-		}
-	}
-
-retry:
-	error = xfs_bmapi_reserve_delalloc(ip, whichfork, offset_fsb,
-			end_fsb - offset_fsb, prealloc_blocks,
-			whichfork == XFS_DATA_FORK ? &imap : &cmap,
-			whichfork == XFS_DATA_FORK ? &icur : &ccur,
-			whichfork == XFS_DATA_FORK ? eof : cow_eof);
-	switch (error) {
-	case 0:
-		break;
-	case -ENOSPC:
-	case -EDQUOT:
-		/* retry without any preallocation */
-		trace_xfs_delalloc_enospc(ip, offset, count);
-		if (prealloc_blocks) {
-			prealloc_blocks = 0;
-			goto retry;
-		}
-		/*FALLTHRU*/
-	default:
-		goto out_unlock;
-	}
-
-	if (whichfork == XFS_COW_FORK) {
-		trace_xfs_iomap_alloc(ip, offset, count, whichfork, &cmap);
-		goto found_cow;
-	}
-
-	/*
-	 * Flag newly allocated delalloc blocks with IOMAP_F_NEW so we punch
-	 * them out if the write happens to fail.
-	 */
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	trace_xfs_iomap_alloc(ip, offset, count, whichfork, &imap);
-	return xfs_bmbt_to_iomap(ip, iomap, &imap, IOMAP_F_NEW);
-
-found_imap:
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	return xfs_bmbt_to_iomap(ip, iomap, &imap, 0);
-
-found_cow:
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	if (imap.br_startoff <= offset_fsb) {
-		error = xfs_bmbt_to_iomap(ip, srcmap, &imap, 0);
-		if (error)
-			return error;
-	} else {
-		xfs_trim_extent(&cmap, offset_fsb,
-				imap.br_startoff - offset_fsb);
-	}
-	return xfs_bmbt_to_iomap(ip, iomap, &cmap, IOMAP_F_SHARED);
-
-out_unlock:
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	return error;
-
-}
-
 int
 xfs_iomap_write_unwritten(
 	xfs_inode_t	*ip,
@@ -931,6 +718,15 @@ xfs_ilock_for_iomap(
 	return 0;
 }
 
+static int
+xfs_file_iomap_begin_delay(
+	struct inode		*inode,
+	loff_t			offset,
+	loff_t			count,
+	unsigned		flags,
+	struct iomap		*iomap,
+	struct iomap		*srcmap);
+
 static int
 xfs_file_iomap_begin(
 	struct inode		*inode,
@@ -1068,6 +864,218 @@ xfs_file_iomap_begin(
 	return error;
 }
 
+static int
+xfs_file_iomap_begin_delay(
+	struct inode		*inode,
+	loff_t			offset,
+	loff_t			count,
+	unsigned		flags,
+	struct iomap		*iomap,
+	struct iomap		*srcmap)
+{
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
+	xfs_fileoff_t		end_fsb = xfs_iomap_end_fsb(mp, offset, count);
+	struct xfs_bmbt_irec	imap, cmap;
+	struct xfs_iext_cursor	icur, ccur;
+	xfs_fsblock_t		prealloc_blocks = 0;
+	bool			eof = false, cow_eof = false, shared = false;
+	int			whichfork = XFS_DATA_FORK;
+	int			error = 0;
+
+	ASSERT(!XFS_IS_REALTIME_INODE(ip));
+	ASSERT(!xfs_get_extsz_hint(ip));
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+
+	if (unlikely(XFS_TEST_ERROR(
+	    (XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) != XFS_DINODE_FMT_EXTENTS &&
+	     XFS_IFORK_FORMAT(ip, XFS_DATA_FORK) != XFS_DINODE_FMT_BTREE),
+	     mp, XFS_ERRTAG_BMAPIFORMAT))) {
+		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_LOW, mp);
+		error = -EFSCORRUPTED;
+		goto out_unlock;
+	}
+
+	XFS_STATS_INC(mp, xs_blk_mapw);
+
+	if (!(ip->i_df.if_flags & XFS_IFEXTENTS)) {
+		error = xfs_iread_extents(NULL, ip, XFS_DATA_FORK);
+		if (error)
+			goto out_unlock;
+	}
+
+	/*
+	 * Search the data fork fork first to look up our source mapping.  We
+	 * always need the data fork map, as we have to return it to the
+	 * iomap code so that the higher level write code can read data in to
+	 * perform read-modify-write cycles for unaligned writes.
+	 */
+	eof = !xfs_iext_lookup_extent(ip, &ip->i_df, offset_fsb, &icur, &imap);
+	if (eof)
+		imap.br_startoff = end_fsb; /* fake hole until the end */
+
+	/* We never need to allocate blocks for zeroing a hole. */
+	if ((flags & IOMAP_ZERO) && imap.br_startoff > offset_fsb) {
+		xfs_hole_to_iomap(ip, iomap, offset_fsb, imap.br_startoff);
+		goto out_unlock;
+	}
+
+	/*
+	 * Search the COW fork extent list even if we did not find a data fork
+	 * extent.  This serves two purposes: first this implements the
+	 * speculative preallocation using cowextsize, so that we also unshare
+	 * block adjacent to shared blocks instead of just the shared blocks
+	 * themselves.  Second the lookup in the extent list is generally faster
+	 * than going out to the shared extent tree.
+	 */
+	if (xfs_is_cow_inode(ip)) {
+		if (!ip->i_cowfp) {
+			ASSERT(!xfs_is_reflink_inode(ip));
+			xfs_ifork_init_cow(ip);
+		}
+		cow_eof = !xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb,
+				&ccur, &cmap);
+		if (!cow_eof && cmap.br_startoff <= offset_fsb) {
+			trace_xfs_reflink_cow_found(ip, &cmap);
+			goto found_cow;
+		}
+	}
+
+	if (imap.br_startoff <= offset_fsb) {
+		/*
+		 * For reflink files we may need a delalloc reservation when
+		 * overwriting shared extents.   This includes zeroing of
+		 * existing extents that contain data.
+		 */
+		if (!xfs_is_cow_inode(ip) ||
+		    ((flags & IOMAP_ZERO) && imap.br_state != XFS_EXT_NORM)) {
+			trace_xfs_iomap_found(ip, offset, count, XFS_DATA_FORK,
+					&imap);
+			goto found_imap;
+		}
+
+		xfs_trim_extent(&imap, offset_fsb, end_fsb - offset_fsb);
+
+		/* Trim the mapping to the nearest shared extent boundary. */
+		error = xfs_inode_need_cow(ip, &imap, &shared);
+		if (error)
+			goto out_unlock;
+
+		/* Not shared?  Just report the (potentially capped) extent. */
+		if (!shared) {
+			trace_xfs_iomap_found(ip, offset, count, XFS_DATA_FORK,
+					&imap);
+			goto found_imap;
+		}
+
+		/*
+		 * Fork all the shared blocks from our write offset until the
+		 * end of the extent.
+		 */
+		whichfork = XFS_COW_FORK;
+		end_fsb = imap.br_startoff + imap.br_blockcount;
+	} else {
+		/*
+		 * We cap the maximum length we map here to MAX_WRITEBACK_PAGES
+		 * pages to keep the chunks of work done where somewhat
+		 * symmetric with the work writeback does.  This is a completely
+		 * arbitrary number pulled out of thin air.
+		 *
+		 * Note that the values needs to be less than 32-bits wide until
+		 * the lower level functions are updated.
+		 */
+		count = min_t(loff_t, count, 1024 * PAGE_SIZE);
+		end_fsb = xfs_iomap_end_fsb(mp, offset, count);
+
+		if (xfs_is_always_cow_inode(ip))
+			whichfork = XFS_COW_FORK;
+	}
+
+	error = xfs_qm_dqattach_locked(ip, false);
+	if (error)
+		goto out_unlock;
+
+	if (eof) {
+		prealloc_blocks = xfs_iomap_prealloc_size(ip, whichfork, offset,
+				count, &icur);
+		if (prealloc_blocks) {
+			xfs_extlen_t	align;
+			xfs_off_t	end_offset;
+			xfs_fileoff_t	p_end_fsb;
+
+			end_offset = XFS_WRITEIO_ALIGN(mp, offset + count - 1);
+			p_end_fsb = XFS_B_TO_FSBT(mp, end_offset) +
+					prealloc_blocks;
+
+			align = xfs_eof_alignment(ip, 0);
+			if (align)
+				p_end_fsb = roundup_64(p_end_fsb, align);
+
+			p_end_fsb = min(p_end_fsb,
+				XFS_B_TO_FSB(mp, mp->m_super->s_maxbytes));
+			ASSERT(p_end_fsb > offset_fsb);
+			prealloc_blocks = p_end_fsb - end_fsb;
+		}
+	}
+
+retry:
+	error = xfs_bmapi_reserve_delalloc(ip, whichfork, offset_fsb,
+			end_fsb - offset_fsb, prealloc_blocks,
+			whichfork == XFS_DATA_FORK ? &imap : &cmap,
+			whichfork == XFS_DATA_FORK ? &icur : &ccur,
+			whichfork == XFS_DATA_FORK ? eof : cow_eof);
+	switch (error) {
+	case 0:
+		break;
+	case -ENOSPC:
+	case -EDQUOT:
+		/* retry without any preallocation */
+		trace_xfs_delalloc_enospc(ip, offset, count);
+		if (prealloc_blocks) {
+			prealloc_blocks = 0;
+			goto retry;
+		}
+		/*FALLTHRU*/
+	default:
+		goto out_unlock;
+	}
+
+	if (whichfork == XFS_COW_FORK) {
+		trace_xfs_iomap_alloc(ip, offset, count, whichfork, &cmap);
+		goto found_cow;
+	}
+
+	/*
+	 * Flag newly allocated delalloc blocks with IOMAP_F_NEW so we punch
+	 * them out if the write happens to fail.
+	 */
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	trace_xfs_iomap_alloc(ip, offset, count, whichfork, &imap);
+	return xfs_bmbt_to_iomap(ip, iomap, &imap, IOMAP_F_NEW);
+
+found_imap:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return xfs_bmbt_to_iomap(ip, iomap, &imap, 0);
+
+found_cow:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	if (imap.br_startoff <= offset_fsb) {
+		error = xfs_bmbt_to_iomap(ip, srcmap, &imap, 0);
+		if (error)
+			return error;
+	} else {
+		xfs_trim_extent(&cmap, offset_fsb,
+				imap.br_startoff - offset_fsb);
+	}
+	return xfs_bmbt_to_iomap(ip, iomap, &cmap, IOMAP_F_SHARED);
+
+out_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	return error;
+}
+
 static int
 xfs_file_iomap_end_delalloc(
 	struct xfs_inode	*ip,
-- 
2.20.1

