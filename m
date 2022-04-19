Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3B89507692
	for <lists+linux-xfs@lfdr.de>; Tue, 19 Apr 2022 19:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232344AbiDSRek (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 19 Apr 2022 13:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232206AbiDSRej (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Apr 2022 13:34:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF6A36E26;
        Tue, 19 Apr 2022 10:31:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 296096151C;
        Tue, 19 Apr 2022 17:31:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C941C385A7;
        Tue, 19 Apr 2022 17:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650389515;
        bh=ERS/3GR0TWIgixTFg1qrvAJnAVRzCYigvKvX8IE7l1Q=;
        h=Subject:From:To:Cc:Date:From;
        b=aizJFyEJfWokjQdpYbMfReLb3ooldgRgT5s/qnDBv3aXRKKjdV8fm59RI5Bk1rf1z
         IUanJQHtxJ0KiFHK8moxezGup4jtVJxypgaVAH+HJSpsOuDLKW1LA86nL/gEcwIyMR
         x9MY5XSYV5MZjuL4h6x0IU2RKLokL8PrUavi1rIUaVm/WaU2u/wqDuB0Y/aAYpS2Ao
         fmWcFqnr5RnpSs6LBqHDmBXj+lVxdbBY7bXiw9YN5KPgilvfVSZYsh2mMyLo7cDjRb
         kG/ntocN4nFq6HawaKsZZKmStnROVSlGUSW49rMt1FTSMFnfuE8lBSM3CgmTnB/WmB
         btZxcKw0Q5tVQ==
Subject: [PATCHSET 0/2] fstests: random fixes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     Catherine Hoang <catherine.hoang@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 19 Apr 2022 10:31:54 -0700
Message-ID: <165038951495.1677615.10687913612774985228.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here's the usual batch of odd fixes for fstests.

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
 tests/generic/019 |    4 ++--
 tests/xfs/019     |    3 +--
 tests/xfs/019.out |    2 +-
 3 files changed, 4 insertions(+), 5 deletions(-)

