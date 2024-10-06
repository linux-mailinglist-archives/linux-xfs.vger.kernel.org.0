Return-Path: <linux-xfs+bounces-13649-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E3229991F0A
	for <lists+linux-xfs@lfdr.de>; Sun,  6 Oct 2024 16:53:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 12CF51C20FD1
	for <lists+linux-xfs@lfdr.de>; Sun,  6 Oct 2024 14:53:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2627B13A896;
	Sun,  6 Oct 2024 14:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shopee.com header.i=@shopee.com header.b="dz0oBZh3"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7284C14EC5E
	for <linux-xfs@vger.kernel.org>; Sun,  6 Oct 2024 14:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728226388; cv=none; b=l1nEY8rQrYzbzmqez+tA3YYvXneLx/VO7xl8av4stOByQduMU3dzhMT8+1xvyNY25N/gRWvYt86PFgg/lF52sStEc/b51AG32MnjOdWT+UEi5X6s05iZZPPRurhhRuw8DSpYRF6/xzfklNms+FgSP1j9Nv3ArcKcqLaLkWLAvUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728226388; c=relaxed/simple;
	bh=f7R704RsWlDrxzSooYYoOU0A7FIBYe24AoPYxQ5cGvw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Pqc+YK1fX4YVl6ED39QFMPaGJtIBl55PXsS1UYtCt7HAi35lqMXLq1kK/Q/fYhLDwxCo/dYW0skRzCPLwp6GJw4mIWG9dYLW1eIlKMsoe654pBHlmTVji5EELlI61fLycLDBNjuKDE1Byd+7stSfGBF0EfdiiRUTv6GUAo/36TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=shopee.com; spf=pass smtp.mailfrom=shopee.com; dkim=pass (2048-bit key) header.d=shopee.com header.i=@shopee.com header.b=dz0oBZh3; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=shopee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shopee.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2e199b1d157so2634349a91.2
        for <linux-xfs@vger.kernel.org>; Sun, 06 Oct 2024 07:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1728226387; x=1728831187; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9eAPrPoMERAiWqG8615Bek5ETZFlvIxFExngJIu2ukc=;
        b=dz0oBZh3VOLaKZ12KfCkGrlZggkZ3vcII6FAEBsXBIYSEEITBfr76HZYxbB+HfT5P9
         51GoHOG77vMrJrzvBgUqSXKjc7xWKjj9EVoqvvg06lRH1yZPe6ZQ3PTl6+f4HN6hw4mY
         jM8YQfwChEk0g+ijVHHKRzyVO+euzqUZEEDf1rOe72oy+coMebybmlGOJNGNMaX0sfzZ
         dqd/3PcYu1Nds1WTHfCz3h9dO1pYJnkslCslRafLw63mNie/kzcjPAJkSsswwSxCHdYH
         8m2Rfgj81j5xSo95DNldOZ491AAJyFkdroJvt9o4fIitNbYuvIBjM3Eyp0k3Cs9gC5hp
         pvuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728226387; x=1728831187;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9eAPrPoMERAiWqG8615Bek5ETZFlvIxFExngJIu2ukc=;
        b=A7MoiDBzNSBeZysswv7TKfrU+Rc424eZKEM/yGZCy7E2YsYT6AG6lRgD4Pj4mU2hQW
         gkyQSolQXvuZsKW3+McciUWzIH3P+8aIJWqA7IlXh1ktMRNwOrlCbSCXOlRtQX3UTT+l
         3QL09BBhyRL7LsD5wkqTLpN7Cjz7Xg1mP14FdcLFpgqK68EE3Ugfja+X4xqQtf2dec3X
         DY3sjP1dqyXc7QuH9vz/kI15FXcJ91lymP8fHVfqqZj7anY4K+K349CysdmDBl9AgusM
         FCRIYBP223znOwkBoCl/sOFev4+xe0OjvJrIdzpPW8fiuuD8EvKMaYeQWtEAsWfPh5Sq
         eoWw==
X-Forwarded-Encrypted: i=1; AJvYcCXetPUtMa08Hleg9vC7tPCU2hmM2uQhwKu4p+4bct4FmYc8EHWXYA6CaJsYLwFBcxBV3PyzgPxz73A=@vger.kernel.org
X-Gm-Message-State: AOJu0YxxHlV4E48FxvGIfe/TYpsR2NeQpsAR4IlGAaMg2sEsz4FTKwfc
	HippuF7BecM3fXZwJM8kT1og/XOrp4zbsbnYk4wwKU4byrkM78AG4EL5RDoWzOs=
X-Google-Smtp-Source: AGHT+IGZxFAwhuS3OVDNQNCnjWK72kn4p7aawm+WgQnlBR5xxHp0OCCw7G+Tdm2ecDi8+9pF4eZ5cg==
X-Received: by 2002:a17:90b:11c9:b0:2e0:ad69:1e08 with SMTP id 98e67ed59e1d1-2e1e6229186mr10941867a91.16.1728226386789;
        Sun, 06 Oct 2024 07:53:06 -0700 (PDT)
Received: from localhost.localdomain ([143.92.64.17])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e1e8664bfasm5213680a91.44.2024.10.06.07.53.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Oct 2024 07:53:06 -0700 (PDT)
From: Tang Yizhou <yizhou.tang@shopee.com>
X-Google-Original-From: Tang Yizhou
To: jack@suse.cz,
	hch@infradead.org,
	willy@infradead.org,
	akpm@linux-foundation.org,
	chandan.babu@oracle.com
