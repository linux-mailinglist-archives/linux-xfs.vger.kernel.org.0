Return-Path: <linux-xfs+bounces-200-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1579E7FC552
	for <lists+linux-xfs@lfdr.de>; Tue, 28 Nov 2023 21:26:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 466E91C20F6E
	for <lists+linux-xfs@lfdr.de>; Tue, 28 Nov 2023 20:26:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A7C24F882;
	Tue, 28 Nov 2023 20:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EioyYD9b"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC323D0DC
	for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2023 20:26:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3472C433C8;
	Tue, 28 Nov 2023 20:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701203195;
	bh=PHtuiry7mdDZoTjtQB6Di+gRio2d6OjydQKXEip/K0k=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=EioyYD9b/MM9XNBn4lQ0NExVfeqt20PeNtssyWf1xVfN9GaBrDKk0kEtqiCUjLr0k
	 SQyFbskXcgUAMu6ijQEVGrbJ/D5xdfm5a2k/vw3j9m9QiA4Rns7R6ubYrj89ZZsbA/
	 vHyT8EyuvQ/pyLRCdfcg/XOQT0FMY5jpKT1AeMYtZBs8OAAmn+4w2CouC8qJg6IVPM
	 F33t0oqJUMinJWpcVH7dpMvXWPhHf5CD3O7pacTKfFR6/LW+GJRuTteapwPKRLdEHy
	 VBD9HarmgMy0g9gDNjSEFRzi+gf+AaEtgfWAQrvuewI24iUdy/Y0yGLTXg5XGbLwBy
	 ojtsKdck0NhnQ==
Subject: [PATCH 1/7] xfs: don't leak recovered attri intent items
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, leo.lilong@huawei.com, chandanbabu@kernel.org,
 hch@lst.de
Cc: linux-xfs@vger.kernel.org
Date: Tue, 28 Nov 2023 12:26:34 -0800
Message-ID: <170120319438.13206.6231336717299702762.stgit@frogsfrogsfrogs>
In-Reply-To: <170120318847.13206.17051442307252477333.stgit@frogsfrogsfrogs>
References: <170120318847.13206.17051442307252477333.stgit@frogsfrogsfrogs>
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

If recovery finds an xattr log intent item calling for the removal of an
attribute and the file doesn't even have an attr fork, we know that the
removal is trivially complete.  However, we can't just exit the recovery
function without doing something about the recovered log intent item --
it's still on the AIL, and not logging an attrd item means it stays
there forever.

This has likely not been seen in practice because few people use LARP
and the runtime code won't log the attri for a no-attrfork removexattr
operation.  But let's fix this anyway.

Also we shouldn't really be testing the attr fork presence until we've
taken the ILOCK, though this doesn't matter much in recovery, which is
single threaded.

Fixes: fdaf1bb3cafc ("xfs: ATTR_REPLACE algorithm with LARP enabled needs rework")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_attr_item.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 36fe2abb16e6..11e88a76a33c 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -329,6 +329,13 @@ xfs_xattri_finish_update(
 		goto out;
 	}
 
+	/* If an attr removal is trivially complete, we're done. */
+	if (attr->xattri_op_flags == XFS_ATTRI_OP_FLAGS_REMOVE &&
+	    !xfs_inode_hasattr(args->dp)) {
+		error = 0;
+		goto out;
+	}
+
 	error = xfs_attr_set_iter(attr);
 	if (!error && attr->xattri_dela_state != XFS_DAS_DONE)
 		error = -EAGAIN;
@@ -608,8 +615,6 @@ xfs_attri_item_recover(
 			attr->xattri_dela_state = xfs_attr_init_add_state(args);
 		break;
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
-		if (!xfs_inode_hasattr(args->dp))
-			goto out;
 		attr->xattri_dela_state = xfs_attr_init_remove_state(args);
 		break;
 	default:


