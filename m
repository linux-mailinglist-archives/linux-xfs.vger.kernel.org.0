Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF5D6BD917
	for <lists+linux-xfs@lfdr.de>; Thu, 16 Mar 2023 20:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjCPT1C (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 16 Mar 2023 15:27:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbjCPT1B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:27:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8132C8888
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 12:26:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E695B82302
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 19:26:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52B67C433D2;
        Thu, 16 Mar 2023 19:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678994817;
        bh=Ok2jL3S8Vqn4hmBKjtxLAMT7WDu6JiaR443/ItGyegY=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=euv2/iqKUrDxoK57IcXjzBys6uUTlNwPcRSzcIdpKxjvSTIINhASgQdV5L/BgZuxr
         eTEChVJQqYB99HjiLfsllOEWcrHSYxh9IDqt64Rv6jTRtZ5fkHttJBkRMkOx62vMmy
         hRxTRwQfaoKgy366Vrl8phhciVpqzzMJxOGtwnsp+tL3FWO4d6jLRs64zDyE8Ke76u
         X/X5AzciXpDmah+LxSM0mnlgMP9Q0ZmMCdD98J0oBo3E/cfwx8UiMDAWa+91t7kVvu
         BIwkMMmt1TOWjwHmAEq1KcWNlvUMEo6W0YAHeljT+I8R+1jmQnPcyumroGmR3QN4iA
         x+DbmUxLIY14g==
Date:   Thu, 16 Mar 2023 12:26:56 -0700
Subject: [PATCH 4/9] mkfs: fix subdir parent pointer creation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167899415429.16278.5259298733491430583.stgit@frogsfrogsfrogs>
In-Reply-To: <167899415375.16278.9528475200288521209.stgit@frogsfrogsfrogs>
References: <167899415375.16278.9528475200288521209.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Rework the protofile code so that it uses the same deferred parent
pointer ops that the kernel uses to create parent pointers.  While we're
at it, make it so that subdirs of the root directory and reserved files
also get parent pointers.  Found by xfs/019.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    3 ++
 mkfs/proto.c             |   65 +++++++++++++++++++++++++++++++++-------------
 2 files changed, 50 insertions(+), 18 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index e44b0b29e..055d2862a 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -140,6 +140,9 @@
 #define xfs_log_get_max_trans_res	libxfs_log_get_max_trans_res
 #define xfs_log_sb			libxfs_log_sb
 #define xfs_mode_to_ftype		libxfs_mode_to_ftype
+#define xfs_parent_defer_add		libxfs_parent_defer_add
+#define xfs_parent_finish		libxfs_parent_finish
+#define xfs_parent_start		libxfs_parent_start
 #define xfs_perag_get			libxfs_perag_get
 #define xfs_perag_put			libxfs_perag_put
 #define xfs_prealloc_blocks		libxfs_prealloc_blocks
diff --git a/mkfs/proto.c b/mkfs/proto.c
index ac7ffbe9d..e0131df50 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -8,7 +8,6 @@
 #include <sys/stat.h>
 #include "libfrog/convert.h"
 #include "proto.h"
-#include "xfs_parent.h"
 
 /*
  * Prototypes for internal functions.
@@ -349,6 +348,20 @@ newdirectory(
 		fail(_("directory create error"), error);
 }
 
+static struct xfs_parent_defer *
+newpptr(
+	struct xfs_mount	*mp)
+{
+	struct xfs_parent_defer	*ret;
+	int			error;
+
+	error = -libxfs_parent_start(mp, &ret);
+	if (error)
+		fail(_("initializing parent pointer"), error);
+
+	return ret;
+}
+
 static void
 parseproto(
 	xfs_mount_t	*mp,
@@ -384,6 +397,7 @@ parseproto(
 	char		*value;
 	struct xfs_name	xname;
 	xfs_dir2_dataptr_t offset;
+	struct xfs_parent_defer *parent = NULL;
 
 	memset(&creds, 0, sizeof(creds));
 	mstr = getstr(pp);
@@ -458,6 +472,7 @@ parseproto(
 	case IF_REGULAR:
 		buf = newregfile(pp, &len);
 		tp = getres(mp, XFS_B_TO_FSB(mp, len));
+		parent = newpptr(mp);
 		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFREG, 1, 0,
 					   &creds, fsxp, &ip);
 		if (error)
@@ -481,7 +496,7 @@ parseproto(
 			exit(1);
 		}
 		tp = getres(mp, XFS_B_TO_FSB(mp, llen));
-
+		parent = newpptr(mp);
 		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFREG, 1, 0,
 					  &creds, fsxp, &ip);
 		if (error)
@@ -492,15 +507,24 @@ parseproto(
 		xname.type = XFS_DIR3_FT_REG_FILE;
 		newdirent(mp, tp, pip, &xname, ip->i_ino, &offset);
 		libxfs_trans_log_inode(tp, ip, flags);
+		if (parent) {
+			error = -libxfs_parent_defer_add(tp, parent, pip,
+					&xname, offset, ip);
+			if (error)
+				fail(_("committing parent pointers failed."),
+						error);
+		}
 		error = -libxfs_trans_commit(tp);
 		if (error)
 			fail(_("Space preallocation failed."), error);
+		libxfs_parent_finish(mp, parent);
 		rsvfile(mp, ip, llen);
 		libxfs_irele(ip);
 		return;
 
 	case IF_BLOCK:
 		tp = getres(mp, 0);
+		parent = newpptr(mp);
 		majdev = getnum(getstr(pp), 0, 0, false);
 		mindev = getnum(getstr(pp), 0, 0, false);
 		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFBLK, 1,
@@ -516,6 +540,7 @@ parseproto(
 
 	case IF_CHAR:
 		tp = getres(mp, 0);
+		parent = newpptr(mp);
 		majdev = getnum(getstr(pp), 0, 0, false);
 		mindev = getnum(getstr(pp), 0, 0, false);
 		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFCHR, 1,
@@ -530,6 +555,7 @@ parseproto(
 
 	case IF_FIFO:
 		tp = getres(mp, 0);
+		parent = newpptr(mp);
 		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFIFO, 1, 0,
 				&creds, fsxp, &ip);
 		if (error)
@@ -542,6 +568,7 @@ parseproto(
 		buf = getstr(pp);
 		len = (int)strlen(buf);
 		tp = getres(mp, XFS_B_TO_FSB(mp, len));
+		parent = newpptr(mp);
 		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFLNK, 1, 0,
 				&creds, fsxp, &ip);
 		if (error)
@@ -564,6 +591,7 @@ parseproto(
 			libxfs_log_sb(tp);
 			isroot = 1;
 		} else {
+			parent = newpptr(mp);
 			libxfs_trans_ijoin(tp, pip, 0);
 			xname.type = XFS_DIR3_FT_DIR;
 			newdirent(mp, tp, pip, &xname, ip->i_ino, &offset);
@@ -572,9 +600,19 @@ parseproto(
 		}
 		newdirectory(mp, tp, ip, pip);
 		libxfs_trans_log_inode(tp, ip, flags);
+		if (parent) {
+			error = -libxfs_parent_defer_add(tp, parent, pip,
+					&xname, offset, ip);
+			if (error)
+				fail(_("committing parent pointers failed."),
+						error);
+		}
 		error = -libxfs_trans_commit(tp);
 		if (error)
 			fail(_("Directory inode allocation failed."), error);
+
+		libxfs_parent_finish(mp, parent);
+
 		/*
 		 * RT initialization.  Do this here to ensure that
 		 * the RT inodes get placed after the root inode.
@@ -597,28 +635,19 @@ parseproto(
 		fail(_("Unknown format"), EINVAL);
 	}
 	libxfs_trans_log_inode(tp, ip, flags);
+	if (parent) {
+		error = -libxfs_parent_defer_add(tp, parent, pip, &xname,
+				offset, ip);
+		if (error)
+			fail(_("committing parent pointers failed."), error);
+	}
 	error = -libxfs_trans_commit(tp);
 	if (error) {
 		fail(_("Error encountered creating file from prototype file"),
 			error);
 	}
 
-	if (xfs_has_parent(mp)) {
-		struct xfs_parent_name_rec      rec;
-		struct xfs_da_args		args = {
-			.dp = ip,
-			.name = (const unsigned char *)&rec,
-			.namelen = sizeof(rec),
-			.attr_filter = XFS_ATTR_PARENT,
-			.value = (void *)xname.name,
-			.valuelen = xname.len,
-		};
-		libxfs_init_parent_name_rec(&rec, pip, offset);
-		error = -libxfs_attr_set(&args);
-		if (error)
-			fail(_("Error creating parent pointer"), error);
-	}
-
+	libxfs_parent_finish(mp, parent);
 	libxfs_irele(ip);
 }
 

