Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD55670F40
	for <lists+linux-xfs@lfdr.de>; Wed, 18 Jan 2023 01:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbjARA6T (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 17 Jan 2023 19:58:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbjARA56 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Jan 2023 19:57:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A6759E4C
        for <linux-xfs@vger.kernel.org>; Tue, 17 Jan 2023 16:44:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 792046159B
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 00:44:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9724C433D2;
        Wed, 18 Jan 2023 00:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674002689;
        bh=9CvFS7Jlh4TUywGMnINuqVzphG9r07051N4y6vVQuGY=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=J7ETpvUDWHgWXTuzDSjURzCL2ecivjtVJRL2+fK1D4ZUELbqDzzssTayZV9O3ZLzl
         QCc/RDs1pVJ5xgY9WGYulRLacdWld4ceUuceW9vzeSP/O6k9fsj1wr4FUShNE1cEw5
         2j7f+O+6qzOpRC8LMUyYLDp0O+t3zLochh8pDg8FVevgv8IZtVJdhauxGqCfzXkZum
         A+uyH6eHP6b13kVz9ASjoDRwoj8oe8UegKTIvmF2DFgs69+8a8wyECsJSmsO8BnN2h
         7nWhhVdWW0JcK7CjTdvSraaN6m22zojOZCp5yFTAte/iCLFQhiUSIMshT7pnJS1vVN
         jZBZANjgquL6w==
Date:   Tue, 17 Jan 2023 16:44:49 -0800
Subject: [PATCH 1/3] design: update group quota inode information for v5
 filesystems
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, chandan.babu@oracle.com,
        allison.henderson@oracle.com
Message-ID: <167400163292.1925795.12938763753506074554.stgit@magnolia>
In-Reply-To: <167400163279.1925795.1487663139527842585.stgit@magnolia>
References: <167400163279.1925795.1487663139527842585.stgit@magnolia>
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

Fix a few out of date statements about the group quota inode field on v5
filesystems.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 .../allocation_groups.asciidoc                     |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)


diff --git a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
index 0e48b4bf..7ee5d561 100644
--- a/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
+++ b/design/XFS_Filesystem_Structure/allocation_groups.asciidoc
@@ -262,11 +262,12 @@ maintained in the first superblock.
 *sb_uquotino*::
 Inode for user quotas. This and the following two quota fields only apply if
 +XFS_SB_VERSION_QUOTABIT+ flag is set in +sb_versionnum+. Refer to
-xref:Quota_Inodes[quota inodes] for more information
+xref:Quota_Inodes[quota inodes] for more information.
 
 *sb_gquotino*::
-Inode for group or project quotas. Group and Project quotas cannot be used at
-the same time.
+Inode for group or project quotas. Group and project quotas cannot be used at
+the same time on v4 filesystems.  On a v5 filesystem, this inode always stores
+group quota information.
 
 *sb_qflags*::
 Quota flags. It can be a combination of the following flags:

