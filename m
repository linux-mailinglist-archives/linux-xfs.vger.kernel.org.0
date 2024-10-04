Return-Path: <linux-xfs+bounces-13633-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E2B9990B13
	for <lists+linux-xfs@lfdr.de>; Fri,  4 Oct 2024 20:22:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DAA48B2700C
	for <lists+linux-xfs@lfdr.de>; Fri,  4 Oct 2024 18:22:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0137B21B44C;
	Fri,  4 Oct 2024 18:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VN8qgzWA"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD8FA21B441;
	Fri,  4 Oct 2024 18:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728065934; cv=none; b=UzHm215PLSqfC3ot4AEH6RRgt8qei0WrM9L2HyKNl7cRV2+jRruzESJRfLP7Q9XGc6tiIkrDHqrMd9zgLcmbhQUftEw3qQ5fqq4G0sTajJfjFSrAJN89zgSvz3ekUeFG6LbIDrYa63M4NLH3z+H+1tjru4546/hn7O4tmAYZThA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728065934; c=relaxed/simple;
	bh=MJzmWT6AHwLeoV55B/mEguR8hVitLpdD11bbWACmNpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NTXPXy8pb9JBeVMSO06Z9fH57wmCLBk52pGSUq029CA3ibPhhnmnmr0201XBdMGiSLVLSJEyKSj71wP5dedMo5W96aymAotQ1q8hBKzVIkhfpuXGBuUTourguSTSVi9Ctd3PotqFTCFmf6l65Ku4Y+fKJQUiUBq6NeBqrWWZCxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VN8qgzWA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A7F2C4CEC6;
	Fri,  4 Oct 2024 18:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728065934;
	bh=MJzmWT6AHwLeoV55B/mEguR8hVitLpdD11bbWACmNpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VN8qgzWA0WStPt8o8tO0khDSlBXxWyUz6c707Li+ycx/Mwi3Hn138Ao4YKRT/st/E
	 GJYcnSTL6a4giwKQB8XgxD+SsbqjfbaEEB48BuwNUkHmO0GKcpASUaUTf04MH+hlaM
	 4oriUhzuk7Z6/j2Jt6LjX7jkdSt6hB87X01PV3aKy3ZnQvze6TBIESjf53yBkjk0Qo
	 QymYANL/Av3+rlV5/xsj5MoBuMOXy88ZbUVReZrHvGNFPOqq3xa1vSyREz72+nO83W
	 ARpwpbhXPZ66ZPsTjru61geZAEk6V9zhQSLUUhzUNlrgJLNUawgEnhAqX8p7EAbYg9
	 ozOxjg9q+QEXw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Pankaj Raghav <p.raghav@samsung.com>,
	Hannes Reinecke <hare@suse.de>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Daniel Gomez <da.gomez@samsung.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.11 14/76] iomap: fix iomap_dio_zero() for fs bs > system page size
Date: Fri,  4 Oct 2024 14:16:31 -0400
Message-ID: <20241004181828.3669209-14-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241004181828.3669209-1-sashal@kernel.org>
References: <20241004181828.3669209-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.11.2
Content-Transfer-Encoding: 8bit

From: Pankaj Raghav <p.raghav@samsung.com>

[ Upstream commit 10553a91652d995274da63fc317470f703765081 ]

iomap_dio_zero() will pad a fs block with zeroes if the direct IO size
< fs block size. iomap_dio_zero() has an implicit assumption that fs block
size < page_size. This is true for most filesystems at the moment.

If the block size > page size, this will send the contents of the page
next to zero page(as len > PAGE_SIZE) to the underlying block device,
causing FS corruption.

iomap is a generic infrastructure and it should not make any assumptions
about the fs block size and the page size of the system.

Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
Link: https://lore.kernel.org/r/20240822135018.1931258-7-kernel@pankajraghav.com
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Daniel Gomez <da.gomez@samsung.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/buffered-io.c |  4 ++--
 fs/iomap/direct-io.c   | 45 ++++++++++++++++++++++++++++++++++++------
 2 files changed, 41 insertions(+), 8 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index f420c53d86acc..d745f718bcde8 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -2007,10 +2007,10 @@ iomap_writepages(struct address_space *mapping, struct writeback_control *wbc,
 }
 EXPORT_SYMBOL_GPL(iomap_writepages);
 
