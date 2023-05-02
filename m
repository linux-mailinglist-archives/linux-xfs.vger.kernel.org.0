Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23B726F4AE8
	for <lists+linux-xfs@lfdr.de>; Tue,  2 May 2023 22:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbjEBUIO (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 2 May 2023 16:08:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbjEBUII (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 2 May 2023 16:08:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8BB819B3;
        Tue,  2 May 2023 13:08:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46B2362876;
        Tue,  2 May 2023 20:08:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CC80C4339E;
        Tue,  2 May 2023 20:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683058086;
        bh=ZsiJeVmPP8vxUs8m/EnFknyHoLZQsB2DfCVLh2B1XHc=;
        h=Subject:From:To:Cc:Date:From;
        b=iz8iiLmfoGxmDTVaSpvzOBX5ykc5Xyqxyu2jMKJr5kCF8olbc7+T3Nvx88kHcW2EF
         K/tNdNICwNW6KoQzf2wEV+C+6oeXkmmXSt+9RVXkdF8b6GTCx53CyWTVsg/Tf2/otH
         AFHuOGeVge42yE/LZzK6SwylRtPpatepNXLAmTt2Xc5bFt2inuz+s+eiLk12elfgFP
         XqrXcrWJfZQvdCqn14/Mqpo+KJu9QmYEi0ixHSJ+RP8uOfkm1kVVYEKYjdrN5iSv7y
         5pDndBptw8Gb96Zv+h68MPvnbs1ALRKCXYsw2HXtyqY1FaSdpC2pdGiQycp9Ux7dvW
         boQ/2FMCn4I8Q==
Subject: [PATCHSET 0/7] fstests: random fixes for v2023.05.01
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 02 May 2023 13:08:05 -0700
Message-ID: <168305808594.331137.16455277063177572891.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here's the usual odd fixes for fstests.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
---
 ltp/fsx.c           |    9 +++++----
 src/fiemap-tester.c |   25 +++++++++++--------------
 tests/generic/094   |    5 -----
 tests/generic/225   |    5 -----
 tests/generic/724   |    2 +-
 tests/xfs/243       |   12 ++++++------
 tests/xfs/245       |    6 +++---
 tests/xfs/262       |    2 +-
 tests/xfs/272       |    4 ++--
 tests/xfs/274       |    8 ++++----
 tests/xfs/791       |    2 +-
 11 files changed, 34 insertions(+), 46 deletions(-)

