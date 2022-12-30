Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0184659F6F
	for <lists+linux-xfs@lfdr.de>; Sat, 31 Dec 2022 01:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235928AbiLaATC (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 19:19:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235908AbiLaAS7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:18:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F264C193DB
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:18:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8EE1A61D11
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:18:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED38BC433EF;
        Sat, 31 Dec 2022 00:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672445938;
        bh=F1pQF2eEc8zmEXMo4ohfMkmpyRZkOG7s7L3sMhzMe/Y=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=aUe2MaXyFN00kGeiF0rqQkz3ENLo0yOGSqK8tGt/pyE8q6ipzfRIkfsI1++Gu0nYl
         z/rnnVyX+E2guVqHUVrgaUAaggGK19Cz07ek+dzlNkT9Acw6/Qk7Q/oy61TzHC/GNM
         dZl9TKNQpuMQPs09WFBRxSOqUSHxGkJCl8D4S0xywoXqVu0AC03nfhQXq0t1hTcViC
         o2Ua1z5ih8dFDBfFkrXBvL5h9SgDME7VwIoMgMfviIqvfmutYUzT9jUwOXOswLRrOC
         JTIBKxaFXLhmLQUyNmu+JQi1R3ne7WWyMkfZ0EbCT3RWxBUIKEsWaRTrKw+7n+Q8b5
         oaCm+51vPeyrw==
Subject: [PATCH 01/19] vfs: introduce new file range exchange ioctl
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:59 -0800
Message-ID: <167243867953.713817.9258434191329480531.stgit@magnolia>
In-Reply-To: <167243867932.713817.982387501030567647.stgit@magnolia>
References: <167243867932.713817.982387501030567647.stgit@magnolia>
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

Introduce a new ioctl to handle swapping contents between two files.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_fs.h |    1 +
 1 file changed, 1 insertion(+)


diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 400cf68e551..210c17f5a16 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -841,6 +841,7 @@ struct xfs_scrub_metadata {
 #define XFS_IOC_FSGEOMETRY	     _IOR ('X', 126, struct xfs_fsop_geom)
 #define XFS_IOC_BULKSTAT	     _IOR ('X', 127, struct xfs_bulkstat_req)
 #define XFS_IOC_INUMBERS	     _IOR ('X', 128, struct xfs_inumbers_req)
+/*	FIEXCHANGE_RANGE ----------- hoisted 129	 */
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
 
 

