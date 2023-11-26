Return-Path: <linux-xfs+bounces-110-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DCDE17F92C7
	for <lists+linux-xfs@lfdr.de>; Sun, 26 Nov 2023 14:01:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 701D128119A
	for <lists+linux-xfs@lfdr.de>; Sun, 26 Nov 2023 13:01:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2A78D262;
	Sun, 26 Nov 2023 13:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LsNLXTuF"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D76F5110
	for <linux-xfs@vger.kernel.org>; Sun, 26 Nov 2023 05:01:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=0X/0Jg1VQ6nw9Ha2XbS5uhAr0IwDKkPln+CTMWEPLpE=; b=LsNLXTuFbZWrjwVBjiPgVw9kjc
	ekSj9dENJpGAbElnZ2xWslZAdcWq7jNE5qECXkLxI3VBG9QkKfd1h/5zSxGi4z08UrWmj2TJQiGdO
	VWVe7SLD88hPa2EFI58tkOjb58zj9vMUMli37ByRATWbU7IYFJW32o+ANIPfMSo2CIfG+4frdLAoW
	qZeI/OQeVsGzxQR8WtQAPUB7+pITTYUtrBJVOQBXkpXBLkedSi0cDRubpHCsE3Nzm1f/dVZokNLe2
	sHy2nLNkCtqcp1UmYmBW9WKkAwPLGAXng8MgNYz1XFIJf2RXNZTfpTMoYYibRHPgh2n6F6Nd79lIT
	9u9ac6CQ==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1r7ElT-00BGiO-0F;
	Sun, 26 Nov 2023 13:01:36 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/4] xfs: clean up the XFS_IOC_FSCOUNTS handler
Date: Sun, 26 Nov 2023 14:01:22 +0100
Message-Id: <20231126130124.1251467-3-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231126130124.1251467-1-hch@lst.de>
References: <20231126130124.1251467-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Split XFS_IOC_FSCOUNTS out of the main xfs_file_ioctl function, and
merge the xfs_fs_counts helper into the ioctl handler.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_fsops.c | 16 ----------------
 fs/xfs/xfs_fsops.h |  1 -
 fs/xfs/xfs_ioctl.c | 29 ++++++++++++++++++++---------
 3 files changed, 20 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 7cb75cb6b8e9b4..01681783e2c31a 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -343,22 +343,6 @@ xfs_growfs_log(
 	return error;
 }
 
-/*
- * exported through ioctl XFS_IOC_FSCOUNTS
- */
-
-void
-xfs_fs_counts(
-	xfs_mount_t		*mp,
-	xfs_fsop_counts_t	*cnt)
-{
-	cnt->allocino = percpu_counter_read_positive(&mp->m_icount);
-	cnt->freeino = percpu_counter_read_positive(&mp->m_ifree);
-	cnt->freedata = percpu_counter_read_positive(&mp->m_fdblocks) -
-						xfs_fdblocks_unavailable(mp);
-	cnt->freertx = percpu_counter_read_positive(&mp->m_frextents);
-}
-
 /*
  * exported through ioctl XFS_IOC_SET_RESBLKS & XFS_IOC_GET_RESBLKS
  *
diff --git a/fs/xfs/xfs_fsops.h b/fs/xfs/xfs_fsops.h
index 2cffe51a31e8b2..45f0cb6e805938 100644
--- a/fs/xfs/xfs_fsops.h
+++ b/fs/xfs/xfs_fsops.h
@@ -8,7 +8,6 @@
 
 extern int xfs_growfs_data(struct xfs_mount *mp, struct xfs_growfs_data *in);
 extern int xfs_growfs_log(struct xfs_mount *mp, struct xfs_growfs_log *in);
-extern void xfs_fs_counts(xfs_mount_t *mp, xfs_fsop_counts_t *cnt);
 extern int xfs_reserve_blocks(xfs_mount_t *mp, uint64_t *inval,
 				xfs_fsop_resblks_t *outval);
 extern int xfs_fs_goingdown(xfs_mount_t *mp, uint32_t inflags);
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 8faaf2ef67a7b8..c8e78c8101c65c 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1902,6 +1902,24 @@ xfs_ioctl_getset_resblocks(
 	return 0;
 }
 
+static int
+xfs_ioctl_fs_counts(
+	struct xfs_mount	*mp,
+	struct xfs_fsop_counts	*uarg)
+{
+	struct xfs_fsop_counts	out = {
+		.allocino = percpu_counter_read_positive(&mp->m_icount),
+		.freeino = percpu_counter_read_positive(&mp->m_ifree),
+		.freedata = percpu_counter_read_positive(&mp->m_fdblocks) -
+				xfs_fdblocks_unavailable(mp),
+		.freertx = percpu_counter_read_positive(&mp->m_frextents),
+	};
+
+	if (copy_to_user(uarg, &out, sizeof(out)))
+		return -EFAULT;
+	return 0;
+}
+
 /*
  * These long-unused ioctls were removed from the official ioctl API in 5.17,
  * but retain these definitions so that we can log warnings about them.
@@ -2038,15 +2056,8 @@ xfs_file_ioctl(
 		return error;
 	}
 
-	case XFS_IOC_FSCOUNTS: {
-		xfs_fsop_counts_t out;
-
-		xfs_fs_counts(mp, &out);
-
-		if (copy_to_user(arg, &out, sizeof(out)))
-			return -EFAULT;
-		return 0;
-	}
+	case XFS_IOC_FSCOUNTS:
+		return xfs_ioctl_fs_counts(mp, arg);
 
 	case XFS_IOC_SET_RESBLKS:
 	case XFS_IOC_GET_RESBLKS:
-- 
2.39.2


