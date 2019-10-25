Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09C78E4193
	for <lists+linux-xfs@lfdr.de>; Fri, 25 Oct 2019 04:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390147AbfJYCgV (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 24 Oct 2019 22:36:21 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:41322 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728416AbfJYCgV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Oct 2019 22:36:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=idgdtenPHdeCrx49CT0ejYHif4Rl/hlqy92HuSIrYXc=; b=d0t0DXOBhMk5XIg33d+/pLH//
        aMCatn5OeJaplHeUoaTIgnAFmPe5y4pjMIYO6A7Qk7mfTSARCxZ882JQMxqoBLblC/20JRvg4OxmK
        VCZ/EzjNvoiFFKYWct6my5JwuYhJ7dZEjchu0ppcUVPQDN7uAbOPpCeB6/Cc2P0uRHg4og/CNOjar
        2iKGq1aaZqwj6Z1nJUsLd3XFoFCB0vBZU6cNYeMtVcGONrC19CYGodPWqpPMkAE9D6oqeBJzdJfWE
        rF+OFu4+5MVHfkzJLrP++Hn83MIjkiKOPIZ+YTuH/05vykMIFkWvaHVmSY14yONtEaIHvY6QAwqcR
        Nkj+g6EAA==;
Received: from p91006-ipngnfx01marunouchi.tokyo.ocn.ne.jp ([153.156.43.6] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iNpSd-0003dH-Qv; Fri, 25 Oct 2019 02:36:21 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH 2/4] fs: add generic UNRESVSP and ZERO_RANGE ioctl handlers
Date:   Fri, 25 Oct 2019 11:36:07 +0900
Message-Id: <20191025023609.22295-3-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191025023609.22295-1-hch@lst.de>
References: <20191025023609.22295-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

These use the same scheme as the pre-existing mapping of the XFS
RESVP ioctls to ->falloc, so just extend it and remove the XFS
implementation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/compat_ioctl.c      | 32 ++++++++++++++++---
 fs/ioctl.c             | 12 +++++--
 fs/xfs/xfs_ioctl.c     | 72 +++++++-----------------------------------
 fs/xfs/xfs_ioctl.h     |  1 -
 fs/xfs/xfs_ioctl32.c   |  7 ++--
 include/linux/falloc.h |  3 ++
 include/linux/fs.h     |  2 +-
 7 files changed, 54 insertions(+), 75 deletions(-)

diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index a7ec2d3dff92..7d920dda2811 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -480,11 +480,14 @@ struct space_resv_32 {
 	__s32		l_pad[4];	/* reserve area */
 };
 
-#define FS_IOC_RESVSP_32		_IOW ('X', 40, struct space_resv_32)
+#define FS_IOC_RESVSP_32	_IOW ('X', 40, struct space_resv_32)
+#define FS_IOC_UNRESVSP_32	_IOW ('X', 41, struct space_resv_32)
 #define FS_IOC_RESVSP64_32	_IOW ('X', 42, struct space_resv_32)
+#define FS_IOC_UNRESVSP64_32	_IOW ('X', 43, struct space_resv_32)
+#define FS_IOC_ZERO_RANGE_32	_IOW ('X', 57, struct space_resv_32)
 
 /* just account for different alignment */
-static int compat_ioctl_preallocate(struct file *file,
+static int compat_ioctl_preallocate(struct file *file, int mode,
 			struct space_resv_32    __user *p32)
 {
 	struct space_resv	__user *p = compat_alloc_user_space(sizeof(*p));
@@ -498,7 +501,7 @@ static int compat_ioctl_preallocate(struct file *file,
 	    copy_in_user(&p->l_pad,	&p32->l_pad,	4*sizeof(u32)))
 		return -EFAULT;
 
-	return ioctl_preallocate(file, p);
+	return ioctl_preallocate(file, mode, p);
 }
 #endif
 
@@ -1022,13 +1025,32 @@ COMPAT_SYSCALL_DEFINE3(ioctl, unsigned int, fd, unsigned int, cmd,
 #if defined(CONFIG_IA64) || defined(CONFIG_X86_64)
 	case FS_IOC_RESVSP_32:
 	case FS_IOC_RESVSP64_32:
-		error = compat_ioctl_preallocate(f.file, compat_ptr(arg));
+		error = compat_ioctl_preallocate(f.file, 0, compat_ptr(arg));
+		goto out_fput;
+	case FS_IOC_UNRESVSP_32:
+	case FS_IOC_UNRESVSP64_32:
+		error = compat_ioctl_preallocate(f.file, FALLOC_FL_PUNCH_HOLE,
+				compat_ptr(arg));
+		goto out_fput;
+	case FS_IOC_ZERO_RANGE_32:
+		error = compat_ioctl_preallocate(f.file, FALLOC_FL_ZERO_RANGE,
+				compat_ptr(arg));
 		goto out_fput;
 #else
 	case FS_IOC_RESVSP:
 	case FS_IOC_RESVSP64:
-		error = ioctl_preallocate(f.file, compat_ptr(arg));
+		error = ioctl_preallocate(f.file, 0, compat_ptr(arg));
+		goto out_fput;
+	case FS_IOC_UNRESVSP:
+	case FS_IOC_UNRESVSP64:
+		error = ioctl_preallocate(f.file, FALLOC_FL_PUNCH_HOLE,
+				compat_ptr(arg));
 		goto out_fput;
+	case FS_IOC_ZERO_RANGE:
+		error = ioctl_preallocate(f.file, FALLOC_FL_ZERO_RANGE,
+				compat_ptr(arg));
+		goto out_fput;
+	}
 #endif
 
 	case FICLONE:
diff --git a/fs/ioctl.c b/fs/ioctl.c
index fef3a6bf7c78..55c7cfb0e599 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -466,7 +466,7 @@ EXPORT_SYMBOL(generic_block_fiemap);
  * Only the l_start, l_len and l_whence fields of the 'struct space_resv'
  * are used here, rest are ignored.
  */
-int ioctl_preallocate(struct file *filp, void __user *argp)
+int ioctl_preallocate(struct file *filp, int mode, void __user *argp)
 {
 	struct inode *inode = file_inode(filp);
 	struct space_resv sr;
@@ -487,7 +487,8 @@ int ioctl_preallocate(struct file *filp, void __user *argp)
 		return -EINVAL;
 	}
 
-	return vfs_fallocate(filp, FALLOC_FL_KEEP_SIZE, sr.l_start, sr.l_len);
+	return vfs_fallocate(filp, mode | FALLOC_FL_KEEP_SIZE, sr.l_start,
+			sr.l_len);
 }
 
 static int file_ioctl(struct file *filp, unsigned int cmd,
@@ -503,7 +504,12 @@ static int file_ioctl(struct file *filp, unsigned int cmd,
 		return put_user(i_size_read(inode) - filp->f_pos, p);
 	case FS_IOC_RESVSP:
 	case FS_IOC_RESVSP64:
-		return ioctl_preallocate(filp, p);
+		return ioctl_preallocate(filp, 0, p);
+	case FS_IOC_UNRESVSP:
+	case FS_IOC_UNRESVSP64:
+		return ioctl_preallocate(filp, FALLOC_FL_PUNCH_HOLE, p);
+	case FS_IOC_ZERO_RANGE:
+		return ioctl_preallocate(filp, FALLOC_FL_ZERO_RANGE, p);
 	}
 
 	return vfs_ioctl(filp, cmd, arg);
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index da4aaa75cfd3..3fe1543f9f02 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -588,13 +588,12 @@ xfs_attrmulti_by_handle(
 int
 xfs_ioc_space(
 	struct file		*filp,
-	unsigned int		cmd,
 	xfs_flock64_t		*bf)
 {
 	struct inode		*inode = file_inode(filp);
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct iattr		iattr;
-	enum xfs_prealloc_flags	flags = 0;
+	enum xfs_prealloc_flags	flags = XFS_PREALLOC_CLEAR;
 	uint			iolock = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
 	int			error;
 
@@ -635,65 +634,21 @@ xfs_ioc_space(
 		goto out_unlock;
 	}
 
-	/*
-	 * length of <= 0 for resv/unresv/zero is invalid.  length for
-	 * alloc/free is ignored completely and we have no idea what userspace
-	 * might have set it to, so set it to zero to allow range
-	 * checks to pass.
-	 */
-	switch (cmd) {
-	case XFS_IOC_ZERO_RANGE:
-	case XFS_IOC_UNRESVSP:
-	case XFS_IOC_UNRESVSP64:
-		if (bf->l_len <= 0) {
-			error = -EINVAL;
-			goto out_unlock;
-		}
-		break;
-	default:
-		bf->l_len = 0;
-		break;
-	}
-
-	if (bf->l_start < 0 ||
-	    bf->l_start > inode->i_sb->s_maxbytes ||
-	    bf->l_start + bf->l_len < 0 ||
-	    bf->l_start + bf->l_len >= inode->i_sb->s_maxbytes) {
+	if (bf->l_start < 0 || bf->l_start > inode->i_sb->s_maxbytes) {
 		error = -EINVAL;
 		goto out_unlock;
 	}
 
-	switch (cmd) {
-	case XFS_IOC_ZERO_RANGE:
-		flags |= XFS_PREALLOC_SET;
-		error = xfs_zero_file_space(ip, bf->l_start, bf->l_len);
-		break;
-	case XFS_IOC_UNRESVSP:
-	case XFS_IOC_UNRESVSP64:
-		error = xfs_free_file_space(ip, bf->l_start, bf->l_len);
-		break;
-	case XFS_IOC_ALLOCSP:
-	case XFS_IOC_ALLOCSP64:
-	case XFS_IOC_FREESP:
-	case XFS_IOC_FREESP64:
-		flags |= XFS_PREALLOC_CLEAR;
-		if (bf->l_start > XFS_ISIZE(ip)) {
-			error = xfs_alloc_file_space(ip, XFS_ISIZE(ip),
-					bf->l_start - XFS_ISIZE(ip), 0);
-			if (error)
-				goto out_unlock;
-		}
-
-		iattr.ia_valid = ATTR_SIZE;
-		iattr.ia_size = bf->l_start;
-
-		error = xfs_vn_setattr_size(file_dentry(filp), &iattr);
-		break;
-	default:
-		ASSERT(0);
-		error = -EINVAL;
+	if (bf->l_start > XFS_ISIZE(ip)) {
+		error = xfs_alloc_file_space(ip, XFS_ISIZE(ip),
+				bf->l_start - XFS_ISIZE(ip), 0);
+		if (error)
+			goto out_unlock;
 	}
 
+	iattr.ia_valid = ATTR_SIZE;
+	iattr.ia_size = bf->l_start;
+	error = xfs_vn_setattr_size(file_dentry(filp), &iattr);
 	if (error)
 		goto out_unlock;
 
@@ -2113,16 +2068,13 @@ xfs_file_ioctl(
 		return xfs_ioc_setlabel(filp, mp, arg);
 	case XFS_IOC_ALLOCSP:
 	case XFS_IOC_FREESP:
-	case XFS_IOC_UNRESVSP:
 	case XFS_IOC_ALLOCSP64:
-	case XFS_IOC_FREESP64:
-	case XFS_IOC_UNRESVSP64:
-	case XFS_IOC_ZERO_RANGE: {
+	case XFS_IOC_FREESP64: {
 		xfs_flock64_t		bf;
 
 		if (copy_from_user(&bf, arg, sizeof(bf)))
 			return -EFAULT;
-		return xfs_ioc_space(filp, cmd, &bf);
+		return xfs_ioc_space(filp, &bf);
 	}
 	case XFS_IOC_DIOINFO: {
 		struct dioattr		da;
diff --git a/fs/xfs/xfs_ioctl.h b/fs/xfs/xfs_ioctl.h
index 654c0bb1bcf8..25ef178cbb74 100644
--- a/fs/xfs/xfs_ioctl.h
+++ b/fs/xfs/xfs_ioctl.h
@@ -9,7 +9,6 @@
 extern int
 xfs_ioc_space(
 	struct file		*filp,
-	unsigned int		cmd,
 	xfs_flock64_t		*bf);
 
 int
diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index 257b7caf7fed..3c0d518e1039 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -557,16 +557,13 @@ xfs_file_compat_ioctl(
 	case XFS_IOC_ALLOCSP_32:
 	case XFS_IOC_FREESP_32:
 	case XFS_IOC_ALLOCSP64_32:
-	case XFS_IOC_FREESP64_32:
-	case XFS_IOC_RESVSP64_32:
-	case XFS_IOC_UNRESVSP64_32:
-	case XFS_IOC_ZERO_RANGE_32: {
+	case XFS_IOC_FREESP64_32: {
 		struct xfs_flock64	bf;
 
 		if (xfs_compat_flock64_copyin(&bf, arg))
 			return -EFAULT;
 		cmd = _NATIVE_IOC(cmd, struct xfs_flock64);
-		return xfs_ioc_space(filp, cmd, &bf);
+		return xfs_ioc_space(filp, &bf);
 	}
 	case XFS_IOC_FSGEOMETRY_V1_32:
 		return xfs_compat_ioc_fsgeometry_v1(mp, arg);
diff --git a/include/linux/falloc.h b/include/linux/falloc.h
index 674d59f4d6ce..f5c73f0ec22d 100644
--- a/include/linux/falloc.h
+++ b/include/linux/falloc.h
@@ -20,7 +20,10 @@ struct space_resv {
 };
 
 #define FS_IOC_RESVSP		_IOW('X', 40, struct space_resv)
+#define FS_IOC_UNRESVSP		_IOW('X', 41, struct space_resv)
 #define FS_IOC_RESVSP64		_IOW('X', 42, struct space_resv)
+#define FS_IOC_UNRESVSP64	_IOW('X', 43, struct space_resv)
+#define FS_IOC_ZERO_RANGE	_IOW('X', 57, struct space_resv)
 
 #define	FALLOC_FL_SUPPORTED_MASK	(FALLOC_FL_KEEP_SIZE |		\
 					 FALLOC_FL_PUNCH_HOLE |		\
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e0d909d35763..2b5692207c1d 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2547,7 +2547,7 @@ extern int finish_no_open(struct file *file, struct dentry *dentry);
 
 /* fs/ioctl.c */
 
-extern int ioctl_preallocate(struct file *filp, void __user *argp);
+extern int ioctl_preallocate(struct file *filp, int mode, void __user *argp);
 
 /* fs/dcache.c */
 extern void __init vfs_caches_init_early(void);
-- 
2.20.1

