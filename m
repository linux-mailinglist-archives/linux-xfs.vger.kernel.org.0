Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 317DA659DD8
	for <lists+linux-xfs@lfdr.de>; Sat, 31 Dec 2022 00:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235662AbiL3XL2 (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 18:11:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235616AbiL3XL1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:11:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2F90DE81
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:11:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90E4461C37
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:11:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB78BC433EF;
        Fri, 30 Dec 2022 23:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441886;
        bh=T4kiSeEUnwMTLXvuCI3+KDa0Nrk/KGJOc4x8n36xP04=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=O68sGJdacMRA7fibv1HTPnl26x5vbaBZ6sKZu9pVV5A6s+zow1ae/lV4BSUjlRZu1
         Gm8XQ1pOpYpZibupoUAll0ppBe9pflGI/jJ0dw8DMhQAoc7qunE0AZ9g12a8Qa3QBB
         kJgJDzXn2hvFB5RojDXmMiWD+zMESQayjz9wmIVCXThBAxyeXuZQE6twQ7rhGpwT2q
         kOfSQ2roLiMg6sJK3Scvbrjf3nMySeq0eR/So3W8lHvYocYp4lFNG/rKTdxxiguYAU
         2IzavNBUZUFClt4xfuv3ONBLJNS5vfDaCD8s4SWVhhWdqgjS6/hXl4HCb4SNd0hWYe
         oe/2Fz/PzPCfQ==
Subject: [PATCHSET v24.0 0/6] xfs_repair: use in-memory rmap btrees
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:48 -0800
Message-ID: <167243866890.712584.9795710743681868714.stgit@magnolia>
In-Reply-To: <Y69Unb7KRM5awJoV@magnolia>
References: <Y69Unb7KRM5awJoV@magnolia>
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

Now that we've ported support for in-memory btrees to userspace, port
xfs_repair to use them instead of the clunky slab interface that we
currently use.  This has the effect of moving memory consumption for
tracking reverse mappings into a memfd file, which means that we could
(theoretically) reduce the memory requirements by pointing it at an
on-disk file or something.  It also enables us to remove the sorting
step and to avoid having to coalesce adjacent contiguous bmap records
into a single rmap record.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-use-in-memory-btrees
---
 libxfs/libxfs_api_defs.h |   13 +
 libxfs/xfile.c           |  169 ++++++++++
 libxfs/xfile.h           |   10 -
 repair/agbtree.c         |   18 +
 repair/agbtree.h         |    1 
 repair/dinode.c          |    9 -
 repair/phase4.c          |   25 --
 repair/phase5.c          |    2 
 repair/rmap.c            |  754 ++++++++++++++++++++++++++++++----------------
 repair/rmap.h            |   32 +-
 repair/scan.c            |    7 
 repair/slab.c            |   49 ++-
 repair/slab.h            |    2 
 repair/xfs_repair.c      |    6 
 14 files changed, 754 insertions(+), 343 deletions(-)

