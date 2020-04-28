Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 788421BB2D5
	for <lists+linux-xfs@lfdr.de>; Tue, 28 Apr 2020 02:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbgD1AWj (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 27 Apr 2020 20:22:39 -0400
Received: from mga18.intel.com ([134.134.136.126]:16476 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726424AbgD1AVt (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 27 Apr 2020 20:21:49 -0400
IronPort-SDR: otWHwsYP7gJC3Nedz6AbXqXhkUeVc5uPDXCHZ+L0kQVVteh2pfSR7lMCPyRP+Bveh/tYzgz0i9
 BLJquHBI3eig==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2020 17:21:48 -0700
IronPort-SDR: CzElres2me3QpcebS4hq61xayp3+MnEtKbHg/B4tNmZEW4TkWo5aykndJ3RyIAZQsROOEfosir
 v8KDoWQIoJgg==
X-IronPort-AV: E=Sophos;i="5.73,325,1583222400"; 
   d="scan'208";a="275659926"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Apr 2020 17:21:47 -0700
From:   ira.weiny@intel.com
To:     linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Ira Weiny <ira.weiny@intel.com>,
        Dave Chinner <dchinner@redhat.com>, Jan Kara <jack@suse.cz>,
        Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Chinner <david@fromorbit.com>,
        "Theodore Y. Ts'o" <tytso@mit.edu>, Jeff Moyer <jmoyer@redhat.com>,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: [PATCH V11 02/11] fs: Remove unneeded IS_DAX() check in io_is_direct()
Date:   Mon, 27 Apr 2020 17:21:33 -0700
Message-Id: <20200428002142.404144-3-ira.weiny@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200428002142.404144-1-ira.weiny@intel.com>
References: <20200428002142.404144-1-ira.weiny@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

Remove the check because DAX now has it's own read/write methods and
file systems which support DAX check IS_DAX() prior to IOCB_DIRECT on
their own.  Therefore, it does not matter if the file state is DAX when
the iocb flags are created.

Also remove io_is_direct() as it is just a simple flag check.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes from v8:
	Rebase to latest Linus tree

Changes from v6:
	remove io_is_direct() as well.
	Remove Reviews since this is quite a bit different.

Changes from v3:
	Reword commit message.
	Reordered to be a 'pre-cleanup' patch
---
 drivers/block/loop.c | 6 +++---
 include/linux/fs.h   | 7 +------
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index da693e6a834e..14372df0f354 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -634,8 +634,8 @@ static int do_req_filebacked(struct loop_device *lo, struct request *rq)
 
 static inline void loop_update_dio(struct loop_device *lo)
 {
-	__loop_update_dio(lo, io_is_direct(lo->lo_backing_file) |
-			lo->use_dio);
+	__loop_update_dio(lo, (lo->lo_backing_file->f_flags & O_DIRECT) |
+				lo->use_dio);
 }
 
 static void loop_reread_partitions(struct loop_device *lo,
@@ -1028,7 +1028,7 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
 	if (!(lo_flags & LO_FLAGS_READ_ONLY) && file->f_op->fsync)
 		blk_queue_write_cache(lo->lo_queue, true, false);
 
-	if (io_is_direct(lo->lo_backing_file) && inode->i_sb->s_bdev) {
+	if ((lo->lo_backing_file->f_flags & O_DIRECT) && inode->i_sb->s_bdev) {
 		/* In case of direct I/O, match underlying block size */
 		unsigned short bsize = bdev_logical_block_size(
 			inode->i_sb->s_bdev);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 4f6f59b4f22a..a87cc5845a02 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3394,11 +3394,6 @@ extern void setattr_copy(struct inode *inode, const struct iattr *attr);
 
 extern int file_update_time(struct file *file);
 
-static inline bool io_is_direct(struct file *filp)
-{
-	return (filp->f_flags & O_DIRECT) || IS_DAX(filp->f_mapping->host);
-}
-
 static inline bool vma_is_dax(const struct vm_area_struct *vma)
 {
 	return vma->vm_file && IS_DAX(vma->vm_file->f_mapping->host);
@@ -3423,7 +3418,7 @@ static inline int iocb_flags(struct file *file)
 	int res = 0;
 	if (file->f_flags & O_APPEND)
 		res |= IOCB_APPEND;
-	if (io_is_direct(file))
+	if (file->f_flags & O_DIRECT)
 		res |= IOCB_DIRECT;
 	if ((file->f_flags & O_DSYNC) || IS_SYNC(file->f_mapping->host))
 		res |= IOCB_DSYNC;
-- 
2.25.1

