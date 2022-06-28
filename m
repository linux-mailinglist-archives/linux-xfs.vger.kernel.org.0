Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Original-To: lists+linux-xfs@lfdr.de
Delivered-To: lists+linux-xfs@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C26055EF85
	for <lists+linux-xfs@lfdr.de>; Tue, 28 Jun 2022 22:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232828AbiF1UYk (ORCPT <rfc822;lists+linux-xfs@lfdr.de>);
        Tue, 28 Jun 2022 16:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232941AbiF1UXi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 16:23:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3073393EF;
        Tue, 28 Jun 2022 13:21:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58CB4B8203E;
        Tue, 28 Jun 2022 20:21:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B0BC3411D;
        Tue, 28 Jun 2022 20:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656447678;
        bh=Tc3XWgmTfSzgL7zL16V7yRsdeK+VG1YusAA943viFHo=;
        h=Subject:From:To:Cc:Date:From;
        b=jRTB7pXuSj5D57TzYPqeoVtWFdW9pAx+xe7LGOFqetfDTs6Wed0eXjLjLdigLAVya
         Cq7NkZ9OOlPyLDjvMQY4qK9g+klrmYkxyZJhY/qiqGdI+3VM3COlpICUbjAnPTD0Ki
         fNQG1Jr/3uu7BOMV1FEeS6NSqQ4DhddNVvRhfslm4jf+das86hC3Xxwa37OvheGQGk
         ZoYh+lNBi4h+yv+jxJb64lbb+WRULU19RmwvhULwXfb7BcrmjUvrAo/Z5jhIAls/Ar
         g9Zhy+Jk+fNb1JXytNQjpVd2/W4XIB/EkOAnQVEwLp/6n2ziJQekfan6Pnbz5Ao5xO
         V8q1e2gAbQkDg==
Subject: [PATCHSET 0/9] fstests: random fixes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 28 Jun 2022 13:21:17 -0700
Message-ID: <165644767753.1045534.18231838177395571946.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 check                  |    3 +++
 common/repair          |    1 +
 src/seek_sanity_test.c |   12 ++++++++++-
 tests/xfs/018          |   52 +++++++++++++++++++++++++++++++++++++++++++-----
 tests/xfs/018.out      |   16 ++++-----------
 tests/xfs/109          |    2 +-
 tests/xfs/166          |   19 ++++++++++++++----
 tests/xfs/547          |   14 +++++++++----
 tests/xfs/843          |   51 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/843.out      |    2 ++
 tests/xfs/844          |   33 ++++++++++++++++++++++++++++++
 tests/xfs/844.out      |    3 +++
 12 files changed, 181 insertions(+), 27 deletions(-)
 create mode 100755 tests/xfs/843
 create mode 100644 tests/xfs/843.out
 create mode 100755 tests/xfs/844
 create mode 100644 tests/xfs/844.out

