Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 781E1659CBF
	for <lists+linux-xfs@lfdr.de>; Fri, 30 Dec 2022 23:26:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235584AbiL3W0q (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Fri, 30 Dec 2022 17:26:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbiL3W0p (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:26:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13D5314094
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:26:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C372CB81C22
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:26:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76DE8C433D2;
        Fri, 30 Dec 2022 22:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672439202;
        bh=Yxlcawt06Jjx3wob3daWJf+MpYYBVi2qwDL1g6dTV08=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Xp7kPKqLljVjbwrbZyYjZnxJZ05/y+ibf2IfRUVLrQrYRiObiZtcB3rVx7IB3sG/F
         JnrKYihpGJwCrtA4D3Uusb3SEcepOK3QrUmS80I03N89IveiWuR+txCqEHv0XZ9KYp
         XXjjsqPWLa2Nyim56AAA8XGW1SfdqqMBj8BjSn9swxTLmNcL8xIXZd076Qv6n3RpS4
         cnfVjrssiTMNt6DGR2jM7wPhnFdOUn+S+A4eCJkc7QlXVQa6mtwlSUY3m135ogwa7B
         9S67WOfZFB7Dub9asOuvjVUUoKIPUnrkyGLZQZVwOoDx8tpciJktUF5rPY/m3D16DL
         rF9AFSBhnY9lg==
Subject: [PATCHSET v24.0 0/2] xfs: detect incorrect gaps in rmap btree
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:32 -0800
Message-ID: <167243829239.684733.6811272411929910504.stgit@magnolia>
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

Following in the theme of the last two patchsets, this one strengthens
the rmap btree record checking so that scrub can count the number of
space records that map to a given owner and that do not map to a given
owner.  This enables us to determine exclusive ownership of space that
can't be shared.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-detect-rmapbt-gaps

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-detect-rmapbt-gaps
---
 fs/xfs/libxfs/xfs_rmap.c |  198 ++++++++++++++++++++++++++++++++--------------
 fs/xfs/libxfs/xfs_rmap.h |   18 +++-
 fs/xfs/scrub/agheader.c  |   10 +-
 fs/xfs/scrub/bmap.c      |   14 +++
 fs/xfs/scrub/btree.c     |    2 
 fs/xfs/scrub/ialloc.c    |    4 -
 fs/xfs/scrub/inode.c     |    2 
 fs/xfs/scrub/rmap.c      |   45 ++++++----
 fs/xfs/scrub/scrub.h     |    2 
 9 files changed, 198 insertions(+), 97 deletions(-)

