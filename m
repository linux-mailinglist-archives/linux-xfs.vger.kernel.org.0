Return-Path: <linux-xfs+bounces-26251-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 10642BCEDEC
	for <lists+linux-xfs@lfdr.de>; Sat, 11 Oct 2025 03:33:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 16A8D1A6695C
	for <lists+linux-xfs@lfdr.de>; Sat, 11 Oct 2025 01:33:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 996F66BB5B;
	Sat, 11 Oct 2025 01:33:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="QeATIuYO"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1763AC1C
	for <linux-xfs@vger.kernel.org>; Sat, 11 Oct 2025 01:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760146410; cv=none; b=uJV+0Q6lt7CBMjmdAgw6qM11/6oQ14OZpVSJHZcQ0GSS6VhBrjt75drsFyC7RtsTX/Hn72KW0JXOkfayy5U8jnk1+2YeNv8qgsaxxrIJ49f160bPBC2TSRlFrE643haXl95SiIt7GI5UqeLP+9paYGTt1Map5yHGzTXFGjUkYHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760146410; c=relaxed/simple;
	bh=FMRXqxPu0WQ5Ax5nNw0lt7BC+iqQTQtavFODzaAsDT8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=miKtYk5j+DGc0uV0q1Cgz/1uVCNBPG59AZJKSxPEMOrhsq3H5G8+7Ar7bTKZejRl+0ysx522OYSvbRXTFErvRv1Gp19Fk4Pu4L6kqLyZ+glCL0EVPE8Tr0wSRWGYQ3bIQajW9gQW4czyeBPpFNCUFo/1wNT0SEOVDBq/fl5rM6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=QeATIuYO; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-26c209802c0so26032595ad.0
        for <linux-xfs@vger.kernel.org>; Fri, 10 Oct 2025 18:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1760146408; x=1760751208; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=d/dbVKML6jyfDJLg2rXlA//5YED8oSUDfIzTUJyF0qc=;
        b=QeATIuYOcV0Ubn5NJlFEQDCHZ0h28DOmhcI+7yCi3dTo2PHhSkNAMKrV4rHFhJVa3Q
         hRGRX4Dg5/FIGNviJ5G8oEgQGL12pWHXmMg4qZygXcKEA6yHqCENVu+3atCXPrv/RnXr
         w5/4sGoiCCQDhUzRDdY91lCQZ0hnDuY7v1e64/9vpk8XmCQz9/TgDeO2vk6dEyveCSJt
         xVP2wf1XwEEXlxeZWVousAUDWJeNSKpf9/zuB7YcW/YAUBgk1/N7yCTIFZs0o7qPbak0
         BPb0ujZjAqJJEYVCm8b8W1c4A7iF2OuBdSdwUNK2EWst1hQAggSA0MzrARvvLXvPneyd
         zVqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760146408; x=1760751208;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d/dbVKML6jyfDJLg2rXlA//5YED8oSUDfIzTUJyF0qc=;
        b=wJhO5XKf9GgCxJ+tySsiOJh7NttqoeWj38f1fKYi7YqB/F0d6DgCfjnYD/iin/Ko+w
         q0B0STErmTLKYM+ERbBx35UIlzSLvxP1pEoHM9JQu/4qkmze1b2epP1z9f7LxkYk1078
         41e7eXPuMJIJuaYlq0SwItY0+kSDInt2SuqYcJzddTvSbGF+pgcvxiWKiWXpDJ8PiSUI
         AQBO5tnoICrzweI05HHGJqAgf6FsU8+LS8IYKnHxkvMlWhNlfFsI1RZyOyArgDgC247r
         NMvauibnVcSlzzEXuaJkioAJEAFRyLc58UB9z9YoFa947ntsOlSDykWHm053h2Cvf0Y3
         D/nQ==
X-Forwarded-Encrypted: i=1; AJvYcCULu9QMOErdFjliIvYUMCHlsdZ2ayVxeK+/eMUPIDolnv2/PT3AdSZ4cZergou6L4hR3MglKIHKHfg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzXhjsOtSYgpaY99r3vbNRimZr6+AkoP/pesLJZ5avMhww3lUsT
	e999mBk9qCYXSLCw2pGz2Y2I4Ip4cHYSyO4S96bPu4WnqKOSssyia+gMMhkgTMxxDWc=
