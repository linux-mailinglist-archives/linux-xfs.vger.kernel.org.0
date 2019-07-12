Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0572467650
	for <lists+linux-xfs@lfdr.de>; Fri, 12 Jul 2019 23:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727776AbfGLVzC (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 12 Jul 2019 17:55:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52044 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727245AbfGLVzC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 12 Jul 2019 17:55:02 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DFEF1308620F
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jul 2019 21:46:59 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B74E91001B17
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jul 2019 21:46:59 +0000 (UTC)
Subject: [PATCH 4/4] xfsprogs: don't use enum for buffer flags
To:     linux-xfs <linux-xfs@vger.kernel.org>
References: <a40115ca-93e2-6dd2-7940-5911988f8fe4@redhat.com>
From:   Eric Sandeen <sandeen@redhat.com>
Message-ID: <9a4275dd-3e33-1fbb-efd4-57db6f646bff@redhat.com>
Date:   Fri, 12 Jul 2019 16:46:59 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <a40115ca-93e2-6dd2-7940-5911988f8fe4@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Fri, 12 Jul 2019 21:46:59 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This roughly mirrors

  807cbbdb xfs: do not use emums for flags used in tracing

and lets us use the xfs_buf_flags_t type in function calls as is
done in the kernel.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/include/xfs_trans.h b/include/xfs_trans.h
index 60e1dbdb..926fe102 100644
--- a/include/xfs_trans.h
+++ b/include/xfs_trans.h
@@ -107,12 +107,12 @@ bool	libxfs_trans_ordered_buf(xfs_trans_t *, struct xfs_buf *);
 struct xfs_buf	*libxfs_trans_get_buf_map(struct xfs_trans *tp,
 					struct xfs_buftarg *btp,
 					struct xfs_buf_map *map, int nmaps,
-					uint flags);
+					xfs_buf_flags_t flags);
 
 int	libxfs_trans_read_buf_map(struct xfs_mount *mp, struct xfs_trans *tp,
 				  struct xfs_buftarg *btp,
 				  struct xfs_buf_map *map, int nmaps,
-				  uint flags, struct xfs_buf **bpp,
+				  xfs_buf_flags_t flags, struct xfs_buf **bpp,
 				  const struct xfs_buf_ops *ops);
 static inline struct xfs_buf *
 libxfs_trans_get_buf(
@@ -133,7 +133,7 @@ libxfs_trans_read_buf(
 	struct xfs_buftarg	*btp,
 	xfs_daddr_t		blkno,
 	int			numblks,
-	uint			flags,
+	xfs_buf_flags_t		flags,
 	struct xfs_buf		**bpp,
 	const struct xfs_buf_ops *ops)
 {
diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index 79ffd470..e09dd849 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -81,14 +81,15 @@ typedef struct xfs_buf {
 bool xfs_verify_magic(struct xfs_buf *bp, __be32 dmagic);
 bool xfs_verify_magic16(struct xfs_buf *bp, __be16 dmagic);
 
-enum xfs_buf_flags_t {	/* b_flags bits */
-	LIBXFS_B_EXIT		= 0x0001,	/* ==LIBXFS_EXIT_ON_FAILURE */
-	LIBXFS_B_DIRTY		= 0x0002,	/* buffer has been modified */
-	LIBXFS_B_STALE		= 0x0004,	/* buffer marked as invalid */
-	LIBXFS_B_UPTODATE	= 0x0008,	/* buffer is sync'd to disk */
-	LIBXFS_B_DISCONTIG	= 0x0010,	/* discontiguous buffer */
-	LIBXFS_B_UNCHECKED	= 0x0020,	/* needs verification */
-};
+/* b_flags bits */
+#define LIBXFS_B_EXIT		0x0001	/* ==LIBXFS_EXIT_ON_FAILURE */
+#define LIBXFS_B_DIRTY		0x0002	/* buffer has been modified */
+#define LIBXFS_B_STALE		0x0004	/* buffer marked as invalid */
+#define LIBXFS_B_UPTODATE	0x0008	/* buffer is sync'd to disk */
+#define LIBXFS_B_DISCONTIG	0x0010	/* discontiguous buffer */
+#define LIBXFS_B_UNCHECKED	0x0020	/* needs verification */
+
+typedef unsigned int xfs_buf_flags_t;
 
 #define XFS_BUF_DADDR_NULL		((xfs_daddr_t) (-1LL))
 
diff --git a/libxfs/trans.c b/libxfs/trans.c
index 453e5476..faf36daa 100644
--- a/libxfs/trans.c
+++ b/libxfs/trans.c
@@ -404,7 +404,7 @@ libxfs_trans_get_buf_map(
 	struct xfs_buftarg	*target,
 	struct xfs_buf_map	*map,
 	int			nmaps,
-	uint			flags)
+	xfs_buf_flags_t		flags)
 {
 	xfs_buf_t		*bp;
 	struct xfs_buf_log_item	*bip;
@@ -480,7 +480,7 @@ libxfs_trans_read_buf_map(
 	struct xfs_buftarg	*target,
 	struct xfs_buf_map	*map,
 	int			nmaps,
-	uint			flags,
+	xfs_buf_flags_t		flags,
 	struct xfs_buf		**bpp,
 	const struct xfs_buf_ops *ops)
 {


