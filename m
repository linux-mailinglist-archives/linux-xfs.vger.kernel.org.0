Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD9A0EDCF9
	for <lists+linux-xfs@lfdr.de>; Mon,  4 Nov 2019 11:54:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728728AbfKDKyu (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 4 Nov 2019 05:54:50 -0500
Received: from icp-osb-irony-out4.external.iinet.net.au ([203.59.1.220]:34019
        "EHLO icp-osb-irony-out4.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728559AbfKDKyu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 05:54:50 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2CEAAC6AsBd/xK90HYNWRsBAQEBAQE?=
 =?us-ascii?q?BBQEBAREBAQMDAQEBgX2EPYQpj1gBAQEBAQEGgRGKCYUxjBEJAQEBAQEBAQE?=
 =?us-ascii?q?BNwEBhDsDAgKEMDgTAg4BAQEEAQEBAQEFAwGFWIYqAgEDIwRSEBgNAiYCAkc?=
 =?us-ascii?q?QBhOFdbBidX8zGoozgQ4ogWWKRniBB4ERM4Mdh1WCXgSNFIIvN4VfYUOWdYI?=
 =?us-ascii?q?ulVEMjigDiy4tqX2Bek0uCoMnUIM3F44wZ45tAQE?=
X-IPAS-Result: =?us-ascii?q?A2CEAAC6AsBd/xK90HYNWRsBAQEBAQEBBQEBAREBAQMDA?=
 =?us-ascii?q?QEBgX2EPYQpj1gBAQEBAQEGgRGKCYUxjBEJAQEBAQEBAQEBNwEBhDsDAgKEM?=
 =?us-ascii?q?DgTAg4BAQEEAQEBAQEFAwGFWIYqAgEDIwRSEBgNAiYCAkcQBhOFdbBidX8zG?=
 =?us-ascii?q?oozgQ4ogWWKRniBB4ERM4Mdh1WCXgSNFIIvN4VfYUOWdYIulVEMjigDiy4tq?=
 =?us-ascii?q?X2Bek0uCoMnUIM3F44wZ45tAQE?=
X-IronPort-AV: E=Sophos;i="5.68,266,1569254400"; 
   d="scan'208";a="207138643"
Received: from unknown (HELO [192.168.1.222]) ([118.208.189.18])
  by icp-osb-irony-out4.iinet.net.au with ESMTP; 04 Nov 2019 18:54:46 +0800
Subject: [PATCH v9 02/17] xfs: use super s_id instead of struct xfs_mount
 m_fsname
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Mon, 04 Nov 2019 18:54:46 +0800
Message-ID: <157286488618.18393.1609303449076519243.stgit@fedora-28>
In-Reply-To: <157286480109.18393.6285224459642752559.stgit@fedora-28>
References: <157286480109.18393.6285224459642752559.stgit@fedora-28>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Eliminate struct xfs_mount field m_fsname by using the super block s_id
field directly.

Signed-off-by: Ian Kent <raven@themaw.net>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_error.c     |    2 +-
 fs/xfs/xfs_log.c       |    2 +-
 fs/xfs/xfs_message.c   |    4 ++--
 fs/xfs/xfs_mount.c     |    5 +++--
 fs/xfs/xfs_mount.h     |    1 -
 fs/xfs/xfs_pnfs.c      |    2 +-
 fs/xfs/xfs_super.c     |   35 +++++++++++++----------------------
 fs/xfs/xfs_trans_ail.c |    2 +-
 8 files changed, 22 insertions(+), 31 deletions(-)

diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index 849fd4476950..3ff3fc202522 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -257,7 +257,7 @@ xfs_errortag_test(
 
 	xfs_warn_ratelimited(mp,
 "Injecting error (%s) at file %s, line %d, on filesystem \"%s\"",
-			expression, file, line, mp->m_fsname);
+			expression, file, line, mp->m_super->s_id);
 	return true;
 }
 
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 33fb38864207..d7d3bfd6a920 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1526,7 +1526,7 @@ xlog_alloc_log(
 
 	log->l_ioend_workqueue = alloc_workqueue("xfs-log/%s",
 			WQ_MEM_RECLAIM | WQ_FREEZABLE | WQ_HIGHPRI, 0,
-			mp->m_fsname);
+			mp->m_super->s_id);
 	if (!log->l_ioend_workqueue)
 		goto out_free_iclog;
 
diff --git a/fs/xfs/xfs_message.c b/fs/xfs/xfs_message.c
index 9804efe525a9..584d0eb7cbd8 100644
--- a/fs/xfs/xfs_message.c
+++ b/fs/xfs/xfs_message.c
@@ -20,8 +20,8 @@ __xfs_printk(
 	const struct xfs_mount	*mp,
 	struct va_format	*vaf)
 {
-	if (mp && mp->m_fsname) {
-		printk("%sXFS (%s): %pV\n", level, mp->m_fsname, vaf);
+	if (mp && mp->m_super) {
+		printk("%sXFS (%s): %pV\n", level, mp->m_super->s_id, vaf);
 		return;
 	}
 	printk("%sXFS: %pV\n", level, vaf);
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 3e8eedf01eb2..5ea95247a37f 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -667,7 +667,8 @@ xfs_mountfs(
 	/* enable fail_at_unmount as default */
 	mp->m_fail_unmount = true;
 
-	error = xfs_sysfs_init(&mp->m_kobj, &xfs_mp_ktype, NULL, mp->m_fsname);
+	error = xfs_sysfs_init(&mp->m_kobj, &xfs_mp_ktype,
+			       NULL, mp->m_super->s_id);
 	if (error)
 		goto out;
 
@@ -1241,7 +1242,7 @@ xfs_mod_fdblocks(
 	printk_once(KERN_WARNING
 		"Filesystem \"%s\": reserve blocks depleted! "
 		"Consider increasing reserve pool size.",
-		mp->m_fsname);
+		mp->m_super->s_id);
 fdblocks_enospc:
 	spin_unlock(&mp->m_sb_lock);
 	return -ENOSPC;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 6e7d746b41bc..0481e6d086a7 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -89,7 +89,6 @@ typedef struct xfs_mount {
 	struct percpu_counter	m_delalloc_blks;
 
 	struct xfs_buf		*m_sb_bp;	/* buffer for superblock */
-	char			*m_fsname;	/* filesystem name */
 	char			*m_rtname;	/* realtime device name */
 	char			*m_logname;	/* external log device name */
 	int			m_bsize;	/* fs logical block size */
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index c637f0192976..5233929d9538 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -60,7 +60,7 @@ xfs_fs_get_uuid(
 
 	printk_once(KERN_NOTICE
 "XFS (%s): using experimental pNFS feature, use at your own risk!\n",
-		mp->m_fsname);
+		mp->m_super->s_id);
 
 	if (*len < sizeof(uuid_t))
 		return -EINVAL;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index f3ecd696180d..6438738a204a 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -161,14 +161,6 @@ xfs_parseargs(
 	substring_t		args[MAX_OPT_ARGS];
 	int			size = 0;
 
-	/*
-	 * set up the mount name first so all the errors will refer to the
-	 * correct device.
-	 */
-	mp->m_fsname = kstrndup(sb->s_id, MAXNAMELEN, GFP_KERNEL);
-	if (!mp->m_fsname)
-		return -ENOMEM;
-
 	/*
 	 * Copy binary VFS mount flags we are interested in.
 	 */
@@ -778,33 +770,33 @@ xfs_init_mount_workqueues(
 	struct xfs_mount	*mp)
 {
 	mp->m_buf_workqueue = alloc_workqueue("xfs-buf/%s",
-			WQ_MEM_RECLAIM|WQ_FREEZABLE, 1, mp->m_fsname);
+			WQ_MEM_RECLAIM|WQ_FREEZABLE, 1, mp->m_super->s_id);
 	if (!mp->m_buf_workqueue)
 		goto out;
 
 	mp->m_unwritten_workqueue = alloc_workqueue("xfs-conv/%s",
-			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0, mp->m_fsname);
+			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0, mp->m_super->s_id);
 	if (!mp->m_unwritten_workqueue)
 		goto out_destroy_buf;
 
 	mp->m_cil_workqueue = alloc_workqueue("xfs-cil/%s",
 			WQ_MEM_RECLAIM | WQ_FREEZABLE | WQ_UNBOUND,
-			0, mp->m_fsname);
+			0, mp->m_super->s_id);
 	if (!mp->m_cil_workqueue)
 		goto out_destroy_unwritten;
 
 	mp->m_reclaim_workqueue = alloc_workqueue("xfs-reclaim/%s",
-			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0, mp->m_fsname);
+			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0, mp->m_super->s_id);
 	if (!mp->m_reclaim_workqueue)
 		goto out_destroy_cil;
 
 	mp->m_eofblocks_workqueue = alloc_workqueue("xfs-eofblocks/%s",
-			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0, mp->m_fsname);
+			WQ_MEM_RECLAIM|WQ_FREEZABLE, 0, mp->m_super->s_id);
 	if (!mp->m_eofblocks_workqueue)
 		goto out_destroy_reclaim;
 
 	mp->m_sync_workqueue = alloc_workqueue("xfs-sync/%s", WQ_FREEZABLE, 0,
-					       mp->m_fsname);
+					       mp->m_super->s_id);
 	if (!mp->m_sync_workqueue)
 		goto out_destroy_eofb;
 
@@ -1009,10 +1001,9 @@ xfs_fs_drop_inode(
 }
 
 STATIC void
-xfs_free_fsname(
+xfs_free_names(
 	struct xfs_mount	*mp)
 {
-	kfree(mp->m_fsname);
 	kfree(mp->m_rtname);
 	kfree(mp->m_logname);
 }
@@ -1189,7 +1180,7 @@ xfs_test_remount_options(
 
 	tmp_mp->m_super = sb;
 	error = xfs_parseargs(tmp_mp, options);
-	xfs_free_fsname(tmp_mp);
+	xfs_free_names(tmp_mp);
 	kmem_free(tmp_mp);
 
 	return error;
@@ -1555,7 +1546,7 @@ xfs_fs_fill_super(
 
 	error = xfs_parseargs(mp, (char *)data);
 	if (error)
-		goto out_free_fsname;
+		goto out_free_names;
 
 	sb_min_blocksize(sb, BBSIZE);
 	sb->s_xattr = xfs_xattr_handlers;
@@ -1582,7 +1573,7 @@ xfs_fs_fill_super(
 
 	error = xfs_open_devices(mp);
 	if (error)
-		goto out_free_fsname;
+		goto out_free_names;
 
 	error = xfs_init_mount_workqueues(mp);
 	if (error)
@@ -1719,9 +1710,9 @@ xfs_fs_fill_super(
 	xfs_destroy_mount_workqueues(mp);
  out_close_devices:
 	xfs_close_devices(mp);
- out_free_fsname:
+ out_free_names:
 	sb->s_fs_info = NULL;
-	xfs_free_fsname(mp);
+	xfs_free_names(mp);
 	kfree(mp);
  out:
 	return error;
@@ -1753,7 +1744,7 @@ xfs_fs_put_super(
 	xfs_close_devices(mp);
 
 	sb->s_fs_info = NULL;
-	xfs_free_fsname(mp);
+	xfs_free_names(mp);
 	kfree(mp);
 }
 
diff --git a/fs/xfs/xfs_trans_ail.c b/fs/xfs/xfs_trans_ail.c
index 6ccfd75d3c24..aea71ee189f5 100644
--- a/fs/xfs/xfs_trans_ail.c
+++ b/fs/xfs/xfs_trans_ail.c
@@ -836,7 +836,7 @@ xfs_trans_ail_init(
 	init_waitqueue_head(&ailp->ail_empty);
 
 	ailp->ail_task = kthread_run(xfsaild, ailp, "xfsaild/%s",
-			ailp->ail_mount->m_fsname);
+			ailp->ail_mount->m_super->s_id);
 	if (IS_ERR(ailp->ail_task))
 		goto out_free_ailp;
 

