Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1F5750007
	for <lists+linux-xfs@lfdr.de>; Mon, 24 Jun 2019 05:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbfFXDIe (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 23 Jun 2019 23:08:34 -0400
Received: from icp-osb-irony-out1.external.iinet.net.au ([203.59.1.210]:33411
        "EHLO icp-osb-irony-out1.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726980AbfFXDIe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 23 Jun 2019 23:08:34 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2AJAQCVOxBd/3Gu0HYNVxwBAQEEAQE?=
 =?us-ascii?q?HBAEBgWeELYQWk0kGgRGJeIUXihCBZwkBAQEBAQEBAQE3AQEBhDoDAgKDATg?=
 =?us-ascii?q?TAQMBAQEEAQEBAQQBkHsCAQMjVhAYDQImAgJHEAYThRmiSXGBMRqKEYEMKIF?=
 =?us-ascii?q?iihN4gQeBRIMdhCyDIoJYBI5KhXc/lQkJghaTfQyNIAOKGC2DY6IogXlNLgq?=
 =?us-ascii?q?DJ4JNF44tZZAyAQE?=
X-IPAS-Result: =?us-ascii?q?A2AJAQCVOxBd/3Gu0HYNVxwBAQEEAQEHBAEBgWeELYQWk?=
 =?us-ascii?q?0kGgRGJeIUXihCBZwkBAQEBAQEBAQE3AQEBhDoDAgKDATgTAQMBAQEEAQEBA?=
 =?us-ascii?q?QQBkHsCAQMjVhAYDQImAgJHEAYThRmiSXGBMRqKEYEMKIFiihN4gQeBRIMdh?=
 =?us-ascii?q?CyDIoJYBI5KhXc/lQkJghaTfQyNIAOKGC2DY6IogXlNLgqDJ4JNF44tZZAyA?=
 =?us-ascii?q?QE?=
X-IronPort-AV: E=Sophos;i="5.63,410,1557158400"; 
   d="scan'208";a="221015963"
Received: from unknown (HELO [192.168.1.222]) ([118.208.174.113])
  by icp-osb-irony-out1.iinet.net.au with ESMTP; 24 Jun 2019 10:59:22 +0800
Subject: [PATCH 10/10] xfs: mount-api - rename xfs_fill_super()
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Mon, 24 Jun 2019 10:59:21 +0800
Message-ID: <156134516161.2519.11373830976371295990.stgit@fedora-28>
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

Now the legacy mount functions have been removed xfs_fill_super()
can be renamed to xfs_fs_fill_super() in keeping with the previous
xfs naming convention.

Signed-off-by: Ian Kent <raven@themaw.net>
---
 fs/xfs/xfs_super.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 643b40e8a328..38f3af44fbbf 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1756,7 +1756,7 @@ __xfs_fs_fill_super(
 }
 
 STATIC int
-xfs_fill_super(
+xfs_fs_fill_super(
 	struct super_block	*sb,
 	struct fs_context	*fc)
 {
@@ -1798,7 +1798,7 @@ STATIC int
 xfs_get_tree(
 	struct fs_context	*fc)
 {
-	return vfs_get_block_super(fc, xfs_fill_super);
+	return vfs_get_block_super(fc, xfs_fs_fill_super);
 }
 
 STATIC void

