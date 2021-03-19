Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B67A341228
	for <lists+linux-xfs@lfdr.de>; Fri, 19 Mar 2021 02:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhCSBeV (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 18 Mar 2021 21:34:21 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:34869 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229948AbhCSBd6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Mar 2021 21:33:58 -0400
Received: from dread.disaster.area (pa49-181-239-12.pa.nsw.optusnet.com.au [49.181.239.12])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id BAFA663EF9;
        Fri, 19 Mar 2021 12:33:56 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lN41U-0048oQ-7o; Fri, 19 Mar 2021 12:33:56 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lN41U-003FtL-0D; Fri, 19 Mar 2021 12:33:56 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     hsiangkao@redhat.com
Subject: [PATCH 7/7] repair: scale duplicate name checking in phase 6.
Date:   Fri, 19 Mar 2021 12:33:55 +1100
Message-Id: <20210319013355.776008-8-david@fromorbit.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210319013355.776008-1-david@fromorbit.com>
References: <20210319013355.776008-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0 cx=a_idp_d
        a=gO82wUwQTSpaJfP49aMSow==:117 a=gO82wUwQTSpaJfP49aMSow==:17
        a=dESyimp9J3IA:10 a=20KFwNOVAAAA:8 a=3pgqu3-PYap36f93kZgA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

phase 6 on large directories is cpu bound on duplicate name checking
due to the algorithm having effectively O(n^2) scalability. Hence
when the duplicate name hash table  size is far smaller than the
number of directory entries, we end up with long hash chains that
are searched linearly on every new entry that is found in the
directory to do duplicate detection.

The in-memory hash table size is limited to 64k entries. Hence when
we have millions of entries in a directory, duplicate entry lookups
on the hash table have substantial overhead. Scale this table out to
larger sizes so that we keep the chain lengths short and hence the
O(n^2) scalability impact is limited because N is always small.

For a 10M entry directory consuming 400MB of directory data, the
hash table now sizes at 6.4 million entries instead of ~64k - it is
~100x larger. While the hash table now consumes ~50MB of RAM, the
xfs_repair footprint barely changes as it's using already consuming
~9GB of RAM at this point in time. IOWs, the incremental memory
usage change is noise, but the directory checking time:

Unpatched:

  97.11%  xfs_repair          [.] dir_hash_add
   0.38%  xfs_repair          [.] longform_dir2_entry_check_data
   0.34%  libc-2.31.so        [.] __libc_calloc
   0.32%  xfs_repair          [.] avl_ino_start

Phase 6:        10/22 12:11:40  10/22 12:14:28  2 minutes, 48 seconds

Patched:

  46.74%  xfs_repair          [.] radix_tree_lookup
  32.13%  xfs_repair          [.] dir_hash_see_all
   7.70%  xfs_repair          [.] radix_tree_tag_get
   3.92%  xfs_repair          [.] dir_hash_add
   3.52%  xfs_repair          [.] radix_tree_tag_clear
   2.43%  xfs_repair          [.] crc32c_le

Phase 6:        10/22 13:11:01  10/22 13:11:18  17 seconds

has been reduced by an order of magnitude.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 repair/phase6.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/repair/phase6.c b/repair/phase6.c
index a432856cca52..f72c92032009 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -288,19 +288,37 @@ dir_hash_done(
 	free(hashtab);
 }
 
+/*
+ * Create a directory hash index structure based on the size of the directory we
+ * are about to try to repair. The size passed in is the size of the data
+ * segment of the directory in bytes, so we don't really know exactly how many
+ * entries are in it. Hence assume an entry size of around 64 bytes - that's a
+ * name length of 40+ bytes so should cover a most situations with large
+ * really directories.
+ */
 static struct dir_hash_tab *
 dir_hash_init(
 	xfs_fsize_t		size)
 {
-	struct dir_hash_tab	*hashtab;
+	struct dir_hash_tab	*hashtab = NULL;
 	int			hsize;
 
-	hsize = size / (16 * 4);
-	if (hsize > 65536)
-		hsize = 63336;
-	else if (hsize < 16)
+	hsize = size / 64;
+	if (hsize < 16)
 		hsize = 16;
-	if ((hashtab = calloc(DIR_HASH_TAB_SIZE(hsize), 1)) == NULL)
+
+	/*
+	 * Try to allocate as large a hash table as possible. Failure to
+	 * allocate isn't fatal, it will just result in slower performance as we
+	 * reduce the size of the table.
+	 */
+	while (hsize >= 16) {
+		hashtab = calloc(DIR_HASH_TAB_SIZE(hsize), 1);
+		if (hashtab)
+			break;
+		hsize /= 2;
+	}
+	if (!hashtab)
 		do_error(_("calloc failed in dir_hash_init\n"));
 	hashtab->size = hsize;
 	hashtab->byhash = (struct dir_hash_ent **)((char *)hashtab +
-- 
2.30.1

