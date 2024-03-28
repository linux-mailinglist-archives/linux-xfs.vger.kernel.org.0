Return-Path: <linux-xfs+bounces-5522-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D00B988B7E3
	for <lists+linux-xfs@lfdr.de>; Tue, 26 Mar 2024 04:02:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C95D2C67D5
	for <lists+linux-xfs@lfdr.de>; Tue, 26 Mar 2024 03:02:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E13212838B;
	Tue, 26 Mar 2024 03:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rn2p1j4F"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F140412836A
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711422170; cv=none; b=su5MxPj7fVmYmrl0bDvjSh07kMz7imzz3mzC10SlkIqKUkvdWYeCCNHYPMtoiWUu2DLVjYmi7d0QMFcYosDn9Jeur0GjsXEr6Q0ApYKn7bbpXV/6WOZo0qn5XFvhfLGjxY2Y6X6RgSHNgN7w25jzB045MF4ZDsSASr00ApTZrLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711422170; c=relaxed/simple;
	bh=Cyd05sCYdUjl7zfTh9d5KROnXj706mNDnyGaPLioFg8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M+jNlx204+FbUSUvQimGw3D9uxYyOskQXmgFdEC8q0z+ImWs3/GhmHGjBrhdenZsoxaj7/ci0useumm4V5HzBXGOwNzD4RY07j48hqYXpHDqGbUwzL6AfjmlUkpPIwSQZO6G0A+XQfuQ+Keo6ImO8OA/wyLYQYNbHDsAwOO0B2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rn2p1j4F; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B45C433F1;
	Tue, 26 Mar 2024 03:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711422169;
	bh=Cyd05sCYdUjl7zfTh9d5KROnXj706mNDnyGaPLioFg8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Rn2p1j4FjzIAdLQM33g3yoVC2wVV4WV4w5EWWkAxfJrtqlJVpB3gWQWZR6x9Iewnp
	 2fuFBqcyHSanDG4SZJRzwt+l7cgS4Zm1AOQ4jSJQoTX9rZM+5yIFnifljjSgt7in7U
	 1cbGVwOuqDdUIkv9iDQzKy0cYRAdCjLM6PnxDsi5q16ILPuFXGgzlHHRcON+wJd+cd
	 pKUbXlc4OOTMVDadNaJvpYgZLX5a7dCfIyEJWLH4GCeMLJqX3DnC9Z/MGeWl16QWrQ
	 R10vZ1eBhvN+bFaQRzUiAOBogwfqpqS9HWdzRRKQhrvKJy99xuRlo4veRrVMr/Qwmo
	 Z1b4aJERakIvw==
Date: Mon, 25 Mar 2024 20:02:49 -0700
Subject: [PATCH 13/13] xfs_{db,repair}: use m_blockwsize instead of
 sb_blocksize for rt blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171142126495.2211955.12892140886978547219.stgit@frogsfrogsfrogs>
In-Reply-To: <171142126291.2211955.14829143192552278353.stgit@frogsfrogsfrogs>
References: <171142126291.2211955.14829143192552278353.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

In preparation to add block headers to rt bitmap and summary blocks,
convert all the relevant calculations in the userspace tools to use the
per-block word count instead of the raw blocksize.  This is key to
adding this support outside of libxfs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
---
 db/check.c      |    4 ++--
 repair/phase6.c |    4 ++--
 repair/rt.c     |    9 +++++----
 3 files changed, 9 insertions(+), 8 deletions(-)


diff --git a/db/check.c b/db/check.c
index 103ea4022c3b..2f2fbc7cbd81 100644
--- a/db/check.c
+++ b/db/check.c
@@ -3630,7 +3630,7 @@ process_rtbitmap(
 	int		t;
 	xfs_rtword_t	*words;
 
-	bitsperblock = mp->m_sb.sb_blocksize * NBBY;
+	bitsperblock = mp->m_blockwsize << XFS_NBWORDLOG;
 	words = malloc(mp->m_blockwsize << XFS_WORDLOG);
 	if (!words) {
 		dbprintf(_("could not allocate rtwords buffer\n"));
@@ -3749,7 +3749,7 @@ process_rtsummary(
 
 		args.sumbp = iocur_top->bp;
 		ondisk = xfs_rsumblock_infoptr(&args, 0);
-		memcpy(sfile, ondisk, mp->m_sb.sb_blocksize);
+		memcpy(sfile, ondisk, mp->m_blockwsize << XFS_WORDLOG);
 		pop_cur();
 		sfile += mp->m_blockwsize;
 	}
diff --git a/repair/phase6.c b/repair/phase6.c
index 0818ee1a1501..fcb26d594b10 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -626,7 +626,7 @@ _("can't access block %" PRIu64 " (fsbno %" PRIu64 ") of realtime bitmap inode %
 
 		args.rbmbp = bp;
 		ondisk = xfs_rbmblock_wordptr(&args, 0);
-		memcpy(ondisk, bmp, mp->m_sb.sb_blocksize);
+		memcpy(ondisk, bmp, mp->m_blockwsize << XFS_WORDLOG);
 
 		libxfs_trans_log_buf(tp, bp, 0, mp->m_sb.sb_blocksize - 1);
 
@@ -705,7 +705,7 @@ _("can't access block %" PRIu64 " (fsbno %" PRIu64 ") of realtime summary inode
 
 		args.sumbp = bp;
 		ondisk = xfs_rsumblock_infoptr(&args, 0);
-		memcpy(ondisk, smp, mp->m_sb.sb_blocksize);
+		memcpy(ondisk, smp, mp->m_blockwsize << XFS_WORDLOG);
 
 		libxfs_trans_log_buf(tp, bp, 0, mp->m_sb.sb_blocksize - 1);
 
diff --git a/repair/rt.c b/repair/rt.c
index 9aff5a0d3d58..e49487829af2 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -25,8 +25,9 @@ rtinit(xfs_mount_t *mp)
 		return;
 
 	/*
-	 * realtime init -- blockmap initialization is
-	 * handled by incore_init()
+	 * Allocate buffers for formatting the collected rt free space
+	 * information.  The rtbitmap buffer must be large enough to compare
+	 * against any unused bytes in the last block of the file.
 	 */
 	wordcnt = libxfs_rtbitmap_wordcount(mp, mp->m_sb.sb_rextents);
 	btmcompute = calloc(wordcnt, sizeof(union xfs_rtword_raw));
@@ -87,7 +88,7 @@ generate_rtinfo(
 
 	ASSERT(mp->m_rbmip == NULL);
 
-	bitsperblock = mp->m_sb.sb_blocksize * NBBY;
+	bitsperblock = mp->m_blockwsize << XFS_NBWORDLOG;
 	extno = start_ext = 0;
 	bmbno = in_extent = start_bmbno = 0;
 
@@ -199,7 +200,7 @@ check_rtfile_contents(
 			break;
 		}
 
-		if (memcmp(bp->b_addr, buf, mp->m_sb.sb_blocksize))
+		if (memcmp(bp->b_addr, buf, mp->m_blockwsize << XFS_WORDLOG))
 			do_warn(_("discrepancy in %s at dblock 0x%llx\n"),
 					filename, (unsigned long long)bno);
 


