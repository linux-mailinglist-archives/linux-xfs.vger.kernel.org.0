Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F138659D37
	for <lists+linux-xfs@lfdr.de>; Fri, 30 Dec 2022 23:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235603AbiL3Wuz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 17:50:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiL3Wux (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:50:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8A14BC3F
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:50:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8799FB81D94
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:50:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C4A1C433EF;
        Fri, 30 Dec 2022 22:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440649;
        bh=T/haMHuOdnL3NfjTHoCkhzVjIdeq7ZxYlYEpKcNKkJk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=LpbUfpP0kHjrRh73d5BX3y4VKc7qBRbpKPeWkA7HWg677T5VocsWObJM6bTWUteEK
         1uF1oYGWou81VjnVvS+xZT/7iLXhCeJmAkYtlWlXxPQGULU1qqMeImBT0ukT0m9Myb
         flJmz/WQblel26cdeOIXJPZvZx+igUr/mauQvZmgcYsEi74hoGI7tdeWZmweh26G0z
         QGHEnZ5CWNDKtfDYbho+xlu9I2JE7BM0PM0G9mGOVM6Io5C+Fw/NYxCV5GJT+ov2HQ
         fsJnmavu8X26mGXlBIKV82Ph7AAR5pT00tp1ueBVSxD/hTii2KAGzkmYhctHs8TBmG
         /LZH2HK0aESAg==
Subject: [PATCH 10/11] xfs: clean up xattr scrub initialization
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:47 -0800
Message-ID: <167243830746.687022.6104601319492322161.stgit@magnolia>
In-Reply-To: <167243830598.687022.17067931640967897645.stgit@magnolia>
References: <167243830598.687022.17067931640967897645.stgit@magnolia>
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

Clean up local variable initialization and error returns in xchk_xattr.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/attr.c |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)


diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index 3e568c78210b..ea4a723f175c 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -560,7 +560,16 @@ int
 xchk_xattr(
 	struct xfs_scrub		*sc)
 {
-	struct xchk_xattr		sx;
+	struct xchk_xattr		sx = {
+		.sc			= sc,
+		.context		= {
+			.dp		= sc->ip,
+			.tp		= sc->tp,
+			.resynch	= 1,
+			.put_listent	= xchk_xattr_listent,
+			.allow_incomplete = true,
+		},
+	};
 	xfs_dablk_t			last_checked = -1U;
 	int				error = 0;
 
@@ -581,22 +590,13 @@ xchk_xattr(
 		error = xchk_da_btree(sc, XFS_ATTR_FORK, xchk_xattr_rec,
 				&last_checked);
 	if (error)
-		goto out;
+		return error;
 
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
-		goto out;
-
-	/* Check that every attr key can also be looked up by hash. */
-	memset(&sx, 0, sizeof(sx));
-	sx.context.dp = sc->ip;
-	sx.context.resynch = 1;
-	sx.context.put_listent = xchk_xattr_listent;
-	sx.context.tp = sc->tp;
-	sx.context.allow_incomplete = true;
-	sx.sc = sc;
+		return 0;
 
 	/*
-	 * Look up every xattr in this file by name.
+	 * Look up every xattr in this file by name and hash.
 	 *
 	 * Use the backend implementation of xfs_attr_list to call
 	 * xchk_xattr_listent on every attribute key in this inode.
@@ -613,11 +613,11 @@ xchk_xattr(
 	 */
 	error = xfs_attr_list_ilocked(&sx.context);
 	if (!xchk_fblock_process_error(sc, XFS_ATTR_FORK, 0, &error))
-		goto out;
+		return error;
 
 	/* Did our listent function try to return any errors? */
 	if (sx.context.seen_enough < 0)
-		error = sx.context.seen_enough;
-out:
-	return error;
+		return sx.context.seen_enough;
+
+	return 0;
 }

