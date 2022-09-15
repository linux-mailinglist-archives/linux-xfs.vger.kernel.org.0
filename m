Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 277825B9B89
	for <lists+linux-xfs@lfdr.de>; Thu, 15 Sep 2022 15:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbiIONDV (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Thu, 15 Sep 2022 09:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiIONDU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Sep 2022 09:03:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D509C234
        for <linux-xfs@vger.kernel.org>; Thu, 15 Sep 2022 06:03:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 999946238D
        for <linux-xfs@vger.kernel.org>; Thu, 15 Sep 2022 13:03:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BCD2C433C1
        for <linux-xfs@vger.kernel.org>; Thu, 15 Sep 2022 13:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663246994;
        bh=mL2lu8W/0IAg6eqeSP/zw1VDiQE4AmASuiuYJIHVp1k=;
        h=Date:From:To:Subject:From;
        b=LtV369JLUaPTnZWYvoZp3KiGSHImgaCM91F8S8yaCQJE7cA+VJ5KgQ2Psy8C2PWek
         7UYNCl9ZOvmsRp6XtgLTwb0MTrOpzLM2HZlLFP8+BqgdhJDr7wpoqPDlncGAhCmCul
         R6BKmQ7+Uh0ylCkC77WbBXZB7KZFiC304bvxvQTISJnZXB7zx4lAvsLl8GFGoHmgid
         VLBPeeMd4Ezu6h4mmwGHHwa26hsPKON0g7NgyfjaC6s4kqPc9FGn0/P7UsnnH7tBFL
         24IeI755a5luj/9RImVGuUfWUsGcIvUPKiUIDqmlGF0G0s7BKpGvFnOuM47h+0kRo1
         esDcUDS+sICww==
Date:   Thu, 15 Sep 2022 15:03:09 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsprogs updated to 6.0.0-rc0
Message-ID: <20220915130309.a72eyhog3jayy6rf@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/

has just benn updated.

This is essentially a fast-forward merge from for-next branch, containing only
libxfs-sync patches.

Any questions, please let me know.


The new head of the master branch is commit:

3c6e12a4a xfsprogs: Release v6.0.0-rc0

New Commits:

Andrey Strachuk (1):
      [798d43495] 798d43495

Carlos Maiolino (1):
      [3c6e12a4a] 3c6e12a4a

Dan Carpenter (1):
      [17df7eb7e] 17df7eb7e

Darrick J. Wong (6):
      [722e81c12] 722e81c12
      [7ff5f1edf] 7ff5f1edf
      [d4292c669] d4292c669
      [4f8415858] 4f8415858
      [eae3e30d4] eae3e30d4
      [e373f06a3] e373f06a3

Dave Chinner (17):
      [ef78f876e] ef78f876e
      [37dc5890e] 37dc5890e
      [4330a9e00] 4330a9e00
      [87db57baf] 87db57baf
      [f9084bd95] f9084bd95
      [bc87af992] bc87af992
      [c1030eda4] c1030eda4
      [1d202c10b] 1d202c10b
      [9a73333d9] 9a73333d9
      [75c01cccf] 75c01cccf
      [83af0d13a] 83af0d13a
      [8aa34dc9b] 8aa34dc9b
      [cee2d89ae] cee2d89ae
      [54f6b9e5e] 54f6b9e5e
      [0b2f4162b] 0b2f4162b
      [69535dadf] 69535dadf
      [b9846dc9e] b9846dc9e

Slark Xiao (1):
      [e4a32219d] e4a32219d

Xiaole He (1):
      [ec36ecd2d] ec36ecd2d

hexiaole (1):
      [d3e53ab7c] d3e53ab7c


Code Diffstat:

 VERSION                     |   6 +--
 configure.ac                |   2 +-
 db/fsmap.c                  |   2 +-
 db/info.c                   |   2 +-
 db/namei.c                  |   2 +-
 include/xfs_inode.h         |  65 ++++++++++++++++++++++++++-
 libxfs/defer_item.c         |   6 ++-
 libxfs/init.c               |   3 +-
 libxfs/libxfs_api_defs.h    |   1 +
 libxfs/libxfs_priv.h        |  12 +++--
 libxfs/rdwr.c               |   8 ++--
 libxfs/util.c               |   7 +--
 libxfs/xfs_ag.c             | 171 ++++++++++++++++++++++++++++++++++++++++++++++------------------------
 libxfs/xfs_ag.h             |  75 +++++++++++++++++++++++++------
 libxfs/xfs_ag_resv.c        |   2 +-
 libxfs/xfs_alloc.c          | 145 ++++++++++++++++++++++++++---------------------------------
 libxfs/xfs_alloc.h          |  58 +++++-------------------
 libxfs/xfs_alloc_btree.c    |   9 ++--
 libxfs/xfs_attr.c           |  22 +++++----
 libxfs/xfs_attr.h           |  10 ++---
 libxfs/xfs_attr_leaf.c      |  28 ++++++------
 libxfs/xfs_attr_remote.c    |  15 ++++---
 libxfs/xfs_bmap.c           |  84 +++++++++++++++++-----------------
 libxfs/xfs_bmap_btree.c     |  10 ++---
 libxfs/xfs_btree.c          |  29 +++++-------
 libxfs/xfs_dir2.c           |   2 +-
 libxfs/xfs_dir2_block.c     |   6 +--
 libxfs/xfs_dir2_sf.c        |   8 ++--
 libxfs/xfs_format.h         |   2 +-
 libxfs/xfs_ialloc.c         |  86 +++++++++++++++--------------------
 libxfs/xfs_ialloc.h         |  25 ++---------
 libxfs/xfs_ialloc_btree.c   |  20 ++++-----
 libxfs/xfs_inode_buf.c      |  15 +++----
 libxfs/xfs_inode_fork.c     |  65 ++++++++++++++-------------
 libxfs/xfs_inode_fork.h     |  27 ++---------
 libxfs/xfs_refcount.c       |  19 ++++----
 libxfs/xfs_refcount_btree.c |   5 +--
 libxfs/xfs_rmap.c           |   8 ++--
 libxfs/xfs_rmap_btree.c     |   9 ++--
 libxfs/xfs_symlink_remote.c |   2 +-
 libxfs/xfs_trans_resv.c     |   2 +-
 libxfs/xfs_types.c          |  73 ++++--------------------------
 libxfs/xfs_types.h          |   9 ----
 mkfs/proto.c                |   2 +-
 repair/dino_chunks.c        |  12 +++--
 repair/dinode.c             |   5 ++-
 repair/phase6.c             |  11 ++---
 repair/quotacheck.c         |   4 +-
 repair/rmap.c               |  16 ++++---
 repair/scan.c               |  70 +++++++++++++++++++++--------
 50 files changed, 660 insertions(+), 617 deletions(-)

-- 
Carlos Maiolino
