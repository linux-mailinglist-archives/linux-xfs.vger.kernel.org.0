Return-Path: <linux-xfs+bounces-5381-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 56AE68810A1
	for <lists+linux-xfs@lfdr.de>; Wed, 20 Mar 2024 12:14:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D7223B234B7
	for <lists+linux-xfs@lfdr.de>; Wed, 20 Mar 2024 11:14:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AECDA4439F;
	Wed, 20 Mar 2024 11:13:17 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08FD83EA8A;
	Wed, 20 Mar 2024 11:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710933197; cv=none; b=pe/M+5oBf6hh5Nf0g8psbnvurXLO8B1a9FuBjN/hO4JfgGUOJUVBfZMl2TYWVASR4uabGUdY5AMAGecydcbynYPXc19z2J2Ql1Rp+bF2cscVkXQzebK6I2p5E35v1e7mOGUvA1/lXH2pu12qBkkiyMYDvGTQXdCpjF1oPuxS26Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710933197; c=relaxed/simple;
	bh=7m0Uk4v1piAVjb3ow3xNPG2gihflmyetP7oBtlSTaFY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=du8xZ7y6Ns+pzKedbH7HrSXiTXXdV3CqdVqVWhRaBktvh7lIp00+f4pmlRI0G0SBI+o2x/F3LZ5KB3DVFE3d5tl2l1Pk2+f00FYw4xuS7VxlzN8juiWESQrvWMBjElgdLcP+gREQmd80SNOndsDw5rA66fi7VEydypYQ7NHUrq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4V05YC5v38z4f3kjC;
	Wed, 20 Mar 2024 19:13:03 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id C6DF31A0A9B;
	Wed, 20 Mar 2024 19:13:09 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP1 (Coremail) with SMTP id cCh0CgBXKBG5xPplGX0fHg--.18516S7;
	Wed, 20 Mar 2024 19:13:09 +0800 (CST)
From: Zhang Yi <yi.zhang@huaweicloud.com>
To: linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	djwong@kernel.org,
	hch@infradead.org,
	brauner@kernel.org,
	david@fromorbit.com,
	tytso@mit.edu,
	jack@suse.cz,
	yi.zhang@huawei.com,
	yi.zhang@huaweicloud.com,
	chengzhihao1@huawei.com,
	yukuai3@huawei.com
Subject: [PATCH v4 3/9] xfs: make xfs_bmapi_convert_delalloc() to allocate the target offset
Date: Wed, 20 Mar 2024 19:05:42 +0800
Message-Id: <20240320110548.2200662-4-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240320110548.2200662-1-yi.zhang@huaweicloud.com>
References: <20240320110548.2200662-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgBXKBG5xPplGX0fHg--.18516S7
X-Coremail-Antispam: 1UD129KBjvJXoWxCr13tw1DAw48AF1fZrW3Awb_yoWrZrWDpF
	Z3Ca43GF4qqw1rZFsayF10qw1Skw1xCFW8KF43Wwn7Z3yYvr1fWFn2kF1ru34UK3yfZ3W2
	qr45Aa47Wws8Za7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPj14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JrWl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUXVWUAwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v2
	6r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2
	Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
	Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8Jw
	CI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUoL0eDUUU
	U
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

