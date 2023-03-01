Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 097956A65F9
	for <lists+linux-xfs@lfdr.de>; Wed,  1 Mar 2023 03:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbjCAC7M (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 28 Feb 2023 21:59:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjCAC7M (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Feb 2023 21:59:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 391174C14;
        Tue, 28 Feb 2023 18:59:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9DD86122C;
        Wed,  1 Mar 2023 02:59:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3052BC433D2;
        Wed,  1 Mar 2023 02:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677639550;
        bh=2XUqCDN5obPTVw6gdUTST5T79HLXXgbtO6UGKb5NSBo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=q6YHsriHGOXuuLsASr8DDLmaQkzQ1Zarih2Bb5J5NMmcKLvgUrEqKQtPUaQQZhYV1
         o6eqwPWCv9Zr0ENNjLX/nDUb8F/A3f/D9Xaya7ikB2e9MliYgV9e/V/2jZiIdvP8Qj
         14W2LOR19yVCSXbrOWKFnYaV0+/XV31iwY2C3HuAnnfm/9799eUs4TfUpseurfJ9NU
         Ov0miAz+R5+CzrUNTbmyXNO/rcGH1EBL7HhhPqxSEUm/eRPMOdthwyLKQGZxV8rI2V
         OPNmzl4dTWKBx26fDVyCaugDGRd1oIUpk4YhTOAB2RmnTsQptOBLAm7Jgf5oeT3p7F
         ttWag8mvp4mzA==
Subject: [PATCH 1/7] xfs/122: fix for swapext log items
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 28 Feb 2023 18:59:09 -0800
Message-ID: <167763954976.3796922.18383591838839702382.stgit@magnolia>
In-Reply-To: <167763954409.3796922.11086772690906428270.stgit@magnolia>
References: <167763954409.3796922.11086772690906428270.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Add entries for the extent swapping log items.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/122.out |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index 95e53c5081..21549db7fd 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -117,6 +117,9 @@ sizeof(struct xfs_rtrmap_root) = 4
 sizeof(struct xfs_rud_log_format) = 16
 sizeof(struct xfs_rui_log_format) = 16
 sizeof(struct xfs_scrub_metadata) = 64
+sizeof(struct xfs_swap_extent) = 64
+sizeof(struct xfs_sxd_log_format) = 16
+sizeof(struct xfs_sxi_log_format) = 80
 sizeof(struct xfs_unmount_log_format) = 8
 sizeof(xfs_agf_t) = 224
 sizeof(xfs_agfl_t) = 36

