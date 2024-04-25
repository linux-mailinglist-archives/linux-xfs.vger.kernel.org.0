Return-Path: <linux-xfs+bounces-7599-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EA4DB8B228D
	for <lists+linux-xfs@lfdr.de>; Thu, 25 Apr 2024 15:25:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A87A528893F
	for <lists+linux-xfs@lfdr.de>; Thu, 25 Apr 2024 13:25:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 225E914B082;
	Thu, 25 Apr 2024 13:23:12 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE6D14A4DC;
	Thu, 25 Apr 2024 13:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714051392; cv=none; b=kpI94uTBCA+G4jOY2UO4UVVhGXr1ZBfzdrmsODTgt9ABkNC6QgHaYarOh3BChGWOnO/hE2LdLqseqQfYzKR0wl/2oqauKxcfORnPZKnSyPiDqoWK5qGKyNwkQEWiTEILKf5/jpKdgyZXBLu3byw8D5YkGc3Ilxj+1ZflgWb1M2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714051392; c=relaxed/simple;
	bh=p0kTiIemxh00/pQbgYWUoB/ldaiHmz89sNg9zGAbEfw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZbaPJtYvCc7xbB8FbpuCvw/BRRFAUs4TZhmUb3gtNbtZkQBLgzYf2k0C7zzckDlP7zS4p1RtYbgmfz2m2zoxoMpik9ZXMdcr27faDdi8GkUf1vwtl8SwyytECTwsr/bz0kY+ivjiI9WqmS02wo9/tgzh2E9nUwG3fKJdywwGkpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4VQGkZ0TzJz4f3kkH;
	Thu, 25 Apr 2024 21:23:02 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id ECADE1A0199;
	Thu, 25 Apr 2024 21:23:06 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP1 (Coremail) with SMTP id cCh0CgCXaBEqWSpmHu+2Kw--.61462S11;
	Thu, 25 Apr 2024 21:23:06 +0800 (CST)
From: Zhang Yi <yi.zhang@huaweicloud.com>
To: linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	djwong@kernel.org,
	hch@infradead.org,
	brauner@kernel.org,
	david@fromorbit.com,
	chandanbabu@kernel.org,
	tytso@mit.edu,
	jack@suse.cz,
	yi.zhang@huawei.com,
	yi.zhang@huaweicloud.com,
	chengzhihao1@huawei.com,
	yukuai3@huawei.com
Subject: [PATCH v5 7/9] iomap: use a new variable to handle the written bytes in iomap_write_iter()
Date: Thu, 25 Apr 2024 21:13:33 +0800
Message-Id: <20240425131335.878454-8-yi.zhang@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240425131335.878454-1-yi.zhang@huaweicloud.com>
References: <20240425131335.878454-1-yi.zhang@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgCXaBEqWSpmHu+2Kw--.61462S11
X-Coremail-Antispam: 1UD129KBjvJXoWxXFWxKw45Kw4UKr43CF18AFb_yoW5trWfp3
	43Ka95uFWxt3y7WFn5GFy5WFyYkFyfKFW7GrWUGrsIvFn0yr45KF1UWayFv3W5Xas3Cr4f
	tF4vyryrGF1UAr7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPI14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E
	14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIx
	kGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAF
	wI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr
	0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUQ
	SdkUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

From: Zhang Yi <yi.zhang@huawei.com>

In iomap_write_iter(), the status variable used to receive the return
value from iomap_write_end() is confusing, replace it with a new written
variable to represent the written bytes in each cycle, no logic changes.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/iomap/buffered-io.c | 33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 63d94189e568..854fa3d4b1c8 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -889,7 +889,7 @@ static loff_t iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i)
 	loff_t length = iomap_length(iter);
 	size_t chunk = PAGE_SIZE << MAX_PAGECACHE_ORDER;
 	loff_t pos = iter->pos;
-	ssize_t written = 0;
+	ssize_t total_written = 0;
 	long status = 0;
 	struct address_space *mapping = iter->inode->i_mapping;
 	unsigned int bdp_flags = (iter->flags & IOMAP_NOWAIT) ? BDP_ASYNC : 0;
@@ -900,6 +900,7 @@ static loff_t iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i)
 		size_t offset;		/* Offset into folio */
 		size_t bytes;		/* Bytes to write to folio */
 		size_t copied;		/* Bytes copied from user */
+		size_t written;		/* Bytes have been written */
 
 		bytes = iov_iter_count(i);
 retry:
@@ -944,7 +945,7 @@ static loff_t iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i)
 			flush_dcache_folio(folio);
 
 		copied = copy_folio_from_iter_atomic(folio, offset, bytes, i);
-		status = iomap_write_end(iter, pos, bytes, copied, folio);
+		written = iomap_write_end(iter, pos, bytes, copied, folio);
 
 		/*
 		 * Update the in-memory inode size after copying the data into
@@ -954,22 +955,22 @@ static loff_t iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i)
 		 * unlock and release the folio.
 		 */
 		old_size = iter->inode->i_size;
-		if (pos + status > old_size) {
-			i_size_write(iter->inode, pos + status);
+		if (pos + written > old_size) {
+			i_size_write(iter->inode, pos + written);
 			iter->iomap.flags |= IOMAP_F_SIZE_CHANGED;
 		}
-		__iomap_put_folio(iter, pos, status, folio);
+		__iomap_put_folio(iter, pos, written, folio);
 
 		if (old_size < pos)
 			pagecache_isize_extended(iter->inode, old_size, pos);
-		if (status < bytes)
-			iomap_write_failed(iter->inode, pos + status,
-					   bytes - status);
-		if (unlikely(copied != status))
-			iov_iter_revert(i, copied - status);
+		if (written < bytes)
+			iomap_write_failed(iter->inode, pos + written,
+					   bytes - written);
+		if (unlikely(copied != written))
+			iov_iter_revert(i, copied - written);
 
 		cond_resched();
-		if (unlikely(status == 0)) {
+		if (unlikely(written == 0)) {
 			/*
 			 * A short copy made iomap_write_end() reject the
 			 * thing entirely.  Might be memory poisoning
@@ -983,17 +984,17 @@ static loff_t iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i)
 				goto retry;
 			}
 		} else {
-			pos += status;
-			written += status;
-			length -= status;
+			pos += written;
+			total_written += written;
+			length -= written;
 		}
 	} while (iov_iter_count(i) && length);
 
 	if (status == -EAGAIN) {
-		iov_iter_revert(i, written);
+		iov_iter_revert(i, total_written);
 		return -EAGAIN;
 	}
-	return written ? written : status;
+	return total_written ? total_written : status;
 }
 
 ssize_t
-- 
2.39.2


