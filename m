Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C447A3E3102
	for <lists+linux-xfs@lfdr.de>; Fri,  6 Aug 2021 23:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239811AbhHFVYG (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 6 Aug 2021 17:24:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28162 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240279AbhHFVYG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 Aug 2021 17:24:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628285029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Bct8bOHoBon/hoiLR13K/+hChaFT9X0FxGbehSQyWtc=;
        b=HDuLKRIZje535Q7dKNdu7fqDx+CTxHVwqhAwT8OcTxheRQgYG9kIU7kNJVw/xdvMCdBKSQ
        vrmfp08o9GoeL4d2L00rkEmX6+8FNiBfm7HD+W5tc2ckzXwAcyuku4KXysUSSYmaVcJbZl
        POHXS9dR6D2LGrNg26VwlrgbLusX3Rc=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-gjuqrqv_Pg2r_6DniGxBmw-1; Fri, 06 Aug 2021 17:23:48 -0400
X-MC-Unique: gjuqrqv_Pg2r_6DniGxBmw-1
Received: by mail-ej1-f70.google.com with SMTP id k21-20020a1709062a55b0290590e181cc34so3535098eje.3
        for <linux-xfs@vger.kernel.org>; Fri, 06 Aug 2021 14:23:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Bct8bOHoBon/hoiLR13K/+hChaFT9X0FxGbehSQyWtc=;
        b=l9E98UFmHmO6jvZYhY72i53jwVc1Q+UH1eeBChnBaKbIc80rBWSZdEoMIn0HbbDqkK
         ua5MEoi426ZeCYk+DC4mz0Vu8NIIvgvyc4mUOv+GZ8aI4RkmYPK5S0cara+pKq6qzYyb
         VCVM7AV93nhBZg7bugWzzrewzBazLeyqLfr60P8pBWQ3DJxDatJHMaVBnwPcnojoctCD
         02bNPILtFtxYxCCaF2iMn8eDcmBqT8cRWt2B7K1581neKroAfM6Ue6EPTzXuW3lyadOa
         38sLJ6MtbFshH1sp9ljS/INi9C1gDeSsJiyG+NoD54CTYdeiqw/e4kasHQt3bjW/AxK7
         FFDA==
X-Gm-Message-State: AOAM532epa4axS4NuS7Hdxeu0J008WwwFOFeel0K7uvYylOpjLxfYs60
        SczF9BYdrroUy6BCbDxeti1AfbWeFpUuLySZiwPK5PzYt9fQOozVfkeATC49+fWep4C3XR0joMC
        KWcGeR094rsUcqLOmt7gYXEb4zVx1mEJZKuX0lxT2p/kgBT6Go4CYnwgCvQ2aQdVuA2ILEo8=
X-Received: by 2002:a17:907:2108:: with SMTP id qn8mr11445095ejb.549.1628285027467;
        Fri, 06 Aug 2021 14:23:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwMytThQmIvTfapO3G/6qSNxhryVslWSSS/mGAZEAqfOgppqJ/Ju6OHBUwtd93/mwJJKCDTOw==
X-Received: by 2002:a17:907:2108:: with SMTP id qn8mr11445088ejb.549.1628285027287;
        Fri, 06 Aug 2021 14:23:47 -0700 (PDT)
Received: from localhost.localdomain ([84.19.91.9])
        by smtp.gmail.com with ESMTPSA id og35sm3256741ejc.28.2021.08.06.14.23.44
        for <linux-xfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 14:23:45 -0700 (PDT)
From:   Pavel Reichl <preichl@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 18/29] xfsprogs: Stop using platform_findsizes()
Date:   Fri,  6 Aug 2021 23:23:07 +0200
Message-Id: <20210806212318.440144-19-preichl@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210806212318.440144-1-preichl@redhat.com>
References: <20210806212318.440144-1-preichl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

---
 libfrog/linux.c    |  8 +++++++-
 libfrog/platform.h |  2 +-
 libfrog/topology.c |  6 +++---
 libxfs/init.c      | 12 ++++++------
 4 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/libfrog/linux.c b/libfrog/linux.c
index 3e4f2291..891373c6 100644
--- a/libfrog/linux.c
+++ b/libfrog/linux.c
@@ -192,7 +192,7 @@ platform_flush_device(
 }
 
 void
-platform_findsizes(char *path, int fd, long long *sz, int *bsz)
+findsizes(char *path, int fd, long long *sz, int *bsz)
 {
 	struct stat	st;
 	uint64_t	size;
@@ -251,6 +251,12 @@ platform_findsizes(char *path, int fd, long long *sz, int *bsz)
 		max_block_alignment = *bsz;
 }
 
