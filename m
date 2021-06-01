Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E400392699
	for <lists+linux-xfs@lfdr.de>; Thu, 27 May 2021 06:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbhE0Exl (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 27 May 2021 00:53:41 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:48782 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232616AbhE0Exk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 May 2021 00:53:40 -0400
Received: from dread.disaster.area (pa49-180-230-185.pa.nsw.optusnet.com.au [49.180.230.185])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 44531862700
        for <linux-xfs@vger.kernel.org>; Thu, 27 May 2021 14:52:06 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lm804-005h1J-RE
        for linux-xfs@vger.kernel.org; Thu, 27 May 2021 14:52:04 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lm804-004qge-JX
        for linux-xfs@vger.kernel.org; Thu, 27 May 2021 14:52:04 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 6/6] xfs: reduce transaction reservation for freeing extents
Date:   Thu, 27 May 2021 14:52:02 +1000
Message-Id: <20210527045202.1155628-7-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210527045202.1155628-1-david@fromorbit.com>
References: <20210527045202.1155628-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=dUIOjvib2kB+GiIc1vUx8g==:117 a=dUIOjvib2kB+GiIc1vUx8g==:17
        a=5FLXtPjwQuUA:10 a=20KFwNOVAAAA:8 a=7un6xMnLzUUjxZIj67YA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Ever since we moved to deferred freeing of extents, we only every
free one extent per transaction. We separated the bulk unmapping of
extents from the submission of EFI/free/EFD transactions, and hence
while we unmap extents in bulk, we only every free one per
transaction.

Our transaction reservations still live in the era from before
deferred freeing of extents, so still refer to "xfs_bmap_finish"
and it needing to free multiple extents per transaction. These
freeing reservations can now all be reduced to a single extent to
reflect how we currently free extents.

This significantly reduces the reservation sizes for operations like
truncate and directory operations where they currently reserve space
for freeing up to 4 extents per transaction.

For a 4kB block size filesytsem with reflink=1,rmapbt=1, the
reservation sizes change like this:

Reservation		Before			After
(index)			logres	logcount	logres	logcount
 0	write		314104	    8		314104	    8
 1	itruncate	579456	    8           148608	    8
 2	rename		435840	    2           307936	    2
 3	link		191600	    2           191600	    2
 4	remove		312960	    2           174328	    2
 5	symlink		470656	    3           470656	    3
 6	create		469504	    2           469504	    2
 7	create_tmpfile	490240	    2           490240	    2
 8	mkdir		469504	    3           469504	    3
 9	ifree		508664	    2           508664	    2
 10	ichange		  5752	    0             5752	    0
 11	growdata	147840	    2           147840	    2
 12	addafork	178936	    2           178936	    2
 13	writeid		   760	    0              760	    0
 14	attrinval	578688	    1           147840	    1
 15	attrsetm	 26872	    3            26872	    3
 16	attrsetrt	 16896	    0            16896	    0
 17	attrrm		292224	    3           148608	    3
 18	clearagi	  4224	    0             4224	    0
 19	growrtalloc	173944	    2           173944	    2
 20	growrtzero	  4224	    0             4224	    0
 21	growrtfree	 10096	    0            10096	    0
 22	qm_setqlim	   232	    1              232	    1
 23	qm_dqalloc	318327	    8           318327	    8
 24	qm_quotaoff	  4544	    1             4544	    1
 25	qm_equotaoff	   320	    1              320	    1
 26	sb		  4224	    1             4224	    1
 27	fsyncts		   760	    0              760	    0
MAX			579456	    8           318327	    8

So we can see that many of the reservations have gone substantially
down in size. itruncate, rename, remove, attrinval and attrrm are
much smaller now. The maximum reservation size has gone from being
attrinval at 579456*8 bytes to dqalloc at 318327*8 bytes. This is a
substantial improvement for common operations.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_trans_resv.c | 63 +++++++++++++++++-----------------
 1 file changed, 31 insertions(+), 32 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_trans_resv.c b/fs/xfs/libxfs/xfs_trans_resv.c
