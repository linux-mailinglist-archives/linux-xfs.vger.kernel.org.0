Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAD3965A122
	for <lists+linux-xfs@lfdr.de>; Sat, 31 Dec 2022 03:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236137AbiLaCCO (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 21:02:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236120AbiLaCCE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:02:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE742AF8
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:02:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C3D661C19
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:02:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 640FAC433D2;
        Sat, 31 Dec 2022 02:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452122;
        bh=66ABgFbLpUkhL6frq5OrD81i9O/fOjTxK7NVlkm9WO4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=VGgasl4wyXm6XUIs4E3SpRrcSyfBQtEUJg/k77kR9RwNyS96FMuQ8owVJmueL8Bco
         tiXgRTiOlJm69pY2YpQLlYxPuZlnU5rVPngDXB9EEa29p8do8SJfEbTHGnlWaFtqdK
         z4lb4p++bzsCGgmnNPjccv4vCTPVWgQC2hFdYsLsqwA/03Z3plXuK7m28S62xOIqqv
         ucAzVD8QImfM9pgB+f1dC1Cv7EnTM3cGELleuhLGTrRjFq23IX5gUfsRhAaf/QBHBd
         vJqV1Cl7GFaKk4EtqmsfM5DXaU5R2HCOgGlWEwn67M4WU11k66ahbT34oRv43UXAAH
         2/g/fVCFZLUQA==
Subject: [PATCH 3/3] xfs: enable realtime quota again
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:42 -0800
Message-ID: <167243872269.719004.14408029636244073820.stgit@magnolia>
In-Reply-To: <167243872224.719004.160021889997830176.stgit@magnolia>
References: <167243872224.719004.160021889997830176.stgit@magnolia>
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

Enable quotas for the realtime device.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_qm.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 7a69857c4e49..99167e3250f9 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -1493,15 +1493,9 @@ xfs_qm_mount_quotas(
 	int			error = 0;
 	uint			sbf;
 
-	/*
-	 * If quotas on realtime volumes is not supported, we disable
-	 * quotas immediately.
-	 */
-	if (mp->m_sb.sb_rextents) {
-		xfs_notice(mp, "Cannot turn on quotas for realtime filesystem");
-		mp->m_qflags = 0;
-		goto write_changes;
-	}
+	if (mp->m_sb.sb_rextents)
+		xfs_warn(mp,
+	"EXPERIMENTAL realtime quota feature in use. Use at your own risk!");
 
 	ASSERT(XFS_IS_QUOTA_ON(mp));
 

