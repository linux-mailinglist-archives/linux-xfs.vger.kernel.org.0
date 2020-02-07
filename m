Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7730E1550E5
	for <lists+linux-xfs@lfdr.de>; Fri,  7 Feb 2020 04:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727195AbgBGDQd (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 6 Feb 2020 22:16:33 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:60812 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726674AbgBGDQc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Feb 2020 22:16:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1581045392; x=1612581392;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R3D5RUas+JgGoLa1CcRwK5J6+TdkRuePQStsQ3EYvdk=;
  b=PIEkpJcICnWANkQEVH3InMnXXBKQmXUG+TlpAvLoAQ5rT2E6QElOFxJb
   fMUBP7wap9aLexhwim2ZetZZZqzKVrN4qTHrFbCOz1CCpl4cqNOamBA3d
   nSivVvgTm/o7yBUBVoIrBjykiDqyqaxfOfcYrD4iGS3wjTeJmzAGSOIVD
   wG+kWrT5QUziFEbbhDnZg2wgk7XdGhZF0cDNWQrBSUzeWIYizFDQkNGYU
   juIZuACxAJIwXBdJ9W+uuXT/z4jkmEvwUtcy7jLqGuKZErmS/AuqfQjhF
   kX5VhTBG9GCNjn8m6VIs+snC+GlWwHjVqZyWbWqPu3yxz3w5mkLoVbBKJ
   Q==;
IronPort-SDR: vC/Y5nVJ42kByWREbNhlJulRjV92NwEzw7ddVzFMcI6wXOjTFLoKTSouFRscFUUT1Aoh95aYZL
 Q//+OrjBKGDw6WdPGwp+ygEDCNf+NmKL4BLfdr00Mp9rPXcbqiVB54nvCl4sxaizdSui6Iw3wE
 UCLNCJpSmI6qijC6/AXBIFgoztVK2Phuxv9z33fq/dQHD3lKVc5IUbSq0/uA141fXxk6DVpIsW
 nAiNMBighMFXxjNW6EfuhWpWgDnAehg+Oj3zEHmLE72wPB7bPN8QVkPOhNYdZXdsGFKtrjtWz1
 jZs=
X-IronPort-AV: E=Sophos;i="5.70,411,1574092800"; 
   d="scan'208";a="129872401"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 07 Feb 2020 11:16:10 +0800
IronPort-SDR: 6JFXwWQ3StRT1UhcnWmMsKlCkDr7ppQWk/JmJFFQkP+0eTZNG7ChGUAjZyPaOfCBB4oRaolTg6
 JPc020ZBQsoZ4CVgymHTqU/r7hcGUeMDsyQ4WnzjTuGJzwpqaQ5D29LH1N63qLdxz1lXqFczD9
 35S2oaxpNIGYvB+FYzxi1peK0mrpvbgSIn+uU2HA8qClXojA2yKVpWXyNIvIvUXpLYV1AXU/H+
 wpifoBj5/R2w36lPh64+GqCxOaZnahJKhgtHepCUrWTvHAWtWyY9iCFZPKU/ATXJRepAw7gwNE
 TVB7R+0UnhTZ7SFmy/qwKFqr
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2020 19:09:08 -0800
IronPort-SDR: hZIduODiQ4HaMJdLXK6Ql6C0Igu2LvXOP/3ZAbcZ6Z4gzrObeosxvPG9361XkY+euEWsbSDm+U
 YEDEiTptNjWWvFJIFmcKxnPirIBPFm4fwfv3zRAbUiEeLHA05SnpraG3k6+fs7fbcnldrn81Pv
 SJluYnc3eWdiUQltgyTuHlrm+mh89MUXJJAvSX599Y42khVbNM1nGn9mnYI75Es+hYwHihRxlq
 r2vNH4qo61+z4FtahATsRgAaGK1dyP4gzd4xAayLEH/uwF4TXVeUepIxXe0d0wbEcH0SGDc6TQ
 fww=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 06 Feb 2020 19:16:07 -0800
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Johannes Thumshirn <jth@kernel.org>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        Dave Chinner <david@fromorbit.com>
Subject: [PATCH v13 1/2] fs: New zonefs file system
Date:   Fri,  7 Feb 2020 12:16:05 +0900
Message-Id: <20200207031606.641231-2-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200207031606.641231-1-damien.lemoal@wdc.com>
References: <20200207031606.641231-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

zonefs is a very simple file system exposing each zone of a zoned block
device as a file. Unlike a regular file system with zoned block device
support (e.g. f2fs), zonefs does not hide the sequential write
constraint of zoned block devices to the user. Files representing
sequential write zones of the device must be written sequentially
starting from the end of the file (append only writes).

As such, zonefs is in essence closer to a raw block device access
interface than to a full featured POSIX file system. The goal of zonefs
is to simplify the implementation of zoned block device support in
applications by replacing raw block device file accesses with a richer
file API, avoiding relying on direct block device file ioctls which may
be more obscure to developers. One example of this approach is the
implementation of LSM (log-structured merge) tree structures (such as
used in RocksDB and LevelDB) on zoned block devices by allowing SSTables
to be stored in a zone file similarly to a regular file system rather
than as a range of sectors of a zoned device. The introduction of the
higher level construct "one file is one zone" can help reducing the
amount of changes needed in the application as well as introducing
support for different application programming languages.

Zonefs on-disk metadata is reduced to an immutable super block to
persistently store a magic number and optional feature flags and
values. On mount, zonefs uses blkdev_report_zones() to obtain the device
zone configuration and populates the mount point with a static file tree
solely based on this information. E.g. file sizes come from the device
zone type and write pointer offset managed by the device itself.

The zone files created on mount have the following characteristics.
1) Files representing zones of the same type are grouped together
   under a common sub-directory:
     * For conventional zones, the sub-directory "cnv" is used.
     * For sequential write zones, the sub-directory "seq" is used.
  These two directories are the only directories that exist in zonefs.
  Users cannot create other directories and cannot rename nor delete
  the "cnv" and "seq" sub-directories.
2) The name of zone files is the number of the file within the zone
   type sub-directory, in order of increasing zone start sector.
3) The size of conventional zone files is fixed to the device zone size.
   Conventional zone files cannot be truncated.
4) The size of sequential zone files represent the file's zone write
   pointer position relative to the zone start sector. Truncating these
   files is allowed only down to 0, in which case, the zone is reset to
   rewind the zone write pointer position to the start of the zone, or
   up to the zone size, in which case the file's zone is transitioned
   to the FULL state (finish zone operation).
5) All read and write operations to files are not allowed beyond the
   file zone size. Any access exceeding the zone size is failed with
   the -EFBIG error.
6) Creating, deleting, renaming or modifying any attribute of files and
   sub-directories is not allowed.
7) There are no restrictions on the type of read and write operations
   that can be issued to conventional zone files. Buffered, direct and
   mmap read & write operations are accepted. For sequential zone files,
   there are no restrictions on read operations, but all write
   operations must be direct IO append writes. mmap write of sequential
   files is not allowed.

Several optional features of zonefs can be enabled at format time.
* Conventional zone aggregation: ranges of contiguous conventional
  zones can be aggregated into a single larger file instead of the
  default one file per zone.
* File ownership: The owner UID and GID of zone files is by default 0
  (root) but can be changed to any valid UID/GID.
* File access permissions: the default 640 access permissions can be
  changed.

The mkzonefs tool is used to format zoned block devices for use with
zonefs. This tool is available on Github at:

git@github.com:damien-lemoal/zonefs-tools.git.

zonefs-tools also includes a test suite which can be run against any
zoned block device, including null_blk block device created with zoned
mode.

Example: the following formats a 15TB host-managed SMR HDD with 256 MB
zones with the conventional zones aggregation feature enabled.

$ sudo mkzonefs -o aggr_cnv /dev/sdX
$ sudo mount -t zonefs /dev/sdX /mnt
$ ls -l /mnt/
total 0
dr-xr-xr-x 2 root root     1 Nov 25 13:23 cnv
dr-xr-xr-x 2 root root 55356 Nov 25 13:23 seq

The size of the zone files sub-directories indicate the number of files
existing for each type of zones. In this example, there is only one
conventional zone file (all conventional zones are aggregated under a
single file).

$ ls -l /mnt/cnv
total 137101312
-rw-r----- 1 root root 140391743488 Nov 25 13:23 0

This aggregated conventional zone file can be used as a regular file.

$ sudo mkfs.ext4 /mnt/cnv/0
$ sudo mount -o loop /mnt/cnv/0 /data

The "seq" sub-directory grouping files for sequential write zones has
in this example 55356 zones.

$ ls -lv /mnt/seq
total 14511243264
-rw-r----- 1 root root 0 Nov 25 13:23 0
-rw-r----- 1 root root 0 Nov 25 13:23 1
-rw-r----- 1 root root 0 Nov 25 13:23 2
...
-rw-r----- 1 root root 0 Nov 25 13:23 55354
-rw-r----- 1 root root 0 Nov 25 13:23 55355

For sequential write zone files, the file size changes as data is
appended at the end of the file, similarly to any regular file system.

$ dd if=/dev/zero of=/mnt/seq/0 bs=4K count=1 conv=notrunc oflag=direct
1+0 records in
1+0 records out
4096 bytes (4.1 kB, 4.0 KiB) copied, 0.000452219 s, 9.1 MB/s

$ ls -l /mnt/seq/0
-rw-r----- 1 root root 4096 Nov 25 13:23 /mnt/seq/0

