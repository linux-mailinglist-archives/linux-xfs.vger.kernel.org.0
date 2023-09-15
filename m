Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDC2B7A1BF4
	for <lists+linux-xfs@lfdr.de>; Fri, 15 Sep 2023 12:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234273AbjIOKXC (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 15 Sep 2023 06:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234229AbjIOKXB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Sep 2023 06:23:01 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 660D9A1
        for <linux-xfs@vger.kernel.org>; Fri, 15 Sep 2023 03:22:55 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30571C433C7
        for <linux-xfs@vger.kernel.org>; Fri, 15 Sep 2023 10:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694773375;
        bh=eh8REMLXSBX34hzVRw0FSqVkLl9Q0aqBDTiyPHpLos8=;
        h=From:To:Subject:Date:From;
        b=CyGVbRYiuJrRQFxD7GTQBG3dhDEmCgzEXE2SP5yItjLPY5g99zGbvOeMqLOu9OOda
         QQrD7k4mdmonAngxP/hqHPRIfx2+HBkgRcYa6rKeHXt+2Tksm8PmZFg3Gwsc5Z5l0+
         efOaq/jgP8C51k6/vMgWA3KL1BiHDqQn/+tdZwrYadVlwbxoSZNLDIHRPKm6ykWAqW
         Pir9K5gA1Te+m/dhTol5nFpJ3ywwi9xkFRmcITVcWpUTupkrqpPYU+6psCQ7AmWC3d
         eVCtwsDF9j9ArkOAyFfwmDnvIBpUrBlcn/o/DCaAGV3/gne6s9y4aJxrhcFTT+FiXd
         h24ErEQYO6Lqg==
From:   cem@kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [PATCH V2] mkfs: Improve warning when AG size is a multiple of stripe width
Date:   Fri, 15 Sep 2023 12:22:46 +0200
Message-Id: <20230915102246.108709-1-cem@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Carlos Maiolino <cmaiolino@redhat.com>

The current output message prints out a suggestion of an AG size to be
used in lieu of the user-defined one.
The problem is this suggestion is printed in filesystem blocks, without
specifying the suffix to be used.

This patch tries to make user's life easier by outputing the option as
it should be used by the mkfs, so users can just copy/paste it.

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---

V2:
	- Keep printing it in FSBs, just add the agsize= and the 'b' suffix at
	  the end

 mkfs/xfs_mkfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index d3a15cf44..b61934e57 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3179,9 +3179,9 @@ _("agsize rounded to %lld, sunit = %d\n"),
 		if (cli_opt_set(&dopts, D_AGCOUNT) ||
 		    cli_opt_set(&dopts, D_AGSIZE)) {
 			printf(_(
-"Warning: AG size is a multiple of stripe width.  This can cause performance\n\
-problems by aligning all AGs on the same disk.  To avoid this, run mkfs with\n\
-an AG size that is one stripe unit smaller or larger, for example %llu.\n"),
+"Warning: AG size is a multiple of stripe width. This can cause performance\n\
+problems by aligning all AGs on the same disk. To avoid this, run mkfs with\n\
+an AG size that is one stripe unit smaller or larger, for example: agsize=%llub\n"),
 				(unsigned long long)cfg->agsize - dsunit);
 			fflush(stdout);
 			goto validate;
-- 
2.39.2

