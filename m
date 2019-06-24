Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA33B50004
	for <lists+linux-xfs@lfdr.de>; Mon, 24 Jun 2019 05:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbfFXDIP (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 23 Jun 2019 23:08:15 -0400
Received: from icp-osb-irony-out1.external.iinet.net.au ([203.59.1.210]:33360
        "EHLO icp-osb-irony-out1.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727027AbfFXDIP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Jun 2019 23:08:15 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2AJAQCVOxBd/3Gu0HYNVxwBAQEEAQE?=
 =?us-ascii?q?HBAEBgWeELYQWk0kGgRGJeIUXi3cJAQEBAQEBAQEBNwEBAYQ6AwICgwE4EwE?=
 =?us-ascii?q?DAQEBBAEBAQEEAZB7AgEDIwRSEBgNAiYCAkcQBhOFGaJJcX4zGooRgQwogWK?=
 =?us-ascii?q?KE3iBB4FEgx2HToJYBI5KhXc/lQkJghaTfQyNIAOKGC2DY6IogXlNLgqDJ4J?=
 =?us-ascii?q?NF44tZZAyAQE?=
X-IPAS-Result: =?us-ascii?q?A2AJAQCVOxBd/3Gu0HYNVxwBAQEEAQEHBAEBgWeELYQWk?=
 =?us-ascii?q?0kGgRGJeIUXi3cJAQEBAQEBAQEBNwEBAYQ6AwICgwE4EwEDAQEBBAEBAQEEA?=
 =?us-ascii?q?ZB7AgEDIwRSEBgNAiYCAkcQBhOFGaJJcX4zGooRgQwogWKKE3iBB4FEgx2HT?=
 =?us-ascii?q?oJYBI5KhXc/lQkJghaTfQyNIAOKGC2DY6IogXlNLgqDJ4JNF44tZZAyAQE?=
X-IronPort-AV: E=Sophos;i="5.63,410,1557158400"; 
   d="scan'208";a="221015855"
Received: from unknown (HELO [192.168.1.222]) ([118.208.174.113])
  by icp-osb-irony-out1.iinet.net.au with ESMTP; 24 Jun 2019 10:59:02 +0800
Subject: [PATCH 07/10] xfs: mount-api - add xfs_fc_free()
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Mon, 24 Jun 2019 10:59:02 +0800
Message-ID: <156134514204.2519.9597800141023778002.stgit@fedora-28>
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

Add the fs_context_operations method .free that performs fs
context cleanup on context release.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/xfs/xfs_super.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 7326b21b32d1..0a771e1390e7 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -2413,10 +2413,33 @@ static const struct super_operations xfs_super_operations = {
 	.free_cached_objects	= xfs_fs_free_cached_objects,
 };
 
+static void xfs_fc_free(struct fs_context *fc)
+{
+	struct xfs_fs_context	*ctx = fc->fs_private;
+	struct xfs_mount	*mp = fc->s_fs_info;
+
+	if (mp) {
+		/*
+		 * If an error occurs before ownership the xfs_mount
+		 * info struct is passed to xfs by the VFS (by assigning
+		 * it to sb->s_fs_info and clearing the corresponding
+		 * fs_context field, done before calling fill super via
+		 * .get_tree()) there may be some strings to cleanup.
+		 */
+		if (mp->m_logname)
+			kfree(mp->m_logname);
+		if (mp->m_rtname)
+			kfree(mp->m_rtname);
+		kfree(mp);
+	}
+	kfree(ctx);
+}
+
 static const struct fs_context_operations xfs_context_ops = {
 	.parse_param = xfs_parse_param,
 	.get_tree    = xfs_get_tree,
 	.reconfigure = xfs_reconfigure,
+	.free	     = xfs_fc_free,
 };
 
 static struct file_system_type xfs_fs_type = {

