Return-Path: <linux-xfs+bounces-14327-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AED49A2C8C
	for <lists+linux-xfs@lfdr.de>; Thu, 17 Oct 2024 20:50:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9D5671C20B13
	for <lists+linux-xfs@lfdr.de>; Thu, 17 Oct 2024 18:50:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDA7820CCE9;
	Thu, 17 Oct 2024 18:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TADQfQqj"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C21F20100C
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 18:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729191040; cv=none; b=J5zYBpEssw/Kc/E5boSVSclI7M42489YBv2EWJHvA+jXgRGqYkk2tpKO3Sve6IZavoh7b52LRLLWPULf15cpSW9BHyUwvSMhlhayMDMvhu2FsQzL4mIeRWn2wfVCr8oeR5X4VXSIwQHGF/IFl5qCGs980BUreYrLwiECfx8Pgs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729191040; c=relaxed/simple;
	bh=8u+KfXJ4FOWSxmRRQYe5LP0hs2gxBHxRVTvv7ga+frk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FyBe6YB8smnahdr28KHI3VlOpXjxg6so6oXHzYmvCF9VpN/6mqX0VAUwIaxpaACAXZ9t0z5LjkL3MZtJD7pKCNeUrElJn6iF8dsgrzLdorxeX/tp+zERkhjcUqAnv93Gr9gJrjBtY1As9y70QptEYIM0HIbahHoHqOC8s9ZAHaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TADQfQqj; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDD5AC4CEC3;
	Thu, 17 Oct 2024 18:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729191040;
	bh=8u+KfXJ4FOWSxmRRQYe5LP0hs2gxBHxRVTvv7ga+frk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=TADQfQqjHTACmJydILbhxBsMoFgOwwweTpGwqu3857HGvBIh3hcyeWfIcYM6jCeKU
	 avems3EaH2RnZJk6Z4UsIBLKlUMgM5+nY5KupakAlC2rC2V9aDLMotmqPP3/LNp/8R
	 9pFaZdxmtXbHjYh817a/HA5zP8tcrtpKzoK/etzJ24kqgyQoujDN4hQTSxzmoRO77w
	 PV0e9bgQynUYj94kjpFGrs8YByN7DjQ7wddzBP1ZMm/8sYBY3XhSVvP9Nox/leOf5d
	 4QLpBnFTr7faWF5jhnv03LswccAu82ljYBwVXx6oidmbrighbl3p8Vf8VSoYowSpbv
	 09uolynUXMSfA==
Date: Thu, 17 Oct 2024 11:50:39 -0700
Subject: [PATCH 16/22] xfs: pass the iunlink item to the
 xfs_iunlink_update_dinode trace point
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919068137.3449971.11233477574385154117.stgit@frogsfrogsfrogs>
In-Reply-To: <172919067797.3449971.379113456204553803.stgit@frogsfrogsfrogs>
References: <172919067797.3449971.379113456204553803.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

So that decoding is only done when tracing is actually enabled and the
call site look a lot neater.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_iunlink_item.c |   13 ++++++-------
 fs/xfs/xfs_trace.c        |    1 +
 fs/xfs/xfs_trace.h        |   15 ++++++++-------
 3 files changed, 15 insertions(+), 14 deletions(-)


diff --git a/fs/xfs/xfs_iunlink_item.c b/fs/xfs/xfs_iunlink_item.c
index 2ddccb172fa013..1fd70a7aed6347 100644
--- a/fs/xfs/xfs_iunlink_item.c
+++ b/fs/xfs/xfs_iunlink_item.c
@@ -52,14 +52,14 @@ xfs_iunlink_log_dinode(
 	struct xfs_trans	*tp,
 	struct xfs_iunlink_item	*iup)
 {
-	struct xfs_mount	*mp = tp->t_mountp;
 	struct xfs_inode	*ip = iup->ip;
 	struct xfs_dinode	*dip;
 	struct xfs_buf		*ibp;
+	xfs_agino_t		old_ptr;
 	int			offset;
 	int			error;
 
-	error = xfs_imap_to_bp(mp, tp, &ip->i_imap, &ibp);
+	error = xfs_imap_to_bp(tp->t_mountp, tp, &ip->i_imap, &ibp);
 	if (error)
 		return error;
 	/*
@@ -73,22 +73,21 @@ xfs_iunlink_log_dinode(
 	dip = xfs_buf_offset(ibp, ip->i_imap.im_boffset);
 
 	/* Make sure the old pointer isn't garbage. */
-	if (be32_to_cpu(dip->di_next_unlinked) != iup->old_agino) {
+	old_ptr = be32_to_cpu(dip->di_next_unlinked);
+	if (old_ptr != iup->old_agino) {
 		xfs_inode_verifier_error(ip, -EFSCORRUPTED, __func__, dip,
 				sizeof(*dip), __this_address);
 		error = -EFSCORRUPTED;
 		goto out;
 	}
 
-	trace_xfs_iunlink_update_dinode(mp, iup->pag->pag_agno,
-			XFS_INO_TO_AGINO(mp, ip->i_ino),
-			be32_to_cpu(dip->di_next_unlinked), iup->next_agino);
+	trace_xfs_iunlink_update_dinode(iup, old_ptr);
 
 	dip->di_next_unlinked = cpu_to_be32(iup->next_agino);
 	offset = ip->i_imap.im_boffset +
 			offsetof(struct xfs_dinode, di_next_unlinked);
 
-	xfs_dinode_calc_crc(mp, dip);
+	xfs_dinode_calc_crc(tp->t_mountp, dip);
 	xfs_trans_inode_buf(tp, ibp);
 	xfs_trans_log_buf(tp, ibp, offset, offset + sizeof(xfs_agino_t) - 1);
 	return 0;
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index 2af9f274e8724e..7ef50107224647 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -32,6 +32,7 @@
 #include "xfs_fsmap.h"
 #include "xfs_btree_staging.h"
 #include "xfs_icache.h"
+#include "xfs_iunlink_item.h"
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
 #include "xfs_error.h"
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 43cc59bdf1c31e..c4a8c259428aba 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -74,6 +74,7 @@ struct xfs_refcount_irec;
 struct xfs_fsmap;
 struct xfs_rmap_irec;
 struct xfs_icreate_log;
+struct xfs_iunlink_item;
 struct xfs_owner_info;
 struct xfs_trans_res;
 struct xfs_inobt_rec_incore;
@@ -4060,9 +4061,8 @@ TRACE_EVENT(xfs_iunlink_update_bucket,
 );
 
 TRACE_EVENT(xfs_iunlink_update_dinode,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, xfs_agino_t agino,
-		 xfs_agino_t old_ptr, xfs_agino_t new_ptr),
-	TP_ARGS(mp, agno, agino, old_ptr, new_ptr),
+	TP_PROTO(const struct xfs_iunlink_item *iup, xfs_agino_t old_ptr),
+	TP_ARGS(iup, old_ptr),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
@@ -4071,11 +4071,12 @@ TRACE_EVENT(xfs_iunlink_update_dinode,
 		__field(xfs_agino_t, new_ptr)
 	),
 	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
-		__entry->agino = agino;
+		__entry->dev = iup->pag->pag_mount->m_super->s_dev;
+		__entry->agno = iup->pag->pag_agno;
+		__entry->agino =
+			XFS_INO_TO_AGINO(iup->ip->i_mount, iup->ip->i_ino);
 		__entry->old_ptr = old_ptr;
-		__entry->new_ptr = new_ptr;
+		__entry->new_ptr = iup->next_agino;
 	),
 	TP_printk("dev %d:%d agno 0x%x agino 0x%x old 0x%x new 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),


