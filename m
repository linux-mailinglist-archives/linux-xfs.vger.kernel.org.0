Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91A923C7BE0
	for <lists+linux-xfs@lfdr.de>; Wed, 14 Jul 2021 04:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237375AbhGNCh7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 13 Jul 2021 22:37:59 -0400
Received: from mail108.syd.optusnet.com.au ([211.29.132.59]:34427 "EHLO
        mail108.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237457AbhGNCh7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Jul 2021 22:37:59 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail108.syd.optusnet.com.au (Postfix) with ESMTPS id E01D81B1176;
        Wed, 14 Jul 2021 12:34:47 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m3UjW-006Hef-Qa; Wed, 14 Jul 2021 12:34:46 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1m3UjW-00Awej-Ih; Wed, 14 Jul 2021 12:34:46 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     linux-mm@kvack.org
Subject: [PATCH 1/3] mm: Add kvrealloc()
Date:   Wed, 14 Jul 2021 12:34:38 +1000
Message-Id: <20210714023440.2608690-2-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210714023440.2608690-1-david@fromorbit.com>
References: <20210714023440.2608690-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=e_q4qTt1xDgA:10 a=20KFwNOVAAAA:8 a=FgU_YNmxFDRv79IIi3MA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

During log recovery of an XFS filesystem with 64kB directory
buffers, rebuilding a buffer split across two log records results
in a memory allocation warning from krealloc like this:

xfs filesystem being mounted at /mnt/scratch supports timestamps until 2038 (0x7fffffff)
XFS (dm-0): Unmounting Filesystem
XFS (dm-0): Mounting V5 Filesystem
XFS (dm-0): Starting recovery (logdev: internal)
------------[ cut here ]------------
WARNING: CPU: 5 PID: 3435170 at mm/page_alloc.c:3539 get_page_from_freelist+0xdee/0xe40
.....
RIP: 0010:get_page_from_freelist+0xdee/0xe40
Call Trace:
 ? complete+0x3f/0x50
 __alloc_pages+0x16f/0x300
 alloc_pages+0x87/0x110
 kmalloc_order+0x2c/0x90
 kmalloc_order_trace+0x1d/0x90
 __kmalloc_track_caller+0x215/0x270
 ? xlog_recover_add_to_cont_trans+0x63/0x1f0
 krealloc+0x54/0xb0
 xlog_recover_add_to_cont_trans+0x63/0x1f0
 xlog_recovery_process_trans+0xc1/0xd0
 xlog_recover_process_ophdr+0x86/0x130
 xlog_recover_process_data+0x9f/0x160
 xlog_recover_process+0xa2/0x120
 xlog_do_recovery_pass+0x40b/0x7d0
 ? __irq_work_queue_local+0x4f/0x60
 ? irq_work_queue+0x3a/0x50
 xlog_do_log_recovery+0x70/0x150
 xlog_do_recover+0x38/0x1d0
 xlog_recover+0xd8/0x170
 xfs_log_mount+0x181/0x300
 xfs_mountfs+0x4a1/0x9b0
 xfs_fs_fill_super+0x3c0/0x7b0
 get_tree_bdev+0x171/0x270
 ? suffix_kstrtoint.constprop.0+0xf0/0xf0
 xfs_fs_get_tree+0x15/0x20
 vfs_get_tree+0x24/0xc0
 path_mount+0x2f5/0xaf0
 __x64_sys_mount+0x108/0x140
 do_syscall_64+0x3a/0x70
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Essentially, we are taking a multi-order allocation from kmem_alloc()
(which has an open coded no fail, no warn loop) and then
reallocating it out to 64kB using krealloc(__GFP_NOFAIL) and that is
then triggering the above warning.

This is a regression caused by converting this code from an open
coded no fail/no warn reallocation loop to using __GFP_NOFAIL.

What we actually need here is kvrealloc(), so that if contiguous
page allocation fails we fall back to vmalloc() and we don't
get nasty warnings happening in XFS.

Fixes: 771915c4f688 ("xfs: remove kmem_realloc()")
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_log_recover.c |  4 +++-
 include/linux/mm.h       |  2 ++
 mm/util.c                | 15 +++++++++++++++
 3 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 1721fce2ec94..3c08d495844d 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2062,7 +2062,9 @@ xlog_recover_add_to_cont_trans(
 	old_ptr = item->ri_buf[item->ri_cnt-1].i_addr;
 	old_len = item->ri_buf[item->ri_cnt-1].i_len;
 
-	ptr = krealloc(old_ptr, len + old_len, GFP_KERNEL | __GFP_NOFAIL);
+	ptr = kvrealloc(old_ptr, old_len, len + old_len, GFP_KERNEL);
+	if (!ptr)
+		return -ENOMEM;
 	memcpy(&ptr[old_len], dp, len);
 	item->ri_buf[item->ri_cnt-1].i_len += len;
 	item->ri_buf[item->ri_cnt-1].i_addr = ptr;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 57453dba41b9..ff9c00bfb76d 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -829,6 +829,8 @@ static inline void *kvcalloc(size_t n, size_t size, gfp_t flags)
 	return kvmalloc_array(n, size, flags | __GFP_ZERO);
 }
 
+extern void *kvrealloc(const void *p, size_t oldsize, size_t newsize,
+		gfp_t flags);
 extern void kvfree(const void *addr);
 extern void kvfree_sensitive(const void *addr, size_t len);
 
diff --git a/mm/util.c b/mm/util.c
index 99c6cc77de9e..b7698d6b2226 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -635,6 +635,21 @@ void kvfree_sensitive(const void *addr, size_t len)
 }
 EXPORT_SYMBOL(kvfree_sensitive);
 
+void *kvrealloc(const void *p, size_t oldsize, size_t newsize, gfp_t flags)
+{
+	void *newp;
+
+	if (oldsize >= newsize)
+		return (void *)p;
+	newp = kvmalloc(newsize, flags);
+	if (!newp)
+		return NULL;
+	memcpy(newp, p, oldsize);
+	kvfree(p);
+	return newp;
+}
+EXPORT_SYMBOL(kvrealloc);
+
 static inline void *__page_rmapping(struct page *page)
 {
 	unsigned long mapping;
-- 
2.31.1

