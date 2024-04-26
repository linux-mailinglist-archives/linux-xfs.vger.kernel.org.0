Return-Path: <linux-xfs+bounces-7682-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 662A18B4192
	for <lists+linux-xfs@lfdr.de>; Fri, 26 Apr 2024 23:56:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 852991C217A3
	for <lists+linux-xfs@lfdr.de>; Fri, 26 Apr 2024 21:56:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EA02381B9;
	Fri, 26 Apr 2024 21:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ckNFz/uC"
X-Original-To: linux-xfs@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA99136B17
	for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2024 21:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714168555; cv=none; b=ppU+prvXw4luY4XA6DBVukVtCpWn6xzEUZeD2M1h7jdtfM83nUXUTZ8KpNrnFb7ba/aHNYzJWqGXk95fcPsklE4D52QUFd90uyhii5BA1S20mIfidCTqt/Qt8gMi9W+AqAmQ+FoOQihfeT6W8dCS7tMdJ1z3G4pMpV8kT4UP4+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714168555; c=relaxed/simple;
	bh=74EzXvfodK2An85RkrYsBhDKHl5q9eYnM26iOYPOG0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HA9gXuQJY0NNZdp0mEAWLYXyX5mvOddf/ruWXBg6zfbLP7i4dVmyXI0GVzJEsACzNgwSVyWx+L4F2xJjHgPxsArXBwLugPnJ5jCA5siuedTY5cgbbULlCr9vGRFXJljqJraxYNrCWcDHuzfPF0rBXfmK64rlPxe0R31au8Zrskc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ckNFz/uC; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1e834159f40so21421105ad.2
        for <linux-xfs@vger.kernel.org>; Fri, 26 Apr 2024 14:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714168553; x=1714773353; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w8EuxZb9dTO7XxZLYwYupZsuh/2kwnjPPgB5uiKl14w=;
        b=ckNFz/uCbb96An0S9A0thuVncjYZU7Whp6+xbpkKm95AdjGJBgdzXNcLm9TXXJXTGu
         gSugkJq7wHEaxgTIfY1ckOnwDSaYHg3f6hGGZjKi2Bo0ddDZs5BDzDq+SEwbeTqzSF+s
         zYQlH7wvJjb1U1UafNOGvQOWbqX4DCRz2ZBcbjtXojE81u96qkCmdPIyVL6aD8M/UZ4a
         mkl983bilj8ie43hBEunfqEk7qAkdXOLcA3NFK8zIpnV2J5xW+0X5Cu4CG/MbrBtGpNU
         4gotPECPAGq62FZHrwYmXzTRZvAn6MOKLOrFaEpCQhjj2uevyhtEQu9QZHBWHhHcLQ9q
         eTXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714168553; x=1714773353;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w8EuxZb9dTO7XxZLYwYupZsuh/2kwnjPPgB5uiKl14w=;
        b=sw9bPCMlWE0xz/0XWi7T7Sn+hFClgMUlghnwhVwQVuoyvkWVDQgxxT572l827Dl+5t
         1kkXkHHkkLcfhKaNjWzIdnninUruEY8i7eZVhec3XyJCsLVpp0jMD20HWEwu6zLZKuAr
         wiIyUr/xLE7csCGPTOxfWuznVVngg+qkrmKC8CTT/C0wjvkKZlawPHhb8vD+eDirqOXp
         9aLmajyy2qRxrFEjQf/trF/HP8P8U4RZhfg4d46Fq7aQbhI2kXnRpfTlq//HZXZ82nmU
         2KiffcTaHbipxzmRKKsZP7Jk34IQ/5GD+O8ACujDxEy1u7akjE3hiGWpwf0sXubixgGR
         8qog==
X-Gm-Message-State: AOJu0Yz9qZbGUP4tZoJ+GD16f6hxxEV1rnNJP1lYFbAGGUmkI0WfJdls
	vDSyaWQ8BK335qvKlT2KMqDsnAyDCbRcHUMf1GRKgEErzhK7ZSTv4DTT4IjW
X-Google-Smtp-Source: AGHT+IHEPEXaRGpLJhlQeH2FmNE3T+ufVOqYqPUWlw6XBf6eLZDeI87tuRmtmzoockMv2CoMYsojMA==
X-Received: by 2002:a17:902:eec1:b0:1e9:1f39:2edb with SMTP id h1-20020a170902eec100b001e91f392edbmr3859575plb.26.1714168552913;
        Fri, 26 Apr 2024 14:55:52 -0700 (PDT)
