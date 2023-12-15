Return-Path: <linux-xfs+bounces-830-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C9D1813F45
	for <lists+linux-xfs@lfdr.de>; Fri, 15 Dec 2023 02:37:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CCCB3283E90
	for <lists+linux-xfs@lfdr.de>; Fri, 15 Dec 2023 01:37:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8509646BC;
	Fri, 15 Dec 2023 01:37:07 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 200B3468C
	for <linux-xfs@vger.kernel.org>; Fri, 15 Dec 2023 01:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentoo.org
From: Sam James <sam@gentoo.org>
To: linux-xfs@vger.kernel.org
Cc: Sam James <sam@gentoo.org>
Subject: [PATCH v3 4/4] io: Adapt to >= 64-bit time_t
Date: Fri, 15 Dec 2023 01:36:43 +0000
Message-ID: <20231215013657.1995699-4-sam@gentoo.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231215013657.1995699-1-sam@gentoo.org>
References: <20231215013657.1995699-1-sam@gentoo.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We now require (at least) 64-bit time_t, so we need to adjust some printf
specifiers accordingly.

Unfortunately, we've stumbled upon a ridiculous C mmoment whereby there's
no neat format specifier (not even one of the inttypes ones) for time_t, so
we cast to intmax_t and use %jd.

Signed-off-by: Sam James <sam@gentoo.org>
---
v3: uintmax_t -> intmax_t as time_t is signed

 io/stat.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/io/stat.c b/io/stat.c
index e8f68dc3..743a7586 100644
--- a/io/stat.c
+++ b/io/stat.c
@@ -66,11 +66,11 @@ dump_raw_stat(struct stat *st)
 	printf("stat.ino = %llu\n", (unsigned long long)st->st_ino);
 	printf("stat.size = %lld\n", (long long)st->st_size);
 	printf("stat.blocks = %lld\n", (long long)st->st_blocks);
-	printf("stat.atime.tv_sec = %ld\n", st->st_atim.tv_sec);
+	printf("stat.atime.tv_sec = %jd\n", (intmax_t)st->st_atim.tv_sec);
 	printf("stat.atime.tv_nsec = %ld\n", st->st_atim.tv_nsec);
-	printf("stat.ctime.tv_sec = %ld\n", st->st_ctim.tv_sec);
+	printf("stat.ctime.tv_sec = %jd\n", (intmax_t)st->st_ctim.tv_sec);
 	printf("stat.ctime.tv_nsec = %ld\n", st->st_ctim.tv_nsec);
-	printf("stat.mtime.tv_sec = %ld\n", st->st_mtim.tv_sec);
+	printf("stat.mtime.tv_sec = %jd\n", (intmax_t)st->st_mtim.tv_sec);
 	printf("stat.mtime.tv_nsec = %ld\n", st->st_mtim.tv_nsec);
 	printf("stat.rdev_major = %u\n", major(st->st_rdev));
 	printf("stat.rdev_minor = %u\n", minor(st->st_rdev));
-- 
2.43.0


