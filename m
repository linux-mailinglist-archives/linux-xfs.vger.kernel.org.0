Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C411840D15B
	for <lists+linux-xfs@lfdr.de>; Thu, 16 Sep 2021 03:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232171AbhIPBsO (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 15 Sep 2021 21:48:14 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:33181 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233367AbhIPBsO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Sep 2021 21:48:14 -0400
Received: from dread.disaster.area (pa49-195-238-16.pa.nsw.optusnet.com.au [49.195.238.16])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 8957088A1C
        for <linux-xfs@vger.kernel.org>; Thu, 16 Sep 2021 11:46:53 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mQgUH-00CySp-2X
        for linux-xfs@vger.kernel.org; Thu, 16 Sep 2021 11:46:53 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95-RC2)
        (envelope-from <david@fromorbit.com>)
        id 1mQgUH-007hX6-1Q
        for linux-xfs@vger.kernel.org;
        Thu, 16 Sep 2021 11:46:53 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 5/5] libxfs: add wrappers for kernel semaphores
Date:   Thu, 16 Sep 2021 11:46:49 +1000
Message-Id: <20210916014649.1835564-6-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916014649.1835564-1-david@fromorbit.com>
References: <20210916013707.GQ2361455@dread.disaster.area>
 <20210916014649.1835564-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=DzKKRZjfViQTE5W6EVc0VA==:117 a=DzKKRZjfViQTE5W6EVc0VA==:17
        a=7QKq2e-ADPsA:10 a=20KFwNOVAAAA:8 a=y2uvV0bdPpqU0iTU31UA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Implemented via pthread mutexes.

On Linux, fast pthread mutexes don't actaully check which thread
owns the lock on unlock, so can be used in situations where the
unlock occurs in a different thread to the lock. This is
non-portable behaviour, so if other platforms are supported, this
may need to be converted to posix semaphores.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 include/Makefile     |  1 +
 include/libxfs.h     |  1 +
 include/sema.h       | 35 +++++++++++++++++++++++++++++++++++
 libxfs/libxfs_priv.h |  1 +
 4 files changed, 38 insertions(+)
 create mode 100644 include/sema.h

diff --git a/include/Makefile b/include/Makefile
index 98031e70fa0d..ce89d0237c19 100644
--- a/include/Makefile
+++ b/include/Makefile
@@ -17,6 +17,7 @@ LIBHFILES = libxfs.h \
 	kmem.h \
 	list.h \
 	parent.h \
+	sema.h \
 	spinlock.h \
 	xfs_inode.h \
 	xfs_log_recover.h \
diff --git a/include/libxfs.h b/include/libxfs.h
index 61475347b09d..ca5a21b03b8a 100644
--- a/include/libxfs.h
+++ b/include/libxfs.h
@@ -20,6 +20,7 @@
 #include "atomic.h"
 #include "spinlock.h"
 #include "completion.h"
+#include "sema.h"
 
 #include "xfs_types.h"
 #include "xfs_fs.h"
diff --git a/include/sema.h b/include/sema.h
new file mode 100644
index 000000000000..bcccb156b0ea
--- /dev/null
+++ b/include/sema.h
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2019-20 RedHat, Inc.
+ * All Rights Reserved.
+ */
+#ifndef __LIBXFS_SEMA_H__
+#define __LIBXFS_SEMA_H__
+
+/*
+ * This implements kernel compatible semaphore _exclusion_ semantics. It does
+ * not implement counting semaphore behaviour.
+ *
+ * This makes use of the fact that fast pthread mutexes on Linux don't check
+ * that the unlocker is the same thread that locked the mutex, and hence can be
+ * unlocked in a different thread safely.
+ *
+ * If this needs to be portable or we require counting semaphore behaviour in
+ * libxfs code, this requires re-implementation based on posix semaphores.
+ */
+struct semaphore {
+	pthread_mutex_t		lock;
+};
+
+#define sema_init(l, nolock)		\
+do {					\
+	pthread_mutex_init(&(l)->lock, NULL);	\
+	if (!nolock)			\
+		pthread_mutex_lock(&(l)->lock);	\
+} while (0)
+
+#define down(l)			pthread_mutex_lock(&(l)->lock)
+#define down_trylock(l)		pthread_mutex_trylock(&(l)->lock)
+#define up(l)			pthread_mutex_unlock(&(l)->lock)
+
+#endif /* __LIBXFS_SEMA_H__ */
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 9f28fd908d43..1fc243cf6c5e 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -50,6 +50,7 @@
 #include "atomic.h"
 #include "spinlock.h"
 #include "completion.h"
+#include "sema.h"
 
 #include "xfs_types.h"
 #include "xfs_arch.h"
-- 
2.33.0

