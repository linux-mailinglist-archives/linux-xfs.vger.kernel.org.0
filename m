Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4018A7F5421
	for <lists+linux-xfs@lfdr.de>; Thu, 23 Nov 2023 00:07:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231623AbjKVXG7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 22 Nov 2023 18:06:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbjKVXG6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Nov 2023 18:06:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA821D8
        for <linux-xfs@vger.kernel.org>; Wed, 22 Nov 2023 15:06:54 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B0C2C433C7;
        Wed, 22 Nov 2023 23:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700694414;
        bh=XynHzj6h44ZdsvK8cBT1mwhwTjH+Rk63srZZ6LTyCzk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=mHYlPh4WYM9fyuEGFzXQJmMdkjBhstIAFD2DwASeufy0X4QQfBysvqpOE9tdfyidk
         FMXYB1Lcq5LGboPrnopn0G1zfNUaJm5fgWhJynQhrpS/mCImq85rfOHnuWhFQ2N3LE
         4GXVx91zKVFUh2ocxeMaPn4fPJ9+JvoaZMpVUO7roYCEeonVNuS4+sIpQH38bbTb6v
         A9hWhoqzfKE2TidmaL/3mJir5fehJr6rZTr9rsrw4x1P4Uuyj2AMCTjnMDuez5JIAc
         scDWBTVG/U9UM7cpSrxwFkgDYXQBWHb7Oq1nZPpsdaNhCqd7VGyxnC3sGeBw3h7K8L
         YhyRoUjaAFZGA==
Subject: [PATCH 1/9] libfrog: move 64-bit division wrappers to libfrog
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 22 Nov 2023 15:06:54 -0800
Message-ID: <170069441404.1865809.15599372422489523965.stgit@frogsfrogsfrogs>
In-Reply-To: <170069440815.1865809.15572181471511196657.stgit@frogsfrogsfrogs>
References: <170069440815.1865809.15572181471511196657.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

We want to keep the rtgroup unit conversion functions as static inlines,
so share the div64 functions via libfrog instead of libxfs_priv.h.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/libxfs.h     |    1 +
 libfrog/Makefile     |    1 +
 libfrog/div64.h      |   96 ++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/libxfs_priv.h |   77 +---------------------------------------
 4 files changed, 99 insertions(+), 76 deletions(-)
 create mode 100644 libfrog/div64.h


diff --git a/include/libxfs.h b/include/libxfs.h
index b28781d19d3..a6a5f66f28d 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -18,6 +18,7 @@
 #include "kmem.h"
 #include "libfrog/radix-tree.h"
 #include "libfrog/bitmask.h"
+#include "libfrog/div64.h"
 #include "atomic.h"
 #include "spinlock.h"
 
diff --git a/libfrog/Makefile b/libfrog/Makefile
index 8cde97d418f..dcfd1fb8a93 100644
--- a/libfrog/Makefile
+++ b/libfrog/Makefile
@@ -41,6 +41,7 @@ crc32cselftest.h \
 crc32defs.h \
 crc32table.h \
 dahashselftest.h \
+div64.h \
 fsgeom.h \
 logging.h \
 paths.h \
diff --git a/libfrog/div64.h b/libfrog/div64.h
new file mode 100644
index 00000000000..673b01cbab3
--- /dev/null
+++ b/libfrog/div64.h
@@ -0,0 +1,96 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2000-2005 Silicon Graphics, Inc.
+ * All Rights Reserved.
+ */
+#ifndef LIBFROG_DIV64_H_
+#define LIBFROG_DIV64_H_
+
+static inline int __do_div(unsigned long long *n, unsigned base)
+{
+	int __res;
+	__res = (int)(((unsigned long) *n) % (unsigned) base);
+	*n = ((unsigned long) *n) / (unsigned) base;
+	return __res;
+}
+
+#define do_div(n,base)	(__do_div((unsigned long long *)&(n), (base)))
+#define do_mod(a, b)		((a) % (b))
+#define rol32(x,y)		(((x) << (y)) | ((x) >> (32 - (y))))
+
+/**
+ * div_u64_rem - unsigned 64bit divide with 32bit divisor with remainder
+ * @dividend: unsigned 64bit dividend
+ * @divisor: unsigned 32bit divisor
+ * @remainder: pointer to unsigned 32bit remainder
+ *
+ * Return: sets ``*remainder``, then returns dividend / divisor
+ *
+ * This is commonly provided by 32bit archs to provide an optimized 64bit
+ * divide.
+ */
+static inline uint64_t
+div_u64_rem(uint64_t dividend, uint32_t divisor, uint32_t *remainder)
+{
+	*remainder = dividend % divisor;
+	return dividend / divisor;
+}
+
+/**
+ * div_u64 - unsigned 64bit divide with 32bit divisor
+ * @dividend: unsigned 64bit dividend
+ * @divisor: unsigned 32bit divisor
+ *
+ * This is the most common 64bit divide and should be used if possible,
+ * as many 32bit archs can optimize this variant better than a full 64bit
+ * divide.
+ */
+static inline uint64_t div_u64(uint64_t dividend, uint32_t divisor)
+{
+	uint32_t remainder;
+	return div_u64_rem(dividend, divisor, &remainder);
+}
+
+/**
+ * div64_u64_rem - unsigned 64bit divide with 64bit divisor and remainder
+ * @dividend: unsigned 64bit dividend
+ * @divisor: unsigned 64bit divisor
+ * @remainder: pointer to unsigned 64bit remainder
+ *
+ * Return: sets ``*remainder``, then returns dividend / divisor
+ */
+static inline uint64_t
+div64_u64_rem(uint64_t dividend, uint64_t divisor, uint64_t *remainder)
+{
+	*remainder = dividend % divisor;
+	return dividend / divisor;
+}
+
+static inline uint64_t rounddown_64(uint64_t x, uint32_t y)
+{
+	do_div(x, y);
+	return x * y;
+}
+
+static inline bool isaligned_64(uint64_t x, uint32_t y)
+{
+	return do_div(x, y) == 0;
+}
+
+static inline uint64_t
+roundup_64(uint64_t x, uint32_t y)
+{
+	x += y - 1;
+	do_div(x, y);
+	return x * y;
+}
+
+static inline uint64_t
+howmany_64(uint64_t x, uint32_t y)
+{
+	x += y - 1;
+	do_div(x, y);
+	return x;
+}
+
+#endif /* LIBFROG_DIV64_H_ */
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 2729241bdaa..5a7decf970e 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -48,6 +48,7 @@
 #include "kmem.h"
 #include "libfrog/radix-tree.h"
 #include "libfrog/bitmask.h"
