Return-Path: <linux-xfs+bounces-4989-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6892D87B0AD
	for <lists+linux-xfs@lfdr.de>; Wed, 13 Mar 2024 19:59:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9A3C61C23256
	for <lists+linux-xfs@lfdr.de>; Wed, 13 Mar 2024 18:59:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A49E5A105;
	Wed, 13 Mar 2024 17:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZuiBDpvm"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA4D5A103;
	Wed, 13 Mar 2024 17:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710352746; cv=none; b=C6hqtUJ0D3e0ZzpBWhhso/meVx/XqlU1iUrriqbdMoml+99ppd5hWqJ1lPVj0qxP7afc41+2EUjP0xcVI2MUm6STw3ynzXgqfoOXanXqksNzkP73KqDJ6DytBMHQZi4W3w8RAahTvWA3taps+1Ncp9xrY+FYTDwb3yyDHcXMJdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710352746; c=relaxed/simple;
	bh=494y+3iuQlrODS2eWZyrS+vexwRjyUKAwpufvVwqiUw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=plTPVRj7FxhG00dxii3M2bEwLl2qMQMxl6IbBjiVWbVWboTOM0OAN63R04Bn9XWoTp3E/LIZP9LLIzX80pEPDFwTjrxxqOxvfo3Agooag/n/A0iq0/FLOSl1EwvivOQrSi751h7RnkuV1zfgfyJbeWplbbDgCxTg4t9c68N1JIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZuiBDpvm; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB632C43390;
	Wed, 13 Mar 2024 17:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710352745;
	bh=494y+3iuQlrODS2eWZyrS+vexwRjyUKAwpufvVwqiUw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZuiBDpvmBbndX8saE6/Vtv4H7ePrc7lZ/QtozgOMSbDT3yKBxHuzYKGhpe50IVR/V
	 r88K7EPiEAiqUdpacXtpWeqBpHjWDliKL4J038LtMRUHuqZ6pOlb2rXqxqH3rM2blN
	 ArGYYJ1twnZ0U21qcGXd9v3pJhDOcU8xso+obqwaqp3FI/v+UzMZh4mNsCB5rGFEGF
	 kzJn6+KhA+eWXhzkI1FrMYzd2QE0tA+GXVmxxhxDlvtHRT9JuZ3A6ZdOtcy19NqOMd
	 PFBmFKZYi8s1IZx0dQRkS5kXJ6K/huIAXHLz1q9UGyTeWCttMQsnk9oZ/BFzN5CAJD
	 MoVsJ1WatydYw==
Date: Wed, 13 Mar 2024 10:59:05 -0700
Subject: [PATCH 25/29] xfs: clean up stale fsverity metadata before starting
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@redhat.com, ebiggers@kernel.org
Cc: linux-fsdevel@vger.kernel.org, fsverity@lists.linux.dev,
 linux-xfs@vger.kernel.org
Message-ID: <171035223758.2613863.14784213448726046229.stgit@frogsfrogsfrogs>
In-Reply-To: <171035223299.2613863.12196197862413309469.stgit@frogsfrogsfrogs>
References: <171035223299.2613863.12196197862413309469.stgit@frogsfrogsfrogs>
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

Before we let fsverity begin writing merkle tree blocks to the file,
let's perform a minor effort to clean up any stale metadata from a
previous attempt to enable fsverity.  This can only happen if the system
crashes /and/ the file shrinks, which is unlikely.  But we could do a
better job of cleaning up anyway.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_verity.c |   42 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 40 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_verity.c b/fs/xfs/xfs_verity.c
index bb4ca8716c34..cfa50534bfc4 100644
--- a/fs/xfs/xfs_verity.c
+++ b/fs/xfs/xfs_verity.c
@@ -422,6 +422,44 @@ xfs_verity_get_descriptor(
 	return args.valuelen;
 }
 
+/*
+ * Clear out old fsverity metadata before we start building a new one.  This
+ * could happen if, say, we crashed while building fsverity data.
+ */
+static int
+xfs_verity_drop_old_metadata(
+	struct xfs_inode		*ip,
+	u64				new_tree_size,
+	unsigned int			tree_blocksize)
+{
+	struct xfs_fsverity_merkle_key	name;
+	struct xfs_da_args		args = {
+		.dp			= ip,
+		.whichfork		= XFS_ATTR_FORK,
+		.attr_filter		= XFS_ATTR_VERITY,
+		.op_flags		= XFS_DA_OP_REMOVE,
+		.name			= (const uint8_t *)&name,
+		.namelen		= sizeof(struct xfs_fsverity_merkle_key),
+		/* NULL value make xfs_attr_set remove the attr */
+		.value			= NULL,
+	};
+	u64				offset;
+	int				error = 0;
+
+	/*
+	 * Delete as many merkle tree blocks in increasing blkno order until we
+	 * don't find any more.  That ought to be good enough for avoiding
+	 * dead bloat without excessive runtime.
+	 */
+	for (offset = new_tree_size; !error; offset += tree_blocksize) {
+		xfs_fsverity_merkle_key_to_disk(&name, offset);
+		error = xfs_attr_set(&args);
+	}
+	if (error == -ENOATTR)
+		return 0;
+	return error;
+}
+
 static int
 xfs_verity_begin_enable(
 	struct file		*filp,
@@ -430,7 +468,6 @@ xfs_verity_begin_enable(
 {
 	struct inode		*inode = file_inode(filp);
 	struct xfs_inode	*ip = XFS_I(inode);
-	int			error = 0;
 
 	xfs_assert_ilocked(ip, XFS_IOLOCK_EXCL);
 
@@ -440,7 +477,8 @@ xfs_verity_begin_enable(
 	if (xfs_iflags_test_and_set(ip, XFS_VERITY_CONSTRUCTION))
 		return -EBUSY;
 
-	return error;
+	return xfs_verity_drop_old_metadata(ip, merkle_tree_size,
+			tree_blocksize);
 }
 
 static int