Cc: linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Tang Yizhou <yizhou.tang@shopee.com>
Subject: [PATCH v2 3/3] xfs: Let the max iomap length be consistent with the writeback code
Date: Sun,  6 Oct 2024 23:28:49 +0800
Message-Id: <20241006152849.247152-4-yizhou.tang@shopee.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20241006152849.247152-1-yizhou.tang@shopee.com>
References: <20241006152849.247152-1-yizhou.tang@shopee.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tang Yizhou <yizhou.tang@shopee.com>

Since commit 1a12d8bd7b29 ("writeback: scale IO chunk size up to half
device bandwidth"), macro MAX_WRITEBACK_PAGES has been removed from the
writeback path. Therefore, the MAX_WRITEBACK_PAGES comments in
xfs_direct_write_iomap_begin() and xfs_buffered_write_iomap_begin() appear
outdated.

In addition, Christoph mentioned that the xfs iomap process should be
similar to writeback, so xfs_max_map_length() was written following the
logic of writeback_chunk_size().

v2: Thanks for Christoph's advice. Resync with the writeback code.

Signed-off-by: Tang Yizhou <yizhou.tang@shopee.com>
---
 fs/fs-writeback.c         |  5 ----
 fs/xfs/xfs_iomap.c        | 52 ++++++++++++++++++++++++---------------
 include/linux/writeback.h |  5 ++++
 3 files changed, 37 insertions(+), 25 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index d8bec3c1bb1f..31c72e207e1b 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -31,11 +31,6 @@
 #include <linux/memcontrol.h>
 #include "internal.h"
 
-/*
- * 4MB minimal write chunk size
- */
-#define MIN_WRITEBACK_PAGES	(4096UL >> (PAGE_SHIFT - 10))
-
 /*
  * Passed into wb_writeback(), essentially a subset of writeback_control
  */
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 1e11f48814c0..80f759fa9534 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -4,6 +4,8 @@
  * Copyright (c) 2016-2018 Christoph Hellwig.
  * All Rights Reserved.
  */
+#include <linux/writeback.h>
+
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
@@ -744,6 +746,34 @@ xfs_ilock_for_iomap(
 	return 0;
 }
 
+/*
+ * We cap the maximum length we map to a sane size to keep the chunks
+ * of work done where somewhat symmetric with the work writeback does.
+ * This is a completely arbitrary number pulled out of thin air as a
+ * best guess for initial testing.
+ *
+ * Following the logic of writeback_chunk_size(), the length will be
+ * rounded to the nearest 4MB boundary.
+ *
+ * Note that the values needs to be less than 32-bits wide until the
+ * lower level functions are updated.
+ */
+static loff_t
+xfs_max_map_length(struct inode *inode, loff_t length)
+{
+	struct bdi_writeback *wb;
+	long pages;
+
+	spin_lock(&inode->i_lock);
+	wb = inode_to_wb(wb);
+	pages = min(wb->avg_write_bandwidth / 2,
+		    global_wb_domain.dirty_limit / DIRTY_SCOPE);
+	spin_unlock(&inode->i_lock);
+	pages = round_down(pages + MIN_WRITEBACK_PAGES, MIN_WRITEBACK_PAGES);
+
+	return min_t(loff_t, length, pages * PAGE_SIZE);
+}
+
 /*
  * Check that the imap we are going to return to the caller spans the entire
  * range that the caller requested for the IO.
@@ -878,16 +908,7 @@ xfs_direct_write_iomap_begin(
 	if (flags & (IOMAP_NOWAIT | IOMAP_OVERWRITE_ONLY))
 		goto out_unlock;
 
-	/*
-	 * We cap the maximum length we map to a sane size  to keep the chunks
-	 * of work done where somewhat symmetric with the work writeback does.
-	 * This is a completely arbitrary number pulled out of thin air as a
-	 * best guess for initial testing.
-	 *
-	 * Note that the values needs to be less than 32-bits wide until the
-	 * lower level functions are updated.
-	 */
-	length = min_t(loff_t, length, 1024 * PAGE_SIZE);
+	length = xfs_max_map_length(inode, length);
 	end_fsb = xfs_iomap_end_fsb(mp, offset, length);
 
 	if (offset + length > XFS_ISIZE(ip))
@@ -1096,16 +1117,7 @@ xfs_buffered_write_iomap_begin(
 		allocfork = XFS_COW_FORK;
 		end_fsb = imap.br_startoff + imap.br_blockcount;
 	} else {
-		/*
-		 * We cap the maximum length we map here to MAX_WRITEBACK_PAGES
-		 * pages to keep the chunks of work done where somewhat
-		 * symmetric with the work writeback does.  This is a completely
-		 * arbitrary number pulled out of thin air.
-		 *
-		 * Note that the values needs to be less than 32-bits wide until
-		 * the lower level functions are updated.
-		 */
-		count = min_t(loff_t, count, 1024 * PAGE_SIZE);
+		count = xfs_max_map_length(inode, count);
 		end_fsb = xfs_iomap_end_fsb(mp, offset, count);
 
 		if (xfs_is_always_cow_inode(ip))
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index d6db822e4bb3..657bc4dd22d0 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -17,6 +17,11 @@ struct bio;
 
 DECLARE_PER_CPU(int, dirty_throttle_leaks);
 
+/*
+ * 4MB minimal write chunk size
+ */
+#define MIN_WRITEBACK_PAGES	(4096UL >> (PAGE_SHIFT - 10))
+
 /*
  * The global dirty threshold is normally equal to the global dirty limit,
  * except when the system suddenly allocates a lot of anonymous memory and
-- 
2.25.1


