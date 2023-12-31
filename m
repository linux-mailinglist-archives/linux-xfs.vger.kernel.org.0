Return-Path: <linux-xfs+bounces-2042-lists+linux-xfs=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9ECD3821134
	for <lists+linux-xfs@lfdr.de>; Mon,  1 Jan 2024 00:36:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3D1E21F224A9
	for <lists+linux-xfs@lfdr.de>; Sun, 31 Dec 2023 23:36:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13A75C2DA;
	Sun, 31 Dec 2023 23:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bN+AK5p7"
X-Original-To: linux-xfs@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42A9C2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:36:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B6CEC433C8;
	Sun, 31 Dec 2023 23:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065782;
	bh=tBvnMlYmcEEjkeIgXJLgjQWp/CO/n5qW60eFb7tEdeE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=bN+AK5p7W/GlDv+3jewLrHBc+ozTqvQ5D5V7d2uGM87gU3KEM9e3guR6HTRHFKtHC
	 5zFBvqKmIXniF6qg6dfySRVCfeD+CdhYREzewt53Qq5ipwtOWFs6BWqMOIr3nRNq92
	 6Rkda5wFRl1pXKceTRT7JCNSdq2JzIdUFTHdxLlzscRWdtzgrJRXJsTQMdDhryQsrn
	 BS1sEIALcS4aOY2c4n0nkBkvLwa3abFukRlcnjJ0xVLbkM8Rpi6Pb3V+Ue8z3wcVf+
	 uQ9cpAeRyeZQcPbtF1LBrgmTPWZI1Zti5lLf7ZqZDa9gjZ9iBHnWcskXdUec0/2QV1
	 0tfidGaZWK/kw==
Date: Sun, 31 Dec 2023 15:36:21 -0800
Subject: [PATCH 26/58] xfs_db: basic xfs_check support for metadir
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405010294.1809361.16491233404708859058.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
References: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
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

Support metadata directories in xfs_check.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/check.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)


diff --git a/db/check.c b/db/check.c
index 2f2fbc7cbd8..ae527471161 100644
--- a/db/check.c
+++ b/db/check.c
@@ -2663,7 +2663,9 @@ process_dir(
 		if (!sflag || id->ilist || CHECK_BLIST(bno))
 			dbprintf(_("no .. entry for directory %lld\n"), id->ino);
 		error++;
-	} else if (parent == id->ino && id->ino != mp->m_sb.sb_rootino) {
+	} else if (parent == id->ino &&
+		   id->ino != mp->m_sb.sb_rootino &&
+		   id->ino != mp->m_sb.sb_metadirino) {
 		if (!sflag || id->ilist || CHECK_BLIST(bno))
 			dbprintf(_(". and .. same for non-root directory %lld\n"),
 				id->ino);
@@ -2673,6 +2675,11 @@ process_dir(
 			dbprintf(_("root directory %lld has .. %lld\n"), id->ino,
 				parent);
 		error++;
+	} else if (id->ino == mp->m_sb.sb_metadirino && id->ino != parent) {
+		if (!sflag || id->ilist || CHECK_BLIST(bno))
+			dbprintf(_("metadata directory %lld has .. %lld\n"),
+				id->ino, parent);
+		error++;
 	} else if (parent != NULLFSINO && id->ino != parent)
 		addparent_inode(id, parent);
 }
@@ -2916,6 +2923,9 @@ process_inode(
 		type = DBM_DIR;
 		if (dip->di_format == XFS_DINODE_FMT_LOCAL)
 			break;
+		if (xfs_has_metadir(mp) &&
+		    id->ino == mp->m_sb.sb_metadirino)
+			addlink_inode(id);
 		blkmap = blkmap_alloc(dnextents);
 		break;
 	case S_IFREG:
@@ -2924,18 +2934,21 @@ process_inode(
 		else if (id->ino == mp->m_sb.sb_rbmino) {
 			type = DBM_RTBITMAP;
 			blkmap = blkmap_alloc(dnextents);
-			addlink_inode(id);
+			if (!xfs_has_metadir(mp))
+				addlink_inode(id);
 		} else if (id->ino == mp->m_sb.sb_rsumino) {
 			type = DBM_RTSUM;
 			blkmap = blkmap_alloc(dnextents);
-			addlink_inode(id);
+			if (!xfs_has_metadir(mp))
+				addlink_inode(id);
 		}
 		else if (id->ino == mp->m_sb.sb_uquotino ||
 			 id->ino == mp->m_sb.sb_gquotino ||
 			 id->ino == mp->m_sb.sb_pquotino) {
 			type = DBM_QUOTA;
 			blkmap = blkmap_alloc(dnextents);
-			addlink_inode(id);
+			if (!xfs_has_metadir(mp))
+				addlink_inode(id);
 		}
 		else
 			type = DBM_DATA;


