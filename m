Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 110FE167FB8
	for <lists+linux-xfs@lfdr.de>; Fri, 21 Feb 2020 15:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727851AbgBUOL4 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 21 Feb 2020 09:11:56 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:59270 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728468AbgBUOLz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 21 Feb 2020 09:11:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=ZLSTyaD86BzxjIuGrq6X2EkTrTChBEZATy+GTQ7mr9E=; b=TPwX9Uc5EYTLEj2NPYf6F0F5xl
        dP2ShHhVnlZZOmK5QaFaU7CN8IKvgABncp/zZkFay0JrGbzeA35Jf464WHgeESA4wF3QWZIVtWtag
        hLw35ZGUDbSIFypGXJVPWhhAGkFD3CC32r7mINN/uzYyNK3zfasvaW33BiF3/TQLdPXL9ONLZSSqh
        b1VLfo+2lUuiIjItG/aOg1wp9rVByPde7stXN/22ALnnyd1ftz1dOch12gIolVGzNwKKmEYhoOmNr
        0cyxA2KUBQrAF2rTs80CNtU3ZDcVnYynfVraX2HJc+L31BzVpm3mvfSInYAr7AUXwtArOi/pGW6t0
        E1IMoyPw==;
Received: from [38.126.112.138] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j5923-0000GK-Nn; Fri, 21 Feb 2020 14:11:55 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>,
        Dave Chinner <dchinner@redhat.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 04/31] xfs: merge xfs_attrmulti_attr_remove into xfs_attrmulti_attr_set
Date:   Fri, 21 Feb 2020 06:11:27 -0800
Message-Id: <20200221141154.476496-5-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200221141154.476496-1-hch@lst.de>
References: <20200221141154.476496-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Merge the ioctl handlers just like the low-level xfs_attr_set function.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
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

