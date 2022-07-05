Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDCBB5679F1
	for <lists+linux-xfs@lfdr.de>; Wed,  6 Jul 2022 00:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230438AbiGEWJg (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 5 Jul 2022 18:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiGEWJg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jul 2022 18:09:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B42A6193C5
        for <linux-xfs@vger.kernel.org>; Tue,  5 Jul 2022 15:09:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5030C61C19
        for <linux-xfs@vger.kernel.org>; Tue,  5 Jul 2022 22:09:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9BCCC341C8;
        Tue,  5 Jul 2022 22:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657058974;
        bh=ct3yZZBzMtMZBEb2nhBtmYhmOYFn0DWyVZZR2GQE2Gg=;
        h=Subject:From:To:Cc:Date:From;
        b=XHVUbcVtEoYuj420T9QNJlF9Sy1bsH3cIv0NEhrMlzDP57DT5wutC9S6B4DEIR44d
         srLQ/l2w/w3JUw4YxL+n1Ms7vXWVZCUp+66cUQbEnGKp/8C9kWxsCdvyOawqXLIB48
         v8LHews3HHbYUC0BYxL+dUG7OwEke6tgU4m0DZebZx9dfykb5VApoyFl5iTLwJ7b3z
         mwFxHHOQ0a0WxkSIC4F26qDcJz5YfHAc234JNgXxskclJFORLSACoQVs31JgcopwgT
         Zd3jcquKS6R8TQC501YcrbAgHh5mZOBcxPfiRyw4vYNB70vBXb9XGwSyLSOHBlWyYa
         eSOvT/S5e6F0g==
Subject: [PATCHSET 0/3] xfs: make attr forks permanent
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Tue, 05 Jul 2022 15:09:34 -0700
Message-ID: <165705897408.2826746.14673631830829415034.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series fixes a use-after-free bug that syzbot uncovered.  The UAF
itself is a result of a race condition between getxattr and removexattr
because callers to getxattr do not necessarily take any sort of locks
before calling into the filesystem.

Although the race condition itself can be fixed through clever use of a
memory barrier, further consideration of the use cases of extended
attributes shows that most files always have at least one attribute, so
we might as well make them permanent.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=make-attr-fork-permanent-5.20
---
 fs/xfs/libxfs/xfs_attr.c           |   16 ++++----
 fs/xfs/libxfs/xfs_attr.h           |   10 +++--
 fs/xfs/libxfs/xfs_attr_leaf.c      |   27 +++++++-------
 fs/xfs/libxfs/xfs_bmap.c           |   71 ++++++++++++++++++------------------
 fs/xfs/libxfs/xfs_bmap_btree.c     |    8 ++--
 fs/xfs/libxfs/xfs_btree.c          |    4 +-
 fs/xfs/libxfs/xfs_dir2_block.c     |    2 +
 fs/xfs/libxfs/xfs_dir2_sf.c        |    2 +
 fs/xfs/libxfs/xfs_inode_buf.c      |    7 ++--
 fs/xfs/libxfs/xfs_inode_fork.c     |   55 ++++++++++++++++------------
 fs/xfs/libxfs/xfs_inode_fork.h     |   11 ++----
 fs/xfs/libxfs/xfs_symlink_remote.c |    2 +
 fs/xfs/scrub/bmap.c                |   14 ++++---
 fs/xfs/scrub/dabtree.c             |    2 +
 fs/xfs/scrub/dir.c                 |    2 +
 fs/xfs/scrub/quota.c               |    2 +
 fs/xfs/scrub/symlink.c             |    2 +
 fs/xfs/xfs_attr_inactive.c         |   12 ++----
 fs/xfs/xfs_attr_list.c             |    9 ++---
 fs/xfs/xfs_bmap_util.c             |   12 +++---
 fs/xfs/xfs_dir2_readdir.c          |    2 +
 fs/xfs/xfs_icache.c                |   12 +++---
 fs/xfs/xfs_inode.c                 |   18 +++++----
 fs/xfs/xfs_inode.h                 |   22 +++++++++++
 fs/xfs/xfs_inode_item.c            |   50 +++++++++++++------------
 fs/xfs/xfs_ioctl.c                 |    2 +
 fs/xfs/xfs_iomap.c                 |    8 ++--
 fs/xfs/xfs_itable.c                |    2 +
 fs/xfs/xfs_qm.c                    |    2 +
 fs/xfs/xfs_reflink.c               |    6 ++-
 30 files changed, 203 insertions(+), 191 deletions(-)

