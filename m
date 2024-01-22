Return-Path: <linux-xfs+bounces-2885-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E95F835B8F
	for <lists+linux-xfs@lfdr.de>; Mon, 22 Jan 2024 08:24:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0650F1F21E5E
	for <lists+linux-xfs@lfdr.de>; Mon, 22 Jan 2024 07:24:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE3E9F9FD;
	Mon, 22 Jan 2024 07:24:18 +0000 (UTC)
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A359A101FA
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jan 2024 07:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=140.211.166.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705908258; cv=none; b=Emj7vAtgSi1gUh2lqtNC1iPBynf7y0EBB5R4jSD5ZBKDGvLRIWnaAnmw15dXKzVDUZjdyV+lUj/f1+dsQsQB1TX4BjPNDpUqxa5SRcXDqg6SujT/bGWrOvI/88IGgaS2GhHCBK1jTkXHsWXYbqiJBqTO+o+XigQVYwbzchOBTFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705908258; c=relaxed/simple;
	bh=DOA1yXRpJ7FYIm12d5aXISmMHG62GUnFKKBGPlzT+OU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pDQgRr1MlXiZYAe6zd7b3HYWnbcafghgaqo7BZ0WvEfR3HXrBjum+cs1vNCp8oiL/QlfPE6ycEnWXWJ4uBd9bXJLHRnzW5vjUMFsilocYKCpU14CUZDdSqvGQH5hlRBt7IVXe0E/EdLbUnKTkUK7jh/8tRhrrBwsNkJb07JHYvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org; spf=pass smtp.mailfrom=gentoo.org; arc=none smtp.client-ip=140.211.166.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentoo.org
From: Sam James <sam@gentoo.org>
To: linux-xfs@vger.kernel.org
Cc: Sam James <sam@gentoo.org>,
	"Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH v4 3/3] io: Adapt to >= 64-bit time_t
Date: Mon, 22 Jan 2024 07:23:28 +0000
Message-ID: <20240122072351.3036242-3-sam@gentoo.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122072351.3036242-1-sam@gentoo.org>
References: <20240122072351.3036242-1-sam@gentoo.org>
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

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Sam James <sam@gentoo.org>
---
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


