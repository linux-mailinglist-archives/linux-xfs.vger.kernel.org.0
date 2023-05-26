Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5CF711D94
	for <lists+linux-xfs@lfdr.de>; Fri, 26 May 2023 04:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbjEZCOZ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 May 2023 22:14:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbjEZCOV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:14:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B4813D
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:14:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0070664768
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:14:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64561C433D2;
        Fri, 26 May 2023 02:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685067259;
        bh=gU7IdZHRX6DzOosWLxXHOCmVzlR23yww/Zdxiabbrrk=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=D9NsJtxnlkDiTlQ+9rL8/ExxMlUuc2MXaTggrtHvriv/LtG0cvYB5plSOVlLPxXkP
         P6e++6CZhz7MkNJMtUgGzfF6gOlr4CAT3XqgMWFW2orFYAYE/EHEREULDFS2Xf4z47
         +wLpo/eh1vePVDdqxMHQF5FrI0kBwaCsT6INLUNNobOyI+lNTOMY+geoZrtAy/1Hwe
         0rJ+NWsfZSAOetVbT2v1KYfd+jjdTderl8zYNW9ajbBOYsYFcfJHyr5g8ZEuqm9aLW
         sVYsqfavVbFYc21E03GQXaN+UOh6xA3ZuTBq0C4rIs9LqZNEcihlYf9+5fsM5T1bai
         kJrU3ZLxuT29g==
Date:   Thu, 25 May 2023 19:14:18 -0700
Subject: [PATCH 17/18] xfs: don't remove the attr fork when parent pointers
 are enabled
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506072944.3744191.9181014638334683414.stgit@frogsfrogsfrogs>
In-Reply-To: <168506072673.3744191.16402822066993932505.stgit@frogsfrogsfrogs>
References: <168506072673.3744191.16402822066993932505.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

When an inode is removed, it may also cause the attribute fork to be
removed if it is the last attribute. This transaction gets flushed to
the log, but if the system goes down before we could inactivate the symlink,
the log recovery tries to inactivate this inode (since it is on the unlinked
list) but the verifier trips over the remote value and leaks it.

Hence we ended up with a file in this odd state on a "clean" mount.  The
"obvious" fix is to prohibit erasure of the attr fork to avoid tripping
over the verifiers when pptrs are enabled.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr_leaf.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 884528ca3b49..54b38e6528f2 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -913,7 +913,8 @@ xfs_attr_sf_removename(
 	totsize -= size;
 	if (totsize == sizeof(xfs_attr_sf_hdr_t) && xfs_has_attr2(mp) &&
 	    (dp->i_df.if_format != XFS_DINODE_FMT_BTREE) &&
-	    !(args->op_flags & (XFS_DA_OP_ADDNAME | XFS_DA_OP_REPLACE))) {
+	    !(args->op_flags & (XFS_DA_OP_ADDNAME | XFS_DA_OP_REPLACE)) &&
+	    !xfs_has_parent(mp)) {
 		xfs_attr_fork_remove(dp, args->trans);
 	} else {
 		xfs_idata_realloc(dp, -size, XFS_ATTR_FORK);
@@ -922,7 +923,8 @@ xfs_attr_sf_removename(
 		ASSERT(totsize > sizeof(xfs_attr_sf_hdr_t) ||
 				(args->op_flags & XFS_DA_OP_ADDNAME) ||
 				!xfs_has_attr2(mp) ||
-				dp->i_df.if_format == XFS_DINODE_FMT_BTREE);
+				dp->i_df.if_format == XFS_DINODE_FMT_BTREE ||
+				xfs_has_parent(mp));
 		xfs_trans_log_inode(args->trans, dp,
 					XFS_ILOG_CORE | XFS_ILOG_ADATA);
 	}

