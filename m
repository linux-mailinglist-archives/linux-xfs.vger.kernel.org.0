Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF5A424680
	for <lists+linux-xfs@lfdr.de>; Tue, 21 May 2019 05:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727581AbfEUDw6 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 20 May 2019 23:52:58 -0400
Received: from sandeen.net ([63.231.237.45]:56806 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726265AbfEUDw5 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 20 May 2019 23:52:57 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 4F750325F;
        Mon, 20 May 2019 22:52:54 -0500 (CDT)
Subject: [PATCH 7/7 V2] libxfs: share kernel's xfs_trans_inode.c
To:     Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org
References: <1558410427-1837-1-git-send-email-sandeen@redhat.com>
 <1558410427-1837-8-git-send-email-sandeen@redhat.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <79484f9f-42e3-29bc-9d84-897e0191ede2@sandeen.net>
Date:   Mon, 20 May 2019 22:52:56 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1558410427-1837-8-git-send-email-sandeen@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Now that the majority of cosmetic changes and compat shims
are in place, we can directly share kernelspace's
xfs_trans_inode.c with just a couple more small tweaks.
In addition to the file move,

* ili_fsync_fields is added to xfs_inode_log_item (but not used)
* test_and_set_bit() helper is created

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

V2: good grief, get the new file in the patch

 include/xfs_trans.h      |    3 
 libxfs/Makefile          |    1 
 libxfs/libxfs_priv.h     |    9 ++
 libxfs/trans.c           |   65 -------------------
 libxfs/util.c            |   27 --------
 libxfs/xfs_trans_inode.c |  155 +++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 167 insertions(+), 93 deletions(-)

diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index 118fa0b..60e1dbd 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -30,8 +30,9 @@ typedef struct xfs_inode_log_item {
 	xfs_log_item_t		ili_item;		/* common portion */
 	struct xfs_inode	*ili_inode;		/* inode pointer */
 	unsigned short		ili_lock_flags;		/* lock flags */
-	unsigned int		ili_fields;		/* fields to be logged */
 	unsigned int		ili_last_fields;	/* fields when flushed*/
+	unsigned int		ili_fields;		/* fields to be logged */
+	unsigned int		ili_fsync_fields;	/* ignored by userspace */
 } xfs_inode_log_item_t;
 
 typedef struct xfs_buf_log_item {
diff --git a/libxfs/Makefile b/libxfs/Makefile
index 160498d..8c681e0 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -93,6 +93,7 @@ CFILES = cache.c \
 	xfs_rtbitmap.c \
 	xfs_sb.c \
 	xfs_symlink_remote.c \
+	xfs_trans_inode.c \
 	xfs_trans_resv.c \
 	xfs_types.c
 
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index a8c0f0b..c75b92d 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -608,6 +608,15 @@ static inline int test_bit(int nr, const volatile unsigned long *addr)
 	return *p & mask;
 }
 
+/* Sets and returns original value of the bit */
+static inline int test_and_set_bit(int nr, volatile unsigned long *addr)
+{
+	if (test_bit(nr, addr))
+		return 1;
+	set_bit(nr, addr);
+	return 0;
+}
+
 /* Keep static checkers quiet about nonstatic functions by exporting */
 int xfs_inode_hasattr(struct xfs_inode *ip);
 int xfs_attr_get_ilocked(struct xfs_inode *ip, struct xfs_da_args *args);
diff --git a/libxfs/trans.c b/libxfs/trans.c
index c7a1d52..5c56b4f 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -331,25 +331,6 @@ libxfs_trans_cancel(
 }
 
 void
-libxfs_trans_ijoin(
-	xfs_trans_t		*tp,
-	xfs_inode_t		*ip,
-	uint			lock_flags)
-{
-	xfs_inode_log_item_t	*iip;
-
-	if (ip->i_itemp == NULL)
-		xfs_inode_item_init(ip, ip->i_mount);
-	iip = ip->i_itemp;
-	ASSERT(iip->ili_inode != NULL);
-
-	ASSERT(iip->ili_lock_flags == 0);
-	iip->ili_lock_flags = lock_flags;
-
-	xfs_trans_add_item(tp, &iip->ili_item);
-}
-
-void
 libxfs_trans_inode_alloc_buf(
 	xfs_trans_t		*tp,
 	xfs_buf_t		*bp)
@@ -363,52 +344,6 @@ libxfs_trans_inode_alloc_buf(
 }
 
 /*
- * This is called to mark the fields indicated in fieldmask as needing
- * to be logged when the transaction is committed.  The inode must
- * already be associated with the given transaction.
- *
- * The values for fieldmask are defined in xfs_log_format.h.  We always
- * log all of the core inode if any of it has changed, and we always log
- * all of the inline data/extents/b-tree root if any of them has changed.
- */
-void
-xfs_trans_log_inode(
-	xfs_trans_t		*tp,
-	xfs_inode_t		*ip,
-	uint			flags)
-{
-	ASSERT(ip->i_itemp != NULL);
-
-	tp->t_flags |= XFS_TRANS_DIRTY;
-	set_bit(XFS_LI_DIRTY, &ip->i_itemp->ili_item.li_flags);
-
-	/*
-	 * Always OR in the bits from the ili_last_fields field.
-	 * This is to coordinate with the xfs_iflush() and xfs_iflush_done()
-	 * routines in the eventual clearing of the ilf_fields bits.
-	 * See the big comment in xfs_iflush() for an explanation of
-	 * this coordination mechanism.
-	 */
-	flags |= ip->i_itemp->ili_last_fields;
-	ip->i_itemp->ili_fields |= flags;
-}
-
-int
-libxfs_trans_roll_inode(
-	struct xfs_trans	**tpp,
-	struct xfs_inode	*ip)
-{
-	int			error;
-
-	xfs_trans_log_inode(*tpp, ip, XFS_ILOG_CORE);
-	error = xfs_trans_roll(tpp);
-	if (!error)
-		xfs_trans_ijoin(*tpp, ip, 0);
-	return error;
-}
-
-
-/*
  * Mark a buffer dirty in the transaction.
  */
 void
diff --git a/libxfs/util.c b/libxfs/util.c
index 2ba9dc2..171a172 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -149,33 +149,6 @@ current_time(struct inode *inode)
 	return tv;
 }
 