index 02079f55ef20..f5e76eeae281 100644
--- a/fs/xfs/libxfs/xfs_trans_resv.c
+++ b/fs/xfs/libxfs/xfs_trans_resv.c
@@ -232,8 +232,7 @@ xfs_rtalloc_log_count(
  * Various log reservation values.
  *
  * These are based on the size of the file system block because that is what
- * most transactions manipulate.  Each adds in an additional 128 bytes per
- * item logged to try to account for the overhead of the transaction mechanism.
+ * most transactions manipulate.
  *
  * Note:  Most of the reservations underestimate the number of allocation
  * groups into which they could free extents in the xfs_defer_finish() call.
@@ -262,9 +261,9 @@ xfs_rtalloc_log_count(
  *    the superblock free block counter: sector size
  *    the realtime bitmap: ((MAXEXTLEN / rtextsize) / NBBY) bytes
  *    the realtime summary: 1 block
- * And the bmap_finish transaction can free bmap blocks in a join (t3):
+ * And the deferred freeing can free bmap blocks in a join (t3):
  *    the super block free block counter: sector size
- *    two extent allocfree reservations for the AG.
+ *    one extent allocfree reservation for the AG.
  */
 STATIC uint
 xfs_calc_write_reservation(
@@ -290,23 +289,25 @@ xfs_calc_write_reservation(
 	}
 
 	t3 = xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
-	     xfs_allocfree_extent_res(mp) * 2;
+	     xfs_allocfree_extent_res(mp);
 
 	return XFS_DQUOT_LOGRES(mp) + max3(t1, t2, t3);
 }
 
 /*
- * In truncating a file we free up to two extents at once.  We can modify (t1):
+ * In truncating a file we defer freeing so we only free one extent per
+ * transaction for normal files. For rt files we limit to 2 extents per
+ * transaction.
+ * We can modify (t1):
  *    the inode being truncated: inode size
  *    the inode's bmap btree: (max depth + 1) * block size
- * And the bmap_finish transaction can free the blocks and bmap blocks (t2):
- *    the super block to reflect the freed blocks: sector size
- *    four extent allocfree reservations for the AG.
- * Or, if it's a realtime file (t3):
+ * Or, if it's a realtime file (t2):
  *    the super block to reflect the freed blocks: sector size
  *    the realtime bitmap: 2 exts * ((MAXEXTLEN / rtextsize) / NBBY) bytes
  *    the realtime summary: 2 exts * 1 block
- *    two extent allocfree reservations for the AG.
+ * And the deferred freeing can free the blocks and bmap blocks (t3):
+ *    the super block to reflect the freed blocks: sector size
+ *    one extent allocfree reservation for the AG.
  */
 STATIC uint
 xfs_calc_itruncate_reservation(
@@ -318,17 +319,16 @@ xfs_calc_itruncate_reservation(
 	t1 = xfs_calc_inode_res(mp, 1) +
 	     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) + 1, blksz);
 
-	t2 = xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
-	     xfs_allocfree_extent_res(mp) * 4;
-
 	if (xfs_sb_version_hasrealtime(&mp->m_sb)) {
-		t3 = xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
-		     xfs_calc_buf_res(xfs_rtalloc_log_count(mp, 2), blksz) +
-		     xfs_allocfree_extent_res(mp) * 2;
+		t2 = xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
+		     xfs_calc_buf_res(xfs_rtalloc_log_count(mp, 2), blksz);
 	} else {
-		t3 = 0;
+		t2 = 0;
 	}
 
+	t3 = xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
+	     xfs_allocfree_extent_res(mp);
+
 	return XFS_DQUOT_LOGRES(mp) + max3(t1, t2, t3);
 }
 
@@ -337,10 +337,9 @@ xfs_calc_itruncate_reservation(
  *    the four inodes involved: 4 * inode size
  *    the two directory btrees: 2 * (max depth + v2) * dir block size
  *    the two directory bmap btrees: 2 * max depth * block size
- * And the bmap_finish transaction can free dir and bmap blocks (two sets
- *	of bmap blocks) giving:
+ * And the deferred freeing can free dir and bmap blocks giving:
  *    the superblock for the free block count: sector size
- *    three extent allocfree reservations for the AG.
+ *    one extent allocfree reservations for the AG.
  */
 STATIC uint
 xfs_calc_rename_reservation(
@@ -351,7 +350,7 @@ xfs_calc_rename_reservation(
 		     xfs_calc_buf_res(2 * XFS_DIROP_LOG_COUNT(mp),
 				      XFS_FSB_TO_B(mp, 1))),
 		    (xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
-		     xfs_allocfree_extent_res(mp) * 3));
+		     xfs_allocfree_extent_res(mp)));
 }
 
 /*
@@ -375,7 +374,7 @@ xfs_calc_iunlink_remove_reservation(
  *    the linked inode: inode size
  *    the directory btree could split: (max depth + v2) * dir block size
  *    the directory bmap btree could join or split: (max depth + v2) * blocksize
- * And the bmap_finish transaction can free some bmap blocks giving:
+ * And the deferred freeing can free bmap blocks giving:
  *    the superblock for the free block count: sector size
  *    one extent allocfree reservation for the AG.
  */