Received: from lrumancik.svl.corp.google.com ([2620:15c:2a3:200:2b3a:c37d:d273:a588])
        by smtp.gmail.com with ESMTPSA id b18-20020a170903229200b001eb2e6b14e0sm855772plh.126.2024.04.26.14.55.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Apr 2024 14:55:52 -0700 (PDT)
From: Leah Rumancik <leah.rumancik@gmail.com>
To: linux-xfs@vger.kernel.org
Cc: amir73il@gmail.com,
	chandan.babu@oracle.com,
	fred@cloudflare.com,
	mngyadam@amazon.com,
	Dave Chinner <dchinner@redhat.com>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Leah Rumancik <leah.rumancik@gmail.com>
Subject: [PATCH 6.1 CANDIDATE 04/24] xfs,iomap: move delalloc punching to iomap
Date: Fri, 26 Apr 2024 14:54:51 -0700
Message-ID: <20240426215512.2673806-5-leah.rumancik@gmail.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
In-Reply-To: <20240426215512.2673806-1-leah.rumancik@gmail.com>
References: <20240426215512.2673806-1-leah.rumancik@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

[ Upstream commit 9c7babf94a0d686b552e53aded8d4703d1b8b92b ]

Because that's what Christoph wants for this error handling path
only XFS uses.

It requires a new iomap export for handling errors over delalloc
ranges. This is basically the XFS code as is stands, but even though
Christoph wants this as iomap funcitonality, we still have
to call it from the filesystem specific ->iomap_end callback, and
call into the iomap code with yet another filesystem specific
callback to punch the delalloc extent within the defined ranges.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
---
 fs/iomap/buffered-io.c | 60 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_iomap.c     | 47 ++++++---------------------------
 include/linux/iomap.h  |  4 +++
 3 files changed, 72 insertions(+), 39 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index a0a4d8de82ca..24be3297822b 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -827,6 +827,66 @@ iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *i,
 }
 EXPORT_SYMBOL_GPL(iomap_file_buffered_write);
 
