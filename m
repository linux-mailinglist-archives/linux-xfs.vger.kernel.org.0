Return-Path: <linux-xfs+bounces-398-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 865FD803BD7
	for <lists+linux-xfs@lfdr.de>; Mon,  4 Dec 2023 18:41:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3AFB32810D0
	for <lists+linux-xfs@lfdr.de>; Mon,  4 Dec 2023 17:41:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BCB72E857;
	Mon,  4 Dec 2023 17:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="K9EU1aWY"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4987ED3
	for <linux-xfs@vger.kernel.org>; Mon,  4 Dec 2023 09:41:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=DjBpB82NIPqIvdHEpIiFyUWmT0qyMF3gfTnYj/AJgCY=; b=K9EU1aWYUEfLne13XfZO6oXzzM
	yYSVd1u9xfT0rjqoNSgqvsWUlZo9w1KO9AzMpFLv3V8skimYTh/kMnL/eNkQOy3qwYluaMU4d+P6g
	hvC2kD6qB1fAdN7mSked5e1NeXFZXZz5wVYMdPHxahg1ivwQKzRNbiXj1Dk0cic6fxxCjYGQ/t9dQ
	FvAF8uryRIY0JzTbyfU+DhGCLRhkASqR3mO/r+KFnUSv7LUkkGFpD9JRG+P7KBpvkttlBeqqRthRH
	xDrPF59DO3Tv09i5KqN+wgSvSAXJ8P2zPiY5OHCK4ED9T+4pB3AqjXAQAeOsZ05Wb4MlH/inuX2vY
	tiniEiYg==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rACwJ-005DiR-0o;
	Mon, 04 Dec 2023 17:41:03 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/4] xfs: clean up the XFS_IOC_{GS}ET_RESBLKS handler
Date: Mon,  4 Dec 2023 18:40:54 +0100
Message-Id: <20231204174057.786932-2-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231204174057.786932-1-hch@lst.de>
References: <20231204174057.786932-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The XFS_IOC_GET_RESBLKS and XFS_IOC_SET_RESBLKS already share a fair
amount of code, and will share even more soon.  Move the logic for both
of them out of the main xfs_file_ioctl function into a
xfs_ioctl_getset_resblocks helper to share the code and prepare for
additional changes.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_ioctl.c | 87 +++++++++++++++++++++++-----------------------
 1 file changed, 43 insertions(+), 44 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index a82470e027f727..8faaf2ef67a7b8 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1862,6 +1862,46 @@ xfs_fs_eofblocks_from_user(
 	return 0;
 }
 
+static int
+xfs_ioctl_getset_resblocks(
+	struct file		*filp,
+	unsigned int		cmd,
+	void __user		*arg)
+{
+	struct xfs_mount	*mp = XFS_I(file_inode(filp))->i_mount;
+	struct xfs_fsop_resblks	fsop = { };
+	int			error;
+	uint64_t		in;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (cmd == XFS_IOC_SET_RESBLKS) {
+		if (xfs_is_readonly(mp))
+			return -EROFS;
+
+		if (copy_from_user(&fsop, arg, sizeof(fsop)))
+			return -EFAULT;
+
+		error = mnt_want_write_file(filp);
+		if (error)
+			return error;
+		in = fsop.resblks;
+		error = xfs_reserve_blocks(mp, &in, &fsop);
+		mnt_drop_write_file(filp);
+		if (error)
+			return error;
+	} else {
+		error = xfs_reserve_blocks(mp, NULL, &fsop);
+		if (error)
+			return error;
+	}
+
+	if (copy_to_user(arg, &fsop, sizeof(fsop)))
+		return -EFAULT;
+	return 0;
+}
+
 /*
  * These long-unused ioctls were removed from the official ioctl API in 5.17,
  * but retain these definitions so that we can log warnings about them.
@@ -2008,50 +2048,9 @@ xfs_file_ioctl(
 		return 0;
 	}
 
-	case XFS_IOC_SET_RESBLKS: {
-		xfs_fsop_resblks_t inout;
-		uint64_t	   in;
-
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-
-		if (xfs_is_readonly(mp))
-			return -EROFS;
-
-		if (copy_from_user(&inout, arg, sizeof(inout)))
-			return -EFAULT;
-
-		error = mnt_want_write_file(filp);
-		if (error)
-			return error;
-
-		/* input parameter is passed in resblks field of structure */
-		in = inout.resblks;
-		error = xfs_reserve_blocks(mp, &in, &inout);
-		mnt_drop_write_file(filp);
-		if (error)
-			return error;
-
-		if (copy_to_user(arg, &inout, sizeof(inout)))
-			return -EFAULT;
-		return 0;
-	}
-
-	case XFS_IOC_GET_RESBLKS: {
-		xfs_fsop_resblks_t out;
-
-		if (!capable(CAP_SYS_ADMIN))
-			return -EPERM;
-
-		error = xfs_reserve_blocks(mp, NULL, &out);
-		if (error)
-			return error;
-
-		if (copy_to_user(arg, &out, sizeof(out)))
-			return -EFAULT;
-
-		return 0;
-	}
+	case XFS_IOC_SET_RESBLKS:
+	case XFS_IOC_GET_RESBLKS:
+		return xfs_ioctl_getset_resblocks(filp, cmd, arg);
 
 	case XFS_IOC_FSGROWFSDATA: {
 		struct xfs_growfs_data in;
-- 
2.39.2


