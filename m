Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59383510EBE
	for <lists+linux-xfs@lfdr.de>; Wed, 27 Apr 2022 04:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357162AbiD0C0S (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 26 Apr 2022 22:26:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357167AbiD0C0P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 22:26:15 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8183614C3CD
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 19:23:05 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-62-197.pa.nsw.optusnet.com.au [49.195.62.197])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 9B0BF53735F
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 12:23:02 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1njXKW-004yyB-SA
        for linux-xfs@vger.kernel.org; Wed, 27 Apr 2022 12:23:00 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1njXKW-002uv3-R7
        for linux-xfs@vger.kernel.org;
        Wed, 27 Apr 2022 12:23:00 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/8] xfs: tag transactions that contain intent done items
Date:   Wed, 27 Apr 2022 12:22:55 +1000
Message-Id: <20220427022259.695399-5-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220427022259.695399-1-david@fromorbit.com>
References: <20220427022259.695399-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=6268a906
        a=KhGSFSjofVlN3/cgq4AT7A==:117 a=KhGSFSjofVlN3/cgq4AT7A==:17
        a=z0gMJWrwH1QA:10 a=20KFwNOVAAAA:8 a=yPCof4ZbAAAA:8
        a=f4-_iRGBJiCRqTHycS8A:9
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Intent whiteouts will require extra work to be done during
transaction commit if the transaction contains an intent done item.

To determine if a transaction contains an intent done item, we want
to avoid having to walk all the items in the transaction to check if
they are intent done items. Hence when we add an intent done item to
a transaction, tag the transaction to indicate that it contains such
an item.

We don't tag the transaction when the defer ops is relogging an
intent to move it forward in the log. Whiteouts will never apply to
these cases, so we don't need to bother looking for them.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_shared.h | 24 +++++++++++++++++-------
 fs/xfs/xfs_bmap_item.c     |  2 +-
 fs/xfs/xfs_extfree_item.c  |  2 +-
 fs/xfs/xfs_refcount_item.c |  2 +-
 fs/xfs/xfs_rmap_item.c     |  2 +-
 5 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_shared.h b/fs/xfs/libxfs/xfs_shared.h
index 25c4cab58851..c4381388c0c1 100644
--- a/fs/xfs/libxfs/xfs_shared.h
+++ b/fs/xfs/libxfs/xfs_shared.h
@@ -54,13 +54,23 @@ void	xfs_log_get_max_trans_res(struct xfs_mount *mp,
 /*
  * Values for t_flags.
  */
-#define	XFS_TRANS_DIRTY		0x01	/* something needs to be logged */
-#define	XFS_TRANS_SB_DIRTY	0x02	/* superblock is modified */
-#define	XFS_TRANS_PERM_LOG_RES	0x04	/* xact took a permanent log res */
-#define	XFS_TRANS_SYNC		0x08	/* make commit synchronous */
-#define XFS_TRANS_RESERVE	0x20    /* OK to use reserved data blocks */
-#define XFS_TRANS_NO_WRITECOUNT 0x40	/* do not elevate SB writecount */
-#define XFS_TRANS_RES_FDBLKS	0x80	/* reserve newly freed blocks */
+/* Transaction needs to be logged */
+#define XFS_TRANS_DIRTY			(1u << 0)
+/* Superblock is dirty and needs to be logged */
+#define XFS_TRANS_SB_DIRTY		(1u << 1)
+/* Transaction took a permanent log reservation */
+#define XFS_TRANS_PERM_LOG_RES		(1u << 2)
+/* Synchronous transaction commit needed */
+#define XFS_TRANS_SYNC			(1u << 3)
+/* Transaction can use reserve block pool */
+#define XFS_TRANS_RESERVE		(1u << 4)
+/* Transaction should avoid VFS level superblock write accounting */
+#define XFS_TRANS_NO_WRITECOUNT		(1u << 5)
+/* Transaction has freed blocks returned to it's reservation */
+#define XFS_TRANS_RES_FDBLKS		(1u << 6)
+/* Transaction contains an intent done log item */
+#define XFS_TRANS_HAS_INTENT_DONE	(1u << 7)
+
 /*
  * LOWMODE is used by the allocator to activate the lowspace algorithm - when
  * free space is running low the extent allocator may choose to allocate an
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index ed67c0028a68..3b968b31911b 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -255,7 +255,7 @@ xfs_trans_log_finish_bmap_update(
 	 * 1.) releases the BUI and frees the BUD
 	 * 2.) shuts down the filesystem
 	 */
-	tp->t_flags |= XFS_TRANS_DIRTY;
+	tp->t_flags |= XFS_TRANS_DIRTY | XFS_TRANS_HAS_INTENT_DONE;
 	set_bit(XFS_LI_DIRTY, &budp->bud_item.li_flags);
 
 	return error;
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 21a159f9d8c5..96735f23d12d 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -381,7 +381,7 @@ xfs_trans_free_extent(
 	 * 1.) releases the EFI and frees the EFD
 	 * 2.) shuts down the filesystem
 	 */
-	tp->t_flags |= XFS_TRANS_DIRTY;
+	tp->t_flags |= XFS_TRANS_DIRTY | XFS_TRANS_HAS_INTENT_DONE;
 	set_bit(XFS_LI_DIRTY, &efdp->efd_item.li_flags);
 
 	next_extent = efdp->efd_next_extent;
diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index 6536eea4c6ea..b523ce2c775b 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -260,7 +260,7 @@ xfs_trans_log_finish_refcount_update(
 	 * 1.) releases the CUI and frees the CUD
 	 * 2.) shuts down the filesystem
 	 */
-	tp->t_flags |= XFS_TRANS_DIRTY;
+	tp->t_flags |= XFS_TRANS_DIRTY | XFS_TRANS_HAS_INTENT_DONE;
 	set_bit(XFS_LI_DIRTY, &cudp->cud_item.li_flags);
 
 	return error;
diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index c2bb8cfc231e..b269e68407b9 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -328,7 +328,7 @@ xfs_trans_log_finish_rmap_update(
 	 * 1.) releases the RUI and frees the RUD
 	 * 2.) shuts down the filesystem
 	 */
-	tp->t_flags |= XFS_TRANS_DIRTY;
+	tp->t_flags |= XFS_TRANS_DIRTY | XFS_TRANS_HAS_INTENT_DONE;
 	set_bit(XFS_LI_DIRTY, &rudp->rud_item.li_flags);
 
 	return error;
-- 
2.35.1

