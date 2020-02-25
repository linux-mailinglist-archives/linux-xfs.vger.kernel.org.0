Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA4216F305
	for <lists+linux-xfs@lfdr.de>; Wed, 26 Feb 2020 00:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729453AbgBYXK1 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Feb 2020 18:10:27 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:53394 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729458AbgBYXK1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Feb 2020 18:10:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=UA8DE4OLKOVvsSlS/t5RFbdB8Hwbjk5JQWfur4LKtPE=; b=eTV6nLwHn/Zk22q4kFMWg+4C9b
        dUWWjQ+7Wi9qfxITbWacwM1jHMimDalf9++PsPwuFuqptZwMlvOkr+JKsLigf5D7wcMKdus1F5Af7
        oXC8vac71mx4MvNdzH/Q9YXhY1Z8DW5AxMIjXeTc7Dabp7XmUnCBmsVf6aVfHAOjUu6V/y03GWKyJ
        +wL/rhhU4o2ZhNTyKWc8X3ynlEmBOr86xKtFnMJ/QETTRG8EjtogHt3IopcV6+xSIrfnXVUgv7HxZ
        7zhMBkD26dqNo54DksVSdHsdUTqZKup0LgqUnfy7QkBj4YcYPZHy4IwRN6//3r0iR+OGu/NBpzNRT
        TO24+lww==;
Received: from [4.28.11.157] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6jLO-0003An-SP; Tue, 25 Feb 2020 23:10:26 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 22/30] xfs: lift common checks into xfs_ioc_attr_list
Date:   Tue, 25 Feb 2020 15:10:04 -0800
Message-Id: <20200225231012.735245-23-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200225231012.735245-1-hch@lst.de>
References: <20200225231012.735245-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Lift the flags and bufsize checks from both callers into the common code
in xfs_ioc_attr_list.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_ioctl.c   | 23 ++++++++++++-----------
 fs/xfs/xfs_ioctl32.c | 11 -----------
 2 files changed, 12 insertions(+), 22 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index a8fe9553b432..508326f6ec67 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -361,6 +361,18 @@ xfs_ioc_attr_list(
 	struct xfs_attrlist		*alist;
 	int				error;
 
+	if (bufsize < sizeof(struct xfs_attrlist) ||
+	    bufsize > XFS_XATTR_LIST_MAX)
+		return -EINVAL;
+
+	/*
+	 * Reject flags, only allow namespaces.
+	 */
+	if (flags & ~(ATTR_ROOT | ATTR_SECURE))
+		return -EINVAL;
+	if (flags == (ATTR_ROOT | ATTR_SECURE))
+		return -EINVAL;
+
 	/*
 	 * Validate the cursor.
 	 */
@@ -415,17 +427,6 @@ xfs_attrlist_by_handle(
 		return -EPERM;
 	if (copy_from_user(&al_hreq, arg, sizeof(xfs_fsop_attrlist_handlereq_t)))
 		return -EFAULT;
-	if (al_hreq.buflen < sizeof(struct xfs_attrlist) ||
-	    al_hreq.buflen > XFS_XATTR_LIST_MAX)
-		return -EINVAL;
-
-	/*
-	 * Reject flags, only allow namespaces.
-	 */
-	if (al_hreq.flags & ~(ATTR_ROOT | ATTR_SECURE))
-		return -EINVAL;
-	if (al_hreq.flags == (ATTR_ROOT | ATTR_SECURE))
-		return -EINVAL;
 
 	dentry = xfs_handlereq_to_dentry(parfilp, &al_hreq.hreq);
 	if (IS_ERR(dentry))
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 10ea0222954c..840d17951407 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -366,17 +366,6 @@ xfs_compat_attrlist_by_handle(
 	if (copy_from_user(&al_hreq, arg,
 			   sizeof(compat_xfs_fsop_attrlist_handlereq_t)))
 		return -EFAULT;
-	if (al_hreq.buflen < sizeof(struct xfs_attrlist) ||
-	    al_hreq.buflen > XFS_XATTR_LIST_MAX)
-		return -EINVAL;
-
-	/*
-	 * Reject flags, only allow namespaces.
-	 */
-	if (al_hreq.flags & ~(ATTR_ROOT | ATTR_SECURE))
-		return -EINVAL;
-	if (al_hreq.flags == (ATTR_ROOT | ATTR_SECURE))
-		return -EINVAL;
 
 	dentry = xfs_compat_handlereq_to_dentry(parfilp, &al_hreq.hreq);
 	if (IS_ERR(dentry))
-- 
2.24.1

