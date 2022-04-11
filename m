Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5EE24FB118
	for <lists+linux-xfs@lfdr.de>; Mon, 11 Apr 2022 02:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232656AbiDKAeM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 10 Apr 2022 20:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242659AbiDKAeI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Apr 2022 20:34:08 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1081D11A03
        for <linux-xfs@vger.kernel.org>; Sun, 10 Apr 2022 17:31:56 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-233-190.pa.vic.optusnet.com.au [49.186.233.190])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id DE72510CE8AD
        for <linux-xfs@vger.kernel.org>; Mon, 11 Apr 2022 10:31:50 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ndhy9-00GEMo-Bq
        for linux-xfs@vger.kernel.org; Mon, 11 Apr 2022 10:31:49 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1ndhy9-008pjN-Aq
        for linux-xfs@vger.kernel.org;
        Mon, 11 Apr 2022 10:31:49 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 09/17] xfs: convert buffer log item flags to unsigned.
Date:   Mon, 11 Apr 2022 10:31:39 +1000
Message-Id: <20220411003147.2104423-10-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220411003147.2104423-1-david@fromorbit.com>
References: <20220411003147.2104423-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=deDjYVbe c=1 sm=1 tr=0 ts=625376f6
        a=bHAvQTfMiaNt/bo4vVGwyA==:117 a=bHAvQTfMiaNt/bo4vVGwyA==:17
        a=z0gMJWrwH1QA:10 a=20KFwNOVAAAA:8 a=a4IuYPeEK0sUFmN56-AA:9
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

5.18 w/ std=gnu11 compiled with gcc-5 wants flags stored in unsigned
fields to be unsigned.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_buf_item.h | 24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.h b/fs/xfs/xfs_buf_item.h
index e11e9ef2338f..4d8a6aece995 100644
--- a/fs/xfs/xfs_buf_item.h
+++ b/fs/xfs/xfs_buf_item.h
@@ -8,15 +8,18 @@
 
 /* kernel only definitions */
 
+struct xfs_buf;
+struct xfs_mount;
+
 /* buf log item flags */
-#define	XFS_BLI_HOLD		0x01
-#define	XFS_BLI_DIRTY		0x02
-#define	XFS_BLI_STALE		0x04
-#define	XFS_BLI_LOGGED		0x08
-#define	XFS_BLI_INODE_ALLOC_BUF	0x10
-#define XFS_BLI_STALE_INODE	0x20
-#define	XFS_BLI_INODE_BUF	0x40
-#define	XFS_BLI_ORDERED		0x80
+#define	XFS_BLI_HOLD		(1u << 0)
+#define	XFS_BLI_DIRTY		(1u << 1)
+#define	XFS_BLI_STALE		(1u << 2)
+#define	XFS_BLI_LOGGED		(1u << 3)
+#define	XFS_BLI_INODE_ALLOC_BUF	(1u << 4)
+#define XFS_BLI_STALE_INODE	(1u << 5)
+#define	XFS_BLI_INODE_BUF	(1u << 6)
+#define	XFS_BLI_ORDERED		(1u << 7)
 
 #define XFS_BLI_FLAGS \
 	{ XFS_BLI_HOLD,		"HOLD" }, \
@@ -28,11 +31,6 @@
 	{ XFS_BLI_INODE_BUF,	"INODE_BUF" }, \
 	{ XFS_BLI_ORDERED,	"ORDERED" }
 
-
-struct xfs_buf;
-struct xfs_mount;
-struct xfs_buf_log_item;
-
 /*
  * This is the in core log item structure used to track information
  * needed to log buffers.  It tracks how many times the lock has been
-- 
2.35.1

