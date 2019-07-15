Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3D369A55
	for <lists+linux-xfs@lfdr.de>; Mon, 15 Jul 2019 20:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728256AbfGOR7x (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 15 Jul 2019 13:59:53 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42026 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726074AbfGOR7x (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 15 Jul 2019 13:59:53 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6FHxMAx143503;
        Mon, 15 Jul 2019 17:59:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=dMe0qkDMOohGef5wtTTGZtupXq66fdjCcPBZa/8ukyg=;
 b=4e7rW/5ppxSxru3EdgdCwaZOoN44FYPyOUbGZK15g23Nfck/dOYmg5aJ142E0eYkAp3v
 EM5NBTn1N3Gq9uFhuKqCao8J8ASzDwNaXgAUDPwsjBQhKWv1ic1I3ZQayyFL5iJP4NZR
 VMkthTXpbe1ZZrMkdCcOJIOSgYYdwrntssSaAy5v0we0DL6rS+Zi+BRl8Rxb3JoxMQMN
 +8fsAA8M1jWoetBu5w29EnWIdhnNMi3OB1nc7sixOKuGO3A5YPgc04/diD0N3n44MpGX
 t22/Ndb2zMXTjquR/esTHVWDqeeHjU8fY3efD/NSDFHZTimah7RdZWqBytsuv8MNPlC/ tA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2tq6qtg4uw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Jul 2019 17:59:36 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6FHwUvi103181;
        Mon, 15 Jul 2019 17:59:36 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2tq5bbxhc0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Jul 2019 17:59:35 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6FHxYrs010171;
        Mon, 15 Jul 2019 17:59:34 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 15 Jul 2019 10:59:34 -0700
Subject: [PATCH 2/9] iomap: move the swapfile code into a separate file
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     hch@infradead.org, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        agruenba@redhat.com
Date:   Mon, 15 Jul 2019 10:59:33 -0700
Message-ID: <156321357313.148361.12301737644937245852.stgit@magnolia>
In-Reply-To: <156321356040.148361.7463881761568794395.stgit@magnolia>
References: <156321356040.148361.7463881761568794395.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9319 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907150209
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9319 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907150209
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Move the swapfile activation code into a separate file so that we can
group related functions in a single file instead of having a single
enormous source file.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/iomap.c          |  170 ------------------------------------------------
 fs/iomap/Makefile   |    4 +
 fs/iomap/swapfile.c |  180 +++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 184 insertions(+), 170 deletions(-)
 create mode 100644 fs/iomap/swapfile.c


diff --git a/fs/iomap.c b/fs/iomap.c
index 217c3e5a13d6..521e90825dbe 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -2000,176 +2000,6 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 }
 EXPORT_SYMBOL_GPL(iomap_dio_rw);
 
-/* Swapfile activation */
-
-#ifdef CONFIG_SWAP
-struct iomap_swapfile_info {
-	struct iomap iomap;		/* accumulated iomap */
-	struct swap_info_struct *sis;
-	uint64_t lowest_ppage;		/* lowest physical addr seen (pages) */
-	uint64_t highest_ppage;		/* highest physical addr seen (pages) */
-	unsigned long nr_pages;		/* number of pages collected */
-	int nr_extents;			/* extent count */
-};
-
-/*
- * Collect physical extents for this swap file.  Physical extents reported to
- * the swap code must be trimmed to align to a page boundary.  The logical
- * offset within the file is irrelevant since the swapfile code maps logical
- * page numbers of the swap device to the physical page-aligned extents.
- */
-static int iomap_swapfile_add_extent(struct iomap_swapfile_info *isi)
-{
-	struct iomap *iomap = &isi->iomap;
-	unsigned long nr_pages;
-	uint64_t first_ppage;
-	uint64_t first_ppage_reported;
-	uint64_t next_ppage;
-	int error;
-
-	/*
-	 * Round the start up and the end down so that the physical
-	 * extent aligns to a page boundary.
-	 */
-	first_ppage = ALIGN(iomap->addr, PAGE_SIZE) >> PAGE_SHIFT;
-	next_ppage = ALIGN_DOWN(iomap->addr + iomap->length, PAGE_SIZE) >>
-			PAGE_SHIFT;
-
-	/* Skip too-short physical extents. */
-	if (first_ppage >= next_ppage)
-		return 0;
-	nr_pages = next_ppage - first_ppage;
-
-	/*
-	 * Calculate how much swap space we're adding; the first page contains
-	 * the swap header and doesn't count.  The mm still wants that first
-	 * page fed to add_swap_extent, however.
-	 */
-	first_ppage_reported = first_ppage;
-	if (iomap->offset == 0)
-		first_ppage_reported++;
-	if (isi->lowest_ppage > first_ppage_reported)
-		isi->lowest_ppage = first_ppage_reported;
-	if (isi->highest_ppage < (next_ppage - 1))
-		isi->highest_ppage = next_ppage - 1;
-
-	/* Add extent, set up for the next call. */
-	error = add_swap_extent(isi->sis, isi->nr_pages, nr_pages, first_ppage);
-	if (error < 0)
-		return error;
-	isi->nr_extents += error;
-	isi->nr_pages += nr_pages;
-	return 0;
-}
-
-/*
- * Accumulate iomaps for this swap file.  We have to accumulate iomaps because
- * swap only cares about contiguous page-aligned physical extents and makes no
- * distinction between written and unwritten extents.
- */
-static loff_t iomap_swapfile_activate_actor(struct inode *inode, loff_t pos,
-		loff_t count, void *data, struct iomap *iomap)
-{
-	struct iomap_swapfile_info *isi = data;
-	int error;
-
-	switch (iomap->type) {
-	case IOMAP_MAPPED:
-	case IOMAP_UNWRITTEN:
-		/* Only real or unwritten extents. */
-		break;
-	case IOMAP_INLINE:
-		/* No inline data. */
-		pr_err("swapon: file is inline\n");
-		return -EINVAL;
-	default:
-		pr_err("swapon: file has unallocated extents\n");
-		return -EINVAL;
-	}
-
-	/* No uncommitted metadata or shared blocks. */
-	if (iomap->flags & IOMAP_F_DIRTY) {
-		pr_err("swapon: file is not committed\n");
-		return -EINVAL;
-	}
-	if (iomap->flags & IOMAP_F_SHARED) {
-		pr_err("swapon: file has shared extents\n");
-		return -EINVAL;
-	}
-
-	/* Only one bdev per swap file. */
-	if (iomap->bdev != isi->sis->bdev) {
-		pr_err("swapon: file is on multiple devices\n");
-		return -EINVAL;
-	}
-
-	if (isi->iomap.length == 0) {
-		/* No accumulated extent, so just store it. */
-		memcpy(&isi->iomap, iomap, sizeof(isi->iomap));
-	} else if (isi->iomap.addr + isi->iomap.length == iomap->addr) {
-		/* Append this to the accumulated extent. */
-		isi->iomap.length += iomap->length;
-	} else {
-		/* Otherwise, add the retained iomap and store this one. */
-		error = iomap_swapfile_add_extent(isi);
-		if (error)
-			return error;
-		memcpy(&isi->iomap, iomap, sizeof(isi->iomap));
-	}
-	return count;
-}
-
-/*
- * Iterate a swap file's iomaps to construct physical extents that can be
- * passed to the swapfile subsystem.
- */
-int iomap_swapfile_activate(struct swap_info_struct *sis,
-		struct file *swap_file, sector_t *pagespan,
-		const struct iomap_ops *ops)
-{
-	struct iomap_swapfile_info isi = {
-		.sis = sis,
-		.lowest_ppage = (sector_t)-1ULL,
-	};
-	struct address_space *mapping = swap_file->f_mapping;
-	struct inode *inode = mapping->host;
-	loff_t pos = 0;
-	loff_t len = ALIGN_DOWN(i_size_read(inode), PAGE_SIZE);
-	loff_t ret;
-
-	/*
-	 * Persist all file mapping metadata so that we won't have any
-	 * IOMAP_F_DIRTY iomaps.
-	 */
-	ret = vfs_fsync(swap_file, 1);
-	if (ret)
-		return ret;
-
-	while (len > 0) {
-		ret = iomap_apply(inode, pos, len, IOMAP_REPORT,
-				ops, &isi, iomap_swapfile_activate_actor);
-		if (ret <= 0)
-			return ret;
-
-		pos += ret;
-		len -= ret;
-	}
-
-	if (isi.iomap.length) {
-		ret = iomap_swapfile_add_extent(&isi);
-		if (ret)
-			return ret;
-	}
-
-	*pagespan = 1 + isi.highest_ppage - isi.lowest_ppage;
-	sis->max = isi.nr_pages;
-	sis->pages = isi.nr_pages - 1;
-	sis->highest_bit = isi.nr_pages - 1;
-	return isi.nr_extents;
-}
-EXPORT_SYMBOL_GPL(iomap_swapfile_activate);
-#endif /* CONFIG_SWAP */
-
 static loff_t
 iomap_bmap_actor(struct inode *inode, loff_t pos, loff_t length,
 		void *data, struct iomap *iomap)
diff --git a/fs/iomap/Makefile b/fs/iomap/Makefile
index b778a05acac3..e38061f2b901 100644
--- a/fs/iomap/Makefile
+++ b/fs/iomap/Makefile
@@ -5,3 +5,7 @@
 #
 
 ccflags-y += -I $(srctree)/$(src)/..
+
+obj-$(CONFIG_FS_IOMAP)		+= iomap.o
+
+iomap-$(CONFIG_SWAP)		+= swapfile.o
diff --git a/fs/iomap/swapfile.c b/fs/iomap/swapfile.c
new file mode 100644
index 000000000000..0bd578b580bb
--- /dev/null
+++ b/fs/iomap/swapfile.c
@@ -0,0 +1,180 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2018 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ */
+#include <linux/module.h>
+#include <linux/compiler.h>
+#include <linux/fs.h>
+#include <linux/iomap.h>
+#include <linux/swap.h>
+
+#include "internal.h"
+
+/* Swapfile activation */
+
+struct iomap_swapfile_info {
+	struct iomap iomap;		/* accumulated iomap */
+	struct swap_info_struct *sis;
+	uint64_t lowest_ppage;		/* lowest physical addr seen (pages) */
+	uint64_t highest_ppage;		/* highest physical addr seen (pages) */
+	unsigned long nr_pages;		/* number of pages collected */
+	int nr_extents;			/* extent count */
+};
+
+/*
+ * Collect physical extents for this swap file.  Physical extents reported to
+ * the swap code must be trimmed to align to a page boundary.  The logical
+ * offset within the file is irrelevant since the swapfile code maps logical
+ * page numbers of the swap device to the physical page-aligned extents.
+ */
+static int iomap_swapfile_add_extent(struct iomap_swapfile_info *isi)
+{
+	struct iomap *iomap = &isi->iomap;
+	unsigned long nr_pages;
+	uint64_t first_ppage;
+	uint64_t first_ppage_reported;
+	uint64_t next_ppage;
+	int error;
+
+	/*
+	 * Round the start up and the end down so that the physical
+	 * extent aligns to a page boundary.
+	 */
+	first_ppage = ALIGN(iomap->addr, PAGE_SIZE) >> PAGE_SHIFT;
+	next_ppage = ALIGN_DOWN(iomap->addr + iomap->length, PAGE_SIZE) >>
+			PAGE_SHIFT;
+
+	/* Skip too-short physical extents. */
+	if (first_ppage >= next_ppage)
+		return 0;
+	nr_pages = next_ppage - first_ppage;
+
+	/*
+	 * Calculate how much swap space we're adding; the first page contains
+	 * the swap header and doesn't count.  The mm still wants that first
+	 * page fed to add_swap_extent, however.
+	 */
+	first_ppage_reported = first_ppage;
+	if (iomap->offset == 0)
+		first_ppage_reported++;
+	if (isi->lowest_ppage > first_ppage_reported)
+		isi->lowest_ppage = first_ppage_reported;
+	if (isi->highest_ppage < (next_ppage - 1))
+		isi->highest_ppage = next_ppage - 1;
+
+	/* Add extent, set up for the next call. */
+	error = add_swap_extent(isi->sis, isi->nr_pages, nr_pages, first_ppage);
+	if (error < 0)
+		return error;
+	isi->nr_extents += error;
+	isi->nr_pages += nr_pages;
+	return 0;
+}
+
+/*
+ * Accumulate iomaps for this swap file.  We have to accumulate iomaps because
+ * swap only cares about contiguous page-aligned physical extents and makes no
+ * distinction between written and unwritten extents.
+ */
+static loff_t iomap_swapfile_activate_actor(struct inode *inode, loff_t pos,
+		loff_t count, void *data, struct iomap *iomap)
+{
+	struct iomap_swapfile_info *isi = data;
+	int error;
+
+	switch (iomap->type) {
+	case IOMAP_MAPPED:
+	case IOMAP_UNWRITTEN:
+		/* Only real or unwritten extents. */
+		break;
+	case IOMAP_INLINE:
+		/* No inline data. */
+		pr_err("swapon: file is inline\n");
+		return -EINVAL;
+	default:
+		pr_err("swapon: file has unallocated extents\n");
+		return -EINVAL;
+	}
+
+	/* No uncommitted metadata or shared blocks. */
+	if (iomap->flags & IOMAP_F_DIRTY) {
+		pr_err("swapon: file is not committed\n");
+		return -EINVAL;
+	}
+	if (iomap->flags & IOMAP_F_SHARED) {
+		pr_err("swapon: file has shared extents\n");
+		return -EINVAL;
+	}
+
+	/* Only one bdev per swap file. */
+	if (iomap->bdev != isi->sis->bdev) {
+		pr_err("swapon: file is on multiple devices\n");
+		return -EINVAL;
+	}
+
+	if (isi->iomap.length == 0) {
+		/* No accumulated extent, so just store it. */
+		memcpy(&isi->iomap, iomap, sizeof(isi->iomap));
+	} else if (isi->iomap.addr + isi->iomap.length == iomap->addr) {
+		/* Append this to the accumulated extent. */
+		isi->iomap.length += iomap->length;
+	} else {
+		/* Otherwise, add the retained iomap and store this one. */
+		error = iomap_swapfile_add_extent(isi);
+		if (error)
+			return error;
+		memcpy(&isi->iomap, iomap, sizeof(isi->iomap));
+	}
+	return count;
+}
+
+/*
+ * Iterate a swap file's iomaps to construct physical extents that can be
+ * passed to the swapfile subsystem.
+ */
+int iomap_swapfile_activate(struct swap_info_struct *sis,
+		struct file *swap_file, sector_t *pagespan,
+		const struct iomap_ops *ops)
+{
+	struct iomap_swapfile_info isi = {
+		.sis = sis,
+		.lowest_ppage = (sector_t)-1ULL,
+	};
+	struct address_space *mapping = swap_file->f_mapping;
+	struct inode *inode = mapping->host;
+	loff_t pos = 0;
+	loff_t len = ALIGN_DOWN(i_size_read(inode), PAGE_SIZE);
+	loff_t ret;
+
+	/*
+	 * Persist all file mapping metadata so that we won't have any
+	 * IOMAP_F_DIRTY iomaps.
+	 */
+	ret = vfs_fsync(swap_file, 1);
+	if (ret)
+		return ret;
+
+	while (len > 0) {
+		ret = iomap_apply(inode, pos, len, IOMAP_REPORT,
+				ops, &isi, iomap_swapfile_activate_actor);
+		if (ret <= 0)
+			return ret;
+
+		pos += ret;
+		len -= ret;
+	}
+
+	if (isi.iomap.length) {
+		ret = iomap_swapfile_add_extent(&isi);
+		if (ret)
+			return ret;
+	}
+
+	*pagespan = 1 + isi.highest_ppage - isi.lowest_ppage;
+	sis->max = isi.nr_pages;
+	sis->pages = isi.nr_pages - 1;
+	sis->highest_bit = isi.nr_pages - 1;
+	return isi.nr_extents;
+}
+EXPORT_SYMBOL_GPL(iomap_swapfile_activate);

