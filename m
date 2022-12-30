Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 750F9659CC1
	for <lists+linux-xfs@lfdr.de>; Fri, 30 Dec 2022 23:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235589AbiL3W1B (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 17:27:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235585AbiL3W1B (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:27:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F8C41D0DF
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:27:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51EE6B81C22
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:26:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D917C433D2;
        Fri, 30 Dec 2022 22:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672439218;
        bh=+z0Xex8pu8ck8t5nG7wR7aHR6NJsMp6FdtjhkJkPPYs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=gVZwx2TiSuYxEjUxguUrE3LPukdhNVBD28QSA0pDyV3uqVr4dzrwohzpIB1oGcgoL
         v4qTTghGPY6q4viLmWIzkceFlkgSEU3fl3NCnYDYslVijb4SGPeXP/SvCkM7j8h//O
         WueY47sBwQ2+ha72YasrJmczvETRuU4+Zr+CV0MUhUyhYFf8K4QmNO6SaiXzeY7kKK
         V7lLNFQR5JImr+tn5Y4jYcMiDv/fd19iPMRLXB2NEBKLVZnMudvcSrkFdcU/8PX4OG
         GbVMVQQOyfxn7aSafVTuSfr4BZusBvX9fjLUK9vCJC99cvvWV5Ub0QA7+L3zTJdRiL
         9/F0EjSR9H0WA==
Subject: [PATCHSET v24.0 0/4] xfs: fix iget/irele usage in online fsck
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:35 -0800
Message-ID: <167243829551.684831.7487988225134202107.stgit@magnolia>
In-Reply-To: <Y69UceeA2MEpjMJ8@magnolia>
References: <Y69UceeA2MEpjMJ8@magnolia>
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

Hi all,

This patchset fixes a handful of problems relating to how we get and
release incore inodes in the online scrub code.  The first patch fixes
how we handle DONTCACHE -- our reasons for setting (or clearing it)
depend entirely on the runtime environment at irele time.  Hence we can
refactor iget and irele to use our own wrappers that set that context
appropriately.

The second patch fixes a race between the iget call in the inode core
scrubber and other writer threads that are allocating or freeing inodes
in the same AG by changing the behavior of xchk_iget (and the inode core
scrub setup function) to return either an incore inode or the AGI buffer
so that we can be sure that the inode cannot disappear on us.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-iget-fixes
---
 fs/xfs/scrub/bmap.c   |    2 
 fs/xfs/scrub/common.c |  267 +++++++++++++++++++++++++++++++++++++++++--------
 fs/xfs/scrub/common.h |   10 ++
 fs/xfs/scrub/dir.c    |    2 
 fs/xfs/scrub/inode.c  |  180 ++++++++++++++++++++++++++++-----
 fs/xfs/scrub/parent.c |    9 +-
 fs/xfs/scrub/scrub.c  |    2 
 fs/xfs/xfs_icache.c   |    3 -
 fs/xfs/xfs_icache.h   |   11 +-
 9 files changed, 398 insertions(+), 88 deletions(-)

