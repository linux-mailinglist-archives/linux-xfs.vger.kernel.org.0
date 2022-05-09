Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B573251F238
	for <lists+linux-xfs@lfdr.de>; Mon,  9 May 2022 03:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233731AbiEIBaA (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Sun, 8 May 2022 21:30:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235619AbiEIAph (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 May 2022 20:45:37 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C6ECB658B
        for <linux-xfs@vger.kernel.org>; Sun,  8 May 2022 17:41:45 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id B7CF6534591
        for <linux-xfs@vger.kernel.org>; Mon,  9 May 2022 10:41:41 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nnrT2-009hdc-Mm
        for linux-xfs@vger.kernel.org; Mon, 09 May 2022 10:41:40 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nnrT2-003CQM-Ld
        for linux-xfs@vger.kernel.org;
        Mon, 09 May 2022 10:41:40 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 18/18] xfs: detect empty attr leaf blocks in xfs_attr3_leaf_verify
Date:   Mon,  9 May 2022 10:41:38 +1000
Message-Id: <20220509004138.762556-19-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220509004138.762556-1-david@fromorbit.com>
References: <20220509004138.762556-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=62786345
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=oZkIemNP1mAA:10 a=20KFwNOVAAAA:8 a=j0Z8cYLM2iZn_fZ0F7kA:9
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

xfs_repair flags these as a corruption error, so the verifier should
catch software bugs that result in empty leaf blocks being written
to disk, too.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/libxfs/xfs_attr_leaf.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index d15e92858bf0..15a990409463 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -310,6 +310,15 @@ xfs_attr3_leaf_verify(
 	if (fa)
 		return fa;
 
+	/*
+	 * Empty leaf blocks should never occur;  they imply the existence of a
+	 * software bug that needs fixing. xfs_repair also flags them as a
+	 * corruption that needs fixing, so we should never let these go to
+	 * disk.
+	 */
+	if (ichdr.count == 0)
+		return __this_address;
+
 	/*
 	 * firstused is the block offset of the first name info structure.
 	 * Make sure it doesn't go off the block or crash into the header.
-- 
2.35.1

