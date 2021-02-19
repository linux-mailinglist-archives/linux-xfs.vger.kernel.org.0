Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADDF31F42B
	for <lists+linux-xfs@lfdr.de>; Fri, 19 Feb 2021 04:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbhBSDSq (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 18 Feb 2021 22:18:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:53300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229480AbhBSDSq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Feb 2021 22:18:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0481F64ED5;
        Fri, 19 Feb 2021 03:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613704685;
        bh=c9AQbZHIZu+64uIAgJxyYjMNzlQhNZm+9gXS7NSHtl4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Q4ZKER5dSJc9cQc9bOjBQt0IOLFZW7vsB2XVjmwTIQUY+0hUco7W5RdQO3+4hBKr+
         xYz4yNx308Jehe+yzv87F8r0XPUK+cVjl8G3hmWOiB5I+tDtss6JO83mc31FiOCOSY
         IJo216iCp0am5E84igm02XDHOvSt4zifIV5HqQWwddECKMF3H+VjGr4EIwVWw3W6U4
         XM0jo0Qb8PV10MkOHXmlJ/jH0z3YbZBr9//Kpj+k0H7tQ7xjbKQqzJ8iU28uEvicnJ
         d3EX1CJ5v3+TxWxsCFaKh+ph5ydgdP4lXoHcdI206mSLtkPSz1RwuUxno6vL4HG42N
         Zi/5KFwxmJNtw==
Subject: [PATCH 2/4] libxfs: simulate system failure after a certain number of
 writes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Thu, 18 Feb 2021 19:18:04 -0800
Message-ID: <161370468470.2389661.11874247132336274370.stgit@magnolia>
In-Reply-To: <161370467351.2389661.12577563230109429304.stgit@magnolia>
References: <161370467351.2389661.12577563230109429304.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add an error injection knob so that we can simulate system failure after
a certain number of disk writes.  This knob is being added so that we
can check repair's behavior after an arbitrary number of tests.

Set LIBXFS_DEBUG_WRITE_CRASH={ddev,logdev,rtdev}=nn in the environment
to make libxfs SIGKILL itself after nn writes to the data, log, or rt
devices.  Note that this only applies to xfs_buf writes and zero_range.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/linux.h    |   13 ++++++++++
 libxfs/init.c      |   68 +++++++++++++++++++++++++++++++++++++++++++++++++---
 libxfs/libxfs_io.h |   19 +++++++++++++++
 libxfs/rdwr.c      |    6 ++++-
 4 files changed, 101 insertions(+), 5 deletions(-)


diff --git a/include/linux.h b/include/linux.h
index 03b3278b..7bf59e07 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -31,6 +31,8 @@
 #ifdef OVERRIDE_SYSTEM_FSXATTR
 # undef fsxattr
 #endif
+#include <unistd.h>
+#include <assert.h>
 
 static __inline__ int xfsctl(const char *path, int fd, int cmd, void *p)
 {
@@ -186,6 +188,17 @@ platform_zero_range(
 #define platform_zero_range(fd, s, l)	(-EOPNOTSUPP)
 #endif
 
+/*
+ * Use SIGKILL to simulate an immediate program crash, without a chance to run
+ * atexit handlers.
+ */
+static inline void
+platform_crash(void)
+{
+	kill(getpid(), SIGKILL);
+	assert(0);
+}
+
 /*
  * Check whether we have to define FS_IOC_FS[GS]ETXATTR ourselves. These
  * are a copy of the definitions moved to linux/uapi/fs.h in the 4.5 kernel,
diff --git a/libxfs/init.c b/libxfs/init.c
index 8a8ce3c4..1ec83791 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -590,7 +590,8 @@ libxfs_initialize_perag(
 static struct xfs_buftarg *
 libxfs_buftarg_alloc(
 	struct xfs_mount	*mp,
-	dev_t			dev)
+	dev_t			dev,
+	unsigned long		write_fails)
 {
 	struct xfs_buftarg	*btp;
 
@@ -603,10 +604,29 @@ libxfs_buftarg_alloc(
 	btp->bt_mount = mp;
 	btp->bt_bdev = dev;
 	btp->flags = 0;
+	if (write_fails) {
+		btp->writes_left = write_fails;
+		btp->flags |= XFS_BUFTARG_INJECT_WRITE_FAIL;
+	}
+	pthread_mutex_init(&btp->lock, NULL);
 
 	return btp;
 }
 
+enum libxfs_write_failure_nums {
+	WF_DATA = 0,
+	WF_LOG,
+	WF_RT,
+	WF_MAX_OPTS,
+};
+
+static char *wf_opts[] = {
+	[WF_DATA]		= "ddev",
+	[WF_LOG]		= "logdev",
+	[WF_RT]			= "rtdev",
+	[WF_MAX_OPTS]		= NULL,
+};
+
 void
 libxfs_buftarg_init(
 	struct xfs_mount	*mp,
@@ -614,6 +634,46 @@ libxfs_buftarg_init(
 	dev_t			logdev,
 	dev_t			rtdev)
 {
+	char			*p = getenv("LIBXFS_DEBUG_WRITE_CRASH");
+	unsigned long		dfail = 0, lfail = 0, rfail = 0;
+
+	/* Simulate utility crash after a certain number of writes. */
+	while (p && *p) {
+		char *val;
+
+		switch (getsubopt(&p, wf_opts, &val)) {
+		case WF_DATA:
+			if (!val) {
+				fprintf(stderr,
+		_("ddev write fail requires a parameter\n"));
+				exit(1);
+			}
+			dfail = strtoul(val, NULL, 0);
+			break;
+		case WF_LOG:
+			if (!val) {
+				fprintf(stderr,
+		_("logdev write fail requires a parameter\n"));
+				exit(1);
+			}
+			lfail = strtoul(val, NULL, 0);
+			break;
+		case WF_RT:
+			if (!val) {
+				fprintf(stderr,
+		_("rtdev write fail requires a parameter\n"));
+				exit(1);
+			}
+			rfail = strtoul(val, NULL, 0);
+			break;
+		default:
+			fprintf(stderr, _("unknown write fail type %s\n"),
+					val);
+			exit(1);
+			break;
+		}
+	}
+
 	if (mp->m_ddev_targp) {
 		/* should already have all buftargs initialised */
 		if (mp->m_ddev_targp->bt_bdev != dev ||
@@ -647,12 +707,12 @@ libxfs_buftarg_init(
 		return;
 	}
 
-	mp->m_ddev_targp = libxfs_buftarg_alloc(mp, dev);
+	mp->m_ddev_targp = libxfs_buftarg_alloc(mp, dev, dfail);
 	if (!logdev || logdev == dev)
 		mp->m_logdev_targp = mp->m_ddev_targp;
 	else
-		mp->m_logdev_targp = libxfs_buftarg_alloc(mp, logdev);
-	mp->m_rtdev_targp = libxfs_buftarg_alloc(mp, rtdev);
+		mp->m_logdev_targp = libxfs_buftarg_alloc(mp, logdev, lfail);
+	mp->m_rtdev_targp = libxfs_buftarg_alloc(mp, rtdev, rfail);
 }
 
 /*
diff --git a/libxfs/libxfs_io.h b/libxfs/libxfs_io.h
index c80e2d59..3cc4f4ee 100644
--- a/libxfs/libxfs_io.h
+++ b/libxfs/libxfs_io.h
@@ -22,6 +22,8 @@ struct xfs_perag;
  */
 struct xfs_buftarg {
 	struct xfs_mount	*bt_mount;
+	pthread_mutex_t		lock;
+	unsigned long		writes_left;
 	dev_t			bt_bdev;
 	unsigned int		flags;
 };
@@ -30,6 +32,23 @@ struct xfs_buftarg {
 #define XFS_BUFTARG_LOST_WRITE		(1 << 0)
 /* A dirty buffer failed the write verifier. */
 #define XFS_BUFTARG_CORRUPT_WRITE	(1 << 1)
+/* Simulate failure after a certain number of writes. */
+#define XFS_BUFTARG_INJECT_WRITE_FAIL	(1 << 2)
+
+/* Simulate the system crashing after a certain number of writes. */
+static inline void
+xfs_buftarg_trip_write(
+	struct xfs_buftarg	*btp)
+{
+	if (!(btp->flags & XFS_BUFTARG_INJECT_WRITE_FAIL))
+		return;
+
+	pthread_mutex_lock(&btp->lock);
+	btp->writes_left--;
+	if (!btp->writes_left)
+		platform_crash();
+	pthread_mutex_unlock(&btp->lock);
+}
 
 extern void	libxfs_buftarg_init(struct xfs_mount *mp, dev_t ddev,
 				    dev_t logdev, dev_t rtdev);
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index ca272387..fd456d6b 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -74,8 +74,10 @@ libxfs_device_zero(struct xfs_buftarg *btp, xfs_daddr_t start, uint len)
 	/* try to use special zeroing methods, fall back to writes if needed */
 	len_bytes = LIBXFS_BBTOOFF64(len);
 	error = platform_zero_range(fd, start_offset, len_bytes);
-	if (!error)
+	if (!error) {
+		xfs_buftarg_trip_write(btp);
 		return 0;
+	}
 
 	zsize = min(BDSTRAT_SIZE, BBTOB(len));
 	if ((z = memalign(libxfs_device_alignment(), zsize)) == NULL) {
@@ -105,6 +107,7 @@ libxfs_device_zero(struct xfs_buftarg *btp, xfs_daddr_t start, uint len)
 				progname, __FUNCTION__);
 			exit(1);
 		}
+		xfs_buftarg_trip_write(btp);
 		offset += bytes;
 	}
 	free(z);
@@ -860,6 +863,7 @@ libxfs_bwrite(
 	} else {
 		bp->b_flags |= LIBXFS_B_UPTODATE;
 		bp->b_flags &= ~(LIBXFS_B_DIRTY | LIBXFS_B_UNCHECKED);
+		xfs_buftarg_trip_write(bp->b_target);
 	}
 	return bp->b_error;
 }

