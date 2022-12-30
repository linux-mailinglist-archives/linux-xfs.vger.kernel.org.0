Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FDD665A0E4
	for <lists+linux-xfs@lfdr.de>; Sat, 31 Dec 2022 02:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236051AbiLaBqr (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 20:46:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231435AbiLaBqq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:46:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 856EA13EA6
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:46:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 219AA61CBE
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:46:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 812FBC433D2;
        Sat, 31 Dec 2022 01:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451204;
        bh=H7tChPkvpO6fikFmVinsGspoTZkvt/8/jQtoseic9p4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=vQGoQ1hNexsvwz1w6n8jKPiDqxcRgXVWDFFJiyLZTHKMY5NOKX6AeqsIPnKZVPuE/
         UQc+l7UIt0GetRdf7B0JhwcTGVyjrBiz4QvInWjVlMqdMESwUUJHVda6o4OJ6LTH4e
         KqBulm4OS/tAQUK6qCoHMcPIPrFpBhCEeGTJ9ynvZItvwtsdUQIODj+iGJjF6EA42z
         xShcoRuZihCmxk6qligHA2oqo5dlTlNRJoyIeEky7nntcvmO1YqR3+dgVu5ftnc6c7
         bD3qNBGVdIGPLF8YMrET4dMI4gmS/XHMqqKAWe6eeSzg98qPHSLXqJ/r8bRCIU47U3
         qPVjNtwFfZn+w==
Subject: [PATCH 38/38] xfs: enable realtime rmap btree
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:21 -0800
Message-ID: <167243870146.715303.3590524752697246789.stgit@magnolia>
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_super.c |    6 ------
 1 file changed, 6 deletions(-)


diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index e145de0bd562..4abeff701093 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1669,12 +1669,6 @@ xfs_fs_fill_super(
 		}
 	}
 
-	if (xfs_has_rmapbt(mp) && mp->m_sb.sb_rblocks) {
-		xfs_alert(mp,
-	"reverse mapping btree not compatible with realtime device!");
-		error = -EINVAL;
-		goto out_filestream_unmount;
-	}
 
 	if (xfs_has_large_extent_counts(mp))
 		xfs_warn(mp,

