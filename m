Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F5E77D6F8A
	for <lists+linux-xfs@lfdr.de>; Wed, 25 Oct 2023 16:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344816AbjJYOKy (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 25 Oct 2023 10:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344884AbjJYOKx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Oct 2023 10:10:53 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B28193;
        Wed, 25 Oct 2023 07:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=jujzRHkRyr+wEL+M5CNsHITMDxSDVwIofgMIOfpKOzo=; b=RouRtqdbgT1VUyFZLCwnq9twGz
        5f3XS5x4NLWzTcuzopnzsaPpcu6W3ywN5LX3wU1N2A+oblEZd77vb2YdzipXhTthiYHHWn9dNruCp
        8OXiQ+/zpGQoraat6lPZMj1fJnfM4WdFt2TKqP9UGwKRl+nku76aXjNf1oh1QXEzD5WYR8TOmuPQq
        XTRU/M5I9Lv0Dhw/958Duwa+GKVy3Z32pasiOK7PJ9z3BbzO1vKBwIhPXvSwXzb17DnuaiRORMXaG
        /Ak/oi+QQ0xWzQXRye2Az5Tqu27fU4Knqv0b2yDEsuzyEvf6lcCApVDhbUwa5Nt7SZbQ6KflbQU2a
        mbI+lmww==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qvear-00CTy1-0A;
        Wed, 25 Oct 2023 14:10:45 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>, Matthew Wilcox <willy@infradead.org>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 4/4] xfs: respect the stable writes flag on the RT device
Date:   Wed, 25 Oct 2023 16:10:20 +0200
Message-Id: <20231025141020.192413-5-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231025141020.192413-1-hch@lst.de>
References: <20231025141020.192413-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Update the per-folio stable writes flag dependening on which device an
inode resides on.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_inode.h | 8 ++++++++
 fs/xfs/xfs_ioctl.c | 8 ++++++++
 fs/xfs/xfs_iops.c  | 7 +++++++
 3 files changed, 23 insertions(+)

diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 0c5bdb91152e1c..682959c8f78cb0 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -561,6 +561,14 @@ extern void xfs_setup_inode(struct xfs_inode *ip);
 extern void xfs_setup_iops(struct xfs_inode *ip);
 extern void xfs_diflags_to_iflags(struct xfs_inode *ip, bool init);
 
+static inline void xfs_update_stable_writes(struct xfs_inode *ip)
+{
+	if (bdev_stable_writes(xfs_inode_buftarg(ip)->bt_bdev))
+		mapping_set_stable_writes(VFS_I(ip)->i_mapping);
+	else
+		mapping_clear_stable_writes(VFS_I(ip)->i_mapping);
+}
+
 /*
  * When setting up a newly allocated inode, we need to call
  * xfs_finish_inode_setup() once the inode is fully instantiated at
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index be69e7be713e5c..535f6d38cdb540 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1149,6 +1149,14 @@ xfs_ioctl_setattr_xflags(
 	ip->i_diflags2 = i_flags2;
 
 	xfs_diflags_to_iflags(ip, false);
+
+	/*
+	 * Make the stable writes flag match that of the device the inode
+	 * resides on when flipping the RT flag.
+	 */
+	if (rtflag != XFS_IS_REALTIME_INODE(ip) && S_ISREG(VFS_I(ip)->i_mode))
+		xfs_update_stable_writes(ip);
+
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	XFS_STATS_INC(mp, xs_ig_attrchg);
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 2b3b05c28e9e48..b8ec045708c318 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1298,6 +1298,13 @@ xfs_setup_inode(
 	gfp_mask = mapping_gfp_mask(inode->i_mapping);
 	mapping_set_gfp_mask(inode->i_mapping, (gfp_mask & ~(__GFP_FS)));
 
+	/*
+	 * For real-time inodes update the stable write flags to that of the RT
+	 * device instead of the data device.
+	 */
+	if (S_ISREG(inode->i_mode) && XFS_IS_REALTIME_INODE(ip))
+		xfs_update_stable_writes(ip);
+
 	/*
 	 * If there is no attribute fork no ACL can exist on this inode,
 	 * and it can't have any file capabilities attached to it either.
-- 
2.39.2

