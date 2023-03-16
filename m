Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E66A6BD902
	for <lists+linux-xfs@lfdr.de>; Thu, 16 Mar 2023 20:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbjCPTY2 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 16 Mar 2023 15:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbjCPTYS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:24:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4769CB042
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 12:23:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3F44B82302
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 19:23:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B103C4339B;
        Thu, 16 Mar 2023 19:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678994630;
        bh=/OXI0PJs5vy1pANhtUoRAAt2o/G3dF6CAeXkWhlDBwQ=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=otSJC5U9Q9NbNtqTAKiyeCs19FelIKPg0v6B6e4VIwarl53iRk5+9gBaIaDmUfUYo
         JJGMrluuqRNQdC18s/dwcpmVw+pnkpjHI4Iseh5bhxNv5hq3Opudpote0Q/gXxlT67
         WBcBlNyJA5tkwlYvdygkpL/7AmXbg9Tdf6xpYmngyLuDpNXwmZo/H9qcxX4PabmhGF
         2Wk1UvofAXQV6k/DpYnt7X3Wr6EgKT6FkbeWU2KvjtRCNL0/itwB36iHz/BdVlOZxd
         Thg4UlQTAVzy+gnpDD0GuS/6bc3ep/VvsdM399XHXFXTxmPL6FBo5ZrKP0XpV044oL
         Y4Scc7+Bb6wDA==
Date:   Thu, 16 Mar 2023 12:23:49 -0700
Subject: [PATCH 09/17] xfs: flip nvreplace detection in xfs_attr_complete_op
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167899414483.15363.18330355264115568396.stgit@frogsfrogsfrogs>
In-Reply-To: <167899414339.15363.12404998880107296432.stgit@frogsfrogsfrogs>
References: <167899414339.15363.12404998880107296432.stgit@frogsfrogsfrogs>
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

Gate the NVREPLACE code on the op flags directly, instead of inferring
it through args->new_namelen.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_attr.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 996ef24482e1..1a047099e9c7 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -426,9 +426,15 @@ xfs_attr_complete_op(
 		return XFS_DAS_DONE;
 
 	args->attr_filter &= ~XFS_ATTR_INCOMPLETE;
-	if (args->new_namelen == 0)
+	if (xfs_attr_intent_op(attr) != XFS_ATTRI_OP_FLAGS_NVREPLACE)
 		return replace_state;
 
+	/*
+	 * NVREPLACE operations require the caller to set the old and new names
+	 * explicitly.
+	 */
+	ASSERT(args->new_namelen > 0);
+
 	args->name = args->new_name;
 	args->namelen = args->new_namelen;
 	args->hashval = xfs_da_hashname(args->name, args->namelen);

