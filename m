Return-Path: <linux-xfs+bounces-4779-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D09B08796B6
	for <lists+linux-xfs@lfdr.de>; Tue, 12 Mar 2024 15:46:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 00C4F1C221F4
	for <lists+linux-xfs@lfdr.de>; Tue, 12 Mar 2024 14:46:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 993B37C0A2;
	Tue, 12 Mar 2024 14:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="MCCj4xt2"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2911DFD8;
	Tue, 12 Mar 2024 14:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710254744; cv=none; b=hE9dMQjTR5ft4DWsCQMHDXeKBPBcQQp6NMSn1r9NXm5XmQYfQuxSn2nahm7p2DXW6GZ1xmbFzp5RpGaFGDA+1hqowx/5tSaxWn/N2NzzB9NFMBlVF8Zlvkt2A5GKP77y5uLffJ4fRhYQRmpokw68mXmDNELeZFOI86EN1cRwLlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710254744; c=relaxed/simple;
	bh=Ls2beDqT1fpA9RDS0rEL8fsnufcoewqU2agFzA3pmos=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=l4IqdjrIjbvIKSaEjRmetwyUoaFIc52kz0DaN4yMqGXNqepGShKyvIstv1T6OJrew7cEduVo7WjMlce0SHyeRwZxwW552551cuVTYk2Bj9fY78mcC+SoSEFRZppU3t7gDEKO/3/+SjExOljFdApkFeyv6L3n4ULPuZkTS5y8NYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=MCCj4xt2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=vSsMfJD3f2N5FqYGaSXx227O7Ol0Kb1Bq+IO61l8gLU=; b=MCCj4xt2AAzGYF6yq4+ayaTTSi
	zVx2XNkBIH+5HGywq+W/UbXBFjbnm5PkTRK0DGMqVFnirgRB1BIj01AQveVPAi5P4+lUC1AOdJoGS
	mRnX7cOM1LqEFddgaj2Af4X5IVcUifZQNQMtehgeZTt/RbL3ksZXuC5tA+827tX6v9nhAyvnxKH0D
	SrAwODNBsbS32sw16w07NxalqiAE8UMCWA7eHZVtXyq0XTpR/g+nO8J2EADArgwsG6ldqT71pPzGJ
	0wNHaRcFlrP/D7cle6wcgLCaohrZwaeDto0GCcmNmkrRi94wT57AmYjizb4P+HI1YXLhfDlPwhkOA
	tpPgTImg==;
Received: from [50.226.187.238] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rk3Nt-00000006C72-3B5Z;
	Tue, 12 Mar 2024 14:45:42 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Chandan Babu R <chandanbabu@kernel.org>,
	Keith Busch <kbusch@kernel.org>
Cc: linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 1/5] block: move discard checks into the ioctl handler
Date: Tue, 12 Mar 2024 08:45:27 -0600
Message-Id: <20240312144532.1044427-2-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240312144532.1044427-1-hch@lst.de>
References: <20240312144532.1044427-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Most bio operations get basic sanity checking in submit_bio and anything
more complicated than that is done in the callers.  Discards are a bit
different from that in that a lot of checking is done in
__blkdev_issue_discard, and the specific errnos for that are returned
to userspace.  Move the checks that require specific errnos to the ioctl
handler instead and replace the existing kernel sector alignment check
with the actual alignment check based on the logical block size. This
leaves jut the basic sanity checking in submit_bio for the other
submitters of discards and introduces two changes in behavior:

 1) the logical block size alignment check of the start and len is lost
    for non-ioctl callers.
    This matches what is done for other operations including reads and
    writes.  We should probably verify this for all bios, but for now
    make discards match the normal flow.
 2) for non-ioctl callers all errors are reported on I/O completion now
    instead of synchronously.  Callers in general mostly ignore or log
    errors so this will actually simplify the code once cleaned up

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-lib.c | 20 --------------------
 block/ioctl.c   | 13 +++++++++----
 2 files changed, 9 insertions(+), 24 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index dc8e35d0a51d6d..50923508a32466 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -59,26 +59,6 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, struct bio **biop)
 {
 	struct bio *bio = *biop;
-	sector_t bs_mask;
-
-	if (bdev_read_only(bdev))
-		return -EPERM;
-	if (!bdev_max_discard_sectors(bdev))
-		return -EOPNOTSUPP;
-
-	/* In case the discard granularity isn't set by buggy device driver */
-	if (WARN_ON_ONCE(!bdev_discard_granularity(bdev))) {
-		pr_err_ratelimited("%pg: Error: discard_granularity is 0.\n",
-				   bdev);
-		return -EOPNOTSUPP;
-	}
-
-	bs_mask = (bdev_logical_block_size(bdev) >> 9) - 1;
-	if ((sector | nr_sects) & bs_mask)
-		return -EINVAL;
-
-	if (!nr_sects)
-		return -EINVAL;
 
 	while (nr_sects) {
 		sector_t req_sects =
diff --git a/block/ioctl.c b/block/ioctl.c
index 0c76137adcaaa5..57c8171fda93c5 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -95,6 +95,8 @@ static int compat_blkpg_ioctl(struct block_device *bdev,
 static int blk_ioctl_discard(struct block_device *bdev, blk_mode_t mode,
 		unsigned long arg)
 {
+	sector_t bs_mask = (bdev_logical_block_size(bdev) >> SECTOR_SHIFT) - 1;
+	sector_t sector, nr_sects;
 	uint64_t range[2];
 	uint64_t start, len;
 	struct inode *inode = bdev->bd_inode;
@@ -105,18 +107,21 @@ static int blk_ioctl_discard(struct block_device *bdev, blk_mode_t mode,
 
 	if (!bdev_max_discard_sectors(bdev))
 		return -EOPNOTSUPP;
+	if (bdev_read_only(bdev))
+		return -EPERM;
 
 	if (copy_from_user(range, (void __user *)arg, sizeof(range)))
 		return -EFAULT;
 
 	start = range[0];
 	len = range[1];
+	sector = start >> SECTOR_SHIFT;
+	nr_sects = len >> SECTOR_SHIFT;
 
-	if (start & 511)
+	if (!nr_sects)
 		return -EINVAL;
-	if (len & 511)
+	if ((sector | nr_sects) & bs_mask)
 		return -EINVAL;
-
 	if (start + len > bdev_nr_bytes(bdev))
 		return -EINVAL;
 
@@ -124,7 +129,7 @@ static int blk_ioctl_discard(struct block_device *bdev, blk_mode_t mode,
 	err = truncate_bdev_range(bdev, mode, start, start + len - 1);
 	if (err)
 		goto fail;
-	err = blkdev_issue_discard(bdev, start >> 9, len >> 9, GFP_KERNEL);
+	err = blkdev_issue_discard(bdev, sector, nr_sects, GFP_KERNEL);
 fail:
 	filemap_invalidate_unlock(inode->i_mapping);
 	return err;
-- 
2.39.2


