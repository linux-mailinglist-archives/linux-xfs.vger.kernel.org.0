Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DDBF2E7B5C
	for <lists+linux-xfs@lfdr.de>; Wed, 30 Dec 2020 18:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgL3RAp (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 30 Dec 2020 12:00:45 -0500
Received: from mail.cn.fujitsu.com ([183.91.158.132]:58640 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726949AbgL3RAo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 30 Dec 2020 12:00:44 -0500
X-IronPort-AV: E=Sophos;i="5.78,461,1599494400"; 
   d="scan'208";a="103085837"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 31 Dec 2020 00:58:45 +0800
Received: from G08CNEXMBPEKD06.g08.fujitsu.local (unknown [10.167.33.206])
        by cn.fujitsu.com (Postfix) with ESMTP id 04B1F4CE601E;
        Thu, 31 Dec 2020 00:58:40 +0800 (CST)
Received: from G08CNEXCHPEKD04.g08.fujitsu.local (10.167.33.200) by
 G08CNEXMBPEKD06.g08.fujitsu.local (10.167.33.206) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Thu, 31 Dec 2020 00:58:40 +0800
Received: from irides.mr (10.167.225.141) by G08CNEXCHPEKD04.g08.fujitsu.local
 (10.167.33.209) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 31 Dec 2020 00:58:39 +0800
From:   Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
To:     <linux-kernel@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
        <linux-nvdimm@lists.01.org>, <linux-mm@kvack.org>
CC:     <linux-fsdevel@vger.kernel.org>, <linux-raid@vger.kernel.org>,
        <darrick.wong@oracle.com>, <dan.j.williams@intel.com>,
        <david@fromorbit.com>, <hch@lst.de>, <song@kernel.org>,
        <rgoldwyn@suse.de>, <qi.fuli@fujitsu.com>, <y-goto@fujitsu.com>
Subject: [PATCH 06/10] pmem: Implement ->corrupted_range() for pmem driver
Date:   Thu, 31 Dec 2020 00:55:57 +0800
Message-ID: <20201230165601.845024-7-ruansy.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201230165601.845024-1-ruansy.fnst@cn.fujitsu.com>
References: <20201230165601.845024-1-ruansy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-yoursite-MailScanner-ID: 04B1F4CE601E.AFEA7
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@cn.fujitsu.com
X-Spam-Status: No
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Obtain the superblock of a pmem disk, and call filesystem's
->corrupted_range() to handle the corrupted data.

Signed-off-by: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
---
 block/genhd.c         | 12 ++++++++++++
 drivers/nvdimm/pmem.c | 24 ++++++++++++++++++++++++
 include/linux/genhd.h |  1 +
 3 files changed, 37 insertions(+)

diff --git a/block/genhd.c b/block/genhd.c
index 9387f050c248..436adce123b2 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1058,6 +1058,18 @@ struct block_device *bdget_disk(struct gendisk *disk, int partno)
 }
 EXPORT_SYMBOL(bdget_disk);
 
+struct block_device *bdget_disk_sector(struct gendisk *disk, sector_t sector)
+{
+	struct block_device *bdev = NULL;
+	struct hd_struct *part = disk_map_sector_rcu(disk, sector);
+
+	if (part)
+		bdev = bdget_part(part);
+
+	return bdev;
+}
+EXPORT_SYMBOL(bdget_disk_sector);
+
 /*
  * print a full list of all partitions - intended for places where the root
  * filesystem can't be mounted and thus to give the victim some idea of what
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 4a114937c43b..4688bff19c20 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -253,6 +253,29 @@ static int pmem_rw_page(struct block_device *bdev, sector_t sector,
 	return blk_status_to_errno(rc);
 }
 
+static int pmem_corrupted_range(struct gendisk *disk, struct block_device *bdev,
+				loff_t disk_offset, size_t len, void *data)
+{
+	struct super_block *sb;
+	loff_t bdev_offset;
+	sector_t disk_sector = disk_offset >> SECTOR_SHIFT;
+	int rc = 0;
+
+	bdev = bdget_disk_sector(disk, disk_sector);
+	if (!bdev)
+		return -ENODEV;
+
+	bdev_offset = (disk_sector - get_start_sect(bdev)) << SECTOR_SHIFT;
+	sb = get_super(bdev);
+	if (sb && sb->s_op->corrupted_range) {
+		rc = sb->s_op->corrupted_range(sb, bdev, bdev_offset, len, data);
+		drop_super(sb);
+	}
+
+	bdput(bdev);
+	return rc;
+}
+
 /* see "strong" declaration in tools/testing/nvdimm/pmem-dax.c */
 __weak long __pmem_direct_access(struct pmem_device *pmem, pgoff_t pgoff,
 		long nr_pages, void **kaddr, pfn_t *pfn)
@@ -281,6 +304,7 @@ static const struct block_device_operations pmem_fops = {
 	.owner =		THIS_MODULE,
 	.submit_bio =		pmem_submit_bio,
 	.rw_page =		pmem_rw_page,
+	.corrupted_range =	pmem_corrupted_range,
 };
 
 static int pmem_dax_zero_page_range(struct dax_device *dax_dev, pgoff_t pgoff,
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 03da3f603d30..ed06209008b8 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -303,6 +303,7 @@ static inline void add_disk_no_queue_reg(struct gendisk *disk)
 extern void del_gendisk(struct gendisk *gp);
 extern struct gendisk *get_gendisk(dev_t dev, int *partno);
 extern struct block_device *bdget_disk(struct gendisk *disk, int partno);
+extern struct block_device *bdget_disk_sector(struct gendisk *disk, sector_t sector);
 
 extern void set_device_ro(struct block_device *bdev, int flag);
 extern void set_disk_ro(struct gendisk *disk, int flag);
-- 
2.29.2



