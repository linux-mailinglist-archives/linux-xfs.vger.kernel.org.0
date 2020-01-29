Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBBB114CF09
	for <lists+linux-xfs@lfdr.de>; Wed, 29 Jan 2020 18:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgA2RDW (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 29 Jan 2020 12:03:22 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:46576 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726847AbgA2RDW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jan 2020 12:03:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Ck0ZRAC1ra13jqDIKSJYNQmS0LxWh3MQVS6Radjo2Kg=; b=lC5aN3axVLo64/+cpmWFzlkj7x
        p+rHltxTLWJ5Kr37hZhMkzV72RXe8df47xXnol+wUH09/iswjWZWnosbrHnhF8Q6k/Wc/L6vMOr2U
        sv82ORzWQT81N1ydFepR94tF/8ZR+8S94oQZ6o54ZYMT3kQiCJtvIwlMpK6veB2arwIdGzvkzomtM
        H/V6H/3DYVtn3xTfVSWu6v5OZNph1btE0/PnX3KlqE9AmpOagIjXEe2cgDGeo8YmKXVr3UB0Nbxbb
        DwSz++fzGzmIIuI1FXcOTfvHGW3M8hzFLTPCpBhGY21ddcNRZuzFRRk5qWylg/w4isvzXZK+4H/Ey
        PpNaLIVQ==;
Received: from [2001:4bb8:18c:3335:c19:50e8:dbcf:dcc6] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iwqkL-0006rg-UE; Wed, 29 Jan 2020 17:03:22 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 04/30] xfs: merge xfs_attrmulti_attr_remove into xfs_attrmulti_attr_set
Date:   Wed, 29 Jan 2020 18:02:43 +0100
Message-Id: <20200129170310.51370-5-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200129170310.51370-1-hch@lst.de>
References: <20200129170310.51370-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Merge the ioctl handlers just like the low-level xfs_attr_set function.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_ioctl.c   | 34 ++++++++++------------------------
 fs/xfs/xfs_ioctl.h   |  6 ------
 fs/xfs/xfs_ioctl32.c |  4 ++--
 3 files changed, 12 insertions(+), 32 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 79c418888e9a..b806003caacd 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -389,18 +389,20 @@ xfs_attrmulti_attr_set(
 	uint32_t		len,
 	uint32_t		flags)
 {
-	unsigned char		*kbuf;
+	unsigned char		*kbuf = NULL;
 	int			error;
 	size_t			namelen;
 
 	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
 		return -EPERM;
-	if (len > XFS_XATTR_SIZE_MAX)
-		return -EINVAL;
 
-	kbuf = memdup_user(ubuf, len);
-	if (IS_ERR(kbuf))
-		return PTR_ERR(kbuf);
+	if (ubuf) {
+		if (len > XFS_XATTR_SIZE_MAX)
+			return -EINVAL;
+		kbuf = memdup_user(ubuf, len);
+		if (IS_ERR(kbuf))
+			return PTR_ERR(kbuf);
+	}
 
 	namelen = strlen(name);
 	error = xfs_attr_set(XFS_I(inode), name, namelen, kbuf, len, flags);
@@ -410,22 +412,6 @@ xfs_attrmulti_attr_set(
 	return error;
 }
 
-int
-xfs_attrmulti_attr_remove(
-	struct inode		*inode,
-	unsigned char		*name,
-	uint32_t		flags)
-{
-	int			error;
-
-	if (IS_IMMUTABLE(inode) || IS_APPEND(inode))
-		return -EPERM;
-	error = xfs_attr_set(XFS_I(inode), name, strlen(name), NULL, 0, flags);
-	if (!error)
-		xfs_forget_acl(inode, name, flags);
-	return error;
-}
-
 STATIC int
 xfs_attrmulti_by_handle(
 	struct file		*parfilp,
@@ -504,8 +490,8 @@ xfs_attrmulti_by_handle(
 			ops[i].am_error = mnt_want_write_file(parfilp);
 			if (ops[i].am_error)
 				break;
-			ops[i].am_error = xfs_attrmulti_attr_remove(
-					d_inode(dentry), attr_name,
+			ops[i].am_error = xfs_attrmulti_attr_set(
+					d_inode(dentry), attr_name, NULL, 0,
 					ops[i].am_flags);
 			mnt_drop_write_file(parfilp);
 			break;
diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
index 420bd95dc326..819504df00ae 100644
--- a/fs/xfs/xfs_ioctl.h
+++ b/fs/xfs/xfs_ioctl.h
@@ -46,12 +46,6 @@ xfs_attrmulti_attr_set(
 	uint32_t		len,
 	uint32_t		flags);
 
-extern int
-xfs_attrmulti_attr_remove(
-	struct inode		*inode,
-	unsigned char		*name,
-	uint32_t		flags);
-
 extern struct dentry *
 xfs_handle_to_dentry(
 	struct file		*parfilp,
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 9705172e5410..e085f304e539 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -488,8 +488,8 @@ xfs_compat_attrmulti_by_handle(
 			ops[i].am_error = mnt_want_write_file(parfilp);
 			if (ops[i].am_error)
 				break;
-			ops[i].am_error = xfs_attrmulti_attr_remove(
-					d_inode(dentry), attr_name,
+			ops[i].am_error = xfs_attrmulti_attr_set(
+					d_inode(dentry), attr_name, NULL, 0,
 					ops[i].am_flags);
 			mnt_drop_write_file(parfilp);
 			break;
-- 
2.24.1

