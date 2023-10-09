Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E97637BE930
	for <lists+linux-xfs@lfdr.de>; Mon,  9 Oct 2023 20:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234559AbjJISZy (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Mon, 9 Oct 2023 14:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233096AbjJISZx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Oct 2023 14:25:53 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1418CA3
        for <linux-xfs@vger.kernel.org>; Mon,  9 Oct 2023 11:25:52 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A84E1C433C7;
        Mon,  9 Oct 2023 18:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696875951;
        bh=cGEblf3IjJexfH78lMOYVVWVFRsnelBaCzH3o6rc39o=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=YoMmhQPI9wNpxjzgaWn4yJBmL+gil3jXfU4il8J3mI1XDc79RNM1hIPoKd/2i+S4m
         z7tiAD+4eHukuD3o0cGX7hMEWwr6j97doisiaFtuGlApXArEl9cvb1pfZ/IYiBIzkW
         WtT7b9c3ttlV7Dbs/6NIVK17gU9G9uCYYH8G9V+DUVrj62i0Pz5nOLyxGibHnbhrlC
         nTBU/ZqenuMlSLca39wfJ56y2AcjYgrcFNVDQ8mEry60dkZc54SIEcf4vrv7CNDbHa
         JJ+RtYMR9Bapm8OwNyPIPf4iuqPnJkF3iHyhHx4bAy+dpABAT8biBDZc0gINqOk+pr
         HzTX2c3F2A69A==
Subject: [PATCH 1/2] xfs: adjust the incore perag block_count when shrinking
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 09 Oct 2023 11:25:51 -0700
Message-ID: <169687595108.3969352.10885468926344975772.stgit@frogsfrogsfrogs>
In-Reply-To: <169687594536.3969352.5780413854846204650.stgit@frogsfrogsfrogs>
References: <169687594536.3969352.5780413854846204650.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If we reduce the number of blocks in an AG, we must update the incore
geometry values as well.

Fixes: 0800169e3e2c9 ("xfs: Pre-calculate per-AG agbno geometry")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c |    6 ++++++
 1 file changed, 6 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index e9cc481b4ddff..f9f4d694640d0 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -1001,6 +1001,12 @@ xfs_ag_shrink_space(
 		error = -ENOSPC;
 		goto resv_init_out;
 	}
+
+	/* Update perag geometry */
+	pag->block_count -= delta;
+	__xfs_agino_range(pag->pag_mount, pag->block_count, &pag->agino_min,
+				&pag->agino_max);
+
 	xfs_ialloc_log_agi(*tpp, agibp, XFS_AGI_LENGTH);
 	xfs_alloc_log_agf(*tpp, agfbp, XFS_AGF_LENGTH);
 	return 0;