The written file can be truncated to the zone size, preventing any
further write operation.

$ truncate -s 268435456 /mnt/seq/0
$ ls -l /mnt/seq/0
-rw-r----- 1 root root 268435456 Nov 25 13:49 /mnt/seq/0

Truncation to 0 size allows freeing the file zone storage space and
restart append-writes to the file.

$ truncate -s 0 /mnt/seq/0
$ ls -l /mnt/seq/0
-rw-r----- 1 root root 0 Nov 25 13:49 /mnt/seq/0

Since files are statically mapped to zones on the disk, the number of
blocks of a file as reported by stat() and fstat() indicates the size
of the file zone.

$ stat /mnt/seq/0
  File: /mnt/seq/0
  Size: 0       Blocks: 524288     IO Block: 4096   regular empty file
Device: 870h/2160d      Inode: 50431       Links: 1
Access: (0640/-rw-r-----)  Uid: (    0/    root)   Gid: (    0/  root)
Access: 2019-11-25 13:23:57.048971997 +0900
Modify: 2019-11-25 13:52:25.553805765 +0900
Change: 2019-11-25 13:52:25.553805765 +0900
 Birth: -

The number of blocks of the file ("Blocks") in units of 512B blocks
gives the maximum file size of 524288 * 512 B = 256 MB, corresponding
to the device zone size in this example. Of note is that the "IO block"
field always indicates the minimum IO size for writes and corresponds
to the device physical sector size.

This code contains contributions from:
* Johannes Thumshirn <jthumshirn@suse.de>,
* Darrick J. Wong <darrick.wong@oracle.com>,
* Christoph Hellwig <hch@lst.de>,
* Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com> and
* Ting Yao <tingyao@hust.edu.cn>.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 MAINTAINERS                |    9 +
 fs/Kconfig                 |    1 +
 fs/Makefile                |    1 +
 fs/zonefs/Kconfig          |    9 +
 fs/zonefs/Makefile         |    4 +
 fs/zonefs/super.c          | 1439 ++++++++++++++++++++++++++++++++++++
 fs/zonefs/zonefs.h         |  189 +++++
 include/uapi/linux/magic.h |    1 +
 8 files changed, 1653 insertions(+)
 create mode 100644 fs/zonefs/Kconfig
 create mode 100644 fs/zonefs/Makefile
 create mode 100644 fs/zonefs/super.c
 create mode 100644 fs/zonefs/zonefs.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 56765f542244..089fd879632a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18303,6 +18303,15 @@ L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	arch/x86/kernel/cpu/zhaoxin.c
 
+ZONEFS FILESYSTEM
+M:	Damien Le Moal <damien.lemoal@wdc.com>
+M:	Naohiro Aota <naohiro.aota@wdc.com>
+R:	Johannes Thumshirn <jth@kernel.org>
+L:	linux-fsdevel@vger.kernel.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/dlemoal/zonefs.git
+S:	Maintained
+F:	fs/zonefs/
+
 ZPOOL COMPRESSED PAGE STORAGE API
 M:	Dan Streetman <ddstreet@ieee.org>
 L:	linux-mm@kvack.org
diff --git a/fs/Kconfig b/fs/Kconfig
index 7b623e9fc1b0..a3f97ca2bd46 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -40,6 +40,7 @@ source "fs/ocfs2/Kconfig"
 source "fs/btrfs/Kconfig"
 source "fs/nilfs2/Kconfig"
 source "fs/f2fs/Kconfig"
+source "fs/zonefs/Kconfig"
 
 config FS_DAX
 	bool "Direct Access (DAX) support"
diff --git a/fs/Makefile b/fs/Makefile
index 1148c555c4d3..527f228a5e8a 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -133,3 +133,4 @@ obj-$(CONFIG_CEPH_FS)		+= ceph/
 obj-$(CONFIG_PSTORE)		+= pstore/
 obj-$(CONFIG_EFIVAR_FS)		+= efivarfs/
 obj-$(CONFIG_EROFS_FS)		+= erofs/
