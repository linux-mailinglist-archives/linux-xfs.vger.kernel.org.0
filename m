Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1DDF21EC2
	for <lists+linux-xfs@lfdr.de>; Fri, 17 May 2019 21:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbfEQTqH (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 17 May 2019 15:46:07 -0400
Received: from sandeen.net ([63.231.237.45]:39422 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726851AbfEQTqH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 17 May 2019 15:46:07 -0400
Received: from Liberator-6.local (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 153E2116F9;
        Fri, 17 May 2019 14:45:46 -0500 (CDT)
Subject: [PATCH 9/3] libxfs: create current_time helper and sync
 xfs_trans_ichgtime
To:     Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>
References: <8fc2eb9e-78c4-df39-3b8f-9109720ab680@redhat.com>
From:   Eric Sandeen <sandeen@sandeen.net>
Openpgp: preference=signencrypt
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <70781913-e46c-783e-789d-ce0e6af65549@sandeen.net>
Date:   Fri, 17 May 2019 14:46:05 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <8fc2eb9e-78c4-df39-3b8f-9109720ab680@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Make xfs_trans_ichgtime() almost match kernelspace by creating a
new current_time() helper to match the kernel utility.

This reduces still more cosmetic change.  We may want to sync the
creation flag over to the kernel even though it's not used today.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 3e7e80ea..289d1774 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -16,6 +16,16 @@ struct xfs_mount;
 struct xfs_inode_log_item;
 struct xfs_dir_ops;
 
+/*
+ * These are not actually used, they are only for userspace build
+ * compatibility in code that looks at i_state
+ */
+#define I_DIRTY_TIME		0
+#define I_DIRTY_TIME_EXPIRED	0
+
+#define IS_I_VERSION(inode)			(0)
+#define inode_maybe_inc_iversion(inode,flags)	(0)
+
 /*
  * Inode interface. This fakes up a "VFS inode" to make the xfs_inode appear
  * similar to the kernel which now is used tohold certain parts of the on-disk
@@ -25,6 +35,7 @@ struct inode {
 	mode_t		i_mode;
 	uint32_t	i_nlink;
 	xfs_dev_t	i_rdev;		/* This actually holds xfs_dev_t */
+	unsigned long	i_state;	/* Not actually used in userspace */
 	uint32_t	i_generation;
 	uint64_t	i_version;
 	struct timespec	i_atime;
@@ -149,6 +160,9 @@ extern void	xfs_trans_ichgtime(struct xfs_trans *,
 				struct xfs_inode *, int);
 extern int	xfs_iflush_int (struct xfs_inode *, struct xfs_buf *);
 
+#define timespec64 timespec
+extern struct timespec64 current_time(struct inode *inode);
+
 /* Inode Cache Interfaces */
 extern bool	xfs_inode_verify_forks(struct xfs_inode *ip);
 extern int	xfs_iget(struct xfs_mount *, struct xfs_trans *, xfs_ino_t,
diff --git a/libxfs/util.c b/libxfs/util.c
index aff91080..1734ae9a 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -136,11 +136,21 @@ xfs_log_calc_unit_res(
 	return unit_bytes;
 }
 
+struct timespec64
+current_time(struct inode *inode)
+{
+	struct timespec64	tv;
+	struct timeval		stv;
+
+	gettimeofday(&stv, (struct timezone *)0);
+	tv.tv_sec = stv.tv_sec;
+	tv.tv_nsec = stv.tv_usec * 1000;
+
+	return tv;
+}
+
 /*
  * Change the requested timestamp in the given inode.
- *
- * This was once shared with the kernel, but has diverged to the point
- * where it's no longer worth the hassle of maintaining common code.
  */
 void
 xfs_trans_ichgtime(
@@ -148,12 +158,14 @@ xfs_trans_ichgtime(
 	struct xfs_inode	*ip,
 	int			flags)
 {
-	struct timespec tv;
-	struct timeval	stv;
+	struct inode		*inode = VFS_I(ip);
+	struct timespec64	tv;
+
+	ASSERT(tp);
+	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
+
+	tv = current_time(inode);
 
-	gettimeofday(&stv, (struct timezone *)0);
-	tv.tv_sec = stv.tv_sec;
-	tv.tv_nsec = stv.tv_usec * 1000;
 	if (flags & XFS_ICHGTIME_MOD)
 		VFS_I(ip)->i_mtime = tv;
 	if (flags & XFS_ICHGTIME_CHG)

