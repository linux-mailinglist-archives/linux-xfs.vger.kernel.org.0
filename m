Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A185D65A079
	for <lists+linux-xfs@lfdr.de>; Sat, 31 Dec 2022 02:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236057AbiLaBUr (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 20:20:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236061AbiLaBUr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:20:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 014B721BC
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:20:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1F03B81DF6
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:20:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 635CAC433D2;
        Sat, 31 Dec 2022 01:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672449643;
        bh=RqY0WPRQE83k3gVrbDWfrZnxRAP4pIo10vWFaZLVg4Q=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=jqkXesoZRltnEcvhg27Vu2IGfl2LE1k86k5eFnFBvGi6hZMzrRlP1Z1nJQiauVoFy
         /WXZWeCt6IRtmaUWFPnQo5C+ih61OJ6RUScXnRczFb9odqreqSTsb5EZR3gV8Q3kRv
         gfYh3dIditZ2Re2UMzVQam9GlRg/iXt4YLpIHi5A3aGer8KhA6nGp++sf5ftfDWM8G
         SugVR3vSgYRygh8cBGQ2TkgLCleGbUUV97Zg6i5bi2fQbu5xo01eRDH+VHmoRGjUM4
         QMRUgOIoEHOV8Pgx7nihoi3VlFKDRWnWVU+0J/4fRkMle9PZMvbhi8NdoTcEU8i2kq
         Dr7tRx1p8jnlQ==
Subject: [PATCH 03/11] xfs: prevent rt growfs when quota is enabled
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:36 -0800
Message-ID: <167243865660.709511.1241958901947112425.stgit@magnolia>
In-Reply-To: <167243865605.709511.15650588946095003543.stgit@magnolia>
References: <167243865605.709511.15650588946095003543.stgit@magnolia>
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

Quotas aren't (yet) supported with realtime, so we shouldn't allow
userspace to set up a realtime section when quotas are enabled, even if
they attached one via mount options.  IOWS, you shouldn't be able to do:

# mkfs.xfs -f /dev/sda
# mount /dev/sda /mnt -o rtdev=/dev/sdb
# xfs_growfs -r /mnt

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_rtalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 726e3cec34d5..3ac8ca845239 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -959,7 +959,7 @@ xfs_growfs_rt(
 		return -EINVAL;
 
 	/* Unsupported realtime features. */
-	if (xfs_has_rmapbt(mp) || xfs_has_reflink(mp))
+	if (xfs_has_rmapbt(mp) || xfs_has_reflink(mp) || xfs_has_quota(mp))
 		return -EOPNOTSUPP;
 
 	nrblocks = in->newblocks;

