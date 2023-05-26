Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3816711DC8
	for <lists+linux-xfs@lfdr.de>; Fri, 26 May 2023 04:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbjEZCX1 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 May 2023 22:23:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbjEZCX0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:23:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 039B99B
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:23:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CDE064B7B
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:23:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDF57C433D2;
        Fri, 26 May 2023 02:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685067805;
        bh=9eL7XeYB9EP5CDIDx8VdAXpj6a90rLRSXvxKmQ0tQn4=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=OCoe/5/y/WzVVTNiOJk8zVPvvC4iVW6+5bPMDovLx5sguuB1pCb9EftAf+ln9Hj2S
         kByYgSoSa8Eyiw8nOffaK3JUlwRsTbTco0JIHfeiATWJAu5fzRtAxlr7crKAgjJDbw
         MZg1L3A3kObzdVEbuGvquU5i3Alj851uOA0iTyKfpFS/IAgwDD4k47YAYyphL/hAMB
         MiQqJXI+nW5yA86rTJxXsFLd+N1jcNEnJ2/QW0dIqb/hL++NXMbixLXBp8jW72adnO
         5emPGW9tgkvCfE1H0xZGdHJWpXZzwki45mXu5K2FutM8JZab5jBYQxlgVqj5X4YApI
         7fYV9OwL+8knA==
Date:   Thu, 25 May 2023 19:23:24 -0700
Subject: [PATCH 06/30] xfs: add parent attributes to link
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506077970.3749421.4493608855532915792.stgit@frogsfrogsfrogs>
In-Reply-To: <168506077876.3749421.7883085669588003826.stgit@frogsfrogsfrogs>
References: <168506077876.3749421.7883085669588003826.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

This patch modifies xfs_link to add a parent pointer to the inode.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
[djwong: minor rebase fixes]
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_trans_space.c |   14 ++++++++++++++
 libxfs/xfs_trans_space.h |    3 +--
 2 files changed, 15 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_trans_space.c b/libxfs/xfs_trans_space.c
index 3408e700f01..039bbd91e87 100644
--- a/libxfs/xfs_trans_space.c
+++ b/libxfs/xfs_trans_space.c
@@ -50,3 +50,17 @@ xfs_mkdir_space_res(
 {
 	return xfs_create_space_res(mp, namelen);
 }
+
+unsigned int
+xfs_link_space_res(
+	struct xfs_mount	*mp,
+	unsigned int		namelen)
+{
+	unsigned int		ret;
+
+	ret = XFS_DIRENTER_SPACE_RES(mp, namelen);
+	if (xfs_has_parent(mp))
+		ret += xfs_parent_calc_space_res(mp, namelen);
+
+	return ret;
+}
diff --git a/libxfs/xfs_trans_space.h b/libxfs/xfs_trans_space.h
index 6cda87153b3..5539634009f 100644
--- a/libxfs/xfs_trans_space.h
+++ b/libxfs/xfs_trans_space.h
@@ -86,8 +86,6 @@
 	(2 * (mp)->m_alloc_maxlevels)
 #define	XFS_GROWFSRT_SPACE_RES(mp,b)	\
 	((b) + XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK))
-#define	XFS_LINK_SPACE_RES(mp,nl)	\
-	XFS_DIRENTER_SPACE_RES(mp,nl)
 #define	XFS_QM_DQALLOC_SPACE_RES(mp)	\
 	(XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK) + \
 	 XFS_DQUOT_CLUSTER_SIZE_FSB)
@@ -107,5 +105,6 @@ unsigned int xfs_parent_calc_space_res(struct xfs_mount *mp,
 
 unsigned int xfs_create_space_res(struct xfs_mount *mp, unsigned int namelen);
 unsigned int xfs_mkdir_space_res(struct xfs_mount *mp, unsigned int namelen);
+unsigned int xfs_link_space_res(struct xfs_mount *mp, unsigned int namelen);
 
 #endif	/* __XFS_TRANS_SPACE_H__ */

