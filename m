Return-Path: <linux-xfs+bounces-7975-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 335AD8B766E
	for <lists+linux-xfs@lfdr.de>; Tue, 30 Apr 2024 14:57:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 574B51C20D9F
	for <lists+linux-xfs@lfdr.de>; Tue, 30 Apr 2024 12:57:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42C7C171E48;
	Tue, 30 Apr 2024 12:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Yvtam141"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A6AC17167B
	for <linux-xfs@vger.kernel.org>; Tue, 30 Apr 2024 12:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714481777; cv=none; b=NA7jf/vQzsEc6xkmBYvtFw5gWnR16Zhr90NHoCOB23z1tSuqLQKN9GrA8tmWsDWqWezs0bkKkjQKpGjTc042ajblXLvSkEn21q3zSKTRRP5MulLu7fg9BVeXTOnn7iGWKYC4U1AXLMT2ZrRIGnPQUcwWcco95Ndid8DkbfRaRco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714481777; c=relaxed/simple;
	bh=UDP9MhMGH017lG+i+Ip90qq7xVigPxPeZ8znuL//gEE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ebq9aG0NIK2xhj0K86biqmqP6EQavNRlN+UoZusUGoEMXES0f3sZopWBzmc4/RwBUajGa7Jf3DdZPe2e0yRCtSjVEFo8rSzYm47CvHCRqKX2silzFOoEMVJ4bpvwAKLr/nskLo1vAWp5rqF7tJffBlaqIiq+25wI2BmBJp/dgrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Yvtam141; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=1y673b+B5fE5tmJh1tE+lMzJ3bEyg7JgBaCGQyfdN0U=; b=Yvtam141jl1oJFFJ3S4D015ReE
	0LlrGvcF46V8lqsvVuOWtp+8QLMxfdGsEJRVkj3LNc0WXjHMQVAtDpnI6yTXXH0G3KRZAYaB5QrtK
	hXezZODHRkQM4B9Z1XoEtI6NDcaOm46ggcAr+0/6N6yH4vps70CCZ0/TgYK06H+hSm0w24mHeE1dI
	AB4vaLMp9W7h5680s00y/RYxZTUaX6tQSMiqQSQL2IPpE9El/IVgC3OHu6s8p8H86orLeDVxUoEKP
	nuPFbXxnpbCWOq2qb22HmMvwTTDwgfg2g9NXoGTgZdAD/KMY9PomJnddaPC8S7TX8umPXq0kjHtsX
	Rqzag3sg==;
Received: from [2001:4bb8:188:7ba8:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s1n1q-00000006P8b-0yMt;
	Tue, 30 Apr 2024 12:56:14 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 3/3] xfs: simplify iext overflow checking and upgrade