@@ -411,9 +410,9 @@ xfs_calc_iunlink_add_reservation(xfs_mount_t *mp)
  *    the removed inode: inode size
  *    the directory btree could join: (max depth + v2) * dir block size
  *    the directory bmap btree could join or split: (max depth + v2) * blocksize
- * And the bmap_finish transaction can free the dir and bmap blocks giving:
+ * And the deferred freeing can free the dir and bmap blocks giving:
  *    the superblock for the free block count: sector size
- *    two extent allocfree reservations for the AG.
+ *    one extent allocfree reservation for the AG.
  */
 STATIC uint
 xfs_calc_remove_reservation(
@@ -425,7 +424,7 @@ xfs_calc_remove_reservation(
 		     xfs_calc_buf_res(XFS_DIROP_LOG_COUNT(mp),
 				      XFS_FSB_TO_B(mp, 1))),
 		    (xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
-		     xfs_allocfree_extent_res(mp) * 2));
+		     xfs_allocfree_extent_res(mp)));
 }
 
 /*
@@ -670,9 +669,9 @@ xfs_calc_addafork_reservation(
  * Removing the attribute fork of a file
  *    the inode being truncated: inode size
  *    the inode's bmap btree: max depth * block size
- * And the bmap_finish transaction can free the blocks and bmap blocks:
+ * And the deferred freeing can free the blocks and bmap blocks:
  *    the super block to reflect the freed blocks: sector size
- *    four extent allocfree reservations for the AG.
+ *    one extent allocfree reservation for the AG.
  */
 STATIC uint
 xfs_calc_attrinval_reservation(
@@ -682,7 +681,7 @@ xfs_calc_attrinval_reservation(
 		    xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK),
 				     XFS_FSB_TO_B(mp, 1))),
 		   (xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
-		    xfs_allocfree_extent_res(mp) * 4));
+		    xfs_allocfree_extent_res(mp)));
 }
 
 /*
@@ -730,9 +729,9 @@ xfs_calc_attrsetrt_reservation(
  *    the inode: inode size
  *    the attribute btree could join: max depth * block size
  *    the inode bmap btree could join or split: max depth * block size
- * And the bmap_finish transaction can free the attr blocks freed giving:
+ * And the deferred freeing can free the attr blocks freed giving:
  *    the superblock for the free block count: sector size
- *    two extent allocfree reservations for the AG.
+ *    one extent allocfree reservations for the AG.
  */
 STATIC uint
 xfs_calc_attrrm_reservation(
@@ -746,7 +745,7 @@ xfs_calc_attrrm_reservation(
 					XFS_BM_MAXLEVELS(mp, XFS_ATTR_FORK)) +
 		     xfs_calc_buf_res(XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK), 0)),
 		    (xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
-		     xfs_allocfree_extent_res(mp) * 2));
+		     xfs_allocfree_extent_res(mp)));
 }
 
 /*
-- 
2.31.1

