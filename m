Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61F04659F8C
	for <lists+linux-xfs@lfdr.de>; Sat, 31 Dec 2022 01:26:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235735AbiLaA0u (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 19:26:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235651AbiLaA0t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:26:49 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 717441E3FE
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:26:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C8BFDCE1A90
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:26:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14428C433D2;
        Sat, 31 Dec 2022 00:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672446405;
        bh=11/dV7lFGnzM4QqN68djhJkqzYGj0UaR6lAgW01K4Dg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=tBD8WWxvdFXGwWOEhNBhUn8GqsoeckoAI1s/x0zpt3fisH/I0+EtpR5VMyPbb752b
         Y4qRGtJDogjsc6xruHX4gRBvx5UkFwHDjYYvDB8vLR0oYsFETjrJ10YoOVcNY9vhzv
         08JSxGPHvHRubkCXuAXmhKxmPeb6OoxeLBTcNqiDSEYQMnvY/wOYzEHds48kJCxX9i
         dQYxCtDBsvDOrRxiaNV/3CJYirN1gF48xJXNkKSeNfATe+MJoiwMRQIo9Z4rpbEu6C
         q7muiYZ3Arv2Cuw4WvXG/Xf0GKFt9ksDtfKYDkGZOZowozHxqsk3Q+bb5ddh9oZVrS
         LZ05S1mQ6g2Sg==
Subject: [PATCH 4/6] xfs_scrub: add missing repair types to the mustfix and
 difficulty assessment
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:14 -0800
Message-ID: <167243869420.715119.8599663908301526903.stgit@magnolia>
In-Reply-To: <167243869365.715119.17881025524336922669.stgit@magnolia>
References: <167243869365.715119.17881025524336922669.stgit@magnolia>
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

Add a few scrub types that ought to trigger a mustfix (such as AGI
corruption) and all the AG space metadata to the repair difficulty
assessment.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/repair.c |    7 +++++++
 1 file changed, 7 insertions(+)


diff --git a/scrub/repair.c b/scrub/repair.c
index 814a385ce29..cb0ca50a18e 100644
--- a/scrub/repair.c
+++ b/scrub/repair.c
@@ -291,6 +291,7 @@ action_list_find_mustfix(
 		if (!(aitem->flags & XFS_SCRUB_OFLAG_CORRUPT))
 			continue;
 		switch (aitem->type) {
+		case XFS_SCRUB_TYPE_AGI:
 		case XFS_SCRUB_TYPE_FINOBT:
 		case XFS_SCRUB_TYPE_INOBT:
 			alist->nr--;
@@ -317,11 +318,17 @@ action_list_difficulty(
 		case XFS_SCRUB_TYPE_RMAPBT:
 			ret |= REPAIR_DIFFICULTY_SECONDARY;
 			break;
+		case XFS_SCRUB_TYPE_SB:
+		case XFS_SCRUB_TYPE_AGF:
+		case XFS_SCRUB_TYPE_AGFL:
+		case XFS_SCRUB_TYPE_AGI:
 		case XFS_SCRUB_TYPE_FINOBT:
 		case XFS_SCRUB_TYPE_INOBT:
 		case XFS_SCRUB_TYPE_BNOBT:
 		case XFS_SCRUB_TYPE_CNTBT:
 		case XFS_SCRUB_TYPE_REFCNTBT:
+		case XFS_SCRUB_TYPE_RTBITMAP:
+		case XFS_SCRUB_TYPE_RTSUM:
 			ret |= REPAIR_DIFFICULTY_PRIMARY;
 			break;
 		}

