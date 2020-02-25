Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C269916ED9D
	for <lists+linux-xfs@lfdr.de>; Tue, 25 Feb 2020 19:13:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729536AbgBYSN7 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 25 Feb 2020 13:13:59 -0500
Received: from sandeen.net ([63.231.237.45]:54448 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728367AbgBYSN7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 Feb 2020 13:13:59 -0500
Received: from Liberator.local (unknown [4.28.11.152])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id B82162B25
        for <linux-xfs@vger.kernel.org>; Tue, 25 Feb 2020 12:13:33 -0600 (CST)
Subject: [PATCH V4] libxfs: use FALLOC_FL_ZERO_RANGE in libxfs_device_zero
From:   Eric Sandeen <sandeen@sandeen.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
References: <4bc3be27-b09d-a708-f053-6f7240642667@sandeen.net>
Autocrypt: addr=sandeen@sandeen.net; prefer-encrypt=mutual; keydata=
 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 pA==
Message-ID: <1c7c39f7-91a7-be85-5906-e55180a91a5f@sandeen.net>
Date:   Tue, 25 Feb 2020 10:13:55 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <4bc3be27-b09d-a708-f053-6f7240642667@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I had a request from someone who cared about mkfs speed over
a slower network block device to look into using faster zeroing
methods, particularly for the log, during mkfs.

Using FALLOC_FL_ZERO_RANGE is faster in this case than writing
a bunch of zeros across a wire.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: Clean up all the nasty stuff I'd flung out there as a wild first
cut, thanks Dave.

V3: make len_bytes a size_t; leave "end_offset" where it is for the loop
use.  It's a bit odd but ... just don't mess with it for now, one patch
one change.

V4: Use EOPNOTSUPP not EOPNOTSUP (same on linux anyway but meh)
I ignored(tm) darrick's suggestion to make libxfs_device_zero accept
a longer length, for now - no callers need anything bigger at this time.

diff --git a/include/builddefs.in b/include/builddefs.in
index 4700b527..1dd27f76 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -144,6 +144,9 @@ endif
 ifeq ($(HAVE_GETFSMAP),yes)
 PCFLAGS+= -DHAVE_GETFSMAP
 endif
+ifeq ($(HAVE_FALLOCATE),yes)
+PCFLAGS += -DHAVE_FALLOCATE
+endif
 
 LIBICU_LIBS = @libicu_LIBS@
 LIBICU_CFLAGS = @libicu_CFLAGS@
diff --git a/include/linux.h b/include/linux.h
index 8f3c32b0..8d5c4584 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -20,6 +20,10 @@
 #include <stdio.h>
 #include <asm/types.h>
 #include <mntent.h>
+#include <fcntl.h>
+#if defined(HAVE_FALLOCATE)
+#include <linux/falloc.h>
+#endif
 #ifdef OVERRIDE_SYSTEM_FSXATTR
 # define fsxattr sys_fsxattr
 #endif
@@ -164,6 +168,24 @@ static inline void platform_mntent_close(struct mntent_cursor * cursor)
 	endmntent(cursor->mtabp);
 }
 
+#if defined(FALLOC_FL_ZERO_RANGE)
+static inline int
+platform_zero_range(
+	int		fd,
+	xfs_off_t	start,
+	size_t		len)
+{
+	int ret;
+
+	ret = fallocate(fd, FALLOC_FL_ZERO_RANGE, start, len);
+	if (!ret)
+		return 0;
+	return -errno;
+}
+#else
+#define platform_zero_range(fd, s, l)	(-EOPNOTSUPP)
+#endif
+
 /*
  * Check whether we have to define FS_IOC_FS[GS]ETXATTR ourselves. These
  * are a copy of the definitions moved to linux/uapi/fs.h in the 4.5 kernel,
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 0d9d7202..e2d9d790 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -61,8 +61,18 @@ libxfs_device_zero(struct xfs_buftarg *btp, xfs_daddr_t start, uint len)
 {
 	xfs_off_t	start_offset, end_offset, offset;
 	ssize_t		zsize, bytes;
+	size_t		len_bytes;
 	char		*z;
-	int		fd;
+	int		error, fd;
+
+	fd = libxfs_device_to_fd(btp->dev);
+	start_offset = LIBXFS_BBTOOFF64(start);
+
+	/* try to use special zeroing methods, fall back to writes if needed */
+	len_bytes = LIBXFS_BBTOOFF64(len);
+	error = platform_zero_range(fd, start_offset, len_bytes);
+	if (!error)
+		return 0;
 
 	zsize = min(BDSTRAT_SIZE, BBTOB(len));
 	if ((z = memalign(libxfs_device_alignment(), zsize)) == NULL) {
@@ -73,9 +83,6 @@ libxfs_device_zero(struct xfs_buftarg *btp, xfs_daddr_t start, uint len)
 	}
 	memset(z, 0, zsize);
 
-	fd = libxfs_device_to_fd(btp->dev);
-	start_offset = LIBXFS_BBTOOFF64(start);
-
 	if ((lseek(fd, start_offset, SEEK_SET)) < 0) {
 		fprintf(stderr, _("%s: %s seek to offset %llu failed: %s\n"),
 			progname, __FUNCTION__,


