Return-Path: <linux-xfs+bounces-11410-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D4EC94C154
	for <lists+linux-xfs@lfdr.de>; Thu,  8 Aug 2024 17:29:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BF2EE1F2B923
	for <lists+linux-xfs@lfdr.de>; Thu,  8 Aug 2024 15:29:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 010F2190661;
	Thu,  8 Aug 2024 15:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IyAblN0c"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53941190072
	for <linux-xfs@vger.kernel.org>; Thu,  8 Aug 2024 15:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723130910; cv=none; b=kGJBo8FYsdkFQJMhoAI5K8aO8dzYsj8OWp6DvASwcEb4GF/MTfHZQx9srbHhAOliBMFuLqb7Epiz1Q1gGvFpwfPOfIqkIRRUJyia+O7dlb81O1iGD7/HfV24pd6CvjWHlP9MAE1thF2gz0r/3/Tdo3r1JZ/DY4w+AMrcJHvabNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723130910; c=relaxed/simple;
	bh=J6Leu8/NjO23GT58hVUMPeJM2l3c+SYzc021Q0VWY/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jWkwRg85cFQAfYdIHOUQX2TqKIgb7exZ4glWTIqYpe7eXr1tIBGpZnhw1pFqndETeYc5UXqq+1KP3Z/0A9ANZmUJjhAgTyNDGdSDQqM3lfx97ObfgUTrO3t37W4WQ1sABYUKS57ZtYf0BKsLVlI54b+x3uG4f2xOoxmbcIQpaXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IyAblN0c; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=QobfccF+bzo+Z4/oCpc3aso3/9FbArdyguCNPPZZfCk=; b=IyAblN0cep1O54c9KOt2IbKoiD
	C3+xFfba4wD9xH4y162AAK1LS7+RbCddChkjZ9rRWQx6bNbnWluJdeZphjWRTxt0j1oIG04ItAmtc
	Uj9X3boI0OsBUMKqBloh5CW0rH2leB8jw+C1V6c+7z5DOKhNFWFW2l0XxzzHX+YZEkOLvwTToyFkv
	4SOO2JS/WmqSf5h50aFeQWfA+l96WcyXfjF9NsfulZ/WBF78ilgiXGiDm5d0C9Kp0gpPWH2Uara06
	iXE/Utxat2m4NPRSMFSfXMvlLtm00x8+7vXD8MhomlEev4oFJCmhPzOrXB6f9vf46nTEHEViJ/IRB
	AtyppXTA==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sc540-00000008kWh-2tbN;
	Thu, 08 Aug 2024 15:28:28 +0000
From: Christoph Hellwig <hch@lst.de>
To: Chandan Babu R <chandan.babu@oracle.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 5/9] xfs: don't free post-EOF blocks on read close
Date: Thu,  8 Aug 2024 08:27:31 -0700
Message-ID: <20240808152826.3028421-6-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240808152826.3028421-1-hch@lst.de>
References: <20240808152826.3028421-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

From: Dave Chinner <dchinner@redhat.com>

When we have a workload that does open/read/close in parallel with other
allocation, the file becomes rapidly fragmented. This is due to close()
calling xfs_file_release() and removing the speculative preallocation
beyond EOF.

Add a check for a writable context to xfs_file_release to skip the
post-EOF block freeing (an the similarly pointless flushing on truncate
down).

Before:

Test 1: sync write fragmentation counts

/mnt/scratch/file.0: 919
/mnt/scratch/file.1: 916
/mnt/scratch/file.2: 919
/mnt/scratch/file.3: 920
/mnt/scratch/file.4: 920
/mnt/scratch/file.5: 921
/mnt/scratch/file.6: 916
/mnt/scratch/file.7: 918

After:

Test 1: sync write fragmentation counts

/mnt/scratch/file.0: 24
/mnt/scratch/file.1: 24
/mnt/scratch/file.2: 11
/mnt/scratch/file.3: 24
/mnt/scratch/file.4: 3
/mnt/scratch/file.5: 24
/mnt/scratch/file.6: 24
/mnt/scratch/file.7: 23

Signed-off-by: Dave Chinner <dchinner@redhat.com>
[darrick: wordsmithing, fix commit message]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
[hch: ported to the new ->release code structure]
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_file.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index dae8dd1223550d..60424e64230743 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1217,12 +1217,18 @@ xfs_file_release(
 	 * There is no point in freeing blocks here for open but unlinked files
 	 * as they will be taken care of by the inactivation path soon.
 	 *
+	 * When releasing a read-only context, don't flush data or trim post-EOF
+	 * blocks.  This avoids open/read/close workloads from removing EOF
+	 * blocks that other writers depend upon to reduce fragmentation.
+	 *
 	 * If we can't get the iolock just skip truncating the blocks past EOF
 	 * because we could deadlock with the mmap_lock otherwise. We'll get
 	 * another chance to drop them once the last reference to the inode is
 	 * dropped, so we'll never leak blocks permanently.
 	 */
-	if (inode->i_nlink && xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
+	if (inode->i_nlink &&
+	    (file->f_mode & FMODE_WRITE) &&
+	    xfs_ilock_nowait(ip, XFS_IOLOCK_EXCL)) {
 		if (xfs_can_free_eofblocks(ip) &&
 		    !xfs_iflags_test(ip, XFS_IDIRTY_RELEASE)) {
 			/*
-- 
2.43.0