+obj-$(CONFIG_ZONEFS_FS)		+= zonefs/
diff --git a/fs/zonefs/Kconfig b/fs/zonefs/Kconfig
new file mode 100644
index 000000000000..fb87ad372e29
--- /dev/null
+++ b/fs/zonefs/Kconfig
@@ -0,0 +1,9 @@
+config ZONEFS_FS
+	tristate "zonefs filesystem support"
+	depends on BLOCK
+	depends on BLK_DEV_ZONED
+	help
+	  zonefs is a simple file system which exposes zones of a zoned block
+	  device (e.g. host-managed or host-aware SMR disk drives) as files.
+
+	  If unsure, say N.
diff --git a/fs/zonefs/Makefile b/fs/zonefs/Makefile
new file mode 100644
index 000000000000..75a380aa1ae1
--- /dev/null
+++ b/fs/zonefs/Makefile
@@ -0,0 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0
+obj-$(CONFIG_ZONEFS_FS) += zonefs.o
+
+zonefs-y	:= super.o
diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
new file mode 100644
index 000000000000..8bc6ef82d693
--- /dev/null
+++ b/fs/zonefs/super.c
@@ -0,0 +1,1439 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Simple file system for zoned block devices exposing zones as files.
+ *
+ * Copyright (C) 2019 Western Digital Corporation or its affiliates.
+ */
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/magic.h>
+#include <linux/iomap.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/blkdev.h>
+#include <linux/statfs.h>
+#include <linux/writeback.h>
+#include <linux/quotaops.h>
+#include <linux/seq_file.h>
+#include <linux/parser.h>
+#include <linux/uio.h>
+#include <linux/mman.h>
+#include <linux/sched/mm.h>
+#include <linux/crc32.h>
+
+#include "zonefs.h"
+
+static int zonefs_iomap_begin(struct inode *inode, loff_t offset, loff_t length,
+			      unsigned int flags, struct iomap *iomap,
+			      struct iomap *srcmap)
+{
+	struct zonefs_inode_info *zi = ZONEFS_I(inode);
+	struct super_block *sb = inode->i_sb;
+	loff_t isize;
+
+	/* All I/Os should always be within the file maximum size */
+	if (WARN_ON_ONCE(offset + length > zi->i_max_size))
+		return -EIO;
+
+	/*
+	 * Sequential zones can only accept direct writes. This is already
+	 * checked when writes are issued, so warn if we see a page writeback
+	 * operation.
+	 */
+	if (WARN_ON_ONCE(zi->i_ztype == ZONEFS_ZTYPE_SEQ &&
+			 (flags & IOMAP_WRITE) && !(flags & IOMAP_DIRECT)))
+		return -EIO;
+
+	/*
+	 * For conventional zones, all blocks are always mapped. For sequential
+	 * zones, all blocks after always mapped below the inode size (zone
+	 * write pointer) and unwriten beyond.
+	 */
+	mutex_lock(&zi->i_truncate_mutex);
+	isize = i_size_read(inode);
+	if (offset >= isize)
+		iomap->type = IOMAP_UNWRITTEN;
+	else
+		iomap->type = IOMAP_MAPPED;
+	if (flags & IOMAP_WRITE)
+		length = zi->i_max_size - offset;
+	else
+		length = min(length, isize - offset);
+	mutex_unlock(&zi->i_truncate_mutex);
+
+	iomap->offset = ALIGN_DOWN(offset, sb->s_blocksize);
+	iomap->length = ALIGN(offset + length, sb->s_blocksize) - iomap->offset;
+	iomap->bdev = inode->i_sb->s_bdev;
+	iomap->addr = (zi->i_zsector << SECTOR_SHIFT) + iomap->offset;
+
+	return 0;
+}
+
+static const struct iomap_ops zonefs_iomap_ops = {
+	.iomap_begin	= zonefs_iomap_begin,
+};
+
+static int zonefs_readpage(struct file *unused, struct page *page)
+{
+	return iomap_readpage(page, &zonefs_iomap_ops);
+}
+
+static int zonefs_readpages(struct file *unused, struct address_space *mapping,
+			    struct list_head *pages, unsigned int nr_pages)
+{
+	return iomap_readpages(mapping, pages, nr_pages, &zonefs_iomap_ops);
+}
+
+/*
+ * Map blocks for page writeback. This is used only on conventional zone files,
+ * which implies that the page range can only be within the fixed inode size.
+ */
+static int zonefs_map_blocks(struct iomap_writepage_ctx *wpc,
+			     struct inode *inode, loff_t offset)
+{
+	struct zonefs_inode_info *zi = ZONEFS_I(inode);
+
+	if (WARN_ON_ONCE(zi->i_ztype != ZONEFS_ZTYPE_CNV))
+		return -EIO;
+	if (WARN_ON_ONCE(offset >= i_size_read(inode)))
+		return -EIO;
+
+	/* If the mapping is already OK, nothing needs to be done */
+	if (offset >= wpc->iomap.offset &&
+	    offset < wpc->iomap.offset + wpc->iomap.length)
+		return 0;
+
+	return zonefs_iomap_begin(inode, offset, zi->i_max_size - offset,
+				  IOMAP_WRITE, &wpc->iomap, NULL);
+}
+
+static const struct iomap_writeback_ops zonefs_writeback_ops = {
+	.map_blocks		= zonefs_map_blocks,
+};
+
+static int zonefs_writepage(struct page *page, struct writeback_control *wbc)
+{
+	struct iomap_writepage_ctx wpc = { };
+
+	return iomap_writepage(page, wbc, &wpc, &zonefs_writeback_ops);
+}
+
+static int zonefs_writepages(struct address_space *mapping,
+			     struct writeback_control *wbc)
+{
+	struct iomap_writepage_ctx wpc = { };
+
+	return iomap_writepages(mapping, wbc, &wpc, &zonefs_writeback_ops);
+}
+
+static const struct address_space_operations zonefs_file_aops = {
+	.readpage		= zonefs_readpage,
+	.readpages		= zonefs_readpages,
+	.writepage		= zonefs_writepage,
+	.writepages		= zonefs_writepages,
+	.set_page_dirty		= iomap_set_page_dirty,
+	.releasepage		= iomap_releasepage,
+	.invalidatepage		= iomap_invalidatepage,
+	.migratepage		= iomap_migrate_page,
+	.is_partially_uptodate	= iomap_is_partially_uptodate,
+	.error_remove_page	= generic_error_remove_page,
+	.direct_IO		= noop_direct_IO,
+};
+
+static void zonefs_update_stats(struct inode *inode, loff_t new_isize)
+{
+	struct super_block *sb = inode->i_sb;
+	struct zonefs_sb_info *sbi = ZONEFS_SB(sb);
+	loff_t old_isize = i_size_read(inode);
+	loff_t nr_blocks;
+
+	if (new_isize == old_isize)
+		return;
+
+	spin_lock(&sbi->s_lock);
+
+	/*
+	 * This may be called for an update after an IO error.
+	 * So beware of the values seen.
+	 */
+	if (new_isize < old_isize) {
+		nr_blocks = (old_isize - new_isize) >> sb->s_blocksize_bits;
+		if (sbi->s_used_blocks > nr_blocks)
+			sbi->s_used_blocks -= nr_blocks;
+		else
+			sbi->s_used_blocks = 0;
+	} else {
+		sbi->s_used_blocks +=
+			(new_isize - old_isize) >> sb->s_blocksize_bits;
+		if (sbi->s_used_blocks > sbi->s_blocks)
+			sbi->s_used_blocks = sbi->s_blocks;
+	}
+
+	spin_unlock(&sbi->s_lock);
+}
+
+/*
+ * Check a zone condition and adjust its file inode access permissions for
+ * offline and readonly zones. Return the inode size corresponding to the
+ * amount of readable data in the zone.
+ */
+static loff_t zonefs_check_zone_condition(struct inode *inode,
+					  struct blk_zone *zone, bool warn)
+{
+	struct zonefs_inode_info *zi = ZONEFS_I(inode);
+
+	switch (zone->cond) {
+	case BLK_ZONE_COND_OFFLINE:
+		/*
+		 * Dead zone: make the inode immutable, disable all accesses
+		 * and set the file size to 0 (zone wp set to zone start).
+		 */
+		if (warn)
+			zonefs_warn(inode->i_sb, "inode %lu: offline zone\n",
+				    inode->i_ino);
+		inode->i_flags |= S_IMMUTABLE;
+		inode->i_mode &= ~0777;
+		zone->wp = zone->start;
+		return 0;
+	case BLK_ZONE_COND_READONLY:
+		/* Do not allow writes in read-only zones */
+		if (warn)
+			zonefs_warn(inode->i_sb, "inode %lu: read-only zone\n",
+				    inode->i_ino);
+		inode->i_flags |= S_IMMUTABLE;
+		inode->i_mode &= ~0222;
+		/* fallthrough */
+	default:
+		if (zi->i_ztype == ZONEFS_ZTYPE_CNV)
+			return zi->i_max_size;
+		return (zone->wp - zone->start) << SECTOR_SHIFT;
+	}
+}
+
+struct zonefs_ioerr_data {
+	struct inode	*inode;
+	bool		write;
+};
+
+static int zonefs_io_error_cb(struct blk_zone *zone, unsigned int idx,
+			      void *data)
+{
+	struct zonefs_ioerr_data *err = data;
+	struct inode *inode = err->inode;
+	struct zonefs_inode_info *zi = ZONEFS_I(inode);
+	struct super_block *sb = inode->i_sb;
+	struct zonefs_sb_info *sbi = ZONEFS_SB(sb);
+	loff_t isize, data_size;
+
+	/*
+	 * Check the zone condition: if the zone is not "bad" (offline or
+	 * read-only), read errors are simply signaled to the IO issuer as long
+	 * as there is no inconsistency between the inode size and the amount of
+	 * data writen in the zone (data_size).
+	 */
+	data_size = zonefs_check_zone_condition(inode, zone, true);
+	isize = i_size_read(inode);
+	if (zone->cond != BLK_ZONE_COND_OFFLINE &&
+	    zone->cond != BLK_ZONE_COND_READONLY &&
+	    !err->write && isize == data_size)
+		return 0;
+
+	/*
+	 * At this point, we detected either a bad zone or an inconsistency
+	 * between the inode size and the amount of data written in the zone.
+	 * For the latter case, the cause may be a write IO error or an external
+	 * action on the device. Two error patterns exist:
+	 * 1) The inode size is lower than the amount of data in the zone:
+	 *    a write operation partially failed and data was writen at the end
+	 *    of the file. This can happen in the case of a large direct IO
+	 *    needing several BIOs and/or write requests to be processed.
+	 * 2) The inode size is larger than the amount of data in the zone:
+	 *    this can happen with a deferred write error with the use of the
+	 *    device side write cache after getting successful write IO
+	 *    completions. Other possibilities are (a) an external corruption,
+	 *    e.g. an application reset the zone directly, or (b) the device
+	 *    has a serious problem (e.g. firmware bug).
+	 *
+	 * In all cases, warn about inode size inconsistency and handle the
+	 * IO error according to the zone condition and to the mount options.
+	 */
+	if (zi->i_ztype == ZONEFS_ZTYPE_SEQ && isize != data_size)
+		zonefs_warn(sb, "inode %lu: invalid size %lld (should be %lld)\n",
+			    inode->i_ino, isize, data_size);
+
+	/*
+	 * First handle bad zones signaled by hardware. The mount options
+	 * errors=zone-ro and errors=zone-offline result in changing the
+	 * zone condition to read-only and offline respectively, as if the
+	 * condition was signaled by the hardware.
+	 */
+	if (zone->cond == BLK_ZONE_COND_OFFLINE ||
+	    sbi->s_mount_opts & ZONEFS_MNTOPT_ERRORS_ZOL) {
+		zonefs_warn(sb, "inode %lu: read/write access disabled\n",
+			    inode->i_ino);
+		if (zone->cond != BLK_ZONE_COND_OFFLINE) {
+			zone->cond = BLK_ZONE_COND_OFFLINE;
+			data_size = zonefs_check_zone_condition(inode, zone,
+								false);
+		}
+	} else if (zone->cond == BLK_ZONE_COND_READONLY ||
+		   sbi->s_mount_opts & ZONEFS_MNTOPT_ERRORS_ZRO) {
+		zonefs_warn(sb, "inode %lu: write access disabled\n",
+			    inode->i_ino);
+		if (zone->cond != BLK_ZONE_COND_READONLY) {
+			zone->cond = BLK_ZONE_COND_READONLY;
+			data_size = zonefs_check_zone_condition(inode, zone,
+								false);
+		}
+	}
+
+	/*
+	 * If error=remount-ro was specified, any error result in remounting
+	 * the volume as read-only.
+	 */
+	if ((sbi->s_mount_opts & ZONEFS_MNTOPT_ERRORS_RO) && !sb_rdonly(sb)) {
+		zonefs_warn(sb, "remounting filesystem read-only\n");
+		sb->s_flags |= SB_RDONLY;
+	}
+
+	/*
+	 * Update block usage stats and the inode size  to prevent access to
+	 * invalid data.
+	 */
+	zonefs_update_stats(inode, data_size);
+	i_size_write(inode, data_size);
+	zi->i_wpoffset = data_size;
+
+	return 0;
+}
+
+/*
+ * When an file IO error occurs, check the file zone to see if there is a change
+ * in the zone condition (e.g. offline or read-only). For a failed write to a
+ * sequential zone, the zone write pointer position must also be checked to
+ * eventually correct the file size and zonefs inode write pointer offset
+ * (which can be out of sync with the drive due to partial write failures).
+ */
+static void zonefs_io_error(struct inode *inode, bool write)
+{
+	struct zonefs_inode_info *zi = ZONEFS_I(inode);
+	struct super_block *sb = inode->i_sb;
+	struct zonefs_sb_info *sbi = ZONEFS_SB(sb);
+	unsigned int noio_flag;
+	unsigned int nr_zones =
+		zi->i_max_size >> (sbi->s_zone_sectors_shift + SECTOR_SHIFT);
+	struct zonefs_ioerr_data err = {
+		.inode = inode,
+		.write = write,
+	};
+	int ret;
+
+	mutex_lock(&zi->i_truncate_mutex);
+
+	/*
+	 * Memory allocations in blkdev_report_zones() can trigger a memory
+	 * reclaim which may in turn cause a recursion into zonefs as well as
+	 * struct request allocations for the same device. The former case may
+	 * end up in a deadlock on the inode truncate mutex, while the latter
+	 * may prevent IO forward progress. Executing the report zones under
+	 * the GFP_NOIO context avoids both problems.
+	 */
+	noio_flag = memalloc_noio_save();
+	ret = blkdev_report_zones(sb->s_bdev, zi->i_zsector, nr_zones,
+				  zonefs_io_error_cb, &err);
+	if (ret != nr_zones)
+		zonefs_err(sb, "Get inode %lu zone information failed %d\n",
+			   inode->i_ino, ret);
+	memalloc_noio_restore(noio_flag);
+
+	mutex_unlock(&zi->i_truncate_mutex);
+}
+
+static int zonefs_file_truncate(struct inode *inode, loff_t isize)
+{
+	struct zonefs_inode_info *zi = ZONEFS_I(inode);
+	loff_t old_isize;
+	enum req_opf op;
+	int ret = 0;
+
+	/*
+	 * Only sequential zone files can be truncated and truncation is allowed
+	 * only down to a 0 size, which is equivalent to a zone reset, and to
+	 * the maximum file size, which is equivalent to a zone finish.
+	 */
+	if (zi->i_ztype != ZONEFS_ZTYPE_SEQ)
+		return -EPERM;
+
+	if (!isize)
+		op = REQ_OP_ZONE_RESET;
+	else if (isize == zi->i_max_size)
+		op = REQ_OP_ZONE_FINISH;
+	else
+		return -EPERM;
+
+	inode_dio_wait(inode);
+
+	/* Serialize against page faults */
+	down_write(&zi->i_mmap_sem);
+
+	/* Serialize against zonefs_iomap_begin() */
+	mutex_lock(&zi->i_truncate_mutex);
+
+	old_isize = i_size_read(inode);
+	if (isize == old_isize)
+		goto unlock;
+
+	ret = blkdev_zone_mgmt(inode->i_sb->s_bdev, op, zi->i_zsector,
+			       zi->i_max_size >> SECTOR_SHIFT, GFP_NOFS);
+	if (ret) {
+		zonefs_err(inode->i_sb,
+			   "Zone management operation at %llu failed %d",
+			   zi->i_zsector, ret);
+		goto unlock;
+	}
+
+	zonefs_update_stats(inode, isize);
+	truncate_setsize(inode, isize);
+	zi->i_wpoffset = isize;
+
+unlock:
+	mutex_unlock(&zi->i_truncate_mutex);
+	up_write(&zi->i_mmap_sem);
+
+	return ret;
+}
+
+static int zonefs_inode_setattr(struct dentry *dentry, struct iattr *iattr)
+{
+	struct inode *inode = d_inode(dentry);
+	int ret;
+
+	if (unlikely(IS_IMMUTABLE(inode)))
+		return -EPERM;
+
+	ret = setattr_prepare(dentry, iattr);
+	if (ret)
+		return ret;
+
+	/*
+	 * Since files and directories cannot be created nor deleted, do not
+	 * allow setting any write attributes on the sub-directories grouping
+	 * files by zone type.
+	 */
+	if ((iattr->ia_valid & ATTR_MODE) && S_ISDIR(inode->i_mode) &&
+	    (iattr->ia_mode & 0222))
+		return -EPERM;
+
+	if (((iattr->ia_valid & ATTR_UID) &&
+	     !uid_eq(iattr->ia_uid, inode->i_uid)) ||
+	    ((iattr->ia_valid & ATTR_GID) &&
+	     !gid_eq(iattr->ia_gid, inode->i_gid))) {
+		ret = dquot_transfer(inode, iattr);
+		if (ret)
+			return ret;
+	}
+
+	if (iattr->ia_valid & ATTR_SIZE) {
+		ret = zonefs_file_truncate(inode, iattr->ia_size);
+		if (ret)
+			return ret;
+	}
+
+	setattr_copy(inode, iattr);
+
+	return 0;
+}
+
+static const struct inode_operations zonefs_file_inode_operations = {
+	.setattr	= zonefs_inode_setattr,
+};
+
+static int zonefs_file_fsync(struct file *file, loff_t start, loff_t end,
+			     int datasync)
+{
+	struct inode *inode = file_inode(file);
+	int ret = 0;
+
+	if (unlikely(IS_IMMUTABLE(inode)))
+		return -EPERM;
+
+	/*
+	 * Since only direct writes are allowed in sequential files, page cache
+	 * flush is needed only for conventional zone files.
+	 */
+	if (ZONEFS_I(inode)->i_ztype == ZONEFS_ZTYPE_CNV)
+		ret = file_write_and_wait_range(file, start, end);
+	if (!ret)
+		ret = blkdev_issue_flush(inode->i_sb->s_bdev, GFP_KERNEL, NULL);
+
+	if (ret)
+		zonefs_io_error(inode, true);
+
+	return ret;
+}
+
+static vm_fault_t zonefs_filemap_fault(struct vm_fault *vmf)
+{
+	struct zonefs_inode_info *zi = ZONEFS_I(file_inode(vmf->vma->vm_file));
+	vm_fault_t ret;
+
+	down_read(&zi->i_mmap_sem);
+	ret = filemap_fault(vmf);
+	up_read(&zi->i_mmap_sem);
+
+	return ret;
+}
+
+static vm_fault_t zonefs_filemap_page_mkwrite(struct vm_fault *vmf)
+{
+	struct inode *inode = file_inode(vmf->vma->vm_file);
+	struct zonefs_inode_info *zi = ZONEFS_I(inode);
+	vm_fault_t ret;
+
+	if (unlikely(IS_IMMUTABLE(inode)))
+		return VM_FAULT_SIGBUS;
+
+	/*
+	 * Sanity check: only conventional zone files can have shared
+	 * writeable mappings.
+	 */
+	if (WARN_ON_ONCE(zi->i_ztype != ZONEFS_ZTYPE_CNV))
+		return VM_FAULT_NOPAGE;
+
+	sb_start_pagefault(inode->i_sb);
+	file_update_time(vmf->vma->vm_file);
+
+	/* Serialize against truncates */
+	down_read(&zi->i_mmap_sem);
+	ret = iomap_page_mkwrite(vmf, &zonefs_iomap_ops);
+	up_read(&zi->i_mmap_sem);
+
+	sb_end_pagefault(inode->i_sb);
+	return ret;
+}
+
+static const struct vm_operations_struct zonefs_file_vm_ops = {
+	.fault		= zonefs_filemap_fault,
+	.map_pages	= filemap_map_pages,
+	.page_mkwrite	= zonefs_filemap_page_mkwrite,
+};
+
+static int zonefs_file_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	/*
+	 * Conventional zones accept random writes, so their files can support
+	 * shared writable mappings. For sequential zone files, only read
+	 * mappings are possible since there are no guarantees for write
+	 * ordering between msync() and page cache writeback.
+	 */
+	if (ZONEFS_I(file_inode(file))->i_ztype == ZONEFS_ZTYPE_SEQ &&
+	    (vma->vm_flags & VM_SHARED) && (vma->vm_flags & VM_MAYWRITE))
+		return -EINVAL;
+
+	file_accessed(file);
+	vma->vm_ops = &zonefs_file_vm_ops;
+
+	return 0;
+}
+
+static loff_t zonefs_file_llseek(struct file *file, loff_t offset, int whence)
+{
+	loff_t isize = i_size_read(file_inode(file));
+
+	/*
+	 * Seeks are limited to below the zone size for conventional zones
+	 * and below the zone write pointer for sequential zones. In both
+	 * cases, this limit is the inode size.
+	 */
+	return generic_file_llseek_size(file, offset, whence, isize, isize);
+}
+
+static int zonefs_file_write_dio_end_io(struct kiocb *iocb, ssize_t size,
+					int error, unsigned int flags)
+{
+	struct inode *inode = file_inode(iocb->ki_filp);
+	struct zonefs_inode_info *zi = ZONEFS_I(inode);
+
+	if (error) {
+		zonefs_io_error(inode, true);
+		return error;
+	}
+
+	if (size && zi->i_ztype != ZONEFS_ZTYPE_CNV) {
+		/*
+		 * Note that we may be seeing completions out of order,
+		 * but that is not a problem since a write completed
+		 * successfully necessarily means that all preceding writes
+		 * were also successful. So we can safely increase the inode
+		 * size to the write end location.
+		 */
+		mutex_lock(&zi->i_truncate_mutex);
+		if (i_size_read(inode) < iocb->ki_pos + size) {
+			zonefs_update_stats(inode, iocb->ki_pos + size);
+			i_size_write(inode, iocb->ki_pos + size);
+		}
+		mutex_unlock(&zi->i_truncate_mutex);
+	}
+
+	return 0;
+}
+
+static const struct iomap_dio_ops zonefs_write_dio_ops = {
+	.end_io			= zonefs_file_write_dio_end_io,
+};
+
+/*
+ * Handle direct writes. For sequential zone files, this is the only possible
+ * write path. For these files, check that the user is issuing writes
+ * sequentially from the end of the file. This code assumes that the block layer
+ * delivers write requests to the device in sequential order. This is always the
+ * case if a block IO scheduler implementing the ELEVATOR_F_ZBD_SEQ_WRITE
+ * elevator feature is being used (e.g. mq-deadline). The block layer always
+ * automatically select such an elevator for zoned block devices during the
+ * device initialization.
+ */
+static ssize_t zonefs_file_dio_write(struct kiocb *iocb, struct iov_iter *from)
+{
+	struct inode *inode = file_inode(iocb->ki_filp);
+	struct zonefs_inode_info *zi = ZONEFS_I(inode);
+	struct super_block *sb = inode->i_sb;
+	size_t count;
+	ssize_t ret;
+
+	/*
+	 * For async direct IOs to sequential zone files, ignore IOCB_NOWAIT
+	 * as this can cause write reordering (e.g. the first aio gets EAGAIN
+	 * on the inode lock but the second goes through but is now unaligned).
+	 */
+	if (zi->i_ztype == ZONEFS_ZTYPE_SEQ && !is_sync_kiocb(iocb)
+	    && (iocb->ki_flags & IOCB_NOWAIT))
+		iocb->ki_flags &= ~IOCB_NOWAIT;
+
+	if (iocb->ki_flags & IOCB_NOWAIT) {
+		if (!inode_trylock(inode))
+			return -EAGAIN;
+	} else {
+		inode_lock(inode);
+	}
+
+	ret = generic_write_checks(iocb, from);
+	if (ret <= 0)
+		goto inode_unlock;
+
+	iov_iter_truncate(from, zi->i_max_size - iocb->ki_pos);
+	count = iov_iter_count(from);
+
+	if ((iocb->ki_pos | count) & (sb->s_blocksize - 1)) {
+		ret = -EINVAL;
+		goto inode_unlock;
+	}
+
+	/* Enforce sequential writes (append only) in sequential zones */
+	mutex_lock(&zi->i_truncate_mutex);
+	if (zi->i_ztype == ZONEFS_ZTYPE_SEQ && iocb->ki_pos != zi->i_wpoffset) {
+		mutex_unlock(&zi->i_truncate_mutex);
+		ret = -EINVAL;
+		goto inode_unlock;
+	}
+	mutex_unlock(&zi->i_truncate_mutex);
+
+	ret = iomap_dio_rw(iocb, from, &zonefs_iomap_ops,
+			   &zonefs_write_dio_ops, is_sync_kiocb(iocb));
+	if (zi->i_ztype == ZONEFS_ZTYPE_SEQ &&
+	    (ret > 0 || ret == -EIOCBQUEUED)) {
+		if (ret > 0)
+			count = ret;
+		mutex_lock(&zi->i_truncate_mutex);
+		zi->i_wpoffset += count;
+		mutex_unlock(&zi->i_truncate_mutex);
+	}
+
+inode_unlock:
+	inode_unlock(inode);
+
+	return ret;
+}
+
+static ssize_t zonefs_file_buffered_write(struct kiocb *iocb,
+					  struct iov_iter *from)
+{
+	struct inode *inode = file_inode(iocb->ki_filp);
+	struct zonefs_inode_info *zi = ZONEFS_I(inode);
+	ssize_t ret;
+
+	/*
+	 * Direct IO writes are mandatory for sequential zone files so that the
+	 * write IO issuing order is preserved.
+	 */
+	if (zi->i_ztype != ZONEFS_ZTYPE_CNV)
+		return -EIO;
+
+	if (iocb->ki_flags & IOCB_NOWAIT) {
+		if (!inode_trylock(inode))
+			return -EAGAIN;
+	} else {
+		inode_lock(inode);
+	}
+
+	ret = generic_write_checks(iocb, from);
+	if (ret <= 0)
+		goto inode_unlock;
+
+	iov_iter_truncate(from, zi->i_max_size - iocb->ki_pos);
+
+	ret = iomap_file_buffered_write(iocb, from, &zonefs_iomap_ops);
+	if (ret > 0)
+		iocb->ki_pos += ret;
+	else if (ret == -EIO)
+		zonefs_io_error(inode, true);
+
+inode_unlock:
+	inode_unlock(inode);
+	if (ret > 0)
+		ret = generic_write_sync(iocb, ret);
+
+	return ret;
+}
+
+static ssize_t zonefs_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
+{
+	struct inode *inode = file_inode(iocb->ki_filp);
+
+	if (unlikely(IS_IMMUTABLE(inode)))
+		return -EPERM;
+
+	if (sb_rdonly(inode->i_sb))
+		return -EROFS;
+
+	/* Write operations beyond the zone size are not allowed */
+	if (iocb->ki_pos >= ZONEFS_I(inode)->i_max_size)
+		return -EFBIG;
+
+	if (iocb->ki_flags & IOCB_DIRECT)
+		return zonefs_file_dio_write(iocb, from);
+
+	return zonefs_file_buffered_write(iocb, from);
+}
+
+static int zonefs_file_read_dio_end_io(struct kiocb *iocb, ssize_t size,
+				       int error, unsigned int flags)
+{
+	if (error) {
+		zonefs_io_error(file_inode(iocb->ki_filp), false);
+		return error;
+	}
+
+	return 0;
+}
+
+static const struct iomap_dio_ops zonefs_read_dio_ops = {
+	.end_io			= zonefs_file_read_dio_end_io,
+};
+
+static ssize_t zonefs_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
+{
+	struct inode *inode = file_inode(iocb->ki_filp);
+	struct zonefs_inode_info *zi = ZONEFS_I(inode);
+	struct super_block *sb = inode->i_sb;
+	loff_t isize;
+	ssize_t ret;
+
+	/* Offline zones cannot be read */
+	if (unlikely(IS_IMMUTABLE(inode) && !(inode->i_mode & 0777)))
+		return -EPERM;
+
+	if (iocb->ki_pos >= zi->i_max_size)
+		return 0;
+
+	if (iocb->ki_flags & IOCB_NOWAIT) {
+		if (!inode_trylock_shared(inode))
+			return -EAGAIN;
+	} else {
+		inode_lock_shared(inode);
+	}
+
+	/* Limit read operations to written data */
+	mutex_lock(&zi->i_truncate_mutex);
+	isize = i_size_read(inode);
+	if (iocb->ki_pos >= isize) {
+		mutex_unlock(&zi->i_truncate_mutex);
+		ret = 0;
+		goto inode_unlock;
+	}
+	iov_iter_truncate(to, isize - iocb->ki_pos);
+	mutex_unlock(&zi->i_truncate_mutex);
+
+	if (iocb->ki_flags & IOCB_DIRECT) {
+		size_t count = iov_iter_count(to);
+
+		if ((iocb->ki_pos | count) & (sb->s_blocksize - 1)) {
+			ret = -EINVAL;
+			goto inode_unlock;
+		}
+		file_accessed(iocb->ki_filp);
+		ret = iomap_dio_rw(iocb, to, &zonefs_iomap_ops,
+				   &zonefs_read_dio_ops, is_sync_kiocb(iocb));
+	} else {
+		ret = generic_file_read_iter(iocb, to);
+		if (ret == -EIO)
+			zonefs_io_error(inode, false);
+	}
+
+inode_unlock:
+	inode_unlock_shared(inode);
+
+	return ret;
+}
+
+static const struct file_operations zonefs_file_operations = {
+	.open		= generic_file_open,
+	.fsync		= zonefs_file_fsync,
+	.mmap		= zonefs_file_mmap,
+	.llseek		= zonefs_file_llseek,
+	.read_iter	= zonefs_file_read_iter,
+	.write_iter	= zonefs_file_write_iter,
+	.splice_read	= generic_file_splice_read,
+	.splice_write	= iter_file_splice_write,
+	.iopoll		= iomap_dio_iopoll,
+};
+
+static struct kmem_cache *zonefs_inode_cachep;
+
+static struct inode *zonefs_alloc_inode(struct super_block *sb)
+{
+	struct zonefs_inode_info *zi;
+
+	zi = kmem_cache_alloc(zonefs_inode_cachep, GFP_KERNEL);
+	if (!zi)
+		return NULL;
+
+	inode_init_once(&zi->i_vnode);
+	mutex_init(&zi->i_truncate_mutex);
+	init_rwsem(&zi->i_mmap_sem);
+
+	return &zi->i_vnode;
+}
+
+static void zonefs_free_inode(struct inode *inode)
+{
+	kmem_cache_free(zonefs_inode_cachep, ZONEFS_I(inode));
+}
+
+/*
+ * File system stat.
+ */
+static int zonefs_statfs(struct dentry *dentry, struct kstatfs *buf)
+{
+	struct super_block *sb = dentry->d_sb;
+	struct zonefs_sb_info *sbi = ZONEFS_SB(sb);
+	enum zonefs_ztype t;
+	u64 fsid;
+
+	buf->f_type = ZONEFS_MAGIC;
+	buf->f_bsize = sb->s_blocksize;
+	buf->f_namelen = ZONEFS_NAME_MAX;
+
+	spin_lock(&sbi->s_lock);
+
+	buf->f_blocks = sbi->s_blocks;
+	if (WARN_ON(sbi->s_used_blocks > sbi->s_blocks))
+		buf->f_bfree = 0;
+	else
+		buf->f_bfree = buf->f_blocks - sbi->s_used_blocks;
+	buf->f_bavail = buf->f_bfree;
+
+	for (t = 0; t < ZONEFS_ZTYPE_MAX; t++) {
+		if (sbi->s_nr_files[t])
+			buf->f_files += sbi->s_nr_files[t] + 1;
+	}
+	buf->f_ffree = 0;
+
+	spin_unlock(&sbi->s_lock);
+
+	fsid = le64_to_cpup((void *)sbi->s_uuid.b) ^
+		le64_to_cpup((void *)sbi->s_uuid.b + sizeof(u64));
+	buf->f_fsid.val[0] = (u32)fsid;
+	buf->f_fsid.val[1] = (u32)(fsid >> 32);
+
+	return 0;
+}
+
+enum {
+	Opt_errors_ro, Opt_errors_zro, Opt_errors_zol, Opt_errors_repair,
+	Opt_err,
+};
+
+static const match_table_t tokens = {
+	{ Opt_errors_ro,	"errors=remount-ro"},
+	{ Opt_errors_zro,	"errors=zone-ro"},
+	{ Opt_errors_zol,	"errors=zone-offline"},
+	{ Opt_errors_repair,	"errors=repair"},
+	{ Opt_err,		NULL}
+};
+
+static int zonefs_parse_options(struct super_block *sb, char *options)
+{
+	struct zonefs_sb_info *sbi = ZONEFS_SB(sb);
+	substring_t args[MAX_OPT_ARGS];
+	char *p;
+
+	if (!options)
+		return 0;
+
+	while ((p = strsep(&options, ",")) != NULL) {
+		int token;
+
+		if (!*p)
+			continue;
+
+		token = match_token(p, tokens, args);
+		switch (token) {
+		case Opt_errors_ro:
+			sbi->s_mount_opts &= ~ZONEFS_MNTOPT_ERRORS_MASK;
+			sbi->s_mount_opts |= ZONEFS_MNTOPT_ERRORS_RO;
+			break;
+		case Opt_errors_zro:
+			sbi->s_mount_opts &= ~ZONEFS_MNTOPT_ERRORS_MASK;
+			sbi->s_mount_opts |= ZONEFS_MNTOPT_ERRORS_ZRO;
+			break;
+		case Opt_errors_zol:
+			sbi->s_mount_opts &= ~ZONEFS_MNTOPT_ERRORS_MASK;
+			sbi->s_mount_opts |= ZONEFS_MNTOPT_ERRORS_ZOL;
+			break;
+		case Opt_errors_repair:
+			sbi->s_mount_opts &= ~ZONEFS_MNTOPT_ERRORS_MASK;
+			sbi->s_mount_opts |= ZONEFS_MNTOPT_ERRORS_REPAIR;
+			break;
+		default:
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+static int zonefs_show_options(struct seq_file *seq, struct dentry *root)
+{
+	struct zonefs_sb_info *sbi = ZONEFS_SB(root->d_sb);
+
+	if (sbi->s_mount_opts & ZONEFS_MNTOPT_ERRORS_RO)
+		seq_puts(seq, ",errors=remount-ro");
+	if (sbi->s_mount_opts & ZONEFS_MNTOPT_ERRORS_ZRO)
+		seq_puts(seq, ",errors=zone-ro");
+	if (sbi->s_mount_opts & ZONEFS_MNTOPT_ERRORS_ZOL)
+		seq_puts(seq, ",errors=zone-offline");
+	if (sbi->s_mount_opts & ZONEFS_MNTOPT_ERRORS_REPAIR)
+		seq_puts(seq, ",errors=repair");
+
+	return 0;
+}
+
+static int zonefs_remount(struct super_block *sb, int *flags, char *data)
+{
+	sync_filesystem(sb);
+
+	return zonefs_parse_options(sb, data);
+}
+
+static const struct super_operations zonefs_sops = {
+	.alloc_inode	= zonefs_alloc_inode,
+	.free_inode	= zonefs_free_inode,
+	.statfs		= zonefs_statfs,
+	.remount_fs	= zonefs_remount,
+	.show_options	= zonefs_show_options,
+};
+
+static const struct inode_operations zonefs_dir_inode_operations = {
+	.lookup		= simple_lookup,
+	.setattr	= zonefs_inode_setattr,
+};
+
+static void zonefs_init_dir_inode(struct inode *parent, struct inode *inode,
+				  enum zonefs_ztype type)
+{
+	struct super_block *sb = parent->i_sb;
+
+	inode->i_ino = blkdev_nr_zones(sb->s_bdev->bd_disk) + type + 1;
+	inode_init_owner(inode, parent, S_IFDIR | 0555);
+	inode->i_op = &zonefs_dir_inode_operations;
+	inode->i_fop = &simple_dir_operations;
+	set_nlink(inode, 2);
+	inc_nlink(parent);
+}
+
+static void zonefs_init_file_inode(struct inode *inode, struct blk_zone *zone,
+				   enum zonefs_ztype type)
+{
+	struct super_block *sb = inode->i_sb;
+	struct zonefs_sb_info *sbi = ZONEFS_SB(sb);
+	struct zonefs_inode_info *zi = ZONEFS_I(inode);
+
+	inode->i_ino = zone->start >> sbi->s_zone_sectors_shift;
+	inode->i_mode = S_IFREG | sbi->s_perm;
+
+	zi->i_ztype = type;
+	zi->i_zsector = zone->start;
+	zi->i_max_size = min_t(loff_t, MAX_LFS_FILESIZE,
+			       zone->len << SECTOR_SHIFT);
+	zi->i_wpoffset = zonefs_check_zone_condition(inode, zone, true);
+
+	inode->i_uid = sbi->s_uid;
+	inode->i_gid = sbi->s_gid;
+	inode->i_size = zi->i_wpoffset;
+	inode->i_blocks = zone->len;
+
+	inode->i_op = &zonefs_file_inode_operations;
+	inode->i_fop = &zonefs_file_operations;
+	inode->i_mapping->a_ops = &zonefs_file_aops;
+
+	sb->s_maxbytes = max(zi->i_max_size, sb->s_maxbytes);
+	sbi->s_blocks += zi->i_max_size >> sb->s_blocksize_bits;
+	sbi->s_used_blocks += zi->i_wpoffset >> sb->s_blocksize_bits;
+}
+
+static struct dentry *zonefs_create_inode(struct dentry *parent,
+					const char *name, struct blk_zone *zone,
+					enum zonefs_ztype type)
+{
+	struct inode *dir = d_inode(parent);
+	struct dentry *dentry;
+	struct inode *inode;
+
+	dentry = d_alloc_name(parent, name);
+	if (!dentry)
+		return NULL;
+
+	inode = new_inode(parent->d_sb);
+	if (!inode)
+		goto dput;
+
+	inode->i_ctime = inode->i_mtime = inode->i_atime = dir->i_ctime;
+	if (zone)
+		zonefs_init_file_inode(inode, zone, type);
+	else
+		zonefs_init_dir_inode(dir, inode, type);
+	d_add(dentry, inode);
+	dir->i_size++;
+
+	return dentry;
+
+dput:
+	dput(dentry);
+
+	return NULL;
+}
+
+struct zonefs_zone_data {
+	struct super_block	*sb;
+	unsigned int		nr_zones[ZONEFS_ZTYPE_MAX];
+	struct blk_zone		*zones;
+};
+
+/*
+ * Create a zone group and populate it with zone files.
+ */
+static int zonefs_create_zgroup(struct zonefs_zone_data *zd,
+				enum zonefs_ztype type)
+{
+	struct super_block *sb = zd->sb;
+	struct zonefs_sb_info *sbi = ZONEFS_SB(sb);
+	struct blk_zone *zone, *next, *end;
+	const char *zgroup_name;
+	char *file_name;
+	struct dentry *dir;
+	unsigned int n = 0;
+	int ret = -ENOMEM;
+
+	/* If the group is empty, there is nothing to do */
+	if (!zd->nr_zones[type])
+		return 0;
+
+	file_name = kmalloc(ZONEFS_NAME_MAX, GFP_KERNEL);
+	if (!file_name)
+		return -ENOMEM;
+
+	if (type == ZONEFS_ZTYPE_CNV)
+		zgroup_name = "cnv";
+	else
+		zgroup_name = "seq";
+
+	dir = zonefs_create_inode(sb->s_root, zgroup_name, NULL, type);
+	if (!dir)
+		goto free;
+
+	/*
+	 * The first zone contains the super block: skip it.
+	 */
+	end = zd->zones + blkdev_nr_zones(sb->s_bdev->bd_disk);
+	for (zone = &zd->zones[1]; zone < end; zone = next) {
+
+		next = zone + 1;
+		if (zonefs_zone_type(zone) != type)
+			continue;
+
+		/*
+		 * For conventional zones, contiguous zones can be aggregated
+		 * together to form larger files. Note that this overwrites the
+		 * length of the first zone of the set of contiguous zones
+		 * aggregated together. If one offline or read-only zone is
+		 * found, assume that all zones aggregated have the same
+		 * condition.
+		 */
+		if (type == ZONEFS_ZTYPE_CNV &&
+		    (sbi->s_features & ZONEFS_F_AGGRCNV)) {
+			for (; next < end; next++) {
+				if (zonefs_zone_type(next) != type)
+					break;
+				zone->len += next->len;
+				if (next->cond == BLK_ZONE_COND_READONLY &&
+				    zone->cond != BLK_ZONE_COND_OFFLINE)
+					zone->cond = BLK_ZONE_COND_READONLY;
+				else if (next->cond == BLK_ZONE_COND_OFFLINE)
+					zone->cond = BLK_ZONE_COND_OFFLINE;
+			}
+		}
+
+		/*
+		 * Use the file number within its group as file name.
+		 */
+		snprintf(file_name, ZONEFS_NAME_MAX - 1, "%u", n);
+		if (!zonefs_create_inode(dir, file_name, zone, type))
+			goto free;
+
+		n++;
+	}
+
+	zonefs_info(sb, "Zone group \"%s\" has %u file%s\n",
+		    zgroup_name, n, n > 1 ? "s" : "");
+
+	sbi->s_nr_files[type] = n;
+	ret = 0;
+
+free:
+	kfree(file_name);
+
+	return ret;
+}
+
+static int zonefs_get_zone_info_cb(struct blk_zone *zone, unsigned int idx,
+				   void *data)
+{
+	struct zonefs_zone_data *zd = data;
+
+	/*
+	 * Count the number of usable zones: the first zone at index 0 contains
+	 * the super block and is ignored.
+	 */
+	switch (zone->type) {
+	case BLK_ZONE_TYPE_CONVENTIONAL:
+		zone->wp = zone->start + zone->len;
+		if (idx)
+			zd->nr_zones[ZONEFS_ZTYPE_CNV]++;
+		break;
+	case BLK_ZONE_TYPE_SEQWRITE_REQ:
+	case BLK_ZONE_TYPE_SEQWRITE_PREF:
+		if (idx)
+			zd->nr_zones[ZONEFS_ZTYPE_SEQ]++;
+		break;
+	default:
+		zonefs_err(zd->sb, "Unsupported zone type 0x%x\n",
+			   zone->type);
+		return -EIO;
+	}
+
+	memcpy(&zd->zones[idx], zone, sizeof(struct blk_zone));
+
+	return 0;
+}
+
+static int zonefs_get_zone_info(struct zonefs_zone_data *zd)
+{
+	struct block_device *bdev = zd->sb->s_bdev;
+	int ret;
+
+	zd->zones = kvcalloc(blkdev_nr_zones(bdev->bd_disk),
+			     sizeof(struct blk_zone), GFP_KERNEL);
+	if (!zd->zones)
+		return -ENOMEM;
+
+	/* Get zones information from the device */
+	ret = blkdev_report_zones(bdev, 0, BLK_ALL_ZONES,
+				  zonefs_get_zone_info_cb, zd);
+	if (ret < 0) {
+		zonefs_err(zd->sb, "Zone report failed %d\n", ret);
+		return ret;
+	}
+
+	if (ret != blkdev_nr_zones(bdev->bd_disk)) {
+		zonefs_err(zd->sb, "Invalid zone report (%d/%u zones)\n",
+			   ret, blkdev_nr_zones(bdev->bd_disk));
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static inline void zonefs_cleanup_zone_info(struct zonefs_zone_data *zd)
+{
+	kvfree(zd->zones);
+}
+
+/*
+ * Read super block information from the device.
+ */
+static int zonefs_read_super(struct super_block *sb)
+{
+	struct zonefs_sb_info *sbi = ZONEFS_SB(sb);
+	struct zonefs_super *super;
+	u32 crc, stored_crc;
+	struct page *page;
+	struct bio_vec bio_vec;
+	struct bio bio;
+	int ret;
+
+	page = alloc_page(GFP_KERNEL);
+	if (!page)
+		return -ENOMEM;
+
+	bio_init(&bio, &bio_vec, 1);
+	bio.bi_iter.bi_sector = 0;
+	bio.bi_opf = REQ_OP_READ;
+	bio_set_dev(&bio, sb->s_bdev);
+	bio_add_page(&bio, page, PAGE_SIZE, 0);
+
+	ret = submit_bio_wait(&bio);
+	if (ret)
+		goto free_page;
+
+	super = kmap(page);
+
+	ret = -EINVAL;
+	if (le32_to_cpu(super->s_magic) != ZONEFS_MAGIC)
+		goto unmap;
+
+	stored_crc = le32_to_cpu(super->s_crc);
+	super->s_crc = 0;
+	crc = crc32(~0U, (unsigned char *)super, sizeof(struct zonefs_super));
+	if (crc != stored_crc) {
+		zonefs_err(sb, "Invalid checksum (Expected 0x%08x, got 0x%08x)",
+			   crc, stored_crc);
+		goto unmap;
+	}
+
+	sbi->s_features = le64_to_cpu(super->s_features);
+	if (sbi->s_features & ~ZONEFS_F_DEFINED_FEATURES) {
+		zonefs_err(sb, "Unknown features set 0x%llx\n",
+			   sbi->s_features);
+		goto unmap;
+	}
+
+	if (sbi->s_features & ZONEFS_F_UID) {
+		sbi->s_uid = make_kuid(current_user_ns(),
+				       le32_to_cpu(super->s_uid));
+		if (!uid_valid(sbi->s_uid)) {
+			zonefs_err(sb, "Invalid UID feature\n");
+			goto unmap;
+		}
+	}
+
+	if (sbi->s_features & ZONEFS_F_GID) {
+		sbi->s_gid = make_kgid(current_user_ns(),
+				       le32_to_cpu(super->s_gid));
+		if (!gid_valid(sbi->s_gid)) {
+			zonefs_err(sb, "Invalid GID feature\n");
+			goto unmap;
+		}
+	}
+
+	if (sbi->s_features & ZONEFS_F_PERM)
+		sbi->s_perm = le32_to_cpu(super->s_perm);
+
+	if (memchr_inv(super->s_reserved, 0, sizeof(super->s_reserved))) {
+		zonefs_err(sb, "Reserved area is being used\n");
+		goto unmap;
+	}
+
+	uuid_copy(&sbi->s_uuid, (uuid_t *)super->s_uuid);
+	ret = 0;
+
+unmap:
+	kunmap(page);
+free_page:
+	__free_page(page);
+
+	return ret;
+}
+
+/*
+ * Check that the device is zoned. If it is, get the list of zones and create
+ * sub-directories and files according to the device zone configuration and
+ * format options.
+ */
+static int zonefs_fill_super(struct super_block *sb, void *data, int silent)
+{
+	struct zonefs_zone_data zd;
+	struct zonefs_sb_info *sbi;
+	struct inode *inode;
+	enum zonefs_ztype t;
+	int ret;
+
+	if (!bdev_is_zoned(sb->s_bdev)) {
+		zonefs_err(sb, "Not a zoned block device\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * Initialize super block information: the maximum file size is updated
+	 * when the zone files are created so that the format option
+	 * ZONEFS_F_AGGRCNV which increases the maximum file size of a file
+	 * beyond the zone size is taken into account.
+	 */
+	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
+	if (!sbi)
+		return -ENOMEM;
+
+	spin_lock_init(&sbi->s_lock);
+	sb->s_fs_info = sbi;
+	sb->s_magic = ZONEFS_MAGIC;
+	sb->s_maxbytes = 0;
+	sb->s_op = &zonefs_sops;
+	sb->s_time_gran	= 1;
+
+	/*
+	 * The block size is set to the device physical sector size to ensure
+	 * that write operations on 512e devices (512B logical block and 4KB
+	 * physical block) are always aligned to the device physical blocks,
+	 * as mandated by the ZBC/ZAC specifications.
+	 */
+	sb_set_blocksize(sb, bdev_physical_block_size(sb->s_bdev));
+	sbi->s_zone_sectors_shift = ilog2(bdev_zone_sectors(sb->s_bdev));
+	sbi->s_uid = GLOBAL_ROOT_UID;
+	sbi->s_gid = GLOBAL_ROOT_GID;
+	sbi->s_perm = 0640;
+	sbi->s_mount_opts = ZONEFS_MNTOPT_ERRORS_RO;
+
+	ret = zonefs_read_super(sb);
+	if (ret)
+		return ret;
+
+	ret = zonefs_parse_options(sb, data);
+	if (ret)
+		return ret;
+
+	memset(&zd, 0, sizeof(struct zonefs_zone_data));
+	zd.sb = sb;
+	ret = zonefs_get_zone_info(&zd);
+	if (ret)
+		goto cleanup;
+
+	zonefs_info(sb, "Mounting %u zones",
+		    blkdev_nr_zones(sb->s_bdev->bd_disk));
+
+	/* Create root directory inode */
+	ret = -ENOMEM;
+	inode = new_inode(sb);
+	if (!inode)
+		goto cleanup;
+
+	inode->i_ino = blkdev_nr_zones(sb->s_bdev->bd_disk);
+	inode->i_mode = S_IFDIR | 0555;
+	inode->i_ctime = inode->i_mtime = inode->i_atime = current_time(inode);
+	inode->i_op = &zonefs_dir_inode_operations;
+	inode->i_fop = &simple_dir_operations;
+	set_nlink(inode, 2);
+
+	sb->s_root = d_make_root(inode);
+	if (!sb->s_root)
+		goto cleanup;
+
+	/* Create and populate files in zone groups directories */
+	for (t = 0; t < ZONEFS_ZTYPE_MAX; t++) {
+		ret = zonefs_create_zgroup(&zd, t);
+		if (ret)
+			break;
+	}
+
+cleanup:
+	zonefs_cleanup_zone_info(&zd);
+
+	return ret;
+}
+
+static struct dentry *zonefs_mount(struct file_system_type *fs_type,
+				   int flags, const char *dev_name, void *data)
+{
+	return mount_bdev(fs_type, flags, dev_name, data, zonefs_fill_super);
+}
+
+static void zonefs_kill_super(struct super_block *sb)
+{
+	struct zonefs_sb_info *sbi = ZONEFS_SB(sb);
+
+	if (sb->s_root)
+		d_genocide(sb->s_root);
+	kill_block_super(sb);
+	kfree(sbi);
+}
+
+/*
+ * File system definition and registration.
+ */
+static struct file_system_type zonefs_type = {
+	.owner		= THIS_MODULE,
+	.name		= "zonefs",
+	.mount		= zonefs_mount,
+	.kill_sb	= zonefs_kill_super,
+	.fs_flags	= FS_REQUIRES_DEV,
+};
+
+static int __init zonefs_init_inodecache(void)
+{
+	zonefs_inode_cachep = kmem_cache_create("zonefs_inode_cache",
+			sizeof(struct zonefs_inode_info), 0,
+			(SLAB_RECLAIM_ACCOUNT | SLAB_MEM_SPREAD | SLAB_ACCOUNT),
+			NULL);
+	if (zonefs_inode_cachep == NULL)
+		return -ENOMEM;
+	return 0;
+}
+
+static void zonefs_destroy_inodecache(void)
+{
+	/*
+	 * Make sure all delayed rcu free inodes are flushed before we
+	 * destroy the inode cache.
+	 */
+	rcu_barrier();
+	kmem_cache_destroy(zonefs_inode_cachep);
+}
+
+static int __init zonefs_init(void)
+{
+	int ret;
+
+	BUILD_BUG_ON(sizeof(struct zonefs_super) != ZONEFS_SUPER_SIZE);
+
+	ret = zonefs_init_inodecache();
+	if (ret)
+		return ret;
+
+	ret = register_filesystem(&zonefs_type);
+	if (ret) {
+		zonefs_destroy_inodecache();
+		return ret;
+	}
+
+	return 0;
+}
+
+static void __exit zonefs_exit(void)
+{
+	zonefs_destroy_inodecache();
+	unregister_filesystem(&zonefs_type);
+}
+
+MODULE_AUTHOR("Damien Le Moal");
+MODULE_DESCRIPTION("Zone file system for zoned block devices");
+MODULE_LICENSE("GPL");
+module_init(zonefs_init);
+module_exit(zonefs_exit);
diff --git a/fs/zonefs/zonefs.h b/fs/zonefs/zonefs.h
new file mode 100644
index 000000000000..ad17fef7ce91
--- /dev/null
+++ b/fs/zonefs/zonefs.h
@@ -0,0 +1,189 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Simple zone file system for zoned block devices.
+ *
+ * Copyright (C) 2019 Western Digital Corporation or its affiliates.
+ */
+#ifndef __ZONEFS_H__
+#define __ZONEFS_H__
+
+#include <linux/fs.h>
+#include <linux/magic.h>
+#include <linux/uuid.h>
+#include <linux/mutex.h>
+#include <linux/rwsem.h>
+
+/*
+ * Maximum length of file names: this only needs to be large enough to fit
+ * the zone group directory names and a decimal zone number for file names.
+ * 16 characters is plenty.
+ */
+#define ZONEFS_NAME_MAX		16
+
+/*
+ * Zone types: ZONEFS_ZTYPE_SEQ is used for all sequential zone types
+ * defined in linux/blkzoned.h, that is, BLK_ZONE_TYPE_SEQWRITE_REQ and
+ * BLK_ZONE_TYPE_SEQWRITE_PREF.
+ */
+enum zonefs_ztype {
+	ZONEFS_ZTYPE_CNV,
+	ZONEFS_ZTYPE_SEQ,
+	ZONEFS_ZTYPE_MAX,
+};
+
+static inline enum zonefs_ztype zonefs_zone_type(struct blk_zone *zone)
+{
+	if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL)
+		return ZONEFS_ZTYPE_CNV;
+	return ZONEFS_ZTYPE_SEQ;
+}
+
+/*
+ * In-memory inode data.
+ */
+struct zonefs_inode_info {
+	struct inode		i_vnode;
+
+	/* File zone type */
+	enum zonefs_ztype	i_ztype;
+
+	/* File zone start sector (512B unit) */
+	sector_t		i_zsector;
+
+	/* File zone write pointer position (sequential zones only) */
+	loff_t			i_wpoffset;
+
+	/* File maximum size */
+	loff_t			i_max_size;
+
+	/*
+	 * To serialise fully against both syscall and mmap based IO and
+	 * sequential file truncation, two locks are used. For serializing
+	 * zonefs_seq_file_truncate() against zonefs_iomap_begin(), that is,
+	 * file truncate operations against block mapping, i_truncate_mutex is
+	 * used. i_truncate_mutex also protects against concurrent accesses
+	 * and changes to the inode private data, and in particular changes to
+	 * a sequential file size on completion of direct IO writes.
+	 * Serialization of mmap read IOs with truncate and syscall IO
+	 * operations is done with i_mmap_sem in addition to i_truncate_mutex.
+	 * Only zonefs_seq_file_truncate() takes both lock (i_mmap_sem first,
+	 * i_truncate_mutex second).
+	 */
+	struct mutex		i_truncate_mutex;
+	struct rw_semaphore	i_mmap_sem;
+};
+
+static inline struct zonefs_inode_info *ZONEFS_I(struct inode *inode)
+{
+	return container_of(inode, struct zonefs_inode_info, i_vnode);
+}
+
+/*
+ * On-disk super block (block 0).
+ */
+#define ZONEFS_LABEL_LEN	64
+#define ZONEFS_UUID_SIZE	16
+#define ZONEFS_SUPER_SIZE	4096
+
+struct zonefs_super {
+
+	/* Magic number */
+	__le32		s_magic;
+
+	/* Checksum */
+	__le32		s_crc;
+
+	/* Volume label */
+	char		s_label[ZONEFS_LABEL_LEN];
+
+	/* 128-bit uuid */
+	__u8		s_uuid[ZONEFS_UUID_SIZE];
+
+	/* Features */
+	__le64		s_features;
+
+	/* UID/GID to use for files */
+	__le32		s_uid;
+	__le32		s_gid;
+
+	/* File permissions */
+	__le32		s_perm;
+
+	/* Padding to ZONEFS_SUPER_SIZE bytes */
+	__u8		s_reserved[3988];
+
+} __packed;
+
+/*
+ * Feature flags: specified in the s_features field of the on-disk super
+ * block struct zonefs_super and in-memory in the s_feartures field of
+ * struct zonefs_sb_info.
+ */
+enum zonefs_features {
+	/*
+	 * Aggregate contiguous conventional zones into a single file.
+	 */
+	ZONEFS_F_AGGRCNV = 1ULL << 0,
+	/*
+	 * Use super block specified UID for files instead of default 0.
+	 */
+	ZONEFS_F_UID = 1ULL << 1,
+	/*
+	 * Use super block specified GID for files instead of default 0.
+	 */
+	ZONEFS_F_GID = 1ULL << 2,
+	/*
+	 * Use super block specified file permissions instead of default 640.
+	 */
+	ZONEFS_F_PERM = 1ULL << 3,
+};
+
+#define ZONEFS_F_DEFINED_FEATURES \
+	(ZONEFS_F_AGGRCNV | ZONEFS_F_UID | ZONEFS_F_GID | ZONEFS_F_PERM)
+
+/*
+ * Mount options for zone write pointer error handling.
+ */
+#define ZONEFS_MNTOPT_ERRORS_RO		(1 << 0) /* Make zone file readonly */
+#define ZONEFS_MNTOPT_ERRORS_ZRO	(1 << 1) /* Make zone file offline */
+#define ZONEFS_MNTOPT_ERRORS_ZOL	(1 << 2) /* Make zone file offline */
+#define ZONEFS_MNTOPT_ERRORS_REPAIR	(1 << 3) /* Remount read-only */
+#define ZONEFS_MNTOPT_ERRORS_MASK	\
+	(ZONEFS_MNTOPT_ERRORS_RO | ZONEFS_MNTOPT_ERRORS_ZRO | \
+	 ZONEFS_MNTOPT_ERRORS_ZOL | ZONEFS_MNTOPT_ERRORS_REPAIR)
+
+/*
+ * In-memory Super block information.
+ */
+struct zonefs_sb_info {
+
+	unsigned long		s_mount_opts;
+
+	spinlock_t		s_lock;
+
+	unsigned long long	s_features;
+	kuid_t			s_uid;
+	kgid_t			s_gid;
+	umode_t			s_perm;
+	uuid_t			s_uuid;
+	unsigned int		s_zone_sectors_shift;
+
+	unsigned int		s_nr_files[ZONEFS_ZTYPE_MAX];
+
+	loff_t			s_blocks;
+	loff_t			s_used_blocks;
+};
+
+static inline struct zonefs_sb_info *ZONEFS_SB(struct super_block *sb)
+{
+	return sb->s_fs_info;
+}
+
+#define zonefs_info(sb, format, args...)	\
+	pr_info("zonefs (%s): " format, sb->s_id, ## args)
+#define zonefs_err(sb, format, args...)		\
+	pr_err("zonefs (%s) ERROR: " format, sb->s_id, ## args)
+#define zonefs_warn(sb, format, args...)	\
+	pr_warn("zonefs (%s) WARNING: " format, sb->s_id, ## args)
+
+#endif
diff --git a/include/uapi/linux/magic.h b/include/uapi/linux/magic.h
index 3ac436376d79..d78064007b17 100644
--- a/include/uapi/linux/magic.h
+++ b/include/uapi/linux/magic.h
@@ -87,6 +87,7 @@
 #define NSFS_MAGIC		0x6e736673
 #define BPF_FS_MAGIC		0xcafe4a11
 #define AAFS_MAGIC		0x5a3c69f0
+#define ZONEFS_MAGIC		0x5a4f4653
 
 /* Since UDF 2.01 is ISO 13346 based... */
 #define UDF_SUPER_MAGIC		0x15013346
-- 
2.24.1

