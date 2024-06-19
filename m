Return-Path: <linux-xfs+bounces-9497-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3327790EA1C
	for <lists+linux-xfs@lfdr.de>; Wed, 19 Jun 2024 13:54:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C4D932841C5
	for <lists+linux-xfs@lfdr.de>; Wed, 19 Jun 2024 11:54:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 035BB13DDB4;
	Wed, 19 Jun 2024 11:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3H287grF"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8978137747
	for <linux-xfs@vger.kernel.org>; Wed, 19 Jun 2024 11:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718798074; cv=none; b=p5YAxH6NFelgkNXruaKrmIwtxgqwsM5QT+nFQPDsfkxcNAB3IXssxaN5RO2GcbzmTY6AGJG6l2vX4f05VMiYp4nKJp5u2CTsG3RdTJ81gwtJHXCFSmDEhC8hjt6vENzSOD47IJRbxNgoAlBxe+7v2nD4OkzbdrfQZLJTziWLQyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718798074; c=relaxed/simple;
	bh=2ceETvIZVnivoxfrdlOMZunonIkde0gGypO+irm1a0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tmupcvAeXd/bOtr0BTShfCQSF4PmFKUvCwBa1OmuiOF9oajJp8LBdfUu0/E8YR0WghFnOt09nB9ZQvJx6v2VYlhaU9hyD1LpLbGRgYtMINeRmobQK8jufNTJuu3hjedU1fmTmKqYAzngglVVtNBXLue76iuGNkYUYcRfKFt6vAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3H287grF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=km9pqJBc15cNzjV8YL5dc4OVBT9Ut/+5PfqYsw27YX8=; b=3H287grFJEJSppT6718zGgEFSp
	cpbEAPS3AUUdWsUgr5YOWQniV63jaSw4W2V9yGbYpDSlZOYhTcF3I9CLVkmmvp305KcZ/AnwafDji
	WwdTD3jo//VAsM7t/uLMgs3p1P9rqltX3/5uE/zvEyL6ztiejKt60oqC+ZNy8Dq2LVzZTyxZ41ol/
	FWiSbCyfuMSBCToAiky3Ac9A4HiIk2akd9YY/elIB+KS0f8vWpQICiRja5A6TkCe8eMZ8TukE23Hc
	0+TH4townCp0efy8N4dGHxZ0ncBNasEAOhthMlagZEMTCHrB9RQMROCvY3yGsLuVHyEm9jyXp3dNI
	IpSKqWUw==;
Received: from 2a02-8389-2341-5b80-3836-7e72-cede-2f46.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:3836:7e72:cede:2f46] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sJttX-000000014O2-3Qzj;
	Wed, 19 Jun 2024 11:54:32 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/6] xfs: move the dio write relocking out of xfs_ilock_for_iomap
Date: Wed, 19 Jun 2024 13:53:51 +0200
Message-ID: <20240619115426.332708-2-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240619115426.332708-1-hch@lst.de>
References: <20240619115426.332708-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

About half of xfs_ilock_for_iomap deals with a special case for direct
I/O writes to COW files that need to take the ilock exclusively.  Move
this code into the one callers that cares and simplify
xfs_ilock_for_iomap.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_iomap.c | 71 ++++++++++++++++++++++------------------------
 1 file changed, 34 insertions(+), 37 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 3783426739258c..b0085e5972393a 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -717,53 +717,30 @@ imap_needs_cow(
 	return true;
 }
 
+/*
+ * Extents not yet cached requires exclusive access, don't block for
+ * IOMAP_NOWAIT.
+ *
+ * This is basically an opencoded xfs_ilock_data_map_shared() call, but with
+ * support for IOMAP_NOWAIT.
+ */
 static int
 xfs_ilock_for_iomap(
 	struct xfs_inode	*ip,
 	unsigned		flags,
 	unsigned		*lockmode)
 {
-	unsigned int		mode = *lockmode;
-	bool			is_write = flags & (IOMAP_WRITE | IOMAP_ZERO);
-
-	/*
-	 * COW writes may allocate delalloc space or convert unwritten COW
-	 * extents, so we need to make sure to take the lock exclusively here.
-	 */
-	if (xfs_is_cow_inode(ip) && is_write)
-		mode = XFS_ILOCK_EXCL;
-
-	/*
-	 * Extents not yet cached requires exclusive access, don't block.  This
-	 * is an opencoded xfs_ilock_data_map_shared() call but with
-	 * non-blocking behaviour.
-	 */
-	if (xfs_need_iread_extents(&ip->i_df)) {
-		if (flags & IOMAP_NOWAIT)
-			return -EAGAIN;
-		mode = XFS_ILOCK_EXCL;
-	}
-
-relock:
 	if (flags & IOMAP_NOWAIT) {
-		if (!xfs_ilock_nowait(ip, mode))
+		if (xfs_need_iread_extents(&ip->i_df))
+			return -EAGAIN;
+		if (!xfs_ilock_nowait(ip, *lockmode))
 			return -EAGAIN;
 	} else {
-		xfs_ilock(ip, mode);
+		if (xfs_need_iread_extents(&ip->i_df))
+			*lockmode = XFS_ILOCK_EXCL;
+		xfs_ilock(ip, *lockmode);
 	}
 
-	/*
-	 * The reflink iflag could have changed since the earlier unlocked
-	 * check, so if we got ILOCK_SHARED for a write and but we're now a
-	 * reflink inode we have to switch to ILOCK_EXCL and relock.
-	 */
-	if (mode == XFS_ILOCK_SHARED && is_write && xfs_is_cow_inode(ip)) {
-		xfs_iunlock(ip, mode);
-		mode = XFS_ILOCK_EXCL;
-		goto relock;
-	}
-
-	*lockmode = mode;
 	return 0;
 }
 
@@ -801,7 +778,7 @@ xfs_direct_write_iomap_begin(
 	int			nimaps = 1, error = 0;
 	bool			shared = false;
 	u16			iomap_flags = 0;
-	unsigned int		lockmode = XFS_ILOCK_SHARED;
+	unsigned int		lockmode;
 	u64			seq;
 
 	ASSERT(flags & (IOMAP_WRITE | IOMAP_ZERO));
@@ -817,10 +794,30 @@ xfs_direct_write_iomap_begin(
 	if (offset + length > i_size_read(inode))
 		iomap_flags |= IOMAP_F_DIRTY;
 
+	/*
+	 * COW writes may allocate delalloc space or convert unwritten COW
+	 * extents, so we need to make sure to take the lock exclusively here.
+	 */
+	if (xfs_is_cow_inode(ip))
+		lockmode = XFS_ILOCK_EXCL;
+	else
+		lockmode = XFS_ILOCK_SHARED;
+
+relock:
 	error = xfs_ilock_for_iomap(ip, flags, &lockmode);
 	if (error)
 		return error;
 
+	/*
+	 * The reflink iflag could have changed since the earlier unlocked
+	 * check, check if it again and relock if needed.
+	 */
+	if (xfs_is_cow_inode(ip) && lockmode == XFS_ILOCK_SHARED) {
+		xfs_iunlock(ip, lockmode);
+		lockmode = XFS_ILOCK_EXCL;
+		goto relock;
+	}
+
 	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb, &imap,
 			       &nimaps, 0);
 	if (error)
-- 
2.43.0


