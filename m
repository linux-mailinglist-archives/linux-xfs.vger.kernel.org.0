Return-Path: <linux-xfs+bounces-25385-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 81E5CB50103
	for <lists+linux-xfs@lfdr.de>; Tue,  9 Sep 2025 17:25:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DC4811BC7AF4
	for <lists+linux-xfs@lfdr.de>; Tue,  9 Sep 2025 15:25:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8A52352065;
	Tue,  9 Sep 2025 15:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Pq3Ny+ia"
X-Original-To: linux-xfs@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED57F343202
	for <linux-xfs@vger.kernel.org>; Tue,  9 Sep 2025 15:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757431495; cv=none; b=I09bbRAepqSDzz+NkfFKvwOWIJT1ZZp3vpjxkUOcVcSo6vvGvjBdSJIeSlkKVNXl2UuzLEw6Df3i6dA5XD9DtZYQY8NiQENW4xSc149wOMK4ZQ0yae7wiipxd8Wv/M+mgXSVYPhclJwKRXVwPl8vC/eQFAzLzwQaj16Ii1z7TQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757431495; c=relaxed/simple;
	bh=DmqedATQlA3tvap4luNWBTZlVEta2u1+Btm7jB/VL10=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=CeAIHrK99VGRuCPlEkcbMhmUDNFehGEr/mYT5jYm0ctvsYXs2IDe/qEUEn/I+EBlfrThXDKMzh5aifa3QQJCBV9ou8gfVBurxondOndtfsFO4DgyucimT1LRQKZuehjOpqaoCyob0ytnC9oxEdIXVGwjtv5lBcY86wrOhPPFlWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Pq3Ny+ia; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757431493;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eBZ9scCH/zyWPoJz68zBrnbhhD6hwcL6Zqo/WIdWR24=;
	b=Pq3Ny+iaBPrFzTHAFYQsRHS7RH0A/RAo4G0PNGQFcgfR+sI4f0dO+rRKwP4hweiHiysg5g
	qo6BPSn+e9OHY9thZt8KFho70c8j9jr0ucnbx/8sr/SnnhTVZ8nZ0vfXFOLvcdm1J8iZbP
	7X0BeVf+6gNy1MGUvABmTphMU3sEXVU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-436-4Klhy9pEPDWYgnbTxDjq-w-1; Tue, 09 Sep 2025 11:24:49 -0400
X-MC-Unique: 4Klhy9pEPDWYgnbTxDjq-w-1
X-Mimecast-MFC-AGG-ID: 4Klhy9pEPDWYgnbTxDjq-w_1757431487
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45dcfc6558cso42116555e9.1
        for <linux-xfs@vger.kernel.org>; Tue, 09 Sep 2025 08:24:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757431487; x=1758036287;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eBZ9scCH/zyWPoJz68zBrnbhhD6hwcL6Zqo/WIdWR24=;
        b=rcczW7wECXEbhbzUMdbfzUSNq1yvvLRwnpA6S6LbESYfeEbieYLfs29LAV7EMmrWje
         U3BZf/c/ZiqMe6VwjIFd/+JlPVbVQF/emI57bf4/yH9O5aEGVC+XASMPyo8l0loMOyvK
         gMds2UbwNe5rW/k6OKtmhynW1T8Dp0S7JFcNi8GPBlAEJ4PonsatbeXhoTHyJfg7hLPA
         P9Dt1vaxGuaJj0IFAGpbM5UhSR96pidPX2iMQT2G+qEf/yN1IiCcWcoCroz6E1CGguUb
         W/C4dUUrA/7KehezyVJovPxQFHNOt0I8dP68i4Z9pNgBzj9gExgE4Mlb6f8yGxEyakVb
         3OPQ==
X-Forwarded-Encrypted: i=1; AJvYcCWcHuNMMBiEoGTgwmBJ1GMnFsOGr2/Y+ZGX/uMkmA0kbGkoy2b9kO1N1k/BfsL7avz/iG7VqgUFJio=@vger.kernel.org
X-Gm-Message-State: AOJu0YwDphsuOct4JmSUk+bBASKFyjJObSSdugiZmwL/jXG6KbFyRZ7X
	cf2+/4TN8/3ZTgAccTkiQpfyxUBs8rFVIB8Zq0u5KOKeH9kRNJ0GBsIcR3vSv370tIrCf58zVDV
	qyBZJLNTjNc0CJEOsK+0CUPK31IU7/imUc/zNX/VtM7xF5BCDeDh4QkqSBCr67OyCvUAhGV0=