X-Gm-Gg: ASbGncu5LgE1RjtluHsRz1vBuOxKnfaEWg8Z4qnV7xTBzOFTcNMgL+/2QMHCN7xjKAU
	4gZ143pJ6d8j/dtdP6EALLMo9dqxxVQLTb7TpJl4HUG9KaL7d2lDs2kkfnZKGQKLXH5Q0Xh64CM
	FhiMCrqt4lxJt7ZFNRScB06j5G2OniElXmRqp0FYFokJhUKQQaIJwuUDEkdzvC6lIF6csywHhQQ
	Tw13zI5IUQQeZr0G832bpTYZZu35azNeqPCdi4xTXxdYFgv19nJyakCFDsirP2v7txgK8qUDTEm
	xupxzfdLVSfbNv84xqQd/d3McMYphfEwbiXXDABQ6ueMBIgC/RyIcDNdquZpaN1s7VkhKbmyvWm
	Y8r9AFp4K3cWRKAxkoa2sdv40yjCRp6EM48CHIos+TQlU4iZpbjfTE6yOUaAgIKqZvS/lszRwGq
	b3ER1XhA==
X-Google-Smtp-Source: AGHT+IH2ZLFZnAX+DFQkY9v0s+2anWfLJ5/4tgkkHlg3OcqGLJ41YRx4qbgQD3SYi5SqmtyxL/sNpg==
X-Received: by 2002:a17:902:da8e:b0:26a:589b:cf11 with SMTP id d9443c01a7336-29027402d24mr204107925ad.43.1760146407559;
        Fri, 10 Oct 2025 18:33:27 -0700 (PDT)
Received: from localhost.localdomain ([139.177.225.239])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b678ddc9f8esm3533310a12.10.2025.10.10.18.33.21
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 10 Oct 2025 18:33:27 -0700 (PDT)
From: Fengnan Chang <changfengnan@bytedance.com>
To: axboe@kernel.dk,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	asml.silence@gmail.com,
	willy@infradead.org,
	djwong@kernel.org,
	hch@infradead.org,
	ritesh.list@gmail.com,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-ext4@vger.kernel.org
