Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9866D1B4C37
	for <lists+linux-xfs@lfdr.de>; Wed, 22 Apr 2020 19:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726066AbgDVRyg (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 22 Apr 2020 13:54:36 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:48277 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726060AbgDVRyg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Apr 2020 13:54:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587578074;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4x9WzDng92B/epGaojhJRMmAmSEM4p8Raw6ozrFtx8k=;
        b=eDBXCwRcT50dt/fVovvBo11EMJgHV+hXzQzu/yNhcdBAOXxhs6mDJiMMk0LOvhEGTMnvEd
        aZCMeZoKQJJ9liw5xjBBVLTebLhWphXm0KtFfdnVfnjhklFCoEcwUflR7EXQh84hLFCzgt
        NJlqHApGfltiweHr41wGSTlomVW+auI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-432-FQYlCNjoNKqougqxIjjK_A-1; Wed, 22 Apr 2020 13:54:32 -0400
X-MC-Unique: FQYlCNjoNKqougqxIjjK_A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C6261107ACCC
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 17:54:31 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 81B776084C
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 17:54:31 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 03/13] xfs: fallthru to buffer attach on error and simplify error handling
Date:   Wed, 22 Apr 2020 13:54:19 -0400
Message-Id: <20200422175429.38957-4-bfoster@redhat.com>
In-Reply-To: <20200422175429.38957-1-bfoster@redhat.com>
References: <20200422175429.38957-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The inode flush code has several layers of error handling between
the inode and cluster flushing code. If the inode flush fails before
acquiring the backing buffer, the inode flush is aborted. If the
cluster flush fails, the current inode flush is aborted and the
cluster buffer is failed to handle the initial inode and any others
that might have been attached before the error.

Since xfs_iflush() is the only caller of xfs_iflush_cluster(), the
error handling between the two can be condensed in the top-level
function. If we update xfs_iflush_int() to always fall through to
the log item update and attach the item completion handler to the
buffer, any errors that occur after the first call to
xfs_iflush_int() can be handled with a buffer I/O failure.

