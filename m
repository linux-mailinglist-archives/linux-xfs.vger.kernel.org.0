Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D504865A0C7
	for <lists+linux-xfs@lfdr.de>; Sat, 31 Dec 2022 02:39:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236121AbiLaBjN (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 20:39:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236119AbiLaBjM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:39:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C64713DD9
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:39:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD7E861CC6
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:39:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AD9AC433EF;
        Sat, 31 Dec 2022 01:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450751;
        bh=VNqn4IKxv0UI/VpegWuoH9PpnbmqB5F35XorWUit5s8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=BfJLklaqvs/lyY2RBie2YrqpvGV3kYLyznwyI3oFQBQl7O6Y3sYZgZYRkK2ziDvXT
         LEP1EwKF9RyDXOOGZJ/qfD1Q2M7WCZOhtJCLl6oq/rVMIM6MRPkQFj6BThwtf8Gjck
         IQb0pSOhfso8vtJYc9imXEPWApUhcCb82Gu0IqG5sWjrGeYejMch+aLNL6SisHaYaR
         NHs1hTDL1lMBob4fb4NByr5fNE85cPxfR9e4ZRj9gqN3Df65dE5qowNHvykyyHpoQY
         NFOGP3s8ufIiyaLBdCtojyqt+EPTJIFshbVw06y4tm1DqNQkdnaOLhHJB7GJSXcVEH
         xPPU1Yg1LRXJA==
Subject: [PATCH 09/38] xfs: support recovering rmap intent items targetting
 realtime extents
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:17 -0800
Message-ID: <167243869728.715303.12164955598997789324.stgit@magnolia>
In-Reply-To: <167243869558.715303.13347105677486333748.stgit@magnolia>
References: <167243869558.715303.13347105677486333748.stgit@magnolia>
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

Now that we have rmap on the realtime device, log recovery has to
support remapping extents on the realtime volume.  Make this work.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rmap_item.c |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 5f04f55f5caa..a2949f818e0c 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -507,6 +507,9 @@ xfs_rui_validate_map(
 	if (!xfs_verify_fileext(mp, map->me_startoff, map->me_len))
 		return false;
 
+	if (map->me_flags & XFS_RMAP_EXTENT_REALTIME)
+		return xfs_verify_rtbext(mp, map->me_startblock, map->me_len);
+
 	return xfs_verify_fsbext(mp, map->me_startblock, map->me_len);
 }
 

