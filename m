Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71569319634
	for <lists+linux-xfs@lfdr.de>; Fri, 12 Feb 2021 00:01:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbhBKXA2 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 11 Feb 2021 18:00:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:46062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229960AbhBKXA0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Feb 2021 18:00:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C89D664E4D;
        Thu, 11 Feb 2021 22:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613084381;
        bh=kshpFGwnWZ8RSpTHePwMTNzZQ6gGQi/ujxZCcp8l1uI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=qrB1/N6Rfodz/UmngCCYoCke2IH00IO4MpXTDLjN1TGa/18/aul5WGps9NGlUe/Rc
         IT00lVMNmy6HOGFAjnf829cY7TY0JG366dVNDrM8zBIp8Gly8902QFMSx7fik+zVn8
         mLdDefeA2OTpoOjZ67z9ebbUMvDpM2LebnpmkiNXVBYZ/8giaK17F0vZMrKpicbNsw
         FcAWQjBg5jUI6OdGWbcxj9QdEd+UMkjjBIu33ZlUFg978GSxR0Wt3F4gG3BQwyLKXX
         BorlktSYhLcOBQsBLD9H7WOPtLKxs9r8pxLbL8yFl9EFuTSBrFgPLgvnw0S6LMyPn5
         fs6l58e2hgv+w==
Subject: [PATCH 07/11] xfs_repair: clear the needsrepair flag
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Thu, 11 Feb 2021 14:59:41 -0800
Message-ID: <161308438117.3850286.9338169953118054325.stgit@magnolia>
In-Reply-To: <161308434132.3850286.13801623440532587184.stgit@magnolia>
References: <161308434132.3850286.13801623440532587184.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Clear the needsrepair flag, since it's used to prevent mounting of an
inconsistent filesystem.  We only do this if we make it to the end of
repair with a non-zero error code, and all the rebuilt indices and
corrected metadata are persisted correctly.

Note that we cannot combine clearing needsrepair with clearing the quota
checked flags because we need to clear the quota flags even if
reformatting the log fails, whereas we can't clear needsrepair if the
log reformat fails.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 include/xfs_mount.h |    1 +
 libxfs/init.c       |   20 +++++++++++++-------
 repair/agheader.c   |   21 +++++++++++++++++++++
 repair/xfs_repair.c |   42 ++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 77 insertions(+), 7 deletions(-)


diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 36594643..75230ca5 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -181,6 +181,7 @@ xfs_perag_resv(
 
 extern xfs_mount_t	*libxfs_mount (xfs_mount_t *, xfs_sb_t *,
 				dev_t, dev_t, dev_t, int);
+int libxfs_flush_mount(struct xfs_mount *mp);
 int		libxfs_umount(struct xfs_mount *mp);
 extern void	libxfs_rtmount_destroy (xfs_mount_t *);
 
diff --git a/libxfs/init.c b/libxfs/init.c
index 9fe13b8d..8a8ce3c4 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -870,7 +870,7 @@ _("%s: Flushing the %s failed, err=%d!\n"),
  * Flush all dirty buffers to stable storage and report on writes that didn't
  * make it to stable storage.
  */
-static int
+int
 libxfs_flush_mount(
 	struct xfs_mount	*mp)
 {
@@ -878,13 +878,13 @@ libxfs_flush_mount(
 	int			err2;
 
 	/*
-	 * Purge the buffer cache to write all dirty buffers to disk and free
-	 * all incore buffers.  Buffers that fail write verification will cause
-	 * the CORRUPT_WRITE flag to be set in the buftarg.  Buffers that
-	 * cannot be written will cause the LOST_WRITE flag to be set in the
-	 * buftarg.
+	 * Flush the buffer cache to write all dirty buffers to disk.  Buffers
+	 * that fail write verification will cause the CORRUPT_WRITE flag to be
+	 * set in the buftarg.  Buffers that cannot be written will cause the
+	 * LOST_WRITE flag to be set in the buftarg.  Once that's done,
+	 * instruct the disks to persist their write caches.
 	 */
-	libxfs_bcache_purge();
+	libxfs_bcache_flush();
 
 	/* Flush all kernel and disk write caches, and report failures. */
 	if (mp->m_ddev_targp) {
@@ -923,6 +923,12 @@ libxfs_umount(
 
 	libxfs_rtmount_destroy(mp);
 
+	/*
+	 * Purge the buffer cache to write all dirty buffers to disk and free
+	 * all incore buffers, then pick up the outcome when we tell the disks
+	 * to persist their write caches.
+	 */
+	libxfs_bcache_purge();
 	error = libxfs_flush_mount(mp);
 
 	for (agno = 0; agno < mp->m_maxagi; agno++) {
diff --git a/repair/agheader.c b/repair/agheader.c
index 8bb99489..2af24106 100644
--- a/repair/agheader.c
+++ b/repair/agheader.c
@@ -452,6 +452,27 @@ secondary_sb_whack(
 			rval |= XR_AG_SB_SEC;
 	}
 
+	if (xfs_sb_version_needsrepair(sb)) {
+		if (i == 0) {
+			if (!no_modify)
+				do_warn(
+	_("clearing needsrepair flag and regenerating metadata\n"));
+			else
+				do_warn(
+	_("would clear needsrepair flag and regenerate metadata\n"));
+		} else {
+			/*
+			 * Quietly clear needsrepair on the secondary supers as
+			 * part of ensuring them.  If needsrepair is set on the
+			 * primary, it will be cleared at the end of repair
+			 * once we've flushed all other dirty blocks to disk.
+			 */
+			sb->sb_features_incompat &=
+					~XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+			rval |= XR_AG_SB_SEC;
+		}
+	}
+
 	return(rval);
 }
 
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 40352458..90d1a95a 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -712,6 +712,45 @@ check_fs_vs_host_sectsize(
 	}
 }
 
+/* Clear needsrepair after a successful repair run. */
+void
+clear_needsrepair(
+	struct xfs_mount	*mp)
+{
+	struct xfs_buf		*bp;
+	int			error;
+
+	/*
+	 * If we're going to clear NEEDSREPAIR, we need to make absolutely sure
+	 * that everything is ok with the ondisk filesystem.  Make sure any
+	 * dirty buffers are sent to disk and that the disks have persisted
+	 * writes to stable storage.  If that fails, leave NEEDSREPAIR in
+	 * place.  Don't purge the buffer cache here since we're not done yet.
+	 */
+	error = -libxfs_flush_mount(mp);
+	if (error) {
+		do_warn(
+	_("Cannot clear needsrepair due to flush failure, err=%d.\n"),
+			error);
+		return;
+	}
+
+	/* Clear needsrepair from the superblock. */
+	bp = libxfs_getsb(mp);
+	if (!bp || bp->b_error) {
+		do_warn(
+	_("Cannot clear needsrepair from primary super, err=%d.\n"),
+			bp ? bp->b_error : ENOMEM);
+	} else {
+		mp->m_sb.sb_features_incompat &=
+				~XFS_SB_FEAT_INCOMPAT_NEEDSREPAIR;
+		libxfs_sb_to_disk(bp->b_addr, &mp->m_sb);
+		libxfs_buf_mark_dirty(bp);
+	}
+	if (bp)
+		libxfs_buf_relse(bp);
+}
+
 int
 main(int argc, char **argv)
 {
@@ -1128,6 +1167,9 @@ _("Note - stripe unit (%d) and width (%d) were copied from a backup superblock.\
 	libxfs_bcache_flush();
 	format_log_max_lsn(mp);
 
+	if (xfs_sb_version_needsrepair(&mp->m_sb))
+		clear_needsrepair(mp);
+
 	/* Report failure if anything failed to get written to our fs. */
 	error = -libxfs_umount(mp);
 	if (error)