Cc: Fengnan Chang <changfengnan@bytedance.com>
Subject: [PATCH] block: enable per-cpu bio cache by default
Date: Sat, 11 Oct 2025 09:33:12 +0800
Message-Id: <20251011013312.20698-1-changfengnan@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Per cpu bio cache was only used in the io_uring + raw block device,
after commit 12e4e8c7ab59 ("io_uring/rw: enable bio caches for IRQ
rw"),  bio_put is safe for task and irq context, bio_alloc_bioset is
safe for task context and no one calls in irq context, so we can enable
per cpu bio cache by default.

Benchmarked with t/io_uring and ext4+nvme:
taskset -c 6 /root/fio/t/io_uring  -p0 -d128 -b4096 -s1 -c1 -F1 -B1 -R1
-X1 -n1 -P1  /mnt/testfile
base IOPS is 562K, patch IOPS is 574K. The CPU usage of bio_alloc_bioset
decrease from 1.42% to 1.22%.

The worst case is allocate bio in CPU A but free in CPU B, still use
t/io_uring and ext4+nvme:
base IOPS is 648K, patch IOPS is 647K.

Also use fio test ext4/xfs with libaio/sync/io_uring on null_blk and
nvme, no obvious performance regression.

Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
---
 block/bio.c        | 26 ++++++++++++--------------
 block/blk-map.c    |  4 ++++
 block/fops.c       |  4 ----
 include/linux/fs.h |  3 ---
 io_uring/rw.c      |  1 -
 5 files changed, 16 insertions(+), 22 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 3b371a5da159..16b20c10cab7 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -513,20 +513,18 @@ struct bio *bio_alloc_bioset(struct block_device *bdev, unsigned short nr_vecs,
 	if (WARN_ON_ONCE(!mempool_initialized(&bs->bvec_pool) && nr_vecs > 0))
 		return NULL;
 
-	if (opf & REQ_ALLOC_CACHE) {
-		if (bs->cache && nr_vecs <= BIO_INLINE_VECS) {
-			bio = bio_alloc_percpu_cache(bdev, nr_vecs, opf,
-						     gfp_mask, bs);
-			if (bio)
-				return bio;
-			/*
-			 * No cached bio available, bio returned below marked with
-			 * REQ_ALLOC_CACHE to particpate in per-cpu alloc cache.
-			 */
-		} else {
-			opf &= ~REQ_ALLOC_CACHE;
-		}
-	}
+	opf |= REQ_ALLOC_CACHE;
+	if (bs->cache && nr_vecs <= BIO_INLINE_VECS) {
+		bio = bio_alloc_percpu_cache(bdev, nr_vecs, opf,
+					     gfp_mask, bs);
+		if (bio)
+			return bio;
+		/*
+		 * No cached bio available, bio returned below marked with
+		 * REQ_ALLOC_CACHE to participate in per-cpu alloc cache.
+		 */
+	} else
+		opf &= ~REQ_ALLOC_CACHE;
 
 	/*
 	 * submit_bio_noacct() converts recursion to iteration; this means if
diff --git a/block/blk-map.c b/block/blk-map.c
index 23e5d5ebe59e..570a7ca6edd1 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -255,6 +255,10 @@ static struct bio *blk_rq_map_bio_alloc(struct request *rq,
 {
 	struct bio *bio;
 
+	/*
+	 * Even REQ_ALLOC_CACHE is enabled by default, we still need this to
+	 * mark bio is allocated by bio_alloc_bioset.
+	 */
 	if (rq->cmd_flags & REQ_ALLOC_CACHE && (nr_vecs <= BIO_INLINE_VECS)) {
 		bio = bio_alloc_bioset(NULL, nr_vecs, rq->cmd_flags, gfp_mask,
 					&fs_bio_set);
diff --git a/block/fops.c b/block/fops.c
index ddbc69c0922b..090562a91b4c 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -177,8 +177,6 @@ static ssize_t __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 	loff_t pos = iocb->ki_pos;
 	int ret = 0;
 
-	if (iocb->ki_flags & IOCB_ALLOC_CACHE)
-		opf |= REQ_ALLOC_CACHE;
 	bio = bio_alloc_bioset(bdev, nr_pages, opf, GFP_KERNEL,
 			       &blkdev_dio_pool);
 	dio = container_of(bio, struct blkdev_dio, bio);
@@ -326,8 +324,6 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
 	loff_t pos = iocb->ki_pos;
 	int ret = 0;
 
-	if (iocb->ki_flags & IOCB_ALLOC_CACHE)
-		opf |= REQ_ALLOC_CACHE;
 	bio = bio_alloc_bioset(bdev, nr_pages, opf, GFP_KERNEL,
 			       &blkdev_dio_pool);
 	dio = container_of(bio, struct blkdev_dio, bio);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 601d036a6c78..18ec41732186 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -365,8 +365,6 @@ struct readahead_control;
 /* iocb->ki_waitq is valid */
 #define IOCB_WAITQ		(1 << 19)
 #define IOCB_NOIO		(1 << 20)
-/* can use bio alloc cache */
-#define IOCB_ALLOC_CACHE	(1 << 21)
 /*
  * IOCB_DIO_CALLER_COMP can be set by the iocb owner, to indicate that the
  * iocb completion can be passed back to the owner for execution from a safe
@@ -399,7 +397,6 @@ struct readahead_control;
 	{ IOCB_WRITE,		"WRITE" }, \
 	{ IOCB_WAITQ,		"WAITQ" }, \
 	{ IOCB_NOIO,		"NOIO" }, \
-	{ IOCB_ALLOC_CACHE,	"ALLOC_CACHE" }, \
 	{ IOCB_DIO_CALLER_COMP,	"CALLER_COMP" }, \
 	{ IOCB_AIO_RW,		"AIO_RW" }, \
 	{ IOCB_HAS_METADATA,	"AIO_HAS_METADATA" }
diff --git a/io_uring/rw.c b/io_uring/rw.c
index af5a54b5db12..fa7655ab9097 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -856,7 +856,6 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
 	ret = kiocb_set_rw_flags(kiocb, rw->flags, rw_type);
 	if (unlikely(ret))
 		return ret;
-	kiocb->ki_flags |= IOCB_ALLOC_CACHE;
 
 	/*
 	 * If the file is marked O_NONBLOCK, still allow retry for it if it
-- 
2.39.5 (Apple Git-154)


