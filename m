Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 360B5659CB3
	for <lists+linux-xfs@lfdr.de>; Fri, 30 Dec 2022 23:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235470AbiL3WYY (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 17:24:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiL3WYY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:24:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41FB81D0CF
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:24:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8ECB61C18
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:24:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39FB5C433EF;
        Fri, 30 Dec 2022 22:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672439062;
        bh=KP80NweqspzgwOu+PTSv2cWIMhrp8I/ZYYgTvRlXFgQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=sAJfVC37/MyNp36fptz2M7Who+WEba2ZBxumy7yuAS07wjVUWY9dr1Dh9vepDP3sg
         D1isLiCHcuAzBo+JMBjIGnoeaVVKO5YeQ9FgYl2Qd10Jo6EN2p/m6daHqyv4zYUjHk
         62DPZvWmbFP0mjmoGbk4YvhcG6YGe9vwfj+VhdLCzA/ssUbwiswZFtomeJFX/CU4Ds
         9xjKfUy7PKBX14iHLhm3UUL9yLmOBZ/5KwGbZsXYGmCuoNKq1vPHVrOXDvBVNbzDra
         LMKO+QVURW852kEtat+LiHu2ytVFxep36tE8Npv4/Jh9vQcCx52k1rb4vfVYT91nYn
         Y8/5/LJCPEk1A==
Subject: [PATCHSET v24.0 0/5] xfs: make intent items take a perag reference
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:00 -0800
Message-ID: <167243826070.683449.502057797810903920.stgit@magnolia>
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

Now that we've cleaned up some code warts in the deferred work item
processing code, let's make intent items take an active perag reference
from their creation until they are finally freed by the defer ops
machinery.  This change facilitates the scrub drain in the next patchset
and will make it easier for the future AG removal code to detect a busy
AG in need of quiescing.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=intents-perag-refs

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=intents-perag-refs
---
 fs/xfs/libxfs/xfs_ag.c             |    6 +---
 fs/xfs/libxfs/xfs_alloc.c          |   22 +++++++--------
 fs/xfs/libxfs/xfs_alloc.h          |   12 ++++++--
 fs/xfs/libxfs/xfs_bmap.c           |    1 +
 fs/xfs/libxfs/xfs_bmap.h           |    4 +++
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    7 +++--
 fs/xfs/libxfs/xfs_refcount.c       |   33 +++++++++-------------
 fs/xfs/libxfs/xfs_refcount.h       |    4 +++
 fs/xfs/libxfs/xfs_refcount_btree.c |    5 ++-
 fs/xfs/libxfs/xfs_rmap.c           |   29 +++++++------------
 fs/xfs/libxfs/xfs_rmap.h           |    4 +++
 fs/xfs/scrub/repair.c              |    3 +-
 fs/xfs/xfs_bmap_item.c             |   29 +++++++++++++++++++
 fs/xfs/xfs_extfree_item.c          |   54 +++++++++++++++++++++++++-----------
 fs/xfs/xfs_refcount_item.c         |   36 +++++++++++++++++++++---
 fs/xfs/xfs_rmap_item.c             |   32 +++++++++++++++++++--
 16 files changed, 196 insertions(+), 85 deletions(-)

