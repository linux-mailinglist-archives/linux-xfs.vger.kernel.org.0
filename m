Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3B64501EC3
	for <lists+linux-xfs@lfdr.de>; Fri, 15 Apr 2022 00:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347379AbiDNW5H (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 14 Apr 2022 18:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347377AbiDNW5F (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Apr 2022 18:57:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F532183A1
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 15:54:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2ED2F61CB8
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 22:54:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D3B3C385A1;
        Thu, 14 Apr 2022 22:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649976877;
        bh=3v+kqg4FMgXquIMc56IvcLcz+Vi8yJas4dEpmLZx4uI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=CAoIT0CJHYRUzhFBBVB/es/RiTViWcF0IvKAGG2AKJGTnVZJ6qNT/9x0FSxIZtfEw
         SsSX3sNOKz8f9RyW6RW6/p2n9JNBuNg0Cye22PuEOQtVZm8P/v9/bmAVLzZzbS77Za
         uLVn6U0PI9lSSGM7nXxlZS1G09thlsewGPURjbJzypGzoZOhkbj/ebRbW1K8FZbhUX
         7GJdccht6bHnxHPLgZ8QZoRPVU67WL8p5GUfHczWfGLgoTFfZOeA1QZ83d2ZBtwwtQ
         8QiLV4MVU/8UGMzKhGX+aroWEs+STISoN1sqpBsnc0HEGXLUUqg5pNDNCXZMiRDF5F
         STlR8I5O3vPgQ==
Subject: [PATCH 2/6] xfs: remove a __xfs_bunmapi call from reflink
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 14 Apr 2022 15:54:37 -0700
Message-ID: <164997687710.383881.15849921169442020335.stgit@magnolia>
In-Reply-To: <164997686569.383881.8935566398533700022.stgit@magnolia>
References: <164997686569.383881.8935566398533700022.stgit@magnolia>
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

From: Darrick J. Wong <djwong@kernel.org>

This raw call isn't necessary since we can always remove a full delalloc
extent.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_reflink.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 54e68e5693fd..09bedbfef01a 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1133,7 +1133,7 @@ xfs_reflink_remap_extent(
 		xfs_refcount_decrease_extent(tp, &smap);
 		qdelta -= smap.br_blockcount;
 	} else if (smap.br_startblock == DELAYSTARTBLOCK) {
-		xfs_filblks_t	len = smap.br_blockcount;
+		int		done;
 
 		/*
 		 * If the extent we're unmapping is a delalloc reservation,
@@ -1141,10 +1141,11 @@ xfs_reflink_remap_extent(
 		 * incore state.  Dropping the delalloc reservation takes care
 		 * of the quota reservation for us.
 		 */
-		error = __xfs_bunmapi(NULL, ip, smap.br_startoff, &len, 0, 1);
+		error = xfs_bunmapi(NULL, ip, smap.br_startoff,
+				smap.br_blockcount, 0, 1, &done);
 		if (error)
 			goto out_cancel;
-		ASSERT(len == 0);
+		ASSERT(done);
 	}
 
 	/*

