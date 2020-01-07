Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 458CD132C17
	for <lists+linux-xfs@lfdr.de>; Tue,  7 Jan 2020 17:57:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728468AbgAGQyy (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 7 Jan 2020 11:54:54 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:52234 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728391AbgAGQyx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Jan 2020 11:54:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=2S6EU5V4HACqDVtrr9GHTkUrFxxbjvBmBf462dPdEQQ=; b=O7/4YJ2WhSG6BaYa3Vhi08q5i5
        pWLB+Nleg9KQ0rQke9hzWCHFCVeTPVweij89OZV6hN6uh5bPE7iyF0+CeqJmnXzURt87gLY+Alog7
        AHlxPU6bLg2d+meMdS68WOOV/KRcES0eX3siyVjbXH2ryhI+lb33Y1E1KcMpFRoXuqWF/TrD51Mru
        ucazFkF8en+4QS9noQf7tItnBwYB1AY5hyJ7msRmqK0YWfcAhTkdZ3usfYxn//MR8O31rFY5DjF3k
        PwAmtPiwVMk1Cx9q2WtjoaQ3E2pmX4IsBwyN62626Wleyohd/gn1N6pBgXVjVDiNiKN8piR/HL6wE
        b7/c+tow==;
Received: from clnet-p19-102.ikbnet.co.at ([83.175.77.102] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ios85-0002R6-AC; Tue, 07 Jan 2020 16:54:53 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 4/4] xfs: fix misuse of the XFS_ATTR_INCOMPLETE flag
Date:   Tue,  7 Jan 2020 17:54:42 +0100
Message-Id: <20200107165442.262020-5-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107165442.262020-1-hch@lst.de>
References: <20200107165442.262020-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

XFS_ATTR_INCOMPLETE is a flag in the on-disk attribute format, and thus
in a different namespace as the ATTR_* flags in xfs_da_args.flags.
Switch to using a XFS_DA_OP_INCOMPLETE flag in op_flags instead.  Without
this users might be able to inject this flag into operations using the
attr by handle ioctl.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c      | 2 +-
 fs/xfs/libxfs/xfs_attr_leaf.c | 4 ++--
 fs/xfs/libxfs/xfs_da_btree.h  | 4 +++-
 fs/xfs/libxfs/xfs_da_format.h | 2 --
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 0d7fcc983b3d..2368a1bfe7e8 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1007,7 +1007,7 @@ xfs_attr_node_addname(
 		 * The INCOMPLETE flag means that we will find the "old"
 		 * attr, not the "new" one.
 		 */
-		args->flags |= XFS_ATTR_INCOMPLETE;
+		args->op_flags |= XFS_DA_OP_INCOMPLETE;
 		state = xfs_da_state_alloc();
 		state->args = args;
 		state->mp = mp;
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 08d4b10ae2d5..fed537a4353d 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -2403,8 +2403,8 @@ xfs_attr3_leaf_lookup_int(
 		 * If we are looking for INCOMPLETE entries, show only those.
 		 * If we are looking for complete entries, show only those.
 		 */
-		if ((args->flags & XFS_ATTR_INCOMPLETE) !=
-		    (entry->flags & XFS_ATTR_INCOMPLETE)) {
+		if (!!(args->op_flags & XFS_DA_OP_INCOMPLETE) !=
+		    !!(entry->flags & XFS_ATTR_INCOMPLETE)) {
 			continue;
 		}
 		if (entry->flags & XFS_ATTR_LOCAL) {
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index e16610d1c14f..0f4fbb0889ff 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -89,6 +89,7 @@ typedef struct xfs_da_args {
 #define XFS_DA_OP_OKNOENT	0x0008	/* lookup/add op, ENOENT ok, else die */
 #define XFS_DA_OP_CILOOKUP	0x0010	/* lookup to return CI name if found */
 #define XFS_DA_OP_ALLOCVAL	0x0020	/* lookup to alloc buffer if found  */
+#define XFS_DA_OP_INCOMPLETE	0x0040	/* lookup INCOMPLETE attr keys */
 
 #define XFS_DA_OP_FLAGS \
 	{ XFS_DA_OP_JUSTCHECK,	"JUSTCHECK" }, \
@@ -96,7 +97,8 @@ typedef struct xfs_da_args {
 	{ XFS_DA_OP_ADDNAME,	"ADDNAME" }, \
 	{ XFS_DA_OP_OKNOENT,	"OKNOENT" }, \
 	{ XFS_DA_OP_CILOOKUP,	"CILOOKUP" }, \
-	{ XFS_DA_OP_ALLOCVAL,	"ALLOCVAL" }
+	{ XFS_DA_OP_ALLOCVAL,	"ALLOCVAL" }, \
+	{ XFS_DA_OP_INCOMPLETE,	"INCOMPLETE" }
 
 /*
  * Storage for holding state during Btree searches and split/join ops.
diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 3dee33043e09..05615d1f4113 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -683,8 +683,6 @@ struct xfs_attr3_leafblock {
 
 /*
  * Flags used in the leaf_entry[i].flags field.
- * NOTE: the INCOMPLETE bit must not collide with the flags bits specified
- * on the system call, they are "or"ed together for various operations.
  */
 #define	XFS_ATTR_LOCAL_BIT	0	/* attr is stored locally */
 #define	XFS_ATTR_ROOT_BIT	1	/* limit access to trusted attrs */
-- 
2.24.1

