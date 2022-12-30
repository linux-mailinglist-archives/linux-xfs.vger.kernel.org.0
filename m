Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 599F665A24F
	for <lists+linux-xfs@lfdr.de>; Sat, 31 Dec 2022 04:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236216AbiLaDOJ (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 22:14:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236337AbiLaDN4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:13:56 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 159B8E59;
        Fri, 30 Dec 2022 19:13:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 82C8ACE1A94;
        Sat, 31 Dec 2022 03:13:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB77EC433D2;
        Sat, 31 Dec 2022 03:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456432;
        bh=meNQWhIdgExk3OmYrYAIE3I3rJnTZeaV6Ah+wXLtDw8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ItBRBD7p+qMWSP/MJTZvKI7CXEJHQ0SjPOV8FsVmi8isGjsZbhr0bdeWRnrhT/pJq
         pTLG1Z9slxQrTMZP6NP+bjU44AtQx6pSYcLdmm9YwwMikWnSB50FjO5xT0uwJMTmqE
         SiANbKJZzFPe7gU9zhM9cA4PN9vKZe6scxBDfLIdmRtuHZikB8kJ27iO3IPu5cMuyQ
         ePXNNKekgXdNJ8tP+K/reD2syea3XGfbBQviCORy+TDFMohz+ceAAtFPkra/uNI097
         prtzTTOoj6P//e8m1l3r87nVUDaejtCo+0wOTLgcIMO1Me7Syu4IzIJK3hrJAo31sn
         hIiE3BwJk53Fw==
Subject: [PATCH 05/13] xfs/122: update for rtgroups-based realtime rmap btrees
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:44 -0800
Message-ID: <167243884461.739669.12021078942237159704.stgit@magnolia>
In-Reply-To: <167243884390.739669.13524725872131241203.stgit@magnolia>
References: <167243884390.739669.13524725872131241203.stgit@magnolia>
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

Now that we've redesigned realtime rmap to require that the rt section
be sharded into allocation groups of no more than 2^31 blocks, we've
reduced the size of the ondisk structures and therefore need to update
this test.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/122.out |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/tests/xfs/122.out b/tests/xfs/122.out
index 53eff0027e..e0801f9660 100644
--- a/tests/xfs/122.out
+++ b/tests/xfs/122.out
@@ -116,8 +116,8 @@ sizeof(struct xfs_rmap_key) = 20
 sizeof(struct xfs_rmap_rec) = 24
 sizeof(struct xfs_rtbuf_blkinfo) = 48
 sizeof(struct xfs_rtgroup_geometry) = 128
-sizeof(struct xfs_rtrmap_key) = 24
-sizeof(struct xfs_rtrmap_rec) = 32
+sizeof(struct xfs_rtrmap_key) = 20
+sizeof(struct xfs_rtrmap_rec) = 24
 sizeof(struct xfs_rtrmap_root) = 4
 sizeof(struct xfs_rtsb) = 104
 sizeof(struct xfs_rud_log_format) = 16

