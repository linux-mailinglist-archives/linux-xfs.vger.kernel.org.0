Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30C856F0E85
	for <lists+linux-xfs@lfdr.de>; Fri, 28 Apr 2023 00:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344333AbjD0WtN (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 27 Apr 2023 18:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344332AbjD0WtN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Apr 2023 18:49:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AECD02123
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 15:49:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CCBF64038
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 22:49:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A74C6C433D2;
        Thu, 27 Apr 2023 22:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682635751;
        bh=yFfl01x0eTU8CT1M6ReoW96Le8hyIBiRk90ejh/F5y0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lQm5jXrlYtgR0N+AiAyi0dSzcN0y1OgXmTJuZ6Eb/H4Iws486WxJvel1CI0wl+/4p
         kYcsIeGYQLD2gPQ3HRH5syVO5HqwuWfILe1c0NEBm4Sb0U6ZBRihS0Iyx2vbQfTF1k
         t+VazKldZeh17P9S8Iszpo1a+iO80OXVyirNNN2pgJWNkCRPD0z37cHgw1+BkWYLG7
         aIKT8ln+R5Yq/PDeDQWyV7FTm0uMR4dNWhlCADCHP2a/ZRZGzusJ3aSTDd88ZJ2ER7
         Pneos8klU/nsU3IggoisFCREUMqjlaUPTjm1LDSmydGBD2Ss3FgSUQmPRT2B4aTmQs
         aTYnxVYgqZZVw==
Subject: [PATCH 3/4] xfs: flush dirty data and drain directios before
 scrubbing cow fork
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     david@fromorbit.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 27 Apr 2023 15:49:11 -0700
Message-ID: <168263575120.1717721.12848317172206345585.stgit@frogsfrogsfrogs>
In-Reply-To: <168263573426.1717721.15565213947185049577.stgit@frogsfrogsfrogs>
References: <168263573426.1717721.15565213947185049577.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When we're scrubbing the COW fork, we need to take MMAPLOCK_EXCL to
prevent page_mkwrite from modifying any inode state.  The ILOCK should
suffice to avoid confusing online fsck, but let's take the same locks
that we do everywhere else.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/bmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 87ab9f95a487..69bc89d0fc68 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -42,12 +42,12 @@ xchk_setup_inode_bmap(
 	xfs_ilock(sc->ip, XFS_IOLOCK_EXCL);
 
 	/*
-	 * We don't want any ephemeral data fork updates sitting around
+	 * We don't want any ephemeral data/cow fork updates sitting around
 	 * while we inspect block mappings, so wait for directio to finish
 	 * and flush dirty data if we have delalloc reservations.
 	 */
 	if (S_ISREG(VFS_I(sc->ip)->i_mode) &&
-	    sc->sm->sm_type == XFS_SCRUB_TYPE_BMBTD) {
+	    sc->sm->sm_type != XFS_SCRUB_TYPE_BMBTA) {
 		struct address_space	*mapping = VFS_I(sc->ip)->i_mapping;
 
 		sc->ilock_flags |= XFS_MMAPLOCK_EXCL;