+void
+platform_findsizes(char *path, int fd, long long *sz, int *bsz)
+{
+	findsizes(path, fd, sz, bsz);
+}
+
 char *
 platform_findrawpath(char *path)
 {
diff --git a/libfrog/platform.h b/libfrog/platform.h
index 1705c1c9..914da2c7 100644
--- a/libfrog/platform.h
+++ b/libfrog/platform.h
@@ -21,8 +21,8 @@ int platform_direct_blockdev(void);
 int platform_align_blockdev(void);
 unsigned long platform_physmem(void);	/* in kilobytes */
 void platform_findsizes(char *path, int fd, long long *sz, int *bsz);
+void findsizes(char *path, int fd, long long *sz, int *bsz);
 int platform_nproc(void);
 
-void platform_findsizes(char *path, int fd, long long *sz, int *bsz);
 
 #endif /* __LIBFROG_PLATFORM_H__ */
diff --git a/libfrog/topology.c b/libfrog/topology.c
index b1b470c9..a21ba6c6 100644
--- a/libfrog/topology.c
+++ b/libfrog/topology.c
@@ -117,7 +117,7 @@ check_overwrite(
 	fd = open(device, O_RDONLY);
 	if (fd < 0)
 		goto out;
-	platform_findsizes((char *)device, fd, &size, &bsz);
+	findsizes((char *)device, fd, &size, &bsz);
 	close(fd);
 
 	/* nothing to overwrite on a 0-length device */
@@ -296,7 +296,7 @@ void get_topology(
 	char *dfile = xi->volname ? xi->volname : xi->dname;
 
 	/*
-	 * If our target is a regular file, use platform_findsizes
+	 * If our target is a regular file, use findsizes
 	 * to try to obtain the underlying filesystem's requirements
 	 * for direct IO; we'll set our sector size to that if possible.
 	 */
@@ -312,7 +312,7 @@ void get_topology(
 
 		fd = open(dfile, flags, 0666);
 		if (fd >= 0) {
-			platform_findsizes(dfile, fd, &dummy, &ft->lsectorsize);
+			findsizes(dfile, fd, &dummy, &ft->lsectorsize);
 			close(fd);
 			ft->psectorsize = ft->lsectorsize;
 		} else
diff --git a/libxfs/init.c b/libxfs/init.c
index 784f15e2..7bc3b59d 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -324,7 +324,7 @@ libxfs_init(libxfs_init_t *a)
 			a->ddev= libxfs_device_open(dname, a->dcreat, flags,
 						    a->setblksize);
 			a->dfd = libxfs_device_to_fd(a->ddev);
-			platform_findsizes(dname, a->dfd, &a->dsize,
+			findsizes(dname, a->dfd, &a->dsize,
 					   &a->dbsize);
 		} else {
 			if (!check_open(dname, flags, &rawfile, &blockfile))
@@ -332,7 +332,7 @@ libxfs_init(libxfs_init_t *a)
 			a->ddev = libxfs_device_open(rawfile,
 					a->dcreat, flags, a->setblksize);
 			a->dfd = libxfs_device_to_fd(a->ddev);
-			platform_findsizes(rawfile, a->dfd,
+			findsizes(rawfile, a->dfd,
 					   &a->dsize, &a->dbsize);
 		}
 	} else
@@ -342,7 +342,7 @@ libxfs_init(libxfs_init_t *a)
 			a->logdev = libxfs_device_open(logname,
 					a->lcreat, flags, a->setblksize);
 			a->logfd = libxfs_device_to_fd(a->logdev);
-			platform_findsizes(dname, a->logfd, &a->logBBsize,
+			findsizes(dname, a->logfd, &a->logBBsize,
 					   &a->lbsize);
 		} else {
 			if (!check_open(logname, flags, &rawfile, &blockfile))
@@ -350,7 +350,7 @@ libxfs_init(libxfs_init_t *a)
 			a->logdev = libxfs_device_open(rawfile,
 					a->lcreat, flags, a->setblksize);
 			a->logfd = libxfs_device_to_fd(a->logdev);
-			platform_findsizes(rawfile, a->logfd,
+			findsizes(rawfile, a->logfd,
 					   &a->logBBsize, &a->lbsize);
 		}
 	} else
@@ -360,7 +360,7 @@ libxfs_init(libxfs_init_t *a)
 			a->rtdev = libxfs_device_open(rtname,
 					a->rcreat, flags, a->setblksize);
 			a->rtfd = libxfs_device_to_fd(a->rtdev);
-			platform_findsizes(dname, a->rtfd, &a->rtsize,
+			findsizes(dname, a->rtfd, &a->rtsize,
 					   &a->rtbsize);
 		} else {
 			if (!check_open(rtname, flags, &rawfile, &blockfile))
@@ -368,7 +368,7 @@ libxfs_init(libxfs_init_t *a)
 			a->rtdev = libxfs_device_open(rawfile,
 					a->rcreat, flags, a->setblksize);
 			a->rtfd = libxfs_device_to_fd(a->rtdev);
-			platform_findsizes(rawfile, a->rtfd,
+			findsizes(rawfile, a->rtfd,
 					   &a->rtsize, &a->rtbsize);
 		}
 	} else
-- 
2.31.1

