Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAA2D65A176
	for <lists+linux-xfs@lfdr.de>; Sat, 31 Dec 2022 03:23:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236216AbiLaCXV (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 21:23:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236221AbiLaCXU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:23:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E9DA1A23D
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:23:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B55461CB1
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:23:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64CEDC433D2;
        Sat, 31 Dec 2022 02:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672453398;
        bh=yFoELNdPaEWhPPPvv0MJxpEMtp7RLJ5ku740hwKJmSw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=DtXKARCge8zvDMa0XFY4FQps4ZvNHTLOn3W1bZG9hamjsM4AdtY0bBtCPV32p3JqV
         Kv7ec7nwSi2aUze49f/AH8o0uxF1S2mGGSPLQ8ZrETykC7IHKScx5ah62TnO6MYcnj
         VvGHldlzeNSb7SJVG4yqb32UyccaTZEJ9PpA4VmYLJn0fIKaDcVtP6yOOIPjpW2OAN
         6EhD9N6avOY0gyiCWTyq2cdDsbwgOsg5ytjBqHCBv+wsX08lKMF+IWmkr37Ltj/4bW
         60awen0WwSGV6qjYg83geaEvgIiFM6iNPsvTMdzP5xNVdtpOsZzq0UoA6zhZpw3+8A
         UbRic89p/Xivg==
Subject: [PATCH 06/10] xfs: convert do_div calls to xfs_rtb_to_rtx helper
 calls
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:28 -0800
Message-ID: <167243876895.727509.11114523582352015622.stgit@magnolia>
In-Reply-To: <167243876812.727509.17144221830951566022.stgit@magnolia>
References: <167243876812.727509.17144221830951566022.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Convert these calls to use the helpers, and clean up all these places
where the same variable can have different units depending on where it
is in the function.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_bmap.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)


diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 5fbfc5372c9..3637b07feba 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -4915,12 +4915,8 @@ xfs_bmap_del_extent_delay(
 	ASSERT(got->br_startoff <= del->br_startoff);
 	ASSERT(got_endoff >= del_endoff);
 
-	if (isrt) {
-		uint64_t rtexts = XFS_FSB_TO_B(mp, del->br_blockcount);
-
-		do_div(rtexts, mp->m_sb.sb_rextsize);
-		xfs_mod_frextents(mp, rtexts);
-	}
+	if (isrt)
+		xfs_mod_frextents(mp, xfs_rtb_to_rtxt(mp, del->br_blockcount));
 
 	/*
 	 * Update the inode delalloc counter now and wait to update the

