Return-Path: <linux-xfs+bounces-7081-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F27B8A8DBD
	for <lists+linux-xfs@lfdr.de>; Wed, 17 Apr 2024 23:21:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6FD60B21EE8
	for <lists+linux-xfs@lfdr.de>; Wed, 17 Apr 2024 21:21:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DCB2262A3;
	Wed, 17 Apr 2024 21:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tfRroVmA"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC584AEED
	for <linux-xfs@vger.kernel.org>; Wed, 17 Apr 2024 21:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713388907; cv=none; b=drSZXJc5wXLcPhDCm45ME7saGj71WhQc/PSmEfSdpgzVr1H2Emc553tNBcIp7YALBI9yRMemLxgEjq54g1dOMI2swOJEG21GC7iEfMPlTFYuOwkXVOGoi76Ll2QbYwzt2/65uABFFrO25TqrJo8Y5XrviLyqbjfYqTh7t2OOlyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713388907; c=relaxed/simple;
	bh=R7okSxMc71pCS3Ojkzk8DVSE4ORwJxsEi0BKACD2G3E=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PCeNiAdeIjtuoogVGUb7/ikkDE71NMn49/0PxlfsKF37WRdbpyx9c0PfkLRCeCpglofS4LCtJPLmcA7A+ONGofvWGqOdu7H107LBBq0oMHAu+whZLS72m6q4eLjnE9Nmzk5WtL8o8KxkmH9wVsqExae9mJJmaGiDkPR6iUwxw2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tfRroVmA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A05C6C072AA;
	Wed, 17 Apr 2024 21:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713388906;
	bh=R7okSxMc71pCS3Ojkzk8DVSE4ORwJxsEi0BKACD2G3E=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=tfRroVmANFccpfY734cXMpzMGJEiTPkUAyMvLcLn0I18XWakUilJlM8PKK8Kcy/Jd
	 xkJHw/X5lQYH5OVRFgM/V5E3mgiNT27Y0hnBOtwr1lxl4Y522OnwO/q3U5Fc3gRy4E
	 yOsTts0NeLjv+3SnQN8sc+mM6CIYCN61Hro/smae8iG2uNs79sdjaYDZtAjNNKQd7H
	 B/qs0AuBN++1Xxn3XCCHdmAD9QNgIaWxvCcf3dYK5lDkwtXFT15G5MsuPk0s9+0IEM
	 ohSKWDfoHW9dO+ofkIhYKcmK45vkv8nnQR8J3KPLgIyaKDGCxmaL5iQN0hoQd7Rw06
	 f9XWpGz5NqyUw==
Date: Wed, 17 Apr 2024 14:21:46 -0700
Subject: [PATCH 11/11] xfs_{db,repair}: use m_blockwsize instead of
 sb_blocksize for rt blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Bill O'Donnell <bodonnel@redhat.com>,
 linux-xfs@vger.kernel.org
Message-ID: <171338841902.1853034.10525243879133638569.stgit@frogsfrogsfrogs>
In-Reply-To: <171338841726.1853034.8225385129852277375.stgit@frogsfrogsfrogs>
References: <171338841726.1853034.8225385129852277375.stgit@frogsfrogsfrogs>
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
index 103ea4022..2f2fbc7cb 100644
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
index 0818ee1a1..fcb26d594 100644
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
index 9aff5a0d3..e49487829 100644
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
 


