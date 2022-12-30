Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC7265A0F3
	for <lists+linux-xfs@lfdr.de>; Sat, 31 Dec 2022 02:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236079AbiLaBuk (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 20:50:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236099AbiLaBuj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:50:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC3631DDD3
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:50:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 68C1361CBE
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:50:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C74F3C433EF;
        Sat, 31 Dec 2022 01:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451437;
        bh=iBcydqg97ByD2/qKSXb1BD7D7BJKFnwn0aTjWegVUfc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=i7w+BhPMr9gAoR0f/BUpRZUplRnesmSszToVY0gGxAgvkv9dVPArYgOfCx2qEpuFv
         F6qEPDxH/zc8myWRN3lD/74OV7JL4mFGNKeGYz922GBc9LWvcxTCDw98owpUqHRY1u
         zVjyCsjSbPXzfhcw1QRSjxkuWdA+ijpH2Wo1Nm87SlICha9CIKc/oCAzf8MIaUp+N1
         LxyasFEAeRHRsMr5ZjN6j0pbtGyy69YJ2amehtxpmjvUI4q1qzB6r1v9lp7W0eWDJP
         iP2FNZrq8kdXfDN2ThxnjXk+MXoWHQWzdGKt/haYUKJvGO/ZGgQcoxCg7E1w0m8m8j
         DZjkP5io8OjCQ==
Subject: [PATCH 10/42] xfs: add realtime refcount btree block detection to log
 recovery
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:30 -0800
Message-ID: <167243871039.717073.15249797934773660086.stgit@magnolia>
In-Reply-To: <167243870849.717073.203452386730176902.stgit@magnolia>
References: <167243870849.717073.203452386730176902.stgit@magnolia>
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

Identify rt refcount btree blocks in the log correctly so that we can
validate them during log recovery.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_buf_item_recover.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/fs/xfs/xfs_buf_item_recover.c b/fs/xfs/xfs_buf_item_recover.c
index 496260c9d8cd..5368a0d34452 100644
--- a/fs/xfs/xfs_buf_item_recover.c
+++ b/fs/xfs/xfs_buf_item_recover.c
@@ -268,6 +268,9 @@ xlog_recover_validate_buf_type(
 		case XFS_REFC_CRC_MAGIC:
 			bp->b_ops = &xfs_refcountbt_buf_ops;
 			break;
+		case XFS_RTREFC_CRC_MAGIC:
+			bp->b_ops = &xfs_rtrefcountbt_buf_ops;
+			break;
 		default:
 			warnmsg = "Bad btree block magic!";
 			break;
@@ -772,6 +775,7 @@ xlog_recover_get_buf_lsn(
 		break;
 	}
 	case XFS_RTRMAP_CRC_MAGIC:
+	case XFS_RTREFC_CRC_MAGIC:
 	case XFS_BMAP_CRC_MAGIC:
 	case XFS_BMAP_MAGIC: {
 		struct xfs_btree_block *btb = blk;