Lift the error handling from xfs_iflush_cluster() into xfs_iflush()
and consolidate with the existing error handling. This also replaces
the need to release the buffer because failing the buffer with
XBF_ASYNC drops the current reference.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_inode.c | 108 ++++++++++++++++-----------------------------
 1 file changed, 38 insertions(+), 70 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 1aea19ca6601..6cdb9fbe2d89 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -3496,6 +3496,7 @@ xfs_iflush_cluster(
 	struct xfs_inode	**cilist;
 	struct xfs_inode	*cip;
 	struct xfs_ino_geometry	*igeo =3D M_IGEO(mp);
+	int			error =3D 0;
 	int			nr_found;
 	int			clcount =3D 0;
 	int			i;
@@ -3588,11 +3589,10 @@ xfs_iflush_cluster(
 		 * re-check that it's dirty before flushing.
 		 */
 		if (!xfs_inode_clean(cip)) {
-			int	error;
 			error =3D xfs_iflush_int(cip, bp);
 			if (error) {
 				xfs_iunlock(cip, XFS_ILOCK_SHARED);
-				goto cluster_corrupt_out;
+				goto out_free;
 			}
 			clcount++;
 		} else {
@@ -3611,32 +3611,7 @@ xfs_iflush_cluster(
 	kmem_free(cilist);
 out_put:
 	xfs_perag_put(pag);
-	return 0;
-
-
-cluster_corrupt_out:
-	/*
-	 * Corruption detected in the clustering loop.  Invalidate the
-	 * inode buffer and shut down the filesystem.
-	 */
-	rcu_read_unlock();
-
-	/*
-	 * We'll always have an inode attached to the buffer for completion
-	 * process by the time we are called from xfs_iflush(). Hence we have
-	 * always need to do IO completion processing to abort the inodes
-	 * attached to the buffer.  handle them just like the shutdown case in
-	 * xfs_buf_submit().
-	 */
-	ASSERT(bp->b_iodone);
-	xfs_buf_ioend_fail(bp, XBF_ASYNC);
-	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
-
-	/* abort the corrupt inode, as it was not attached to the buffer */
-	xfs_iflush_abort(cip, false);
-	kmem_free(cilist);
-	xfs_perag_put(pag);
-	return -EFSCORRUPTED;
+	return error;
 }
=20
 /*
@@ -3692,17 +3667,16 @@ xfs_iflush(
 	 */
 	if (XFS_FORCED_SHUTDOWN(mp)) {
 		error =3D -EIO;
-		goto abort_out;
+		goto abort;
 	}
=20
 	/*
 	 * Get the buffer containing the on-disk inode. We are doing a try-lock
-	 * operation here, so we may get  an EAGAIN error. In that case, we
-	 * simply want to return with the inode still dirty.
+	 * operation here, so we may get an EAGAIN error. In that case, return
+	 * leaving the inode dirty.
 	 *
 	 * If we get any other error, we effectively have a corruption situatio=
n
-	 * and we cannot flush the inode, so we treat it the same as failing
-	 * xfs_iflush_int().
+	 * and we cannot flush the inode. Abort the flush and shut down.
 	 */
 	error =3D xfs_imap_to_bp(mp, NULL, &ip->i_imap, &dip, &bp, XBF_TRYLOCK,
 			       0);
@@ -3711,14 +3685,7 @@ xfs_iflush(
 		return error;
 	}
 	if (error)
-		goto corrupt_out;
-
-	/*
-	 * First flush out the inode that xfs_iflush was called with.
-	 */
-	error =3D xfs_iflush_int(ip, bp);
-	if (error)
-		goto corrupt_out;
+		goto abort;
=20
 	/*
 	 * If the buffer is pinned then push on the log now so we won't
@@ -3728,28 +3695,28 @@ xfs_iflush(
 		xfs_log_force(mp, 0);
=20
 	/*
-	 * inode clustering: try to gather other inodes into this write
+	 * Flush the provided inode then attempt to gather others from the
+	 * cluster into the write.
 	 *
-	 * Note: Any error during clustering will result in the filesystem
-	 * being shut down and completion callbacks run on the cluster buffer.
-	 * As we have already flushed and attached this inode to the buffer,
-	 * it has already been aborted and released by xfs_iflush_cluster() and
-	 * so we have no further error handling to do here.
+	 * Note: Once we attempt to flush an inode, we must run buffer
+	 * completion callbacks on any failure. If this fails, simulate an I/O
+	 * failure on the buffer and shut down.
 	 */
-	error =3D xfs_iflush_cluster(ip, bp);
-	if (error)
-		return error;
+	error =3D xfs_iflush_int(ip, bp);
+	if (!error)
+		error =3D xfs_iflush_cluster(ip, bp);
+	if (error) {
+		xfs_buf_ioend_fail(bp, XBF_ASYNC);
+		goto shutdown;
+	}
=20
 	*bpp =3D bp;
 	return 0;
=20
-corrupt_out:
-	if (bp)
-		xfs_buf_relse(bp);
-	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
-abort_out:
-	/* abort the corrupt inode, as it was not attached to the buffer */
+abort:
 	xfs_iflush_abort(ip, false);
+shutdown:
+	xfs_force_shutdown(mp, SHUTDOWN_CORRUPT_INCORE);
 	return error;
 }
=20
@@ -3791,6 +3758,7 @@ xfs_iflush_int(
 	struct xfs_inode_log_item *iip =3D ip->i_itemp;
 	struct xfs_dinode	*dip;
 	struct xfs_mount	*mp =3D ip->i_mount;
+	int			error;
=20
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
 	ASSERT(xfs_isiflocked(ip));
@@ -3801,12 +3769,13 @@ xfs_iflush_int(
 	/* set *dip =3D inode's place in the buffer */
 	dip =3D xfs_buf_offset(bp, ip->i_imap.im_boffset);
=20
+	error =3D -EFSCORRUPTED;
 	if (XFS_TEST_ERROR(dip->di_magic !=3D cpu_to_be16(XFS_DINODE_MAGIC),
 			       mp, XFS_ERRTAG_IFLUSH_1)) {
 		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
 			"%s: Bad inode %Lu magic number 0x%x, ptr "PTR_FMT,
 			__func__, ip->i_ino, be16_to_cpu(dip->di_magic), dip);
-		goto corrupt_out;
+		goto flush_out;
 	}
 	if (S_ISREG(VFS_I(ip)->i_mode)) {
 		if (XFS_TEST_ERROR(
@@ -3816,7 +3785,7 @@ xfs_iflush_int(
 			xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
 				"%s: Bad regular inode %Lu, ptr "PTR_FMT,
 				__func__, ip->i_ino, ip);
-			goto corrupt_out;
+			goto flush_out;
 		}
 	} else if (S_ISDIR(VFS_I(ip)->i_mode)) {
 		if (XFS_TEST_ERROR(
@@ -3827,7 +3796,7 @@ xfs_iflush_int(
 			xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
 				"%s: Bad directory inode %Lu, ptr "PTR_FMT,
 				__func__, ip->i_ino, ip);
-			goto corrupt_out;
+			goto flush_out;
 		}
 	}
 	if (XFS_TEST_ERROR(ip->i_d.di_nextents + ip->i_d.di_anextents >
@@ -3838,14 +3807,14 @@ xfs_iflush_int(
 			__func__, ip->i_ino,
 			ip->i_d.di_nextents + ip->i_d.di_anextents,
 			ip->i_d.di_nblocks, ip);
-		goto corrupt_out;
+		goto flush_out;
 	}
 	if (XFS_TEST_ERROR(ip->i_d.di_forkoff > mp->m_sb.sb_inodesize,
 				mp, XFS_ERRTAG_IFLUSH_6)) {
 		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
 			"%s: bad inode %Lu, forkoff 0x%x, ptr "PTR_FMT,
 			__func__, ip->i_ino, ip->i_d.di_forkoff, ip);
-		goto corrupt_out;
+		goto flush_out;
 	}
=20
 	/*
@@ -3862,7 +3831,7 @@ xfs_iflush_int(
=20
 	/* Check the inline fork data before we write out. */
 	if (!xfs_inode_verify_forks(ip))
-		goto corrupt_out;
+		goto flush_out;
=20
 	/*
 	 * Copy the dirty parts of the inode into the on-disk inode.  We always
@@ -3905,6 +3874,8 @@ xfs_iflush_int(
 	 * need the AIL lock, because it is a 64 bit value that cannot be read
 	 * atomically.
 	 */
+	error =3D 0;
+flush_out:
 	iip->ili_last_fields =3D iip->ili_fields;
 	iip->ili_fields =3D 0;
 	iip->ili_fsync_fields =3D 0;
@@ -3914,10 +3885,10 @@ xfs_iflush_int(
 				&iip->ili_item.li_lsn);
=20
 	/*
-	 * Attach the function xfs_iflush_done to the inode's
-	 * buffer.  This will remove the inode from the AIL
-	 * and unlock the inode's flush lock when the inode is
-	 * completely written to disk.
+	 * Attach the inode item callback to the buffer whether the flush
+	 * succeeded or not. If not, the caller will shut down and fail I/O
+	 * completion on the buffer to remove the inode from the AIL and releas=
e
+	 * the flush lock.
 	 */
 	xfs_buf_attach_iodone(bp, xfs_iflush_done, &iip->ili_item);
=20
@@ -3926,10 +3897,7 @@ xfs_iflush_int(
=20
 	ASSERT(!list_empty(&bp->b_li_list));
 	ASSERT(bp->b_iodone !=3D NULL);
-	return 0;
-
-corrupt_out:
-	return -EFSCORRUPTED;
+	return error;
 }
=20
 /* Release an inode. */
--=20
2.21.1

