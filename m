Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 845EF4D53FB
	for <lists+linux-xfs@lfdr.de>; Thu, 10 Mar 2022 22:54:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344141AbiCJVyq (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 10 Mar 2022 16:54:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344154AbiCJVyp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Mar 2022 16:54:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21E3114D244
        for <linux-xfs@vger.kernel.org>; Thu, 10 Mar 2022 13:53:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B2D7661AC3
        for <linux-xfs@vger.kernel.org>; Thu, 10 Mar 2022 21:53:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A777C340F5;
        Thu, 10 Mar 2022 21:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646949223;
        bh=+IbJj3gYrsl1QJORdYRwzLlxIQylK+PDHOSgT60cG88=;
        h=Subject:From:To:Cc:Date:From;
        b=cTgC2UYb8WxQG7NeXNWMTpPa8JtvFveDmXCDFQWtuf9MmfXFlk9Nms4PgYlx+p7kt
         QyoM3CG+efF7d0xFpHf9CQRuZeSxIqHgrYfhcfz1FKYzhdCq/EgnRbsOYVr/75hb7e
         hHCSp95wvMjoOEzGogOCYc6WgWkuxooNWgmGy4EMIJJLHu2mFaYneyXaNUCPAGR5VM
         n+1uMapZZ9pDdN3Mb7qA+SetMJyxHha8vlgcly+MtHi7cb8fBXBYzvzfjFYJDIpsi7
         TyX0Ok2Lh+wUVDat0A+1vmk1PbUjlxpLrNtPt0olMN4zfyHBmeG7t5IJIbM+1ldS3T
         W/iMdAd+WbXmA==
Subject: [PATCHSET v2 0/2] xfs: constify dotdot global variable
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 10 Mar 2022 13:53:42 -0800
Message-ID: <164694922267.1119724.17942999738634110525.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

I was auditing the code base when I noticed that the xfs_name_dotdot
variable is both global and mutable.  In theory, someone could change
the contents of that variable (either through misuse or by exploiting a
kernel bug) which would then break the directory code, so let's shut
down that attack surface by making it const.

v2: make the lookup function name argument const, thereby avoiding
    clunkiness in the second patch

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=constify-dotdot-5.18
---
 fs/xfs/libxfs/xfs_dir2.c      |   36 ++++++++++++++++++++----------------
 fs/xfs/libxfs/xfs_dir2.h      |    8 ++++----
 fs/xfs/libxfs/xfs_dir2_priv.h |    5 +++--
 fs/xfs/xfs_inode.c            |    6 +++---
 fs/xfs/xfs_inode.h            |    2 +-
 fs/xfs/xfs_trace.h            |    4 ++--
 6 files changed, 33 insertions(+), 28 deletions(-)