Date: Tue, 30 Apr 2024 14:56:02 +0200
Message-Id: <20240430125602.1776108-4-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240430125602.1776108-1-hch@lst.de>
References: <20240430125602.1776108-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Currently the calls to xfs_iext_count_may_overflow and
xfs_iext_count_upgrade are always paired.  Merge them into a single
function to simplify the callers and the actual check and upgrade
logic itself.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c       |  5 +--
 fs/xfs/libxfs/xfs_bmap.c       |  5 +--
 fs/xfs/libxfs/xfs_inode_fork.c | 57 +++++++++++++++-------------------
 fs/xfs/libxfs/xfs_inode_fork.h |  6 ++--
 fs/xfs/xfs_bmap_item.c         |  4 +--
 fs/xfs/xfs_bmap_util.c         | 24 +++-----------
 fs/xfs/xfs_dquot.c             |  5 +--
 fs/xfs/xfs_iomap.c             |  9 ++----
 fs/xfs/xfs_reflink.c           |  9 ++----
 fs/xfs/xfs_rtalloc.c           |  5 +--
 10 files changed, 41 insertions(+), 88 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 1c2a27fce08a9d..ded92ccefe9f6d 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -1050,11 +1050,8 @@ xfs_attr_set(
 		return error;
 
 	if (op != XFS_ATTRUPDATE_REMOVE || xfs_inode_hasattr(dp)) {
-		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
+		error = xfs_iext_count_ensure(args->trans, dp, XFS_ATTR_FORK,
 				XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
-		if (error == -EFBIG)
-			error = xfs_iext_count_upgrade(args->trans, dp,
-					XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
 		if (error)
 			goto out_trans_cancel;
 	}
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 6053f5e5c71eec..3debd0d561b812 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4621,11 +4621,8 @@ xfs_bmapi_convert_delalloc(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
-	error = xfs_iext_count_may_overflow(ip, whichfork,
+	error = xfs_iext_count_ensure(tp, ip, whichfork,
 			XFS_IEXT_ADD_NOSPLIT_CNT);
-	if (error == -EFBIG)
-		error = xfs_iext_count_upgrade(tp, ip,
-				XFS_IEXT_ADD_NOSPLIT_CNT);
 	if (error)
 		goto out_trans_cancel;
 
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 7d660a9739090a..82e670dd1212c4 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -765,53 +765,46 @@ xfs_ifork_verify_local_attr(
 	return 0;
 }
 
+/*
+ * Check if the inode fork supports adding nr_to_add more extents.
+ *
+ * If it doesn't but we can upgrade it to large extent counters, do the upgrade.
+ * If we can't upgrade or are already using big counters but still can't fit the
+ * additional extents, return -EFBIG.
+ */
 int
-xfs_iext_count_may_overflow(
+xfs_iext_count_ensure(
+	struct xfs_trans	*tp,
 	struct xfs_inode	*ip,
 	int			whichfork,
-	int			nr_to_add)
+	uint			nr_to_add)
 {
+	struct xfs_mount	*mp = ip->i_mount;
+	bool			has_large =
+		xfs_inode_has_large_extent_counts(ip);
 	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
-	uint64_t		max_exts;
 	uint64_t		nr_exts;
 
+	ASSERT(nr_to_add <= XFS_MAX_EXTCNT_UPGRADE_NR);
+
 	if (whichfork == XFS_COW_FORK)
 		return 0;
 
-	max_exts = xfs_iext_max_nextents(xfs_inode_has_large_extent_counts(ip),
-				whichfork);
-
-	if (XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
-		max_exts = 10;
-
+	/* no point in upgrading if if_nextents overflows */
 	nr_exts = ifp->if_nextents + nr_to_add;
-	if (nr_exts < ifp->if_nextents || nr_exts > max_exts)
+	if (nr_exts < ifp->if_nextents)
 		return -EFBIG;
 
-	return 0;
-}
-
-/*
- * Upgrade this inode's extent counter fields to be able to handle a potential
- * increase in the extent count by nr_to_add.  Normally this is the same
- * quantity that caused xfs_iext_count_may_overflow() to return -EFBIG.
- */
-int
-xfs_iext_count_upgrade(
-	struct xfs_trans	*tp,
-	struct xfs_inode	*ip,
-	uint			nr_to_add)
-{
-	ASSERT(nr_to_add <= XFS_MAX_EXTCNT_UPGRADE_NR);
-
-	if (!xfs_has_large_extent_counts(ip->i_mount) ||
-	    xfs_inode_has_large_extent_counts(ip) ||
-	    XFS_TEST_ERROR(false, ip->i_mount, XFS_ERRTAG_REDUCE_MAX_IEXTENTS))
+	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_REDUCE_MAX_IEXTENTS) &&
+	    nr_exts > 10)
 		return -EFBIG;
 
-	ip->i_diflags2 |= XFS_DIFLAG2_NREXT64;
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-
+	if (nr_exts > xfs_iext_max_nextents(has_large, whichfork)) {
+		if (has_large || !xfs_has_large_extent_counts(mp))
+			return -EFBIG;
+		ip->i_diflags2 |= XFS_DIFLAG2_NREXT64;
+		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	}
 	return 0;
 }
 
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index bd53eb951b6515..9e1456f5cc2c85 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -256,10 +256,8 @@ extern void xfs_ifork_init_cow(struct xfs_inode *ip);
 
 int xfs_ifork_verify_local_data(struct xfs_inode *ip);
 int xfs_ifork_verify_local_attr(struct xfs_inode *ip);
-int xfs_iext_count_may_overflow(struct xfs_inode *ip, int whichfork,
-		int nr_to_add);
-int xfs_iext_count_upgrade(struct xfs_trans *tp, struct xfs_inode *ip,
-		uint nr_to_add);
+int xfs_iext_count_ensure(struct xfs_trans *tp, struct xfs_inode *ip,
+		int whichfork, uint nr_to_add);
 bool xfs_ifork_is_realtime(struct xfs_inode *ip, int whichfork);
 
 /* returns true if the fork has extents but they are not read in yet. */
diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index d27859a684aa69..38067d02ee3ca7 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -524,9 +524,7 @@ xfs_bmap_recover_work(
 	else
 		iext_delta = XFS_IEXT_PUNCH_HOLE_CNT;
 
-	error = xfs_iext_count_may_overflow(ip, work->bi_whichfork, iext_delta);
-	if (error == -EFBIG)
-		error = xfs_iext_count_upgrade(tp, ip, iext_delta);
+	error = xfs_iext_count_ensure(tp, ip, work->bi_whichfork, iext_delta);
 	if (error)
 		goto err_cancel;
 
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 53aa90a0ee3a85..11062bddba0e5e 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -713,11 +713,8 @@ xfs_alloc_file_space(
 		if (error)
 			break;
 
-		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+		error = xfs_iext_count_ensure(tp, ip, XFS_DATA_FORK,
 				XFS_IEXT_ADD_NOSPLIT_CNT);
-		if (error == -EFBIG)
-			error = xfs_iext_count_upgrade(tp, ip,
-					XFS_IEXT_ADD_NOSPLIT_CNT);
 		if (error)
 			goto error;
 
@@ -775,10 +772,8 @@ xfs_unmap_extent(
 	if (error)
 		return error;
 
-	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+	error = xfs_iext_count_ensure(tp, ip, XFS_DATA_FORK,
 			XFS_IEXT_PUNCH_HOLE_CNT);
-	if (error == -EFBIG)
-		error = xfs_iext_count_upgrade(tp, ip, XFS_IEXT_PUNCH_HOLE_CNT);
 	if (error)
 		goto out_trans_cancel;
 
@@ -1054,10 +1049,8 @@ xfs_insert_file_space(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
-	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+	error = xfs_iext_count_ensure(tp, ip, XFS_DATA_FORK,
 			XFS_IEXT_PUNCH_HOLE_CNT);
-	if (error == -EFBIG)
-		error = xfs_iext_count_upgrade(tp, ip, XFS_IEXT_PUNCH_HOLE_CNT);
 	if (error)
 		goto out_trans_cancel;
 
@@ -1283,23 +1276,16 @@ xfs_swap_extent_rmap(
 			trace_xfs_swap_extent_rmap_remap_piece(tip, &uirec);
 
 			if (xfs_bmap_is_real_extent(&uirec)) {
-				error = xfs_iext_count_may_overflow(ip,
-						XFS_DATA_FORK,
+				error = xfs_iext_count_ensure(tp, ip, XFS_DATA_FORK,
 						XFS_IEXT_SWAP_RMAP_CNT);
-				if (error == -EFBIG)
-					error = xfs_iext_count_upgrade(tp, ip,
-							XFS_IEXT_SWAP_RMAP_CNT);
 				if (error)
 					goto out;
 			}
 
 			if (xfs_bmap_is_real_extent(&irec)) {
-				error = xfs_iext_count_may_overflow(tip,
+				error = xfs_iext_count_ensure(tp, tip,
 						XFS_DATA_FORK,
 						XFS_IEXT_SWAP_RMAP_CNT);
-				if (error == -EFBIG)
-					error = xfs_iext_count_upgrade(tp, ip,
-							XFS_IEXT_SWAP_RMAP_CNT);
 				if (error)
 					goto out;
 			}
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 13aba84bd64afb..c2e66d392399dd 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -341,11 +341,8 @@ xfs_dquot_disk_alloc(
 		goto err_cancel;
 	}
 
-	error = xfs_iext_count_may_overflow(quotip, XFS_DATA_FORK,
+	error = xfs_iext_count_ensure(tp, quotip, XFS_DATA_FORK,
 			XFS_IEXT_ADD_NOSPLIT_CNT);
-	if (error == -EFBIG)
-		error = xfs_iext_count_upgrade(tp, quotip,
-				XFS_IEXT_ADD_NOSPLIT_CNT);
 	if (error)
 		goto err_cancel;
 
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 9ce0f6b9df93e6..9dfb8e1a5a55cb 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -299,9 +299,7 @@ xfs_iomap_write_direct(
 	if (error)
 		return error;
 
-	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK, nr_exts);
-	if (error == -EFBIG)
-		error = xfs_iext_count_upgrade(tp, ip, nr_exts);
+	error = xfs_iext_count_ensure(tp, ip, XFS_DATA_FORK, nr_exts);
 	if (error)
 		goto out_trans_cancel;
 
@@ -625,11 +623,8 @@ xfs_iomap_write_unwritten(
 		if (error)
 			return error;
 
-		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+		error = xfs_iext_count_ensure(tp, ip, XFS_DATA_FORK,
 				XFS_IEXT_WRITE_UNWRITTEN_CNT);
-		if (error == -EFBIG)
-			error = xfs_iext_count_upgrade(tp, ip,
-					XFS_IEXT_WRITE_UNWRITTEN_CNT);
 		if (error)
 			goto error_on_bmapi_transaction;
 
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 0ab2ef5b58f6c4..323d5494149698 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -773,11 +773,8 @@ xfs_reflink_end_cow_extent(
 	del = got;
 	xfs_trim_extent(&del, *offset_fsb, end_fsb - *offset_fsb);
 
-	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+	error = xfs_iext_count_ensure(tp, ip, XFS_DATA_FORK,
 			XFS_IEXT_REFLINK_END_COW_CNT);
-	if (error == -EFBIG)
-		error = xfs_iext_count_upgrade(tp, ip,
-				XFS_IEXT_REFLINK_END_COW_CNT);
 	if (error)
 		goto out_cancel;
 
@@ -1277,9 +1274,7 @@ xfs_reflink_remap_extent(
 	if (dmap_written)
 		++iext_delta;
 
-	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK, iext_delta);
-	if (error == -EFBIG)
-		error = xfs_iext_count_upgrade(tp, ip, iext_delta);
+	error = xfs_iext_count_ensure(tp, ip, XFS_DATA_FORK, iext_delta);
 	if (error)
 		goto out_cancel;
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index b476a876478d93..37edf4c5ce73ad 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -695,11 +695,8 @@ xfs_growfs_rt_alloc(
 		xfs_ilock(ip, XFS_ILOCK_EXCL);
 		xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 
-		error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK,
+		error = xfs_iext_count_ensure(tp, ip, XFS_DATA_FORK,
 				XFS_IEXT_ADD_NOSPLIT_CNT);
-		if (error == -EFBIG)
-			error = xfs_iext_count_upgrade(tp, ip,
-					XFS_IEXT_ADD_NOSPLIT_CNT);
 		if (error)
 			goto out_trans_cancel;
 
-- 
2.39.2


