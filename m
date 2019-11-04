Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A096AEDD06
	for <lists+linux-xfs@lfdr.de>; Mon,  4 Nov 2019 11:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728481AbfKDKzl (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 4 Nov 2019 05:55:41 -0500
Received: from icp-osb-irony-out4.external.iinet.net.au ([203.59.1.220]:34019
        "EHLO icp-osb-irony-out4.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727771AbfKDKzl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Nov 2019 05:55:41 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2B+AQC6AsBd/xK90HYNWRwBAQEBAQc?=
 =?us-ascii?q?BAREBBAQBAYF9gW+CToQpj1gBAQEBAQEGixqFMYwRCQEBAQEBAQEBATcBAYQ?=
 =?us-ascii?q?7AwIChDA4EwIOAQEBBAEBAQEBBQMBhViGKgIBAyMEUhAYDQImAgJHEAYThXW?=
 =?us-ascii?q?wYnV/MxqKM4EOKIFlikZ4gQeBEYNQh1WCXgSPQzeGQEOWdYIulVEMjigDiy4?=
 =?us-ascii?q?tqX2Bek0uCoMnUIM3F44wZ45tAQE?=
X-IPAS-Result: =?us-ascii?q?A2B+AQC6AsBd/xK90HYNWRwBAQEBAQcBAREBBAQBAYF9g?=
 =?us-ascii?q?W+CToQpj1gBAQEBAQEGixqFMYwRCQEBAQEBAQEBATcBAYQ7AwIChDA4EwIOA?=
 =?us-ascii?q?QEBBAEBAQEBBQMBhViGKgIBAyMEUhAYDQImAgJHEAYThXWwYnV/MxqKM4EOK?=
 =?us-ascii?q?IFlikZ4gQeBEYNQh1WCXgSPQzeGQEOWdYIulVEMjigDiy4tqX2Bek0uCoMnU?=
 =?us-ascii?q?IM3F44wZ45tAQE?=
X-IronPort-AV: E=Sophos;i="5.68,266,1569254400"; 
   d="scan'208";a="207138692"
Received: from unknown (HELO [192.168.1.222]) ([118.208.189.18])
  by icp-osb-irony-out4.iinet.net.au with ESMTP; 04 Nov 2019 18:55:38 +0800
Subject: [PATCH v9 12/17] xfs: dont set sb in xfs_mount_alloc()
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Mon, 04 Nov 2019 18:55:38 +0800
Message-ID: <157286493892.18393.741584813179014451.stgit@fedora-28>
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

When changing to use the new mount api the super block won't be
available when the xfs_mount struct is allocated so move setting the
super block in xfs_mount to xfs_fs_fill_super().

Signed-off-by: Ian Kent <raven@themaw.net>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_super.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 4b570ba3456a..62dfc678c415 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1560,8 +1560,7 @@ xfs_destroy_percpu_counters(
 }
 
 static struct xfs_mount *
-xfs_mount_alloc(
-	struct super_block	*sb)
+xfs_mount_alloc(void)
 {
 	struct xfs_mount	*mp;
 
@@ -1569,7 +1568,6 @@ xfs_mount_alloc(
 	if (!mp)
 		return NULL;
 
-	mp->m_super = sb;
 	spin_lock_init(&mp->m_sb_lock);
 	spin_lock_init(&mp->m_agirotor_lock);
 	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_ATOMIC);
@@ -1605,9 +1603,10 @@ xfs_fs_fill_super(
 	 * allocate mp and do all low-level struct initializations before we
 	 * attach it to the super
 	 */
-	mp = xfs_mount_alloc(sb);
+	mp = xfs_mount_alloc();
 	if (!mp)
 		goto out;
+	mp->m_super = sb;
 	sb->s_fs_info = mp;
 
 	error = xfs_parseargs(mp, (char *)data);

