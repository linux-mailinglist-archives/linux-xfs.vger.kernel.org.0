Return-Path: <linux-xfs+bounces-1999-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB604821109
	for <lists+linux-xfs@lfdr.de>; Mon,  1 Jan 2024 00:25:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 864541C21B78
	for <lists+linux-xfs@lfdr.de>; Sun, 31 Dec 2023 23:25:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A87D5C2D4;
	Sun, 31 Dec 2023 23:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LzLjOlun"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75719C2CC
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:25:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43CE7C433C8;
	Sun, 31 Dec 2023 23:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065110;
	bh=Q8IBQ5cFJ9Qzf+orw3ibhMIbjAnnh7t431XLrWkRX5M=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LzLjOlunDsd8uR1Q3s2NBbAUB6E2Qr9v6JkfzdPH/T8Am68jL5+mGrULzqKREI9LX
	 FjksatKgVRA9AWCYWExX97hQlciH6phQfYA5kEZTM94rXByu+xWidYH49cDh+/jiEv
	 0Fltb2bzl11fNjk/YNN6TzBK4IfGLFD09Lh6PfcXiYwymiiMZiMc0WaaNskBwB+AsP
	 wsH5h0u9AR/pvMTj51I7wrEcXKNJy4FPLj8vrZ0VKy3xjTpdUW31SGpLXagptjkvRe
	 Q7b4S911SUtSbTErCt/la0O3qj0fzc0g8zhhKV7o3cVlC5E2FuseGDuxDNFEqh4Ww0
	 MLKmLg4YpzsKg==
Date: Sun, 31 Dec 2023 15:25:09 -0800
Subject: [PATCH 11/28] libxfs: pass flags2 from parent to child when creating
 files
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405009323.1808635.14260753186484818050.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009159.1808635.10158480820888604007.stgit@frogsfrogsfrogs>
References: <170405009159.1808635.10158480820888604007.stgit@frogsfrogsfrogs>
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

When mkfs creates a new file as a child of an existing directory, we
should propagate the flags2 field from parent to child like the kernel
does.  This ensures that mkfs propagates cowextsize hints properly when
protofiles are in use.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/inode.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)


diff --git a/libxfs/inode.c b/libxfs/inode.c
index e34b8e4b194..518c8b45371 100644
--- a/libxfs/inode.c
+++ b/libxfs/inode.c
@@ -59,6 +59,20 @@ xfs_inode_propagate_flags(
 	ip->i_diflags |= di_flags;
 }
 
+/* Propagate di_flags2 from a parent inode to a child inode. */
+static void
+xfs_inode_inherit_flags2(
+	struct xfs_inode	*ip,
+	const struct xfs_inode	*pip)
+{
+	if (pip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE) {
+		ip->i_diflags2 |= XFS_DIFLAG2_COWEXTSIZE;
+		ip->i_cowextsize = pip->i_cowextsize;
+	}
+	if (pip->i_diflags2 & XFS_DIFLAG2_DAX)
+		ip->i_diflags2 |= XFS_DIFLAG2_DAX;
+}
+
 /*
  * Increment the link count on an inode & log the change.
  */
@@ -141,6 +155,8 @@ libxfs_icreate(
 	case S_IFDIR:
 		if (pip && (pip->i_diflags & XFS_DIFLAG_ANY))
 			xfs_inode_propagate_flags(ip, pip);
+		if (pip && (pip->i_diflags2 & XFS_DIFLAG2_ANY))
+			xfs_inode_inherit_flags2(ip, pip);
 		/* FALLTHROUGH */
 	case S_IFLNK:
 		ip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;