-static int __init iomap_init(void)
+static int __init iomap_buffered_init(void)
 {
 	return bioset_init(&iomap_ioend_bioset, 4 * (PAGE_SIZE / SECTOR_SIZE),
 			   offsetof(struct iomap_ioend, io_bio),
 			   BIOSET_NEED_BVECS);
 }
-fs_initcall(iomap_init);
+fs_initcall(iomap_buffered_init);
diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index f3b43d223a46e..c02b266bba525 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -11,6 +11,7 @@
 #include <linux/iomap.h>
 #include <linux/backing-dev.h>
 #include <linux/uio.h>
+#include <linux/set_memory.h>
 #include <linux/task_io_accounting_ops.h>
 #include "trace.h"
 
@@ -27,6 +28,13 @@
 #define IOMAP_DIO_WRITE		(1U << 30)
 #define IOMAP_DIO_DIRTY		(1U << 31)
 
+/*
+ * Used for sub block zeroing in iomap_dio_zero()
+ */
+#define IOMAP_ZERO_PAGE_SIZE (SZ_64K)
+#define IOMAP_ZERO_PAGE_ORDER (get_order(IOMAP_ZERO_PAGE_SIZE))
+static struct page *zero_page;
+
 struct iomap_dio {
 	struct kiocb		*iocb;
 	const struct iomap_dio_ops *dops;
@@ -232,13 +240,20 @@ void iomap_dio_bio_end_io(struct bio *bio)
 }
 EXPORT_SYMBOL_GPL(iomap_dio_bio_end_io);
 
-static void iomap_dio_zero(const struct iomap_iter *iter, struct iomap_dio *dio,
+static int iomap_dio_zero(const struct iomap_iter *iter, struct iomap_dio *dio,
 		loff_t pos, unsigned len)
 {
 	struct inode *inode = file_inode(dio->iocb->ki_filp);
-	struct page *page = ZERO_PAGE(0);
 	struct bio *bio;
 
+	if (!len)
+		return 0;
+	/*
+	 * Max block size supported is 64k
+	 */
+	if (WARN_ON_ONCE(len > IOMAP_ZERO_PAGE_SIZE))
+		return -EINVAL;
+
 	bio = iomap_dio_alloc_bio(iter, dio, 1, REQ_OP_WRITE | REQ_SYNC | REQ_IDLE);
 	fscrypt_set_bio_crypt_ctx(bio, inode, pos >> inode->i_blkbits,
 				  GFP_KERNEL);
@@ -246,8 +261,9 @@ static void iomap_dio_zero(const struct iomap_iter *iter, struct iomap_dio *dio,
 	bio->bi_private = dio;
 	bio->bi_end_io = iomap_dio_bio_end_io;
 
-	__bio_add_page(bio, page, len, 0);
+	__bio_add_page(bio, zero_page, len, 0);
 	iomap_dio_submit_bio(iter, dio, bio, pos);
+	return 0;
 }
 
 /*
@@ -356,8 +372,10 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
 	if (need_zeroout) {
 		/* zero out from the start of the block to the write offset */
 		pad = pos & (fs_block_size - 1);
-		if (pad)
-			iomap_dio_zero(iter, dio, pos - pad, pad);
+
+		ret = iomap_dio_zero(iter, dio, pos - pad, pad);
+		if (ret)
+			goto out;
 	}
 
 	/*
@@ -431,7 +449,8 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
 		/* zero out from the end of the write to the end of the block */
 		pad = pos & (fs_block_size - 1);
 		if (pad)
-			iomap_dio_zero(iter, dio, pos, fs_block_size - pad);
+			ret = iomap_dio_zero(iter, dio, pos,
+					     fs_block_size - pad);
 	}
 out:
 	/* Undo iter limitation to current extent */
@@ -753,3 +772,17 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	return iomap_dio_complete(dio);
 }
 EXPORT_SYMBOL_GPL(iomap_dio_rw);
+
+static int __init iomap_dio_init(void)
+{
+	zero_page = alloc_pages(GFP_KERNEL | __GFP_ZERO,
+				IOMAP_ZERO_PAGE_ORDER);
+
+	if (!zero_page)
+		return -ENOMEM;
+
+	set_memory_ro((unsigned long)page_address(zero_page),
+		      1U << IOMAP_ZERO_PAGE_ORDER);
+	return 0;
+}
+fs_initcall(iomap_dio_init);
-- 
2.43.0