+/*
+ * When a short write occurs, the filesystem may need to remove reserved space
+ * that was allocated in ->iomap_begin from it's ->iomap_end method. For
+ * filesystems that use delayed allocation, we need to punch out delalloc
+ * extents from the range that are not dirty in the page cache. As the write can
+ * race with page faults, there can be dirty pages over the delalloc extent
+ * outside the range of a short write but still within the delalloc extent
+ * allocated for this iomap.
+ *
+ * This function uses [start_byte, end_byte) intervals (i.e. open ended) to
+ * simplify range iterations, but converts them back to {offset,len} tuples for
+ * the punch callback.
+ */
+int iomap_file_buffered_write_punch_delalloc(struct inode *inode,
+		struct iomap *iomap, loff_t pos, loff_t length,
+		ssize_t written,
+		int (*punch)(struct inode *inode, loff_t pos, loff_t length))
+{
+	loff_t			start_byte;
+	loff_t			end_byte;
+	int			blocksize = i_blocksize(inode);
+	int			error = 0;
+
+	if (iomap->type != IOMAP_DELALLOC)
+		return 0;
+
+	/* If we didn't reserve the blocks, we're not allowed to punch them. */
+	if (!(iomap->flags & IOMAP_F_NEW))
+		return 0;
+
+	/*
+	 * start_byte refers to the first unused block after a short write. If
+	 * nothing was written, round offset down to point at the first block in
+	 * the range.
+	 */
+	if (unlikely(!written))
+		start_byte = round_down(pos, blocksize);
+	else
+		start_byte = round_up(pos + written, blocksize);
+	end_byte = round_up(pos + length, blocksize);
+
+	/* Nothing to do if we've written the entire delalloc extent */
+	if (start_byte >= end_byte)
+		return 0;
+
+	/*
+	 * Lock the mapping to avoid races with page faults re-instantiating
+	 * folios and dirtying them via ->page_mkwrite between the page cache
+	 * truncation and the delalloc extent removal. Failing to do this can
+	 * leave dirty pages with no space reservation in the cache.
+	 */
+	filemap_invalidate_lock(inode->i_mapping);
+	truncate_pagecache_range(inode, start_byte, end_byte - 1);
+	error = punch(inode, start_byte, end_byte - start_byte);
+	filemap_invalidate_unlock(inode->i_mapping);
+
+	return error;
+}
+EXPORT_SYMBOL_GPL(iomap_file_buffered_write_punch_delalloc);
+
 static loff_t iomap_unshare_iter(struct iomap_iter *iter)
 {
 	struct iomap *iomap = &iter->iomap;
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 7bb55dbc19d3..ea96e8a34868 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1123,12 +1123,12 @@ xfs_buffered_write_iomap_begin(
 static int
 xfs_buffered_write_delalloc_punch(
 	struct inode		*inode,
-	loff_t			start_byte,
-	loff_t			end_byte)
+	loff_t			offset,
+	loff_t			length)
 {
 	struct xfs_mount	*mp = XFS_M(inode->i_sb);
-	xfs_fileoff_t		start_fsb = XFS_B_TO_FSBT(mp, start_byte);
-	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, end_byte);
+	xfs_fileoff_t		start_fsb = XFS_B_TO_FSBT(mp, offset);
+	xfs_fileoff_t		end_fsb = XFS_B_TO_FSB(mp, offset + length);
 
 	return xfs_bmap_punch_delalloc_range(XFS_I(inode), start_fsb,
 				end_fsb - start_fsb);
@@ -1143,13 +1143,9 @@ xfs_buffered_write_iomap_end(
 	unsigned		flags,
 	struct iomap		*iomap)
 {
-	struct xfs_mount	*mp = XFS_M(inode->i_sb);
-	loff_t			start_byte;
-	loff_t			end_byte;
-	int			error = 0;
 
-	if (iomap->type != IOMAP_DELALLOC)
-		return 0;
+	struct xfs_mount	*mp = XFS_M(inode->i_sb);
+	int			error;
 
 	/*
 	 * Behave as if the write failed if drop writes is enabled. Set the NEW
@@ -1160,35 +1156,8 @@ xfs_buffered_write_iomap_end(
 		written = 0;
 	}
 
-	/* If we didn't reserve the blocks, we're not allowed to punch them. */
-	if (!(iomap->flags & IOMAP_F_NEW))
-		return 0;
-
-	/*
-	 * start_fsb refers to the first unused block after a short write. If
-	 * nothing was written, round offset down to point at the first block in
-	 * the range.
-	 */
-	if (unlikely(!written))
-		start_byte = round_down(offset, mp->m_sb.sb_blocksize);
-	else
-		start_byte = round_up(offset + written, mp->m_sb.sb_blocksize);
-	end_byte = round_up(offset + length, mp->m_sb.sb_blocksize);
-
-	/* Nothing to do if we've written the entire delalloc extent */
-	if (start_byte >= end_byte)
-		return 0;
-
-	/*
-	 * Lock the mapping to avoid races with page faults re-instantiating
-	 * folios and dirtying them via ->page_mkwrite between the page cache
-	 * truncation and the delalloc extent removal. Failing to do this can
-	 * leave dirty pages with no space reservation in the cache.
-	 */
-	filemap_invalidate_lock(inode->i_mapping);
-	truncate_pagecache_range(inode, start_byte, end_byte - 1);
-	error = xfs_buffered_write_delalloc_punch(inode, start_byte, end_byte);
-	filemap_invalidate_unlock(inode->i_mapping);
+	error = iomap_file_buffered_write_punch_delalloc(inode, iomap, offset,
+			length, written, &xfs_buffered_write_delalloc_punch);
 	if (error && !xfs_is_shutdown(mp)) {
 		xfs_alert(mp, "%s: unable to clean up ino 0x%llx",
 			__func__, XFS_I(inode)->i_ino);
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 238a03087e17..0698c4b8ce0e 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -226,6 +226,10 @@ static inline const struct iomap *iomap_iter_srcmap(const struct iomap_iter *i)
 
 ssize_t iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *from,
 		const struct iomap_ops *ops);
+int iomap_file_buffered_write_punch_delalloc(struct inode *inode,
+		struct iomap *iomap, loff_t pos, loff_t length, ssize_t written,
+		int (*punch)(struct inode *inode, loff_t pos, loff_t length));
+
 int iomap_read_folio(struct folio *folio, const struct iomap_ops *ops);
 void iomap_readahead(struct readahead_control *, const struct iomap_ops *ops);
 bool iomap_is_partially_uptodate(struct folio *, size_t from, size_t count);
-- 
2.44.0.769.g3c40516874-goog


