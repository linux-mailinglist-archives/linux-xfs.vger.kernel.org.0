Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D988DA365
	for <lists+linux-xfs@lfdr.de>; Thu, 17 Oct 2019 03:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389753AbfJQBrY (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 16 Oct 2019 21:47:24 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33585 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727387AbfJQBrY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Oct 2019 21:47:24 -0400
Received: by mail-pg1-f195.google.com with SMTP id i76so346039pgc.0;
        Wed, 16 Oct 2019 18:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=rVJD5UxloovhiCkJ29H51QyBZ8G1eVF8rpQyrdGv45Y=;
        b=YjYfjemRDi68dsiqcdUeHa6/KWu0yE1H/rCSVxoaCZVXoc1g+owfUtUtnTvlMdHXZZ
         fH3WZhhuXdkItIML8WqeFwCeNWx/Ik08E0ViQ9xImQBtC5vX4DoHDIWW3/uIOmncDG1Q
         LZfeh384p2yX6dn0nDhMXWyOLGcnobxGC5nxu0qYk5FIcb/scGfIIT5V2u+bBeJaiiHR
         J3vN8Z1f6C7eCc2KNjRBfe12deWIIJHKwQjEN2JxfZX0jFHTI7hZZ/939DJyAI28OY6U
         gP0trJoZpEAVXwQbGeATV1Hl16ecvUa4o/E6KZiWDoiQaSpdpQChSVOpXUCdsnqorFX3
         VBwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=rVJD5UxloovhiCkJ29H51QyBZ8G1eVF8rpQyrdGv45Y=;
        b=iZnm3awXR49/8+6LqUrz6pB6WoDEN6F2O3rjcw4fZb2vu3KT6p41oJfHJf+NJjlhAv
         FD7OPt5PHk5dx/8SqMlgsVzMM+KnOGw4HAmxupwViy1Z5reai9UAhHCFTt/eVwTnaJ7e
         KASKyIGSCenIRXsVXR3EfxJc7Fw8ZLwiGvYMDwQTAe1mB/lmZhT0evc/0c7b4KoM/0cQ
         3OrIw3HoLz+CLPB873wgPL1ZCbqnkSq0c2mACMJoNBsRm3TcYir3N/FsqtQ1kOY0anx8
         tlwz7HucRrNR9fEqCsvfESB/zy1OPAY5z2Ft8yRirQ2CtPKDo7nyopGJhmrUqI60WzTq
         Vj5g==
X-Gm-Message-State: APjAAAU1qTKMhjLtBCr8c+kNo/lDi+v0B9fNbXS2MYgfZKk9Als4WUu3
        EJN3HK2XyhrDY4H5cNzkRg==
X-Google-Smtp-Source: APXvYqzNssgfm25MwzuMb2puUAFl6SNOGAMfTO9N5Nen1eJtspRr9SETqlvNY2McM5lfFoPbPzKAWw==
X-Received: by 2002:a63:f646:: with SMTP id u6mr1241261pgj.71.1571276843432;
        Wed, 16 Oct 2019 18:47:23 -0700 (PDT)
Received: from [10.76.90.34] ([203.205.141.123])
        by smtp.gmail.com with ESMTPSA id l24sm358320pff.151.2019.10.16.18.47.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Oct 2019 18:47:22 -0700 (PDT)
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, Eryu Guan <guaneryu@gmail.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Brian Foster <bfoster@redhat.com>, newtongao@tencent.com,
        jasperwang@tencent.com
From:   kaixuxia <xiakaixu1987@gmail.com>
Subject: [PATCH v3] fsstress: add renameat2 support
Message-ID: <b6fa2a70-a603-7ebc-f913-593a3731a4fc@gmail.com>
Date:   Thu, 17 Oct 2019 09:47:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Support the renameat2 syscall in fsstress.

Signed-off-by: kaixuxia <kaixuxia@tencent.com>
---
Changes in v3:
 - Fix the rename(..., 0) case, avoide to cripple fsstress.

 ltp/fsstress.c | 158 +++++++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 125 insertions(+), 33 deletions(-)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 51976f5..1a20358 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -44,6 +44,38 @@ io_context_t	io_ctx;
 #define IOV_MAX 1024
 #endif
 
+#ifndef HAVE_RENAMEAT2
+#if !defined(SYS_renameat2) && defined(__x86_64__)
+#define SYS_renameat2 316
+#endif
+
+#if !defined(SYS_renameat2) && defined(__i386__)
+#define SYS_renameat2 353
+#endif
+
+static int renameat2(int dfd1, const char *path1,
+		     int dfd2, const char *path2,
+		     unsigned int flags)
+{
+#ifdef SYS_renameat2
+	return syscall(SYS_renameat2, dfd1, path1, dfd2, path2, flags);
+#else
+	errno = ENOSYS;
+	return -1;
+#endif
+}
+#endif
+
+#ifndef RENAME_NOREPLACE
+#define RENAME_NOREPLACE	(1 << 0)	/* Don't overwrite target */
+#endif
+#ifndef RENAME_EXCHANGE
+#define RENAME_EXCHANGE		(1 << 1)	/* Exchange source and dest */
+#endif
+#ifndef RENAME_WHITEOUT
+#define RENAME_WHITEOUT		(1 << 2)	/* Whiteout source */
+#endif
+
 #define FILELEN_MAX		(32*4096)
 
 typedef enum {
@@ -85,6 +117,9 @@ typedef enum {
 	OP_READV,
 	OP_REMOVEFATTR,
 	OP_RENAME,
+	OP_RNOREPLACE,
+	OP_REXCHANGE,
+	OP_RWHITEOUT,
 	OP_RESVSP,
 	OP_RMDIR,
 	OP_SETATTR,
@@ -203,6 +238,9 @@ void	readlink_f(int, long);
 void	readv_f(int, long);
 void	removefattr_f(int, long);
 void	rename_f(int, long);
+void    rnoreplace_f(int, long);
+void    rexchange_f(int, long);
+void    rwhiteout_f(int, long);
 void	resvsp_f(int, long);
 void	rmdir_f(int, long);
 void	setattr_f(int, long);
@@ -262,6 +300,9 @@ opdesc_t	ops[] = {
 	/* remove (delete) extended attribute */
 	{ OP_REMOVEFATTR, "removefattr", removefattr_f, 1, 1 },
 	{ OP_RENAME, "rename", rename_f, 2, 1 },
+	{ OP_RNOREPLACE, "rnoreplace", rnoreplace_f, 2, 1 },
+	{ OP_REXCHANGE, "rexchange", rexchange_f, 2, 1 },
+	{ OP_RWHITEOUT, "rwhiteout", rwhiteout_f, 2, 1 },
 	{ OP_RESVSP, "resvsp", resvsp_f, 1, 1 },
 	{ OP_RMDIR, "rmdir", rmdir_f, 1, 1 },
 	/* set attribute flag (FS_IOC_SETFLAGS ioctl) */
@@ -354,7 +395,7 @@ int	open_path(pathname_t *, int);
 DIR	*opendir_path(pathname_t *);
 void	process_freq(char *);
 int	readlink_path(pathname_t *, char *, size_t);
-int	rename_path(pathname_t *, pathname_t *);
+int	rename_path(pathname_t *, pathname_t *, int);
 int	rmdir_path(pathname_t *);
 void	separate_pathname(pathname_t *, char *, pathname_t *);
 void	show_ops(int, char *);
@@ -1519,7 +1560,7 @@ readlink_path(pathname_t *name, char *lbuf, size_t lbufsiz)
 }
 
 int
-rename_path(pathname_t *name1, pathname_t *name2)
+rename_path(pathname_t *name1, pathname_t *name2, int mode)
 {
 	char		buf1[NAME_MAX + 1];
 	char		buf2[NAME_MAX + 1];
@@ -1528,14 +1569,17 @@ rename_path(pathname_t *name1, pathname_t *name2)
 	pathname_t	newname2;
 	int		rval;
 
-	rval = rename(name1->path, name2->path);
+	if (mode == 0)
+		rval = rename(name1->path, name2->path);
+	else
+		rval = renameat2(AT_FDCWD, name1->path, AT_FDCWD, name2->path, mode);
 	if (rval >= 0 || errno != ENAMETOOLONG)
 		return rval;
 	separate_pathname(name1, buf1, &newname1);
 	separate_pathname(name2, buf2, &newname2);
 	if (strcmp(buf1, buf2) == 0) {
 		if (chdir(buf1) == 0) {
-			rval = rename_path(&newname1, &newname2);
+			rval = rename_path(&newname1, &newname2, mode);
 			assert(chdir("..") == 0);
 		}
 	} else {
@@ -1555,7 +1599,7 @@ rename_path(pathname_t *name1, pathname_t *name2)
 			append_pathname(&newname2, "../");
 			append_pathname(&newname2, name2->path);
 			if (chdir(buf1) == 0) {
-				rval = rename_path(&newname1, &newname2);
+				rval = rename_path(&newname1, &newname2, mode);
 				assert(chdir("..") == 0);
 			}
 		} else {
@@ -1563,7 +1607,7 @@ rename_path(pathname_t *name1, pathname_t *name2)
 			append_pathname(&newname1, "../");
 			append_pathname(&newname1, name1->path);
 			if (chdir(buf2) == 0) {
-				rval = rename_path(&newname1, &newname2);
+				rval = rename_path(&newname1, &newname2, mode);
 				assert(chdir("..") == 0);
 			}
 		}
@@ -4215,8 +4259,18 @@ out:
 	free_pathname(&f);
 }
 
+struct print_flags renameat2_flags [] = {
+	{ RENAME_NOREPLACE, "NOREPLACE"},
+	{ RENAME_EXCHANGE, "EXCHANGE"},
+	{ RENAME_WHITEOUT, "WHITEOUT"},
+	{ -1, NULL}
+};
+
+#define translate_renameat2_flags(mode)	\
+	({translate_flags(mode, "|", renameat2_flags);})
+
 void
-rename_f(int opno, long r)
+do_renameat2(int opno, long r, int mode)
 {
 	fent_t		*dfep;
 	int		e;
@@ -4234,35 +4288,49 @@ rename_f(int opno, long r)
 	init_pathname(&f);
 	if (!get_fname(FT_ANYm, r, &f, &flp, &fep, &v1)) {
 		if (v1)
-			printf("%d/%d: rename - no filename\n", procid, opno);
+			printf("%d/%d: rename - no source filename\n", procid, opno);
 		free_pathname(&f);
 		return;
 	}
-
-	/* get an existing directory for the destination parent directory name */
-	if (!get_fname(FT_DIRm, random(), NULL, NULL, &dfep, &v))
-		parid = -1;
-	else
-		parid = dfep->id;
-	v |= v1;
-
-	/* generate a new path using an existing parent directory in name */
-	init_pathname(&newf);
-	e = generate_fname(dfep, flp - flist, &newf, &id, &v1);
-	v |= v1;
-	if (!e) {
-		if (v) {
-			(void)fent_to_name(&f, &flist[FT_DIR], dfep);
-			printf("%d/%d: rename - no filename from %s\n",
-				procid, opno, f.path);
+	/* Both pathnames must exist for the RENAME_EXCHANGE */
+	if (mode == RENAME_EXCHANGE) {
+		init_pathname(&newf);
+		if (!get_fname(FT_ANYm, random(), &newf, NULL, &dfep, &v1)) {
+			if (v1)
+				printf("%d/%d: rename - no target filename\n", procid, opno);
+			free_pathname(&newf);
+			free_pathname(&f);
+			return;
+		}
+		id = dfep->id;
+		parid = dfep->parent;
+	} else {
+		/* get an existing directory for the destination parent directory name */
+		if (!get_fname(FT_DIRm, random(), NULL, NULL, &dfep, &v))
+			parid = -1;
+		else
+			parid = dfep->id;
+		v |= v1;
+
+		/* generate a new path using an existing parent directory in name */
+		init_pathname(&newf);
+		e = generate_fname(dfep, flp - flist, &newf, &id, &v1);
+		v |= v1;
+		if (!e) {
+			if (v) {
+				(void)fent_to_name(&f, &flist[FT_DIR], dfep);
+				printf("%d/%d: rename - no filename from %s\n",
+					procid, opno, f.path);
+			}
+			free_pathname(&newf);
+			free_pathname(&f);
+			return;
 		}
-		free_pathname(&newf);
-		free_pathname(&f);
-		return;
 	}
-	e = rename_path(&f, &newf) < 0 ? errno : 0;
+
+	e = rename_path(&f, &newf, mode) < 0 ? errno : 0;
 	check_cwd();
-	if (e == 0) {
+	if (e == 0 && mode != RENAME_EXCHANGE) {
 		int xattr_counter = fep->xattr_counter;
 
 		if (flp - flist == FT_DIR) {
@@ -4273,12 +4341,13 @@ rename_f(int opno, long r)
 		add_to_flist(flp - flist, id, parid, xattr_counter);
 	}
 	if (v) {
-		printf("%d/%d: rename %s to %s %d\n", procid, opno, f.path,
+		printf("%d/%d: rename(%s) %s to %s %d\n", procid,
+			opno, translate_renameat2_flags(mode), f.path,
 			newf.path, e);
 		if (e == 0) {
-			printf("%d/%d: rename del entry: id=%d,parent=%d\n",
+			printf("%d/%d: rename source entry: id=%d,parent=%d\n",
 				procid, opno, fep->id, fep->parent);
-			printf("%d/%d: rename add entry: id=%d,parent=%d\n",
+			printf("%d/%d: rename target entry: id=%d,parent=%d\n",
 				procid, opno, id, parid);
 		}
 	}
@@ -4287,6 +4356,29 @@ rename_f(int opno, long r)
 }
 
 void
+rename_f(int opno, long r)
+{
+	do_renameat2(opno, r, 0);
+}
+void
+rnoreplace_f(int opno, long r)
+{
+	do_renameat2(opno, r, RENAME_NOREPLACE);
+}
+
+void
+rexchange_f(int opno, long r)
+{
+	do_renameat2(opno, r, RENAME_EXCHANGE);
+}
+
+void
+rwhiteout_f(int opno, long r)
+{
+	do_renameat2(opno, r, RENAME_WHITEOUT);
+}
+
+void
 resvsp_f(int opno, long r)
 {
 	int		e;
-- 
1.8.3.1

-- 
kaixuxia
