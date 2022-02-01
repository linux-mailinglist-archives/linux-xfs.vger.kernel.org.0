Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2FE84A5363
	for <lists+linux-xfs@lfdr.de>; Tue,  1 Feb 2022 00:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbiAaXja (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 31 Jan 2022 18:39:30 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:35582 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229649AbiAaXj3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Jan 2022 18:39:29 -0500
Received: from dread.disaster.area (pa49-180-69-7.pa.nsw.optusnet.com.au [49.180.69.7])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 4BAEC62C49C
        for <linux-xfs@vger.kernel.org>; Tue,  1 Feb 2022 10:39:24 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nEgGY-006aS3-U8
        for linux-xfs@vger.kernel.org; Tue, 01 Feb 2022 10:39:22 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nEgGY-003I24-Sd
        for linux-xfs@vger.kernel.org;
        Tue, 01 Feb 2022 10:39:22 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/5] xfs: set prealloc flag in xfs_alloc_file_space()
Date:   Tue,  1 Feb 2022 10:39:18 +1100
Message-Id: <20220131233920.784181-4-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220131233920.784181-1-david@fromorbit.com>
References: <20220131233920.784181-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=61f8732c
        a=NB+Ng1P8A7U24Uo7qoRq4Q==:117 a=NB+Ng1P8A7U24Uo7qoRq4Q==:17
        a=oGFeUVbbRNcA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=MQa1602MSgzbZQLP09sA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Now that we only call xfs_update_prealloc_flags() from
xfs_file_fallocate() in the case where we need to set the
preallocation flag, do this in xfs_alloc_file_space() where we
already have the inode joined into a transaction and get
rid of the call to xfs_update_prealloc_flags() from the fallocate
code.

This also means that we now correctly avoid setting the
XFS_DIFLAG_PREALLOC flag when xfs_is_always_cow_inode() is true, as
these inodes will never have preallocated extents.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_bmap_util.c | 9 +++------
 fs/xfs/xfs_file.c      | 8 --------
 2 files changed, 3 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index d4a387d3d0ce..eb2e387ba528 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -850,9 +850,6 @@ xfs_alloc_file_space(
 			rblocks = 0;
 		}
 
-		/*
-		 * Allocate and setup the transaction.
-		 */
 		error = xfs_trans_alloc_inode(ip, &M_RES(mp)->tr_write,
 				dblocks, rblocks, false, &tp);
 		if (error)
@@ -869,9 +866,9 @@ xfs_alloc_file_space(
 		if (error)
 			goto error;
 
-		/*
-		 * Complete the transaction
-		 */
+		ip->i_diflags |= XFS_DIFLAG_PREALLOC;
+		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
 		error = xfs_trans_commit(tp);
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		if (error)
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 7846d55cba01..082e3ef81418 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -908,7 +908,6 @@ xfs_file_fallocate(
 	struct inode		*inode = file_inode(file);
 	struct xfs_inode	*ip = XFS_I(inode);
 	long			error;
-	enum xfs_prealloc_flags	flags = 0;
 	uint			iolock = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
 	loff_t			new_size = 0;
 	bool			do_file_insert = false;
@@ -1006,8 +1005,6 @@ xfs_file_fallocate(
 		}
 		do_file_insert = true;
 	} else {
-		flags |= XFS_PREALLOC_SET;
-
 		if (!(mode & FALLOC_FL_KEEP_SIZE) &&
 		    offset + len > i_size_read(inode)) {
 			new_size = offset + len;
@@ -1057,11 +1054,6 @@ xfs_file_fallocate(
 			if (error)
 				goto out_unlock;
 		}
-
-		error = xfs_update_prealloc_flags(ip, XFS_PREALLOC_SET);
-		if (error)
-			goto out_unlock;
-
 	}
 
 	/* Change file size if needed */
-- 
2.33.0

