Return-Path: <linux-xfs+bounces-615-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B78780D223
	for <lists+linux-xfs@lfdr.de>; Mon, 11 Dec 2023 17:38:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C92B72818C8
	for <lists+linux-xfs@lfdr.de>; Mon, 11 Dec 2023 16:38:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A6AF48CEB;
	Mon, 11 Dec 2023 16:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Nwn4kOml"
X-Original-To: linux-xfs@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3475AC2
	for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2023 08:38:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=GQiM/lFhLocC+Xk976WUL6PtsBmA5w0/0C9cIn/eR+E=; b=Nwn4kOmldXuH5FfyBin4bQshH3
	ddO3D6424ZV7Va/+5ixddenBu/7gyHEzXw96Tg5Kccp+jOJiIG/Xq3DXSWZT8dt6eJzBBChHguSos
	gJOWldkmp2KRYUNwr4xpnPWbbXyEyZw1RhEoEBor6wzIDfc2pteGnKsGNdO7wIOcocgihzZEw2n/F
	VaYE87NhZCaz01PMw/0T52jH0HC7+smXkDtHSURecTu7UHfezVV5iv+meiokncnT6sxqHtEd8rQUG
	ptBg7PG9nARAuY5a7ClEwha/1hvZ4pOJR9APLce7trn7IpNPc/qaGfdA2ufByp4fazE4kh+fiQvPN
	r+9qk6Pw==;
Received: from [2001:4bb8:19a:a621:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rCjIe-005tHk-1y;
	Mon, 11 Dec 2023 16:38:33 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 16/23] libfrog: make platform_set_blocksize exit on fatal failure
Date: Mon, 11 Dec 2023 17:37:35 +0100
Message-Id: <20231211163742.837427-17-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231211163742.837427-1-hch@lst.de>
References: <20231211163742.837427-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

platform_set_blocksize has a fatal argument that is currently only
used to change the printed message.  Make it actually fatal similar to
other libfrog platform helpers to simplify the caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libfrog/linux.c    | 27 +++++++++++++++------------
 libfrog/platform.h |  4 ++--
 libxfs/init.c      | 15 ++++++---------
 3 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/libfrog/linux.c b/libfrog/linux.c
index 2e4fd316e..46a5ff39e 100644
--- a/libfrog/linux.c
+++ b/libfrog/linux.c
@@ -127,20 +127,23 @@ platform_check_iswritable(char *name, char *block, struct stat *s)
 	return platform_check_mount(name, block, s, flags);
 }
 
-int
-platform_set_blocksize(int fd, char *path, dev_t device, int blocksize, int fatal)
+void
+platform_set_blocksize(int fd, char *path, dev_t device, int blocksize,
+		bool fatal)
 {
-	int error = 0;
-
-	if (major(device) != RAMDISK_MAJOR) {
-		if ((error = ioctl(fd, BLKBSZSET, &blocksize)) < 0) {
-			fprintf(stderr, _("%s: %s - cannot set blocksize "
-					"%d on block device %s: %s\n"),
-				progname, fatal ? "error": "warning",
-				blocksize, path, strerror(errno));
-		}
+	int error;
+
+	if (major(device) == RAMDISK_MAJOR)
+		return;
+	error = ioctl(fd, BLKBSZSET, &blocksize);
+	if (error < 0) {
+		fprintf(stderr, _("%s: %s - cannot set blocksize "
+				"%d on block device %s: %s\n"),
+			progname, fatal ? "error": "warning",
+			blocksize, path, strerror(errno));
+		if (fatal)
+			exit(1);
 	}
-	return error;
 }
 
 /*
diff --git a/libfrog/platform.h b/libfrog/platform.h
index e3e6b7c71..20f9bdf5c 100644
--- a/libfrog/platform.h
+++ b/libfrog/platform.h
@@ -10,8 +10,8 @@
 int platform_check_ismounted(char *path, char *block, struct stat *sptr,
 		int verbose);
 int platform_check_iswritable(char *path, char *block, struct stat *sptr);
-int platform_set_blocksize(int fd, char *path, dev_t device, int bsz,
-		int fatal);
+void platform_set_blocksize(int fd, char *path, dev_t device, int bsz,
+		bool fatal);
 int platform_flush_device(int fd, dev_t device);
 int platform_direct_blockdev(void);
 int platform_align_blockdev(void);
diff --git a/libxfs/init.c b/libxfs/init.c
index 6570c595a..5be6f8cf1 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -125,15 +125,12 @@ retry:
 	}
 
 	if (!readonly && setblksize && (statb.st_mode & S_IFMT) == S_IFBLK) {
-		if (dio) {
-			/* try to use the given explicit blocksize */
-			(void)platform_set_blocksize(fd, path, statb.st_rdev,
-					setblksize, 0);
-		} else {
-			/* given an explicit blocksize to use */
-			if (platform_set_blocksize(fd, path, statb.st_rdev, setblksize, 1))
-			    exit(1);
-		}
+		/*
+		 * Try to use the given explicit blocksize.  Failure to set the
+		 * block size is only fatal for direct I/O.
+		 */
+		platform_set_blocksize(fd, path, statb.st_rdev, setblksize,
+				dio);
 	}
 
 	/*
-- 
2.39.2


