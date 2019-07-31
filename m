Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54C3C7C061
	for <lists+linux-xfs@lfdr.de>; Wed, 31 Jul 2019 13:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbfGaLtx (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 31 Jul 2019 07:49:53 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:55517 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727201AbfGaLtu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 31 Jul 2019 07:49:50 -0400
X-IronPort-AV: E=Sophos;i="5.64,330,1559491200"; 
   d="scan'208";a="72591476"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 31 Jul 2019 19:49:45 +0800
Received: from G08CNEXCHPEKD01.g08.fujitsu.local (unknown [10.167.33.80])
        by cn.fujitsu.com (Postfix) with ESMTP id 2983A4CDE81D;
        Wed, 31 Jul 2019 19:49:45 +0800 (CST)
Received: from iridescent.g08.fujitsu.local (10.167.225.140) by
 G08CNEXCHPEKD01.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.439.0; Wed, 31 Jul 2019 19:49:52 +0800
From:   Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
To:     <linux-xfs@vger.kernel.org>, <linux-nvdimm@lists.01.org>,
        <darrick.wong@oracle.com>
CC:     <linux-kernel@vger.kernel.org>, <rgoldwyn@suse.de>,
        <gujx@cn.fujitsu.com>, <david@fromorbit.com>,
        <qi.fuli@fujitsu.com>, <caoj.fnst@cn.fujitsu.com>,
        <ruansy.fnst@cn.fujitsu.com>, Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [RFC PATCH 1/7] dax: Introduce dax_copy_edges() for COW.
Date:   Wed, 31 Jul 2019 19:49:29 +0800
Message-ID: <20190731114935.11030-2-ruansy.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190731114935.11030-1-ruansy.fnst@cn.fujitsu.com>
References: <20190731114935.11030-1-ruansy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.225.140]
X-yoursite-MailScanner-ID: 2983A4CDE81D.A72BB
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@cn.fujitsu.com
X-Spam-Status: No
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

To copy source data to destance address before write.  Change
dax_iomap_pfn() to return the address as well in order to use it for
performing a memcpy in case the type is IOMAP_COW.

dax_copy_edges() is a helper functions performs a copy from one part of
the device to another for data not page aligned.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Signed-off-by: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
---
 fs/dax.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 52 insertions(+), 4 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 88b93796855e..450baafe2ea4 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -984,7 +984,7 @@ static sector_t dax_iomap_sector(struct iomap *iomap, loff_t pos)
 }
 
 static int dax_iomap_pfn(struct iomap *iomap, loff_t pos, size_t size,
-			 pfn_t *pfnp)
+			 pfn_t *pfnp, void **addr)
 {
 	const sector_t sector = dax_iomap_sector(iomap, pos);
 	pgoff_t pgoff;
@@ -996,11 +996,13 @@ static int dax_iomap_pfn(struct iomap *iomap, loff_t pos, size_t size,
 		return rc;
 	id = dax_read_lock();
 	length = dax_direct_access(iomap->dax_dev, pgoff, PHYS_PFN(size),
-				   NULL, pfnp);
+				   addr, pfnp);
 	if (length < 0) {
 		rc = length;
 		goto out;
 	}
+	if (!pfnp)
+		goto out_check_addr;
 	rc = -EINVAL;
 	if (PFN_PHYS(length) < size)
 		goto out;
@@ -1010,6 +1012,12 @@ static int dax_iomap_pfn(struct iomap *iomap, loff_t pos, size_t size,
 	if (length > 1 && !pfn_t_devmap(*pfnp))
 		goto out;
 	rc = 0;
+
+out_check_addr:
+	if (!addr)
+		goto out;
+	if (!*addr)
+		rc = -EFAULT;
 out:
 	dax_read_unlock(id);
 	return rc;
@@ -1084,6 +1092,46 @@ int __dax_zero_page_range(struct block_device *bdev,
 }
 EXPORT_SYMBOL_GPL(__dax_zero_page_range);
 
+/*
+ * dax_copy_edges - Copies the part of the pages not included in
+ * 		    the write, but required for CoW because
+ * 		    offset/offset+length are not page aligned.
+ */
+static int dax_copy_edges(struct inode *inode, loff_t pos, loff_t length,
+			  struct iomap *srcmap, void *daddr)
+{
+	unsigned offset = pos & (PAGE_SIZE - 1);
+	loff_t end = pos + length;
+	loff_t pg_end = round_up(end, PAGE_SIZE);
+	void *saddr = 0;
+	int ret = 0;
+
+	ret = dax_iomap_pfn(srcmap, pos, length, NULL, &saddr);
+	if (ret)
+		return ret;
+	/*
+	 * Copy the first part of the page
+	 * Note: we pass offset as length
+	 */
+	if (offset) {
+		if (saddr)
+			ret = memcpy_mcsafe(daddr, saddr, offset);
+		else
+			memset(daddr, 0, offset);
+	}
+
+	/* Copy the last part of the range */
+	if (end < pg_end) {
+		if (saddr)
+			ret = memcpy_mcsafe(daddr + offset + length,
+			       saddr + offset + length,	pg_end - end);
+		else
+			memset(daddr + offset + length, 0,
+					pg_end - end);
+	}
+	return ret;
+}
+
 static loff_t
 dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 		struct iomap *iomap, struct iomap *srcmap)
@@ -1338,7 +1386,7 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
 			count_memcg_event_mm(vma->vm_mm, PGMAJFAULT);
 			major = VM_FAULT_MAJOR;
 		}
-		error = dax_iomap_pfn(&iomap, pos, PAGE_SIZE, &pfn);
+		error = dax_iomap_pfn(&iomap, pos, PAGE_SIZE, &pfn, NULL);
 		if (error < 0)
 			goto error_finish_iomap;
 
@@ -1555,7 +1603,7 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
 
 	switch (iomap.type) {
 	case IOMAP_MAPPED:
-		error = dax_iomap_pfn(&iomap, pos, PMD_SIZE, &pfn);
+		error = dax_iomap_pfn(&iomap, pos, PMD_SIZE, &pfn, NULL);
 		if (error < 0)
 			goto finish_iomap;
 
-- 
2.17.0



