Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54365711DB6
	for <lists+linux-xfs@lfdr.de>; Fri, 26 May 2023 04:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233448AbjEZCUh (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 25 May 2023 22:20:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjEZCUg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:20:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7885D187
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:20:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1612D64A68
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:20:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 752ABC433D2;
        Fri, 26 May 2023 02:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685067633;
        bh=eMMGTxutoh2MbA5Irl799e1xcj5R7cCP5D1WwCk6JkA=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=A3xvNRR+pa+0cyA0UpOWSM0MGpZLSB6nGlVwMXvIvG813y/QZP/kZ5jT1wRpevU1A
         SDVd4RKRzgx5EvTNd5yLqgx7wI+sM/ATbkDpJcNnjj++juKiq+vdm/7O98FJNM2/aO
         fWJBV0Pe5Zq9KEwwZdhUbNIe3a/N4NGVhNNYivnEx5/om/vghXpSvc5cwegDfmrMfX
         PqCxGnLIEC0BD9KpLrZ5MMsTkRjTD4K6SQt+YY5/Mrv8voqFBKI60P1m7sSmVX4+H5
         ry5g8Jm2kAMYmIPZDiThyBfJb7/7UZ2Xgcrxwl/UExGvXAP2db620KF+VFbz9bXZpX
         SHRFCyCEPiyvw==
Date:   Thu, 25 May 2023 19:20:33 -0700
Subject: [PATCH 05/10] xfs: use helpers to extract xattr op from opflags
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506077502.3749126.16260179667138628033.stgit@frogsfrogsfrogs>
In-Reply-To: <168506077431.3749126.3177791326683307311.stgit@frogsfrogsfrogs>
References: <168506077431.3749126.3177791326683307311.stgit@frogsfrogsfrogs>
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

Create helper functions to extract the xattr op from the ondisk xattri
log item and the incore attr intent item.  These will get more use in
the patches that follow.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_attr.h |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index e4f55008552..4bacafa59a4 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -529,6 +529,11 @@ struct xfs_attr_intent {
 	struct xfs_bmbt_irec		xattri_map;
 };
 
+static inline unsigned int
+xfs_attr_intent_op(const struct xfs_attr_intent *attr)
+{
+	return attr->xattri_op_flags & XFS_ATTRI_OP_FLAGS_TYPE_MASK;
+}
 
 /*========================================================================
  * Function prototypes for the kernel.

