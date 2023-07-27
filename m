Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11BEB765F3C
	for <lists+linux-xfs@lfdr.de>; Fri, 28 Jul 2023 00:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbjG0WVM (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 27 Jul 2023 18:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjG0WVL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2023 18:21:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D3CE187
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 15:21:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B78D61F57
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 22:21:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B27BC433C7;
        Thu, 27 Jul 2023 22:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690496469;
        bh=QJvSMp5wCs8GbfO3byN2l5baw/7KSE8j5Z0wQ0v1QA8=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=OAt7YpjZINrysDIGDQ2lI/kGU0mjhH2FwlhCH29RGUqD/+5INVzs7LSRqPYrvMJE+
         ItcmHxK+fqO5LfhHl3Cowjw9SWEZlY7QM0uktbv1OhQmiA4iYZxL64K13rLDOEzonX
         jBIdoE6LCqItC9pUfFC4YJ65yXBuY/4JxXhTtKZRoK9p3vAKVowcgm4oGbrH9rEDD9
         9cizwzu7ljbhT0ambHlufdJUpWs223lVT+kXlD2YAiw7FdhT9k3UHV/NKQPcCcrs5U
         kq8QmNi8fnhLbb0gzjkbv68hA7SLfoM+7+NIbOaJfpw04JAv+W/XOz6hBBvJ5zwVfY
         3VHkSQRui8dFQ==
Date:   Thu, 27 Jul 2023 15:21:08 -0700
Subject: [PATCHSET v26.0 0/6] xfs: online repair of inodes and forks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <169049626432.922543.2560381879385116722.stgit@frogsfrogsfrogs>
In-Reply-To: <20230727221158.GE11352@frogsfrogsfrogs>
References: <20230727221158.GE11352@frogsfrogsfrogs>
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

Hi all,

In this series, online repair gains the ability to repair inode records.
To do this, we must repair the ondisk inode and fork information enough
to pass the iget verifiers and hence make the inode igettable again.
Once that's done, we can perform higher level repairs on the incore
inode.  The fstests counterpart of this patchset implements stress
testing of repair.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-inodes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-inodes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-inodes
---
 fs/xfs/Makefile                    |    1 
 fs/xfs/libxfs/xfs_attr_leaf.c      |   32 -
 fs/xfs/libxfs/xfs_attr_leaf.h      |    2 
 fs/xfs/libxfs/xfs_bmap.c           |   22 
 fs/xfs/libxfs/xfs_bmap.h           |    2 
 fs/xfs/libxfs/xfs_dir2_priv.h      |    2 
 fs/xfs/libxfs/xfs_dir2_sf.c        |   29 -
 fs/xfs/libxfs/xfs_format.h         |    3 
 fs/xfs/libxfs/xfs_shared.h         |    1 
 fs/xfs/libxfs/xfs_symlink_remote.c |   21 
 fs/xfs/scrub/alloc.c               |    2 
 fs/xfs/scrub/bmap.c                |    4 
 fs/xfs/scrub/common.c              |   26 +
 fs/xfs/scrub/common.h              |    8 
 fs/xfs/scrub/dir.c                 |   21 
 fs/xfs/scrub/inode.c               |   14 
 fs/xfs/scrub/inode_repair.c        | 1607 ++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/parent.c              |   10 
 fs/xfs/scrub/repair.c              |   47 +
 fs/xfs/scrub/repair.h              |   28 +
 fs/xfs/scrub/rtbitmap.c            |    4 
 fs/xfs/scrub/rtsummary.c           |    4 
 fs/xfs/scrub/scrub.c               |    2 
 fs/xfs/scrub/trace.h               |  174 ++++
 24 files changed, 2023 insertions(+), 43 deletions(-)
 create mode 100644 fs/xfs/scrub/inode_repair.c

