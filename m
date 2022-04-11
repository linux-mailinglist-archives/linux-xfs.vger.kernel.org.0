Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 218E94FB10B
	for <lists+linux-xfs@lfdr.de>; Mon, 11 Apr 2022 02:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234982AbiDKAeG (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 10 Apr 2022 20:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231398AbiDKAeE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 Apr 2022 20:34:04 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9819811A03
        for <linux-xfs@vger.kernel.org>; Sun, 10 Apr 2022 17:31:51 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-233-190.pa.vic.optusnet.com.au [49.186.233.190])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id C8E0010CE855
        for <linux-xfs@vger.kernel.org>; Mon, 11 Apr 2022 10:31:49 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ndhy9-00GEMa-95
        for linux-xfs@vger.kernel.org; Mon, 11 Apr 2022 10:31:49 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1ndhy9-008pj8-8C
        for linux-xfs@vger.kernel.org;
        Mon, 11 Apr 2022 10:31:49 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 06/17] xfs: convert AGF log flags to unsigned.
Date:   Mon, 11 Apr 2022 10:31:36 +1000
Message-Id: <20220411003147.2104423-7-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220411003147.2104423-1-david@fromorbit.com>
References: <20220411003147.2104423-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=625376f5
        a=bHAvQTfMiaNt/bo4vVGwyA==:117 a=bHAvQTfMiaNt/bo4vVGwyA==:17
        a=z0gMJWrwH1QA:10 a=20KFwNOVAAAA:8 a=-XfM-_w09cZF3wrI41kA:9
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
 fs/xfs/libxfs/xfs_alloc.c  | 10 +++++-----
 fs/xfs/libxfs/xfs_alloc.h  |  2 +-
 fs/xfs/libxfs/xfs_format.h | 38 +++++++++++++++++++-------------------
 3 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index b52ed339727f..1ff3fa67d4c9 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2777,7 +2777,7 @@ xfs_alloc_get_freelist(
 	xfs_agblock_t		bno;
 	__be32			*agfl_bno;
 	int			error;
-	int			logflags;
+	uint32_t		logflags;
 	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_perag	*pag;
 
@@ -2830,9 +2830,9 @@ xfs_alloc_get_freelist(
  */
 void
 xfs_alloc_log_agf(
-	xfs_trans_t	*tp,	/* transaction pointer */
-	struct xfs_buf	*bp,	/* buffer for a.g. freelist header */
-	int		fields)	/* mask of fields to be logged (XFS_AGF_...) */
+	struct xfs_trans	*tp,
+	struct xfs_buf		*bp,
+	uint32_t		fields)
 {
 	int	first;		/* first byte offset */
 	int	last;		/* last byte offset */
@@ -2902,7 +2902,7 @@ xfs_alloc_put_freelist(
 	struct xfs_perag	*pag;
 	__be32			*blockp;
 	int			error;
-	int			logflags;
+	uint32_t		logflags;
 	__be32			*agfl_bno;
 	int			startoff;
 
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index d4c057b764f9..84ca09b2223f 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -121,7 +121,7 @@ void
 xfs_alloc_log_agf(
 	struct xfs_trans *tp,	/* transaction pointer */
 	struct xfs_buf	*bp,	/* buffer for a.g. freelist header */
-	int		fields);/* mask of fields to be logged (XFS_AGF_...) */
+	uint32_t	fields);/* mask of fields to be logged (XFS_AGF_...) */
 
 /*
  * Interface for inode allocation to force the pag data to be initialized.
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index d665c04e69dd..65e24847841e 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -525,26 +525,26 @@ typedef struct xfs_agf {
 
 #define XFS_AGF_CRC_OFF		offsetof(struct xfs_agf, agf_crc)
 
-#define	XFS_AGF_MAGICNUM	0x00000001
-#define	XFS_AGF_VERSIONNUM	0x00000002
-#define	XFS_AGF_SEQNO		0x00000004
-#define	XFS_AGF_LENGTH		0x00000008
-#define	XFS_AGF_ROOTS		0x00000010
-#define	XFS_AGF_LEVELS		0x00000020
-#define	XFS_AGF_FLFIRST		0x00000040
-#define	XFS_AGF_FLLAST		0x00000080
-#define	XFS_AGF_FLCOUNT		0x00000100
-#define	XFS_AGF_FREEBLKS	0x00000200
-#define	XFS_AGF_LONGEST		0x00000400
-#define	XFS_AGF_BTREEBLKS	0x00000800
-#define	XFS_AGF_UUID		0x00001000
-#define	XFS_AGF_RMAP_BLOCKS	0x00002000
-#define	XFS_AGF_REFCOUNT_BLOCKS	0x00004000
-#define	XFS_AGF_REFCOUNT_ROOT	0x00008000
-#define	XFS_AGF_REFCOUNT_LEVEL	0x00010000
-#define	XFS_AGF_SPARE64		0x00020000
+#define	XFS_AGF_MAGICNUM	(1u << 0)
+#define	XFS_AGF_VERSIONNUM	(1u << 1)
+#define	XFS_AGF_SEQNO		(1u << 2)
+#define	XFS_AGF_LENGTH		(1u << 3)
+#define	XFS_AGF_ROOTS		(1u << 4)
+#define	XFS_AGF_LEVELS		(1u << 5)
+#define	XFS_AGF_FLFIRST		(1u << 6)
+#define	XFS_AGF_FLLAST		(1u << 7)
+#define	XFS_AGF_FLCOUNT		(1u << 8)
+#define	XFS_AGF_FREEBLKS	(1u << 9)
+#define	XFS_AGF_LONGEST		(1u << 10)
+#define	XFS_AGF_BTREEBLKS	(1u << 11)
+#define	XFS_AGF_UUID		(1u << 12)
+#define	XFS_AGF_RMAP_BLOCKS	(1u << 13)
+#define	XFS_AGF_REFCOUNT_BLOCKS	(1u << 14)
+#define	XFS_AGF_REFCOUNT_ROOT	(1u << 15)
+#define	XFS_AGF_REFCOUNT_LEVEL	(1u << 16)
+#define	XFS_AGF_SPARE64		(1u << 17)
 #define	XFS_AGF_NUM_BITS	18
-#define	XFS_AGF_ALL_BITS	((1 << XFS_AGF_NUM_BITS) - 1)
+#define	XFS_AGF_ALL_BITS	((1u << XFS_AGF_NUM_BITS) - 1)
 
 #define XFS_AGF_FLAGS \
 	{ XFS_AGF_MAGICNUM,	"MAGICNUM" }, \
-- 
2.35.1

