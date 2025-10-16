Return-Path: <linux-xfs+bounces-26580-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id CFA2FBE524D
	for <lists+linux-xfs@lfdr.de>; Thu, 16 Oct 2025 20:59:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 26DF8504541
	for <lists+linux-xfs@lfdr.de>; Thu, 16 Oct 2025 18:59:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4753523D7F2;
	Thu, 16 Oct 2025 18:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DtCaFzIx"
X-Original-To: linux-xfs@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE2D24635E
	for <linux-xfs@vger.kernel.org>; Thu, 16 Oct 2025 18:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760641133; cv=none; b=Gq0ZkQ7LHynHjMeh8sWaRi/ZuEyQIXfJTs8bGkLX/5YJymgxOoqxBUXHr5JilzWwfhPmC/5gJyW84JhQ6NSQ1L5ri5fV7EQUh5KNd6yHX5CNeGU/rtqSPICRa4zUs8VX4vy6rmCuxMTsw8EkUfsiIPemCj3YozbEfo+9i9w24p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760641133; c=relaxed/simple;
	bh=6NJrRzDp5IK26dGWoriEBUGl1eTuI74ZeJlMUfd+cck=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gucmnlhnQ7xGCYgumDbguPVo53brl3wLDe3N/vOpfdGUaAvjByXUmajIVNuTiFXOJJJNLHSKMoolkWMfZvP8ea8xI2CPiU3Bth+uXQwedbvKs9IgDIZpFONO+dGAzfn0FIXSXeYeoShZzkodT3Wy93bED8ldJEhgXeRHYpdpwVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DtCaFzIx; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760641130;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VUxrKxfE77KdZKUJSbkP2w8yFObJwGuldF4u+RV6K08=;
	b=DtCaFzIxKKDgr8vJWeJnmTDYUKaRwBGaVRhYt8wY3RMJTgbMF3Yhyr+rSMMY8LLWjw23Nk
	XFVrhjMDdEgxyelHKgO61zXtndtNg79HySQicijxJxLL57twCPuVRtJNtmMI710zVkUF4n
	g/nxzgPwuWsJR9+x09Kzx5Avz81oyeQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-516-M4qzTMX8P7yYj4wRM4pc0w-1; Thu,
 16 Oct 2025 14:58:48 -0400
X-MC-Unique: M4qzTMX8P7yYj4wRM4pc0w-1
X-Mimecast-MFC-AGG-ID: M4qzTMX8P7yYj4wRM4pc0w_1760641127
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B66E3180122A;
	Thu, 16 Oct 2025 18:58:47 +0000 (UTC)
Received: from bfoster.redhat.com (unknown [10.22.65.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 35E711956056;
	Thu, 16 Oct 2025 18:58:47 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
To: linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 5/6] xfs: only flush when COW fork blocks overlap data fork holes
Date: Thu, 16 Oct 2025 15:03:02 -0400
Message-ID: <20251016190303.53881-6-bfoster@redhat.com>
In-Reply-To: <20251016190303.53881-1-bfoster@redhat.com>
References: <20251016190303.53881-1-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

The zero range hole mapping flush case has been lifted from iomap
into XFS. Now that we have more mapping context available from the
->iomap_begin() handler, we can isolate the flush further to when we
know a hole is fronted by COW blocks.

Rather than purely rely on pagecache dirty state, explicitly check
for the case where a range is a hole in both forks. Otherwise trim
to the range where there does happen to be overlap and use that for
the pagecache writeback check. This might prevent some spurious
zeroing, but more importantly makes it easier to remove the flush
entirely.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_iomap.c | 36 ++++++++++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index ba5697d8b8fd..29f1462819fa 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1704,10 +1704,12 @@ xfs_buffered_write_iomap_begin(
 {
 	struct iomap_iter	*iter = container_of(iomap, struct iomap_iter,
 						     iomap);
+	struct address_space	*mapping = inode->i_mapping;
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
 	xfs_fileoff_t		offset_fsb = XFS_B_TO_FSBT(mp, offset);
 	xfs_fileoff_t		end_fsb = xfs_iomap_end_fsb(mp, offset, count);
+	xfs_fileoff_t		cow_fsb = NULLFILEOFF;
 	struct xfs_bmbt_irec	imap, cmap;
 	struct xfs_iext_cursor	icur, ccur;
 	xfs_fsblock_t		prealloc_blocks = 0;
@@ -1775,6 +1777,8 @@ xfs_buffered_write_iomap_begin(
 		}
 		cow_eof = !xfs_iext_lookup_extent(ip, ip->i_cowfp, offset_fsb,
 				&ccur, &cmap);
+		if (!cow_eof)
+			cow_fsb = cmap.br_startoff;
 	}
 
 	/* We never need to allocate blocks for unsharing a hole. */
@@ -1789,17 +1793,37 @@ xfs_buffered_write_iomap_begin(
 	 * writeback to remap pending blocks and restart the lookup.
 	 */
 	if ((flags & IOMAP_ZERO) && imap.br_startoff > offset_fsb) {
-		if (filemap_range_needs_writeback(inode->i_mapping, offset,
-						  offset + count - 1)) {
+		loff_t start, end;
+
+		imap.br_blockcount = imap.br_startoff - offset_fsb;
+		imap.br_startoff = offset_fsb;
+		imap.br_startblock = HOLESTARTBLOCK;
+		imap.br_state = XFS_EXT_NORM;
+
+		if (cow_fsb == NULLFILEOFF) {
+			goto found_imap;
+		} else if (cow_fsb > offset_fsb) {
+			xfs_trim_extent(&imap, offset_fsb,
+					cow_fsb - offset_fsb);
+			goto found_imap;
+		}
+
+		/* COW fork blocks overlap the hole */
+		xfs_trim_extent(&imap, offset_fsb,
+			    cmap.br_startoff + cmap.br_blockcount - offset_fsb);
+		start = XFS_FSB_TO_B(mp, imap.br_startoff);
+		end = XFS_FSB_TO_B(mp,
+				   imap.br_startoff + imap.br_blockcount) - 1;
+		if (filemap_range_needs_writeback(mapping, start, end)) {
 			xfs_iunlock(ip, lockmode);
-			error = filemap_write_and_wait_range(inode->i_mapping,
-						offset, offset + count - 1);
+			error = filemap_write_and_wait_range(mapping, start,
+							     end);
 			if (error)
 				return error;
 			goto restart;
 		}
-		xfs_hole_to_iomap(ip, iomap, offset_fsb, imap.br_startoff);
-		goto out_unlock;
+
+		goto found_imap;
 	}
 
 	/*
-- 
2.51.0


