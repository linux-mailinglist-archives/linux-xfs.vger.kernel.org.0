Return-Path: <linux-xfs+bounces-729-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 36E1A81222C
	for <lists+linux-xfs@lfdr.de>; Wed, 13 Dec 2023 23:57:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BAD6A2818CD
	for <lists+linux-xfs@lfdr.de>; Wed, 13 Dec 2023 22:57:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA81881856;
	Wed, 13 Dec 2023 22:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kh5XYsgx"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 872BB7FBD3
	for <linux-xfs@vger.kernel.org>; Wed, 13 Dec 2023 22:57:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59343C433C8;
	Wed, 13 Dec 2023 22:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702508231;
	bh=uUvJxBb0P58+ttoRABWvwl/7yARLY2xHgXnxRlD/CEQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kh5XYsgxwTGcOJorFML0SNBoQV+YNtuupGJiGnMzYkQWsTWoPUqzXwDKklxDTIgyL
	 p5T+GlrVkAycgzmTzfXkDQdknDezI8oR1OQ1YPF3/p0PG0AFQxdqnAneVv3buju2s0
	 NQtLULiTveCw8M3nosuFtbuvCy6VBKtFFTOsow9aRqx4BLzPX1/bpzY07Hi+30bFgy
	 bMa1twLcwsVvZZswu5q0F0A9+5D1pBLm7c1ENrG13UiCzFfzbbw1mVhpy14oYy56yt
	 9/nEI5TrXBVRXDiyq5Qw+YOnAVk0jBTtLAkG2/ORVMh/7Gz/5ASHNSbc2eRroSdyrQ
	 cFJ16WCti+xHw==
Date: Wed, 13 Dec 2023 14:57:10 -0800
Subject: [PATCH 1/4] xfs: check the ondisk space mapping behind a dquot
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, hch@lst.de, chandanbabu@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170250784355.1399626.10483147929754923168.stgit@frogsfrogsfrogs>
In-Reply-To: <170250784331.1399626.6539338084714476832.stgit@frogsfrogsfrogs>
References: <170250784331.1399626.6539338084714476832.stgit@frogsfrogsfrogs>
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

Each xfs_dquot object caches the file offset and daddr of the ondisk
block that backs the dquot.  Make sure these cached values are the same
as the bmapi data, and that the block state is written.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/quota.c |   58 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 58 insertions(+)


diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index 5671c8153433..59350cd7a325 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -6,6 +6,7 @@
 #include "xfs.h"
 #include "xfs_fs.h"
 #include "xfs_shared.h"
+#include "xfs_bit.h"
 #include "xfs_format.h"
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
@@ -75,6 +76,47 @@ struct xchk_quota_info {
 	xfs_dqid_t		last_id;
 };
 
+/* There's a written block backing this dquot, right? */
+STATIC int
+xchk_quota_item_bmap(
+	struct xfs_scrub	*sc,
+	struct xfs_dquot	*dq,
+	xfs_fileoff_t		offset)
+{
+	struct xfs_bmbt_irec	irec;
+	struct xfs_mount	*mp = sc->mp;
+	int			nmaps = 1;
+	int			error;
+
+	if (!xfs_verify_fileoff(mp, offset)) {
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
+		return 0;
+	}
+
+	if (dq->q_fileoffset != offset) {
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
+		return 0;
+	}
+
+	error = xfs_bmapi_read(sc->ip, offset, 1, &irec, &nmaps, 0);
+	if (error)
+		return error;
+
+	if (nmaps != 1) {
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
+		return 0;
+	}
+
+	if (!xfs_verify_fsbno(mp, irec.br_startblock))
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
+	if (XFS_FSB_TO_DADDR(mp, irec.br_startblock) != dq->q_blkno)
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
+	if (!xfs_bmap_is_written_extent(&irec))
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
+
+	return 0;
+}
+
 /* Scrub the fields in an individual quota item. */
 STATIC int
 xchk_quota_item(
@@ -93,6 +135,17 @@ xchk_quota_item(
 	if (xchk_should_terminate(sc, &error))
 		return error;
 
+	/*
+	 * We want to validate the bmap record for the storage backing this
+	 * dquot, so we need to lock the dquot and the quota file.  For quota
+	 * operations, the locking order is first the ILOCK and then the dquot.
+	 * However, dqiterate gave us a locked dquot, so drop the dquot lock to
+	 * get the ILOCK.
+	 */
+	xfs_dqunlock(dq);
+	xchk_ilock(sc, XFS_ILOCK_SHARED);
+	xfs_dqlock(dq);
+
 	/*
 	 * Except for the root dquot, the actual dquot we got must either have
 	 * the same or higher id as we saw before.
@@ -103,6 +156,11 @@ xchk_quota_item(
 
 	sqi->last_id = dq->q_id;
 
+	error = xchk_quota_item_bmap(sc, dq, offset);
+	xchk_iunlock(sc, XFS_ILOCK_SHARED);
+	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, offset, &error))
+		return error;
+
 	/*
 	 * Warn if the hard limits are larger than the fs.
 	 * Administrators can do this, though in production this seems


