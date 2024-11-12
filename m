Return-Path: <linux-xfs+bounces-15286-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 20FC69C4A9D
	for <lists+linux-xfs@lfdr.de>; Tue, 12 Nov 2024 01:24:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 87911B31863
	for <lists+linux-xfs@lfdr.de>; Mon, 11 Nov 2024 23:58:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D62071E0DE2;
	Mon, 11 Nov 2024 23:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="IdKYygrt"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD401E0B91
	for <linux-xfs@vger.kernel.org>; Mon, 11 Nov 2024 23:49:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731368956; cv=none; b=c1Ary29vU9w8wQqws75HXAfI0aGx5BRBlsFMMBnj4HrBjUKxVfOtlgj5SOZg5s++fTj5ckA2mL5KP6u+aMNuwUcP5ndQtRYHklirmyBjKBqpLajZRt+3UtOMBfN9yGeDHppybsbjqZ856xpvNH4K2E/JzbhAGSIdZMIaJuHfQu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731368956; c=relaxed/simple;
	bh=IMtVN6mYVCOPkikFXXrJuZnZt8ZpG9Lqn7xujyAZ3eg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bUdxoNPZzbAS6UAx/NMW/eRxZWHv7QZk3Ldw0jtgQaR5F/QJJe0S+nvsUXO+eyNSZ6AWLuwz8CvpuLlkAes4IStpPu/NYe0c6rLX9JTV5R/FKhSzzJEqycoFSJqbuCRD/MiQ4NFmFgZ6GRwMAt+bQwVmDDPo6wetzC3D/hFCWX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=IdKYygrt; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7240d93fffdso4130013b3a.2
        for <linux-xfs@vger.kernel.org>; Mon, 11 Nov 2024 15:49:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731368954; x=1731973754; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F8VuOfX6p9OA5iVa4jUFPNHPqu8A2RaR+lAgXUtkcVc=;
        b=IdKYygrtPZRQ4q4zua1tosyRBJ+adpZs/6Ecrnytyi89gBbGOTfaTD5JWVti36KeIX
         SosDNw0sDX0m66mZQQkD89wPGeDqTvjhTOgH2wH3Mu3+uhuotA9UM34uVKSEUWz67B2O
         2n55gmyeZ6wn2eofRfC7WHwDY3014gJzTgBr5M8Ety7CHq5W6d2BWGfz+93tDB6OZQ/N
         cZ8ST2MSpPFlitU6RBLe4TJXlsDlIHG/rKieoe8MyUg+fIirzxi3hvwS412w0FneHKHP
         TkAjdZURq8Neqq7wpqsvgac9dUvLClIFXWWwzcc/GoTX4HmwCCPIWikX2shYuIssDAfs
         wIyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731368954; x=1731973754;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F8VuOfX6p9OA5iVa4jUFPNHPqu8A2RaR+lAgXUtkcVc=;
        b=cwZIaymzbjU6PsVPFUP+Q/e4yWU/xwp/3jQWwDFRq45XyOJxFTGUbnH6+bzzKGCB+i
         RizeN8cnH8zo+vXWlBSXNaOhygC44bQK1M9bQeWHV848mrdjjvcfufKfIeXGbDig7boh
         JuT2k75VB9SihoBlc93B232FFcN8i9vEr7F3ZtTPu3Ks5zm2W28GUV/eUvGMm5WQYZNR
         qmlDby7HARIV7JLnop/5ow8KmnARmjkqJl7wBlv4NyYQXlHvOWRAYkPl+qiN3wKs4q3H
         cJO9gfNHKjKiE5hfyCT4C2XJLjTtalODNk//mOMxFb4YihQ26XqPPf6YYXWq9kVEiZ0n
         KRrA==
X-Forwarded-Encrypted: i=1; AJvYcCWTATsZzD8bFMTRb6+jvlZ7Ye+tyw1ReaW0lL9/uT+6SONNruVAszDbo1yKNAcFWFRHKB1vuRWdtBQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRmQV3RjEyTKOsHc1B0L/ovGD634sWj+W+bYMMOBibeehcnWlo
	i3lnv9tvceViFObkxNw137ah+mPWe+vsXG2IQeieGxIkwv4ru5NzLc55XEDZaRU=
X-Google-Smtp-Source: AGHT+IF2+wW3TLckV7VSNmFRA6TqTX3hVCOrji7S4MicSJHEM7Y626gshLEQCdd+Y+7SrufulOQgng==
X-Received: by 2002:a05:6a00:2354:b0:71e:60fc:ad11 with SMTP id d2e1a72fcca58-72413354230mr19707325b3a.16.1731368953536;
        Mon, 11 Nov 2024 15:49:13 -0800 (PST)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-724078a7ee9sm10046057b3a.64.2024.11.11.15.49.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2024 15:49:12 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Cc: hannes@cmpxchg.org,
	clm@meta.com,
	linux-kernel@vger.kernel.org,
	willy@infradead.org,
	kirill@shutemov.name,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 16/16] btrfs: add support for uncached writes
Date: Mon, 11 Nov 2024 16:37:43 -0700
Message-ID: <20241111234842.2024180-17-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241111234842.2024180-1-axboe@kernel.dk>
References: <20241111234842.2024180-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The read side is already covered as btrfs uses the generic filemap
helpers. For writes, just pass in FGP_UNCACHED if uncached IO is being
done, then the folios created should be marked appropriately.

For IO completion, ensure that writing back folios that are uncached
gets punted to one of the btrfs workers, as task context is needed for
that. Add an 'uncached_io' member to struct btrfs_bio to manage that.

Outside of that, call generic_uncached_write() upon successful
completion of a buffered write.