+#include "libfrog/div64.h"
 #include "atomic.h"
 #include "spinlock.h"
 #include "linux-err.h"
@@ -215,66 +216,6 @@ static inline bool WARN_ON(bool expr) {
 	(inode)->i_version = (version);	\
 } while (0)
 
-static inline int __do_div(unsigned long long *n, unsigned base)
-{
-	int __res;
-	__res = (int)(((unsigned long) *n) % (unsigned) base);
-	*n = ((unsigned long) *n) / (unsigned) base;
-	return __res;
-}
-
-#define do_div(n,base)	(__do_div((unsigned long long *)&(n), (base)))
-#define do_mod(a, b)		((a) % (b))
-#define rol32(x,y)		(((x) << (y)) | ((x) >> (32 - (y))))
-
-/**
- * div_u64_rem - unsigned 64bit divide with 32bit divisor with remainder
- * @dividend: unsigned 64bit dividend
- * @divisor: unsigned 32bit divisor
- * @remainder: pointer to unsigned 32bit remainder
- *
- * Return: sets ``*remainder``, then returns dividend / divisor
- *
- * This is commonly provided by 32bit archs to provide an optimized 64bit
- * divide.
- */
-static inline uint64_t
-div_u64_rem(uint64_t dividend, uint32_t divisor, uint32_t *remainder)
-{
-	*remainder = dividend % divisor;
-	return dividend / divisor;
-}
-
-/**
- * div_u64 - unsigned 64bit divide with 32bit divisor
- * @dividend: unsigned 64bit dividend
- * @divisor: unsigned 32bit divisor
- *
- * This is the most common 64bit divide and should be used if possible,
- * as many 32bit archs can optimize this variant better than a full 64bit
- * divide.
- */
-static inline uint64_t div_u64(uint64_t dividend, uint32_t divisor)
-{
-	uint32_t remainder;
-	return div_u64_rem(dividend, divisor, &remainder);
-}
-
-/**
- * div64_u64_rem - unsigned 64bit divide with 64bit divisor and remainder
- * @dividend: unsigned 64bit dividend
- * @divisor: unsigned 64bit divisor
- * @remainder: pointer to unsigned 64bit remainder
- *
- * Return: sets ``*remainder``, then returns dividend / divisor
- */
-static inline uint64_t
-div64_u64_rem(uint64_t dividend, uint64_t divisor, uint64_t *remainder)
-{
-	*remainder = dividend % divisor;
-	return dividend / divisor;
-}
-
 #define min_t(type,x,y) \
 	({ type __x = (x); type __y = (y); __x < __y ? __x: __y; })
 #define max_t(type,x,y) \
@@ -380,22 +321,6 @@ roundup_pow_of_two(uint v)
 	return 0;
 }
 
-static inline uint64_t
-roundup_64(uint64_t x, uint32_t y)
-{
-	x += y - 1;
-	do_div(x, y);
-	return x * y;
-}
-
-static inline uint64_t
-howmany_64(uint64_t x, uint32_t y)
-{
-	x += y - 1;
-	do_div(x, y);
-	return x;
-}
-
 /* buffer management */
 #define XBF_TRYLOCK			0
 #define XBF_UNMAPPED			0

