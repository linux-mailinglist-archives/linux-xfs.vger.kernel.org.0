Return-Path: <linux-xfs+bounces-1390-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BB8C820DF5
	for <lists+linux-xfs@lfdr.de>; Sun, 31 Dec 2023 21:46:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 068FDB216A6
	for <lists+linux-xfs@lfdr.de>; Sun, 31 Dec 2023 20:46:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69857BA2E;
	Sun, 31 Dec 2023 20:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G4fo/ref"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36211BA22
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:46:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BDACC433C7;
	Sun, 31 Dec 2023 20:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704055585;
	bh=Iwgtbz43KQ2GDEx8guiaCpEZoUhtQ5g9OHBFsayr+3c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=G4fo/refiFK3B98w/N9Q2Y9pr4cfJfJUP59tSFqK7aoKwCaZC3EOkAkgzRVMfBpJF
	 0uFZAerHI0DomNRx89RXfm6JkO/78zEK3MTxM8erVyf9xqvo1Jwq2UjKZSgtbJXcTI
	 Y9DWzX2FJTxto46KH91oSiNZC96jSfnzRQZOhHxFfi1pRo4mMUB5lziVgKm2qp2FdF
	 HMXEqm1lvoCblB0oBFlqZseOGFlZbgWqnfK6npGax+5obMcrPXg0c0gJMZUOd5E4DG
	 cOWUyAHn60rMEYwpXPlKmgECuUSoniwOhNXMrg5Kd6RJMbeQWEY6i8tQPIvwh3KlL4
	 R7rvO2tbhexLQ==
Date: Sun, 31 Dec 2023 12:46:24 -0800
Subject: [PATCH 06/14] xfs: preserve NVLOOKUP in xfs_attr_set
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: catherine.hoang@oracle.com, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <170404840499.1756514.9313936060568212683.stgit@frogsfrogsfrogs>
In-Reply-To: <170404840374.1756514.8610142613907153469.stgit@frogsfrogsfrogs>
References: <170404840374.1756514.8610142613907153469.stgit@frogsfrogsfrogs>
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

Preserve the attr-value lookup flag when calling xfs_attr_set.  Normal
xattr users will never use this, but parent pointer fsck will.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 2de3f6ad36601..d1f228c67857f 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -945,11 +945,11 @@ xfs_attr_set(
 	/*
 	 * We have no control over the attribute names that userspace passes us
 	 * to remove, so we have to allow the name lookup prior to attribute
-	 * removal to fail as well.  Preserve the logged flag, since we need
-	 * to pass that through to the logging code.
+	 * removal to fail as well.  Preserve the logged and vlookup flags,
+	 * since we need to pass them through to the lower levels.
 	 */
-	args->op_flags = XFS_DA_OP_OKNOENT |
-					(args->op_flags & XFS_DA_OP_LOGGED);
+	args->op_flags &= (XFS_DA_OP_LOGGED | XFS_DA_OP_NVLOOKUP);
+	args->op_flags |= XFS_DA_OP_OKNOENT;
 
 	if (!is_remove) {
 		XFS_STATS_INC(mp, xs_attr_set);