Since xfs_bmapi_convert_delalloc() only attempts to allocate the entire
delalloc extent and require multiple invocations to allocate the target
offset. So xfs_convert_blocks() add a loop to do this job and we call it
in the write back path, but xfs_convert_blocks() isn't a common helper.
Let's do it in xfs_bmapi_convert_delalloc() and drop
xfs_convert_blocks(), preparing for the post EOF delalloc blocks
converting in the buffered write begin path.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c | 34 +++++++++++++++++++++++--
 fs/xfs/xfs_aops.c        | 54 +++++++++++-----------------------------
 2 files changed, 46 insertions(+), 42 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 07dc35de8ce5..e44b9bbe0c4a 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -4516,8 +4516,8 @@ xfs_bmapi_write(
  * invocations to allocate the target offset if a large enough physical extent
  * is not available.
  */
-int
-xfs_bmapi_convert_delalloc(
+static int
+xfs_bmapi_convert_one_delalloc(
 	struct xfs_inode	*ip,
 	int			whichfork,
 	xfs_off_t		offset,
@@ -4648,6 +4648,36 @@ xfs_bmapi_convert_delalloc(
 	return error;
 }
 
+/*
+ * Pass in a dellalloc extent and convert it to real extents, return the real
+ * extent that maps offset_fsb in iomap.
+ */
+int
+xfs_bmapi_convert_delalloc(
+	struct xfs_inode	*ip,
+	int			whichfork,
+	loff_t			offset,
+	struct iomap		*iomap,
+	unsigned int		*seq)
+{
+	int			error;
+
+	/*
+	 * Attempt to allocate whatever delalloc extent currently backs offset
+	 * and put the result into iomap.  Allocate in a loop because it may
+	 * take several attempts to allocate real blocks for a contiguous
+	 * delalloc extent if free space is sufficiently fragmented.
+	 */
+	do {
+		error = xfs_bmapi_convert_one_delalloc(ip, whichfork, offset,
+					iomap, seq);
+		if (error)
+			return error;
+	} while (iomap->offset + iomap->length <= offset);
+
+	return 0;
+}
+
 int
 xfs_bmapi_remap(
 	struct xfs_trans	*tp,
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 813f85156b0c..6479e0dac69d 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -233,45 +233,6 @@ xfs_imap_valid(
 	return true;
 }
 
-/*
- * Pass in a dellalloc extent and convert it to real extents, return the real
- * extent that maps offset_fsb in wpc->iomap.
- *
- * The current page is held locked so nothing could have removed the block
- * backing offset_fsb, although it could have moved from the COW to the data
- * fork by another thread.
- */
-static int
-xfs_convert_blocks(
-	struct iomap_writepage_ctx *wpc,
-	struct xfs_inode	*ip,
-	int			whichfork,
-	loff_t			offset)
-{
-	int			error;
-	unsigned		*seq;
-
-	if (whichfork == XFS_COW_FORK)
-		seq = &XFS_WPC(wpc)->cow_seq;
-	else
-		seq = &XFS_WPC(wpc)->data_seq;
-
-	/*
-	 * Attempt to allocate whatever delalloc extent currently backs offset
-	 * and put the result into wpc->iomap.  Allocate in a loop because it
-	 * may take several attempts to allocate real blocks for a contiguous
-	 * delalloc extent if free space is sufficiently fragmented.
-	 */
-	do {
-		error = xfs_bmapi_convert_delalloc(ip, whichfork, offset,
-				&wpc->iomap, seq);
-		if (error)
-			return error;
-	} while (wpc->iomap.offset + wpc->iomap.length <= offset);
-
-	return 0;
-}
-
 static int
 xfs_map_blocks(
 	struct iomap_writepage_ctx *wpc,
@@ -289,6 +250,7 @@ xfs_map_blocks(
 	struct xfs_iext_cursor	icur;
 	int			retries = 0;
 	int			error = 0;
+	unsigned int		*seq;
 
 	if (xfs_is_shutdown(mp))
 		return -EIO;
@@ -386,7 +348,19 @@ xfs_map_blocks(
 	trace_xfs_map_blocks_found(ip, offset, count, whichfork, &imap);
 	return 0;
 allocate_blocks:
-	error = xfs_convert_blocks(wpc, ip, whichfork, offset);
+	/*
+	 * Convert a dellalloc extent to a real one. The current page is held
+	 * locked so nothing could have removed the block backing offset_fsb,
+	 * although it could have moved from the COW to the data fork by another
+	 * thread.
+	 */
+	if (whichfork == XFS_COW_FORK)
+		seq = &XFS_WPC(wpc)->cow_seq;
+	else
+		seq = &XFS_WPC(wpc)->data_seq;
+
+	error = xfs_bmapi_convert_delalloc(ip, whichfork, offset,
+				&wpc->iomap, seq);
 	if (error) {
 		/*
 		 * If we failed to find the extent in the COW fork we might have
-- 
2.39.2


