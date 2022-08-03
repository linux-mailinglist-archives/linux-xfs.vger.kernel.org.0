Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A72C588647
	for <lists+linux-xfs@lfdr.de>; Wed,  3 Aug 2022 06:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235444AbiHCEWO (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Wed, 3 Aug 2022 00:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233637AbiHCEWN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Aug 2022 00:22:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C1F1550BF;
        Tue,  2 Aug 2022 21:22:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50847B82188;
        Wed,  3 Aug 2022 04:22:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDD44C433C1;
        Wed,  3 Aug 2022 04:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659500530;
        bh=H0ssKvvszCvzT4R5op+LccuLNpSwM9/AXfYbD2sCivE=;
        h=Subject:From:To:Cc:Date:From;
        b=RlwwJbKiXG7koGYVc/34Gw8POqdA/FWEYC9W/LtpmWDAd4+UI1hLrDvd8a74kBhOR
         l+ClnAd7PSH6AHwwJsyWhnDUOMh9HnLYuv8gh0THPmHflDX+bBUmuTNVKl+4iqKCgc
         3KjrODFdCDwt0itztGhJNHtLYwSYL0b4twWVhrvM8U02kwTNPJBKwASTRnZqShHLvP
         D2HZIkY32GIFMKE5Oejv2PqAYG4lkCOhitY4S37gdUnsENB+pinPThlIdyjvlDLyzN
         NacJNjV3t5x/E1F1oemLVR3/SmRPgemSUrIZOCSA5qEpNPeH04cY9+0r0OYcXHDUgq
         EjHfB41yHSRJw==
Subject: [PATCHSET v2 0/2] fstests: enhance fail_make_request
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 02 Aug 2022 21:22:09 -0700
Message-ID: <165950052948.199134.11841652463463547824.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series starts by refactoring boilerplate code around
fail_make_request (aka error injection in the block layer) and then
enhances it to play nicely with multi-device XFS filesystems.

v2: add hch reviews

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=fix-fail-make-request
---
 common/fail_make_request |   63 ++++++++++++++++++++++++++++++++++++++++++++++
 common/rc                |    7 -----
 tests/btrfs/088          |   14 ++++------
 tests/btrfs/150          |   13 ++++-----
 tests/generic/019        |   40 ++++-------------------------
 5 files changed, 78 insertions(+), 59 deletions(-)
 create mode 100644 common/fail_make_request