X-Gm-Gg: ASbGnctI6MYa34fQBpxnJd25hsI536WtFUD+DcaHtsLLQurR29y7jC7MOvvOvnSSzJJ
	uM0LzNxWk5Em81/9gq3Nr+QS6km9Ut8TZ7USpvKfBNxB8dXqt0SxTo2o7J2+JBzOYm7zlv+BEWM
	D68u9yDi26kCmbjj3oENNoydLjHrRdIR9NPN8LH0zOvqADru4IRZQJ4CAi2O4o/UJqDBUVXeCH/
	FlgkCbtOx+jnoXmaS5uHj9ZG76TyaQPQqQGY7/l/wKnPgaIcgtbf+ZCLxABoNw76ajxJaKaA63w
	QEDr0dkaYDUrMHKjZ9F9ElFDVamEsfMRyIDJOrE=
X-Received: by 2002:a05:6000:186b:b0:3e7:42c5:ea46 with SMTP id ffacd0b85a97d-3e742c5ecc3mr8754260f8f.55.1757431486834;
        Tue, 09 Sep 2025 08:24:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGxbjkZ+LXkNckp/mA2ukswzHjE6s8xH7pjrkr+Tm+yixaxasA3i7Ue/iKRyo3do4u4RZPQ/A==
X-Received: by 2002:a05:6000:186b:b0:3e7:42c5:ea46 with SMTP id ffacd0b85a97d-3e742c5ecc3mr8754241f8f.55.1757431486363;
        Tue, 09 Sep 2025 08:24:46 -0700 (PDT)
Received: from [127.0.0.2] ([91.245.205.131])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45df17d9774sm11432015e9.9.2025.09.09.08.24.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 08:24:45 -0700 (PDT)
From: Andrey Albershteyn <aalbersh@redhat.com>
X-Google-Original-From: Andrey Albershteyn <aalbersh@kernel.org>
Date: Tue, 09 Sep 2025 17:24:38 +0200
Subject: [PATCH v3 v3 3/4] xfs_io: make ls/chattr work with special files
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250909-xattrat-syscall-v3-3-4407a714817e@kernel.org>
References: <20250909-xattrat-syscall-v3-0-4407a714817e@kernel.org>
In-Reply-To: <20250909-xattrat-syscall-v3-0-4407a714817e@kernel.org>
To: aalbersh@kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-xfs@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>, 
 "Darrick J. Wong" <djwong@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=6848; i=aalbersh@kernel.org;
 h=from:subject:message-id; bh=UAmqibEOjJrsPJ7LNU85TMCGqr7HuDx292L9Wqa7rtM=;
 b=owJ4nJvAy8zAJea2/JXEGuOHHIyn1ZIYMg647fq2U/mIXlPu//N+xovf8qlY8J5Y1LLrsf3On
 F5WqVknS7I6SlkYxLgYZMUUWdZJa01NKpLKP2JQIw8zh5UJZAgDF6cATETJn5HhmP3iDI9LkU/X
 rojUX7Uo1KTUJnC6+X0Gnu7jLx9c6uU1YGTYI21oo2W2Ze3jOVWF/HXvS9gVjy8rDzvx9s/ezwH
 MyuuYAUrrRs4=
X-Developer-Key: i=aalbersh@kernel.org; a=openpgp;
 fpr=AE1B2A9562721A6FC4307C1F46A7EA18AC33E108

From: Andrey Albershteyn <aalbersh@redhat.com>

With new file_getattr/file_setattr syscalls we can now list/change file
attributes on special files instead for ignoring them.

Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 io/attr.c | 138 +++++++++++++++++++++++++++++++++++++-------------------------
 io/io.h   |   2 +-
 io/stat.c |   2 +-
 3 files changed, 84 insertions(+), 58 deletions(-)

diff --git a/io/attr.c b/io/attr.c
index fd82a2e73801..022ca5f1df1b 100644
--- a/io/attr.c
+++ b/io/attr.c
@@ -8,6 +8,7 @@
 #include "input.h"
 #include "init.h"
 #include "io.h"
