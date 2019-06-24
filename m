Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7EDE50002
	for <lists+linux-xfs@lfdr.de>; Mon, 24 Jun 2019 05:08:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbfFXDID (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 23 Jun 2019 23:08:03 -0400
Received: from icp-osb-irony-out1.external.iinet.net.au ([203.59.1.210]:33315
        "EHLO icp-osb-irony-out1.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726323AbfFXDID (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Jun 2019 23:08:03 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2AeAACVOxBd/3Gu0HYNVxwBAQEEAQE?=
 =?us-ascii?q?HBAEBgVUFAQELAYQshBaTSQaBEYl4hReEX4UdgXsJAQEBAQEBAQEBNwEBAYQ?=
 =?us-ascii?q?6AwICgwE2Bw4BAwEBAQQBAQEBBAGQewIBAyMEUhAYDQImAgJHEAYThRmiSXF?=
 =?us-ascii?q?+MxqKEYEMKAGBYYoTeIEHgREzgx2HToJYBIt8gk6Fdz+VCQmCFpN9DI0gA4o?=
 =?us-ascii?q?YLYNjnSiEcAyBfU0uCoMngk0Xji1lkDIBAQ?=
X-IPAS-Result: =?us-ascii?q?A2AeAACVOxBd/3Gu0HYNVxwBAQEEAQEHBAEBgVUFAQELA?=
 =?us-ascii?q?YQshBaTSQaBEYl4hReEX4UdgXsJAQEBAQEBAQEBNwEBAYQ6AwICgwE2Bw4BA?=
 =?us-ascii?q?wEBAQQBAQEBBAGQewIBAyMEUhAYDQImAgJHEAYThRmiSXF+MxqKEYEMKAGBY?=
 =?us-ascii?q?YoTeIEHgREzgx2HToJYBIt8gk6Fdz+VCQmCFpN9DI0gA4oYLYNjnSiEcAyBf?=
 =?us-ascii?q?U0uCoMngk0Xji1lkDIBAQ?=
X-IronPort-AV: E=Sophos;i="5.63,410,1557158400"; 
   d="scan'208";a="221015739"
Received: from unknown (HELO [192.168.1.222]) ([118.208.174.113])
  by icp-osb-irony-out1.iinet.net.au with ESMTP; 24 Jun 2019 10:58:45 +0800
Subject: [PATCH 04/10] xfs: mount-api - refactor xfs_fs_fill_super()
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Mon, 24 Jun 2019 10:58:44 +0800
Message-ID: <156134512264.2519.11045220600510784871.stgit@fedora-28>
In-Reply-To: <156134510205.2519.16185588460828778620.stgit@fedora-28>
References: <156134510205.2519.16185588460828778620.stgit@fedora-28>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Much of the code in xfs_fs_fill_super() will be used by the
fill super function used by the new mount-api.

So refactor the common code into a helper in an attempt to
show what's actually changed.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/xfs/xfs_super.c |   65 ++++++++++++++++++++++++++++++++++------------------
 1 file changed, 42 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index e78fea14d598..cf8efb465969 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1823,27 +1823,14 @@ xfs_mount_alloc(
 
 
 STATIC int
-xfs_fs_fill_super(
-	struct super_block	*sb,
-	void			*data,
+__xfs_fs_fill_super(
+	struct xfs_mount	*mp,
 	int			silent)
 {
+	struct super_block	*sb = mp->m_super;
 	struct inode		*root;
-	struct xfs_mount	*mp = NULL;
-	int			flags = 0, error = -ENOMEM;
-
-	/*
-	 * allocate mp and do all low-level struct initializations before we
-	 * attach it to the super
-	 */
-	mp = xfs_mount_alloc(sb);
-	if (!mp)
-		goto out;
-	sb->s_fs_info = mp;
-
-	error = xfs_parseargs(mp, (char *)data);
-	if (error)
-		goto out_free_fsname;
+	int			flags = 0;
+	int			error;
 
 	sb_min_blocksize(sb, BBSIZE);
 	sb->s_xattr = xfs_xattr_handlers;
@@ -1870,7 +1857,7 @@ xfs_fs_fill_super(
 
 	error = xfs_open_devices(mp);
 	if (error)
-		goto out_free_fsname;
+		goto out;
 
 	error = xfs_init_mount_workqueues(mp);
 	if (error)
@@ -2003,10 +1990,6 @@ xfs_fs_fill_super(
 	xfs_destroy_mount_workqueues(mp);
  out_close_devices:
 	xfs_close_devices(mp);
- out_free_fsname:
-	sb->s_fs_info = NULL;
-	xfs_free_fsname(mp);
-	kfree(mp);
  out:
 	return error;
 
@@ -2016,6 +1999,42 @@ xfs_fs_fill_super(
 	goto out_free_sb;
 }
 
+STATIC int
+xfs_fs_fill_super(
+	struct super_block	*sb,
+	void			*data,
+	int			silent)
+{
+	struct xfs_mount	*mp = NULL;
+	int			error = -ENOMEM;
+
+	/*
+	 * allocate mp and do all low-level struct initializations before we
+	 * attach it to the super
+	 */
+	mp = xfs_mount_alloc(sb);
+	if (!mp)
+		goto out;
+	sb->s_fs_info = mp;
+
+	error = xfs_parseargs(mp, (char *)data);
+	if (error)
+		goto out_free_fsname;
+
+	error = __xfs_fs_fill_super(mp, silent);
+	if (error)
+		goto out_free_fsname;
+
+	return 0;
+
+ out_free_fsname:
+	sb->s_fs_info = NULL;
+	xfs_free_fsname(mp);
+	kfree(mp);
+out:
+	return error;
+}
+
 STATIC void
 xfs_fs_put_super(
 	struct super_block	*sb)

