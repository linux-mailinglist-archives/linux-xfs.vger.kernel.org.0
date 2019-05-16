Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00A3920FB1
	for <lists+linux-xfs@lfdr.de>; Thu, 16 May 2019 22:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbfEPUln (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 16 May 2019 16:41:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44152 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726449AbfEPUln (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 May 2019 16:41:43 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3DB62301E12F
        for <linux-xfs@vger.kernel.org>; Thu, 16 May 2019 20:41:43 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 10238798A9
        for <linux-xfs@vger.kernel.org>; Thu, 16 May 2019 20:41:42 +0000 (UTC)
Subject: [PATCH 8/3] xfs: factor log item initialisation
To:     linux-xfs <linux-xfs@vger.kernel.org>
References: <8fc2eb9e-78c4-df39-3b8f-9109720ab680@redhat.com>
From:   Eric Sandeen <sandeen@redhat.com>
Message-ID: <31991357-c836-6a50-4203-dae25c051def@redhat.com>
Date:   Thu, 16 May 2019 15:41:41 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <8fc2eb9e-78c4-df39-3b8f-9109720ab680@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.41]); Thu, 16 May 2019 20:41:43 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Each log item type does manual initialisation of the log item.
Delayed logging introduces new fields that need initialisation, so
factor all the open coded initialisation into a common function
first.

Source kernel commit: 43f5efc5b59db1b66e39fe9fdfc4ba6a27152afa

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 libxfs/libxfs_priv.h |  1 +
 libxfs/logitem.c     |  8 ++------
 libxfs/util.c        | 12 ++++++++++++
 3 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 157a99d6..7551ed65 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -564,6 +564,7 @@ int xfs_zero_extent(struct xfs_inode *ip, xfs_fsblock_t start_fsb,
 
 
 bool xfs_log_check_lsn(struct xfs_mount *, xfs_lsn_t);
+void xfs_log_item_init(struct xfs_mount *, struct xfs_log_item *, int);
 #define xfs_log_in_recovery(mp)	(false)
 
 /* xfs_icache.c */
diff --git a/libxfs/logitem.c b/libxfs/logitem.c
index e862ab4f..14c62f67 100644
--- a/libxfs/logitem.c
+++ b/libxfs/logitem.c
@@ -103,9 +103,7 @@ xfs_buf_item_init(
 	fprintf(stderr, "adding buf item %p for not-logged buffer %p\n",
 		bip, bp);
 #endif
-	bip->bli_item.li_type = XFS_LI_BUF;
-	bip->bli_item.li_mountp = mp;
-	INIT_LIST_HEAD(&bip->bli_item.li_trans);
+	xfs_log_item_init(mp, &bip->bli_item, XFS_LI_BUF);
 	bip->bli_buf = bp;
 	bip->__bli_format.blf_type = XFS_LI_BUF;
 	bip->__bli_format.blf_blkno = (int64_t)XFS_BUF_ADDR(bp);
@@ -149,8 +147,6 @@ xfs_inode_item_init(
 		ip->i_ino, iip);
 #endif
 
-	iip->ili_item.li_type = XFS_LI_INODE;
-	iip->ili_item.li_mountp = mp;
-	INIT_LIST_HEAD(&iip->ili_item.li_trans);
+	xfs_log_item_init(mp, &iip->ili_item, XFS_LI_INODE);
 	iip->ili_inode = ip;
 }
diff --git a/libxfs/util.c b/libxfs/util.c
index 4901123a..aff91080 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -691,6 +691,18 @@ xfs_log_check_lsn(
 	return true;
 }
 
+void
+xfs_log_item_init(
+	struct xfs_mount	*mp,
+	struct xfs_log_item	*item,
+	int			type)
+{
+	item->li_mountp = mp; 
+	item->li_type = type;
+        
+	INIT_LIST_HEAD(&item->li_trans);
+}   
+
 static struct xfs_buftarg *
 xfs_find_bdev_for_inode(
 	struct xfs_inode	*ip)
-- 
2.17.0