With that, add FOP_UNCACHED to the btrfs file_operations fop_flags
structure, enabling use of RWF_UNCACHED.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/btrfs/bio.c       |  4 ++--
 fs/btrfs/bio.h       |  2 ++
 fs/btrfs/extent_io.c |  8 +++++++-
 fs/btrfs/file.c      | 10 +++++++---
 4 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index 7e0f9600b80c..253e1a656934 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -334,7 +334,7 @@ static void btrfs_end_bio_work(struct work_struct *work)
 	struct btrfs_bio *bbio = container_of(work, struct btrfs_bio, end_io_work);
 
 	/* Metadata reads are checked and repaired by the submitter. */
-	if (is_data_bbio(bbio))
+	if (bio_op(&bbio->bio) == REQ_OP_READ && is_data_bbio(bbio))
 		btrfs_check_read_bio(bbio, bbio->bio.bi_private);
 	else
 		btrfs_bio_end_io(bbio, bbio->bio.bi_status);
@@ -351,7 +351,7 @@ static void btrfs_simple_end_io(struct bio *bio)
 	if (bio->bi_status)
 		btrfs_log_dev_io_error(bio, dev);
 
-	if (bio_op(bio) == REQ_OP_READ) {
+	if (bio_op(bio) == REQ_OP_READ || bbio->uncached_io) {
 		INIT_WORK(&bbio->end_io_work, btrfs_end_bio_work);
 		queue_work(btrfs_end_io_wq(fs_info, bio), &bbio->end_io_work);
 	} else {
diff --git a/fs/btrfs/bio.h b/fs/btrfs/bio.h
index e2fe16074ad6..39b98326c98f 100644
--- a/fs/btrfs/bio.h
+++ b/fs/btrfs/bio.h
@@ -82,6 +82,8 @@ struct btrfs_bio {
 	/* Save the first error status of split bio. */
 	blk_status_t status;
 
+	bool uncached_io;
+
 	/*
 	 * This member must come last, bio_alloc_bioset will allocate enough
 	 * bytes for entire btrfs_bio but relies on bio being last.
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 872cca54cc6c..b97b21178ed7 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -760,8 +760,11 @@ static void submit_extent_folio(struct btrfs_bio_ctrl *bio_ctrl,
 	ASSERT(bio_ctrl->end_io_func);
 
 	if (bio_ctrl->bbio &&
-	    !btrfs_bio_is_contig(bio_ctrl, folio, disk_bytenr, pg_offset))
+	    !btrfs_bio_is_contig(bio_ctrl, folio, disk_bytenr, pg_offset)) {
+		if (folio_test_uncached(folio))
+			bio_ctrl->bbio->uncached_io = true;
 		submit_one_bio(bio_ctrl);
+	}
 
 	do {
 		u32 len = size;
@@ -779,6 +782,9 @@ static void submit_extent_folio(struct btrfs_bio_ctrl *bio_ctrl,
 			len = bio_ctrl->len_to_oe_boundary;
 		}
 
+		if (folio_test_uncached(folio))
+			bio_ctrl->bbio->uncached_io = true;
+
 		if (!bio_add_folio(&bio_ctrl->bbio->bio, folio, len, pg_offset)) {
 			/* bio full: move on to a new one */
 			submit_one_bio(bio_ctrl);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 4fb521d91b06..a27d194a28e0 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -919,7 +919,7 @@ static gfp_t get_prepare_gfp_flags(struct inode *inode, bool nowait)
 static noinline int prepare_pages(struct inode *inode, struct page **pages,
 				  size_t num_pages, loff_t pos,
 				  size_t write_bytes, bool force_uptodate,
-				  bool nowait)
+				  bool nowait, bool uncached)
 {
 	int i;
 	unsigned long index = pos >> PAGE_SHIFT;
@@ -928,6 +928,8 @@ static noinline int prepare_pages(struct inode *inode, struct page **pages,
 	int ret = 0;
 	int faili;
 
+	if (uncached)
+		fgp_flags |= FGP_UNCACHED;
 	for (i = 0; i < num_pages; i++) {
 again:
 		pages[i] = pagecache_get_page(inode->i_mapping, index + i,
@@ -1323,7 +1325,8 @@ ssize_t btrfs_buffered_write(struct kiocb *iocb, struct iov_iter *i)
 		 * contents of pages from loop to loop
 		 */
 		ret = prepare_pages(inode, pages, num_pages,
-				    pos, write_bytes, force_page_uptodate, false);
+				    pos, write_bytes, force_page_uptodate,
+				    false, iocb->ki_flags & IOCB_UNCACHED);
 		if (ret) {
 			btrfs_delalloc_release_extents(BTRFS_I(inode),
 						       reserve_bytes);
@@ -1512,6 +1515,7 @@ ssize_t btrfs_do_write_iter(struct kiocb *iocb, struct iov_iter *from,
 	btrfs_set_inode_last_sub_trans(inode);
 
 	if (num_sync > 0) {
+		generic_uncached_write(iocb, num_sync);
 		num_sync = generic_write_sync(iocb, num_sync);
 		if (num_sync < 0)
 			num_written = num_sync;
@@ -3802,7 +3806,7 @@ const struct file_operations btrfs_file_operations = {
 	.compat_ioctl	= btrfs_compat_ioctl,
 #endif
 	.remap_file_range = btrfs_remap_file_range,
-	.fop_flags	= FOP_BUFFER_RASYNC | FOP_BUFFER_WASYNC,
+	.fop_flags	= FOP_BUFFER_RASYNC | FOP_BUFFER_WASYNC | FOP_UNCACHED,
 };
 
 int btrfs_fdatawrite_range(struct btrfs_inode *inode, loff_t start, loff_t end)
-- 
2.45.2


