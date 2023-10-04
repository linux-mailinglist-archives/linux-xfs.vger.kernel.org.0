Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF287B98B4
	for <lists+linux-xfs@lfdr.de>; Thu,  5 Oct 2023 01:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230381AbjJDXc2 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 4 Oct 2023 19:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbjJDXc1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Oct 2023 19:32:27 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E2DC0
        for <linux-xfs@vger.kernel.org>; Wed,  4 Oct 2023 16:32:24 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F13AEC433C8;
        Wed,  4 Oct 2023 23:32:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696462344;
        bh=kweq5u7ow4YjzNvrQnxYLlILtr1yI6Bc+wSZwKCNGGQ=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=Uw8JevrOqpTvcodyudeZvEwGufpUN/huPMhokbcz9u83QrxyIlDR9bWLbU6LdRFBc
         aPx36yB7BmVHhFtBO1EEknkMkn/sBJi+m9nA6WxvBq4oSQUoQAlAPTVDW6aCkRL2qU
         /DYLSBLDRZsunjdD/hsjKNtiofkDqxW/wYpkMeDd4tkUFaNstE+2HrI/7id+q69pb5
         qY9CG0eEzonWBPoapHGpQ807R7Lib0/+KkBbG8j58JA4KQGzjXN/EbwY41Sn8tT6oO
         tiEtGxpktKa65j99QUnj0Vs2co1ahubY2W1oMggaXrCN+FGU4lpFCyQZnP7JGesUsr
         g4ke9I4SbPkSA==
Date:   Wed, 4 Oct 2023 16:32:23 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCHSET v27.0 0/7] xfs: reserve disk space for online repairs
Message-ID: <20231004233223.GK21298@frogsfrogsfrogs>
References: <20230926231410.GF11439@frogsfrogsfrogs>
 <169577059140.3312911.17578000557997208473.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169577059140.3312911.17578000557997208473.stgit@frogsfrogsfrogs>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 26, 2023 at 04:29:17PM -0700, Darrick J. Wong wrote:
> Hi all,
> 
> Online repair fixes metadata structures by writing a new copy out to
> disk and atomically committing the new structure into the filesystem.
> For this to work, we need to reserve all the space we're going to need
> ahead of time so that the atomic commit transaction is as small as
> possible.  We also require the reserved space to be freed if the system
> goes down, or if we decide not to commit the repair, or if we reserve
> too much space.

Just a heads up -- I rebased my development branch on 6.6-rc4 and
uploaded the whole mess to kernel.org.  These earlier patchsets are more
or less the same, but wanted people to be able to build the branch with
the latest (xfs/iomap) bugfixes.

In the meantime, I'll go look through Dave's allocator reorg series and
figure out how that meshes with the forcealign series that John sent.

--D

> To keep the atomic commit transaction as small as possible, we would
> like to allocate some space and simultaneously schedule automatic
> reaping of the reserved space, even on log recovery.  EFIs are the
> mechanism to get us there, but we need to use them in a novel manner.
> Once we allocate the space, we want to hold on to the EFI (relogging as
> necessary) until we can commit or cancel the repair.  EFIs for written
> committed blocks need to go away, but unwritten or uncommitted blocks
> can be freed like normal.
> 
> Earlier versions of this patchset directly manipulated the log items,
> but Dave thought that to be a layering violation.  For v27, I've
> modified the defer ops handling code to be capable of pausing a deferred
> work item.  Log intent items are created as they always have been, but
> paused items are pushed onto a side list when finishing deferred work
> items, and pushed back onto the transaction after that.  Log intent done
> item are not created for paused work.
> 
> The second part adds a "stale" flag to the EFI so that the repair
> reservation code can dispose of an EFI the normal way, but without the
> space actually being freed.
> 
> If you're going to start using this code, I strongly recommend pulling
> from my git trees, which are linked below.
> 
> This has been running on the djcloud for months with no problems.  Enjoy!
> Comments and questions are, as always, welcome.
> 
> --D
> 
> kernel git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-auto-reap-space-reservations
> 
> xfsprogs git tree:
> https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-auto-reap-space-reservations
> ---
>  fs/xfs/Makefile                    |    1 
>  fs/xfs/libxfs/xfs_ag.c             |    2 
>  fs/xfs/libxfs/xfs_alloc.c          |  102 +++++++
>  fs/xfs/libxfs/xfs_alloc.h          |   22 +-
>  fs/xfs/libxfs/xfs_bmap.c           |    4 
>  fs/xfs/libxfs/xfs_bmap_btree.c     |    2 
>  fs/xfs/libxfs/xfs_btree_staging.h  |    7 
>  fs/xfs/libxfs/xfs_defer.c          |  229 ++++++++++++++--
>  fs/xfs/libxfs/xfs_defer.h          |   20 +
>  fs/xfs/libxfs/xfs_ialloc.c         |    5 
>  fs/xfs/libxfs/xfs_ialloc_btree.c   |    2 
>  fs/xfs/libxfs/xfs_refcount.c       |    6 
>  fs/xfs/libxfs/xfs_refcount_btree.c |    2 
>  fs/xfs/scrub/agheader_repair.c     |    1 
>  fs/xfs/scrub/common.c              |    1 
>  fs/xfs/scrub/newbt.c               |  510 ++++++++++++++++++++++++++++++++++++
>  fs/xfs/scrub/newbt.h               |   65 +++++
>  fs/xfs/scrub/reap.c                |    7 
>  fs/xfs/scrub/scrub.c               |    2 
>  fs/xfs/scrub/trace.h               |   37 +++
>  fs/xfs/xfs_extfree_item.c          |   13 +
>  fs/xfs/xfs_reflink.c               |    2 
>  fs/xfs/xfs_trace.h                 |   13 +
>  23 files changed, 991 insertions(+), 64 deletions(-)
>  create mode 100644 fs/xfs/scrub/newbt.c
>  create mode 100644 fs/xfs/scrub/newbt.h
> 