-/*
- * Change the requested timestamp in the given inode.
- */
-void
-libxfs_trans_ichgtime(
-	struct xfs_trans	*tp,
-	struct xfs_inode	*ip,
-	int			flags)
-{
-	struct inode		*inode = VFS_I(ip);
-	struct timespec64	tv;
-
-	ASSERT(tp);
-	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
-
-	tv = current_time(inode);
-
-	if (flags & XFS_ICHGTIME_MOD)
-		VFS_I(ip)->i_mtime = tv;
-	if (flags & XFS_ICHGTIME_CHG)
-		VFS_I(ip)->i_ctime = tv;
-	if (flags & XFS_ICHGTIME_CREATE) {
-		ip->i_d.di_crtime.t_sec = (int32_t)tv.tv_sec;
-		ip->i_d.di_crtime.t_nsec = (int32_t)tv.tv_nsec;
-	}
-}
-
 STATIC uint16_t
 xfs_flags2diflags(
 	struct xfs_inode	*ip,
diff --git a/libxfs/xfs_trans_inode.c b/libxfs/xfs_trans_inode.c
new file mode 100644
index 0000000..87e6335
--- /dev/null
+++ b/libxfs/xfs_trans_inode.c
@@ -0,0 +1,155 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000,2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+#include "libxfs_priv.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_inode.h"
+#include "xfs_trans.h"
+#include "xfs_trace.h"
+
+/*
+ * Add a locked inode to the transaction.
+ *
+ * The inode must be locked, and it cannot be associated with any transaction.
+ * If lock_flags is non-zero the inode will be unlocked on transaction commit.
+ */
+void
+xfs_trans_ijoin(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	uint			lock_flags)
+{
+	xfs_inode_log_item_t	*iip;
+
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+	if (ip->i_itemp == NULL)
+		xfs_inode_item_init(ip, ip->i_mount);
+	iip = ip->i_itemp;
+
+	ASSERT(iip->ili_lock_flags == 0);
+	iip->ili_lock_flags = lock_flags;
+
+	/*
+	 * Get a log_item_desc to point at the new item.
+	 */
+	xfs_trans_add_item(tp, &iip->ili_item);
+}
+
+/*
+ * Transactional inode timestamp update. Requires the inode to be locked and
+ * joined to the transaction supplied. Relies on the transaction subsystem to
+ * track dirty state and update/writeback the inode accordingly.
+ */
+void
+xfs_trans_ichgtime(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	int			flags)
+{
+	struct inode		*inode = VFS_I(ip);
+	struct timespec64 tv;
+
+	ASSERT(tp);
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+
+	tv = current_time(inode);
+
+	if (flags & XFS_ICHGTIME_MOD)
+		inode->i_mtime = tv;
+	if (flags & XFS_ICHGTIME_CHG)
+		inode->i_ctime = tv;
+	if (flags & XFS_ICHGTIME_CREATE) {
+		ip->i_d.di_crtime.t_sec = (int32_t)tv.tv_sec;
+		ip->i_d.di_crtime.t_nsec = (int32_t)tv.tv_nsec;
+	}
+}
+
+/*
+ * This is called to mark the fields indicated in fieldmask as needing
+ * to be logged when the transaction is committed.  The inode must
+ * already be associated with the given transaction.
+ *
+ * The values for fieldmask are defined in xfs_inode_item.h.  We always
+ * log all of the core inode if any of it has changed, and we always log
+ * all of the inline data/extents/b-tree root if any of them has changed.
+ */
+void
+xfs_trans_log_inode(
+	xfs_trans_t	*tp,
+	xfs_inode_t	*ip,
+	uint		flags)
+{
+	struct inode	*inode = VFS_I(ip);
+
+	ASSERT(ip->i_itemp != NULL);
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+
+	/*
+	 * Don't bother with i_lock for the I_DIRTY_TIME check here, as races
+	 * don't matter - we either will need an extra transaction in 24 hours
+	 * to log the timestamps, or will clear already cleared fields in the
+	 * worst case.
+	 */
+	if (inode->i_state & (I_DIRTY_TIME | I_DIRTY_TIME_EXPIRED)) {
+		spin_lock(&inode->i_lock);
+		inode->i_state &= ~(I_DIRTY_TIME | I_DIRTY_TIME_EXPIRED);
+		spin_unlock(&inode->i_lock);
+	}
+
+	/*
+	 * Record the specific change for fdatasync optimisation. This
+	 * allows fdatasync to skip log forces for inodes that are only
+	 * timestamp dirty. We do this before the change count so that
+	 * the core being logged in this case does not impact on fdatasync
+	 * behaviour.
+	 */
+	ip->i_itemp->ili_fsync_fields |= flags;
+
+	/*
+	 * First time we log the inode in a transaction, bump the inode change
+	 * counter if it is configured for this to occur. While we have the
+	 * inode locked exclusively for metadata modification, we can usually
+	 * avoid setting XFS_ILOG_CORE if no one has queried the value since
+	 * the last time it was incremented. If we have XFS_ILOG_CORE already
+	 * set however, then go ahead and bump the i_version counter
+	 * unconditionally.
+	 */
+	if (!test_and_set_bit(XFS_LI_DIRTY, &ip->i_itemp->ili_item.li_flags) &&
+	    IS_I_VERSION(VFS_I(ip))) {
+		if (inode_maybe_inc_iversion(VFS_I(ip), flags & XFS_ILOG_CORE))
+			flags |= XFS_ILOG_CORE;
+	}
+
+	tp->t_flags |= XFS_TRANS_DIRTY;
+
+	/*
+	 * Always OR in the bits from the ili_last_fields field.
+	 * This is to coordinate with the xfs_iflush() and xfs_iflush_done()
+	 * routines in the eventual clearing of the ili_fields bits.
+	 * See the big comment in xfs_iflush() for an explanation of
+	 * this coordination mechanism.
+	 */
+	flags |= ip->i_itemp->ili_last_fields;
+	ip->i_itemp->ili_fields |= flags;
+}
+
+int
+xfs_trans_roll_inode(
+	struct xfs_trans	**tpp,
+	struct xfs_inode	*ip)
+{
+	int			error;
+
+	xfs_trans_log_inode(*tpp, ip, XFS_ILOG_CORE);
+	error = xfs_trans_roll(tpp);
+	if (!error)
+		xfs_trans_ijoin(*tpp, ip, 0);
+	return error;
+}