+#include "libfrog/file_attr.h"
 
 static cmdinfo_t chattr_cmd;
 static cmdinfo_t lsattr_cmd;
@@ -113,7 +114,7 @@ chattr_help(void)
 }
 
 void
-printxattr(
+print_xflags(
 	uint		flags,
 	int		verbose,
 	int		dofname,
@@ -156,36 +157,36 @@ lsattr_callback(
 	int			status,
 	struct FTW		*data)
 {
-	struct fsxattr		fsx;
-	int			fd;
+	struct file_attr	fa;
+	int			error;
 
 	if (recurse_dir && !S_ISDIR(stat->st_mode))
 		return 0;
 
-	if ((fd = open(path, O_RDONLY)) == -1) {
-		fprintf(stderr, _("%s: cannot open %s: %s\n"),
-			progname, path, strerror(errno));
-		exitcode = 1;
-	} else if ((xfsctl(path, fd, FS_IOC_FSGETXATTR, &fsx)) < 0) {
+	error = xfrog_file_getattr(AT_FDCWD, path, stat, &fa,
+				   AT_SYMLINK_NOFOLLOW);
+	if (error) {
 		fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
 			progname, path, strerror(errno));
 		exitcode = 1;
-	} else
-		printxattr(fsx.fsx_xflags, 0, 1, path, 0, 1);
+		return 0;
+	}
+
+	print_xflags(fa.fa_xflags, 0, 1, path, 0, 1);
 
-	if (fd != -1)
-		close(fd);
 	return 0;
 }
 
 static int
 lsattr_f(
-	int		argc,
-	char		**argv)
+	int			argc,
+	char			**argv)
 {
-	struct fsxattr	fsx;
-	char		*name = file->name;
-	int		c, aflag = 0, vflag = 0;
+	struct file_attr	fa;
+	char			*name = file->name;
+	int			c, aflag = 0, vflag = 0;
+	struct stat		st;
+	int			error;
 
 	recurse_all = recurse_dir = 0;
 	while ((c = getopt(argc, argv, "DRav")) != EOF) {
@@ -211,17 +212,28 @@ lsattr_f(
 	if (recurse_all || recurse_dir) {
 		nftw(name, lsattr_callback,
 			100, FTW_PHYS | FTW_MOUNT | FTW_DEPTH);
-	} else if ((xfsctl(name, file->fd, FS_IOC_FSGETXATTR, &fsx)) < 0) {
+		return 0;
+	}
+
+	error = stat(name, &st);
+	if (error)
+		return error;
+
+	error = xfrog_file_getattr(AT_FDCWD, name, &st, &fa,
+				   AT_SYMLINK_NOFOLLOW);
+	if (error) {
 		fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
 			progname, name, strerror(errno));
 		exitcode = 1;
-	} else {
-		printxattr(fsx.fsx_xflags, vflag, !aflag, name, vflag, !aflag);
-		if (aflag) {
-			fputs("/", stdout);
-			printxattr(-1, 0, 1, name, 0, 1);
-		}
+		return 0;
 	}
+
+	print_xflags(fa.fa_xflags, vflag, !aflag, name, vflag, !aflag);
+	if (aflag) {
+		fputs("/", stdout);
+		print_xflags(-1, 0, 1, name, 0, 1);
+	}
+
 	return 0;
 }
 
@@ -232,44 +244,45 @@ chattr_callback(
 	int			status,
 	struct FTW		*data)
 {
-	struct fsxattr		attr;
-	int			fd;
+	struct file_attr	attr;
+	int			error;
 
 	if (recurse_dir && !S_ISDIR(stat->st_mode))
 		return 0;
 
-	if ((fd = open(path, O_RDONLY)) == -1) {
-		fprintf(stderr, _("%s: cannot open %s: %s\n"),
-			progname, path, strerror(errno));
-		exitcode = 1;
-	} else if (xfsctl(path, fd, FS_IOC_FSGETXATTR, &attr) < 0) {
+	error = xfrog_file_getattr(AT_FDCWD, path, stat, &attr,
+				   AT_SYMLINK_NOFOLLOW);
+	if (error) {
 		fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
 			progname, path, strerror(errno));
 		exitcode = 1;
-	} else {
-		attr.fsx_xflags |= orflags;
-		attr.fsx_xflags &= ~andflags;
-		if (xfsctl(path, fd, FS_IOC_FSSETXATTR, &attr) < 0) {
-			fprintf(stderr, _("%s: cannot set flags on %s: %s\n"),
-				progname, path, strerror(errno));
-			exitcode = 1;
-		}
+		return 0;
+	}
+
+	attr.fa_xflags |= orflags;
+	attr.fa_xflags &= ~andflags;
+	error = xfrog_file_setattr(AT_FDCWD, path, stat, &attr,
+				   AT_SYMLINK_NOFOLLOW);
+	if (error) {
+		fprintf(stderr, _("%s: cannot set flags on %s: %s\n"),
+			progname, path, strerror(errno));
+		exitcode = 1;
 	}
 
-	if (fd != -1)
-		close(fd);
 	return 0;
 }
 
 static int
 chattr_f(
-	int		argc,
-	char		**argv)
+	int			argc,
+	char			**argv)
 {
-	struct fsxattr	attr;
-	struct xflags	*p;
-	unsigned int	i = 0;
-	char		*c, *name = file->name;
+	struct file_attr	attr;
+	struct xflags		*p;
+	unsigned int		i = 0;
+	char			*c, *name = file->name;
+	struct stat		st;
+	int			error;
 
 	orflags = andflags = 0;
 	recurse_all = recurse_dir = 0;
@@ -326,19 +339,32 @@ chattr_f(
 	if (recurse_all || recurse_dir) {
 		nftw(name, chattr_callback,
 			100, FTW_PHYS | FTW_MOUNT | FTW_DEPTH);
-	} else if (xfsctl(name, file->fd, FS_IOC_FSGETXATTR, &attr) < 0) {
+		return 0;
+	}
+
+	error = stat(name, &st);
+	if (error)
+		return error;
+
+	error = xfrog_file_getattr(AT_FDCWD, name, &st, &attr,
+				   AT_SYMLINK_NOFOLLOW);
+	if (error) {
 		fprintf(stderr, _("%s: cannot get flags on %s: %s\n"),
 			progname, name, strerror(errno));
 		exitcode = 1;
-	} else {
-		attr.fsx_xflags |= orflags;
-		attr.fsx_xflags &= ~andflags;
-		if (xfsctl(name, file->fd, FS_IOC_FSSETXATTR, &attr) < 0) {
-			fprintf(stderr, _("%s: cannot set flags on %s: %s\n"),
-				progname, name, strerror(errno));
-			exitcode = 1;
-		}
+		return 0;
 	}
+
+	attr.fa_xflags |= orflags;
+	attr.fa_xflags &= ~andflags;
+	error = xfrog_file_setattr(AT_FDCWD, name, &st, &attr,
+				   AT_SYMLINK_NOFOLLOW);
+	if (error) {
+		fprintf(stderr, _("%s: cannot set flags on %s: %s\n"),
+			progname, name, strerror(errno));
+		exitcode = 1;
+	}
+
 	return 0;
 }
 
diff --git a/io/io.h b/io/io.h
index 259c034931b8..35fb8339eeb5 100644
--- a/io/io.h
+++ b/io/io.h
@@ -78,7 +78,7 @@ extern int		openfile(char *, struct xfs_fsop_geom *, int, mode_t,
 extern int		addfile(char *, int , struct xfs_fsop_geom *, int,
 				struct fs_path *);
 extern int		closefile(void);
-extern void		printxattr(uint, int, int, const char *, int, int);
+extern void		print_xflags(uint, int, int, const char *, int, int);
 
 extern unsigned int	recurse_all;
 extern unsigned int	recurse_dir;
diff --git a/io/stat.c b/io/stat.c
index c257037aa8ee..c1085f14eade 100644
--- a/io/stat.c
+++ b/io/stat.c
@@ -112,7 +112,7 @@ print_extended_info(int verbose)
 	}
 
 	printf(_("fsxattr.xflags = 0x%x "), fsx.fsx_xflags);
-	printxattr(fsx.fsx_xflags, verbose, 0, file->name, 1, 1);
+	print_xflags(fsx.fsx_xflags, verbose, 0, file->name, 1, 1);
 	printf(_("fsxattr.projid = %u\n"), fsx.fsx_projid);
 	printf(_("fsxattr.extsize = %u\n"), fsx.fsx_extsize);
 	printf(_("fsxattr.cowextsize = %u\n"), fsx.fsx_cowextsize);

-- 
2.50.1


