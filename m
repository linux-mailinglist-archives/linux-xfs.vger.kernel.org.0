Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B652C40CFCF
	for <lists+linux-xfs@lfdr.de>; Thu, 16 Sep 2021 01:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbhIOXHz (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 15 Sep 2021 19:07:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:59062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231197AbhIOXHy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:07:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22CC1600D4;
        Wed, 15 Sep 2021 23:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747195;
        bh=kMbavDg8ElL5x6mviBTdurXquAYkzVHYNlZeFKp8xQM=;
        h=Subject:From:To:Cc:Date:From;
        b=M/x/p15hvT6JVs0l9q5gy4GxOCevR4LdAQe/mgraEWeCpD+8vVCjG1sddMWCI87P/
         YQuNdCoJj7vWEkqsEJSyHf93UQYkneIJSZNomLNim3BvTYCcaROdOfXM3ppuc1aet3
         PMWMv83nUCAMrI66B3OT/TS+OQ32Soa1jyh2TLFJSDY4VsI3ziLQVYgaPyFakoZNTb
         VF32q20xga5upyObqe9GbPd5wCEeFguZz4Bt5UWDk529ZHRDp0Tql/VQT1RUvMxqoa
         8chVwwJ0GwOiBX4wsyouQXSR4UXfpHEo40fXM7Fkx7BSqaHGyFfP+hO7/G5c6Ffnzi
         8v/deKX+DX12w==
Subject: [PATCHSET 00/61] xfs: sync libxfs with 5.14
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Carlos Maiolino <cmaiolino@redhat.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        Brian Foster <bfoster@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Kees Cook <keescook@chromium.org>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        Allison Henderson <allison.henderson@oracle.com>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        Carlos Maiolino <cmaiolino@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Bill O'Donnell <bodonnel@redhat.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:06:34 -0700
Message-ID: <163174719429.350433.8562606396437219220.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This patchset backports all the libxfs changes from kernel 5.14, as well
as all the related for_each_perag and fallthrough; cleanups that went
with it.  I've prepared this series and pull request per Eric's request.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=libxfs-5.14-sync
---
 db/fsmap.c                  |   17 -
 db/info.c                   |   18 -
 db/type.c                   |    2 
 growfs/xfs_growfs.c         |    6 
 include/atomic.h            |    1 
 include/libxfs.h            |    3 
 include/linux.h             |   17 +
 include/xfs_mount.h         |   65 ---
 include/xfs_multidisk.h     |    5 
 libfrog/Makefile            |    3 
 libfrog/mockups.h           |   43 ++
 libfrog/radix-tree.h        |    3 
 libxfs/Makefile             |   10 
 libxfs/init.c               |  147 +++----
 libxfs/libxfs_api_defs.h    |    2 
 libxfs/libxfs_priv.h        |   18 +
 libxfs/topology.c           |    5 
 libxfs/topology.h           |    6 
 libxfs/util.c               |   12 -
 libxfs/xfs_ag.c             |  287 +++++++++++++
 libxfs/xfs_ag.h             |  136 ++++++
 libxfs/xfs_ag_resv.c        |   15 -
 libxfs/xfs_ag_resv.h        |   15 +
 libxfs/xfs_alloc.c          |  113 +++--
 libxfs/xfs_alloc.h          |    2 
 libxfs/xfs_alloc_btree.c    |   31 +
 libxfs/xfs_alloc_btree.h    |    9 
 libxfs/xfs_attr.c           |  956 ++++++++++++++++++++++++++-----------------
 libxfs/xfs_attr.h           |  403 ++++++++++++++++++
 libxfs/xfs_attr_leaf.c      |    5 
 libxfs/xfs_attr_leaf.h      |    2 
 libxfs/xfs_attr_remote.c    |  167 +++-----
 libxfs/xfs_attr_remote.h    |    8 
 libxfs/xfs_bmap.c           |    3 
 libxfs/xfs_bmap.h           |    1 
 libxfs/xfs_btree.c          |   15 -
 libxfs/xfs_btree.h          |   12 -
 libxfs/xfs_da_btree.c       |    2 
 libxfs/xfs_ialloc.c         |  696 ++++++++++++++++---------------
 libxfs/xfs_ialloc.h         |   43 --
 libxfs/xfs_ialloc_btree.c   |   46 +-
 libxfs/xfs_ialloc_btree.h   |   13 -
 libxfs/xfs_inode_buf.c      |   30 +
 libxfs/xfs_log_format.h     |   14 -
 libxfs/xfs_refcount.c       |  122 +++--
 libxfs/xfs_refcount.h       |    9 
 libxfs/xfs_refcount_btree.c |   39 +-
 libxfs/xfs_refcount_btree.h |    7 
 libxfs/xfs_rmap.c           |  147 +++----
 libxfs/xfs_rmap.h           |    6 
 libxfs/xfs_rmap_btree.c     |   46 +-
 libxfs/xfs_rmap_btree.h     |    8 
 libxfs/xfs_sb.c             |  145 -------
 libxfs/xfs_sb.h             |    9 
 libxfs/xfs_shared.h         |   20 -
 libxfs/xfs_trans_inode.c    |   10 
 libxfs/xfs_types.c          |    4 
 libxfs/xfs_types.h          |    1 
 mkfs/proto.c                |    1 
 mkfs/proto.h                |   13 +
 mkfs/xfs_mkfs.c             |   11 
 repair/agbtree.c            |   28 +
 repair/agbtree.h            |    8 
 repair/dinode.c             |   18 -
 repair/phase4.c             |    4 
 repair/phase5.c             |   16 -
 repair/rmap.c               |   43 +-
 repair/sb.c                 |    1 
 repair/scan.c               |    4 
 scrub/inodes.c              |    2 
 scrub/repair.c              |    2 
 scrub/scrub.c               |    8 
 72 files changed, 2520 insertions(+), 1619 deletions(-)
 create mode 100644 libfrog/mockups.h
 rename libfrog/topology.c => libxfs/topology.c (99%)
 rename libfrog/topology.h => libxfs/topology.h (88%)
 create mode 100644 mkfs/proto.h

