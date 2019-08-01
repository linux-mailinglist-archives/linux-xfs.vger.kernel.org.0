Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3975C7D904
	for <lists+linux-xfs@lfdr.de>; Thu,  1 Aug 2019 12:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbfHAKHv (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 1 Aug 2019 06:07:51 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:51831 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725379AbfHAKHv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Aug 2019 06:07:51 -0400
Received: from fsav109.sakura.ne.jp (fsav109.sakura.ne.jp [27.133.134.236])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id x71A7YOF018015;
        Thu, 1 Aug 2019 19:07:34 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav109.sakura.ne.jp (F-Secure/fsigk_smtp/530/fsav109.sakura.ne.jp);
 Thu, 01 Aug 2019 19:07:34 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/530/fsav109.sakura.ne.jp)
Received: from ccsecurity.localdomain (softbank126012062002.bbtec.net [126.12.62.2])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id x71A7T6U018004
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Thu, 1 Aug 2019 19:07:34 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
To:     linux-xfs@vger.kernel.org
Cc:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH] fs: xfs: Remove unused KM_NOSLEEP, change KM_SLEEP to 0.
Date:   Thu,  1 Aug 2019 19:07:22 +0900
Message-Id: <1564654042-9088-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Since no caller is using KM_NOSLEEP and no callee branches on KM_SLEEP,
but removing KM_SLEEP requires modification of 97 locations, let's remove
KM_NOSLEEP branch and (for now) change KM_SLEEP to 0.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 fs/xfs/kmem.c |  6 +++---
 fs/xfs/kmem.h | 15 +++++----------
 2 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
index 16bb9a328678..7cd315ad937e 100644
--- a/fs/xfs/kmem.c
+++ b/fs/xfs/kmem.c
@@ -17,7 +17,7 @@ kmem_alloc(size_t size, xfs_km_flags_t flags)
 
 	do {
 		ptr = kmalloc(size, lflags);
-		if (ptr || (flags & (KM_MAYFAIL|KM_NOSLEEP)))
+		if (ptr || (flags & KM_MAYFAIL))
 			return ptr;
 		if (!(++retries % 100))
 			xfs_err(NULL,
@@ -67,7 +67,7 @@ kmem_realloc(const void *old, size_t newsize, xfs_km_flags_t flags)
 
 	do {
 		ptr = krealloc(old, newsize, lflags);
-		if (ptr || (flags & (KM_MAYFAIL|KM_NOSLEEP)))
+		if (ptr || (flags & KM_MAYFAIL))
 			return ptr;
 		if (!(++retries % 100))
 			xfs_err(NULL,
@@ -87,7 +87,7 @@ kmem_zone_alloc(kmem_zone_t *zone, xfs_km_flags_t flags)
 
 	do {
 		ptr = kmem_cache_alloc(zone, lflags);
-		if (ptr || (flags & (KM_MAYFAIL|KM_NOSLEEP)))
+		if (ptr || (flags & KM_MAYFAIL))
 			return ptr;
 		if (!(++retries % 100))
 			xfs_err(NULL,
diff --git a/fs/xfs/kmem.h b/fs/xfs/kmem.h
index 267655acd426..f74a7d6d40dc 100644
--- a/fs/xfs/kmem.h
+++ b/fs/xfs/kmem.h
@@ -16,8 +16,7 @@
  */
 
 typedef unsigned __bitwise xfs_km_flags_t;
-#define KM_SLEEP	((__force xfs_km_flags_t)0x0001u)
-#define KM_NOSLEEP	((__force xfs_km_flags_t)0x0002u)
+#define KM_SLEEP	((__force xfs_km_flags_t)0x0000u)
 #define KM_NOFS		((__force xfs_km_flags_t)0x0004u)
 #define KM_MAYFAIL	((__force xfs_km_flags_t)0x0008u)
 #define KM_ZERO		((__force xfs_km_flags_t)0x0010u)
@@ -32,15 +31,11 @@ kmem_flags_convert(xfs_km_flags_t flags)
 {
 	gfp_t	lflags;
 
-	BUG_ON(flags & ~(KM_SLEEP|KM_NOSLEEP|KM_NOFS|KM_MAYFAIL|KM_ZERO));
+	BUG_ON(flags & ~(KM_SLEEP|KM_NOFS|KM_MAYFAIL|KM_ZERO));
 
-	if (flags & KM_NOSLEEP) {
-		lflags = GFP_ATOMIC | __GFP_NOWARN;
-	} else {
-		lflags = GFP_KERNEL | __GFP_NOWARN;
-		if (flags & KM_NOFS)
-			lflags &= ~__GFP_FS;
-	}
+	lflags = GFP_KERNEL | __GFP_NOWARN;
+	if (flags & KM_NOFS)
+		lflags &= ~__GFP_FS;
 
 	/*
 	 * Default page/slab allocator behavior is to retry for ever
-- 
2.16.5

