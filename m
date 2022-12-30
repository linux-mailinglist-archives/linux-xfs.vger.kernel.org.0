Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96A37659CB7
	for <lists+linux-xfs@lfdr.de>; Fri, 30 Dec 2022 23:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbiL3WZL (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 17:25:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235581AbiL3WZK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:25:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 215081D0E4
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:25:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB3B261C15
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:25:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13CD3C433D2;
        Fri, 30 Dec 2022 22:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672439109;
        bh=F4yayb5jkEpVKSn1W7WEYfD7sAI1MfkDS9FslYH6jFo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=gzqbgYVuM5dw57E7KkDz+Q6c66aimfe0QtiagXazIL5X2Sfk7VDeV1ApaxUuOrvwI
         DuZjwIEvmJPrBBmX7jui7XILQtYc7OlXfGW/JuMA8mejyj6XEFdiRZvxjql6a5sPI1
         YqiZbrP2CHiyBEvrYDb4VjcN71bZSGcklAE+qhNHoyit2NGXbJAofPsbHOigcUFsVy
         pNzhmI3QHcD/SpfI75PLuU480mdljBma/xgfCBgtZWmKd4+3l9h14UWg5JFbYs9pS6
         BDE6psZob++oY7TLbOhLoo1py4C+W7ENasJsp0975AIZuIwM8EdRfG6hFHWkKWIdis
         EnNMJanOl7ZyQ==
Subject: [PATCHSET v24.0 0/8] xfs: standardize btree record checking code
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:11 -0800
Message-ID: <167243827121.683855.6049797551028464473.stgit@magnolia>
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

While I was cleaning things up for 6.1, I noticed that the btree
_query_range and _query_all functions don't perform the same checking
that the _get_rec functions perform.  In fact, they don't perform /any/
sanity checking, which means that callers aren't warned about impossible
records.

Therefore, hoist the record validation and complaint logging code into
separate functions, and call them from any place where we convert an
ondisk record into an incore record.  For online scrub, we can replace
checking code with a call to the record checking functions in libxfs,
thereby reducing the size of the codebase.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=btree-complain-bad-records

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=btree-complain-bad-records
---
 fs/xfs/libxfs/xfs_alloc.c        |   82 ++++++++++++++++++++++++---------
 fs/xfs/libxfs/xfs_alloc.h        |    6 ++
 fs/xfs/libxfs/xfs_bmap.c         |   31 ++++++++++++
 fs/xfs/libxfs/xfs_bmap.h         |    2 +
 fs/xfs/libxfs/xfs_ialloc.c       |   77 +++++++++++++++++++++----------
 fs/xfs/libxfs/xfs_ialloc.h       |    2 +
 fs/xfs/libxfs/xfs_ialloc_btree.c |    2 -
 fs/xfs/libxfs/xfs_ialloc_btree.h |    2 -
 fs/xfs/libxfs/xfs_inode_fork.c   |    3 +
 fs/xfs/libxfs/xfs_refcount.c     |   73 +++++++++++++++++++----------
 fs/xfs/libxfs/xfs_refcount.h     |    2 +
 fs/xfs/libxfs/xfs_rmap.c         |   95 ++++++++++++++++++++++++--------------
 fs/xfs/libxfs/xfs_rmap.h         |   12 +++--
 fs/xfs/scrub/alloc.c             |   24 +++++-----
 fs/xfs/scrub/bmap.c              |    6 ++
 fs/xfs/scrub/ialloc.c            |   24 ++--------
 fs/xfs/scrub/refcount.c          |   14 +-----
 fs/xfs/scrub/rmap.c              |   44 ++----------------
 18 files changed, 303 insertions(+), 198 deletions(-)

